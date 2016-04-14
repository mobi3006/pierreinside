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

# Beliebte Produkte




