# Jenkins

* [Dokumentation](https://jenkins.io/doc/)
* [Handbuch](https://jenkins.io/doc/book/)

Jenkins wird zur Automatisierung von Builds und Deployments verwendet.

---

## Getting Started

Jenkins wird einfach per

```bash
java -jar jenkins.war --httpPort=8080
```

gestartet. Selbst mit Docker ist es aufwendiger.

### Installation via Ubuntu Package Manager

Wie in der [Doku](https://pkg.jenkins.io/debian/) beschrieben

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install jenkins
```

Über http://localhost:8080 ist das Jenkins UI erreichbar, über das man ein paar Plugins installieren muß:

* Pipeline
* Pipeline Stage View
* OWASP Markup Formatter
* Git
* Email Extension
* Mailer
* ...

und einen ersten User anlegen kann (zusätzlich zum `admin` User, dessen initiales Passwort man in `/var/lib/jenkins/secrets/initialAdminPassword` findet).

#### Problem - No Java executable found

Auf meinem System schlug der Start fehl mit

```log
No Java executable found in current PATH
```

Das Problem ist das Jenkins Startup Script `/etc/init.d/jenkins`, das folgende Zeile aufweist

```bash
PATH=/bin:/usr/bin:/sbin:/usr/sbin
```

Mein Java befindet sich aber in `/usr/lib/jvm/java`. Als Workaround habe ich einen Link `ln -s /usr/lib/jvm/java/bin/java /usr/sbin/java` angelegt - ich wollte das Script nicht verändern, da es evetntuell über ein Paket-Update wieder überschrieben wird.

### Installation via Docker

* [Start Jenkins via Docker](https://jenkins.io/doc/book/installing/#downloading-and-running-jenkins-in-docker)

Diese Variante ist die schnellste, wenn man bereits Java 9 oder höher installaiert hat, denn

> "You will need to explicitly install a Java runtime environment, because Jenkins does not work with Java 9" ([Doku](https://pkg.jenkins.io/debian/))

[Docker Jenkins Agents](https://jenkins.io/doc/book/pipeline/docker/) können in dieser Variante evtl. auch verwendet werden ... mit dem [Docker-in-Docker Ansatz](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/).

---

## Konzepte

![Konzepte einer Jenkins-Pipeline](images/jenkins-concepts.png)

### Jobs

Jobs stellen den Trigger zur Ausführung von Pipelines zur Verfügung. Jobs werden entweder manuell oder automatisch (z. B. beim Commit in einen Source-Branch - aka "SCM polling trigger") gestartet.

Es gibt verschiedene Job-Typen:

* Maven Projekt
* Pipeline
  * ein Pipeline-Job enthält entweder eine Pipeline-Definition oder referenziert ein `Jenkinsfile` über ein VCS-Repository (SVN, GIT).
* Multibranch Pipeline
  * häufig bei Build-Jobs verwendet, wenn Feature-Branches verwendet werden ... in dem Fall soll jeder Branch automatisch bei einem Commit gebaut werden
* ...

### Pipeline

* [Jenkins Doku](https://jenkins.io/doc/book/pipeline/)
* [Jenkins-Pipelines Dokumentation](https://jenkins.io/pipeline/getting-started-pipelines/)
* [Syntax](https://jenkins.io/doc/book/pipeline/syntax/)

Groovy war von Beginn an DIE Scriptsprache für Jenkins, um Entwicklern mehr Freiheiten zu geben. Deshalb ist Groovy auch die Basis für die Definition von Pipelines in einem Textfile (z. B. `Jenkinsfile`). Dieser Code ("Infrastructure-as-Code) wird genauso behandelt wie Source-Code (unter Versionskontrolle). Damit ist das Git-Repository eines Services noch weiter self-contained, denn es enthält auch seinen eigenen Build-Job (ähnlich kann man das bei anderen Build-Tools wie beispielsweise [Travis](travis.md)). In Jenkins muß dann nur noch ein Job angelegt werden, in dem die Location des Git-Repositories definiert wird, und angegeben wird, daß das Repository ein Jenkinsfile enthält.

Man unterscheidet zwei Arten von Pipeline Definitionen:

* [Declarative Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
  * durch eine abstrakte DSL (Groovy-basiert) einfacher zu nutzen
* [Scriped Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)
  * mächtiger als die deklarative Pipeline, da hier richtig programmiert werden kann
  * es existiert sogar ein eigenes Ökosystem, um die Effizienz durch Reuse zu erhöhen - [Nutzung/Erstellung von Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/)

#### Trigger

Typischerweise triggert man einen Build nach einem SCM-Commit - hierzu muß man bei Jenkins *Build Triggers - Poll SCM* konfigurieren.

Sehr praktisch sind allerdings auch Web-Hooks (*Build Triggers - Trigger builds remotely*), so daß man Build von außen explizit triggern kann. Auf diese Weise kann auch eine Integration anderen Tools erfolgen.

### Agent

Jenkins startet Aufgaben (Projekte, Pipelines) und braucht hierzu eine Laufzeitumgebung. Die Laufzeitumgebung nennt man Agent ... es werden verschiedene Typen unterstützt:

* Docker
* Jenkins-Knoten

Man kann den Agent an verschiedenen Stellen definieren:

* Pipeline
* Stage einer Pipeline
* ...

---

## Classic UI vs. Blue Ocean

[Blue Ocean](https://www.youtube.com/watch?time_continue=1&v=mn61VFdScuk) ist das neuere User-Interface, das parallel zur Classic UI existiert.

---

## Global Tools

Nicht alle Tools werden über Plugins integriert. Tools wie

* JDK
* Git
* Ant
* Maven
* Packer
* Terraform
* Docker
* ...

werden über "Jenkins - Global Tool Configuration" konfiguriert.

## Shared Libraries

* [Jenkins Doku](https://jenkins.io/doc/book/pipeline/shared-libraries/)

Jenkinsfiles werden aufgrund des Ansatzes einen Service als Single-Source-of-Responsibility zu betrachten, der alle Aspekte seines Lifecycles selbst managed, in das Microservice Repository gepackt. Wenn die Pipelines dann allerdings komplexer werden, dann kann die Pflege (Bugfixing, Extensions) aufwendig werden, wenn die `Jenkinsfile` der Services i. a. sehr ähnlich aussehen.

In diesem Fall kann man Groovy Shared Libraries verwenden, um die Pflege zu zentralisieren. Das `Jenkinsfile` sieht dann so aus:

```bash
#!/usr/bin/env groovy

@Library('my-jenkins-library') _

microservice-pipeline('docker')
```

Über Parameter können verschiedene Ausprägungen adressiert werden.

In der Jenkins-Server Konfiguration muß die `my-jenkins-library` unter `Manage Jenkins - Configure System - Global Pipeline Libraries` eingebunden werden. Hier gibt man beispielsweise ein Git-Repository an.

---

## Jenkins CLI

Zur Automatisierung von Aufgaben ist die Jenkins CLI gedacht, die per

```bash
java -jar jenkins-cli.jar -s http://localhost:8080/ help
```

aufgerufen werden kann. Für die meisten Aufufe benötigt man allerdings besondere Berechtigungen. Hierzu muß zum User ein API-Token über das Jenkins User-Management erstellt werden:

![Jenkins API-Token](images/jenkinsApiToken.png)

Am besten packt man diesen insgesamt länglichen Aufruf in ein Shell-Skript `jenkins-cli.sh` (das sich im `PATH` befindet) und spendiert noch einen `alias jenkins=jenkins-cli.sh`

```bash
#!/bin/bash

_user=pfh
_apiKey=112a010e3c1408a97e38fb5d50fd79d0bf

java -jar ~/programs/jenkins/jenkins-cli.jar -s http://${_user}:${_apiKey}@localhost:8080/ $@
```

so daß man es dann bequem von überall per `jenkins version` aufrufen kann.

---

## Plugins

Jenkins zeichnet sich gegenüber anderen Build-Tools dadurch aus, daß es eine Fülle an Plugins gibt.

### AnsiColor Plugin

* so sind die Logfiles leichter zu lesen

### Office 365 Connector Plugin

Mit diesem Plugin klappen auch Microsoft Teams Notifications aus Jenkins Pipelines heraus.