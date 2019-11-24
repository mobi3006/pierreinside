# Jenkins

Einsortieren:

* http://wiki.jenkins-ci.org/display/JENKINS/Git+Parameter+Plugin


* [Dokumentation](https://jenkins.io/doc/)
* [Handbuch](https://jenkins.io/doc/book/)

Jenkins wird zur Automatisierung von Builds und Deployments verwendet.

---

## TLDR;

Die Idee von Jenkins ist prinzipiell gut ... aber ob ich wirklich Jenkins nehmen würde, wenn ich die freie Wahl hätte - ich denke nicht.

Das gute zuerst: Es gibt unzählige Plugins für Jenkins und eine große Community - insofern schießt man sich nicht ins Abseits, wenn man sich dafür entscheidet. Groovy macht die Möglichkeiten THEORETISCH grenzenlos, praktisch setzt das fehlende Tooling feste Grenzen.

ABER:

* die Web-UI ist fürchterlich - unintuitiv und buggy
* die Pipline-Sprache existiert als declarative und scripted Variante - schaut man in Foren, um das eigene Problem zu lösen ist es Laien anfangs meist nicht klar welche Variante in der Lösung beschrieben ist. Zudem ist die Developer Experience sehr bescheiden - wie soll man vernünftig an den Pipelines arbeiten, wenn
  * es keine ordentliche Entwicklungsumgebung (Auto-Vervollständigung, Debugging) gibt. Die Pipelines müssen aufgrund der fehlenden Entwicklungsumgebung immer erst mal ins Remote-Git-Repository gebracht werden (commit, push), um dann den Job zu triggern
  * die Fehlermeldungen sehr kryptisch sind

    > ich habe mal einen Pipeline-Parameter `my-param` genannt und wollte ihn per `${params.my-param}` referenzieren ... ging nicht - die Fehlermeldung war nichtssagend. Die Doku paßte zu meiner Nutzung und deshalb habe ich den Fehler in dem eingebetteten Kontext gesucht. Zwei Stunden später hat es dann durch eine Umbenennung der Parameter-Variable von `my-param` zu `my_param` funktioniert. Ich liebe es.

  * der Workaround über _Jenkins Pipeline Syntax Generator_ funktioniert nicht gut
* das Pipeline-Konzept und die Jobs passen nicht zueinander .. ich muß einen Job anlegen, um daran eine Pipeline zu referenzieren, die genau diesen Job beschreiben soll. Parameter kann ich aber beispielsweise im Job UND in der Pipeline definieren ... was zieht nun?
  * aus diesem Grund hat man gelegentlich auch das Henne-Ei-Problem wie hier
    * ich definiere einen Job, der die Pipeline (mit Build-Parameters) aus dem GIT-Repo holt
    * beim ersten Start kann ich keine Build-Parameter eingeben, weil Jenkins noch gar nicht weiß, daß es welche gibt
    * beim zweiten Start "kennt" Jenkins dann die Pipeline und bietet mir beim Start Build-Parameter zur Auswahl an
    * ... fühlt sich gar nicht gut ...

Fazit: die Entwicklung von Pipelines verkommt zum nervenaufreibenden Trial-and-Error mit `echo` Statements, bei dem man nie den Eindruck hat, die Sprache zu beherrschen.

---

## Getting Started

### Start über java jar

Jenkins wird einfach per

```bash
java -jar jenkins.war --httpPort=8080
```

gestartet. Selbst mit Docker ist es aufwendiger (zumindest, wenn man Docker erst noch installieren muß).

### Installation via Docker

* [Start Jenkins via Docker](https://jenkins.io/doc/book/installing/#downloading-and-running-jenkins-in-docker)

> Diese Variante ist die schnellste, wenn man bereits Java 9 oder höher installiert hat, denn
>> "You will need to explicitly install a Java runtime environment, because Jenkins does not work with Java 9" ([Doku](https://pkg.jenkins.io/debian/))

> [Docker Jenkins Agents](https://jenkins.io/doc/book/pipeline/docker/) können in dieser Variante evtl. auch verwendet werden ... mit dem [Docker-in-Docker Ansatz](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/).

```bash
docker run \
    -u root \
    --rm \
    --name jenkins \
    -d \
    -p 8080:8080 \
    -p 50000:50000 \
    -v /tmp/jenkins-data:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jenkinsci/blueocean
```

Beim Start wird das `admin` Password im Log-Output angezeigt - mit diesem Passwort meldet man sich an der Jenkins UI an. Man kann es aber auch über

```bash
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

ausgeben.

Anschließend kann man [über die UI](http://localhost:8080/) noch Plugins installieren (optional) und landet in der Classic UI. Die [BlueOcean UI ist über eine andere URL verfügbar](http://localhost:8080/blue)

Es gibt verschiedene Docker Images:

* `jenkins`: Raw Installation
* `jenkinsci/blueocean`: Long-Term-Support Jenkins Version mit einigen vorinstallierten Blue-Ocean Plugins ... über http://localhost:8080/blue/ kann man ohne die übliche Plugin-Selektion direkt loslegen
  * [in diesem Buch](https://jenkins.io/doc/book/installing/#downloading-and-running-jenkins-in-docker) als _recommended_ eingestuft und detailliert beschrieben

### Installation via Ubuntu Package Manager

Wie in der [Doku](https://pkg.jenkins.io/debian/) beschrieben

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo echo "deb https://pkg.jenkins.io/debian binary/" >> /etc/apt/sources.list
sudo apt-get update
sudo apt-get install jenkins
```

Über http://localhost:8080 ist das Jenkins UI erreichbar, über das man nach der Installation noch ein paar Basis-Konfigurationen vornehmen muß. U. a. kann man hier einen ersten User anlegen (zusätzlich zum `admin` User, dessen initiales Passwort man in `/var/lib/jenkins/secrets/initialAdminPassword` findet).

#### Manage Jenkins

```bash
sudo service jenkins status
sudo service jenkins stop
sudo service jenkins start
```

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

---

## Konzepte

![Konzepte einer Jenkins-Pipeline](images/jenkins-concepts.png)

### Jobs

Jobs stellen den Trigger zur Ausführung von Pipelines zur Verfügung. Jobs werden entweder manuell oder automatisch (z. B. beim Commit in einen Source-Branch - aka "SCM polling trigger") gestartet. Sehr praktisch ist, daß man Jobs auch mit einem API-Token per HTTP-Request triggern kann. Auf diese Weise kann man jederzeit bequem einen Jublauf triggern.

Es gibt verschiedene Job-Typen:

* Maven Projekt
* Pipeline
  * ein Pipeline-Job enthält entweder eine Pipeline-Definition oder referenziert ein `Jenkinsfile` über ein VCS-Repository (SVN, GIT).
* Multibranch Pipeline
  * häufig bei Build-Jobs verwendet, wenn Feature-Branches verwendet werden ... in dem Fall soll jeder Branch automatisch bei einem Commit gebaut werden
* ...

### Pipeline

* [JAX - Der Praxischeck: Pipeline as Code mit Jenkins 2](https://jaxenter.de/pipeline-jenkins-2-61568)
* [Jenkins Doku](https://jenkins.io/doc/book/pipeline/)
* [Jenkins-Pipelines Dokumentation](https://jenkins.io/pipeline/getting-started-pipelines/)
* [Syntax](https://jenkins.io/doc/book/pipeline/syntax/)

Eine Pipeline beschreibt eine Vielzahl von Schritten ... im Extremfall vom VCS checkout, über Bauen der Artefakte, über das Deployent auf verschiedenen Stages bis zum Smoke-Test auf dem Live-Deployment im Stile eines Canary Releases.

Das semantische Konzept existiert in Jenkins schon von Anfang an, aber erst in 2.0 wurde die Pipeline explizit als Beschreibungsform eingeführt.

Groovy war von Beginn an DIE Scriptsprache für Jenkins, um Entwicklern mehr Freiheiten zu geben. Deshalb ist Groovy auch die Basis für die Definition von Pipelines in einem Textfile (z. B. `Jenkinsfile`). Dieser Code ("Infrastructure-as-Code) wird genauso behandelt wie Source-Code (unter Versionskontrolle). Damit ist das Git-Repository eines Services noch weiter self-contained, denn es enthält auch seinen eigenen Build-Job (ähnlich kann man das bei anderen Build-Tools wie beispielsweise [Travis](travis.md)). In Jenkins muß dann nur noch ein Job angelegt werden, in dem die Location des Git-Repositories definiert wird, und angegeben wird, daß das Repository ein Jenkinsfile enthält.

Man unterscheidet zwei Arten von Pipeline Definitionen:

* [Declarative Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
  * durch eine abstrakte DSL (Groovy-basiert) einfacher zu nutzen
  * der Blue Ocean Pipeline Editor hilft bei der Erstellung einer Pipeline
  * dieser Pipeline Typ wurde nach den Scripted Pipelines zur Vereinfachung eingeführt
* [Scriped Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)
  * mächtiger als die deklarative Pipeline, da hier richtig programmiert werden kann
    * Exception Handling
    * Kontrollstrukturen (`if`, ...)
  * es existiert sogar ein eigenes Ökosystem, um die Effizienz durch Reuse zu erhöhen - [Nutzung/Erstellung von Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries/)

Am besten startet man einen lokaken Jenkins und legt einen Pipeline-Job an. Dann kann man sich Pipeline-Code über "Pipeline Syntax" generieren lassen.

> Leider ist das kein schöner Entwicklungszyklus ... eher Trial-and-Error.

#### Trigger

Typischerweise triggert man einen Build nach einem SCM-Commit - hierzu muß man bei Jenkins *Build Triggers - Poll SCM* konfigurieren.

Sehr praktisch sind allerdings auch Web-Hooks (*Build Triggers - Trigger builds remotely*), so daß man Build von außen explizit triggern kann. Auf diese Weise kann auch eine Integration anderen Tools erfolgen.

Außerdem gibt es in einem Jenkins-Job auch _Post-Build Actions_.

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

---

## Benutzer

Es stehen verschiedene Möglichkeiten der Userverwaltung zur Verfügung (konfiguriert in "Jenkins - Configure Global Security"):

* Jenkins-Userverwaltung
* Active Directory

Berechtigung können auf verschiedenen Granularitätsstufen vergeben werden

* Anyone can do anything
* Logged-in users can do anything
* Legacy Mode
* Matrix-based security
* Project-base Matrix Authorization Strategy

---

## Shared Libraries

* [Jenkins Doku](https://jenkins.io/doc/book/pipeline/shared-libraries/)
* [Tutorial mit Beispielen](https://cleverbuilder.com/articles/jenkins-shared-library/)

Jenkinsfiles werden aufgrund des Ansatzes einen Service als Single-Source-of-Responsibility zu betrachten, der alle Aspekte seines Lifecycles selbst managed, in das Microservice Repository gepackt. Wenn die Pipelines dann allerdings komplexer werden, dann kann die Pflege (Bugfixing, Extensions) aufwendig werden, wenn die `Jenkinsfile` der Services i. a. sehr ähnlich aussehen.

In diesem Fall kann man Groovy Shared Libraries verwenden, um die Pflege zu zentralisieren. Das `Jenkinsfile` sieht dann so aus:

```bash
#!/usr/bin/env groovy
@Library('my-jenkins-library') _
microservice-pipeline('docker')
```

Über Parameter können verschiedene Ausprägungen adressiert werden.

In der Jenkins-Server Konfiguration muß die `my-jenkins-library` unter [_Manage Jenkins - Configure System - Global Pipeline Libraries_](http://localhost:8080/configure) eingebunden werden. Hier gibt man beispielsweise ein Git-Repository an und kann eine Default-Version definieren, die je nach Konfiguration im `Jenkinsfile` überschrieben werden kann:

* Tag referenzieren: `@Library('my-jenkins-library@1.0.3`
* Branches referenzieren: `@Library('my-jenkins-library@feature/my-first-scripted-pipeline')`

> **ACHTUNG:** das _override_ muß in der Konfiguration hierzu explizit erlaubt werden (_Allow default version to be overridden_)!!! Ist das nicht erlaubt und es wird eine spezielle Version referenziert, dann schlägt die Ausführung fehlt (kein Failover).

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

---

## Meine erste Pipeline from-scratch

Ich habe bereits eine Jenkins Infrastruktur und dort laufen auch schon Builds basierend auf einer Scripted Shared Library. Das will ich lokal mit einem frisch installierten Jenkins nachbauen.

Mein erster Service, den ich bauen will stellt im GIT-Repository ein `Jenkinsfile` bereit (da ich meinen Code und meine Deployment-Scripte beisammen und unter Versionskontrolle stellen möchte). Ich erstelle eine erste Pipeline und benötige dazu:

* Repository URL
* Repository Credentials: hierzu verwende ich den _Jenkins Credentials Provider_, der im Dialog angeboten wird. Hierzu hat mir der GIT-Repo-Admin einen User und dessen private Key mitgeteilt (Login-Option: _SSH Username with private key_)
  * nach der erstmaligen Konfiguration finde ich diese Credentials unter: http://localhost:8080/credentials/
* Jenkins Library: in meinem `Jenkinsfile` verwende ich eine Custom-Pipeline-Bibliothek (zwecks Wiederverwendung in verschiedenen Komponenten), die Jenkins noch nicht kennt. Deshalb muß ich die Bibliothek zunächst unter [_Global Pipeline Libraries_](http://localhost:8080/configure) als GIT-Repository bekanntmachen ... [hier kann man auch den zu verwendenden Branch konfigurieren (statisch oder dynamisch)](https://jenkins.io/doc/book/pipeline/shared-libraries/#using-libraries). Später wird in meinen Builds immer `Loading library ...` stehen - ACHTUNG: hier wird dann auch der Branch erwähnt, denn man kann verschiedene Branches
* ich benötige noch Maven, dessen Konfiguration und ein Plugin
  * über [_Global Tool Configuration_](http://localhost:8080/configureTools/) (**ACHTUNG:** dieser Dialog ist sehr verwirrend ... man kann hier die Maven/JDK Installationen des Systems wiederverwenden und muß keine Neuinstallation machen - _Install automatically_ darf nicht ausgewählt sein)!!!) integriere ich die auf meinem System bereits installierte Version, die ich `M3` nenne (weil ich Maven 3.5.2 installiert habe):

    ![Maven Global Tool Config](images/jenkins-globalToolConfig-maven.png)
  
    in meiner Pipeline werde ich dieses Tool [folgendermaßen referenzieren](https://wiki.jenkins.io/display/JENKINS/Pipeline+Maven+Plugin):

    ```groovy
    stage('Compile') {
      withMaven(
        // named Maven installation declared in the Jenkins "Global Tool Configuration"
        maven: 'M3'
      ) {
        sh "mvn clean compile -U"
      }
    }

    > ich präferiere Docker Container, um diese Tools on-the-fly in der richtigen Version bereitzustellen - jetzt arbeite ich erstmal mit den bereits installierten Tools
  * die Konfiguration wird über [_Global Tool Configuration_](http://localhost:8080/configureTools/) durchgeführt ... ich verwende meine lokale `/home/pfh/.m2/settings.xml`
  * das Plugin _Pipeline Maven Integration_ wird über die [UI](http://localhost:8080/pluginManager/) installiert
  * in meiner Pipeline-Library verwende ich das Plugin [_Pipeline Utility Steps_](https://github.com/jenkinsci/pipeline-utility-steps-plugin/blob/master/docs/STEPS.md), um die POM zu lesen (`readMavenPom`) - wird über die [UI](http://localhost:8080/pluginManager/) installiert

* statt der Wiederverwedung von Maven/JDK von meinem Host-System möchte ich Docker-Container verwenden. Deshalb schreibe ich die Scripted Pipeline folgendermaßen um ([siehe Dokumentation](https://jenkins.io/doc/book/pipeline/docker/):

  ```json
  docker
    .image('maven:3.3.9-jdk-8-alpine')
    .inside('-v /tmp/maven:/usr/share/maven/ref/ -u root') {
    stage('Compile') {
        sh "mvn clean compile -U"
    }
  }
  ```

### Optimierung 1: JDK und Maven Builds im Docker Agent

Builds in Docker Agents abzubilden hat den Charme, daß die Builds komplett separiert werden. Es kann nicht mehr vorkommen, daß ein Test einen Port öffnen will, der schon von einem parallel laufenden Test geöffnet wurde.

> "As a side note, I would suggest attaching agents to that master. It is not recommended to run jobs inside a master." ([Automating Jenkins Docker Setup](https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/))

Da der User `jenkins` keine `docker` Kommandos ohne `sudo` ausführen kann, füge ich ihn zur Gruppe `docker` hinzu: `usermod -aG docker jenkins`. Anschließend muß ich noch den Jenkins-Service restarten, damit die neuen Gruppenzuordnungen auch ziehen.

> Die ersten Versuche waren leider wenig erquickend und ich muß gestehen, daß sich die Fehlersuche sehr schwierig gestaltet. Docker selbst ist bei nicht startbaren Docker COntainern ja schon recht schwierig zu analysieren. Dadurch, daß der Docker Container unter dem `jenkins` user gestartet wurde ist die Fehlersuche noch mal schwieriger. Ich hatte beispielsweise das Problem, daß die gemounteten Volumes (mit Maven `settings.xml`) nicht sofort zur Verfügung standen ... ich mußte per `sleep 5` ein paar Sekunden warten. Solche Fehler sind natürlcih die Hölle.  Irgendwann schaffe ich es dann aber doch, meinen Code über den Docker Container zu bauen und zu testen.

So sah meine funktionsfähige Pipeline dann aus:

```groovy
node {
  docker
    .image('maven:3.3.9-jdk-8-alpine')
    .inside(
        // provide shared Maven Repository => performance
            '-v /tmp/.m2:/tmp/.m2 '

        // provide Maven configuration => put it into customized Docker Image
        + '-v /tmp/maven:/usr/share/maven/ref/ '

        // -u root ... https://github.com/carlossg/docker-maven/issues/63
        + '-u root '

        + '--env MAVEN_OPTS="'

        //                  share Maven Repository => performance
        +                   '-Dmaven.repo.local=/tmp/.m2"') {

        stage('Checkout') {
            checkout scm
        }
        stage('Build') {
            sleep 5
            sh 'mvn clean compile -U'
        }
        stage('Test') {
            // workaround for surefire problem
            // ... https://stackoverflow.com/questions/46670582/docker-maven-failsafe-surefire-starting-fork-fails-with-the-forked-vm-termin
            // ... https://issues.apache.org/jira/browse/SUREFIRE-1422
            sh 'apk add --no-cache procps'

            sh "mvn verify"
        }
  }
}
```

### Automatisierung einer Jenkins Installation - auf die harte Tour

* [Jenkins Startup Hooks](https://wiki.jenkins.io/display/JENKINS/Groovy+Hook+Script)
* [Breaking the Jenkins Monolith](https://medium.com/buildit/breaking-the-jenkins-monolith-52c47799ddb0)
  * mit guten Beispielen wie die Konfiguration automatisiert werden kann (mit Tests)
  * inkl. automatischer Jobkonfiguration

Ich konnte nun zwar die Konfiguration von JDK und Maven über Docker Container loswerden, doch die Installation von

* Plugins

und die Konfiguration von

* Admin Password
* GIT Credentials
* Shared Libraries
* Jobs
* Usern

ist weiterhin manuell durchzuführen.

Jenkins verwaltet diese Konfiguration in XML Dateien (`/var/lib/jenkins/credentials.xml`), die mir schwierig migrierbar erscheinen (`plugin="credentials@2.1.18"`). Die Pflege dieser Dateien bei Updates scheint mir keine Freude zu sein.

Welche Alternativen sind möglich?

* Installation per Ansible
* Dockerisierung eines vorkonfigurierten Jenkins
* REST API nutzen
* Groovy Schnittstelle nutzen ... alle -Skripte in `${JENKINS_HOME}/init.groovy.d` werden beim Start idempotent ausgeführt.

#### Optimierung 2: Jenkins als Docker Container

* [Docker in Docker? - Can you run Docker inside a Docker container?](https://itnext.io/docker-in-docker-521958d34efd)

Diese Option hätte den Charme, daß man alles vorkonfigurieren könnte, komplett ohne weitere Infrastruktur auf dem Jenkins-Host (Ansible hat auch Anforderungen). Jeder, der Docker nutzen kann, könnte dann auch einen fertig konfigurierten Jenkins-Server starten.

**Option 1:**

Im Docker Container läuft ein eigener Docker Host (Parent-Mode).

> "The answer is yes, but it is not recommended because it causes many low-level technical problems, which have to do with the way Docker is implemented on the operating system, and which are explained in detail in [Jérôme Petazzoni’s post](https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/)." ([Can you run Docker inside a Docker container?](https://itnext.io/docker-in-docker-521958d34efd))

**Option 2:**

In dem Fall sind die Docker Container

> "The good news is that there is another, recommended, way to use Docker inside a Docker container, with which the two Docker instances are not independent from each other, but which bypasses these problems. With this approach, a container, with Docker installed, does not run its own Docker daemon, but connects to the Docker daemon of the host system. That means, you will have a Docker CLI in the container, as well as on the host system, but they both connect to one and the same Docker daemon. At any time, there is only one Docker daemon running in your machine, the one running on the host system. To achieve this, you can start a Docker container, that has Docker installed, with the following bind mount option: `-v /var/run/docker.sock:/var/run/docker.sock`" ([Can you run Docker inside a Docker container?](https://itnext.io/docker-in-docker-521958d34efd))

Genau das habe ich mal ausprobiert. Jenkins per

```bash
docker run \
    -u root \
    --rm \
    --name jenkins \
    -d \
    -p 9090:8080 \
    -p 50000:50000 \
    -v /tmp/jenkins-data:/var/jenkins_home \
    -v /var/run/docker.sock:/var/run/docker.sock \
    jenkinsci/blueocean
```

gestartet und dann über [Blue Ocean URL](http://localhost:9090/blue/) in die _Classic UI_ gewechselt (Blue Ocean erlaubt keine Pipelines über die UI zu definieren), um diese Jenkins-Pipeline anzulegen:

```json
pipeline {
    agent none
    stages {
        stage('Example Build') {
            agent {
              docker 'maven:3-alpine'
            }
            steps {
                echo 'Hello, Maven'
                sh 'mvn --version'
            }
        }
    }
}
```

Job ausgeführt ... funktioniert - per `watch docker ps` sehe ich während der Jobausführung auch den Docker-Agent :-)

Die Jobs (inkl. History) werden in `/var/jenkins_home` abgelegt, das in obigem Beispiel auf dem Docker Host (`-v /tmp/jenkins-data:/var/jenkins_home`) abgelegt wird. Auf diese Weise verliert man nichts, wenn man den Container löschen muß.

### Automatisierung einer Jenkins Installation - auf die komfortable Tour

* Option 1: Jenkins Plugin
  * [Jenkins Configuration as Code 1](https://www.praqma.com/stories/jenkins-configuration-as-code/)
  * [Jenkins Configuration as Code 2](https://www.praqma.com/stories/start-jenkins-config-as-code/)
* Option 2: Jenkins-as-Code Reference-Server

### Development Environment

* [Pipeline Development Environment](https://jenkins.io/doc/book/pipeline/development/)

Eine lokale Jenkins Installation hat meine Developer Experience auf jeden fall schon mal verbessert - im Vergleich zu einem Shared-Jenkins-Installation. Doch leider muß ich immer noch immer committen, pushen und dann den Jenkins Job triggern. Um dann festzustellen, daß die Syntax im `Jenkinsfile` oder einer Shared-Library nicht stimmt. Das ist nicht besonders effizient :-(

Wie geht es besser?

* Jenkins bietet auf einem gestarteten Jenkins Server ... leider nur Tooling für Declarative Pipelines
  * [Snippet Generator](http://localhost:8080/pipeline-syntax/)
  * [Declarative Directive Generator](http://localhost:8080/directive-generator/)
  * [Global Variable Reference](http://localhost:8080/pipeline-syntax/globals)
* Blue Ocean Pipeline Editor unterstützt die Editierung von Jenkins Pipelines, doch will ich meine üblichen Editoren und Tools (Visual Studio Code, Git) verwenden, um die Dateien zu editieren.
* Command-line Pipeline Linter
  * damit bin ich nicht zurecht gekommen
* Visual Studio Code stellt folgende Plugins bereit:
  * Jenkins Pipeline Linter Connector
    * **unterstützt nur deklarative Pipelines**
    * muß folgendermaßen konfiguriert werden:
      ```json
      "jenkins.pipeline.linter.connector.url": "http://localhost:8080/pipeline-model-converter/validate",
      "jenkins.pipeline.linter.connector.user": "pfh",
      "jenkins.pipeline.linter.connector.pass": "112a010e3c1408a97e38fb5d50fd79d0bf"
      ```
* [Pipeline Unit Testing Framework](https://github.com/jenkinsci/JenkinsPipelineUnit)
  * das sollte man auf jeden Fall verwenden, um die Build-Infrastruktur zu testen!!!

Fazit:

> "I hate to be the bearer of bad news, but the documentation is lacking (and often unspecific as to whether or not its examples are for scripted or declarative pipelines), the book barely grazes the subject (if you’ve found one that has better information please share), and piecing together bits of other peoples’ Github examples and Stack Overflow answers is nothing short of a painful slog. Even then, you’re just as likely (if not more!) to find declarative pipeline examples which, of course, have different syntax and abilities." ([Hacky Hacker’s Guide To Hacking Together Jenkins Scripted Pipelines and Getting Them To Do Things](https://medium.com/devopslinks/a-hacky-hackers-guide-to-hacking-together-jenkins-scripted-pipelines-and-getting-them-to-do-things-a1e943cb8d11))