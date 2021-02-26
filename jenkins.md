# Jenkins

* [Dokumentation](https://jenkins.io/doc/)
* [Handbuch](https://jenkins.io/doc/book/)

Jenkins wird zur Automatisierung von Builds (hiermit hat alles begonnen) und Deployments verwendet.

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
  * hier sollten alle 3 Monate neue Versionen kommen ... war in 2020 aber noch nicht stabil
  * wie lange werden alte LTS gepflegt?

Hersteller wie CloudBees (CloudBees Jenkins Enterprise) bieten Lösungen basierend auf dem OpenSource Stack. Hier gibt es dann AWS-Templates, um ein skalierbares Jenkins-Cluster zu erhalten. Jenkins kommt out-of-the-box vielleicht nicht mit voller Vielfalt daher, aber es scheint genug Potential zu haben, daß es bekannte Unternehmen als Basis für ihre Produkte verwenden.

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

Aus diesem Grund MUSS der Zugriff auf Jenkins komplette abgesichert werden, d. h.

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

## Jenkins Development Environment

Pipleline-Development ist entweder reines Groovy-Coding (Scripted Pipelines) oder zumindest die Verwendung einer spezialisierten DSL (Declrative Pipelines). Insofern wüde man sich wünschen eine IDE zu benutzen, um den Code zu schreiben ... Auto-Vervollständigung, Debugging - die typischen Dinge aus dem 21. Jahrhundert der Softwareentwicklung.

Das Tooling um Jenkins ist hier leider ein wenig rückständig. Aber dennoch gibt es ein paar Tools, die angeboten werden.

### Jenkins Server

Wer Pipeline-Development machen will braucht unbedingt einen laufenden Jenkins-Server. Darin stehen dann 

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