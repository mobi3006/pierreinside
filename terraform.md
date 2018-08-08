# Terraform

* [Homepage by HashiCorp](https://www.terraform.io/)

Tool um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ...) in der Cloud und On-Premise komplexe Deployments abzubilden. Terraform ist KEIN Konfigurationsmanagement-Tool ... Terraform baut die Infrastruktur auf und überläßt die Konfiguration darauf spezialisierten Tools ([Ansible](ansible.md), Chef, Puppet, ...).

## Konzept

Man beschreibt einen Zielzustand und Terraform berechnet daraus einen Execution Plan für verschiedene Deploy-Platformen - die Beschreibung ist unabhängig von der Platform (geringer/kein Vendor-Lockin), der Execution Plan ist platform-spezifisch. Die Planung optimiert die Rollout-Zeit durch Parallelisierung unabhängiger Abschnitte des Execution Plans.

## Terraform vs. Vagrant

[Vagrant](vagrant.md) ist eher für den kleinen lokalen Einsatz gedacht ... Entwicklungsumgebungen automatisieren - keine komplexen Landschaften (ganze Datacenter). Entwicklungsumgebungen verwenden andere Ansätze (z. B. Shared Folder) als komplexe remote Enterprise Umgebungen.

ABER: ganz grundsätzlich falsch ist es nicht, daß die beiden Tools ähnlich sind.

## Installation

Terraform besteht aus einem einzigen Binary (so einfach kann das sein ;-)

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
terraform init
terraform apply     # erzeugt den Execution Plan
```

zum Deployment ... anschließend ist die Maschine auf AWS nutzbar. Mit `terraform destroy` wird die Infrastruktur wieder abgebaut.

## Provisioning

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Verwendet man bereits provisioned Images (z. B. mit [Packer](packer.md)), dann ist man evtl. nicht mehr auf Provisioning-Tools angewiesen.
