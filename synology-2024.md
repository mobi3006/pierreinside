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

## Benutzer vs. Shared Folder

**ACHTUNG:** man muss zwischen User-Accounts und Shared-Folders unterschieden. User Accounts erhalten - sofern die Anlage eines Home-Verzeichnisses erwünscht ist - einen eigenen Speicherbereich unter `/volume1/homes/USERNAME`. Mit diesem User können sie ihr Home-Verzeichnis per `\\IP_ADRESSE_SYNOLOGY\homes\USERNAME` mounten. 


> ACHTUNG: ich lege die Daten **NICHT unter meinem Homeverzeichnis ab**, sondern in einem Shared Folder und gebe meinem Benutzer darauf Berechtigungen. **DENN:** Unter Windows kann man aber zu EINER IP-Adresse nur mit EINEM User eine Verbindung aufbauen, d. h. man kann nicht zwei User-Homeverzeichnisse einbinden. Das limitiert die Verwendung von Home-Verzeichnissen.

Aus diesem Grund habe ich mich entschieden alle Daten nicht in Home-Verzeichnisse abzulegen, sondern in Shared-Foldern, auf die dann bestimmte User Berechtigung erhalten. Auf Filesystem-Ebene sind die Berechtungen `rwxrwxrwx+` vergeben, d. h. grundsätzlich hat JEDER User Zugriff. ABER: beim Zugriff über SMB (Netzwerk-Share) schaltet sich die Synology dazwischen und wertet die Share-Berechtigungen aus, um den Zugriff zu gewähren oder zu verweigern. Der Owner der Datei ist tatsächlich der User, der sie angelegt hat - es wird IMMER die Gruppe `users` gesetzt, in der standardmäßig alle User enthalten sind (sofern nicht explizit geändert).

Bei der Anlage eines Shared-Folder sollte man den Recycle-Support einschalten

> Das hat zudem den Vorteil, dass ich mir beispielsweise die Berechtigung erteilen kann die Dateien meinen Kinder zu bearbeiten ... das kommt immer mal wieder vor, wenn ich ihnen helfe. Würden die Dateien in deren Home-Verzeichnis liegen, dann wäre das recht umständlich.

Will man Daten zwischen Usern teilen, dann verwendet man Shared-Folder. Die liegen unter `/volume1/SHARED_FOLDER`. Zusätzlich muss man jedem Benutzer, der Zugriff haben soll, eine Berechtigung auf den Shared-Folder. Jeder Nutzer kann dann mit "seinen" Credntials den Shared-Folder per `\\IP_ADRESSE_SYNOLOGY\SHARED_FOLDER` mounten. Das ist natürlich viel flexibler, weil ein Benutzer n Shared-Folders einbinden kann (aber nur ein Home-Folder).

Damit es nicht zu Verwirrung kommt, erhält der Username ein Kürzel (z. B. `/volume1/homes/pfh`) aber der dazugehörige Shared-Folder einen Langnamen (z. B. `/volume1/pierre`).

Beim mounten muss man dann natürlich die 

> so war das bei meiner alten DS112 auch

### Drucker-Scans

Ich verwende einen Shared-Folder `public`, auf den JEDER Nutzer meiner Famile Schreibzugriff hat. Wir tauschen hier Dateien aus.

Ich habe einen Netzwerkdrucker, der Scans auf die Synology ablegt. Hierzu habe ich einen User `dnf2665` für den Drucker angelegt (der nicht einmal ein Home-Verzeichnis braucht). 

Dieser User erhält auch Schreibberechtigung auf den `public`-Shared-Folder.

### PhotoSync

Auch hier wird ein Nutzer angelegt, mit dem die PhotoSync-App sich authentifiziert, um Zugriff auf den Shared-Folder `/volume1/photoysync` zu bekommen. Hier werden alle Photos hochgeladen, um sie dann nachzubearbeiten, zu kategorisieren und nach `/volume1/photos` von einem automatisierten Job zu verschieben.

## Benutzer

Wann lege ich einen Benutzer an:

* für jeden menschlichen Nutzer
  * diese Nutzer bekommen ein Home-Verzeichnis
* für jedes Gerät, das irgendwie Zugriff auf Dateien auf dem Synology braucht
  * diese Nutzer bekommen i. a. **KEIN** Home-Verzeichnis ... denn ich lege sie nur an, um die Berechtigung auf Shared-Folders einzurichten
  * tatsächlich bekommt JEDES Gerät einen eigenen User, denn damit kann ich die Berechtigungen gerätespezifisch steuern

In der Einstellung "Benutzer und Gruppe - Erweitert" muss man explizit die automatische Anlage eines Home-Verzeichnisses für neue Benutzer anschalten. Standardmäßig ist das ausgeschaltet.

Im Windows-Explorer kann das Home-Verzeichnis des Nutzers per `\\IP_ADRESSE\homes\USERNAME` eingebunden werden (ACHTUNG: aufpassen bei `homes` - in DSM 6 war das nicht so).

## Shared Folder

Shared-Folders liegen unter `/volume1/SHARED_FOLDER` (im Gegensatz zu Home-Verzeichnissen von Benutzern, die unter `/volume1/homes/USERNAME` liegen).

Einen Shared-Folder kann man mit n Benutzern teilen - jedem Benutzer kann man andere Berechtigungen geben.

Typische Shared-Folders:

* `public`
* `photos`
* `music`
* `videos`
* `backup`

## Backups

Backup-Daten (liegen auf einer externen USB-Festplatte) müssen nicht migriert werden - im Notfall habe ich noch die alte Synology.

Allerdings müssen die Backup-Jobs für die neue Synology eingerichtet werden.

## Drucker

Ein Dell DNF2665 wird verwendet, um eingescannte Dokumente auf dem Synology für alle Nutzer bereitzustellen. Meine neue Synology hat eine neue IP-Adresse bekommen und während der Migration habe ich einen Hybrid-Betrieb, d. h. einige Dateien liegen noch auf der alten Syology (eingebunden in ein paar Rechner) und migrierte liegen auf der Neuen. Ich kann also nicht einfach die alte IP-Adrese verwenden, um auf die neue Synology zuzugreifen.

Leider ist der Touch-Screen meines Druckers nicht mehr voll funktionsfähig und deshalb konnte ich darüber nicht die neue Synology als Ziel konfigurieren. Letztlich habe ich es einfach über das Web-Interface des Druckers gemacht.

## ssh-Server

Ich habe den ssh-Server aktiviert ... allerdings können nur User der Gruppe `administrators` sich mit ihrem Account peer ssh anmelden. Das macht ja irgendwo auch Sinn.

## Git-Server

Hierzu muss man das Package Git-Server installieren. DEr Zugriff erfolgt über ssh, d. h. jeder Git-Nutzer muss somit in die `administrators` Gruppe aufgenommen werden. Anschliessend kann man per

```
git clone ssh://mygituser@192.168.1.2:/volume1/mysharefolder/myrepo1
```

ein Repository clonen.

Hat man noch kein Repository auf der Synology, so

* legt man am besten ein Shared-Folder an
* gibt jedem berechtigten User auf diesen Shared Folder Write-Access
* per ssh mit dem Admin-User anmelden und dann:
  * `mkdir -p /volume1/my-shared-git-folder/my-repo`
  * `cd /volume1/my-shared-git-folder/my-repo`
  * `git init --bare`
