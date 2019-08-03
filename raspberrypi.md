# Raspberry Pi (RPi)

---

## Dokumentation/Tutorials

* [Freenove](https://github.com/Freenove/Freenove_Ultimate_Starter_Kit_for_Raspberry_Pi/archive/master.zip)
* [Elektronik-Fibel](https://www.elektronik-kompendium.de/shop/buecher/elektronik-fibel)
* Elektronik-Kompendium
  * [Elektronik Grundlagen](https://www.elektronik-kompendium.de/sites/grd/index.htm)
  * [Raspberry PI](https://www.elektronik-kompendium.de/sites/raspberry-pi/index.htm)

---

## Raspberry 3

Hierbei handelt es sich um ein vollausgestattes Modell mit

* 4 USB-Anschlüsse
* WLAN Modul
* Ethernet Adapter
* Kamera-Port
* Display Port Anschluß für ein Touch Screen
* GPIO-Anschlüsse verfügbar

---

## Raspberry Pi Zero

Der Raspberry PI Zero ist das kleinste Modell und mit 5 Euro extrem günstig. Er bringt allerdings auch keinen Netzwerkanschluß mit und nur einen einzigen USB-Anschluß für Periperiegeräte (ein USB-Anschluß steht zurätzlich für die Stromversorgung zur Verfügung).

Die GPIO Anschlüsse müssen noch eingelötet werden.

Aber für 5 Euro ... ein Einstieg in IoT ist gemacht.

### GPIOs einlöten

* https://www.youtube.com/watch?v=97Or02ihJMo

---

## GPIO - General Purpose Input Output

* [PIN Belegung](https://www.elektronik-kompendium.de/sites/raspberry-pi/1907101.htm)

Mit den GPIOs lassen sich

* Eingaben (z. B. Taster)
* Ausgaben (z. B. LEDs, Displays)

integrieren, um sie in einer Software zu benutzen (z. B. Steuerung für einen MP3 Player).

Zudem bieten GPIOs verschiedene Stromversorgungen an (3,3V und 5V).

### Breadboard

* [YouTube Video - GPIO Extension Board anschließen](https://www.youtube.com/watch?v=E61VYI3VSRo)
* [Verwendung eines Breadboards](https://www.datenreise.de/raspberry-pi-wie-verwendet-man-ein-breadboard-steckplatine-anleitung/)

Hiermit lassen sich GPIO-Verbindungen ohne Löten aufbauen ... also sehr praktisch zum Rumprobieren. Man benötigt hierzu Female-Male-Kabel, das Female-Ende steckt man auf den GPIO und das Male-Ende in das Breadboard - damit führt man den GPIO-PIN aus dem Raspberry PI Motherboard raus und schafft Platz für LEDs, Schalter, ... die auf das Breadboard verbaut werden. Wenn man alle GPIO Pins auf das Board rausführt, dann belegt man schon 20 Zeilen auf dem Breadboard - je nach Größe des Breadboards bleiben dann viel oder wenige Reihen zum Aufbau der eigenen Schaltung.

Mit einem [GPIO Extension Board - ca. 10 Euro](https://www.amazon.de/dp/B00NWA2AS0/ref=dp_prsubs_1) lassen sich ALLE GPIO Anschlüsse auf ein Breadboard rausführen. Man benötigt dann keine Female Kabel mehr und hat alle Anschlüsse außerhalb des Motherboards zur Verfügung. Das ist sehr praktisch, wenn man seinen Raspberry schon in ein Gehäuse verpacken will und der Zugang zu den GPIOs nur mit Aufwand möglich ist.

Man kann auf das Breadboard auch n

### Programmieren mit Python

* [mit GPIO programmieren](https://www.elektronik-kompendium.de/sites/raspberry-pi/2006041.htm)

> "Bevor man einen GPIO als Eingang oder Ausgang benutzen kann, muss dieser konfiguriert bzw. eingestellt werden. Leider merkt sich der Raspberry Pi diese Einstellung nicht. Deshalb muss die Einstellung bei jedem Neustart erneut ausgeführt werden." ([GPIO konfigurieren/einstellen](https://www.elektronik-kompendium.de/sites/raspberry-pi/2202131.htm))

### Programmieren mit Java

* https://pi4j.com/
* [Java auf Raspberry PI installieren](http://www.savagehomeautomation.com/pi-jdk)

> ACHTUNG: Die Verwendung von Java statt Python hat den Nachteil, daß bei Java noch Bytecode mittels Java-Compiler aus dem Source-Code erzeugt werden muß. Beim interpretierten Python kann man den Source-Code einfach ändern.

Notwendige Vorbereitungen:

* auf einem aktuellen Raspbian ist das Oracle Java runtime environment schon vorinstalliert
* [Installation](http://wiringpi.com/download-and-install/) der nativen Bibliothek [WiringPi](http://wiringpi.com/) auf dem RPi
* [Pi4J Installation](https://pi4j.com/1.2/install.html)
* Java-Programme sehen dann beispielsweise so aus:
  * [Control GPIO](https://github.com/Pi4J/pi4j/blob/master/pi4j-example/src/main/java/ControlGpioExample.java)
  * [Listen GPIO](https://github.com/Pi4J/pi4j/blob/master/pi4j-example/src/main/java/ListenGpioExample.java)
  * [Shutdown GPIO](https://github.com/Pi4J/pi4j/blob/master/pi4j-example/src/main/java/ShutdownGpioExample.java)
  * [Trigger GPIO](https://github.com/Pi4J/pi4j/blob/master/pi4j-example/src/main/java/TriggerGpioExample.java)

> Ich meinem Raspberry Pi 3 B+ hat die Nutzung von WiringPi nicht funktioniert. Nachdem `sudo apt-get install wiringpi` zu "undefined Symbol: wiringPiVersion" führte, versuchte ich mich an der Installation per Git-Repository. Das erste Problem bei der Installation von `git-core` (fehlendes Python Modul `ConfigParser`) konnte ich noch lösen, indem ich auf meinem System Python 2 als Default eingestellt habe (via `update-alternatives`). Das nachfolgende Problem "Unable to determine hardware version. I see: Hardware BCM2835 - expecting BCM2708 or BCM2709" war zu hartnäckig. Weder die beschriebene Installation über Git (mit `build`) hat funktioniert, noch die [Installation der Latest Version](http://wiringpi.com/wiringpi-updated-to-2-52-for-the-raspberry-pi-4b/) via `sudo dpkg -i wiringpi-latest.deb` hat funktioniert.
>> Ich habe dann aufgegeben ...

### Arcade Button

Arcade-Buttons sind schöne Taster wie man sie früher an Arcade Spielautomaten fand.

### Erste kleine Schaltungen mit programmatischer Steuerung

> ACHTUNG: man sollte vermeiden, die Schaltung aufzubauen während der RPi läuft, denn bei falscher Beschaltung können die elektronischen Teile zerstört werden. Hier ist ein Breadboard mit Extension Board sehr praktisch: man trennt das Flachbandkabel vom Breadboard (wodurch der RPi nicht mehr mit der Schaltung verbunden ist), baut die Schaltung auf, kontrolliert sie nochmals und verbindet RPi und Breadboard wieder mit Flachbandkabel. Somit muß man den RPi nicht runterfahren, um eine neue Schaltung aufzubauen.

* [YouTube - eine LED zum Leuchten bringen](https://www.youtube.com/watch?v=ntKI2Nj-hSU)

---

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

### Konfiguration

Die Konfiguration erfolgt über `sudo raspi-config`. Hier lassen sich Einstellungen für

* Boot
* Netzwerk
* Lokalisierung (Sprache und Tastatur)
* Dienste
  * ssh
  * VNC
* Hardarware
  * Kamera

vornehmen.

---

## Betrieb ohne Monitor

Nach der Erstinstallation (für die man zur Auswahl des per Noob zu installierenden Betriebssystems eine grafische Ausgabe benötigt) braucht man keinen Bildschirm mehr. Eine Textkonsole bekommt man per `ssh` und eine grafische Oberfläche per VNC (geht auch ssh mit X11-Forwarding?) ... allerdings geht die Kommunikation dann übers Netzwerk (Performance?).

### ssh

Dies ist die typischste Verwendungsform und sollte auf jeden Fall konfiguriert werden. Per X11-Forwarding und einem lokalen X11-Server (z. B. [Xming](https://sourceforge.net/projects/xming/)) kann man dann auch auf Remote Desktop Connections via VNC verzichten.

### Remote Desktop Connection

In der Microsoft-Windows-Welt sind Remote-Desktop-Connections üblich - Windows verwendet hierzu das Remote-Desktop-Protocol (RDP) und bringt auch das passende Tool (`mstsc.exe`) mit.

Auf dem Raspberry Pi ein RDP-Server per `sudo apt-get install xrdp` installiert werden. Danach kann man sich von einem Windows-Rechner per Remote-Desktop-Connection verbinden und erhält die grafische Oberfläche des Raspberry PI.

### VNC

* [Stefan Strobel](http://strobelstefan.org/?p=2731)

VNC-Server per `sudo aptitude install tightvncserver` auf dem Raspberry installieren und per `tightvncserver` starten. Danach eine VNC Session auf dem Raspberry mit `vncserver :1 -geometry 1024x728 -depth 24` erstellen.

Mit einem VNC kompatiblen Client (z. B. [RealVnc](https://www.realvnc.com)) auf einem Laptop kann man sich dann - eine Netzwerkverbindung vorausgesetzt - mit dem Raspberry verbinden.

---

## WLAN

### USB Stick-Kompatibilität

* [kompatible WLAN-Adapter](http://www.forum-raspberrypi.de/Thread-liste-kompatibler-wifi-adapter)

Man sollte darauf achten einen Raspberry PI Zero kompatiblen WLAN Sstick zu verwenden. Außerdem darauf achten, daß der WLAN-Stick nicht zuviel Strom benötigt (die er über einen aktiven USB-Hub bekommen könnte) ... je nach Anwendungsfall kann das aber auch kein Problem darstellen.

* NETGEAR WNA1000M-100PES N150 kostet nur 6 Euro
* LogiLink WL0084E Wireless-LAN Nano-Adapter kostet nur 6 Euro
* TP-Link TL-WN823N v1 für 10 Euro sollte passen (ABER ACHTUNG: angeblich nur die v1 - nicht die v2).

### Inbetriebnahme

* https://thepihut.com/blogs/raspberry-pi-tutorials/16018016-how-to-setup-wifi-on-the-raspberry-pi-raspbian
* http://strobelstefan.org/?p=4282

---

## Programmierung

### Node RED

Hiermit lassen sich sehr komfortabel Aktionsketten programmieren/konfigurieren.

Installation per

```bash
sudo apt-get install nodered
```

---

## Zubehör

Zubehör gibt es häufig auch als Starter Kits ... das macht auf jeden Fall Sinn, um schon mal eine Basisausstattung zu haben.

---

## Bastelideen

* [Pico Spielekonsole mit Lucky Luke Spiel](https://github.com/mobi3006/pico)
* [Projekt Sportstracker - unser eigenes Projekt](projekt_sportstracker.md)
* https://raspberry.tips/hausautomatisierung/raspberry-pi-software-zur-hausautomatisierung/
* http://raspberrypiguide.de/howtos/powerpi-raspberry-pi-haussteuerung/

---
