# Java Annotations

* Schnellübersicht: http://de.wikipedia.org/wiki/Annotation_%28Java%29

Annotationen wurden in Java 1.5 eingeführt. Vorgänger ausserhalb des Java-Kerns war XDoclet, mit dem man u. a. bei EJB 1.x und 2.x die Deployment-Deskriptoren (u. a. Database-Mapping) in den Java-Code schreiben konnte. Die Deployment-Deskriptoren wurden aus diesen Annotationen zur Compile-Zeit erzeugt. Dadurch war diese Information sehr nah beim Code. Annotationen bieten eine große Chance, die Semantik zu erhöhen und die Dokumentation zu verbessern.

Annotationen werden in Abhängigkeit der gesetzten [RetentionPolicy](http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8u40-b25/java/lang/annotation/RetentionPolicy.java#RetentionPolicy) (siehe entsprechende Annotationsdeklaration) zu unterschiedlichen Zeitpunkten ausgewertet

* SOURCE: vor der Compile-Zeit, um dem Compiler wichtige Informationen zu liefern (z.  B. @Deprecated, @Override) ... diese Annotationen schaffen es nicht in den Bytecode
  * es werden vom Compiler Warnungen angezeigt
  * es wird Code generiert
* CLASS: zur Compilezeit/Deployzeit, um Code/Ressourcen zu generieren (z. B. Deployment-Deskriptoren) - im Bytecode enthalten
* RUNTIME: zur Laufzeit (z. B. @Test von JUnit, @Transactional von Spring) - im Bytecode enthalten
  * mittels Reflection

ausgewertet.

Java stellt einige Annotationen (z.  B. @Deprecated, @Override) selbst zur Verfügung, sie werden von Standard-Frameworks (Spring, Hibernate, ...) angeboten und jeder kann natürlich auch eigene schreiben.

## Beispiel: JUnit @Test-Annotation

Deklaration (Bestandteil des JUnit-Pakets):

```java
@Retention(RetentionPolicy.RUNTIME)  // Annotation wird mit in den Bytecode geschleift - kann zur Laufzeit ausgewertet werden
@Target({ElementType.METHOD})        // man kann die Annotation an eine Methode hängen
public @interface Test {

   static class None extends Throwable {
      private  None() {}
   }

   Class<? extends Throwable>  expected() default None.class;

   long  timeout() default 0L;
}
```

Und so wird sie benutzt:

```java
public TestClass {

   @Test(timeout=100, expected=RuntimeException.class)
   public void myTestMethod() {
      // ...
   }
}
```

Somit muss eine Testklasse nicht mehr von TestCase erben, sondern kann den Vererbungsmechanismus für wichtigere Dinge (die Wiederverwendung eigener Testlogik) verwenden.

## Meta-Annotationen

Folgende Annotationen verwendet man nur bei der Annotationsdeklaration (also innerhalb einer @interface Ressource)

* @Documented: dann findet die Annotation auch ihren Weg in die JavaDoc
* @Inherited: Annotation wird auch in abgeleitete Klassen vererbt (z. B. @Transactional von Spring)
* @Retention: wann wird die Annotation ausgewertet (siehe RetentionPolicy)
  * RUNTIME
* @Target: an welche Komponenten kann die Annotation gehangen werden (siehe Enumeration ElementType):
  * PACKAGE (z. B. @Deprecated)
  * TYPE (z. B: Spings @Transactional) - an eine Klasse
  * METHOD - an eine Methode
  * FIELD - an eine Member-Variable
  * ANNOTATION_TYPE - an eine Annotationsdeklaration (Wiederverwendung von Annotationslogik) - das steht dann beispielsweise in den Meta-Annotationen
  * ...

## Auswertung von Annotationen

* siehe: http://download.oracle.com/javase/1,5.0/docs/guide/apt/GettingStarted.html

Auswertung durch

* Schreiben eines `AnnotationProcessor`, der dann beispielsweise vom APT Tool (Annotations Procession Tool - Bestandteil des JDK) ausgeführt wird
* Reflection (nur für RUNTIME)

### Auswertung zur Compile-Zeit

* [Tutorial 1](https://www.javacodegeeks.com/2015/09/java-annotation-processors.html)
* [Tutorial 2](http://www.baeldung.com/java-annotation-processing-builder)

Wegen 

> "An important thing to note is the limitation of the annotation processing API — it can only be used to generate new files, not to change existing ones. The notable exception is the Lombok library which uses annotation processing as a bootstrapping mechanism to include itself into the compilation process and modify the AST via some internal compiler APIs. This hacky technique has nothing to do with the intended purpose of annotation processing [...]" (http://www.baeldung.com/java-annotation-processing-builder)

gibt es keine Möglichkeit, Prioritäten auf den Annotationen zu setzen, um bestimmte Annotationen vor anderen zu verarbeiten. Das könnte dann Sinn machen, wenn man zur Compilezeit weitere Annotationen hinzufügen wollte - das ist aber gar nicht vorgesehen.


* jede Java-Klasse kann zu einem Annotation Processor werden indem es das Interface [`javax.annotation.processing.Processor`](http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8u40-b25/javax/annotation/processing/Processor.java#Processor) implementiert
  * wenn der Vererbungsmechnismus noch nicht genutzt ist, kann man von [javax.annotation.processing.AbstractProcessor](http://grepcode.com/file/repository.grepcode.com/java/root/jdk/openjdk/8u40-b25/javax/annotation/processing/AbstractProcessor.java#AbstractProcessor) ableiten
* Annotation-Processing erfolgt in sog. Runden, denn Annotation-Prozessoren zur Compile-Zeit erzeugen i. a. auch Code, der dann wiederum mit Annotation versehen sein können, die prozessiert werden müssen

    > "The annotation processing is done in multiple rounds. Each round starts with the compiler searching for the annotations in the source files and choosing the annotation processors suited for these annotations. Each annotation processor, in turn, is called on the corresponding sources. If any files are generated during this process, another round is started with the generated files as its input. This process continues until no new files are generated during the processing stage." (http://www.baeldung.com/java-annotation-processing-builder)

### Auswertung zur Laufzeit

Wenn die Annotation bis in den Bytecode gelangt ist (RetentionPolicy.RUNTIME), dann kann sie zur Laufzeit per Reflection ausgewertet werden. Beispiel:

```java
if (MyClass.class.isAnnotationPresent(Deprecated.class)) { 
    // ...
}
```