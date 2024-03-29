# Docker

* https://dzone.com/refcardz/getting-started-with-docker-1
* https://dzone.com/refcardz/java-containerization

Virtualisierung von Systemen ist schon lange eine tolle Sache, die ich auch für meine Linux Entwicklungsumgebung und mein ContentManagementSystem nutze. Auf diese Weise kann ich prima

* Spielsysteme aufsetzen
* ohne Gefahr Updates fahren (Image vorher clonen - dann updates ausprobieren)
* Snapshots machen (um einen Rücksprung zu haben) - wenn man sich das manuelle clonen sparen will
* Systeme portable machen
* Systeme komplett backupen

Hierzu verwende ich i. a. VirtualBox (früher auch mal VMWare) und mittlerweile auch [Vagrant](vagrant.md). Das hat bisher auch gut funktioniert und ich bin mit der Windows-Wirt/Linux-Images (u. a. für meine [Workbench](workbench.md)) sehr zufrieden. Dennoch gibt es ein paar Dinge, die mich stören:

* Backups bedeuten immer das Kopieren des kompletten Images (viele, viele Gigabyte) - das kostet Zeit und Plattenplatz
* will man nur mal was ausprobieren, dann ist clonen relativ umständlich - aufgrund der Imagegröße kann es erstens dauern und zweitens ist der SSD-Plattenplatz auch recht beschränkt
* der Memory-Overhead für ein OS ist recht hoch, wenn man davon nur ein oder zwei Services benötigt

**Ergo:** Virtualisierung über Images funktioniert gut, hat aber auch Nachteile - es ist eben schwergewichtig.

Eine leichtgewichtige Lösung sind *Linux Containers* ... Docker ist eine Implementierung dieses Konzepts. 

---

## Appetizer - what makes it sexy

* https://codefresh.io/blog/using-docker-generate-ssl-certificates/

Das schöne an Docker ist, daß ein Service (Applikation, Komponente) seine Dependencies bereits mitbringt, d. h. man ist nicht darauf angewiesen, daß auf dem auszuführenden System eine spezielle Java Version installiert ist ... weil der Service diese Java-Version einfach mitbringt. Das erhöht die Wahrscheinlichkeit, daß der Service tatsächlich auf dem Zielsystem in der Art und Weise läuft, in der er auch getestet wurde. Die Qualität für den Endanwender steigt.

Zudem muß das Zielsystem nicht verändert werden ... was die wenigsten Anwender wollen, wenn sie eine ihnen unbekannte Software installieren. Vor allem, wenn man eine Software nur mal ausprobieren will, dann möchte man sein System nicht verschmutzen. Zwei unterschiedliche Container können unterschiedlicher Versionen einer Dependency verwenden (z. B. Java 7 oder Java 8, Apache 2.2 oder 2.4). 

Hat man kein Java, Maven, Perl, Groovy, OpenSSL, ... auf einem System installiert, so kann man es über Docker-Container bereitstellen, ohne das Zielsystem zu verändern. Auf diese Weise kann man recht komplexe Toolings anbieten, die nach einem `git clone` einsatzfähig sind und keine Kompatibilitätsprobleme mit dem Zielsystem haben.

Die Installation kommt i. a. out-of-the-box (sofern die Image-Entwickler gute Defaults vorgesehen haben), was den Einstieg extrem vereinfacht. Die Installation ist Bestandteil des Images, aus dem ein Container hervorgeht. Man muß i. a. keine Dokumentation lesen, um einen Service zu starten. Die Konfiguration erfolgt zumeist über Volumes, die vom Docker-Host in den Docker-Container gemountet werden.

Die Docker-Engine abstrahiert außerdem vom Betriebssystem. Es spielt keine Rolle, ob der Container unter Windows 10, Ubunhtu, CentOS, MacOS, ... läuft. 

> In der Praxis habe ich zumindest mit Windows (Docker Toolbox, Docker for Windows) anfangs Probleme gehabt, weil die Architektur (Virtuelles Image mit einem Linux Betriebssystem) recht komplex und fehleranfällig war. Mittlerweile ist das deutlich besser geworden.

---

## Basics

