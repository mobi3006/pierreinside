# Netflix Hystrix

* https://github.com/Netflix/Hystrix

The Hystrix library contains tooling to develop fault-tolerant resilient distributed systems.

## Circuit-Breaker

### Pattern

* http://martinfowler.com/bliki/CircuitBreaker.html

Use Circuit-Breaker to deal with failure situations that should not result in complete application downtime because all Worker Threads are blocked by blocking service calls:

> "When a single API dependency fails at high volume with increased latency (causing blocked request threads) it can rapidly (seconds or sub-second) saturate all available Tomcat (or other container such as Jetty) request threads and take down the entire API."(http://techblog.netflix.com/2012/02/fault-tolerance-in-high-volume.html)

![all worker threads blocked](http://1.bp.blogspot.com/-Ftl-RdX27cM/T05Zqc9b_kI/AAAAAAAAAbg/leCKXwOYBIA/s1600/dependencies3.png)

**Quelle:** http://1.bp.blogspot.com/-Ftl-RdX27cM/T05Zqc9b_kI/AAAAAAAAAbg/leCKXwOYBIA/s1600/dependencies3.png"

The Circuit Breaker is service that sits before a delegatee that is providing the business method the client is interested in. Inside the CircuitBreaker we have information whether the delegatee is healthy or broken - if the Circuit Breaker can delegate the request or not. This is (a simlified) algorithm implemented inside:

* at the beginning the Circuit-Brealer is CLOSED (electricity streaming possible) - requests are delegeted to the decorated service. If the request is processed successfully everything is fine. If not, we increase the failure counter. 
* if a counter rises above a configured failure threshold the Circuit-Breaker is OPEN (no electricity streaming possible) - the delegate stops delegating requests to the decorated service. Instead a configured method is called.
* the Circuit-Breaker is self-healing ... after some time it tries to delegate again ... if it works the Circuit-Breaker switches to CLOSED (electricity streaming possible) - otherwise it remains in OPEN state.

![Circuit Breaker state diagram](http://martinfowler.com/bliki/images/circuitBreaker/state.png)

**Quelle:** http://martinfowler.com/bliki/images/circuitBreaker/state.png

Usually you can configure some aspects of your CircuitBreaker:

* invocation timeout
* failure threshold - maybe depdending on the occurred error
* which errors are relevant for circuit-breaking
* algorithm when to switch from OPEN-to-CLOSE

### Implementation

For sure, you can build it on your own ... but why should you reinvent the wheel?

Netflix provides the [Hystrix library](https://github.com/Netflix/Hystrix/wiki/How-it-Works) that offers some useful tools for distributed systems. One component is a CircuitBreaker implementation. The recommended separation approach is by Threads but it can be configured to do separation by Semaphores but this is limited to limit the amount of parallel requests ... timeouts cannot be triggered.

#### Separation by Threads

* [How isolation works?](https://github.com/Netflix/Hystrix/wiki/How-it-Works#isolation)

In this approach separate thread pools (configurable sizes) are used to execute commands which can be interrupted (after a configurable time) by killing the thread.