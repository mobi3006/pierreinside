# Foto-Video-Sammlung ab 2024

Über die letzten 20 Jahre haben sich 100.000 Fotos und Videos angesammelt. Wunderschöne Erinnerungen, die uns extrem wichtig sind und wir deshalb ständig im Zugriff haben möchten. Die Sammlung erweitert sich ständig.

---

## Motivation zur Änderung des aktuellen NAS Ansatzes

Derzeit verwenden wir eine in die Jahre gekommene Synology DS112+. Der Ansatz ist [hier detailiert](fotoVideoSammlung-bis-2023.md) beaschrieben. Die Festplatten (eine in der Synology und eine fürs Backup) sind nun voll und müssen alterbedingt ausgetauscht werden. Die Synology wird hauptsächlich für Fotos und Videos von unseren Handys und Fotoapparaten genutzt - dient aber auch als Fileserver für alle anderen Daten (Word, PDF, Powerpoint), d. h. unsere Laptops speichern keine wichtigen Daten auf den Endgeräten selbst, sondern auf der Synology. Die Synology fertigt Backups an.

Ein Wechsel der Synology ist mit einem Wechsel

* von DSM 6.x auf 7.x (inkl. Filesystem ext4 auf Btrfs)
* von DS Photo auf Synology Photos

verbunden. Ein harter Einschnitt, da der bisherige Ansatz zur Foto/Video-Sammlung auch nur nach vielen Recherchen (insbes. der Codec-Support war immer wieder ein Problem) und Optimierungen so funktioniert hat. Ich erwarte also auch hier deutlichen Aufwand, wenn wir wechseln müssen.

Deshalb stelle ich den Ansatz nun erneut auf den Prüfstand.

### Was mich derzeit stört?

**DS Photo App:**

Die DS Photo App für den FireTV ist relativ langsam und die Video-Wiedergabe scheiterte in der Vergangenheit auch immer mal wieder am Codec-Support. Auf der DS Photo Handy App müssen Plugins Videos wiedergeben. Es funktioniert, ist aber kein großartiges Nutzererlebnis. Mit Amazon Photos ist das ein Quantensprung - es geht also deutlich besser.

Das neue Synology Photos (DS Photo wurde durch Synology Moments abgelöst und das wiederum durch Synology Photos) wird auf dem FireTV gar nicht unterstützt. Ich würde mich nicht darauf verlassen, dass Synology alle meine Endgeräte unterstützt und dazu auch noch meine Use-Cases.

**Updates im Bereich Foto/Video:**

Mein Eindruck ist, dass Synology auch relativ behäbig ist, was die Bereitstellung von Apps ist. Die Features sind dann nicht vollkommen ausgereift.

**Performance:**

Die Indizierung neuer Dateien dauert sehr lang ... natürlich ist die Synology Hardware nicht geeignet, um einer schnellere Indizierung vorzunehmen. Grundsätzlich stört das auch nicht, da es ja dann tagelang im Hintergund laufen kann. Es zeigt aber, dass die Lösung nicht optimal ist.

**Hot vs Schrott:**

Ich habe noch keine komfortable Möglichkeit, die Best-of-Inhalte (= Hot) zu selektieren, d. h. 95% ist Schrott und könnte gelöscht werden - die verbleibenden 5% sind aber wichtige Erinnerungen.

**FireTV Integration:**

Ist zwar möglich aber relativ langsam ... mein Eindruck ist auch, dass Synology nicht die Men-Power hat (oder auch Prioritäten) wie Großunternehmen wie Amazon, Google oder Apple. Für einen kleinen Anbieter decken sie aber ein so großes Spektrum an Funktionalität ab, dass die einzelnen Lösungen nicht Best-of sind.

---

## Anforderung - Cloud oder NAS?

> ENTSCHEIDUNG: Cloud

