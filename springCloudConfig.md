# Spring Cloud Config
* http://cloud.spring.io/spring-cloud-config/

Spring Boot bietet bereits eine komfortable Möglichzeit, die Konfiguration der Anwendung über Property-Files (oder Yaml-Files) zu steuern - [siehe ``@Value`` und ``@ConfigurationProperties``](springBoot.md). Allerdings ist diese Konfiguration nach dem Start der Anwendnung nicht mehr änderbar (ohne die Anwendnung zu restarten). In einer Zeit, in der Anwendungen automatische skalieren und Failover mitbringen, ist das zu kurz gegriffen. 

Spring Cloud Config setzt auf Spring Boot auf (vermutlich geht es auch in Nicht-Spring-Boot-Applikationen).

---

# Getting Started ...

## Maven Dependencies
 Die Dependencies

* ``spring-cloud-config``
* ``spring-cloud-starter-config``
* ``spring-boot-starter-actuator``

werden im ``pom.xml`` (sofern Maven verwendet wird) hinterlegt.

## Deployment

Am schnellsten kommt man zu einer lauffähigen Spring Cloud Config Anwendnung durch die Verwendung des [Spring Initializr](https://start.spring.io/). Nach Auswahl von 

* Actuator
* Config Client
* Config Server
* Rest - nicht zwingend, aber ganz praktisch zum Testen (ich würde keine Applikation mehr ohne REST-Schnittstelle erstellen)

Anschließend steht ein ZIP-Artefakt zum Download, in dem sich das Gerüst der Anwendung befindet.

Nach dem Build, steht das Executable-Jar fürs Deployment zur Verfügung:

    mvn clean install
    cd target
    java -jar myapp.jar

Die vom Actuator bereitgestellte REST-Schnittstelle ``http://localhost:8081/env`` liefert schon erste Auskünfte:


> Der Spring Boot Actuator steuert u. a. ein paar REST-Webservices zur Verfügung, über die Informationen zum Config-Server (http://localhost:8081/env) abgerufen werden können.

## Config-Repository anlegen
Zum Testen kann ein lokales [GIT-Repository](git.md) angelegt werden


## Application
Die SpringBoot-Applikation 

    @SpringBootApplication
    @EnableConfigServer
    public class Application {
        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    }

wird zum Config-Client, dem über ``@EnableConfigServer`` bekannt gemacht wird, daß es einen Config-Server gibt. Configuration Properties werden über 

    @Value("${de.cachaca.cloud.provider}")
    private String cloudProvider;
    
injeziert. Zunächst werden die Properties im konfigurierten (``application.properties``: Property ``spring.cloud.config.uri``) Config-Server gesucht. Erst danach in den Property-Files des Classpath. 

---

# Config-Server
Ein Config-Server ist der Service, der den Zugang zur  Konfiguration bereitstellt. Die Konfiguration selber liegt in einem Configuration Repository:

* Git-Repository
  * lokal: ``spring.cloud.config.server.git.uri: file://${user.home}/config-repo``
  * remote: ``spring.cloud.config.server.git.uri: https://github.com/spring-cloud-samples/config-repo/bar.properties``

Über ``@EnableConfigServer`` wird der Spring-Boot-Applikation der Hinweis zur Verwendung eines Config-Servers gegeben. Dadurch wird zuerst der Config-Server angefragt und dann erst Konfiguration aus dem Classpath.