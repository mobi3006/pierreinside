# GL-AR750S-Ext aka Slate

Bei diesem Gerät handelt es sich um einen Mini-Router in der Größe eines Handy's. Das besondere ist, daß man ihn mit einem 5V-USB-Kabel betreibt - man kann also einfach die Powerbank anschließen und im Internet-Cafe die WLAN-Verbindung nutzen ... der Slate kümmert sich um die VPN Verschlüsselung aller über sein WLAN angeschlossenen Geräte.

Der Slate kann sich über folgende Kanäle mit dem Internet verbinden:

* LAN
* WLAN
* USB-Tethering
* USB-3G/4G-Model, z. B. USB-Stick mit SIM-Karte (nicht im Lieferumfang)

Der Slate bietet folgende Anschlüsse für Geräte, die sich untereinander oder mit dem Internet verbinden wollen:

* LAN (2x)
  * er hat 3 LAN Anschlüsse, die alle im Switch-Modus genutzt werden können. Nutzt man eine LAN-Verbindung für den Zugang zum Internet, so bleiben noch 2 LAN-Buchsen frei
* 2 WLANs mit jeweils 2,4G und 5G
  * somit läßt sich ein normales WLAN und ein Gäste-WLAN realisieren

Zudem hat er einen Micro-SD-Slot als Datenspeicher.

---

## Erst-Inbetriebnahme

Der Slate baut nach dem Start ein WLAN auf, mit dem man sich zur Konfiguration mit dem Browser verbindet. Die IP-Adresse ist im Werkszustand

* normales WLAN: `192.168.8.1` - nur hierüber ist die Admin-Web-UI erreichbar
* Gäste-WLAN: `192.168.9.1`

und das WLAN Password ist `goodlife`. Bei der Erstanmeldung über das Web-UI http://192.168.8.1 (leider kein SSL Support) muß man ein Passwort für den Adminitrator-User `root` vergeben.

### Netzwerk-Reset

Durch drücken des Reset-Buttons (neben dem Mode-Button) für 3 Sekunden wird das Netzwerk-Setup zurückgesetzt. Sehr praktisch, wenn man das sich mal verkonfiguriert hat und das Asmin-Web-UI nicht mehr erreichbar ist

### Factory-Reset

Durch drücken des Reset-Buttons (neben dem Mode-Button) für 10 Sekunden wird das Gerät auf Werkseinstellungen zurückgesetzt.

---

## Betrieb an der Powerbank

Der Normal-Betrieb an einer Powerbank hat problemlos funktioniert. Meine Powerbank (Anker Power Core II 20000 mAh) lief damit 10 Stunden und der Ladezustand hat sich nicht einmal verändert (allerdings war 8 Stunden auch keinerlei Traffic). Ich bin gespannt, ob das unter Last mehrerer Clients mit VPN-Verschlüsselung auch noch funktioniert.

Auf diese Weise kann ich leicht mal mein WLAN erweitern (im Repeater-Modus), um am Ende des Gartens die WLAN-Situation zu verbessern.

---

## Network-Mode

### Router

Das ist der Default-Mode - der Slate verbindet die beiden getrennten Netzwerke (Internet und internes Netzwerk) miteinander. Zwischendrin kümmert er sich bei Bedarf um die VPN-Verschlüsselung.

### Access Point

### Extender

### WDS
