# Docker Compose
Hiermit lassen sich komplexe Softwaresystem aus einzelnen Docker-Containern (repräsentieren i. a. Services, die aus einem einzigen Prozess bestehen) aufbauen und miteinander vernetzen. Im Hinblick auf Microservices ist das natürlich sehr interessant.

Ein Docker-Compose ist eine Beschreibung (``docker-compose.yml``) einer Vernetzung von Docker-Images. Per ``docker-compose up`` wird diese Beschreibung interpretiert, die Container gestartet (aus den Images werden nun Container) und die Docker-Container miteinander vernetzt.

Aber selbst wenn man keine komplexen Landschaften aufbauen muß, ist ``docker-compose`` in jedem Fall hilfreich, um komplexe ``docker run`` Kommandos (beispielsweise mit vielen Volume-Mounts) abzubilden, die sich dadurch persistieren und versionieren lassen.

---

# Links
* https://docs.docker.com/compose/gettingstarted/

---

# Installation
Unter [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) konnte ich mit ``apt-get`` zwar ``docker-compose`` installieren, bekam aber nur eine sehr alte Version (1.5.2). Neuere Packages habe ich nicht gefunden. Die meisten aktuellen Tutorials (auch die von Docker selber) verwenden mittlerweile allerdings die Version 2 im der Docker-Copmpose-DSL ... ``docker-compose.yml``:

```
version: '2'

services:
  web:
    build: 
``` 

Unter 

* https://docs.docker.com/compose/install/

habe ich dann rausgefunden, daß man das scheinbar auch ohne Paket sehr leicht installieren (und updaten kann):

```
curl -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
chmod +x /usr/local/bin/docker-compose 
```

---

# Nutzung
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

## Services
Docker Compose abstrahiert von den Containern und hat Services als zentrales Konzept. Das zeigt sich beispielsweise daran, daß

* die Services sind unter ihrem Servicenamen als Hostname erreichbar sind
* man Services über den Servicenamen referenziert und nicht den evtl. auch vergebenene Containernamen
* man bei ``docker-compose up mysql`` den Servicenamen angibt, auch wenn der Container, der im Hintergrund gestartet wird den Namen ``pfh_mysql``. Deshalb sind folgende Befehle identisch:
  *  ``docker logs pfh_mysql``
  *  ``docker-compose logs mysql``

Die ``docker-compose.yml`` liefert hier den entsprechenden Kontext und muß sich deshalb auch im aktuellen Verzeichnis befinden.

---

# Befehle
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