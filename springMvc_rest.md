# Spring MVC REST

Spring bietet auch eine Lösung für REST-basierte Webservices (das Paket nennt sich ``spring-web``) - gehört zum Spring MVC Paket. Es tritt damit in Konkurrenz zu vielen in der Java-Welt existierenden REST-Implementierungen (u. a. [JAX-RS JSR-339](https://jcp.org/en/jsr/detail?id=339)).

Wie bei Spring üblich wird viel mit Java-Annotationen gearbeitet:

* ``@RestController``
* ``@RequestMapping``
* ``@RequestBody``
* ``@RequestParam``
* ``@ResponseBody``
* ``@ResponseStatus``

---

## Marshalling/Unmarshalling

* funktioniert über die sog. ``HttpMessageConverter``
* JSON-based-Payload funktioniert out-of-the-box schon sehr gut
* XML-base-Payload ... hier bietet sich JAXB an
* andere Formate kann man natürlich auch verwenden, doch muß man sich dann evtl. selbst um das Marshalling/Unmarshalling kümmern

### HttpEntity, RequestEntity, ResponseEntity

``HttpEntity`` repräsentiert eine HttpRequest (``RequestEntity``) oder HttpResponse (= ``ResponseEntity``).

#### RequestEnity

```java
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.TEXT_PLAIN);
HttpEntity<String> entity = 
  new HttpEntity<String>(helloWorld, headers);
URI location = template.postForLocation("http://example.com", entity);
```

#### ResponseEnity

Eine ``@RestController``-Schnittstelle

```java
public String getName();
```

kann auch als

```java
public ResponseEntity<String> String getName();
```

modelliert werden. Verwendet man die ``FooEntity`` Objekte, so hat man mehr Informationen (z. B. HTTP-Status-Code-Value und Http-Header).

#### ResponseStatus

Exceptions kann man direkt mit einem ResponseStatus (HTTP-Code) verknüpfen:

```java
@ResponseStatus(value = HttpStatus.NOT_FOUND)
public class PersonNotFoundException extends RuntimeException {
```

In der HttpServletResponse landet in diesem Fall automatisch ein ``HttpStatus.NOT_FOUND`` (404).

#### Zugriff per RestTemplate

[siehe Abschnitt zum Testen](springBoot_testing.md)

---

## Vergleich zu Jax-RS

JAX-RS ist eine Java-Community Specifikation ([JSR-339](https://jcp.org/en/jsr/detail?id=339)), zu der es unterschiedliche Implementierungen gibt. [Apache CXF](http://cxf.apache.org/docs/jax-rs.html) liefert eine solche Implementierung. Spring REST implementiert NICHT den JAX-RS-Standard ... insofern handelt es sich um einen proprietären Ansatz.

### Annotationslevel

Bei JAX-RS werden Webservices auf Interface-Level spezifiziert, bei Spring REST hingegen auch Class-Level.

## RestTemplate für REST-Clients

Spring bietet mit dem `RestTemplate` einen Client für REST-Services. Das besondere an diesem Ansatz ist, daß er mit verschiedenen unterliegenden HTTP-Bibliotheken funktioniert. Per Default (bei Nutzung über `new RestTemplate()`) wird Standard JDK verwendet werden, um HTTP-Verbindungen zu initiieren (hier verwendet man System-Properties wie `javax.net.ssl.trustStore` für die Konfiguration des Truststores). Man kann allerdings auch andere Bibliotheken nutzen ... wie hier z. B. Apache HttpComponents (`HttpComponentsClientHttpRequestFactory`):

```java
SSLContext sslContext =
        new SSLContextBuilder().loadTrustMaterial(truststore.getURL(), password).build();
SSLConnectionSocketFactory socketFactory =
        new SSLConnectionSocketFactory(sslContext, NoopHostnameVerifier.INSTANCE);
final Registry<ConnectionSocketFactory> registry = RegistryBuilder.<ConnectionSocketFactory>create()
        .register("http", PlainConnectionSocketFactory.getSocketFactory())
        .register("https", socketFactory)
        .build();
final PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager(registry);
HttpClient httpClient = HttpClients.custom()
        .setSSLSocketFactory(socketFactory)
        .setConnectionManager(connectionManager)
        .build();
RestTemplate restTemplate = RestTemplate(new HttpComponentsClientHttpRequestFactory(httpClient));
```