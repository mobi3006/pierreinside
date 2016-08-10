# Thymeleaf
Ich hatte bisher mit Velocity-Templating und JSPs gearbeitet. Im Zuge der Nutzung von Spring MVC/Boot haben wir Thymeleaf für ein HTML-Frontend genutzt und damit auch Email-Templates umgesetzt.

[Spring MVC](springMvc.md) ist grundsätzlich unabhängig von der View-Technologie. Es sieht aber explizit die Nutzung von Thymeleaf für diese Aufgabe vor, was man schon daran sieht, daß Spring in den Parent-Poms als Dependency enthalten ist.

> **DISCLAIMER:** Ich habe Thymeleaf in einer Spring-Boot-Applikation kennengelernt ... deshalb sind die Aussagen auf diesen Use-Case bezogen. In anderen Kontexten ist es möglicherweise anders.

---

# Spring-Petclinic mit Thymeleaf
* https://github.com/thymeleaf/thymeleafexamples-petclinic

Hier findet man Best-Practices für die Thymeleaf-Nutzung.

---

# Version 2 vs. 3
* http://www.thymeleaf.org/doc/articles/thymeleaf3migration.html

---

# Getting Started
Dieses Template

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
  <head>
    <title>My first Thymeleaf Template</title>
  </head>
  <body>
    <p th:text="#{home.welcome}">Welcome to my App</p>
  </body>
</html>
```

sorgt für die Ausgabe 

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
  <head>
    <title>My first Thymeleaf Template</title>
  </head>
  <body>
    <p>Willkommen bei Pierre</p>
  </body>
</html>
```

wennn zur Laufzeit diese ``message.properties``  verwendet wird:

    home.welcome=Willkommen bei Pierre

Wird diese Datei einfach so im Browser angezeigt, dann wird daraus (sie *Natural Templating* Idee)

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
  <head>
    <title>My first Thymeleaf Template</title>
  </head>
  <body>
    <p>Welcome to my App</p>
  </body>
