# Spring REST
Spring bietet auch eine Lösung für REST-basierte Webservices (das Paket nennt sich ``spring-web``). Es tritt damit in Konkurrenz zu vielen in der Java-Welt existierenden REST-Implementierungen (u. a. JAX-RS). 

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

    public ResponseEntity(T body, MultiValueMap<String, String> headers, HttpStatus statusCode)
    
Die Benutzung ist straight-forward.




