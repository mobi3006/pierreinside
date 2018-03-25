# NoSQL

NoSQL ("*Not only SQL*" - nicht "*No SQL*") ist eine Gegenbewegung (seit 2009) zu relationalen Datenbanken.

Wenn ich im folgenden von Vorteilen/Nachteilen spreche, dann ist mir durchaus bewußt, daß es auf den Anwendungsfall ankommt ...

## Motivation

> NoSQL DEFINITION:
Next Generation Databases mostly addressing some of the points: being non-relational, distributed, open-source and horizontally scalable. (http://nosql-database.org/)

Typische Charakterisierungen:

* schema-free
* easy replication support
* simple API
* eventually consistent / BASE (not ACID)
* huge amount of data

### Nachteile relationaler Datenbanken

#### Datenstruktur

SQl-Datenbanken arbeiten gut, wenn die Daten einem festen Schema gehorchen. Ändert sich das Schema, dann muß es sich für alte und neue Daten ändern. Bei vielen Daten, deren Struktur und Semantik sich über die Zeit verändert (Lebenszyklus einer Software), führt das zu Problemen, die sich nur mit großen Kraftanstrengungen auf einer relationalen Datenbank abbilden lassen.

NoSQL-Datenbanken bieten sich an, wenn die zu speichernden bzw. suchenden Daten nicht besondes strukturiert sind (z. B. sich über die Zeit verändern). Bei einer  ... bei einer Volltextsuche über Strings oder ganze Dokumente ist man bei NoSQL Datenbanken im richtigen Einsatzgebiet. Ein XML-Dokument ist zwar strukuriert, für eine Speicherung in relationalen Datenbankstrukturen (= Tabellen) ist es aber kaum geeignet, weil schon die Anwendung der ersten Normalform relationaler Datenbanken zu einem Problem führt ("Jedes Attribut der Relation muss einen atomaren Wertebereich haben", https://de.wikipedia.org/wiki/Normalisierung_(Datenbank)#Erste_Normalform_(1NF)).

die Struktur häufig doch aus vielen optionalen Bestandteilen besteht, die wiederum schlecht in das 

Solche Dokumente lassen sich in relationalen Datenbanken beispielsweise folgendermaßen speichern:

* Ansatz 1: verwendet man CLOBs oder BLOBs
* Ansatz 2: spaltet das Dokument in mehrere Tabellen/Spalten auf

Nachteile dieser Ansätze:

* Ansatz 1: Suchen auf den Daten ist nicht performant - es sei denn die Datenbank verfügt über entsprechende NoSQL-Erweiterungen
* Ansatz 2: sehr aufwendig - Boilerplate-Mapping-Code (fehleranfällig, schwer wartbar)

Viele relationale Datenbanken antworten auf den Trend mit entsprechenden Erweiterungen, die sich mehr (PostgreSQL) oder weniger gut anfühlen. Letztlich macht eine NoSQL Datenbank aber nicht nur die Abfragemöglichkeit aus, sondern ganz besonders auch die Skalierbarkeit. Und hier sind NoSQL Datenbanken relationalen Datenbanken mit NoSQl-Features deutlich überlegen.

### Vorteile NoSQL Datenbanken

* Versionierung out-of-the-box
* Replikation out-of-the-box => horizontale Skalierung leicht
  * das wird bei der Parallelisierung von Abfragen ausgenutzt
* schemalos (bei ElasticSearch spricht man von einem schemaless-schema) - kommt also gut mit Änderungen an den Schemata zurecht

### Nachteile von NoSQl Datenbanken

* häufig verwendet man NoSQL Datenbanken nicht als einzige Datenbank, sondern parallel zu einer transaktionalen relationalen Datenbank. Insofern hat Hot Data in der relationalen Datenbank und synchronisiert sie in die NoSQl Datenbank ("cold" data). Somit dauert es eine Weile bis hot data auf der NoSQL Datenbank angekommen sind und indiziert wurden (und damit auch gefunden werden können). Insofern kann die Aktualität einer NoSQL-Abfrage eingeschränkt sein ... dafür bekommt man die Ergebnisse allerdings rasend schnell.

## Kategorisierung

Innerhalb von NoSQL-datenbanken unterscheidet man folgende Typen:

* Wide Column Store
  * [Cassandra](https://cassandra.apache.org/)
* Document Store
  * [ElasticSearch](https://www.elastic.co/)
  * MongoDB
  * CouchDB
* Tuple Store
  * [Redis](http://redis.io/)
* Graph Database
  * Neo4J
* Object Database
  * Versant
  * db4o
* Grid & Cloud Database
* XML-Database
* ...

Wie man sieht gibt es also eine ganze Reihe unterschiedlicher NoSQL-Datenbank-Kategorien (die Grenzen sind schwimmend) und zu jeder Kategorie unzählige Produkte.

## Produkte im Detail

### Document Store - Elasticsearch

* no ACID transaction support
* no good support for relations ... Graph databases are addressing it

### Graph Database - OrientDB

* [Homepage](http://orientdb.com)
* [Training](http://orientdb.com/training)

This seems to be the *EierlegendeWollmilchsau* - a mixture of the best of different storage approaches:

* [OrientDB Feature in comparison to RDBMS, DocumentStore, other GraphDBs](http://orientdb.com/why-orientdb/)

What makes OrientDB outstanding

> Distributed Reliability
Most NoSQL solutions are used as “cache” to speed up certain use cases, while the master database remains a relational DBMS. For this reason, the average NoSQL product is built more for performance and scalability, while sacrificing reliability.

OrientDB, however, isn’t the average NoSQL DBMS. What happens when a server node crashes? Thanks to WAL (Write Ahead Logging), OrientDB is able to restore the database content after a crash. Any pending transactions are automatically rolled back. Immediately, the server cluster redistributes the load across the available nodes and all the clients connected to the node in failure are automatically switched to an available server node with no fail-over to the application level.
It is

* lightning fast
  * relations are modeled by persistent pointers and not runtime joins ... optimized for read access
  * distributed => scalable
* has [Spring Data](SpringData) support (https://github.com/noskovd/spring-data-orient) - not official

### Elasticsearch

[siehe eigener Artikel](elasticSearch.md)