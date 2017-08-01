# Instana
Bei diesem Tool handelt es sich um ein Application Performance Monitoring (APM) Tool, das mit den Platzhirschen [New Relic](https://newrelic.com/) und [Dynatrace](https://www.dynatrace.com) konkurriert, aber deutlich günstiger ist.

# Motivation

# Alternativen
Mit Ansätzen wie der [Zeitreihen-Datenbankk Prometheus](https://prometheus.io/) lassen sich auch eigene Lösungen stricken, die allerdings zunächst (vielleicht auch dauerhaft) einen hohen zeitlichen Invest erfordern. Letztlich ist man als Betreiber einer Anwendung aber nicht mit den reinen Daten zufrieden, sondern der Nutzen steht und fällt mit der Möglichkeit, aus diesen Unmengen an Daten tatsächlich Informationen zu gewinnen. Nur dadurch lassen sich Probleme/Bottlenecks in der Anwendung aufdecken und gewinnbringende Verbesserungen umsetzen.

Aus guten Grund wurden Lösungen wie Instana, New Relic, Dynatrace, ... geschaffen, die für teures Geld verkauft werden. Eine Selbstimplementierung kann sich wahrscheinlich nur ein Großunternehmen leisten. Eine Adaption vorhandener Open-Source-Lösungen kann auch zeitaufwendig sein oder gar in die Sackgasse führen.

Aus diesem Grund sind bezahlbare fertige (gut supportete) Lösungen eine gute Sache für bestimmte Firmen.

# SaaS oder On-Premise
Instana bietet seinen Dienst als Software-as-a-Service (präferiert) aber auch als On-äPremise-Lösung an. 

Gegen eine Saas-Lösung könnte die Geheimhaltung der Daten sprechen ... per Default versucht Instana keine sensiblen Daten zu loggen (bei SQL-Queries werden keine gebundenen Parameter mitgeloggt), aber letztlich ist es eine Frage des Vertrauens.

