# Spring Cloud Config
* [Offizielle Dokumentation](http://cloud.spring.io/spring-cloud-config/)

Spring Boot bietet bereits eine komfortable Möglichzeit, die Konfiguration der Anwendung über Property-Files (oder Yaml-Files) zu steuern - [siehe ``@Value`` und ``@ConfigurationProperties``](springBoot.md). Allerdings ist diese Konfiguration nach dem Start der Anwendnung nicht mehr änderbar (ohne die Anwendnung zu restarten). In einer Zeit, in der Anwendungen automatische skalieren und Failover mitbringen, ist das zu kurz gegriffen. 

Spring Cloud Config soll diese Lücke clientseitig und serverseitig schließen.

> Spring Cloud Config auf Spring Boot auf (vermutlich geht es auch in Nicht-Spring-Boot-Applikationen).

---

# Getting Started ...
In diesem Beispiel werde ich eine Spring-Boot-Applikation bereitstellen, die auch gleichzeitig einen Spring Cloud Config Server bereitstellt. Die Spring-Boot-Application agiert also als Config-Client gegen den Config-Server.

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
* Web
  * nur optional, aber ganz praktisch zum Testen - aus meiner Sicht sollte jede Applikation ein REST-Schnittstelle haben

Anschließend steht ein ZIP-Artefakt zum Download, in dem sich das Gerüst der Anwendung befindet.

Nach dem Build, steht das Executable-Jar fürs Deployment zur Verfügung:

    mvn clean install
    cd target
    java -jar myapp.jar

Die vom Actuator bereitgestellte REST-Schnittstelle ``http://localhost:8081/env`` liefert schon erste Auskünfte:

    { "profiles":[],
      "server.ports":{"local.server.port":8080}
      ...

> Der Spring Boot Actuator steuert u. a. ein paar REST-Webservices zur Verfügung, über die Informationen zum Config-Server (http://localhost:8081/env) abgerufen werden können.

Zum erstellten Applikationscode fügen wir noch eine REST-Schnittstelle zum Testen ein:

    @SpringBootApplication
    @RestController
    public class Application {

        @Value("${de.cachaca.learn.spring.configRepositoryProvider}")
        private String configRepositoryProvider;

        @RequestMapping(value = "/config", method = RequestMethod.GET)
        public String getConfig() {
            return configRepositoryProvider;
        }

        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    }

und konfigurieren den ``de.cachaca.learn.spring.configRepositoryProvider`` über die ``application.properties``:

    de.cachaca.learn.spring.configRepositoryProvider = classpath
    
Nach dem Start der Anwendung sollte bei ``http://localhost:8081/config`` der Wert ``classpath`` ausgegeben werden.

Soweit nichts Neues ... aber im Folgenden machen wir die Konfiguration über einen Config-Server.

## Config-Repository anlegen
Zum Testen kann ein lokales [GIT-Repository](git.md) angelegt werden:

    mkdir de.cachaca.learn.spring.cloud-config
    cd de.cachaca.learn.spring.cloud-config
    git init
    echo de.cachaca.learn.spring.configRepositoryProvider = local git repository > application.properties
    git add application.properties
    git commit -m "initial commit"

## Applikation konfigurieren
Die SpringBoot-Applikation 

    @SpringBootApplication
    @EnableConfigServer
    public class Application {
        public static void main(String[] args) {
            SpringApplication.run(Application.class, args);
        }
    }

wird zum Config-Client. Über ``@EnableConfigServer`` wird konfiguriert, daß es einen Config-Server gibt. Configuration Properties werden über 

    @Value("${de.cachaca.cloud.provider}")
    private String cloudProvider;
    
injeziert. Zunächst werden die Properties im konfigurierten Config-Server gesucht (konfiguriert über ``application.properties#spring.cloud.config.uri``). Wird dort nichts gefunden, wird im Classpath nach einer Property-Datei gesucht.

Dementsprechend wird in ``application.properties`` folgendes eingetragen:

    spring.cloud.config.server.git.uri = file://${user.home}/src/external/de.cachaca.learn.spring.cloud-config

Nach einem Restart der Anwendnung wird bei ``http://localhost:8081/config`` der Wert ``local git repository`` ausgegeben werden.

---

# Config-Server
Ein Config-Server ist der Service, der den Zugang zur  Konfiguration bereitstellt. Die Konfiguration selber liegt in einem Configuration Repository:

* Git-Repository
  * lokal: ``spring.cloud.config.server.git.uri: file://${user.home}/config-repo``
  * remote: ``spring.cloud.config.server.git.uri: https://github.com/spring-cloud-samples/config-repo/bar.properties``

Über ``@EnableConfigServer`` wird der Spring-Boot-Applikation der Hinweis zur Verwendung eines Config-Servers gegeben. Dadurch wird zuerst der Config-Server angefragt und dann erst Konfiguration aus dem Classpath.