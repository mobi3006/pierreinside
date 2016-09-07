# Maven

* Refcardz maven 2: https://dzone.com/refcardz/apache-maven-2

**TODO ... REWORK NEEDED ...**

* http://www.sonatype.com/books/maven-book/reference/

Build-Tool der Apache Foundation - Apache preist maven als Projektmanagement-Tool an, weil es auch Reports erzeugen kann und die Kommunikation der Entwickler unterstützt. Es ist also mehr als ant, mehr als nur ein Build-Tool.

Die in ant genannten "Targets" heißen bei Maven "Goals", sie können wie bei ant als Parameter angegeben werden, um bestimmte Ziele zu erreichen (z. B. maven clean build).

Hier ein Beispiel:

```
maven eclipse:eclipse
```

ruft das Goal ``eclipse`` (hinter dem Doppelpunkt) im PlugIn mit dem Namen ``eclipse`` (vor dem Doppelpunkt) auf.

---

# Repositories

Maven unterscheidet zwischen 

* **Remote-Repository:** Der maven-Bauprozess kann  mehrere Remote-Repositories verwenden, von denen als Dependency formulierte notwendige Bibliotheken (bei Maven 2 auch Plugins) runtergeladen werden. Eine andere Lösung besteht darin, nicht die Clients mit unterschiedlichen Repositories zu konfigurieren, sondern lokal einen Repository Manager aufzusetzen und diesen so zu konfigurieren, daß externe Artefakte automatisch aus anderen Repositories gezogen und gecached werden (siehe unten Nexus Reposititory Manager).
* **Local-Repository:** liegt lokal auf der Festplatte und hier gibt es nur eins. Durch das lokale Repository ist das Arbeiten im Offline-Modus (also z. B. auch ohne Netzwerkverbindung) möglich. 
 
Im Online-Modus wird der Timestamp der lokalen Bibliothek mit dem der Remote-Bibliothek verglichen und nur bei Änderungen am Remote-File erfolgt ein Download in das Local-Repository.