</html>
```

> Am Anfang hatte ich nicht genau hingeschaut und ``th:text`` für ein Table-Header Element gehalten. Hier gehört das aber zum Namespace http://www.thymeleaf.org und wird dementsprechend von der Thymeleaf-Template-Engine interpretiert.

Hier die Thymeleaf-DSL:
* http://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html#attribute-precedence


---

# Thymeleaf als UI Technologie
* DSL-Sprachelemente: http://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html
* Ein praktisches Beispiel: http://spr.com/part-2-adding-views-using-thymeleaf-and-jsp-if-you-want/

## JSP-Alternative
JSP ist ein Generator für HTML ... Thymeleaf ist ein Generator für HTML. 

Thymeleaf wird im [Getting Started ... Serving Web Content with Spring MVC](http://spring.io/guides/gs/serving-web-content/) von Spring als View-Technologie vorgestellt. [SpringRoo](http://projects.spring.io/spring-roo/) verwendet Thymeleaf beispielsweise als Default-UI-Technologie.

### JSF-Alternative?
JSF definiert einen Lifecycle und ist insofern deutlich komplexer. Zudem hat JSF einen View-First-Ansatz ... im Gegensatz zum Controller-First-Ansatz von JSP/Thymeleaf.

## Thymeleaf-DSL = Dialekt
Thymeleaf arbeitet mit dem Konzept *Dialekt*. Ein Dialekt ist die DSL, die vom Thymeleaf ViewResolver interpretiert wird, um aus den Templates (in den die Dialekte verwendet werden) fertige Artefakte (z. B. HTML-Seiten) zu machen. Thymeleaf bringt folgende Dialekte mit:

* ``org.thymeleaf.spring4.dialect.SpringStandardDialect``
* ``org.thymeleaf.extras.springsecurity4.dialect.SpringSecurityDialect``
* ``nz.net.ultraq.thymeleaf.LayoutDialect``

Siehe *Getting Started ...* für ein Beispiel.

### SpringStandardDialect
Dieser Dialekt ermöglicht eine möglichst nahtlose Integration der Thymeleaf-View-Technologie mit einem Spring-Backend. Auf diese Weise wird es möglich, in Thymeleaf-Templates Spring-Komponenten über Spring Expression Language einzubetten, um so

* Daten bereitzustellen
* Berechnungen/Formatierungen durchzuführen
* Spring-Controller mit der Verarbeitung HTTP-Requests (POST/GET) zu beauftragen (``th:action``, ``th:object``)

## Natural Templating Ansatz
* http://www.thymeleaf.org/doc/tutorials/2.1/thymeleafspring.html#its-still-a-prototype

Verwendet man JSF als UI-Technologie, so können die JSF-Seiten (haben beispielsweise die Dateiendung ``*.xhtml``) im Browser ohne die dahinterliegende Applikation nicht vernünftig dargestellt werden, weil die Platzhalter nicht ersetzt sind.

Thymeleaf adressiert dieses Problem mit dem sog. Natural Templating Ansatz, so daß Thymeleaf-Templates im Browser auch ohne Ersetzung der Platzhalter vernünftig dargestellt werden. Auf diese Weise können Contentersteller und Entwickler an dem gleichen Artefakt arbeiten noch bevor an eine lauffähige Version überhaupt zu denken ist.

Hierzu werden sog. Prototypen verwendet:

```html
<p th:text="#{home.welcome}">Willkommen zuhause</p>
```

In diesem Beispiel ist *Willkommen zuhause* ein Prototype (= Mock), der zur Laufzeit durch den Thymeleaf-Templating-Mechanismus ersetzt wird (der tatsächliche Wert kommt aus ``#{home.welcome}``).

### Dynamische Tabellen
Manchmal kommt es vor, daß man ohne Laufzeitumgebung gar keine Informationen bekäme. Bei dynamisch generierten Tabellen ist das beispielsweise der Fall. Hier kann man dann eine/mehrere Zeilen per ``th:remove="all"`` als Prototyp kennzeichnen. Diese Zeile(n) werden zur Laufzeit nicht dargestellt.

### Links über ``href``
Bei ``href`` zeigt der Natural Templating Ansatz seine Stärke:

```xml
<a href="details.html" 
   th:href="@{http://localhost:8080/gtvg/order/details(orderId=${o.id})}">view</a>
```

Dieser Link ist auch ohne Runtime-Engine - allein durch Öffnen der Seite im Browser - immer noch navigierbar, d. h. man kommt damit zur ``details.html`` und profitiert dort wieder vom Natural Templating.

Der produktive Code ist somit gleichzeitig ein Mock.

### ... vs. Inlining
Man kann statt der ``th:foo`` Attribute die Expression-Language auch inline verwenden. In Ausnahmefällen ist das auch tatsächlich erforderlich (wenn das Template kein XML-Format ist) ... siehe unten Plaintext-Emails. 

Statt

```xml
<p>Hello, <span th:text="${session.user.name}">Sebastian</span>!</p>
```

kann mit Inlining das geschrieben werden:

```xml
<body th:inline="text">
  ...
  <p>Hello, [[${session.user.name}]]!</p>
  ...
</body>
```

**Nachteil:** Man verliert dadurch aber das Natural Templating, d. h. im Browser ohne laufende Templating-Engine wird diese Seite nicht sinnvoll dargestellt.

**Achtung:** In Thymeleaf 3 braucht man ``th:inline="text"`` nicht mehr ... es wird sogar empfohlen, es wegzulassen

## Expression Language
* http://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html#standard-expression-syntax

> **ACHTUNG:** es werden verschiedene Symbole verwendet ... je nach Content: ``#{}``, ``${}``, ``*{}``, ``@{}``

Über die Expression Language 
* erfolgt die Verknüpfung von statischem Content (aka *Templates*) und dynamischen Daten. Hier beispielsweise der Zugriff auf eine Spring-Bean:

```xml
<p th:text="${user.name}">Welcome home</p>
```    

* erfolgt Internationalisierung - Einbettung von Message-Properties via 

```xml
<p th:text="#{home.welcome}">Welcome home</p>
```

### Bewertung
Ich empfand die Expression Language als gewöhnungsbedürftig. Das ist syntaktisch falsch

```html
<div th:text="#{label.pin}: ${pin}" th:remove="tag">
  PIN: 4711
