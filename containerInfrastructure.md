# Container Infrastruktur

---

# CoreOS
[siehe eigener Abschnitt](coreos)

---

# Kubernetes
[siehe eigener Abschnitt](kubernetes)

---

# Rancher
* http://rancher.com/

Container-Platform, die typische Betriebssystem-Features (``ntp``, ``syslog``, ``udev``, ...) selbst in Containern bereitstellt. Man unterscheidet

* system-docker
  * hier laufen Betriebssystem-Container
* user-docker
  * hier laufen die typischen Docker-Container einer Anwendung

Rancher integriert 

* Kubernetes
* Mesos
* Docker Swarm

als Controller-Ansätze.

## Getting Started
Deploy Rancher auf Virtualbox via ``docker-machine``

```
docker-machine create \
   -d virtualbox
   --virtualbox-boot2docker-url https://release.rancher.com/os/latest/rancheros.iso \
   rancher-demo
```

---


