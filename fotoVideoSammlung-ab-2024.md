# Foto-Video-Sammlung ab 2024

Über die letzten 20 Jahre haben sich 100.000 Fotos und Videos angesammelt. Wunderschöne Erinnerungen, die uns extrem wichtig sind und wir deshalb ständig im Zugriff haben möchten. Die Sammlung erweitert sich ständig.

---

# Motivation zur Änderung des aktuellen NAS Ansatzes

Derzeit verwenden wir eine in die Jahre gekommene Synology DS112+. Der Ansatz ist [hier detailiert](fotoVideoSammlung-bis-2023.md) beaschrieben. Die Festplatten (eine in der Synology und eine fürs Backup) sind nun voll und müssen alterbedingt ausgetauscht werden. Die Synology wird hauptsächlich für Fotos und Videos von unseren Handys und Fotoapparaten genutzt - dient aber auch als Fileserver für alle anderen Daten (Word, PDF, Powerpoint), d. h. unsere Laptops speichern keine wichtigen Daten auf den Endgeräten selbst, sondern auf der Synology. Die Synology fertigt Backups an.

Ein Wechsel der Synology ist mit einem Wechsel

* von DSM 6.x auf 7.x (inkl. Filesystem ext4 auf Btrfs)
* von DS Photo auf Synology Photos

verbunden. Ein harter Einschnitt, da der bisherige Ansatz zur Foto/Video-Sammlung auch nur nach vielen Recherchen (insbes. der Codec-Support war immer wieder ein Problem) und Optimierungen so funktioniert hat. Ich erwarte also auch hier deutlichen Aufwand, wenn wir wechseln müssen.

Deshalb stelle ich den Ansatz nun erneut auf den Prüfstand.

## Was mich derzeit stört?

### DS Photo App

Die DS Photo App für den FireTV ist relativ langsam und die Video-Wiedergabe scheiterte in der Vergangenheit auch immer mal wieder am Codec-Support. Auf der DS Photo Handy App müssen Plugins Videos wiedergeben. Es funktioniert, ist aber kein großartiges Nutzererlebnis. Mit Amazon Photos ist das ein Quantensprung - es geht also deutlich besser.

Das neue Synology Photos (DS Photo wurde durch Synology Moments abgelöst und das wiederum durch Synology Photos) wird auf dem FireTV gar nicht unterstützt. Ich würde mich nicht darauf verlassen, dass Synology alle meine Endgeräte unterstützt und dazu auch noch meine Use-Cases.

### Updates im Bereich Foto/Video

Mein Eindruck ist, dass Synology auch relativ behäbig ist, was die Bereitstellung von Apps ist. Die Features sind dann nicht vollkommen ausgereift.

### Performance

Die Indizierung neuer Dateien dauert sehr lang ... natürlich ist die Synology Hardware nicht geeignet, um einer schnellere Indizierung vorzunehmen. Grundsätzlich stört das auch nicht, da es ja dann tagelang im Hintergund laufen kann. Es zeigt aber, dass die Lösung nicht optimal ist.

### Hot vs Schrott

Ich habe noch keine komfortable Möglichkeit, die Best-of-Inhalte (= Hot) zu selektieren, d. h. 95% ist Schrott und könnte gelöscht werden - die verbleibenden 5% sind aber wichtige Erinnerungen.

### FireTV Integration

Ist zwar möglich aber relativ langsam ... mein Eindruck ist auch, dass Synology nicht die Men-Power hat (oder auch Prioritäten) wie Großunternehmen wie Amazon, Google oder Apple. Für einen kleinen Anbieter decken sie aber ein so großes Spektrum an Funktionalität ab, dass die einzelnen Lösungen nicht Best-of sind.

---

# Anforderung - Cloud oder NAS?

> ENTSCHEIDUNG: Cloud

Wir sind nun schone viele Jahre in der Cloud (hauptsächlich mit Onedrive und 1und1 Cloud-Speicher). Die wichtigsten (persönlichen) Fotos/Videos haben wir allerdings auf dem NAS. Früher bestand gar keine Möglichkeit, die Datenmengen in die Cloud zu bringen. Mittlerweile haben wir aber 40 MBit/s Upload und in nächsten bekommen wir Glasfaser und damit die Möglichkeit, die Bandbreite weiter zu erhöhen.

Die Cloud ist einfach super komfortabel, wenn es

* um die Nutzung von verschiedenen Endgeräten (Laptops, Handy, Tablet, FireTV Stick) geht
* um einen mobilen Support ... mittlerweile arbeite ich nur noch im Home-Office und vielleicht werde ich auch mal eine Zeitland tatsächlich durch Europa fahren und nicht zuhause. 

## Auschließlich Cloud?

> ENTSCHEIDUNG: nein

Die Cloudanbieter sind professionell und machen ihren Job sicher besser als ich zuhause. Allerdings passieren auch dort Fehler und ich will auf jeden Fall einen Datenverlust verhinden ... die Erinnerungen sind mir einfach zu wichtig.

