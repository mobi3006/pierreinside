# Reactive Programming

# Links
* http://www.reactivemanifesto.org
* http://reactivex.io/
* [Venkat Subramaniam - Reactive Programming](https://www.youtube.com/watch?v=3bAQXTVsEiQ)

# Motivation

Bei den nicht-funktionalen Anforderungen an Software hat sich in den letzten 10 Jahren sehr viel bewegt. Mittlerweile sind automatische Skalierbarkeit, Resilience, Responsiveness viel stärker in den Fokus gerückt. Diese gedankliche Weiterentwicklung mündet im ![Reactive Manifest][1].

Mittlerweile sind wir bei den Standard-Architekturen wie JSF, Spring, ... gar nicht mehr gewohnt mit Threads zu arbeiten. Einige PaaS-Ansätze verbieten das sogar explizit und werfen eine Exception. Klar, Multithreading erhöht in jedem Fall die Komplexität für den Entwickler, doch läßt sich damit die Hardware besser auslasten und am Ende gewinnt der Nutzer, weil die Software mehr Responsiveness aufweist.

Insofern handelt es sich um ein zweischneidiges Schwert - auch der [Technology Radar](https://www.thoughtworks.com/de/radar/techniques) meint dazu:

> "We recommend assessing the performance and scalability needs of your system before committing to this architectural style."

Die Ideen hinter Reactive Programming sind schon so alt wie die IT selbst: 

* Observer-Pattern
* Publish-Subscribe
* Asynchronität

Und natürlich ist eine effinziente Nutzung von Ressourcen schon IMMER ein Thema ... früher vielleicht sogar mehr als heute. Deshalb ist die Frage berechtigt warum man das nicht schon immer so gemacht hat? Ich habe darauf keine Antwort - ich vermute, daß es liet daran, daß über das Internet SOA erst mal möglich war und auch viele kleine Unternehmen Interesse an professionellen Services bekommen haben. Zudem haben sich einige Unternehmen dem Open-Source Gedanken verschrieben und ihr professionellen Lösungen anderen bereitgestellt. Microservices, Funtional Programming, Websockets, ... helfen dabei, daß sich Anwendungen basierend auf dem Observer-Pattern durchsetzen können.
Auf diese Weise ist ein Ökosystem entstanden, das den Nährboden für die Umsetzung längst akzeptierter Ideen bildet.

Kurz: früher hatte man nicht das Tooling, um die Konzepte massentauglich umzusetzen

Über andere Bewegungen wie Auto-Scaling, Docker, Cloud-Deployment, ... kommen Tools dazu, die es Startups ermöglichen mit wenig Invest coole Services zu implementieren, für die die Kunden bereit sind zu bezahlen. Dadurch entstehen Applikationen, die sich selbst finanzieren.

Ich denke wir sind nun soweit, um tatsächlich reaktive verteilte Systeme auf High-Level-Konzepten umzusetzen (der Abstraktionsgrad sorgt dafür, daß wir schnell zu erstaunlichen Ergebnissen kommen) ... das ist eine Riesenchance für die Anwendungsentwicklung. Wir haben uns vom Request-Response-Paradigma weiterentwickelt sind nun auf einer neuen Stufe der realen und für jedermann umsetzbaren Softwareentwicklung angekommen (die Theorie dahinter existiert schon ewig).

Besser kann man es nicht motivieren: [Venkat Subramaniam - Reactive Programming](https://www.youtube.com/watch?v=3bAQXTVsEiQ)

WOW :-)

## Anschauliches Beispiel

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

## Effizienzerhöhung statt vertikaler/horizontaler Skalierung

> "Efficiency is achieved by not doing things faster ... it is achieved by avoiding work that shouldn't be done ([Venkat Subramaniam](https://www.youtube.com/watch?v=3bAQXTVsEiQ))

Wenn man Dinge vermeidet, die niemand (mehr benötigt), dann stehen mehr Ressourcen für die Dinge zur Verfügung, die tatsächlich jemand benötigt. Wenn man dann mal die unnötigen Dinge abgestellt hat und trotzdem in Ressourcenproblem/Performanceprobleme läuft, DANN ist es Zeit über weitere Ressourcen nachzudenken.

### Pull vs. Push

Ein Pull ist ineffizient im Vergleich zu einem Push, ein Push nur dann Rechenzeit beansprucht, wenn tatsächlich etwas Neues passiert. 

Reactive Programming ist durch den Publish-Subscribe-Ansatz ein Push-Ansatz.

Ist denn der Pull-Ansatz nicht genau das, was uns in der realen Welt immer wieder begegnet:

* Radioprogramm läuft immer weiter ... wir können es aber abschalten, weil wir uns gerade nicht dafür interessieren oder unsere Ressourcen (Gehirn) anderweitig benötigen
* Temperatur ist immer vorhanden ... wir interessieren uns nur eben selten dafür
* ...

Wie man sieht ist das Push-Prinzip allgegenwärtig und könnte - richtig angewendet - dafür sorgen, daß wir uns ganz gezielt für relavente Dinge registrieren können und nur bei Änderungen informiert werden. Finden keine Änderungen statt, dann werden wir auch nicht gestört (optimiert den Client) - wenn wir uns nicht mehr interessieren, teilen wir es dem Server mit (optimiert den Server). Auf diese Weise erhalten wir ein extrem optimierten System, das durch die Optimierung mit weniger Ressourcen mehr Clients bedienen kann.

### Unsubscribe

Wenn ein Client an Daten nicht mehr interessiert ist, dann kann er das dem Server über ein unsubcribe mitteilen. Auf diese Weise können die Server-Resourcen für Clients genutzt werden, die tatsächlich noch an Informationen interessiert sind.

## Was haben Microservices damit zu tun?
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
RxJava ist nur eine von einigen Java-Bibliotheken, die das reaktive Programmiermodell in unsere Java-Applikationen bringen kann. Für andere Programmiersprachen gibt es entsprechende Bibliotheken, die aber glücklicherweise alle miteinander interagieren können (was inbes. bei eine Microservice-Architektur sehr wichtig ist).

### Links
* [JavaOne: Functional Reactive Programming in RxJava](https://www.youtube.com/watch?v=Dk8cR1Kxj0Y)
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

## Reactive Programming in UI

In UI you usually have to deal with Model-View-Controller Pattern. If the Model is reacting on server events because state has changed by somebody else you can implement a distributed real-time-UI.

Das kann man sehr schön mal mit Reactive.js - einer JavaScript-Bibliothek ausprobieren.