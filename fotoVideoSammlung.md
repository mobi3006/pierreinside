# Meine Foto- und Video-Sammlung

Ich verwende im wesentlichen meine [Synology](synology.md) als Fileserver und die DS Photo App, um die Erinnerungen komfortabel über Tablets, Smartphones und Fire TV anzuschauen.

Problematisch ist, daß die Synchronisierung aufgrund meiner heterogenen Gerätelandschaft (Microsoft Windows, MacOS, Android, iOS, GoPro, Spiegelreflexkamera) unterschiedlich funktioniert und ich eine Synchronisierung über die Cloud aus verschiedenen Gründen ablehne (siehe unten).

---

## Idee - temporäre lokale Sammlung

Ich habe mir angewöhnt einmal im Quartal/Halbjahr die Dateien aller Endgeräte auf einer externen USB 3.0 Festplatte zu sammeln. Dort werden die Dateien umbenannt im mein einheitliches Namensschema `YYMMDD_HHMMSS`, gedreht gemäß EXIF Ausrichtung und in Windows-kompatible Formate umgewandelt (z. B. `JPEG` statt `HEIC`-Format). Das passiert mit den Dateien aller Geräte zunächst separat - anschließend werden die Dateien nach Quartalen getrennt und nach Themen sortiert in einem gemeinsamen Ordner der externen Festplatte gesammelt. Ist das abgeschlossen, dann werden die Dateien über den Synology Uploader (spart Ressourcenn auf dem Synology - die Indizierung dauert dann nicht Tage, sondern nur Stunden) auf den Photostation-Bereich der Synology kopiert.

Danach sind die Erinnerungen über DS Photo App verfügbar.

### Warum nicht automatisiert

Die Vielzahl unterschiedlicher Endgeräte erschwert den Vorgang - das fängt schon damit an, daß iOS andere Formate/Codecs verwendet als Android und mein DS Photo auch nicht alle Formaten auf allen Endgeräten abspielen kann.

> Mir ist schon bewußt, daß dies eine recht fragile Angelegenheit ist und sich jederzeit etwas ändern kann - was dann wiederum mit zeitaufwendiger Recherche verbunden ist. Bisher funktioniert der Ansatz aber recht gut - das Endergebnis ist gut ... der Weg dorthin manchmal recht beschwerlich.

Da ich keine hochperformante Anbindung ans Internet, um 10 GB Videos in der Cloud zu sammeln, die ich später dann doch vielleicht wegwerfe ... zudem ist das nicht ganz günstig (Cloud-Speicher) und aus Sicherheitserwägungen fragwürdig. Eine Synchronisierung von iOS Geräten auf die Synology scheint kein typischer Use-Case zu sein ... Apple will seine iCloud platzieren. Ich habe nahezu kostenlosen Speicher auf meiner [Synology](synology.md) ... warum sollte ich den nicht nutzen.

Darüberhinaus muß ich die Fotos noch nachbearbeiten hinsichtlich Dateinamen-Schema und Ausrichtung.

Die manuelle Synchronisierung von Daten hat natürlich auch einige Nachteile:

* zeitintensiv
* fehleranfällig
* wird deshalb zu selten durchgeführt
  * ich kenne Leute, die haben wichtige Fotos (= Erinnerungen) seit Jahren nur auf ihrem Handy. Geht das mal verloren oder hat einen Hardwaredefekt, dann sind diese Erinnerungen für immer verloren. Das ist KEINE gute Idee. Zudem dauert es recht lang bis die Daten mehreren Monate (mehrere Gigabyte) vom Handy auf einen anderen Rechner transferiert sind ... ich hatte da bei meinem iPhone mit einigen Abbrüchen (trotz Kabelverbindung) zu tun und es nervte einfach nur. Gelegentlich mal ein Transfer (sogar über WLAN) ist da deutlich schneller durchgeführt.

