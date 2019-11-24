# Fluentd

* [Why Fluentd](https://www.fluentd.org/why)

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
  * für Custom-Formate schreibt man einen Parser

---

## Alternativen

* [Logstash](https://medium.com/tensult/the-log-battle-logstash-and-fluentd-c65f2f7c24b4)
  * findet im beliebten ELK-Stack Verwendung
* [Splunk](https://www.splunk.com/)
* [LogPacker]

---

## Plugin-Konzept

Fluentd basiert auf einem Plugin-Konzept.

---

## Docker Integration

Man kann 