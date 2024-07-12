# Domain Name Service - DNS

Gute Dokumentationen:

* http://www.lug-erding.de/vortrag/DNS+BIND.html
* http://de.wikipedia.org/wiki/Domain_Name_System

---

# Motivation

Rechner werden im Internet über IP-Adressen adressiert. Leider kann sich die niemand merken und ausserdem könnten die sich durch Veränderungen an der Netzstrultur (z. B. man wechselt den Provider) - deshalb hat man mit den FullQualifiedDomainNames (FQDN) eine Abstraktionsschicht eingezogen, die diese Probleme löst. Kurzum: ein DNS-Server mappt FQDN auf IP-Adressen über sog. A-Records.

Aber ein DNS kennt noch viele weitere Einsatzbereiche, dür die es entsprechende Recordtypen gibt.

Ein guter Vergleich ist die Verwendung von Telefonnummern. Wir können uns die ganz gut merken, damit es es aber funktioniert müssen die "Kabel" in den Telefonzentralen richtig geschaltet sein, sonst kommt unser Anruf dennoch woanders an. Der DNS ist für das Routing in der unterliegenden Technik verantwortlich. Dementsprechend kritisch ist er ... denn damit könnte man Nutzer auf andere Seiten umlenken (Stichwort Phishing - DNSSec). 

---

# Komponenten

* Client = Resolver
* Server = Domain Name Server
  * autoritative Nameserver
    * ein autoritativer Nameserver ist das Original der DNS-Informationen. Ein autoritativer Nameserver ist für eine Zone/Domain zuständig (z. B. cachaca.de) - er kann die Verwaltung von Subdomains an weitere Nameserver delegieren
  * non-autoritative Nameserver
    * sie sammeln und cachen die Informationen aus vielen autoritativen Nameservern
---

# Verwaltung und Nutzung

## DNS-Zone

Eine DNS-Zone wird über ein Zone-File administriert, das verschiedene Record-Typen enthält. Wird eine Sub-Zone hier eingebunden, dann erfolgt das über einen `NS`-Entry, der die Auflösung an einen anderen Nameserver zur Auflösung der DNS-Entries dieser Zone weiterleitet.

### Zone `local.`

TopLevelDomains wie `de`, `com`, `org`, ... haben eine gleichnamige Zone `de.`, `com.`, `org.`, ... (der Punkt dahinter ist tatsächlich relevant). Die Zone `local.` ist keine TopLevel-Zone, doch wird diese Pseudo-Zone gerne für DNS-Einträge in einem LAN, um beispielsweise zwei Mailserver im LAN aufzusetzen, die sich gegenseitig Mails schicken können, ohne die Mailserver ans Internet anbinden zu müssen.

Hier ist beschrieben wie man bind nutzen kann, um eine local Zone zu konfigurieren: http://wiki.linuxmce.org/index.php/How_to_setup_Local_Authoritative_DNS

## Record-Typen

