# GL-AR750S-Ext aka Slate

Bei diesem Gerät handelt es sich um einen Mini-Router in der Größe eines Handy's. Das besondere ist, daß man ihn mit einem 5V-USB-Kabel betreibt - man kann also einfach die Powerbank anschließen und im Internet-Cafe die WLAN-Verbindung nutzen ... der Slate kümmert sich um die VPN Verschlüsselung aller über sein WLAN angeschlossenen Geräte.

Der Slate kann sich über folgende Kanäle mit dem Internet verbinden:

* LAN
* WLAN
* USB-Tethering mit angeschlossenem Handy
* USB-3G/4G-Model, z. B. USB-Stick mit SIM-Karte (nicht im Lieferumfang)

Der Slate bietet folgende Anschlüsse für Geräte, die sich untereinander oder mit dem Internet verbinden wollen:

* LAN (2x)
  * er hat 3 LAN Anschlüsse, die alle im Switch-Modus genutzt werden können. Nutzt man eine LAN-Verbindung für den Zugang zum Internet, so bleiben noch 2 LAN-Buchsen frei
* 2 WLANs mit jeweils 2,4G und 5G
  * somit läßt sich ein normales WLAN und ein Gäste-WLAN realisieren

Zudem hat er einen Micro-SD-Slot als Datenspeicher.

---

## Erst-Inbetriebnahme

> nach einem Reset auf Werkseinstellungen muss dieser Vorgang wiederholt werden

Der Slate arbeitet per Default im Router-Modus, d. h. er baut nach dem Start zwei eigene WLANs (2,4 GHz und 5 GHz) auf. Mit einem der WLANs muß man sich verbinden und die Erst-Konfiguration über die Adminitrations-Web-Oberfläche vornehmen - die Zugangsdaten befinden sich auf der Unterseite des Slate. Nachdem die WLAN-Verbindung steht, gehts per Internet-Browser zur Erst-Konfiguration per Web-UI. Die IP-Adressen sind im Werkszustand

* normales WLAN: `192.168.8.1` - nur hierüber ist die Admin-Web-UI erreichbar
* Gäste-WLAN: `192.168.9.1`

und das WLAN Password ist `goodlife`. Bei der Erstanmeldung über das Web-UI http://192.168.8.1 (leider kein SSL Support) muß man ein Passwort für den Adminitrator-User `root` vergeben.

Die wichtigste Entscheidung ist die der Netzwerk-Architektur (siehe unten). Per Default ist der Slate im Router-Modus.

---

## Maintenance

### Update

Gelegentlich sollte man die Firmware des Slate aktualsieren (Security Patches). Das erfolgt über die Administrations-Web-UI.

### Netzwerk-Reset

Durch drücken des Reset-Buttons (neben dem Mode-Button) für 3 Sekunden wird das Netzwerk-Setup zurückgesetzt. Sehr praktisch, wenn man das sich mal verkonfiguriert hat und das Administrations-Web-UI nicht mehr erreichbar ist

### Factory-Reset

Durch drücken des Reset-Buttons (neben dem Mode-Button) für 10 Sekunden wird das Gerät auf Werkseinstellungen zurückgesetzt.

---

## Network-Mode

