# MySQL

---

# Installation
Unter Linux gibt es zwei Paketquellen:
* RECOMMENDED: offizielle MySQL Pakete ... die Installation läuft über das *MySQL APT Repository* 
* Pakete des Distributionsanbieters

## MySQL APT Repository
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
  * hierzu muss man sich bei Oracle registrieren 
* *MySQL APT Repository* installieren: ``sudo dpkg -i mysql-apt-config_0.8.0-1_all.deb``
  * ACHTUNG: damit wird das System (die Repo-Konfiguration des Linux-Systems) nur so konfiguriert, daß man die offiziellen MySQL Pakete installieren kann
* ``sudo apt-get update``, um die MySQL Repository Informationen upzudaten

## User einrichten
Bei der Einrcihtung eines Users gibt man den Usernamen und den Host an, mit dem man zugreifen möchte. Verwendet man

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

# Konfiguration
Erfolgt über ``/etc/mysql/my.cnf``, die aber wiederum weitere ``*.cnf`` Dateien in ``/etc/mysql/conf.d/`` berücksichtigt und miteinander abmischt ... die Dateien in ``/etc/mysql/conf.d/`` überschreiben die Werte in ``/etc/mysql/my.cnf``.

---

# MySQL Workbench
* https://www.youtube.com/watch?v=X_umYKqKaF0

MySQL stellt mit der Workbench auch Tooling für Developer bereit, um

* die Datenbank zu administrieren
* Datenbankabfragen auszuführen
* Performanceanalysen durchzuführen

## Installation
* http://dev.mysql.com/doc/workbench/en/wb-installing-linux.html

Man sollte nach Möglichkeit die Pakete von MySQL selbst verwenden (aka ``mysql-workbench-community``) anstatt die - teilweise veralteten - Pakete des Distributionsanbieters (aka ``mysql-workbench``).

DESHALB:
* das MySQL APT Repository installieren, um die offiziellen Pakete zu bekommen
  * siehe Installation von MySQL (weiter oben)
* ``sudo apt-get install mysql-workbench-community``
* MySQL Workbench starten: ``mysql-workbench``

## Performance Analyse
siehe eigene Seite

---

# Storage Engine
MySQL bietet mehrere Storage Engines an, die teilweise hoistorisch gewachsen sind - teilweise aber auch unterschiedliche Einsatzbereiche haben:

* InnoDB: transaktional
* MyISAM: nicht transaktional

---

# Information Schema
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

---

## MySQL Enterprise Manager
* https://www.mysql.com/products/enterprise/monitor.html
* Youtube Video: https://www.youtube.com/watch?v=e5HhC0XiioY

Da MySQL mittlerweile zu Oracle gehört, sieht der MySQL Enterprise Manager fast genauso aus wie der Oracle Enterprise Manager. Vom Oracle Enterprise Manager war ich sehr begeistert ... wir haben damit viele Bottlenecks entdeckt und konnte diese oft schon mit kleinen Änderungen (z. B. Index anlegen) beheben.

Mit diesem Tool sind gezielte Realtime-Analysen möglich, um die Hotspots auf der Datenbank zu finden (Explain-Plans, Index-Nutzung, IO auf Filesystem und Netzwerk).

## MySQL Workbench
* https://www.mysql.de/products/workbench/performance/

---

# Optimierung
* http://dev.mysql.com/doc/refman/5.7/en/mysqlcheck.html

Die SQL-Engine benötigt Informationen über die Datenbelegung der Tabellen, um den besten Execution Plan berechnen zu können. Das liegt daran, daß je nach Belegung unterschiedliche Indexzugriffe optimal sind.

Bei Oracle verwendet man den sog. *Gather Stats Job* ... bei MySQL verwendet man ``mysqlcheck`` mit ``--analyze`` und ``--optimize`` Option:

```
mysqlcheck --analyze --databases mydatabase --user root -p
```

---

# MySQL im Docker Container
Vermutlich wird man die Datenbank-Dateien auf den Docker-Host legen wollen, um den MySQL-Container wegwerfen und neu deployen zu können, ohne die Daten zu verlieren.

Hier läuft man allerdings schnell in Permission-Probleme, weil die User-Ids auf dem Docker-Host nicht mit den User-Ids im Docker-Container übereinstimmen und man somit auf dem Docker-Host nur als ``root`` volle Rechte auf die Dateien hat (um beispielsweise die Datenbank-Dateien zu löschen).  

## Backup und Restore
* http://depressiverobot.com/2015/02/19/mysql-dump-docker.html

---

# FAQ
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

**Antwort 1:** Das liegt daran, daß die MySQL-Server im Container liegt und das Unix-Socket-File ``/var/run/mysqld/mysqld.sock`` auf dem Docker-Host gar nicht existiert. Es muß eine Network-Socket Kommunikation initiiert werden. Hierzu muß statt ``localhost:32768`` ein ``127.0.0.1:32768`` verwendet werden. 
Alternativ kann man die Verbindungsart auch per ``--protocol=TCP`` angeben (http://serverfault.com/questions/337818/how-to-force-mysql-to-connect-by-tcp-instead-of-a-unix-socket)
