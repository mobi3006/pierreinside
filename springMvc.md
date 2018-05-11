# Spring MVC

* Doku: http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

Spring MVC ist Request-Driven, d. h. ein Controller erhält Http-Requests (GET, POST), die er verarbeitet und zu guter Letzt eine Antwort in Form eines Views (= UI) sendet.

* http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

---

## Spring MVC Rest

[siehe eigenes Kapitel](springMvcRest.md)

Ein ``@RestController`` und ein ``@Controller`` (für UIs) sehen fast identisch aus. Während der RestController allerdings HttpResponses zurückliefert, liefert der Controller View-Identifier, über die dann eine HTML-Response gebaut und zum Client (= Browser) geliefert wird. 

Die Grenzen zwischen UI-Client und Rest-Client verschwimmen ... und das ist auch gut so.

---

## Spring MVC - View-Technologie

Spring MVC ist zunächst mal unabhängig von der konkret eingesetzten View-Technologie. Es bietet Adapter, um beispielsweise JSP oder [Thymeleaf](thymeleaf.md) zu verwenden. Hier findet man weitere Informationen:

* http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-viewresolver

### i18n - Internationalization

* https://justinrodenbostel.com/2014/05/13/part-4-internationalization-in-spring-boot/
* Gedanken von Mkkyong: https://www.mkyong.com/spring-mvc/spring-mvc-internationalization-example/

#### Locale-Resolver

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

#### LocaleContextHolder

Über

* ``LocaleContextHolder.getLocale()``
* ``LocaleContextHolder.getTimezone()``

lassen sich Informationen zum aktuellen Thread ermitteln. Dort steckt beispielsweise die Locale drin, die der konfigurierte LocaleResolver ermittelt hat.

#### LocaleChangeInterceptor

