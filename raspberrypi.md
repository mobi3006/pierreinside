# Raspberry Pi

## Raspberry 3

Hierbei handelt es sich um ein vollausgestattes Modell mit

* 4 USB-Anschlüsse
* WLAN Modul
* Ethernet Adapter
* Kamera-Port
* Display Port Anschluß für ein Touch Screen
* GPIO-Anschlüsse verfügbar

## Raspberry Pi Zero

Der Raspberry PI Zero ist das kleinste Modell und mit 5 Euro extrem günstig. Er bringt allerdings auch keinen Netzwerkanschluß mit und nur einen einzigen USB-Anschluß für Periperiegeräte (ein USB-Anschluß steht zurätzlich für die Stromversorgung zur Verfügung).

Die GPIO Anschlüsse müssen noch eingelötet werden.

Aber für 5 Euro ... ein Einstieg in IoT ist gemacht. 

### GPIOs einlöten

* https://www.youtube.com/watch?v=97Or02ihJMo

## Betriebssystem

* https://www.raspberrypi.org/downloads/

Das Betriebssystem wird auf einer SD-Karte installiert. Hierzu braucht man einen PS/Laptop, um das Betriebssystem auf die Karte zu bekommen.

### Formatierung SD-Karte

* [SD Card Formatter](https://www.sdcard.org/downloads/formatter_4/index.html)

Der SD Card Formatter wird auf einem Laptop installiert und danach die SD-Karte formatiert.

### Option 1: Installation über Noobs

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

### Option 2: Installation über ein Image File

* https://www.raspberrypi.org/documentation/installation/installing-images/README.md

Möchte man keine Installation über Noobs machen, so kann man sich vorab auch für ein Betriebssystem entscheiden, das man auf die SD-Karte kopiert. Hierzu:

* Download des Betriebssystem Archivs (z. B. Raspbian: https://www.raspberrypi.org/downloads/raspbian/)
* Entpacken des Archivs (enthält eine `*.img` Datei)
* mit dem [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) das `*.img` Image auf die SD-Karte schreiben

Nicht wundern, daß Windows die Karte nun mit 62 MB Größe anzeigt. Hierbei handelt es sich ausschließlich um die Boot-Partition (enthält u. a. `kernel.img`). Das Image hat noch mehr Speicher belegt, aber das zeigt Windows nicht an.

Jetzt kann das System über die SD-Karte gebootet werden. 

> Bei mir hat das mit einem Rasspberry PI Zero nicht auf Anhieb geklappt. Der über HDMI angeschlossene Monitor blieb einfach schwarz. Vielleicht liegt es an der Micro-SD, die vielleicht nicht kompatibel ist: http://elinux.org/RPi_SD_cards

### Option 3: Installation ohne Monitor und WLAN

* http://blog.gbaman.info/?p=699
* https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a

Scheinbar schnell gemacht und unspektakulär.

### Raspbian

Raspian kann über Noob oder direkt installiert werden (siehe oben).

Nach der Installation bootet das System per default in Runlevel 3 ... also keine grafische Oberfläche. Über ein Konsolenfenster startet man per `startx` die grafische Oberfläche.

## Betrieb ohne Monitor

Nach der Erstinstallation (für die man zur Auswahl des per Noob zu installierenden Betriebssystems eine grafische Ausgabe benötigt) braucht man keinen Bildschirm mehr. Eine Textkonsole bekommt man per `ssh` und eine grafische Oberfläche per VNC (geht auch ssh mit X11-Forwarding?) ... allerdings geht die Kommunikation dann übers Netzwerk (Performance?). 

### VNC

* http://strobelstefan.org/?p=2731

VNC-Server per `sudo aptitude install tightvncserver` auf dem Raspberry installieren und per `tightvncserver` starten. Danach eine VNC Session auf dem Raspberry mit `vncserver :1 -geometry 1024x728 -depth 24` erstellen.

Mit einem VNC kompatiblen Client auf einem Laptop kann man sich dann - eine Netzwerkverbindung vorausgesetzt - mit dem Raspberry verbinden.

## WLAN

### USB Stick-Kompatibilität

* http://www.forum-raspberrypi.de/Thread-liste-kompatibler-wifi-adapter

Man sollte darauf achten einen Raspberry PI Zero kompatiblen WLAN Sstick zu verwenden. Außerdem darauf achten, daß der WLAN-Stick nicht zuviel Strom benötigt (die er über einen aktiven USB-Hub bekommen könnte) ... je nach Anwendungsfall kann das aber auch kein Problem darstellen. 

* NETGEAR WNA1000M-100PES N150 kostet nur 6 Euro
* LogiLink WL0084E Wireless-LAN Nano-Adapter kostet nur 6 Euro
* TP-Link TL-WN823N v1 für 10 Euro sollte passen (ABER ACHTUNG: angeblich nur die v1 - nicht die v2).

### Inbetriebnahme

* https://thepihut.com/blogs/raspberry-pi-tutorials/16018016-how-to-setup-wifi-on-the-raspberry-pi-raspbian
* http://strobelstefan.org/?p=4282

## Programmierung

### Node RED

Hiermit lassen sich sehr komfortabel Aktionsketten programmieren/konfigurieren.

Installation per

```bash
sudo apt-get install nodered
```

## Zubehör

Zubehör gibt es häufig auch als Starter Kits ... das macht auf jeden Fall Sinn, um schon mal eine Basisausstattung zu haben.

### Breadboard

* https://www.datenreise.de/raspberry-pi-wie-verwendet-man-ein-breadboard-steckplatine-anleitung/

Hiermit lassen sich GPIO-Verbindungen ohne Löten aufbauen ... also sehr praktisch zum Rumprobieren.

---

## Bastelideen

* [Projekt Sportstracker - unser eigenes Projekt](projekt_sportstracker.md)
* https://raspberry.tips/hausautomatisierung/raspberry-pi-software-zur-hausautomatisierung/
* http://raspberrypiguide.de/howtos/powerpi-raspberry-pi-haussteuerung/

---
