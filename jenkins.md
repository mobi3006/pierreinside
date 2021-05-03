# Jenkins

* [Dokumentation](https://jenkins.io/doc/)
* [Handbuch](https://jenkins.io/doc/book/)
* [Source-Code](https://github.com/jenkinsci/jenkins)

Jenkins wird zur Automatisierung von Builds (hiermit hat alles begonnen) und Deployments verwendet.

Jenkins ist in Java geschrieben und bietet innerhalb der Pipelines und Web-UI Groovy zum Scripten (ohne compilieren zu müssen) an.

---

## TLDR

Die Idee von Jenkins ist prinzipiell gut ... aber ob ich wirklich Jenkins nehmen würde, wenn ich die freie Wahl hätte - ich bin mir nicht sicher ... es ist auf jeden Fall Luft nach oben.

Das Gute zuerst:

* Jenkins ist offen ... über Shell- und Groovy-Skripte läßt nich nahezu jeder Use-Case integrieren und Custom-Solutions nach Belieben bauen
* es gibt unzählige Plugins für Jenkins und eine große Community - insofern schießt man sich nicht ins Abseits, wenn man sich dafür entscheidet

ABER:

* die Web-UI ist fürchterlich - unintuitiv und buggy
  * aber das Problem haben scheinbar auch andere Lösungen (z. B. AWS-Toolchain)
* die Pipline-Sprache existiert als deklarative und scripted Variante - schaut man in Foren, um das eigene Problem zu lösen ist es Laien anfangs meist nicht klar welche Variante in der Lösung beschrieben ist. Zudem ist die Developer Experience sehr bescheiden - wie soll man vernünftig an den Pipelines arbeiten, wenn
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

Diese Variante ist die schnellste, wenn man bereits Java 9 oder höher installiert hat, denn

> "You will need to explicitly install a Java runtime environment, because Jenkins does not work with Java 9" ([Doku](https://pkg.jenkins.io/debian/))

[Docker Jenkins Agents](https://jenkins.io/doc/book/pipeline/docker/) können in dieser Variante auch verwendet werden ... mit dem [Docker-in-Docker Ansatz](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/).

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
  * ich habe das quasi nie benutzt ... allerdings sah der Pipeline Editor in den Videos ganz brauchbar aus

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

### LTS vs. Weekly

Jeninks unterstützt zwei Linien:

* Weekly
* LTS
  * hier sollten alle 3 Monate neue Major-Versionen (z. B. 2.235) kommen ... war in 2020 aber noch nicht stabil
  * wie lange werden alte LTS gepflegt?

Hersteller wie CloudBees (CloudBees Jenkins Enterprise) bieten Lösungen basierend auf dem OpenSource Stack. Hier gibt es dann AWS-Templates, um ein skalierbares Jenkins-Cluster zu erhalten. Jenkins kommt out-of-the-box vielleicht nicht mit voller Vielfalt daher, aber es scheint genug Potential zu haben, daß es bekannte Unternehmen als Basis für ihre Produkte verwenden.

Jenkins bietet Tooling ([jenkins-plugin-cli](https://github.com/jenkinsci/plugin-installation-manager-tool)), um alle Plugin-Anhängigkeiten innerhalb einer Major-Version basierend auf einer Liste von Plugins automatisch aufzulösen, zu installieren oder evtl. Konflikte zu entdecken.

> Dieses Tool funktioniert tatsächlich sehr gut.

### Jobs

Jobs werden in Jenkins entweder manuell angelegt oder durch einen sog. Seed-Job. Letzteres ist natürlich erforderlich, wenn man automatisieren will. Ein Job kann eine Pipeline in Form eines `Jenkinsfile` referenzieren, in dem die einzelnen Schritte definiert sind. In einem solchen `Jenkinsfile` sind allerdings keine Informationen über den Pipeline-Typ (z. B. Multibranch) und deren Konfiguration (z. B. Branch Filter). Das sind typische Job-Typen (ich vermute je nach Jenkins-Version und installierten Plugins gibt mehr oder weniger):

* Freestyle Project
* Maven Project
* Pipeline
* Multibranch Pipeline

> Die Grenze zwischen Job und Pipeline (oder dem was man in einemm `Jenkinsfile` machen kann) scheinen nicht so klar definiert zu sein. Man kann beispielsweise den Trigger im Job aber auch im `Jenkinsfile` definieren. Dadurch entsteht ein konzeptionelles Henne-Ei-Problem, denn Pipeline-Parameter (oder auch Trigger-Informationen), die im `Jenkinsfile` definiert werden (aber auch im Job), stehen bei der Ausführung des Jobs erst dann zur Verfügung, wenn der Job einmalig gestartet wurde ... man muß den Job also zweimal starten - das sorgt immer wieder für Verwirrung und Probleme (vergißt man schnell) :-(

Jobs stellen den Trigger zur Ausführung von Pipelines zur Verfügung. Jobs werden entweder manuell oder automatisch (z. B. beim Commit in einen Source-Branch - aka "SCM polling trigger") gestartet. Sehr praktisch ist, daß man Jobs auch mit einem API-Token per HTTP-Request triggern kann. Auf diese Weise kann man jederzeit bequem einen Joblauf triggern.

Es gibt verschiedene Job-Typen ... auch beim Wording in Jenkins-Server verschwimmen die Grenzen zwischen Pipeline und Job:

* Maven Projekt
* Pipeline
  * ein Pipeline-Job enthält entweder eine Pipeline-Definition oder referenziert ein `Jenkinsfile` über ein VCS-Repository (SVN, GIT).
* Multibranch Pipeline
  * häufig bei Build-Jobs verwendet, wenn Feature-Branches verwendet werden ... in dem Fall soll jeder Branch automatisch bei einem Commit gebaut werden
* ...

### Pipeline

Eine Pipeline beschreibt eine Vielzahl von Schritten ... im Extremfall vom VCS checkout, über Bauen der Artefakte, über das Deployent auf verschiedenen Stages bis zum Smoke-Test auf dem Live-Deployment im Stile eines Canary Releases.

Details finden sich [hier](jenkins_pipeline.md).

### Executors

In Jenkins muß man keine Agents konfigurieren, wenn man das nicht will (z. B. Remote Agents). Es reicht Executors zu definieren und das ist die Anzahl der Prozesse, die Jenkins maximal mit der Durchführung von Aufgaben beauftragt. Diese Executors laufen dann als separate Prozesse auf dem Jenkins Server ... und sie laufen auch gelegentlich mal weiter, obwohl der Jenkins Server schon gestoppt wurde.

> Ich habe das mal erlebt, daß der Linux-Kernel Prozesse wegen Speichermangel (Stichwort Overprovisioning) hart (`kill -9`) abgeschossen hat. Darunter auch den Jenkins-Server Prozess (mit der UI). Die Executor-Prozesse liefen aber weiter und haben weiter hohe Last erzeugt.

### Filesystem-Struktur

Man muß selten auf das Filesystem runter ... bei hartnäckigen Problemen muß das aber einfach sein.

```
JENKINS_HOME/
  fingerprints/
  jobs/
    - Jobdefinitionen (`config.xml`, `indexing.xml`)
    - Job-Ausführungen (pro Branch)
      - Ergebnisse von JUnit Tests
      - hier wird der komplette Kontext des Ausführungsscope gehalten (`build.xml`, Pipeline-Bibliotheken)
      - inkl. History mit Links auf "Last Succesful", "Last Failed", ...)
  nodes/
  plugins/
  secrets/
  tools/
  updates/
  users/
  workspace/
    in diesem Bereich befinden sich die temporären Verzeichnisse der Jobs
    hier wird der code ausgecheckt und gebaut. Es befinden sich auch die
    referenzierten Libraries darin.
```

### Security

Jenkins braucht zur Abbildung natürlich Zugriff auf den Source-Code ... hierfür werden üblicherweise Credentials (= Secrets) benötigt. Je nach Komplexität der Pipelines werden viele Secrets benötigt (z. B. um ein Deployment anzustoßen oder Notifications zu versenden). Jenkins wird somit zu einer zentralen Komponente für Angriffe auf die Security ... hier lassen sich Secrets abgreifen oder in die Builds eingreifen, um so die Artefakte zu manipulieren.

Jenkins hat einen Secret-Store, in dem die Secrets abgelegt werden und nur Jenkins hat Zugriff im Klartext. Jedes Secret bekommt eine ID und kann in den Jobs/Pipelines referenziert werden. Wenn der Job eine eine Pipeline als `Jenkinsfile` eines GIT-Repositories referenziert, so wird der GIT-Access schon im Job benötigt. Hierzu muß das Repo und die Credential konfiguriert werden:

![Jenkins-Job-Git-Credentials](images/jenkins-job-git-credentials.png)

Hier kann entweder ein Credential aus dem Secret-Store (im Beispiel `jenkins`) referenziert werden oder `- none -`. Im letzteren Fall fällt Jenkins - wenn nicht noch in der Jenkins-Konfiguration global überschrieben - auf die ssh-Konfiguration (im Beispiel wird eine ssh-Url verwendet!!!) zurück, die zum User gehört, mit dem Jenkins ausgeführt wird. Diese findet man wie üblich auf dem Filesystem unter `~/.ssh/config`. In beide Fällen findet man die Konfiguration auf dem Filesystem `JENKINS_HOME/jobs/JOBNAME/config.xml` - das kann gelegentlich mal hiflreich sein, um die UI-Konfigruation mit der tatsächlich genutzten (persistierten) Konfiguration abzugleichen.

Aus diesem Grund MUSS der Zugriff auf Jenkins komplett abgesichert werden, d. h.

* Authentifizierung und Authorisierung
  * im besten Fall verwendet man kein lokales User-Management, sondern ein unternehmensweites Active-Directory (LDAP Security Realm), so daß man sein typische Passwort verwenden kann und auch Rollen zentral managen kann
    * ein scheidender Mitarbeiter verliert somit automatisch seinen Zugriff
* nicht jeder darf alles ... Matrix-Based Security oder Project-based Matrix Authorization Strategy
* Audit-Logs
* Nachvollziehbarkeit ... wer hat wann welche Jobs gestartet
* Secrets müssen im Secure Store des Jenkins aufbewahrt werden
  * wenn man den Server from-scratch per Code aufsetzen will ist eine Challenge, die Secrets hier reinzubekommen
    * verwendet man einen Docker-Jenkins mit `docker-compose`, so kann man die Secrets in der `secrets` section angeben und somit bereitstellen. Unter Verwendung des [JCasC-Plugins](jenkins_configurationAsCode.md) kann man die Secrets dann im Secret-Store anlegen

---

## Classic UI vs. Blue Ocean UI

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

## Benutzer und Berechtigungen

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

## Pipeline Typen - Skripted vs Deklarativ

In einer Scripted Pipeline handelt es sich um reinen Groovy-Code, der genau so integretiert wird wie er da steht. Unter Verwendung von Closures, GStrings, ... hat Groovy an sich schon einen DSL-Touch und kann leicht mit einer deklarativen Pipeline verwechselt werden.

In einer deklarativen Pipeline hingegen hält man sich an die Syntax der DSL, kann aber per `script { // groovy code }` auch Groovy-Code einflechten.

Zentrales Element der

* [skripted Pipeline](https://www.jenkins.io/doc/book/pipeline/#scripted-pipeline-fundamentals) ist `node`
  * [Details](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline)
  * ein Executor/Agent führt einen `node` aus - es Handelt sich beim `node` also um eine Ausführungseinheit
  * eine Unterteilung in `stage`-Abschnitte ist - im Gegensatz zu skripted Pipelines - optional
  * eine Skripted Pipeline kennt das Schlüsselwort `steps` nicht
* [deklarativen Pipeline](https://www.jenkins.io/doc/book/pipeline/#declarative-pipeline-fundamentals) ist `pipeline`
  * [Details](https://www.jenkins.io/doc/book/pipeline/syntax/#declarative-pipeline)
  * Statements dürfen NICHT durch Semikolons getrennt werden
    * Semikolons sind in Groovy optional ... in deklarativen Pipelines sind sie verboten => hieraus läßt sich ableiten, daß der Code nicht einfach vom Groovy-Interpreter verarbeitet wird, sondern vermutlich noch eine Transformation in Groovy-Code erfolgt

Andere Elemente (z. B. `stage`, GString-Support, Nutzung von Shared-Libraries) sind in beiden enthalten. Das macht es für den Newbie echt schwer. Beide Pipeline-Typen verwenden das gleiche Subsystem und verwenden deshalb auch gleiche Sprachelemente.

Besonders schwierig ist die Verwendung von geschweiften Klammern (`{ ... }`). Während die in einer scripted Pipeline eine Groovy-Closure kennzeichnet, handelt es sich in einer declarative Pipeline um syntactic Sugar (man weiß nicht genau, ob das tatsächlich als Closure gehandhabt wird). Stattdessen werden in Declarative Pipelines bei Funktionsaufrufen die runde Klammer verwendet.

Mein Fazit: Selbst nach Jahren der Nutzung fällt es mir nach einer Pause nicht leicht, die Konzepte auseinanderzuhalten und genau zu wissen wie ein Snippet verarbeitet wird.

### Motivation

Aus der [Dokumentation](https://www.jenkins.io/doc/book/pipeline/syntax/#scripted-pipeline):

TLDR:

* "Declarative Pipeline encourages a declarative programming model."
* "Scripted Pipelines follow a more imperative programming model."

> "Unlike Declarative, Scripted Pipeline is effectively a general-purpose DSL built with Groovy. Most functionality provided by the Groovy language is made available to users of Scripted Pipeline, which means it can be a very expressive and flexible tool with which one can author continuous delivery pipelines [...] Scripted Pipeline is serially executed from the top of a Jenkinsfile downwards, like most traditional scripts in Groovy or other languages. Providing flow control, therefore, rests on Groovy expressions, such as the if/else conditionals [...] Another way Scripted Pipeline flow control can be managed is with Groovy’s exception handling support. When Steps fail for whatever reason they throw an exception. Handling behaviors on-error must make use of the try/catch/finally blocks in Groovy [...] The Groovy learning-curve isn’t typically desirable for all members of a given team, so Declarative Pipeline was created to offer a simpler and more opinionated syntax for authoring Jenkins Pipeline. [...] Where they differ however is in syntax and flexibility. Declarative limits what is available to the user with a more strict and pre-defined structure, making it an ideal choice for simpler continuous delivery pipelines. Scripted provides very few limits, insofar that the only limits on structure and syntax tend to be defined by Groovy itself, rather than any Pipeline-specific systems, making it an ideal choice for power-users and those with more complex requirements. As the name implies, Declarative Pipeline encourages a declarative programming model. Whereas Scripted Pipelines follow a more imperative programming model.

"
---

## Modularisierung

Eine Pipeline, bei der alles nacheinander weg in den Pipeline-Code geschrieben wird ist relativ schlecht lesbar, weil unterschiedliche Abstraktionslevel verwendet werden. Es macht mehr Sinn Untermodule/Funktionen zu verwenden, die einen Teilaspekt (z. B. `build`, `deploy`, `checkCodeQuality`) implementieren. Insbesondere bei komplexen Pipelines verbirgt das recht viel Komplexität und macht die Pipeline viel verständlicher.

### Deklarative Pipeline

* [gutes Beispiel](https://www.jenkins.io/blog/2017/10/02/pipeline-templates-with-shared-libraries/)

In referenzierten Beispiel wird die Function `deploy(developmentServer, serverPort)` aufgerufen, die in einer separaten Datei `deploy.goovy` abgebildet ist. Hier wird deutlich, daß die DSL-Sprache eine Verzweigung in Groovy-Code erlaubt. Der Groovy-Code muß folgende Schnittstelle haben:

```groovy
def call(def server, def port) {
  // your groovy code
}
```

---

## Shared Pipeline Libraries

* [Konfiguration](https://www.jenkins.io/blog/2017/06/27/speaker-blog-SAS-jenkins-world/)
* [Video](https://www.youtube.com/watch?v=Wj-weFEsTb0)
* [mehr Details](https://www.jenkins.io/doc/book/pipeline/shared-libraries/)
* [Best Practices und Insights - MUST READ](https://bmuschko.com/blog/jenkins-shared-libraries/)

Shared Libraries bieten der Vorteil von Code-Reuse über Groovy-Functions, die aus der Pipeline aufgerufen werden können. Auf diese Weise können Build-Jobs einer Microservice-Architektur den gleichen Build-Code verwenden oder auch nur Teile davon.

Man kann Shared Libraries auf Global- und Folder-Level definieren. Der große Unterschied ist, daß Folder-Libraries NICHT vertrauenswürdig sind. Sie laufen in der Sandbox ab und bestimmte Aufrufe (z. B. `Jenkins.getInstance()`) sind dann nicht erlaubt und müssen zunächste explizit per "Manage Jenkins - In-process Script Approval" erlaubt werden. Global Shared Libraries sind per Default trusted ... aller Code innerhalb der Shared Libraries ist trusted und es bedarf keines Approvals für den Code `Jenkins.getInstance()`.

Zudem läßt solch pipeline-externer Code leichter testen.

> *ACHTUNG:* Als unerfahrener Groovy-Entwickler ist mir nicht immer bewußt was nun Core-Groovy-Sprachaspekte sind und was nun zur Jenkins-Integration und Jenkins-Magic gehört. Deshalb habe ich mich zunächst sehr schwer damit getan.

### Details

Während der Ausführungszeit werden shared Libraries in den Workspace des Jobs geclont. Dadurch sind die Jobs voneinander isoliert.

### Struktur

```text
(root)
+- src                     # Groovy source files
|                          # ... werden zum Classpath hinzugefügt, wenn die Pipeline ausgeführt wird
|   +- org
|       +- foo
|           +- Bar.groovy  # class org.foo.Bar
+- vars
|   +- foo.groovy          # 'foo' variable ... Functions darin können einfach per "foo.funcA()" in der
|                          # Pipeline genutzt werden es ist keine Instanziierung notwendig
|   +- foo.txt             # help for 'foo' variable
+- resources               # resource files (external libraries only)
|   +- org
|       +- foo
|           +- bar.json    # static helper data for org.foo.Bar
```

In `vars` verwendet man entweder kleinere Helper-Scripte oder Entrypoints, die man direkt aus der Pipeline in einer DSL-like-Syntax aufrufen will. Beispielsweise kann man eine Datei `pipeline_build.groovy` dort ablegen und im Jenkinsfile verwendet man dann einfach `pipeline_build`.

> Das schaut sehr elegant aus, hat mich anfangs aber total verwirrt, weil die Bereitstellung dieser Variable `pipeline_build` Jenkins-Magic ist. [Dieser Artikel]() hat mich erhellt.

### Integration in das Jenkinsfile

Eine Shared Library muß im Jenkins ("Manage Jenkins - Global Pipeline Libraries") konfiguriert werden bevor sie in der Pipeline per `@Library` Annotation (Groovy-Annotation, die von Jenkins ausgewertet wird) zur Nutzung vorbereitet.

```groovy
@Library('my-pipeline@development') _     // alles wird importiert
pipeline_build {                          // Variable pipeline_build wird mit der Closure
  analyzeCode = true                      //    { analyzeCode = true }
}                                         // aufgerufen
```

> Das `_` bedeutet, daß die gesamte Library importiert wird - hier könnte man restriktiver sein. Man kann in "Manage Jenkins - Global Pipeline Libraries" einen Default-Branch definieren, der verwendet wird, wenn keiner explizit (in obigem Beispiel `development`) angegeben ist.

Es handelt sich bei `{ analyzeCode = true }` um eine [Groovy-Closure](https://groovy-lang.org/closures.html) (kann auch leer sein - `{}`), die als Parameter an die Variable `pipeline_build` übergeben und ausgeführt wird.

> HÄÄÄÄÄÄ ... was ist da denn los - einen Parameter an eine Variable übergeben??? Letztlich beinhaltet die Variable `pipeline_build` eine Funktion (dafür hat Jenkins gesorgt - Integrationsmagic). Das Statement `pipeline_build { analyzeCode = true }` sorgt dann für die Ausführung der Funktion mit dem Closure-Parameter ... technisch über `call`. Wollte man das explizit tun wollen, so würden man `pipeline_build()` programmieren.

Die Datei `vars/pipeline_build.groovy` könnte dann so aussehen:

```groovy
def call(body) {
    // Auswertung des Body Blocks
    def params = [branch: "master", analyzeCode: false]   // default values
    body.resolveStrategy = Closure.DELEGATE_FIRST         // Closure-Konfiguration
    body.delegate = params                                // Closure-Konfiguration
    body()                                                // Closure "body" ausführen
}
```

Die Zeilen in der Function `call` sorgen dafür, daß das übergebene Closure-Objekt konfiguriert wird (`resolveStrategy`, `delegate`) und der Closure-Code ausgeführt wird. Damit werden letztlich die übergebenen Parameter (`analyzeCode=true`) und die Default-Werte (`branch: master`) gegeneinander abgemischt und übrig bleibt `params = [branch: "master", analyzeCode: true]`.

Variablen-Code `var/schedule.groovy` kann aber auch so aussehen:

```groovy
import de.cachaca.Scheduler

def call(Map config) {
  def scheduler = new Scheduler()
  if (config.when_day) {

  }
}
```

In dem Fall hat der Parameter auch einen Datentyp (`Map`) ... im vorigen Beispiel war der formale Parameter untypisiert (`body`) und bekam zur Laufzeit eine Closure übergeben. Die Map wird dann folgendermaßen übergeben:

```groovy
schedule when_day: "Saturday"
```

Auch das sieht irgendwie nicht wie Code aus, sondern wie eine DSL. Nur dadurch erreicht, daß man die Klammern (`schedule(when_day: "Saturday")`) beim Aufruf einer Funktion in Groovy weglassen kann. Ein weiteres Indiz dafür, daß man mit Groovy nette DSLs implementieren kann, bei denen die Grenze zwischen Code und Konfiguration verschwimmt.

Außerdem verwendet der Funktionskörper sogar eine Groovy-Klasse aus `src/de/cachaca/Scheduler` - der Einstieg in die Objektorientierung innerhalb von Jenkins-Libraries.

In diesem Fall kann der Code in einer Scripted Pipeline (`Jenkinsfile`) so aussehen (`when_day` und `when_time` sind Funktionsparameter ... in Groovy können die Klammern weggelassen werden - ein Zugeständnis an das Ziel leserliche DSLs schreiben zu können)

```groovy
@Library('my-pipeline@development') _
schedule when_day: "today", when_time: "08:00"
```

aufgerufen werden. Das sind doch schon richtig nett aus und hat gar nicht mehr den Antlitz von Code ... eine der großen Stärken von Groovy: [DSL](https://en.wikipedia.org/wiki/Domain-specific_language)

---

## Jenkins Development Environment

Pipleline-Development ist entweder reines Groovy-Coding (Scripted Pipelines) oder zumindest die Verwendung einer spezialisierten DSL (Declarative Pipelines). Insofern wüde man sich wünschen eine IDE zu benutzen, um den Code zu schreiben ... Auto-Vervollständigung, Debugging - die typischen Dinge aus dem 21. Jahrhundert der Softwareentwicklung.

Das Tooling um Jenkins ist hier leider ein wenig rückständig. Aber dennoch gibt es ein paar Tools, die angeboten werden.

### Jenkins Server

Wer Pipeline-Development machen will braucht unbedingt einen laufenden Jenkins-Server. Darin stehen dann einige Tools zur Verfügung:

* https://JENKINS_SERVER/script
  * Ausführungsumgebung für Scripts
* https://JENKINS_SERVER/pipeline-syntax
  * Code-Snippet Generator
* https://JENKINS_SERVER/directive-generator/
  * Declarative Pipeline Generator
* Job Replay
  * bei jedem ausgeführten Job-Lauf kann man anschließend ein Replay triggern und dabei den Code einmalig anpassen, auch wenn die Pipeline über ein `Jenkinsfile` definiert wurde

### IntelliJ Code Completion

* [Plugin](https://www.triology.de/blog/jenkins-pipeline-plugin-code-vervollstaendigung)

### Pipeline Unit Testing Framework

...

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

### Update-Prozess

Plugins erfahren während der Maintenance einer Minor Version (z. B. 2.235) Updates. Alle Patchversionen (z. B. 2.235.5) werden bei der Installation mit den `latest` Plugins zu dieser Minorversion ausgestattet (z. B. [von hier](https://updates.jenkins.io/2.235/latest/)). Auf diese Weise ist das Ergebnis vom Zeitpunkt des Updates abhängig, d. h. ein Update der Version 2.235.5 im Januar kann zu einem anderen Endergebnis führen wie das Update der gleichen Version im März - höchstwahrscheinlich sogar, wenn die Version noch gut maintained ist.

[Jenkins Plugin-Installation-Manager-Tool](https://github.com/jenkinsci/plugin-installation-manager-tool) kümmert sich bei einem Update der Plugings auch um die Abhängigkeiten, so daß am Ende eine zueinander passende Plugin-Kollektion stehen sollte.

### AnsiColor Plugin

* so sind die Logfiles leichter zu lesen

### Office 365 Connector Plugin

Mit diesem Plugin klappen auch Microsoft Teams Notifications aus Jenkins Pipelines heraus.

---

## Integrationsmöglichkeiten

### REST-API

* [Dokumentation](https://www.jenkins.io/doc/book/using/remote-access-api/)

Im einfachsten Fall verwendet man `curl` als Client ... es wird aber auch eine [Python Library](https://pypi.org/project/jenkinsapi/) angeboten.

### API-Token

Will man beispielsweise Jobs remote starten, um so beispielsweise einen Jenkins Build Server mit einem Jenkins Deploy Server zu koppeln, so benötigt man dazu natürlich (Jenkins ist der Hochsicherheitstrackt) Credentials. Jenkins unterstützt hierzu API-Tokens, die an einem User hängen und dessen Berechtigungen verwenden.

---

## Groovy-Scripts

Jenkins in Java geschrieben ist und bietet die [API](https://javadoc.jenkins.io/) für die Verwendung in Pipelines und in der Script Console (https://JENKINS/script) in Form von Groovy-Code an. Groovy wird gerne für solche Custom-Extensions verwendet, da der Code zur Laufzeit interpretiert wird (und nicht erst umständlich compilert werden muss).

Allerdings sind viele Library-Calls defaultmäßig aus Sicherheitsgründen verboten. So führt

```groovy
#!/usr/bin/env groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
    println it.fullName + " - " + it.class
};
```

in einer Pipeline zur Fehlermeldung (in der Script-Console "https://JENKINS/script" ist das hingegen erlaubt!!!)

> staticMethod jenkins.model.Jenkins getInstance Approving this signature may introduce a security vulnerability! You are advised to deny it.

![Script Approval](images/jenkins-scriptApproval.png)

Durch clicken innerhalb der Fehlermeldung kann das Approval erteilt werden. Innerhalb von "Manage Jenkins - In-process Script Approval" kann man sich alle Approvals ansehen (https://JENKINS/scriptApproval/).

> ACHTUNG: Script-Approvals bürgen Security-Issues

### Script Beispiele

```groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
    println it.fullName + " - " + it.class
};
```

```groovy
Jenkins.instance.getAllItems(org.jenkinsci.plugins.workflow.job.WorkflowJob.class).each {
    println it.fullName + " - " + it.class
};
```

---

## Entwicklungsumgebung

* [VSCode - Jenkins Doc](https://marketplace.visualstudio.com/items?itemName=Maarti.jenkins-doc)

### Syntaxcheck des Jenkinsfiles - manuell

Mit dem "Replay"-Button auf der Web-UI kann kann schon ganz gut agieren ... ist dann halt immer copy-paste aus dem Editor.

### Syntaxcheck des Jenkinsfiles - CLI

Ein Jenkins-Server bietet den  [Endpunkt "pipeline-model-converter/validate"](https://www.jenkins.io/doc/book/pipeline/development/#linter) an, mit dem sich die Syntax eines `Jenkinsfiles` überprüfen läßt. Mit einem `JENKINS_CRUMP` läßt sich das auch per `curl` durchführen:

```bash
_serverUrl=
_user=
_password=
_apiToken=
_pathToJenkinsfile=
JENKINS_CRUMB=`curl --insecure --user ${_user}:${_apiToken} "${_serverUrl}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"`
curl --insecure --user --user ${_user}:${_apiToken} -X POST -H $JENKINS_CRUMB -F "jenkinsfile=<${_pathToJenkinsfile}" ${_serverUrl}/pipeline-model-converter/validate
```

läßt sich das automatisieren ... allerdings kann man die Pipeline dann nicht einfach ausführen. Das geht in der Web-UI natürlich sehr komfortabel.

> ACHTUNG: man sollte sich gut überlegen, ob man das `_password` tatsächlich preisgeben will (Command History) - ich empfehle, einen API-Token zu generieren und zu verwenden.

Einige Editoren (Eclipse, Visual Studio Code) bieten eine [Linter-Integration](https://www.jenkins.io/doc/book/pipeline/development/#ide-integrations). Dabei werden die Curl-Requests im Hintergrund ausgeführt ... für manche User ein wenig komfortabler, aber das gleiche Prinzip.

### Jenkinsfile lokal ausführen

Mit dem [Plugin "Jenkins Runner"](https://marketplace.visualstudio.com/items?itemName=dave-hagedorn.jenkins-runner) habe ich versucht, eine komplette Integration von `Jenkinsfile`-Dateien in Visual Studio Code abzubilden.

Mein Ziel war `Jenkinsfile` editieren und danach das Kommando "Jenkins Runner - Run Pipeline Script on Default Job" in Visual Studio Code auszuführen. In der Hoffnung, daß dann der in `settings.json` konfigurierte (und manuell in Jenkins angelegt) Job angepaßt wird und ich so meine Änderungen testen kann.

Die ersten Schwierigkeiten mit https (mein Server-Zertifikat wurde nicht akzeptiert => http erlaubt) und Authentifizierung (ich habe einen API-Token verwendet) konnte ich noch umschiffen.

An der Meldung

> "ERROR ... does not have the envinject plugin installed - cannot use set environment variables for this job"

bin ich dann allerdings gescheitert. Nach Installation des Plugins und Jenkins Restart blieb die Fehlermdelung hartnäckig ... selbst bei dieser minimalen Pipeline:

```Jenkinsfile
pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
```

Ich habe diese Idee nicht weiter verfolgt - kein Blocker ... wäre nur nice-to-have gewesen.