</div>
```

Stattdessen schreibt man

```html
<div th:text="#{label.pin} + ': ' + ${pin}" th:remove="tag">
  PIN: 4711
</div>
```

kann aber auch das schreiben: 

```html
<div th:text="|#{label.pin}: ${pin}|" th:remove="tag">
  PIN: 4711
</div>
```

## Spring MVC + Thymeleaf
* http://www.thymeleaf.org/doc/tutorials/2.1/thymeleafspring.html
* [Komplexeres Beispiel](https://github.com/thymeleaf/thymeleafexamples-stsm)

### Konfiguration
Thymeleaf bringt eine Auto-Konfiguration mit, die in einer Spring Boot Applikation auch automatisch gezogen wird. Man findet diese Auto-Konfiguration in der Klasse [``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration``](https://github.com/spring-projects/spring-boot/blob/v1.3.6.RELEASE/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/thymeleaf/ThymeleafAutoConfiguration.java).

Thymeleaf verwendet den Standard Spring Boot Mechanismus, d. h. man findet die Konfigurationsparameter in [``ThymeleafProperties``](https://github.com/spring-projects/spring-boot/blob/v1.3.6.RELEASE/spring-boot-autoconfigure/src/main/java/org/springframework/boot/autoconfigure/thymeleaf/ThymeleafProperties.java). Darin zeigt sich beispielsweise 

```java
@ConfigurationProperties("spring.thymeleaf")
public class ThymeleafProperties {
	public static final String DEFAULT_PREFIX = "classpath:/templates/";
	private String prefix = DEFAULT_PREFIX;
}
```

daß Templates per Default in ``classpath:/templates/`` gesucht werden und daß man über das Property ``spring.thymeleaf.prefix`` (bei einer Spring Boot Anwendung gesetzt in ``application.properties``) diese Einstellung überschreiben kann. Diese Information findet man übrigens nicht nur im Source-Code, sondern auch in der Spring-Dokumentation:

* http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties

Größere Anpassungen von Thymeleaf können über Spring-Annotationen erfolgen (hier in einer Spring Boot Applikation):

```java
@Configuration
@EnableConfigurationProperties(ThymeleafProperties.class)
@ConditionalOnClass(SpringTemplateEngine.class)
@AutoConfigureAfter(WebMvcAutoConfiguration.class)
public class ThymeleafConfiguration 
  extends WebMvcConfigurerAdapter implements ApplicationContextAware {

    private ApplicationContext applicationContext;

    @Autowired
    ThymeleafProperties properties;

    public void setApplicationContext(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    @Bean
    public TemplateEngine templateEngine() {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.addTemplateResolver(htmlTemplateResolver());
        engine.addTemplateResolver(textTemplateResolver());
        return engine;
    }

    private ITemplateResolver htmlTemplateResolver() {
        ClassLoaderTemplateResolver templateResolver = new ClassLoaderTemplateResolver();
        templateResolver.setPrefix("templates");
        templateResolver.setSuffix(".html");
        templateResolver.setTemplateMode("HTML5");
        return templateResolver;
    }    
}
```

Hier ist ein Weg über XML-Dateien beschrieben:

* http://www.thymeleaf.org/doc/tutorials/2.1/thymeleafspring.html#spring-mvc-configuration

Hat man eine Spring Boot Applikation, so ist Thymleaf über ``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration.java`` bereits auto-konfiguriert. Will man dann seine eigene ``ThymeleafConfiguration`` (siehe oben) einschieben, so muß man die Auto-Konfiguration folgendermaßen rauskonfigurieren:

```java
@SpringBootApplication(
  exclude={
    org.springframework.boot.autoconfigure
      .thymeleaf.ThymeleafAutoConfiguration.class})
public class MyApplication { // ...}
```

### i18n - Internationalisierung
Per Default verwendet Thymeleaf in einer Spring-Boot Anwendnung den ``org.thymeleaf.spring4.messageresolver.SpringMessageResolver``, um den Key ``title.homepage`` 

```html
<title th:text="#{title.homepage}">hier werden sie geholfen</title>
```

zu internationalisieren.

Der Thymeleaf-``SpringMessageResolver`` verwendet den Spring-``MessageSource``-Ansatz, d. h. defaultmässig wird eine Datei ``messages.properties`` auf dem Classpath gesucht. Will man das Umkonfigurieren, dann hilft ein Blick in ``MessageSourceAutoConfiguration``. 

---

# Localized Templates
Häufig haben Seiten einen hohen statischen Anteil und nur einen geringen dynamischen, der dann häufig auch sprachunabhängig ist. Insofern würde es Sinn machen, für jede Sprache eine eigene Datei zu verwenden - anstatt die Datei aus übersetzbaren Message-Properties zusammenzusetzen.

* https://github.com/thymeleaf/thymeleaf/issues/497

Bis Thymeleaf  

---

# Erweiterbarkeit
* http://www.thymeleaf.org/doc/articles/sayhelloextendingthymeleaf5minutes.html
* http://www.thymeleaf.org/doc/articles/sayhelloagainextendingthymeleafevenmore5minutes.html

Thymeleaf kann um eigene Dialekte erweitert werden, um so eine eigene DSL zu schaffen.

# Spring Boot Integration
* http://www.thymeleaf.org/doc/tutorials/2.1/thymeleafspring.html

Thymeleaf wird in [Spring Boot](springBoot.md) direkt supported (Bestandteil der Starter-Pakete). Es ist leicht möglich - ähnlich wie in JSF - Werte über Beans bereitzustellen, um so beispielsweise den Content einer HTML-Seite dynamisch zusammenzubauen.

## Thymeleaf 3 - Spring Boot 1.3
Hiermit gibts Probleme:

* https://github.com/spring-projects/spring-boot/issues/4393

---

# Plain-Text-Emails
> DISCLAIMER: Thymeleaf hat sich - [laut eigener Aussage in den FAQ](http://www.thymeleaf.org/faq.html#compare-other-engines) - auf XML/HTML-Content spezialisiert.

> HINWEIS: in der Version 3.x wird aber auch explizit nicht-XML-Inhalt unterstützt ... beispielsweise Plain-Text-Emails.

Bei GitHub findet man dieses Beispiel:

* https://github.com/thymeleaf/thymeleafexamples-springmail

## ... mit Thymeleaf 2
Thymeleaf 2 ist stark auf die Verwendung von XML/HTML zugeschnitten ist. Bei Plain-Text gibt es aber keine Elemente, an die sich die Thymeleaf-DSL andocken kann. Stattdessen kann [*Text inlining*](http://www.thymeleaf.org/doc/tutorials/2.1/usingthymeleaf.html#text-inlining) verwendet werden, um zu ersetzende Elemente zu referenzieren. Dieser Ansatz läuft dem *Natural Templating* zuwider, weil die Platzhalter eben nicht durch Prototypen ersetzt sind. Deshalb sollte *Inlining* nur im äußersten Notfall eingesetzt werden.

Das Inlining muß aber engekündigt werden ... aber auch die Ankündigung muß an einem Element hängen, z. B. an ``<html>``. Damit dieses notwendige Element nicht sichtbar wird (wir wollen ja kein ``<html>`` in den Nutzdaten haben), können wir uns eines ``th:remove="tag"`` bedienen, das eigentlich für den Natural-Templating-Ansatz (siehe oben) vorhanden ist. Irgendwie schon sehr tricky ...

In diesem Template (``emailplain.html``) wird ``[[${name}]]``

```html
<html th:inline="text" th:remove="tag">
  Hello [[${name}]],
  cheers
</html>
```

bei diesem Code

```java
Context ctx = new Context(Locale.US);
ctx.setVariable("name", "Pierre");
templateEngine.process("emailplain", ctx);    
```

ersetzt durch ``Pierre``, so daß dieses Endergebnis zu erwarten ist: 

    Hello Pierre,
    cheers.

... schon tricky wie sich das künstliche ``html``-Element durch ``th:remove="tag"`` selbst entfernt.
