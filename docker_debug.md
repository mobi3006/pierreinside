# Debugging Docker

Docker ist eine feine Sache, doch die Fehlersuche gestaltet sich hin und wieder zum Albtraum, da der Container zunächst mal irgendwie nicht greifbar ist - insbesondere nicht, wenn er nicht mehr läuft. Die Fehlersuche hat mich anfangs vor ein ziemliches Problem gestellt und dazu bewogen, die Docker-Konzepte zunächst mal ansatzweise zu verstehen. Nichtsdestotrotz stand ich auch danach erst mal wie der Ochs vorm Berg.

## Container läuft noch

Wenn ein Docker Container nicht schon beim Start stirbt oder gleich nach dem Start beendet wird (weil nur ein paar Befehle ausgefürt werden), dann ist die Fehlersuche schon mal einfacher.

### Logs anschauen

Per `docker logs myContainer` kann man sich die Logs des Container anschauen - das funktioniert auch mit nicht mehr laufenden Containern (siehe ``docker ps -a``).

### Befehle im Container

Per `docker exec -it myRunningContainer bash` kann man sich eine Shell im Container ergattern und ein wenig rumschnüffeln.

### Installation von Tools

Problematisch finde ich, daß in den meisten Images nicht mal die einfachsten Tools (z. B. ``less``) verfügbar sind (natürlich nicht, denn die Images sind i. a. minimal). Die Nutzung von Analyse-Tools ist somit erst gar nicht möglich.

Allerdings lassen sich diese Tools on-the-fly nachinstallieren. Hierzu öffnet man eine Konsole im Container (`docker exec -it myRunningContainer bash`) und installiert die Software (z. B. `apt-get install telnet`) mit dem jeweiligen Paketmanager.

### Konfiguration anschauen

Mit`docker inspect myContainer` erhält man Informationen über den Container - das funktioniert auch mit nicht mehr laufenden Containern (siehe ``docker ps -a``).

### docker events

Per

```bash
docker events
```

erhält man auf der Konsole zusätzliche Informationen wie diese:

```
137 pfh@workbench ~ % docker events                                                                                                                                     :(
2016-09-12T13:25:39.211049880+02:00 container create 55260...
	(image=mobi3006/glassfish:3.1.2.2, name=nostalgic_bohr)
2016-09-12T13:25:39.212171664+02:00 container attach 55260...
	(image=mobi3006/glassfish:3.1.2.2, name=nostalgic_bohr)
2016-09-12T13:25:39.230392314+02:00 network connect fdd42...
	(container=55260..., name=bridge, type=bridge)
2016-09-12T13:25:39.233426688+02:00 volume mount ffadc...
	(container=55260..., destination=/mnt/containerContributions/artifacts, driver=local, propagation=, read/write=true)
2016-09-12T13:25:39.233447617+02:00 volume mount e3ebb...
	(container=55260..., destination=/mnt/containerContributions/config, driver=local, propagation=, read/write=true)
2016-09-12T13:25:39.378383107+02:00 container start 55260...
	(image=mobi3006/glassfish:3.1.2.2, name=nostalgic_bohr)
2016-09-12T13:25:39.379673101+02:00 container resize 5526...
	(height=35, image=mobi3006/glassfish:3.1.2.2, name=nostalgic_bohr, width=171)
2016-09-12T13:25:39.416374044+02:00 container die 55260...
	(exitCode=99, image=mobi3006/glassfish:3.1.2.2, name=nostalgic_bohr)
2016-09-12T13:25:39.526018442+02:00 network disconnect fdd42...
	(container=55260..., name=bridge, type=bridge)
2016-09-12T13:25:39.550278951+02:00 volume unmount ffadc...
	(container=55260..., driver=local)
2016-09-12T13:25:39.550304339+02:00 volume unmount e3ebb...
	(container=55260..., driver=local)
```

 Am besten führt man diesen Befehl in einem anderen Konsolenfenster aus, damit sich die Informationen nicht so mitten rein mischen.

## Container stirbt beim Start

Wenn ein Docker Container schon beim Start stirbt, dann ist die Fehlersuche schwieriger.

### Logs anschauen

... funktioniert auch bei beendeten Containern - siehe oben

### Konfiguration anschauen

... funktioniert auch bei beendeten Containern - siehe oben

### Shellzugriff durch Einschränkung der Initialisierungsroutine

Wenn der Container schon beim Starten abraucht, so kann am Entrypoint des Images liegen, der für die Initialisierung des Containers zuständig ist. Hier wird ein Container des Images `panubo/vsftpd` gestartet, ohne den Entrypoint des Images auszuführen:

```bash
docker run -t -it panubo/vsftpd /bin/bash
```

Auf diese Weise erhält man eine Konsole auf dem Container und kann das Entrypoint-Script evtl. manuell ausführen und so den Fehler reproduzieren.