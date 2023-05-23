# Virtual Private Network (VPN)

Im beruflichen Umfeld benutze ich seit Jahren VPN im Homeoffice, doch privat habe ich es noch nicht benötigt. Im Urlaub finde ich es allerdings manchmal recht schwierig, gute mobile Datenverbindungen am Urlaubsort zu bekommen. Meine Endgeräte lasse ich nicht einfach ins Hotel-WLAN, denn nicht alle Applikationen verwenden zuverlässig Verschlüsselung auf Applikationsebene bzw. einige meiner Endgeräte sind betriebssystemseitig  (z. B. Android) seit Jahren outdated, so daß mein Vertrauen in die Verschlüsselungstechnologien nicht besonders groß sind.

Klar ist allerdings auch, daß ich mit meinem mobilen Datenansatz über den Mobilfunkprovider auch angreifbar bin (bei den geschilderten Problemen), doch halte ich es für aufwendiger als in einem Hotel einen Sniffer im WLAN-Router zu installieren.

## Motivation

* zentrale Verschlüsselung auf Betriebssystemebene statt Verschlüsselung auf Applikationsebene
* lokale IP-Adresse
  * einige Serviceanbieter (z. B. Netflix) bieten ihren Dienst nur im eigenen Land an. Über die IP-Adresse erfolgt eine Lokalisierung, so daß als Ausländer den Dienst eigentlich nicht nutzen kann. Verwendet man allerdings ein VPN, dessen Server im entsprechenden Land steht, dann sieht der Dienst eine lokale IP-Adresse und sendet die Daten, die dann aber wiederum über den VPN-Kanal nach Deutschland weitergeleitet werden.
* Anonymität im Internet

## VPN-Anbieter

### Avira Phantom VPN

* kostenlos bis 500 MB/Monat
  * da es mir nicht ums Streamen von Multimediadaten geht, sondern nur fürs sichere Surfen, ist das ein sehr interessantes Angebot
* Standort in 25 Ländern wählbar

### Eigenes VPN

Macht man den eigenen Internet-Anschluss zuhause öffentlich (DynDNS), so kann man auch seinen eigenen VPN-Server betreiben.

Die Fritzbox unterstützt VPN aber kein schnelles Wireguard. Das kann man mit dem [Brume](https://www.gl-inet.com/products/gl-mt2500/) nachrüsten. Den stöpselt man einfach an seine Fritzbox und kann nach einer schnellen Konfiguration über den iPhone - Slate - Hotel-WLAN - Fritzbox - Brume eine eigene VPN Verbindung aufbauen.