Wir sind nun schone viele Jahre in der Cloud (hauptsächlich mit Onedrive und 1und1 Cloud-Speicher). Die wichtigsten (persönlichen) Fotos/Videos haben wir allerdings auf dem NAS. Früher bestand gar keine Möglichkeit, die Datenmengen in die Cloud zu bringen. Mittlerweile haben wir aber 40 MBit/s Upload und in nächsten bekommen wir Glasfaser und damit die Möglichkeit, die Bandbreite weiter zu erhöhen.

Die Cloud ist einfach super komfortabel, wenn es

* um die Nutzung von verschiedenen Endgeräten (Laptops, Handy, Tablet, FireTV Stick) geht
* um einen mobilen Support ... mittlerweile arbeite ich nur noch im Home-Office und vielleicht werde ich auch mal eine Zeitland tatsächlich durch Europa fahren und nicht zuhause. 

### Auschließlich Cloud?

> ENTSCHEIDUNG: nein

Die Cloudanbieter sind professionell und machen ihren Job sicher besser als ich zuhause. Allerdings passieren auch dort Fehler und ich will auf jeden Fall einen Datenverlust verhinden ... die Erinnerungen sind mir einfach zu wichtig.

Aus diesem Grund möchte ich dennoch eine konsistente Kopie der Daten lokal verfügbar haben.

Das bedeutet nicht unbedingt, dass ein NAS gesetzt ist. Bei einem Onedrive Cloudspeicher werden die Daten evtl. auch verschiedenen Endgeräte synchronisiert, die als Sicherheit vielleicht ausreichen könnten.

Eine Synchronisierung ist ausserdem kein Backup. Lösche ich alle meine Daten aus Versehen, dann wird dieses Löschen auf alle Endgeräte angewendet => Daten weg.

