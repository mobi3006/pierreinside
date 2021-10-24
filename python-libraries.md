# Python Libraries

Die Mächtigkeit einer Sprache steht und fällt mit den Libraries - erst dadurch wird ein Tool richtig effizient. Python lernt man schnell, doch es dauert bis man sich gut in den Libraries und Frameworks auskennt. Es lohnt sich, denn Python hat einiges zu bieten.

---

## Konzept

* [Installing Packages](https://packaging.python.org/tutorials/installing-packages/)

Module/Packages (Distributions), die Python nicht mitliefert müssen per `pip install MODULE_NAME` installiert werden (bzw. `pip install MODULE_NAME --upgrade` für ein upgrade auf die letzte Version). Pakete von einem Python-Repository definieren i. a. alle notwendigen Dependencies, so daß diese automatisch mitinstalliert werden.

Hat man hingegen eine Source-Code-Repository geclont (z. B. von GitHub), dann gibt es verschiedene Wege

* handelt es sich um ein Source-Code-Respository, das schon für `setuptools` vorbereitet ist, dann ist `pip install .` das Mittel der Wahl
* ansonsten findet sich vielleicht eine Datei `requirements.txt` im Ordner (Best-Practice) und man kann diese per `pip install -r requirements.txt` auf einen Schlag installieren.

> ACHTUNG: hier sollte man die Systeminstallation (z. B. `/usr/bin/python`) nicht mit allerhand Libraries vollballern. Auf einem System nutzt man i. a. viele Versionen einer Bibliothek und deshalb sollte man die Ausführungsumgebung immer projektspezifisch halten. Das hilft auch beim Fail-Fast-Prinzip ... vergißt man eine notwendige Bibliothek in `requirements.txt` zu erwähnen. Am besten funktioniert das mit [virtuellen Umgebungen](python.md). Docker-Container bieten auch eine Möglichkeit, doch sind virtuelle Umgebungen noch besser in die Entwicklungsarbeit (z. B. Shell) integriert.

---

## Paketmanager Pip

* [How to publish your own Python Package to PyPI](https://realpython.com/courses/how-to-publish-your-own-python-package-pypi/)

Für die Installation neuer Pakete (zusätzlich zu den Paketen in der Python-Installation) verwendet man `pip install foo`. Die Python-Pakete werden dann von [PyPI](https://pypi.org/) runtergeladen und lokal (in der Python Distribution bzw. im virtuellen Environment) installiert, so daß sie für die Nutzung im eigenen Code oder als eigenständige Anwendung zur Verfügung stehen.

> BTW: `pip` ist auch in Python geschrieben und kann somit auch als solches per `python -m pip install foo` aufgerufen werden. Tatsächlich ist das `pip`-Kommando nur ein Python-Script, das so aussieht:

```python
#!/home/pfh/venv/bin/python
# -*- coding: utf-8 -*-
import re
import sys
from pip._internal.cli.main import main
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(main())
```

Will man ein installiertes Paket, das eine Anwendung repräsentiert, starten, so tut man das per `python -m reader` (in diesem Beispiel muß man das Paket [`realpython-reader`](https://pypi.org/project/realpython-reader/) vorher natürlich per `pip install realpython-reader` installiert haben).

> Im Source-Code dieses `readers` erkennt man in der [`setup.py`](https://github.com/realpython/reader/blob/master/setup.py), daß die Anwendung bei der Installation als `realpython` zum Aufruf per Console zur Verfügung gestellt wird:
>
> ```properties
> entry_points={"console_scripts": ["realpython=reader.__main__:main"]},
> ```
>
> Statt eines `python -m reader` kann man also auch einfach `realpython` ausführen.

Eine Alternative zu Pip ist [Easy Install](http://peak.telecommunity.com/DevCenter/EasyInstall) - [Vergleich](https://packaging.python.org/discussions/pip-vs-easy-install/), das vor `pip` existierte.

Pip präferiert das "Wheel"-Paketformat, kann aber auch mit [Source-Distributions](https://packaging.python.org/glossary/#term-Source-Distribution-or-sdist) umgehen, die sich teilweise parallel auf PyPI befinden.

### Eigene Package-Repositories

Per Default werden Python-Packages auf PyPI gesucht. Hat man ein eigenes Python-Repository, so muß man ds konfigurieren. Wo man ds tut findet man am besten per `pip config -v list` raus. Unter Linux kann man die Konfiguration i. a. in `~/.pip/pip.conf` user-spezifisch oder in `/etc/pip.conf` System-global durchführen. Unter Windows ist das vermutlich anders.

### Paketformate

Ein Paket enthält die ausführbaren Python-Module und zudem noch Meta-Informationen

* Wheel ... supported von Pip
* Egg ... supported von Easy-Install

### setuptools

* [Setuptools Dokumentation](http://peak.telecommunity.com/DevCenter/setuptools)

> mit `setuptools` (Built-In-Package) lassen sich Python-Packages als [Python-Eggs](http://peak.telecommunity.com/DevCenter/PythonEggs) oder als Wheel verteilen ("Eggs are to Pythons as Jars are to Java") ... ich denke es gibt hier auch Alternativen. Python-Eggs werden von den beiden bekanntesten Python-Paketmanagers (Pip, Easy Install)

Der Source-Code eines Python-Pakets muß folgende Struktur haben und entsprechende Dateien bereitstellen:

```text
your-package/
    __init__.py
    __main__.py     # support for python -m
    foo.py
test/
setup.py            # <==== MANDATORY ... Python-Code
README.md
LICENSE.txt         # choosealicense.com
MANIFEST.in         # Build-File (welche Dateien sollen ins Package?)
                    # setup.py behandelt nur den Source-Code
```

> ACHTUNG: ob die Tests in einen eigenen Ordner `test` gehören ist mir noch nicht klar ... habe noch keine Best-Practices gefunden.

Zum lokalen Testen (im Development Mode) kann man dann ein `pip install --editable .` verwenden ... `pip` wertet dann das `setup.py`-Datei aus und installiert das Paket in die aktuelle Python-Distribution (z. B. Virtuelles Environment). Die Option `--editable` kann weggelassen werden, sie ermöglicht Änderungen ohne erneutes `pip install .` sichtbar zu machen (zumindest viele Änderungen ... natürlich keine Änderungen an `setup.py`), da direkt auf dem Source-Code gearbeitet wird anstatt auf `site-packages` der Python-Distribution => Realtime-Updates (SEHR zu EMPFEHLEN).

#### Binary Distributions - Wheel Format

Per `python setup.py bdist_wheel` ("B Dist" = "Binary Distribution") wird eine Binary Distribution im Wheel-Format gebaut. Anschließend die Ordner `build` (plattformabhängig) und `dist` (enthält die Wheel-Datei). Hängt man hintendran noch ein `upload` (z. B. `python setup.py bdist_wheel upload -r "my-pypi"`), dann wird das Wheel-Paket in das Python-Repository `my-pypi` hochgeladen (das in `~/.pypirc` mit Credential konfiguriert werden muß).

Eine Wheel-Datei kann auch beispielsweise per `twine` auf ein Artifact-Repository (PyPI, Nexus) hochgeladen werden.

Da `setup.py` tatsächlich Configuration-as-Python-Code ist kann man darin solche Dinge machen:

```python
from setuptools import setup, find_packages

with open("README.md", "r") as readme_file_handle:
  long_description = readme_file_handle.read()

setup(
  long_description=long_description,
  long_description_content_type="text/markdown",

  packages=find_packages(exclude=("test*", "testing*"))
)
```

Die "Konfiguration" ist also tatsächlich Code !!!

In dieser `setup.py` definiert man die Runtime-Dependencies (`install_requires=['jinja2','Click']`) und auch die Development Dependencies (z. B. um Tests auszuführen `extras_require={ "dev": ["pytest>=3.7"]}`). Verwendet man diese Form der `extras_require`, kann man die `dev`-Dependencies per `pip install .[dev]` mitinstallieren.

> alternativ könnte man auch eine `requirements.txt` Datei bereitstellen, um solche Development Dependencies zu definieren ... das würde aber das Dependency-Management auf unterschiediche Ansätze verteilen :-( BTW: `requirements.txt` macht Sinn, wenn man reine Developer-Tools hat, die nicht als Package, sondern nur als Source-Code bereitgestellt werden. Man kann eine `requirements.txt` aus den aktuell installierten Packages per `pip freeze > requirements.txt` generieren lassen.

Es existiert auch die Möglichkeit, die [Konfiguration in einem `setup.cfg` in einem ini-Format](https://setuptools.readthedocs.io/en/latest/userguide/declarative_config.html) durchzuführen. Allerdings gibt man hiermit natürlich die Vorteile des Codings (z. B. `find_packages(exclude=("test*", "testing*"))`) auf.

#### Binary Distributions - Egg Format

Per `python setup.py bdist_egg` ("B Dist" = "Binary Distribution") wird eine Binary Distribution im Egg-Format gebaut.

#### Source Distributions

Per `python setup.py sdist` ("S Dist") wird eine Source-Distribution als `tar.gz` gebaut.

Der Vorteil einer Source-Distribution besteht darin, daß man den Code lokal hat und und prüfen kann.

### twine - upload Packages

* [twine upload](https://youtu.be/GIF3LaRqgXo?t=1474)

```bash
pip install twine
twine upload dist/*
```

### distutils

Alternative zu `setuptools`

### PyPI

* [Video](https://www.youtube.com/watch?v=GIF3LaRqgXo)

### Eigenes Python Repository

* [Dokumentation](https://help.sonatype.com/repomanager3/formats/pypi-repositories)
* [StackOverflow](https://stackoverflow.com/questions/56592918/how-to-upload-the-python-packages-to-nexus-sonartype-private-repo)

Bei der Entwicklung von Non-Open-Source Software will man seine Software natürlich nicht für die ganze Welt bereitstellen, sondern evtl. nur innerhalb eines Unternehmens. Hierzu benötigt man ein Artifact-Repositiory (z. B. Nexus), das die Pakete beherbergt (als Ersatz für PyPI).

Hierzu bedarf es

* Artifact-Repository (z. B. Nexus)
  * kann auch als Cache fungieren, so daß `pip` auf dem Client nicht mehr PyPI direkt verwendet, sondern nur über das eigene Artifact-Repository ... kann die Downloadmenge reduzieren - außerdem stehen dann alle bereits runtergeladenen Pakete gecached zur Verfügung (Ausfallsicherheit)
* Konfiguration der lokalen Python-Konfiguration (`pip.conf`), um dieses Artifact-Repository zu berücksichtigen

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

