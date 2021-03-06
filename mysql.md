# MySQL

---

## Distributionen

Es gibt u. a. folgende Distributionen

* Community MySQL ... von Oracle
  * bildet die Grundlage für die anderen Distributionen
* MariaDB
  * hat häufig ein paar dedizierte Performance-Optimierungen
  * erstellt vom MySQL Gründer
* Percona Server
  * hat häufig ein paar dedizierte Performance-Optimierungen
  * SlowQuery Log ist viel informativer
* WebScaleSQL
  * Fork von Facebook, Google, ...

Diese Distributionenn sind zueinander kompatibel, so daß man eine andere Distribution installieren kann, die auf den Dateien der anderen arbeitet.

---

## Installation

Unter Linux gibt es zwei Paketquellen:

* RECOMMENDED: offizielle MySQL Pakete ... die Installation läuft über das *MySQL APT Repository* (siehe unten)
* Pakete des Distributionsanbieters

### MySQL APT Repository

* http://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/
* http://dev.mysql.com/downloads/repo/apt/

Enthält:

* verschiedene MySQL Server Versionen
* MySQL Workbench
* MySQL Utilities
* MySQL Suite
* MySQL Router

Schritt für Schritt:

* download des *MySQL APT Repository* von hier: http://dev.mysql.com/downloads/repo/apt/
  * hierzu muss man NICHT sich bei Oracle registrieren ... einfach _No thanks, just start my download_ auswählen, dann gehts auch ohne Registrierung
* *MySQL APT Repository* installieren: ``sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb``
  * ACHTUNG: damit wird das System (die Repo-Konfiguration des Linux-Systems) nur so konfiguriert, daß man die offiziellen MySQL Pakete installieren kann
* ``sudo apt-get update``, um die MySQL Repository Informationen upzudaten
* danach kann man dann weitere Pakete wie z. B. den MySQL Server oder die MySQL Workbench per `apt-get install mysql-workbench-community` installieren

Nach meinemm Upgrade von Ubuntu 16.04 LTS auf 18.04 LTS war dann plötzlich meine MySQL Workbench weg. Nach `sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb` wollte ich es per `sudo apt-get update && sudo apt-get install mysql-workbench-community` installieren, doch das schlug hiermit fehl:

```
The following packages have unmet dependencies:
 mysql-workbench-community : Depends: libcurl3 (>= 7.16.2) but it is not going to be installed
                             Depends: libjasper1 but it is not installable
                             Depends: libnetcdf11 (>= 4.0.1) but it is not installable
                             Depends: libpng12-0 (>= 1.2.13-4) but it is not installable
                             Depends: libxerces-c3.1 but it is not installable
```

