# Graylog

---

# Getting Started
Ich liebe [Docker](docker.md), denn damit funktioniert der Start innerhalb weniger Sekunden (http://docs.graylog.org/en/2.2/pages/installation/docker.html). Folgenden Inhalt als `docker-compose.yml` speichern

```
version: '2'
services:
  mongo:
    image: "mongo:3"
  elasticsearch:
    image: "elasticsearch:2"
    command: "elasticsearch -Des.cluster.name='graylog'"
  graylog:
    image: graylog2/server:2.2.1-1
    environment:
      GRAYLOG_PASSWORD_SECRET: somepasswordpepper
      GRAYLOG_ROOT_PASSWORD_SHA2: 8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
      GRAYLOG_WEB_ENDPOINT_URI: http://127.0.0.1:9000/api
    depends_on:
      - mongo
      - elasticsearch
    ports:
      # Web UI
      - "9000:9000"
      # Input channel
      - "5555:5555"
```

und danach ein `docker-compose`. Wenige Sekunden später (nicht ungeduldig sein - es kann bis zu 30 Sekunden dauern) ist die UI per `http://localhost:9000` erreichbar und man kann sich mit `admin:admin` einloggen.

Die Daten werden auch erstmal nur im Container persistiert ... sind also weg, wenn man man den Container löscht. Im Abschnitt *Automatisiertes Docker Deployment* werde ich einige Verbesserungen beschreiben.

Zunächst muß man Graylog einen Input-Kanal verpassen (System - Inputs), über den Nachrichten reinkommen können. Mm besten verwendet man einen ganz einfachen *Plaintext TCP* oder *Plaintext UDP* Inputkanal. Dann kann man per [Netcat](https://wiki.ubuntuusers.de/netcat/) über die Konsole Nachrichten zum Inputkanal schicken:

```
echo "first log message" | nc -w 0 -u 127.0.0.1 5555
```

... und voila - kurze Zeit später - findet man den Eintrag über die Suche im Graylog.

---

# Inputtypen
Folgende Inputmöglichkeiten stehen out-of-the-box zur Verfügung:

* Plaintext TCP, UDP, Kafka, AMQP
* Syslog TCP, UDP, Kafka, AMQP
* GELF TCP, UDP, Kafka, AMQP, HTTP
* Beats

---

# Anwendungslogging
Microservices sind derzeit ein Hype, der die Notwendigkeit eines zentralen Log-Reportings erhöht. Niemand kann die vielen Log-Files auswerten, wenn sie nicht irgendwo gesammelt werden. Hier haben sich Ansätze wie Graylog und ELK etabliert, die ein komfortable UI Schnittstelle (und REST-Schnittstellen) zur Auswertung der Logs bietet.

Graylog hat mit [GELF](http://docs.graylog.org/en/2.2/pages/gelf.html) sogar ein eigenes Log-Format aus der Taufe gehoben und bietet für verschiedenen Programmiersprachen APIs an. Über GELF lassen sich auch Logs von Windows-Maschinen integrieren.

Um Java-Logs ins Graylog zu bekommen, muß man an der Anwendung i. a. nichts verändert. Meistens verwenden die Anwendnungen eh schon Java-Logging und hierfür gibt es den sog. `GelfAppender`, den man in die log4j Konfiguration integriert:

```
<appender name="GELF" class="me.moocar.logbackgelf.GelfAppender">
        <graylog2ServerHost>localhost</graylog2ServerHost>
        <graylog2ServerPort>5559</graylog2ServerPort>
        <useLoggerName>true</useLoggerName>
        <useThreadName>true</useThreadName>
        <messagePattern>%m%n%ex{full}</messagePattern>
        <shortMessagePattern>%m%.-250rEx{short}</shortMessagePattern>
        <includeFullMDC>true</includeFullMDC>
        <hostName>localhost</hostName>
        <staticAdditionalField>anyfield:anyvalue</staticAdditionalField>
</appender>
```

Anschließend benötigt Graylog aber noch einen GELF- Inputkanal (System - Inputs), der an den o. a. Port `5559` gebunden wird. 

---

# Automatisiertes Docker Deployment
Mit dem *Getting Started* Ansatz bekommt man zunächst nur einen leeren Graylog Server zum Laufen. Man will die Konfiguration aber nicht immer wieder erneuern, wenn man den Container neu aufsetzt (z. B. wegen eines Image Updates). Außerdem nöchte man die Konfiguration evtl. unter Versionskontrolle stellen.

## Konfiguration
Graylog bietet die Möglichkeit sog. Content-Packages zu exportieren/importieren ... und das bereits beim Startup oder aber auch während des laufenden Betriebs. Auf diese kann man auch leicht Konfigurationen zwischen Servern austauschen.

Für den automatischen Import eines Content-Packages (hier `my-contentPack.json`) beim Serverstart muß folgende Konfiguration (`graylog.conf`) vorgenommen werden:

```
content_packs_loader_enabled = true
content_packs_dir = /usr/share/graylog/data/contentpacks
content_packs_auto_load = grok-patterns.json, my-contentPack.json
```

### Alternative: MongoDB dump/restore
* https://docs.mongodb.com/manual/tutorial/backup-and-restore-tools/

Graylog verwendet MongoDB als Storage für die Konfiguration. Dementsprechend kann man die gesamte (!!!) Konfiguration sichern (`mongodump --out /dump/ --db graylog`) und wiederherstellen (`mongorestore --db=graylog /dump/graylog`).

## REST API
* http://docs.graylog.org/en/2.2/pages/configuration/rest_api.html

Die REST API kann bei einigen Dingen sehr hilfreich sein. Über *System - Nodes - API browser* gelangt man zu einem [Swagger-UI](http://swagger.io/), mit dem sich die REST-Schnittstelle aus dem Browser heraus bedienen läßt.