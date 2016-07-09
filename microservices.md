# Microservices
* Refcardz: https://dzone.com/refcardz/getting-started-with-microservices

Microservices ist ein Modularisierungsansatz - ein Modul/Komponente/Service wird selbständig deployed. Durch Kombination mehrerer Microservices entsteht eine Lösung (= Anwendung).

Es gibt ganz unterschiedliche Meinungen dazu wie groß ein Mikroservice sein sollten. Von wenigen Zeilen Code (Nanoservices mit 10 Zeilen) bis zu mehreren Tausend Zeilen. Ich persönlich stelle mir schon etwas größeres darunter vor.

---

# Chancen
* **unabhängiges Arbeiten** einzelner Teams
  * größere Verantwortung bei jedem einzelnen Entwickler und dadurch auch höhere Identifikation und Motivation
* **eigenständige Releasezyklen** für jeden Microservice
  * bei Monolithen müssen zum Releasezeitpunkt ALLE Teile einen zumindest akzeptablen Qualitätsstand haben ... das erhöht die Anforderungen an Planung. Teilweise müssen fast fertige Komponenten wieder zurückgebaut werden, weil sie eben nur FAST FERTIG sind. Continuous Delivery ist damit sehr schwierig. Letztlich führt es zu einem längeren Time-to-Market.
    * könnten Feature-Branches das Dilemma lösen?
* jeder Microservice kann einen **eigenen Technologiestack** wählen ... und wenn es nur unterschiedliche Versionen einer Library/Framework ist
  * weniger Abstimmung notwendig
  * es gibt dann nicht mehr DEN einen Architekten, sondern viele ... und das ist aus meiner Sicht eine sehr gute Idee, denn JEDER sollte ARCHITEKT sein
  * Nutzung neuer Technologien leichter möglich - es kann auch mal eine neue Technologie ausprobiert werden, die dann aber tatsächlich bis zur Produktionsreife (so daß man auch tatsächlich richtige Probleme lösen muß)
    * dadurch lebt die Architektur und die Software bleibt attraktiv für Entwickler (die nichts mehr hassen als immer wieder dasselbe zu machen)
* **gezielte horizontale und vertikale Skalierung** einzelner Lösungsbestandteile möglich
* **kleinere Deployments mit kürzeren Startzeiten** - hilft auch bei horizontaler Skalierung und zur Reduktion von Ausfallzeiten
* Mikoservices bieten einen Migrationspfad, um Features in gewachsenen/alten Monolithen durch Neuimplementierungen zu ersetzen.

## Freier Technologiestack ... wem hilfts?
Spielt die freie Wahl das Technologiestacks tatsächlich eine Rolle? Wird ein Unternehmen einen Zoo von Technologien zulassen?

Bei großen Unternehmen kommt es evtl. wirklich vor, daß ganz unterschiedliche Programmiersprachen und Frameworks eingesetzt werden. Insofern ist das für solche Unternehmen sicherlich ein Gewinn.

Spielt das für kleine Unternehmen eine Rolle? Solche Unternehmen werden vermutlich gar nicht eine solche Breite an Technologien abdecken (können/wollen). Für solche Firmen liegt der Mehrwert in der Flexibilität und der Attraktivität als Arbeitgeber.

---

# Herausforderungen
* in Microservice-Architekturen erhöht sich die Anzahl an Schnittstellen ... und Schnittstellen sind immer teuer/schwierig (Abstimmungsaufwand, Testen)
* geringerer Abstimmungsaufwand beim Bau der Lösung bedeutet auch geringer Anteil an Management - wieviele Manager werden dann noch benötigt?
* die gewonnenen Freiheiten bedeuten auch mehr Verantwortung
* Monitoring und Deployment vieler Komponenten
* Deployment der Gesamtlösung ist aufwendiger
* häufig ist das Team, das einen Microservice betreut/entwickelt, so klein, daß die Entwickler auch das Deployment und den Betrieb machen (inkl. Support) ... das muß man auch erst einmal wollen
* in verteilten Systemen existieren Probleme, die es in Monolithen nicht gibt. Ein paar Beispiele:
  * Fehler in der Netzwerkkommunikation
  * Latenz
  * Redundanz von Daten vs. Performance

---

# Interessante Technologien
... für die Umsetzung von Microservices:

* Docker
* Service Discovery (Consul, Heureka, ...)
* Spring Boot, Spring Cloud ...
* ELK (**E**lasticsearch + **L**ogstash + **K**ibana)
* Resilience (Hystrix, ...) 

---

