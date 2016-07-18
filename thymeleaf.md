# Thymeleaf
Ich hatte bisher mit JSF/JSP- und Velocity-Templating-Engines gearbeitet. Im Zuge der Nutzung von Spring Boot haben wir Thymeleaf für unser HTML-Frontend genutzt (ohne JSF).

---

# Getting Started
So siehts im Einsatz aus:

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
  <head>
    <title th:remove="all">My first Thymeleaf Template</title>
  </head>
  <body>
    <p th:text="#{home.welcome}">Welcome to my App</p>
  </body>
</html>
```

Am Anfang hatte ich nicht genau hingeschaut und ``th:text`` für ein Table-Header Element gehalten. Hier gehört das aber zum Namespace http://www.thymeleaf.org und wird dementsprechend von der Thymeleaf-Template-Engine interpretiert.


---

# Thymeleaf: ALternative zu JSF?
* http://www.thymeleaf.org/doc/tutorials/2.1/thymeleafspring.html#its-still-a-prototype

## Natural Templating Ansatz
Thymeleaf verfolgt den Ansatz, daß Thymeleaf-Templates im Browser auch ohne Ersetzung der Platzhalter vernünftig dargestellt werden sollen. Auf diese Weise können Contentersteller und Entwickler an dem gleichen Artefakt arbeiten.

Hierzu werden sog. Prototypen verwendet:

```html
<input 
   type="text" 
   name="name" 
   value="Pierre Feld" 
   th:value="${user.name}" />
```

---

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



