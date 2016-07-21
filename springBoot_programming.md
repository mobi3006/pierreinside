# Spring Boot Programming
Spring-Boot verwendet - Spring-typisch ([siehe auch Spring-Core](springCore.md))  - Java-Annotation en-masse, um den ApplicationContext aufzubauen. Sie werden verwendet, um die Springinitialisierung durch den Spring-Boot-Loader zu ermöglichen. Beispiele:

* ``@SpringBootApplication``
* ``@EnableAutoConfiguration``
* ...

Zudem erhöht diese Vorgehensweise die Semantik der Klassen, so daß der Leser ein besseres Verständnis erhält (das ist aus meiner Sicht bei einer Trennung von Java-Code und XML-Code immer ein Problem gewesen).

> i. a. gibt es xml-basierte Alternativen zur Annotation aber die Spring-Macher empfehlen die Verwendung von Annotationen).

---

# Steuerung der Spring-Initialisierung

* http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#using-boot-locating-the-main-class

## @SpringBootApplication
Convenience Annotation ... subsumiert die empfohlenen Annotationen 

* ``@EnableAutoConfiguration``
* ``@Configuration``
* ``@ComponentScan``

## @EnableAutoConfiguration
Ist diese Eigenschaft gesetzt, so versucht Spring sich die Spring-Konfiguration der Anwendung selbst zu erschließen. Da das DER Konfigurationsmechanismus von SpringBoot ist, sind zumindest alle Komponenten, die von Spring Boot direkt unterstützt werden mit einer ``*AutoConfiguration``-Klasse ausgestattet, z. B. 

* ActiveMQAutoConfiguration
* CacheAutoConfiguration
* CassandraAutoConfiguration
* CloudAutoConfiguration
* ConsulAutoConfiguration
* ElasticSearchAutoConfiguration
* FacebookAutoConfiguration
* FlywayAutoConfiguration
* JpaRepositoriesAutoConfiguration
* MailSenderAutoConfiguration
* ...

In diesen ``*AutoConfiguration``-Klassen werden die entsprechenden Properties aus  ``application.properties`` gezogen, so daß die Komponenten weitestgehend über einache Properties anpassbar sind und keine spezielle Spring-Konfiguration erfordern. 

Hierin steckt schon eine Menge Magie ...

> Wenn eine JPA Dependency definiert ist und EnableAutoConfiguration gesetzt ist, dann sucht der Spring Boot (der Loader) nach entsprechenden ``@Entity`` Anntotaionen im Code

... solange das zuverlässig und intuitiv funktioniert ist alles gut ;-)

### Wie ist die Magie umgesetzt?

Als ich mich der [Thymeleaf-Technologie (Bestandteil von Spring Boot)](thymeleaf.md) näherte, tat ich das an einer bereits existierenden Anwendnung. Die lief und ich wollte nun rausfinden wo ich denn nun meine Templates hinlegen soll. Ich fand im Code keine Konfiguration und in der umfassenden Dokumentation fand ich auch keine Hinweise. Erst über Umwege fand ich die Information, daß das über die automatisch gezogene ``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration`` erfolgte.

Thymeleaf liefert folgende Klasse:

```java
@Configuration
@EnableConfigurationProperties(ThymeleafProperties.class)
@ConditionalOnClass(SpringTemplateEngine.class)
@AutoConfigureAfter(WebMvcAutoConfiguration.class)
public class ThymeleafAutoConfiguration {

	@Configuration
	@ConditionalOnMissingBean(name = "defaultTemplateResolver")    // <--- ACHTUNG A
	public static class DefaultTemplateResolverConfiguration { ... }
    
		@Autowired
		private ThymeleafProperties properties;                   // <--- ACHTUNG B1
    
		@Bean
		public TemplateResolver defaultTemplateResolver() {
			TemplateResolver resolver = new TemplateResolver();
			resolver.setResourceResolver(thymeleafResourceResolver());
			resolver.setPrefix(this.properties.getPrefix());      // <--- ACHTUNG B2
			resolver.setSuffix(this.properties.getSuffix());
			resolver.setTemplateMode(this.properties.getMode());
			if (this.properties.getEncoding() != null) {
				resolver.setCharacterEncoding(
                  this.properties.getEncoding().name());
			}
			resolver.setCacheable(this.properties.isCache());
			Integer order = this.properties.getTemplateResolverOrder();
			if (order != null) {
				resolver.setOrder(order);
			}
			return resolver;
		}
	}
    
	@Configuration
	@ConditionalOnMissingBean(SpringTemplateEngine.class)         // <--- ACHTUNG C
	protected static class ThymeleafDefaultConfiguration {

		@Autowired
		private final Collection<ITemplateResolver> templateResolvers = 
          Collections.emptySet();

		@Autowired(required = false)
		private final Collection<IDialect> dialects = 
          Collections.emptySet();

		@Bean
		public SpringTemplateEngine templateEngine() {
			SpringTemplateEngine engine = new SpringTemplateEngine();
			for (ITemplateResolver templateResolver : this.templateResolvers) {
				engine.addTemplateResolver(templateResolver);
			}
			for (IDialect dialect : this.dialects) {
				engine.addDialect(dialect);
			}
			return engine;
		}
	}
}
```

