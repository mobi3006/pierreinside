# Spring Boot Testing

## Integrationtesting

* http://docs.spring.io/spring/docs/current/spring-framework-reference/html/integration-testing.html
* https://www.jayway.com/2014/07/04/integration-testing-a-spring-boot-application/

Eine typische Testklasse für eine Webapplikation sieht so aus:

```java
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(
        classes = MyApplication.class,
        locations = { "classpath:META-INF/test-context.xml" })
@WebIntegrationTest("server.port:0")
public class MyApplicationTest {

    @Autowired
    private MyService service;

    @Test
    public void testServiceCall() {
        service.method();
    }
}
```

### @RunWith(SpringJUnit4ClassRunner.class)

Dieser JUnit-Testrunner sollte grundsätzlich bei Spring-basierten Komponenten verwendet werden. Er stellt die Grundvoraussetzung dar - sonst darf man sich nicht wundern, wenn spring-spezifische Aspekte (z. B. der Aufbau des ApplicationContext aus xml-Dateien ``@ContextConfiguration(locations = { "classpath:mymodule-context.xml" })``) nicht funktionieren.

### @SpringApplicationConfiguration

Diese Annotation wird eingesetzt, um die zu testenden Applikation zu initialisieren. Deshalb darf die SpringBoot-Main-Class nicht fehlen. Zudem werden evtl. noch ein paar Initializer für die Testumgebung aufgeführt (z. B. zur Initialisierung von Mocks).

Hier kann man auch Spring-Initialisierung über Spring-Kontexte in XML-Form anstoßen:

```java
@SpringApplicationConfiguration(
        classes = MySpringBootApplication.class,
        locations = { "classpath:test-context.xml" })
```

### @IntegrationTest

### @WebIntegrationTest

Handelt es sich um einen ``@IntegrationTest``, der auch eine ``@WebAppConfiguration`` benötigt, dann sollte man vermutlich ``@WebIntegrationTest`` verwenden. In einem WebIntegrationTest wird ein Applicationserver (Servlet-Container - per Default Toncat) gestartet

#### Applikationskonfiguration

Die Applikationskonfiguration wird aus der ``application.properties`` gezogen, kann aber über 

```java
@WebIntegrationTest({"server.port=0", "management.port=0"})
```

für jeden Test übersteuert werden.

##### Freien Port suchen

Es macht Sinn, einen freien (!!!) Port für zu startenden Applicationserver zu suchen:

```java
@WebIntegrationTest({"server.port=0", "management.port=0"})
```

und diesen Port dann per

```java
@Value("${local.server.port}")
int port;
```

zu injezieren.

### Rest-Tests

Das Testen von Rest-Schnittstellen läuft über ``TestRestTemplate``.

#### Vorsicht vor Test-Fakes

Da die Rest-Services ganz normale Java-Beans sind, läuft man Gefahr die Beans über Java-Aufrufe zu testen. Hierbei wird allerdings nicht die Funktionalität getestet, die ein RICHTIGER Applikationsclient verwendet. Beispielsweise wird das Marshalling/Unmarshalling nicht durchlaufen.

Diese Abkürzungen fangen am Anfang vielleicht gar nicht auf, doch spätestens, wenn beispielsweise auf ``HttpServletRequest`` im Rest-Service zugegriffen werden soll ... eine solche Instanz dann aber gar nicht existiert.

#### Option 1: TestRestTemplate

**Basic-Authentication:**

``new TestRestTemplate("username", "password")``

**MessageConverters:**

```java
restTemplate = new RestTemplate();
List<HttpMessageConverter<?>> list = new ArrayList<HttpMessageConverter<?>>();
list.add(new MappingJacksonHttpMessageConverter());
restTemplate.setMessageConverters(list);
```

**RestTemplate: postForObject vs. postForEntity**

Entity liefert nicht nur das eigentliche Result-Objekt des Webservice, sondern auch gleichzeitig Status-Code, ...

Empfehlung: verwende ``postForEntity``

**Beispiel:**

```java
RestTemplate restTemplate = new RestTemplate();

HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);

String requestInJsonFormat = 
    "{\"question\":\"What is your name?\"}";
HttpEntity<String> requestEntity = 
    new HttpEntity<String>(requestInJsonFormat, headers);
String answer =
    restTemplate.postForObject(
        "http://localhost/orakel",
        requestEntity,
        String.class);
```

#### Option 2: MockMvc

#### Option 3...n:

Irgendweinen anderen Http-Client verwenden.