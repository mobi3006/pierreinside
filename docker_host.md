# Docker Host
Dieses Kapital betrachtet eher die Docker Internas.

---

# Linux Containers

---

# Filesystem
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

> Das ist übrigens ein Ansatzpunkt, um Containerübergreifendes Logging mit dem ELK Stack zu erm