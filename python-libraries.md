# Python Libraries

Die Mächtigkeit einer Sprache steht und fällt mit den Libraries - erst dadurch wird ein Tool richtig effizient. Python lernt man schnell, doch es dauert bis man sich gut in den Libraries und Frameworks auskennt. Es lohnt sich, denn Python hat einiges zu bieten.

---

## Konzept

Module, die Python nicht mitliefert müssen per `pip install MODULE_NAME` installiert werden. Für die Automatisierung dieses Prozesses ist es hilfreich, alle notwendigen Module in einer Datei (z. B. `requirements.txt`) zu sammeln (die i. a. unter Versionskontrolle steht) und dann per `pip3 install -r requirements.txt` auf einen Schlag zu installieren. Das vereinfacht die Nutzung einer (unbekannten) Anwendung ungemein.

> ACHTUNG: hier sollte man die Systeminstallation (z. B. `/usr/bin/python`) nicht mit allerhand Libraries vollballern. Auf einem System nutzt man i. a. viele Versionen einer Bibliothek und deshalb sollte man die Ausführungsumgebung immer projektspezifisch halten. Das hilft auch beim Fail-Fast-Prinzip ... vergißt man eine notwendige Bibliothek in `requirements.txt` zu erwähnen. Am besten funktioniert das mit [virtuellen Umgebungen](python.md). Docker-Container bieten auch eine Möglichkeit, doch sind virtuelle Umgebungen noch besser in die Entwicklungsarbeit (z. B. Shell) integriert.

---

## Selenium

[siehe eigener Abschnitt](python-selenium.md)

---

## CLIs - Command Line Interfacse

[siehe eigener Abschnitt](cli.md)

---

## Web-Services - requests

* [Homepage](https://docs.python-requests.org/en/master/)

Was wäre die Welt ohne Webservices ...

---

## Template-Engine - jinja2

[siehe eigener Abschnitt](jinja2.md)

... zur Generierung von Content (HTML-Seiten, JSON, XML, ...) - ein Tool, das wirklich jeder (insbes. im DevOps-Bereich) braucht.

---

## Django

[siehe eigenes Kapitel](django.md)

---

## FastAPI

* [siehe separate Seite](fastapi.md)

