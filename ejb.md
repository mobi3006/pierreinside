# EJB
Enterprise Java Beans (EJB) sind Teil der JEE Spezifikation, die mittlerweile schon in Version 1.8 vorliegt (passend zu Java 8).

Der JEE Standard war lange Zeit dominieren im Enterprise-Java-Umfeld. Doch Spring ist in die Pharlance eingebrochen und hatte mit dem deutlich pragmatischeren Ansatz schnell eine große Fangemeinde. Zudem ist Spring aufgrund seiner Eigenständigkeit deutlich schneller in der Entscheidungsfindung als JEE mit seinem Java Community Process, bei dem es schon mal ein paar Jahre dauern kann bis eine neue Version erscheint.

---

# EJB 1.6
* http://docs.oracle.com/javaee/6/tutorial/doc/

Es gibt verschiedene Arten von EJBs:

* Session Bean 
  * Stateful
  * Stateless
  * Singleton
* Message-Driven Bean

## Context and Dependency Injection (CDI)
* https://docs.jboss.org/cdi/spec/1.0/html/

Enterprise Beans werden bei entsprechender Kennzeichnung (`@EJB`) in andere Java-Klassen injeziert. Im JEE-Umfeld verwendet man hierzu die CDI-Spezifikation.

