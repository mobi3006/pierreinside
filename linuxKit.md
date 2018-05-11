# LinuxKit - Docker-based Linux-Distribution

* GitHub Repository: https://github.com/linuxkit/linuxkit

> "A toolkit for building secure, portable and lean operating systems for containers"

Aus der Kombination

* Moby
  * [Homepage](https://mobyproject.org/)
  * [GitHub Repository](https://github.com/moby/moby#transitioning-to-moby)
  * eine Alternative ist [Packer von HashiCorp](https://www.packer.io/)
  * das Moby-Projekt liefert auch die Grundlage für die Integration von Linux-Containers in Windows und MacOS (letzteres ist kein Linux-System, sondern ein BSD-System). In beiden Fällen wird ein Linux-Image benötigt, das die Runtime für die Docker-Container bereitstellt. Das von [Docker for Windows](docker_windows.md) genutzte Image heißt dementsprechend auch "MobyLinuxVM"
* LinuxKit

lassen sich Images für verschiedene Hypervisor-Ansätze (lokale wie Qemu und MacOS aber auch Images für Cloud anbieter) erzeugen, um auf diese Weise ganze Systeme Stage-übergreifend.

## Subprojects

* https://github.com/linuxkit/linuxkit/tree/master/projects

Zum LinuxKit git es einige interessante Subprojekte:

* Kubernetes
  * [Git-Repository](https://github.com/linuxkit/linuxkit/tree/master/projects/kubernetes)
  * [Vorstellung auf der DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=1246)
* okernel
  * hiermit erhöht sich Security beim Betrieb von Containern indem der Speicherzugriff über Containergrenzen verhindert wird
  * [Git-Repository](https://github.com/linuxkit/linuxkit/tree/master/projects/okernel)
  * [Vorstellung auf der DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=788)