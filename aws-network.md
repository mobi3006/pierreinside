# AWS Netzwerk Knowhow

* [Stephane Marek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528534#overview)
* [Digital Cloud Training](https://www.youtube.com/channel/UCZGGwqjk5jfO4vN1SOCJ2ew)

Wenn man eine neue EC2 Instanz startet, so kann man das **OHNE** all die Sachen zu wissen, da die Default-Konfiguration (angelegt bei der Account Erstellung) schon so ausgelegt ist, daß das alles reibungslos funktioniert. Will man allerdings eine halbwegs professionelle (= sicher, performant) anbieten, dann **MUSS** man sich damit beschäftigen.

![AWS-Core-Components](images/aws-core-components.png)

Hier sieht man auch sehr schön, warum man beim Starten einer EC2 Instanz die Security-Group, das Subnet, das VPC, ... angeben muß.

---

## VPC - Virtual Private Cloud

* [Stephane Marek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528538#overview)
* [How Amazon VPC works](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html)

Die Virtual Privat Cloud ist das Ziel einer jeden Server-based Anwendung ... hier wird sie gehostet. Das VPC riegelt zumeist den Zugriff auf die Anwendungslösung ab und lässt nur noch dedizierte Zugriffe zu. Zwischen VPC und Internet kann eine Verbindung hergestellt werden ... und zumeist macht das auch Sinn, denn die User sind meistens außerhalb des VPC. Das VPC wie ein Subnetz zu verstehen, das über einen Router/InternetGateway mit der Aussenwelt verbunden wird (in beide Richtungen).

Als Anwendungshoster kann ich mich für ein oder mehrere VPC entscheiden (bis zu 5 VPCs sind in EINER Region innerhalb eines AWS Accounts möglich). Die VPCs sind logisch voneinander isoliert ... Verbindungen kann man konfigurieren. Meistens hat man aber auch verschiedene Hosting-Umgebungen (Development, Test, Staging, Production), die man voneinander durch Nutzung verschiedener VPCs voneinander trennen möchte (hier kann man aber auch verschiedene AAWS Accounts verwenden ... eine noch stärkere Trennung als die über VPCs).

* ein VPC liegt in einer Region, deckt aber alle Availability Zones (AZ) dieser Region ab
  * die Subnets liegen dann in unterschiedlichen AZs
* ein VPC hat eine Main Route Table, die Kommunikation innerhalb des VPC zwischen allen Subnets erlaubt
* jeder AWS Account kommt schon vorkonfiguriert mit (um den Einstieg zu erleichtern) ... im Produktionsumfeld sollte alle Komponenten selbst konfigurieren
  * Default-VPC **MIT** (ACHTUNG) Public-Internet-Access ... ohne VPC geht nix
    * Internet-Zugang vorhanden (Inbound + Outbound)
    * alle EC2 erhalten public IP-addresses ... ready-to-go
    * Route Table vorkonfiguriert
    * DHCP vorkonfiguriert
    * Network ACL vorkonfiguriert
  * Default-Subnets in allen Availability Zones
  * Subnet NACLs
  * Security Groups
  * Internet Gateway
  * Route Table
* besitzt einen oder mehrere CIDR-Ranges und vergibt **PRIVATE** IP-Adressen aus dem 172.xxx.xxx.xxx Netz für die darin befindlichen Netzwerkkomponenten (z. B. EC2-Instanzen)
* IP-Ranges von VPC sollten sich nach Möglichkeit nicht überlagern, damit man später noch ALLE VPCs miteinander verbinden kann (Eindeutigkeit)
* definiert DNS Einstellungen
* konfiguriert einen Flow Log (zur Problemanalyse)
* zumeist definiert man verschiedene Subnets ... jedes Subnetz muss eine CIDR-Range aus dem VPC-CIDR-Range haben
  * pro Availability Zone ein Subnetz
  * unterschiedliche Subnets für public (z. B. Webserver) und private (z. B. Datenbank) Resources

### CIDR

* [CIDR Calculator](https://www.ipaddressguide.com/cidr)

CIDR-Notation Bedeutung

* `192.168.0.0/32`
  * alle 32 Bits sind fest => nur eine einzige IP-Adresse ist in der Range: `192.168.0.0`
* `192.168.0.0/16`
  * die ersten 16 Bits sind fest (`192.168`) und die anderen Variable - Range: `192.168.0.0` - `192.168.255.255`
* `192.168.0.0/30`
  * 30 Stellen sind fest, 2 sind frei => 2^2 = 4 IP-Adressen - Range `192.168.0.0` - `192.168.0.3`

### VPC Peering

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528554#overview)

* Verbindung zweier VPCs (z. B. in verschiedenen Accounts), um den Zusammenschluss zu simulieren (funktioniert natürlich nur, wenn die privaten IP-Adressen nicht überlappen)
  * **Einsatzbereich:** VPCs unterschiedlicher Regionen oder gar Accounts verbinden
* die Route Tables müssen nachgepflegt werden, um den Traffic in das andere VPC über die VPC-Peering-Connection zu routen

### VPC Endpoints (aka AWS PrivateLink)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528556#overview)
* eigene Services als VPC Endpoint bereitstellen [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/18078439#overview)

Hosted Services wie S3, DynamoDB, CloudWatch, SNS, ... sind natürlich öffentlich erreichbar und könnten darüber - bei entsprechender Outgoing/Ingoing-Traffic-Konfiguration in den Security-Groups und NACLs - problemlos von einer EC2 Instanz in einem private Network genutzt werden.

**ABER:** das ist natürlich nicht optimal, denn warum sollte man das AWS-Ecosystem verlassen, um den Traffic dann durche öffentliche Internet zu routen (Latenz, Angriffsvektoren). Außerdem kommt es ohne große Konfiguration (NAT-Gateway, Router, Internet-Gateway) aus, sondern kann direkt aus einem private Network genutzt werden (nur die VPC Endpoint Konfiguration wird benötigt).

Die Lösung sind VPC-Endpoints:

* Interface Endpoints
  * hier konfiguriert man "nur" ein Elastic-Network-Interface (= virtuelle Netzwerkkarte) und eine Security-Group darum
  * unterstützt von den meisten AWS Services
* Gateway Endpoints
  * hier muß man die Routing Tables anpassen

---

## Subnet

* gebunden an ein VPC
* gebunden an eine Availability Zone (z. B. eu-central-1a)
* hat einen CIDR-Block ... der muß eine Teilmenge des VPC sein
* typischerweises verwendet man public (wenige IP-Adressen) und private (viele IP-Adressen) Subnetze
* typischerweises hat man pro Availability Zone, die man abdecken möchte, ein private und ein public Subnetz
* Subnetze müssen entsprechend konfiguriert werden, um aus dem Internet erreichbar zu sein
  * für public Ressourcen: Internet Gateway
  * für private Ressourcen (in private Networks): Bastion Host
    * zumindest ssh Zugriff ist hier für Admins erforderlich
* später werden wir weitere Komponenten (z. B. EC2 Instanz) über das zugewiesene Subnet positionieren und so über verschiedene Availability Zones verteilen und Zugriffe managen
* public Subnets sollten auch public IP-Adressen erhalten (sonst werden sie ja von einem User nicht in mein VPC geroutet) ... das muss man aber explizit konfigurieren

---

## Internet Gateway (IGW) und Route Table

* [Stephan Marek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528544#overview)
* [Configure route tables](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

* IGW stellt - in Verbindung mit einer Route Table und einem Router - den Zugang zwischen dem VPC und dem Internet dar
  * ein IGW ohne Route Table hat keinen Wert, denn nur darüber wird das Internet-Gateway für die Ressourcen der jeweiligen Subnets nutzbar
  * die Main-Route-Table hängt am VPC ... sie enthält per Default nur Einträge, die das Routing zwischen allen Subnetzen des VPC ermöglicht (`target = local`) - ein Routing von innen-nach-außen und von außen-nach-innen ist hier aus Sicherheitsgründen nicht konfiguriert
  * jedes Subnetz hat eine Custom Route Table
  * die Route-Table stellt sicher, dass einkommende Requests auch im ans richtige Subnetz weitergeleitet werden (i. a. ist das dann ein Public-Subnetz)
    * ob ein Subnet private oder public ist hängt einzig und allein daran, ob die Route Table ein Routing ins Subnetz definiert
* von AWS wird sichergestellt, dass es hochverfügbar (skaliert horizontal, Redundanz) ist
* VPC und IGW haben eine 1:1 Beziehung

---

## NAT Instance - DEPRECATED

> **DEPRECATED** by NAT Gateway (seit Ende 2020), die AWS-managed sind, höhere Bandbreite und Verfügbarkeit haben

* erlaubt EC2 Instanzen aus privaten Subnetzen auf das Internet zuzugreifen ... braucht man schon allein, um die Packages des Betriebssystems/Toolings up-to-date zu halten ... also **IMMER**
  * letztlich auch über Router, Route Table und Internet Gateway
  * es wird ein spezielles Amazon Linux AMI bereitgestellt, das als EC2 Instanz im Public-Subnetz deployed wird
* NAT Instance muss im Public Subnetz laufen, denn nur das hat i. a. das Routing über das Internet-Gateway definiert. Ein Zugriff aus dem privaten Subnetz erfolgt also über das NAT
  * es agiert als Vermittlungsstelle zwischen WWW und Private Network
    * da die NAT Instance die Sender-IP-Adresse verändert muss die Einstellung "Source-and-Destination-Check" auf der EC2 Instanz des private Networks disabled werden muss
* braucht eine Elastic IP Adresse (= feste IP-Adresse) ... damit die Responses auf Requests auch wieder ankommen
* ein privates Subnetz verwendet Route Table, um den Traffic über die NAT Instance zu routen

---

## NAT Gateway (NATGW)

* [Stephan Marek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528550#overview)

* wird verwendet, um einer privaten Komponente (z. B. EC2 Instanz) Zugriff auf das Internet zu ermöglichen ... braucht man schon allein, um die Packages des Betriebssystems/Toolings up-to-date zu halten ... also **IMMER**
  * die Route Table muss dazu entsprechend konfiguriert werden
* muss in einem separaten Subnet betrieben werden als eine EC2 Instanz, die es verwenden will
* High-Availability in EINER Availibility Zone
  * ABER: ist gebunden an EINE Availibility Zone => pro AZ ein NAT-Gateway erforderlich
* verwendet eine public Elastic IP (feste IP-Adresse)
* braucht ein Internet Gateway (genauso wie eine *NAT Instance*)
* managed by AWS (im Gegensatz zu NAT Instance)
  * man muss keine Security-Groups managen
  * keine OS Patches, Software Installationen
* es wird keine Security-Group gebraucht

> Bastion Hosts sind mit einem NAT Gateway nicht möglich, da man keinen ssh-Zugriff auf das NATGW hat

---

## Security Group (SG)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/26098134#learning-tools)

* Security Groups regeln den Inbound und Outbound Zugriff auf AWS Resourcen (z. B. EC2, Load-Balancers) ... also im Prinzip eine Firewall. Best-Practice ist ALLE AWS Ressourcen von einer Security Group zu umschließen und damit den Zugriff abzusichern. Eine Security Group filtert den Traffic ... wohingegen eine Route Table den Traffic umlenkt, aber keine Authorisierungskontrolle mehr macht.
* EINE Security Group kann für viele Ressourcen verwendet werden - eine Ressource kann viele Security-Groups zugeordnet haben.
* Security Groups sind stateful (im Gegensatz zum NACL), d. h.
  * wenn ein Incoming-Request durch die Security-Group gelassen wurde, dann wird die Response ungeprüft durchgelassen
  * wenn eine Outgoing-Request durch die Security-Group gelassen wurde, dann wird die Response ungeprüft durchgelassen
* eine Security Group erlaubt ausschließlich ALLOW rules ... weil alles andere by default verboten ist

---

## Network Access Control List (NACL)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528552#overview)

* ein NACL schirmt den Traffic eines (oder mehrerer) ganzer Subnetze ab (im Gegensatz zur Security Group, die nur eine Ressource abschirmt) ... you see: NACLs können wiederverwendet werden
  * Ephemeral Ports sind in diesem Kontext wichtig, denn die NACLs müssen den Rückweg einer Connection durchlassen ... hierbei handelt es sich um einen beliebigen Port, den der Client beim Aufbau der Verbindung für die Antwort anbietet
* NACL sind stateless (im Gegensatz zur Security Group), d. h.
  * wenn ein Incoming-Request durch die NACL gelassen wurde, dann wird die Response trotzdem nochmals geprüft
  * wenn eine Outgoing-Request durch die NACL gelassen wurde, dann wird die Response trotzdem nochmals geprüft
* ein NACL pro Subnetz
* die Default-NACL erlaubt ALLEN eingehenden und ausgehenden Traffic ... convenience Konfiguration, um die AWS-User-Experience nicht zu zerstören
  * will man NACLs anpassen, dann sollte man **NICHT** die Default-NACL anpassen, sondern eine neue erzeugen und dem Subnet zuweisen
  * ein NACL erlaut ALLOW und DENY Rules (im Gegensatz zur Security Group)

---

## Bastion Hosts

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528558#overview)

Für den Zugriff auf eine Ressource (z. B. EC2 Instanz) muss sie public sein. Viele Ressourcen werden aber i. a. im private Network versteckt, um Angriffspunkte zu vermeiden. Hier kommen Bastion Hosts ins Spiel, die im Public Subnet laufen und den Zugriff auf das Private Subnet erlauben.

Für diesen Einsatzbereich muss der Bastion Host natürlich vollkommen sicher sein. Deshalb wird man hier den Zugriff nur auf eine bestimmte IP-Range einschränken (z. B. aus einem Firmen-VPN ... und selbst da vielleicht nur für OPS-Admins).

---

## DNS

* [DNS@pierreinside](dns.md)
* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c03/learn/lecture/28384280#overview)
* [AWS Skillbuilder](https://explore.skillbuilder.aws/learn/course/17896/play/93873/amazon-route-53-basics)

* DNS-Resolving wird auf VPC-Ebene eingestellt
* AWS stellt einen Route53-DNS-Server unter 169.254.169.253 (public IP!!!) zur Verfügung. Auf diese Weise werden
  * Internet-Names (z. B. www.heise.de) aufgelöst ... wenn eine EC2 Instanz beispielsweise Zugriff braucht
  * public EC2 Instanznamen (z. B. `ec2-52-57-251-205.eu-central-1.compute.amazonaws.com`) auf die IP-Adresse (z. B. `52.57.251.205`) aufgelöst
  * private EC2 Instanznamen (z. B. `web.mycompany.private`) wird auf die private IP-Adresse (z. B. `172.31.46.59` augelöst), um intern auch mit sprechenden Domain-Names zu arbeiten (Route53 Hosted Zones)
* man kann auch einen Custom-DNS-Server starten

### Route53

> Der Name leitet sich aus dem Standard-Port für DNS-Server (53) ab.

Route53 ist ein AWS Managed Service, d. h. man sorgt sich nur um die Spezifikation (= Konfiguration) und AWS managed die dahinterliegende Infrastruktur und sorgt für High-Availability (z. B. mehrere DNS Server verteilt über die Welt). Die Route53-Konfiguration ist global, d. h. man macht sie nicht in einer bestimmten AWS Region, sondern Global innerhalb eines AWS Accounts.

Hier lassen sich

* Private Hosted Zones
  * mit dem sich DNS-Namen im eigenen VPC vergeben und auflösen lassen (Routing innerhalb eines VPCs)
* Public Hosted Zones
  * hier agiert AWS als Domain-Registrar (wie jeder andere Domain-Hoster)
* man kann die "Registered Domains" [hier verwalten](https://us-east-1.console.aws.amazon.com/route53/domains)

einrichten.

Bei der Einrichtung einer Zone (z. B. `cachaca.de.`) sorgt AWS dafür, dass ein paar DNS-Servers für die Auflösung von Domains aus dieser Zone (z. B. `www.cachaca.de`) zuständig sind. Diese DNS Server werden als `NS` Records in der Zone `cachaca.de.` hinterlegt.

Route 53 unterstützt auch Routing-Policies (ist das eigentlich eine Route 53 Besonderheit oder kann das jeder DNS Server?):

* Simple
* Failover (z. B. in ein Desaster-Recovery)
  * dann braucht man auch entsprechende Health-Checks
* Geolocation
* Weighted
  * hier vergibt man dann den gleichen A-Record Namen (z. B. `www.cachaca.de`) an verschiedene IP-Adressen und gewichtet deren Nutzung
  * auf diese Weise kann man die Processing Last verteilen oder auch Canary-Releases abbilden
* Multi-Value
  * hiermit lassen sich Client-Side Loadbalancer abbilden
  * dabei liefert Route53 bis zu 8 A-Records für einen FQDN und der Client kann sich einen aussuchen  

Mit den unterschielichen Routing-Typen lassen sich Canary-Releases abbilden, Multi-Region-Failovers, ...

> Routing Policies sind keine richtigen Umleitungen eines Requests an einen anderen Empfänger, d. h. die Nachrichten gehen nicht durch den DNS an einen Zielserver. Es werden nur die FQDN unterschiedlich durch den Nameserver aufgelöst (bei einem sehr niedrigen TTL) und der Client spricht dann halt einen andere IP-Adresse (= Server) an. Insofern ist das ein relativ rudimentäres (nicht-transparentes) Routing. Aus diesem Grund sind diese Routin-Policies auch nur sinnvoll zu verwenden, wenn man einen sehr kleinen TTL verwendet ... ansonsten cached der Client dies sehr lange und der Route53-DNS-Server ist gar nicht mehr in die Entscheidung eingebunden.

Bei der Verwendung von Routing-Policies definiert man für eine FQDN (z. B. www.cachaca.de) unterschiedliche IP-Adressen. Je nach Routing-Strategie (z. B. Latency) erhält der Anfrager eine andere IP-Adresse (z. B. die IP-Adresse eine Elastic Loadbalancers - ALB). Blöd wäre nun aber dieser Load-Balancer derzeit nicht verfügbar ist, aber die DNS-Auflösung zu ihm führt. Um das zu vermeiden, können Health-Checks für bestimmte DNS-Records (abhängig von der Routing-Policy) konfiguriert werden. Diese haben dann Einfluss auf die Routing-Strategy. AWS unterhält hierzu Health-Checker Dienste (außerhalb des Kunden-VPC - managed by AWS), die aus aller Welt die Health-Check-URL des Ziels aufrufen. Antwortet der Health-Check des ALB mit einer 2xx/3xx (der Health-Check kann aber auf den Text der Antwort parsen, um eine bessere Interpretation durchzuführen) so wird das als "healthy" interpretiert. Erst wenn mind. 18% der Health-Checkers den Service als "healthy" bewerten, wird er tatsächlich als "healthy" angesehen und Traffic wird dorthin geroutet.

> Viele Anwendungen (z. B. Spring-Boot Anwendungen) haben eine dedizierte Health-Check url (z. B. http://www.cachaca.de/health). Haben sie das nicht, dann steht unter dem FQDN vermutlich nur ein allgemeiner Request zur Verfügung und man kann nur den HTTP-Status Code 2xx/4xx/... für eine Interpretation des Health-Status verwenden-

Neben einfachen Health-Checks, die nur eine einzige IP-Adresse prüfen können, kann man _Calculated Health-Checks_ verwenden, die die Ergebnisse mehrerer einfacher Health-Checks zu einem gemeinsamenen Health-Check kombinieren.

Dadurch, dass die Health-Checkers außerhalb des VPC liegen, können sie grundsätzlich nur Public-Endpoints prüfen - die Security-Groups/Firewalls müssen den Zugriff erlauben. Die Health-Checkers liegen in einer dedicated IP-Range, so dass man leicht Ausnahmen zuverlässig deklarieren kann. Für private Endpoints kann man sich eines Tricks bedienen ... CloudWatch-Metric mit einem CloudWatch-Alarm - der Healthcheck monitored dann den CloudWatch-Alarm.

**Verwendet man das tatsächlich in der Praxis ... gibt es nicht viel bessere Lösungen?**

* ja man verwendet es tatsächlich noch für
  * Geolocation
  * Weighted Routing
  * ...
* ABER: das ersetzt natürlich nicht Server-Side-Loadbalancer
  * man kann mit Multi-Value Strategie einen Client-Side-Loadbalancer abbilden

### External DNS-Registrar aber Route53 Hosted Zone

Wenn man eine Domain (cachaca.de) bei einem beliebigen DNS-Registrar (z. B. webspace-verkauf.de) kauft, dann stellt dieser i. a. auch den DNS-Server bereit. Diese DNS-Server sind als NS-Entries in seiner hosted Zone eingetragen und steuern das Management der DNS-Zone. Nun kann man aber die NS-Entries beim External Registrar editieren und hier zum Beispiel die DNS-Servers eintragen, die man beim Einrichten einer AWS-Hosted-Zone erstellt bekommt.

---

## Elastic Network Interface (ENI)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/18077955#learning-tools)

Hierbei handelt es sich um die virtuallen Netzwerkkarten einer Ressource.

Das besondere daran ist, daß man sie zur Laufzeit einfach einer anderen EC2 Instanz zuordnen kann, um beispielsweise Fail-over abzubilden (die IP-Adresse bleibt dabei erhalten und der Traffic wird einfach auf eine andere Instanz umgeleitet).

---

## Transit Gateway

Ein Transit-Gateway regelt den Zugriff auf andere VPCs (und auch OnPrem-Netzwerke).

---

## Direct Connect (DX)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13531250#overview)
* [What is AWS Direct Connect?](https://docs.aws.amazon.com/directconnect/latest/UserGuide/Welcome.html)

* private Connection vom Corporate Datacenter ins AWS VPC
  * Zugriff auf Public UND Private AWS Ressourcen
* typischer Aspekt bei Cloud-OnPrem-Integrationsszenarien
* verwendet ein Virtual Private Gateway (VGW) am AWS VPC

---

## Virtual Private Gateway (VGW)

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/13528560#overview)

Wird verwendet, um Corporate Networks per VPN mit einem AWS VPC zu verbinden. Hiermit lassen sich dann auch Hybrid-Cloud-Solutions realisieren.

### AWS VPN CloudHub

hier lassen sich sogar verschiedene Corporate Standorte über VPN via Virtual Private Gateway (VGW) verbinden.

---

## Troubleshooting

Bei der manuellen Konfiguration (aber auch bei einer Konfiguration via [Terraform](terraform.md)) können sich schnell Fehler einschleichen. AWS stellt ein paar Debugging-Tools zur Verfügung.

### VPC Rechability Analyzer

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/28874542#overview)

Mit diesem Tool lassen sich Probleme in der Kommunikationskonfiguration (Subnetze, NACL, Security-Groups, ENI, ...) analysieren, ohne daß dabei Kommunikation stattfindet (d. h. das funktioniert auch in Produktivumgebungen sehr gut). Man bekommt hier sehr detailierte Informationen über das Problem und kann daraus häufig direkt eine Lösung ableiten.

Der Nachteil der AWS Console oder auch Configuration-as-Code ist, daß durch die Verwendung von IDs beim referenzieren der "Code" sehr schwer lesbar ist und so Fehler sehr schwer zu entdecken sind. Zudem ist die Konfiguration häufig weit verstreut und die Konzepte (z. B. NACL vs Security Group = stateless vs stateful) nicht im Detail nicht immer geläufig sind.

> **ABER:** es kostet pro Analyse

### Network Access Analyzer

...

### VPC Flow Logs

* [Stephane Maarek](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/28874566#overview)

Daten werden nach S3 oder CloudWatch geschrieben.
