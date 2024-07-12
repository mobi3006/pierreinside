# Kubernetes Helm

* [Website](https://helm.sh/)

Helm ist ein Package-Manager für Kubernetes.

Ein Kubernetes Package (sog. Helm-Chart) besteht aus einer Sammlung von Kubernetes-Manifest Dateien, die mit einem einzigen Kommando installiert werden können. Dadurch ist es möglich, eine komplexes Kubernetes-Lösung leicht wiederverwendbar zur Installation bereitzustellen. Typische Ressourcen in einem Helm-Chart sind Deployment, Service, Ingress, ConfigMap, Secret.

Ein solches Package muss sich natürlich in die Anwendungslandschaft einfügen und hat deshalb ein paar Konfigurationsparameter. Das Package ist dann zunächst mal eine Blackbox wie jedes andere Package (OS-Package, Terraform-Modul) oder Software, die man installiert. Mit einem einzigen Kommando kann man damit eine große Infrastruktur aufbauen ... letztlich ist man auf gute Konfigurationsparameter, eine ausreichende Dokumentation und eine gute Community angewiesen. 

> im Hintergrund befindet sich auch nur ein Source-Code-Repository (z. B. auf GitHub), das mit der Helm-CLI leichter nutzbar gemacht wird

---

# Installation CLI

Helm ist eine CLI (hat aber auch [terraform](terraform.md) Unterstützung), die z. B. folgendermaßen installiert wird

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

---

# Konfiguration CLI

Helm kann verschiedene Package-Repositories verwalten. So fügt man ein Repository zu einem [AWS-EKS Cluster](aws-eks.md) hinzu (vorausgesetzt man hat AWS mit dem richtigen Account konfiguriert):

```
helm repo add eks https://aws.github.io/eks-charts
```

Anschließend kann man per

```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster-name \
  --set serviceAccount.create=false \
  --set serviceAccount.name=my-service-account \
  --set image.repository=602401143452.dkr.ecr.eu-central-1.amazonaws.com/amazon/aws-load-balancer-controller
```

ein Deployment starten, das man auch per `kubectl get deployments` abfragen.

---

# Terraform

Mit einem

```
resource "helm_release" "example" {
  name       = "my-redis-release"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "6.0.1"

  ...
}
```

kann man eine Helm-Chart Instanz in einem Kubernetes Cluster managen.