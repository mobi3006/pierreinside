# Synology 2024

Meine [DS112+](synology-ds112.md) ist im Jahr 2019 aus dem Support-Fenster ausgelaufen und erhält keine neuen Features mehr. Es wird nur noch Sicherheitsupdates geben - [DSM 6.2 ist die letzte Version](https://www.ifun.de/synology-dsm-6-2-1-die-letzten-updates-fuer-zahlreiche-alt-modelle-126579/) für meine ewig alte Synology.

Ich brauche weiterhin kein Raid, da Hochverfügbarkeit kein Kriterium ist und Raids kein Backup ersetzen - ich investiere lieber in eine zweite Festplatte, die als Backup-Speicher dient.

Im Sommer/Herbst 2020 ist die DS220+ erschienen, das Preis-Leistungs-Verhältnis erscheint mir am besten. Die DS218 kam im Dezember 2017 raus, die DS118 im Oktober 2017.

---

# Haupt-Einsatzgebiet

Meine Haupteinsatzgebiete waren bisher

* Fileserver
* Backup
  * lokal auf USB-Festplatte
  * remote auf günstigen Cloud-Speicher
* Foto-Sammlung ... Nutzung über Amazon Fire-TV
* Foto-Backup von den Handys

Mit der Synology-Foto-Lösung war ich nicht ganz zufrieden, da

* die Indizierung immer ewig gedauert hat (die Performance ist halt eher mäßig)
* die App DS Photo schon ein wenig in die Jahre gekommen ist (Face-Recognition, ...)
* es doch immer ein wenig langsam war von Bild zu Bild zu schalten
* Videos wegen Codec-Problemen nicht immer so dolle waren

Mit dem Wechsel auf eine neue Synology müßte ich alle meine Bilder neu indizieren und auf die neue Lösung Synology Photos umsteigen müsste. Mein Eindruck ist, dass im Foto-Bereich die Cloud-Anbieter ein besseres Paket schnüren. Aus diesem Grund habe ich den Use-Case [neu designed](fotoVideoSammlung-ab-2024.md) und benötige die Synology nur noch als Raw-Speicher, BestOf-Speicher und Backup-Lösung (meiner auf der Cloud gespeicherten Best-Of-Bilder) ... also nur noch als Fileserver.

Aus diesem Grund brauche ich auch keine teure CPU-Maschine, sondern habe mich für die neueste 1-Bay Synology DS124 entschieden. Keine Plus Variante, da die Performance nur für einen Fileserver-Einsatz reichen muss. Mit 170 Euro und 2 neuen 6 TB Festplatten mit 500 Euro eine akzeptable Lösung.

## Cloud

Mein langfristiges Ziel ist der vollständige Weg in die Cloud. Ich will einfach irgendwann nicht mehr an mein Home-Netzwerk gebunden sein und mittlerweile habe ich mit Glasfaser auch genügend Bandbreite, um die Daten schnell hochzuladen.

Allerdings kostet Cloud-Speicher noch relativ viel und bei meinen Fotos/Videos von verschiedenen Handys/Kameras will ich erstmal aussortieren ... nur das Beste kommt in die Cloud. Damit reduziert sich der notwendige Speicher auf ein akzeptables Maß.

---

# Migration

Die Neuanschaffung ist mit einer Migration verbunden ... und das nervt in aller Regel, weil das keinen Zusatznutzen bringt und meistens auch nicht problemlos vonstatten geht. Einer der Gründe warum mein DS112 so alt geworden ist (in der Cloud hätte ich diese Probleme wahrscheinlich nicht).

... ich werde meine alte DS112 behalten (vielleicht als Speicher auf Reisen ... wenn der Traum vom Wohnmobil und dem mobilen Arbeiten realisiert worden ist). Die Festplatten scheinen noch in einem brauchbaren Zustand zu sein ... auch wenn ich das nach 10 Jahren kaum glauben kann.

Ich denke es macht keinen Sinn irgendwelche Einstellungen migrieren zu wollen. Ich richte die Synology mit DSM 7.2 einfach neu ein und schiebe meine Daten auf das neue Gerät.

---

# Inbetriebnahme

Über http://find.synology.com habe ich meine neue Synology schnell gefunden und konnte DSM in wenigen Minuten installieren.

## Synology Account

Ich lege einen Synology Account an, weil die Notifications (z. B. über fehlgeschlagene Backups, Festplattenfehler, ausstehende Updates) darüber versendet werden.

Andere Features wie C2 Backup oder Zugriff aus dem Internet nutze ich nicht.

## Synology Photos

... installiere ich erst gar nicht - das würde meine Synology mit 100.000 Fotos und Videos überfordern. Ich nutze sie für Fotos ausschließlich als Fileserver.

## Garantie Plus

Nach einer Registrierung meiner Synology habe ich eine um 2 Jahre erweiterte Garantie ... soll dafür aber 17 Euro zahlen. 10% meines Kaufpreises ... verzichte.

## Adaptive MFA

... hier werde ich per Mail über verdächtige Anmeldeversuche informiert - das will ich.

## Filesystem

Hier gibt es eigentlich nur 2 Optionen

* Btrfs
* ext4

Da Btrfs leistungshungriger (empfohlen werden 2 GB RAM - meine DS124 hat nur 1 GB) ist, habe ich mich für ext4 entschieden, das ja weiterentwickelt wird. Ich bin grundsätzlich eher ungeduldig bei Maschinen ... da will ich mich nicht schon gleich am Anfang ärgern müssen.

Die Features von Btrfs brauche i

## Benutzer

In der Einstellung "Benutzer und Gruppe - Erweitert" muss man explizit die automatische Anlage eines Home-Verzeichnisses für neue Benutzer anschalten. Standardmäßig ist das ausgeschaltet.

Im Windows-Explorer muss die Verbindung zu `\\IP_ADRESSE\homes\USERNAME` aufgebaut werden (ACHTUNG: aufpassen bei `homes` - in DSM 6 war das nicht so).

## Backups

Backups müssen nicht migriert werden - im Notfall habe ich noch die alte Synology.

