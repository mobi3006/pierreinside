# AWS Elastic Kubernetes Service

* [Kubernetes@pierreinside](kubernetes.md)
* [EKS Terraform Blueprint](https://aws-ia.github.io/terraform-aws-eks-blueprints/latest/)

Das ist eine managed EKS Control Plane (abgebildet im sog. Master-Node - im Gegensatz zu den Worker-Nodes = Data-Plane), das den härtesten Teil eines [Kubernetes Clusters](kubernetes.md) abbildet. Kubernetes selbst ist Technologie-agnostic, d. h. das unterliegende Backend spielt keine Rolle für die Orchestrierung von Workload. Allerdings wird ein Backend benötigt und hier kommen natürlich alle Cloud-Anbieter (AWS; Azure, Google) in Frage ... man kann prinzipiell aber natürlich auch seine eigene Hardware bereitstellen.

Die Cloudanbieter offerieren Lösungen (wie AWS beispielsweise mit AWS-EKS), die für ihre Cloud zugeschnitten sind und damit maximal integriert. Im Hintergrund wird die Infrastruktur des Cloud-Anbieters genutzt ... in diesem Fall AWS => EC2 Instanzen, NLBs (Network-Load-Balancers), EBS-Volumes oder auch Fargate. Das ist so gut integriert, dass man es häufig gar nicht mitbekommt, was da im Hintergrund auf seinem AWS-Account alles geschieht (und natürlich Kosten verursacht). Insofern bietet AWS-EKS ein Abstraktionslayer und eine funktionierende (häufig getestete) Integration.

Man könnte aber auch AWS verwenden und sein Kubernetes selbst darauf managen ... muss sich dann aber um viele Dinge selbst kümmern. Die Control-Plane ist der komplexe Part eines Kubernetes-Clusters ... es macht also Sinn, dies den Experten von AWS anzuvertrauen ... wenn man es nicht leisten kann, dieses KnowHow selbst aufzubauen.

Um die Data-Plane muss sich der Nutzer selbst kümmern. EKS kann mit zwei unterschiedlichen "Data Plane" (= Workers ... hierauf laufen die Pods) genutzt werden - die Control Plane kommt mit beiden zurecht:

* Traditional Server (EC2) Container Data Plane
* Serverless Container (Fargate) Data Plane

Das ist keine ENTWEDER/ODER Entscheidung ... stattdessen können beide Ansätze koexistieren.

---

## EC2 vs Fargate Data Plane

Der Fargate Ansatz reduziert den Maintenance Aufwand deutlich, da Auto-Scaling und VMs automatisch managed sind von AWS selbst. Dafür ist er in der Vielfalt limitiert.

Fargate verwendet letztlich auch EC2 Instanzen ... man muss sie aber nicht managen.

---

## AWS EKS Workshop

> **ACHTUNG:** bei der Ausführung des Terraform Codes werden AWS Ressourcen erstellt, die **signifikante Kosten** erzeugen!!!

* [Amazon EKS explained](https://www.eksworkshop.com/docs/introduction)
* Amazon EKS Workshop
  * [Dokumentation](https://www.eksworkshop.com/docs/introduction)
  * [Video - Demo](https://www.youtube.com/watch?v=_TFk5jQr2lk)
    * [Managed Nodes](https://youtu.be/_TFk5jQr2lk?t=1171)
    * [Fargate](https://youtu.be/_TFk5jQr2lk?t=2993)
      * [Dokumentation](https://www.eksworkshop.com/docs/fundamentals/fargate/)

Step-by-Step Workshop wie man ein AWS EKS Cluster auf Basis des [aws-samples/eks-workshop-v2 GitHub repos](https://github.com/aws-samples/eks-workshop-v2) aufsetzt. Diese Projekt bietet schon eine Vielzahl von [Addons](https://github.com/aws-samples/eks-workshop-v2/blob/main/terraform/modules/cluster/addons.tf#L25).

Nach einem initialen

```
terraform apply -auto-apply
```

steht das EKS-Cluster bereits zur Verfügung.

---

## kubectl CLI

[siehe hier @pierreinside](kubernetes.md)

---

## eksctl CLIs

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

---

## aws CLI

* AWS bildet das Backend von AWS-EKS ... somit ist natürlich auch `aws`-CLI ein nützliches Tool
  * [siehe hier @pierreinside](aws.md)
