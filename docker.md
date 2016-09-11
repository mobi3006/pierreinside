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

# Basics

Docker basiert auf Linux Containers. Linux Containers sind - wie der Name vermuten lässt - im Kernel (= Linux) verankert. Es ermöglicht den Aufbau virtueller Systemlanschaften in einem Linux-System ... beispielsweise sogar in einem Linux-Virtualisierunsgimage. Weitere Linux-Systeme (= Container) laufen im Linux-Wirt werden über Prozesse abgebildet. Diese Linux Container basieren zwingend auf dem gleichen Kernel ... man kann also einen Container nicht mit einem anderen Kernel laufen lassen.

Docker stellt komfortable Tools bereit, um

* Linux Images aus einem Dockerfile zu erzeugen - siehe [docker build](docker_build.md)
* basierend auf einem DockerImage lauffähige Instanzen (= DockerContainer) zu erzeugen - siehe [docker run](docker_run.md) 
* DockerContainer wieder zu einem Linux Image zu verpacken
* Docker Images zu teilen, um Docker-Container auf anderen Maschinen zu starten

Docker ist aber nur eine von vielen Möglichkeiten, Linux Containers zu nutzen. Auf dieser Seite geht es aber ausschließlich um Docker.

## Begrifflichkeiten

* **Linux Image**: Definition einer Umgebung in Form des Dockerfile (vergleichbar dem Vagrantfile bei Vagrant)
* **Linux Container**: laufendes Linux Image
  * Dockerhub:
    * Bereitstellung von Docker-Images (public, private)
    * automatische Image-Rebuilds wenn sich die im Image verbauten Quellen ändern (GitHub)

## Docker Hub
* https://hub.docker.com/

Dies ist ein DockerImage-Repository. Am besten legt man sich hier mal einen Account an.

DockerHub stellt auch Officzielle Images von Herstellern/Communities bereit (dennoch sollte man IMMER für sich die Frage beantworten WEM MAN VERTRAUT): https://hub.docker.com/explore/

---

# Grundsätzliches
## Container-ID vs. Container-NAME
Container haben eine ID und einen NAME ... in dieser Art:

* CONTAINER ID: 7c1c034d0b4a
* NAME: stoic_pare

Für menschliche Nutzer ist der NAME leichter zu verwenden als die ID ... beides identifiziert den Conatiner auf dem System aber eindeutig. Beim Start eines Images kann man dem zu erstellenden Container einen Namen geben:

``` 
docker run --name myname
```

Dann bekommt der Container eine ID und diesen Namen "myname". Gibt man keinen Namen an, dann vergibt Docker einen eigenen wie beispielsweise ``stoic_pare``.

## Alle Container verfügbar
Docker speichert alle jemals erstellten Container ... d. h. auch auf die nicht mehr laufenden Container hat man noch Zugriff. Über

```
docker ps -a
```

wird die Liste ALLER Container angezeigt (im Gegensatz dazu liefert ``docker ps`` nur die laufenden Container). 

## Container-Zwischenstände

---

# Befehle
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

# Docker und Vagrant
Benutzt man Docker innerhalb eines Vagrant-Images, so gibt es ein paar Besonderheiten.

## Port-Forwarding

Das Docker-Port-Forwarding muss für das Vagrant-Port-Forwarding nachgezogen werden, damit man vom Host auf die Ports zugreifen kann. Leider unterstützt Vagrant kein on-the-fly Port-Forwarding (zumindest habe ich noch nichts gefunden). Deshalb sollte man in diesem Fall aus Docker-Images immer mit einem festen Port (-p 5000:8080) und nicht mit einem zufälligen (-P)  weiterleiten. So kann man in Vagrant ein paar Ports per Default forwarden und die Docker-Image-Ports dann bei Bedarf auf diese Ports weiterleiten.  

---

# FAQ

**Frage 1:** Ich nutze Docker auf einem Ubuntu 16.04 LTS VirtualBox-Image. Leider habe ich keinen Internetzugriff aus dem Container heraus - innerhalb des VirtualBox-Images funktioniert alles wunderbar:

```
pfh@workbench ~/src/docker-glassfish/3_1_2_2 (git)-[master] % docker run -it --rm ubuntu apt-get update
0% [Connecting to archive.ubuntu.com]
```

**Antwort 1a:** 
Ich hatte in meinem Virtual-Box-Linux-System den DNS von VirtualBox angegeben:

```
pfh@workbench ~/% cat /etc/resolv.conf 
nameserver 127.0.1.1
```

Nachdem ich den auf den Unternehmens-DNS umgestellt hatte, war alles ok.

**Antwort 1b:**
Hänge ich ``--net=host`` an den Befehl, dann funktioniert es auch mit dem VirtualBox-DNS (``nameserver 127.0.1.1``).:

```
pfh@workbench ~/src/docker-glassfish/3_1_2_2 (git)-[master] % docker run -it --rm --net=host ubuntu apt-get update
```
**Antwort 1c:**
Vielleicht kann man da auch was in ``/etc/default/docker`` konfigurieren ...


