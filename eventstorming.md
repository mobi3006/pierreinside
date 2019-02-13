# Eventstorming

- [Buch von Alberto Brandolini "Introducing Event Storming (2018 noch nicht fertiggestellt)"](https://leanpub.com/introducing_eventstorming)
  - [Alberto Brandolini - 50.000 Orange Stickies Later](https://www.youtube.com/watch?v=1i6QYvYhlYQ)
  - [Introducing Event Storming - 2013 von Alberto Brandolini](http://ziobrando.blogspot.com/2013/11/introducing-event-storming.html)
- [infoq - Experiences Using Event Storming](https://www.infoq.com/news/2016/06/event-storming-ddd)

Ich habe einen Bericht im [Java Magazin](https://jaxenter.de/java-magazin-12-18-event-storming-editorial-76840) und ein [YouTube Video](https://www.youtube.com/watch?v=Xh6Ts19M6rg) gesehen und fand die Idee ganz interessant. An einem Happy Friday habe ich mir das mal genauer angeschaut.

---

## Geschichte

- 2013 zum ersten mal unter diesem Namen aufgetaucht
- kommt aus der Domain-Driven-Design Ecke

---

## Konzept

"It is not the things that matter in early stages of design ... it is the things that happen" ([Russ Miles](http://www.russmiles.com/essais/archives/11-2016))

Ziel des Event-Stormings ist die interaktive Schaffung eines gemeinsamen Lösungs-/Problemverständnisses. Man beginnt mit einer weißen Wand und Domain-Events, die in eine zeitliche Abfolge gebracht werden müssen und mit Reaktionen angereichert werden. Am Ende hat man Konsens an einigen Punkten erreicht, wichtiges von unwichtigen unterschieden, Dissens gekennzeichnet ... eine gute Grundlage für die Kollaboration im weiteren Verlauf, um **gemeinsam ein Outcome zu realisieren**. Der Ansatz zwingt zwingt zur (kontroversen) Diskussion und Kollaboration in einer sehr frühen Phase des Projekts. Man identifiziert eine unterschiedliche Erwartungshaltung, entdeckt unterschiedliches Verständnis und Sprache. Schafft man es trotz chaotischen Vorgehens die Diskussion kreativ, offensiv und zielorientiert zu einem weitestgehenden Konsens zu bringen, dann hat man einen sehr guten Grundstein gelegt und im besten Fall die Unternehmenskultur psoitiv weiterentwickelt. Ausgehend von dieser Athmosphäre werden Stakeholder auch in Zukunft nicht mehr übereinander und aneinander vorbei sprechen, sondern miteinander. So werden Probleme auch im weiteren Verlauf frühzeitig adressiert und gemeinsam gelöst.

Die Formulierung von Anforderungen ist **nicht** Ziel eines Event-Stormings. Stattdessen will man (gruppenübergreifend - Fachexperten, Architekten, Programmierer, Tester, Operations) Diskussionen führen, Silos werden aufgelöst, gemeinsames Lernen durch Diskussion. Am Ende steht ein besseres und gemeinsames Verständnis der Domäne. Das hilft bei der Adressierung (Formulierung, Priorisierung) von Problemen und dem Lösungsentwurf. Erst daraus ergeben sich dann die Anfoderungen.

Obwohl es sich um einen Ansatz aus dem Domain-Drive-Design handelt geht es hier im wesentlichen um die Prozesse und nicht um das darunterliegende Domänenmodell. Die Ereignisse (aka _Domain Events_) sind reale und nicht abstrakt - dadurch bleibt man fokussiert auf die Beschreibung realer Prozesse und ihrer Probleme. Das Domänenmodell kommt erst viel später und ist schon recht implementierungsnah (einige abstrakte Entities sind evtl. vorhanden, die bereits für einen bestimmten Lösungsansatz entworfen wurden). Fokussiert man sich hingegen sofort auf die Modellierung des Domain-Modells, dann kann es leicht passieren, over-engineering zu betreiben, weil man Dinge in das Modell einmodelliert, die für die Lösung nicht relevant sind.

Für diesen Ansatz braucht man nur Post-Its und viel Platz (Wand, Tisch, Boden). Ausgehend von Ereignissen identifiziert man die Auslöser der Ereignisse (Commands - User, externes System, Zeit) kommt man zur Diskussion über die Reaktion auf dieses Ereignis. Auf diese Weise schafft man interaktiv ein dokumentiertes gemeinsames Verständnis, ohne sich in Technologie-Diskussionen zu verstricken. Die Domänenmodelierung entsteht praktisch von selbst.

Das Konzept Post-Its statt digitale Modellierungstools zu verwenden ist charmant, wenn man in der Gruppe modellieren will. Jeder kann sich beteiligen ... es gibt nicht DEN EINEN, der das Tool bedient. Stattdessen wird evtl. an ganz unterschiedlichen Events gleichzeitig gearbeitet, die Ergebnisse sind für jeden jederzeit vollständig sichtbar. Außerdem ist man in seiner Modellierungssprache in keinster Weise eingeschränkt ... es ist kein UML und kein BPMN und kein xyz, stattdessen entwickelt sich die Sprache gemeinsam weiter. BEDENKE: an der Diskussion sind häufig verschiedene Fachrichtungen beteiligt ... niemand soll durch die Festlegung auf eine bestimmte Notation ausgegrenzt werden - der Weg ist das Ziel. Die Verwendung einer weißen Fläche ermöglicht viele weitere einfache Modellierungsansätze:

- Post-Its mit verschiedenen Farben und Formen
- Linien um die Post-Its in verschiedenen Farben
  - beispielsweise, um Bounded Contexts oder Komponenten/Services zu visualisieren
- ausgedruckte Icons, Bilder und Schriftzüge
- Anordnung vollkommen frei - Umordnung jederzeit mit ein wenig Aufwand möglich
  - Events sind meistens zeitlich gegliedert ... von links nach rechts

Formalismen von Tools (UML-Editoren zwingen zu korrekter Notation), Einschränkungen und Bedienungsprobleme dieser Tools stehen nicht im Weg. Selbst wenn das Tool von ein paar Teilnehmern exzellent beherrscht wird, dann sind die anderen außen vor.

Man kann es auf verschiedenen Levels durchführen

- Big-Picture Event-Stormings
- Design Event-Storming

### Sprache

In der Farbgebung, Formen und Semantik der Zettel ist man vollkommen frei ... einige Standards haben sich aber schon etabliert. Die Sprache wird während der Diskussion weiterentwickelt. Findet man ein Konzept, das man mit den bisherigen Mitteln nicht ausdrücken kann, dann wird ein neues Spracheelement definiert und in einer Legende festgehalten. Typischerweise sieht das dann so aus:

- Domain Events: oranger Post-It
  - in Vergangenheitsform formuliert (z. B. "Taxi verpasst")
- Command: blauer Post-It
- Read Model: grünes Post-It
  - hiermit sind Benutzereingaben gemeint
- Attention/Hot-Spot (Risiko, Problem, Dissens): roter Post-It
- Externes System: pink Post-It

---

## Durchführung

### Events

In einer Stillen Anfangsphase schreiben die Beteiligten Domain Events auf die organgenen Zettel und kleben sie an die Wand - chronologisch (schon hier wird es zu einer Diskussion kommen). Dabei wird man im Zuge von Diskussionen die Events umgestalten

- Doubletten entdecken
- konkretisieren
- umformulieren
- voneinander abgrenzen
- neue Events entdecken

### Tips

- "Focus on Behaviour, Not Data"
- "Postpone Naming"

---

## Bewertung

### Vor der tatsächlichen Nutzung

Ich glaube, daß die Fokussierung auf Events - im Gegensatz zur Fokussierung auf die Substantive (wie bei DDD häufig empfohlen) - dazu führt, daß die tatsächlichen Use-Cases der Domäne identifiziert und davon ausgehend ein sehr schlankes Domain-Modell entwirft. Geht man von den Substantiven aus, dann verleitet es dazu ein Modell zu entwerfen, das nicht zugeschnitten ist auf die Use-Cases, sondern zuviele Real-World-Eigenschaften aufweist, die in der Problem-Domäne gar nicht benötigt werden. Es entstehen also schlankere Modelle - weniger Komplexität.