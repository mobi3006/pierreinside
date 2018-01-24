# Jenkins

Jenkins wird zur Automatisierung von Builds und Deployments verwendet.

## Getting Started

Am einfachsten gelingt der Start mit einem Docker-Container, denn hier gibt es schon fertige Docker-Images, die man innerhalb weniger Sekunden am Laufen hat.

## Plugins

Jenkins zeichnet sich gegenüber anderen Build-Tools dadurch aus, daß es eine Fülle an Plugins gibt.

## Pipelines

Als *Pipelines* werden die Build-Jobs bezeichnet - sie bestehen aus i. a. aus meheren Steps, die nacheinander (ähnlich einer Pipeline) abgearbeitet werden.

### Multibranch vs. Singlebranch

In einem Git-basierten Enwticklungsansatz verwendet man i. a. separate Branches für Bugfixings/Features. Insofern würde man hier eine Multi-Branch-Pipeline brauchen. Für Release-Pipelines verwendet man Single-Branch-Pipelines.

### Pipeline Spezifikation

Die Spezifikation einer Pipeline kann im Git-Repository des Projekts über eine Datei beliebigen Namens (z. B. `Jenkinsfile`) erfolgen. Damit ist das Git-Repository noch weiter self-contained. Im Jenkins muß dann nur noch ein Job angelegt werden, in dem die Location des Git-Repositories definiert wird, und angegeben wird, daß das Repository ein Jenkinsfile enthält. 