Aus diesem Grund möchte ich dennoch eine konsistente Kopie der Daten lokal verfügbar haben.

Das bedeutet nicht unbedingt, dass ein NAS gesetzt ist. Bei einem Onedrive Cloudspeicher werden die Daten evtl. auch verschiedenen Endgeräte synchronisiert, die als Sicherheit vielleicht ausreichen könnten.

Eine Synchronisierung ist ausserdem kein Backup. Lösche ich alle meine Daten aus Versehen, dann wird dieses Löschen auf alle Endgeräte angewendet => Daten weg.

Ich muss ehrlich aber auch zugeben, dass ich den Cloud-Anbietern hinsichtlich Feature-Support nicht traue. Ändern die ihr Konzept oder ihren Schwerpunkt, so kann das bei mir dazu führen, dass meine Anwendungsfälle nicht mehr passen. Das passiert leider immer wieder (habe ich gerade bei der [Abkündigung von Amazon Drive](https://www.reddit.com/r/photography/comments/znss6i/amazon_drive_shutting_down_where_to_migrate/?rdt=40187) mitbekommen) und sind dann halt Einzelschicksale, für die sich die Cloudanbieter nicht interessieren.

## Entscheidung - Cloud und NAS und Backup

Ich brauche weiterhin ein NAS als Fileserver mit Backup-Funktionalität. Ich brauche allerdings keinen Support mehr für Multimedia oder Foto/Video-Bibliotheken, da ich hier Amazon Photos und Microsoft Onedrive verwende.

Aus diesem Grund reicht mir auch eine schmalbrüstige kostengünstige 1-Bay Synology wie die DS124.

---

# Anforderung - Schrott vs Schätze

Von den 100.000 Fotos sind wahrscheinlich nur 5-10% zu gebrauchen und wichtig für uns. Wir schauen häufig die alten Fotos/Videos an (über FireTV), haben aber immer noch keine Selektion vorgenommen und das reduziert den Spass am Schauen.

Es wäre optimal, wenn man beim Betrachten der Bilder gleichzeitig diese Selektion vornehmen könnte.

---

# Anforderung - Ordnerstruktur vs. Flat

> ENTSCHEIDUNG: Flat

Beim Testen der Amazon Photos Lösung ist mir aufgefallen, dass Ende 2023 der Support von Amazon Cloud Drive eingestellt wird. Damit wird wahrscheinlich auch der Support von Ordnerstrukturen wegfallen, so dass nur noch Fotos existieren.

Bisher habe ich immer Unterordner angelegt:

* Jahr
* Quartal
* Event

Das würde dann nicht mehr unterstützt werden.

Letztlich bedeutet diese Ordner-Hierarchie aber immer Aufwand für mich, der nicht unerheblich ist. Mein Eindruck ist, dass ich es mir aber keine signifikanten Vorteile bietet. Hätte ich eine auf einem Zeitstrahl angeordnete Darstellung mit Filtern

* nach Jahr
* nach Favorites
* nach Tags

dann wäre das viel besser und würde sogar weniger Aufwand für mich bedeuten.

## JPEG vs HEIC

> ENTSCHEIDUNG: JPEG

Apple verwendet standardmäßig HEIC (kann man aber einstellen), doch auch nach 3 Jahren hat sich dieses Format mit der besseren Komprimierung bei gleicher Qualität noch nicht durchgesetzt. Auf meinem Windows 11 Laptop musste ich für 0,99 Euro eine Zusätzliches Plugin installieren.

Mit JPEG ist man auf der sicheren Seite.

> Lacher nebenbei: Über den Webbrowser konnte ich bei iCloud keine HEIC Dateien hochladen ... nur JPG wurden unterstützt.

## H.264 vs H.265/HECV

> ENTSCHEIDUNG: H.265/HECV

Apple verwendet standardmäßig H.265/HECV. Hier werden höhere Auflösungen unterstützt und somit wird sich das über kurz oder lang gegen den älteren Standard G.264 durchsetzen.

## Tagging

> ENTSCHEIDUNG: manuelle Tags werden nicht unbedingt benötigt

Früher hatte ich mal die Idee, ICMP-Tags in den Metadaten der Dateien zu pflegen. Ein Unterfangen, das viel zu aufwendig ist und für die es auch keine Tools für Massendaten gab. Für Videos gibt es ein solches Konzept nicht einmal.

Im Zuge der Artificial-Intelligence-Bewegung liefern das die Cloud-Anbieter bereits out-of-the-box und das wird in den nächsten Jahren eher besser als schlechter.

---

# Anforderung - Kosten

Cloud-Speicher kostet Geld ... ein NAS aber auch. Ich bin bereit ein bisschen Geld zu investieren, aber es sollte natürlich ein gutes Kosten/Nutzen-Verhältnis haben.

In meinem Fall brauche ich ein NAS und die Cloud, allerdings ein eher günstiges NAS, das mehr als Fileserver, denn als Multimedia-Server dient.

---

# Anforderung - API

Manchmal habe ich evtl. sehr spezielle Vorstellungen von MEINER Lösung, die von dem gewählten Cloud-Anbieter nicht oder irgendwann nicht mehr unterstützt werden.

Ich möchte also schon sehr gerne eine API, mit der ich Tools bei Bedarf selbst hinzufügen kann.

---

# Anforderung - Source-of-Truth

Ich präferiere einen gestandenen Cloud-Anbieter, der vermutlich auch in 10 Jahren noch existiert - kein Nischen-Anbieter.

Ich möchte ausserdem meine Dateien als Quelle behalten (= Source-of-Truth)... on-top möchte ich die Bilder aber schnell und komfortabel auf verschiedenen Endgeräten (Handy/Tablet, Fernseher, Laptop) betrachten können. Dieses Endrendering halte ich für relativ kurzlebig, d. h. was heute super funktioniert könnte in 2 Jahren gar nicht mehr gehen oder durch eine neue Lösung ersetzt werden. Letztlich bleiben nur die Dateien. Es ist daher wichtig, die Dateien auf ein Best-of-Minumum einzudampfen. Dann kann man schnell den Renderer wechseln.

> Bei Amazon Photos verliert man die Hoheit über die Dateien. Sie liegen irgendwo im Hintergrund. Niemand weiss, ob die Ordnerstruktur, die Dateinamen, die Tags, die Alben, die Originalqualität, ... erhalten bleiben. Aus diesem Grund kann eine solche Lösung nur ein Renderer sein, der das komfortable Browsing ermöglicht.

---

# Anforderung - Vendor Lock-In

Natürlich will dich jeder Cloud-Anbieter langfristig binden und damit ein Lock-In erzeugen. Für mich ist allerdings wichtig, dass ich IMMER an meine Raw-Daten komme und notfalls auf eine andere Lösung umziehen.

Mit dem Cloud-NAS-Ansatz ist das aber gegeben. Da ich kein weiteres manuelles Tagging mache und auch keine Ordnerstruktur mehr brauche, würde ich da auch nichts verlieren. Klar würde Aufwand entstehen, aber das wäre relativ unproblematisch.

---

# Anforderung - unterschiedliche Quellen

Meine Fotos/Videos kommen aus

* Handys
* Tablets
* Fotokamera
* Videokamera

Alle Endgeräten haben unterschiedliche Daten-Benennungen ... manche brauchbare, manche unterirdische. Ich muss garantieren, dass jedes Bild einen eindeutigen und sortierbaren Namen hat. Und das konsistent. Lange Zeit schieden automatische Uploads von den Endgeräten in meine Produktions-Landschaft deshalb aus.

Bis ich die PhotoSync App für iOS/Android entdeckt habe.

> Nahezu jeder Cloud-Anbieter unterstützt den automatischen Upload der Kamera-Bilder in seine Cloud. Da allerdings 95% der Fotos/Videos Schrott sind, braucht man unverhältnismäßig viel Speicher, der entsprechend teuer ist. Neben den Kosten hat man dann aber immer noch nicht das Problem "Hot-vs-Schrott" gelöst. Zudem ist man darauf angewiesen, dass der Upload die Meta-Daten erhält, keine seltsamen Meta-Daten hinzufügt, die Qualität erhält und man die Daten auch in voller Qualität wieder runterbekommt. Mein Eindruck ist, dass die Cloud-Anbieter hier die Chance sehen den Kunden langfristig zu binden ... und das will ICH nicht. Ich habe schon zu häufig erlebt, dass die großen Player von einen auf den anderen Tag eine andere Strategie haben und der Support aufhört, die Lösungen schlechter werden und dann muss man schnell handeln.

## PhotoSync App

Dieses Tool ist mein wahrgewordener Traum. Man kann nahezu jedes Targetsystem vom Handy snychronisieren und dabei

* Dateinamen anpassen (ich bevorzuge das Format `YYMMDD_HHMMSS_MMM` - das ist selbst von verschiedenen Endgeräten Unique)
* Metadaten ergänzen
  * das ermöglicht auch in Videos den Support des Aufnahmedatums
  * separate XMP Header werden unterstützt
* Fotos
  * es werden auch Ratings übertragen, d. h. ein Herz Rating für ein Bild auf dem iPhone landet im Datei-Meta-Tag "Bewertung" mit einem 5-Sterne Rating
    * auf diese Weise kann ich Fotos schon auf dem Endgerät (iPhone) bewerten und nicht erst nach der Durchsicht in Microsoft Foto
      * vor allem ist es dann auch schon Bestandteil meiner `photos-raw` Daten
* Videos ... könnte verbessert werden - ich habe ein Support-Ticket bei PhotoSync hierzu offen
  * LEIDER werden hier keine Ratings im File-Header übernommen ABER Ratings von der iOS Photo App (das Herz) sind per `exiftool` als `Rating : 5` zu sehen
  * LEIDER wird hier ein "MediaCreateDate" auf den Tag der Synchronisierung gesetzt ... und das wird von Amazon Photos zur Sortierung verwenden. Mit dem Ergebnis, dass die Videos zeitlich falsch einsortiert werden.
    * hierfür könnte ich eine Automatisierung über [`exiftool`](https://exiftool.org/) implementieren, die automatisch täglich auf meinem Synology läuft ... aber natürlich würde ich lieber darauf verzichten:

      ```
      _createDate=`exiftool -s3 -CreateDate ${_file}`
      exiftool -quiet "-MediaCreateDate=${_createDate}" "-MediaModifyDate=${_createDate}" -overwrite_original
      ```

* Formatkonvertierungen vornehmen (HEIC => JPEG, HECV/H.265 => H.264)
  * iPhone verwendet standardmäßig HEIC/HECV ... ein Format, das sich noch nicht auf allen Platformen durchgesetzt hat - auch wenn es KEIN Apple proprietäres Format ist
  * da man HEIC/HECV in die älteren Formate JPEG/H.264 transformieren kann, ist das kein Ausschlusskriterium für die neuen Formate - bei Videos wird H.265 vermutlich H.264 (= HECV) ablösen, da es höhere Auflösungen unterstützt
* in der Premium-Version können neue Dateien automatisch auf mein Synology hochgeladen werden (ich brauche ja einen Ersatz für DS Photos)
* für unterschiedliche Ziele kann man unterschiedliche Einstellungen verwenden
  * so kann man beispielsweise schnell mal ein Album in geringer Auflösung der Familie oder Freunden zur Verfügung stellen¶

Ich habe PhotoSync folgendermaßen eingestellt:

* Hinzufügen von Metadaten
* Konvertierung von HEIC nach JPEG ... maximale Qualität
* Konvertierung von HEIV nach H.264 ... maximale Qualität
* in Temporärdatei übertragen: NEIN
  * das hat den Zeitstempel der Datei verändert
* überschreiben erlauben: NEIN
  * bei mir ist der Sync mehrfach abgebrochen und als Neu gekennzeichnete Dateien war aber schon übertragen. Mit dieser Einstellung konnte ich die nächsten Sync deutlich beschleunigen
  * angeblich sorgen OS Upgrades manchmal dafür, dass die "Neu" Kennzeichnung falsch ist - in dem Fall überträgt man am besten alle Dateien neu. Auch hier werden dann schon übertragene Dateien übersprungen.

PhotoSync existiert seit 2011 ... wer sich 13 Jahre auf dem Markt hält, hat entsprechende Qualität und langfristiges Interesse hinreichend nachgewiesen. Ich habe keine Lust, mir in 2 Jahren wieder eine neue Software suchen zu müssen.

> Ich schrieb dem Support von PhotoSync Samstag um 17:00 Uhr ... um 17:30 hatte ich schon eine Antwort

## Synology Nachbearbeitung mit exiftool

Für das ExifTool gibt es für DSM 7.x kein Package. Deshalb habe ich das Tool ssh-Session installiert:

```
ssh yourSynologyAdminUser@yourSynologyIpAddress -p yourPortNumber

cd /tmp
wget https://exiftool.org/Image-ExifTool-12.73.tar.gz
tar xvfz Image-ExifTool-12.73.tar.gz
mv Image-ExifTool-12.73 ExifTool
cd ExifTool
chmod 755 exiftool
sudo chown -R root:root *
cd ..
sudo mv ExifTool /usr/share/applications/
sudo vi /etc/profile
```

Zusätzlich habe ich auf der Synology Perl per DSM als Package installiert, da es für das ExifTool gebraucht wird.

Danach die Synlogy neu starten.

Nach dem Neustart habe ich über den DSM Task Scheduler eine neue Task angelegt, die einmal täglich die neuen Dateien (aus dem Ordner `new`) analysiert und in die Ordner `bestof` und `not-bestof` verteilt. Hierzu wird das per `exiftool` ausgelesene `Rating` (gesetzt auf meinem iPhone) verwendet.

Am Ende erhalte ich ein Protokoll per eMail zugestellt. So kann ich sicher sein, dass die Nachbearbeitung tatsächlich noch funktioniert.

Über diesen Ansatz könnte ich jederzeit auch noch andere Änderungen oder Prüfungen machen.

> **ACHTUNG:** in diesenSkripten sollte man immer absolute Pfade verwenden (auch zum `exiftool`), da die `PATH`-Konfiguration scheinbar nicht zieht.

---

# Anforderung - Sicherheit

Meine Fotos/Videos sollen natürlich niemandem zugänglich sein. Sie müssen aber nicht unbedingt verschlüsselt gespeichert werden. Wenn ich mich entscheiden müsste zwischen komfortablem Betrachten oder höchste Sicherheit, dann würde ich mich für das komfortable Betrachten entscheiden.

---

# Finale Lösung

## Lösung für Fotos ab Q3/2020

* Sammlung der Fotos/Videos auf dem NAS
  * per PhotoSync werden die Fotos/Videos - nach erfolgtem Rating auf dem iPhone (Herz-Symbol) - in regelmäßigen Abständen übertragen
    * ich verwende nicht die Auto-Übertragung, da die Fotos/Videos erst gerated werden müssen
  * PhotoSync sorgt dafür, dass
    * eine Konvertierung der Formate erfolgt (HEIC => JPG, H.265 => H.264)
    * Dateinamen angepasst werden (`IMG_5621.HEIC` => `20231231_130504_123`)
      * das Datum ist bei den Fotos/Videos ganz entscheidend, denn hieraus ergibt sich die Reihenfolge bei der Betrachtung. Aus diesem Grund darf ich dies Information UNTER GAR KEINEN UMSTÄNDEN verlieren. Mit dem Dateinamen bin ich auf der sicheren Seite - selbst wenn doch mal ALLE Meta-Daten verloren gingen
  * früher habe ich die Fotos immer nich nach Exif-Header gedreht ... ich denke heutzutage wird das JEDER Bildbetrachter automatisch tun ... das sollte nicht mehr meine Aufgabe sein
* regelmäßiger Job auf der Synology (einmal täglich), der nach Meta-Tag `Rating` eine Aufspaltung der in Ordner `new` befindlichen Dateien nach `bestof` und `not-bestof` vornimmt. Danach ist der `new` Ordner im Idealfall leer. Sollten sich darin aber Dateien befinden, die nicht bestimmten Regeln genügen (z. B. Namensschema, im Scripting unberücksichtigte Dateiendungen), dann verbleiben die im `new` Ordner. Über die versendete Report-eMail sollte ich Probleme erkennen und nachbessern. Notfalls werden die Dateien in `new` gelöscht
* die `bestof` werden nach OneDrive per Synology "Cloud-Sync" automatisch synchronisiert (One-Way-Upload)
* alle Photos/Videos werden komplett durch ein automatisches Backup ALLER Fotos/Videos (nicht nur bestof) auf eine externe USB-Festplatte, die am Synology hängt, gesichert

## Lösung für Fotos bis Q2/2020

> Diese liegen nicht auf unseren iPhones, sondern vollständig auf dem NAS

* auf einem Rechner werden die Fotos von der Synology heruntergeladen und lokal via Microsoft Fotos (Legacy) als Favorit (= Best-Of) gekennzeichnet
  * diese Kennzeichnung ist dann in den Meta-Daten der Datei und somit persistent - unabhängig vom späteren Bildbetrachter
* Export des neuen Bilder aus Microsoft Fotos (Legacy) nach OnseDrive (in die Microsoft-Cloud) in einen Familien-Account
* Download der Best-of auf das NAS - langfristiger lokaler Speicher
  * damit haben wir auch die Best-of-Kennzeichnung im NAS

## Bewertung der Lösung

Auf diese Weise werden die Daten an fünf Stellen verteilt gespeichert

* Speicher 1: Endgerät
* **Speicher 2: NAS**
* Speicher 3: NAS-Backup
* **Speicher 4: Microsoft Onedrive**
  * als langfristige Cloud-Speicherlösung, auf die ALLE Familienmitglieder von überall Zugriff haben
* Speicher 5: TV-optimiert
  * Cloud-Anbieter
    * man kann die Fotos/Videos auch auf OneDrive ansehen ... fürs Betrachten am TV ist das aber nicht optimiert (OneDrive bietet hier nicht mal eine eigene App - nur Drittanbieter) 
    * Amazon Photos für die Integration in die Multimedia-Lösung der Familie (Amazon Fire-TV-Stick) ... Fotos/Videos am Fernseher anschauen

... da sollte eigentlich nicht mehr viel schiefgehen.

## Bewertung der Lösung im Vergleich zur Synology-basierten Lösung davor

* Synology hat immer Ewigkeiten gebraucht, um die Fotos aufzubereiten
  * Features wie Face-Recognition waren zunächst gar nicht verfügbar oder dann erst nach einem Umstieg auf Synology Photos
    * zudem braucht es hier Rechenpower
* die Synology als Quelle für den Zugriff aus Fire-TV oder Handy Apps war
  * immer recht langsam
  * bei den Videos gab es Codec Probleme
  * fragil, da man sich nicht darauf verlassen konnte, dass Synology diese Apps weiterentwickelt
* ich habe immer nach einer Möglichkeit gesucht, meine Fotos/Videos auch in die Cloud zu "sichern"
  * eine Festplatte raucht doch mal ab (insbes. bei einem 1-Bay NAS eine große Gefahr)
  * bei einem Wohnungsbrand ist das NAS sicher auch nicht mehr zu gebrauchen ... und das Backup auf eine externe USB-Platte, die normalerweise ausserhalb der eigenen Wohnung lagert, erfolgt doch nur 1-2 mal im Jahr

---

# TV-Optimierung - Cloud-Anbieter

Der Teil hat sich in den letzten Jahren als der schwierigste dargestellt. Vor 10 Jahren hatte ich ja noch Verständnis. Aber im Zeitalter von Social-Media und Handy Kamera mit Riesenspeicher immer verfügbar, kann ich leider nicht verstehen, dass es keine ordentlichen durchdachten Lösungen gibt.

Nur mal eine kleine Liste der Probleme:

* Codecs nicht unterstützt
* Formate nicht unterstützt (HEIC)
  * nicht mal Apple (die selbst alls Fotos in HEIC speichern) erlaubt einen Upload via Webbrowser von diesem Format ... nur JPG wird unterstützt
* zu langsam
* zu schlechte Bildqualität
* Sortierung falsch und nicht konfigurierbar
* zu teuer
* Meta-Daten gehen verloren
* Timestamps werden geändert
* Vendor-Lockin
  * auf einem Android TV (Google) wird kein Amazon Photos unterstützt und andersrum
    * auf einem Android TV wird nicht mal Google Fotos unterstützt
  * ... beliebig lange Liste von Problemen
* kein Support für Dia-Shows

Amazon Photos war endlich mal ein Anbieterm, der nahezu alle Anforderungen gut oder sogar bestens umgesetzt haben. Und dann wurden die Videos nach Upload-Datum sortiert ... und das obwohl Aufnahmedatum eingestellt war und ALLE Meta-Tags das Aufnahmedaatum referenzierten. Die Analyse endete in Verzweiflung und Aufgabe.

Das zeigt aber schön wie schwierig das Thema noch immer zu sein scheint. Die Foren verzweifelter Endkunden sind voll davon.

## Amazon Photos

Die Amazon Photos App wird auf einem Laptop/Handy installiert (MacOS und iOS von Apple werden auch unterstützt). Hiermit kann man theoretisch die Bilder direkt von allen Endgeräten sichern. So verwende ich es aber nicht, da wir das NAS verwenden, um nicht den ganzen Schrott in die Cloud zu laden. Es wird ERST aussortiert und dann nur das Best-of hochgeladen ... die Dinge, die man sich dann auch gerne immer mal wieder ansieht.

> Auf einem Laptop verwendet man eine sog. "Datensicherung", um die Daten nach Amazon Photos hochzuladen. Die Sicherung kann so eingestellt werden, dass sie automatisch und sofort erfolgt. Auf diese Weise kann der Prozess (in meinem Fall nach dem Export aus Microsoft Fotos nach OneDrive) vollständig automatisiert werden. Aufgrund dieses intendierten Use-Cases landen die Fotos/Videos in einem Ordner "backup/ENDGERÄT" ... d. h. für jedes Endgerät wird ein eigener Ordner angelegt. Verwendet man die App auf einem Mobiltelefon, dann landen die Fotos/Videos in den Ordnern Pictures/Videos (aber so nutze ich es nicht).

Die Dateien sind auch über

* https://amazon.de/photos

erreichbar. Dort kann man auch Alben anlegen.

### Kosten

Als Amazon Prime Kunde ist die unbegrenzte Speicherung von Fotos kostenlos ... nur Videos kosten den üblichen Cloudspeicher-Betrag (der scheinbar bei allen Anbietern nahezu identisch ist). Wenn es sich nur um die Best-Of-Videos handelt, dann reichen uns aber 100 GB, die nur 2 Euro im Monat kosten.

### Fotos anschauen

Die FireTV und Handy Apps zum Betrachten der Fotos/Videos sind sehr gut und haben auch Filter-Möglichkeiten (nach Orten und Personen). Die App ist sehr schnell und übersichtlich. Es werden unzähliche Foto/Video-Formate unterstützt, die ständig erweitert werden.

Über den FirteTV Stick kann man seine Best-of auch als Bildschirmschoner einstellen. Auf diese Weise könnte man einen Fernseher als Digitalen Bilderrahmen implementieren ... eine schöne Idee.

Die Amazon Echo Shows zeigen die Bilder in regelmäßigen Abständen an ... eine schöne Idee immer mal wieder in Erinnerungen zu schwelgen.

### Vendor-Lock-In

Mit hinterliegendem Amazon Drive war es problemlos möglich ALLE Dateien ohne Verlust der originären Dateinamen *MIT* Ordnerstruktur zu exportieren. Allerdings pro Endgerät ... was mir nicht so gefällt an dem Ansatz.

Ich habe keine Ahnung was passiert, wenn Amazon-Drive ab 2024 nicht mehr existiert ... es gibt für Amazon Photos scheinbar auch keine API. Könnte sein, dass Amazon hier den Vendor-LockIn erhöhen will.

Für mich hat das allerdings keine Relevanz, da ich Amazon Photos nur zum Anzeigen verwende ... die Core-Daten Daten liegen auf Microsoft OneDrive und meinem NAS.

> Eigentlich nicht konsistent, dass gerade AWS keine API anbietet. Im Business Bereich mit Amazon-Web-Services für alles eine API gibt. Das stärkt meinen Verdacht, dass Amazon hier die Kunden binden will.

### Fazit

Es besteht das Risiko eines Vendor-Lock-Ins. Allerdings ist das Amazon-Ecosystem auch grandios mit Hardware und Software. Das findet man bei fast keinem anderen Anbieter. Höchstens vielleicht noch Apple und dort ist der vendor-Lock-In noch größer.

Für mich ist der vendor-Lockin zu verschmerzen, da ich Amazon Photos nur für die Anzeige der Bilder verwende ... es ist ein temporäreren Speicher, den ich bei Bedarf leicht nach Apple iCloud, Google Fotos oder was auch immer ersetzen kann. Wichtig ist einzig und allein die persistente Speicherung der Best-of auf Onedrive und auf der NAS.

## Apple iCloud

Bei Multimedia würde ich grundsätzlich Apple eine hohe Professionalität aussprechen. Allerdings ist Apple für einen extremen Vendor-LockIn bekannt - mit dem Vorteil eines hohen Komforts ... allerdings nur, wenn man sich an die von Apple-unterstützten Use-Cases hält. Will man davon abweichen, kann es schwierig werden.

Aus diesem Grund ist Apple hier nicht mehr Favorit.

## Microsoft OneDrive

Microsoft scheint keine gute Integration in die üblichen Set-Top-Boxen zu haben ... nur Drittanbieter liefern Apps

## NVidia Shield Pro

Diese Rechenmaschine von NVidia könnte am Fernseher im Wohnzimmer hängen und die Bilder von einer externen USB-Festplatte ziehen.

> Es soll wohl auch super fürs Upscaling von FullHD auf 4k sein ... eine Option, wenn wir uns mal einen großen 75 Zoll TV zulegen.

## Western Digital

... das Ding hab ich vor 10 Jahren am TV genutzt ... könnte ich vielleicht mal reaktivieren.

## Google Fotos

nicht mal auf einem Android TV gibt es eine App von Google für die "Google Fotos" ... lächerlich

---

# Windows Fotos App

> ACHTUNG: es gibt dort eine ältere Version (Foto Legacy) und eine neuere. Unter Windows 10 hatte ich die Legacy installiert und beim Wechsel auf Windows 11 haben ich viele Features vermisst. Erst nach einer Recherche habe ich herausgefunden, dass die neue Version deutlich limitiert ist (= nicht zu gebrauchen ist) ... die alte aber weiterhin existiert.

Früher hatte ich mal ein Windows Programm namens Picasa verwendet, mit ich sehr gut klar kam. Microsoft Fotos scheint das nun zu ersetzen. Ein sehr gutes Programm scheint mir.

Sehr schnell und komfortabel zu bedienen. Ich habe einen Laptop-Tablet mit Touchscreen mit Windows 11 ... damit kann ich komfortabel nebenbei auf der Couch, im Bett oder sogar unterwegs die Hot-vs-Schrott-Selektion durchführen.

## Hot-vs-Schrott Konzept

Über die App lassen sich Favoriten für Fotos sehr leicht setzen (mit dem Herz-Symbol). Damit landen die Bilder im virtuellen Album "Favoriten". Anschließend kann ich diese in ein echtes Album packen und mit einem einfach Click nach OneDrive synchronisieren.

Für Videos funktioniert es nicht mit dem Herz-Symbol. Stattdessen lege ich ein Album an und füge ein Video mit dem Plus-Symbol hinzu ... das hat allerdings den Nachteil, dass die Information nicht in den Meta-Daten persistiert wird. Lioegt vielleicht daran, dass man auch über den Windows-Explorer diese Meta-Information nicht setzen kann.

> Seltsam ist, dass es ein (virtuelles) Album "Favoriten" gibt, das allerdings keine Synchronisierung nach OneDrive anbietet. Deshalb der Umweg über ein (echtes) Album. Macht das Sinn, Microsoft?

Foto-App persistiert die Favoriten-Bewertung nicht nur in seiner App-internen Datenbank, sondern auch im Exif-Header der Datei (4 Sterne) auf dem Window-Dateisystem (sofern die Datei bereits über einen EXIF Header verfügt). Leider erzeugt das Programm keinen Exif-Header falls er fehlen sollte - in diesem Fall ist die Best-of-Markierung nur in der App-internen Datenbank.

> Das bedeutet allerdings auch, dass Microsoft Fotos Schreibrechte auf die Datei haben muss. Das muss ich in meiner Gesamtlösung berücksichtigen!!! Keine Ahnung, ob das auf OneDrive oder dem Linux-Filesystem meines Synology erhalten bleibt. Die Favoriten-Selektion ist damit PERSISTENT in den Daten der Datei - das Ergebnis ist somit ganz unabhängig von Microsoft Fotos nutzbar - **MEGA APPLAUS**. Das ist exakt mein Use-Case für Hot-vs-Schrott.

Ein Problem besteht bei Fotos ohne Exif-Header (einige ganz alte Fotos hatten keinen). Hier ist das Erfassungsdatum das Datum an dem ich das Foto auf die lokale Laptop-Festplatte kopiert habe und das wird dann in der Foto-App für die Sortierung nach Alter verwendet. Ich habe das Windows Tool "EXIF Date Changer" verwendet, um dieses Problem manuell zu korrigieren.

Mit einer externen Festplatte hat die Markierung von Favoriten nicht zuverlässig funktioniert. Manchmal hat es einfach nicht geklappt. Letztlich habe ich mich entschieden, die Fotos/Videos in Tranchen auf meinem Laptop zu bearbeiten, da meine Laptop-Festplatte nicht groß genug für 1 TB Daten war. Das ist ok ... ich hätte allerdings die externe Festplatte bevorzugt.

> Nach der Löschung eines Bildes oder ganzer Ordner oder der Änderung von Input-Sourcen waren diese weiterhin in der Vorschau (Thumbnails) sichtbar. Das hat zu großer Verwirrung geführt und das Programm unbrauchbar gemacht. Ich habe aus dem Programm keine Möglichkeit gefunden, die Quellen neu zu indizieren und die alten rauszuwerfen. Selbst eine Neuinstallation des Programms hat nicht geholfen. Über "Windows - Fotos Legacy - App Einstellungen - Zurücksetzen" konnte ich die Metadaten-Datenbank dann resetten. Beim nächsten Start muss man dann aber auch wieder OneDrive verknüpfen, die Einstellung "Meine OneDrive-Inhalte anzeigen - nur aus dem Ordner Bilder" einstellen, HEIC-Plugins hinzufügen und die relevanten Foto-Ordner hinzufügen. Sehr schwach, Microsoft.

## Hot-vs-Schrott Algorithmus

Ich kopiere immer Tranchen von 1-2 Jahren von meinem Synology NAS auf den Laptop, da dieser nicht so viel Speicherplatz hat.

In Foto (Legacy) folgende Einstellungen vornehmen:

* OneDrive verknüpfen (Familien-Account)
* Einstellung "Meine OneDrive-Inhalte anzeigen - nur aus dem Ordner Bilder" setzen
* relevante lokale Foto-Ordner über "Einstellungen - Quellen" hinzufügen
* optional: HEIC-Plugins hinzufügen
* Fotos/Videos selektieren
  * Fotos mit dem Herz als Favorit im virtuellen "Favoriten"-Album ablegen
  * Videos mit "Hinzufügen zu" zu dem Album "best-of-bis_20xy1231" hinzufügen
    * beim ersten Video muss das Album angelegt werden
    * ACHTUNG: noch nicht die Option "Auf OneDrive speichern" auswählen für das Album ... das machen wir ERST GANZ AM ENDE der Best-of-Selektion
      * Grund dafür ist, dass das eine EINMALIGE Aktion ist und dannauf OneDrive ein Ordner mit dem aktuellen Datum entsteht ... so würde jeden Tag ein neuer Ordner entstehen
* wenn die gesamte Tranche bearbeitet wurde, dann
  * werden alle Fotos aus dem virtuellen Album "Favoriten" zum Album "best-of-bis_20xy1231" hinzugefügt
  * zum Schluss wird auf dem Album "best-of-bis_20xy1231" die Option "Auf OneDrive speichern" ausgewählt ... damit landen die Bilder des Albums in einem Ordner auf dem lokalen OneDrive-Ordner "Pictures/Camera imports/YYYY-MM-DD"
    * diesen Ordner nach "Pictures/Camera imports/best-of-bis_20xy1231" umbenennen
  * Amazon Photos App auf dem Laptop öffnen:
    * Datensicherung starten
    * wenn Datensicherung fertig, dann anhalten
      * wir wollen verhindern, dass ein Export aus Microsoft-Fotos einen Ordner mit dem Namen "YYYY-MM-DD" nach Amazon-Photos hochlädt (bevor wir den nach "best-of-bis_20xy1231" umbenannt haben). Deshalb starten wir die Synchronisierung manuell
  * nach ein paar Minute prüfen, ob die Synchronisierung ... stattfindet
    * nach OneDrive

## Cloud-Support

Die direkte Anbindung von OneDrive (iCloud wird scheinbar auch - zumindest rudimentär - supported) ist natürlich klasse. So könnte ich OneDrive als File-Cloud-Provider weiter nutzen.

## Fazit

Microsoft hat im Ansatz ein tolles Programm. Wie man mit einer neuen Version (die unter Windows 11 auch noch der Default ist) die Funktionalität so einschränken kann ist mir ein Rätsel.

Ich war es zwischenzeitlich leid, das Programm reverse-engineeren zu müssen ... eigentlich sollte alles out-of-the-box funktionieren und intuitiv sein. Der nicht funktionierende externe Datenträger-Support ist mir vollkommen schleierhaft - gerade bei Fotos muss man doch damit rechnen, dass die nicht lokal vorliegen.

Ich habe nun - glaube ich (bis zur nächsten Überraschung) einen Weg gefunden, die Selektion Hot-vs-Schrott damit abzubilden.

Ich fürchte, dass ich diesen Teil der Lösung über kurz oder lang austauschen muss. Ich verstehe nicht warum Microsoft gute Lösungen wie Picasa oder Microsoft Fotos (Legacy) immer wieder einstampft, ohne passenden Ersatz zu haben. Ich habe doch wahrlich keine seltsamen Use-Cases.