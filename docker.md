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

* Linux Images aus einem Dockerfile zu erzeugen
* basierend auf einem DockerImage lauffähige Instanzen (= DockerContainer) zu erzeugen 
* DockerContainer wieder zu einem Linux Image zu verpacken
* Linux Images zu verteilen, um auf anderen Maschinen Container davon zu starten

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

## Ausführungsmodi eines Containers

**Temporär:**
```
sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
``` 

Nachdem Hello world ausgegeben wurde, wird der Container auch gleich wieder gestoppt.

**Interaktiv:**
```
sudo docker run -t -i ubuntu:14.04 /bin/bash
```

anschließend landet man auf der Konsole des Containers ... und siehe da: es sieht aus wie ein typisches Linux-Filesystem. Ausschließlich am geänderten Prompt (z. B. ``root@aab3edb0b6f3:/etc#``) merkt man, daß die Shell scheinbar gewechselt wurde.

Wenn die Console (per exit oder Ctrl-D) verlassen wird, dann wird der Container auch gestoppt.

**Dämonized:**
```
sudo docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

---

# Grundsätzliches
## Container-ID vs. COntainer-NAME
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

---

# Eigene Images erzeugen
Für die Erzeugung eigener Docker-Images gibt es zwei Möglichkeiten:

1. basierend auf einem existierenden Docker-Image (z. B. von DockerHub) einen Container instanziieren. Am laufenden Container Änderungen vornehmen und vom Endergebnis ein neues Image ziehen. siehe https://docs.docker.com/engine/tutorials/dockerimages/#/creating-our-own-images

2. ein ``Dockerfile`` erzeugen, das die Bauanleitung für das Image darstellt - siehe https://docs.docker.com/engine/tutorials/dockerimages/#/building-an-image-from-a-dockerfile

Im ersten Fall kann man von außen nicht beurteilen, in welchem Zustand das Image ist (welche Änderungen wurden vorgenommen). 

Verwendet man hingegen ein Dockerfile kann jeder nachvollziehen welche Änderungen basierend auf einem Base-Image durchgeführt wurden.

## Dockerfile
Hat man ein ``Dockerfile`` erzeugt, dann baut man das entsprechende Image per

```
docker build -t mobi3006:myFirstDockerImage . 
```

aus dem Verzeichnis, in dem sich das ``Dockerfile`` befindet. In obigen Beispiel bekommt das Image den Namen ``myFirstDockerImage``. Unter diesem Namen kann es dann beispielsweise per

```
docker run myFirstDockerImage
```

gestartet werden.

### Fehlersuche - letzten erfolgreichen Zustand herstellen
Natürlich geht nicht immer alles glatt bei der Erstellung eines Docker-Images aus einem ``Dockerfile``. Gelegentlich kommt es zu Abbrüchen und man muß rausfinden warum der Build abgebrochen ist:

```
pfh@workbench ~/src/de.cachaca.learn.docker % docker build -t mobi3006:myFirstDockerImage .
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM python:2.7
 ---> 6b494b5f019c
Step 2 : ADD . /code
 ---> 84a8af1f094d
Removing intermediate container de191afbd859
Step 3 : WORKDIR /code
 ---> Running in cc10315026b0
 ---> ba40591c8dc8
Removing intermediate container cc10315026b0
Step 4 : RUN pip install redis
 ---> Running in 8d81897ba9aa
Collecting redis
  Retrying (Retry(total=4, connect=None, read=None, redirect=None)) after connection broken by 
 'NewConnectionError('<pip._vendor.requests.packages.urllib3.connection.VerifiedHTTPSConnection object at 0x7f0a56258810>: 
  Failed to establish a new connection: [Errno -2] Name or service not known',)': /simple/redis/
```

Docker hier im Hintergrund einen Docker-Container, der über die Kommandos aus dem ``Dockerfile`` verändert wird. Nach jedem erfolgreichen Kommando wird der vorhergehende Container gelöscht. Schlägt ein Komando fehl, dann kann man den Container in dem letzten erfolgreichen Zustand (in obigem Fall der Containerzustand) besuchen:

```
docker run --rm -it ba40591c8dc8 bash -il
```

um daurauf dann die Fehleranalyse zu machen. Man wiederholt dann beispielsweise den fehlgeschlagenen Befehl.

### Fehlersuche - Zugriff auf fehlerhaften Zustand erhalten
Will man den Zustand des Containers nach dem fehlerhaften Kommando erhalten, so muß man zunächst die Container-ID rausfinden:

```
docker ps -a
```
und dann ein Commit ausführen, um den Zustand zu persistieren:


im Fehlerfall Eine andere Variante ist 

```
pfh@workbench ~/src/docker-glassfish/3_1_2_2 (git)-[master] % docker ps -a
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES

7c1c034d0b4a 784650b6da23 "/bin/sh -c 'wget htt" 49 minutes ago Exited (4) 49 minutes ago stoic_pare

37664f444f8a 784650b6da23 "/bin/sh -c 'wget htt" 53 minutes ago Exited (4) 52 minutes ago backstabbing_kalam

2c3fb351f200 gessnerfl/glassfish:3.1.2.2 "sh /opt/deploy.sh" 4 hours ago Exited (137) About an hour ago glassfish



## Dockerfile Best-Practices
* https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
* Containers should be ephemeral:  
  * man kann sie einfach wegwerfen und ersetzen
* Run only one process per Container
* mach das Image so schlank wie möglich

> Mit Alpine Linux gibt es ein Linux Image, das nur 5 MB groß ist und somit bestens geeignet ist, wenn man ein minimales Docker-Image aufbauen will - natürlich muss man dann um so mehr Packages manuell nachinstallieren.

---

# Docker und Vagrant
Benutzt man Docker innerhalb eines Vagrant-Images, so gibt es ein paar Besonderheiten.

## Port-Forwarding

Das Docker-Port-Forwarding muss für das Vagrant-Port-Forwarding nachgezogen werden, damit man vom Host auf die Ports zugreifen kann. Leider unterstützt Vagrant kein on-the-fly Port-Forwarding (zumindest habe ich noch nichts gefunden). Deshalb sollte man in diesem Fall aus Docker-Images immer mit einem festen Port (-p 5000:8080) und nicht mit einem zufälligen (-P)  weiterleiten. So kann man in Vagrant ein paar Ports per Default forwarden und die Docker-Image-Ports dann bei Bedarf auf diese Ports weiterleiten.  

---