Maven ist eng mit der Nutzung eines Continous Integration (CI) Prozesses verbunden. Eine typische CI-Infrastruktur besteht aus Subversion und Jenkins. Jenkins prüft in regelmäßigen Abständen, ob Commits im Subversion stattgefunden haben. Wenn ein Commit erfolgt ist, wird die Komponente z. B. per maven gebaut und im Falle eines Erfolges aufs Remote-Repository kopiert/deployed. Dadurch stehen auf dem Remote-Repository immer die aktuellsten Bibliotheken/Artefakte zur Verfügung, die dann beim Bauen per maven durch andere Entwickler automatisch sofort genutzt werden (falls diese im Online-Modus arbeiten). Innerhalb eines Entwicklungsprojekts wird man also ein Remote-Repository aufsetzen (Stichwort Nexus Repository Manager: http://nexus.sonatype.org/) - in einem solchen Projekt-Repository lassen sich auch einige der bekannten Repositories sind Apache (von hier zieht man sich auch die maven-2-Plugins), Codehaus, ...

## Nexus Repository Manager

Jeder, der Continous Integration mit maven abbildet, kommt nicht umhin einen Repository Manager aufzusetzen oder einen zu verwenden. Für Closed-Source-Projekte wird man einen eigenen Repository Manager aufsetzen (z. B. Nexus Repository Manager: http://nexus.sonatype.org/), da man die Artefakte sicher nicht öffentlich bereitstellen will.

Der Nexus Repository Manager ist ein Tool zur Verwaltung von Build-Artefakten. Man unterscheidet:

    Proxied/Cached-Artefakte
        Cached Artefakte werden von öffentlichen Repositories runtergeladen (z. B. http://repo2.maven.org/) und lokal gespeichert (z. B. Third-Party-Libs).
        Warum cached man die 3rd-Party Libs?
            einfache Konfiguration: jeder SVN-Client muss nur ein einziges Repository angeben (nämlich den lokalen Nexus) und kann auch "beliebige" Third-Party-Artefakte nutzen
            die lokale Speicherung verhindert, daß die Artefakte irgendwann mal nicht mehr verfügbar sind (dauerhaft oder temporär) und ich somit meine eigenen Artefakte nicht mehr bauen kann 
    Hosted-Artefakte
        eigene Artefakte, die nur lokal (im eigenen Repository-Manager) bereitgestellt werden

Technisch besteht der Repository-Manager aus einem WAR, das beispielsweise in Tomcat deployed wird.
maven 1 vs. maven 2
Ein Parallelbetrieb ist problemlos möglich, da die Programme und Umgebungsvariablen unterschiedlich heißen

Unterschiede:

    executable: maven vs. mvn
    MAVEN_HOME vs. M2_HOME
    MAVEN_REPO_LOCAL vs. ???
    project.xml vs. pom.xml
    transitive Abhängigkeiten - siehe Abschnitt maven 2

Gemeinsamkeiten:

Beim Bauen erzeugt maven dann folgende Verzeichnisse:

    cache: hier liegen maven plugins drin - mit maven plugins kann der Maven-Prozess erweitert werden
    repository: lokales maven Repository, das Downloads vom Remote Maven Repository hosted und lokal gebaute Bibliotheken (jars) beheimatet. Baue ich lokal ein Projekt A, dann wird das erzeugte A.jar ins lokale Repository kopiert. Checke ich meine Änderungen ein, so wird das Projekt A zentral gebaut und die A.jar-Datei ins Remote-Repository kopiert. Baut anschließend jemand ein Projekt B, das von A abhängt (also verwendet), so wird festgestellt, daß die im lokalen Repository befindliche A.jar Datei veraltet ist und downloaded sie vom Remote-Repository, um anschließend B.jar zu bauen.

Wichtige Schalter:

    -o: Offline mode - keine Updates vom Remote Repository ins Local Repository
    -g: zeige alle verfügbaren Goals

Maven 2
Viele OpenSource-Projecte (Spring, Hibernate, Apache ...) deployen ihre Artefakte ins offizielle Maven 2 Repository: http://search.maven.org/. Somit ist das eine gute Anlaufstelle für öffentliche Libs. Für ein Projekt wird man sein eigenes Repository aufsetzen, so daß die gebauten Artefakte nur lokal verfügbar sind - die öffentlichen zieht man sich aus einem öffentlichen Repository.

---

# Maven Konzepte
## Convention over Configuration

Maven definiert eine Standard-Verzeichnisstruktur für Komponenten. Hält man sich an diese Verzeichnisstruktur muss man wesentlich weniger im ``pom.xml`` (maven 2) bzw. ``project.xml`` (maven 1) konfigurieren (im Gegensatz zu ant, bei dem man all diese Dinge konfigurieren muss).

Standardverzeichnisstruktur:

    src/
      main/
        java/
        resources/
      test/
        java/
        resources/
    target/
      classes/

---

## Project-Object-Model ... pom.xml

Die ``project.xml`` von maven 1 wurde ersetzt durch die ``pom.xml``. Darin werden u. a. folgende Aspekte behandelt:

    Module:
        eine pom.xml kann Untermodule haben. Auf diese Weise lässt sich eine Hierarchie aufbauen, so daß ein mvn install auf oberster Ebene zu einem mvn install auf den darunterliegenden Modulen/Projekten führt
        im Gegenzug können darunterliegende Komponenten die pom.xml darüberliegender Ebenen referenzieren, so daß die Konfigurationen wiederverwenden kann
            strenggenommen müssen nicht darüberliegende pom's referenziert werden, denn die Referenzierung erfolgt über die übliche Artefakt-Identifizierung (die pom bildet eben auch ein Artefakt), welche wiederum über das lokale Repository aufgelöst wird (evtl. wird das Artefakt zuvor von einem Remote-Repository geladen)

So siehts in der parent-pom aus:

```xml
<groupId>com.icw.ehf.test</groupId>
<artifactId>ehf-template-test-parent-pom</artifactId>
<version>2.12-SNAPSHOT</version>
<packaging>pom</packaging>
```

und so wird das Artefakt in einer anderen pom als parent referenziert:

```xml
<parent>
<groupId>com.icw.ehf.test</groupId>
<artifactId>ehf-template-test-parent-pom</artifactId>
<version>2.12-SNAPSHOT</version>
</parent>
```

    distributionManagement
    repositories
    pluginRepositories
        wo kann sich maven plugins ziehen?
    pluginManagement
    Konfiguration von Plugins 

<pluginManagement>
<plugins>
<plugin>
<groupId>org.apache.maven.plugins</groupId>
<artifactId>maven-project-info-reports-plugin</artifactId>
<version>2.1.1</version>
<configuration>
<dependencyLocationEnabled>false</dependencyLocationEnabled>
<dependencyDetailsEnabled>false</dependencyDetailsEnabled>
</configuration>
</plugin>
</plugins>
</pluginManagement>

    reporting
    Profilkonfiguration
        Profile werden verwendet, um das Verhalten von maven für verschiedene Nutzungsszenarien (z. B. ohne Tests) und Situationen (z. B. wenn JDK 1.4 verwendet wird, dann gelten andere Konfigurationen)
        innerhalb eines Profils kann man dann beispielsweise Properties setzen, Plugins konfigurieren,

Identifikation eines Moduls:

Ein Modul wird eindeutig identifiziert durch folgende Parameter:

    GroupId: z. B. com.thoughtworks.xstream
    ArtefaktId: z. B. xstream
    Version: z. B. 1.2
    Packaging: z. B. jar, pom, war

Dadurch wird das Modul eindeutig als com.thoughtworks.xstream:xstream:jar:1.2 identifiziert. Die Artefakte dieses Moduls sind dann im Repository (z. B. http://repository.codehaus.org) in folgendem Verzeichnis zu finden:

com/
thoughtworks/
xstream/
xstream/
1.2

siehe auch hier: http://repository.codehaus.org/com/thoughtworks/xstream/xstream/1.2/

 Lebenszyklus:

siehe hier: http://www.sonatype.com/books/maven-book/reference/simple-project-sect-lifecycle.html

Die Maven-2-Philosophie unterscheidet sich stark von maven 1. Während man in maven 1 nur Goals aufruft, verwendet man in maven 2 Phasen. Im folgenden sind die Hauptphasen aufgeführt (es gibt noch fein-granularere Phasen):

    validate
    compile
    test
    package
    integration-test
    verify
    install
        kopiert die Artefakte ins lokale Repository
    deploy
        kopiert die Artefakte in ein Remote-Repository

Jede Phase wiederum besteht aus dem Aufruf verschiedender Goals verschiedener Artefakte. Die Phasen bringen von der Core-Maven-Engine bereits Standard-Goals mit, doch der Lifecycle kann durch die pom.xml-Datei erweitert werden, indem Plugins an die Lifecycle-Phasen gebunden werden.

Wenn man z. B. mvn install aufruft, dann laufen die Phasen validate, compile, test, package, integration-test, verify und install ab. Insofern bringt man die Software bis zu einem bestimmten Zustand - die Goals sind somit auf einem deutlich abstrakteren Level als der pure Goal-Aufruf bei maven 1. Jede Phase besteht aus 1-n Schritten, die Goal-Aufrufe verschiedener Plugins sind. Als jemand, der ein Projekt aus dem Versionssystem runterlädt kann es mit dem Standardaufruf mvn install ohne detaillierte Kenntnisse der Goals bedienen (ist bei maven 1 nicht so einfach möglich). In der pom.xml steht alles notwendige, um die Software in den Zustand install zu versetzen. Bei mvn install auf einem per Archetype erzeugten Projekt sieht die Aufrufreihenfolge folgendermassen aus (Auszug aus dem Log):

[INFO] [resources:resources {execution: default-resources}]
...
[INFO] [compiler:compile {execution: default-compile}]
...
[INFO] [resources:testResources {execution: default-testResources}]
...
[INFO] [compiler:testCompile {execution: default-testCompile}]
...
[INFO] [surefire:test {execution: default-test}]
...
[INFO] [jar:jar {execution: default-jar}]
...
[INFO] [install:install {execution: default-install}]

Durch maven-Plugins können die einzelnen Schritte der Phasen erweitert/angepasst werden.

Man kann natürlich auch noch einfach PlugIn-Goals aufrufen: z. B. mvn dependency:resolve oder mvn eclipse:eclipse. Jede beliebige Software, die maven zum Build verwendet lässt sich per mvn install bauen, testen und local installieren.

Hier ist das ganz schön dargestellt: http://www.sonatype.com/books/maven-book/reference/installation-sect-common-interface.html

PlugIn-Installation:

Es genügt, das maven-Repository (http://repo1.maven.org/maven2) in der pom.xml zu definieren und dann die gewünschten Goals eines PlugIns zu verwenden. Ein Beispiel von der Kommandozeile (der automatische Download und Installation bei Verwendung von Plugins im pom-File funktioniert genauso gut):

mvn dependency:resolve

Hierdurch wird das dependency-Plugin für maven2 (http://maven.apache.org/plugins/maven-dependency-plugin/) runtergeladen und genutzt. Verwendet man eine Phase als Goal (z. B. mvn install), dann werden alle notwendigen Plugins automatisch runtergeladen (sofern sich ein Repository in der pom.xml befindet, die es anbietet).

Für PlugIns wird das gleiche Updateverfahren wie für als Dependency definierte Artefakte. Es wird immer geprüft, ob auf dem Remote-Repository ein neueres PlugIn verfügbar ist. Wenn das der Fall ist, dann wird es runtergeladen und verwendet. Auf diese Weise arbeitet man immer mit den neuesten PlugIns - was natürlich besondere Anforderungen an die BAckward-Compatibility der PlugIns stellt.

Transitive Abhängigkeiten:

Angenommen

Modul A depends on Modul B depends on Modul C

In Maven 1 musste man in Modul explizit eine Abhängigkeit zu Modul C aufführen. Das hat erstens das Information-Hiding-Prinzip verletzt aber zweitens - und das ist in der Praxis viel entscheidender - hat es zu Maintanance-Problemen geführt, denn bei Änderungen an den Dependencies von Modul B mussten automatisch die Dependencies von Modul A angepasst werden. Ansonsten konnte es zu fehlenden Abhängigkeiten führen, die in einem gebrochenen Build resultieren :-(

Maven 2 kann diese transitiven Abhängigkeiten selbst auflösen - bei Lesen des pom.xml von Modul A wird die Abhängigkeit zu Modul B festgestellt. Maven erreicht das durch Deployment der pom.xml-Datei parallel zu den Artefakten, d. h. wenn die Maven-Engine die Abhängigkeit des Moduls A von Modul B erkennt, dann lädt es die Artefakte (u. a. Bibliotheken, pom.xml) vom Repository und liest dann die pom.xml vom Modul B und wiederholt den Vorgang - ganz einfach :-)

In der Theorie klingt das richtig gut. ABER: die Praxis lässt einen das ein oder andere mal fluchen. Ein paar Beispiele:

    Problem 1: Versionskonflikt

    Assembly verwendet Modul A, das wiederum transitiv Modul Z in Version 1.1 verwendet
    Assembly verwendet Modul B, das wiederum transitiv Modul Z in Version 1.4 verwendet

Rein technisch gesehen würden beide jars (modul-Z-1.1.jar und modul-Z-1.4.jar) in den Classpath wandern (die Reihenfolge ist vermutlich nicht definiert) und das könnte fatale Folgen haben. Deshalb muss das Assembly an dieser Stelle verhindern, dass Version 1.1 verwendet wird

<dependency>
<groupId>...</groupId>
<artifactId>modul-A</artifactId>
<exclusions>
<exclusion>
<groupId></groupId>
<artifactId>modul-Z</artifactId>
</exclusion>
</exclusions>
</dependency>
<dependency>
<groupId>...</groupId>
<artifactId>modul-B</artifactId>
</dependency>


Aufgrund der erwarteten Abwärtskompatibilität (syntaktisch und hoffentlich auch semantisch) innerhalb eines Minor-Releases (1.1 -> 1.4) sollte das Modul A, das gegen Modul Z in Version 1.1 programmiert und getestet hat, auch mit Modul 1.4 zurechtkommen.
Schwieriger wird die Sache, wenn ein Major-Release die beiden trennt ... beispielsweise 1.1 und 2.4. Dann läuft Modul A evtl. nicht mehr mit Version 2.4 des Modul Z. Dann muss man sich was anderes überlegen oder es einfach mal auf einen Versuch ankommen lassen (ich meine natürlich compilieren und wenn das geht ordentlich testen).

Bei Versionsänderungen führt diese Problematik regelmässig zu Freudensprüngen ;-)

Maven 2 kann hier prinzipiell nichts dafür ... in diese Versionsproblematik kommt man immer. Es ist eben ein semantisches Problem und kein technisches. Leider wird man nicht darauf aufmerksam gemacht ... oder gibt es da Tools?

    Problem 2: Lizenzproblematik

Im professionellen Umfeld macht man i. d. R. einen Bogen um GPL, LGPL oder ähnliche Lizenzen, weil es im worst-case zur Folge hat, daß man seinen eigenen Code veröffentlichen muss. Das kann das Geschäftsmodell ganz schön durcheinanderbringen.
Durch die transitive Abhängigkeitsauflösung, zieht man sich automatisch weitere Bibliotheken rein, die man nicht explizit referenziert hat. Wenn sich darunter vielleicht eine unangenehme Lizenz befindet (und vielleicht war die Lizenz von Version 1.3 noch unkritisch aber plötzlich in Version 1.3.1 bedenklich), dann kanns schnell gefährlich werden. Deshalb ist die ständige (automatisierte) Prüfung der Lizenzen absolut erforderlich.

Aufbau eines Repositories:

Remote- und Local-Repository haben folgenden Aufbau:

groupid/
artefactId/
pom-file
metadata....xml
maven-metadata.xml

Archetypen:

Archetypen sind Templates zur Erstellung eines Maven-Projekts (in maven 1 wird das vom genapp-Plugin erledigt). Hier findet man eine kleine Einführung: http://www.sonatype.com/books/maven-book/reference/simple-project-sect-create-simple.html. Durch den Befehl

mvn archetype:generate
-DgroupId=de.cachaca.learn.maven2
-DartifactId=de.cachaca.learn.maven2.simple
-DpackageName=de.cachaca.learn.maven2
-Dversion=1.0-SNAPSHOT

wird ein Maven2-Projekt erzeugt. Es wird hierbei interaktiv über die Kommandozeile noch der Archetyp abgefragt - hier gibt es bereits für verschiedene Technologien vordefinierte Archetypen (jsf, osgi, jpa, myfaces, cocoon, scala, wicket, ...). Ein ganz einfacher Archetype ist die Nummer 15 "maven-archetype-quickstart". Das erzeugte Projekt hat bereits die Standardverzeichnisstruktur und sogar eine ausführbare Java-Klasse mit Tests.

Durch

cd de.cachaca.learn.maven2.simple
mvn install
java -cp target/de.cachaca.learn.maven2.simple-1.0-SNAPSHOT.jar de.cachaca.learn.maven2.App

kann man die erzeugte HelloWorld-Klasse bauen und starten.

pom-Hierarchie:

siehe hier: http://www.sonatype.com/books/maven-book/reference/simple-project-sect-pom.html

Die pom.xml-Datei eines maven2-Projekts ist nur ein Teil der tatsächlich verwendeten pom.xml-Datei. Maven-Settings, User-Settings, Super-POMs, ... erweitern die projektspezifische POM-Datei. Per mvn help:effective-pom kann man die tatsächlich verwendete POM-Datei einsehen.
Einige Maven Plugins
Die Core-Maven-Engine ist ziemlich dumm und weiss nichts darüber wie man ein Projekt baut. Sie weiss nur, wie man eine pom.xml-Datei liest/interpretiert, Plugins automatisch downloaded und den Classpath erweitert. Das Salz in der Suppe sind die Plugins.
Maven und Eclipse:
Verwendet man maven und Eclipse als Entwicklungsumgebung, so ist es eher unüblich die .classpath und .project Dateien im Versionierungstool zu halten, denn diese Dateien sind redundant zum Maven Project Object Model (POM) - sie können daraus generiert werden. Hat man das entsprechende maven-Plugin installiert, so werden die Dateien einfach per "maven eclipse" (bei maven 1.x) erzeugt.
Maven 2:
Ich wollte mit Maven 2 die Selenium-IDE (Subversion-URL) per mvn package bauen und bekam sofort die Fehlermeldung

BUILD ERROR The plugin 'org.apache.maven.plugins:maven-resources-plugin' does not exist or no valid version could be found

Ich hatte scheinbar einfach nicht das erforderliche Plugin. Doch eigentlich hätte ich eine Reihe von Standard-PlugIns bei der Installation von Maven 2 von maven.apache.org erwartet, doch meine Installation hat nicht einmal ein plugin Verzeichnis. Entweder sind tatsächlich keinerlei PlugIns installatiert oder ich habe einen Fehler in der Konfiguration.

Das mvn-Shell-Skript sieht zunächst mal gut aus und scheint auch die cygwin Inkompatibilitäten hinsichtlich der Windows-Pfade zu berücksichtigen (interessant, dass cygwin solch breite Unterstützung erfährt). Um diese Fehlerquelle gänzlich auszuschalten, probiere ich es einfach mal unter einer DOS-Shell aus. Doch "glücklicherweise" mit dem gleichen Ergebnis. Bleibt mir also nur das Forschen nach den PlugIns.

Die Plugins finde ich schnell auf der Apache-Site, doch die Installation wird nicht erklärt. Ich habe den Hinweis gefunden 71234 ,

mvn -U clean

würde alle PlugIns installieren, die zur Ausführung des Goals clean erforderlich sind. Doch da bekomme ich auch nur eine Fehlermeldung. Nach Angabe eines Proxy-Servers (den ich hier in der Firma brauche) in $MAVEN2/conf/settings.xml klappt es :-) Meine Selenium-IDE builde ich per mvn -U package. Anschließend finde ich die Plugins in ~/.m2/repository (ich habe keine speziellen Repository-Umgebungsvariablen gesetzt).

# Remote-SNAPSHOT-Abhängigkeiten ... DONT DO THIS

Das Wesen von maven ist die Bereitstellung von SNAPSHOT-Artefakten in einem Remote-Repsoitory. Die Frage ist allerdings: "Wer soll die benutzen?"

Als Maven-Anfänger war ich der Meinung, daß ich diese Remote-SNAPSHOT-Artefakte vom Remote-Maven-Repository benötige, weil ich dann viel weniger lokal bauen muss. Das ist einerseits richtig, ABER: das ist fehleranfällig, weil:

    die SNAPSHOT-Artefakte vom Remote-Maven-Repository evtl. nicht zu meinem Sourcecode Dateien passen. Ich müsste bei jedem Abgleich der Artefakte auch den lokalen Source-Baum MIT GENAU DEN SOURCEN updaten, die zu genau diesem Artefakt geführt haben
        das Problem zeigt sich dann häufig, wenn man den Debugging-Prozess so konfiguriert hat, dass die lokalen Sourcen verwendet werden. Die sind dann natürlich out-of-sync und der Debugger geht durch nicht ausführbare Zeilen - weil Bytecode und Sourc-Code out-of-sync sind
    ich bekomme Artefakte fehlgeschlagener Builds ... ich habe dann Artefakte eines Commits runtergeladen, das nicht beim ersten gebauten Modul fehlschlägt, sondern erst wesentlich später. Somit bekomme ich einen nicht-konsistenten Stand. Die Analyse kostet mich evtl. mehrere Stunden
    man weiss nicht, welche Codestand die Artefakte widerspiegeln und wie der zu meinem lokalen Sourcecode-Stand passt. Auch das kann mich Stunden kosten - insbesondere wenn ich sich um semantische Probleme tief im Code handelt und nicht Probleme, die zur Compilezeit oder Laufzeit mit einer Exception abbrechen
    neuere Artefakte überschreiben meine lokalen Builds. Klar kann ich mit "-o" in den offline-Mode gehen. Aber das kann ich nicht mehr machen, wenn ich neue Stable-Version (z. B. Third-Party-Libs) ziehen muss. Dann muss ich Online gehen und zerstöre mir meinen lokalen Stand.
        eine Lösung hier: Trennung zwischen stable-version-synchronisierung (GUT) und snapshot-synchronisierung (SCHLECHT)

Letztlich möchte ich während der Entwicklung meines Features relativ isoliert arbeiten. Und das funktioniert auch in Teamwork - ich muss also nicht Alleinkämpfer sein. Ich muss nur mein Arbeitsverhalten leicht ändern. Wenn ich mit jemandem zusammenarbeite und der committet, dann mach ich lokal ein update und baue alle relevanten Module neu.

**Deshalb empfehle ich:**

    keine Remote-Snapshot-Artefakte mehr verwenden - das kann man in den maven-settings einstellen. Es werden nur noch stable-Snapshots gezogen.
    der Offline-Mode kann helfen solange man keine updates von Stable-Versions (beispielsweise von Third-Party-Libs) machen muss. Vor dem Wechsel in den Offline-Mode (am sichersten in den settings.xml - <offline>true</offline> eintragen, da man es sonst vielleicht vergisst (-o) oder die MAVEN_OPTS nicht auf jeder Shell gesetzt sind) sollte man aber im Root ein "mvn dependency:go-offline" machen damit sichergestellt ist, daß alle Goals/Phasen auch tatsächlich offline funktionieren.
        ABER bedenke: das ist nur ein Workaround - eigentlich braucht man ein Exclude-SNAPSHOT-Artefakts-from-Download

## Ist das noch immer Continous Integration?

Ziel des Continous Integration ist ein Fail-Fast zu erreichen. Aus meiner Sicht ist dafür der Jenkins/Hudson zuständig, der ständig den kompletten Source-Tree auscheckt und alles neu baut. Hier kann man Optimierungen vornehmen und ein für den Jenkins lokales maven-Repository aufsetzen, um nicht immer alles neu bauen zu müssen, wenn sich ganz oben was ändert.

Continous Integration dient dem Gesamtprodukt und ist ein gutes Feedback, das man berücksichtigen sollte. ABER: es darf nicht dazu führen, daß die Entwickler in ihrer Geschwindigkeit ausgebremst werden. Und genau dazu führt die Verwendung von Remot-Snapshot-Abhängigkeiten. Und diese Aussage gilt auch, wenn es 30 Minuten dauert, um den gesamten Source-Tree durchzubauen. Das muss man nur ganz selten machen. Danach erfolgen Builds nur noch sehr selektiv und auch nur dann wenn man mit anderen zusammenarbeitet. Arbeitet man allein, kann man alles lokal machen. In den Offline-Mode kann man oftmals nicht gehen, weil manchmal doch stable-Versions gebraucht werden (weil man ein Goal aufruft, das weitere Plugins benötigt oder weil sich am pom-File was geändert hat). Hat man den eigenen Meilenstein erreicht, committet man - hierauf sollte man mit Hinblick auf den Continous Integration Gedanken nicht allzu lange Warten (eher im Stunden/Tage-Bereich als im Tage/Wochen-Bereich). Hierzu sollte man mit den aktuellen Sourcen synchronisieren und wird dann ein "svn update" machen (was dann wiederum einen lokalen Build vieler Module nach sich zieht).
Ant vs. Maven
siehe hier: http://www.sonatype.com/books/maven-book/reference/installation-sect-compare-ant-maven.html

# Maven ist langsam
* https://zeroturnaround.com/rebellabs/your-maven-build-is-slow-speed-it-up/

## Option: Parallelisierung der Module-Builds
Je nach Modulabhängigkeiten ist eine parallele Verarbeitung der Module-Builds möglich:

```
mvn -T 4 install
```

Auf diese Weise werden im Maximalfall 4 parallele Threads genutzt. Die Module müssen natürlich dennoch in der richtigen Reihenfolge gebaut werden, von den Ästen zur Wurzel. Parallele Geschwisterprojekte lassen sich aber unabhängig voneinander parallel bauen.

## Option: Parallelisierung der Testausführung
Die Reihenfolge der Tests sollte eigentlich - bei sauberer Testausführung - keine Rolle spielen ... zumal die Reihenfolge von vielen Aspekten abhängig ist und sich zwischen den Java-Versionen, Betriebssystemen unterscheidet. 

Deshalb sollte die Parallelisierung der Testausführung eine gute Option sein.

## Option: nur notwendige Module bauen
Hat man eine Änderung in Modul A vorgenommen, dann will man i. a. nur Modul A und alle davon abhängigen Module bauen:

```
mvn install -pl modules/moduleA -am
```
