# REST

* Refcardz: https://dzone.com/refcardz/rest-foundations-restful
* http://www.restapitutorial.com/resources.html
* http://blog.philipphauer.de/restful-api-design-best-practices/
* [HTTP 1.1 Protokoll - RFC-2068](https://tools.ietf.org/html/rfc2068)

Der REST-Webservice-Ansatz kam einige Zeit nach dem SOAP-Webservice-Ansatz auf ...

REST ist kein Standard, sondern ein Architekturstil basierend auf Standards wie beispielsweise das HTTP-Protokoll, MIME-Types, URL, ... Insofern gibt es keine festen Vorgaben (wie bei Standards üblich - siehe [RFC-2068](https://tools.ietf.org/html/rfc2068)), die unbedingt einzuhalten sind, sondern eher Empfehlungen.

---

## REST vs. SOAP

* [externer Vergleich](http://www.xfront.com/REST.ppt)

Das SOAP-Ecosystem ist über die Jahre sehr stark gewachsen und hat viele Erweiterungen im Bereich Security, Validierung, XML-Tooling hervorgebracht. Einige dieser Tools können bei der Verwendung von XML als Payload von REST wiederverwendet werden. Allerdings werden REST-Services häufig auf mit JSON als Payload-Format verwendet und dann braucht es neue Tools für

* Serialisierung/Deserialisierung
* Schnittstellen-Spezifikation und Validierung
* ...

### REST lebt HTTP

REST verwendet das HTTP-Protokoll mit seinen Methoden GET, POST, PUT, DELETE ... die verwendete Methode hat in REST eine Bedeutung. Der Payload (beim PUT, POST) wird in den HTTP-Body gepackt ... in einem beliebigen Format (XML, JSON, YAML, Freitext, ...).

Dadurch kann REST allerdings auch weitere Vorteile des HTTP-Protokolls besser nutzen als SOAP:

* Caching auf URL-Basis mit der Information innerhalb einer HTTP-Response, ob und wie lange das Ergebnis gecached werden darf.
* bookmarkable
* Interoperabilität ... es ist kein Custom-SOAP-Protokoll erforderlich
* Authentication im HTTP-Header (funktioniert aber auch bei SOAP)

### SOAP nutzt HTTP als Tunnel

SOAP verwendet das HTTP-Protokoll hingegen nur zum Transport. Im HTTP-Body ist das eigentliche XML-basierte SOAP-Protokoll (``<soap:envelope>``) erweitert um Custom-Namespaces versteckt:

```xml
<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
            <p:getListOfKids xmlns:p="http://www.cachaca.de"/>
    </soap:Body>
</soap:Envelope>
```

Deshalb spielt für SOAP auch ausschließlich die HTTP-POST-Methode eine Rolle. Das eigentliche semantische Protokoll wird über HTTP getunnelt und kommt so auch durch die meisten Firmen-Firewalls.

**Hintergrund:** SOAP kam auf als CORBA und Java-RMI für die Kommunikation zwischen Systemen genutzt wurden. CORBA basierte auf dem IIOP-Protokoll, das von Firmen-Firewalls i. a. blockiert wurde. SOAP setzte deshalb auf HTTP, um dieses Problem zu lösen. 

### SOAP-MessageDispatcher-Ansatz

SOAP ermöglicht (es gibt auch andere Vorgehensweisen) die Verwendung eines zentralen MessageDispatchers, so daß alle Nachrichten zur gleichen URL geschickt werden. Der MessageDispatcher interpretiert die im HTTP-Body enthaltenen Nachricht und routet sie weiter. 

#### Nachteil 1: Security

Für Systemadministatoren könnte dies die Administration erschweren. Bei REST könnte der Admin Zugriffe auf bestimmte Ressourcen mit einer einfachen Regel im Proxy-Server unterbinden, weil alle relevanten Informationen über die HTTP-Methode und die URL abgebildet sind. Bei SOAP hingegen muß das nicht standardisierte Nutzdatenprotokoll analysisert werden ... das ist um einiges aufwendiger und erfordert erhöhten Wartungsaufwand.

#### Nachteil 2: Caching

Ist nicht möglich ... sofern man im Proxy nicht irgendwelche applikationsspezifische Logik nachbauen will (das kann niemand wollen).

### Fazit

In geschlossenen Umgebungen, über die man gemeinsam bestimmen kann, funktioniert SOAP. In offenen Umgebungen ohne zentrale Entscheider hat sich REST bewährt, weil es das einfachere standardisiertere Protokoll ist und somit Interoperabilität besser unterstützt.

---

## Wichtige HTTP-Header

* https://en.wikipedia.org/wiki/List_of_HTTP_header_fields

### Request-Fields

* https://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Request_fields

#### Authorization

Anmeldung am Server

    Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==

#### Accept

Kennzeichnet in welchem Style die Antwort akzeptiert wird

    Accept: text/plain
    Accept: application/xml
    Accept: application/json
    ...

Hierüber kann der Client entscheiden, in welchem Format die Ressource vom Server geliefert werden soll (XML, Json, ...). Ein Server muß natürlich nicht alle Formate unterstützen ... das hängt von der Schnittstelle ab.

#### Accept-Language

Hiermit kann der Client seine gewünschte Sprache mitteilen ... das ist evtl. in einer Consumer-Schnittstelle relevant (z. B. die Antwort enthält menschenlesbare Informationen oder es wird vom Server eine eMail verschickt). 

#### Content-Type

Der Server Kennzeichnet hiermit in welchem Format die Antwort versendet wird

    application/xml
    application/json
    ...

Bei einem HTTP-POST oder -PUT kann der Client aber auch das Format des Request-Body kennzeichnen.

#### Cache-Control

* https://en.wikipedia.org/wiki/Web_cache#Cache_control

    Cache-Control: no-cache

#### ETags

* https://en.wikipedia.org/wiki/HTTP_ETag
* https://tools.ietf.org/html/rfc7232#section-2.3

#### User-Agent

Kennzeichnet den Client

    User-Agent: Mozilla/5.0
    (X11; Linux x86_64; rv:12.0)
    Gecko/20100101 Firefox/21.0

### Response-Fields

* https://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Response_fields

---

## Idee Traversierbarkeit

Bei REST besteht die Idee, daß ein Client sich ohne weiteres Wissen von einer Ressource zur nächsten Ressource hangeln kann, weil eine Ressource wiederum andere Ressourcen referenziert (über einen HTTP-GET-Request).

Bei SOAP wäre das nicht möglich, weil immer ein HTTP-POST mit SOAP-Envelope erforderlich ist. Das lässt sich nicht in einem einfachen Link unterbringen.

---

## REST API Empfehlungen

* [Zalando Guideline](http://zalando.github.io/restful-api-guidelines/)

---

## Java-REST Frameworks

In der Java-Welt gibt es u. a. folgende Ansätze, um RESTful Webservices zu implementieren:

* JAX-RS-Spezifikation basiert: [JAX-RS](https://jcp.org/en/jsr/detail?id=339) ist eine Spezifikation des Java-Community-Process (JSR-339) 
  * Implementierung CXF
  * Implementierung [Jersey](https://jersey.java.net/)
* [Spring REST](springRest.md)