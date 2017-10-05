# Kubernetes

* Refcardz: https://dzone.com/refcardz/kubernetes-essentials

Kubernetes ist ein Google-Projekt zur Orchestrierung von Containern (z. B. Docker-Containern). Auf diese Weise lassen sich Deployments automatisieren, administrieren, horizontales skalieren, ausrollen (Rolling Deployments). Kubernetes besitzt ausserdem eine Selbstheilungsmöglichkeit - stirbt ein Pod, so bekommt Kubernetes das mit und startet einen neuen.

# Infrastruktur
* CoreOS mit Docker/Rocket 
* flannel
* Kubernetes Controller
* Kubernetes Node
* Terraform
* Google Compute Engine

# Konzepte
**Pods:**
* ist atomare Deployment-Einheit ... Dinge, die IMMER gemeinsam auf einer Maschine (= Minion) deployed werden.
* besteht aus einem Konglomerats von Docker-Containern, Data-Volumes, Networks, ...
  * kann aber natürlich auch nur ein einziger Docker-Container sein
* ein Pod kann mehrere Labels haben, die dann verwendet werden, um Pods auszuwählen
* Pods teilen sich Volumes
* alle Container eines Pods können über ``localhost`` miteinander kommunizieren (vereinfacht die Konfiguration)
* sind volatil ... können wegfallen oder sich vermehren (getriggert durch den 

**Minion:**
* Minion ist die softwareseitige Komponente eines Nodes - der Node besteht aus der Hardware und der Software (= dem Minion)

**Node:**
* Teilnehmer an einem Kubernetes Cluster
* auf einem Node 

**Master-Node:**
* ausgezeichneter Node, der als Master fungiert und folgende Dienste bereitstellt
  * API-Server: hiermit kommuniziert das Tool `kubectl`, das der Administrator zur Steuerung verwendet
  * Scheduler: überwacht, daß die Spezifikation der Landschaft (z. B. Anzahl der Pods) eingehalten ist und startet/stoppt ggf. Pods
  * Controller für Background-Aufgaben

**Kubelet:**
* Agent, der auf jedem Slave-Node im Kubernetes-Cluster läuft
* hierüber wird der Kubernetes-Master auch über neue Nodes informiert (Node registriert sich beim Master)
* ist der verlängerte Arm des Kubernetes-Masters, ein paar Beispiels
  * erhält den Auftrag einen neuen Pod zu starten
  * stellt Health-Check-Informationen des Nodes bereit

**Service:**
* hat eine statische Location (z. B. FQDN, IP-Addresse) - im Gegensatz zu Pods, die so volatil sind, daß sie ständig woanders sein können.
* der Service ist eigentlich ein Service-Proxy, der dem Client diese Volatilität verbirgt und ihm eine beständige Kommunikationsadresse bietet
  * verwendet hierzu die Pod Lables, um die passenden Ziele zu finden   

**etcd:**
* key/value Store
* enthält die Konfiguration des Clusters 
* jeder Knoten hat Zugriff

**Reconciliation:**
* man definiert einen gewünschten Zustand und Kubernetes sorgt dafür, daß der Zustand erreicht wird:
  * gewünschter Zustand: 3 Pods xyz laufen
  * aktueller Zustand: 1 Pod xyz läuft
  * Kubernetes Replication Controller started 2 weitere xyz Pods 
* Kubernetes macht Healthchecks, um den aktuellen Zustand immer abzufragen und den gewünschten Zustand evtl. zu erreichen

## Nice2Know
* neue Knoten werden nach dem Start von Kubelet automatisch in das Cluster als Ressource aufgenommen
* über ein Overlay-Network (z. B. bei Docker) wird ein Netzwerk gespannt, das die Kommunikation der Cluster-Nodes ermöglicht 

# Getting Started
Grundsätzlich basiert Kubernetes auf der Idee, das Deployment über mehrere Maschinen zu verteilen. [Minikube](https://github.com/kubernetes/minikube) ist ein Ansatz, um Kubernetes lokal auf einem einzigen Cluster-Knoten zu betreiben und damit erste Erfahrungen zu sammeln.

Die manuelle Installation eines Kubernetes-Clusters ist nicht trivial (insbes. hinsichtlich der Netzwerkkonfiguration). Insofern ist Minikube ein guter Startpunkt. Auf vielen IaaS-Plattformen (z. B. AWS) existieren fertige Templates, die die Installation und Konfiguration zu einem Kinderspiel machen. Auch das ist ein guter Startpunkt.

## Lokale Installation per Minikube/Virtualbox
* https://github.com/kubernetes/minikube

Für die Installation werden zwei Programme:
* `minikube`
  * unter Windows lädt man sich die `exe` Datei aus dem Internet und benennt es um in `minikube.exe`
* `kubectl`
  * unter Windows lädt man sich die `exe` Datei aus dem Internet 
 
Beide Programme sollten sich im `PATH` befinden. Dann startet man eine terminal-Konsole und beginnt die Installation per `minikube start`:

```
minikube start
Starting local Kubernetes v1.6.4 cluster...
Starting VM...
Downloading Minikube ISO
 90.95 MB / 90.95 MB [==============================================] 100.00% 0s
Moving files into cluster...
Setting up certs...
Starting cluster components...
Connecting to cluster...
Setting up kubeconfig...
Kubectl is now configured to use the cluster.
```

Dabei wird das sog. "Minikube ISO" runtergeladen (nach `~/.minikube`) und ein Virtualbox-Image erzeugt und gestartet. Jetzt kann das Kubernetes-"Cluster" mit Leben gefüllt werden:

```
kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
```

Der deployte und exponierte Pod liefert einen Http-GET-Service, der per `minikube service hello-minikube` aufgerufen werden kannn.

Die Minikube-VM (und damit auch das Kubernetes Cluster) wird per `minikube stop` runtergefahren.

### Minikube - Dashboard 
* https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Per `minikube dashboard` wird eine Administrationskonsole im Browser aufgerufen.

### Minikube - ssh
Per `minikube ssh` kann man eine SSH-Konsole auf das Minikube-Image bekommen und so bessere Einsichten erhalten (leider ist diese Shell nicht besonders komfortabel konfiguriert - beispielsweise funktioniert die Kommandohistorie nicht ordentlich).

### Minikube - Docker Kommandos aufrufen
Entweder macht man ein `minikube ssh`, um auf die Konsole des Minikube-Images zu kommen oder man biegt die lokal eingegebenen `docker` Kommandos (`docker ps`) auf die Minikube-VM um ... das ist recht praktisch, da die das Terminal bei `minikube ssh` nicht besonders komfortabel ist.

* https://github.com/kubernetes/minikube/blob/master/docs/reusing_the_docker_daemon.md

# Google Cloud Engine

Die Google Cloud Engine ist 

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

---


