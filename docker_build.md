# Docker Build

Für die Erzeugung eigener Docker-Images gibt es zwei Möglichkeiten:

1. basierend auf einem existierenden Docker-Image (z. B. von DockerHub) einen Container instanziieren. Am laufenden Container Änderungen vornehmen und vom Endergebnis ein neues Image ziehen. siehe https://docs.docker.com/engine/tutorials/dockerimages/#/creating-our-own-images

2. ein ``Dockerfile`` erzeugen, das die Bauanleitung für das Image darstellt - siehe https://docs.docker.com/engine/tutorials/dockerimages/#/building-an-image-from-a-dockerfile

Im ersten Fall kann man von außen nicht beurteilen, in welchem Zustand das Image ist (welche Änderungen wurden vorgenommen). Außerdem ist das auch nicht gut reproduzierbar ... manuelles Anpassen statt Automatisierung wird gefördert. Deshalb sollte man das vermeiden!!!

Verwendet man hingegen ein Dockerfile kann jeder nachvollziehen welche Änderungen basierend auf einem Base-Image durchgeführt wurden. Man kann hier die üblichen Verfahren wie Code-Reviews, Build-on-Change, ... verwenden.

> "5) Don’t create images from running containers – In other terms, don’t use “docker commit” to create an image. This method to create an image is not reproducible  and should be completely avoided. Always use a Dockerfile or any other S2I (source-to-image) approach that is totally reproducible, and you can track changes to the Dockerfile if you store it in a source control repository (git)." ([10 things to avoid in docker containers](https://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/))

Im übrigen wird beim `docker build` nichts anderes gamacht als einzelne Container erzeugt (und wieder weggeworfen), auf denen die `Dockerfile`-Anweisungen ausgeführt werden. Insofern handelt es sich um einen automatisierten Option-1 Prozess.

---

## Dockerfile

* [MUST-READ - Best practices for writing Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
* [MUST-READ - Dockerfile Best practices](https://docs.docker.com/v17.09/engine/userguide/eng-image/dockerfile_best-practices/#expose)
* [MUST-READ - 9 Common Dockerfile Mistakes](https://runnable.com/blog/9-common-dockerfile-mistakes)
* [MUST READ - 10 things to avoid in docker containers](https://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/)

Hat man ein ``Dockerfile`` erzeugt, dann baut man das entsprechende Image per

```bash
docker build -t mobi3006/myFirstDockerImage .
```

aus dem Verzeichnis, in dem sich das ``Dockerfile`` befindet.

> `.` ist in diesem Fall der sog. Build-Context

In obigen Beispiel bekommt das Image den Namen ``myFirstDockerImage``. Unter diesem Namen kann es dann beispielsweise per

```bash
docker run myFirstDockerImage
```

gestartet werden. Das Image befindet sich damit aber nur in der lokalen Registry - in vielen Fällen wird man die Images zentral bereitstellen wollen und muß das Images per `docker push ...` noch registrieren

### Was beim Build passiert

Der Build eines Images besteht darin, basierend auf dem Base-Image (``FROM mysql``) einen Container zu instanziieren und darauf die Anweisungen aus dem Dockerfile auszuführen. Nach jedem erfolgreichen Step hat man einen neuen Containerzustand und der wird in ein (Intermediate-) Image committet (z. B. mit den seltsamen Namen ``d799d66c1d0b``).

> "Only the instructions RUN, COPY, ADD create layers. Other instructions create temporary intermediate images, and do not increase the size of the build." ([Dockerfile-Best-Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/))

Die Layer kann man sich übrigens per `docker history myFirstDockerImage` anschauen.

> "Next you can see each instruction in the Dockerfile being executed step-by-step. You can see that each step creates a new container, runs the instruction inside that container and then commits that change - just like the docker commit work flow you saw earlier. When all the instructions have executed you’re left with the 97feabe5d2ed image (also helpfuly tagged as ouruser/sinatra:v2) and all intermediate containers will get removed to clean things up." (https://docs.docker.com/engine/tutorials/dockerimages/)

Bei erfolgreichem Build sorgt der letzte Commit (= aktueller Zustand des Containers wird in ein Image persistiert) dafür, daß das Image den angegebenen sprechenden Namen erhält (z. B. ``mysql:5.7``).

> Beim Start eines solchen Images ist dann schon alles vorbereitet und als oberster [Layer](https://docs.docker.com/storage/storagedriver/) wird ein writable Layer gesetzt, so daß man im Container Veränderungen vornehmen kann.

Docker Images können schon mal groß werden - deshalb versucht man mit dem Layered-Filesystem eine Optimierung der Artefakte. Das zahlt sich nicht nur im Speicherverbrauch der Images aus, sondern auch beim Download durch die Nutzer der Images. Somit können Docker Container schneller gestartet werden, auch wenn sie vermeintlich groß sind und noch nicht lokal zur Verfügung stehen.

Ein Docker-Build kann sehr schnell sein, denn durch die Versionierung der einzelnen Steps, müssen nur noch die geänderten Steps neu durchgeführt werden. Ändert sich nichts, dann wird auch nichts getan ... im Build sieht man das am `Using cache`:

```log
Step 3/13 : ENV MAVEN_HOME /usr/share/maven
 ---> Using cache
 ---> 704681550aa8
```

Von dieser Optimierung muß man wissen, wenn man ein `Dockerfile` schreibt, denn

> "Another issue is with running apt-get update in a different line than running your apt-get install command. The reason why this is bad is because a line with only apt-get update will get cached by the build and won't actually run every time you need to run apt-get install. Instead, make sure you run apt-get update in the same line with all the packages to ensure all are updated correctly." ([9 Common Dockerfile Mistakes](https://runnable.com/blog/9-common-dockerfile-mistakes))

**DESHALB:** um beste Build-Performance und Ressourcennutzung zu erzielen, sollte man explizit sein und nicht diesem Anti-Pattern verfallen:

```
# !!! ANTIPATTERN !!!
COPY ./my-app/ /home/app/
RUN npm install # or RUN pip install or RUN bundle install
# !!! ANTIPATTERN !!!
```

Ändert man etwas an einem Layer, dann müssen alle darüberliegenden Layer neu gebaut werden.

**DESHALB:** um beste Build-Performance und Ressourcennutzung zu erzielen, sollte die Reihenfolge der Statements geeignet gewählt sein!!!

**ACHTUNG:** bei Updates am Betriebssystem (z. B. `RUN apt-get upgrade`) will man das Caching i. a. nicht haben, denn Docker würde zum Buildzeitpunkt keine Änderung an dem Layer erkennen können und würde den gecachten Stand verwenden, ohne das `apt-get upgrade` durchzuführen.

Beim Download eines Docker Images (während eines Build oder beim Start eines Containers) sieht man die Layer übrigens auch:

```log
Sending build context to Docker daemon  59.19MB
Step 1/13 : FROM maven:3.6.1-jdk-8
3.6.1-jdk-8: Pulling from library/maven
9cc2ad81d40d: Downloading [=========================================>         ]  37.23MB/45.37MB
e6cb98e32a52: Download complete
ae1b8d879bad: Download complete
42cfa3699b05: Download complete
8d27062ef0ea: Download complete
9b91647396e3: Download complete
7498c1055ea3: Downloading [==================>                                ]  39.37MB/104.2MB
58d962a105be: Download complete
3a71983ad027: Download complete
0f1fddd5e427: Download complete
```

Jedes gecachte Layer muß dann nicht mehr runtergeladen werden. ALLERDINGS: gecachte Layer können ganz schön viel Platz verbrauchen. deshalb sollte man gelegentlich mal aufräumen!!!

### Use multi-stage builds

* [Docker-Dokumentation - Multi-Stage Builds](https://docs.docker.com/develop/develop-images/multistage-build/)

Manchmal paketiert man nicht nur die Artefakte im Build, sondern stößt auch tatsächlich Builds der Software an. Die Zwischenartefakte will man natürlich nicht im Image haben. Vor Docker 17.05 mußte man sich hier selbst helfen ... ab 17.05 verwendet man Multi-Stage Builds.

### Empfehlungen

* "4) Don’t use a single layer image – To make effective use of the layered filesystem, always create your own base image layer for your OS, another layer for the username definition, another layer for the runtime installation, another layer for the configuration, and finally another layer for your application. It will be easier to recreate, manage, and distribute your image." ([10 things to avoid in docker containers](https://developers.redhat.com/blog/2016/02/24/10-things-to-avoid-in-docker-containers/))
* die Reihenfolge wird bestimmt durch "was ändert sich häufiger" bzw. "was muß ich bei einer Änderung noch ändern" ... dementsprechend updated man zuerst das Betriebssystem und am Ende die Anwendung
* "The solution is perform updates and cleanups in a single RUN instruction, which both updates the image, and frees space (resulting in a smaller image) at the same time." ([Keep it small: a closer look at Docker image sizing](https://developers.redhat.com/blog/2016/03/09/more-about-docker-images-size/))
* was man runterlädt sollte man nach der Installation auch im selben RUN Command entfernen:

  ```Dockerfile
  RUN apt-get update \
         && apt-get -y install xdg-utils wget unzip \
         && apt-get clean \
         && rm -rf /var/lib/apt/lists/*
  ```

---

## Fehlersuche

Natürlich geht nicht immer alles glatt bei der Erstellung eines Docker-Images aus einem ``Dockerfile``. Gelegentlich kommt es zu Abbrüchen und man muß rausfinden warum der Build abgebrochen ist.

Und als Newbie steht man dann erst mal auf verlorenem Posten, weil man ja nur das Image baut und nichts Lauffähiges in der Hand hat. Man hat ja nicht mal ein Images, aus dem man einen Container erzeugen könnte ... oder vielleicht doch?

Hier ein Beispiel:

```bash
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

Docker erstellt hier im Hintergrund einen Docker-Container (aus dem Base-Image ``python:2.7``), der über die Kommandos aus dem ``Dockerfile`` verändert wird. Nach jedem erfolgreichen Kommando wird der aktuelle Zustand des Containers (``---> Running in cc10315026b0``) in ein Intermediate-Image (``---> ba40591c8dc8``) committet und das vorhergehende Image gelöscht (``Removing intermediate container cc10315026b0``). Schlägt ein Komando fehl, dann steht das letzte erfolgreiche Image zur Instanziierung zur Verfügung (``ba40591c8dc8``). Dass instanziiert man dann und besorgt sich eine Konsole

```bash
docker run --rm -it ba40591c8dc8 bash -il
```

um dann bespielsweise die fehlerhafte Anweisung auszuführen.

### Fehlersuche - Zugriff auf fehlerhaften Zustand erhalten

Will man den Zustand des Containers nach dem fehlerhaften Kommando erhalten, so muß man zunächst die Container-ID rausfinden (``8d81897ba9aa``), die ja im Log steht (und auch per ``docker ps -a`` sichtbar ist):

```
Step 4 : RUN pip install redis
 ---> Running in 8d81897ba9aa
Collecting redis
  Retrying (Retry(total=4, connect=None, read=None, redirect=None))
     after connection broken by
```

Dann führt man ein Commit aus (``docker commit 8d81897ba9aa my-broken-image``), um aus dem Container ein Image zu machen (so wie das der Buildprozess nach jedem erfolgreichen Step auch macht ... wir machen es jetzt halt auf einem gebrochenen Zustand). Anschließend wird das Image instanziiert und man holt sich eine Konsole darauf:

dann den Container per ```` zu starten und eine Console zu bekommen.

```bash
docker run -it my-broken-image bash
```

Voila ... wenn man die Prinzipien mal verstanden hat, muß man auch vor der Fehlersuche nicht mehr zittern.

---

## Dockerfile Best-Practices

* https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
* Containers should be ephemeral:
  * man kann sie einfach wegwerfen und ersetzen
* Run only one process per Container
* mach das Image so schlank wie möglich

> Mit Alpine Linux gibt es ein Linux Image, das nur 5 MB groß ist und somit bestens geeignet ist, wenn man ein minimales Docker-Image aufbauen will - natürlich muss man dann um so mehr Packages manuell nachinstallieren.

---

## Continuous Integration für Docker Images

Natürlich will niemand die Images immer wieder manuell neu bauen ... man erwartet die Images eigentlich in einem Repository. Sobald ein Update auf die Image-Ressourcen erfolgt wird das Image neu gebaut, getestet und bei entsprechender Qualität ins Docker-Repository hochgeladen.

Bei einem

```bash
docker run image:latest
```

erfolgt dann automatisch ein Download der neuesten Version.

### CI: GitHub - DockerHub

DockerHub bietet schon eine einfache CI-Chain für GitHub-Docker-Repositories. Hierzu muß man im DockerHub das GitHub-Repository verlinken und einen Automated Build konfigurieren.

Travis bietet sicherlich noch mehr Funktionalität - DockerHub ist aber ein guter Einstieg in die Welte der Docker-CI.

### GitHub - Travis - DockerHub

Diese Toolchain bildet CI für Docker-Images komfortabel ab. Im GitHub-Projekt wird eine `.travis.yml` im Root Verzeichnis erwartet. Diese Datei kündigt an, daß es sich um einen Docker-Service handelt und was beim Build geschehen soll (hier am Beispiel meines Forks von `groovy/docker-groovy` - https://github.com/mobi3006/docker-groovy):

```yml
language: bash
services: docker
...
script:
  - docker build -t "${image}" .
  - cd ../test
  - ./run.sh "${image}" "2.4.8"
```

In diesem Beispiel fehlt allerdings das Publishing auf ein Docker-Repository ([Details hier](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry)).

In [Travis](https://travis-ci.org/) muß der Build für das entsprechende GitHub Repository aktiviert werden.

Beim nächsten Commit im GitHub-Repository erfolgt innerhalb weniger Sekunden/Minuten ein automatischer Build.

---

## Anwendung: ins Image vs. als ContainerContribution

### Container Contribution

Als ich mit Docker meine erste Landschaft (``docker-compose``) aufgebaut habe, sah das so aus:

* Dockerfile
* Entrypoint Script (``docker-entrypoint.sh``)
* containerContributions

Das Image enthielt NICHT das Artefakt der zu startenden Anwendnung. Stattdessen wurde das Artefakt (durch ein ``prepare-deployment.sh`` Skript) in ``containerContributions``  abgelegt und das Entrypoint Skript zog sich die zu installierende Anwendung aus ``containerContributions``.

Aus meiner Sicht hat das - zumindest solange man sich noch in einer Development-Phaase befindet folgende Vorteile:

* Docker Images sind klein
* Docker Images müssen nicht neu gebaut werden, um eine andere Version der Anwendnung zu deployen
* Änderungen an den Docker-Skripten sind auch nachträglich möglich

### Maven builds Docker Image

Maven Plugins (z. B. com.spotify#docker-maven-plugin) helfen beim Bau eines Docker-Images für ein Assembly-Artefakts.

Bisher konnte ich mich mit dem Ansatz zum Entwicklungszeitpunkt noch nicht anfreunden, weil zum Zeitpunkt des Builds des Anwendnungs-Artefakts das Skripting der Docker-Infrastruktur (``Dockerfile``, ``docker-entrypoint.sh``) evtl. noch nicht fertig sind. Die Wahrscheinlichkeit ist hoch, daß die erzeugten Docker Images nutzlos sind. Stattdessen könnte man - ähnlich wie bei einem Application-Server - das Docker-Images als PaaS betreiben, d. h. man contributed das zu deployende Artefakt über ein Volume in den Container und startet es. Im Stile eines Open-Containers.

Wenn es dann allerdings ins Releasing einer Anwendung geht, dann macht dieser natürlich Sinn, denn hier möchten man die Docker-Images abschließen - niemand soll die zu startende Anwendung ändern können. Das Artefakt soll FEST mit dem Image verbacken sein.

### Entscheidung

Vielleicht liegt die Wahrheit in der Mitte. Docker ist ein Synonym für einfache Deployments ... man startet ein Docker-Image und los gehts. Insofern ist der ``prepare-deployment.sh`` Ansatz sicher nicht Enduser geeignet (es sei denn das Docker Image ist eine Platform-as-a-Service). Allerdings würde ich diesen Schritt erst ganz zum Schluß gehen (beim Tag/Release).