# Java 8

* Beispielcode - Buch "Java 8 in Action": https://github.com/java8/Java8InAction

Java 8 ist ein großer Schritt in ein einfacheres Programmiermodell (Lambda-Ausdrücke, Function-Parameter) und performanteres Laufzeitmodell (Streams => Multicore Processing). Insofern ist der Druck sich weiterzuentwickeln nicht nur ausgelöst durch die Tendenz, daß Java unsexy outdated ist (aber auch vielleicht ein Henne-Ei-Problem).

Natürlich ist Mulithreading (Ausnutzung mehrerer CPU-Cores) auch schon mit Java 7 möglich, aber hierzu benötigt man auch viel Erfahrung. Zumal das Programmiermodell in vielen Umgebungen genau gegenläufig ist ... nur sehr wenige Entwickler werden tagtäglich mit Threads arbeiten.

Als rein objektorientierte Sprache geschaffen öffnet sich Java neuen Sprachkonzepten (hier: der funktionalen Programmierung) und bleibt damit attraktiv. Das riesige Java-Ökosystem verliert dadurch nicht weiter an Attraktivität.

## Funktionen als Parameter

Java als objektorientierte Programmiersprache kannte bisher nur Objekte als Übergabeparameter (mal abgesehen von skalaren Parametern we `int`). Aber ein Objekt hat immer einen Zustand und den kann dann eine aufgerufenen Methode verändern. Wenn man das unterbinden möchte und nur einen Algorithmus (= Funktion) übergeben möchte, dann konnte man maximal die Schnittstelle des übergebenen Objekts einschränken. Aber letztlich ist das nicht was man will (vom Rücken durch die Brust ins Auge).

Stattdessen will man gelegentlich nur die Berechnungsvorschrift oder maximal den lauffähigen Algorithmus übergeben, um beispielsweise das Sortierkriterium für die Sortierung zu definieren.

### Support in JDK-Klassen

In Klassen des Java-JDK werden Methodenparameter bereits unterstützt, so daß man ganz leicht

```java
File[] hiddenFiles = new File(".").listFiles(File::isHidden);
```

schreiben kann, um ein Array aller versteckten Dateien des aktuellen Verzeichnisses zu bekommen. Diese Art der Programmierung ist viel leichter zu lesen als ein Objekt eines Prädikats zu übergeben (viel unnützer Code dabei):

```java
File[] hiddenFiles = new File(".").listFiles(
    new FileFilter() {
        public boolean accept(File file) {
            return file.isHidden();
        }
    }
);
```

Eine Methode muß natürlich explizit für Funktionenparameter entwickelt werden - sie braucht Parameter mit einem funktionalen Interface.

Funktionale Interfaces zeichnen sich folgendermaßen aus:

* genau eine abstrakte (!!!) Methode (z. B. `java.util.function.Predicate`, `java.util.Comparator`) - denn genau diese (eindeutige) Methode wird mit dem Code des Lambda Ausdrucks implementiert
  * `default` Methoden dürfen beliebig viele enthalten sein

Man kann funktionale Interfaces mit `@FunctionalInterface` annotieren (recommended!!!), dann beschwert sich der Compiler, wenn das Interface nicht genau eine abstrakte Methode hat. Man kann zwar darauf verzichten, doch würde ich es IMMER tun, denn nachfolgende Refactorings könnten diese Semantik brechen (z. B. indem das Interface ein `extends OtherInterface` bekommt).

Folgende funktionale Interfaces wurden in Java 8 eingeführt:

* `java.util.function.Predicate`: T -> boolean
* `java.util.function.BiPredicate`: (S, T) -> boolean
* `java.util.function.Consumer`: T -> void
* `java.util.function.Function`: T -> S
* `java.util.function.Supplier`: () -> T
* ...