Ich muss ehrlich aber auch zugeben, dass ich den Cloud-Anbietern hinsichtlich Feature-Support nicht traue. Ändern die ihr Konzept oder ihren Schwerpunkt, so kann das bei mir dazu führen, dass meine Anwendungsfälle nicht mehr passen. Das passiert leider immer wieder (habe ich gerade bei der [Abkündigung von Amazon Drive](https://www.reddit.com/r/photography/comments/znss6i/amazon_drive_shutting_down_where_to_migrate/?rdt=40187) mitbekommen) und sind dann halt Einzelschicksale, für die sich die Cloudanbieter nicht interessieren.

### Entscheidung - Cloud und NAS und Backup

Ich brauche weiterhin ein NAS als Fileserver mit Backup-Funktionalität. Ich brauche allerdings keinen Support für Multimedia oder Foto/Video-Bibliotheken.

---

## Anforderung - Schrott vs Schätze

Von den 100.000 Fotos sind wahrscheinlich nur 5-10% zu gebrauchen und wichtig für uns. Wir schauen häufig die alten Fotos/Videos an (über FireTV), haben aber immer noch keine Selektion vorgenommen und das reduziert den Spass am Schauen.

Es wäre optimal, wenn man beim Betrachten der Bilder gleichzeitig diese Selektion vornehmen könnte.

---

## Anforderung - Ordnerstruktur vs. Flat

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

### Tagging

> ENTSCHEIDUNG: manuelle Tags werden nicht benötigt

Früher hatte ich mal die Idee, ICMP-Tags in den Metadaten der Dateien zu pflegen. Ein Unterfangen, das viel zu aufwendig ist und für die es auch keine Tools für Massendaten gab. Für Videos gibt es ein solches Konzept nicht einmal.

Im Zuge der Artificial-Intelligence-Bewegung liefern das die Cloud-Anbieter bereits out-of-the-box und das wir in den nächsten Jahren eher besser als schlechter.

---

## Anforderung - Kosten

Cloud-Speicher kostet Geld ... ein NAS aber auch. Ich bin bereit ein bisschen Geld zu investieren, aber es sollte natürlich ein gutes Kosten/Nutzen-Verhältnis haben.

In meinem Fall brauche ich ein NAS und die Cloud, allerdings ein eher günstiges NAS, das mehr als Fileserver, denn als Multimedia-Server dient.

---

## Anforderung - API

Manchmal habe ich evtl. sehr spezielle Vorstellungen von MEINER Lösung, die von dem gewählten Cloud-Anbieter nicht oder irgendwann nicht mehr unterstützt werden.

Ich möchte also schon sehr gerne eine API, mit der ich Tools bei Bedarf selbst hinzufügen kann.

---

## Anforderung - Source-of-Truth

Ich präferiere einen gestandenen Cloud-Anbieter, der vermutlich auch in 10 Jahren noch existiert - kein Nischen-Anbieter.

Ich möchte ausserdem meine Dateien als Quelle behalten (= Source-of-Truth)... on-top möchte ich die Bilder aber schnell und komfortabel auf verschiedenen Endgeräten (Handy/Tablet, Fernseher, Laptop) betrachten können. Dieses Endrendering halte ich für relativ kurzlebig, d. h. was heute super funktioniert könnte in 2 Jahren gar nicht mehr gehen oder durch eine neue Lösung ersetzt werden. Letztlich bleiben nur die Dateien. Es ist daher wichtig, die Dateien auf ein Best-of-Minumum einzudampfen. Dann kann man schnell den Renderer wechseln.

> Bei Amazon Photos verliert man die Hoheit über die Dateien. Sie liegen irgendwo im Hintergrund. Niemand weiss, ob die Ordnerstruktur, die Dateinamen, die Tags, die Alben, die Originalqualität, ... erhalten bleiben. Aus diesem Grund kann eine solche Lösung nur ein Renderer sein, der das komfortable Browsing ermöglicht.

---

## Anforderung - Vendor Lock-In

Natürlich will dich jeder Cloud-Anbieter langfristig binden und damit ein Lock-In erzeugen. Für mich ist allerdings wichtig, dass ich IMMER an meine Raw-Daten komme und notfalls auf eine andere Lösung umziehen.

Mit dem Cloud-NAS-Ansatz ist das aber gegeben. Da ich kein manuelles Tagging mache und auch keine Ordnerstruktur mehr brauche, würde ich da auch nichts verlieren. Klar würde Aufwand entstehen, aber das wäre relativ unproblematisch.

---

## Anforderung - unterschiedliche Quellen

Meine Fotos/Videos kommen aus

* Handys
* Tablets
* Fotokamera
* Videokamera

Alle Endgeräten haben unterschiedliche Daten-Benennungen ... manche brauchbare, manche unterirdische. Ich muss garantieren, dass jedes Bild einen eindeutigen und sortierbaren Namen hat. Und das konsistent.

Aus diesem Grund scheiden automatische Uploads von den Endgeräten in meine Produktions-Landschaft aus. Als temporärer Speicher wäre es akzeptabel.

---

## Anforderung - Sicherheit

Meine Fotos/Videos sollen natürlich niemandem zugänglich sein. Sie müssen aber nicht unbedingt verschlüsselt gespeichert werden. Wenn ich mich entscheiden müsste zwischen komfortablem Betrachten oder höchste Sicherheit, dann würde ich mich für das komfortable Betrachten entscheiden.

---

## Konzept

* Sammlung der Fotos/Videos auf dem NAS - Temporärer Speicher lokal
  * teilweise automatisierte Uploads von den Endgeräten (in den Handys kein Problem)
  * (semi-) automatische Umbenennung der Dateien (Dateiname nach Timestamp, z. B. 20231231_170123.jpg)
  * früher habe ich die Fotos immer nich nach Exif-Header gedreht ... ich denke heutzutage wird das JEDER Bildbetrachter automatisch tun ... das sollte nicht mehr meine Aufgabe sein
  * Backup der Raw-Daten
* manueller oder automatischer Upload der Dateien in die Cloud - Temporärer Speicher Cloud
  * Selektion der Best-of
* Download der Best-of auf das NAS - Langfristiger Speicher lokal
  * Backup der Raw-Daten
* Upload der Favorites nach Onedrive - Langfristiger Speicher Cloud

---

## Cloud-Anbieter - Amazon Photos

### Kosten

Als Amazon Prime Kunde ist die unbegrenzte Speicherung von Fotos kostenlos ... nur Videos kosten den üblichen Cloudspeicher-Betrag (der scheinbar bei allen Anbietern nahezu identisch ist).

### Fotos anschauen

Die FireTV und Handy Apps zum Betrachten der Fotos/Videos sind sehr gut und haben auch Filter-Möglichkeiten. Die App ist sehr schnell und übersichtlich. Es werden unzähliche Foto/Video-Formate unterstützt, die ständig erweitert werden.

Über den FirteTV Stick kann man seine Best-of auch als Bildschirmschoner einstellen. Auf diese Weise könnte man einen Fernseher als Digitalen Bilderrahmen implementieren ... eine schöne Idee.

Die Amazon Echo Shows zeigen die Bilder in regelmäßigen Abständen an ... eine schöne Idee immer mal wieder in Erinnerungen zu schwelgen.

### Hot-vs-Schrott

Die FireTV-App bietet ein Favorite-Tagging (= Hot). Leider bieten Web-UI und Laptop-Uploader keine Selektions- und Download-Möglichkeit dieser Favorites.

Die Handy-App bietet diese Möglichkeit.

### Vendor-Lock-In

Mit hinterliegendem Amazon Drive war es problemlos möglich ALLE Dateien ohne Verlust der originären Dateinamen mit Ordnerstruktur zu exportieren. Allerdings pro Endgerät ... was mir nicht so gefällt an dem Ansatz.

Ich habe keine Ahnung was passiert, wenn Amazon-Drive ab 2024 nicht mehr existiert ... es gibt für Amazon Photos scheinbar auch keine API. Könnte sein, dass Amazon hier den Vendor-LockIn erhöhen will.

> Eigentlich nicht konsisten, dass AWS keine API anbietet, obwohl es im Business Bereich mit Amazon-Web-Services für alles eine API gibt. Das stärkt meinen Verdacht, dass Amazon hier die Kunden binden will.

### Fazit

Es besteht das Risiko eines Vendor-Lock-Ins. Allerdings ist das Amazon-Ecosystem auch grandios mit Hardware und Software. Das findet man bei fast keinem anderen Anbieter. Höchstens vielleicht noch Apple und dort ist der vendor-Lock-In noch größer.

---

## Cloud-Anbieter - Apple iCloud

Bei Multimedia würde ich grundsätzlich Apple eine hohe Professionalität aussprechen. Allerdings ist Apple für einen extremen Vendor-LockIn bekannt - mit dem Vorteil eines hohen Komforts ... allerdings nur, wenn man sich an die von Apple-unterstützten Use-Cases hält. Will man davon abweichen, kann es schwierig werden.

Aus diesem Grund ist Apple hier nicht mehr Favorit.

---

## Cloud-Anbieter - Microsoft OneDrive

Ich habe sowieso ein Office 365 Family Abo, das mit 6 x 1 TB Cloud-Speicher daherkommt. Die App zum Betrachten der Fotos/Videos ist sehr gut.

> Allerdings ist der Speicher auf 1 TB pro Account beschränkt ... man kann noch ein weiteres Terabyte für den üblichen Preis hinzukaufen

---

## Cloud-Anbieter - Google One

---

## Windows Fotos App

> ACHTUNG: es gibt dort eine ältere Version (Foto Legacy) und eine neuere. Unter Windows 10 hatte ich die Legacy installiert und beim Wechsel auf Windows 11 haben ich viele Features vermisst. Erst nach einer Recherche habe ich herausgefunden, dass die neue Version deutlich limitiert ist (= nicht zu gebrauchen ist) ... die alte aber weiterhin existiert.

Früher hatte ich mal ein Windows Programm namens Picasa verwendet, mit ich sehr gut klar kam. Microsoft Fotos scheint das nun zu ersetzen. Ein sehr gutes Programm scheint mir.

Sehr schnell und komfortabel zu bedienen. Ich habe ein Laptop-Tablet mit Touchscreen als Windows 11 Maschine ... damit könnte ich dann komfortabel auf der Couch, im Bett oder sogar unterwegs die Hot-vs-Schrott-Selektion durchführen.

### Hot-vs-Schrott

Über die App lassen sich Favoriten sehr leicht setzen und daraus ein Album machen, das die Fotos/Videos verlustfrei nach OneDrive synchronisiert.

> Seltsam ist, dass es ein Album "Favoriten" gibt, das allerdings keine Synchronisierung nach OneDrive anbietet. Man muss die Favoriten erst in ein separates Album exportieren und dort gibt es dann die Möglichkeit. Macht das Sinn, Microsoft?

Das schöne ist, dass die Markierung als Favorit dazu führt, dass in den Metadaten der Datei ein Rating mit 4 Sternen gesetzt wird. Die Favoriten-Selektion ist damit PERSISTENT in den Daten der Datei - das Ergebnis ist somit ganz unabhängig von Microsoft Fotos nutzbar - **KLASSE**. Das ist exakt mein Use-Case für Hot-vs-Schrott.

> Das bedeutet allerdings auch, dass Microsoft Fotos Schreibrechte auf die Datei haben muss. Das muss ich in meiner Gesamtlösung berücksichtigen!!!

Mit einer externen Festplatte hat die Selktierung von Favoriten nicht zuverlässig funktioniert. Manchmal hat es einfach nicht geklappt. Letztlich habe ich mich entschieden, die Fotos/Videos in Tranchen zu selektierung, da meine Laptop-Festplatte nicht groß genug für 1 TB Daten war. Das ist ok ... ich hätte allerdings die externe Festplatte bevorzugt.

Nach der Löschung eines Bildes oder ganzer Ordner oder der Änderung von Input-Sourcen waren diese weiterhin in der Vorschau (Thumbnails) sichtbar. Das hat zu großer Verwirrung geführt und das Programm unbrauchbar gemacht. Ich habe aus dem Programm keine Möglichkeit gefunden, die Quellen neu zu indizieren und die alten rauszuwerfen. Selbst eine Neuinstallation des Programms hat nicht geholfen. Über Windows Apps - Fotos - Reparieren konnte ich die Metadaten-Datenbank dann resetten. Sehr schwach, Microsoft.

### Cloud-Support

Die direkte Anbindung von OneDrive (iCloud wird scheinbar auch - zumindest rudimentär - supported) ist natürlich klasse. So könnte ich OneDrive als File-Cloud-Provider weiter nutzen.

### HEIC Support

In Windows 10 hat die App keinen HEIC Support, d. h. man kann keine HEICs/HEIVs als Favorit auswählen. In Windows 11 scheint es dafür ein komfortabel zu installierendes Plugin zu geben.

> Ich speichere auf meiner Synology keine HEICs/HEIVs, da DS Photos und auch andere Viewer damit Probleme haben (auch wenn ich dadurch Live-Photos verliere). Schon bei der Synchronisation vom Handy nach Synology via DS Photos werden die Fotos in JPEG umgewandelt. Somit ist das auch unter Windows 10 kein Problem für mich.

### Fazit

Microsoft hat im Ansatz ein tolles Programm. Wie man mit einer neuen Version (die unter Windows 11 auch noch der Default ist) die Funktionalität so einschränken kann ist mir ein Rätsel.

Ich war es zwischenzeitlich leid, das Programm reverse-engineeren zu müssen ... eigentlich sollte alles out-of-the-box funktionieren und intuitiv sein. Der nicht funktionierende externe Datenträger-Support ist mir vollkommen schleierhaft - gerade bei Fotos muss man doch damit rechnen, dass die nicht lokal vorliegen.

Ich habe nun - glaube ich (bis zur nächsten Überraschung) einen Weg gefunden, die Selektion Hot-vs-Schrott damit abzubilden. Langfristig muss ich aber dennoch eine andere Lösung finden ... wenn Microsoft nicht deutlich nachbassert.