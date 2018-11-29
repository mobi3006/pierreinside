# Docker Compose

Hiermit lassen sich komplexe Softwaresystem aus einzelnen Docker-Containern (repräsentieren i. a. Services, die aus einem einzigen Prozess bestehen) aufbauen und miteinander vernetzen. Im Hinblick auf Microservices ist das natürlich sehr interessant.

Ein Docker-Compose ist eine Beschreibung (``docker-compose.yml``) einer Vernetzung von Docker-Images. Per ``docker-compose up`` wird diese Beschreibung interpretiert, Container gestartet (aus den Images werden nun Container) und miteinander vernetzt ... bei ``docker-compose`` wird automatisch ein eigenes Bridge-Netzwerk aufgebaut, in dem die Hosts/Services über ihren Servicenamen aufgelöst werden können (es müssen keine IP-Adressen verwendet werden).

Aber selbst wenn man keine komplexen Landschaften aufbauen muß, ist ``docker-compose`` in jedem Fall hilfreich, um komplexe ``docker run`` Kommandos (beispielsweise mit vielen Volume-Mounts) abzubilden, die sich dadurch persistieren und versionieren lassen.

---

## Installation

Unter [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) konnte ich mit ``apt-get`` zwar ``docker-compose`` installieren, bekam aber nur eine sehr alte Version (1.5.2). Neuere Packages habe ich nicht gefunden. Die meisten aktuellen Tutorials (auch die von Docker selber) verwenden mittlerweile allerdings die Version 2 im der Docker-Copmpose-DSL ... ``docker-compose.yml``:

```yaml
version: '2'

services:
  web:
    build:
```

Unter https://docs.docker.com/compose/install/ habe ich rausgefunden, daß Docker-Compose tatsächlich nur aus einem einzigen Script besteht, das man irgendwo im $PATH ablegt (z. B. `/usr/local/bin/docker-compose`) und ausführbar macht (alle verfügbaren Versionen befinden sich hier: https://github.com/docker/compose/releases)

```bash
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

> Das hat leider den Nachteil, daß man bei einem Systemupgrade (`sudo apt-get upgrade`) nicht automatisch Docker aktualisiert bekommt. Das muß man dann bei Bedarf nachholen ... oder die Disziplin haben regelmäßige Updates aller Tar-Balls zu machen.

### Upgrade

Da Docker-Compose nur aus einem einzigen Binary besteht, ist das Upgrade genauso durchzuführen wie die Installation.

## Nutzung

Das ``docker-composse.yml`` ist die Spezifikation des Compose. Hier werden 

* Services
* Links
* volumes
* Netwerke
* Umgebungsvariablen
* Port-Forwarding
* ...

spezifiziert und die Anwendnung dadurch aufgebaut.

Die Ausführung kann lokal aber auch remote erfolgen, so daß man dadurch ganz leicht die Anwendung nicht lokal, sondern bei einem Docker-Cloud-Provider wie DigitalOcean fahren kann.

### Services

Docker Compose abstrahiert von den Containern und hat Services als zentrales Konzept. Die Servicenamen dienen auch der Adressierung (statt IP-Adressen oder Containernamen) und werden dementsprechend in Service-URLs verwendet. Das zeigt sich beispielsweise daran, daß

* die Services sind unter ihrem Servicenamen als Hostname erreichbar sind
* man Services über den Servicenamen referenziert und nicht den evtl. auch vergebenene Containernamen
* man bei ``docker-compose up mysql`` den Servicenamen angibt, auch wenn der Container, der im Hintergrund gestartet wird den Namen ``pfh_mysql``. Deshalb sind folgende Befehle identisch:
  * ``docker logs pfh_mysql``
  * ``docker-compose logs mysql``

Die ``docker-compose.yml`` liefert hier den entsprechenden Kontext und muß sich deshalb auch im aktuellen Verzeichnis befinden.

---

## Befehle

* ``docker-compose up``
  * gesamte Anwendung hochfahren
  * ``-d`` daemonized hochfahren
* ``docker-compose up my-service``
  * nur den ``my-service`` starten
* ``docker-compose down``
  * gesamte Anwendung runterfahren und die Container löschen - im Gegensatz zu ``docker-compose stop``
* ``docker-compose start``
  * gesamte Anwendung aus den existierenden (gestoppten) Containern starten. Sollten bereits einige Container der Anwendung schon laufen, dann stört das nicht
* ``docker-compose start mysql``
  * Container ``mysql`` starten
* ``docker-compose logs``
  * aggregierte Log-Ansicht von allen Services (bzw. Machines)
* ``docker-compose logs -f``
  * forwarding Log-Ansicht von allen Services (bzw. Machines)
* ``docker-compose build web``
  * Image des Service ``web`` neu bauen
* `docker-compose run --rm myService ping localhost`
  * Service in einem neuen Container starten und ein einziges Kommand absetzen - danach wird der Container gestoppt und gelöscht

## Reihenfolge

* [Docker-Compose - Getting Started](https://docs.docker.com/compose/gettingstarted/)
* [Docker-Compose - Control Startup Order](https://docs.docker.com/compose/startup-order/)

Links sind ein Mittel, um Abhängigkeiten zwischen Containern zu beschreiben. Das ist sehr praktisch, wenn man die Abhängigkeiten vor dem Benutzer verbergen will (statt `docker-compose up service1 dep-service-a dep-service-b` nur `docker-compose up service1`). Allerdings werden die Container nur gestartet, es ist zu keinem Zeitpunkt klar, ob der darin befindliche Service auch tatsächlich benutzbar ist oder sich noch in der Startphase befindet.

> ABER ACHTUNG: Docker Compose sorgt nur dafür, daß die linked Containers gestartet werden ... es KANN NICHT garantiert werden, daß der Service dann tatsächlich auch schon nutzbar ist. In diesem Fall könnte man mit Tools wie [`wait-for-it`](https://github.com/vishnubob/wait-for-it)/[`dockerize`](https://github.com/vishnubob/wait-for-it)/[`wait-for`](https://github.com/Eficode/wait-for) arbeiten. Diese stellen aber nur einen Workaround dar, denn eigentlich muß man in Microservice-Produktivszenarien immer damit rechnen, daß Services nicht mehr verfügbar sind und Resilience Patterns implementieren.

Es gibt allerdings Lösungen durch andere OSS-Projekte:

* https://github.com/vishnubob/wait-for-it
  * [wird in Spring Petclinic benutzt ... in der `entrypoint` Konfiguration](https://github.com/spring-petclinic/spring-petclinic-microservices/blob/master/docker-compose.yml)
* https://github.com/jwilder/dockerize

Diese Tools packt man am besten in das Docker-Image und kann sie dann im Provisioningscript verwenden.