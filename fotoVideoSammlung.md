# Meine Foto- und Video-Sammlung

Ich verwende im wesentlichen meine [Synology](synology.md) als Fileserver und die DS Photo App, um die Erinnerungen komfortabel über Tablets, Smartphones und Fire TV anzuschauen.

Problematisch ist, daß die Synchronisierung aufgrund meiner heterogenen Gerätelandschaft (Microsoft Windows, MacOS, Android, iOS, GoPro, Spiegelreflexkamera) unterschiedlich funktioniert und ich eine Synchronisierung über die Cloud aus verschiedenen Gründen ablehne (siehe unten).

## tl;dr

Der erste Use-Case, der in meiner Landschaft nicht paßt und mich überlegen läßt, mein iPhone durch Android Handy zu ersetzen. Das macht mich wahnsinnig und ich habe schon Tage mit diesem Problem verbracht. Nur das iPhone (und natürlich die anderen Apple Geräte) macht hier Probleme, weil

* Apple verwendet von Synology nicht unterstützte Formate (HEIC), d. h. eine Transformation MUSS erfolgen, wenn man Synology - DS Photo verwenden will
  * über Einstellungen - Fotos - Auf MAC oder PC übertragen - Automatisch kann man zwar bei der Übertragung eine Umwandlung durchführen lassen, doch
    * die USB-Verbindung zum Windows PC per Windows Explorer funktioniert nicht stabil und schnell ... ständige Abbrüche
      * iTunes ist der letzte Scheiß - ich habe nicht mal einen Abschnitt "Foto" gefunden ... der Button "Synchronisiere" war nicht clickbar
    * das Kopieren dauert dadurch sehr lang
  * beim Upload nach OneDrive erfolt - entgegen einigen Foren - keine automatische Konvertierung

Nach 1,5 Jahren iPhone-Nutzung habe ich nun endlich rausgefunden, daß man die Kamera auf maximale Kompatibilität einstellen kann (Einstellungen - Kamera - Formate - Maximale Kompatibilität). Dann werden Bilder im JPG-Format statt HEIC-Format aufgenommen. Keine Ahnung welche Auswirkungen es auf Videos hat (evtl. andere Codecs), aber das erscheint mir eine sinnvolle Einstellung in meinem Anwendungsfall.

