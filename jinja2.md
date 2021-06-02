# Jinja 2 - Template Engine

* [Dokumentation](https://jinja.palletsprojects.com/en/master/)

Templates lassen sich für viele Zwecke einsetzen:

* Konfigurationsdateien erzeugen
* HTML-Dateien erzeugen

Letztlich ermöglicht es die Ersetzung von Platzhaltern in einer Datei. Allerdings sind hier nicht nur dumme Ersetzungen der Art `Hallo {{name}}` möglich, sondern auch

* `if ... else ...`
* `for`

In [diesem Artikel](http://www.patricksoftwareblog.com/templates-and-bootstrap/) ist das sehr schön beschrieben.

---

## Kategorien

* `{% … %}`: Statements wie for-loops, if/else, Python-Funktionsaufrufe
* `{{ … }}`: einfache Ersetzungen von Daten (aus dem Datenmodell)
* `{# … #}`: Kommentare ... erscheinen nicht im gerenderten Code

---

## HTML-Seitengenerierung

Statische HTML-Seiten werden durch Generierung wartbar. Auf diese Weise werden die statischen Anteile in das Template geschrieben und die dynamischen Teile (z. B. Informationen aus einer Datenbank) werden elegant über Jinja2-Syntax hinzugefügt.

Packt man noch ein bisschen Zucker in Form von [Twitter-Bootstrap](bootstrap.md) hinzu, kommt man innerhalb kürzester Zeit zu einem professionellen Look-and-Feel

---

## Jinja 2 mit Python

* [viele Beispiele](https://realpython.com/primer-on-jinja-templating/)

Insbesondere als DevOps Engineer gehören Python und Jinja zur Grundausstattung. Die Möglichkeiten von Shell-Scripting sind dann doch recht schnell erschöpft ... es fehlt einfach an so vielen Dingen (Exception Handling, Content-Handling, Debugging, Datenstrukturen).

```python
from jinja2 import Template

template = Template("Hello {{ something }}!")
print(template.render(something="World"))
```

Bei größeren Templates möchte man natürlich nicht jede einzelne Variable übergeben müssen. In solchen Fällen verwendet man ein Dictionary:

```python
def render_template(template_file: Union[str, Template], variables: Dict[str, str]) -> str:
    env = Environment(loader=FileSystemLoader(''))
    template = env.get_template(template_file)
    return template.render(input=variables)
```