Ein Nameserver verwaltet Informationen in Form von sog. Resource Records - es gibt u. a. folgende Record-Typen (eine ausführlichere Liste findet man hier: http://de.wikipedia.org/wiki/Domain_Name_System#Aufbau_der_DNS-Datenbank, http://de.wikipedia.org/wiki/Resource_Record#Die_wichtigsten_RR-Typen):

* SOA: Start of Authority
  * gibt an welche Zone von diesem Nameserver verwaltet wird - nur, wenn es sich um einen autoritativen Nameserver (= Primary Nameserver) handelt
* NS
  * entweder: referenziert die DNS-Servers, die für die Namensauflösung dieser Zone zuständig sind
  * oder: bei Subzonen werden die DNS-Server dieser Subzone referenziert, über die eine Delegation erfolgt
* A
  * es kann mehrere A-Records zu einem einzigen FQDN geben, so dass **MEHRERE** IP-Adressen auf die Query nach dem A-Record zurückgeliefert werden. Der Client kann dann einen beliebigen auswählen
* AAAA
* CNAME
  * macht FQDN => FQDN Auflösung - CNAME fungiert als Alias-Definition
  * auf diese Weise könnte ich `google.cachaca.de` auf `google.de` umleiten
* MX
* CERT
* SRV
* TXT

Diese Entries werden in jeweils unterschiedlichen Kontexten (= Use-Cases) verwendet, d. h. ein `A` Record löst einen FQDN zu einer IP-Adresse auf und ein `NS`-Entry enthält die Nameserver, die die Sub-Zone verwaltet.

> **ACHTUNG:** die Records haben ALLE eine sog. Time-to-Live (TTL), die fürs Caching relevant ist. Setzt man die zu hoch an, dann dauert es entsprechend lange bis man Einträge nach Änderungen in allen Caches aktualisiert hat - im worst-case führt eine Änderung dann zu einer temporären Nicht-Erreichbarkeit. Setzt man den Wert zu niedrig an, dann dauert die hierarchische Namensauflösung entsprechend lange. Die TTL sollte man also mit Bedacht wählen.

---

# FQDN-Namesauflösung iterativ vs. rekursiv

DNS ist dezentral organisiert, d. h. ein DomainNameServer ist für eine sog. Zone/Domäne (eine Subdomäne ist auch eine Domäne) zuständig (z. B. für die Domäne cachace.de). Eine Domäne ist in eine oder mehrere Zonen (= Subdomains) aufgeteilt (z. B. einkauf.cachaca.de und produktion.cachaca.de) - das kann der Domänen-Administrator frei entscheiden. Ein Client bekommt einen Resolver (= Nameserver) konfiguriert (z . B. in /etc/resolv.conf) oder aber auch bei der Initialisierung des Netzwerks zugewiesen (z. B. wenn man die DSL-Verbindung aufbaut). Der einkonfigurierte Resolver dient als zentrale Anlaufstelle für DNS-Requests. Kann der Resolver den Request selbst nicht auflösen (weil es sich nicht um einen Record aus seiner verwalteten Zone handelt oder die Caches dafür abgelaufen ist), dann delegiert er den Request weiter. Im worst-case landet der Request beim DNS, der für die Zone der Root-Domain zuständig ist.

Braucht ein Client eine IP-Adresse, so wendet er sich an den Resolver mit dem gewünschten FQDN (z. B. www.cachaca.de). Dann ...

## Iterative Auflösung

findet der Resolver (er übernimmt den aktiven Part - im rekursiven Szenario übernimmt der an den Resolver angebunde DNS den aktiven Part) raus, welcher Root-Server für die Top-Level-Domain de zuständig ist (dig -t ns de):

```
de.                     82783   IN      NS      a.nic.de.
de.                     82783   IN      NS      z.nic.de.
de.                     82783   IN      NS      l.de.net.
de.                     82783   IN      NS      f.nic.de.
de.                     82783   IN      NS      s.de.net.
```

Der Resolver fragt anschließend einen dieser Nameserver (z. B. a.nic.de) - die IP-Adresse wird über den A-Record ermittelt (dig -t A a.nic.de) nach dem zuständigen Nameserver für die Domain cachaca.de (dig -t NS cachaca.de):

```
;; ANSWER SECTION:
cachaca.de.             335     IN      NS      ns3.webspace-verkauf.de.
cachaca.de.             335     IN      NS      ns2.webspace-verkauf.de.
cachaca.de.             335     IN      NS      ns1.webspace-verkauf.de.

;; ADDITIONAL SECTION:
ns3.webspace-verkauf.de. 9022   IN      A       212.12.104.14
ns2.webspace-verkauf.de. 9022   IN      A       213.160.90.82
ns1.webspace-verkauf.de. 9022   IN      A       212.12.114.14
```

Nun kann der Resolver einen der definierten (autoritativen) Nameserver für cachaca.de (z. B. ns3.webspace-verkauf.de = 212.12.104.14) nach der Auflösung von www.cachaca.de befragen. Zur Antwort erhält er (dig -t a www.cachaca.de):

```
;; ANSWER SECTION:
www.cachaca.de.         7008    IN      A       80.246.53.11
```

## Rekursive Auflösung

Hier ist das auch sehr schön grafisch aufbereitet (SUPER!!!): http://de.wikipedia.org/w/index.php?title=Datei:DNS-query-to-wikipedia.svg&filetimestamp=20110823143358

Der Resolver sendet einen Request zur Auflösung des FQDN www.cachaca.de an SEINEN (in /etc/resolv.conf) definierten Resolver/DomainNameServer. Dieser wendet das iterative Verfahren an.

Wendet er sich an seinen (z. B. in /etc/resolv.conf) spezifizierten DNS A. Wenn dieser DNS A für die Domäne cachaca.de zuständig ist, kann er über die definierten A (IPv4) bzw. AAAA (IPv6) sofort zurückliefert. Wenn dieser DNS nicht für die Domäne zuständig ist, dann könnte es sein,

* daß er den Request an den DNS der Subdomäne delegiert (Delegation innerhalb der Domäne)
  * so würde das in einem dig -t ns cachaca.de aussehen
    * einkauf.cachaca.de          IN NS nameserver-1.cachaca.de.
    * produktion.cachaca.de     IN NS nameserver-2.cachaca.de.
  * Nameserver können durchaus redundant (wegen Ausfallsicherheit) ausgelegt sein (Master-Nameserver, Slave-Nameserver)
    * einkauf.cachaca.de          IN NS nameserver-1.cachaca.de.
    * einkauf.cachaca.de          IN NS nameserver-1a.cachaca.de.
    * produktion.cachaca.de     IN NS nameserver-1.cachaca.de.
    *produktion.cachaca.de     IN NS nameserver-1a.cachaca.de.
* daß er den Request an den DNS der zuständige Domäne delegiert (Delegation an eine andere Domäne)

**Allgemeine Info:**

Zur Auflösung der RecordResource-Requests (also wie oben z. B. die Abfrage eines A-Records) wird i. d. R. das UDP-Protokoll verwendet.

---

# DNS-Caching

Die Auflösung über die Root-Server bis hin zu den autoritativen Servern ist natürlich relativ ineffizient, wenn man berücksichtigt, daß es sich um Informationen handelt, die sich nur ganz selten ändern.

Die DNS-Einträge können (beispielsweise durch andere DNS, Browser, ...) Ergebnisse der iterativen Namensauflösung lokal cachen, um sich Requests an autoritative Nameserver zu sparen. Da es sich beim FQDN-IP-Mapping um sehr statische Informationen handelt, erhöht dieses Caching die Performance deutlich.

Ändert man die IP-Adresse eines Servers (z. B. wegen Umzug zu einem anderen Webhoster oder Umzug von Netzen), so muß dieses Mapping geändert werden. Deshalb haben die von einem autoritativen DNS (= Hauptverwalter der Zone) bereitgestellten Daten eine begrenzte Lebensdauer (TimeToLive TTL - nicht zu kurz und nicht zu lang, um eine hohe Performance zu erreichen aber dennoch Änderungen zu ermöglichen). Ist dieses Lebensdauer abgelaufen, so wird der Cache gelöscht und die Daten werden erneut vom autoritative Nameserver geladen.

---

# DNS vs Elstic-Servers

Im Cloud-Umfeld arbeitet man i. a. mit elastischen Servern. Je nach Last werden weitere Server gestartet oder nicht genutzte wieder runtergefahren. Man könnte nun auf die Idee kommen, die einzelnen Server als DNS-Entries bereitzustellen. Für diese schnelle Änderungsrate sind die Enträge aber nicht gemacht. In diesem Fall würde man einen Loadbalancer vor die Server setzen und diesen Loadbalancer mit einer Public-Address versehen, die über DNS geroutet wird.

Ein Application-Load-Balancer könnte dann Requests für eine Domain `cachaca.de` zuständig sein und dann aufgrund einer Subdomain (z. B. `api.cachaca.de`) oder eines URL-Path (z. B. `cachaca.de/api`) eine Delegation in dahinterliegende (private) Servers durchführen.

---

# Wer betreibt einen Nameserver

## Szenario - lesender Zugriff

In größeren LANs wird i. d. R. ein (oder mehrere - wegen Ausfallsicherheit) eigener Nameserver betrieben, der neben den Internet-FQDNs auch die internen FQDNs des LAN verwaltet. Dieser DNS cached die Informationen der autoritativen DNS-Server bis das Ende die TTL abgelaufen ist. Dann wird der autoritative Server erneut kontaktiert und das Spiel beginnt von vorn.

Als Privatanwender (ohne größeres LAN) wird man den DNS seines Internet-Providers nutzen (wird automatisch beim Erhalt der Public Internet-Address mitgeliefert). Dennoch trägt man den DNS seines Providers nicht direkt in die /etc/resolv.conf, da sie sich ändern kann und man dann mit veralteten DNS-Server-Adressen arbeitet (die im besten Fall gar nicht mehr funktionieren ... dann würde man das Problem zumindest noch mitbekommen). Stattdessen übermittelt der DSL-Provider beim DSL-Verbindungsaufbau zwei DNS-Server (es sind wohl zwei vorgeschrieben). Diese kann der Router verwenden (man kann aber auch einen anderen DNS-Server im router konfigurieren). In den Clientrechnern im LAN verwendet man dann die IP-Adresse des Routers, der die DNS-Requests an den eingetragenen DNS-Server weiterleitet (evtl. erfolgt hier auch ein Caching). Der DHCP-Server übernimmt auch das DNS-Handling ... zumindest kann die dem Host (-namen) zugeordnete IP-Adresse an dem DNS-Server übermittelt werden, so daß die Rechner im internen LAN auch mit sprechenden Hostnamen adressiert werden können. Am einfachsten ist das alles - zumindest für kleinere Netze (z. B. für Privatanwender) - wenn der DSL-Router gleichzeitig DHCP-Server und DNS-Server (zumindest für das lokale Netz) ist. Wenn der Router nicht autoritativer Server für die angefragte Zone/Domain ist, wird er vermutlich im Cache nachsehen und dann evtl. an den DNS des DSL-Providers weiterreichen (sog. Forwarding). Kommt die Antwort vom externen DNS, so wird der Router diese Information cachen (bis die TTL erreicht ist)

## Szenario - schreibender Zugriff

Gute Quellen:

* http://www.xentity.de/linux/eigene-dns-zone-mit-bind/
* http://www.dmarkweb.com/setting-up-a-local-network-dns-server-using-bind9-for-debian.html
* http://www.lug-erding.de/vortrag/DNS+BIND.html

Ein Zonenverwalter ist für die Bereitstellung autoritativer DNS (sind  i. d. R. redundant ausgelegt) verantwortlich. Den Zonenverwalter bekommt man beispielsweise über

```
whois cachaca.de
[Zone-C]
Type: PERSON
Name: Markus ...
Organisation: ...
```

raus.

Jeder, der eine Internet-Domäne betreibt braucht für diese auch einen Zonenverwalter. Entweder mimt der Hoster den Zonenverwalter (weil es recht komplex ist und ein Gelegenheits-Computer-Nutzer sich damit nicht wirklich beschäftigen will) oder der Eigentümer der Adresse muss sich selbst darum kümmern.

Allerdings ist man in einem Dilemma, wenn man seine eigene Zone mit seinem eigenen DNS aufbauen will, weil ja zunächst mal niemand weiß, welcher DNS die Zone cachaca.de verwaltet - Henne/Ei-Problem. Aus diesem Grund wird zur Domain ein sog. Glue-Record definiert, der auf die IP-Adresse des autoritativen DNS-Server zeigt.
Eigenen Nameserver im LAN betreiben - Fritzbox
In lokalen Netzen (vor allem in Unternehmensnetzen) macht es durchaus Sinn einen eigenen DNS (z. B. bind, dnsmasq) für die lokalen Rechner zu betrieben. Auch dort will man nicht immer 172.31.15.55 eingeben, sondern mailserver.local. - die Auflösung FQDN -> IP-Adresse wird also auch für lokale Rechner benötigt. Betreibt man einen DHCP-Server im LAN (z. B. im Internet-Router) so kann dieser auch als DNS für Rechner des lokalen Netzwerks fungieren - Adressen ausserhalb des LAN würde er an den DNS des Hosters oder einen anderen vertrauenswürdigen DNS weiterleiten.
In diesem Fall würde man in die /etc/resolv.conf die Adresse dieses eigenen Nameservers eintragen. Dieser sollte dann aber auch wissen, an welche Nameserver die Anfragen weitergeleitet/forwarded werden können, die er selber nicht beantworten kann - deshalb trägt man eine entsprechende Forward-Information (hier am Beispiel bind-Nameserver) ein (172.31.15.1 ist die Adresse des Routers, der wiederum einen Forward an den DNS des Providers macht und der dann u. U. die Information vom autoritativen Nameserver holt):

```
forwarders {
        172.31.15.1;
};
```

Die /etc/resolv.conf sollte dann ungefähr so aussehen (172.31.15.99 ist die IP-Adresse des DNS):

```
search cachaca.local
nameserver 172.31.15.99
```

Die bei Privatanwendern beliebte Fritzbox ist DSL-Router, DHCP-Server und DNS-Server in einem ... das vereinfacht die Konfiguration.

## Eigenen Nameserver im LAN betreiben - dnsmasq

    * https://mohan43u.wordpress.com/2012/08/06/dnsmasq-for-home-user/

Gelegentlich - zumindest in der Softwareentwicklung - will man auf seinem eigenen System einen DNS betreiben (dür die eigenen IP-Adressen/Dienste). Dennoch benötigt man natürlich einen DNS für öffentliche Records (z. B. wenn man aufs Internet oder Inranet zugreifen will).

In diesem Fall kann man DNSMASQ lokal laufen lassen. In diesem kann man komfortabel ein Routing einstellen ... für welche Zonen ist der lokale DNS zuständig, für welche Zonen ist der Unternehmens-DNS zuständig.

---

# CDN - Content Delivery Network

* [Wikipedia](https://en.wikipedia.org/wiki/Content_delivery_network)

Beim CDN geht es darum (statischen) Content (Webseiten, JavaScript-Bibliotheken, Downloads) nahe beim Benutzer bereitzustellen, um die Netzwerk-Latenz zu reduzieren. Durch die Verteilung des Contents auf verschiedene Server läßt sich so auch die Ausfallsicherheit erhöhen.

Für CDNs hat sich ein eigener Markt entwickelt, d. h. die Contentersteller hosten das CDN gar nicht selbst, sondern beauftragen einen Drittanbieter (z. B. [Akamai](https://en.wikipedia.org/wiki/Akamai_Technologies)).

---

# Tools

* [Online dig](https://toolbox.googleapps.com/apps/dig/)

## dig (Linux) und ipconfig (Windows)

Will man die Konfiguration einer Zone/Domain rausfinden, so kann man das Tool dig verwenden (besser als nslookup).

Im folgenden gilt:

* die Angabe eines DomainNameServers per @IPADDRESS/FQDN (dig @172.31.15.23 pxshealthdomain.local NS) ist nur notwendig, wenn man gezielt einen bestimmten Nameserver adressieren möchte - lässt man es weg, dann wird der in /etc/resolv.conf spezifizierte verwendet

**Wie ist die Domäne/Zone cachaca.de definiert?**

Der Einstiegspunkt für die Zonen-Definition ist der SOA-Record - hier wird der Zonenname hinterlegt und der Master-Nameserver:

```
dig cachaca.de SOA
```

liefert

```
cachaca.de.             10800   IN      SOA     ns1.webspace-verkauf.de. info.webspace-verkauf.de. 2009110303 10800 3600 604800 10800
```

Das bedeutet:

* Master-Nameserver: `ns1.webspace-verkauf.de` (die Alternativen findet man per dig cachaca.de NS)
* der Zonenverwalter hat die eMail-Adresse `info@webspace-verkauf.de` (ACHTUNG: in der Definition wird das @ durch einen Punkt ersetzt - das ist hier KEIN FEHLER)

**Welche Nameserver sind für die Domäne/Zone cachaca.de definiert?**

```
dig cachaca.de NS
```

**Welche IP-Adresse hat der Server www.cachaca.de?**

```
dig www.cachaca.de A
```

ACHTUNG: dies ist die Information des Standard Resolvers (siehe /etc/resolv.conf). Will man gezielt einen speziellen DNS befragen, so verwendet man folgendes Kommando (mit @ wird der Nameserver spezifiziert - in diesem Fall der Nameserver von 1und1 - meinem DSL Provider):

```
pfh@linux-lmzo:/var/spool/mail> dig @195.50.140.246 www.heise.de

; <<>> DiG 9.5.0-P2 <<>> @195.50.140.246 www.heise.de
; (1 server found)
;; global options:  printcmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3464
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;www.heise.de.                  IN      A

;; ANSWER SECTION:
www.heise.de.           1518    IN      A       193.99.144.85

;; Query time: 32 msec
;; SERVER: 195.50.140.246#53(195.50.140.246)
;; WHEN: Mon Oct  1 22:57:39 2012
;; MSG SIZE  rcvd: 46
```

**Wie sieht der aktuelle lokale DNS-Cache aus?**

```
ipconfig /displaydns
```

**Wie kann ich den lokalen DNS-Cache unter Windows löschen?**

```
ipconfig /flushdns
```

**Wo wird außerdem gecached?**

Ich habe meinen DNS-Cache per `ipconfig` gelöscht (siehe oben), aber dennoch gehen die Firefox-Requests nicht auf die in `C:\Windows\System32\drivers\etc` angegebenen IP-Adressen - was ist da los?

Browser haben i. d. R. auch noch einen DNS-Cache ... für Firefox gibt es beispielsweise das Add-On DNSFlusher