Zeit für mich auf das Tool meiner Kollegen _[DBeaver](https://dbeaver.io/) umzusteigen. Diese elenden Dependencies ... Docker ist echt eine geniale Erfindung (auch wenn es mir in dem Fall in keiner Weise hilft).

### User einrichten

Bei der Einrichtung eines Users gibt man den Usernamen und den Host an, mit dem man zugreifen möchte. Verwendet man

```
pfh@localhost
```

dann kann man sich nur vom Rechner anmelden, auf dem der Server läuft. Verwendet man stattdessen

```
pfh@*
```

dann kann man sich von jedem Rechner anmelden.

Das hat aber scheinbar nichts mir der Bindung des Kommunikationsports an das Netzwerkinterface zu tun. Ich finde das sehr strange.

---

## Konfiguration und Administration

Erfolgt über ``/etc/mysql/my.cnf``, die aber wiederum weitere ``*.cnf`` Dateien in ``/etc/mysql/conf.d/`` berücksichtigt und miteinander abmischt ... die Dateien in ``/etc/mysql/conf.d/`` überschreiben die Werte in ``/etc/mysql/my.cnf``.

### User und Datenbanken anlegen

* [MySQL Passwort-Generator](https://www.browserling.com/tools/mysql-password)

Ich bin ein großer Fan von CLI's, weil ich dann meine Befehle immer wieder über die Command-History wiederfinden kann und außerdem mit Kollegen austauschen kann. Das ist dann oftmals schon der erste Schritt zur Automatisierung von Aufgaben. Hierzu benötigt man das `mysql`-CLI-Tool. Am einfachsten man startet einen Docker-Container (z. B. `docker run -it mysql:5.7 sh`) - alternativ kann man natürlich einen MySQL-Client installieren.

Beachte, daß an einer Stelle Backticks benutzt werden müssen, wenn der Datenbankname Bindestriche enthält!!!

```bash
mysql -u root -h db.cachaca.de -p
... interaktive Passwortabfrage ...
create database `pierre-database`
GRANT ALL PRIVILEGES ON `pierre-database`.* TO 'pierre'@'%' IDENTIFIED BY PASSWORD '*A4B6157319038724E3560894F7F932C8886EBFCF;';
```

Anschließend sollten die Grants `show grants 'pierre';` so aussehen:

```
+-------------------------------------------------------------------------------------------------------+
| Grants for pierre@%                                                                                   |
+-------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO 'pierre'@'%' IDENTIFIED BY PASSWORD '*A4B6157319038724E3560894F7F932C8886EBFCF' |
| GRANT ALL PRIVILEGES ON `pierre`.* TO 'pierre'@'%'                                                  |
+-------------------------------------------------------------------------------------------------------+
```

und ich sollte mich mit dem User `pierre/1234` (Passwort ist `1234`) anmelden können und per

```
use pierre;
create table haus (id VARCHAR(32)) DEFAULT CHARSET=utf8;
```

die Tabelle `pierre.haus` anlegen können.

> In dem Beispiel führe ich das Anlegen der Datenbank in dem `mysql` Terminal aus - das ist also von der Bash-History nicht abgedeckt. In diesem Fall ist das beabsichtigt, da hier auch Passwörter erforderlich sind, die ich **NICHT** in der History haben möchte.

Nach diesen Schritten kann sich der User `my-user` an der Datenbank `pierre-database` des Datenbankservers `db.cachaca.de` von allen Rechnern aus anmelden (für das hashed Passwort habe ich [MySQL Passwort-Generator](https://www.browserling.com/tools/mysql-password) verwendet) und hat dabei alle Berchtigungen (`ALL PRIVILEGES` = `SELECT` + `INSERT` + ... [siehe Dokumentation](https://dev.mysql.com/doc/refman/5.7/en/grant.html)).

Ich hatte mal Probleme mit der `REVOKE` Syntax ... das `shwo grants for pierre` Kommando hat mir dann geholfen, den richtigen Befehl mit den richtigen Hochkomma und Backticks zu finden. Einfach in

    GRANT ALL PRIVILEGES ON `pierre`.* TO 'pierre'@'%'

das `GRANT` durch `REVOKE` und `TO`durch `FROM` austauschen:

    REVOKE ALL PRIVILEGES ON `pierre`.* FROM 'pierre'@'%'

Voila ;-)

---

## MySQL Workbench

* https://www.youtube.com/watch?v=X_umYKqKaF0

MySQL stellt mit der Workbench auch Tooling für Developer bereit, um

* die Datenbank zu administrieren
* Datenbankabfragen auszuführen
* Performanceanalysen durchzuführen

### Installation

* http://dev.mysql.com/doc/workbench/en/wb-installing-linux.html

Man sollte nach Möglichkeit die Pakete von MySQL selbst verwenden (aka ``mysql-workbench-community``) anstatt die - teilweise veralteten - Pakete des Distributionsanbieters (aka ``mysql-workbench``).

DESHALB:

* das MySQL APT Repository installieren, um die offiziellen Pakete zu bekommen (siehe oben)
* ``sudo apt-get install mysql-workbench-community``
* MySQL Workbench starten: ``mysql-workbench``

### Performance Analyse

siehe eigene Seite

---

## dbeaver

Nach einem Upgrade meiner Linux-Distribution hat die MySQL-Workbench nicht mehr funktioniert und ich habe dem [dbeaver](https://dbeaver.io/) eine Chance gegeben, da meine Kollegen begeistert sind.

... ich mag ihn auch

---

## Storage Engine

MySQL bietet mehrere Storage Engines an, die teilweise hoistorisch gewachsen sind - teilweise aber auch unterschiedliche Einsatzbereiche haben:

* InnoDB: transaktional
* MyISAM: nicht transaktional

### InnoDB

* jede Tabelle landet in einer eigenen Datei, die einen Tablespace repräsentiert (zumindest bei der Einstellung `innodb_file_per_table=1`) - ein Aufteilen auf verschiedene Festplatten (schnell/langsam) mit jeweils eigenen Festplattencontrollern (Zugriffsparallelisiserung) ist dadurch möglich
* Row-Locks
* ACID Support

### MyISAM

* kennt nur Table-Locks keine Row-Locks ... schlechte Performance in Multi-Session-Szenarien

---

## Information Schema

MySQL hält neben dem *Performance Schema* (siehe unten) auch das sog. *Information Schema*. In diesem findet man beispielsweise die Größe der Datenbank und die Anzahl der Zeilen.

> ACHTUNG: es handelt sich hier nur um ungefähre Angaben ... insbes. bei der Zeilenanzahl wird man das schnell feststellen. Diese Daten verändern sich auch, wenn man ein ``ANALYZE TABLE`` durchführt (und das sollte man auch tatsächlich tun bevor man verlässliche Angaben haben will!!!).

```
SELECT
	TABLE_NAME, 
    table_rows, 
    round(((data_length) / 1024 / 1024),2) "Data Length in MB" , 
    round(((index_length) / 1024 / 1024),2) "Index Length in MB", 
	round(((data_length + index_length) / 1024 / 1024),2) "Size in MB"
FROM information_schema.TABLES 
WHERE table_schema = "mydatabase" and
	  round(((data_length + index_length) / 1024 / 1024),2) > 10
```

> ACHTUNG:
>
> * man sollte vor der Nutzung des Information Schema ein Analyze Tables machen, ansonsten sind die Werte nicht aktuell
> * `table_rows` kann man nicht gebrauchen ... es handelt sich um einen hochgerechneten Wert (aus der `data_length` und einem durchschnittlichen Datensatz

---

### MySQL Enterprise Manager

* https://www.mysql.com/products/enterprise/monitor.html
* Youtube Video: https://www.youtube.com/watch?v=e5HhC0XiioY

Da MySQL mittlerweile zu Oracle gehört, sieht der MySQL Enterprise Manager fast genauso aus wie der Oracle Enterprise Manager. Vom Oracle Enterprise Manager war ich sehr begeistert ... wir haben damit viele Bottlenecks entdeckt und konnte diese oft schon mit kleinen Änderungen (z. B. Index anlegen) beheben.

Mit diesem Tool sind gezielte Realtime-Analysen möglich, um die Hotspots auf der Datenbank zu finden (Explain-Plans, Index-Nutzung, IO auf Filesystem und Netzwerk).

... mittlerweile bin ich großer von von [Instana](instana.md) - Realtime Live Database Analyse und noch mehr :-)

### MySQL Workbench

* https://www.mysql.de/products/workbench/performance/

---

## Optimierung

* http://dev.mysql.com/doc/refman/5.7/en/mysqlcheck.html

Die SQL-Engine benötigt Informationen über die Datenbelegung der Tabellen, um den besten Execution Plan berechnen zu können. Das liegt daran, daß je nach Belegung unterschiedliche Indexzugriffe optimal sind.

Bei Oracle verwendet man den sog. *Gather Stats Job* ... bei MySQL verwendet man ``mysqlcheck`` mit ``--analyze`` und ``--optimize`` Option:

```bash
mysqlcheck --analyze --databases mydatabase --user root -p
```

---

## MySQL-Server im Docker Container

Vermutlich wird man die Datenbank-Dateien auf den Docker-Host legen wollen, um den MySQL-Container wegwerfen und neu deployen zu können, ohne die Daten zu verlieren.

Hier läuft man allerdings schnell in Permission-Probleme, weil die User-Ids auf dem Docker-Host nicht mit den User-Ids im Docker-Container übereinstimmen und man somit auf dem Docker-Host nur als ``root`` volle Rechte auf die Dateien hat (um beispielsweise die Datenbank-Dateien zu löschen).

### Backup und Restore

* http://depressiverobot.com/2015/02/19/mysql-dump-docker.html

---

## MySQL-Tooling im Docker Container

Nicht jeder hat die MySQL Tools auf seinem Rechner installiert. Was liegt da näher als einen MySQL-Container zu starten und die Tools daraus zu nutzen.

### Zugriff über MySQL Client aus Docker Container

Das Tool `mysql` ist ein CLI zum Zugrifdf auf MySQL Datenbanken:

```bash
pfh@workbench ~ % docker run mysql:5.7 \
   mysql \
      --protocol=TCP \
      --host="10.90.61.109" \
      --port=53306 \
      --user="root" \
      --password=root \
      --database=mydb \
      --execute="select * from information_schema.TABLES"
```

Das funktioniert grundsätzlich ganz prima. Läuft die Datenbank allerdings auf dem Docker-Host in einem Docker-Container, dann darf man nicht ``localhost`` oder ``127.0.0.1`` als `` host`` verwenden, sondern die IP-Adresse des Docker-Hosts. Ansonsten bekommt man einen kryptischen Fehler dieser Art:

```
ERROR 2003 (HY000): Can't connect to MySQL server on '127.0.0.1' (111)
```

siehe auch http://dev.mysql.com/doc/refman/5.7/en/problems-connecting.html

---

## FAQ

* https://dev.mysql.com/doc/refman/5.6/en/problems-connecting.html

**Frage 1:** Ich habe einen MySQL Server im Docker-Container laufen - gestartet per ``docker run --name piedb -e MYSQL_ROOT_PASSWORD=Test1234 -d -P mysql:5.7``. Der Server startet auch korrekt 

```
2016-09-14T13:26:53.173357Z 0 [Note] mysqld: ready for connections.
Version: '5.7.15'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306
MySQL Community Server (GPL)
```

und der Port 3306 ist auch weitergeleitet:

```
0.0.0.0:32768->3306/tcp
```

aber wenn ich mich mit einem Datenbank-Client darauf connecten will (localhost:32768), dann bekomme ich die Fehlermeldung

```
Unable to connect to the database. 
Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
```

**Antwort 1:** Das liegt daran, daß die MySQL-Server im Container liegt und das Unix-Socket-File ``/var/run/mysqld/mysqld.sock`` auf dem Docker-Host gar nicht existiert. Es muß eine Network-Socket Kommunikation initiiert werden. Hierzu muß statt ``localhost:32768`` ein ``127.0.0.1:32768`` verwendet werden. Alternativ kann man die Verbindungsart auch per ``--protocol=TCP`` explizit angeben (http://serverfault.com/questions/337818/how-to-force-mysql-to-connect-by-tcp-instead-of-a-unix-socket).

Siehe auch http://dev.mysql.com/doc/refman/5.7/en/problems-connecting.html
