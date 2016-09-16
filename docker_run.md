# docker run
Beim Erzeugen eines Containers per ``docker run`` wird aus einem Image ein Container instanziiert. Es wird geschaut, ob das Image lokal schon vorhanden ist. Wenn nicht, wird es vom konfigurierten Repository (z. B. DockerHub) automatisch runtergeladen.

Container können nur einen einzigen Befehl ausführen (ich nenne die mal **Command-Container**) und stoppen dann automatisch. Sie bleiben dann als Container noch lokal auf der Platte vorhanden (sichtbar per ``docker ps -a``). Bei solchen Containern macht ein start per ``docker start container-id`` keinen Sinn, weil sie sofort bereits alles getan haben, was ihnen aufgetragen wurde. Die Logausgabe kann per ``docker logs container-id`` sowohl bei laufenden als auch bei gestoppten Containern ansehen. Man kann sie dementsprechend auch einfach per ``docker rm container-id`` löschen.

Container, die als dauerhafter Service laufen sollen (ich nenne sie **Service-Container**), arbeiten hingegen dauerhaft ... werden also nicht sofort wieder gestoppt. Auf solche Container kann man sich dann per ``docker exec -it bash`` auf die Console verbinden und umschauen. Solche Container können auch gestoppt werden (``docker stop container-id``) und später wieder gestartet werden (``docker start container-id``) wodurch sie wieder in den letzten Status gehen und im best-case einfach ihren Dienst wieder absolvieren. Sie behalten somit also ihren Zustand!!! Hat man dem Container einen Namen beim Start gegeben (``docker run --name bla hello-world``), dann ist der Container benannt (hier ``bla``) und ein anschließendes ``docker run --name bla hello-world`` ist nicht möglich, weil der Container noch existiert (aber evtl. gestoppt ist). Man muß den Container dann evtl. erst stoppen (``docker stop bla``) und dann löschen (``docker rm bla``) bevor ein neuer Container mit diesem Namen angelegt werden kann.

>ACHTUNG: es gibt auch den Befehl ``docker start my-container``, der einen beendeten Container startet (``docker stop my-container`` stoppt einen laufenden Container).

## Images zum Rumspielen
Zum Rumspielen genügen sehr kleine Images wie

* hello-world
* busybox (< 5MB)

## Ausführungsmodi eines Containers

**Temporär:**
```
sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
``` 

Nachdem Hello world ausgegeben wurde, wird der Container auch gleich wieder gestoppt. Der Container wird bei ``docker ps`` nicht mehr angezeigt, nur noch bei ``docker ps -a`` (``-a`` = all).

**Interaktiv:**
```
sudo docker run -t -i ubuntu:14.04 /bin/bash
```

anschließend landet man auf der Konsole des Containers ... und siehe da: es sieht aus wie ein typisches Linux-Filesystem. Ausschließlich am geänderten Prompt (z. B. ``root@aab3edb0b6f3:/etc#``) merkt man, daß die Shell scheinbar gewechselt wurde.

Wenn die Console (per exit oder Ctrl-D) verlassen wird, dann wird der Container auch gestoppt.

**Dämonized:**
```
sudo docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

Verläßt man einen laufenden Container mit ``Ctrl-C``, so erhält er ein ``SIGKILL`` Event, so daß der Container noch sauber runterfahren kann. Will man den Container stattdessen im Hintergrund weiterlaufen lassen, so sollte man ``Ctrl-p`` ``Ctrl-q`` verwenden, um die Console zu verlassen.

## Umgebungsvariablen setzen
Häufig basieren Docker-Container auf Umgebungsvariablen, um eine Integration in die jeweilige Infrastruktur zu ermöglichen. Solche Umgebungsvraiablen können per ``-e `` gesetzt werden:

```
docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw
```

## Fehlersuche in Containern
Die Fehlersuche hat mich anfangs vor ein ziemliches Problem gestellt und dazu bewogen, die Docker-Konzepte zunächst mal ansatzweise zu verstehen. Nichtsdestotrotz stand ich auch danach erst mal wie der Ochs vorm Berg.

Weiterhin problematisch finde ich, daß in den meisten Images nicht mal die einfachsten Tools (z. B. ``less``) verfügbar sind ... von Analysewerkzeugen (z. B. ``netstat``, ``dig``) ganz zu schweigen. 

### Logs anschauen
Mit 

```
docker logs silly_wozniak
```

erhält die Konsolenausgabe des Containers - das funktioniert auch mit nicht mehr laufenden Containern (siehe ``docker ps -a``).

### Konfiguration anschauen
Mit 

```
docker inspect silly_wozniak
```

erhält man Informationen über den Container - das funktioniert auch mit nicht mehr laufenden Containern (siehe ``docker ps -a``).

### Shellzugriff
Ein Shellzugriff ist nur auf einen laufenden Container möglich (das gestaltet die Fehlersuche manchmal recht schwierig). Insofern macht das auch nur bei Service-Containern Sinn, die dauerhaft laufen und nicht nur ein Kommando ausführen.

```
docker exec -it my-container bash
```

### Konsolenzugriff
Mit 

```
docker attach silly_wozniak
```

erhält man die Shell-Console auf dem Container (sofern der Container tatsächlich noch läuft). Sollte der Container nicht mehr laufen, so  kann man ihn evtl. mit ``docker start `` starten.

>ACHTUNG: um einen Container zu verlassen, ohne ihn zu stoppen, muß man ``CTRL-p`` ``CTRL-q`` verwenden.

### Logs anschauen
```
docker logs silly_wozniak
```

### docker events
Per 

```
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

 Am besten führt man diesen Befehl in einem anderen Konsolenfenster aus, damit sich die Informationen nicht so mitt rein mischen.



