# AWS Elastic Kubernetes Service

* [Kubernetes@pierreinside](kubernetes.md)
* [EKS Terraform Blueprint](https://aws-ia.github.io/terraform-aws-eks-blueprints/latest/)

AWS EKS ist eine managed Kubernetes Control Plane (abgebildet im sog. Master-Node - im Gegensatz zu den Worker-Nodes = Data-Plane), die den härtesten Teil eines [Kubernetes Clusters](kubernetes.md) abbildet. Das Control-Plane-Cluster läuft in einem von AWS managed VPC, hat aber eine Verbindung in das vom Kunden managed Worker-Cluster (abgebildet als Node-Groups).

> man muss natürlich nicht AWS EKS verwenden, um Kubernetes auf EC2 zu nutzen. Man kann auch die Control-Plane vollkommen selbst bauen. Die Control-Plane ist allerdings der komplexe Part eines Kubernetes-Clusters. Man benötigt hier entsprechend Erfahrung und Zeit, um einen HA-Cluster zuverlässig (etcd Backup) bereitzustellen und alle 6 Monate eine Migration der Kubernetes Version vorzunehmen. Aus diesem Grund hat sich AWS entschieden EKS anzubieten.
Kubernetes selbst ist Technologie-agnostic, d. h. das unterliegende Backend (Cloud, OnPrem) spielt keine Rolle für die Orchestrierung von Workload. Allerdings wird ein Backend benötigt und hier kommen natürlich alle Cloud-Anbieter (AWS; Azure, Google) in Frage ... man kann prinzipiell aber natürlich auch seine eigene Hardware bereitstellen.

Für die Data-Plane bietet AWS

* EC2 Instanzen, NLBs (Network-Load-Balancers), EBS-Volumes,
* oder AWS Fargate
* oder beides

Die Data-Plane ist der einfache Teil, weil man hier nur eine Integration in den Cluster braucht um Compute-Ressourcen zur Verfügung zu stellen.

---

# AWS-EKS vs AWS-ECS

Der Elastic-Container-Service (ECS) stellt eine AWS-spezifische Alternative zu Kubernetes dar. Genau wie AWS-EKS kann es mit EC2 oder Fargate Ressourcen als Compute-Nodes arbeiten.

---

# EC2 vs Fargate Data Plane

Der Fargate Ansatz reduziert den Maintenance Aufwand deutlich, da Auto-Scaling und VMs automatisch managed sind von AWS selbst. Dafür ist er in der Vielfalt limitiert (z. B. kein Support von DaemonSets).

> Fargate verwendet letztlich auch EC2 Instanzen ... man muss sie aber nicht managen.

---

# AWS EKS Workshop

Der offizielle *Amazon EKS Workshop* ist eine tolle Einführung und ein MUST-HAVE für den Einstieg.

* [Amazon EKS explained](https://www.eksworkshop.com/docs/introduction)
* Amazon EKS Workshop
  * [Dokumentation](https://www.eksworkshop.com/docs/introduction)
  * [code eks-workshop-v2 auf GitHub](https://github.com/aws-samples/eks-workshop-v2)
  * Videos
    * [Part 1](https://www.youtube.com/watch?v=_TFk5jQr2lk)
    * [Part 2](https://www.youtube.com/live/EAZnXII9NTY)
    * [Part 3](https://youtu.be/ajPe7HVypxg)
    * [Part 4](https://youtu.be/dONzzCc0oHo)
    * [Part 5](https://youtu.be/l-FKi7eCb7k)
    * [Managed Nodes](https://youtu.be/_TFk5jQr2lk?t=1171)
    * [Fargate](https://youtu.be/_TFk5jQr2lk?t=2993)
      * [Dokumentation](https://www.eksworkshop.com/docs/fundamentals/fargate/)

Der [Terraform-Code](https://github.com/aws-samples/eks-workshop-v2) erzeugt ein Cluster (**ACHTUNG: signifikante KOSTEN**) und auch eine Cloud9 Entwicklungsumgebung, so dass man die Beispiele leicht nachvollziehen kann, ohne die ganzen Tools lokal selbst installieren zu müssen. Über [Addons](https://github.com/aws-samples/eks-workshop-v2/blob/main/terraform/modules/cluster/addons.tf#L25) lässt sich der Umfang leicht konfigurieren. Ein Reset ist leicht über ein einziges Kommando zu bewerkstelligen (``).

Step-by-Step Workshop wie man ein AWS EKS Cluster auf Basis des [aws-samples/eks-workshop-v2 GitHub repos](https://github.com/aws-samples/eks-workshop-v2) aufsetzt. Diese Projekt bietet schon eine Vielzahl von .

Nach einem initialen

```
terraform apply -auto-apply
```

steht das EKS-Cluster bereits zur Verfügung.

---

# kubectl CLI

[siehe hier @pierreinside](kubernetes.md)

Verwendet man Amazon-EKS, so kann man sich per

```
aws eks --region <aws_region> update-kubeconfig --name <cluster-name>
```

die Konfiguration in eine Datei erzeugen lassen. Per Default ist es `~/.kube.config`. Hat man allerings eine `KUBECONFIG` Umgebungsvariable gesetzt, dann wird diese Datei verwendet.

Eine Liste der im Account verfügbaren Cluster bekommt man per `aws eks list-clusters` (die korrekte Konfiguration der AWS Credentials natürlich vorausgesetzt).

---

# eksctl CLIs

* [Homepage](https://eksctl.io/)

Mit der `eksctl` wird das AWS EKS Cluster gemanaged. Mit

```
eksctl create cluster \
  --name my-eks-cluster \
  --region eu-central-1 \
  --ssh-access \
  --ssh-public-key=my-public-keypair \
  --node-type=m5.large \
  --nodes=2
```

kann man besipielsweise ein AWS-EKS-Cluster erzeugen. Bei diesem einzelnen Befehl werden sehr viele AWS-Ressourcen erstellt und miteinander über Konfiguration verknüpft. Somit ist das `ekscli` ein sehr mächtiger Apparat, der auf hohem Abstraktionslevel sitzt. 

> Diese CLIs sind i. a. sehr praktisch für die Fehleranalyse. Für die Administration (Erstellung/Konfiguration/Löschung) eines Clusters sind sie aber nicht erste Wahl, da die Wahrscheinlichkeit hoch ist, dass durch die fehlende Automatisierung Snowflake Server entstehen (Kommandos werden in einer bestimmten Reihenfolge evtl. sogar fehlerhaft oder unvollständig) ausgeführt werden. Aus diesem Grund empfiehlt sich für die Administration Terraform oder AWS Cloudformation.

## Bewertung

Es ist ok `eksctl` für gelegentlich Abfragen über das Cluster zu verwenden (z. B. zur Fehleranalyse). Vielleicht ist es auch ein nettes Learning, mal ein Cluster damit aufzubauen.

Allerdings sollte man jegliche Infrastruktur-Komponenten mit Infrastructure-as-Code managen (z. B. [via terraform](terraform.md)). Tut man das nicht entstehen Snowflake-Installationen, die nur noch manuell gemanged werden können und das ist sehr fehleranfällig und kaum nachvollziehbar. Mit Terraform kann man auch schnell mal erstellte (teure) Infrastruktur mit einem einzigen Kommando wieder abbauen. Insofern ist das auch in Lernsituationen die bessere Variante.

---

# AWS Node-Group

> nur wenn self-managed EC2 Instanzen als Worker-Nodes verwendet

* in AWS verwendet man Node-Groups, um die Worker-Nodes in Gruppen zu separieren

---

# Node Auto-Scaler

Der [AWS Cluster-Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md) verwendet eine Auto-Scaling-Group, um die Anzahl der Nodes lastabhängig zu steuern.

> neben diesem Node-Scaling gibt es auch ein Auto-Scaling auf Pod-Ebene ([siehe Horizontal-Pod-Autoscaler](kubernetes-autoscaler.md))

---

# Ingress

---

# Service-Account

* [kubernetes.io - Managing Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)

Der EKS-Service-Account ist die AWS-Identität, mit der die Kubernetes Ressourcen (z. B. Pods) arbeiten ... der Pod wird mit dem Service-Account assoziiert. Insofern hängen hier u. a. Berechtigungen dran.

> Der Service-Account ist vergleichbar mit einem technischen User-Account
