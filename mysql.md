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

---

# MySQL im Docker Container
## Backup und Restore
* http://depressiverobot.com/2015/02/19/mysql-dump-docker.html

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
