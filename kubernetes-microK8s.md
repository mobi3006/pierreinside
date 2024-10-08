# microK8s

* [Hompage](https://microk8s.io/)

Das ist eine Lightweight Kubernetes Lösung, die von Canonical entwicklet wird. Die ansonsten schwer zu managegende Control-Plane (die man auch bei AWS-EKS einkaufen kann) ist kommt out-of-the-box:

> "MicroK8s is the easiest way to consume Kubernetes as it abstracts away much of the complexity of managing the lifecycle of clusters." ([Statement](https://microk8s.io/compare))

---

# Motivation

Für die Einarbeitung in Kubernetes wollte ich eine möglichst billige und schnelle Lösung haben. Ein Cluster via AWS EKS zu betreiben ist sicherlich der Porsche, aber kommt auch mit entsprechenden Kosten daher (pro Tag kommen da schon mal 10 Euro zusammen ... ohne, dass Last drauf ist) und deshalb sollte man ihn - wenn ausschließlich zum Training verwendet - immer wieder zerstören ... der Aufbau und Abbau kann mit ([Amazon EKS](aws-eks.md)) aber schon mal eine Stunde dauern (und das ist schon die schnelle Variante).

Da ich sowieso ein Freund von [Raspberry Pi](raspberrypi.md) bin, finde ich ein den [Pi-Cluster](https://ubuntu.com/tutorials/how-to-kubernetes-cluster-on-raspberry-pi?&_ga=2.18592121.1799920633.1683720724-1318647719.1683625013#1-overview) sehr interessant. Hier könnte man auch langfristig sein eigenes kleines billiges Datacenter aufbauen.

---

# Getting started

## Installation

Auf meinem Ubuntu verwende ich folgende Befehle

```
sudo apt update
sudo snap install microk8s --channel=latest/stable --classic
sudo usermod -a -G microk8s vagrant
mkdir -p ~/.kube
sudo chown -R vagrant ~/.kube
```

Einmal abmelden und neu anmelden (damit der User `vagrant` auch tatsächlich in der Gruppe `micork8s` ist) und dann noch dieses Kommando nachschießen:

## Start

```
microk8s start
```

## Konfiguration

Microk8s kommt mit einem Plugin-Ansatz daher ... die Plugins muss man entsprechend einschalten

```
microk8s enable rbac dns storage ingress
```

Microk8s kommt zwar schon gebundelt mit einem eigenen `kubectl` (`microk8s.kubectl`), will neben dem Microk8s auch einen "normalen" Kubernetes Cluster managen, dann wird man das offizielle `kubectl` verwenden wollen.

> Ich empfehle, das `microk8s.kubectl` nicht zu verwenden. Stattdessen das normale `kubectl` per `microk8s config > ~/.kube/config` umkonfigurieren. Dann funktioniert auch die Auto-Completion von `kubectl` einfach out-of-the-box auch für Microk8s.

## Konfiguration kubectl

Mit

```
microk8s config > ~/.kube/config-microk8s
```

erstellt man die Konfiguration und macht sie per

```
export KUBECONFIG=~/.kube/config-microk8s
```

zur aktuellen, so dass `kubectl get pods` gegen das MicroK8s-Cluster läuft.

## Ingress-Controller

Über

```
microk8s enable ingress
```

wird der Ingress-Controller im Microk8s enabled und gestartet. Er befindet sich in einem separaten Namespace.

> ACHTUNG: man benötigt hierfür zudem den metallb Load-Balancer, der VOR dem Ingress-Controller sitzt

## metallb - Load-Balancer

```
microk8s enable metallb:192.168.100.40-192.168.100.49
```

Die IP-Range definiert, welche IP-Adressen die Load-Balancer erhalten werden (meist reichen in MicroK8s weniger als 10 IP-Adressen). Da die IP-Adressen im gleichen Netzwerk wie der MicroK8s-Knoten (= localhost ... bei MicroK8s der einzige Knoten) liegen muss, kann man per `k get nodes -o wide` herausfinden welche IP-Adresse localhost hat.

---

# Vergleich zu anderen Lösungen

Ich habe mich für microK8s entschieden, weil

* es mit Canonical einen renomierten Anbieter im Hintergrund hat (und hoffentlich noch eine Weile weiterentwickelt wird)
* auf einem Raspberry Pi betrieben werden kann (ARM64 + minimale Hardware-Anforderungen)
* mich [dieser Vergleich](https://microk8s.io/compare) überzeugt hat
  * Vanilla Kubernetes
  * Multi-Node Support

## Minikube

Minikube unterstützt nur einen einzelnen Worker-Knoten ... ist somit kein echtes Cluster und somit stark eingeschränkt.

## k3s

* [Homepage](https://k3s.io/)
* [GitHub](https://github.com/k3s-io/k3s/)

## k3d

* [Homepage](https://k3d.io)

> "k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker. k3d makes it very easy to create single- and multi-node k3s clusters in docker, e.g. for local development on Kubernetes." ([Homepage](https://k3d.io))

Der Vorteil ist, dass man Cluster-Nodes als Docker-Container abbildet und somit auch lokal auf einem Laptop eine Multi-Node-Cluster starten kann.

## kind

* [Homepage](https://kind.sigs.k8s.io/)

... `kind` kommt in Docker-Desktop schon vorinstalliert.

---

