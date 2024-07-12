# ArgoCD

* [Argo CD](https://argo-cd.readthedocs.io)
* [Video (technisch) - ArgoCD Starter Guide: Full Tutorial for ArgoCD in Kubernetes](https://www.youtube.com/watch?v=JLrR9RV9AFA)
* [Video - (konzeptuell + technisch) - ArgoCD Tutorial for Beginners | GitOps CD for Kubernetes](https://www.youtube.com/watch?v=MeU5_k9ssrs)

ArgoCD ist eine Continuous-Deployment Lösung für Kubernetes Ressourcen (Manifests, Helm-Charts). Es ist GitOps-basiert, d. h. die Spezifikation in Git-Repo definiert den gewünschten State des K8s-Clusters. Ähnlich wie bei [Terraform](terraform.md) wir der aktuelle State des K8s-Clusters mit dem gewünschten State (= Spezifikation) - definiert in einem Git-Repository - verglichen. Sollte es hier Diskrepanzen geben, kann ArgoCD automatisch oder durch einen anderen Trigger (z. B. Rollout-Approval) tätig werden und bringt das Cluster wieder in den spezifizierten Zustand.

> man muss hier die Health-Checks von Kubernetes abgrenzen ... die überwachen, ob der aktuelle Zustand dem Zustand im Kubernetes State (etcd) entspricht. Ist das nicht der Fall, dann wird Kubernetes im Sinne von Self-Healing aktiv. Bei ArgoCD geht es darum, dass jemand die Spezifikation in Git geändert hat und evtl. ein neues Deployment gegen K8s erfolgen muss. 

ArgoCD kümmert sich nicht um die Erstellung der zu deployenden Artfakte - das bleibt Aufgabe eine CI-Tools ([GitHub Workflows](github-actions.md), [Jenkins](jenkins.md), ...). ArgoCD ist nur an der Deployment-Konfiguration interessiert (häufig auch NICHT Teil des Repositories, das die Applikationskomponente repräsentiert bzw. dessen Source-Codes), die diese Artefakte ein K8s-Cluster-Deployment über Manifests, Helm-Charts, Kustomize-Files, ... definiert.

---

# Getting Started

Auf einem existierenden K8s-Cluster ([AWS EKS](aws-eks.md), [microk8s](kubernetes-microK8s.md), ...) kann man ArgoCD ganz leicht folgendermaßen in einem neuen Namespace installieren ([see here](https://github.com/devopsjourney1/argo-examples)):

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Das Manifest-File ist recht länglich und setzt den gesamten Stack auf.

> In meinem Parallels-VM Ubuntu-Image Setup **OHNE** UI-support muss ich explzit `address` angeben: `kubectl port-forward --address 0.0.0.0 service/argocd-server -n argocd 8080:443`, um den Zugriff vom UI-fähigen Host-System (MacOS) zu ermöglichen.

Mit diesem Kommando kommt man an das Password des `admin` Users:

```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

so dass man sich per Web-Browser `http://localhost:8080` (bzw. in meinem Setup `http://host.docker.internal:8080`) anmelden kann.

---

# Konzepte

## Unterschied zu Jenkins

* ArgoCD läuft innerhalb des K8s-Clusters und hat es schon allein dadurch entfallen einige schwierige Problemstellungen einer Jenkins-Nutzung (Credentials für den Zugriff auf K8s)
* ArgoCD verwendet einen Pull-Mechanismus ... Jenkins pushed Änderungen nach K8s

## Betriebsmodell

Ein ArgoCD-Server kann beliebig viele K8s-Cluster bedienen - man kann aber auch eine 1:1 Beziehung haben.

ArgoCD läuft selbst in einem EKS-Cluster ... es kann also in einem Namespace laufen, der neben den Namespaces läuft, die er überwacht.

## Sync-Policy

ArgoCD kann manuell syncen oder automatisch. Es schaut zwar bei jedem der beiden Modi regelmäßig nach, ob sich Änderungen ergeben haben, aber nur im `auto`-Mode werden die Änderungen auch applied.

---

# Rollbacks

Rollback kann man natürlich auf Git-Level machen. Eine Alternative dazu ist, das in ArgoCD zu machen. ArgoCD hat die History der Syncs gespeichert und daran ist ein Git-Commit referenziert. Bei einem aus ArgoCD initiierten Rollback aus der WebUI (z. B. notwendig, wenn man in der Nacht niemanden hat, der den Git-Codechange approve kann) wird automatisch der Auto-Sync-Mode ausgeschaltet.
