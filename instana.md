# Instana

Bei diesem Tool handelt es sich um ein Application Performance Monitoring (APM) Tool, das mit den Platzhirschen [New Relic](https://newrelic.com/) und [Dynatrace](https://www.dynatrace.com) konkurriert, aber deutlich günstiger ist.

## Motivation

* [Michael Krumm - Youtube](https://www.youtube.com/watch?v=wghFJGpF3Fw)
* [Instana Webinar](https://www.youtube.com/watch?v=z14wXHzw5lU)

Bei Instana ist Auto-Detection von neuen Hosts (physikalische Sicht), Services, internen Applikationsstrukturen Strukturen (APIs) und deren Beziehungen zueinander das Guiding Light. Insbesondere in elastischen Cloud-Deployments ist das eine sehr wichtige Eigenschaft. Instana versucht, die Semantik der Anwendungen zu verstehen, um nicht nur Daten, sondern tatsächlich Informationen und automatisches Alerting zu liefern. Bei diesem Ziel ist jede (hart geforderte) manuelle Intervention (zur expliziten Abbildung dieser Strukturen) aufgrund des elastischen/agilen Umfeld nicht akzeptabel, weil es zum Scheitern verurteilt ist. Maintenance-Free. Hierzu enthält Instana viel Wissen über Technologien (z. B. JPA), denn das wird bei der Interpretation der Daten benötigt. Auf diese Weise werden die verschiedenen Layer der Applikation erkannt. Damit ist ein Drill-Down vom Web-Service-Request bis runter zu den dadurch ausgelösten Datanbank-Zugriffen möglich. Tatsächliche Bottlenecks können so nicht nur entdeckt, sondern eine evtl. Lösung zeichnet sich im besten Fall schon ab (z. B. wenn 2000 Datenbank-Calls abgesetzt werden, dann werden scheinbar Datenbankzugriffe in einer Loop-Schleife gemacht ... das skaliert natürlich nicht und muß durch Bulk-Queries ersetzt werden). Datenströme (logische Sicht) werden inkl. der Auslastung dargestellt und ermöglichen somit eine gezielte Analyse der Bottlenecks. Asynchrone Kommunikation durch das System kann dem initiierenden Request zugeordnet werden, so daß letztlich der gesamte Kommunikationsweg untersucht werden kann - und das im Live-System.

Die Root-Cause-Analyse soll von Instana vereinfacht werden - deshalb:

* Incidents, werden austomatisch erkannt
* dive deep ... überall kann man leicht filtern (Filterwerte werden i. a. automatisch bereitgestellt)
  * wenn die automatischen Filter nicht ausreichen, dann kann man auch eine Filtersprache verwenden (e. g. `entity.selfType:java`)
* Depp Links werden unterstützt (z. B. in Alert-Notifications), so daß der Kontext sofort ersichtlich ist und zwischen Beteiligten ausgetauscht werden kann

## Alternativen

Mit Ansätzen wie der [Zeitreihen-Datenbankk Prometheus](https://prometheus.io/) lassen sich auch eigene Lösungen stricken, die allerdings zunächst (vielleicht auch dauerhaft) einen hohen zeitlichen Invest erfordern. Letztlich ist man als Betreiber einer Anwendung aber nicht mit den reinen Daten zufrieden, sondern der Nutzen steht und fällt mit der Möglichkeit, aus diesen Unmengen an Daten tatsächlich Informationen zu gewinnen. Nur dadurch lassen sich Probleme/Bottlenecks in der Anwendung aufdecken und gewinnbringende Verbesserungen umsetzen.

Aus guten Grund wurden Lösungen wie Instana, New Relic, Dynatrace, ... geschaffen, die für teures Geld verkauft werden. Eine Selbstimplementierung kann sich wahrscheinlich nur ein Großunternehmen leisten. Eine Adaption vorhandener Open-Source-Lösungen kann auch zeitaufwendig sein oder gar in die Sackgasse führen.

Aus diesem Grund sind bezahlbare fertige (gut supportete) Lösungen eine gute Sache für bestimmte Firmen. Instana scheint diesen Markt im Auge zu haben.

## Konzepte und Features

### SaaS oder On-Premise

Instana bietet seinen Dienst als Software-as-a-Service (präferiert) aber auch als On-Premise-Lösung an.

Gegen eine Saas-Lösung könnte die Geheimhaltung der Daten sprechen ... per Default versucht Instana keine sensiblen Daten zu loggen (z. B. bei SQL-Queries werden keine gebundenen Parameter mitgeloggt), aber letztlich ist es eine Frage des Vertrauens bzw. einen Nachweis aus Compliance Sicht zu erbringen.

### Application Perspective

Application Perspective ist eine gefilterte Ansicht für selektierte Services - Definition durch den Benutzer (Subset aus Services, Endpoints). Alle Requests, die über irrelevante (d. h. applikationsfremde) Services/Endpoints getriggert werden, werden ignoriert. Bei der Definition einer Application Perspective kann man einfach einen oder mehrere Services selektieren und dann alle Downstream-Services automatisch selektieren lassen.

### Services und Endpoints

* Services und Endpoints automatically discovered
  * endpoints define the API of a service
    * automatically discovered types:
      * BATCH
      * DATABASE
      * HTTP
      * MESSAGING
      * RPC
  * services: collection of endpoints
    * kann verteilt sein ... davon abstrahiert Instana

### Traces

Traces sind real-time informationen über die Aktivitäten, die die Services ausführen.

### Infrastrcuture Map

* unmonitored Hosts
  * haben keine Instana-Agents installiert
    * monitored Agents öffnen Verbindungen zu diesen unmonitored Hosts

### Change, Issue, Incident

Datenaufzeichnung ist die Grundlage, um daraus Informationen zu gewinnen. Die geringstmögliche Beaobachtung ist ein Change - hierzu muß vergleicht Instana die Veränderungen am System (z. B. Service gestartet/gestoppt). Instana sammelt die Systemdaten kontinuierlich und benötigt eine kritische Menge an Daten, um einen Überblick über den "normalen" Verlauf zu bekommen und Abweichungen davon festzustellen. Diese Abweichungen werden als Issue bewertet. Nach bestimmten Regeln (system-based oder custom-based) wird aus einem Issue ein Incident.

Change, Issue und Incident haben alle einen Startzeitpunkt und einen Endzeitpunkt.

* Change:
  * start/stop eines Servers/Services
  * trigger ein Deplyoment
  * Konfigurationsänderung
* Issue:
  * unhealthy Entity (Service Latency Degradation, hohe Fehlerraten, Filesystem voll)
* Incident:
  * Issue auf einem Edge System (ein System, das direkte Verbindung zu einem Client hat)
  * Dynamic Graph

Noch besser als nachträglich Probleme erklären zu können ist allerdings, Problemsituationen als Issue zu erkennen BEVOR daraus Incidents werden bzw. für den Benutzer tatsächlich wahrnehmbare Probleme werden.

Instana mißt verschiedene Indikatoren (Durchsatz, Latenz, Fehlerrate, Ausnutzung) und bietet ab einem bestimmten Threshold automatisches Incidenting (Auffälligkeiten) und Alerting (Probleme). In gewisser Weise ist der Alerting Mechanismus auch selbstlernend (Frage: WIRKLICH?). Für eine Root-Cause Analyse läßt sich in einer Zeitmaschine reisen (Time-Shift).

Instana ist elastic-Microservice-aware, d. h. gestoppte Knoten stellen noch nicht automatisch ein Incident dar - zunächst ist das mal nur ein Issue dar.

> ACHTUNG: da die Abtastrate von einer Sekunde sehr hoch ist, aggregiert Instana die Daten ab einem gewissen Alter, um die Datenmenge zu reduzieren. I. a. geschieht das allerdings so spät, daß man zum Zeitpunkt der Root-Cause-Analyse noch alle Daten unaggregiert zur Verfügung hat.

Beispiel:

Bei meinem allerersten Versuch, Instana zu nutzen, wurde mein Host rot gekennzeichnet in der Instana-UI und mit dem Alert "Low Disk Space" gekennzeichnet. Ein `df -h` auf meinem lokalen System offenbarte, daß Instana bescheid wußte. GENIAL.

### Alerting

Ausgehend von Changes, Issues und Incidents können Alerts getriggert und an verschiedene Kanäle (sog. Alerting Integrations ... eMail, PagerDuty, Office365, Webhook) definiert werden, so daß man bei extrem kritischen Situationen Benachrichtigungen an externe System verschickt.

Empfehlung: "Don't waste time creating and maintaining health rules" - das macht Instana automatisch (technologieabhängig)

Instana unterstützt Deep-Links, um bei Notifications direkt in den Scope einzutauchen.

### Service Discovery and Drill-Down

In einem elastischen Microservices Umfeld ist es essentiell, daß neue Services nicht erst aufwendig einkonfiguriert werden müssen. Statdessen leben die Services teilweise nur Minuten oder gar Sekunden.

Instana bietet - ausgehend von einem Services-Aufruf (z. B. Webservice) - einen Drill-Down des gesamten Stack-Traces inkl. Dauer der Requests. Das geht sogar soweit, daß man aus dem Instana-UI in den Java-Code navigieren kann. Awesome :-)

### Interaction Discovery

Instana kann den Weg eines Client-Requests an einen Service über andere Services bis auf unterste Ebene tracen und nachverfolgen. Auf diese Weise lassen sich einersets ganz fein granulare Daten gewinnen (z. B. welche SQL-Query wurde gegen die Datenbank abgesetzt, wie lange hat das gedauert und wie hoch war die I/O-Rate in der Datenbank) und andererseits grobgranulare Informationen (z. B. wie häufig wurde ein Service aufgerufen?) ableiten.

### Zero Configuration

Instana kommt mit dem Anspruch intelligent genug zu sein, um Probleme ohne konfigurierte Grenzwerte zu erkennen.

> Machine lerning algorithms to learn performance patterns.

Allerdings läßt kann man als Application Provider Instana Tips geben oder auch explizit konfigurieren, um bessere Insights zu liefern. Möglichkeiten:

* Instana User Interface: Service Mappers
* Application Code: Java Annotations

### Maintenance-Free

Service Discovery + Interaction Discovery + Zero Configuration &#9658; Maintenance-Free

### 1-Second-Granularity

Die Abtastrate der Sensoren beträgt eine Sekunde, d. h. jede Sekunde werden die Metriken aller beteiligten Komponenten erfaßt und gespeichert.

### Komponentenspezifische Sensoren und Dashboards

Instana kommt mit einer Vielzahl komponentenspezifischer Sensoren

* Betriebssystem
* unterstützte Sprachen: https://www.instana.com/supported-technologies/
* unterstützte Technologien: https://www.instana.com/supported-technologies/

so daß immer die relevanten Metriken gezogen und dargestellt werden können. Das geht sogar soweit, daß zu ein ElasticSearch Knoten Metriken auf folgenden Ebenen im direkten Zugriff sind:

* Lucene Index
* ElastciSearch Shard
* ElasticSearch Cluster
* Java-VM
* OS-Prozess
* Host

Das ist bei der Fehleranalyse sehr hilfreich.

Zudem werden dadurch, daß Instana diese Technologien kennt, besonders auffällige/ungesunde Werte entdeckt. Das kann zu einem Alert führen.

Ein Beispiel:

* bei ElasticSearch können einzelne Knoten gemonitored werden, aber auch ganze Cluster.

### Machine Learning

> Understanding of Patterns of normal behavior by deep learning.

### Komponentenspezifisches Wissen

Da Instana Technology-aware ist (d. h. die eingesetzten Technologien kennt) kann es den Nutzer beim Alerting, bei der Root-Cause-Analyse und beim Problem-Solving unterstützen.

### Metriken

* eigene Metriken können angeboten werden (z. B. Dropwizard Metrics) - zusätzlich zu den Standardmetriken wie CPU, Memory, Heap, ...

### Open-Approach

Instana plant die Sensorentwicklung offen zu gestalten, so daß man für nicht unterstützte Technologien auch eigene Sensoren schreiben kann.

### SDK

* [SDK Dokumentation](https://github.com/instana/instana-java-sdk)
* [Beispiele auf GitHub](https://github.com/instana/instana-java-sdk/tree/master/instana-java-sdk-sample)

Sollte Instana wichtige Strukturen/Zusammenhänge in der Anwendung nicht selbständig erkennen, so lassen sich im Code Metainformationen über Annotationen hinterlegen:

```java
@Span(type = Span.Type.INTERMEDIATE, value = "myService#execute")
```

### API

* [API Dokumentation](https://docs.instana.io/quick_start/api/)
  * u. a. genutzt von [Grafana Instana Plugin](https://grafana.com/plugins/instana-datasource)

Instana bietet eine REST-API, um die Daten automatisiert in die eigenen Workflows einzubinden. Hierzu benötigt man einen API-Key, den man über die Instana UI im Bereich Access Control erzeugen kann (hier definiert man die entsprechenden Berechtigungen).

### Auswertungen über Kategorisierung und Filter

Es stehen folgende Kategorisierungsmöglichkeiten zur Verfügung:
  
* Tenants
  * die Daten verschiedener Tenants sind tatsächlich hart getrennt (z. B. Live vs. Dev/Test) ... ein Filter arbeitet ausschließlich auf den Daten EINES Tenants - im Gegensatz zu den anderen Kategorisierungsmöglichkeiten
* Zones (`entity.zone=myzone`)
* Tags
  * ein Services kann mehrere Tags haben, so daß auf verschiedenen Ebenen gefiltert werden kann
* `entity.type=`

### Cloud-Deployment Datenschutz

Im Gegensatz zu On-Premise-Hosting gibt man beim Cloud-Hosting durch Instana die Daten in deren Obhut - ist das sicher?

> Instana ist SOX-compliant und sichert zu, daß kein Content in Form von URL-Parametern oder Post-Request-Pasyloads auf den Servern

## Architektur

* ein sog. Agent-Prozess (z. B. auch als Docker Container - macht die Nutzung extrem komfortabel) wird auf dem System gestartet ( sehr klein - ca. 50MB Memory) und dann läuft die Auto-Discovery-Maschinerie an
  * enthält komponentenspezifische Sensoren für (Abtastrate: 1 Sekunde)
    * Betriebssystem
    * Java-VM
      * ganz wichtig: man muß den Java-Prozess NICHT mit einem Java-Agent (auf JVM Level) ausstatten. Stattdessen werden die Daten von einem Port abgegriffen, der von der JVM standardmäßig bereitgestellt wird
    * Appserver (z. B. Tomcat)
    * ElasticSearch
    * ...
  * schickt Messwerte ans Backend (On-Premise vs. Cloud)
* Backend (Cloud oder On-Premise)
  * sammelt die Daten der Agents
  * basierend auf Cassandra, Kafka, ElasticSearch ... scale-out possible with these technologies
* Web-User-Interface

## User-Interface

* physikalische Sicht auf Hosts, Container, Prozesse
* logische Sicht auf Services
* Traces - einzelne Messpunkte, die bis in den Code (wird decompiliert) runtergehen

## Integrationsmöglichkeiten

* [Grafana-Integration](https://grafana.com/)
  * Instana läßt sich als Data-Source in Grafana nutzen (siehe [Instana Plugin](https://grafana.com/plugins/instana-datasource))

## Konzepte

![Konzepte](images/instana.png)

## Getting Started

Am einfachsten startet man einen Instana Agent per Docker ... hier die `docker-compose.yml`:

```yml
version: '2'
services:
    instana-agent:
      image: instana/agent
      container_name: instana-agent
      privileged: true
      pid: "host"
      ipc: host
      network_mode: "host"
      environment:
        INSTANA_AGENT_ENDPOINT_PORT: "443"
        INSTANA_AGENT_ENDPOINT: "saas-eu-foo.instana.io"
        INSTANA_AGENT_KEY: "thisIsMyProductkey"
        INSTANA_AGENT_ZONE: "thisIsMyZone"
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - /dev:/dev
        - /sys:/sys
        - /var/log:/var/log
        - ./instana/config/thisIsAnAdditionalConfig.yaml:/opt/instana/agent/etc/instana/thisIsAnAdditionalConfig.yaml
```

> ACHTUNG: dieser Docker Container zieht beim Start per Maven alle Sensoren vom instana Server (im Log findest sich sowas in der Art: `mvn:com.instana/sensor-java-trace/1.2.248`)

> BTW: `instana/config/thisIsAnAdditionalConfig.yaml` ist optional ... man benötigt sie, wenn man Instana Annotation in den Services des Hosts verwendet hat.

Nach dem Start (`docker-compose up instana-agent`) sollte der Host im [Portal](http://instana.io) auftauchen.

## FAQ

**Frage 1:** Welchen Impact hat Instana auf die Performance der Anwendnung?

**Antwort 1:** Java-Anwendungen werden instrumentiert - das dauert ein wenig, ansonsten hat Instana [keine/kaum negativen Einfluss auf die Performance](https://youtu.be/wghFJGpF3Fw?t=1716). Natürlich benötigt der Instana-Agent Ressourcen (Memory/Network-I/O).