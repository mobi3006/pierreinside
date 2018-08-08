# Microservices

* [Refcardz](https://dzone.com/refcardz/getting-started-with-microservices)
* [Microservice Patterns](http://microservices.io/)

Microservices ist ein Modularisierungsansatz - ein Modul/Komponente/Service wird selbständig deployed. Durch Kombination mehrerer Microservices entsteht eine Lösung (= Anwendung).

Es gibt ganz unterschiedliche Meinungen dazu wie groß ein Mikroservice sein sollten. Von wenigen Zeilen Code (Nanoservices mit 10 Zeilen) bis zu mehreren Tausend Zeilen. Ich persönlich stelle mir schon etwas größeres darunter vor.

---

## Chancen

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

### Freier Technologiestack ... wem hilfts?

Spielt die freie Wahl das Technologiestacks tatsächlich eine Rolle? Wird ein Unternehmen einen Zoo von Technologien zulassen?

Bei großen Unternehmen kommt es evtl. wirklich vor, daß ganz unterschiedliche Programmiersprachen und Frameworks eingesetzt werden. Insofern ist das für solche Unternehmen sicherlich ein Gewinn.

Spielt das für kleine Unternehmen eine Rolle? Solche Unternehmen werden vermutlich gar nicht eine solche Breite an Technologien abdecken (können/wollen). Für solche Firmen liegt der Mehrwert in der Flexibilität und der Attraktivität als Arbeitgeber.

---

## Herausforderungen

### Mindset

* die gewonnenen Freiheiten bedeuten auch mehr Verantwortung  
* häufig ist das Team, das einen Microservice betreut/entwickelt, so klein, daß die Entwickler auch das Deployment und den Betrieb machen (inkl. Support) ... das muß man auch erst einmal wollen

### Komplexität

* in Microservice-Architekturen erhöht sich die Anzahl an Schnittstellen ... und Schnittstellen sind immer teuer/schwierig (Abstimmungsaufwand, Testen)
* Monitoring und Deployment vieler Komponenten
  * Logging
  * Healthchecks ... die evtl. auch in die Loadbalancer und die Anwendnung (Resilience) integriert sind
* Deployment der Gesamtlösung ist aufwendiger, weil nun nicht mehr nur EIN Deployment existiert, sondern VIELE 
* Debugging schwieriger
* Administration der Infrastruktur aufwendiger (viele Rechner beteiligt, Firewall, ...)

### Redundanz vs. Performance

* Latenz
* Redundanz von Daten vs. Performance
  * insbes. bei Benutzer-Identität und den daran hängenden Authorisierungen ... Ansätze wie OAuth, SAML und XACML könnten Lösungen sein
  * Caching wird ein zentraler Aspekt der Architektur

### Datenkonsistenz

* um den Durchsatz zu erhöhen (Skalierbarkeit ist ja häufig ein Grund für Microservices) wird man verteilte Transaktionen mit Two-Phase-Commit vermeiden wollen. Evtl. muß man sich von strikten Konsistenzgraden - wie wir sie aus relationalen Datenbanken kennen - verabschieden und pragmatischere Wege beschreiten (sofern möglich) 

### Fehlermöglichkeiten

* Fehler in der Netzwerkkommunikation

### Auf organisatorischer Ebene

* geringerer Abstimmungsaufwand beim Bau der Lösung bedeutet auch geringer Anteil an Management - wieviele Manager werden dann noch benötigt?

---

## Interessante Technologien

... für die Umsetzung von Microservices:

* Docker
* Service Discovery (Consul, Heureka, ...)
* Spring Boot, Spring Cloud ...
* ELK (**E**lasticsearch + **L**ogstash + **K**ibana)
* Resilience (Hystrix, ...)

---

## Best practices

* [Modern Java EE Design Patterns, Markus Eisele](http://developers.redhat.com/promotions/distributed-javaee-architecture/?tcUser=Coffee+Totakeaway&tcDownloadFileName=Modern_Java_EE_Design_Patterns_Red_Hat.pdf&tcRedirect=5000&tcSrcLink=https://www.jboss.org/download-manager/content/origin/files/sha256/a3/a3ff84543ab8a8e303c85c584c978e6d9f2183539f2afa2c564a7b30645bdae1/Modern_Java_EE_Design_Patterns_Red_Hat.pdf&p=Media:+Modern+Java+EE+Design+Patterns&pv=Modern+Java+EE+Design+Patterns&tcDownloadURL=https://access.cdn.redhat.com/content/origin/files/sha256/a3/a3ff84543ab8a8e303c85c584c978e6d9f2183539f2afa2c564a7b30645bdae1/Modern_Java_EE_Design_Patterns_Red_Hat.pdf?_auth_=1468574065_9d4fd90ef3d0d7d6050350bb6cb12896)
* [Microservice Antipatterns, Tammer Saleh](https://www.infoq.com/presentations/cloud-anti-patterns?utm_campaign=rightbar_v2&utm_source=infoq&utm_medium=presentations_link&utm_content=link_text)

Ein paar Stichworte:

* jeder Microservice hat
  * seinen eigenen Build (z. B. Jenkins/Travis Datei im Source-Code)
  * seine eigene Persistenz (lose Kopplung)
  * sein eigenes Team
  * seinen eigenen Technologiestack
    * klar, als unternehmen muß man auch darauf achten, daß man die Services staffen kann - deshalb wird man hier nicht komplett frei sein
  * sein eingenes Operations-Team (das sich um alles kümmert ... Technologieauswahl)
  * sein eigenes Tooling
    * hier können sich Synergien ergeben, wenn man den Technologiestack ähnlich hält
* stateless - nur so erreicht man elastische Lösungen, die skalieren können
* Data-caching in jedem Microservice als zentrales Architekturelement. Würde man immer alle Daten aus den Origin-Data-Sources ziehen, dann wäre die Anwendnung zu langsam.
  * update-Strategy notwendig

### API-Gateway

* [microservices.io](http://microservices.io/patterns/apigateway.html)

Für jeden Client-Typ wird eine eigene API bereitgestellt, da ein mobiler Client sicher weniger/andere Daten benötigt als eine Desktop-Anwendung. Und hinsichtlich Desktop-Anwendungen gibt es auch noch mal unterschieden zwischen verschiedenen Usergruppen (Poweruser brauchen eine andere UI als Gelegenheitsnutzer). In diesem Zusammenhang wird der Ansatz Backend-for-Frontend gerne genannt.

### Microservices mit Spring und Netflix

* [Microservices à la Netflix](https://www.innoq.com/de/articles/2016/12/microservices-a-la-netflix/)

Netflix ist zu einem großen Player in Sachen vieler relevanter Cloud-Eigenschaften (Elastizität, Resilience, Performance, ...) geworden. Viele Patterns und Implementierungen sind in OpenSource-Libraries geflossen und haben auch den Weg nach Spring gefunden. Dadurch sind sie wirklich sehr einfach und schnell integriert ... ein paar Annotation und schwupp funktionieren die eigenen Services à la Netflix.