# Docker@Windows

https://docs.docker.com/toolbox/toolbox_install_windows/

Docker Machine ermöglich die Nutzung von Docker für Windows-Nutzer. Docker hat keinen nativen Windows-Support, sondern verwendet ``docker-machine``, um eine Linux-VM (z. B. unter VirtualBox) zu erzeugen, in der dann die Docker Tools (``docker``, ``docker-compose``, ...) nativ laufen.

--- 

# Installation
Für die Installation gibt es zwei Varianten:

1. Docker Toolbox
2. Docker for Windows
   1. basiert auf Windows Hyper-V Virtrualisierungstechnologie, die erst ab Windows 10 Pro verfügbar ist
   2. ACHTUNG: aktiviert man Windows Hyper-V, dann funktioniert die VirtualBox Virtualisierungstechnologie nicht mehr (https://www.virtualbox.org/ticket/12350 ... keine Ahnung, ob das mit VirtualBox 5.1.x auch noch so ist)

## Docker Toolbox
Bringt folgende Tools mit:

* VirtualBox
* Docker Client
* docker-machine
* docker-compose
* Docker Quickstart Terminal
  * vorkonfgurierte Shell basierend auf MinGW 

Beim Start des Docker Quickstart Terminal wird ungefragt automatisch ein VirtualBox Image namens *default* erzeugt und gestartet, das auf [Boot2docker](https://github.com/boot2docker/boot2docker) basiert. Dieses ist mit 40 MB und einer Bootzeit von unter 5 Sekunden recht leichtgewichtig.

Anschlißend prüft man 

```
docker run hello-world
```

die Installation.

Per

```
docker-machine ssh default
```

kann man sich dann über das Docker Quickstart Terminal (alternativ babun oder cygwin) per ssh verbinden ... entsprechende SSH-Keys wurden automatisch erzeugt und konfiguriert (das ist sehr ähnlich zu [Vagrant](vagrant.md).

Mal sehen wie transparent die Windows-Docker-Integration über das VirtualBox-Image ist.



