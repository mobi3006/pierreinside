# Python

Python unterstützt verschiedene Paradigmen (Strukturierte Programmierung gleichermaßen wie Objektorientierte Programmierung). Es handelt sich hier um eine interpretierte Sprache - somit entfällt das lästige Erstellen compilieren (man kann aber auch Just-In-Time-Compiler wie [PyPy](https://de.wikipedia.org/wiki/PyPy) verwenden) ... einfach Editor auf und coden - was man eben von einer Skriptsprache erwartet. Auf diese Weise kann man es auch sehr praktisch mit [Shellprogrammierung](shellprogramming.md) mixen oder die [Shellskripte vielleicht sogar ablösen](https://medium.com/capital-one-developers/bashing-the-bash-replacing-shell-scripts-with-python-d8d201bc0989).

---

## Versionen

Python gibt es in verschiedenen Versionen. Version 2 und 3 sind zueinander inkompatibel. Dieser Code

```python
stadt = input("In welcher Stadt wohnst Du?")

if "berg" in stadt:
  print("Du wohnst am Berg :-)")
else:
  print("Du wohnst NICHT am Berg :-)")
```

läuft in Python 3 aber nicht in 2.

Glücklicherweise lassen sich beide Versionen parallel betreiben.

> Python 2 ist hat am 1.1.2020 sein End-of-Life erreicht.

---

## Getting started - Command Line

Install Python `sudo apt-get install python3-pip` and create a file `hello.py`

### Python Shell Mode

Dieser Modus wird per `python` gestartet ... es ist anschließend kein Editor notwendig, um Dateien zu editieren und zu speichern. Stattdessen wird der Code direkt in die Shell geschrieben und direkt ausgeführt. Das ist sehr praktischen, wenn man mal eben schnell eine Berechnung wie beispielsweise `print(2**10)` ausführen will. Streng genommen, kann man sich das `print` sparen und einfach `2**10` eingeben. Die Werte der Expressions werden in diesem Modus automatisch ausgegeben.

```python
>>> 2**10
1024
>>> print(2**10)
1024
>>> "Pierre"
'Pierre'
>>> vorname="Pierre"
>>> nachname="Feldbusch"
>>> vorname + " " + nachname
'Pierre Feldbusch'
```

### In File-Mode

In diesem Modus muß man dem Python-Interpreter eine Datei vorwerfen, die er dann interpretiert/ausführt:

```bash
echo "print(42)" > main.py
python main.py
```

wird dann die Zahl `42` ausgegeben :-)

---

## Getting started - Visual Studio Code

* prepare System - see above

Start Visual Studio Code and install the [Visual-Studio-Code Python extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python). Create a file `hello.py`:

```python
msg = "Hello World, Pierre"
print(msg)
```

and execute the command "Run Selection/Line in Python Terminal" :-)

---

## Sprache