Docker basiert auf Linux Containers. Linux Containers sind - wie der Name vermuten lässt - im Kernel (= Linux) verankert. Es ermöglicht den Aufbau virtueller Systemlanschaften in einem Linux-System ... beispielsweise sogar in einem Linux-Virtualisierunsgimage. Weitere Linux-Systeme (= Container) laufen im Linux-Wirt werden über Prozesse abgebildet. Diese Linux Container basieren zwingend auf dem gleichen Kernel ... man kann also einen Container nicht mit einem anderen Kernel laufen lassen.

Docker stellt komfortable Tools bereit, um

* Linux Images aus einem Dockerfile zu erzeugen - siehe [docker build](docker_build.md)
* basierend auf einem DockerImage lauffähige Instanzen (= DockerContainer) zu erzeugen - siehe [docker run](docker_run.md)
* DockerContainer wieder zu einem Linux Image zu verpacken
* Docker Images zu teilen, um Docker-Container auf anderen Maschinen zu starten

Docker ist aber nur eine von vielen Möglichkeiten, Linux Containers zu nutzen. Auf dieser Seite geht es aber ausschließlich um Docker.

### Begrifflichkeiten

* **Linux Image**: Definition einer Umgebung in Form des Dockerfile (vergleichbar dem Vagrantfile bei Vagrant)
* **Linux Container**: laufendes Linux Image
  * Dockerhub:
    * Bereitstellung von Docker-Images (public, private)
    * automatische Image-Rebuilds wenn sich die im Image verbauten Quellen ändern (GitHub)

### Docker Hub

* https://hub.docker.com/

Dies ist ein DockerImage-Repository. Am besten legt man sich hier mal einen Account an.

DockerHub stellt auch Officzielle Images von Herstellern/Communities bereit (dennoch sollte man IMMER für sich die Frage beantworten WEM MAN VERTRAUT): https://hub.docker.com/explore/

---

## Grundsätzliches

### Container-ID vs. Container-NAME

Container haben eine ID und einen NAME ... in dieser Art:

* CONTAINER ID: 7c1c034d0b4a
* NAME: stoic_pare

Für menschliche Nutzer ist der NAME leichter zu verwenden als die ID ... beides identifiziert den Conatiner auf dem System aber eindeutig. Beim Start eines Images kann man dem zu erstellenden Container einen Namen geben:

```bash
docker run --name my-container
```

Dann bekommt der Container eine ID und diesen Namen "my-container". Gibt man keinen Namen an, dann vergibt Docker einen eigenen wie beispielsweise ``stoic_pare``.

>ACHTUNG: sollte man mit benannten Containern arbeiten, dann werden nachfolgende ``docker run --name my-container`` dazu führen, daß KEIN neuer Container erstellt wird, sondern der alte einfach gestart wird!!! Möchte man dann einen neuen Container erzeugen, dann muß der alte zunächst gelöscht werden (``docker rm my-container``).

### Alle Container verfügbar

Docker speichert alle jemals erstellten Container ... d. h. auch auf die nicht mehr laufenden Container hat man noch Zugriff. Über

```bash
docker ps -a
```

wird die Liste ALLER Container angezeigt (im Gegensatz dazu liefert ``docker ps`` nur die laufenden Container).

### Container-Zwischenstände

Docker Re-Builds sind so schnell, weil die Zwischenzustände archiviert werden. Ändert sich am Dockerfile gar nichts, dann muß auch gar nichts geändert werden. Durch den Aufbau des ``Dockerfiles`` kann man den Build einerseit langsamer machen und sogar falsch.

Ein Beispiel:

```bash
RUN apt-get update
RUN apt-get install -y perl
```

So sollte man es nicht machen, weil das erste RUN einen Zwischenzustand A erzeugt und das zweite einen Zwischenzustand B. Ändert man nun das zweite RUN (z. B. in ``RUN apt-get install -y perl python``), dann würde auf dem Zustand A aufgesetzt und das ``RUN apt-get update`` würde nicht mehr ausgeführt. In diesen Container würde also ein evtl. veraltetes Python eingebaut.

Deshalb sollte man es so schreiben:

```bash
RUN apt-get update && apt-get install -y perl
```

