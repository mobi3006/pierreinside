# Jenkins Pipelines

* [JAX - Der Praxischeck: Pipeline as Code mit Jenkins 2](https://jaxenter.de/pipeline-jenkins-2-61568)
* [Jenkins Doku](https://jenkins.io/doc/book/pipeline/)
* [Jenkins-Pipelines Dokumentation](https://jenkins.io/pipeline/getting-started-pipelines/)
* [Syntax](https://jenkins.io/doc/book/pipeline/syntax/)

Eine Pipeline beschreibt eine Vielzahl von Schritten ... im Extremfall vom VCS checkout, über Bauen der Artefakte, über das Deployent auf verschiedenen Stages bis zum Smoke-Test auf dem Live-Deployment im Stile eines Canary Releases.

Das semantische Konzept existiert in Jenkins schon von Anfang an, aber erst in 2.0 wurde die Pipeline explizit als Beschreibungsform eingeführt.

Man unterscheidet zwei Arten von Pipeline Definitionen:

* [Declarative Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
* [Scriped Pipeline](https://jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)

---

## Scripted Pipelines

Groovy war von Beginn an DIE Scriptsprache für Jenkins, um Entwicklern mehr Freiheiten zu geben. Deshalb ist Groovy auch die Basis für die Definition von Pipelines in einem Textfile (z. B. `Jenkinsfile`). Dieser Code ("Infrastructure-as-Code) wird genauso behandelt wie Source-Code (unter Versionskontrolle). Damit ist das Git-Repository eines Services noch weiter self-contained, denn es enthält auch seinen eigenen Build-Job (ähnlich kann man das bei anderen Build-Tools wie beispielsweise [Travis](travis.md)). In Jenkins muß dann nur noch ein Job angelegt werden, in dem die Location des Git-Repositories definiert wird, und angegeben wird, daß das Repository ein Jenkinsfile enthält.

Scripted Pipelines sind komplett in Groovy geschrieben und werden von Jenkins 1:1 so ausgeführt. Man hat hier also sehr viele Freiheiten und somit ist dieser Ansatz auch mächtiger als eine deklarative Pipeline ...

Durch die Fehlende IDE zur Entwicklung von Pipelines im allgemeinen besteht der Entwicklungsprozess häufig aus dem Starten der Pipeline in Jenkins - nur hier kann man sehen, ob die Pipeline tatsächlich funktioniert. Häufig kann das allerdings nicht mal auf dem lokalen System erfolgen, sondern der Code muß ins Remote-Repo gepusht werden, um dann den Job zu starten. Leider ist das kein schöner Entwicklungsprozess mit einer IDE-Integration (Code-Completion), Debugging ... eher aufwendiges Trial-and-Error mit teilweise sehr kryptischen Fehlermeldungen.

Das einzige, was Jenkins bietet, ist ein "Pipeline Syntax Generator" im Jenkins-Server selbst. Das ist besser als garnix ... aber gut ist das noch lang nicht :-( Ich bekomme regelmäßig einen Nervenzusammenbruch, wenn ich Erweiterungen an den Pipelines vornehmen muß.

Die Verwendung von [Shared Libraries]((https://jenkins.io/doc/book/pipeline/shared-libraries/) erfordert weiterhin die Verwendung einer Scripted Pipeline ... eine deklarative Variante existiert hier nicht (soweit ich weiß). Shared Libraries helfen bei der Bereitstellung fertiger Pipelines, die über Parameter konfiguriert werden - auf diese Weise läßt sich die unelegante Pipeline-Erstellung zentralisieren und nicht jedes Team muß alles Details kennen..

---

## Deklarative Pipelines

Die Schwierigkeiten bei der Erstellung von Scripted Pipelines hat die Jenkins-Community zum Anlaß genommen, eine Vereinfachung in Form deklarativer Pipelines anzubieten. Beide Varianten werden parallel unterstützt.

Bei der deklarativen Form verwendet man keinen reinen Groovy-Code mehr, sondern eine fest vorgegebene DSL, die in Groovy-Code übersetzt wird. Teile der DSL-Beschreibung - welche ist mir noch nicht ganz klar (hängt vielleicht auch vom Abschnitt ab) - repräsentieren allerdings weiterhin Groovy-Code (Funktionsaufrufe) und werden 1:1 in den Groovy-Code übernommen.

> Mich verwirrt das im allgemeinen - zumindest wenn ich längere Zeit nicht an den Pipelines gearbeitet habe, muß ich mich erstmal wieder reinfinden und die Trial-and-Error-Odysse beginnt

In der deklarativen Beschreibung kann man an dedizierten Stellen `script { // this is my Groovy code}` verwenden, um darin Groovy-Code einzubetten und die Vorteile einer richtigen Programmiersprache (Kontrollstrukturen, Datenstrukturen, Error-Handling, String-Manipulation, Verwendung anderer Bibliotheken, ...) nutzen zu können. Die Verwendung eines sog. Groovy-Strings (mit Double-Quotes `"`) in deklarativen Pipelines erlaubt die Verwendung von Groovy-Code innerhalb des String.

```
pipeline {

  agent none

  options {
    // is this Groovy-Code???
    buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '7', numToKeepStr: ''))
    disableConcurrentBuilds()
    timestamps()
    ansiColor('xterm')
    skipDefaultCheckout(true)
  }

  environment {
    // Groovy-String => Groovy-Code inside
    snakeCaseJobName = "${JOB_NAME.split('_').tail().join("_").replaceAll("-", "_")}"
  }

  stages {
    stage('Build') { 
      steps { 
        // shell script call in current folder
        sh 'make' 
      }
    }
    stage('Test'){
      steps {
        sh 'make check'
        junit 'reports/**/*.xml' 
      }
    }
  }
```

Der Blue Ocean Pipeline Editor hilft bei der Erstellung einer deklarativen Pipeline, so daß man sich Code-Schnipsel erstellen lassen kann.

> Schade, daß die Jenkins-Community nicht eher an einer IDE gearbeitet hat, mit der man den Groovy-Code durch Auto-Completion, internal Execution, Debugging, ... leichter hätte erstellen können.

---

## Empfehlungen zur Verwendung von Pipelines

* [Shared Libraries](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)
  * [Tutorial - Philipp Stroh](https://www.jenkins.io/blog/2017/10/02/pipeline-templates-with-shared-libraries/)

* verwende deklarative Pipelines wenn möglich
* verwende shared libraries, um Pipelines in verschiedenen Konfigurationen wiederzuverwenden
* versuche die Pipelines auf recht hohem Abstraktionslevel zu halten und Helper-Code in Groovy-Funktionen auszulagern, die dann aus den Pipelines bzw. Pipeline-Modulen aufgerufen werden. Auf diese Weise ist der Helper Code auch tatsächlich automatisiert testbar:

  * `Jenkinsfile`

      ```groovy
      #!/usr/bin/env groovy
      @Library('myLibrary@dev-stage') _

      properties([
              parameters([
                      gitParameter(
                        // ...
                      )
              ])
      ])

      // this function has to be defined in a file called pipeline_deploy.groovy
      pipeline_deploy(
        param1: value1,
        param1: value1,
        param1: value1
      )
      ```

  * `pipeline_deploy.groovy`
    * hier definiert man die wiederverwendbaren Pipelines
    * in ähnlicher Form würde man komplexere Module definieren

      ```groovy
      evaluate(new File("Util.groovy"))

      def call(Map pipelineParams) {

        def util = new Util()

        pipeline {
          environment {
            jobname = "${util.toSnakeCase(JOB_NAME)}"
          }
          // ...
        }

      }
      ```

  * `Util.groovy`
    * hier definiert man Helper-Methoden ohne große Semantik

      ```groovy
      def toSnakeCase(String buildJobName) {
        return buildJobName.replaceAll('-', '_')
      }
      ```

---

## Agent

Jenkins startet Aufgaben (Projekte, Pipelines) und braucht hierzu eine Laufzeitumgebung. Die Laufzeitumgebung nennt man Agent ... es werden verschiedene Typen unterstützt:

* Docker
* Jenkins-Knoten

Man kann den Agent an verschiedenen Stellen definieren:

* Pipeline
* Stage einer Pipeline
* ...

---

## Parameter

* http://wiki.jenkins-ci.org/display/JENKINS/Git+Parameter+Plugin

---

## Trigger

Typischerweise triggert man einen Build nach einem SCM-Commit - hierzu muß man bei Jenkins *Build Triggers - Poll SCM* konfigurieren.

Sehr praktisch sind allerdings auch Web-Hooks (*Build Triggers - Trigger builds remotely*), so daß man Build von außen explizit triggern kann. Auf diese Weise kann man leicht einen Build mit einem Deployment verknüpfen, um so Continuous Deployment abzubilden.

---

## Post-Build-Actions

Außerdem gibt es in einem Jenkins-Job auch _Post-Build Actions_.

---

## Wiederverwendung über Shared Libraries

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
