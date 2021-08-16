# Python Libraries

Die Mächtigkeit einer Sprache steht und fällt mit den Libraries - erst dadurch wird ein Tool richtig effizient. Python lernt man schnell, doch es dauert bis man sich gut in den Libraries und Frameworks auskennt. Es lohnt sich, denn Python hat einiges zu bieten.

---

## Konzept

Module, die Python nicht mitliefert müssen per `pip install MODULE_NAME` installiert werden. Für die Automatisierung dieses Prozesses ist es hilfreich, alle notwendigen Module in einer Datei (z. B. `requirements.txt`) zu sammeln (die i. a. unter Versionskontrolle steht) und dann per `pip3 install -r requirements.txt` auf einen Schlag zu installieren. Das vereinfacht die Nutzung einer (unbekannten) Anwendung ungemein.

> ACHTUNG: hier sollte man die Systeminstallation (z. B. `/usr/bin/python`) nicht mit allerhand Libraries vollballern. Auf einem System nutzt man i. a. viele Versionen einer Bibliothek und deshalb sollte man die Ausführungsumgebung immer projektspezifisch halten. Das hilft auch beim Fail-Fast-Prinzip ... vergißt man eine notwendige Bibliothek in `requirements.txt` zu erwähnen. Am besten funktioniert das mit [virtuellen Umgebungen](python.md). Docker-Container bieten auch eine Möglichkeit, doch sind virtuelle Umgebungen noch besser in die Entwicklungsarbeit (z. B. Shell) integriert.

---

## Paketmanager Pip

* [How to publish your own Python Package to PyPI](https://realpython.com/courses/how-to-publish-your-own-python-package-pypi/)

Für die Installation neuer Pakete (zusätzlich zu den Paketen in der Python-Installation) verwendet man `pip install foo`. Die Python-Pakete werden dann von [PyPI](https://pypi.org/) runtergeladen und lokal (in der Python Distribution bzw. im virtuellen Environment) installiert, so daß sie für die Nutzung im eigenen Code oder als eigenständige Anwendung zur Verfügung stehen.

Will man ein installiertes Paket, das eine Anwendung repräsentiert, starten, so tut man das per `python -m reader` (in diesem Beispiel muß man das Paket [`realpython-reader`](https://pypi.org/project/realpython-reader/) vorher natürlich per `pip install realpython-reader` installiert haben).

> Im Source-Code dieses `readers` erkennt man in der [`setup.py`](https://github.com/realpython/reader/blob/master/setup.py), daß die Anwendung bei der Installation als `realpython` zum Aufruf per Console zur Verfügung gestellt wird:
>
> ```properties
> entry_points={"console_scripts": ["realpython=reader.__main__:main"]},
> ```
>
> Statt eines `python -m reader` kann man also auch einfach `realpython` ausführen.

### Paketstruktur

Der Source-Code eines Python-Pakets muß folgende Struktur haben und entsprechende Dateien bereitstellen:

```text
your-package/
    __init__.py
    __main__.py     # support for python -m
    foo.py
test/
setup.py
README
LICENSE
MANIFEST
```

### PyPI

### Eigenes Python Repository

Bei der Entwicklung von Non-Open-Source Software will man seine Software natürlich nicht für die ganze Welt bereitstellen, sondern evtl. nur innerhalb eines Unternehmens. Hierzu benötigt man ein Artifact-Repositiory (z. B. Nexus), das die Pakete beherbergt (als Ersatz für PyPI).

Statt eines 

* https://stackoverflow.com/questions/56592918/how-to-upload-the-python-packages-to-nexus-sonartype-private-repo

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

---

## Jenkins - api4jenkins

* [Dokumentation](https://api4jenkins.readthedocs.io/en/latest/)
* [PyPi Site](https://pypi.org/project/api4jenkins/)

