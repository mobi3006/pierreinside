# Synology Diskstation DS112+

Auslöser für diesen Kauf war mein zickender Drucker-Server von Edimax. Der meinte irgendwann nur noch komische Zeichen drucken zu wollen und ich investierte viele Stunden - doch leider ohne Erfolg. Der Drucker war noch bestens in Ordnung und deshalb wollte ich nicht einfach einen neuen mit WLAN-Anschluss kaufen ...

Irgendwann stieß ich auf die Synology-Serie, die gleich einige meiner aktuellen und jahrelangen Probleme zu lösen schien:

* File-Server
* Print-Server
* Backup über USB 3.0
* Videoüberwachungsserver
* SVN-Server

Es versprach

* geringen Wartugsaufwand, weil die Distribution von Synology über jahre hinweg gepflegt wird
* geringen Stromverbrauch
* gute Performance in der Plusversion

Das musste die eierlegende Wollmilchsau sein ... aber das versprechen ja viele.

## Alternativen

Anfangs dachte ich gar nicht über Alternativen nach, da ein Kollege mir die Synology als Eierlegende Wollmilchsau empfahl und ich von den Features auch selbst begeistert war. Nach dem Desaster bei der Abschaffung von Time-Backup in der Version 6.1 (Jahr 2018) war ich doch sehr enttäuscht von Synology und schaute mich nach Alternativen zu meinem 6 Jahre alten Gerät um (DS112+).

## Hardware-Konfiguration

Ich entschied mich gegen ein RAID, weil ich das Geld lieber in eine externe USB-Platte stecke, die dann tatsächlich ein Backup ermöglicht (und nicht nur eine Spiegelung). Ich benötige keine 99,9996 % Ausfallsicherheit. Wenn die Platte mal abraucht und ich einen oder zwei Tage nicht auf meine Daten zugreifen kann ... KEIN PROBLEM - solange ich noch ein ordentliches Backup habe

Verbaut ist eine Western Digital WD30EFRX 3TB aus der Red-Serie (für Server-Betrieb).

Gesamtkosten: 350 Euro

## Web-Applikationen

