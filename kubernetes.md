# Kubernetes

* [Refcardz](https://dzone.com/refcardz/kubernetes-essentials)
* Udemy-Kurs [kubernetes for beginners with aws examples" von Michal Hucko](https://www.udemy.com/course/kubernetes-for-beginners-with-aws-examples/learn/lecture/36051770)
  * [GitHub repo](https://github.com/misohu/kubernetes-basics)
  * [Slides](https://docs.google.com/presentation/d/1nHH6RwjNzw7HNRY9chtciCPYVSSVvZgYmXCCbtip4QI/edit#slide=id.p)

Kubernetes ist ein Google-Projekt zur Orchestrierung von Containern (z. B. Docker-Containern). Auf diese Weise lassen sich Deployments automatisieren, administrieren, horizontales skalieren, ausrollen (Rolling Deployments). Kubernetes besitzt ausserdem eine Selbstheilungsmöglichkeit - stirbt ein Pod, so bekommt Kubernetes das mit und startet einen neuen. Kubernetes verwendet einen deklarativen Stil anstatt eines imperativen ... Du definierst das Ziel und Kubernetes kümmert sich um die Umsetzung und Einhaltung.

> ... stirbt also ein Pod (eine Instanz eines Services), dann ist der spezifizierte Zustand (Anzahl der Replicas) nicht mehr korrekt und Kubernetes korrigiert das automatisch.

Health-Checks sind essentiell dafür, dass Kubernetes den geforderte Zielzustand einhalten kann. Ein Pod, der zwar läuft, aber eigentlich nicht mehr genutzt werden kann, wird erkannt und durch einen neuen ersetzt.

Ein Autoscaler kann die Anzahl der Replicas automatisch korriegieren, wenn er merkt, dass die Compute-Power nicht mehr ausreicht, um die Last zu bewältigen.

K8s abstrahiert die unterliegende Infrastruktur. Es spielt keine Rolle, ob darunter OnPrem-Hardware oder Cloud-ressourcen (auch unterschiedlicher Cloud-Anbieter) oder auch nur Raspberry PIs liegen. Kubernetes wird deshalb auch häufig als Operating System der Cloud bezeichnet. Ein Betriebssystem startet Processe auf EINEM Rechner, Kubernetes wendet dieses Konzept auf die Cloud an ... irgendwo wird der Prozess (= Pod) gestartet ... sofern entsprechende Ressourcen vorhanden.

> Letztlich verteilt K8s die vorhandene Rechenpower (On-Prem, Cloud) auf die zu verarbeitende Last. Dabei sind natürlich bestimmte Randbedingungen einzuhalten (z. B. OS-Version, Speicheranforderungen, CPU-Architektur, ...).

Die Cloud hat ihre ursprüngliche Motivation in der Skalierbarkeit. Hierin liegt der grosse Vorteil gegenüber einer limitierten eigenen OnPrem-Umgebung. Grundsätzlich könnte man seine eigene OnPrem-Umgebung so groß gestalten, dass man nie in Ressourcenengpässe läuft und somit keinen Cloud-Anbieter bräuchte. Das wäre allerdings nicht besonders wirtschaftlich, weil man immer auf den worst-case vorbereitet sein müsste und den natürlich auch bezahlen müsste.

> Hieraus ergibt sich eine riesige Chance für Startups, die ohne großes Invest in Hardware ihre Idee auf den Markt bringen können. Ein Booster für Innovation.

AWS, Google, Azure halten diese oversized Umgebung bereit, weil es Kunden gibt, die dafür bezahlen und die wahrscheinlich NIE immer Gleichzeitig unter Vollast laufen, so dass sich er Bedarf mittelt und es sich für den Cloud-Provider und den Kunden rechnet. Im besten Fall ist das eine Win-Win-Situation. Für kleine Unternehmen, die mit einer tollen Idee an den Start gehen wollen, ist das ideal. Sie brauchen nicht in Vorleistung zu gehen, um ein grosses Data-Center aufzubauen, das sie vielleicht nie benötigen. Sobald der Service erfolgreich ist, skaliert die Umgebung automatisch, um die Kunden zu befriedigen - Kosten entstehen erst, wenn sie tatsächloch benötigt werden (und dann im besten Fall auch mit Einnahmen verrechnet werden können).

---

# Konzept Deployment

* ein Deployment repräsentiert eine Menge identischer Pods (ein oder mehrere), die auf die Worker-Nodes deployed werden
* man kann wohl auch ohne das Konzept Deployment auskommen und nur Pods deployen, ABER es bietet einige Vorteile
  * Definition von `replicas:5`: stellt dann auch sicher, dass auch tatsächlich immer so viele laufen (evtl. werden abgestürzte Pods neu gestartet)
    * kann man auch on-the-fly ändern, wenn man sich selbst um das Skaling kümmern will
  * Rollback zu vorherigen Deployment versionen

---

# Konzept Pod

* ist atomare Deployment-Einheit ... Dinge, die IMMER gemeinsam auf einem Node (= Minion) deployed werden.
* besteht aus einem oder mehreren Docker-Containern, Data-Volumes, Networks, ...
  * Komponenten EINES Pods sind eng verknüpft
* ein Pod kann mehrere Labels haben, die dann verwendet werden, um Pods auszuwählen
* Pods teilen sich Volumes
* alle Container eines Pods können über ``localhost`` miteinander kommunizieren (vereinfacht die Konfiguration)
* sind volatil (ephemeral) ... können wegfallen oder sich vermehren (getriggert durch den Auto-Scaler)

---

# Konzept Minion

* Minion ist die softwareseitige Komponente eines Nodes - der Node besteht aus der Hardware und der Software (= dem Minion)

---

# Konzept Node

* Teilnehmer an einem Kubernetes Cluster
* Control-Plane-Nodes vs Data-Plane-Nodes

## Master-Node = Control-Plane

* Steuereinheit des Kubernetes-Clusters zur Verteilung der Arbeit auf die Data-Plane, die aus Worker Nodes besteht
* bestehend aus
  * API-Server (= Kube-API)
    * als Pod (eat your own dogfood) oder System-Prozess bereitgestellt)
    * hiermit kommuniziert das Tool `kubectl`, das der Administrator zur Steuerung verwendet
  * Scheduler: überwacht, daß die Spezifikation der Landschaft (z. B. Anzahl der Pods) eingehalten ist und startet/stoppt ggf. Pods
  * Controller für Background-Aufgaben
  * etcd
    * eine verteilte (ausfallsichere) Key-Value-Datenbank (basierend auf Dqlite) zur Speicherung von Metadaten - dem State des K8s-Clusters.
  * nur der API-Server (Kube-API) spricht mit etcd
  * verwendet das Raft-Protocol

---

# Konzept Kube-API

Das ist eine REST-API (bereitgestellt auf der Control Plane) zur Steuerung des K8s-Clusters.

`kubectl` ist eine CLI, die die REST-API verwendet. Statt eines `kubectl get pods --namespace my-namespace`

```
curl https://192.168.100.39:16443/api/v1/namespaces/my-namespace/pods \
    --header `Authorization: Bearer <TOKEN>' \
    --insecure
```

---

# Konzept Kubelet

* das Herz eines Worker-Knotens, i. a. ein System-Prozess - kein Pod
* Agent, der auf jedem Slave-Node im Kubernetes-Cluster läuft
* hierüber kommunizieren Kube-API-Server und Worker-Node
  * API-Server => Worker-Node:
    * zum Starten/Stoppen eines Pods 
  * Worker-Node => API-Server:
    * wie hoch ist die Auslastung
    * De-/Registrierung eines neuen Worker-Nodes
    * stellt Health-Check-Informationen des Nodes bereit

---

# Konzept Service

* ein Service ist ein Load-Balancer bzw. Service-Proxy, der über eine Vielzahl von Pods liegt, die auf unterschiedliche Knoten (EC2 Instanzen) verteilt werden können
  * verwendet hierzu die Pod Lables, um die passenden Ziele zu finden
* hat eine statische Location (z. B. FQDN, IP-Addresse) - im Gegensatz zu Pods, die so volatil sind, daß sie ständig woanders sein können.

---

# Konzept Daemon Set

Ein DaemonSet stellt sicher, dass auf jedem Worker-Knoten (oder einer definierten Auswahl davon) ein bestimmter Pod läuft. Wenn ein neuer Worker gestartet wird, so wird der Pod automatisch auch auf diesem Knoten deployed.

---

# Konzept Reconciliation

* man definiert einen gewünschten Zustand und Kubernetes sorgt dafür, daß der Zustand erreicht wird:
  * gewünschter Zustand: 3 Pods xyz laufen
  * aktueller Zustand: 1 Pod xyz läuft
  * Kubernetes Replication Controller started 2 weitere xyz Pods 
* Kubernetes macht Healthchecks, um den aktuellen Zustand immer abzufragen und den gewünschten Zustand evtl. zu erreichen

---

# Konzept Namespace

... erlauben die Separierung Workloads, so dass sogar personalisierte Deployments oder unterschiedliche Stages auf demselben EKS-Cluster betrieben werden können. Auf diese Weise kann man den Maintenance-Aufwand reduzieren und Infrastruktur wiederverwenden bzw. sinnvoll aufteilen.

---

# Konzept Addon

Kubernetes bietet ein PlugIn Konzept, das sich Add-Ons nennt. Hiermit können die Features erweitert werden.

---
## Konzept Worker Nodegroup

Gruppe von Workern

---

# Konzept Bastion Host

Häufig wird eine EC2 Instance in einem EKS-Cluster als Bastion-Host verwendet, über den man dann `kubectl` Kommandos (und andere) gegen das Cluster ausführen kann (z. B. zwecks Fehleranalyse). 

---

# Konzept Kube-Proxy

verantwortlich für Load-Balancing

---

# Konzept Kube-Scheduler

verwantwortlich für das Scheduling von Pods

---

# Konzept Kube-DNS

DNS-Auflösung von K8s Komponenten

---

# Konzept Controller Manager

überwacht den Kubernetes Status

---

# Konzept Context

Für `kubectl` werden in `~/.kube.config` verschiedene API-Server (einer Kubernetes-Cluster-Control-Plane definiert) als Ziel der Kommandos definiert - man spricht von `context`. Einer ist der `current-context` - der Default, wenn im Kommando keine anderer `context` angegeben ist.

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data:
      blafasel
    server: https://10.211.55.48:16443
  name: microk8s-cluster
- cluster:
    certificate-authority-data: 
      foobar
    server: https://this_is_the_fqdn.gr1.eu-central-1.eks.amazonaws.com
  name: aws_cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
- context:
    cluster: aws_cluster
    user: aws_user
  name: aws_cluster
current-context: aws_cluster                            <=========== current-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    token: <TOKEN>
- name: aws_user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - --region
      - eu-central-1
      - eks
      - get-token
      - --cluster-name
      - aws_cluster
      - --output
      - json
      command: aws
```

Ein Kontext ist eine Kombination aus

* Cluster
* Account

## Arbeit mit mehreren Clustern

* per `kubectl config set-context microk8s` kann der `current-context` geändert werden
* über den Parameter `--context` kann der Context pro Kommando gesetzt werden (z. B. `kubectl get nodes --context microk8s`)
* man kann auch für jeden Kontext eine andere Datei in `~/.kube` verwenden und per `export KUBECONFIG=` zwischen den Clustern umschalten:

  * `export KUBECONFIG=~/.kube/config-aws`
  * `export KUBECONFIG=~/.kube/config-microk8s`

* ich verwende `kubectx` und `kubens` von [ahmetb](https://github.com/ahmetb/kubectx) - hier läßt sich der Context/Namespace interaktiv umschalten, die History verwenden oder einfach zum vorherigen zurückgehen `kubectx -`

Verwendet man Amazon-EKS, so kann man sich per `aws eks --region <aws_region> update-kubeconfig --name <cluster-name>` die Konfiguration in `~/.kube.config` integrieren lassen. Eine Liste der im Account verfügbaren Cluster bekommt man per `aws eks list clusters <aws_region>` (die korrekte Konfiguration der AWS Credentials natürlich vorausgesetzt).

---

# Konzept Manifest Files

`yaml` Dateien, die einen Zielzustand (= Deployment) beschreiben:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx
  name: nginx
spec:
  replicas: 4
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        resources: {}
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 3
          timeoutSeconds: 3
          failureThreshold: 2
  strategy:
    rollingUpdate:
      maxSurge: 0
      maxUnavailable: 25%
    type: RollingUpdate
```

---

# etcd

* nur die Control Plane verwendet etcd
* key/value Store
* enthält die Konfiguration des Clusters
* jeder Knoten hat Zugriff

## Nice2Know

* neue Knoten werden nach dem Start von Kubelet automatisch in das Cluster als Ressource aufgenommen
* über ein Overlay-Network (z. B. bei Docker) wird ein Netzwerk gespannt, das die Kommunikation der Cluster-Nodes ermöglicht

![Kubernetes Hauptkonzepte](/images/KubernetesMainConcepts.png)

---

# kubectl CLI

`kubectl`-CLI ist ein Client, mit dem ein Administrator mit einem Kubernetes-Cluster spricht. Die Kommunikation erfolgt mit der Kubernetes-Control-Plane - genauer gesagt mit dem API-Server (REST-API). Man installiert i. a. `kubectl` auf dem eigenen Laptop (oder auch einem Bastion Host) und konfiguriert ihn entsprechend auf einen Ziel-Cluster.

`kubectl` benötigt eine enstrechende Konfiguration des Ziel-Clusters in `~/.kube/config`. Intern verwendet `kubectl` die KUBE-API ... eine REST-API der Kubernetes Control Plane. Es ist somit nur eine Abstraktionsschicht, die sehr stabil bleibt ... selbst wenn sich die REST-API mal (auch backward-inkompatibel) ändern sollte.

> In einem elastischen Umfeld ist es wichtig, eine solche Abstraktion zu haben, denn die physische Location des API-Servers kann sich in einem elastischen Umfeld jederzeit ändern.

* `kubectl get namespaces`
* `kubectl get pods -n NAMESPACE`
* `kubectl describe pods -n NAMESPACE`
  * Metadata und Events anzeigen
* `kubectl describe deployment my-app`
* `kubectl apply -f my-deployment.yaml`
  * Deployment starten
* `kubectl get deployments`
* `kubectl rollout status deployment my-deployment`
* `kubectl rollout pause deployment my-deployment`
* `kubectl rollout resume deployment my-deployment`
* `kubectl rollout history deployment my-deployment`
* `kubectl rollout history deployment my-deployment --revision=2`
  * zeigt Details zu diesem Deployment an
* `kubectl rollout undo deployment my-deployment --to-revision=1`
  * rollback deployment
* `kubectl scale deployment my-deployment --replicas=5`
  * verwende 5 Replicas ... sind es derzeit 3 werden weitere erzeugt ... sind es derzeit 7 werden 2 weggeworfen
* `kubectl expose deployment my-deployment --type=LoadBalancer  --name=my-service`
  * Pod als Service anbieten ... der Service repräsentiert einen den verteilten Pods vorgeschalteten Load-Balancer
* `kubectl apply -k /workspace/modules/affinity/checkout`
  * Änderungen innerhalb des Clusters per [Kustomize](https://kustomize.io/) anwenden
* `kubectl exec pod -n catalog -- cat /var/log/syslog`

## Imperative vs Declarative

`kubectl` bietet beide Formen an:

* imperativ: `kubectl run nginx-pod --image=nginx --port 80`
* deklarativ: `kubectl apply -f nginx-deployment.yaml`

Beim deklarativen Beispiel handelt es sich um ein Manifest-Datei, die angewendet wird ... sozusagen eine Definition des Zielzustandes. Darin sind evtl. eine Anzahl von Replicas der NGinx Pods definiert, so dass die Control-Plane selbständig dafür sorgt, dass entsprechend viele Pods laufen. Das gilt aber nicht nur zum Zeitpunkt des `apply`-Statements, sondern auch für später. Der Zielzustand wird in etcd gespeichert und wenn Kubernetes-Control-Plane feststellt, dass nur noch 2 Replicas laufen, dann wird ein dritter Pods gestartet ... self-healing. Wir definieren also nur den Zielzustand und übergeben die Kontrolle an Kubernetes.

Neben diesem konzeptuellen Vorteil, lassen sich solche Manifest-Dateien auch einfach mit anderen teilen (z. B. unter Versionskontrolle stellen) und wiederholt ausführen. Der erste wichtige Schritt zu richtiger Automatisierung - die viel weniger Fehler produziert als eine Step-by-Step-Anleitung von Kommandos (die veraltet). Nicht zu vergessen, dass auf diese Weise auch Wissen geteilt werden kann und Kollaboration (über Pull-Requests) ermöglicht werden kann.

---

# Getting Started

Grundsätzlich basiert Kubernetes auf der Idee, das Deployment über mehrere Maschinen zu verteilen (und unterstützt damit der Microservice Idee). Es gibt verschiedene Lösungen, um Kubernetes lokal auf einem einzigen Cluster-Knoten zu betreiben und damit (ohne weitere Kosten zu erzeugen) erste Erfahrungen zu sammeln

* [minikube](https://github.com/kubernetes/minikube)
  * [siehe auch](kubernetes-minikube.md) 
* [microk8s](https://microk8s.io/)
  * [siehe auch](kubernetes-microK8s.md) 
  * basiert auf containerd und geht somit an Docker vorbei (auch wenn Docker containerd verwendet). Dadurch sieht man bei `docker ps` nicht die Kubernetes Container. Das ist praktisch, wenn man das nicht vermischen möchte.
* [k3s](https://k3s.io/)

Die manuelle Installation eines Kubernetes-Clusters ist nicht trivial (insbes. hinsichtlich der Netzwerkkonfiguration). Insofern ist Minikube ein guter Startpunkt. Auf vielen IaaS-Plattformen (z. B. AWS) existieren fertige Templates, die die Installation und Konfiguration zu einem Kinderspiel machen. Auch das ist ein guter Startpunkt.

---

# Lokale Installation per Shipyard

... pending

---

# Lokale Installation per LinuxKit

* [YouTuber Video - DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=1246)
* [GitHub](https://github.com/linuxkit/linuxkit/tree/master/projects/kubernetes)

---

# Lokale Installation per Docker Desktop

... enthält bereits ein Kubernetes

---

# CI/CD

* [Argo CD](https://argo-cd.readthedocs.io)

---

# Spielprojekte

## Ideensammlung

* http://blog.hypriot.com/
  * http://blog.hypriot.com/post/microservices-bliss-with-docker-and-traefik/
* https://www.scaleway.com/
* https://www.digitalocean.com/

## Raspberry PI Cluster

* http://blog.hypriot.com/post/let-docker-swarm-all-over-your-raspberry-pi-cluster/
* https://open.hpi.de/courses/smarthome2016

![Docker Swarm](http://blog.hypriot.com/post/let-docker-swarm-all-over-your-raspberry-pi-cluster/#&gid=1&pid=3)
