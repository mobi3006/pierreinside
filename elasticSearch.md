# Elastic Search (ES)

* https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html

ElasticSearch ist wesentlicher Bestandteil des sog. ELK-Stacks, zu dem sich dann noch Logstash und Kibana gesellen. Die zugrundelegende Technologie besteht aus dem guten alten Lucene, dessen Fähigkeiten mit ElasticSearch leichter zugänglich und vor allem verteilt werden. Die Dokumente bestehen bei ElasticSearch aus JSON-Dokumenten ... Lucene indiziert ganz viele verschiedene Dokumententypen.

## Historie

Lucene wurde 2001 ins Leben gerufen und wurde hauptsächlich zur Indizierung/Suche auf Texten verwendet. Texte werden hierbei zunächst mal in Tokens zerlegt, um darauf dann nach (Teil-) Strings (teilweise fuzzy) suchen zu können. In Softwareprojekten wird Lucene in Form von ElasticSearch i. a. nicht mit Prosatexten gefüttert, sondern mit noch deutlich einfacheren JSON/XML Dokumenten. Wir vereinfachen es Lucene also schon mal deutlich, können damit aber auch gezielter semantisch suchen (Semantik = einzelne Felder) ... dadurch wird die Suche nochmals deutlich effizienter.

## Konzepte

* ElasticSearch speichert JSON-Dokumente - zur Optimierung der (Volltext-) Suche erfolgt eine Indizierung der Dokumente
* wesentlicher Bestandteil ist die Verteilung der Speicherung über Knoten/Rechner, um so Ausfallsicherheit und höhere Performance zu erreichen
* ein Cluster besteht aus vielen Knoten, die sich spontan per Multicast innerhalb eines Clusternamens vernetzen (der Clustername muß unique sein, sonst können seltsame Seiteneffekte entstehen)
* die Daten sind verteilt (entweder disjunkt über Shards oder redundant über Replicas) auf mehrere Knoten - durch die Redundanz können Suchen durch Parallelisierung beschleunigt werden
* ElasticSearch benötigt nicht unbedingt ein explizites Schema (= Mapping) - dennoch wird empfohlen ein explizites Mapping zu definieren (https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html)
  * wenn kein explizites Mapping definiert ist, dann wird ein implizites verwendet (aka dynamic mapping) - das könnte dann aber später zu Problemen führen, weil die Datentypen falsch interpretiert wurden und die Änderung eines Datentyps (z. B. Zeichenkette => Datum) ist nicht einfach möglich (weil schon Dokumente indiziert wurden)
* ein Index ist der Datenspeicher - in einem Index befinden sich Daten ähnlicher Struktur ... es kann aber auch mehrere Indizes mit dieser Struktur geben. Beispielsweise um Daten zeitlich oder nach anderen Diskriminatoren (z. B. Kundennummer) zu trennen. Ein Alias ist eine Art virtueller Index - hiermit läßt sich ein Index auf mehreren Indizes aufsetzen, um so beispielsweise mehrere Indizes abzufragen (im Request wird dann der Alias verwendet).
  * ein Index kann beliebig viele Dokumente aufnehmen - allerdings sollte man das aus Performancegründen nicht ausreizen und stattdessen mehrere Shards pro Index verwenden (per Default hat ein Index 5 Shards).
    * ACHTUNG: die Anzahl der Shards kann später nicht mehr geändert werden!!!
    * ein ElasticSearch-Index basiert auf einem oder mehreren Lucene-Index (= Shard)
  * ein Index kann viele Replicas (= Shard-Kopie) haben (kann auch beliebig geändert werden), d. h. die Shards werden auf separate Knoten repliziert, um Ausfallsicherheit zu garantieren ... darüber hinaus werden die Replicas auch für die Parallelisierung von Anfragen verwendet (ist aber zweitrangig)

## Getting Started