Diese Klasse ist ein Musterbeispiel dafür wie die AutoConfiguration bei Spring Boot läuft:

* **ACHTUNG A:** Die Auto-Konfiguration ist als Fall-Back gedacht ... indem ich in meiner Anwendnung eine eigene Bean mit dem Namen ``defaultTemplateResolver`` definiere, hebel ich die AutoConfiguration aus.
* **ACHTUNG B1/B2:** die ``ThymeleafProperties`` werden in der default-Konfiguration berücksichtigt, die beispielsweise aus den ``application.properties`` gefüttert werden.
* **ACHTUNG C:** wie bei A nur auf Class-Level

### Auto-Configuration gezielt komplett abschalten/überschreiben

Über Excludes lassen sich einzelne Ressourcen von der Auto-Configuration ausschließen:

```java
@EnableAutoConfiguration(
  exclude={org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration.class})
```
      
Häufig will man die Komponente dann aber dennoch nutzen, dann muß man eine eigene Configuration beisteuern. Hier kann man sich aber immer an der entsprechenden AutoConfiguration-Klasse orientieren.

### Auto Configuration Report

Durch den Start der Anwendung per ``--debug`` Option (``java -jar myapp.jar --debug``) wird ein sog. Auto-Configuration Report ausgegeben:


    =========================
    AUTO-CONFIGURATION REPORT
    =========================
    

    Positive matches:
    -----------------

     AuditAutoConfiguration.AuditEventRepositoryConfiguration matched
        - @ConditionalOnMissingBean (types:
              org.springframework.boot.actuate.audit.AuditEventRepository;
              SearchStrategy: all) found no beans (OnBeanCondition)
    ... blablabla ...
    
Dieser Report kann sehr hilfreich sein, wenn man der Spring-Magie auf die SChliche kommen will.

### Fazit AutoConfiguration
Ich halte diese Form der Konfiguration für vorbildlich und werde es für meine eigenen Komponenten genauso umsetzen. In manchen IDEs kann man sogar Auto-Vervollständigung auf den Properties bekommen.

Ein Anpassung des Verhaltens einer Komponente ist folgendermaßen möglich (die häufigste zuerst genannt):

1. in ``application.properties`` die entsprechenden ``ConfigurationProperties`` überschreiben - hierzu am beste Doku lesen oder die entsprechende ``ConfigurationProperties`` Klasse ausfindig machen (z. B. ``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafProperties``)
2. in der eigenen Anwendung Beans instanziieren, die die Default-Konfiguration übersteuern - hierzu am beste Doku lesen oder die entsprechende AutoConfiguration-Klasse ausfindig machen (z. B. ``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration``)
3. AutoConfiguration einer Komponente komplett deaktivieren und eine eigene Konfiguration in der Anwendung bereitstellen - hierzu am beste Doku lesen oder die entsprechende AutoConfiguration-Klasse ausfindig machen (z. B. ``org.springframework.boot.autoconfigure.thymeleaf.ThymeleafAutoConfiguration``) und als Muster verwenden
  * ACHTUNG: das sollte immer nur die letzte Möglichkeit sein, denn dadurch beraubt man sich evtl. der Forward-Kompatibilität, d. h. bei neuen Versionen ist der Code evtl. nicht mehr lauffähig

## Konfiguration von Applikationseigenschaften
* Spring Referenzdokumentation: http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config
* https://blog.codecentric.de/2016/04/binding-configuration-javabeans-spring-boot/

### Konfigurationseinstellungen im Applikationscode nutzen
Hier unterstützt Spring diese Ansätze

* Property Injection mit Spring-EL
* Type-safe @ConfigurationProperties
* Spring-Cloud-Config

