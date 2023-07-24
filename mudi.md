# Mudi - GL-e750

* [Produktinfos](https://www.gl-inet.com/products/gl-e750/)

Ich habe bereits den [GL-AR750S-Ext aka Slate](slate.md) seit 4 Jahren und war von der Professionalität der Software und der Updates sehr begeistert. Nun läuft der Support für dieses Gerät aus und ich liebäugel mit dem Mudi, der mobil einsetzbar ist (mit integriertem Akku).

---

## Features

* Akku mit 7000mAh
  * 12 Stunden schafft er wenn er kaum benutzt wird
* Display, das wichtige Infos zu Mudi-WLAN (inkl. Passwort), Akku, Modus, ... anzeigt (nur ein bisschen klein)

### Was mir fehlt?

* eSIM support

### Was verbessert werden könnte?

* Displayschrift extrem klein
* rutschiges Plastikgehäuse
  * Plastik ist in Ordnung ... schliesslich soll das WLAN top sein - rutschig sollte es aber nicht sein
* beim Laden über USB-C wird das Gerät relativ warm ... 63° sagt die Admin-UI

---

## Erst-Inbetriebnahme

* aufladen
* 3-5 Sekunden zum Booten auf den Push-Button drücken
* wenn man eine SIM-Karte drin hat, dann zeigt das Display "PIN Code eingeben" an ... das kann man ignorieren - der Mudi hat ja keine Tasten
  * wenn man die PIN bereits im Web-Admin-UI konfiguriert hat verschwindet die Anzeige später (wenn die Initialisierung durch ist)
* mit dem speziellen WLAN des Mudi und dem WLAN-Schlüssel `goodlife` verbinden
* im Webbrowser http://192.168.8.1 verbinden
* **SICHERES** Admin-Passwort vergeben
* Grundeinrichtung über die Web-Admin-UI
  * WLAN-Namen ändern (2,4 / 5 GHz + Gäste-WLAN) und **SICHEREN** WLAN-Schlüssel setzen
  * Internet-Verbindung konfigurieren
    * Repeater Modus ... am besten damit starten
    * Tethering
    * SIM
    * Kabel
  * Firmware upgrade
  * Timezone setzen

---

## Modi

* sind SIM-Karte und Repeater aktiviert, dann wird der Repeater verwenden
  * macht ja Sinn ... kann man das ändern?

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
     * ping 40 ms
     * normales Surfen in Ordnung ... YouTube bis 480p gut - darüber Aussetzer

Ich schätze O2 hat hier einfach nicht das beste Netz.

### Repeater Modus

* ohne VPN
  * 44 MBit/s (DSL 100 MBit)
    * im Down- und Upload
    * im WLAN, das ich im Mudi verwende habe ich 90 MBit/s
      * der Mudi hat keine Top-Performance aber sehr brauchbar
  * Ping 12 ms
