# Groovy

Als Java-Entwickler der ersten Stunde (in der Uni 1996) sollte Groovy die Scripting-Sprache der ersten Wahl sein. Leider bin ich erst sehr spät mit Groovy in Kontakt gekommen ... im Zuge der Automatisierung von CI/CD mit [Jenkins](jenkins.md).

Erst nachdem ich mir Groovy näher angeschaut hatte, konnte ich die Jenkins-Pipelines wirklich verstehen und besseren Code schreiben.

---

## Links

* [Offizielle Dokumentation](https://groovy-lang.org/)

---

## Groovy als DSL-Sprache

Ein paar Sprachelement machen Groovy zu einer DSL-out-of-the-box:

* Klammern können beim Funktionsaufruf weggelassen werden
* Closures
  * Code-Injection
* untypisiert (Typisierung ist aber möglich)
* optionale Parameter mit Default-Values
* prozedurale/funktionale Programmierung
* GStrings
  * Platzhalterersetzung

Auf diese Weise kann regulärer Groovy-Code schon wie eine DSL aussehen. Die Grenze zwischen Implementierung und Konfiguration verschwimmt.

---

## Getting Started

Nach der Installation von [Sdkman](https://sdkman.io/install) kann ich Groovy per `sdk install groovy` komfortabel von der Command-Line installieren.

> Das schöne an SDKman ist das Wechseln der Version der unterstützen Sprachen. Unter Linux ist das ja nicht immer so einfach ...

---

## Entwicklungsumgebung

VisualStudioCode ist mein Schweizer Taschenmesser und deshalb will ich es auch für Groovy verwenden.

Nach der Installation des [Code Runner Plugins](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner) (Groovy muss vorab auf dem Betriebssystem installiert sein) lege ich eine Datei `pierre.groovy` mit folgendem Inhalt an:

```groovy
def myName(name = "Pierre") {
   println "Hello ${name}"
}

myName("Robin")
```

und erhalte nach "Run Code" die Ausgabe "Hello Robin" :-)