* Variables don’t have types in Python; values do. That means that it is acceptable in Python to have a variable name refer to an integer and later have the same variable name refer to a string.
* Python hat Built-In wie `type`, `len`, `input`, `range` ... diese können ohne `import` genutzt werden
* Datentypen wie `int`, `string`, Listen, Tupel haben eingebaute funktionen, die man nutzen kann ... (`print("Pierre".count("r"))`
  * `"Pierre".split("e")`
  * `"".join(["P", "i", "e", "r", "r". "e"])`

### Einrückung

Einrückungen sind bei Python wichtig. Bei Kontrollstrukturen ist das gleich offensichtlich. Bei folgendem Code nicht sofort ... dieser Code ist syntaktisch falsch wegen der Einrückung:

```python
    fruit = "Banane"
    print(fruit)
```

So muß es aussehen:

```python
fruit = "Banane"
print(fruit)
```

### Standarddatentypen

* int
* float
* str
* bool (`True`, `False`)

Man kann den Type eines Wertes per "Casting" verändern `int5 = int("5")`.

### Funktionen

* Funktionen liefern IMMER einen Returnwert ... wenn nicht explizit mit `return bla`, dann ist der Returnwert immer `None`
* Funktionsparameter können Defaultwerte haben und sind dann optional: `def ask_ok(prompt, retries=4)`
* mit `*args` gibt es eine spezielle Variante von Übergabeparameter: Argumentliste

```python
def store(*args):
    ...

store("Pierre", "Silke")
```

* mit `*kvargs` gibt es eine spezielle Variante von Übergabeparameter: Dictionary

```python
def store(**kvargs):
    ...

store(name="Pierre", age=27)
```

### Sequences

Sequences sind die Datentypen

* String (immutable)
* List (mutable)
  * ändern `names[1] = "Pierre"`n
  * einfügen `names[1:1] = ["Jonas", "Robin"]`
  * anhängen `names += ["Jonas", "Robin"]`
  * löschen
    * `names[1:3] = []`
    * `del names[1:3]`
  * clone by Slice-Operator: `namesClone = names[:]`
  * der Operator `+=` hat ein spezielles Handling bei (mutable) List: "obj = obj + object_two is different than obj += object_two ... The first version makes a new object entirely and reassigns to obj. The second version changes the original object so that the contents of object_two are added to the end of the first."
    * Empfehlung: den `+=` Operatior nicht bei Listen - oder besser - gar nicht verwenden
* Tuple (immutable)

* bei immutable Datenstrukturen nimmt Python eine Speicheroptimierung vor und speichert den gleichen Wert nur ein einziges mal (Aliasing)

    ```python
    fruitA = "Banane"
    fruitB = "Banane"
    print("expected True", fruitA is fruitB)
    print("expected True", fruitA == fruitB)
    ```

  * bei muatble Datentypen ist das nicht der Fall!!!

    ```python
    fruitsA = [ "Banane", "Apfel", "Pfirsich" ]
    fruitsB = [ "Banane", "Apfel", "Pfirsich" ]
    print("expected False (compare identical object)", fruitsA is fruitsB)
    print("expected True (compare content!!!)", fruitsA == fruitsB)
    print("expected False", id(fruitsA) == id(fruitsB))
    ```

* `list = ["hello", 2.0, 5, [10, 20]]` ist in Sprache wie Java nicht erlaubt, weil die Werte unterschiedlichen Typs sind ... in Python ist das erlaubt wegen der Regel "Variablen haben keinen Typ - Werte haben einen Typ"
  * mit Listen funktionieren auch typische Operatoren wie `+` und `*`
    * `blist = alist * 2`
* `tupel = ("hello", 2.0, 5, [10,20])` ist ein Tupel ... sieht einer List sehr ähnlich ist aber immutable
* `list` mit mutating Functions:
  * `list.append("banana")`
    * im Gegansatz zu `list = list + ["banana"]`, das zwischenzeitlich eine neue Liste erzeugt, dann die `list`aber auf die neue Liste zeigen läßt. Im Endergebnis gleich, aber technisch anders
  * `list,count("banana")`
  * `list.insert(1, "banana")`
  * `list.index("banana")`
  * `list.remove("banana")`
  * `list.reverse()`
  * `list.sort()`
  * `list.sort(key=None, reverse=false)`
  * `list.pop()`
    * auf diese Weise lassen sich mit `append` und `pop` Stacks implementieren
  * `list.popleft()`
    * auf diese Weise lassen sich Queues mit `list.append()`/`list.popleft()` implementieren
      * nicht performant - besser `queue` aus dem `collections`-Paket verwenden
* `Strings` mit immutable Functions:
  * `nameUpper = "Pierre".upper()`
  * `nameLower = "Pierre".lower()`
  * `stripped = "    Das ist ein Test      ".strip()`
    * `strip` entfernt auch Zeilenumbrüche
  * `replaced = "Das ist ein Test".replace("a", "b")`
  * `print("Hallo {}, ich bin {} Jahre alt und ich habe {} Euro in der Brieftasche".format("Pierre", 13))`
    * hier kann man den Wert noch formatieren (z B. `print("Hallo {}, ich bin {} Jahre alt und ich habe {:.2f} Euro in der Brieftasche".format("Pierre", 13, 100))`)
* Sequenzen unterstützen Slicing ... List-Slices sind Listen, Tupel-Slices sind Tupel, String-Slices sind Strings:
  * `name = Pierre; inBetween = name[1:len(name)-2]`
* `map`
* `set`: `myset={"Pierre", "Silke", "Jonas"}`
  * mit comprehensions: `a = {x for x in 'abracadabra' if x not in 'abc'}`
  * Operationen: `myset - { "Pierre" }` liefert `{"Silke", "Jonas"}`
* Tupel: `('n', 'no', 'nop', 'nope')`
  * Elemente müssen nicht vom gleichen Datentyp sein: `((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))`
  * im Gegensatz zu `list` ist ein Tuppel immutable und hat i. a. unterschiedliche Datentypen - Tupel werden in anderen Use-Cases verwendet
* Dictionary: `tel = {'jack': 4098, 'sape': 4139}`
  * `tel['pierre']=3006` => `{'jack': 4098, 'sape': 4139, 'pierre': 3006}`

### Wichtige Funktionen

* `age=int(input("How old are you? "))`
* `l=range(3,6)   # l=[3,4,5]`
* Lambdafunktionen

  ```python
  >>> pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
  >>> pairs.sort(key=lambda pair: pair[1])
  >>> pairs
  [(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]
  ```

### Bibliotheken / Module

Die Stärke einer Sprache liegt häufig in den Bibliotheken, die man verwenden kann. In Python nennt man dies Bibliotheken Module - sie müssen lokal installiert werden (mit dem Python Package Manager `pip`) und dann im Code importiert werden. Für den Import gibt es zwei Varianten

* `import random`
  * in diesem Fall muß man Funktionen oder Klassen der Bibliothek mit dem Modulnamen vorangestellt referenzieren `diceValue = random.randrange(1, 7)`
* `from random import random, randrange`
  * in diesem Fall kann man auf den Modulnamen verzichten, was sich natürlicher anfühlen kann.`diceValue = randrange(1, 7)`

### Idiome

* List Comprehensions: `squares = [x**2 for x in range(10)]`

### String contains

Da ein String eine Sequence/List ist macht man das nicht per Functions-Call, sondern

```python
stadt = input("In welcher Stadt wohnst Du?")
if "berg" in stadt:
  print("Du wohnst am Berg :-)")
else:
  print("Du wohnst NICHT am Berg :-)")
```

### Loops

```python
for i in range(5):
    print(i)
```

ACHTUNG: in erwartet ein Iterable ... eine Sequenz ist ein Iterable. `range(5)` erzeugt eine List (einfach mal ausprobieren: `print(type(range(5)))`).

### Klassen

* man kann auch außerhalb der Klassendefinition weitere Attribute on-the-fly hinzufügen ... seltsam für einen Compiler-gewöhnten Java-Entwickler ;-)

