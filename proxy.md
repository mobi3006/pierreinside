# Proxy

Ein Proxy wird in Form eines Decorators (= transparent für den Nutzer) vor den eigentlichen vom Benutzer verwendeten Services eingesetzt. Hierbei kann es sich um Aspekte wie

* Caching
* Ausfallsicherheit
* Skalierung

handeln.

# Loadbalancer

Ein Loadbalancer ist eine spezielle Art von Proxy, der für die Lastverteilung und Ausfallsicherheit eingesetzt wird.

## Typen

* Application Load Balancer
  * arbeitet auf HTTP/HTTPS-Ebene (Layer 7)
  * unterstützt die Terminierung der SSL-Verbindung
    * benötigt man Client-Zertifikate, dann muß man diese evtl. als HTTP-Header weiterleiten
  * über [X-Forwarded-For-Header - XFF](https://de.wikipedia.org/wiki/X-Forwarded-For) kann die IP-Adresse des Clients weitergeleitet werden
  * Routingoptionen
    * host-basiert
      * es könnte sein, daß mehrere Domains auf einen Loadbalancer geroutet werden (über DNS), dann kann der ELB über den Hostnamen ein entsprechendes Routing anbieten
    * pfad-basiert
* Network Load Balancer
  * arbeitet auf

# Konzepte

## AWS - Elastic Load Balancer (ELB)

* [AWS - ELB](https://aws.amazon.com/de/elasticloadbalancing/)

Amazon bietet folgende Arten von Loadbalancers:

* Application Load Balancer
  * unterstützt Sticky-Sessions über Cookies, die vom Load-Balancer generiert werden
    * im elastischen Umfeld will man aber eigentlich auf Stickiness verzichten
* Network Load Balancer
