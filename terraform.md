# Terraform

* [Homepage by HashiCorp](https://www.terraform.io/)

Tool um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ...) in der Cloud und On-Premise komplexe Deployments abzubilden. Terraform ist KEIN Konfigurationsmanagement-Tool, es baut die Infrastruktur auf (z. B. virtuelle Maschien) und delegiert die Konfiguration an entsprechende Konfiguration-Management Tools ([Ansible](ansible.md), Chef, Puppet, ...).

> BTW: Terraform verwendet sehr ähnliche Konzepte wie bei [Nomad](nomad.md) ... auch ein HashiCorp Produkt.

## Konzept

Man beschreibt einen Zielzustand und Terraform berechnet daraus einen Execution Plan für verschiedene Deploy-Platformen - die Beschreibung ist unabhängig von der Ziel-Platform (geringer/kein Vendor-Lockin), der Execution Plan ist platform-spezifisch. Die Planung optimiert die Rollout-Zeit durch Parallelisierung unabhängiger Abschnitte des Execution Plans.

## Terraform vs. Vagrant

[Vagrant](vagrant.md) ist eher für den kleinen lokalen Einsatz gedacht ... Entwicklungsumgebungen automatisieren - keine komplexen Landschaften (ganze Datacenter). Entwicklungsumgebungen verwenden andere Ansätze (z. B. Shared Folder) als komplexe remote Enterprise Umgebungen.

ABER: ganz grundsätzlich falsch ist es nicht, daß die beiden Tools ähnlich sind.

## Installation

Terraform besteht nur aus einem einzigen Binary, das für verschiedene Plattformen angeboten wird - toll ... so einfach kann das sein :-)

## Getting Started

* [Terraform Doku](https://www.terraform.io/intro/getting-started/build.html)

Diese Konfiguration (z. B. `example.tf`)

```json
provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}
```

wird mit

```bash
terraform init      # hierdurch wird ein Verzeichnis .terraform im aktuellen Verzeichnis angelegt
terraform apply     # erzeugt den Execution Plan
```

zum Deployment ... anschließend ist die Maschine auf AWS nutzbar. Mit `terraform destroy` wird die Infrastruktur wieder abgebaut.

## Provisioning

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Verwendet man bereits provisioned Images (z. B. mit [Packer](packer.md)), dann ist man evtl. nicht mehr auf Provisioning-Tools angewiesen.

## State

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der aufs Filesystem oder remote (z. B. S3) abgelegt werden kann. Dieser State bestimmt die zu triggernden Aktionen bei einem `terraform apply`. Wenn der State verloren geht (wird gelöscht oder `terraform apply` wird von einem anderen Rechner ausgeführt, der keinen Zugriff auf den State hat), dann kann es zu Fehlermeldungen wie diesen führen, wenn die Aktionen durchgeführt werden:

```
keys already exist under service/petclinic/; delete them before managing this prefix with Terraform
```

Das liegt daran, daß Terraform eine Resource anlegen will, die im Backend (z. B. Consul) aber schon vorhanden ist. Über den State hätte Terraform gewußt, daß die Resource schon existiert und hätte die Aktion gar nicht erst ausführen wollen. 

> ERGO: Terraform liest nicht den aktuellen State vom Backend, sondern aus der `tfstate` Datei - vielleicht ist das so eine Art optimistisches Locking?