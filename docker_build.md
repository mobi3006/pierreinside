# Docker Build

Für die Erzeugung eigener Docker-Images gibt es zwei Möglichkeiten:

1. basierend auf einem existierenden Docker-Image (z. B. von DockerHub) einen Container instanziieren. Am laufenden Container Änderungen vornehmen und vom Endergebnis ein neues Image ziehen (`docker commit 62832asdaskjks7i username/my-image:latest`). siehe https://docs.docker.com/engine/tutorials/dockerimages/#/creating-our-own-images

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

### docker push

* [gutes Tutorial](https://www.youtube.com/watch?v=fdQ7MmQNTa0)

Nach einem Build steht das Docker Image lokale zur Verfügung und kann lokal instanziiert werden. Will man es anderen Usern zur Verfügung stellen, so muss man es in eine Docker-Registry pushen - die Default Registry ist [docker.io](https://hub.docker.com/).

Hierzu muss man sich vorher in der Docker-Registry registrieren, um Credentials zu erhalten. Über die Konsole loggt man sich per

```bash
docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASSWORD
```

ein. 

Nach dem Build (z. B. `docker build -t docker_hub_user/test:latest .`) wird das image per `docker push docker_hub_user/test:latest` auf die Registry gepusht. Anschließend steht das Image per `docker pull docker_hub_user/test:latest` zur Nutzung zur Verfügung.

Will man eine andere Registry als docker.io verwenden, dann muss man das im Imagenamen konfigurieren. In diesem Fall verwendet packt man den Registrynamen zum Imagenamen dazu: `docker push docker.io/docker_hub_user/test:latest`

> **BE AWARE:** obige Befehle führen dazu, dass das Passwort in der Shell-History landet und im Klartext in `~/.docker/config.json` abgelegt wird. Beides sollte man vermeiden ... bessere Möglichkeiten [findet man hier](docker_registry.md)

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

## Multi-Platform Builds

* [gute Einführung](https://www.inovex.de/de/blog/multi-architecture-docker-images/)
* [mehr technische Internals (insbes. QEMU und `binfmt`)](https://medium.com/@artur.klauser/building-multi-architecture-docker-images-with-buildx-27d80f7e2408)

Spätestens seit dem Wechsel von Apple zu ARM-Prozessoren (Apple Silicon) und des AWS-Supports (Graviton) für diese Architektur mit signifikant günstigeren Preisen (40%) ist im Docker-Bereich Mult-Platform-Support angesagt.

Auf einem Build-Server hat man i. d. R. keine unterschiedlichen Architekturtypen verbaut, um die für die jeweilige Architektur passenden Docker-Images zu bauen. Deshalb bietet Docker sog. Multi-Platform Builds per `buildx` an.

### buildx

* [Installationsdoku](https://docs.docker.com/buildx/working-with-buildx/)

Nach der Installation steht `buildx` als Plugin unter `~/.docker/cli-plugins/docker-buildx` zur Verfügung.

Hierbei handelt es sich um ein Plugin der Docker-CLI, das nur bei Setzen des Experimental Flags (`export DOCKER_CLI_EXPERIMENTAL=enabled` oder durch Setzen von

```json
{
  "experimental": "enabled"
}
```

in `~/.docker/config.json` oder `/etc/docker/daemon.json` (je nach Linux-Distribution - hier Ubuntu) zur Verfügung steht (z. B. `docker buildx ls`). Nach dieser Konfiguration kann eine Docker-Daemon restart nicht schaden (z. B. `sudo systemctl restart docker`).

Ich empfehle `build` als Default-Docker-Build-Variante per [`docker buildx install`](https://docs.docker.com/engine/reference/commandline/buildx_install/) zu setzen. Dadurch wird `docker build` ein Alias für `docker buildx build`.

Unter Ubuntu 18.04 werden die folgenden Packages benötigt (in Ubuntu 20.04 allerdings nicht mehr - zumindest nicht, wenn man `tonistiigi/binfmt` verwendet):

```bash
# QEMU ist die Emulationssoftware (statisch gelinkt, um Dependency Probleme zu vermeiden)
qemu-user-static

# hierdurch wird das Kernel Modul "binfmt_misc" geladen
binfmt-support
```

Auf dem Host-System (auch wenn man den Multiarch-Build später in einem Docker-Images macht) werden Handler für die verschiedenen Executable-Files der verschiedenen Architekturen benötigt. Am einfachsten installiert man die per `docker run --privileged --rm tonistiigi/binfmt --install all` (ist man nur an bestimmten Architekturen interessiert verwendet man beispielsweise `docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm`).

> Auf einem CentOS 7 image hat das nicht funktioniert ... hier musste ich [qemu-user-static](https://github.com/multiarch/qemu-user-static) über `docker run --rm --privileged multiarch/qemu-user-static:register --reset` bzw. (mit `--userns host`) `docker run --rm --userns host --privileged multiarch/qemu-user-static:register --reset` verwenden.

Danach sollten sich Handler in `/proc/sys/fs/binfmt_misc` befinden und die nachfolgenden Kommandos **MÜSSEN** (je nach ausgewählten Architekturen) funktionieren:

```bash
docker run --rm arm64v8/alpine uname -a
docker run --rm arm32v7/alpine uname -a
docker run --rm ppc64le/alpine uname -a
docker run --rm s390x/alpine uname -a
```

Best-Practice ist die Erzeugung einer neuen Builder Instanz per `docker buildx create --use --name my-docker-builder` - dadurch verkonfiguriert man schon nicht den Default Builder. Mit `docker buildx ls` sollte man anschließend überprüfen, ob der erzeugte Builder tatsächlich als Default gekennzeichnet ist und tatsächlich alle Formate aus `/proc/sys/fs/binfmt_misc` als Platforms unterstützt.

Anschließend kann man per

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t my-image:latest . --load
```

für die beiden angegebenen Platformen bauen. Dabei wird ein `manifest` file erzeugt, das alles Notwendige enthält, um später komfortabel von einer der beiden Plattformen mit dem gleichen Befehl einen Container zu starten (`docker run -rm my-image:latest`)... durch das Manifest-File wird die richtige Version gewählt.

Per `docker manifest inspect golang:latest` kann man sich ein solches `manifest` beispielhaft anschauen.

Durch `--load` wird das gebaute Docker-Image in der lokalen Docker-Registry verfügbar gemacht (scheinbar ist das nicht immer der Default ... unter einem CentOS 8 musste ich das nicht machen - unter Ubuntu 20.04 hingegen schon), so daß ein `docker inspect my-image:latest` funktioniert.

> Wenn das `--load` zu einem `error: docker exporter does not currently support exporting manifest lists` führt, könnte das daran liegen, daß der lokale Docker Daemon nicht mit `--platform` Listen umgehen kann. Dann nur eine Platform verwenden.

Verwendet man stattdessen `--push` (ohne Parameter) so kann man es zu einer Remote-Docker-Registry (z. B. docker.io) pushen. In dem Fall muss man sich aber vorher einloggen (`docker login`) und das Image muss mit dem passenden Accountnamen benant werden (im Beispiel `docker_hub_user`):

```bash
docker buildx build --platform linux/amd64,linux/arm64 -t docker_hub_user/my-image:latest . --push
```

so daß man anschließend ein `docker pull docker_hub_user/my-image:latest` oder `docker manifest inspect docker_hub_user/my-image:latest` machen kann.

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