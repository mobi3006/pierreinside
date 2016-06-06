# Spring Boot

... vereinfacht die Entwicklung von Java-Server-Applikationen. Man muss solche Server dann nicht in einem Application-Server als war-file deployen, sondern die Server-Applikationen werden als jar gepackt und enthalten einen Spring-Boot-unterstützten Application-Server (z. B. Tomcat, Jetty). Eine Spring-Boot-Applikation kann dann ganz einfach per

    java -jar my-application.jar

gestartet werden.

Zudem unterstützt Spring Boot HotDeployment wie man es bisher beispielsweise über JRebel erkaufen mußte.

---

# Getting Started

Über Spring Initializr kann man sich sehr schnell ein Maven/Gradle Projekt mit verschiedenen Spring (Boot, Cloud, ...) und nicht-Spring Technologien (ElasticSearch, JavaMail, ...)  zusammenstellen lassen (letztlich geht es beispielsweise im die pom.xml und ein paar weitere Getting Started Ressourcen). Es werden auch verschiedene Sprachen unterstützt (2015: sind es Java und Groovy).

## Create maven pom.xml: Spring Initializr

* https://start.spring.io/

Über die Weboberfläche des Initializr wählt man sich Eckpunkte (Sprache, Buildsystem, Frameworks, Technologien) aus, auf denen die Applikation basieren soll. Am Ende bekommt man ein Zip zum Download, das folgendes enthält:

* pom.xml
  * hier ist auch das Maven-Plugin ``spring-boot-maven-plugin`` referenziert, das für die Spring-Boot-Executable-jar-Erzeugung benütigt wird
  * je nach dem für welchen Typ von Spring-Boot-Applikation man sich entschieden hat, findet man unterschiedliche Parent-poms
    * reine Backend-Applikation: ``org.springframework.boot/spring-boot-starter-parent``
    * Webapplikation: ``org.springframework.boot/spring-boot-starter-web-parent``
      * hieraus ergibt sich eine Abhängigkeit zu einem Embedded-Servlet-Container wie Tomcat/Jetty ... die Abhängigkeit ist aber in dem Parent definiert
* Main-Class-Gerüst, so daß man mit der Business-Logik der Anwendung sofort loslegen kann
* Beispiel-Konfiguration

Zudem werden noch ein paar Java-Klassen generiert.

## Build your application
Das Kommando
    
    mvn package

erzeugt ein **Fat-Jar** (compilierte Klassen des Projekts + abhängige Libs), das ohne weiteres startbar ist.

## Start your application

Der Start der Applikation erfolgt über 

    mvn spring-boot:run
    
oder 

    java -jar my-application.jar

Voila ... sehr schlank. Wir sind nun innerhalb weniger Minuten zu einer komfortabel deploybaren Server-Applikation gekommen. Jetzt kanns losgehen mit der Implementierung der Business-Logik.

## Jar-to-war

* https://spring.io/guides/gs/convert-jar-to-war/

Will man eine Spring-Boot Anwendung dennoch in einem externen Application-Server deployen, so benötigt man ein War-Artefakt. Für diesen Anwendungsfall hat Spring maven/gradle-Plugins entwickelt.

Hat man nun ein War-Artefakt erzeugt, so kann man aber dennoch den komfortablen Deployment-Ansatz im embedded-Application-Server per

    java -jar mySpringBootApp.war
    
nutzen.

---

# Build Tool Support
Spring Boot unterstützt die beiden Build-Tools

* maven
* gradle

durch Dependency-Management, Code-Generierung (z. B. pom.xml).

Andere Build-Tools (z. B. ant) können auch verwendet werden, doch wird es nicht von Spring unterstützt, d. h. der Einsatz ist weniger komfortabel.

---

# Annotation-Based
Spring-Boot verwendet - Spring-typisch - Java-Annotation en-masse ... sie werden verwendet, um die Eigenschaften der Anwendung festzulegen. Beispiele:

* ``@SpringBootApplication``
* ``@EnableAutoConfiguration``
* ``@Configuration``
* ``@ComponentScan``

Auf diese Weise weiß der Spring-Boot-Loader (und somit auch der Leser dieser Klasse) beispielsweise wie die Anwendung zu initialisieren ist.

## EnableAutoConfiguration
Ist diese Eigenschaft gesetzt, so versucht Spring sich die Konfiguration der Anwendung selbst zu erschließen.

---

# Spring Dependency Management

Im pom.xml wird man u. a. folgendes finden:

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.3.0.RELEASE</version>
        <relativePath/>
    </parent>

die wiederum die ``spring-boot-dependencies`` (http://search.maven.org/#artifactdetails|org.springframework.boot|spring-boot-dependencies|1.3.5.RELEASE|pom) als Parent hat. In dieser sind Versionen von einer Vielzahl von Frameworks definiert, die zueinander passen. Will man eine andere Version benutzen, so muß man im eigenen ``pom.xml`` nur ein Property definieren, z. B. ``<commons-collections.version>3.2.2</commons-collections.version>``.
