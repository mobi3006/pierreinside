# Instana
Bei diesem Tool handelt es sich um ein Application Performance Monitoring (APM) Tool, das mit den Platzhirschen [New Relic](https://newrelic.com/) und [Dynatrace](https://www.dynatrace.com) konkurriert, aber deutlich günstiger ist.

# Motivation

# Alternativen
Mit Ansätzen wie der [Zeitreihen-Datenbankk Prometheus](https://prometheus.io/) lassen sich auch eigene Lösungen stricken, die allerdings zunächst (vielleicht auch dauerhaft) einen hohen zeitlichen Invest erfordern. Letztlich ist man als Betreiber einer Anwendung aber nicht mit den reinen Daten zufrieden, sondern der Nutzen steht und fällt mit der Möglichkeit, aus diesen Unmengen an Daten tatsächlich Informationen zu gewinnen. Nur dadurch lassen sich Probleme/Bottlenecks in der Anwendung aufdecken und gewinnbringende Verbesserungen umsetzen.

Aus guten Grund wurden Lösungen wie Instana, New Relic, Dynatrace, ... geschaffen, die für teures Geld verkauft werden. Eine Selbstimplementierung kann sich wahrscheinlich nur ein Großunternehmen leisten. Eine Adaption vorhandener Open-Source-Lösungen kann auch zeitaufwendig sein oder gar in die Sackgasse führen.

Aus diesem Grund sind bezahlbare fertige (gut supportete) Lösungen eine gute Sache für bestimmte Firmen. Instana scheint diesen Markt im Auge zu haben. 

# Features

## SaaS oder On-Premise
Instana bietet seinen Dienst als Software-as-a-Service (präferiert) aber auch als On-äPremise-Lösung an. 

Gegen eine Saas-Lösung könnte die Geheimhaltung der Daten sprechen ... per Default versucht Instana keine sensiblen Daten zu loggen (bei SQL-Queries werden keine gebundenen Parameter mitgeloggt), aber letztlich ist es eine Frage des Vertrauens.

## Alerting
Datenaufzeichnung ist die Grundlage, um daraus Informationen zu gewinnen. Noch besser als nachträglich Probleme erklären zu können ist allerdings, Problemsituationen zu erkennen BEVOR daraus tatsächlich Probleme werden.

Instana bietet Alerting, um genau das zu erreichen. In gewisser Weise ist der Alerting Mechanismus auch selbstlernend (Frage: WIRKLICH?).

## Service Discovery
In einem elastischen Microservices Umfeld ist es essentiell, daß neue Services nicht erst aufwendig einkonfiguriert werden müssen. Statdessen leben die Services teilweise nur Minuten oder gar Sekunden.

## Interaction Discovery
Instana kann den Weg eines Client-Requests an einen Service über andere Services bis auf unterste Ebene tracen und nachverfolgen. Auf diese Weise lassen sich einersets ganz fein granulare Daten gewinnen (z. B. welche SQL-Query wurde gegen die Datenbank abgesetzt, wie lange hat das gedauert und wie hoch war die I/O-Rate in der Datenbank) und andererseits grobgranulare Informationen (z. B. wie häufig wurde ein Service aufgerufen?) ableiten. 

## 1-Second-Granularity
Die Abtastrate der Sensoren beträgt eine Sekunde, d. h. jede Sekunde werden die Metriken aller beteiligten Komponenten erfaßt und gespeichert.

## Zero Configuration
Instana kommt mit dem Anspruch intelligent genug zu sein, um Probleme ohne konfigurierte Grenzwerte zu erkennen.

> Machine lerning algorithms to learn performance patterns.

## Misc
* Tenants vs. Zones vs. Filtern vs. Taggen
  * es gibt verschiedene Möglichkeiten, die Daten zu filtern

# Architektur
* Instana Agent (Java-based), kann auch als Docker-Container laufen (es gibt aber auch eine native One-Line-Installation)
  * komponentenspezifische Sensoren für (Abtastrate: 1 Sekunde)
    * Betriebssystem
    * Java-VM
    * Appserver
    * ElasticSearch
    * ...
