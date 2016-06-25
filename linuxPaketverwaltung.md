# Linux-Paketverwaltung

Ein Paketmanagement-Tool führt die Installation und Deinstallation von Software auf Basis der Paketbeschreibungen (hier sind vom Paket-Maintainer u. a. Abhängigkeiten beschrieben) durch. Es sorgt dafür, dass Dateien bei der Installation in den richtigen Verzeichnissen landen und dass evtl. benötigte andere Ressourcen mitinstalliert werden. Bei der Deinstallation sollen alle Ressourcen entfernt werden, die nur von dem zu deinstallierenden Paket genutzt werden. Ressourcen, die vielleicht bei der Installation des zu entfernenden Pakets automatisch mitinstalliert wurden können nur dann auch entfernt werden, wenn sie von keinem anderen Tool gebraucht werden. Kurz:

> Das Paketmanagement-Tool sorgt trotz Änderungen am System durch Installation und Deinstallation von Software immer für ein lauffähige System.

Das größte Problem sind die Abhängigkeiten. So kann es passieren, daß bei der Installation eines Programms ``lib1.3`` gebraucht wird, auf dem System ist aber nur ``lib0.9`` vorhanden. In diesem Fall muss ``lib0.9`` durch ``lib1.3`` ausgetauscht werden. Man muß hoffen/beten, dass die Programme, die bisher auf ``lib0.9`` liefen, jetzt auch mit ``lib1.3`` laufen (bei einem Major-Releasewechsel 0.x -> 1.x ist das keine Selbstverständlichkeit. Ein komfortables Paketmanagement-Tool löst Abhängigkeiten automatisch auf.

Solange die Installation über das Paketmanagement-Tool erfolgt, können diese Informationen konsistent in einer Datenbank abgelegt und abgefragt werden. Installiert man allerdings Programme per Hand (z. B. durch Compilierung des Tar-Balls) ist die Sache schrieriger bis unmöglich :-(

Für die Debian-Distribution gibt es auch sog. Tasks, die viele Einzelpakete zusammenfassen. Will man beispielsweise den Gnome-Desktop verwenden, so kann man einfach die Task ``task-gnome-desktop`` installieren.

Eine Stärke von ``apt`` ist es, daß Software aus verschienden Branches (stable, testing, unstable) verwendet werden kann.

Das Debian-Paketsystem (vielleicht auch andere) vergibt für Pakete auch virtuelle Namen (sog. virtuelle Pakete). Auf diese Weise ist es beispielweise möglich, die Funktion eines ``mail-tranfer-agents`` durch ``mutt``, ``smail``, ``sendmail`` oder ``qmail`` abzubilden. Dadurch ist der Benutzer nicht gezwungen einen speziellen Mail-Tranfer-Agent einzusetzen, sondern es genügt irgendeiner (der sich vielleicht schon auf dem System befindet, weil er von anderen Paketen genutzt wird). In der Software-Enwticklung würde man das als Interface bezeichnen, mit der Möglichkeit zum Zeitpunkt des Deployments verschiedene Implementierungen zu verknüpfen.

---

# dpkg
Das erste Debian-Paketverwaltungs-Tool. Es kann Debian-Pakete (*.deb) verarbeiten.

* ``dpkg search /etc/yp.conf``
  * Liefert Informationen darüber, welches Paket die Datei yp.conf angelegt hat bzw. verwendet

---

# dselect
Menügesteuertes textbasiertes Frontend für Debian-Systeme. Bis Version Debian GNU/Linux 2.2 state-of-the-art. Danach durch ``apt-get`` und ``aptitude`` abgelöst, aber jetzt noch immer verfügbar.

Der Nachfolger von dpkg kann Paketabhängigkeiten automatisch auflösen.

dselect steht für *debian select* (Selektion von Programm-Paketen)

---

# apt-get

* http://www.debian.org/doc/manuals/debian-tutorial/ch-dpkg.html
* Debian-Pakete suchen: http://apt-get.org/
* Linux-User: http://www.linux-magazin.de/Artikel/ausgabe/2002/07/apt/apt.html

Ein weiteres Debian-Paketverwaltungs-Tool (**A** **P**ackage **T**ool - seit Version 3.0), das einen Wrapper um ``dpkg`` herum darstellt. ``apt-get`` kann selbst keine deb-Pakete verarbeiten, sondern benutzt dazu ``dpkg``. Der normale Benutzer muss gar nicht mehr auf ``dpkg`` zurückgreifen, sondern kann die apt-get-Tools verwenden. Im Gegensatz zu ``dpkg`` löst ``apt-get`` Abhängigkeiten automatisch auf, was die Installation natürlich erheblich vereinfacht.

Die ``apt-get`` Befehle funktionieren gut über Auto-Vervollständigung (mit der <Tab>-Taste).

Die Mächtigkeit und Eleganz von *apt* haben auch andere Distributionen erkannt und somit ist es auch unter RPM-basierten Distributionen wie RedHat und SuSE nutzbar. Viele RPM-Pakete lassen sich per apt installieren ([siehe hier](http://freshrpms.net/apt/repositories.html)).

## Befehle

### apt-get

* ``apt-get clean``: 
  * Bei der Installation neuer Pakete werden diese zunächst aus dem Internet auf die lokale Platte runtergeladen und dann installiert. Die Pakete verbleiben auf der Platte (sofern nicht andere Massnahmen ergriffen werden) und verbrauchen natürlich unnötig Platz. Ein clean entfernt die Pakete und schafft somit Platz :-)
* ``apt-file search httpd.conf``: 
  * Sucht nach Paketen, in denen die Datei ``httpd.conf`` vorhanden ist, d. h. benötigt wird. Das funktioniert auch mit Dateien, die gar nicht installiert sind.
* ``apt-get build-dep apache``: 
  * Die meisten Softwarepakete benötigen bei der Übersetzung aus den Quellpaketen weitere Entwicklungspakete wie Libraries und Header-Dateien. Diese werden häufig nicht mitgeliefert und liegen in gesonderten Paketen vor. Das Debian-Paketsystem sieht so genannte *build dependencies* vor, in denen alle Abhängigkeiten zur Erzeugung eines Pakets beschrieben sind. Das Kommando ``apt-get build-dep paketname`` sorgt dafür, dass alle zur Übersetzung eines Pakets benötigten Dateien auf dem System vorhanden sind.
* ``apt-get check``: Prüft die installierten Pakete auf Korrektheit, d. h. sind alle Abhängigkeiten erfüllt und wurde das Paket ordnungsgemäß konfiguriert
* ``apt-get dist-upgrade``: 
  * Upgrade von einem Debian-Release (z. B. von 2.2 auf 3.1). Man kann so auch beispielsweise von stable Branch auf testing oder von testing auf unstable wechseln. **ABER ACHTUNG:** ein Wechsel zurück ist nicht möglich - wenn man also aus gutem Grund im stable Branch war, dann sollte man sich das gut überlegen.
* ``apt-get install apache``: 
  * Installation des neuesten (gemäss ``/etc/apt/sources.list``) Pakets von ``apache`` (hier stellvertretend für beliebige Pakete). Es werden alle Abhängigkeiten aufgelöst (sofern möglich), d. h. alle notwendigen weiteren Pakete werden auch installiert. Es können auch spezielle Versionen installiert werden - näheres siehe man-pages. Werden dabei Fehler gemeldet, so kann man das Problem oftmals beheben, indem man apt anweist per Option ``-f`` (fix [broken dependencies]: ``apt-get -f install apache``), das Problem selbst zu beheben. Sollte das nicht gelingen muss man die Basis-Tools ``dselect`` oder ``dpkg`` anwenden, um die Probleme manuell zu lösen (meistens durch löschen von Paketen per ``dpkg --remove xyz``) und anschliessend mit ``apt-get`` einen erneuten Versuch zu starten.
* ``apt-get -t unstable install firefox``
  * hiermit kann der Default Branch (/etc/apt/apt.conf) überschrieben und die Installation der unstable-Version erzwungen werden. Auf diese Weise konnte ich bei einem Testing-Default-Branch mit aktuell installiertem Firefox 1.0.6 und im Testing-Zweig nur 1.0.7 verfügbarem Firefox die Installation der Version 1.5 aus dem Testing-Zweig erzwingen.
* ``apt-get -u install apache``
  * hier wird zusätzlich eine Liste der upzugradenden Pakete angegeben
* ``apt-get remove apache``
  * Umkehrfunktion zu install. **ACHTUNG:** die Konfigurationsdateien (hier: von Apache) bleiben auf dem System - sollen die auch verschwinden, dann muss man die Option ``--purge``s verwenden
* ``apt-get source apache``
  * Holt die Source Dateien zum Paket ``apache`` in der Version, die in der apt-Datenbank als aktuellste hinterlegt ist (vorher evtl. ein machen). Hierzu muss sich aber in ``apt-get update/etc/apt/sources.list`` mind. ein ``deb-src`` Eintrag befinden. Evtl. muss man noch weitere notwendige Sourcen holen (siehe Kommando ``apt-get build-dep``)
* ``apt-get update``
  * aktualisiert die Paket-Informationen basierend auf der Konfiguration in ``/etc/apt/sources.list``. Dabei werden die neuesten Paketinformationen aus den Package.gz-Dateien von den Paket-Servern in die apt-Datenbank geladen. Die Installation eines Pakets basiert immer auf diesen Informationen, so dass man vor einem install auf jeden Fall ein update dieser Informationsdatenbank durchführen sollte.
  * Die Paketinformationen liegen bei (Knoppix-) Debian unter ``/var/lib/apt/lists`` und können mit einen normalen Editor angezeigt werden. Weitere interessante Verzeichnisse (die mir aber noch nicht ganz klar sind) sind:
    * ``/var/cache/apt``
      * im Verzeichnis archives werden die runtergeladenen Pakete zwischengelagert, die mit einem apt-get clean gelöscht werden
    * ``/var/cache/apt-show-versions`` 
* ``apt-get upgrade``
  * Aktualisiert alle Pakete auf den neuesten Stand (gemäss ``/etc/apt/sources.list``). Vorher muss ein ``apt-get update`` erfolgen. **ABER:** benötigt ein upzugradendes Paket ein Upgrade eines anderen Pakets, dann sorgt der upgrade-Befehl nicht für dessen automatische Installation, sondern das Upgrade wird nicht durchgeführt. Insofern ist upgrade nur für kleinere Upgrades (z. B. Security-Patches) nützlich. Für größere Anpassungen muss man ``dist-upgrade`` nehmen.

### apt-key
Softwareinstallationen sollten generell nur von vertrauenswürdigen Quellen erfolgen, sonst kann Schadsoftware das System komprimittieren (z. B. Trojaner). Werden neue Quellen hinzugefügt, muß noch explizit angegeben werden, daß dieser Quelle und somit der davon bereitgestellten Software vertraut wird.

* ``apt-key list``
  * welchen Quellen wird bereits vertraut
* ``apt-key add 

### apt-cache
* ``apt-cache depends apache``: 
  * Gibt die Abhängigkeiten des Pakets apache von anderen Paketen aus
* ``apt-cache policy apache``: 
  * Welche Versionen von apache sind wo verfügbar. Hier sieht man die Branches sehr schön.
* ``apt-cache show apache``: 
  * Gibt die Beschreibung des Pakets apache aus
* ``apt-cache showpkg apache``: 
  * Anzeige der in den verschiedenen Distributionen/Branches verfügbaren Versionen und zeigt die Pakete an, die vom Paket  ``apache`` abhängig sind (also ``apache`` benötigen, um laufen zu können)
* ``apt-cache stats``: 
  * Cache-Statistik - wieviele Pakete sind vorhanden, ...

### apt-setup
apt-setup ist ein Tool zur Bearbeitung der Datei ``/etc/apt/sources.list``.

### apt-spy
* ``apt-spy -d testing``
  * Prüft alle zum angegebenen Branch/Distribution vorhandenen Mirrors (http://http.us.debian.org/debian/README.mirrors.txt) auf Downloadgeschwindigkeit und trägt die schnellsten in die Dateie ``/etc/apt/sources.list`` ein

---

# Wichtige Konfigurationsdateien
* ``/etc/apt/*``
* ``/etc/apt/apt.conf``
  * hier steht das Default-Release (stable, testing, unstable) drin. Eine typische Datei sieht folgendermassen aus:

```
APT::Default-Release "testing";
APT::Cache-Limit 20000000;
Apt::Get::Purge;
```

* ``/etc/apt/sources.list``
  * steuert woher Pakete geladen werden, d. h. aus welchem Release, welcher Distribution und von welchem Server. Weiter oben stehende Einträge haben höhere Priorität. Weitere Informationen per ``man 5 sources.list``.
Will man nicht die aktuellste Version eines Pakets , sondern die Version zu einem bestimmten Zeitpunkt, dann muss man auf http://snapshot.debian.net ausweichen, wo sich auch ältere Debian-Pakete befinden. Beispiel:


    deb http://snapshot.debian.net/archive/YYYY/MM/DD/debian unstable main contrib non-free


Will man die Datei nicht manuell editieren, so kann man auch das Tool ``apt-setup`` verwenden

---

# Alternativen zum CLI

* ``aptitude``: 
  * Menügesteuertes textbasiertes Frontend für ``apt-get``. Eine sehr nützliche Eigenschaft dieses Programms sind die Informationen beim Start des Programms. Insbesondere die Sicherheitsaktualisierungen sind sehr nützlich, um die wichtigsten/aktuallsten Patches einzuspielen:
    * Sicherheitsaktualisierungen
    * Aktualisierbare Pakete
    * Neue Pakete
    * nicht installierte Pakete
    * veraltete und selbst erstellte Pakete
* ``kpackage``: Grafisches Frontend für apt-get

--- 

# RPM - Redhead Paket Management

Ursprünglich für die Redhead Distribution entwickeltes Paketverwaltungstool. Wurde später auch von SuSE und anderen Distributionen (???) verwendet.

## Organisation

Man spezifiziert - beispielsweise per ``yast`` - einige Repositories, aus denen die aktuellen Paketinformationen und - bei Bedarf (also wenn man die Software installieren oder updaten möchte) - dann auch die Pakete kommen.

## Wichtige Befehle

* ``rpm -ivh mypackage.rpm``
  * Installation eines Pakets
  * ``i`` = install
  * ``v`` = verbose
  * ``h`` = Ausgabe eines Fortschrittsbalkens
* ``rpm -e orarun-1.9-52``
  * Entfernen des Pakets ``orarun-1.9-52``
* ``rpm -qa``
  * Welche Pakete sind installiert?
  * ``q`` = query
  * ``a`` = all
* ``rpm -ql cpp``
  * Welche Dateien bringt ein Paket aus dem Repository mit?
  * ``l`` = list
* ``rpm -qlp orarun.rpm``
* ``rpm -qf /usr/bin/free``
  * Welches Paket hat die Datei ``/usr/bin/free`` mitgebracht?

## Zypper
Zypper ist ein auf RPM aufsetzendes Tool, das eine ähnliche Syntax wie ``apt-get`` hat. Zypper wird auch als CommandLineInterface für Yast verstanden, was man schon allein daran sieht, daß beide Tools die gecachten (=lokalen) Repository Informationen an der gleichen Stelle ablegen ... unter ``/var/cache/zypp``.

Die Installation von Paketen funktioniert so:

    zypper install libaio-devel

### Organisation

Da Zypper auf RPM aufsetzt, wird auch die per Yast durchgeführte Repository-Konfiguration verwendet. Hat man die Repositories beispielsweise per ``yast``, ``rpm``-Befehlen oder ``zypper``-Befehlen konfiguriert, dann findet man die konfigurierten Repositories in ``/etc/zypper/repos.d``. Neben den URLs befinden sich in diesen Files auch Angaben wie ``autorefresh``, ``enabled``, ... Diese Informationen kann man aber auch über ``zypper``-Kommandos abfragen (z. B. ``zypper repos --uri``).

Vor einem System-Update (Update aller installierten Pakete - auch Kernel und andere Systemnahe Komponenten wie beispielsweise ``grub``) sollte man auf jeden Fall ein Update der Metadaten machen (sofern das nicht automatisch geschieht). Die Metadaten werden vom Server gezogen und lokal unter ``/var/cache/zypp`` abgelegt. Zunächst im raw-Format, dann werden sie aber per

    repo2solv.sh 
      -o /var/cache/zypp/solv/REPO_NAME/solv /var/cache/zypp/raw/REPO_NAME

in ein resolvtes Format umgewandelt. Ich hab keine Ahnung worin der Unterschied genau besteht - aber ich vermute folgendes:
* der Server liefert die Daten in Form von xml-Files (RAW-Daten), die dann zwecks besserer/schnellerer Auswertung in ein Binärformat (SOLV) transformiert werden. Das resolvte Format wird allerdings erst erstellt, wenn man ein Online-Update anstösst (nicht bei einem Repository Update/Refresh - hier werden nur die RAW-Daten neu geholt).

Die Verzeichnisstruktur sieht also folgendermassen aus (alles was in ``/var/cache/zypp`` drin ist kann man bedenkenlos wegwerfen, dann man kann es jederzeit wieder neu von den Servern ziehen und neu aufbauen, wenn man eine Netzwerkverbindung hat):

    /var/cache/zypp:
      raw/
        REPO1
            repodata
                repomd.xml: mit Referenzen auf gezippte Metadaten zu den Paketen
                211298382173...-suseinfo.xml.gz
                814818922118...-deltainfo.xml.gz
                892177129231...-updateinfo.xml.gz
                128974123899...-appdata.xml.gz
        REPO2
        ...
      solv/

          REPO1
          REPO2
          ...

Die Repository XML-Metadaten landen im ``raw``-Verzeichnis, die binäre Repräsentation im ``solv`` Verzeichnis.

### Wichtige Befehle

* http://en.opensuse.org/images/1/17/Zypper-cheat-sheet-1.pdf

* ``zypper repos --uri``
  * welche Repositories sind spezifiziert und mit welcher URL
  * alternativ: ``zypper lr -u``
* ``zypper addrepo
  * ein Repository hinzufügen
  * ``zypper addrepo --name coreUpdate http://download.opensuse.org/update/12.3/ coreUpdate``
* ``zypper clean --all``
  * alle gecachten Repository Informationen Löschen (liegen in ``/var/cache/zypp``)
* ``zypper refresh``
  * Repository Cache aktualisieren