Da ich meine Daten noch immer nicht in die Cloud (OneDrive) kopieren will, um sie dann auf meinen Rechner runterzuladen und zu kategorisieren,habe ich mir einen [HooToo Lightning USB Adapter](https://www.amazon.de/HooToo-Laufwerk-Zertifiziert-Lightning-Computer/dp/B01HEHXF3A/ref=sr_1_5?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&keywords=hootoo&qid=1574608249&smid=A2X2NO3429IQ5W&sr=8-5) für 28 Euro gekauft. Dieser Stick hat eine MFI-Zertifizierung - derzeit (2019) funktioniert er ... mal sehen ob das so bleibt, denn Apple ändert ja mal gern was an der Kompatibilität solcher Devices.

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

Scheinbar gibt es aber im iOS Umfeld gar nicht so viele Alternativen ... iCloud ist nun doch recht beliebt. Und scheinbar tut Apple alles dafür, um alle iOS User in ihre Cloud zu locken, denn

> "Aufgrund der Einschränkungen von iOS können iOS-Apps keine Hintergrundaufgaben länger als 3 bis 10 Minuten ausführen, auch nicht mit aktivierten Geofences." [Synology DS Photo Dokumentation](https://www.synology.com/de-de/knowledgebase/Mobile/help/DSphoto/iOS_iPhone)

Aber ich kann meine Fotos/Videos auch auf andere Cloud-Speicher kopieren (OneDrive, Google Drive) ... aber noch habe ich mich aus Sicherheitsgründen nicht dazu durchringen können.

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

> ACHTUNG - PROBLEM - ACHTUNG: anfangs habe ich versucht, die Fotos/Videos per USB-Kabel vom iPhone auf meinen Windows-Rechner zu kopieren. Hierbei hatte ich am iPhone "Einstellungen - Fotos - Auf MAC oder PC übertragen - Automatisch" eingestellt, um die Multimedia-Dateien beim Kopieren automatisch in kompatible (Stichwort HEIC) Formate umzuwandeln. Das klappte leider mehr schlecht als recht. Die Synchronisierung brach immer wieder mit dem gleichen Fehler "Device is unreachable" ab ... gelegentlich funktionierte es aber auch. Bei iOS 11 konnte ich das Problem mit der Umstellung auf die Einstellung "Originale beibehalten" lösen (anschließend mußte ich die Fotos manuell per XnView von HEIC nach JPG konvertieren), doch bei iOS 13 klappte auch das nicht mehr.

Meine Lösung 2019 besteht nun aus einem [Lightning-USB-Adapter mit 64 GB Speicher von HooToo (28 Euro)](https://www.amazon.de/HooToo-Laufwerk-Zertifiziert-Lightning-Computer/dp/B01HEHXF3A/ref=sr_1_5?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&keywords=hootoo&qid=1574608249&smid=A2X2NO3429IQ5W&sr=8-5), über den ich die Multuimedia-Dateien auf meinen Windows-Rechner bekomme. Allerdings muß ich sie anschließend in Windows-kompatible Formate umwandeln ... zumindest die Bilder - die Videos sind Synology-kompatibel.

> Alternative für die Zukunft: Kopieren der Multimedia-Daten in die Cloud - bei OneDrive habe ich genügend Speicher. Derzeit habe ich mich aus Sicherheitsgründen noch nicht zu einer solchen Lösung durchringen können.

* externe Festplatte über USB 3.0 anschließen
  * auf dieser Festplatte werde ich meine Multimediadateien zunächst sammeln (von verschiedenen Quellen), konvertieren und kategorisieren
  * Ordner `sammlung` anlegen
* alle Geräte (aka `device_foo`) nacheinander anschließen (ACHTUNG: GoPro und Spiegelreflexkamera nicht vergessen) und folgende Aktivitäten durchführen
  * auf USB-Platte den Ordner `_already_transferred_to_synology_` anschauen und das Datum der letzten Foto-Synchronisierung rausfinden (z. B. Datum des letzten Bildes rausfinden)
  * auf externer USB-3.0-Festplatte Ordner `device_foo` anlegen
  * jetzt je nach Device alle Dateien seit der letzten Synchronisierung auf die USB-Platte kopieren:
    * iOS:
      * HooToo-Lightning-Stick anschließend und die Fotos/Videos aus dem Ordner "Zuletzt" über die App iPlugmate auf den Stick kopieren
      * Dateien auf die USB-Festplatte kopieren ... in den Ordner `device_foo`
      * Ordner `device_foo` gruppieren nach Typ und sortieren nach Größe
        * `PNG` Dateien löschen - hierbei handelt es sich um Screenshots
        * `MOV` unter 5 MB löschen - hierbei handelt es sich um Live-Photo-Videos oder Schrott-Videos unter 3 Sekunden
        * `HEIC` Dateien (sofern vorhanden) per XnView in JPG umwandeln (Werkzeuge - Stapelverarbeitung)
    * Android
      * Synchronisierung über FolderSync App mit dem Netzwerkshare anstoßen
      * Dateien vom Netzwerkshare auf die USB-Festplatte kopieren ... in den Ordner `device_foo`
* pro `device_foo`
  * alle Bilder gemäß EXIF-Header drehen
  * alle Bilder gemäß EXIF-Header umbenennen (XnView: `<Date[ymd_HMS]>`)
  * alle Filme gemäß Dateistempel `Date modified` umbenennen (XnView: `<Modified_Date[ymd_HMS]>`)
* alle `device_foo` Dateien in `sammlung` vereinen
* auf dem Endgerät ein "Backup Done"-Foto aufnehmen (Marker für die letzte Synchronisierung)  
* Bilder und Videos innerhalb von `sammlung` kategorisieren (großen Müll löschen) ... da dies der letzte Schritt ist, sind auch alle Dateien von VERSCHIEDENEN Endgeräten zum gleichen Event einfach einzusortieren
  * Kategorisierung nach Jahr (z. B. `2018`)
    * Kategorisierung nach Quartal (z. B. `20180100_familie_Q1`)
      * innerhalb eines Quartals Kategorisierung nach Event (z. B. `20180210_skiurlaub`)
* `sammlung` per "Photo Station Uploader" nach Synology Photostation (Ordner `photos`) kopieren und - nach Prüfung ob alles angekommen ist - in `sammlung` löschen
