# Docker@Windows

https://docs.docker.com/toolbox/toolbox_install_windows/

Docker Machine ermöglich die Nutzung von Docker für Windows-Nutzer. Docker hat keinen nativen Windows-Support, sondern verwendet Virtualisierungslösungen wie VirtualBox oder der Microsoft-Pendant Hyper-V, um eine Linux-VM zu erzeugen, in der dann die Docker Tools (``docker``, ``docker-compose``, ...) nativ laufen.

--- 

# Ansätze
Unter Windows gibt es zwei Ansätze:

1. Docker Toolbox
2. Docker for Windows
   1. basiert auf Windows Hyper-V Virtrualisierungstechnologie, die erst ab Windows 10 Pro verfügbar ist
   2. ACHTUNG: aktiviert man Windows Hyper-V, dann funktioniert die VirtualBox Virtualisierungstechnologie nicht mehr (https://www.virtualbox.org/ticket/12350 ... keine Ahnung, ob das mit VirtualBox 5.1.x auch noch so ist)

## Docker for Windows
* https://docs.docker.com/machine/drivers/hyper-v/

>ACHTUNG: das basiert auf Microsofts Hypervisor-Technologie, die nicht gemeinsam mit Virtualbox nutzbar ist ... es kann nur einen geben!!!

### Linux-Container
Docker for Windows benötigt Microsofts Hyper-V-Technologie, die ganz ähnlich zu Oracles VirtualBox Lösung ist (und leider nicht parallel zu dieser laufen kann). Auf dieser Hypervisor-Technology wird ein Linux-Image (`MobyLinuxVM`) erstellt und gestartet. In diesem Linux-Image läuft der Docker-Daemon und die Docker-Container. Der Docker-Client zum Absatzen von Kommandos (z. B. `docker ps`) läuft in einer beliebigen Terminal-Konsole (z. B. Powershell, Command Shell, Babun). Seine Kommandos werden auf das Moby-Image umgebogen.

### Windows-Server-Container
Docker for Windows kann neben Linux-Containern auch Windows-Container betreiben - aber auch hier gilt - ENTWEDER ODER!!!

* [siehe eigener Abschnitt](windowsContainer.md)

## Docker Toolbox
> ACHTUNG: Die Docker-Toolbox ist nur dann zu empfehlen, wenn man Docker auf Windows Maschinen <  Windows 10 Version 1607 (alias Anniversary Update - August 2016) nutzen will, denn dort funktioniert Docker for Windows nicht. 

Bringt folgende Tools mit:

* VirtualBox
* Docker Client
* docker-machine
* docker-compose
* Docker Quickstart Terminal
  * vorkonfgurierte Shell basierend auf MinGW 

Beim Start des Docker Quickstart Terminal wird - sofern noch nicht vorhanden (also beim ersten Start beispielsweise) - automatisch ein VirtualBox Image namens *default* erzeugt und gestartet. Zudem werden ssh-Keys erzeugt und eingebunden (für spätere ``docker-machine ssh default``) - sehr ähnlich zu [Vagrant](vagrant.md). Dieses Image basiert auf der [Boot2docker](https://github.com/boot2docker/boot2docker) Distribution, die mit 40 MB und einer Bootzeit von unter 5 Sekunden recht leichtgewichtig ist ... diese Bootzeit wurde im Praxiseinsatz deutlich überschritten.

Anschließend prüft man 

```
docker run hello-world
```

die Installation.

Per

```
docker-machine ssh default
```

kann man sich auf die Console des Images verbinden..

> ACHTUNG: kann man sich dann über das Docker Quickstart Terminal (alternativ babun oder cygwin) 

Mal sehen wie transparent die Windows-Docker-Integration über das VirtualBox-Image ist.

### Docker Quickstart Terminal
Diese vorkondigurierte Console (basierend auf MinGW) kommt mit der Docker Toolbox mit.

> ACHTUNG: es war mir spontan nicht möglich eine nicht-vorkonfigurierte Console (z. B. babun) zu verwenden ... folgendes Problem:
> ```
{ ~ } » docker run hello-world
C:\Program Files\Docker Toolbox\docker.exe: 
An error occurred trying to connect:
Post http://%2F%2F.%2Fpipe%2Fdocker_engine/v1.24/containers/create: open //./pipe/docker_engine: 
The system cannot find the file specified..
```

Leider kann sie meine Default-Konsole [babun](babun.md) nicht vollständig ersetzen. Mir fehlt hier einfach ein konsolenbasierte Paketmanager.

## Vergleich der beiden Ansätze
Ich hatte mit der Docker Toolbox folgende Probleme:

* das Handling mit dem zu startenden Boot2Docker-Virtualbox-Image klappt meistens ganz gut (weil es beim Docker Quickstart Terminal automatisch gestartet wird - sofern es noch nicht läuft), aber leider nicht immer. Es ist spürbar, daß es sich eher um einen Workaround handelt. Das ist beim Docker for Windows viel besser.
* der Start des Boot2Docker-Images (insbes. die Netzwerk-Konfiguration ... ``Waiting for an IP``) dauert recht lang
* Volumes mit relativen Pfaden (``- ./myfolder:/opt/myfolder``) haben nicht funktioniert. Ich mußte stattdessen absolute Pfade verwenden, die dann aber i. a. nicht bei allen Nutzern passen. Insbesondere wenn unterschiedliche Betriebssystem genutzt werden (siehe FAQ Frage 1) ist das wirklich ein Problem, weil man Fallunterscheidungen machen muß oder in den Docker-Hosts entsprechende Konfigurationen vornehmen muß. Das kann man alles lösen, macht die Erstkonfiguration aber dementsprechend aufwendig und reduziert dadurch die Akzeptanz durch Nutzer, die an der dahinterliegenden Technik nicht interessiert sind ... es muss einfach laufen (PO, Sales, QA)
* die Berechtigungen in den Volumes haben nicht gepaßt, so daß sich MySQL beschwerte, daß ein Konfigurationsfile world-writabe ist und deshalb ignoriert wird (siehe FAQ Frage 2)
* das Docker Quickstart Terminal konnte eine vollwertige Shell wie cygwin/babun nicht ersetzen, weil hier essentielle Tools wie beispielsweise ``wget`` fehlten. Andererseits wurde das Quickstart Terminal benötigt, weil in den Alternativen Shells die Docker-Tools (``docker-compose``, ``docker``, ...) nicht out-of-the-box funktionierten

**KLARER GEWINNER:** Docker for Windows

--- 

# Babun/Cygwin
Die Nutzung von alternativen Shells scheint sowohl mit Docker Toolbox als auch mit Docker for Windows nicht ganz einfach ... und wirkt ziemlich abschreckend und wenig vertrauenerweckend.

Glücklicherweise muß ich Docker nicht unter Windows nutzen, aber meine Windows-Kollegen müssen natürlich auch Docker nutzen können, wenn es mal ein zentraler Aspekt der Anwendungsarchitektur werden soll. Aber es kann ja nicht sein, daß ein Developer-Betriebssystem (naja, ist Windows tatsächlich ein?) entscheidet, ob eine Architektur eingeführt werden kann.

Unter Babun ist das ``docker`` Kommando interessanterweise nur eine ``function``, die in ``~/.babun-docker/bin/babun-docker.sh`` definiert wird und in den Start der zsh eingehangen ist. Dort steckt allerdings Handling bzlg. Babun, Cygwin, Virtualbox drin.

---

# FAQ
**Frage 1:** Unter Windows mit der Docker Toolbox (!!! ... unter Linux problemlos) hat die relative Adressierung in einer Volume-Definition von ``docker-composse.yml`` nicht funktioniert. Das Verzeichnis wurde einfach nicht eingebunden und ich konnte somit auch nicht auf die darin befindlichen Dateien zugreifen. 

```
volumes:
  - ./foo:/mnt/foo
```

**Antwort 1:** Deshalb ist der Docker for Windows Ansatz besser geeignet ... da funktioniert es genauso wie unter Linux - relative Adressierung ... kein Problem.

**Antwort 1a:** Das funktioniert nur, wenn das aktuelle Verzeichnis unter dem Windows-Home liegt.

**Antwort 1b:** Das wird auch hier diskutiert: https://github.com/docker/docker/issues/15526. Bei absoluter Adressierung eines Gast-Pfades hat es funktioniert:

```
volumes:
  - /windows-host/my-docker-compose/foo:/mnt/foo
```

Der Gast-Pfad muß dann aber so gemounted werden, daß dort auch tatsächlich das entsprechende Verzeichnis vom Host-System liegt. Hierzu muß die Shared-Folder Konfiguration des Boot2Docker-Images angepaßt werden (siehe https://support.divio.com/hc/en-us/articles/207537665-Mount-host-folders-to-Docker-VM). Das tut man entweder über die GUI oder VBoxManage. Bei folgendem Filesystemaufbau

```
d:
  my-docker-compose/
    foo/
      anyFile.txt
    docker-compose.yml
```
 würde man folgendes tun:

**Step 1:** Shared Folder hinzufügen (dazu muß das Boot2Docker Image gestoppt sein ... z. B. über VirtualBox-GUI):

```
/cygdrive/c/Programme/VirtualBox/VBoxManage.exe sharedfolder add default \
   -name windows-host 
   -hostpath d:
   --automount
```

**Step 2:** Boot2docker Image anpassen, um den neuen Shared-Folder bei jedem Start automatisch unter ``/mnt/foo`` zu mounten. Docker Terminal starten (dadurch startet automatisch das Boot2docker Image namens *default*) und folgende Befehle eingeben:

```
docker-machine ssh default
sudo su
echo "sudo mkdir /windows_host && \
   sudo mount -t vboxsf windows_host /windows_host" \
   >> /var/lib/boot2docker/bootlocal.sh
sh /var/lib/boot2docker/bootlocal.sh
```

**Frage 2:** Works on my machine ... mein Docker-Mysql-Container bezieht unter Linux meine MySQL Konfigurationsdatei ``my-mysql.cnf`` ein, aber unter Windows mit der Windows Toolbox wird sie mit der Meldung "World-writable config file ... is ignored" ignoriert:

```
pfh@machine MINGW64 /d/dev/src/docker-platform (master)
total 1
-rw-r--r-- 1 pfh 1049089 46 Sep 15 16:22 my-mysql.cnf

pfh@machine MINGW64 /d/dev/src/docker-platform (master)
$ docker-compose up mysql
Creating mysql
Attaching to mysql
	Initializing database
	mysqld: [Warning] World-writable config file '/etc/mysql/conf.d/my-mysql.cnf' is ignored.
```

**Antwort 2a:** Tja, deshalb verwende ich lieber Linux ... das Problem wird auch hier diskutiert: http://stackoverflow.com/questions/37001272/fixing-world-writable-mysql-error-in-docker. Man kann das u. a. lösen, indem man die Permissions unter Windows auf Read-Only setzt (über Git ``.permissions`` lässt sich das vermutlich auch automatisieren).

```
pfh@machine MINGW64 /d/dev/src/docker-platform (master)
total 1
-r--r--r-- 1 pfh 1049089 46 Sep 15 16:22 my-mysql.cnf
```

Nicht unbedingt das was man möchte (gelegentlich will man hier ja vielleicht Änderungen vornehmen)... funzt aber zumindest.

**Antwort 2b:** Über ein Zwischenvolume und das Kopieren ins Filesystem des Docker Containers mit entsprechenden Berechtigungen lässt sich das Problem auch lösen: wird hier dargestellt: http://stackoverflow.com/questions/37001272/fixing-world-writable-mysql-error-in-docker. Nachteil ist allerdings, daß man noch Scripting drumrumbasteln muß ... nicht gerade das, was man will.

**Antwort 2c:** Mounten des Volumes als read-only (``/docker-platform/containerContributions/mysql:/etc/mysql/conf.d:ro``) hilft leider nicht.

**Frage 3:** Ich verwende den Docker Toolbox Ansatz. Die Docker-Tools funktionieren auch im Docker Quickstart Terminal ganz wunderbar. Leider aber nicht in meiner Default-Shell Babun.

**Antwort 3a:** Out-of-the-box geht das nicht ... immer wieder seltsame Probleme wie diese:

```
{ docker-platform } master » docker-machine start default
Starting "default"...
Machine "default" is already running.
{ docker-platform } master » docker-compose up
Couldn't connect to Docker daemon - you might need to run `docker-machine start default`.
```

oder auch der bereits oben aufgeführte ``open //./pipe/docker_engine`` Fehler.

Antwort 3b: Vielleicht hilft hier babun-docker (https://github.com/tiangolo/babun-docker)?

**Frage 4:** Ich verwende unter Windows Babun mit der zsh-Shell, doch ich bekomme folgenden Fehler (Docker Toolbox wird genutzt) - dieser Fehler kommt mit dem Docker Quickstart Terminal (aus der Docker Toolbox) übrigens nicht: 

```
{ Dev } master » docker run \
      -v $PWD:/work \
      -it nginx \
      openssl genrsa -des3 -out /work/client.key.pem 1024
the input device is not a TTY.  If you are using mintty, try prefixing the command with 'winpty'
-- babun-docker: Using winpty
```

**Antwort 4:** Tatsächlich hilft es, wenn ich statt ``docker run ...`` ein ``winpty docker run ...`` verwende, aber das wollt ich natürlich nicht immer machen (vor allem nicht bei Skripten, die zwischen Windows- und Linux-Users geteilt werden). 

**Frage 5:** Ich verwende unter Windows Babun mit der zsh-Shell, doch ich bekomme folgenden Fehler (Docker for Windows) - diese Abfrage kommt immer wieder: 

**Antwort 5:** Bei der Recherche stellte  sich dann raus (bei der Suche nach dem Executable per ``which docker``), daß ``docker`` in Wahrheit unter Babun-Zsh nur eine Function ist (definiert in ``~/.babun-docker/bin/babun-docker.sh``