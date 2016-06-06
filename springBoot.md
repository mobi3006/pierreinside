# Spring Boot

... vereinfacht die Entwicklung von Java-Server-Applikationen. Man muss solche Server dann nicht in einem Application-Server als war-file deployen, sondern die Server-Applikationen werden als jar gepackt und enthalten einen Spring-Boot-unterstützten Application-Server (z. B. Tomcat, Jetty). Eine Spring-Boot-Applikation kann dann ganz einfach per

    java -jar my-application.jar

gestartet werden.

Zudem unterstützt Spring Boot HotDeployment wie man es bisher beispielsweise über JRebel erkaufen mußte.

---

# Getting Started

Über Spring Initializr kann man sich sehr schnell ein Maven/Gradle Projekt mit verschiedenen Spring (Boot, Cloud, ...) und nicht-Spring Technologien (ElasticSearch, JavaMail, ...)  zusammenstellen lassen (letztlich geht es beispielsweise im die pom.xml und ein paar weitere Getting Started Ressourcen). Es werden auch verschiedene Sprachen unterstützt (2015: sind es Java und Groovy).

## Spring Initializr

* https://start.spring.io/

Über die Weboberfläche des Initializr wählt man sich Eckpunkte (Sprache, Buildsystem, Frameworks, Technologien) aus, auf denen die Applikation basieren soll. Am Ende bekommt man ein Zip zum Download, das folgendes enthält:

* pom.xml
* Beispiel-Code
* Beispiel-Konfiguration

## Dependencies

Im pom.xml wird man u. a. folgendes finden:

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.3.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

die wiederum die spring-boot-dependencies als Parent hat (siehe hier). In dieser spring-boot-dependencies sind Versionen von einer Vielzahl von Frameworks definiert, die zueinander passen. Will man eine andere Version benutzen, so muß man im eigenen pom.xml nur ein Property definieren (z. B. ``<commons-collections.version>3.2.2</commons-collections.version>``).

Hat man sich für eine Web-Applikation entschieden, so wird sich in der pom.xml noch folgende Abhängigkeit finden:

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

aus der sich dann auch die Abhängigkeit zu einem embedded Tomcat ergibt.

Zudem werden noch ein paar Java-Klassen generiert.

## Start your application

Der Start der Applikation erfolgt über ``mvn spring-boot:run`` oder ``java -jar my-application.jar``

Voila ... sehr schlank. Wir sind nun innerhalb weniger Minuten zu einer komfortabel deploybaren Server-Applikation gekommen. Jetzt kanns losgehen mit der Implementierung der Business-Logik.

## Jar-to-war

* https://spring.io/guides/gs/convert-jar-to-war/

Will man eine Spring-Boot Anwendung dennoch in einem externen Application-Server deployen, so benötigt man ein War-Artefakt. Für diesen Anwendungsfall hat Spring maven/gradle-Plugins entwickelt.

Hat man nun ein War-Artefakt erzeugt, so kann man aber dennoch den komfortablen Deployment-Ansatz im embedded-Application-Server per

    java -jar mySpringBootApp.war
    
nutzen.