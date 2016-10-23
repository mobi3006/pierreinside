# Kubernetes

* Refcardz: https://dzone.com/refcardz/kubernetes-essentials

Kubernetes ist ein Google-Projekt, mit dem sich Deployments auf Basis von Docker-Containern automatisieren, administrieren, skalieren läßt.

## Infrastruktur
* CoreOS mit Docker/Rocket 
* flannel
* Kubernetes Controller
* Kubernetes Node
* Terraform
* Google Compute Engine

## Konzepte
**Pods:**
* ist atomare Deployment-Einheit ... Dinge, die IMMER gemeinsam auf einer Maschine deployed werden.
* besteht aus einem Konglomerats von Docker-Containern, Data-Volumes, Networks, ...
  * kann aber natürlich auch nur eine einziger Docker-Container sein
* ein Pod kann mehrere Labels haben, die dann verwendet werden, um Pods auszuwählen
* Pods teilen sich Volumes
* alle Container eines Pods können über ``localhost`` miteinander kommunizieren (vereinfacht die Konfiguration)

**Kubelet:**

**Service:**
* hat eine statische Location (z. B. FQDN, IP-Addresse) - im Gegensatz zu Pods, die so volatil sind, daß sie ständig woanders sein können.
* der Service ist eigentlich ein Service-Proxy, der dem Client diese Volatilität verbirgt und ihm eine beständige Kommunikationsadresse bietet
  * verwendet hierzu die Pod Lables, um die passenden Ziele zu finden 

**Reconciliation:**
* man definiert einen gewünschten Zustand und Kubernetes sorgt dafür, daß der Zustand erreicht wird:
  * gewünschter Zustand: 3 Pods xyz laufen
  * aktueller Zustand: 1 Pod xyz läuft
  * Kubernetes Replication Controller started 2 weitere xyz Pods 
* Kubernetes macht Healthchecks, um den aktuellen Zustand immer abzufragen und den gewünschten Zustand evtl. zu erreichen

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



