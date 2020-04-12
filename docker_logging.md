# Docker Logging

Logs werden standardmäßig auf `STDOUT` geschrieben und landen dann in einem File auf dem Docker Host. Bei `docker logs` werden `STDOUT` und `STDERR` angezeigt.

Das ist sehr praktisch, wenn man lokal in einer kleinen Landschaaft unterwegs ist. Wenn man allerdings in verteilten Multi-Node-Szenarien arbeitet - wie das normalerweise in Produktivumgebungen der Fall ist, dann will man die Logs an einer zentralen Stelle abfragen (ElasticSearch, Graylog, ...). Früher hat man das Logging Target gerne in die Applikation gepackt, doch damit bürdet man der Applikation auf, sich Gedanken über die spätere Nutzung zu machen - das bürdet der Anwendung mehr Verantwortung auf als nötig und ist dann auch schwierig zu ändern (wenn man mal 1000 Services hat). Deshalb hat sich im Docker-Umfeld durchgesetzt nur nach Standard-Out zu loggen und von dort weiterzuschieben.

Zudem kann es passieren, daß die Anwendungen in ganz unterschiedlichen Log-Formaten (JSON, XML) mit ganz unterschiedlichen Benennungen der Attribute arbeiten. Diese Daten muß man dann i. a. konsolidieren und in ein gemeinsames Format bringen.

> [LogStash](https://www.elastic.co/products/logstash) (z. B. im ELK-Stack - L = Logstash) und [Fluentd](fluentd.md) sind typische Tools für die Konsolidierung/Filterung von Logs.

---

## Log-Drivers

* [Configure Logging Driver](https://docs.docker.com/config/containers/logging/configure/)

Abhängig vom gewählten Log-Driver kann man weitere Parameter konfigurieren. Der Log-Driver kann die Nachrichten sogar [mit weiteren Informationen anreichern](https://docs.docker.com/config/containers/logging/log_tags/) (z. B. Applikationsversion). Den Log-Driver kann man Docker-zentral in `/etc/docker/daemon.json` einstellen und beim Docker-Container-Start (z. B. im `docker-compose.yml`-File oder als Parameter `--log-driver`) überschreiben.

### json-file

Das ist der Default Log-Driver - wenn nichts anderes im Docker-Daemon (`/etc/docker/daemon.json`) oder beim Docker-Container-Start angegeben wurde.

### none

### Syslog

* [Docker Dokumentation Syslog-Log-Driver](https://docs.docker.com/config/containers/logging/syslog/)

### Gelf

* [Docker Dokumentation Gelf-Log-Driver](https://docs.docker.com/config/containers/logging/gelf/)

Logging im Graylog-Format ... typischerweise zu einem Graylog-Server, kann aber auch von anderen Empfängern verstanden werden (Fluentd, LogStash).

### Fluent

* [Docker Dokumentation Fluentd-Log-Driver](https://docs.docker.com/config/containers/logging/fluentd/)

Vom Fluentd-Log-Driver werden standardmäßig einige Informationen hinzugefügt (Container-ID, Container-Name, ...). Man kann aber auch noch eigene Informationen hinzufügen, um so beispielsweise die Applikationsversion zu loggen.

Ein [Fluentd-Server](fluentd.md) kann die Nachrichten - ähnlich wie Logstash - filtern, konsolidieren und mit Daten anreichern.

Eine Integration von Fluentd kann über den Fluentd-Log-Driver geschehen. Eine andere Form der Integration besteht im JSON-LogDriver, der eine Datei auf dem Docker-Host (`/var/lib/docker/containers/...`)erzeugt, die wiederum von Fluentd im tail-Mode gelesen wird. Letztere Variante hat den Vorteil, daß man die Log-Nachrichten bei `docker logs my-container` noch sieht ... die typische Arbeitsweise mit Docker.

### Google Cloud

* [Docker Dokumentation Google-Cloud-Log-Driver](https://docs.docker.com/config/containers/logging/gcplogs/)

---

## Log-Driver Konfiguration im Docker-Daemon

Man kann die Log-Driver Konfiguration im Docker-Daemon als Default für alle Docker Container in der Datei `/etc/docker/daemon.json` vornehmen ([siehe Dokumentation](https://docs.docker.com/config/containers/logging/configure/)). So findet man heraus welcher Logging-Driver im Daemon konfiguriert ist:

```bash
docker info --format '{{.LoggingDriver}}'
```

---

## Log-Driver Konfiguration im Docker-Container

Man kann die Log-Driver Konfiguration des Docker-Daemons gezielt beim Container-Start eines Containers überschreiben:

```bash
docker run -it --log-driver none alpine ash
```
