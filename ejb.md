# Enterprise Java Beans Spezifikation
Enterprise Java Beans (EJB) sind Teil der JEE Spezifikation, die mittlerweile schon in Version 1.8 vorliegt (passend zu Java 8).

Der JEE Standard war lange Zeit dominieren im Enterprise-Java-Umfeld. Doch Spring ist in die Pharlance eingebrochen und hatte mit dem deutlich pragmatischeren Ansatz schnell eine große Fangemeinde. Zudem ist Spring aufgrund seiner Eigenständigkeit deutlich schneller in der Entscheidungsfindung als JEE mit seinem Java Community Process, bei dem es schon mal ein paar Jahre dauern kann bis eine neue Version erscheint.

---

# Enterprise Java Beans Spezifikation - Version 1.6
* http://docs.oracle.com/javaee/6/tutorial/doc/

Es gibt verschiedene Arten von EJBs:

* Session Bean 
  * Stateful
  * Stateless
  * Singleton
* Message-Driven Bean

## Context and Dependency Injection (CDI)
* https://docs.jboss.org/cdi/spec/1.0/html/
* https://antoniogoncalves.org/2011/04/07/injection-with-cdi-part-i/
* https://antoniogoncalves.org/2011/04/07/injection-with-cdi-part-ii/
* https://antoniogoncalves.org/2011/04/07/injection-with-cdi-part-iii/
* http://docs.jboss.org/weld/reference/latest/en-US/html/part-4.html

CDI-Injection ist Teil der JEE-Spezifikatin seit 1.6. EJB, CDI und JSF sind sehr gut miteinander integriert.

CDI-Injection (`@Inject`) und EJB-Injection (`@EJB`) sind zwei unterschiedliche Ansätze. Alles, was mit EJB-Injection geht, sollte auch mit CDI-Injektion funktionieren ... CDI-Injektion ist weiter gefaßt, denn hiermit lassen sich alle Beans (nicht nur die EJB-seitigen) injezieren.

Enterprise Beans werden bei entsprechender Kennzeichnung (`@EJB`) in andere Java-Klassen injeziert. Im JEE-Umfeld verwendet man hierzu die CDI-Spezifikation.

### Kennzeichnung von CDI-Beans/Projekten
* http://in.relation.to/2009/12/05/why-is-beansxml-required-in-cdi/

CDI benötigt keinerlei Kennzeichnung/Annotation in der zu exponierenden Klasse (wenn man sie dennoch zum Zwecke der Dokumentation kennzeichnen möchte, dann kann man `@Dependent` angeben). Allerdings muß das Projekt entweder als CDI-Beans-Provider gekennzeichnet sein (entweder/oder):

* Deployment-Deskriptor `<MODULE>/src/main/resources/META-INF/beans.xml` muss existieren - kann aber leer sein)
* es muß für die Bean einen Producer geben (eine Methode in einer beliebigen Klasse mit der Annotation `javax.enterprise.inject.Produces`)



