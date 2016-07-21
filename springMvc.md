# Spring MVC
* Doku: http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

Spring MVC ist Request-Driven, d. h. ein Controller erhält Http-Requests (GET, POST), die er verarbeitet und zu guter Letzt eine Antwort in Form eines Views (= UI) sendet. 

* http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

---

# Spring MVC Rest
[siehe eigenes Kapitel](springMvcRest.md)

Frage: Wie stehen ``@Controller`` und ``@RestController`` zueinander ... die Grenzen zwischen UI-Client und Maschine-Client (= Rest-Client) verschwimmen irgendwie ...

---

# Spring MVC - View-Technologie
Spring MVC ist zunächst mal unabhängig von der konkret eingesetzten View-Technologie. Es bietet Adapter, um beispielsweise JSP oder [Thymeleaf](thymeleaf.md) zu verwenden. Hier findet man weitere Informationen:

* http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-viewresolver

## i18n - Internationalization
* Gedanken von Mkkyong: https://www.mkyong.com/spring-mvc/spring-mvc-internationalization-example/

### Locale-Resolver
Per Default verwendet Spring MVC den ``org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver``, so daß die Sprache aus dem Accept-Header gewählt wird. Diese Sprache ist die Sprache, die im Browser eingestellt ist. Da dort mehrere Sprachen eingestellt sein können, wird die erste genommen (= man unterstellt, daß das die bevorzugte Sprache ist).

Will man seine eigene Logik verwenden, so muß man nur einen eigenen ``MyLocaleResolver`` schreiben und als Bean konfigurieren:

```java
public class MyLocaleResolver extends AcceptHeaderLocaleResolver {

    @Override
    public Locale resolveLocale(HttpServletRequest r) {
      // ... your implementation
    }
}
```

Dadurch wird dieser ``MyLocaleResolver`` automatisch eingebunden, wenn ich beispielsweise in einem Controller die Locale injecten lasse:

```java
@RequestMapping(path = "/doit"
public String doIt(@Valid User user,
        BindingResult bindingResult, Model model, Locale language);
```

### Message-Resolver
Spring MVC kommt mit der in Spring Boot üblichen AutoConiguration (``org.springframework.boot.autoconfigure.MessageSourceAutoConfiguration``) daher. Diese Klasse offenbart, was man tun muß, um Texte/Labels/Messages zu internationalisieren ... Dateien der Art:

* ``src/main/resources/messages.properties``
* ``src/main/resources/messages_de.properties``
* ...

anlegen. Gemeinsam mit dem LocaleResolver (s. o.) wird zur Laufzeit der richtige Wert ausgelesen. 

Sollen die Dateien in einem anderen Verzeichnis liegen, sollen es mehrere sein oder sollen sie einen anderen Namen haben, dann müssen die ``application.properties`` angepaßt werden:

```
spring.messages.basename=i18n/my_messages,i18n/your_messages
```

So läßt sich beispielsweise auch das Caching konfigurieren:

```
spring.messages.cacheSeconds = 1 
```

---

# Spring MVC - Controller und Model

## Configuration
Wie üblich verwendet Spring einen annotationsbasierten Ansatz. Die Annotationen werden bei Anwendungsstart gescannt und dadurch die Applikation initialisiert. Handelt es sich um eine Spring Boot Applikation mit ``@EnableAutoConfiguration`` so sollte alles automatisch initialisiert werden. Ansonsten muß 

```xml
<context:component-scan base-package="de.cachaca.myapp"/>
```

eingesetzt werden, um die Annotationen in den Initialisierungsfokus zu rücken.


## @Controller
* http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-controller

Kennzeichnet eine Klasse in der Rolle eines Controllers. Ein Controller erhält HTTP-Requests, z. B. aus Http-Post-Form-Requests. Spring MVC versucht, den Lücke zwischen textbasiertem HTTP und der Arbeit mit Java-Objekten im Controller so klein wie möglich erscheinen zu lassen. Hier muß sich niemand mehr um das Marshalling/Unmarshalling (aus HTTP-Stringwerten Java-Objekte machen) kümmern.

Ein Controller ist zudem für den Web-Flow zuständig und liefert deshalb den zu rendernden View im Return-Value. Diese Information wird vom konfigurierten ``ViewResolver`` (hier ist die Brücke zur UI-technologie) verwendet, um die HTML-Seite zu erzeugen. Siehe unten *Typkonvertierung*.

Einige der in diesem Kontext verwendeten Annotationen (z. B. ``@RequestMapping``) kommen auch beim [``@RestController`` zur Anwendung](springMvcRest.md).

