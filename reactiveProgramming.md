# Reactive Programming
Bei den nicht-funktionalen Anforderungen an Software hat sich in den letzten 10 Jahren sehr viel bewegt. Mittlerweile sind automatische Skalierbarkeit, Resilience, Responsiveness viel stärker in den Fokus gerückt. Diese gedankliche Weiterentwicklung mündet im ![Reactive Manifest][1].

Mittlerweile sind wir bei den Standard-Architekturen wie JSF, Spring, ... gar nicht mehr gewohnt mit Threads zu arbeiten. Einige PaaS-Ansätze verbieten das sogar explizit und werfen eine Exception. Klar, Multithreading erhöht in jedem Fall die Komplexität für den Entwickler, doch läßt sich damit die Hardware besser auslasten und am Ende gewinnt der Nutzer, weil die Software mehr Responsiveness aufweist. 

# Links
* http://www.reactivemanifesto.org
* http://reactivex.io/

# Reaktives Programmiermodell
Vorreiter waren hier Microsoft und Netflix - Netflix portierte die Microsoft *Reactive Extensions (Rx)* nach Java. Netflix machte einige Bibliotheken Open-Source (z. B. RxJava), so daß der Ansatz von anderen Projekten leichter genutzt werden kann.

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

RxJava tritt an, diese Probleme zu beseitigen und dadurch das asynchrone Programmieren zu vereinfachen.

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

wird ein [Publish-Subscribe-Ansatz](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) abgebildet. Sobald ein Subscriber definiert ist beginnt der Mechanismus mit der Zustellung von Daten. Diese Daten werden aber durch die definierte Processing-Chain geschleust.

Es ist möglich, daß ein Observable Datenstrom an mehrere Subscriber verteilt wird (sog. Multicast) - die Liste der Subscriber läßt sich zur Laufzeit noch erweitern.





