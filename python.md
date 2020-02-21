# Python

Python unterstützt verschiedene Paradigmen (Strukturierte Programmierung gleichermaßen wie Objektorientierte Programmierung). Es handelt sich hier um eine interpretierte Sprache - somit entfällt das lästige Erstellen compilieren (man kann aber auch Just-In-Time-Compiler wie [PyPy](https://de.wikipedia.org/wiki/PyPy) verwenden) ... einfach Editor auf und coden - was man eben von einer Skriptsprache erwartet. Auf diese Weise kann man es auch sehr praktisch mit [Shellprogrammierung](shellprogramming.md) mixen oder die [Shellskripte vielleicht sogar ablösen](https://medium.com/capital-one-developers/bashing-the-bash-replacing-shell-scripts-with-python-d8d201bc0989).

---

## Getting started - Command Line

Install Python `sudo apt-get install python3-pip` and create a file `hello.py`

```python
msg = "Hello World, Pierre"
print(msg)
```

and execute the command `python hello.py` ... viola :-)

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

* Datenstrukturen:
  * `list` mit Funktionen - kann man auch als Stack mit `list.append()`/`list.pop()` verwenden oder Queues (nicht performant - besser `queue` aus dem `collections`-Paket verwenden) mit `list.append()`/`list.popleft()`:
    * `list.append(x)`
    * `list.insert(1, x)`
    * `list.index("banana")`
    * `list.remove(x)`
    * `list.sort(key=None, reverse=false)`
    * `list.reverse()`
    * ...
  * `map`
  * `set`: `myset={"Pierre", "Silke", "Jonas"}`
    * mit comprehensions: `a = {x for x in 'abracadabra' if x not in 'abc'}`
    * Operationen: `myset - { "Pierre" }` liefert `{"Silke", "Jonas"}`
  * Tupel: `('n', 'no', 'nop', 'nope')`
    * Elemente müssen nicht vom gleichen Datentyp sein: `((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))`
    * im Gegensatz zu `list` ist ein Tuppel immutable und hat i. a. unterschiedliche Datentypen - Tupel werden in anderen Use-Cases verwendet
  * Dictionary: `tel = {'jack': 4098, 'sape': 4139}`
    * `tel['pierre']=3006` => `{'jack': 4098, 'sape': 4139, 'pierre': 3006}`
* wichtige Funktionen:
  * `age=int(input("How old are you? "))`
  * `l=range(3,6)   # l=[3,4,5]`
  * Lambdafunktionen

    ```python
    >>> pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
    >>> pairs.sort(key=lambda pair: pair[1])
    >>> pairs
    [(4, 'four'), (1, 'one'), (3, 'three'), (2, 'two')]
    ```

* List Comprehensions: `squares = [x**2 for x in range(10)]`

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