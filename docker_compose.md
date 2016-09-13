# Docker Compose
Hiermit lassen sich Landschaften aus Docker-Containern aufbauen und miteinander vernetzen. Ein Docker-Container ist ja eigentlich nur ein Service (= Prozess) ... das ist auch die Empfehlung.

Ein Docker-Compose ist eine Beschreibung (``docker-compose.yml``) einer Vernetzung von Docker-Images. Per ``docker-compose up`` wird diese Beschreibung interpretiert, die Container gestartet (aus den Images werden nun Container) und die Docker-Container miteinander vernetzt.

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

---

# Befehle
* ``docker-compose up``
  * gesamte Anwendung hochfahren
* ``docker-compose up my-service``
  * nur den ``my-service`` starten
* ``docker-compose logs``
  * aggregierte Log-Ansicht von allen Services (bzw. Machines)
* ``docker-compose build web``
  * Image des Service ``web`` neu bauen