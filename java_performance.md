# Java Performance

* [Refcardz Java Performance Optimization](https://dzone.com/refcardz/java-performance-optimization)
* [Refcardz Java Caching](https://dzone.com/refcardz/java-caching)
* [Refcardz Java Profiling with VisualVM](https://dzone.com/refcardz/java-profiling-visualvm)

---

## Caching

Caching ist ein sehr wichtiger Aspekt - insbes. im heutigen [Microservices-Hype](microservices.md). Die Implementierung eines Caches sollte man i. a. aber nicht selber in die Hand nehmen ... es fängt meistens recht trivial an, aber wird dann schnell buggy.

Für Caching würde ich versuchen, vorhandene Bibliotheken einzusetzen.

---

## Guava-Cache

Hierüber läßt sich Caching annotationsbasiert abbilden.

---

## Caffeine

* https://github.com/ben-manes/caffeine

Nachfolger von Guava-Cache
