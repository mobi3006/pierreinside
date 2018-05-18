# Spring Core

Spring ist mit dem Inversion-of-Control-Ansatz (u. a. durch Dependency-Injection) groß rausgekommen.

Spring Core ist ein Factory-Ansatz, d. h. Spring kümmert sich um die Instanziierung der Klassen und um deren Lebenszyklus (Singleton, Prototype, Session, ...).

---

## ApplicationContext

### @ComponentScan

Ist diese Eigenschaft gesetzt, dann sucht der Spring-Loader selbst nach Spring-Beans, d. h. nach Anwendungskomponenten wie

* ``@Component``
* ``@Service``
* ``@Repository``
* ``@Controller``

Zusammen mit ``@Autowired`` ergibt sich dadurch kaum noch expliziter Konfigurationsaufwand.

### @ImportResource

Diese Annotation wird benötigt, um die Spring-Xml-Kontextbeschreibungen nicht-annotationsbasierter Komponenten zu integrieren.

    @ImportResource("classpath:my-context.xml")

### @Configuration

Mit dieser Annotation werden Klassen gekennzeichnet, die Beans beispielsweise über Methoden (``@Bean public MyBean getMyBean``) bereitstellen.

Eine mit ``@Component public class MyConfiguration`` oder ``@Service public class MyService`` gekennzeichnete Klasse exponiert Instanzen dieser Klasse automatisch als Beans, so daß ein ``@Autowired`` darauf möglich ist.

### @Conditional

### @Profile

* [Spring Boot - Properties and Configuration - Dokumentation](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-properties-and-configuration.html)

Über

```java
@org.springframework.context.annotation.Profile("swagger")
public class MyService{ ... }
```

wird die Integration der Klasse in die Initialisierung der Anwendung (durch Spring) davon abhängig gemacht, ob ein bestimmtes Profil in ``application.properties``

```properties
spring.profiles.active=swagger
```

gesetzt wurde.

> Handelt es sich hierbei nicht nur um einen Spezialfall von ``@Conditional``?

Mithilfe von Profilen lassen sich [umgebungsabhängige Konfigurationen](https://docs.spring.io/spring-boot/docs/current/reference/html/howto-properties-and-configuration.html#howto-change-configuration-depending-on-the-environment) abbilden, so daß unterschiedliche `application.properties`-Sektionen verwendet werden. Beim Start der Anwendung wird das zu verwendende Profil in Abhängigkeit der Umgebung bzw. des Use-Cases (z. B. `production`, `docker`, `mock`) gesetzt.

Auf diese Weise lassen sich Konfigurationsfamilien umsetzen ... man kann hier EINE `application.properties` verwenden oder aber auch verschiedene (`application-%{PROFIL}.properties`).

---

## Wiring

### Implizites vs. explizites Wiring

Explizites Wiring (damit hat die Spring-Geschichte begonnen) erfolgt über XML-Dateien. Der Apring-ApplicationContext-Loader liest diese Dateien und erzeugt daraus zur Laufzeit den sog. ApplicationContext.

Implizites Wiring kommt fast ohne xml-Konfiguration aus. Allerdings muß Spring evtl. per

    <context:component-scan/>

mitgeteilt werden, daß die Java-Klassen nach Java-Annotationen durchsucht werden. Alternativ kann auch ``<context:annotation-config/>`` verwendet werden, aber diese Konfiguration ist weniger umfassend (die Unterschiede der beiden Konfigurationsvarianten werden [hier beschrieben]((http://stackoverflow.com/questions/7414794/difference-between-contextannotation-config-vs-contextcomponent-scan)). Es können spring-sepzifische (z. B. ``@Autowired``) und auch Java-Annotationen (z. B. ``@Inject``) verwendet werden.

Aus meiner Sicht macht implizites Wiring den Code besser lesbar, da die Rolle einer Java-Klasse durch die Annotation direkt am Code hervorgeht (z. B. ``@RestController``). Ein Nachteil ist allerdings, daß  Spring dadurch invasiv wird.

> Die Invasivität is m. E. zu vernachlässigen, weil man dies leicht revidieren kann. Zudem wird man nicht ständig das Framework wechseln. Außerdem wird man vermutlich versuchen, den Business-Code in eine technologie-unabhängige Klasse zu verschieben und obendrauf nur einen dünnen technologieabhängigen Wrapper zu setzen.

Hybrid-Ansätze sind problemlos möglich, so daß beispielsweise ein ``@Autowired`` einer per Spring-Bean erfolgen kann, die per xml-Konfiguration instanziiert wird.

### Injection Varianten

Ich präferiere grundsätzlich voll-valide Objekte, d. h. Mandatory-Properties MÜSSEN nach Erzeugung der Instanz (über den vorgesehenen Konstruktor) einsatzbereit sein. Ein Client muß nicht erst noch fünf Setter aufrufen müssen. Das erhöht auch die Semantik, Sicherheit und rediuziert die Fehlerrate.

**Insofern präferiere ich Constructor-Injection.**

**Spring nutze ich eigentlich nur über Annotationen.**

In den letzten Jahren bin ich immer mehr ein Freund des Autowiring geworden, weil es den Boilerplate-Code deutlich reduziert. Häufig passiert es mir, daß ich einen Service benötige (auch aus dem Spring-Framework) und einfach mal ein ``@Autowired`` dranpacke ... schon habe ich den notwendigen Service im Zugriff.

#### Constructor Injection

#### Setter Injection

#### Injection by Reflection

Das funktioniert nur, wenn die Java-Policy dies nicht verbietet.

Für Tests, die die Beans mit Mocks befüttern wollen, muß der Test evtl. die Injection durchführen. Die Verwendung von Reflection Injection führt dazu, daß i. a. keine setter und keine Konstruktoren vorhanden. Reflection ist hier weniger lesbar.

### @Primary

* http://www.java-allandsundry.com/2013/08/spring-autowiring-multiple-beans-of.html
* http://www.concretepage.com/spring/example_primary_spring
* mein Lernprojekt: de.cachaca.learn.spring - package de.cachaca.learn.spring.annotation.primary

Bei der Entwicklung erweiterbarer Software steht man oft vor dem Problem, daß eine Komponente einerseits komfortable nutzbar sein soll (am besten ganz ohne zusätzliche Konfiguration) aber andererseits für andere Einsatzbereiche auch anpassbar sein muß.

In einem Projekt wollten wir von einer proprietären Konfigurationskomponente zu den SpringBoot-Konfigurationsmechanismen (``@ConfigurationProperties``) wechseln ... die alte Variante mußte aber weiterhin unterstützt werden (weil daran noch weitere Features hingen).

Wir haben uns für folgendes Design entschieden:

![Spring @Primary im Einsatz](images/springPrimary.png)

Das Modul ``mail-sender`` bietet ein ``MailConfiguration`` Interface. Zudem eine Implementierung dieses Interface auf Spring-Basis (mit ``@ConfigurationProperties``). Will ein Client diese Konfigurationsveriante nutzen, dann muß er nichts weiter konfigurieren.

Clients - wie unser proprietäres Legacy Module - können ihre eigene Implementierung des ``MailConfiguration`` Interface beisteuern (ist mit ``@Primary`` annotiert) und die Default-Implementierung dadurch übersteuern.

Genau so soll es sein ... das Open-Closed-Prinzip :-)