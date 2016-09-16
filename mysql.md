# MySQL

---

# Konfiguration
Erfolgt über ``/etc/mysql/my.cnf``, die aber wiederum weitere ``*.cnf`` Dateien in ``/etc/mysql/conf.d/`` berücksichtigt und miteinander abmischt ... die Dateien in ``/etc/mysql/conf.d/`` überschreiben die Werte in ``/etc/mysql/my.cnf``.

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
