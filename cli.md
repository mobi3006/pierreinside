# Command Line Interface

Im Power-User-Bereich waren grafische UIs noch nie sehr beliebt. Automatisierung ist auf GUIs einfach nicht möglich.

## Shellscripting

[Shellscripts](shellprogramming.md) sind sehr beliebt für die Automatsierung von Aufgaben. Allerdings sind die verwendeten GNU-Tools und nicht mal die Shells plattformunabhängig. Allzu häufig landet man in der Wartungshölle und muß die Skripte an die Platform anpassen.

> Für Server-CLI ist das vielleicht kein Problem, wenn man aber Tooling für Entwickler auf vielen verschiedenen Plattformen (Windows, Linux, MacOS) bereitstellen will, dann nervts und kostet unnötig Geld.

## Open CLI Framework

* [Homepage](https://oclif.io/)

Auf diesem Node-basierten Framework basieren beispielsweise Heroku-CLI und Salesforce-CLI. Programmiert wird in JavaScript oder TypeScript.

## Python

* [MUST-HAVE-read](https://www.davidfischer.name/2017/01/python-command-line-apps/)
* [Vergleich verschiedener Python CLI-Lösungsansätze](https://codeburst.io/building-beautiful-command-line-interfaces-with-python-26c7e1bb54df)
* [Vergleich](https://realpython.com/comparing-python-command-line-parsing-libraries-argparse-docopt-click/)

### PyInquirer

* [Source Code](https://github.com/CITGuru/PyInquirer)

### Clint

* [Source Code](https://pypi.org/project/clint/)

### Cliff

* [Source Code](https://docs.openstack.org/cliff/latest/)

### Click

* [Homepage](https://click.palletsprojects.com/en/7.x/)
* [Video](https://www.youtube.com/watch?v=kNke39OZ2k0)
* [Video](https://pyvideo.org/europython-2014/writing-awesome-command-line-programs-in-python.html)
* [API](https://click.palletsprojects.com/en/7.x/api/)

**Setuptool:**

* [Dokumentation](https://click.palletsprojects.com/en/7.x/setuptools)

Ein Setup-Tool verhindert, daß man die CLI über Bash-Skripte installieren muß, die in den Umgebungen ganz unterschiedlich funktionieren. Deshalb empfiehlt Click die Nutzung eines `setup.py`-Scripts, in dem auch die Abhängigkeiten definiert werden. Anschließend kann man die CLI (z. B. `mycli`) komfortabel über

```bash
virtualenv venv
source venv/bin/activate
pip install --editable 
```

installieren und dann wie ein Binary von überall nutzen (z. B. `mycli --help`).

**Bash-Completion:**

* [Dokumentation](https://click.palletsprojects.com/en/8.0.x/shell-completion/)

Eine installierte/aufrufbare CLI (z. B. `sb` ... aufgerufen über `sb --help`) liefert durch eine gesetzte Umgebungsvariable (im Beispiel `_SB_COMPLETE=zsh_source sb`) das Script, das erforderlich ist, um Auto-Completion in der Shell zu ermöglichen (die Skripte sind Shell-abhängig). Mit folgendem Snippet, das man beispielsweise in `~/.zshrc` packt, ist das dann erledigt (für eine ZSH-Shell):

```bash
eval "$(_SB_COMPLETE=zsh_source sb)"
```

Anschließend steht Auto-Completion zur Verfügung.

> Zur Optimierung (die Generierung des Skripts kostet Zeit) kann man allerdings auch die shell-spezifischen Skripte erzeugen und zur Ausführung zur Verfügung stellen (unter Versionskontrolle beispielsweise).

### Typer

* [Homepage](https://github.com/tiangolo/typer)

* basiert auf Click ... die Verwandschaft kann man deutlich erkennen
