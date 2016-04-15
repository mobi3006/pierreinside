# NoSQL
NoSQL ("*Not only SQL*" - nicht "*No SQL*") ist eine Gegenbewegung (seit 2009) zu relationalen Datenbanken.

Der Name ist etwas irreführend, weil SQL (Structured Query Language) oft als Synonym für Relationale Datenbanken angesehen wird 

Wenn ich im folgenden von Vorteilen/Nachteilen spreche, dann ist mir durchaus bewußt, daß es auf den Anwendungsfall ankommt ...

# Motivation

> NoSQL DEFINITION:
Next Generation Databases mostly addressing some of the points: being non-relational, distributed, open-source and horizontally scalable. (http://nosql-database.org/)

Typische Charakterisierungen:
* schema-free
* easy replication support
* simple API
* eventually consistent / BASE (not ACID)
* huge amount of data

## Nachteile relationaler Datenbanken
### Datenstruktur
NoSQL-Datenbanken bieten sich an, wenn die zu speichernden Daten nicht besondes strukturiert sind. Ein XML-Dokument ist zwar strukuriert, für eine Speicherung in relationalen Datenbankstrukturen (= Tabellen) 

* Ansatz 1: verwendet man CLOBs oder BLOBs
* Ansatz 2: spaltet das Dokument in mehrere Tabellen/Spalten auf

Nachteile dieser Ansätze:
* Ansatz 1: Suchen auf den Daten ist nicht performant - es sei denn die Datenbank verfügt über entsprechende NoSQL-Erweiterungen
* Ansatz 2: sehr aufwendig - Boilerplate-Mapping-Code (fehleranfällig, schwer wartbar)

## Vorteile NoSQL Datenbanken
* Versionierung out-of-the-box
* Replikation out-of-the-box => horizontale Skalierung leicht
* schemalos (bei ElasticSearch spricht man von einem schemaless-schema) - kommt also gut mit Änderungen an den Schemata zurecht

# Kategorisierung
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

# Produkte im Detail
## Document Store - Elasticsearch 
* no ACID transaction support
* no good support for relations ... Graph databases are addressing it

## Graph Database - OrientDB

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







