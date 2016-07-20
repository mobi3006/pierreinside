# Swagger
Swagger macht REST-Apis generisch nutzbar. Zudem kann es zur Dokumentation genutzt werden. Insofern handelt es sich um eine perfekte Symbiose aus Dokumentation und Code.

---

# Getting Started
* http://swagger.io/getting-started/

Im wesentlichen wird die Swagger-Lib zur Webapplikation hinzugefügt 

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>${springfox.version}</version>
</dependency>
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>${springfox.version}</version>
</dependency>
```

und eine minimale Konfiguration bereitgestellt und dann noch folgende Konfiguration (hier in einer Spring Anwendung):

```java
@Component
@EnableSwagger2
public class MySwaggerConfiguration {

  @Bean
  public Docket api() {
    return new Docket(DocumentationType.SWAGGER_2)
      .useDefaultResponseMessages(false)
      .select()
      .apis(RequestHandlerSelectors.withClassAnnotation(
        RestController.class))
      .paths(PathSelectors.any())
      .build());
  }
}
``` 

Schon sind die REST-Endpunkte der eigenen Anwendung komfortabel über eine Weboberfläche nutzbar:

    http://localhost:8081/swagger-ui.html

---

# Swagger Editor
* http://editor.swagger.io

Hiermit lässt sich schnell in die Swagger-Welt starten. Die Schnittstelle per Contract-First in einem yaml-File beschrieben. Daraus werden dann Client und Server für verschiedene REST-Implementierungen (u. a. Jaxrs Cxf, Spring MVC, Node.js) zum Download bereitgetsellt.

---

# Swagger-Annotationen

* ``io.swagger.annotations.ApiOperation``
* ``io.swagger.annotations.ApiResponse``
* ``io.swagger.annotations.ApiResponses``