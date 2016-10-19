# MySQL Performance

---

# Analyse
## Performance Schema
Das Server Feature *Performance Schema* (seit MySQL 5.5) muß einkonfiguriert sein, damit der Server entsprechende Daten mitloggt (in Datenbanktabellen schreibt). In der MySQL Workbench kann man Über ``Server - Performance Server Setup`` den Detailgrad des Loggings definieren.

Mit der MySQL Workbench können die Ergebnisse recht komfortabel ausgewertet werden.

> ACHTUNG: die Bereitstellung der Performance-Daten kostet auf jeden Fall Performance auf dem Server!!!

## MySQL Workbench
Dieses kostenlose Tool ist schon sehr praktisch, wenn man auf der Suche nach Bottlenecks ist.

## Logging
In der Softwareentwicklung verwendet man häufig Prepared Queries, weil deren Execution Plan nur ein einziges mal berechnet werden muß und dann unabhängig von den Parameter-Bindings genutzt werden können. Explain Plan ist eine recht teure Operation und deshalb macht dieses Vorgehen Sinn.

Nachteil dieses Ansatzes ist allerdings, daß Query und Parameter getrennt sind und häufig auch getrennt geloggt werden (z. B. EclipseLink mit ``eclipselink.logging.level.sql`` und ``eclipselink.logging.parameters``).

Konfiguriert man das Logging im MySQL Server entsprechend

```
general_log=0
general_log_file=/var/lib/mysql/general-log-file.log
```

, dann erhält man im Log vollständige Queries, die man direkt in der MySQL Workbench ausführen kann, um den Explain Plan zu untersuchen.

### Slow-Query Log
Hierüber werden langlaufende Queries in eine Datei geloggt:

```
slow_query_log=0
slow_query_log_file=/var/lib/mysql/slow-query.log
```

Sehr praktisch!!!

---

# Tips
## analyze table
Die Ermittlung des optimalen Explain Plan hängt vom Inhalt der Tabellen ab. Das liegt daran, daß häufig - aufgrund von Indexen, die ähnlich sind - verschiedene Zugriffspfade existieren (neben einem FULL TABLE SCAN). Ein ``analyze table`` hilft dem Optimizer bessere Execution Plans zu ermitteln. Deshalb sollte man dies auch regelmäßig tun.

> Unter Oracle kennt man das als GATHER STATS JOB

Am besten verwendet man ein Script, das alle Tabellen einer Datenbank analyisiert:

```
mysqlcheck --analyze --databases myDatabase --user=root --password=pwd
```

Häufig ist diese Analyse auch relativ schnell durch (hängt natürlich von der Datenbankgröße ab).

* FRAGE: blockiert es???

Per ``show index myTable`` kann man auch die Effizienz der Indizes erfahren (in MySQL Workbench sieht an das über den *Table Inspector*). Eine Kardinalität von 0 deutet auf eine schlechte Effizienz hin ... vielleicht verschafft ein ``analyze table`` hier Abhilfe.

## optimize table
Im Gegensatz zum ``analyze table`` greift ``optimize table`` in die Speicherorganisation der Datenbank ein. Die Datenbank ist während

## Selektivität
Das Ziel des Optimizers ist es, möglichst schnell eine Reduktion der zu berücksichtigenden Datenmenge zu erreichen. Das schafft man, indem die WHERE-clauses ausgewertet werden mit den Indizes, die das erreichen.

### Kardinalität
Die Kardinalität beschreibt wieviele verschiedene Werte ein Index hat. Beispiele:

* bei einem Index auf ``sex`` könnte das beispielsweise 2 sein
* bei einem Index auf ``(age, sex)`` könnten das - angenommen die Personen gehen von 0 Jahre bis 100 Jahre und sind Männer und Frauen - 200 sein

Die Kardinalität in Relation zur Anzahl der Zeilen spiegelt die Selektivität des Index wieder.

Ein Index mit niedriger Kardinalität ``(sex)`` kann aber dennoch gute Dienste leisten. Wenn die Verteilung in der Tabelle bei 

* male: 99
* female: 1

liegt, dann ist ein ``select * from person where sex = 'female'`` extrem schnell.

### Zusammengesetzte Indizes
Ein Index sollte so gewählt sein, daß die Spalten mit der höchsten Reduktion weit vorne stehen. Ein Beispiel:

* BESSER: ``CREATE INDEX idx ON person (age, sex)``
* SCHLECHTER:  ``CREATE INDEX idx ON person (sex, age)``

> ACHTUNG: *besser* oder *schlechter* hängt von der Datenverteilung ab. Wenn ich eine Normalverteilung habe, gelten die Aussagen. Habe ich allerdings nur Personen im Alter von 13 Jahren, dann wäre ``(sex, age)`` besser. DESHALB ist es bei der Performanceoptimierung wichtig, mit realistischen Daten zu arbeiten, die möglichst die gleiche Verteilung aufweisen wie in Live-Betrieb.

## Fragmentierung
* http://dev.mysql.com/doc/refman/5.0/en/innodb-file-defragmenting.html

## Partitionierung
* https://dev.mysql.com/doc/refman/5.1/en/partitioning-types.html

---

# FAQ
## count(foo) ist teuer
* http://stackoverflow.com/questions/511820/select-count-is-slow-even-with-where-clause

