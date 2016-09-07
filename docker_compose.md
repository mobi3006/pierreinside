# Docker Compose
Hiermit lassen sich Landschaften aus Docker-Containern aufbauen und miteinander vernetzen. Ein Docker-Container ist ja eigentlich nur ein Service (= Prozess) ... das ist auch die Empfehlung. 

---

# Installation
Unter [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) konnte ich mit ``apt-get`` zwar ``docker-compose`` installieren, bekam aber nur eine sehr alte Version (1.5.2). Neuere Packages habe ich nicht gefunden.

Unter 

* https://docs.docker.com/compose/install/

habe ich dann rausgefunden, daß man das scheinbar auch ohne Paket sehr leicht installieren (und updaten kann):

```
curl 
    -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
chmod +x /usr/local/bin/docker-compose 
```
