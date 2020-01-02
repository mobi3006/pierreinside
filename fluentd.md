# Fluentd

* [Why Fluentd](https://www.fluentd.org/why)

Fluentd ist im Gegensatz zu ELK keine komplette Lösung (bestehend aus UI, Processing, Storage) - es handelt sich nur um einen Datensammler und integriert sich auch in bereits existierende Logging-Infrastrukturen, ganz ähnlich zu Logstash (aber deutlich performanter). Man kann hier viele Quellen und Ziele anbinden. Zwischendrin verarbeitet Fluentd die Daten (buffer/filter/route)

* Buffering
* Filtering
* Enrichment
* Parsing unstructured Data
* Format-Transformation
* Routing
  * File
  * S3
  * MySql
  * Nagios
  * ...

So sieht die Processing-Chain (= Data-Pipeline) aus und für jeden Abschnitt gibt es entsprechende [Plugins](https://www.fluentd.org/plugins) (u. a. > 200 Output-Plugins):

> Input => Parser => Filter => Buffer => Output => Formatter

Fluentd verarbeitet Nachrichten (Strings, Json), die von einer `source` kommen (push) oder aus einer solchen gezogen (pull) werden und transformiert diese zunächst einmal in das Fluentd-JSON-based-Datenmodell basierend auf Events. Ein Event besteht aus

* `tag` - z. B. `myapp.access`
* `time` im Unix Time-Format
* `record` - Daten im JSON-Format

> ACHTUNG: Parsing kann sehr CPU-intensiv werden (bei hohem Log-Aufkommen) - Input-Plugins sind NIEMALS blockierend

Fluentd ist eine Input-Processing-Output-Komponente und wir häufig bei der Zentralisierung/Konsolidierung von Logs aus verschiedenen Quellen verwendet. Hierbei werden einkommende Log-Nachrichten gefiltert, mit Informationen angereichert, in ein einheitliches Format transformiert und dann zu einem oder mehreren Repositories weitergeleitet.

> Diese Ansätze werden häufig beim Logging eingesetzt. Aufgrund der dynamischen Last-Verteilung über Multi-Nodes-Architekturen sind die konversativen (veralteten) Ansätze von vor 10 Jahren nicht mehr geeignet, um diese Use-Cases zu adressieren.

Auf diese Weise entsteht eine konsolidierte Sicht auf die Log-Nachrichten, die aus verschiedensten Quellen mit verschiedensten Formaten kommen. Durch die Sammlung in einer für diese Datenmenge ausgelegten hochverfügbaren Technologie (No-SQL Datenbanken wie ElasticSearch, Graylog, ...) hat man immer schnellen Zugriff auf die relevanten Informationen und kann nach verschiedensten Attributen suchen.

> Dieses Thema ist unternehmenskritisch, da Logs i. a. in Produktivumgebungen die einzige Möglichkeit sind, um Fehler zu analysieren und den Kunden vor längeren Systemausfällen zu schützen. Die Verwendung von Real-Time-Analyse-Tools wie [Instana](instana.md) ist noch besser ...

Aus diesem Grund kann Fluentd

* aus [vielen Quellen lesen (TCP, UDP, Syslog, tail, ...)](https://docs.fluentd.org/input)
* in [viele Ziele schreiben (StdOut, file, S3, ElasticSearch, http, ...)](https://docs.fluentd.org/output)

Zwischendrin werden Messages

* [gefiltert](https://docs.fluentd.org/filter)
* [geparst](https://docs.fluentd.org/parser)
  * es gibt Standard-Parser für typische Log-Formate wie z. B. [NGINX](https://docs.fluentd.org/parser/nginx)
  * alternativ kann man reguläre Ausdrücker verwenden und [hier testen](https://fluentular.herokuapp.com/)
  * für Custom-Formate schreibt man einen Parser

... Sketch ...

---

## Alternativen

* [Logstash](https://medium.com/tensult/the-log-battle-logstash-and-fluentd-c65f2f7c24b4)
  * findet im beliebten ELK-Stack Verwendung
* [Splunk](https://www.splunk.com/)
* [LogPacker]

---

## Sprache / DSL

* [Config-File Dokumentation](https://docs.fluentd.org/configuration/config-file)

Ohne das Konzept bzw. die Sprache verstanden zu haben ist die Konfigurationsdatei kaum zu verstehen. [Diese Doku](https://docs.fluentd.org/configuration/config-file) bietet einen guten Einstieg.

Fluentd verwendet einen Plugin-Ansatz für diese Aspekte - Erweiterbarkeit war ein wichtiges Qualitätskriterium beim Design der Lösung. Dadurch lassen sich mit einer Logging-Lösung viele verschiedene - auch sehr spezielle - Use-Cases abbilden. Im schlimmsten Fall schreibt man sich sein eigenes Plugin, im einfachsten Fall paßt man nur die Logik über die Fluentd-Sprache an oder verwendet existierende Plugins.

Konzepte ([fluentd documentation](https://docs.fluentd.org/configuration/config-file)):

* "Fluentd allows you to route events based on their tags"
  * woher kommen die Tags?
    * wenn eine Log-Nachricht bereits im JSON-Format kommt (beispielsweise weil man den Logback-GelfAppender verwendet), dann kann dort schon ein `tag` verbaut sein
    * aus dem internen Fluentd-Processing
    * aus der Source, z. B. bei einer `http` Source wird das Tag aus der URL genommen
      * HTTP-Request http://localhost:9880/pierre?json={"logit":"now"} liefert das Tag `pierre`
* "Fluentd tries to match tags in the order that they appear in the config file."
  * "Wider match patterns should be defined after tight match patterns."
  * "If you want to send events to multiple outputs, consider out_copy plugin."
  * "The common pitfall is when you put a `<filter>` block after `<match>`."

Die wichtigesten Elemente sind:

* `<system>`
* `<source>`
  * http
    * hier wird ein HTTP endpoint erzeugt - bedienbar per Browser oder CLI's wie `curl`
  * forward
    * hier wird ein TCP endpoint erzeugt
* `<filter>`
  * filter bedeutet nicht, daß nur ein rausfiltern möglich ist
  * es können per `<record>` weitere Informationen hinzugefügt werden, die dem Event hinzugefügt werden und dann auch in der Output-Phase ausgegeben werden
  * es kann ein Parsing (`<parse>`) erfolgen, bei dem beispielsweise [Raw-String-Logs in JSON transformiert werden](https://docs.fluentd.org/filter/parser)
* `<match>`
  * trigger action
  * man kann auch mehrere Tags matchen: `<match {app.**,system.logs}>`
* `<label>`
  * Routing für ein Event mit
* `<store>`
* `@type`
  * hierüber wird das Plugin selektiert und damit die unterstützen nachfolgenden Aktionen/Konfigurationen
* `tag`
  * einem Event ein weiteres Tag verpassen - über die Tags wird bei `filter` und `match` selektiert
* `@label`
  * hierbei handelt es sich um leichtgewichtige `tag`s:
    > "The "label" directive groups filter and output for internal routing. "label" reduces the complexity of tag handling. [...] "label" is useful for event flow separation without tag prefix." ([fluentd documentation](https://docs.fluentd.org/configuration/config-file))
* `@include`

### Input = Source

Der `type` kennzeichnet das Plugin.

Aus Dateien lesen:

```xml
<source>
  type tail
  path /var/log/httpd.log
  format apache2
  tag web.access
</source>
```

Aus Anwendungen Events erhalten:

```xml
<source>
  type forward
  port 24224
</source>
```

Daten von einem TCP-Socket erhalten und mit einem Regex-Parser parsen:

```xml
<source>
  type tcp
  tag tcp.data
  format /^(?<field_1>\d+) (?<field_2>\w+)/
</source>
```

### Target = Output

Alle Events an ein Ziel weiterleiten/speichern:

```xml
<match *>
  type mongo
  database fluentd
  collection test
</match>
```

Bestimmte Events (`match` - hier mit dem tag `backend.foo`) an ein Ziel weiterleiten/speichern:

```xml
<match backend.*>
  type mongo
  database fluentd
  collection test
</match>
```

Mit de `copy`-Befehl kann man die Daten auch an mehrere Targets verschicken, hier beispielsweise an ElasticSearch und Hadoop:

```xml
<match backend.*>
  type copy

  <match>
    type elasticsearch
    logstash_format true
  </match>

  <match>
    type webhdfs
    host blablub
    port 50070
    path /path/on/hdfs
  </match>
</match>
```

---

## Getting Started

### Docker

* [Link auf offizielle Doku](https://docs.fluentd.org/container-deployment/install-by-docker)

Ich lege erzeuge `/home/pfh/src/de.cachaca.learn.fluentd/fluent.conf` mit diesem Inhalt an:

```fluent.conf
# Receive events from 24224/tcp
# This is used by log forwarding and the fluent-cat command
<source>
  @type forward
  port 24224
</source>

# http://localhost:9880/pierre?json={"event":"data"}
<source>
  @type http
  port 9880
</source>

<match pierre>
  @type file
  path /fluentd/log
</match>
```

lege ein Log-Verzeichnis an:

```bash
mkdir -p /tmp/fluentd/log
chmod -R 777 /tmp/fluentd/log
```

und starte einen Docker-Container mit dem Namen `pierre-fluentd`:

```bash
docker run -d \
    --name pierre-fluentd \
    -p 24224:24224 \
    -p 24224:24224/udp \
    -p 9880:9880 \
    -v /tmp/fluentd/log:/fluentd/log \
    -v /home/pfh/src/de.cachaca.learn.fluentd:/fluentd/etc \
    fluentd
```

Per `docker logs pierre-fluentd` kann ich die Initialisierung des Fluentd-Servers einsehen.

Anschließend kann ich über den HTTP-Endpoint Log-Nachrichten erzeugen:

* im Browser: http://localhost:9880/pierre?json={%22logit%22:%22now%22}
* per curl: `curl -X POST -d 'json={"json":"message"}' http://localhost:9880/pierre`

und die Ausgabe im Verzeichnis `/tmp/fluentd/log` anschauen.

> ACHTUNG: `pierre` wird hier als `tag` verwendet, so daß es zu `match pierre` paßt.

Per `docker rm -f pierre-fluentd` lösche ich den Fluentd-Container wieder nach getaner Arbeit.

### Fluentd-UI

* [Homepage](https://docs.fluentd.org/deployment/fluentd-ui)

... noch nicht ausprobiert - ich mag die Console lieber
