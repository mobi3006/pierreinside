# Minikube

* [Homepage Minikube](https://github.com/kubernetes/minikube)

Für die Installation werden zwei Programme:

* `minikube`
  * unter Windows lädt man sich die `exe` Datei aus dem Internet und benennt es um in `minikube.exe`
* `kubectl`
  * unter Windows lädt man sich die `exe` Datei aus dem Internet

Beide Programme sollten sich im `PATH` befinden. Dann startet man eine terminal-Konsole und beginnt die Installation per `minikube start`:

```bash
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

```bash
kubectl run hello-minikube --image=gcr.io/google_containers/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
```

Der deployte und exponierte Pod liefert einen Http-GET-Service, der per `minikube service hello-minikube` aufgerufen werden kannn.

Die Minikube-VM (und damit auch das Kubernetes Cluster) wird per `minikube stop` runtergefahren.

---

## Dashboard

* https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Per `minikube dashboard` wird eine Administrationskonsole im Browser aufgerufen.

---

## ssh

Per `minikube ssh` kann man eine SSH-Konsole auf das Minikube-Image bekommen und so bessere Einsichten erhalten (leider ist diese Shell nicht besonders komfortabel konfiguriert - beispielsweise funktioniert die Kommandohistorie nicht ordentlich).

---

## Docker Kommandos aufrufen

Entweder macht man ein `minikube ssh`, um auf die Konsole des Minikube-Images zu kommen oder man biegt die lokal eingegebenen `docker` Kommandos (`docker ps`) auf die Minikube-VM um ... das ist recht praktisch, da die das Terminal bei `minikube ssh` nicht besonders komfortabel ist.

* https://github.com/kubernetes/minikube/blob/master/docs/reusing_the_docker_daemon.md