Für die Verwendung primitiver Datentypen (`int`, `float`) gibt es primitive Spezialisierungen der funktionalen Interfaces (`IntPredicate`, `FloatConsumer`) - diese sind hinsichtlich Ressourcennutzung/Performance optimiert, weil sie kein Autoboxing machen müssen.

## Anonyme Funktionen = Lamda Ausdrücke

Hat man benannte Funitonen wie `File.isHidden()` zur Hand ist das wunderbar. Doch wenn das nicht der Fall ist, weil es sich um eine sehr spezielle Funktion handelt, die man beispielsweise nicht unbedingt wiederverwenden kann/will, dann verwendet man anonyme Funktionen aka Lambda-Ausdrücke.

Statt der Bereitstellung von Funktionen wie `filterGreenApples` und `filterHeavyApples` (sie sind statisch => funktional) ...

### Beispiele

```java
(Apple a) -> a.getColor()
() -> 42
() -> {}
(String name) -> System.out.println(name)
(String name) -> { System.out.println(name); }
(String firstName, String lastName) -> { System.out.println(firstName + " " + lastName); }
(String firstName, String lastName) -> { return firstName + " " + lastName; }
(String firstName, String lastName) -> firstName + " " + lastName)
```

Die grundsätzliche Struktur besteht also aus

```java
(parameters) -> expression
```

oder

```java
(parameters) -> { statements }
```

Lambda-Ausdrücke können natürlich auch Exceptions werfen.

### Funtionsvariablen

Lambda-Ausdrücke können auch einer Variablen vom Typ eines funktionalen Interfaces zugewiesen werden:

```java
public void analyzeApples(List<Apple> apples) {
   Predicate<Apple> heavyWeight = (Apple a) -> a.getWeight() > 15;
   apples.stream().filter(heavyWeight);
}
```

so funktioniert das ja auch bei einem funktionalen Parameter

```java
analyzeApples(apples, (Apple a) -> a.getWeight() > 15);
public void analyzeApples(List<Apple> apples, Predicate<Apple> strategy) {
    // ...
}
```

## Beispiel

Statt der Implementierung sehr spezieller Methoden `filterGreenApples(list)`

```java
public static List<Apple> filterGreenApples(List<Apple> inventory){
    List<Apple> result = new ArrayList<>();
    for (Apple apple: inventory){
        if ("green".equals(apple.getColor())) {
            result.add(apple);
        }
    }
    return result;
}

```

können in Java 8 Funktionsparameter verwendet werden `filterApples(inventory, FilteringApples::isGreenApple)`

```java
public static boolean isGreenApple(Apple apple) {
    return "green".equals(apple.getColor());
}

public static List<Apple> filterApples(List<Apple> inventory, Predicate<Apple> p){
    List<Apple> result = new ArrayList<>();
    for(Apple apple : inventory){
        if(p.test(apple)){
            result.add(apple);
        }
    }
    return result;
}
```

oder noch einfacher Lambda-Ausdrücke `list.stream().filter((Apple a) -> a.isGreen())`.

Dadurch erspart man sich die Implementierung vieler sehr spezieller Filter-Algorithmen (deren Logik man auch erst bei Navigation zur Methode erkennt - oder an einem extrem länglichen Namen) und verwendet stattdessen eine sehr schön lesbare deklarative Beschreibung der Filterung. Zudem hat man beim herkömmlichen Ansatz ein DRY-Problem, denn die Schleife wird hier in jede Methode kopiert.

BTW: bei diesem Ansatz landet man unweigerlich in einer Kombinationshölle verschiedener kombinierbarer Filter-Algorithmen - die man zwar durch entsprechende Patterns (z. B. Decorator) reduzieren kann. Mit Funktionsparametern kann man das aber deutlich eleganter lösen.

Vor Java 7 hat man hier häufig ein Interface definiert und eine Instanz einer anonymen Klasse übergeben, doch das war recht verbose und Objekt mit einem Status braucht an der Stelle auch niemand.

