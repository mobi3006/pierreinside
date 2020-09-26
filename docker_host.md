# Docker Host

Dieses Kapital betrachtet eher die Docker Internas.

---

## cgroups

Mit cgroups lassen sich Ressourcen (CPU, Memory) einschränken, die ein Container nutzen darf.

## Remote Docker Host

Die Standard-Konfiguration ist, daß der Docker Host (der führt die Docker-Kommandos wie `docker ps` aus) die lokale Maschine ist. Über `export DOCKER_HOST=tcp://<IP_ADDRESS>:<PORT>` können die Kommandos an einen entfernten Docker-Host umgeleitet werden (sog. Remote Docker API).

> Diese Konzept verwenden vermutlich auch die Docker-Wrapper, die auf nicht-nativen Docker-Umgebungen wie Windows und MacOS eingesetzt werden.

Standardmäßig ist die Remote Docker API aus Sicherheitsgründen abgteschaltet. Über `export DOCKER_OPTS="-H tcp://0.0.0.0:2375` auf dem Docker-Host-Server kann die Remote API auf Port `2375` für ALLE clients verfügbar gemacht werden (will man diese Einstellung dauerhaft machen: `/etc/default/docker` anpassen), so daß ein `export DOCKER_HOST=tcp://<IP_ADDRESS>:2375` auf dem Client den Remote-Docker-Host konfiguriert.

---

## Linux Containers

---

## Permissions - User

Der Docker Daemon läuft als `root` User und erzeugt somit auch Log-Files, die `root` zugeordnet sind:

```
root@workbench:/var/lib/docker/containers/bfaca06879908db6b54e0cc06bbc6ecc67923aff85b70fb911f1461ec8ca5f81>ls -al *.log
-rw-r----- 1 root root 1,2K Dez 16 14:23 bfaca06879908db6b54e0cc06bbc6ecc67923aff85b70fb911f1461ec8ca5f81-json.log
```

Das macht die Sache recht schwierig, wenn Logs beispielsweise von einem [Fluentd](fluentd.md) gelesen werden sollen, um sie dann an Graylog oder ElasticSearch zur nodeübergreifenden Sammlung weitergeleitet werden sollen. Den Fluentd-Prozess läßt man natürlich nicht als `root` laufen (auch nicht in der `root` Gruppe).

Das Problem könnte umgangen werden, indem man Fluentd in einem Docker-Container laufen läßt und die Docker-Host-Log-Files per `volume` mounted.

> BTW: Die Verwendung von `USER myuser` im `Dockerfile` ändert an den Berechtigungen des Log-Files nichts, da der Docker-Daemon noch immer für die Erstellung der Log-Files zuständig ist.

Mit

```bash
setfacl -Rdm g:loggroup:r /var/lib/docker/containers/
```

könnte man der Gruppe `loggroup` Leseberechtigungen auf alle unterhalb von `/var/lib/docker/containers/` erstellten Dateien einräumen und wenn Fluentd in dieser Gruppe ist, dann Voila.

### Dockerfile USER

Per Default läuft der Entrypoint-Prozess im Docker-Container mit dem User `root`. Somit kann der Docker-Container alles im Filesystem des Containers machen. Auch der Docker-Prozess auf dem Docker-Host (`ps -ef`) läuft als User `root`.

Es gibt unandliche Diskussionen, ob man das per `USER` Kommando im `Dockerfile` ändern sollte:

```
RUN adduser -D -u 1234 pfh
USER pfh
```

In diesem Beispiel läuft der Entrypoint-Prozess im Docker-Container mit dem User `pfh`. Das hat zur Folge, daß die Berechtigungen eingeschränkt sind und beispielsweise eine Änderung von `/etc/hosts` nicht möglich ist, weil nur der `root` User hier Berechtigungen hat.

Das hat also zumindest mal Nachteile. Ob es Vorteile hat ist strittig, denn eigentlich ist der `root` User in seinem Container eingesperrt. Aber gemäß dem Least-possible-Permissions-Ansatz sollte man das vermeiden - die Docker-Implementierung könnte Sicherheitslücken enthalten und dem `root` User im Container Zugriff als `root` auf dem Docker Host ermöglichen.

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

> Das ist übrigens ein Ansatzpunkt, um containerübergreifendes Logging mit dem ELK Stack zu ermöglichen - [siehe auch](logging.md)
