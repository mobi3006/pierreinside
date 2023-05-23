# Kubernetes

* [Refcardz](https://dzone.com/refcardz/kubernetes-essentials)
* Udemy-Kurs [kubernetes for beginners with aws examples" von Michal Hucko](https://www.udemy.com/course/kubernetes-for-beginners-with-aws-examples/learn/lecture/36051770)
  * [GitHub repo](https://github.com/misohu/kubernetes-basics)
  * [Slides](https://docs.google.com/presentation/d/1nHH6RwjNzw7HNRY9chtciCPYVSSVvZgYmXCCbtip4QI/edit#slide=id.p)

Kubernetes ist ein Google-Projekt zur Orchestrierung von Containern (z. B. Docker-Containern). Auf diese Weise lassen sich Deployments automatisieren, administrieren, horizontales skalieren, ausrollen (Rolling Deployments). Kubernetes besitzt ausserdem eine Selbstheilungsmöglichkeit - stirbt ein Pod, so bekommt Kubernetes das mit und startet einen neuen. Kubernetes verwendet einen deklarativen Stil anstatt eines imperativen ... Du definierst das Ziel und Kubernetes kümmert sich um die Umsetzung. Das kann bedeuten, dass immer 3 Replicas deployed sein müssen (stürzt einer ab kümmert sich Kubernetes um einen neuen) oder auch einen Autoscaler verwenden kann, der garantiert, dass immer genügend Resourcen zur Verfügung stehen (oder eben ein Deployment nicht erfolgreich ausgeführt werden kann).

Health-Checks sind essentiell dafür, dass Kubernetes den geforderte Zielzustand einhalten kann. Ein Pod, der zwar läuft, aber eigentlich nicht mehr genutzt werden kann, wird erkannt und durch einen neuen ersetzt.

K8s abstrahiert die unterliegende Infrastruktur. Es spielt keine Rolle, ob darunter OnPrem-Hardware oder Cloud-ressourcen (auch unterschiedlicher Cloud-Anbieter) oder auch nur Raspberry PIs liegen. Kubernetes wird deshalb auch häufig als Operating System der Cloud bezeichnet. Ein Betriebssystem startet Processe auf EINEM Rechner, Kubernetes wendet dieses Konzept auf die Cloud an ... irgendwo wird der Prozess (= Pod) gestartet ... sofern entsprechende Ressourcen vorhanden.

Die Cloud hat ihre ursprüngliche Motivation in der Skalierbarkeit. Hierin liegt der grosse Vorteil gegenüber einer limitierten eigenen OnPrem-Umgebung. Grundsätzlich könnte man seine eigene OnPrem-Umgebung so groß gestalten, dass man nie in Ressourcenengpässe läuft und somit keinen Cloud-Anbieter bräuchte. Das wäre allerdings nicht besonders wirtschaftlich, weil man immer auf den worst-case vorbereitet sein müsste und den natürlich auch bezahlen müsste. AWS, Google, Azure halten diese oversized Umgebung bereit, weil es Kunden gibt, die dafür bezahlen und die wahrscheinlich NIE immer Gleichzeitig unter Vollast laufen, so dass sich er Bedarf mittelt und es sich für den Cloud-Provider und den Kunden rechnet. Im besten Fall ist das eine Win-Win-Situation. Für kleine Unternehmen, die mit einer tollen Idee an den Start gehen wollen, ist das ideal. Sie brauchen nicht in Vorleistung zu gehen, um ein grosses Data-Center aufzubauen, das sie vielleicht nie benötigen. Sobald der Service erfolgreich ist, skaliert die Umgebung automatisch, um die Kunden zu befriedigen - Kosten entstehen erst, wenn sie tatsächloch benötigt werden (und dann im besten Fall auch mit Einnahmen verrechnet werden können).

---

## Infrastruktur

* CoreOS mit Docker/Rocket
* flannel
* Kubernetes Controller
* Kubernetes Node
* Terraform
* Google Compute **Engine**

---

## Konzept Deployment

* ein Deployment repräsentiert eine Menge identischer Pods (ein oder mehrere), die auf die Worker-Nodes deployed werden
* man kann wohl auch ohne das Konzept Deployment auskommen und nur Pods deployen, ABER es bietet einige Vorteile
  * Definition von `replicas:5`: stellt dann auch sicher, dass auch tatsächlich immer so viele laufen (evtl. werden abgestürzte Pods neu gestartet)
    * kann man auch on-the-fly ändern, wenn man sich selbst um das Skaling kümmern will
  * Rollback zu vorherigen Deployment versionen

---

## Konzept Pod

* ist atomare Deployment-Einheit ... Dinge, die IMMER gemeinsam auf einem Node (= Minion) deployed werden.
* besteht aus einem oder mehreren Docker-Containern, Data-Volumes, Networks, ...
  * Komponenten EINES Pods sind eng verknüpft
* ein Pod kann mehrere Labels haben, die dann verwendet werden, um Pods auszuwählen
* Pods teilen sich Volumes
* alle Container eines Pods können über ``localhost`` miteinander kommunizieren (vereinfacht die Konfiguration)
* sind volatil (ephemeral) ... können wegfallen oder sich vermehren (getriggert durch den Auto-Scaler)

---

## Konzept Minion

* Minion ist die softwareseitige Komponente eines Nodes - der Node besteht aus der Hardware und der Software (= dem Minion)

---

## Konzept Node

* Teilnehmer an einem Kubernetes Cluster
* auf einem Node

### Master-Node = Control-Plane

* ausgezeichneter Node (evtl. mehrere), der als Master (= Control-Plane) fungiert und folgende Dienste bereitstellt
  * API-Server (= Kube-API, als Pod (eat your own dogfood) oder System-Prozess bereitgestellt): hiermit kommuniziert das Tool `kubectl`, das der Administrator zur Steuerung verwendet
  * Scheduler: überwacht, daß die Spezifikation der Landschaft (z. B. Anzahl der Pods) eingehalten ist und startet/stoppt ggf. Pods
  * Controller für Background-Aufgaben
* auf der Control-Plane läuft auch etcd ... eine verteilte (ausfallsichere) Key-Value-Datenbank (basierend auf Dqlite) zur Speicherung von Metadaten - dem State des K8s-Clusters.
  * nur der API-Server (Kube-API) spricht mit etcd
  * verwendet das Raft-Protocol

---

## Konzept Kube-API

Das ist eine REST-API (bereitgestellt auf der Control Plane) zur Steuerung des K8s-Clusters. `kubectl` verwendet diese API ... wir können das aber natürlich auch tun. Statt eines `kubectl get pods --namespace my-namespace`

```
curl https://192.168.100.39:16443/api/v1/namespaces/my-namespace/pods \
    --header `Authorization: Bearer <TOKEN>' \
    --insecure
```

Als Antwort bekommt man dann ein JSON.

... man erkennt daran, dass das `kubectl` eine durchaus sinnvolle Abstraktionsschicht ist.

---

## Konzept Kubelet

* das Herz eines Worker-Knotens, i. a. ein System-Prozess - kein Pod
* Agent, der auf jedem Slave-Node im Kubernetes-Cluster läuft
* hierüber kommuniziert der Kube-API-Server mit den Worker-Nodes
  * hierüber wird der Kubernetes-Master auch über neue Nodes informiert (Node registriert sich beim Master)
* ist der verlängerte Arm des Kubernetes-Masters, ein paar Beispiels
  * erhält den Auftrag einen neuen Pod zu starten
  * stellt Health-Check-Informationen des Nodes bereit

---

## Konzept Service

* ein Service ist sozusagen ein Load-Balancer bzw. Service-Proxy, der über eine Vielzahl von Pods liegt, die auf unterschiedliche Knoten (EC2 Instanzen) verteilt werden können
  * verwendet hierzu die Pod Lables, um die passenden Ziele zu finden
* hat eine statische Location (z. B. FQDN, IP-Addresse) - im Gegensatz zu Pods, die so volatil sind, daß sie ständig woanders sein können.

---

## Konzept Daemon Set

Ein DaemonSet stellt sicher, dass auf jedem Worker-Knoten (oder einer definierten Auswahl davon) ein bestimmter Pod läuft. Wenn ein neuer Worker gestartet wird, so wird der Pod automatisch auch auf diesem Knoten deployed.

---

## Konzept Reconciliation

* man definiert einen gewünschten Zustand und Kubernetes sorgt dafür, daß der Zustand erreicht wird:
  * gewünschter Zustand: 3 Pods xyz laufen
  * aktueller Zustand: 1 Pod xyz läuft
  * Kubernetes Replication Controller started 2 weitere xyz Pods 
* Kubernetes macht Healthchecks, um den aktuellen Zustand immer abzufragen und den gewünschten Zustand evtl. zu erreichen

---

## Konzept Namespace

... erlauben die Separierung Workloads, so dass sogar personalisierte Deployments oder unterschiedliche Stages auf demselben EKS-Cluster betrieben werden können. Auf diese Weise kann man den Maintenance-Aufwand reduzieren und Infrastruktur wiederverwenden bzw. sinnvoll aufteilen.

---

## Konzept Addon

Kubernetes bietet ein PlugIn Konzept, das sich Add-Ons nennt. Hiermit können die Features erweitert werden.

---
## Konzept Worker Nodegroup

Gruppe von Workern

---

## Konzept Bastion Host

Häufig wird eine EC2 Instance in einem EKS-Cluster als Bastion-Host verwendet, über den man dann `kubectl` Kommandos (und andere) gegen das Cluster ausführen kann (z. B. zwecks Fehleranalyse). 

---

## Konzept Kube-Proxy

verantwortlich für Load-Balancing

---

## Konzept Kube-Scheduler

verwantwortlich für das Scheduling von Pods

---

## Konzept Kube-DNS

DNS-Auflösung von K8s Komponenten

---

## Konzept Controller Manager

überwacht den Kubernetes Status

---

## Konzept Context

Die Contexts werden in `~/.kube.config` definiert.

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
current-context: aws_cluster
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

und ermöglicht die gleichzeitige Nutzung von `kubectl` in verschiedenen Contexts ... default ist der `current-context`.

### Arbeit mit mehreren Clustern

* per `kubectl config set-context microk8s` kann der `current-context` geändert werden
* über den Parameter `--context` kannn der Context pro Kommando gesetzt werden (z. B. `kubectl get nodes --context microk8s`)
* man kann auch verschiedene `KUBECONFIG` Umgebungsvariablen verwenden, um zwischen den Clustern umzuschalten:

  * `export KUBECONFIG=~/.kube/config-aws`
  * `export KUBECONFIG=~/.kube/config-microk8s`

* ich verwende `kubectx` und `kubens` von [ahmetb](https://github.com/ahmetb/kubectx) - hier läßt sich der Context/Namespace interaktiv umschalten, die History verwenden oder einfach zum vorherigen zurückgehen `kubectx -`

---

## Konzept Manifest Files

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

## etcd

* nur die Control Plane verwendet etcd
* key/value Store
* enthält die Konfiguration des Clusters
* jeder Knoten hat Zugriff

### Nice2Know

* neue Knoten werden nach dem Start von Kubelet automatisch in das Cluster als Ressource aufgenommen
* über ein Overlay-Network (z. B. bei Docker) wird ein Netzwerk gespannt, das die Kommunikation der Cluster-Nodes ermöglicht

![Kubernetes Hauptkonzepte](/images/KubernetesMainConcepts.png)

---

## kubectl CLI

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

### Imperative vs Declarative

`kubectl` bietet beide Formen an:

* imperativ: `kubectl run nginx-pod --image=nginx --port 80`
* deklarativ: `kubectl apply -f nginx-deployment.yaml`

Beim deklarativen Beispiel handelt es sich um ein Manifest-Datei, die angewendet wird ... sozusagen eine Definition des Zielzustandes. Darin sind evtl. eine Anzahl von Replicas der NGinx Pods definiert, so dass die Control-Plane selbständig dafür sorgt, dass entsprechend viele Pods laufen. Das gilt aber nicht nur zum Zeitpunkt des `apply`-Statements, sondern auch für später. Der Zielzustand wird in etcd gespeichert und wenn Kubernetes-Control-Plane feststellt, dass nur noch 2 Replicas laufen, dann wird ein dritter Pods gestartet ... self-healing. Wir definieren also nur den Zielzustand und übergeben die Kontrolle an Kubernetes.

Neben diesem konzeptuellen Vorteil, lassen sich solche Manifest-Dateien auch einfach mit anderen teilen (z. B. unter Versionskontrolle stellen) und wiederholt ausführen. Der erste wichtige Schritt zu richtiger Automatisierung - die viel weniger Fehler produziert als eine Step-by-Step-Anleitung von Kommandos (die veraltet). Nicht zu vergessen, dass auf diese Weise auch Wissen geteilt werden kann und Kollaboration (über Pull-Requests) ermöglicht werden kann.

---

## Getting Started

Grundsätzlich basiert Kubernetes auf der Idee, das Deployment über mehrere Maschinen zu verteilen (und unterstützt damit der Microservice Idee). Es gibt verschiedene Lösungen, um Kubernetes lokal auf einem einzigen Cluster-Knoten zu betreiben und damit (ohne weitere Kosten zu erzeugen) erste Erfahrungen zu sammeln

* [minikube](https://github.com/kubernetes/minikube)
  * [siehe auch](kubernetes-minikube.md) 
* [microk8s](https://microk8s.io/)
  * [siehe auch](kubernetes-microK8s.md) 
  * basiert auf containerd und geht somit an Docker vorbei (auch wenn Docker containerd verwendet). Dadurch sieht man bei `docker ps` nicht die Kubernetes Container. Das ist praktisch, wenn man das nicht vermischen möchte.
* [k3s](https://k3s.io/)

Die manuelle Installation eines Kubernetes-Clusters ist nicht trivial (insbes. hinsichtlich der Netzwerkkonfiguration). Insofern ist Minikube ein guter Startpunkt. Auf vielen IaaS-Plattformen (z. B. AWS) existieren fertige Templates, die die Installation und Konfiguration zu einem Kinderspiel machen. Auch das ist ein guter Startpunkt.

---

## Lokale Installation per Shipyard

... pending

---

## Lokale Installation per LinuxKit

* [YouTuber Video - DockerCon 2017](https://youtu.be/FEtVxwsCUBY?t=1246)
* [GitHub](https://github.com/linuxkit/linuxkit/tree/master/projects/kubernetes)

---

## Lokale Installation per Docker Desktop

... enthält bereits ein Kubernetes

---

## CI/CD

* [Argu CD](https://argo-cd.readthedocs.io)

---

## Spielprojekte

### Ideensammlung

* http://blog.hypriot.com/
  * http://blog.hypriot.com/post/microservices-bliss-with-docker-and-traefik/
* https://www.scaleway.com/
* https://www.digitalocean.com/

### Raspberry PI Cluster

* http://blog.hypriot.com/post/let-docker-swarm-all-over-your-raspberry-pi-cluster/
* https://open.hpi.de/courses/smarthome2016

![Docker Swarm](http://blog.hypriot.com/post/let-docker-swarm-all-over-your-raspberry-pi-cluster/#&gid=1&pid=3)
