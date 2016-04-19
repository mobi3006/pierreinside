# Reactive Programming

# Links
* http://www.reactivemanifesto.org
* http://reactivex.io/

# Motivation

Bei den nicht-funktionalen Anforderungen an Software hat sich in den letzten 10 Jahren sehr viel bewegt. Mittlerweile sind automatische Skalierbarkeit, Resilience, Responsiveness viel stärker in den Fokus gerückt. Diese gedankliche Weiterentwicklung mündet im ![Reactive Manifest][1].

Mittlerweile sind wir bei den Standard-Architekturen wie JSF, Spring, ... gar nicht mehr gewohnt mit Threads zu arbeiten. Einige PaaS-Ansätze verbieten das sogar explizit und werfen eine Exception. Klar, Multithreading erhöht in jedem Fall die Komplexität für den Entwickler, doch läßt sich damit die Hardware besser auslasten und am Ende gewinnt der Nutzer, weil die Software mehr Responsiveness aufweist.

Insofern handelt es sich um ein zweischneidiges Schwert - auch der [Technology Radar](https://www.thoughtworks.com/de/radar/techniques) meint dazu:

> "We recommend assessing the performance and scalability needs of your system before committing to this architectural style."

### Anschauliches Beispiel

Eine Webseite listet alle meine Bestellungen bei amazon.de mit den aktuellen Bewertungen und der Differenz zum nun aktuell gültigen Preis auf.

Würde man das squentiell programmieren, so würde man folgendes tun:

```
List<Order> orders = orderRepository.getOrders();
for (Order order : orders) {
  Double currentPrice = priceService.getPrice(order.getProduct().getId());
  String rating = ratingService.getRating(order.getProduct().getId());
  ...
}
```
Wie man hier sehen kann erfolgt keinerlei Parallelisierung. Bei 100 Bestellungen muß ich auf 1 + 100 + 100 = 201 Responses warten. Das kann dauern ...

Mache ich das hingegen parallel, so kann ich - sollten tatsächlich 100 Threads parallel laufen können - nach 1 + 1 = 2 Responses schon das Ergebnis zusammenbauen. Das ist natürlich ein massiver Performancegewinn.

### Was haben Microservices damit zu tun?
Früher hatte man es eher mit monolithischen Systemen zu tun. **EIN** System hatte **ALLE** Daten: 

```
DifferenceReport report =
   shopService.calculateDifferenceReportOfOrders()
```

Die Verbreitung von Microservices hat zu stark verteilten Systemen gefürt, die 

* einen OrderService
* einen PriceService
* einen RatingService

auf unterschiedlichen Servern bereitstellen.

Beim monolithischen System hat der Backend-Service im besten Fall die Parallelisierung gemacht. Evtl. war das nicht notwendig, weil die Daten über entsprechende SQL-Joins mit einem Request aus der (**EINZIGEN**) Datenbank geholt wurde.

Beim verteilten Modell muß sich der Client um die performante Abfrage der beteiligen Microservices kümmern.

# Reaktives Programmiermodell
Vorreiter waren hier Microsoft und Netflix - Netflix portierte die Microsoft *Reactive Extensions (Rx)* nach Java. Netflix machte einige Bibliotheken Open-Source (z. B. RxJava), so daß der Ansatz von anderen Projekten leichter genutzt werden kann.

Das Programmiermodell ist auf dem Observer-Pattern mit publish-subscribe Ansätzen aufgebaut. Zwei Erweiterungen wurden eingeführt:

* Producer kann signalisieren, daß keine Daten mehr zu erwarten sind.
* Producer kann den Observer über Fehler informieren

## Reaktive Programming mit Core-Java
Über 

* Threads
* Futures
* Callbacks (Callback-Hell)

läßt sich reaktives Programmieren umsetzen, doch die die Erfahrung (nicht meine) hat gezeigt, daß das im Details schon recht schnell unübersichtlich wird. Der Umgang mit bedingter Ausführung und verschachtelten asynchronen Aufrufen führt schnell zu komplett unverständlichem Code. Und wenn man den Code schon kaum versteht, ist die Gefahr groß, daß sich Fehler einschleichen (Locking, Thread-Synchronisierung). Und Fehlersuche in stark multi-threaded Programmen ist nun wirklich kein Spaß.
## RxJava
### Idee
> "An API for asynchronous programming with observable streams [...] 
> 
> The Observer pattern done right [...] 
> 
> ReactiveX is a combination of the best ideas from
the Observer pattern, the Iterator pattern, and functional programming"

> (http://reactivex.io/)

Java selbst stellt mit ``java.util.concurrent.Future`` bereits ein Konzept zur Verfügung, doch

>  Techniques like Java Futures are straightforward to use for a single level of asynchronous execution but they start to add non-trivial complexity when they’re nested.
> 
> It is difficult to use Futures to optimally compose conditional asynchronous execution flows (or impossible, since latencies of each request vary at runtime). This can be done, of course, but it quickly becomes complicated (and thus error-prone) or it prematurely blocks on Future.get(), which eliminates the benefit of asynchronous execution.
>
> ReactiveX Observables, on the other hand, are intended for composing flows and sequences of asynchronous data.  
> 
> (http://reactivex.io/intro.html)

RxJava tritt an, asynchrones Multitheading zu vereinfachen. Im Hintergrund arbeiten natürlich weiterhin Threads, doch muß man damit nicht selbst arbeiten. 

### Basiskonzepte

##### Observable und Publish-Subscribe

Über

```
Observable.from(source)
  .filter(...)
  .map(...)
  .reduce(...)
  .subscribe(...)
```

wird ein [Publish-Subscribe-Ansatz](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) abgebildet. Sobald ein Subscriber definiert ist beginnt der Mechanismus mit der Zustellung von Daten. Diese Daten werden aber durch die definierte Processing-Chain geschleust. Der Code ist durch

* Fluent-API
* Lamda-Ausdrücke

sehr gut lesbar. 

Es ist möglich, daß ein Observable Datenstrom an mehrere Subscriber verteilt wird (sog. Multicast) - die Liste der Subscriber läßt sich zur Laufzeit noch erweitern.

#### Observable-Functions

Auf den Observables sind Funktionen definiert:

* filter
* limit
* zip

die die Verarbeitung der Daten deklarativ über eine Fluent-API ermöglicht. Der Code ist dadurch sehr schön lesbar. 

#### Threads zusammenführen
Häufig muß man Daten aus verschiedenen Quellen holen (z. B. für ein Produkt den PREIS und die Bewertung), um dann am Ende eine Gesamtsicht zusammenzubauen.

Das Holen der Daten aus den Quellen kann parallel erfolgen, doch muß man beim Zusammenbau des Ergebnisses warten bis alle Preise und Bewertungen bekannt sind, d. h. alle Requests auch ihre Response geliefert haben. In RxJava funktioniert das über die Methode ``Observable.zip``.

### Dokumentation über Marbles

Die Dokumentation von Rx-Funktionen ist in Prosa oftmals kaum verständlich. Deshalb hat man ein neues Dokumentationsschema erfunden: Marbles




