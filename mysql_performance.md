# MySQL Performance
* http://www.tecmint.com/mysql-mariadb-performance-tuning-and-optimization/
* http://www.speedemy.com/mysql-configuration-tuning-handbook/
* http://speedemy.com/files/mysql/my.cnf

MySQL Community Edition hat brauchbare Default Einstellungen, aber die Konfiguration muß auf jeden Fall an die Bedürfnisse angepaßt werden.

---

# Analyse
## Performance Schema
Das Server Feature *Performance Schema* (seit MySQL 5.5) muß einkonfiguriert sein, damit der Server entsprechende Daten mitloggt (in Datenbanktabellen schreibt). In der MySQL Workbench kann man Über ``Server - Performance Server Setup`` den Detailgrad des Loggings definieren.

Mit der MySQL Workbench können die Ergebnisse recht komfortabel ausgewertet werden.

> ACHTUNG: die Bereitstellung der Performance-Daten kostet auf jeden Fall Performance auf dem Server!!!

## MySQL Workbench
Dieses kostenlose Tool ist schon sehr praktisch, wenn man auf der Suche nach Bottlenecks ist.

## MySQL Enterprise Manager

## MySQLTuner-perl
* https://github.com/major/MySQLTuner-perl
* Perl Skript, das ein paar wesentliche Konfigurationsparameter überprüft und Optimierungsvorschläge macht

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
long_query_time=2
```

Der letzte Parameter bestimmt welche Ausführungszeit als *slow* eingestuft wird.

Sehr praktisch!!!

---

# Tips
## Konfiguration
### InnoDB Buffer Pool
* http://www.tecmint.com/mysql-mariadb-performance-tuning-and-optimization/2/
* https://dev.mysql.com/doc/refman/5.7/en/innodb-buffer-pool-resize.html

Hierbei handelt es sich um den wichtigsten Konfigurationsparameter. Der Schalter `innodb_buffer_pool_size` bestimmt wieviel RAM MySQL für Caching und Indizes verwenden darf. Bei einem MySQL dedicated Rechner sollte man 70-80% des verfügbaren RAM verwenden.

### Query Cache Size
Dieser Cache macht Sinn, wenn man immer wieder die gleichen Queries absetzt. Ist das nicht der Fall, dann macht es keinen Sinn. Ist der Wert zu hoch, dann hat das nachteilige Ausweirkungen auf die Performance, weil der Cache gelockt werden muß, um ihn zu aktualisieren, d. h. die Threads der anderen Queries werden auch blockiert. Ein Wert zwischen 64 und 256 MB sollte i. a. ausreichend sein.

### Max Connections
Jede Connection (die beispielsweise über die Konfiguration des Application Server Connection Pool aufgebaut wird) benötigt - auch wenn sie nicht genutzt wird - Speicher auf dem MySQL Server.

### OS Swappiness
Defaultmäßig fangen Betriebssysteme bei einer bestimmten RAM-Nutzung (Linux 60% - `sysctl vm.swappiness`) mit swappen an. Bei einer Datenbank. Hat man allerdings einen Dedicated MySQL Server und kann durch dessen Konfiguration den Hauptspeicherbedarf relativ genau bestimmen, dann sollte man den Wert reduzieren oder gar auf 0 setzen (`sysctl -w vm.swappiness=0`).

### Richtiges Filesystem verwenden
MariaDB (ein MySQL Fork) empfiehlt XFS, Ext4 und Btrfs.

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
Im Gegensatz zum ``analyze table`` greift ``optimize table`` in die Speicherorganisation der Datenbank ein (die Fragmentierung wird reduziert).

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

