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

# Marshalling/Unmarshalling
* funktioniert über die sog. ``HttpMessageConverter``
* JSON-based-Payload funktioniert out-of-the-box schon sehr gut
* XML-base-Payload ... hier bietet sich JAXB an
* andere Formate kann man natürlich auch verwenden, doch muß man sich dann evtl. selbst um das Marshalling/Unmarshalling kümmern

## ResponseEntity
Eine Schnittstelle

    public String getName();
    
kann auch als 

    public ResponseEntity<String> String getName();

modelliert werden. In letzterem Fall hat man größeren Einfluß auf den HTTP-Status-Code-Value und Http-Response-Header.

Die Schnittstelle zur Erzeugung sieht so aus:

    public ResponseEntity(
      T body, 
      MultiValueMap<String, String> headers, 
      HttpStatus statusCode)
    
Die Benutzung ist straight-forward.

---

# Vergleich zu Jax-RS
JAX-RS ist eine Java-Community Specifikation ([JSR-339](https://jcp.org/en/jsr/detail?id=339)), zu der es unterschiedliche Implementierungen gibt. [Apache CXF](http://cxf.apache.org/docs/jax-rs.html) liefert eine solche Implementierung. Spring REST implementiert NICHT den JAX-RS-Standard ... insofern handelt es sich um einen proprietären Ansatz.

## Annotationslevel

Bei JAX-RS werden Webservices auf Interface-Level spezifiziert, bei Spring REST hingegen auch Class-Level.