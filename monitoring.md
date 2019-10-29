# Monitoring

Monitoring und Alerting ist für den professionellen Betrieb und die Weiterentwicklung einer Anwendung unabdingbar.

Betrieb:

* Entdeckung von Fehlersituationen
* Entdeckung von Ressourcenengpässen (Entwicklung der Antwortzeiten)
* ...

Weiterentwicklung:

* wie wird die Anwendung genutzt ... welche Services sind besonders hoch frequentiert
* wo sind Bottlenecks, d. h. wo lohnt es sich zu optimieren (Entwicklung der Antwortzeiten)
* ...

---

## Granularität

Aus meiner Sicht gibt es verschiedene Granularitäten

* Business-Sicht
  * wieviele Businessprozesse werden angefragt/abgeschlossen
  * hier sollte Alerting ansetzen, denn das ist die Sicht des Kunden
  * zur Root-Cause-Analyse wird die technische Sicht benötigt und natürlich entsprechendes Logging
* technische Sicht
  * hier werden die üblichen technischen Parameter (RAM, I/O, Locks, ...) abgefragt

---

## Produkte

### Instana

[siehe separate Seite](instana.md)

### Zabbix

## Nagios

## Grafana - Prometheus

## Grafana - Graphite
