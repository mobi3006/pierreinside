# Synology 2021

Meine [DS112+](synology-ds112.md) ist im Jahr 2019 aus dem Support-Fenster ausgelaufen und erhält keine neuen Features mehr. Es wird nur noch Sicherheitsupdates geben - [DSM 6.2 ist die letzte Version](https://www.ifun.de/synology-dsm-6-2-1-die-letzten-updates-fuer-zahlreiche-alt-modelle-126579/) für meine ewig alte Synology.

Ich brauche weiterhin kein Raid, da Hochverfügbarkeit kein Kriterium ist und Raids kein Backup ersetzen - ich investiere lieber in eine zweite Festplatte, die als Backup-Speicher dient.

Relevante Geräte (J-Series scheidet für mich aus - meistens recht schwachbrüstig und ich möchte gerne wieder 6 Jahre Ruhe haben bis ich die nächste Lösung kaufe):

* 2 Bay
  * DS220+
    * 320 Euro
  * DS720+
* 4 Bay
  * DS420+
    * 485 Euro
  * DS920+

Im Sommer/Herbst 2020 ist die DS220+ erschienen, das Preis-Leistungs-Verhältnis erscheint mir am besten. Die DS218 kam im Dezember 2017 raus, die DS118 im Oktober 2017.

---

## Haupt-Einsatzgebiet

Ganz entscheidend ist, daß meine Lösungen weiter funktionieren ... [hier](https://stadt-bremerhaven.de/synology-photos-apps-fuer-android-und-ios/) kann man das vorab checken oder zumindest versuchen (der Teufel steckt ja dann immer im Detail).

* Fileserver
* Backup
  * lokal auf USB-Festplatte
  * remote auf günstigen Cloud-Speicher
* Foto-Sammlung ... Nutzung über Amazon Fire-TV
* Foto-Backup von den Handys

Eine neue DSM muß auch Lösungen für diese Anwendungsfälle liefern. Ich werde das Gefühl nicht los, daß ich alle meine Lösungen mit einer neuen Synology überdenken muss ... das hat mich damals viel Zeit gekostet - das will ich nicht wieder investieren müssen.

Vielleicht sollte ich einfach bei meiner alten DS112 bleiben ... mehr als diese Use-Cases nutze ich nicht und die funktionieren doch noch.

Hier ein paar relevante Reviews meine Einsatzbereiche betreffend:

* [nascompares.com](https://nascompares.com/synology-dsm-7-review-part-2-multimedia-backup-management/)
  * Fotos - [Video](https://www.youtube.com/watch?time_continue=930&v=KhFY5yMlujU&feature=emb_logo)

    > "Synology is still one of the only brands that have a 1st party application for Amazon Firetv (DS Video, DS Audio and DS Photo for Native NAS access from your sofa) as well as a 1st party application/skill for Amazon Alexa (DS Audio) for voice-activated audio playback.  They are all very good applications and still very much some of the best you will find in NAS in 2021/2022"

  * Backup im allgemeinen

    > "DSM 7 features ALL of the backup options that are available from Synology on DSM 6.2, as well as presenting them in a slightly tidier way. There are very few new features and functionality extras in DSM7 over DSM 6.2 (aside from how HybridShare integrates Synology C2 as an available storage area and the promised upgrades to Synology Drive/Active Backup for Mac OS later in DSM 7 development), but what is available is still very good indeed and scales well between home and business users. The original OG backup tool from Synology, Hyper Backup, is still very functional and covers a very wide range of backup targets/destinations ranging from local to cloud."

  * Hyper Backup

    > "The original OG backup tool from Synology, Hyper Backup, is still very functional and covers a very wide range of backup targets/destinations ranging from local to cloud. [...] However, Hyper Backup is still a VERY good tool and sits well in the hierarchy of Hyper Backup, Cloud Sync and Active Backup as your backup/sync demands scale-up."

  * Active Backup (u. a. nach Microsoft 365)

    > "I have praised Active Backup on DSM 6.2 numerous times and it continues to impress me in DSM 7. [...] Another feature of Active Backup is that it can be used to support your existing Microsoft Office 365 and/or Google Workspace (formally G-Suite) services (file hosting, accounts, shares, mail, etc) to not only sync and backup those remote services locally in a native way, but also to allow access to them when your internet connection is interrupted/suspended and then synchronize changes when internet connectivity is restored."

### Foto-Sammlung

Ich verwende bisher die App "DS Photo" auf Handy (Android, iOS) und FireTV ... das klappt mit Einschränkungen bei Videos (Codecs) super und ermöglicht uns, Erinnerungen aufzufrischen - die Kinder schauen gerne mit. Hierfür gibt es neue Apps:

* [iOS](https://apps.apple.com/app/id1484764501)
* [Android](https://play.google.com/store/apps/details?id=com.synology.projectkailash)

ABER:

> "95% Moments, 5% DS Photo Station. Hätte ich nur nicht auf DSM 7 gewechselt. Sämtliche Strukturen und sinnvollen Features der Photo Station sucht man hier vergebens. Man kann nur hoffen, dass hier schnellstmöglich Updates erscheinen, welche die simpelsten Funktionen der Photo Station ermöglichen. So fühlt es sich wie ein simplifiziertes Gadget an. Maximaler Frust, vor allem weil die Photo Station nicht mehr funktioniert" ([August 2021](https://play.google.com/store/apps/details?id=com.synology.projectkailash&showAllReviews=true))

Außerdem synchronisiere ich die Bilder der Handys per "DS Photo" auf die Synology - dabei erfolgt auch gleichzeitig eine Transformation von Apple-HEIC auf jpg ... denn HEIC wird von FireTV nicht unterstützt.

---

## 2-Bay vs 4-Bay

Macht es Sinn, einen 4-Bay zu verwenden, um dann mit einem Raid-5 günstigere Festplatten zu verwenden, um mehr Speicher zu haben. Beispiel - 6 TB Speicher sollen zur Speicherung zur Verfügung stehen:

* 2 Bay Variante - 510 Euro
  * DS220+ - 330 Euro
  * 4 x 2 GB Festplatten mit Raid-5 (1 Festplatte Redundanz) - 4 x 70 Euro = 280 Euro
* 4 Bay Variante - 800 Euro
  * DS420+ - 485 Euro
  * 2 x 3 GB Festplatten mit Raid-1 (gespiegelt) - 2 x 160 Euro = 320 Euro

Bei Festplattengrößen, die am oberen Ende liegen (12 TB) und dementsprechend relativ teurer sind macht es dann eher Sinn als bei diesen kleinen Festplattengrößen.

---

## Alternativen

Eigentlich bin ich mit meiner Synology sehr zufrieden - Fileserver, Backup und Foto-Sammlung sind die am meisten genutzen Features ... und die erfüllt sie hervorragend. Dennoch mache ich mich mal schlau, was die Alternativen zu bieten haben.

### Backup in die Cloud

Mittlerweile habe ich eine gute Internetanbindung mit 40 MBit/s Upload, so daß auch eine Cloud-Lösung in Frage kommt.

### Fotos in der Cloud

Bei Amazon Prime ist unbegrenzter Speicher für Fotos vorhanden ... irgendwie kann ich mich aber noch nicht durchringen meine Fotos und Videos einem Cloud-Storage-Anbieter anzuvertrauen. Ich weiß, daß ich hier nicht besonders konsequent bin.

---

## Migration

Die Neuanschaffung ist mit einer Migration verbunden ... und das nervt in aller Regel, weil das keinen Zusatznutzen bringt und meistens auch nicht problemlos vonstatten geht. Einer der Gründe warum mein DS112 so alt geworden ist (in der Cloud hätte ich diese Probleme wahrscheinlich nicht).

### Neue Festplatten

Die 2 GB Festplatte ist noch von 2013 ... da brauche ich unbedingt neue. 4 GB sollte ich hier schon nehmen. Allerdings brauche ich dann 3 Stück (1 + 1 in der Synology und 1 für das USB-Backup).

... vielleicht sollte ich ein verschlüsseltes Backup in die Cloud machen ... statt des USB-Backups.

### Fotos

* [Migration während DSM 6 => DSM 7 Upgrade](https://www.youtube.com/watch?v=L3L0rhqZCQY)

### Backups

... ich werde meine alte DS112 behalten und auch noch eine 1-2 Jahre nicht verändern => Backups müssen nicht unbedingt migriert werden.

---

## Entscheidung

... vertagt ... ich konnte mich nicht entscheiden