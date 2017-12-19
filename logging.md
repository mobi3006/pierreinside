# Logging
* [Java 7 - Mehr als eine Insel - Thema Logging](http://openbook.rheinwerk-verlag.de/java7/1507_20_001.html)

Logging macht ja jeder ... aber in der Zwischenzeit ist daraus fast schon eine Wissenschaft geworden:

* Wahl des richtigen Logging-Ansatzes
* die Konfiguration über verschiedene Logging-Ansätze ist eine echte Herausforderung. Muß das so schwer sein? 
* ... doch die Logs wollen auch gelesen bzw. ausgewertet werden. Bei der Fehleranalyse interessiert man sich i. a. nur für sehr wenige Logeinträge, d. h. man liest auch nur sehr wenige. 

# Historie
Als Java gestartet hat gab ein keinen Logging-Ansatz. Log4J füllte diese Lücke. Mit Java 1.4 wurde dann eine Logging-API innerhalb des JDK implementiert (Java Util Logging - JUL). Leider war die weder API-kompatibel noch so leistungsfähig wie das sehr beliebte Log4J. Dennoch nutzen immer mehr Bibliotheken JUL, weil man damit eine weitere externe Bibliothek einsparen konnte und die Leistungsfähigkeit von JUL ausreichte.

Das Problem war somit geboren, daß man unterschiedliche Logging-Konfigurationen pflegen und konsistent halten mußte.

# SLF4J
Leider gibt es mittlerweile Loggingansätze wie Sand am Meer (z. B. Jakarta commons-logging [aka JCL], log4j, java.util.logging [aka JUL], Logback) und jede Library nutzt ihre eigene Logging API. Letztlich will man aber alle Logeinträge in einem File oder an ein Collector (z. B. Graylog) weiterleiten und nicht 25 unterschiedliche Logansätze gleich konfigurieren müssen.

Der Applikationsentwickler will beliebige Libraries verwenden und dennoch selbst entscheiden können, welchen Logging-Ansatz er in seiner Applikation verwendet. Zur Integration anderer Logging-Ansätze der Libraries bietet SLF4j sog. [Bridges (gesammelt im SLF4JBridgeHandler)](https://www.slf4j.org/legacy.html) an - die als Listener für commons-logging (Bridge-Library: `jcl-over-slf4j.jar`), Log4j (Bridge-Library: `log4j-over-slf4j.jar`), java.util.logging (Bridge-Library: `jul-to-slf4j.jar`) ... fungieren und dann aber an SLF4J delegieren. SLF4J ist selbst keine Logging Lösung, sondern nur eine Facade, die an Logging-Lösungen delegiert. Deshalb erfolgt die Konfiguration (LogLevel, Appender, Rotation, ...) nicht in SLF4J, sondern in der jeweiligen Logging-Lösung, für die sich der Applikationsentwickler zum Zeitpunkt des Deployments entscheidet.

## Unterschied zu Jakarta commons-logging (JCL)
* [Probleme von JCL](http://jayunit100.blogspot.de/2013/10/simplifying-distinction-between-sl4j.html)

JCL ist ein ähnlicher Ansatz, der vor SLF4J existierte, aber einige Schwächen (Komplexität) hatte. Die Entwickler von SLF4J konnten die JCL-Entwickler nicht von einer besseren Lösung in JCL überzeugen und starteten deshalb SLF4.

---

# Graylog
[siehe eigener Abschnitt](graylog.md)

Wo ist allerdings die Grenze zum Monitoring. Wenn eine Exception tausendfach/millionenfach auftritt ... wie bekommt man das mit, wenn man das Monitoring keinen Trigger liefert? In manchen Fällen ist das Logging einfach fehlerhaft (z. B. `error` statt `warning`) und müßte korrigiert werden.

---

# ELK-Stack

