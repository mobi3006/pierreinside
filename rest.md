# REST
Der REST-Webservice-Ansatz kam einige Zeit nach dem SOAP-Webservice-Ansatz auf ...

REST ist kein Standard, sondern ein Architekturstil basierend auf Standards wie beispielsweise das HTTP-Protokoll, MIME-Types, URL, ... Insofern gibt es keine festen Vorgaben (wie bei Standards üblich - siehe [RFC-2068](https://tools.ietf.org/html/rfc2068)), die unbedingt einzuhalten sind, sondern eher Empfehlungen.

---

# REST vs. SOAP
## REST lebt HTTP
REST verwendet das HTTP-Protokoll mit seinen Methoden GET, POST, PUT, DELETE ... die verwendete Methode hat in REST eine Bedeutung. Der Payload (beim PUT, POST) wird in den HTTP-Body gepackt ... in einem beliebigen Format (XML, JSON, YAML, Freitext, ...).

Dadurch kann REST allerdings auch weitere Vorteile des HTTP-Protokolls besser nutzen als SOAP:

* Caching
* Authentication im HTTP-Header (funktioniert aber auch bei SOAP)

## SOAP nutzt HTTP als Tunnel

SOAP verwendet das HTTP-Protokoll hingegen nur zum Transport. Im HTTP-Body ist das eigentliche XML-basierte SOAP-Protokoll (``<soap:envelope>``) erweitert um Custom-Namespaces versteckt:

    <?xml version="1.0"?>
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
        <soap:Body>
              <p:getListOfKids xmlns:p="http://www.cachaca.de"/>
        </soap:Body>
    </soap:Envelope>

Deshalb spielt für SOAP auch ausschließlich die HTTP-POST-Methode eine Rolle. Das eigentliche semantische Protokoll wird über HTTP getunnelt und kommt so auch durch die meisten Firmen-Firewalls.

**Hintergrund:** SOAP kam auf als CORBA und Java-RMI für die Kommunikation zwischen Systemen genutzt wurden. CORBA basierte auf dem IIOP-Protokoll, das von Firmen-Firewalls i. a. blockiert wurde. SOAP setzte deshalb auf HTTP, um dieses Problem zu lösen. 

---

# Idee Traversierbarkeit

Bei REST besteht die Idee, daß ein Client sich ohne weiteres Wissen von einer Ressource zur nächsten Ressource hangeln kann, weil eine Ressource wiederum andere Ressourcen referenziert (über einen HTTP-GET-Request).

Bei SOAP wäre das nicht möglich, weil immer ein HTTP-POST mit SOAP-Envelope erforderlich ist. Das lässt sich nicht in einem einfachen Link unterbringen.