### Files

```python
# open in readonly mode
fileref = open("../data/mydata.csv", "r")   # relativ zum Ausführungskontext (absolute Pfade funktionieren auch)
                                            # Absolute Pfade sind natürlich nicht portierbar

content = fileref.read()                    # fileref.read(n) liest n characters
print(contents[:100])
print(len(content))

lines = fileref.readlines()                 # fileref.readlines(2) liest x Zeilen ... oder eine: fileref.readline()
                                            #
                                            # ACHTUNG: diese Variante verwendet man aus Speichergründen besser nicht,
                                            #          denn hierbei wird die gesamte Datei in den Speicher geladen.
                                            #          Stattdessen verwendet man "fileref" als Iterator und liest
                                            #          zeilenweise.
print(len(lines))

print(lines[:4])
for line in lines:
  print(line)
for line in fileref:                        # das ist die typische Nutzung (IDIOM)
  print(line.strip())

fileref.close()
```

> `open()` ist eine Built-In-Function

Achtung: es handelt sich bei dem File-Handle (z. B. `fileref`) um einen Iterator, d. h. nach einem `content = fileref.readlines()` sorgt ein erneutes `content2 = fileref.readlines()` für eine leere Liste.

Da man beim Filehandling gerne mal das Schließen des Handles vergißt, besitzt Python folgendes Idiom:

```python
with open("../data/mydata.csv", "r") as fileref:
  for line in fileref:
    print(line.strip())
```

Das ist Kontextmanager um das Filehandling, der sich auch gleich um das Schließen kümmert :-)

### Fallstricke

Ein wesentlicher Nachteil untypisierter Sprachen besteht darin, daß Typfehler häufig erst entdeckt werden können, wenn der Code auch ausgeführt wird. In folgendem Beispiel

```python
name = input("Wie ist dein name?")
if name == "Pierre":
    name_int=int(name)
print(name)
```

tritt der Fehler `int(name)` erst in Erscheinung, wenn ich den Namen `Pierre` eingebe. Um dieses Problem zu lösen benötigt man viele Tests ... oder einen intelligenten Editor, der Python-Wissen hat und diese Probleme erkennen kann.

---

## Bibliotheken

### Konzept

Module, die Python nicht mitliefert müssen per `pip install MODULE_NAME` installiert werden. Für die Automatisierung dieses Prozesses ist es hilfreich, alle notwendigen Module in einer Datei (z. B. `requirements.txt`) zu sammeln (die i. a. unter Versionskontrolle steht) und dann per `pip3 install -r requirements.txt` auf einen Schlag zu installieren. Das vereinfacht die Nutzung einer (unbekannten) Anwendung ungemein.

