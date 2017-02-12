# Raspberry Pi
# Raspberry 3
Hierbei handelt es sich um ein vollausgestattes Modell mit

* 4 USB-Anschlüsse
* WLAN Modul
* Ethernet Adapter
* Kamera-Port
* Display Port Anschluß für ein Touch Screen
* GPIO-Anschlüsse verfügbar

# Raspberry Pi Zero
Der Raspberry PI Zero ist das kleinste Modell und mit 5 Euro extrem günstig. Er bringt allerdings auch keinen Netzwerkanschluß mit und nur einen einzigen USB-Anschluß für Periperiegeräte (ein USB-Anschluß steht zurätzlich für die Stromversorgung zur Verfügung).

Die GPIO Anschlüsse müssen noch eingelötet werden.

Aber für 5 Euro ... ein Einstieg in IoT ist gemacht. 

## GPIOs einlöten
* https://www.youtube.com/watch?v=97Or02ihJMo

# Betriebssystem
* https://www.raspberrypi.org/downloads/

Das Betriebssystem wird auf einer SD-Karte installiert. Hierzu braucht man einen PS/Laptop, um das Betriebssystem auf die Karte zu bekommen.

## Formatierung SD-Karte
* [SD Card Formatter](https://www.sdcard.org/downloads/formatter_4/index.html)

Der SD Card Formatter wird auf einem Laptop installiert und danach die SD-Karte formatiert.

## Option 1: Installation über Noobs
* https://www.raspberrypi.org/downloads/noobs/
* https://www.raspberrypi.org/help/videos/#noobs-setup

Noobs ist ein Installer für verschiedene Raspberry Betriebssysteme. Noobs wird auf dem Raspberry installiert und kann sich dann verschiedene andere Betriebssysteme aus dem Internet ziehen und installieren.

Folgende Schritte durchführen:
* Noobs-Zip-Archiv entpackt auf die formatierte SD Karte kopieren
* SD-Karte in den Raspberry stecken
* einen Bildschirm über HDMI anstecken
* WLAN Modul über USB einstecken
* Tastatur über USB anschließen
* Raspberry über USB mit Strom versorgen

Jetzt bootet das System in den Noob-Installer. Hier wählt man das gewünschte Betriebssystem aus, das im Anschluß aus dem Internet gezogen und installiert wird.

## Option 2: Installation über ein Image File
* https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Möchte man keine Installation über Noobs machen, so kann man sich vorab auch für ein Betriebssystem entscheiden, das man auf die SD-Karte kopiert. Hierzu:

* Download des Betriebssystem Archivs (z. B. Raspbian: https://www.raspberrypi.org/downloads/raspbian/)
* Entpacken des Archivs (enthält eine `*.img` Datei)
* mit dem [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) das `*.img` Image auf die SD-Karte schreiben

Jetzt kann das System über die SD-Karte gebootet werden.

## Option 3: Installation ohne Monitor und WLAN
* http://blog.gbaman.info/?p=699
* https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a

Scheinbar schnell gemacht und unspektakulär.

## Raspbian
Raspian kann über Noob oder direkt installiert werden (siehe oben).

Nach der Installation bootet das System per default in Runlevel 3 ... also keine grafische Oberfläche. Über ein Konsolenfenster startet man per `startx` die grafische Oberfläche. 

---

# Betrieb ohne Monitor
Nach der Erstinstallation (für die man zur Auswahl des per Noob zu installierenden Betriebssystems eine grafische Ausgabe benötigt) braucht man keinen Bildschirm mehr. Eine Textkonsole bekommt man per `ssh` und eine grafische Oberfläche per VNC (geht auch ssh mit X11-Forwarding?) ... allerdings geht die Kommunikation dann übers Netzwerk (Performance?). 

## VNC
* http://strobelstefan.org/?p=2731

VNC-Server per `sudo aptitude install tightvncserver` auf dem Raspberry installieren und per `tightvncserver` starten. Danach eine VNC Session auf dem Raspberry mit `vncserver :1 -geometry 1024x728 -depth 24` erstellen.

Mit einem VNC kompatiblen Client auf einem Laptop kann man sich dann - eine Netzwerkverbindung vorausgesetzt - mit dem Raspberry verbinden.

---

# WLAN
## USB Stick-Kompatibilität
* http://www.forum-raspberrypi.de/Thread-liste-kompatibler-wifi-adapter

Man sollte darauf achten einen Raspberry PI Zero kompatiblen WLAN Sstick zu verwenden. Außerdem darauf achten, daß der WLAN-Stick nicht zuviel Strom benötigt (die er über einen aktiven USB-Hub bekommen könnte) ... je nach Anwendungsfall kann das aber auch kein Problem darstellen. 

* NETGEAR WNA1000M-100PES N150 kostet nur 6 Euro
* LogiLink WL0084E Wireless-LAN Nano-Adapter kostet nur 6 Euro
* TP-Link TL-WN823N v1 für 10 Euro sollte passen (ABER ACHTUNG: angeblich nur die v1 - nicht die v2).
* 
## Inbetriebnahme
* https://thepihut.com/blogs/raspberry-pi-tutorials/16018016-how-to-setup-wifi-on-the-raspberry-pi-raspbian
* http://strobelstefan.org/?p=4282

--- 
# Zubehör
## Breadboard
* https://www.datenreise.de/raspberry-pi-wie-verwendet-man-ein-breadboard-steckplatine-anleitung/

Hiermit lassen sich GPIO-Verbindungen ohne Löten aufbauen ... also sehr praktisch zum Rumprobieren.

---

# Hausautomatisierung
Der Markt der Hausautomatisierung ist sehr fragmentiert und das macht die langfristige Entscheidung für eine Ecosystem so schwierig. Es ist sehr viel Bewegung im Markt und die Gefahr aufs falsche Pferd zu setzen groß.

## Funkprotokolle
* http://www.pc-magazin.de/ratgeber/funkprotokolle-ueberblick-rwe-zwave-homematic-1530051.html

Im Haus muß es i. a. ohne Kabel gehen (zumindest wenn man ein Haus nachrüsten möchte) ... deshalb sind Funkprotokolle hier besonders wichtig. Die Endgeräte sind

* Sensoren
* Motoren

und die sprechen dann den ein oder anderen Standard. 

**Endgeräte-Verfügbarkeit:** 

Am besten entscheidet man sich für einen offenen Standard, der weit verbreitet ist. Ärgerlich, wenn man nach Jahren einen Sensor austauschen will und es für den Funkstandard keine Hardware mehr gibt.

**Frequenzbereich:**

Je niederfrequenter (434 MHz oder 868 MHz) das Protokoll ist desto höher die Reichweite und Mauerdurchlässigkeit. 

**Lizenzkosten:**

Lizenzkosten können eine Rolle spielen - bei 434 MHz oder 868 MHz fallen sie beispielsweise nicht an. 

**Energieaufnahme:**

Die notwendige Energieaufnahme ist in diesem Bereich außerdem ein wichtiger Aspekt.

**Störungen:**

In manchen Frequenzbändern sind sehr viele Geräte (WLAN 2,4 GHz) unterwegs und es kommt dementsprechend häufig zu Störungen.

**Sicherheit:**

Hackerangriffe (z. B. Tür kann von Unberechtigten geöffnet werden) sind immer ein Thema.

### WLAN
* spielt in diesem Bereich keine Rolle - im Bereich Homeautomatisierung braucht niemand die Datenmengen, auf die WLAN ausgelegt ist
* hier gibt es kaum Endgeräte

### Bluetooth

### Z-Wave
* Standard G.9959 
* Allianz aus 160 Herstellern
* 600 zertifizierte Produkte
* 868 MHz (Europa), 908 MHz (USA) und 2,4 GHz (weltweit)
* Netzwerktopologie mit Zwischenknoten - Knoten A kann mit Knoten C über Knoten B kommunizieren ... obwohl Knoten A und C nicht direkt kommunizieren können
* Endgeräte recht günstig über Versandhandel zu beziehen
* auf Batteriebetrieb ausgelegt

### ZigBee
* Standard IEEE 802.15.4
  * allerdings gibt es einige Sonderimplementierungen, so daß die Kompatibilität nicht immer gewährleistet ist
* Allianz aus 250 Herstellern
* Leistungsaufnahme sehr gering - für den Batteriebetrieb geeignet und dadurch über Jahre wartungsfrei (verbessert durch den sog. Schalfmodus)
* 868 MHz (Europa), 915 MHz (USA) und 2,4 GHz (weltweit)
* gilt als nicht besonders sicher
* Netzwerktopologie mit Zwischenknoten - Knoten A kann mit Knoten C über Knoten B kommunizieren ... obwohl Knoten A und C nicht direkt kommunizieren können

### HomeMatic
* Firma eQ-3
* proprietäres Protokoll
* viele Endgeräte
* gute Sicherheit über AES-128-Verschlüsselung
* geringer Stromverbrauch
* auf Batteriebetrieb ausgelegt
* es gibt Aktoren, die ihre Funktion auch automon (ohne einen Trigger von außen) ausführen können
* Endgeräte recht günstig über Versandhandel zu beziehen
* große Internet-Community

### RWE SmartHome
* in Kooperation mit eQ-3 (entwickelt die Endgeräte)
* hohe Sicherheit (AES-128 Verschlüsselung)
* Endgeräte recht günstig über Versandhandel zu beziehen
* viele Engeräte - im Vergleich zu ZigBee und Z-Wave aber eher wenig
 
### KNX-RF
* drahtgebunden ... scheidet für eine Nachrüstung aus

### DECT
* im Frequenzband 1,9 GHz - vergleichsweise hohe Energieaufnahme
* Fritzbox unterstützt diesen Ansatz (Funkschalter, Dimmer)
* kaum Endgeräte vorhanden

## Eclipse SmartHome
Hierbei handelt es sich um ein Java-OSGI-basiertes Framework zur Integration Funkstandards/Hersteller/Endgeräte. Lösungen (u. a. OpenHAB) verwenden Eclipse SmartHome als Basis.

REST API

## OpenHAB
Lösung basierend auf [Eclipse SmartHome](https://eclipse.org/smarthome/) - Java-basiert.

### Unterstützte Funkstandards
* Z-Wave
* HomeMatic

### OpenHAB-Server@Raspberry
* http://docs.openhab.org/installation/rasppi.html
* https://github.com/openhab/openhabian

OpenHAB bringt eine eigene Rasbian Distribution namens *OpenHABian*mit.

### OpenHAB-Server@Synology
* https://github.com/openhab/openhab-syno-spk

OpenHAB läuft auch auf einem Synology.

### OpenHAB-Server@Docker
* https://github.com/openhab/openhab-docker
* http://docs.openhab.org/installation/docker.html#obtaining-the-official-image-from-dockerhub

### OpenHAB-Client for iOS
* https://github.com/openhab/openhab.ios

Basierend auf der REST-API.

### OpenHAB-Client for Windows
* https://github.com/openhab/openhab.windows

Basierend auf der REST-API.

---

# Bastelideen
* https://raspberry.tips/hausautomatisierung/raspberry-pi-software-zur-hausautomatisierung/