### RUN vs. CMD vs. ENTRYPOINT

* [ENTRYPOINT und CMD - 1](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/)
* [ENTRYPOINT und CMD - 2](https://medium.com/the-code-review/how-to-use-entrypoint-with-docker-and-docker-compose-1c2062aa17a2)

> "The ENTRYPOINT specifies a command that will always be executed when the container starts. The CMD specifies arguments that will be fed to the ENTRYPOINT." ([von hier](http://stackoverflow.com/questions/21553353/what-is-the-difference-between-cmd-and-entrypoint-in-a-dockerfile))

Startet man also einen Container ohne expliziten Entrypoint, dann wird der im Image definierte Entrypoint- (`--entrypoint`) oder CMD-Kommando (als Parameter) automatisch ausgeführt. Ist keins von beiden definiert, so wird es zu einer Fehlermeldung `Error response from daemon: No command specified` kommen. ABER:

"Many of the Linux distro base images that you find on the Docker Hub will use a shell like /bin/sh or /bin/bash as the the CMD executable." ([von hier](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/))

Man kann aber auch beides definieren ... hä? Wann verwendet man was und warum?

* Folgende Statements kommen alle von [dieser exzellenten Quelle](https://www.ctl.io/developers/blog/post/dockerfile-entrypoint-vs-cmd/):
* "Given how much easier it is to override the CMD, the recommendation is use CMD in your Dockerfile when you want the user of your image to have the flexibility to run whichever executable they choose when starting the container."
* "In contrast, ENTRYPOINT should be used in scenarios where you want the container to behave exclusively as if it were the executable it's wrapping. That is, when you don't want or expect the user to override the executable you've specified."
* "Of course you can achieve this same thing with CMD, but the use of ENTRYPOINT sends a strong message that this container is only intended to run this one command."
* "Combining ENTRYPOINT and CMD allows you to specify the default executable for your image while also providing default arguments to that executable which may be overridden by the user."

### Docker Host Filesystem

Die Docker-Container verwenden das Filesystem des Docker-Host. Unter ``/var/lib/docker`` des Docker-Hosts findet man allerlei Dateien. Einige wichtiges Verzeichnisse (abhängig von der Docker-Konfiguration, d. h. nicht alle müssen immer existieren):

* `containers`
  * hier befinden sich u. a. die log-files, die der Docker-Container beim Schreiben auf die Console erzeugt
* `overlay2`
  * hier befindet sich das Filesystem des Docker-Containers ... will man sich also mal die Datei auf dem Docker-Container ansehen, dann muß man sich nicht per `docker exec -it ...` eine Terminal-Console aufmachen
* `devicemapper`

---

## Docker-Container Hooks

Häufig will man ein Image wiederverwenden, muß aber Anpassungen vornehmen, damit der Container auch in der gewünschten Weise funktioniert. Docker sieht hier verschiedene Ansätze für Hooks vor. Der Entwickler des Image entscheided darüber welche Hooks er anbietet ... in der Dokumentation sollte das eigentlich stehen ... zur Not muß man sich den Code (``Dockerfile``, ``ENTRYPOINT``, ``CMD``, ...) anschauen, um es rauszufinden.

### Umgebungsvariablen

### Volumes

### Entrypoint

* [Docker - Control startup order](https://docs.docker.com/compose/startup-order/)

---

## Befehle

Eine Auflistung aller Befehle erhält man per ``docker`` - per ``docker run --help`` bekommt man alle Parameter erklärt.

Hier jetzt nur ein paar Befehle:

* ``docker --help``
* ``docker <COMMAND> --help``
  * z. B. ``docker run --help``
* ``docker build -t <<IMAGE_NAME>>``
  * aus einem Dockerfile ein DockerImage erzeugen.
* ``docker run <<IMAGE_NAME>>``
  * Basierend auf einem DockerImage ein DockerContainer zu starten
  * **DER WOHL WICHTIGSTE BEFEHL**: ``docker run -it <<IMAGE_NAME/CONTAINER_ID>> bash``
    * so erhält man eine Console in dem gestarteten Container
* ``docker exec -it mysql bash``
   * eine Console auf dem laufenden (daemonized) Container öffnen
* ``docker stop``
  * docker stop a7708b93c390
* ``docker ps``
  * zeigt die auf dem System laufenden Container (nicht Images)
* ``docker ps -a``
  * zeigt alle auf dem System befindlichen Container (auch die gestoppten)
* ``docker rm a7708b93c390``
  * Löschen des Containers mit der ID a7708b93c390...
* ``docker rm $(docker ps -a -q)``
  * Löschen aller Container (egal in welchem Zustand)
*  ``docker images``
  * zeigt die auf dem System befindlichen Images
* ``docker search postfix``
  * sucht nach postfix Images auf dem Dockerhub
* ``docker inspect 579ea0eb412c`` oder ``docker inspect mysql``

---

## Docker und Vagrant

Benutzt man Docker innerhalb eines Vagrant-Images, so gibt es ein paar Besonderheiten.

### Port-Forwarding

Das Docker-Port-Forwarding muss für das Vagrant-Port-Forwarding nachgezogen werden, damit man vom Host auf die Ports zugreifen kann. Leider unterstützt Vagrant kein on-the-fly Port-Forwarding (zumindest habe ich noch nichts gefunden). Deshalb sollte man in diesem Fall aus Docker-Images immer mit einem festen Port (-p 5000:8080) und nicht mit einem zufälligen (-P)  weiterleiten. So kann man in Vagrant ein paar Ports per Default forwarden und die Docker-Image-Ports dann bei Bedarf auf diese Ports weiterleiten.

---

## Docker Hub

Docker Hub ist DAS Docker-Image-Repository.

Für GitHub User hat es den Charme, daß Builds über einen Hook automatisch gestartet werden, d. h.

* Docker Hub und GitHub hier vernetzen: https://docs.docker.com/docker-hub/github/
* im Docker-Projekt auf GitHub einchecken und direkt ein Docker-Image bauen lassen, das für jeden verfügbar ist

### tecnickcom/alldev - Schweizer Taschenmesser

* [Github](https://github.com/tecnickcom/alldev)
* [Docker Hub](https://hub.docker.com/r/tecnickcom/alldev)

---

## Fazit

Ich bin sehr begeistert von Docker (zumindest mal aus Sicht eines Softwareentwicklers).

Als größtes Problem, über das ich bisher gestolpert bin, empfand ich die Probleme mit den Permissions beim Zugriff auf Volumes. Das hat sowohl unter Windows als auch unter Linux nicht funktioniert ... vielleicht fehlt mir aber auch noch das notwendige Know-How - [siehe hier](docker_mysql.md).

---

## FAQ

**Frage 1:** Ich nutze Docker auf einem Ubuntu 16.04 LTS VirtualBox-Image. Leider habe ich keinen Internetzugriff aus dem Container heraus - innerhalb des VirtualBox-Images funktioniert alles wunderbar:

```bash
pfh@workbench ~/src/docker-glassfish/3_1_2_2 (git)-[master] % docker run -it --rm ubuntu apt-get update
0% [Connecting to archive.ubuntu.com]
```

**Antwort 1a:**
Ich hatte in meinem Virtual-Box-Linux-System den DNS von VirtualBox angegeben:

```bash
pfh@workbench ~/% cat /etc/resolv.conf
nameserver 127.0.1.1
```

Nachdem ich den auf den Unternehmens-DNS umgestellt hatte, war alles ok.

**Antwort 1b:**
Hänge ich ``--net=host`` an den Befehl, dann funktioniert es auch mit dem VirtualBox-DNS (``nameserver 127.0.1.1``).:

```bash
pfh@workbench ~/src/docker-glassfish/3_1_2_2 (git)-[master] % docker run -it --rm --net=host ubuntu apt-get update
```

**Antwort 1c:**
Vielleicht kann man da auch was in ``/etc/default/docker`` konfigurieren ...

**Frage 2:** 
Wo finde ich die Log-Files der Docker-Engine?

**Antwort 2:**
Das hängt stark von der verwendeten Linux Distribution ab. Unter meinem Ubuntu 16.04 LTS bekomme ich es per `journalctl -u docker.service`.