> Noch besser finde ich allerdings die Ausführung von Python-Code in einem Docker-Container. Auf diese Weise wird die lokale (Entwicklungs-) Umgebung nicht mit Paketen verschmutzt. Das hilft auch beim Fail-Fast-Prinzip ... vergißt man eine notwendige Bibliothek in `requirements.txt` zu erwähnen, so fällt das in einem Docker-Container sofort auf ... bei der lokalen Nutzung wurde die Bibliothek evtl. einmalig installiert und niemandem ist bewußt, daß die Software in einer anderen Umgebung (bei meinem Kollegen) gar nicht funktioniert. In diesem Zusammenhang gibt es auch [Python Virtual Environments](https://docs.python.org/3/library/venv.html), bei denen die Bibliotheken und Interpreter in einem applikationsspezifischen Verzeichnis installiert werden. Ich würde dennoch die Docker-Container bevorzugen ... ein einmalig erstelltes Docker-Image als Ausführungsumgebung läßt sich einfach mit den Kollegen teilen und sieht WIRKLICH bei allen gleich aus!!!

### FastAPI

* [Homepage](https://fastapi.tiangolo.com/)

Das Framework basiert auf der [OpenAPI Spezifikation](https://github.com/OAI/OpenAPI-Specification). REST-Services werden per `@`- Annotation definiert. Zusätzlich bekommt man eine API-Dokumentation und Ausführungsumgebung als WebUI ([Swagger UI](https://github.com/swagger-api/swagger-ui)) geschenkt. Diese Dokumentation/Ausführungsumgebung ist - weil aus dem Source-Code generiert - immer aktuell.

---

## Python in Kombination mit Shell

### Python executes Shell-Commands

Mit [Fabric](http://www.fabfile.org/) steht eine sehr brauchbare Python Library zur Verfügung, um aus Python-Code (remote) Shell-Kommandos abzusetzen und die Ergebnisse in Python weiterzuverarbeiten.

Die Installation ist mit `pip` schnell erledigt

```bash
pip install fabric2
```

Danach kann man Programme wie `hello-fabric.py`

```python
from fabric2 import Connection
c = Connection('localhost')
result = c.run('uname -s')
print("result: " + result.stdout.strip())
```

per `python hello-fabric.py` ausführen.

In der [Dokumentation](http://docs.fabfile.org/en/2.5/) findet man erste Programmier-Beispiele.

## Kinder lernen programmieren

* [Buch: Programmieren mit Python - supereasy](https://www.amazon.de/Programmieren-mit-Python-supereasy/dp/3831034575/ref=pd_sim_4?_encoding=UTF8&pd_rd_i=3831034575&pd_rd_r=0671b0b2-b66b-11e8-b7b1-1f841b9564db&pd_rd_w=soYkA&pd_rd_wg=aTAco&pf_rd_i=desktop-dp-sims&pf_rd_m=A3JWKAKR8XB7XF&pf_rd_p=a1f1e800-ed31-44e7-8f29-5b327ba0187a&pf_rd_r=WCJX42PT49VD9KM4WVX6&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=WCJX42PT49VD9KM4WVX6)

---

## Jupyter Notebook

* [Einführungsvideo](https://www.youtube.com/watch?v=HW29067qVWk)
* [Jupyter Notebook Galeries - wie andere das nutzen - Visio](https://github.com/jupyter/jupyter/wiki/A-gallery-of-interesting-Jupyter-Notebooks)
  * [so könnte man das beispielsweise für eine Schulpräsentation nutzen](https://nbviewer.jupyter.org/github/ipython/ipython/blob/master/examples/IPython%20Kernel/Trapezoid%20Rule.ipynb)

Interessante Variante, um interaktive Dokumentationen mit Markdown, HTML-iFrames, Python Code, JavaScript, Bash, Ruby, Shell Kommandos zu erstellen.

Im Hintergrund wird ein Webserver gestartet - die Dokumentation ist eigentlich Code, der in einer JSON-Datei gespeichert werden. Diese kann man mit anderen teilen und unter Versionskontrolle stellen. Visual-Studio-Code unterstützt das auch ... da ist die Integration noch weniger sichtbar.

Das Dateiformat `ipynb` wir beispielsweise auch direkt von Github unterstützt, so daß die Datei unter Versionskontrolle gestellt, geteilt und komfortabel im Browser angezeigt werden kann.
