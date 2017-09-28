# Dependency Injection
Ursprünglich wurde dieses Paradigma vom Spring-Framework eingeführt. Mittlerweile ist es state-of-the-art und hat auch in die EJB-Spezifikation in Form von CDI Einzug gehalten.

In vielen Projekten trifft man sogar auf eine CDI-basierte Implementierung (Referenzimplementierung WELD) und eine Spring-basierte Implementierung (vielleicht erfolgt gerade eine Transition).

# Context and Dependency Injection (CDI)
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



