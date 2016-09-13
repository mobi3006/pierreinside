# docker machine
* https://docs.docker.com/machine/

## Einsatz als Docker-Adapter für Windows Platform
Docker Machine ermöglich die Nutzung von Docker für Windows-Nutzer. Docker hat keinen nativen Windows-Support, sondern verwendet ``docker-machine``, um eine Linux-VM (z. B. unter VirtualBox) zu erzeugen, in der dann die Docker Tools (``docker``, ``docker-compose``, ...) nativ laufen.

## Einsatz mit Docker Swarm und Docker Compose ... Scaling
* https://blog.docker.com/2015/02/orchestrating-docker-with-machine-swarm-and-compose/

---

# Installation
* https://docs.docker.com/engine/installation/windows/
* https://docs.docker.com/docker-for-windows/

Für die Installation gibt es zwei Ansätze:

* Docker for Windows
  * basierend auf Microsofts Hyper-V (ab Windows 10 Pro) ... dann funktioniert VirtualBox nicht mehr - siehe https://www.virtualbox.org/ticket/12350
* Docker Toolbox
  * basierend auf VirtualBox' Hypervisor

Da ich selbst VirtualBox verwende, habe ich natürlich die Docker Toolbox installiert!!!


