# Mudi - GL-e750

* [Produktinfos](https://www.gl-inet.com/products/gl-e750/)
* [Handbuch](https://docs.gl-inet.com/router/en/3/setup/gl-e750/first_time_setup/)
* [ausführliches Review - YouTube](https://youtu.be/BhKC7rMrj8E)

Ich habe bereits den [GL-AR750S-Ext aka Slate](slate.md) seit 4 Jahren und war von der Professionalität der Software und der Updates sehr begeistert. Nun läuft der Support für dieses Gerät aus und ich liebäugel mit dem Mudi, der mobil einsetzbar ist (mit integriertem Akku).

> mittlerweile gibt es auch schon V2 dieses Geräts (GL-E750V2), das größere SD-Karten unterstützt und schneller lädt (4 statt 6 Stunden)

Der Mudi ist ein Router, der ein eigenes WLAN zur Verfügung stellt, mit dem sich die Endgeräte verbinden. Der Standard-Anwendungsfall ist, dass der Mudi über ein anderes WLAN, die SIM-Karte, das Handy (Tethering) oder ein Netzwerkkabel eine Verbindung in ein anderes Netzwerk aufbaut und die Kommunikation dorthin routet. Zusätzlich kann sich der Mudi um eine Verschlüsselung kümmern und die SD-Karte als Netzwerklaufwerk zur Verfügung stellen.

---

## Anwendungsfall

Ich möchte mobil arbeiten, also tatsächlich Videokonferenzen von unterwegs und Java/Docker-Builds machen ... nahezu so wie von zuhause. Ausserdem möchte ich meiner Familie (m)eine grosse Datenkarte zur Nutzung zur Verfügung stellen, ohne dass JEDER einen großen Vertrag haben muss.

O2 bietet sehr günstige Datentarife zur Verfügung (allerdings habe ich noch nicht verstanden wie die [Fair-Use-Policy](https://www.o2online.de/service/auslandsoptionen/eu-verordnung/?partnerId=O2_DTI_NEW_TEF_11003&medium=sms&campaignName=eu-roaming_BK_201705) funktioniert):

* https://www.o2online.de/tarife/

Der "Unlimited Smart" kostet gerade mal 43 Euro (allerdings auf 15 Mbit gedrosselt) - - für den gleichen Preis bekommt man 70 GB mit voller Geschwindigkeit (500 MBit).

### VPN

Im Ausland möchte ich eine Deutsche IP-Adresse verwenden, um alle meine Angebote (Netflix, Amazon Prime, Sky, ...) ohne regionale Einschränkungen nutzen kann. [OVPN](https://www.ovpn.com/en/pricing) bietet Open VPN UND Wireguard Server an. Wireguard ist deutlich schneller und benötigt weniger Ressourcen - auf dem Mudi wird dieses Protokoll unterstützt und die Performance soll deutlich besser sein als mit OpenVPN (50 MBit/s vs. 10 MBit/s). 

---

## Features

* Akku mit 7000mAh
  * 12 Stunden schafft er wenn er kaum benutzt wird
  * kann während der Nutzung aufgeladen werden (z. B. über eine Powerbank)
* Display, das wichtige Infos zu Mudi-WLAN (inkl. Passwort), Akku, Modus, ... anzeigt (nur ein bisschen klein)

### Was mir fehlt?

* eSIM support

### Was verbessert werden könnte?

* Displayschrift extrem klein
* rutschiges Plastikgehäuse
  * Plastik ist in Ordnung ... schliesslich soll das WLAN top sein - rutschig sollte es aber nicht sein
* beim Laden über USB-C wird das Gerät relativ warm ... 63° sagt die Admin-UI
  * die normale Betriebstemperatur liegt bei 40-50°

---

## Erst-Inbetriebnahme

> **ACHTUNG:** Die Admin-WebUI http://192.168.8.1 zum Mudi funktioniert nur, wenn man das WLAN des Mudi verwendet. Wenn man also im Heimnetzwerk mit dem Haim-WLAN ist, muss man das WLAN wechseln. Der Mudi verwendet den WLAN-Namen GL-E750-xxx

* aufladen
* 3-5 Sekunden zum Booten auf den Push-Button drücken
* wenn man eine SIM-Karte drin hat, dann zeigt das Display "PIN Code eingeben" an ... das kann man ignorieren - der Mudi hat ja keine Tasten
  * wenn man die PIN bereits im Web-Admin-UI konfiguriert hat verschwindet die Anzeige später (wenn die Initialisierung durch ist)
* mit dem speziellen WLAN des Mudi und dem WLAN-Schlüssel `goodlife` verbinden
* im Webbrowser http://192.168.8.1 verbinden
* **SICHERES** Admin-Passwort vergeben
* Grundeinrichtung über die Web-Admin-UI
  * Mudi-WLAN-Namen ändern (2,4 / 5 GHz + Gäste-WLAN) und **SICHEREN** WLAN-Schlüssel setzen
    * es wird empfohlen bei "TX Power" statt "Maximum" nur "Hoch" zu verwenden ... das spart Batterie
    * als "Kanal" verwende ich "auto"
  * Internet-Verbindung konfigurieren
    * Repeater Modus ... am besten damit starten
    * Tethering
    * SIM
    * Kabel
  * Firmware upgrade
  * Timezone setzen
* SIM-Karte einsetzen ... [nicht ganz einfach siehe YouTube-Video](https://www.youtube.com/watch?v=l9dxJUL7lhA)
* Reboot
* SIM-PIN eingeben über die Web-Admin-UI

### Stand-By

Durch Drücken der Taste für 3 Sekunden kommt der Mudi in einen Standby-Mode (zeigt er auch auf dem Display an). In diesem Modus ist er via WLAN nicht erreichbar - er muss erst wieder aufgeweckt werden (3 Sekunden drücken).

Ausschalten durch 5 Sekunden drücken ... statt 3 Sekunden.

### Probleme

* Firmware-Aktualisierung von 3.211 auf 3.217 war über die Click-Download-Methode nicht möglich ... man kann den Download Button drücken, es passiert aber nichts
  * über [Firmware-Download](https://dl.gl-inet.com/?model=e750) habe ich mir die Latest Stable Version runtergeladen (tar) und dann über "Lokale Aktualisierung" installiert. Anschließend hat es eine Weile gedauert 1-2 MInuten bis die mobile Datenverbindung wieder nutzbar war.

---

## Modi

* sind SIM-Karte und Repeater aktiviert, dann wird der Repeater verwenden
  * macht ja Sinn ... kann man das ändern?

---

## Booting

* der Bootvorgang dauert ca. 2 Minuten

---

## Performance

### O2 Data SIM

* ohne VPN
   * im Wohnzimmer (generell schlechte Mobilfunk-Verbindung - baulich bedingt)
     * 2 MBit/s
     * ping 60 ms
     * selbst normales Surfen nicht angenehm
   * im Arbeitszimmer
     * 7 - 15 MBit/s
       * akzeptabel aber bei weitem keine versprochenene LTE-Geschwindigkeit
     * ping 40 ms
     * normales Surfen in Ordnung ... YouTube bis 720p gut - bei 1080p Aussetzer

Ich schätze O2 hat hier einfach nicht das beste Netz.

### Repeater Modus

* ohne VPN
  * 44 MBit/s (DSL 100 MBit)
    * im Down- und Upload
    * im WLAN, das ich im Mudi verwende habe ich 90 MBit/s
      * der Mudi hat keine Top-Performance aber sehr brauchbar
  * Ping 12 ms

---

## Batterie-Laufzeit

### YouTube Video

* via WLAN 2,4 GHz
* Video mit 720p
* Temperatur kanpp 50° C
* innerhalb von 60 Minuten Batterie von 34% auf 23% gesunken

### Standby

* 60 Minuten Standby: 22% => 16%
* nachts im Standby (10 Stunden) ... 90% => 75%

### Aufladen

* Powerbank: 2:20 Stunden für 45% (während er gelaufen ist - nicht im Standby) => ca. 20% pro Stunde
* USB-Ladegerät: kein Unterschied zur Powerbank
* mitgelieferten Ladegerät: ???
* es spielt keine Rolle, ob Mudi im Standby-Mode oder im Running-Mode ist