### spring.config.location
Über das Property ``spring.config.location`` können Dateien definiert werden, in der die Property-Werte gesetzt werden (es kann eine Übersteuerung erfolgen). Das ist sehr praktisch, wenn man die Anwendnung in einem anderen Environment laufen lassen möchte (statt in der Developer-Umgebung in der Staging-Umgebung):

```bash
java 
  -jar myapp.jar 
  --spring.config.location=
      classpath:/default.properties,
      classpath:/override.properties
```
    
Hierzu muß die Spring-Boot-Applikation allerdings Command-Line-Parameter unterstützen (``SpringApplication.setAddCommandLineProperties(true)``), was aber per Default der Fall ist.

### Laufzeitänderungen
Ist der ``spring-boot-starter-actuator`` aktiviert (als Dependency vorhanden), dann wird ein Rest-Service bereitgestellt, über den die Konfiguration zur Laufzeit geändert werden kan

### Property Injection mit Spring-EL
Ganz ohne weiteres zutun unterstützt Spring bereits das Injecten von Property-Values in Beans per

    @Value("${de.cachaca.cloudProvider})
    private String cloudProvider;
    
Spring sucht in den Property-Dateien im Classpath nach entsprechenden Properties.

Über ``@ConfigurationProperties`` lässt sich dieser Prozess noch ein bisschen komfortabler gestalten.

### Type-safe @ConfigurationProperties
* Spring Referenzdokumentation: http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config-typesafe-configuration-properties

Diesen Ansatz verwendet Spring Boot bei der AutoConfiguration (s. o.). Auf diese Weise werden typensichere Konfigurationen ermöglicht. ``@ConfigurationProperties`` kennzeichnet eine Klasse, die Konfigurationsmöglichkeiten einer Komponente abbildet.

Voraussetzung ist diese Dependency:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-configuration-processor</artifactId>
    <optional>true</optional>
</dependency>
```

Beispiel:

```java
@Component
@ConfigurationProperties(prefix = "de.cachaca.myapp")
public class CloudIntegrationConfiguration {

    private String cloudProviderName = "AWS";

    public void setCloudProviderName(String name) {
      cloudProviderName = name;
    }

    public String getCloudProviderName() {
      return cloudProviderName;
    }
}
```

Eine Anpassung des ``cloudProviderName`` ist über die ``application.properties`` möglich:

    de.cachaca.myapp.cloudProviderName = Microsoft Azure
  
Möchte man die Konfiguration in einer anderen Datei als ``application.properties`` vornehmen, dann geht das über ``@ConfigurationProperties(prefix="test", locations = "classpath:MyConfiguration.properties")``. Aus meiner Sicht besteht dafür i. a. kein Grund ... ich bevorzuge hier den Standardweg und mag es lieber eine einzige Datei zu haben.

Beim Maven-Build wird eine Datei ``spring-configuration-metadata.json`` generiert, die Metadaten für Spring-Boot bereitstellt.

> ACHTUNG: will man innerhalb der IDE bleiben (ohne maven builds anschmeißen zu müssen), dann muß die IDE die Generierung dieser ``spring-configuration-metadata.json`` unterstützen (z. B. m2e bei Eclipse) ... ansonsten wundert man sich warum Änderungen nicht sichtbar sind. 

IntelliJ bietet hier sogar die Möglichkeit zur Autovervollständigung. Willkommen im 21. Jahrhundert der Softwareentwicklung.

### Konfiguration über ``application.properties``/``application.yml``

* Standard-Konfigurationseinstellungen (für alle von Spring-Boot direkt unterstützte Komponenten): http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties
* http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-external-config

Die Konfiguration der Anwendungskomponenten erfolgt in erster Linie über die Dateien

* ``application.properties``
* ``application.yml``

Das [YAML-Format](yaml.md) ist aus meiner Sicht bei komplexen Anwendungen besser geeignet, da die Struktur in YAML hierarchisch aufgebaut ist. Das erhöht die Lesbarkeit und erfordert auch sofort die richtige Eingliederung der Properties in die semantisch passende Ebene. 

Da der Application-Server in einem Executable-Jar auch Komponente der Anwendung ist, findet man dort also auch Konfigurationsmöglichkeiten.

---

## @ConditionalOnProperty
Über 

```java
@RestController
@ConditionalOnProperty(name = "rest.interface.enabled", havingValue = "true")
public class MyResourceImpl {
```

kann man Komponenten in Abhängigkeit der Konfiguration ein/ausschalten ... in ``application.properties`` wird so die Komponente abgeschaltet:

```
rest.interface.enabled = false
```
