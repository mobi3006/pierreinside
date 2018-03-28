# Elastic Search (ES)

* [Buch - ElasticSearch - The Definitive Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
  * die interessantesten Kapitel waren die, die als optional gekennzeichnet waren ... hier steckten die Internas drin

ElasticSearch ist wesentlicher Bestandteil des sog. ELK-Stacks, zu dem sich dann noch Logstash und Kibana gesellen. Die zugrundelegende Technologie besteht aus dem guten alten Lucene, dessen Fähigkeiten mit ElasticSearch leichter zugänglich und vor allem verteilt werden. Die Dokumente bestehen bei ElasticSearch aus JSON-Dokumenten ... Lucene indiziert ganz viele verschiedene Dokumententypen.

## Historie

Lucene wurde 2001 ins Leben gerufen und wurde hauptsächlich zur Indizierung/Suche auf Texten verwendet. Texte werden hierbei zunächst mal in Tokens zerlegt, um darauf dann nach (Teil-) Strings (teilweise fuzzy) suchen zu können. In Softwareprojekten wird Lucene in Form von ElasticSearch i. a. nicht mit Prosatexten gefüttert, sondern mit noch deutlich einfacheren JSON/XML Dokumenten. Wir vereinfachen es Lucene also schon mal deutlich, können damit aber auch gezielter semantisch suchen (Semantik = einzelne Felder) ... dadurch wird die Suche nochmals deutlich effizienter.

## Konzepte

ElasticSearch ist konzipiert, um auf Commodity-Hardware beste Leistung zu liefern. Da Commodity-Hardware allerdings auch schneller mal schlapp macht, sind Fehler im Konzept vorgesehen. Genauso verhält es sich mit der Performance - die schlechtere Leistung von Commodity-Hardware wird versucht durch konzeptionelle Parallelisierung auszugleichen, die glücklicherweise mit dem Konzept zur Ausfallsicherheit (=> Replica-Shards) Hand in Hand geht.

* ElasticSearch speichert JSON-Dokumente - zur Optimierung der (Volltext-) Suche erfolgt danach eine Indizierung der Dokumente
* wesentlicher Bestandteil ist die Verteilung der Speicherung über Knoten/Rechner, um so Ausfallsicherheit und höhere Performance (Parallelisierung von Queries) zu erreichen
* ein Cluster besteht aus vielen Knoten, die sich spontan per Multicast innerhalb eines Clusternamens vernetzen (der Clustername muß unique sein, sonst können seltsame Seiteneffekte entstehen)
* die Daten sind verteilt (entweder disjunkt über Shards oder redundant über Replicas) auf mehrere Knoten - durch die Redundanz können Suchen durch Parallelisierung beschleunigt werden. Jeder Knoten kennt die aktuelle Verteilung der Primary und Replica Shards. Da der Primary-Shard, in dem sich ein Dokument befindet, aus der `_id` des Dokuments errechnet werden kann (Shard-Adressfunktion: `shard = hash(routing) modulo numberOfPrimaryShards` ... mit i. a. `routing = _id`), können Anfragen nach id's (z. B. Auflösen von Suchergebnissen) an die richtigen Knoten weitergeleitet werden. Es ist Best-Practice, daß Clients ihre Anfragen im Round-Robin-Verfahren an die Knoten stellen.
* ein Index ist der Datenspeicher (vergleichbar einer Datenbank) - in einem Index befinden sich Daten ähnlicher Struktur ... es kann aber auch mehrere Indizes mit dieser Struktur geben. Beispielsweise um Daten zeitlich oder nach anderen Diskriminatoren (z. B. Kundennummer) zu trennen. Ein Alias ist eine Art virtueller Index - hiermit läßt sich ein Index auf mehreren Indizes aufsetzen, um so beispielsweise mehrere Indizes abzufragen (im Request wird dann der Alias verwendet).
  * ein Index kann beliebig viele Dokumente aufnehmen - allerdings sollte man das aus Performancegründen nicht ausreizen und stattdessen mehrere Primary Shards pro Index verwenden (per Default hat ein Index 5 Shards) - dann können die Primary Shards auch auf verschiedene Knoten verteilt werden.
    * ACHTUNG: die Anzahl der Shards kann später nicht mehr geändert werden (liegt an der fixen Shard-Adressfunktion)!!!
    * ein ElasticSearch-Index basiert auf einem oder mehreren Lucene-Index (= Shard)
* ES bietet eine komplette REST-Schnittstelle, über die auch die Administration (z. B. Mappings definieren) erfolgen kann

### Index-Settings

* Name
* Anzahl der Shards
* Anzahl der Replicas pro Shard
* Analyzer

### Primary-Shard-Selektion

* [Buch - ElasticSearch - The Definitive Guide - Kapitel Routing a Document to a Shard](https://www.elastic.co/guide/en/elasticsearch/guide/current/routing-value.html)

### Indizierung

JSON-Dokumente werden möglichst schnell synchron auf dem Primary Shard gespeichert, um dem Client eine Response mit einer `_id` geben zu können. Im Nachgang werden die Dokumente asynchron indiziert - hierbei wird zu jedem Feld ein Inverted Index gepflegt. An dieser Stelle kommt auch das Mapping ins Spiel.

Neben der Indizierung der einzelnen Felder konkateniert ElasticSearch per default alle Felder zu einem `_all` String-Feld, das besonders für Volltextsuche über alle Felder genutzt wird.

Die Indizierung von Texten (= Strings) ist sprachabhängig und insofern auch konfigurierbar über sog. Analyzer:

* Standard Analyzer
  * Default
* Simple Analyzer
* Whitespace Analyzer
* Language Analyzer
  * für viele Sprachen verfügbar

Man kann dem Analyzer auch auf die Finger schauen und sich interne Daten ausgeben lassen.

### Mapping

ElasticSearch benötigt nicht unbedingt ein Schema (= Mapping), es kann ein Schema selbst entdecken. Für den Start ist das schon mal ganz ok, aber für den produktiven Einsatz wirdein explizites Mapping empfohlen (https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping.html). 

Ein implizites Schema (aka dynamic mapping) kann später zu Problemen führen. Wenn Datentypen nämlich falsch angenommen wurden (z. B. Zeichenkette => Datum) und die Indizierung schon abgeschlossen ist, dann erfordert die Änderung des Datentyps eine teure Re-Indizierung. Als Alternative bleibt, ein neues Feld anzulegen, doch damit hat man diese Information noch nicht in den Indizierungsdaten der "alten" Dokumente. Natürlich ist die Re-Indizierung kostengünstiger als die Erstabspeicherung (Speicherung + Indizierung), da die Dokumente ja schon im System enthalten sind und nicht erst gespeichert werden müssen. Bei einer Re-Indexierung in einen neuen Index kommen i. a. Aliase zum Einsatz, um dies transparent für die Anwendung durchzuführen.

Man kann sich das implizite Schema von ElasticSearch ausgeben lassen - so kann man unerwarteten Sucherergebnissen auf die Spur kommen.

### Inverted Index

Dies ist DIE Datenstruktur von ElasticSearch. Hierbei werden Texte (z. B. der String eines Feldes) in einzelne Tokens (= Wörter) in ihren Stammformen (Normalisierung !!! sprang => springen !!!) zerlegt und die Häufigkeit des Auftretens gezählt (hierüber ergeben sich automatisch unterschiedliches Scores/Relevanzen von Treffern). Bei einer Suche erfolgt die gleiche Zerlegung und Normalisierung, damit der Inverted Index genutzt werden kann.

Wird der Inverted Index von jedem Knoten selbst aufgebaut oder erfolgt hier auch eine Replikation?

### Fuzzy Search

Volltextsuche in Strings liefert häufig kein binäres Ergebnis, sondern einen Score, da bei der Suche nach "Mein Name ist Pierre" auch Teilstrings gefunden werden ... die erhalten allerdings einen kleineren Score als der exakte String "Mein Name ist Pierre". 

Es kann sogar passieren, daß man noch semantischer sucht:

* Suche nach *USA* soll auch Strings wie *United States of America* finden
* Suche nach *springen* liefert auch Dokumente mit *sprang*
* Suche nach *Fantasie* liefert auch Dokumente mit *Phantasie*
* Suche nach *johnny walker* liefert auch Dokumente mit *Johnnie Walker*

Hierzu ist naürlich schon mehr Kontextwissen erforderlich (deutsche Grammatik über Beugungsformen). Aber in dieser Fuzzy-Search liegt großes Potential, das relationale Datenbanken, die auf einem Normalisierungskonzept beruhen nicht bieten

### Datenverlust

Ein Primary Shard kann beliebig viele Replica-Shards haben (kann auch beliebig geändert werden), die logischerweise auf separaten Knoten liegen sollten. Ändert man die Anzahl der Replica-Shards zur Laufzeit, so stellt das System den gewünschten Zustand im Laufe der Zeit selbst her. Sinkt die die Anzahl der aktiven Replica-Shards unter einen bestimmten Wert (hierfür gibt es eine entsprechende Formel in Abhängigkeit der definierten Replica-Shards - Stichwort *Quorum*), so erlaubt ElasticSearch keine Updates mehr. Das ist ein Schutzmechanismus, um Datenverlust zu verhindern.

ElasticSearch hat noch weitere Health-Metriken, die zu einer Abschaltung der Update-Fähigkeit führen. Beispielsweise sollte das Filesystem noch genpügend Festplattenspeicher haben ... ansonsten droht Abschaltung.

Sollte es dennoch mal zu Datenverlust kommen (alle Teile eines Shards sind nicht mehr verfügbar), so arbeitet ElasticSearch fehlertolerant weiter (kennzeichnet es aber in den Query-Results) ... Zeit für ein Restore des Backups.

### Synchronisierung

* [Buch - ElasticSearch - The Definitive Guide - Kapitel Distributed Document Store]https://www.elastic.co/guide/en/elasticsearch/guide/current/distributed-docs.html

Primary-Shards werden auf die Replica-Shards synchronisiert. Hierbei entsteht natürlich entsprechender Traffic, der über schnellstmögliche Kanäle laufen muß. Ein WRITE-Request ist erst abgeschlossen, wenn die Daten auch auf die geforderten Replicas erfolgreich gespeichert (!!!) wurden (Replikationsstrategie `replication = sync`). Diese Replikationsstrategie ist konfigurierbar (z. B. `async`), aber natürlich auf Kosten eines möglichen Datenverlusts.

ElasticSearch betreibt *Document-Based Replication*, d. h. es werden komplette Dokumente repliziert ... nicht nur Änderungen oder gar das Update-Statement.

Ein typisches Problem bei Synchronisierung sind die unterschiedlichen "Laufzeiten" von Replikationen, d. h. ein Dokument in Version 10 kann vor dem gleichen Dokument in Version 8 auf dem Replica-Shard verarbeitet/gespeichert werden. Die Versionierung der Dokumente wird verwendet, um solche Probleme zu entdecken und aufzulösen z. B. (das nachfolgene Update in Version 8 wird ignoriert).

### Parallelisierung

* [Buch - ElasticSearch - The Definitive Guide - Kapitel Distributed Search Execution](https://www.elastic.co/guide/en/elasticsearch/guide/current/distributed-search.html)

Die Ebene der Parallelisierung ist nicht der Index, nicht der Shard, sondern die Segmente innerhalb eines Shards (= Lucene-Index). Jedes Segment verhält sich wie eine eigene Suchmaschine und kann parallel mit der Verarbeitung eines Requests beauftragt werden. Der Knoten, an den eine Suche gerichtet wird, nennt man Coordinating Node. Da dieser nicht weiß, welche Shards Ergebnisse beisteuern werden, muß auf jedem Shard (entweder im Primary Shard oder Replica Shards) eine Suche statfinden. Jeder Shard muß im worst-case das gesamte Ergebnis bereitstellen (wenn die anderen Shards keine Treffer beisteuern), so daß jeder Shard `from` + `size` Treffer liefert (wenn man hohe Parameterwerte wählt, dann kann das ganz schön viel sein). Zum Schluß müssen die Ergebnisse gemergt werden ... normalerweise liefert ElasticSearch 10 Dokumente als Ergebnis (in der Query kann man das aber konfigurieren ... Pagination ist auch möglich).

Die Suche besteht aus zwei Phasen

* Query Phase: in dieser Phase erfolgt auf jedem Shard parallel eine Suche. Als Ergebnis werden nur die ersten X Dokumente sortiert gemäß Query geliefert. Das Suchergebnis enthält nur die `_id` der Dokumente und die Felder, nach denen sortiert wird.
* Fetch Phase: in dieser Phase erfolgt die Reduktion auf die Ziellänge des Ergebnis (durch Sortierung und Abschneiden der Teilergebnisse) und anschließendem Multi-GET gegen die Shards, die auch schon die Fetch-Phase ausgeführt haben

Aufgrund dieses Konzepts werden in Abhängigkeit von `from`/`size` sehr viele Daten transportiert, von denen nur ein Bruchteil wirklich genutzt werden.

Für das fazinierende/beliebte Endless-Scrolling, bei dem `from` immer weiter nach hinten geschoben wird, wäre dieser Ansatz extrem teuer. Deshalb gibt es hierfür die sog. [Scroll-Optimierung](https://www.elastic.co/guide/en/elasticsearch/guide/current/scroll.html). Hierbei muss man auf Sortierung verzichten und die Aktualität der Daten leidet auch, aber die endlose Bereitstellung der Dokumente ist extrem kostengünstig.

## Getting Started

Wie heutzutage üblich startet man am besten mit Docker und Docker-Compose. Mit der [hier angegebenen](https://www.elastic.co/guide/en/elasticsearch/reference/6.1/docker.html) `docker-compose.yml` startet man im Handumdrehen zum ersten ElasticSearch Cluster.

>ACHTUNG: mittlerweile werden die Docker-Images von ElasticSearch nicht mehr bei Dockerhub gehostet, sondern bei [elastic.io](https://www.docker.elastic.co/#).

Nach dem Start bietet Elasticsearch zwei Kommunikationsports:

* 9200: HTTP-Protokoll ... nutzbar per `curl`, Postman, ...
* 9300: Elasticsearch-Protokoll ... nutzbar per Java-Libraries, ...

## Abfragen

Für Queries gibt es zwei Ansätze

* Search Lite: `GET /website/blog/_search?q=author_name:Pierre`
  * Verwendung von Query-Parametern
  * geeignet für ad-hoc Queries
* Request Body Search API:
  * HTTP-GET mit JSON-Request-Body

    * ACHTUNG: es ist umstritten, ob das guter Design-Ansatz ist (und ob es überhaupt ein valider HTTP-Request ist ... im RFC 7231 ist es nicht verboten ... es ist aber auch nicht definiert, was passieren soll) - einige Tools (z. B. Postman) unterstützen diesen Ansatz nicht. ElasticSearch akzeptiert allerdings auch POST-Requests auf der `_search` Ressource (mit der gleichen Syntax)

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

### Filter vs. Query

Filter sind vor Queries zu bevorzugen, da Caching möglich ist. Filter können bei der Suche nach exakten Werten (keine Fuzziness - z. B. ist das Baujahr zwischen 1950 und 1955?) verwendet werden, bei Queries ist immer eine Fuzziness möglich, so daß eine gewisse Relevanz ins Spiel kommt ... das Suchergebnis hat in diesem Fall einen `_score`.

### Beispiele

* `GET _count`
  * zählt die Anzahl aller Dokumente und liefert auch die Anzahl der Shards
* `GET /website/blog/_search`
  * listet die ersten 10 Einträge des Index `website` vom Typ `blog` auf
* `GET /website/blog/_search?q=author_name:Pierre`
* `GET /website/blog/_count`
  * zählt die Anzahl der Dokumente des Index `website` vom Typ `blog`
* `GET /website/`
  * liefert Informationen zum Index (z. B. Mapping, Aliases)
* `GET /website/_mapping`

ElasticSearch bietet allerdings auch eine JSON-DSL für die Suche an, die empfohlen wird.

## Tooling

### Kibana

Hat man einen ELK-Stack aufgebaut, dann ist Kibana natürlich das naheliegendste Tool, um mit ElasticSearch zu arbeiten. Kibana zeigt bei Bedarf für die Queries auch `curl` output an ... ganz praktisch, wenn man das Kommando auch in Skripten verwenden will.

Kibana ist ein reines Query-Tool - man administriert ElasticSearch damit nicht.

### Marvel - ElasticSearch-Plugin

### Postman

Postman ist kein spezielles ElasticSearch-Tool, aber es kann ganz wunderbar HTTP-REST-Interfaces bedienen ... wie sie ElasticSearch über Port 9200 auch bietet.

> ACHTUNG: in vielen ElasticSearch Query-Beispielen sind HTTP-GET Requests mit einem JSON-Request-Body angegeben (`GET /_count { "query": { "match_all": {} } }`) - bei meinem Postman (Version 5.5.0) konnte ich an ein GET keinen Body hängen. Stattdessen mußte ich daraus einen HTTP-POST machen und dort den Body angeben. Angeblich ist es aber lauf HTTP-Spezifikation nicht verboten einen Body mit einem GET zu verwenden.

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