# Logging

* [Java 7 - Mehr als eine Insel - Thema Logging](http://openbook.rheinwerk-verlag.de/java7/1507_20_001.html)

Logging macht ja jeder ... aber in der Zwischenzeit ist daraus fast schon eine Wissenschaft geworden:

* Wahl des richtigen Logging-Ansatzes
* die Konfiguration über verschiedene Logging-Ansätze ist eine echte Herausforderung. Muß das so schwer sein?
* ... doch die Logs wollen auch gelesen bzw. ausgewertet werden. Bei der Fehleranalyse interessiert man sich i. a. nur für sehr wenige Logeinträge, d. h. man liest auch nur sehr wenige.

## Historie

Als Java gestartet hat gab ein keinen Logging-Ansatz. Log4J füllte diese Lücke. Mit Java 1.4 wurde dann eine Logging-API innerhalb des JDK implementiert (Java Util Logging - JUL). Leider war die weder API-kompatibel noch so leistungsfähig wie das sehr beliebte Log4J. Dennoch nutzen immer mehr Bibliotheken JUL, weil man damit eine weitere externe Bibliothek einsparen konnte und die Leistungsfähigkeit von JUL ausreichte.

Das Problem war somit geboren, daß man unterschiedliche Logging-Konfigurationen pflegen und konsistent halten mußte.

## SLF4J

Leider gibt es mittlerweile Loggingansätze wie Sand am Meer (z. B. Jakarta commons-logging [aka JCL], log4j, java.util.logging [aka JUL], Logback) und jede Library nutzt ihre eigene Logging API. Letztlich will man aber alle Logeinträge in einem File oder an ein Collector (z. B. Graylog) weiterleiten und nicht 25 unterschiedliche Logansätze gleich konfigurieren müssen.

Der Applikationsentwickler will beliebige Libraries verwenden und dennoch selbst entscheiden können, welchen Logging-Ansatz er in seiner Applikation verwendet. Zur Integration anderer Logging-Ansätze der Libraries bietet SLF4j sog. [Bridges (gesammelt im SLF4JBridgeHandler)](https://www.slf4j.org/legacy.html) an - die als Listener für commons-logging (Bridge-Library: `jcl-over-slf4j.jar`), Log4j (Bridge-Library: `log4j-over-slf4j.jar`), java.util.logging (Bridge-Library: `jul-to-slf4j.jar`) ... fungieren und dann aber an SLF4J delegieren. SLF4J ist selbst keine Logging Lösung, sondern nur eine Facade, die an Logging-Lösungen delegiert. Deshalb erfolgt die Konfiguration (LogLevel, Appender, Rotation, ...) nicht in SLF4J, sondern in der jeweiligen Logging-Lösung, für die sich der Applikationsentwickler zum Zeitpunkt des Deployments entscheidet.

## Logback

[Logback](http://logback.qos.ch/) implementiert die [SLF4J API](http://www.slf4j.org/) und somit sieht der Code SLF4J-like aus:

```java
package de.cachaca.learn.logback;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {

  public static void main(String[] args) {

    Logger logger = LoggerFactory.getLogger("de.cachaca.learn.logback");
    logger.debug("Hello world.");

  }
}
```

Zur Laufzeit muß man dem Code allerdings eine SLF4J kompatible Implementierung (z. B. `logback-core-1.2.3.jar`) beisteuern und das ist dann Logback. Diese Implementierung kann allerdings ohne Änderung am Code ausgetauscht werden - nur die Logging-Konfiguration (`logback.xml`) müßte dann ausgetauscht werden. So könnte die Logback-Konfiguration aussehen:

```xml
<configuration debug="true">
  <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <encoder>
      <pattern>"%d{HH:mm:ss.SSS} [%thread] %-5level %logger{50} - %msg%n%ex{full}"</pattern>
    </encoder>
  </appender>
</configuration>
```

In diesem Beispiel wird als raw-text auf die Console geloggt. Das bietet sich beispielsweise auch im [Docker-Umfeld](docker_logging.md) an, da der Docker-Daemon die Speicherung in Dateien übernimmt. Für ein Log-Forwarding auf einen zentralen Log-Server kann man dann Syslog oder [Fluentd](fluentd.md) benutzen.

Über ander [Appender](http://logback.qos.ch/manual/appenders.html) kann man aber auch in Dateien loggen (und dabei sogar rollieren) oder den `SockerAppender` (bzw. `SSLSockerAppender`) verwenden. Wer es ganz bunt treiben will verwendet den `SMTPAppender` und verschickt die Logs per eMail oder schreibt Logs per `DBAppender` in die Datenbank.

Man kann auch andere Formate loggen - beim JSON-basierten GELF-Format ([GELF = Graylog Extended Log Format](https://docs.graylog.org/en/3.1/pages/gelf.html)) würde man noch eine entsprechende Biliothek (z. B. `logback-gelf-1.1.1.jar`) zur Laufzeit benötigen. So könnte die Konfiguration dann aussehen:

```xml
<configuration debug="true">
  <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
    <layout class="me.moocar.logbackgelf.GelfLayout">
      <shortMessageLayout class="ch.qos.logback.classic.PatternLayout">
        <pattern>%m%.-250rEx{short}</pattern>
      </shortMessageLayout>
      <fullMessageLayout class="ch.qos.logback.classic.PatternLayout">
        <pattern>%m%n%ex{full}</pattern>
      </fullMessageLayout>
      <useLoggerName>true</useLoggerName>
      <useThreadName>true</useThreadName>
      <includeFullMDC>true</includeFullMDC>
      <prettyPrint>true</prettyPrint>
      <additionalField>ipAddress:_ip_address</additionalField>
      <staticField class="me.moocar.logbackgelf.Field">
      <key>_app</key>
        <value>my-hello-world-app</value>
      </staticField>
    </layout>
  </appender>
</configuration>
```

Logback bietet noch ein paar weitere [Layouts]((http://logback.qos.ch/manual/layouts.html)) (z. B. HTMLLayout) oder man definiert sein eigenes - das PatternLayout ist sehr mächtig.

SLF4J bietet den sog. [Mapped Diagnostic Context](http://logback.qos.ch/manual/mdc.html), den man im Java-Code verwendet, um bei der Verarbeitung eines Requests auf verschiedenen Layern Informationen zu teilen. Letztlich stehen diese Informationen auch der SLF4J-Implementierung (wie Logback) zur Verfügung, um die Informationen auch wegloggen zu können. In obigem Beispiel übernimmt das die Zeile

```xml
<includeFullMDC>true</includeFullMDC>
```

Der MDC ist threadgebunden, so daß während der Verarbeitung eines Requests auf den gleichen Kontext zugegriffen wird und eine kontinuierliche Anreicherung erfolgen kann. Auf diese Weise kann man beispielsweise beim eingehenden Request eine Request-ID erzeugen und per `MDC.put("requestId", createUniqueRequestId());` in den Kontext stecken. Bei jeder geloggten Nachricht wird die Request-ID dann geloggt. Alle Log-Messages, die während der Verabeitung des Requests erzeugt wurden,erhalten die gleiche Request-ID im Log. Übergibt man die Request-ID auch bei Webservice-Calls, so funktioniert das sogar über Microservice-Grenzen hinweg.

### SLF4J vs. JCL (Jakarta Commons Logging)

* [Probleme von JCL](http://jayunit100.blogspot.de/2013/10/simplifying-distinction-between-sl4j.html)

JCL ist ein ähnlicher Ansatz, der vor SLF4J existierte, aber einige Schwächen (Komplexität) hatte. Die Entwickler von SLF4J konnten die JCL-Entwickler nicht von einer besseren Lösung in JCL überzeugen und starteten deshalb SLF4.

---

## Graylog

[siehe eigener Abschnitt](graylog.md)

Wo ist allerdings die Grenze zum Monitoring. Wenn eine Exception tausendfach/millionenfach auftritt ... wie bekommt man das mit, wenn man das Monitoring keinen Trigger liefert? In manchen Fällen ist das Logging einfach fehlerhaft (z. B. `error` statt `warning`) und müßte korrigiert werden.

Graylog verwendet - wie ELK - ElasticSearch als Storage.

---

## ELK

Mit

* ElasticSearch (Persistenz)
* Logstash (Log-Sammlung und Enrichment) - ähnlich zu [Fluentd](fluentd.md)
  * [Logstash Alternativen](https://sematext.com/blog/logstash-alternatives/)
  * hier existieren viele Plugins
* Kibana (UI)

existiert ein sehr beliebter Stack fürs Logging.

Es wird nicht empfohlen LogStash auf kleinenn Servern zu installieren und hier stattdessen mit einem Lightweight-Log-Shipper wie FileBeat oder Syslog zu arbeiten, mit dem die Logs nach LogStash oder ElasticSearch gepusht werden.

---

## Splunk

Splunk ist eine kommerzielle Logging-Lösung und spielt damit auf der Ebene Graylog/ELK.

---

## Fluentd

[sieht extra Abschnitt](fluentd.md)

---

## Log-Analyse

Neben der Verwendung von Logs zur Fehleranalyse kann man es auch verwenden, um aus den Daten Informationen abzuleiten, z. B. User-Verhalten. Hierzu könnte man beispielsweise Hadoop verwenden.