Synology bietet die zentrale Diskstation-Verwaltung über ein Webfrontend an, so daß man per Browser Zugriff erhält (https://diskstation:5001/webman). Zudem bieten einzelne Pakete weitere Web-Applikationen an, z. B.

* Admin-Oberfläche: https://diskstation:5001
* Photo Station: http://diskstation:80/photo
* Photo Blog: http://diskstation:80/blog
* Time Backup: https://diskstation:5001/timebkp

Auf diese Weise können sich Benutzer auf das konzentrieren, was sie tatsächlich tun wollen, ohne sich erst umständlich durch die allgemeins Diskstation-Oberfläche zu hangeln.

**ACHTUNG:** an diesen Oberflächen kann man sich mit ALLEN Usern anmelden (also beispielsweise auch mit einem normalen User-Account an der Administrationsoberfläche) ... die Feature sind dann aber evtl. eingeschränkt.

## Admin-Oberfläche

Die Admin-Oberfläche wird ihrem Namen nur gerecht, wenn man sich mit dem Administrations-User anmeldet.

### Monitoring

Über *Control Panel - Notification* kann man über den Status des Diskstation im allgemeinen oder einzelne Aktionen per Mail oder Smartphone-Notification informiert werden.

Das ist sehr praktisch, um beispielsweise über fehlgeschlagene Backups, zu hohe Temperaturen, Fehler auf der Platte, ... informiert zu werden.

## Netzwerk-Performance

Wahnsinn ... nahezu volle Nutzung meiner Gigabit-Netzwerk-Bandbreite. Mit einem schnellen Netzwerk-Controller auf der Gegenseite (Laptop mit SSD) schaffte ich 100 MByte/s.

Ich war mir bis dahin nicht mal bewusst, daß mein Netzwerk solche Geschwindigkeiten schaffen kann. Meine *WDTV Live Hub Box* versprach auch Gigabit-Netzwerk und gab mir 10 MByte/s. Daß mehr drin sein sollte war mir klar ... aber tatsächlich soviel ... puh.

Bei dieser Geschwindigkeit stand einer Nutzung als File-Server zunächst mal nichts im Wege ... allerdings mussten die Clients nun auch noch schnell genug sein (und mit WLAN hatte ich auch keine guten Erfahrungen gesammelt).

Einbindung der Clients

Ein paar Clients greifen kabelgebunden darauf zu, die meisten aber über WLAN. Ich habe allerdings nur Geräte, die die geringste WLAN-N-Geschwindigkeit unterstützen: 65mbit/s ... das läuft im Realbetrieb auf 4-6 MByte/s raus.

Reichts das aus, um die Diskstation für alle Use-Cases als File-Server zu verwenden (und dann beispielsweise kleine aber schnelle SSDs in den laptops zu verbauen)?

* für normale Office Arbeiten: uneingeschränkt JA
* für Multimedia-Dateien
  * Bilder in der Größe von 3-5 MB: JA mit leichten Abstrichen (beim schnellen Blättern merkt man es dann doch)
  * Video mit 3-5 MB/s: ... hier wird es eng ... derzeit gehts grad noch so
    * ACHTUNG: dafür kann die Diskstation nichts ... das Problem sind die billigen WLAN-Adapter meiner Endgeräte (selbst mein 1100 Euro teures Asus N56VZ hat eine langsame Atheros-Karte drin ... tja, Asus: an der falschen Stelle 10 Euro gespart)

## Backup

## Was vorher geschah ...

Backup und Dateiorganisation war schon seit Jahren ein Thema ... bisher hatte ich noch keine zufriedenstellende Lösung gefunden.

Ich baute einen Fileserver auf (mein sog. Muli) und lies dort semi-professionelle Backup-Software (Bacula) laufen. Doch das war für Gelegenheits-User einfach zu komplex. Immer wieder musste ich mich in das Thema einarbeiten ... und letztlich lagen die Files in einem binnären Format vor. Das machte ein ungutes Gefühl bei mir. Was wenn ich das Backup tatsächlich mal brauchen sollte ... würde ich dann wirklich restaurieren können (klar, gelegentlich Tests klappten)? Ich hatte kein Vertrauen.

Dann wollte ich GIT verwenden, um versionierte Sicherungen zu erstellen und die dann immer wieder auf ein Remote-Repository auf meinem Fileserver synchronisieren. Hintergrund war der, daß ich die Daten auf verschiedenen Rechnern brauchte. Aber irgendwie synchronisierte ich nur selten (oder nie?) auf meinen Fileserver (vielleicht auch, weil der nicht dauerhaft lief ... warum eigentlich?). Mir fehlte die Disziplin. Und dann lagen mal Files hier, mal dort ... es war fürchterlich.

Zumindest sicherte ich die Daten gelegentlich manuell auf eine externe USB-Platte ... dann aber immer vollständig (inkl. 500 GB Foto/Video Sammlung). Das dauerte dann natürlich entsprechend lang. Und deshalb geschah es nur sehr selten (alle 3-6 Monate).

Ich zog auch eine zentrale Speicherung meiner Daten bei der NSA ... ähm, in der Cloud in Betracht, doch das scheitert an meiner schlechten Upload-Bandbreite (1 MBit/s) ... Tendenz: keine Erhöhung in Sicht.

Das Thema bereitete mir immer Kopfzerbrechen, aber ich hatte keine Lust und Zeit ...

### Synology TimeBackup - nur bis DSM 6.0

... und dann kam Synology DS112+ mit TimeBackup ... und die Erde erstrahlte. Ungelogen ... dieses Teil lässt mich jetzt - nach Jahren des schlechten Gewissens - besser schlafen. Und schon allein aus diesem Grund hat sich die Investition gelohnt.

Da das NAS als zentraler Fileserver fungiert (weil es auch entsprechend schnell ist), benötige ich nur ein Backup des NAS und nicht aller Clients. Die Dezentralisierung war bei meinen bisherigen Backup-Lösungen immer Hauptproblem.

Im Synology-Control-Center musste ich nur die USB-Festplatte anschliessen, das TimeBackup-Package installieren und konfigurieren (z. B. Hourly mit  Smart Recycle) und schon gings gehts. Die USB-Platte kann während der Konfiguration des TimeBackups automatisch (auf Nachfrage!!!) mit ext3 oder ext4 formatiert werden (die einzigen unterstützten Filesysteme). Fertig.

Ich habe noch eine zweite externe USB-Festplatte, die ich an einem anderen Ort (Bank-Safe oder Freunde) lagere, um bei Brand eine Sicherung zu haben. Da ein Time Backup inkrementell ist und mit vielen Links auf die alten Backups arbeitet, war mir nicht klar, ob ich einfach die andere externe Festplatte anstöpseln kann und dann die zwei Backup-Tasks (derzeit zwei, weil sie in unterschiedlichen Intervallen laufen - mehrfach am Tag vs. einmal pro Woche) wie "Basalt im Synology Forum:

"For the normal backup, I use 2 external USB disks with the same name (usbshare1). I swap them every week (using eject function of DSM), but the (single) backup task is not aware of that and just does its job." ([Synology Forum](https://forum.synology.com/enu/viewtopic.php?t=61847))

"allyn" antwortete daraufhin:

"That trick doesn't work unfortunately. I tried this and this is what I found: Time Backup saves disk space by making hard links to the previous backup for unchanged files. This is how it can make new backups using virtually no disk space. Time Backup keeps a list of available backups (on the internal disk). After a disk swap, it can't find the most recent backup (since it was on the other disk) and instead of just using the most recent one available on the current disk, it makes a completely new copy of all of your data. This fills up the disk way too fast because you get a complete new copy after every disk swap. If it would only use the most recent copy available it would work fine. That would be the one change I would make to Time Backup if I had a chance." ([Synology Forum](https://forum.synology.com/enu/viewtopic.php?t=61847))

"allyn" macht es mit komplett getrennten Backup-Tasks, für `usbshare1` und `usbshare2` werden unterschiedliche Backup-Tasks verwendet.

Bei mir funktioniert "allyn"s Ansatz nicht, da ich bereits zwei Backup Tasks habe und keine dritte definieren kann. Ich erhalte die Meldung "the number of tasks exceeds system limitation". Da Synology mit der Version 6.1 (ich habe derzeit noch 6.0 - das Update steht seit Wochen aus) kein TimeBackup mehr unterstützt, habe ich mich in Hyper Backup eingearbeitet.

#### Smart Recycle

Macht man Hourly Backups, dann enstehen 24 Backups am Tag, 168 Backups pro Woche, ... Das ist natürlich eine ganze Menge. Diese Backups sind natürlich optimiert (unveränderte Dateien werden nicht mehrfach gespeichert und nehmen Platz weg), aber dennoch sind es extrem viele und man würde vielleicht auch selbst den überblick verlieren (wenn man ein Restore durchführen will).

Deshalb gibt es die Smart Recycle Option, die nach einem Algorithmus einige Backups behält und die Mehrzahl entsorgt. Das bedeutet:

* von den letzten beiden Tagen werden alle stündlichen Versionen behalten
* von Tag 3 - 7 wird nur eine Version pro Tag behalten

Auf diese Weise behält man noch einen guten Überblick - ich finde den Ansatz sehr gelungen.

#### Backup-Strategie

Jetzt werden die Home-Shares dreimal täglich gesichert und die Foto-Sammlung einmal wöchentlich. Durch SMB-Mount von ``\\diskstation\usbshare1`` kann ich leicht einen Blick auf das Backup werfen. So sieht die Struktur von der Backup "Task 4" vom 21. Oktober 2018 um 23:00 Uhr aus:

```
\\diskstation\usbshare1\
   Diskstation_001144556677\
      task_4\
         20181021-2300\
            photo\
               2016\
                  ...
               2017\
                  ...
               2018\
                  ...
            svn\
               ...
```

Keine Binär-Backups (wie bei Bacula - zu dem ich nie richtiges Vertrauen aufgebaut habe), sondern ich kann in den Ordnern problemlos navigieren und einzelne Dateien oder ganze Verzeichnisbäume wiederherstellen. Ich kann aber auch die Webapplikation starten und mich in die Zeitmaschine setzen, um den aktuellen Stand zu jedem Backup-Zeitpunkt zu erhalten.

Und das beste: wenn sich nichts ändert, wird auch kein (bzw. nur geringer) Platz benötigt :-) Nun habe ich zentrale Datenhaltung, Backup und Versionierung. WOW :-)

Ein kleiner Nachteil für reine Windows-User könnte darin bestehen, daß TimeBackup nur auf ext3 oder ext4 Filesysteme schreibt. Man kann dann also nicht so einfach die USB-Platte abstöpseln und an eine Windows-Kiste hängen, da Windows diese Dateisysteme nicht lesen kann. Normalerweise ist das kein klassischer Use-Case, weil man ja über SMB-Mount (``\\diskstation\usbshare1`` bzw. ``\\diskstation\usbshare2``) oder die FileStation-Webapp auf die Festplatte auch als Windows-User zugreifen kann.

#### Notification

Ich habe es so eingerichtet, daß ich per Mail über Backups informiert werde - so weiss ich zumindest, daß sie noch stattfinden und ob sie erfolgreich waren.

### Hyper Backup

* [motivierender Beitrag](https://www.tutonaut.de/anleitung-verschluesseltes-cloud-backup-mit-synology-hyper-backup-erstellen/)

Hyper Backup unterstützt nicht nur Backups auf lokale Festplatten bzw. externe USB-Festplatten, sondern auch verschlüsselte Backups in die Cloud. Meine DS112+ wird noch unterstützt ... ich habe das Paket auch schon erfolgreich auf meiner DSM 6.0 Version installiert.

Interessante Cloud Storage Anbieter (Preis für 1 TB/Monat):

* Strato HiDrive: 7,50 Euro
  * unschlagbar günstig
  * Server-Standort Deutschland
* Google Drive (mittlerweile umbenannt zu Google One): 10 Euro
* Dropbox: 10 Euro
* OneDrive: 10 Euro
* Remote Synology NAS
  * so könnte ich beispielsweise eine alte Synology zu meinem Eltern stellen und auf Cloud-Backups verzichten

Leider habe ich das gelesen:

"it simply has NOT the ability to make filebased, smartrecyled backup) ... i will NEVER backup me files in a propritary database" ([Synology Forum](https://forum.synology.com/enu/viewtopic.php?t=119519))

... und das war genau mein Problem mit Bacula - ich möchte sichergehen können, daß ich meine Daten auch restoren kann, wenn die Restore-Software nicht funktioniert oder evtl. nicht mehr gewartet wird. Ich möchte die Platte anstöpseln und direkt meine Daten per Windows Explorer copy/paste restaurieren können.

Synology schreibt dazu in der Dokumentation zu Hyper Backup:

"Sie können auf macOS-Computern mit dem AFP-Protokoll via macOS Finder und auf Windows-Computern mit dem SMB-Protokoll über den Windows Explorer auf Sicherungen zugreifen, ohne dass Sie sich auf der DSM-Benutzeroberfläche anmelden müssen."

Hierzu benötigt man den Hyper Backup Explorer ... eine Software für Windows und MacOS, um in den Hyper Backup Sicherungsdatenbanken zu stöbern.

#### Erste Erfahrungen

Das erste Backup auf Basis von Hyper Backup auf eine lokale USB Platte (externe USB 3.0) Platte war extrem langsam. 10-20 MB/s Übertragungsrate (8 Stunden für 300 GB) über eine USB 3.0 Verbindung sind unterirdisch. Für meinen Anwendungsfall (Vierteljährliche Backups, die extern gelagert werden) ist das kein No-Go.

Erfreulich war hingegen, daß die Dateien Backups scheinbar ohne Spezialsoftware (wie Hyper Backup Explorer) im Windows Explorer lesbar waren. Ich konnte zumindest meine externe USB-Platte über `\\diskstation\usbshare2` (also schon über Synology) in Windows einhängen und auf die Dateien zugreifen - könnte natürlich weiterhin sein, daß Synology hier transparent eingreift und das ganze für mich nur so darstellt. Kommt auf ein Versuch an, die Platte ohne beteiligtes Synology einfach in einem Linux Rechner (Windows funktioniert nicht, weil ich `ext4` als Filesystem verwende).

### USB Copy

Nachdem Synology mein geliebtes Time Backup in 6.1 nicht mehr unterstützt, mußte ich mir eine neue Backup Strategie suchen.

Hyper Backup ist wohl der angedachte Ersatz für Time Backup, doch möchte ich mich nicht auf ein proprietäres Format verlassen. Zumindest nicht VOLLSTÄNDIG. Deshalb ist meine Idee:

* Hyper Backup für die tägliche Sicherung
* USB Copy für die Quartalssicherung

USB Copy erzeugt kein Proprietäres Format, sondern ein hierarchisches Abbild der Dateien. Sollte also mal was mit Hyper Backup nicht klappen, dann möchte ich auf das USB Copy zugreifen können ... zur Not verliere ich halt ein paar Monate, aber das wäre zu verkraften.

> Beim Wechsel von DSM 6.0 auf 6.2 hätte ich vorher gerne mal ein USB Copy Backup auf meine zweite externe USB Platte gemacht, doch USB Copy stand in 6.0 nicht als Paket zur Verfügung.

Nach der Installation von DSM 6.2 gleich die erste Enttäuschung. USB Copy ist als Paket verfügbar, doch die Funktionalität ist lächerlich. Ich kann nicht mehrere Ordner zum Mirroring selektieren und wenn ich zwei Copy Jobs mache, dann bekomme ich die Fehlermeldung "The USB/SD folder is usbshare2 is already used for an existing copy". Im Synology Forum lese ich, daß das kein Bug, sondern ein nicht vorhandenes Feature ist. Die wollen mich wohl verarschen??? So ist USB Copy nicht zu gebrauchen ... zumindest nicht für meinen Use-Case. Toll, Time Backup abgeschafft aber keine passende Alternative geschaffen :-(

Hier läßt sich die ganze Misere nachlesen: [https://forum.synology.com/enu/viewtopic.php?t=129488](https://forum.synology.com/enu/viewtopic.php?t=129488)

> Fazit aus diesem Thread: "This feature works just fine on QNAP [...] I really wish that I stayed with QNAP"

## Foto/Video Synchronisierung von iOS

[siehe andere Seite](ipadPro.md)

## Foto/Video Alben anschauen

Mit DS Photo liefert Synology die beste Lösung, die ich bisher kennengelernt habe. Von jedem Endgerät habe ich bisher flüssig Fotos anschauen können ... und die billigen Android-Handys verfügen ja nicht unbedingt über die besten WLAN Chips. Für Videos fehlen allerdings manchmal die richtigen Codecs ... das muß ich mir nochmal genauer ansehen.

Häufig sitzen wir mit unseren Kindern vor dem Fernseher und haben bei der Betrachtung der alten Bilder und Videos viel Spaß. Allein dafür lohnt sich die Synology.

Die Bilder/Videos müssen zunächst mal in die Photo Station kommen, um dort indiziert und für die Wiedergabe auf unterschiedlichen Endgeräten optimiert zu werden ... das kann u. U. schon mal ein paar Tage dauern :-(

Der Upload auf die Photo Station kann folgendermaßen erfolgen:

* den Photo Station Uploader (Windows, MacOS) verwenden ... EMPFOHLEN, denn hier wird die Rechenleistung des Computers verwendet, um die Bilder zu optimieren - ansonsten muß das die Synology tun, die evtl. mehrere Tage damit beschäftig ist
* auf ein Netzwerkshare kopieren

Der Zugriff auf die Bilder ist - nach erfolgreicher Indizierung (ACHTUNG: kann dauern) - per

* File-Share
* Web-Applikation (Photo Station, File Station)
* über Apps wie DS Photo

möglich.

### Synology App DS Photo

* [DS Photo Anmeldung an Photo Station](https://www.synology.com/de-de/knowledgebase/Mobile/help/DSphoto)

Diese App ist verfügbar für die meisten mobilen Platformen (Android, iOS, Amazon Fire). Nach dem Start muß man sich mit einem User anmelden, der über Leseberechtigungen auf die Bilder verfügt.

iOS speichert Fotos seit der Version 11 im HEIC Format (bester Qualität bei minimalem Platz), das von der Synology (Version 6.0) allerdings noch immer nicht verarbeitet werden kann. Somit sind die Fotos nicht über DS Photo zu sehen. Bleibt zunächst mal nur die Konvertierung nach JPG (z. B. per XnView mit dem HEIF Plugin) - in iOS kann man den Download so konfigurieren, daß eine automatische Konvertierung von Bildern und Videos (Codecs) stattfindet, wenn man auf ein Windows Rechner runterlädt ([siehe hier](ipadPro.md]).

### Multimedia Dateien kategorisieren

Ich habe so viele Bilder und Videos (mehrere Zehntausend), daß ich gerne eine "Best of" Sammlung erstellen möchte. Allerdings möchte ich hierzu keine Kopien erstellen oder Links anlegen müssen. Ich möchte auch keine applikationsspezifische Lösung (z. B. eine parallele Multimedia-Datenbank), sondern ich möchte diese Information in die Foto- bzw- Videocontainer packen. Eine applikationsspezifische Lösung scheidet aus meiner Sicht aus - zu groß ist der Aufwand, um dann bei einer Abkündigung der Anwendung alles zu verlieren.

Bei jpeg-Fotos stehen verschiedene Metatag-Formate zur Verfügung, so daß sich eine Kategorisierung hierüber abbilden läßt. Verwendet man die DS Photo App (ACHTUNG: der angemeldete User muß Schreibberechtigung haben) oder auch Synology PhotoStation Web-Frontend, so kann über "Information - Allgemeines Tag" ein Tag vergeben werden, das in den IPTC und XMP Metadaten landet. Diese können beispielsweise in

* DS Photo über die Suche
* Synology PhotoStation über die Suche
  * hierüber lassen sich dann sog. SmartAlben erstellen (Suche durchführen und Ergebnis per "Save as Smart Album" sichern), die über DS Photo App abrufbar sind - das ist sehr gut!!!
* XnView über die Suche
* Fotogalerie (Windows) als Filter

abgefragt werden. Bei Bildern gibt es verschiedene Lösungen (IPTC, XMP, ...) ... aber das ist vielleicht auch noch vom Bildformat abhängig.

Bei Videos gestaltet sich die Sache schwieriger, denn hier sind Metadaten noch nicht standardisiert (zugegeben: bei Bildern gibt es verschiedene Lösungen - bei Videos aber scheinbar gar keine).

## Print-Server

Die Diskstation kann als Printserver für per USB angeschlossene Drucker fungieren - so macht man einen Nicht-Netzwerkdrucker im zu einem Netzwerkdrucker.

Ein Client, der den Netzwerkdrucker verwenden will, muss den Druckertreiber lokal installiert haben - der Drucker bekommt dann nur das erzeugte Dokument in der jeweiligen Druckersprache zugeschickt. Nachdem man den Treiber auf dem Laptop/PC installiert hat (unter Windows reicht dazu ein kurzes Verbinden des Druckers mit dem Laptop/PC ... später kann man evvtl. noch bessere Druckertreiber installieren), verbindet den Drucker per USB mit der Diskstation und startet den Synology Assistant (ein Programm, das man unter www. synology.com runterladen kann). Dort fügt man einen Drucker hinzu, was zur Folge hat, daß man lokal auf dem Laptop/PC einen Druckeranschluss zum Synology-Print-Server erstellt bekommt.

Der Print-Server arbeitet sehr zuverlässig und stabil :-)

## Videoüberwachung

Synology bietet auch eine Videoüberwachung an. Das wollte ich mal ausprobieren (eine Lizenz für eine Kamera ist bereits in jeder Diskstation enthalten - weitere Lizenzen kosten 50 Euro pro Kamera) und kaufte eine Outdoor-Kamera, die mit einer 720p Auflösung schon ganz gute Bilder macht, aber andererseits auch noch bezahlbar ist. Deshalb ist es die Foscam FI9804w für 120 Euro geworden. Diese Kamera steht auf der Synology-Kompatibilitätsliste nicht drauf (wohl aber andere Foscam Modelle), kann aber dennoch verwendet werden, wenn man sie als FI9805W anmeldet.

Interessante ist, daß die Synology-Diskstation folgende Services bietet:

* Speicherung der Daten
* Bewegungsentdeckung - insbesondere in Zusammenhang mit einer Speicherung der Daten macht das Sinn, um dann nur die relevanten Stellen aufzunehmen
* Bereitstellung der Daten über ein Webinterface oder die Tablet/Handy-optimierte App "DS Cam"

### Kamera: Foscam FI9804W

Ich habe mich für diese Kamera entschieden, weil

* WLAN
* 720p (statt der in dieser Preisklasse häufig anzutreffenden 480p)
* mit 120 Euro gerade noch am Rande meiner Schmerzgrenze
* Synology scheint sie zu unterstützen (habe ich in einem Forum gelesen), obwohl sie nicht in der offiziellen Liste stand (man muss sie nur als FI9805W in der Synology-Surveillance-Station anmelden) ... viele andere Foscam-Modell werden offiziell unterstützt

#### Inbetriebnahme

Die mitgelieferte Software bitte einfach nicht verwenden ... bei mir hat sie unter Windows 7 64-Bit überhaupt nicht funktioniert. Weder IPCam Search Tool noch das Management Tool.

* Kamera per Ethernet-Kabel an den Router anschliessen - im weiteren Verlauf werden wir die Kamera über ein Webinterface auf WLAN konfigurieren
  * ein DHCP-Server muss laufen
  * Strom einschalten
* im DHCP-Server nachschauen, welche IP-Adresse die Kamera erhalten hat (im folgenden gehe ich von ``172.31.15.31`` aus)
* im Browser das Webinterface der Kamera (!!!) zur Konfiguration aufrufen:
  * SSL-gesicherte Verbindung: https://172.31.15.31:443
  * alternativ eine ungesicherte Verbindung: http://172.31.15.31:88
  * Anmerkung: die Ports lassen sich später im Webinterface auch ändern
* Anmeldung mit
  * username: admin
  * passwort:
    * das Passwort ist leer!!!
    * am besten gleich ein neues Passwort für den User ``admin`` setzen. Zur besseren Dokumentation (in der folgenden Beschreibung) nehme ich an das Passwort *quatschkopf* wurde vergeben
* WLAN konfigurieren
  * im WLAN-Access-Point müssen neue Geräte zugelassen sein
  * Ethernet-Kabel entfernen
  * Kamera-Restart durch kurzzeitige Stromunterbrechung ... Stecker ziehen ;-)
  * im DHCP-Server nachschauen, welche IP-Adresse die Kamera über das WLAN-Interface erhalten hat (im folgenden gehe ich von ``172.31.15.40`` aus)
  * Zugriff per Webinterface prüfen:
    * SSL-gesicherte Verbindung: ``https://172.31.15.40:443``
    * alternativ eine ungesicherte Verbindung: ``http://172.31.15.40:88``
* Synology-Surveillance-Station einrichten - über das übliche Synology-Admin-Webinterface (zur besseren Dokumentation gehe ich davon, daß die Diskstation die IP-Adresse ``172.31.15.25`` hat - ``https://172.31.15.25:5001``)
  * Paket installieren
  * Surveillance-Station starten. Aus dem Synology-Admin-Webinterface heraus oder per Browser-URL: ``https://172.31.15.25:5001/webman/3rdparty/SurveillanceStation``
  * IP Camera - Add
    * IP-Adresse: 172.31.15.40
    * Port: 88
    * username: admin
      * man kann natürlich auch einen anderen User über das Kamera-Webinterface (``http://172.31.15.40:88``) anlegen
    * passwort: quatschkopf
      * ACHTUNG: das ist nur ein Beispiel!!!
    * Verbindung testen
  * es macht Sinn, die Aufzeichnungsdauer und die Location festzulegen ... einfach mal schauen, was sich so alles findet :-)
* Smartphone App DS Cam installieren
  * IP-Adresse: ``172.31.15.25``
    * ACHTUNG: hier muss die IP-Adresse der Diskstation eingegeben werden, nicht die der Kamera!!!
  * username: admin
  * passwort: DAS_PASSWORT_DES_DISKSTATION_ADMINS
  * **ACHTUNG:** das sind nicht die Credentials der Kamera-Benutzer, sondern die der Synology-Benutzer (man medet sich jetzt an der Diskstation an!!!) ... das kann verwirren. Da ich mein Diskstation-Admin-Passwort nicht in meinem Handy hinterlegen wollte habe ich einen User ``cam`` in der Diskstation angelegt. Dieser User hat keinen Zugriff auf die Shares, sondern ausschließlich auf die Applikation Surveillance-Station.

Ich war fasziniert von der Bewegungserkennung. Immer wenn eine Bewegung festgestellt wird, wird das Video während der gesamten Bewegung aufgezeichnet plus 5 Sekunden davor und danach. PERFEKT :-)

Über die Surveillance-Station oder die DS Cam lassen sich das Echtzeit-Bild (steht immer zur Verfügung ... nicht nur bei Bewegung) und die Aufnahmen ansehen.

## ssh-Server

In der Admin-Konsole muß über *Terminal - enable SSH Service* der SSH-Server einkonfiguriert sein.

Anschließend sollte ein Verbindungsaufbau über den User ``root`` per `ssh root@diskstation` möglich sein.

## Git-Support

* http://blog.osdev.org/git/2014/02/13/using-git-on-a-synology-nas.html

Synology bietet auch ein Git-Server-Paket, das über die Admin-Oberfläche schnell installiert ist. Dann muß man den relevanten Usern (evtl. legt man auch einen User ``gituser`` an) noch Zugriff auf den Git-Server erlauben und sich noch vergewissern, daß der ssh-Server eingerichtet ist, läuft und funktioniert. Der ssh-Server wird benötigt, um

* im folgenden ein Bare-Repository auf der Synology-Diskstation anzulegen (siehe unten)
* zwischen Git-Client und Git-Bare-Repository zu kommunizieren (u. a. ``git clone``, ``git push``)

**ACHTUNG:** ein Stolperstein des Git-Server-Pakets war der Bug (?), daß die Default-Shell meiner Git-Enabled-User auf ``/var/packages/Git/target/bin/git-shell`` gesetzt war (siehe ``/etc/passwd``). Beim Anmeldeversuch über `ssh pfh@diskstation` bekam ich die Fehlermeldung (http://gresch.io/2016/01/fatal-interactive-git-shell-is-not-enabled-on-synology/)

    fatal: Interactive git shell is not enabled.
    hint: ~/git-shell-commands should exist and have read and execute access.

Das muß per vi-Editor (``vi /etc/passwd``) in

    DiskStation> cat /etc/passwd
    pfh:x:1027:100::/var/services/homes/pfh:/bin/sh

abgeändert werden. Nun ist der ssh-Connect mit diesen non-Root-Usern auch wieder möglich.

### Zentraler-Repository-Ansatz mit Synology

#### Bare-Repository auf Diskstation anlegen

Als User ``root`` (ACHTUNG: das ist nicht der Admin-User, mit dem man sich an der Admin-UI anmeldet) per ssh auf die Diskstation wechseln `ssh root@diskstation` und dort per

    cd /volume1/myuser/                # (A)
    mkdir git-repos
    cd git-repos
    mkdir myrepo.git
    cd myrepo.git
    git --bare init
    git update-server-info
    cd ../..
    chown -R myuser:users myrepo.git   # (B)

ein sog. *Bare-Repository* anlegen.

**ACHTUNG:** natürlich muß man die Location (A) und den Owner bzw. die Berechtigungen so wählen, daß der User, mit dem sich der Client später verbinden möchte, auch lesend/schreibend zugreifen kann.

#### Diskstation Repository clonen

Auf dem Client wird das Repository lokal geclont (Achtung: es handelt sich hier um eine ssh-URL - nicht um https): 

    git clone ssh://myuser@diskstation/volume1/homes/myuser/git-repos/myrepo.git

**ACHTUNG:** Für den Support von https-Urls muß noch WebDAV auf der Synology-Diskstation installiert und konfiguriert werden - aber ssh-Verbindungen sind viel besser, da eine passwortfreie Authentifizierung möglich ist.

### Passwortfreie ssh-Verbindung konfigurieren