Lambda Ausdrücke implementieren das Open-Close-Prinzip von Bertrand Meyer sehr gut umgesetzt. Es hat folgenden Charakter (Auszug aus diesem Link):

> "[...] you should design modules that never change. When requirements change, you extend the behavior of such modules by adding new code, not by changing old code that already works." ([Quelle](https://drive.google.com/file/d/0BwhCYaYDn8EgN2M5MTkwM2EtNWFkZC00ZTI3LWFjZTUtNTFhZGZiYmUzODc1/view))

Die Funktionsparameter ermöglichen es, eine Methode auf den seinen eigentlichen Kern zu reduzieren (= Filter) und die Ausprägung des Filterings komplett dem Nutzer der Methode zu überlassen, ohne daß diese spezielle Art des Filterings jemals vom Methodenentwickler vorgedacht wurde!!!

> BTW: letztlich werden Lamda-Ausdrücke bytecodetechnisch ähnlich abgebildet wie der das Java 7 Pendant mit anonymen Klassen. IDEs wie [IDEA](idea.md) erkennen die Strukturen eines mit Java 7 Sprachmitteln formulierten Lamda-Ausdrucks und können den Code automatisch transformieren. Letztlich sind Lambdas also eher Idiome als kreatives Codieren - für einen langjährigen Java-Entwickler handelt es sich anfangs vielleicht noch um eine Übersetzung von seiner alten Welt in die neue. Mit ein bisschen Übung schreibt man den Code gleich auf die neue Weise und wundert sich, wie man es jemals anders machen konnte ;-) 

## Streams

Streams verhalten sich wie die Java-Collection-API - allerdings auf Basis von Funtionsparametern/Lambdaausdrücken, die

* filter
* extract
* collect

Operationen ausführen. Zudem bietet es out-of-the-Box Paralellisierung (via `list.parallelStream()`) auf Multicore-Maschinen - ohne, daß man sich als Entwickler explizit mit Threads rumschlagen muß (deren Synchronisierung aufwendig und fehleranfällig für Gelegenheitsnutzer wäre) und unlesbarer/komplizierter (und damit fehleranfälliger) Code entsteht.

Über `list.stream()` bzw. `list.parallelStream()` gelangt man in die Parallelwelt zur Collections-API. Aus meiner Sicht ist das ein guter Kompromiss für die Einführung des neuen Ansatzes.

## Interface-Default-Methoden

Diese Option ermöglicht die nachträgliche Erweiterung eines Interfaces und macht somit die Software erst wirklich wartbar.

Ein Beispiel:

> Als Library-Anbieter möchte ich das Interface erweitern, ohne die Clients ändern zu müssen, weil die in der Welt verstreut sind und sich auch nicht an meine Release-Zyklen halten können.

Mit Default-Implementierungen ist es möglich, das Interface zu erweitern, ohne Compile-Fehler in den Clients zu erzeugen, die dieses Interface bereits in der alten Version implementieren.

> Durch dieses Feature ergibt sich inhärent eine multiple Inheritance Fähigkeit von Java 8 (eine Klasse kann meherere Interfaces implementieren ... aber ein Interface bringt nicht mehr nur eine abtrakte Schnittstellenbeschreibung mit, sondern auch Laufzeitcode)

Dieses Feature hat Java 8 aber auch selbst gebraucht, um die Stream-API in ihre Collection-API zu integrieren. Somit konnte `java.util.Collection.stream()` eingeführt werden (hat eine `default` Implementierung) ohne bestehenden Code zu ändern, der nun mit Java 8 statt Java 7 gebaut wird. Hier hat sich somit eine Win-Win-Situation ergeben.

## Fazit

Die Neuerungen in Java 8 gehen Hand-in-Hand und bieten die Vorteile, die die JDK Entwickler benötigten, auch dem Application-Developer an.

Zudem haben die JDK-Entwickler mit den parallelen Streams einen leichten Zugang zum Multicore-Processing gefunden.