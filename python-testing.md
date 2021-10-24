# Testen von Python Code

Das Testen hat bei untypisiertem Sprachen wie Python einen noch höheren Stellenwert, da viele Fehler nicht vom Compiler entdeckt werden können, sondern erst zur Laufzeit auftreten.

In folgendem Beispiel

```python
name = input("Wie ist dein name?")
if name == "Pierre":
    name_int=int(name)
print(name)
```

tritt der Fehler `int(name)` erst in Erscheinung, wenn ich den Namen `Pierre` eingebe. Um dieses Problem zu lösen benötigt man viele Tests ... oder einen intelligenten Editor, der Python-Wissen hat und diese Probleme erkennen kann.

Der intelligente Editor hilft allerdings nur, wenn man konsequent Type Hints verwendet. Das ist ABOSULUT empfohlen ... nur nicht um Fehler zu vermeiden, sondern auch um den Komfort zu erhöhen, wenn man Code schreibt.

---

## Einführung

* [Einführung von Realpython](https://realpython.com/python-testing/)

Prinzipiell kann man die `__main__.py` eines Pakets verwenden (oder jedes beliebige Python-Modul), um Test-Code auszuführen. Hierin könnte man dann

```python
if __name__ == "__main__":
    # testcode
    test_my_func1()
    test_my_func2()
```

verwenden, um die Tests auszuführen.

Allerdings sollen Tests i. a. nicht bei dem ersten Fehler zu einem Abbruch führen, sondern alle Tests ausführen und ganz am Ende eine Statistik zeigen ... mit einem entsprechenden Fehlerreport.

Hier kommen Testrunner ins Spiel, die in einem Test-Framework/Library enthalten sind:

* unittest
* nose2
* pytest

---

## unittest

Bei diesem Test-Framework muß man die Tests in Klassen schreiben, die von `unittest.TestCase` erben. Dadurch erhält man aber auch den Komfort von `setUp()` und `tearDown()` Methoden.

### Ausführung

```bash
python -m unittest discover
```

---

## pytest

* [Einführung - Realpython](https://realpython.com/pytest-python-testing/)

> Die `pytest` Tools führen auch `unittest`-Library-Tests aus.

Im Gegensatz zu `unittest` müssen die Tests nicht in eine Klasse gepackt werden ... es genügt:, sondern nur als Funktion

```python
def test_always_passes():
    assert True
```

### Installation

```bash
pip install pytest
```

### Entwicklung

* Parametrisierung ist ein nettes Feature, um Test-Code zu reduzieren ([von hier](https://realpython.com/pytest-python-testing/))

```python
@pytest.mark.parametrize("maybe_palindrome, expected_result", [
    ("", True),
    ("a", True),
    ("Bob", True),
    ("Never odd or even", True),
    ("Do geese see God?", True),
    ("abc", False),
    ("abab", False),
])
def test_is_palindrome(maybe_palindrome, expected_result):
    assert is_palindrome(maybe_palindrome) == expected_result
```

### Ausführung

```bash
pytest
```

Auf diese Weise werden alle Tests unterhalb des aktuellen Verzeichnisses ausgeführt.

Folgende Filtermöglichkeiten stehen zudem zur Verfügung:

* Name-Based-Filtering mit `-k`-Parameter
* Test-Categories mit `-m`-Parameter

### Fixtures

wiederverwendbarer Initialisierungscode ... ein Test erhält die Fixture als Parameter.

```python
import pytest

@pytest.fixture
def people_data():
    return [
        {
            "given_name": "Pierre",
            "family_name": "Feldbusch",
            "title": "Senior Software Engineer",
        },
        {
            "given_name": "Robin",
            "family_name": "Feldbusch",
            "title": "Project Manager",
        },
    ]

def test_format_data_for_display(people_data):
    assert format_data_for_display(example_people_data) == [
        "Pierre Feldbusch: Senior Software Engineer",
        "Robin Feldbusch: Project Manager",
    ]

def test_format_data_for_excel(people_data):
    assert format_data_for_excel(example_people_data) == """given,family,title
        "Pierre Feldbusch: Senior Software Engineer",
        "Robin Feldbusch: Project Manager",
"""
```

Man kann Fixtures in eine Datei mit dem Namen `conftest.py` auslagern und die stehen allen Tests im gleichen Verzeichnis oder darunter zur Verfügung.

### Plugins

`pytest` läßt sich über Plugins erweitern ... beispielsweise um Helper für bestimmte Frameworks (z. B. Django)

---

## tox.ini

* [verschiedene Python versionen testen](https://tox.readthedocs.io/en/latest/)

Auf diese Weise kann man testen, ob sich ein Package auf verschiedenen Python-Versionen installieren läßt - zudem laufen die Tests auch alle auf den definierten Python-Versionen.

sehr zu empfehlen ... hab ich gelesen ...
