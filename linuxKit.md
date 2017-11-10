# LinuxKit - Docker-based Linux-Distribution
* GitHub Repository: https://github.com/linuxkit/linuxkit

Aus der Kombination 

* Moby
  * eine Alternative ist [Packer von HashiCorp](https://www.packer.io/)
* LinuxKit

lassen sich Images für verschiedene Hypervisor-Ansätze (lokale wie Qemu und MacOS aber auch Images für Cloud anbieter) erzeugen, um auf diese Weise ganze Systeme Stage-übergreifend 

# Subprojects
* https://github.com/linuxkit/linuxkit/tree/master/projects

Zum LinuxKit git es einige interessante Subprojekte:

* Kubernetes
  * [Vorstellung auf der DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=1246)
* okernel - hiermit erhöht sich Security beim Betrieb von Containern indem der Speicherzugriff über Containergrenzen verhindert wird
  * [Vorstellung auf der DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=788)