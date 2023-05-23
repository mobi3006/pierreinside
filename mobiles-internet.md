# Mobiles Internet

Natürlich hat jeder mittlerweile mobiles Internet über die SIM-Karte, doch meistens hat man nur geringe Datenmengen, da das in Deutschland noch vergleichsweise teuer ist. Mit einem guten 50 GB Tarif ist man schnell mal bei 30-50 Euro im Monat.

Wenn man nun aber eigentlich nur wenig Daten im Monat benötigt (und das sind ohne Streaming und Remote-Working tatsächlich nicht so viele), dann macht es ja keinen Sinn einen festen Vertrag über 24 Monate abzuschließen, wenn man nur im Urlaub oder kurzen Geschäftsreisen man mehr Daten benötigt.

Welche Möglichkeiten bieten sich hier?

---

## TLDR

Ich verwende für meinen 24 Monatsvertrag eine pyhische SIM-Karte und habe dadurch zwei eSIMs meines iPhone 13 zur freien Verfügung, um kurzfristig eine eSIM eines guten lokalen Anbieters zu buchen. Ich kann dann die Datennutzung so konfigurieren, dass Daten über die günstige eSIM transferiert werden und ich aber dennoch telefonisch (+ SMS + Whatsapp) über mein iPhone mit der üblichen Nummer erreichbar bin.

Für WLAN-Hotspots verwende ich eine VPN Verschlüsselung - entweder auf meinem Handy oder in meinem [Slate](slate.md). WLAN-Hostpots sind leider nicht nur sicherheitstechnisch kritisch sondern auch wenig zuverlässig, was die Leistung und Verfügbarkeit betrifft.

Aus diesem Grund verlasse ich mich nicht auf WLANs, sondern sorge IMMER für eine SIM-basierte Hauptlösung (WLAN nur on-top ... für den Fall, dass es wirklich gut funktioniert).

Als Globetrotter würde ich zum Glocalme greifen, weil es einfach viel weniger administrativen Aufwand bedeutet. Wenn ich aber nur 2 Wochen nach Spanien fahre, dann kaufe ich mir lokal eine einzige SIM oder verwende zuhause gebuchte Datenkontingente, die ich im Ausland nutzen kann (Achtung Fair-Use-Policy!!!).

---

## WLAN Hotspot

Ich bin letzthin im ICE nach Paris gefahren. Über den WLAN-Hotspot des ICEs hatte ich über die gesamten 3 Stunden sehr gutes Internet (auch bei 330 km/h), um Filme zu streamen. So konnte ich meine mobile Datenverbindung schonen.

Leider sind die WLAN Hotspots in Hotels und Campingplätzen nicht zu gebrauchen. Sie werden nur angeboten, weil man das heutzutage hat. Häufig ist die bandbreite allerdings so niedrig, dass selbst einfache Internetseiten ewig zum Laden brauchen. An Streaming oder Remote arbeiten ist da gar nicht zu denken.

Fazit: WLAN-Hotspots sind die kostengünstigste Variante (aus Sicherheitsgründen oder wegen IP-Whitelisting mit VPN Verbindung). Leider sind sie nicht immer zuverlässig, so dass man eine Alternative parat haben sollte.

### Hotspot Flatrate

Einige Anbieter (Freenet, Telekom, Vodafone, ...) bieten sog. Hotspot Flatrates, die man auch ohne einen teuren und langfristigen Vertrag hinzubuchen kann (auch für externe Kunden - man muss also seinen Mobilfunkvertrag nicht dort haben). Sehr günstig (unter 5 Euro - in vielen Tarifen dieser Anbieter auch schon enthalten) kann man sich dann in viele Partner-Hotspots einwählen, mit denen der Provider zusammenarbeitet. Häufig sind das kleine Geschäfte, Hotels, Campingplätze, Tankstellen.

Freenet bietet angeblich auch den Zugang zu allen Telekom-Hotspots ...

Ich würde hier nicht allzuviel erwarten - Geschwindigkeit und Zuverlässigkeit sind wahrscheinlich mäßig.

### Sicherheit

