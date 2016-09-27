# Docker MySQL
* Offizielles Image auf DockerHub: https://hub.docker.com/_/mysql/

Für MySQL gibt es etliche Docker Images ...

---

# Offizielles Docker Image

## Persistenz auf Docker-Host
Ich habe das per (``docker-compose.yml``)

```
volumes:
   - ./containerPersistence/mysql:/var/lib/mysql
```

geschafft und kann somit den Container wegwerfen, ohne die Daten aus der Datenbank zu verlieren. 

### Permissions
* https://denibertovic.com/posts/handling-permissions-with-docker-volumes/

ABER ... der Owner der Dateien ist zunächst mal vom Image/Container festgelegt. Es scheint so als sei das fest auf die User-ID 999 eingestellt ... zumindest findet man in der ``/etc/passwd`` im Docker-Container folgenden Eintrag:

```
mysql:x:999:999::/home/mysql:/bin/sh
```

und das ``docker-entrypoint.sh`` Skript aus dem MySQL Docker Image scheint den Owner der Dateien im sog. DATADIR auf genau diesen User ``mysql`` zu setzen:

```
# allow the container to be started with `--user`
if [ "$1" = 'mysqld' -a -z "$wantHelp" -a "$(id -u)" = '0' ]; then
	DATADIR="$(_datadir "$@")"
	mkdir -p "$DATADIR"
	chown -R mysql:mysql "$DATADIR"
	exec gosu mysql "$BASH_SOURCE" "$@"
fi
```

Sollte diese ID auf dem Docker-Host vergeben sein, dann bekommt man dessen Usernamen angezeigt. Letztlich kann man die Dateien nur als der User der entsprechende User im Docker-Host löschen ... und das ist eben zufällig ... meisten hilft hier nur der User ``root`` oder eben ``sudo``. 

In der Doku zum Image findet man diesen lapidaren Hinweis:

```
The downside is that the user needs to make sure that the directory exists, and that e.g. directory permissions and other security mechanisms on the host system are set up correctly.
```

Dieses Problem wird ausgiebig diskutiert und mittlerweile verwende ich diesen Ansatzbisher habe ich noch keine zufriedenstellende Lösunge gefunden. Folgendes funktioniert schon mal (wobei die Variable UID explizit exportiert werden muß):

```
services:
   mysql:
      image: mysql:5.7
      user: ${UID}
```

hat aber deutliche Seiteneffekte, denn dann ist der Owner innerhalb des Docker-Containers der User mit dieser UID ... und die existiert eben i. a. nicht:

```
I have no name!@mysql:/var/lib/mysql$ ls -al
total 188496
drwxrwxr-x  6 1000 1000     4096 Sep 26 15:11 .
drwxr-xr-x 21 root root     4096 Sep  7 18:19 ..
-rw-rw-r--  1 1000 1000       64 Sep 19 17:13 .keep
-rw-r-----  1 1000 root       56 Sep 26 14:47 auto.cnf
```

DAMN :-(
