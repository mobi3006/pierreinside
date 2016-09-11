# docker run
Beim Erzeugen eines Containers per ``docker run`` wird aus einem Image ein Container instanziiert. Es wird geschaut, ob das Image lokal schon vorhanden ist. Wenn nicht, wird es vom konfigurierten Repository (z. B. DockerHub) automatisch runtergeladen.

>ACHTUNG: es gibt auch den Befehl ``docker start my-container``, der einen beendeten Container startet (``docker stop my-container`` stoppt einen laufenden Container).

## Images zum Rumspielen
Zum Rumspielen genügen sehr kleine Images wie

* helo-world
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

## Zugriffsmöglichkeiten auf einen laufenden Container
### Konfiguration anschauen
Mit 

```
docker inspect silly_wozniak
```

erhält man Informationen über den Container - das funktioniert auch mit nicht mehr laufenden Containern.

### Shellzugriff
Mit 

```
docker attach silly_wozniak
```

erhält man eine Console auf dem Container (sofern der Container tatsächlich noch läuft). Sollte der Container nicht mehr laufen, so kann man ihn natürlich mit ``docker start`` starten.

>ACHTUNG: um einen Container zu verlassen, ohne ihn zu stoppen, muß man ``CTRL-p`` ``CTRL-q`` verwenden.

### Logs anschauen
```
docker logs silly_wozniak
```

