# Docker Orchestrierung

Hier geht es um die Orchestrierung von Docker Clustern ...

Cluster werden aufgebaut, um

* die Verfügbarkeit - bei Ausfall eines Knotens wird ein neuer Knoten gestartet. 
* die Performance  - lastabhängig Knoten kritischer Komponenten hinzuzuschalten und dann auch wieder wegzunehmen (um die Anwendung auch wirtscahftlich zu betreiben)

zu erhöhen. Im besten Fall erfolgt das automatisiert durch das Tooling - eine automatisierte Auswertung des Monitorings ist hier eine Grundvoraussetzung. Bei einfachen Anwendungen kann das vielleicht noch manuell geschehen (auch dann wird es schon aufwendig mit Service Discovery und Konfiguration), aber bei wirklich sehr elastischen bzw. komplexeren Umgebungen muß das automatisiert sein ... sonst dreht das Operations-Team am Rad und die Kunden können nicht schnell genug befriedigt werden.

Glücklicherweise gibt es bereits Lösungen für dieses Problem. Das schöne ist, daß nicht nur docker-basierte Komponenten unterstützt werden, sondern auch herkömmliche Deploymentansätze.

---

## Rancher

* http://rancher.com/

Rancher ist den Docker-Tooling am nächsten. Für die Beschreibung der Deployment-Landschaft wird `docker-compose.yml` in Kombination mit `rancher-compose.yml`. 

Rancher beherrscht auch Windows Container.

### Getting Started

Deploy Rancher auf Virtualbox via ``docker-machine``

```bash
docker-machine create \
   -d virtualbox
   --virtualbox-boot2docker-url https://release.rancher.com/os/latest/rancheros.iso \
   rancher-demo
```

### Scheduler

Rancher bietet mit Cattle seinen eigenen Scheduler ... allerdings ist der bei weitem nicht so performant wie die Platzhirsche

* [Kubernetes](kubernetes.md)
* Mesos (Teil von DC/OS)
* Docker Swarm

Rancher kann diese Scheduler aber integrieren.

### Tiefe der Rancher Dockerisierung

Selbst typische Betriebssystem-Features (``ntp``, ``syslog``, ``udev``, ...) bildet Rancher in Docker-Containern ab. Man unterscheidet

* system-docker
  * hier laufen Betriebssystem-Container
* user-docker
  * hier laufen die typischen Docker-Container einer Anwendung

### Alleinstellungsmerkmal: Machine Driver

Rancher bietet mit den Maschine Drivers eine integration verschiedener Cloud-Anbieter, so daß sich ein Hybrid-Deployment aus Maschinen in Private-Cloud (derzeit: vSphere, OpenStack, RackSpace) und Public-Cloud (derzeit: Amazon EC2, Azure, DigitalOcean, Packet) realisieren läßt.

Man kann auch custom Maschine Driver integrieren.

### Bewertung

Rancher ist ein idealer Einstieg in das Docker-Clustering, da es einerseits nah an Docker-Tooling ist (der Einsteiger findet sich schnell zurecht) und anderseits Komponenten aus weitaus professionelleren Lösungen (z. B. Scheduler) integrieren kann. 

> "Rancher bringt zentrale Vorteile im Hinblick auf Verfügbarkeit und Skalierbarkeit relevanter Services mit sich und erlaubt kurze Deployment-Zyklen. Für den Aufbau einer leistungsfähigen Microservice-Umgebung geht es im ersten Schritt darum, die Bestandsapplikationen in Docker zu überführen und sich mit dessen Handhabung vertraut zu machen. Rancher bietet sich als Einstieg an, um die Voraussetzungen für Microservices und Container zu schaffen." (Michael Vogeler, Jan Wiescher - iX 2/2017)

Rancher unterstützt bis Version 1.3 kein Autoscaling. In Version 1.4 sind rudimentäre Scaling-Feature hinzugekommen (Kubernetes ist aber noch meilenweit entfernt).

---

## Kubernetes

[siehe eigener Abschnitt](kubernetes)

---

## DC/OS

Hierbei handelt es sich um ein Paket aus verschiedenen Einzeltools

* Apache Mesos
* Apache Marathon
* ...

Ich finde die Idee sehr überzeugend und würde es gerne mal ausprobieren. Bei Cloud-Anbietern we AWS, Azure und Google Cloud Engine scheint das auch ziemlich unproblematisch zu sein, weil hier fertige Templates bereitstehen, so daß die Installation per One-Click erfolgt. 

Zur On-Premise-Installation schreibt die iX:

> "Die Installation im Cluster läuft weitestgehend automatisch, erfordert aber eine akribische Vorbereitung." (Daniel Bößwetter - iX Ausgabe 2/2017)