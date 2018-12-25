# Uncle Bob

Diese Ikone der Softwareentwicklung heißt mit bürgerlichem Namen Robert C. Martin - JEDER sollte sich zumindest mal ein paar Videos über diesen interessanten, ulkigen und schrulligen Typen angesehen haben.

[The Future of Programming](https://www.youtube.com/watch?v=ecIWPzGEbFc)

## Bücher

* [Clean Code](https://www.amazon.de/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=sr_1_1?ie=UTF8&qid=1544696407&sr=8-1&keywords=clean+code)

## Clean Code

* "Company killed by (bad) Code"
* existierender Code wird als Vorlage für neuen Code angesehen - der Technical Depth wird propagiert ... durch mehr Entwickler noch schneller
  * niemand erkennt, welche Konzepte die richtigen sind
  * am besten wäre man hätte nur die richtigen Konzepte umgesetzt
  * Alternativ: Schulungen am eigenen Code
* Boys Scout Rule: hinterlasse Code immer ein bisschen besser als Du ihn vorgefunden hast

## Programmiersprachen

* Programmierparadigmen sind keine Erweiterungen, sondern Restriktionen. Beispiel:
  * in C kann man Polymorphie über Function Pointer abbilden - in Java hat man Polymorphie in der Sprache verankert ... aber nicht mehr die Freiheiten von Function Pointers zu verwenden. Und mit den funktionalen Erweiterungen (Lamda) verhält es sich ähnlich
  * wenn man nurn verschiedene Paradigmen in einer Sprache vereinen würde, was bliebe dann übrig?
* aspektiorientierte Programmierung fügt tatsächlich etwas hinzu statt etwas wegzunehmen ... wird aber nicht als eigenständiges Programmierparadigma angesehen
* die Programmiersprachen der heutigen Zeit, sind Implementierungen von Konzepten aus den 1950 - 1975. Gibt es keine neue Ideen mehr?
* eine gemeinsame Programmiersprache hätte viele Vorteile - wie man das in anderen Disziplinen (Naturwissenschaften - z. B. Algebra) schon erkannt und umgesetzt hat
* wie sollte die ideale Programmiersprache aussehen?
  * Garbage Collection
  * basierend auf einer virtuellen Maschine (Plattformunabhängigkeit)
  * Multicore Support (funktionales Aspekte)
  * Polymorphie
  * kein Goto (schwer zu verstehen)
  * textuell (nicht grafisch)
  * schnell
  * wenig Syntax
  * abstrakte symbolische Sprache ... nicht maschinennah
  * [homoiconic](https://en.wikipedia.org/wiki/Homoiconicity) ... Codemanipulationen während der Laufzeit (in Java: Bytecodemanipulation oder vielleicht auch das Reflection-Framework)
  * Closure vereint viele dieser Aspekte