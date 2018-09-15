# Consul

Consul bietet folgende Services

* Key-Value-Store
* Service Discovery

## Architektur

Consul besteht aus

* Consul Server Cluster
  Consul Server Cluster verwendet wird
  * es gibt einen sog. Leader unter den Cluster Knoten
* Consul Client Agents
  * werden von Prozessen für den Zugriff auf das Consul Server Cluster verwendet

### Ports

Das sind die Standardports von Consul Client und Server:

* 8500:
  * WEB UI (http://myserver:8500/ui/dev/services)

## Getting Started

Wie immer in der heutigen Zeit kommt man am schnellsten mit [Docker](docker.md) voran:

```bash
docker run -d --net=host --name=myConsul consul
```

Das WEB UI steht dann unter [http://localhost:8500/ui](http://localhost:8500/ui) zur Verfügung (ACHTUNG: der Container verliert seine Daten durch einen Restart). Hier können dann Key/Values (z. B. `service/foo/server/port`) manuell eingegeben werden (zum rumspielen).

Anwendungen benötigen i. a. eine Konfiguration als Property File. Vor dem Start der Anwendung würde man ausgehend von einem Property-File Template (z. B. `application.yaml.ctmpl` - enthält Platzhalter)

```yml
server:
  port: {{ key "service/foo/server/port" }}
```

 per `consul-template` die Platzhalter auflösen

```bash
/usr/bin/consul-template \
    -config=consul-template.hcl \
    -once \
    -log-level=debug \
    -consul-retry-attempts=2
```

und eine platzhalterfreie Konfigurationsdatei application.yaml` erzeugen, die in der Anwendung referenziert wird.

Die referenzierte Konfigurationsdatei `consul-template.hcl` könnte so aussehen:

```
template {
    error_on_missing_key = true
    source = "application.yaml.ctmpl"
    destination = "application.yaml"
}
```