Hat man diesen Interceptor konfiguriert (

```java
@Configuration
@EnableAutoConfiguration
@ComponentScan
public class WebAppConfig extends WebMvcConfigurerAdapter {

    @Bean
    public LocaleChangeInterceptor myLocaleChangeInterceptor() {
        LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
        lci.setParamName("language");
        return lci;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(myLocaleChangeInterceptor());
    }

}
```

so läßt sich über http://localhost:8081/persondetails?language=de die Sprache auf deutsch umschalten.

#### Message-Resolver

Spring MVC kommt mit der in Spring Boot üblichen AutoConiguration (``org.springframework.boot.autoconfigure.MessageSourceAutoConfiguration``) daher. Diese Klasse offenbart, was man tun muß, um Texte/Labels/Messages zu internationalisieren ... Dateien der Art:

* ``src/main/resources/messages.properties``
* ``src/main/resources/messages_de.properties``
* ...

anlegen. Gemeinsam mit dem LocaleResolver (s. o.) wird zur Laufzeit der richtige Wert ausgelesen.

Sollen die Dateien in einem anderen Verzeichnis liegen, sollen es mehrere sein oder sollen sie einen anderen Namen haben, dann müssen die ``application.properties`` angepaßt werden:

```properties
spring.messages.basename=i18n/my_messages,i18n/your_messages
```

So läßt sich beispielsweise auch das Caching konfigurieren:

```properties
spring.messages.cacheSeconds = 1
```

### Caching

Die vom Server bereitgestellten Ressourcen (JavaScript, Images, ...) sollten clientseitig gecached werden. Hierzu bietet Spring die ``org.springframework.boot.autoconfigure.web.ResourceProperties`` an, in der sich viele interessante Schalter befinden

---

## Spring MVC - Controller und Model

Der Controller übernimmt die Seitensteuerung, d. h. die Controller-Methode liefert einen String als Rückgabewert, der die nachfolgende View-Page repräsentiert, z. B.

```java
return "login";
```

Je nach gewählter View-Technologie (z. B. [Thymeleaf](thymeleaf.md)) und deren Konfiguration wird dann beispielsweise eine Seite ``login.html`` gebaut (aus einem Template) und zum Client geschickt.

Hier kann aber beispielsweise auch ein Redirect-Request auf eine externe Seite getriggert werden:

```java
return "redirect:http://www.cachaca.de";
```

### Configuration

Wie üblich verwendet Spring einen annotationsbasierten Ansatz. Die Annotationen werden bei Anwendungsstart gescannt und dadurch die Applikation initialisiert. Handelt es sich um eine Spring Boot Applikation mit ``@EnableAutoConfiguration`` so sollte alles automatisch initialisiert werden. Ansonsten muß

```xml
<context:component-scan base-package="de.cachaca.myapp"/>
```

eingesetzt werden, um die Annotationen in den Initialisierungsfokus zu rücken.

### @Controller

* http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-controller

Kennzeichnet eine Klasse in der Rolle eines Controllers. Ein Controller erhält HTTP-Requests, z. B. aus Http-Post-Form-Requests. Spring MVC versucht, den Lücke zwischen textbasiertem HTTP und der Arbeit mit Java-Objekten im Controller so klein wie möglich erscheinen zu lassen. Hier muß sich niemand mehr um das Marshalling/Unmarshalling (aus HTTP-Stringwerten Java-Objekte machen) kümmern.

Ein Controller ist zudem für den Web-Flow zuständig und liefert deshalb den zu rendernden View im Return-Value. Diese Information wird vom konfigurierten ``ViewResolver`` (hier ist die Brücke zur UI-technologie) verwendet, um die HTML-Seite zu erzeugen. Siehe unten *Typkonvertierung*.

Einige der in diesem Kontext verwendeten Annotationen (z. B. ``@RequestMapping``) kommen auch beim [``@RestController`` zur Anwendung](springMvcRest.md).

> ACHTUNG: im Gegensatz zu JSF ist Spring MVC ein Controller-First-Ansatz (ähnlich wie JSP). JSF ist ein View-First-Ansatz, d. h. der Einstiegspunkt der View.

#### @RequestMapping

Hierüber werden die Controller-Actions deklariert:

```java
@RequestMapping(path = "/user")
public String getUser(){
    //...
}
```

Hierüber wird ein HTTP-Endpunkt, der dann über ``http://.../user`` auf **ALLE** HTTP-Methoden (GET, POST, PUT, ...) reagiert. Über ``method = RequestMethod.GET`` läßt sich das auf GET-Requests einschränken.

Solche Request-Mappings können relativ komplex werden, wenn beispielsweise ``@PathVariable`` verwendet werden ([ein Beispsiel von hier](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-requestmapping)):

```java
@RequestMapping(
  "/spring-web/
    {symbolicName:[a-z-]+}-
    {version:\\d\\.\\d\\.\\d}
    {extension:\\.[a-z]+}")
public void handle(
    @PathVariable String version,
    @PathVariable String extension) {
    // ...
}
```

Man kann auch Headerwerte zur Selektion der richtigen Controllermethode aufzunehmen.

#### @GetMapping

Ein typischer HTTP-GET ``@Controller``:

```java
@Controller
public class MyController {

  @RequestMapping(path = "/user", method = RequestMethod.GET)
  public String getUser(Model model) { // ... }
      model.addAttribute("user", new User());
      return "index";
  }
}
```

Mittlerweile gibt es auch spezialisierte RequestMappings: ``@GetMapping``, ...

```java
@Controller
public class MyController {

  @GetMapping(path = "/user")
  public String getUser(Model model) { // }
}
```

#### @PostMapping

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

#### @RequestMapping ... Parameter der Java-Methode

* Spring Doku: http://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-typeconversion

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

Ist keine automatische Konvertierung möglich, so könnte es zu einer ``org.springframework.web.method.annotation.MethodArgumentConversionNotSupportedException`` kommen. In solchen Fällen muß man im worst-case entsprechende ``Converter`` schreiben ([weitere Details](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/validation.html#core-convert)).

Tritt beim Unmarshalling ein Fehler auf, so wird das in ``BindingResult`` hinterlegt. Dieser Parameter sollte in keiner HTTP-POST, so daß  der 
Hier finden sich weitere Informationen zur Typ-Konvertierung:

* http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-typeconversion

Mit JAXB kann die Typ-Konvertierung unterstützt werden.

**Semantische Prüfungen:**

Neben diesen syntaktischen Typ-Prüfungen (ein String muß in ein ``java.util.Date`` konvertierbar sein) können weitere semantische Prüfungen sinnvoll sein. Diese können über [Java Bean Validation](java_beanValidation.md) mit ``@Valid`` sehr schön integriert werden:

```java
@ValidUsername
@Size(min=8, max=12)
private String username;

public String sayHello(
   ModelMap m,
   @Valid Person p,
   BindingResult r) {
  // ...
}
```

Die Fehlermeldungen können über den üblichen i18n-Mechanismus (e. g. ``messages.properties``) konfiguriert werden. Allerdings muß dann folgende Konfiguration durchgeführt werden:

```java
public class MvcConfig extends WebMvcConfigurerAdapter {

    @Autowired
    private MessageSource messageSource;

    @Override
    public Validator getValidator() {
        LocalValidatorFactoryBean factory = new LocalValidatorFactoryBean();
        factory.setValidationMessageSource(messageSource);
        return factory;
    }
}
```

#### HttpServletRequest

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

#### AOP-Proxying

Will man im Controller Transaktionen deklarieren (``@Transactional``), so kann man *Class-Based Proxying* verwenden. Das wird im Spring-Context beispielweise über

```xml
<tx:annotation-driven proxy-target-class="true"/>
```

konfiguriert.

#### @RequestBody

Mit dieser Annotation kann man den HTTP-Body (z. B. eines HTTP-POST) in einen Parameter injecten lassen:

```java
public void registerUser(@RequestBody String body) {}
```

Der gelieferte String kann über [HTTP Message Conversion](http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/remoting.html#rest-message-conversion) verarbeitet werden. Bei folgender Schnittstelle geschieht das automatisch ... das entsprechende Marshalling vorausgesetzt (z. B. über JSON-Jackson oder JAXB):

```java
public void registerUser(@RequestBody UserCredential c) {}
```

#### @ResponseBody

Mit dieser Annotation wird das Ergebnis einer Controller-Methode an den HTTP-Response-Body gebunden:

```java
public @ResponseBody User getUser(String username) {}
```

## Spring (Boot) Security

* [Web-Applikationen absichern - Tutorial von spring.io](https://spring.io/guides/gs/securing-web/)
* [Spring-Boot-Security - basierend auf Spring Security](https://docs.spring.io/spring-boot/docs/2.0.1.RELEASE/reference/htmlsingle/#boot-features-security)
* [Spring-Security](https://projects.spring.io/spring-security/)

Zur Absicherung der HTTP-Schnittstellen stellt Spring bereits eine Auto-Configuration bereit, sofern man die Abhängigkeit

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

in der `pom.xml` eingetragen hat. Die Auto-Konfiguration sichert ALLE Http-Endpunkte per Default über HTTP-Basic-Authentication ab (hier zeigt der Browser ein Popup) - über einen `WebSecurityConfigurerAdapter` läßt sich die Konfiguration entsprechend anpassen, so daß einige Endpunkte auch public sind (keiner Authentifizierung bedürfen) oder beispielsweise auch Form-Authentication (mit entsprechendem Layout) ermöglicht wird.