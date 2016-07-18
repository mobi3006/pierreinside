# Spring MVC
* Doku: http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

Spring MVC ist Request-Driven, d. h. ein Controller erhält Http-Requests (GET, POST), die er verarbeitet und zu guter Letzt eine Antwort in Form eines Views (= UI) sendet. 

![sds](http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/images/mvc.png) Quelle: http://docs.spring.io/spring-framework/docs/4.1.2.RELEASE/spring-framework-reference/html/mvc.html#mvc

---

# Spring MVC Rest
[siehe eigenes Kapitel](springMvcRest.md)

---

# DSL

## Configuration
Wie üblich verwendet Spring einen annotationsbasierten Ansatz. Die Annotationen werden bei Anwendungsstart gescannt und dadurch die Applikation initialisiert. Handelt es sich um eine Spring Boot Applikation mit ``@EnableAutoConfiguration`` so sollte alles automatisch initialisiert werden. Ansonsten muß 

```xml
<context:component-scan base-package="de.cachaca.myapp"/>
```

eingesetzt werden, um die Annotationen in den Initialisierungsfokus zu rücken.


## @Controller
* http://docs.spring.io/spring-framework/docs/current/spring-framework-reference/html/mvc.html#mvc-ann-requestmapping

Kennzeichnet eine Klasse in der Rolle eines Controllers. Ein Controller erhält Http-Requests, z. B. aus Http-Pots-Form-Requests.

Ein Controller ist zudem für den Web-Flow zuständig und liefert deshalb den zu rendernden View im Return-Value.

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