> ACHTUNG: im Gegensatz zu JSF ist Spring MVC ein Controller-First-Ansatz (ähnlich wie JSP). JSF ist ein View-First-Ansatz.

### GET-Controller
Ein typischer HTTP-GET ``@Controller``:

```java
@Controller
public class MyController {

  @RequestMapping(path = "/user", method = RequestMethod.GET)
  public String getUser(Model model) {
      model.addAttribute("user", new User());
      return "index";
  }
}
```

### POST-Controller
Ein typischer HTTP-POST-Controller:

```java
@Controller
public class WebPatientRegistrationController {

  @RequestMapping(path = "/register", method = RequestMethod.POST)
  public String register(String username, String emailaddress
          BindingResult bindingResult, Model model) { 
    return "redirect:/registerVerify";
  }
}
```

Spring übernimmt das Mapping der einfachen HTTP-String-Attribute in Java-Objekte.

### @RequestMapping
Mittlerweile gibt es auch spezialisierte RequestMappings: ``@GetMapping``, ...

Solche Request-Mappings können relativ komplex werden, wenn beispielsweise ``@PathVariable`` verwendet werden ([ein Beispsiel von hier](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-requestmapping)):

```java
@RequestMapping(
  "/spring-web/
    {symbolicName:[a-z-]+}-
    {version:\\d\\.\\d\\.\\d}
    {extension:\\.[a-z]+}")
public void handle(@PathVariable String version, @PathVariable String extension) {
    // ...
}
```

Man kann auch Headerwerte zur Selektion der richtigen Controllermethode aufzunehmen.

### @RequestMapping ... Parameter der Java-Methode

**Default-Methoden-Parameter:**

Man kann in eine Controller-Methode die folgenden Parameter aufnehmen und bekommt sie richtig injeziert:

* ``BindingResult``
* ``Model``
* ``Locale`` - die im Browser eingestellte Sprache (kommt über den HTTP Accept-Language Header)

**Methoden-Parameter:**

Dieser Link beschreibt die Regeln für die Java-Methode, die an einem ``@RequestMapping`` hängt:

* http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-methods

**Typ-Konvertierung:**

Im HTTP-Request sind nun Strings enthalten, in den Controller-Methoden arbeitet man häufig aber mit komplexeren Java-Klassen. Hierfür gibt es bereits häufig automatische Konvertierungen, häufig wird aber auch JAXB verwendet.

Tritt beim Unmarshalling ein Fehler auf, so wird das in ``BindingResult`` hinterlegt. Dieser Parameter sollte in keiner HTTP-POST, so daß  der 
Hier finden sich weitere Informationen zur Typ-Konvertierung:

* http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-typeconversion

Mit JAXB kann die Typ-Konvertierung unterstützt werden.

**Semantische Prüfungen:**

Neben diesen syntaktischen Typ-Prüfungen (ein String muß in ein ``java.util.Date`` konvertierbar sein) können weitere semantische Prüfungen sinnvoll sein. Diese können über [Java Bean Validation](java_beanValidation.md) mit ``@Valid`` sehr schön integriert werden:

```java
public String sayHello(
   ModelMap m, 
   @Valid Person p, 
   BindingResult r) {
  // ...
}
```

### HttpServletRequest
Wie kommt man an den ``HttpServletRequest`` im Controller?

**Option 3:**

```java
HttpServletRequest request = 
  ((ServletRequestAttributes)
    RequestContextHolder.currentRequestAttributes())
      .getRequest();
```

Hierzu braucht es aber noch einen 

```java
@Bean 
public RequestContextListener requestContextListener(){
    return new RequestContextListener();
}     
```


### AOP-Proxying
Will man im Controller Transaktionen deklarieren (``@Transactional``), so kann man *Class-Based Proxying* verwenden. Das wird im Spring-Context beispielweise über

```xml
<tx:annotation-driven proxy-target-class="true"/>
```

konfiguriert.

### @RequestBody
Mit dieser Annotation kann man den HTTP-Body (z. B. eines HTTP-POST) in einen Parameter injecten lassen:

```java
public void registerUser(@RequestBody String body) {}
```

Der gelieferte String kann über [HTTP Message Conversion](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/remoting.html#rest-message-conversion) verarbeitet werden. Bei folgender Schnittstelle geschieht das automatisch ... das entsprechende Marshalling vorausgesetzt (z. B. über JSON-Jackson oder JAXB):

```java
public void registerUser(@RequestBody UserCredential c) {}
```

### @ResponseBody
Mit dieser Annotation wird das Ergebnis einer Controller-Methode an den HTTP-Response-Body gebunden:

```java
public @ResponseBody User getUser(String username) {}
```