Ich begegne diesen Problemen mit häufigerer Durchführung ... was das Problem des Aufwandes erhöht und dann wiederum Auswirkungen auf die Häufigkeit haben könnten :-(

### Probleme mit iOS Auto-Synchronisierung auf Synology

* [DS Photo zur Synchronisierung von Foto/Video auf Synology](https://www.ifun.de/einfachere-foto-backups-von-ios-geraeten-auf-synology-nas-laufwerke-78889/)
* [DS Photo - Synology Doku](https://www.synology.com/de-de/knowledgebase/Mobile/help/DSphoto)
* [DS File - Synology Doku](https://www.synology.com/de-de/knowledgebase/Mobile/help/DSfile)

Während ich bei Android eine sehr komfortable Synchronisation meiner Handy-Photos auf die [Synology](synology.md) laufen hatte ([FolderSync](https://play.google.com/store/apps/details?id=dk.tacit.android.foldersync.full&hl=de)) gestaltete sich das bei iOS Endgeräten recht schwierig.

Ich habe mit diesem Thema Stunden verbracht und war dementsprechend frustriert, daß ich es nicht hinbekommen habe

* alle Dateien zu kopieren und dabei Zeitstempel zu erhalten (insbes. bei Video-Dateien entscheidend, um sie zeitlich zu kategorisieren)
  * der Zeitstempel hat mich fast wahnsinnig gemacht ... mal funktionierte es ... mal nicht
* alle Dateien in Windows-kompatible Formate zu konvertieren
  * ich wollte verhindern, daß ich das später manuell tun muß (und evtl. vergesse)
* es zu automatisieren, so daß Multimedia-Dateien im besten Fall automatisch sanchronisiert werden

In dieser Beziehung ist iOS echt fürchterlich - nichts zu spüren von "funktioniert out-of-the-box". Apple ist halt doch nur in den unterstützten Use-Cases richtig gut ... meiner gehört scheinbar nicht dazu :-(

#### Cloud Synchronisierung

Scheinbar gibt es aber im iOS Umfeld gar nicht so viele Alternativen ... iCloud ist nun doch recht beliebt. Und scheinbar tut Apple alles dafür, um alle iOS User in ihre Cloud zu locken (glücklicherweise sind Cloud-Alternativen vorhanden), denn

> "Aufgrund der Einschränkungen von iOS können iOS-Apps keine Hintergrundaufgaben länger als 3 bis 10 Minuten ausführen, auch nicht mit aktivierten Geofences." [Synology DS Photo Dokumentation](https://www.synology.com/de-de/knowledgebase/Mobile/help/DSphoto/iOS_iPhone)

#### App Documents

Die App Documents hab ich bis heute nicht verstanden. Komlett unintuitiv ...

#### Synology App DS Photo

DS Photo bietet eine Photo Upload Option, wobei hier je nach Konfiguration im iOS Gerät eine automatische Typ-Konvertierung (HEIC => JPEG, MOV-Codecs) stattfindet.

> Diese Option ist sehr gut - allerdings sollte man die automatische Indizierung dieses Sync-Ordners abschalten (Photo Station - Settings - Photos - Indexing and Conversion - Conversion Settings), denn ansonsten muß die Synology lange arbeiten, um die Bilder/Videos zu konvertieren

Bisher habe ich mich zu diesem Ansatz noch nicht genutzt ... könnte aber eine gute Option sein, um die manuelle Synchronisierung zu optimieren und zumindest zu einer halb-automatisierten Lösung zu kommen. Jedenfalls würden die Daten so zumindest häufiger synchronisiert.

#### Synology DS File

Hier kann die Synchronisierung automatisiert werden:

* Live Photos: ja/nein
* automatische Konvertierung
  * HEIF nach JPG
  * MOV Videos werden hinsichtlich verwendeter Codecs nicht konvertiert

#### Synology App DS Cloud

Hierfür benötigt es auf dem Synology einen Cloud Station Server.

---

## Algorithmus

> ACHTUNG - bitte iOS Konfiguration prüfen: Die iOS Photos App hat auf dem Endgerät eine Einstellung "Auf MAC oder PC übertragen - Automatisch" bzw "Auf MAC oder PC übertragen - Originale bebehalten". Apple verwendet teilweise proprietäre Formate (HEIC für Fotos - bestimmte Codecs für Videos), die auf anderen Platformen (z. B. Windows) evtl. nicht verfügbar sind. Deshalb werden die Dateien bei Bedarf automatisch im Hintergrund beim Kopiervorgang via Windows Explorer konvertiert (im Windows Explorer werden die Bilder vom iPhone schon mit der Endung `jpg` angezeigt, wenn die Option `Automatisch` eingestellt ist ... das macht die Sache noch transparenter/undurchsichtiger). Das kostet natürlich Zeit (Kopiervorgang dauert länger trotz USB 3) und sorgt für unterschiedliche Dateigrößen ... sorgt aber evtl. für bessere Unterstützung auf den Endgeräten.
>> ACHTUNG - ACHTUNG - PROBLEM: irgendwann brach die Synchronisierung immer wieder mit dem gleichen Fehler "Device is unreachable" ab ... gemeint war das iPhone. Google (aka micatek im Diskussionsforum von Apple) half mir mal wieder auf die Sprünge. Die Photos App ist per Default auf dem iPhone so konfiguriert, daß "Auf MAC oder PC übertragen - Automatisch" eingestellt ist. Wenn die Variante "Auf MAC oder PC übertragen - Originale beibehalten" (und einem Neustart des iPhones klappte die Synchronisierung problemlos ... und das Tempo schien mir auch höher (zumindest von iOS nach Windows ist das ja klar, da keine Konvertierung erfolgt).
>>> ABER: bei dieser Einstellung erfolgt KEINE automatische Konvertierung der Foto/Video-Formate - DS Photo wird hier auf einigen Devices Probleme haben. Deshalb ist dies nur die allerletzte Lösung ... da eine manuelle Konvertierung erfolgen muß.

* externe Festplatte über USB 3.0 anschließen
  * auf dieser Festplatte werde ich meine Multimediadateien zunächst sammeln (von verschiedenen Quellen), konvertieren und kategorisieren
  * Ordner `sammlung` anlegen
* alle Geräte (aka `device_foo`) nacheinander anschließen (ACHTUNG: GoPro und Spiegelreflexkamera nicht vergessen) und folgende Aktivitäten durchführen - ACHTUNG: bei iOS Geräten kann es schon mal eine knappe Minute dauern bis das Gerät im Windows-Explorer navigierbar ist
  * externe Festplatte
    * Ordner `device_foo` anlegen
  * auf iPhone Ordnerinhalte ein `Group by Type` machen (wir sind nämlich nicht an `AAE-File` interessiert) und nach Größe sortieren
  * alle Fotos (`JPG`) seit dem letzten "Backup Done"-Foto (Marker für die letzte Synchronisierung) per Windows Explorer nach `device_foo` kopieren
    * bei iOS Endgeräten: die `HEIC` Dateien werden dabei nach `JPG` konvertiert und erhalten einen entsprechende Dateinamen-Extension
    * Dateien Batchumbennen gemäß EXIF Header (XnView: `<Date[ymd_HMS]>`)
  * von den Videos (z. B. `MOV`) seit dem letzten "Backup Done"-Foto (Marker für die letzte Synchronisierung) nur die mit mind. 5 MB Größe (die anderen sind entweder eh Müll oder Live-Foto-Videos, an denen ich nicht interessiert bin) per Windows Explorer nach `device_foo` kopieren
    * bei iOS Endgeräten: die `MOV` Videos erhalten dabei einen Windows Codec - die Größe nimmt zu aber die Videos lassen sich auf mehr Plattformen ansehen (u. a. DS Photo mit Amazon Fire)
    * anschließend überprüfen, ob die Original-Zeitstempel erhalten sind
      * ACHTUNG: Windows Explorer zeigt häufig `Date` an und das ist der Zeitpunkt des letzten Zugriffs - wir sind am `Date modified` interessiert ... da bin ich schon reingefallen!!!
    * Dateien Batchumbennen gemäß Dateistempel `Date modified` umbenennen (XnView: `<Modified_Date[ymd_HMS]>`)
  * alle Dateien per Windows Explorer aus `device_foo` nach `sammlung` verschieben
  * auf dem Endgerät ein "Backup Done"-Foto aufnehmen (Marker für die letzte Synchronisierung)  
* Android Geräte werden kontinuierlich auf das Netzwerkshare synchronisiert ... hier für jedes Gerät folgendermaßen vorgehen
  * Dateien vom Netzwerkshare nach `device_foo` verschieben
  * weiteres Vorgehen wie bei iOS (siehe oben)
  * alle Dateien per Windows Explorer aus `device_foo` nach `sammlung` verschieben
* Bilder und Videos innerhalb von `sammlung` kategorisieren (großen Müll löschen) ... da dies der letzte Schritt ist, sind auch alle Dateien von VERSCHIEDENEN Endgeräten zum gleichen Event einfach einzusortieren
  * Kategorisierung nach Jahr (z. B. `2018`)
    * Kategorisierung nach Quartal (z. B. `20180100_familie_Q1`)
      * innerhalb eines Quartals Kategorisierung nach Event (z. B. `20180210_skiurlaub`)
* `sammlung` per "Photo Station Uploader" nach Synology Photostation (Ordner `photos`) kopieren und - nach Prüfung ob alles angekommen ist - in `sammlung` löschen