* [so geht's richtig mit dem Slate](https://www.youtube.com/watch?v=AH9smQhUdPc)
  * [Slate](slate.md)
* [VPN Einrichtung](https://www.youtube.com/watch?v=RmOkknhkWuI)

Ein öffentliches WLAN ist natürlich immer als Angriffsvektor zu sehen. Öffne ich ich eine Seite im Browser über "https" (z. B. https://heise.de), so ist die standardmässig verschlüsselt. Allerdings hängt es auch hier vom Endgerät ab wie gut die Verschlüsselung ist. Gute Server verhindern eine Verbindung, wenn der Client keine ausreichende Verschlüsselung unterstützt. Insofern ist das schon sicher und der Betreiber des öffentlichen Hotspots sollte keine Chance haben, die transferierten Daten (auch Passwörter) auszulesen.

Gute Seiten (z. B. http://heise.de) leiten auch IMMER auf die sichere Seite (https://heise.de) um. Teilweise tut das der Browser sogar schon automatisch, so dass es nicht mehr der Server tun muss.

Aus dem Browser heraus ist das also alles schon mal ganz sicher, so dass normales Surfen kein Problem sein sollte.

Allerdings laufen auf einem Laptop oder Handy, das sich mit dem öffentlichen WLAN verbunden hat, noch andere Anwendungen. Professionelle Anwendungen werden die sichere Verschlüsselung wie im Browser genauso verwenden. 

Hat man allerdings unsichere Apps installiert, denen man sogar Passwörter anvertraut hat, dann sieht das schon ganz anders aus.

Ganz dramatisch wird es wenn man auf dem Endgerät keine Sicherheitsupdates gemacht oder noch schlimmer gar keine mehr bereitgestellt werden bzw. wurden.

> Das ist übrigens der Grund warum ich von Android auf iPhone gewechselt habe. Die Update-Frequenz bei meinen Android Geräten war so gering, dass ich einfach kein Vertrauen mehr hatte. Das ist bei der Flagschiffen der großen Anbieter sicher in den Anfangsjahren sicher wie bei Apple auf hohem Niveau. Später lässt das aber auch nach und bei den Billig-Handys bekommt man schon gar keine zeitnahen Updates. Verwendet man dann noch immer die gleichen Passwörter und keinen Second-Factor ... gute Nacht.

Aus diesem Grund vermeide ich WLANs, wenn es geht und ich meine Verbindung nicht über VPN abgesichert habe - lieber verwende ich meine mobilen Daten.

Ein VPN verschlüsselt jeglichen Datenverkehr zuverlässig auf den unteren Netzwerklayern und ist deshalb zu empfehlen. Wenn ich im Browser dann eine Seite per "http" (statt https) aufrufe, dann wir der Datenverkehr zwar nicht auf diesem Applikationslayer verschlüsselt, wohl aber auf einem der unteren Layern. Insofern können auch unsichere Apps/Anwendungen genutzt werden, ohne Gefahr zu laufen, dass sensitive Daten in falsche Hände gelangen.

Mit einem zwischen iPhone und WLAN-Hotspot zwischengeschalteten [Slate](slate.md) lassen sich sichere VPN Verbindungen mit den typischen VPN-Anbietern aufbauen. Die Nutzung von WLAN-Hotspots ist dann sicher.

---

## Data-Pass

Manche Mobilfunkanbieter bieten sog. Data-Pass an, um bei einem tempopären Mehrbedarf nochmal einen Block (5, 10, 20 GB) hinzuzubuchen. Dies Option ist vermutlich am einfachsten ... wenn auch vielleicht nicht am günstigsten, da die Data-Passes zumiest nicht super-billig sind.

> Man sollte die Option "Daten-Automatik" i. a. deaktivieren, da man hier dann für minimale Datenmengen einen sehr hohen Preis zahlen muss.

---

## Temporäre SIM-Karte oder eSIM

* [guter Artikel](https://yourtravel.tv/esim-im-ausland-alternative-zu-glocalme)

Die unbürokratischste Variante sind Prepaid-Karten, bei denen man keine Registrierung benötigt und keine längere Laufzeit hat. Häufig kauft man hier nur ein Datenvolumen, das man in einem bestimmten Zeitraum verbrauchen muss.

Diese SIM-Karte steckt man dann in sein Dual-SIM-Handy, ein Zweithandy oder einen [mobilen Router](mobiler-router.md). Hat man ein eSIM-fähiges Handy, dann braucht man kein Dual-SIM-Handy und ist deutlich flexibler, da man in keinen Laden gehen muss, um an die Karte zu kommen.

> Fair-Use-Policy (FUP): scheinbar kann man sein deutsches Datenvolumen (z. B. 20 GB) im Ausland nicht vollständig im Ausland bei höchster Geschwindigkeit nutzen. Die FUP schiebt dem bei 50% (oder mehr) einen Riegel vor und man surft auf niedriger Geschwindigkeit. Angeblich besteht das Problem bei dem [O2 - 999 GB - 4 Wochen](https://www.o2-freikarte.de/prepaid-tarife/flextarife/myprepaid-max/) nicht ... ob das bei lokalen SIM-Karten auch so ist, weiss ich nicht.

Physische SIM-Karten müssen natürlich in einem Laden gekauft werden (oder werden vorab verschickt), eSIMS hingegen sind in sekundenschnelle online gekauft und einsatzbereit. Hier muss man nichts plane, sondern kann kruzfristig auf Engpässe (wenn man merkt dass das WLAN auf dem Campingplatz doch nichts taugt) reagieren.

Einige Anbieter ([gute Übersicht](https://prepaid-data-sim-card.fandom.com/wiki/Prepaid_SIM_with_data)):

* [airalo](https://www.airalo.com/de)
* [FlexiRoam](https://travel.flexiroam.com)
* [MobiMatter](https://mobimatter.com/)

Wichtig ist natürlich, dass man dann auch ein Netz bekommt, das auch tatsächlich eine gute Abdeckung und Bandbreite verfügt. Und das kann durchaus kompliziert werden, denn in Deutschland ist die Telekom beispielsweise in ländlicher Gebieten mit Abstand die beste Wahl, in Grossstädten bieten dann allerdings Anbieter wie O2 vielleicht bessere Dienste. Diese Seite hilft bei der Auswahl des richtigen Anb

### Lokale SIM-Karten

Reist man ins nicht-europäische Ausland, so fallen i. a. Roaminggebühren an, die sehr hoch sind und die Datennutzung zum Luxus werden lassen.

In solchen Fällen ist es sinnvoller eine lokale Prepaid-SIM-Karte zu verwenden. Allerdings braucht man hier in vielen Ländern eine Identifikationsprüfung.

Europa:

* O2 - Internet-to-Go
   * [O2 - 999 GB - 4 Wochen](https://www.o2-freikarte.de/prepaid-tarife/flextarife/myprepaid-max/)
   * [O2 - 30 GB - 365 Tage](https://www.o2-freikarte.de/prepaid-tarife/flextarife/myprepaid-max/)

Frankreich:

* [Anbieter free - 100GB für 20 Euro](https://comewithus2.com/free-die-prepaid-sim-karte-in-frankreich/)

### Globale SIM-Karten

Bei diesen SIM-Karten (zumeist eSIM) kann man das Datenkontingent weltweit verbrauchen. Das ist natürlich sehr komfortabel, wenn man die Länder häufig wechselt.

ALLERDINGS: ein Anbieter für alle Länder ... das kann dazu führen, dass man nicht immer ein geeignetes Netz bekommt.

---

## Cloud SIM

Dieser Ansatz wird im Abschnitt ["Mobiler Router"](mobiler-router.md) behandelt.

---

## Film-Streaming

Beim Streaming fallen erhebliche Datenmengen an

* SD-Auflösung: 0,5 GB pro Stunde
* HD-Auflösung: 1 GB pro Stunde

Mal ein paar Filme zu schauen ist vielleicht noch im eigenen Vertrag möglich, doch i. a. hat man einen Vertrag, der für die normale Nutzung zugeschnitten ist ... sonst würde man das Geld ja zum Fenster rauswerfen und die Mobilfunkunternehmen reiben sich die Hände.

Es kann passieren, dass der Streaming-Anbieter nicht exakt so funktioniert wie zuhause, weil er an der IP-Adresse erkennt, dass man nun z. B. aus Frankreich kommt (sog. Geo-Blocking). Dann könnten die manche Filme nicht oder in anderen Sprachen verfügbar sein. Stolpert man über dieses Problem, kann eine VPN-Verbindung helfen. Hier lässt sich dann ein deutsche IP-Adresse auswählen und Netflix denkt man sein in Deutschland.

> VPN-Anbieter kosten nochmal zusätzlich Geld ... häufig bieten sie ihre Abos am Black-Friday mit einem Nachlass von 90% an, so dass man dann auf einen Monatspreis von 2-4 Euro kommt.