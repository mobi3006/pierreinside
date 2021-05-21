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

### Linux - switch to Python 3 default

Ich hatte ein realtiv altes Ubuntu-System, das noch Python 2 als default verwendete. Python 3 war schon installiert, doch ich wollte nicht immer `python3` eingeben müssen, um den "richtigen" Interpreter zu starten. Leider besteht Python nicht nur aus dem Interpreter, sondern auch aus dem Paketmanager `pip` und noch weiteren Tools (`pipenv`, ...), die dann alle zueinander passen müssen. Das kann ganz schön nerven.

Es gibt verschiedene Lösungen

* [siehe hier](https://linuxconfig.org/how-to-change-from-default-to-alternative-python-version-on-debian-linux)

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

Nichtsdestotrotz funktioniert das Navigieren in importierte Module (auch meine eigenen, die sich direkt im gleichen Git-Repository befinden) nicht. Hierzu finde ich diesen Beitrag:

* https://stackoverflow.com/questions/53939751/pylint-unresolved-import-error-in-visual-studio-code

---

## Sprache

Man sollte sich an die typischen Idiome/Patterns halten und auch den [Styleguide](https://google.github.io/styleguide/pyguide.html) berücksichtigen. Bestenfalls unterstützt die IDE hierbei und gibt Warnungen aus, wenn sie nicht eingehalten werden (Stickwort Linting).

### Besonderheiten

* Variables don’t have types in Python; values do. That means that it is acceptable in Python to have a variable name refer to an integer and later have the same variable name refer to a string.
* Python unterstützt viele Programmier-Paradigmen ... prozedural, objektorientiert, funktional. Für mich als Java-Entwickler war die Mischung am Anfang etwas befremdlich, d. h. man schreibt sein Hauptprogramm `main.py` und darin sind dann prozedurale Element (Initialisierung), aber auch schon gleich erste Klassen. Eine Mixtur aus Klassen und Initialisierung globaler Variablen. Geht sicher auch anders oder ist das ein gängiges Idiom? Vielleicht habe ich nur keinen Çlean-Code gesehen ...
* Python hat Built-In-Funktionen wie `type`, `len`, `input`, `range` ... diese können ohne `import` genutzt werden
* Datentypen wie `int`, `string`, Listen, Tupel haben eingebaute Funktionen, die man nutzen kann ... (`print("Pierre".count("r"))`
  * `"Pierre".split("e")`
* `"_".join(["P", "i", "e", "r", "r". "e"])`

### Variablen

Global-Namespace vs. Local-Namespace:

```python
def anyFunction(x):
  m = 8
  z = m + 6
  w = y + 1
  y = x * x + k
  return y

y = 5
k = 3
m = 1
```

In diesem Fall ist `y` im globalen Namespace definiert - innerhalb der Funktion `anyFunction` wird `y` allerdings als lokale Variable behandelt, weil sie eine Zuweisung (`y = x * x + k`) erhält. Im lokalen Kontext hat die Variable aber keinen Wert und es wird zu einem Fehler kommen.

Im Gegensatz dazu hat die globale Variable `k` in `anyFuntion` keine Zuweisung, sodaß innerhalb `anyFuntion` der globale Wert `k = 3` verwendet wird.

`m` hingegen ist sowohl im globalen Namensraum als auch im lokalen Namensraum von `anyFuntion`. Der lokale Namensraum hat höhere Priorität.

> Absurd ist in PYthon, daß man `global m` definieren könnte und dann würde innerhalb `anyFuntion` der Wert aus dem globalen Namensraum verwendet. Wer ist das denn für ein Quatsch???

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

### Sequences

Sequences sind die Datentypen

* String (immutable)
* List (mutable) ... mit eckigen Klammern definiert
  * ändern `names[1] = "Pierre"`n
  * einfügen `names[1:1] = ["Jonas", "Robin"]`
  * anhängen `names += ["Jonas", "Robin"]`
  * löschen
    * `names[1:3] = []`
    * `del names[1:3]`
  * Liste clonen by Slice-Operator: `namesClone = names[:]`
  * der Operator `+=` hat ein spezielles Handling bei (mutable) List: "obj = obj + object_two is different than obj += object_two ... The first version makes a new object entirely and reassigns to obj. The second version changes the original object so that the contents of object_two are added to the end of the first."
    * Empfehlung: den `+=` Operatior nicht bei Listen - oder besser - gar nicht verwenden
* Tuple (immutable) ... mit runden Klammern definiert
  * die runden Klammern können weggelassen werden ... die beiden folgenden Tupel sind semantisch gleich

      ```python
      tupelA = ( "Banane", "Apfel", "Pfirsich" )
      tupelB = "Banane", "Apfel", "Pfirsich"
      ```

Besonderheiten von Sequenzen

* bei immutable Datenstrukturen nimmt Python eine Speicheroptimierung vor und speichert den gleichen Wert nur ein einziges mal (Aliasing) - bei mutable Datentypen ist das nicht der Fall!!!
* `list = ["hello", 2.0, 5, [10, 20]]` ist in Sprache wie Java nicht erlaubt, weil die Werte unterschiedlichen Typs sind ... in Python ist das erlaubt wegen der Regel "Variablen haben keinen Typ - Werte haben einen Typ"
  * mit Listen funktionieren auch typische Operatoren wie `+` und `*`
    * `blist = alist * 2`
* `tupel = ("hello", 2.0, 5, [10,20])` ist ein Tupel ... sieht einer List `list = ["hello", 2.0, 5, [10,20]]` sehr ähnlich ist aber immutable
* Sequenzen unterstützen Slicing ... List-Slices sind Listen, Tupel-Slices sind Tupel, String-Slices sind Strings:
  * `name = Pierre; inBetween = name[1:len(name)-2]`
* `map`
* `set`: `myset={"Pierre", "Silke", "Jonas"}`
  * mit comprehensions: `a = {x for x in 'abracadabra' if x not in 'abc'}`
  * Operationen: `myset - { "Pierre" }` liefert `{"Silke", "Jonas"}`
* Tupel: `('n', 'no', 'nop', 'nope')`
  * Elemente müssen nicht vom gleichen Datentyp sein: `((12345, 54321, 'hello!'), (1, 2, 3, 4, 5))`
  * im Gegensatz zu `list` ist ein Tuppel immutable und hat i. a. unterschiedliche Datentypen - Tupel werden in anderen Use-Cases verwendet

### Sequence - String

Speicheroptimierung:

```python
fruitA = "Banane"
fruitB = "Banane"
print("expected True", fruitA is fruitB)
print("expected True", fruitA == fruitB)
```

* mit String kann man "rechnen"

    ```python
    def multiply(s, mult_int):
        return s * mult_int
    print(multiply("Hello", 3))      # HelloHelloHello
    ```

* immutable Functions:
  * `nameUpper = "Pierre".upper()`
  * `nameLower = "Pierre".lower()`
  * `stripped = "    Das ist ein Test      ".strip()`
    * `strip` entfernt auch Zeilenumbrüche
  * `replaced = "Das ist ein Test".replace("a", "b")`
  * `print("Hallo {}, ich bin {} Jahre alt und ich habe {} Euro in der Brieftasche".format("Pierre", 13))`
    * [String-Formatierungsvarianten]()
    * hier kann man den Wert noch formatieren (z B. `print("Hallo {}, ich bin {} Jahre alt und ich habe {:.2f} Euro in der Brieftasche".format("Pierre", 13, 100))`)
    * noch schöner ist, wenn man den Platzhaltern Namen geben kann
      * das vereinfacht Refactorings am String, weil die Reihenfolge der Variablenwerte keine Rolle spielt:
        * `print("Hallo {name}, ich bin {alter} Jahre alt und ich habe {betrag:.2f} Euro in der Brieftasche".format(name="Pierre", alter=13, betrag=100))`
      * wiederholte Strings müssen nicht als Werte wiederholt angegeben werden:
        * `print("Hallo {name}, ich bin {alter} Jahre alt und ich habe {betrag:.2f} Euro in der Brieftasche. Bis bald, {name}".format(name="Pierre", alter=13, betrag=100))`
    * mittlerweile hat sich der f-String durchgesetzt, der noch leichter lesbar ist
      * `print("Hallo {name}, ich bin {alter} Jahre alt und ich habe {betrag:.2f} Euro in der Brieftasche")`
### Sequence - List

mit mutating Functions:

* `list.append("banana")`
  * im Gegansatz zu `list = list + ["banana"]`, das zwischenzeitlich eine neue Liste erzeugt, dann die `list`aber auf die neue Liste zeigen läßt. Im Endergebnis gleich, aber technisch anders
* `list.count("banana")`
* `list.insert(1, "banana")`
* `list.index("banana")`
* `list.remove("banana")`
* `list.reverse()`
* `list.sort()`
  * mutating Method => funtioniert nicht auf Tupels
  * alternativ (und auch funktionaler, da immutable) kann man die Built-In-Funktion `sorted(list)` verwenden, die dann auch auf immutable Sequences funktioniert
* `list.sort(key=None, reverse=False)`
* `list.pop()`
  * auf diese Weise lassen sich mit `append` und `pop` Stacks implementieren
* `list.popleft()`
  * auf diese Weise lassen sich Queues mit `list.append()`/`list.popleft()` implementieren
    * nicht performant - besser `queue` aus dem `collections`-Paket verwenden

### Sequence - Tupel

Speicheroptimierung:

```python
fruitsA = [ "Banane", "Apfel", "Pfirsich" ]
fruitsB = [ "Banane", "Apfel", "Pfirsich" ]
print("expected False (compare identical object)", fruitsA is fruitsB)
print("expected True (compare content!!!)", fruitsA == fruitsB)
print("expected False", id(fruitsA) == id(fruitsB))
```

Mit Tupel-Assignment läßt sich das Tauschen von Variablenwerten sehr elegant beschreiben:

```python
a = 3
b = 5
print(a, b)
a, b = b, a
print(a, b)
```

Auf Tupeln kann man per `sorted` sortieren (Breaking Ties Eigenschaft):

```python
list = [(3, 5), (1,4), (1, 3)]
print(sorted(list)    # [(1, 3), (1, 4), (3, 5)]
```

Diese Eigenschaft kann man gut verwenden, um komlexe Sortierkriterien zu definieren:

```python
list = ["Anton", "Zorro", "Nathan", "12345", "Robin"]
print(sorted(list, key=lambda name: (len(name), name))    # ["12345", "Anton", "Robin", "Zorro", "Nathan"]
```

### Dictionary

* Dictionary (Key-Value-Maps) ... mit geschweiften Klammern:
  * `tel = {'jack': 4098, 'sape': 4139}`
  * `tel['pierre']=3006` => `{'jack': 4098, 'sape': 4139, 'pierre': 3006}`
* ungeordnet
* der Zugriff ist aber - wie bei den Squenzen - über eckige Klammern

```python
# Creation at initialization time
dictAlt = { "one":"eins", "two":"zwei", "three":"drei" }
print(dictAlt)

# Creation after creation
dict = {}
dict["one"] = "eins"
dict["two"] = "zwei"
dict["three"] = "drei"
dict["wasauchimmer"] = ["pierre", "feldbusch", 1972]
print(dict)

del dict["wasauchimmer"]

# dict.keys() erzeugt nur ein Iterable, aber keine list ... aber wird können es per cast transformieren
for key in dict.keys():
  print(key, ":", dict[key])

for value in dict.values():
  print(value)

# hier wird eine List erstellt und ist damit ein Iterator
for item in dict.items():
  print("key: ", item[0], "value", item[1])
# ... aber VIIIIEL eleganter <==== IDIOM
for k, v in dict.items():
  print("key: ", k, "value", v)

# dict implementiert einen Iterator ... wie list/tupel
for key in dict:
  print(key, ":", dict[key])

if "two" in dict:
  print("two ist drin")

# wenn man auf einen Key per Indexing zugreift, der nicht existiert, gibt es einen Fehler
# Wenn man also nicht genau weiß, ob der Key drin ist, dann sollte man es vorher
# prüfen (um den Runtime-Error zu vermeiden) oder die get-Methode verwenden
value = dict.get("Pierre")          # liefert None
if value is None:
  print("nicht gefunden")
else:
  print(value)
print(dict.get(value, "default"))   # liefert default
if value in dict:
  print(dict[two])

feldbusch = { "Pierre" : 48, "Pierre": 76 }
print(feldbusch["Pierre"])        # liefert 76

# dictionary sortieren nach values
dict = { "Pierre" : 48, "a": 76, "b": 14, "c": 100 }
for k in sorted(dict.keys(), key=lambda k: dict[k]):
  print(k, dict[k])
# ... oder noch kürzer ... das sieht doch schon fast wie eine DSL aus :-)
for k in sorted(dict, key=lambda k: dict[k]):
  print(k, dict[k])
```

### Exceptions

Exceptions dienen der Behandlung von Ausnahme-Situationen. Sie sollen verhindern, daß das Programm komplett abbricht und man stattdessen eine weitere Chance erhält (Stichwort Resilience).

Der Exception-Typ (im Beispiel `ZeroDivisionError`) ist optional ... läßt man ihn weg, wird jegliche Exception vom `except`-Block "gefangen".

```python
vornamen = [ "pierre", "hans", "patrick" ]
try:
    x = 5/0
    vorname = vornamen[3]
    myvar = doesNotExist
except ZeroDivisionError as e:
    print("got an ZeroDivisionError")
    print(e)
except IndexError as e:
    print("got an IndexError")
    print(e)
except:
    print("got any other error")
    print(e)
```

Man sollte Exceptions aber nicht mißbrauchen, um den Programmfluß für typische Use-Cases zu steuern:

```python
vornamen = [ "pierre", "hans", "patrick" ]
i = 0
while True:
  try:
      print(vornamen[i])
      i += 1
  except IndexError:
      break
```

Exceptions sind Klassen und haben eine Vererbungshierarchie. Ein `except ArithmeticError:` fängt alle von `ArithmeticError` abgeleiteten Exceptions, also `ZeroDivisionError`, `FloatingPointError` und `OverflowError`. Auf diese Weise kann man mit EINEM except-Statements gleich eine ganze Familie von Fehlern fangen.

Mit einem `KeyboardInterrupt`-Exception-Handler lassen sich beispielsweise Server-Prozesse sauber beenden:

```python
def createServer():
  serversocket = socket(AF_INET, DOCK_STREAM)
  try:
      serversocket.bind(("localhost", 5000))
      serversocket.listen(5)
      while True:
        (clientsocket, address) = serversocket.accept()
        receivedData = clientsocket.recv(5000).decode()

        # interpret received data
        # ...

        # prepare response
        data = "HTTP/1.1 200OK\r\n"
        data += "Content-Type: text/html; charset=utf-8\r\n"
        data += "\r\n"
        data += "<html><body>hello world</body></html>\r\n\r\n"

        # send response
        clientsocket.sendall(data.encode())
        clientsocker.shutdown(SHUT_WR)
  except KeyboardInterrupt:
    print("Server shutdown initiated")
  except Exception as e:
    print("error")
    print(e)
  
  serversocket.close()

createServer()
```

Exceptions kann man über

```python
raise Myexception()
```

auslösen.

### Funktionen

* in Python verwendet man für Funktionsnamen (und Variablennamen) Snake-Case (`get_value()`) anstatt Camel-Case (`getValue()`)
* Funktionen liefern IMMER genau EINEN Returnwert ... wenn nicht explizit mit `return bla`, dann ist der Returnwert immer `None` und kann dann beispielsweise per `if myFunc() == None:` abgefragt werden
  * ein Idiom in Python ist die Verwendung von Tupels als Rückgabewert - damit lassen sich sehr schön mehrere Rückgabewerte definieren und die Formulierung sieht dabei sehr elegant aus (ganz ähnlich wie in [Golang](go.md)):

    ```python
    def getSchwerpunkt(whatever):
      # Berechnung
      return x, y
    xAxis, yAxis= getSchwerpunkt(quadrat)
    ```

* Parameter können auch über Tupel übergeben werden ... allerdings mit einer sehr speziellen Star-Notation:

    ```python
    def setMittelpunkt(x, y):
        print("(x, y) = (", x, ",", y, ")")

    x = 3
    y = 5

    setMittelpunkt(x, y)

    mittelpunkt = x, y
    setMittelpunkt(mittelpunkt[0], mittelpunkt[1])

    setMittelpunkt(*mittelpunkt)
    ```

* Parameter können Default-Werte haben und sind dann optional ... aber ACHTUNG bei mutable Parameters (z. B. Lists), denn der Default-Wert bleibt erhalten!!!
  * mandatory Parameter müssen zuerst aufgeführt werden

    ```python
    def doit(value, list=[]):
      list.append(value)
      return list
    print(doit(1))              # [1]
    print(doit(2))              # [1, 2]
    print(doit(3))              # [1, 2, 3]
    print(doit(4), ["Pierre"])  # [Pierre, 4]
    ```

  * der Default-Wert wird zum Zeitpunkt der Funktionsdefinition festgelegt - nicht zum Zeitpunkt der Asuführung:

      ```python
      initial = 3
      def doit(value=initial):
        return value
      initial = 7
      print(doit())              # 3
      ```

    > man kann hier eine Menge Schindluder betreiben ... das sollte man vermeiden - CleanCode!!! man schreibt den Code für den Leser (Code wird 10x häufiger gelesen als geschrieben) ... irgendwelche Spitzfindigkeiten sollte man vermeiden

* Keyword-Parameter machen den Code sehr lesbar und sind in Kombination mit optionalen Parametern häufig absolut notwendig

    ```python
    def doit(x, y=2, z=3):
      return x * y + z
    print(doit(1))
    print(doit(1, z=5))         # ausgelassener Parameter "y" 
    print(doit(1, z=5, y=7))    # Reihenfolge y, z geändert
    print(doit(z=5, y=7, x=1))  # Reihenfolge x, y, z geändert
    ```

* Dokumentation einer Funktion sollte man mit einen sog. "docstring" machen, denn es gibt Tools, die daraus eine Dokumentation erzeugen

  ```python
  def hello():
    """Gibt "Hallo" aus"""
    print("Hallo")
  hello()
  ```

  * übrigens: die Dokumentation ist zur Laufzeit per `print(hello.__doc__)` lesbar
    * beachte: Funktionen sind ganz normale Objekte `print(type(hello))` liefert `<class 'function'>`
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

Als eingefleischter Nutzer typisierter Sprachen finde ich es relativ schwierig eine Funktion aus dem Kontext heraus zu verstehen, weil ich bei der Funktion

```python
def best_key(x):
  # irgendein komplexer code
```

gar nicht weiß, welchen Datentyp `x` repräsentiert. Der Code innerhalb der Funktion funktioniert aber nur basierend auf einem nicht sichtbaren Kontrakt. Ich muß also den Code der Funktion erstmal halbwegs verstehen, um dann daraus den erwarteten Input-Typ abzulesen.

Das finde ich sehr gewöhnungsbedürftig ... aber konsistent, wenn man berücksichtigt, daß Variablen keinen Typ haben, nur die Werte. Was ich aus dem Code häufig noch schwieriger rauslesen kann ist, ob es sich um eine Liste (mutable) oder ein Tupel (immutable) handelt. Das ist auch für den Entwickler schwierig, der die Methode `best_key` refactoren will und eigentlich nicht weiß, ob dort immer Listen oder manchmal auch Tupel reinwandern ... das bestimmt nämlich der Aufrufer??? 

> In Python 2 hat man das in die Dokumentation geschrieben. In Python 3 verwendet man hierfür Annotationen ... das wird allerdings von Python nicht ausgewertet, sondern komplett ignoriert:

    ```python
    def floatToInt(x: float) -> int:
      return int(x)
    ```

Durch die fehlende Typisierung kann eine Funktion sogar ganz unterschiedliche Datentypen zuürckliefern:

```python
def hello(name):
  if "Pierre" == name:
    return "Hallo Pierre"
  else:
    return 42
name = input("wie ist dein name")
print(type(hello(name)))
```

Sicherlich kein Best-Practice, aber prinzipiell möglich. Typisierter Sprachen würden das verhindern ... um so wichtiger die losen Best-Practices zu kennen und einzuhalten. ABER: es zeigt sich, daß man damit extremen Spaghetticode schreiben kann :-(

### Built-In-Funktionen

...  können ohne `import` genutzt werden

* `print`
* `type`
* `len(list)`
* `max(a, b)`
* `input`
  * `age=int(input("How old are you? "))`
* `range`
  * `l=range(3,6)   # l=(3,4,5)`
* `sorted`
  * `listB = sorted(listA)`
  * `listB = sorted(listA, reverse = True)` ... `reverse` ist ein optionaler Parameter
  * `listB = sorted(listA, key = absolute)` mit folgender `absolute`-Funktion (ACHTUNG: `absolute` ist ein Functionpointer!!!):

      ```python
      def absolute(x):
        if x >= 0:
          return x
        else:
          return -x
      ```

  * `listB = sorted(listA, key = lambda x: absolute(x))` mit einer Lambda-Function

* `enumerate` erhält eine Sequence als Parameter und liefert ein Iterable von `(index, value)` - IDIOM
  * statt

      ```python
      fruits = ['apple', 'pear', 'apricot', 'cherry', 'peach']
      for n in range(len(fruits)):
          print(n, fruits[n])
      ```

  * verwendet man

      ```python
      fruits = ['apple', 'pear', 'apricot', 'cherry', 'peach']
      for index, fruit in enumerate(fruits):
          print(index, fruit)
      ```

### Anonyme Funktionen - Lambda Functions

In meiner Zeit als C-Entwickler nannte man das Functionpointer. Viele Jahre später wurde daraus der Begriff Lambda-Function. Auf diese Art und Weise läßt sich ein Algorithmus als Parameter übergeben, um so das Strategy-Pattern zu implementieren und den Code sehr schön lesbar zu halten. Die Funktionsbeschreibung wird schlanker und erinnert an eine mathematische Funktionsdefinition im Stil von `f(x) = x * x` häufig auch per `x -> x * x` ausgedrückt.

Eine Funktion

```python
def func(args):
  return value
```

wird ganz schematisch (und deshalb können IDEs auch eine automatische Transformation anbieten) folgendermaßen in eine Lambda-Funktion transformiert:

```python
lambda args: value
```

Ein Beispiel:

```python
def square(n):
  return n * n
print(square(2))
```

wird zu

```python
sq = lambda n: n*n
print(sq(2))
```

In diesem Beispiel habe ich eigentlich nicht viel gewonnen, weil ich ja doch eine benannte (Lambda-) Funktion `sq` erstellt habe. Doch in folgendem Beispiel wird die Mächtigkeit deutlich ... ein Sortierkriterium wird über eine Lambda-Funktion definiert:

```python
pairs = [(1, 'one'), (2, 'two'), (3, 'three'), (4, 'four')]
pairs.sort(key=lambda pair: pair[1])
```

### Bibliotheken / Module

Die Stärke einer Sprache liegt häufig in den Bibliotheken, die man verwenden kann. In Python nennt man dies Bibliotheken Module - sie müssen lokal installiert werden (mit dem Python Package Manager `pip`) und dann im Code importiert werden. Für den Import gibt es zwei Varianten

* `import random`
  * in diesem Fall muß man Funktionen oder Klassen der Bibliothek mit dem Modulnamen vorangestellt referenzieren `diceValue = random.randrange(1, 7)`
* `from random import random, randrange`
  * in diesem Fall kann man auf den Modulnamen verzichten, was sich natürlicher anfühlen kann.`diceValue = randrange(1, 7)`

### Idiome

* Werte ignorieren mit `_` als Variablenname

    ```python
    track_medal_counts = {'long jump': 3, '100 meters': 2, '400 meters': 1}
    track_events = []
    for event, _ in track_medal_counts.items():
        track_events.append(event)
    ```

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

---

## Objektorientierung

### Klassen

```python
class Point():
  pass

point1 = Point()
point2 = Point()

point1.x = 5
```

### Instanzvariablen vs Klassenvariablen

Klassenvariablen sind instanzübergreifend und existieren nur ein einziges mal (entspricht `static` Properties in Java). Deshalb werden sie auch innerhalb der Klasse definiert.

> Das paßt konzeptionell zu dem Ansatz die Instanz an alle Methoden explizit zu übergeben. Für mich als Java-Entwickler zunächst mal eine Umstellung.

Instanzvariablen haben höhere Priorität ... bei `print(point1.x)` wird also zunächst mal nach einer Instanzvariablen `x` geschaut und wenn es keine gibt, dann wird nach einer Klassenvariablen geschaut.

Nichtsdestotrotz greift man auf eine Klassenvariable auch über die Instanz zu (`self.classVariable`). Man könnte auf die Klassenvariable aber auch per `Point.classVariable = 3` zugreifen.

```python
class Point():
  classVariable = 0
  def methodA(self):
    if self.classVariable == 0:
      return "null"

point1 = Point()
point1.instanceVariable = 5
```

> Eine Sache, die mir hier nicht gefällt ist, daß ich als Leser der Klasse `Point` nicht weiß, daß es ein Property `instanceVariable` hat ... das taucht irgendwann im Code auf - vielleicht sogar in einer anderen Datei. Zudem werden die Instanzvariablen erst zur Laufzeit angelegt ... nur, daß sie im Code erscheinen bedeutet nicht, daß sie auch existieren:

```python
class Point():
  def initialization(self):
    self.x = 0
    self.y = 0
  def __str__(self):
    return "({}, {})".format(x, y)

print(Point())
```

führt zu einem Laufzeitfehler `NameError: name 'x' is not defined`, da die Instanzvariable `x` (und auch `y`) zum Zeitpunkt der Ausführung der `__str__`-Methode noch gar nicht existiert. Erst durch expliziten Aufruf der Methode `initialization()` erfolgt die Anlage und danach funktioniert auch `__str__` fehlerfrei. Typischerweisse sollte man diese Initialisierung im Konstruktor `__init__(self)` machen.

> Um Spaghetti-Code zu vermeiden, sollte man im Konstruktore ALLE Instanzvariablen anlegen!!!

Jetzt wird es sehr technisch - aber es lohnt sich, darüber nachzudenken:

* Methoden werden in Python als Klassenvariablen behandelt

Das bedeutet, daß ein Aufuf von `point1.methodA()` folgendermaßen abgearbeitet wird:

* gibt es in der Instanz `point1` eine Instanzvariable `methodA` => NEIN
* gibt es in der Klasse `Point` eine Klassenvariable `methodA` => JA
* da nach `methodA` eine `()` folgt wird die Funktion `methodA()` mit `point1` als Parameter aufgerufen

Das Wissen hierüber ist für die tägliche Arbeit nicht entscheidend, gibt aber Einblicke wie das objektorierte Konzept in Python implementiert ist.

### Methoden

Die Funktionen in Klassen werden Methoden genannt. Alle Methoden haben als ersten Parameter IMMER das Objekt `self`, das die Instanz repräsentiert. Python verwendet also einen Delegationsansatz, um Klassen mit Instanzen zu verknüpfen.

> Da ich aus einer anderen Welt (Java, C++, Eiffel) komme, mutet das zunächst mal komisch an.

### Dunderscore-Methoden

* [guter Überblick](http://www.siafoo.net/article/57)

Die Lifecycle-Methoden (Konstruktor, String-Repräsentation, ...) sind in speziellen `__init__(self)` (den Parameternamen `self` zu verwenden ist ein Idiom - man kann jeden anderen verwenden ... macht aber niemand) Methoden verpackt ... können überschrieben werden, müssen aber nicht.

* `__init__(self, x, y)`
  * Konstruktor
* `__str__(self)`
* `__add__(self, other)`
  * `point1 + point2`
* `__sub__(self, other)`

### Vererbung

Die `__init__(self)` Methode kann, muß aber nicht in der erbenden Klasse überschrieben werden. Wenn keine definiert ist, wird die aus der Superklasse automatisch verwendet.

Beim erweitern des geerbten Konstruktors muß dieser explizit per `super()` aufgerufen werden:

```python
class SubClass(SuperClass):
  def __init__(self, name, size):
    super().__init__(name)
    self.size = size
```

---

## Fallstricke

### Best-Practices

Grundsätzlich erlauben solche Sprachen i. a. mehr als compilierte Sprachen ... es ist schwierig Best-Practices vor der Laufzeit zu prüfen. Hierzu bedarf es einer IDE, die das unterstützt und die Best-Practices überprüft. Deshalb werden

* Linter
* Auto-Formatter wie [yapf](https://github.com/google/yapf/)
* Styleguides wie der von [Google](https://google.github.io/styleguide/pyguide.html)

empfohlen.

### Testabdeckung

Zudem sollte man eine hohe Testabdeckung haben, denn ein wesentlicher Nachteil untypisierter Sprachen besteht darin, daß Typfehler häufig erst entdeckt werden können, wenn der Code auch ausgeführt wird. In folgendem Beispiel

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

### Python Virtual Environments

* [Getting Started](https://docs.python-guide.org/dev/virtualenvs/)
* [Tutorial](https://docs.python.org/3/tutorial/venv.html)

Bei diesem Ansatz werden Bibliotheken und Interpreter in einem applikationsspezifischen Verzeichnis installiert, so daß verschiedene Ausführungsumgebungen voneinander getrennt werden können. Auf diese Weise werden Konflikte vermieden und man kann sich nicht auf Bibliotheken stützen, die im Zusammenhang mit einem anderen Projekt installiert wurden ... das verbessert die Qualität in den projektspezifischen Dependencies (`requirements.txt` Datei).

Das Paket zum Management dieser virtuellen Umgebungen wird per `sudo apt install virtualenv` installiert. Per (z. B.) `virtualenv ~/ideWorkspaces/venv/jenkins-stats` wird ein virtuelles Environment im Ordner `~/ideWorkspaces/venv/jenkins-stats` angelegt. Anschließend befinden sich in diesem Verzeichnis einige Shell-Skripte. Um diese Umgebung zu aktivieren wird `source ~/ideWorkspaces/venv/jenkins-stats/bin/activate` ausgeführt. In meiner zsh-Shell ändert sich dadurch der Command-Prompt ... der Name der aktuell aktiven  virtuellen Umgebung ist erkennbar:

```
╭─pfh@workbench ~/src/com.github  
╰─➤  source ~/ideWorkspaces/venv/jenkins-stats/bin/activate
(jenkins-stats) ╭─pfh@workbench ~/src/com.github  
```

Anschließend sind die typischen Python Kommandos (`python`, `pip`, ...) auf die Skripte in der virtuellen Umgebung (`~/ideWorkspaces/venv/jenkins-stats/bin/python`) umgebogen. Die Installation von Libraries per `pip install Jinja2` oder `pip install -r requirements.txt` führen zur Installation der Pakete im virtuellen Environment (`~/ideWorkspaces/venv/jenkins-stats/lib`)

### FastAPI

* [siehe separate Seite](fastapi.md)

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

---

## Python Web-Development

### Django

[siehe eigenes Kapitel](django.md)

### Python Web Server Gateway Interface (WSGI)

* [Spezifikation - PEP 3333](https://www.python.org/dev/peps/pep-3333/)
* [konkretere Details](https://www.fullstackpython.com/wsgi-servers.html)

Dieses Interface ermöglicht die standardisierte Integration von Python-Backends in Webserver wie Apache-Http, NGINX, ... und trägt damit bei, daß sich das Python-Ecosystem (z. B. weitere Python-Web-Application-Frameworks) weiterentwickeln kann.

Die Spezifikation allein ist aber nur die Grundlage, auf der sich dann Implementierungen entwickelt haben:

* [gunicorn](https://gunicorn.org/)
* [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/)
* [mod_wsgi - Apache Modul](https://github.com/GrahamDumpleton/mod_wsgi)
* [cherrypy - Python Webserver acting as WSGI](https://github.com/cherrypy/cherrypy)

---

## Fazit

TL;DR ... ich mag Python und halte es auch für eine sehr gute Sprache zum Lernen von Softwareentwicklung.

### Mein Bedarf

Für meinen Bedarf ist es eine tolle Sprache, weil

* Scripting möglich ... ich muß nicht erst einen Compiler anwerfen, um einen Einzeiler zu programmieren
  * hierzu verwendet man i. a. funktionale oder prozedurale Programmierung
* komplexere Software läßt sich gut mit objektorientierten Konzepten umsetzen

Manche Dinge (z. B. der vorgesehene Variablentyp) wünsche ich mir in der Schnittstellenspezifikation. Aus meiner Sicht ist es keine gute Idee, den intendierten Parametertyp aus dem Funktionscode ableiten zu müssen. Insbesondere bei der Verwendung von Bibliotheken ist das unter Umständen nicht mal möglich. Auch hier helfen Best-Practices (Beschreibung des Parameter-Typs in der Doku).

### Lern-Sprache

Das schöne an Python ist die nahtlose Integration unterschiedlicher Programmier-Paradigmen (prozedural, funktional, objektorientiert). Dadurch entsteht eine schöne Varianz, so daß man auch leicht die verschiedenen Paradigmen vergleichen kann und ihre Vor- und Nachteile kennenlernt. Konzepte wie Lambda und Comprehensions helfen, sehr eleganten und leserlichen Code zu produzieren.

Insbesondere die gute [Raspberry Pi](raspberrypi.md) Unterstützung macht Python zu **DER** Lernsprache.

Ein Nachteil ist aus meiner sicht, daß durch den Interpreter-Ansatz Best-Practices schwieriger einzuhalten sind. Eine Variable kann an Zeile 23 einen String repräsentieren und an Zeile 24 einen Integer ... das wird einfach nicht verhindert. Während erfahrene Softwareentwickler das automatisch vermeiden, sind Anfänger vielleicht geneigt, solche "Abkürzungen" zu nehmen und Spaghetti-Code zu schreiben, der kaum lesebar und fehlerträchtig ist. Allerdings - wenn man es positiv sieht - lassen sich zumindest solche Ansätze direkt nebeneinanderstellen und die Vorteile schön rausarbeiten ... zum Lernen vielleicht sogar NOCH besser.

### Bibliotheken

Die Masse an Bibliotheken ist überwältigend.

> Das kann natürlich auch ein Problem sein ...
