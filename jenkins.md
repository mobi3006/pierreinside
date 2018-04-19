# Jenkins

Jenkins wird zur Automatisierung von Builds und Deployments verwendet.

## Getting Started

Am einfachsten gelingt der Start mit einem Docker-Container, denn hier gibt es schon fertige Docker-Images, die man innerhalb weniger Sekunden am Laufen hat.

## Plugins

Jenkins zeichnet sich gegenüber anderen Build-Tools dadurch aus, daß es eine Fülle an Plugins gibt.

## Pipelines

* [Jenkins-Pipelines Dokumentation](https://jenkins.io/pipeline/getting-started-pipelines/)
* [Syntax](https://jenkins.io/doc/book/pipeline/syntax/)

Als *Pipelines* werden die Build-Jobs bezeichnet - sie bestehen aus i. a. aus meheren Steps, die in Form einer Pipeline-DSL (DSL = DomainSpecificLanguage) beschrieben werden. Jenkins benötigt für die Abarbeitung von Pipelines das [Pipeline-Plugin](https://wiki.jenkins.io/display/JENKINS/Pipeline+Plugin).

### Multibranch vs. Singlebranch

In einem Git-basierten Enwticklungsansatz verwendet man i. a. separate Branches für Bugfixings/Features. Insofern würde man hier eine Multi-Branch-Pipeline brauchen. Für Release-Pipelines verwendet man Single-Branch-Pipelines.

### Pipeline Spezifikation

Die Spezifikation einer Pipeline kann im Git-Repository des Projekts über eine Datei beliebigen Namens (z. B. `Jenkinsfile`) erfolgen. Damit ist das Git-Repository noch weiter self-contained, denn es enthält auch seinen eigenen Build-Job (ähnlich kann man das bei anderen Build-Tools wie beispielsweise [Travis](travis.md)). Im Jenkins muß dann nur noch ein Job angelegt werden, in dem die Location des Git-Repositories definiert wird, und angegeben wird, daß das Repository ein Jenkinsfile enthält.

Hier nur ein Ausschnitt aus den Konzepten, die sich in einer Jenkins-Pipeline befinden:

![Konzepte einer Jenkins-Pipeline](images/jenkins-pipeline.png)