* [Dokumentation](https://docs.gl-inet.com/en/3/setup/slate/more_settings/#network-mode)

Bei der Erst-Inbetriebnahme oder nach einem Reset auf Werkseinstellungen arbeitet der Slate im Router-Modus. Er bietet zwei eigene WLANs an, hat aber noch keine Internetverbindung. Nachdem man sich mit dem WLAN verbunden hat (die Default Zugangsdaten befinden sich an der Unterseite des Geräts) kann man die Administrations-Web-Oberfläche erreichen und die Internet-Verbindung konfigurieren, die in diesem Modus noch nicht existiert.

In der [Web-Oberfläche - Netzwerk-Architektur](http://192.168.8.1/#/bridge) kann man den Netzwerk-Modus bestimmen.

> ACHTUNG: die Umkonfiguration auf einen anderen Netzwerk-Modus kann dazu führen, daß die Administrationsoberfläche nicht mehr verfügbar ist (weil sich die IP-Adresse dadurch ändert). Durch Drücken der Reset-Taste für 3-4 Sekunden wechselt der Slate automatisch wieder in den Router-Modus, so daß man sich über dessen WLAN und die Default-IP-Adresse (so man die nicht)

### Router Modus

> Der von mir präferierte Modus - leicht konfiguriert ... allerdings nicht transparent

In diesem Modus arbeitet der Slate mit der konfigurierten Internetverbindung im Router-Modus, d. h. er bietet sein WLAN an und routet den Traffic in das Netzwerk der Internetverbindung.

Die Endgeräte müssen sich dann also mit dem WLAN des Slate verbinden, was natürlich weniger transparent ist als der Extender Modus, bei dem das bestehende WLAN (des Heimnetzwerkes) erweitert wird und über den üblichen Namen verfügbar ist.

### Access Point Modus

... wenn man den Slate per Netzwerkkabel an ein Switch anschließt

### Extender Modus

... wenn man ein bestehendes WLAN erweitern will

Ich hänge meinen Slate am liebsten in das Gäste-WLAN meines Routers. Damit erhält er eine IP-Adresse, die von meinem Router festgelegt wird. Um nicht immer wieder nach der (dynamischen) IP-Adresse 

### WDS

... wie im Extender-Mode ... allerdings muß man die Zugangsdaten nicht manuell eigeben

---

## Performance

* an einer 100 Mbit/s DSL Leitung
* iPhone 7 per WLAN mit Slate verbunden (liegt direkt neben dem Slate)
* Slate per Powerbank betrieben

> ACHTUNG: es spielt eine große Rolle wie die Antennen des Slate in Relation zum Endgerät (iPhone) und zum Internet-Provider (z. B. WLAN des Home-Routers) ausgerichtet sind und welche Reflexionen (Wände) stattfinden. Es kommt also auf viele Parameter an ... einfach ausprobieren mit einem Speedtest Tool (z. B. [Oookla](https://speedtest.net)). Die Geschwindigkeit kann dadurch wirklich EXTREM schwanken ... bei mir zwischen 3 MBit und 80 MBit/s. KRASS.

Bei meinen Recherchen habe ich rausgefunden, daß der Slate wirklich schnell ist und fast an die 100 MBit meiner DSL-Verbindung rankommt. Sollte die Internetverbindung langsam sein, dann liegt es vermutlich an Konfiguration oder Ausrichtung der Antennen ... aber nicht an der Hardware des Slate - kein limitierender Faktor.

Typischerweise ist das 5GHz-Frequenzband schneller als das 2,4 GHz, wenn keine Wände dazwischen sind. Das 2,4 Band ist zumeist überlastet mit zu vielen Endgeräten, die sich die Bandbreite dann teilen müssen.

### Router-Modus

Download-Geschwindigkeit

* Internet-Router 3m entfernt
* über 2,4 GHz
  * 10-30 MBit/s
* über 5 GHz
  * 50-80 MBit/s

> Geschwindigkeitsvorteile ergeben sich wahrscheinlich aufgrunde weniger Geräte in diesem Frequenzbereich

---

## Betrieb an der Powerbank

Der Normal-Betrieb an einer Powerbank hat problemlos funktioniert. Meine Powerbank (Anker Power Core II 20000 mAh) lief damit 10 Stunden und der Ladezustand hat sich nicht einmal verändert (allerdings war 8 Stunden auch keinerlei Traffic). Ich bin gespannt, ob das unter Last mehrerer Clients mit VPN-Verschlüsselung auch noch funktioniert.

Auf diese Weise kann ich leicht mal mein WLAN erweitern (im Repeater-Modus), um am Ende des Gartens die WLAN-Situation zu verbessern.
