# docker build
Für die Erzeugung eigener Docker-Images gibt es zwei Möglichkeiten:

1. basierend auf einem existierenden Docker-Image (z. B. von DockerHub) einen Container instanziieren. Am laufenden Container Änderungen vornehmen und vom Endergebnis ein neues Image ziehen. siehe https://docs.docker.com/engine/tutorials/dockerimages/#/creating-our-own-images

2. ein ``Dockerfile`` erzeugen, das die Bauanleitung für das Image darstellt - siehe https://docs.docker.com/engine/tutorials/dockerimages/#/building-an-image-from-a-dockerfile

Im ersten Fall kann man von außen nicht beurteilen, in welchem Zustand das Image ist (welche Änderungen wurden vorgenommen). 

Verwendet man hingegen ein Dockerfile kann jeder nachvollziehen welche Änderungen basierend auf einem Base-Image durchgeführt wurden.

---

# Dockerfile
Hat man ein ``Dockerfile`` erzeugt, dann baut man das entsprechende Image per

```
docker build -t mobi3006:myFirstDockerImage . 
```

aus dem Verzeichnis, in dem sich das ``Dockerfile`` befindet. In obigen Beispiel bekommt das Image den Namen ``myFirstDockerImage``. Unter diesem Namen kann es dann beispielsweise per

```
docker run myFirstDockerImage
```

gestartet werden.

## Was passiert beim Build?
Der Build eines Images besteht darin, basierend auf dem Base-Image (``FROM mysql``) einen Container zu instanziieren und darauf die Anweisungen aus dem Dockerfile auszuführen. Nach jedem erfolgreichen Step hat man einen neuen Containerzustand und der wird in ein Image committet (z. B. mit den seltsamen Namen ``d799d66c1d0b``).

>"Next you can see each instruction in the Dockerfile being executed step-by-step. You can see that each step creates a new container, runs the instruction inside that container and then commits that change - just like the docker commit work flow you saw earlier. When all the instructions have executed you’re left with the 97feabe5d2ed image (also helpfuly tagged as ouruser/sinatra:v2) and all intermediate containers will get removed to clean things up." (https://docs.docker.com/engine/tutorials/dockerimages/)

Bei erfolgreichem Build sorgt der letzte Commit (= aktueller Zustand des Containers wird in ein Image persistiert) dafür, daß das Image den angegebenen sprechenden Namen erhält (z. B. ``mysql:5.7``).

## Versionierung der Build-Step-Ergebnisse
Ein Docker-Build kann sehr schnell sein, denn durch die Versionierung der einzelnen Steps, müssen nur noch die geänderten Steps neu durchgeführt werden. Ändert sich nichts, dann wird auch nichts getan.

**DESHALB:** um beste Build-Performance zu erzielen, sollte die Reihenfolge der Statements geeignet gewählt sein!!!

--- 

# Fehlersuche
Natürlich geht nicht immer alles glatt bei der Erstellung eines Docker-Images aus einem ``Dockerfile``. Gelegentlich kommt es zu Abbrüchen und man muß rausfinden warum der Build abgebrochen ist.

Und als Newbie steht man dann erst mal auf verlorenem Posten, weil man ja nur das Image baut und nichts Lauffähiges in der Hand hat. Man hat ja nicht mal ein Images, aus dem man einen Container erzeugen könnte ... oder vielleicht doch?

Hier ein Beispiel:

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

Docker erstellt hier im Hintergrund einen Docker-Container (aus dem Base-Image ``python:2.7``), der über die Kommandos aus dem ``Dockerfile`` verändert wird. Nach jedem erfolgreichen Kommando wird der aktuelle Zustand des Containers (``---> Running in cc10315026b0``) in ein Intermediate-Image (``---> ba40591c8dc8``) committet und das vorhergehende Image gelöscht (``Removing intermediate container cc10315026b0``). Schlägt ein Komando fehl, dann steht das letzte erfolgreiche Image zur Instanziierung zur Verfügung (``ba40591c8dc8``). Dass instanziiert man dann und besorgt sich eine Konsole

```
docker run --rm -it ba40591c8dc8 bash -il
```

um dann bespielsweise die fehlerhafte Anweisung auszuführen.

## Fehlersuche - Zugriff auf fehlerhaften Zustand erhalten
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

```
docker run -it my-broken-image bash
```

Voila ... wenn man die Prinzipien mal verstanden hat, muß man auch vor der Fehlersuche nicht mehr zittern.

---

# Dockerfile Best-Practices
* https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
* Containers should be ephemeral:  
  * man kann sie einfach wegwerfen und ersetzen
* Run only one process per Container
* mach das Image so schlank wie möglich

> Mit Alpine Linux gibt es ein Linux Image, das nur 5 MB groß ist und somit bestens geeignet ist, wenn man ein minimales Docker-Image aufbauen will - natürlich muss man dann um so mehr Packages manuell nachinstallieren.
