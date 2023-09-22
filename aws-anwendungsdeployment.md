# AWS Anwendungsdeployment

In diesem Abschnitt beleuchte ich die verschiedenen Ansätze jegliche Arten von Anwendungen (sehr einfach aber auch sehr komplexe) auf AWS zu betreiben.

Allen gemeinsam ist, dass die Basic-Tools von AWS (EC2, VPC, ALB, Auto-Scaling-Groups, Security-Groups, ...) mehr oder weniger offensichtlich genutzt werden, um so ein komplexes Szenario abzubilden. Je nach Lösung hat man entweder weniger oder mehr Einfluß.

Man kann sich AWS wie einen Baukasten mit Basis-Komponenten vorstellen. Einige der daraus von AWS zusammengebauten und zur Wiederverwendung bereitgestellten Composite-Komponenten tragen dann spezielle Namen wieAWS Fargate, AWS EKS, ... Enduser werden dann wiederum ihrerseits aus den BaDaneben stehen jedem Nutzer natürlich auch selbst die Basis-Komponenten und Composite-Komponenten zu seine eigenen Custom-Komponenten (= Lösung) zusammenbauen. Ist die so allgemein, dass sie für andere relevant sein könnte, kann er auch diese wiederum zur Weiterverwendung auf dem Amazon Marketplace anbieten.

---

## S3 Static Website

Eine Webseite besteht ja nur aus HTML, CSS, Java-Script und passt somit perfekt in ein S3-Filesystem. AWS bietet genau zu diesem Zweck die Möglichkeit, einem S3-Bucket als static Website zu konfigurieren ... super einfach, um schnell mal eine Webseite bereitzustellen.

Da moderne Single-Page-Applikationen auch nur aud den oben genannten Komponenten bestehen, handelt es sich hier automatisch um ein Anwendungs-Deployment. So einfach kanns sein.

---

## App Runner

Hierbei handelt es sich um einen PaaS-Ansatz (vor einigen Jahren hatte ich mal mit der Google App Engine rumgespielt ... sehr ähnlich).

Mit wenigen Konfigurationen (CPU, Memory, Port) stellt AWS eine auto-skalierte Anwendung zur Verfügung. Die Anwendungen müssen dazu als

* Source-Code (Docker-basiertes Repo in GitHub)
* Docker-Image (private oder public AWS-ECR)

zur Verfügung stehen.

---

## AWS Lambda

> Limitation: ein Job darf nur 15 Minuten dauern

---

## Elastic Container Service (ECS)

Hierbei handelt es sich um ein AWS-proprietäre Alternative zu Kubernetes.

---

## Elastic Kubernetes Service (EKS)

* [siehe eigener Abschnitt](aws-eks.md)
