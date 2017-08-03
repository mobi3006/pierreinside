# Instana
Bei diesem Tool handelt es sich um ein Application Performance Monitoring (APM) Tool, das mit den Platzhirschen [New Relic](https://newrelic.com/) und [Dynatrace](https://www.dynatrace.com) konkurriert, aber deutlich günstiger ist.

# Motivation
* [Michael Krumm - Youtube](https://www.youtube.com/watch?v=wghFJGpF3Fw)

# Alternativen
Mit Ansätzen wie der [Zeitreihen-Datenbankk Prometheus](https://prometheus.io/) lassen sich auch eigene Lösungen stricken, die allerdings zunächst (vielleicht auch dauerhaft) einen hohen zeitlichen Invest erfordern. Letztlich ist man als Betreiber einer Anwendung aber nicht mit den reinen Daten zufrieden, sondern der Nutzen steht und fällt mit der Möglichkeit, aus diesen Unmengen an Daten tatsächlich Informationen zu gewinnen. Nur dadurch lassen sich Probleme/Bottlenecks in der Anwendung aufdecken und gewinnbringende Verbesserungen umsetzen.

Aus guten Grund wurden Lösungen wie Instana, New Relic, Dynatrace, ... geschaffen, die für teures Geld verkauft werden. Eine Selbstimplementierung kann sich wahrscheinlich nur ein Großunternehmen leisten. Eine Adaption vorhandener Open-Source-Lösungen kann auch zeitaufwendig sein oder gar in die Sackgasse führen.

Aus diesem Grund sind bezahlbare fertige (gut supportete) Lösungen eine gute Sache für bestimmte Firmen. Instana scheint diesen Markt im Auge zu haben. 

# Features

## SaaS oder On-Premise
Instana bietet seinen Dienst als Software-as-a-Service (präferiert) aber auch als On-Premise-Lösung an. 

Gegen eine Saas-Lösung könnte die Geheimhaltung der Daten sprechen ... per Default versucht Instana keine sensiblen Daten zu loggen (z. B. bei SQL-Queries werden keine gebundenen Parameter mitgeloggt), aber letztlich ist es eine Frage des Vertrauens bzw. einen Nachweis aus Compliance Sicht zu erbringen.

## Alerting
Datenaufzeichnung ist die Grundlage, um daraus Informationen zu gewinnen. Noch besser als nachträglich Probleme erklären zu können ist allerdings, Problemsituationen zu erkennen BEVOR daraus tatsächlich Probleme werden.

Instana bietet Alerting, um genau das zu erreichen. In gewisser Weise ist der Alerting Mechanismus auch selbstlernend (Frage: WIRKLICH?).

## Service Discovery
In einem elastischen Microservices Umfeld ist es essentiell, daß neue Services nicht erst aufwendig einkonfiguriert werden müssen. Statdessen leben die Services teilweise nur Minuten oder gar Sekunden.

## Interaction Discovery
Instana kann den Weg eines Client-Requests an einen Service über andere Services bis auf unterste Ebene tracen und nachverfolgen. Auf diese Weise lassen sich einersets ganz fein granulare Daten gewinnen (z. B. welche SQL-Query wurde gegen die Datenbank abgesetzt, wie lange hat das gedauert und wie hoch war die I/O-Rate in der Datenbank) und andererseits grobgranulare Informationen (z. B. wie häufig wurde ein Service aufgerufen?) ableiten. 

## Zero Configuration
Instana kommt mit dem Anspruch intelligent genug zu sein, um Probleme ohne konfigurierte Grenzwerte zu erkennen.

> Machine lerning algorithms to learn performance patterns.

## Maintenance-Free
Service Discovery + Interaction Discovery + Zero Configuration &#9658; Maintenance-Free

## 1-Second-Granularity
Die Abtastrate der Sensoren beträgt eine Sekunde, d. h. jede Sekunde werden die Metriken aller beteiligten Komponenten erfaßt und gespeichert.

## Komponentenspezifische Sensoren
Instana kommt mit einer Vielzahl komponentenspezifischer Sensoren

* unterstützte Sprachen: https://www.instana.com/supported-technologies/
* unterstützte Technologien: https://www.instana.com/supported-technologies/

, so daß immer die relevanten Metriken gezogen und dargestellt werden können. Zudem werden dadurch, daß Instana diese Technologien kennt, besonders auffällige Werte entdeckt. Das kann zu einem Alert führen.

Ein Beispiel:
Bei ElasticSearch können einzelne Knoten gemonitored werden, aber auch ganze Cluster. 

## Machine Learning
> Understanding of Patterns of normal behavior by deep learning.

## Komponentenspezifisches Wissen
Da Instana Technology-aware ist (d. h. die eingesetzten Technologien kennt) kann es den Nutzer beim Alerting, bei der Root-Cause-Analyse und beim Problem-Solving unterstützen. 

## Open-Approach
Instana plant die Sensorentwicklung offen zu gestalten, so daß man für nicht unterstützte Technologien auch eigene Sensoren schreiben kann.

## API
Erkennt Instana wichtige Strukturen bzww. neuralgische Punkte in der Anwendung nicht selbständig, so lassen sich im Code Metainformationen über Annotationen hinterlegen.

## Misc
* Tenants vs. Zones vs. Filtern vs. Taggen
  * es gibt verschiedene Möglichkeiten, die Daten zu filtern

# Architektur
* Agent (Java-based)
  * native Installation auf gängigen Betriebssystemen - kann auch als Docker-Container laufen (für Getting-Started sehr interessant)
  * enthält komponentenspezifische Sensoren für (Abtastrate: 1 Sekunde)
    * Betriebssystem
    * Java-VM
    * Appserver
    * ElasticSearch
    * ...
  * schickt Messwerte ans Backend 
* Backend
  * sammelt die Daten der Agents
* Web-User-Interface

# User-Interface
* physikalische Sicht auf Hosts, Container, Prozesse
* logische Sicht auf Services
* Traces - einzelne Messpunkte, die bis in den Code (wird decompiliert) runtergehen

# FAQ

**Frage 1:** Welchen Impact hat Instana auf die Performance der Anwendnung?

**Antwort 1:** Java-Anwendungen werden instrumentiert - das dauert ein wenig, ansonsten hat Instana keine/kaum negativen Einfluss auf die Performance (https://youtu.be/wghFJGpF3Fw?t=1716). NAtürlich benötigt der Instana-Agent Ressourcen (Memory/Network-I/O).
