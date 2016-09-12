# docker build
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

Der Build eines Images besteht darin, die Anweisungen aus dem Dockerfile in einem Container (der aus dem Base-Image aufsetzt) auszuführen:

>"Next you can see each instruction in the Dockerfile being executed step-by-step. You can see that each step creates a new container, runs the instruction inside that container and then commits that change - just like the docker commit work flow you saw earlier. When all the instructions have executed you’re left with the 97feabe5d2ed image (also helpfuly tagged as ouruser/sinatra:v2) and all intermediate containers will get removed to clean things up." (https://docs.docker.com/engine/tutorials/dockerimages/)

Am Ende wird der Zustand des Containers in ein Image persistiert und der angegebene Tag (= Name) verpaßt.

### Versionierung
Ein Docker-Build kann sehr schnell sein, denn durch die Versionierung der einzelnen Steps, müssen nur noch die geänderten Steps neu durchgeführt werden. Ändert sich nichts, dann wird auch nichts getan.

**DESHALB:** um beste Build-Performance zu erzielen, sollte die Reihenfolge der Statements geeignet gewählt sein!!!

### Fehlersuche
* ``docker inspect mysql``
  * hiermit bekommt man schon mal einen guten Überblick über die Container-Konfiguration (Status, Netwerk, Umgebungsvariablen, Mounts, ...)

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

und dann ein Commit ausführen, um den Zustand per ``docker commit`` zu persistieren und dann den Container per ``docker run -it 23621632143126 bash`` zu starten und eine Console zu bekommen.


## Dockerfile Best-Practices
* https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/
* Containers should be ephemeral:  
  * man kann sie einfach wegwerfen und ersetzen
* Run only one process per Container
* mach das Image so schlank wie möglich

> Mit Alpine Linux gibt es ein Linux Image, das nur 5 MB groß ist und somit bestens geeignet ist, wenn man ein minimales Docker-Image aufbauen will - natürlich muss man dann um so mehr Packages manuell nachinstallieren.



