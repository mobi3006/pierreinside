# Docker Host

Dieses Kapital betrachtet eher die Docker Internas.

---

## Remote Docker Host

Die Standard-Konfiguration ist, daß der Docker Host (der führt die Docker-Kommandos wie `docker ps` aus) die lokale Maschine ist. Über `export DOCKER_HOST=tcp://<IP_ADDRESS>:<PORT>` können die Kommandos an einen entfernten Docker-Host umgeleitet werden (sog. Remote Docker API).

> Diese Konzept verwenden vermutlich auch die Docker-Wrapper, die auf nicht-nativen Docker-Umgebungen wie Windows und MacOS eingesetzt werden.

Standardmäßig ist die Remote Docker API aus Sicherheitsgründen abgteschaltet. Über `export DOCKER_OPTS="-H tcp://0.0.0.0:2375` auf dem Docker-Host-Server kann die Remote API auf Port `2375` für ALLE clients verfügbar gemacht werden (will man diese Einstellung dauerhaft machen: `/etc/default/docker` anpassen), so daß ein `export DOCKER_HOST=tcp://<IP_ADDRESS>:2375` auf dem Client den Remote-Docker-Host konfiguriert.

---

## Linux Containers

---

## Filesystem

Das Filesystem des Docker Containers liegt unter ``/var/lib/docker/containers/``. Wann man beispielsweise bei ``docker ps -a`` folgendes Ergebnis bekommt:

```
CONTAINER ID        IMAGE
87f9102cf87a        pierre
```

dann findet man das Filesystem des Docker-Containers unter ``/var/lib/docker/containers/87f9102cf87a571ea26e38994d57700e3a4e30b339d7347`` (der Zugriff ist vermutlich auf ``root`` beschränkt). Darunter findet sich dann folgende Verzeichnisstruktur:

```
root@workbench:/var/lib/docker/containers/87f9102cf87a571ea26e38994d57700e3a4e30b339d734798d3017d2a1bd4377>tree
.
├── 87f9102cf87a571ea26e38994d57700e3a4e30b339d734798d3017d2a1bd4377-json.log
├── config.v2.json
├── hostconfig.json
├── hostname
├── hosts
├── resolv.conf
├── resolv.conf.hash
└── shm
```

Hier findet man also beispielsweise auch das Consolen-Log, die Docker-Engine bei ``docker logs 87f9102cf87a571ea26e38994d57700e3a4e30b339d734798d3017d2a1bd4377`` liefert.

> Das ist übrigens ein Ansatzpunkt, um containerübergreifendes Logging mit dem ELK Stack zu ermöglichen