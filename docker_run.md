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

```bash
sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
```

Nachdem Hello world ausgegeben wurde, wird der Container auch gleich wieder gestoppt. Der Container wird bei ``docker ps`` nicht mehr angezeigt, nur noch bei ``docker ps -a`` (``-a`` = all).

**Interaktiv:**

```bash
sudo docker run -t -i ubuntu:14.04 /bin/bash
```

anschließend landet man auf der Konsole des Containers ... und siehe da: es sieht aus wie ein typisches Linux-Filesystem. Ausschließlich am geänderten Prompt (z. B. ``root@aab3edb0b6f3:/etc#``) merkt man, daß die Shell scheinbar gewechselt wurde.

Wenn die Console (per exit oder Ctrl-D) verlassen wird, dann wird der Container auch gestoppt.

**Dämonized:**

```bash
sudo docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
```

Verläßt man einen laufenden Container mit ``Ctrl-C``, so erhält er ein ``SIGKILL`` Event, so daß der Container noch sauber runterfahren kann. Will man den Container stattdessen im Hintergrund weiterlaufen lassen, so sollte man ``Ctrl-p`` ``Ctrl-q`` verwenden, um die Console zu verlassen.

## Umgebungsvariablen setzen

Häufig basieren Docker-Container auf Umgebungsvariablen, um eine Integration in die jeweilige Infrastruktur zu ermöglichen. Solche Umgebungsvraiablen können per ``-e`` gesetzt werden:

```bash
docker run -e MYSQL_ROOT_PASSWORD=my-secret-pw
```

## Entrypoint override

`docker run -it --entrypoint "/bin/ls" ubuntu:14.04 -al /mnt`
