# Spring Boot

* [Offizielle Dokumentation](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)
* [Spring Boot Cookbook](http://file.allitebooks.com/20151028/Spring%20Boot%20Cookbook.pdf)

... vereinfacht die Entwicklung von Java-Server-Applikationen indem ein ausführbares jar-File erstellt wird, das sich selbst in der jeweiligen Umgebung deployed. Das jar enthält in diesem Fall ALLE notwendigen Third-Party-Bibliotheken und zudem noch die notwendige Laufzeitumgebung. Handelt es sich um eine Web-Applikation, so ist ein Servlet-Container (Tomcat, Jetty) eingebettet, in dem die Web-Applikation deployed wird. Eine Spring-Boot-Applikation kann dann ganz einfach per

    java -jar my-application.jar

gestartet werden. Ein Start als Betriebssystem-Service wird auch unterstützt.

---

# Getting Started
* [YouTube Video](https://www.youtube.com/watch?v=p8AdyMlpmPk)

Über Spring Initializr kann man sich sehr schnell ein Maven/Gradle Projekt mit verschiedenen Spring (Boot, Cloud, ...) und nicht-Spring Technologien (ElasticSearch, JavaMail, ...)  zusammenstellen lassen (letztlich geht es beispielsweise im die pom.xml und ein paar weitere Getting Started Ressourcen). Es werden auch verschiedene Sprachen unterstützt (2015: sind es Java und Groovy).

## Spring Initializr => erstellt Maven pom.xml

* [Initializr Webapplikation](https://start.spring.io/)

Über die Weboberfläche des Initializr wählt man sich Eckpunkte (Sprache, Buildsystem, Frameworks, Technologien) aus, auf denen die Applikation basieren soll. Am Ende bekommt man ein Zip zum Download, das folgendes enthält:

* pom.xml
  * hier ist auch das Maven-Plugin ``spring-boot-maven-plugin`` referenziert, das für die Spring-Boot-Executable-jar-Erzeugung benütigt wird
  * je nach dem für welchen Typ von Spring-Boot-Applikation man sich entschieden hat, findet man unterschiedliche Parent-poms
    * reine Backend-Applikation: ``org.springframework.boot/spring-boot-starter-parent``
    * Webapplikation: ``org.springframework.boot/spring-boot-starter-web-parent``
      * hieraus ergibt sich eine Abhängigkeit zu einem Embedded-Servlet-Container wie Tomcat/Jetty ... die Abhängigkeit ist aber in dem Parent definiert
* Main-Class-Gerüst, so daß man mit der Business-Logik der Anwendung sofort loslegen kann

      @SpringBootApplication
      public class MyApplication 
        extends SpringBootServletInitializer {

        public static void main(String[] args) {
          MyApplication.run(MyApplication.class, args);
        }

        protected SpringApplicationBuilder configure(
          SpringApplicationBuilder application) {
          return application.sources(MyApplication.class);
        }
      }

* Beispiel-Konfiguration

## Build der Applikation
Das Kommando
    
    mvn package

erzeugt ein **Fat-Jar** (compilierte Klassen des Projekts + abhängige Libs), das ohne weiteres startbar ist.

## Start der Applikation

Der Start der Applikation erfolgt über (ODER-Optionen)

1. Start aus der IDE
    * Debugging ist dann sehr leicht möglich 
2. ``mvn spring-boot:run`` 
    * Remote-Debugging  
3. ``java -jar my-application.jar``

> **Empfehlung:** ich präferiere die ersten beiden, weil dadurch der Warm-Restart-Mechnismus verwendet werden kann.

Voila ... sehr schlank. Wir sind nun innerhalb weniger Minuten zu einer komfortabel deploybaren Server-Applikation gekommen. Jetzt kanns losgehen mit der Implementierung der Business-Logik.

**ACHTUNG:** Unter Windows kann ein Doppelclick auf das jar/war-Artefakt dazu führen, daß die Anwendung automatisch als Dienst installiert wird.

## Eclipse-Integration der Applikation
Über

    mvn eclipse:eclipse

werden die Eclipse Artefakte ``.project`` und ``.classpath`` erzeugt. Danach kann das Projekt in Eclipse importiert werden. 

**ACHTUNG:** standardmäßig waren die Dateien ``application.properties`` und ``application.yml`` vom Build ausgeschlossen. Das sollte man ändern!!! Ansonsten  wandern diese Dateien (auch nach Änderungen) nie in den Runtime-Classpath der Applikation und somit funktioniert die Anwendung nicht richtig.

> Wenn man zufällig ein Build über Maven angestoßen hatte, dann wurden im ``target/classes`` Verzeichnis diese Dateien abgelegt ... Eclipse hätte aber niemals ein Update darauf gemacht. Hmmmm, schon strange ... will mich da jemand zu IntelliJ treiben?

---

# Build Tool Support
Spring Boot unterstützt die beiden Build-Tools

* maven
* gradle ... habe ich selbst noch nicht genutzt - deshalb beschränke ich mich im folgenden auf maven

durch Dependency-Management, Code-Generierung (z. B. pom.xml).

Andere Build-Tools (z. B. ant) können auch verwendet werden, doch wird es nicht von Spring unterstützt, d. h. der Einsatz ist weniger komfortabel.

## Maven: Starter POMs

* [Offizielle Dokumentation ... Using Starter-POMs](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-starter-poms)

Im Initializr generierten ``pom.xml`` wird man u. a. folgendes finden:

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.3.0.RELEASE</version>
        <relativePath/>
    </parent>

Das sorgt für zwei Dinge:

* das ``spring-boot-maven-plugin`` ist integriert, so daß ein ausführbares jar-File erstellt wird
* die ``spring-boot-dependencies`` (siehe [Maven Central Repository](http://search.maven.org/#artifactdetails|org.springframework.boot|spring-boot-dependencies|1.3.5.RELEASE|pom)) werden verwendet. In dieser sind Versionen von einer Vielzahl von Frameworks definiert, die zueinander passen (Spring übernimmt also das Dependency-Management (wenn man will).

Auf diese Weise kommt man schon mal sehr schnell sehr weit.

## Maven: Artefakt Typen jar vs. self-executable jar

Per Default (d. h. wenn das Default Parent-Pom verwendet wird) werden zwei Typen von jar-Artefakten erstellt:

* ausführbares JAR [mit folgendem Inhalt](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#executable-jar-jar-file-structure):
  * alle notwendigen Libs (als jars)
  * Laufzeitumgebung (z. B. Servlet-Container)
* normales JAR des Moduls, um in anderen Assemblies verwendet zu werden

## Maven: Artefakt-Typ: jar vs. war

* How-To: https://spring.io/guides/gs/convert-jar-to-war/

Will man eine Spring-Boot Anwendung dennoch in einem externen Application-Server deployen, so benötigt man ein War-Artefakt. Für diesen Anwendungsfall verwendet man 

    <packaging>war</packaging>
    
im ``pom.xml``.

Hat man nun ein War-Artefakt erzeugt, so kann man aber dennoch den Executable-Deployment-Ansatz nutzen:

    java -jar mySpringBootApp.war


## Maven: Version einer Dependency ändern

* [How-To customize Dependency Versions](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-customize-dependency-versions)

Spring pflegt zueinander passende Versionen ausgewählter Bibliotheken, d. h. verwendet man Spring-Boot 1.3.6, so sind in [spring-boot-dependencies](http://repo1.maven.org/maven2/org/springframework/boot/spring-boot-dependencies/1.3.6.RELEASE/spring-boot-dependencies-1.3.6.RELEASE.pom) automatisch viele Versionen festgelegt:

```
<spring.version>4.2.7.RELEASE</spring.version>
<hibernate.version>4.3.11.Final</hibernate.version>
<thymeleaf.version>2.1.4.RELEASE</thymeleaf.version>
...
```

Im eigenen ``pom.xml`` kann man die Version folgendermaßen ändern ... Spring kann dann natürlich die Kompatibilität nicht mehr garantieren:

```
<thymeleaf.version>3.0.0.RELEASE</thymeleaf.version>
```

## pom.xml: Interessante Properties

```xml
<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
<java.version>1.8</java.version>
``` 

## Remote-Debugging
Über 

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-maven-plugin</artifactId>
      <configuration>
        <jvmArguments>
            -Xdebug
            -Xrunjdwp:transport
              =dt_socket,server=y,suspend=n
              ,address=9000
        </jvmArguments>
      </configuration>
    </plugin>
  </plugins>
</build>
```

wird das Remote-Debugging der Applikation ermöglich, wenn sie über maven gestartet wird (``mvn spring-boot:run``).

Startet man hingegen das executable jar-Artefakt (erstellt durch ``mvn install``), dann kann dort das Debugging wie üblich per Java-Parameter beim Programmstart

```bash
java 
  -jar myapp.jar 
  -Xdebug 
  -Xrunjdwp:transport=dt_socket
    ,address=8000,server=y,suspend=n`` 
```

konfiguriert werden.

---

# Programming
[siehe eigener Abschnitt
Spring-Boot verwendet - [Spring-typisch ... siehe auch Spring-Core](springCore.md)

---

# Integrationtesting
[siehe eigener Abschnitt](springBoot_testing.md)

## Remote Debugging ermöglichen

Um ein Remote-Debugging (z. B. über eine IDE) der Spring-Boot-Applikation zu ermöglichen, muß die Applikation folgendermaßen gestartet werden:

    java 
      -Xdebug 
      -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n
      - jar myapp.jar

Soll die Applikation aus der IDE gestartet werden, so müssen die ``-X``-Argumente im Launcher als VM-Argumente eingetragen werden.

Ist die Applikation gestartet, wird in der IDE ein Remote-Debug-Prozess gestartet, der sich an den Remote-Debug-Port der Anwendung verbindet (wie üblich, wenn Java-Applikationen remote gedebugged werden).

---

# HotSwapping
* Developer Tools: http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-devtools
* http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-hotswapping

Spring Boot bringt eine Warm-Restart-Funktionalität (siehe unten) mit. Hierzu müssen die Develeoper Tools aktiviert werden. Startet man die Anwendung aus der IDE, so führen Änderungen in der IDE automatisch zu einem Warm-Restart der Anwendung ... ein JRebel-Light (dafür aber kostenlos).

## Developer Tools (aka ``devtools``)
Über die Dependency

```xml
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
      </dependency>
    </dependencies>
```

erfolgt die Integration der Developer Tools. Dann sollte man noch folgende Konfiguration in der ``application.properties`` setzen:

* ``spring.devtools.livereload.enabled=true`` 

### Cold-Start vs. Warm-Restart vs. Reload 

* Cold-Start:
  * gesamte Anwendung wird neu gestartet
  * diesen Ansatz verfolgen Application-Server i. d. R. out-of-the-box
  * dauert lang (je nach Anwendung mehrere Minuten)
* Warm-Restart: in Sping-Boot integrierter Ansatz (Developer Tools)
  * funktioniert mit zwei Classloadern. Einer ist für die unveränderbaren Third-Party-Ressourcen zuständig, einer für die veränderlichen eigenen Ressourcen.
  * funktioniert auch mit Remote-Deployments (http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-devtools-remote)
  * geht deutlich schneller
* Reload: 
  * hierbei wird die Anwendung nicht neu gestartet, sondern die Änderungen werden nachgeladen
  * geht am schnellsten (i. d. R. sofort bis wenige Sekunden) und funktioniert (aus eigener Erfahrung) ganz wunderbar!!!
  * Java-Bytecode HotSwapping: Moderne IDEs unterstützen alle Hot-Swapping von Byte-Code sofern die Klassen/Methoden-Signatur nicht geändert wird, d. h. bei Änderungen im Methoden-Body. Das funktioniert bei Spring-Boot somit 
  * [JRebel Ansatz](http://zeroturnaround.com/software/jrebel/)
  * [Spring-Loaded Ansatz](https://github.com/spring-projects/spring-loaded)

### Feature: Automatic Warm Restart

Die Developer Tools aktivieren per Default das Automatic Restart Feature. Sobald sich eine Ressource auf dem Filesystem ändert (z. B. durch eine Änderung in der IDE und der daraus folgenden Class-Generierung) erfolgt ein Warm-Restart (Erklärung siehe oben).

**ACHTUNG:** es muß sichergestellt werden, daß das von der IDE erzeugte Class-File auch tatsächlich im Classpath der gestarteten Anwendung landet. Ist die Anwendung in der IDE gestartet, dann geschieht das automatisch. Läuft die Anwendung über maven (``mvn spring-boot:run``), dann kommt es darauf an wohin die IDE die class-Datei compiliert. Läuft die Anwendung über das Executable-Jar (``java -jar myapp.jar``), dann kann es nicht funktionieren, weil die Klassen aus dem Jar-Artefakt gezogen werden.

### Feature: Reload Templates

* http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-reload-thymeleaf-template-content

In einer Produktionsumgebung ist das Caching von Templates eine sehr sinnvolle Vorgehensweise, weil sich die Templates nicht ändern. In Developer-Umgebungen will man hingegen die Änderungen am sofort sehen und nicht erst die Anwendung durchstarten müssen.

Über die ``application.properties`` kann das Caching ausgeschaltet werden:

    spring.velocity.cache = false
    
### Konfiguration

Die Konfiguration der ``devtools`` erfolgt Spring-Boot-like in der ``application.properties``. Da es sich aber schon um spezielle Entwickler-abhängige Einstellungen handelt, kann der Entwickler die Einstellungen per ``~/.spring-boot-devtools.properties`` dauerhaft übersteuern (siehe http://docs.spring.io/spring-boot/docs/current/reference/html/using-boot-devtools.html#using-boot-devtools-globalsettings).

---

# Cloud-Deployment
* http://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#cloud-deployment

Spring Boot Applikationen mit ihrem Executable-Jar-Ansatz (mit inkludierten Third-Party-Apps) sind relativ leicht auf beliebten PaaS-Providern deploybar.

## CloudFoundry
CloudFoundry ist - genauso wie Spring - ein Produkt von [Pivotal](http://pivotal.io/). Insofern ist es fast zwangsläufig, daß Spring Boot Applikationen komfortabel auf der CloudFoundry-Plattform deployed werden können.

Nach der Erstellung der Spring Boot Applikation per Maven 

    mvn clean package
    
wird die Anwendnung per (das CLI ``cf`` muß vorher natürlich installiert werden)

    cf login -u myuser -p mypassword
    cf push myapp -p target/myapp.jar

Danach ist die Anwendung über http://myapp.cfapps.io erreichbar.

## Heroku
Der Heroku-Cloud-Deployment ist nur unwesentlich aufwendiger als das CloudFoundry-Deployment.

---

# Production-Ready Features
[siehe eigener Abschnitt](springBoot_productionReady.md)

---

# Fazit
Spring zeigt mit seinen neuen Projekten (Boot, Config, ...), daß es sich innovativ weiterentwickelt und echte Mehrwerte für die Nutzer schafft. Der Einstieg in die Java-Welt wird generell (und insbesondere mit Blick auf Microservices) extrem vereinfacht. Verteilte Systeme - wie ich sie vor 20 Jahren im Studium theoretisch kennengelernt habe - werden nun auch für kleine Unternehmen/Startups realisierbar. Und dazu muß man nicht 3 Monate auf Schulung gehen ...

Seit 2010 hat sich in den Bereichen Microservices, Cloud-Deployment, DevOps, Continous Delivery so viel getan, daß die Softwareentwicklung auf einem neuen Level angekommen ist.

Spring trifft den Nerv der Zeit ... Hut ab :-)

## Kritikpunkte
Auch wenn der Einstieg sehr leicht fällt ... ums Lesen von Dokumentation kommt man nicht rum ;-)
### Magie
> "The Spring Boot auto-configuration tries its best to ‘do the right thing’, but sometimes things fail and it can be hard to tell why." (siehe [Spring Boot Dokumentation](http://docs.spring.io/spring-boot/docs/current-SNAPSHOT/reference/htmlsingle/#howto-troubleshoot-auto-configuration))

Spring hat schon recht viel Magic eingebaut. Beispielsweise kann Code compilierbar sein, aber durch eine fehlende Abhängigkeit verhält er sich zur Laufzeit einfach nicht wie erwartet, weil eben die zur Laufzeit ausgewertete Abhängigkeit fehlt. 

Es hat etwas von Pluggable-Extensions, wenn ich zur Applikation die Bibliothek ``spring-boot-starter-actuator-1.3.5.RELEASE.jar`` hinzufüge und dadurch weitere REST-Endpunkte vorhanden sind. Sehr komfortabel ... aber erst mal gewöhnungsbedürftig.

### Überblick über Unterprojekte
Zudem kann ist die Zuordnung einer Funktionalität zu einem Spring-Projekt nicht immer einfach. Dementsprechend fällt die Auswahl der richtigen Dependencies recht schwer. 