Wie heutzutage üblich startet man am besten mit Docker und Docker-Compose. Mit der [hier angegebenen](https://www.elastic.co/guide/en/elasticsearch/reference/6.1/docker.html) `docker-compose.yml` startet man im Handumdrehen zum ersten ElasticSearch Cluster.

>ACHTUNG: mittlerweile werden die Docker-Images von ElasticSearch nicht mehr bei Dockerhub gehostet, sondern bei [elastic.io](https://www.docker.elastic.co/#).

Nach dem Start bietet Elasticsearch zwei Kommunikationsports:

* 9200: HTTP-Protokoll ... nutzbar per `curl`, Postman, ...
* 9300: Elasticsearch-Protokoll ... nutzbar per Java-Libraries, ...

## Tooling

### Kibana

Hat man einen ELK-Stack aufgebaut, dann ist Kibana natürlich das naheliegendste Tool, um mit ElasticSearch zu arbeiten. Kibana zeigt bei Bedarf für die Queries auch `curl` output an ... ganz praktisch, wenn man das Kommando auch in Skripten verwenden will.

Kibana ist ein reines Query-Tool - man administriert ElasticSearch damit nicht.

### Marvel - ElasticSearch-Plugin

### Postman

Postman ist kein spezielles ElasticSearch-Tool, aber es kann ganz wunderbar HTTP-REST-Interfaces bedienen ... wie sie ElasticSearch über Port 9200 auch bietet.

## Queries

Bei Queries bekommt man eine Gesamtergebnis-Zusammenfassung mit

* Anzahl der Treffer
* den Score des Dokuments mit dem höchsten Score

und zu den ersten gefundenen Dokumenten die folgenden Informationen:

* Index
* Typ
* ID
* Score (= Relevanz)
* Dokument im Original

ES sortiert die Ergebnisse per default nach Relevanz.

### Beispiele

* `GET _count`
  * zählt die Anzahl aller Dokumente und liefert auch die Anzahl der Shards
* `GET /website/blog/_search`
  * listet die ersten 10 Einträge des Index `website` vom Typ `blog` auf
* `GET /website/blog/_search?q=author_name:Pierre`
* `GET /website/blog/_count`
  * zählt die Anzahl der Dokumente des Index `website` vom Typ `blog`

ElasticSearch bietet allerdings auch eine JSON-DSL für die Suche an, die :

## Detailbetrachtung

### Analogien zu relationalen Datenbanken

* Relationale DB  => Datenbank  => Tabelle  => Zeile    => Spalte
* ElasticSearch   => Index      => Typ      => Dokument => Feld

### Dokument-Metadaten

Jedes Dokument hat folgende Daten

* ES-Index (zu dem es gehört)
* Typ
* Identifier - entweder vom Speichernden (`PUT /website/blog/4711 { "title": ... }`) oder von ES (`POST /website/blog/ { "title": ... }`) vergeben
* Version

In einer ElasticSearch URl sind Index (`website`), Typ (`blog`) und Identifier (`4711`) teil der URL ``PUT /website/blog/4711 { "title": ... }`.

### Schemaless-Schema

Bei ElasticSearch werden JSON-Dokumente gespeichert. Im Gegensatz zu relationalen Datenbanken müssen die Dokumente, die in DEM GLEICHEN Index liegen, aber nicht exakt die gleiche Struktur haben. Meistens werden sich die Strukturen ähneln ... Unterschiede und somit auch unterschiedliche Versionen eines Dokuments stellen das System aber hindichtlich der Suche vor keine großen Herausforderungen. Man spricht hier auch vom Schemaless-Schema.

### Near-Realtime (NRT)

Aufgrund konzeptioneller Eigenschaften (Resfresh Intervall) dauert es eine kurze Weile (eine Sekunde) bis ein Dokument auch tatsächlich gefunden werden kann. Durch die Verteilung der Daten und Optimierung von Suchanfragen über verteilte Shards/Replicas kann es passieren, daß Daten nicht SOFORT gefunden werden. Insofern handelt es sich bei ElasticSearch um eine extrem, schnelle Antwort, doch sind die Ergebnisse mit auch einer gewissen Vorsicht zu genießen.

### Immutable Documents

* https://www.elastic.co/guide/en/elasticsearch/guide/current/update-doc.html

Die Dokumente sind in ElasticSearch immutable ... ein Update wird als Insert und Delete abgebildet. Das physikalische Löschen wird zunächst allerdings zurückgestellt bis tatsächlich im Zuge Schreiben neuer Daten auf die Platte zugegriffen werden muß. Dadurch werden Updates zu einer vergleichsweise teuren Angelegenheit. Am besten funktioniert ES bei einer INSERT-ONLY-Datenspeicher (z. B. Archivierung).

### Versionierung

Jedes Dokument erhält eine Version ... bei jeder Änderung wir die Version hochgezählt und die alte Version des Dokuments wird gelöscht.

### Joins in ElasticSearch

* https://www.elastic.co/guide/en/elasticsearch/guide/current/application-joins.html#application-joins

Im einfachsten Fall sind alle Daten nach denen man suchen möchte in EINEM Dokument (= Index). Leider ist das selten der Fall.

*Beispiel:*

Man möchte auf einem Blog nach Autor und Bloginhalt suchen. In diesem Fall hat man vermutlich Indizes für Autoren und für Blogs. Würde man alles in EIN Dokument bzw. einen Index packen, dann hätte man Redundanzen, die sich bei Änderungen (z. B. Autor zieht um) negativ bemerkbar machen.

Durch die Abbildung von normalisierten Indizes spart man zwar Speicherplatz und aufwendige Update Prozeduren aber spart bei der Suche Queries ein, die ansonsten seriall ablaufen müßten - klarer Fall für einen Trade-off. Die Alternative sind Application-Side-Joins.

## Bewertung

ElasticSearch ist faszinierend, weil es aufgrund der konzeptionellen und algroithmischen Effizienz (wenn es im richtigen Einsatzgebiet genutzt wird) irrsinnig schnelle Suchen auf vergleichsweise billiger Hardware durchführen kann. Aufgrund der Ausfallsicherheit durch Replikation ist es auch kein Problem, wenn die billige vergleichsweise kleine Festplatte dann mal den Geist aufgibt.