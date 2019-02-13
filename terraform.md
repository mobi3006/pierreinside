# Terraform

* [Homepage by HashiCorp](https://www.terraform.io/)

Tool um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ...) in der Cloud und On-Premise komplexe Deployment-Landschaften abzubilden. Terraform ist KEIN Konfigurationsmanagement-Tool, es baut die Infrastruktur auf (z. B. virtuelle Maschinen) und delegiert die Konfiguration an entsprechende Konfiguration-Management Tools ([Ansible](ansible.md), Chef, Puppet, ...).

> BTW: Terraform verwendet sehr ähnliche Konzepte wie bei [Nomad](nomad.md) ... auch ein HashiCorp Produkt.

Terrform ist Cloud-Provider unabhängig ... damit verhindert es im Gegensatz zu den Cloud Pendants Amazon AWS CloudFormation oder Microsoft Azure-Resource-Manager den Vendor-Lock-In. Gelegentlich will/muß man sogar Multi-Cloud-Architekturen (Amazon-, Google-, Microsoft-Cloud in **EINER** Landschaft) abbilden.

---

## Konzept

Man beschreibt einen Zielzustand und Terraform berechnet daraus einen Execution Plan für verschiedene Deploy-Platformen - die Beschreibung ist unabhängig von der Ziel-Platform (geringer/kein Vendor-Lockin), der Execution Plan ist platform-spezifisch. Die Planung optimiert die Rollout-Zeit durch Parallelisierung unabhängiger Abschnitte des Execution Plans.

Im Gegensatz dazu werden in Ansible imperativ die durchzuführenden Schritte angegeben ... der DevOps muß also immer genau wissen welchen Zustand die Umgebung hat und welche Schritte auszuführen sind. Das ist natürlich deutlich fehleranfälliger als wenn dies - wie bei Terraform - aus der Beschreibung des Zielzustands und dem aktuellen Zustand berechnet wird. Zudem zeigt Terrform die durchführenden Aktionen nach einem `terraform plan` übersichtlich an (kann man sogar als Input für einen Approval im Vier-Augen-Prinzip verwenden). Im Gegensatz Bash-Skripting hat Ansible aber zumindest auf ganz niederiger Ebene etwas wie die Beschreibung des Zielzustands:

```
- name: Instana Agent | ensure packages present
  package:
    name: instana-agent-static
    state: latest
    update_cache: yes
- name: Instana Agent | ensure Agent started
  service:
    name: instana-agent
    state: started
```

In diesem Beispiel muß man sich als Ansible-Entwickler nicht mehr prüfen, ob der Agent bereits nicht mehr darum kümmern, ob der Instana-Agent evtl. schon gestartet ist. Aber dennoch beschreibt man nicht nur einfach, daß man einen gestarteten Agent haben möchte, sondern muß auch die Schritte dahin ("ensure packages present", "ensure Agent started"). Insofern ist Ansible schon mal einen Schritt weiter als bash-Skripting (ist es das wert?), aber noch weit vom Terraform-Komfort entfernt.

---

## Terraform vs. Vagrant

[Vagrant](vagrant.md) ist eher für den kleinen lokalen Einsatz gedacht ... Entwicklungsumgebungen automatisieren - keine komplexen Landschaften (ganze Datacenter). Entwicklungsumgebungen verwenden andere Ansätze (z. B. Shared Folder) als komplexe remote Enterprise Umgebungen.

ABER: ganz grundsätzlich falsch ist es nicht, daß die beiden Tools ähnlich sind.

---

## Installation

Terraform besteht nur aus einem einzigen Binary ([Go ist die Sprache](https://de.wikipedia.org/wiki/Go_(Programmiersprache)), in der es programmiert ist - ganz typisch ist, daß ein einziges Binary entsteht), [das für verschiedene Plattformen angeboten wird](https://releases.hashicorp.com/terraform/) - toll ... so einfach kann das sein :-)

```bash
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
chmod 755 terraform
```

> ACHTUNG: will man Terraform-State mit anderen Benutzern teilen (z. B. über S3 Bucket), dann sollte man entweder die gleiche Terraform-Version verwenden oder in Terraform eine State-Version explizit konfigurieren.

---

## Getting Started

* [Terraform Doku](https://www.terraform.io/intro/getting-started/build.html)

Diese Konfiguration (z. B. `main.tf`)

```json
provider "aws" {
  access_key = "ACCESS_KEY_HERE"
  secret_key = "SECRET_KEY_HERE"
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "${var.instance_type}"
}

variable "instance_type" {
  type = "string"
}
```

wird mit

```bash
terraform verify                            # Syntaxprüfung
terraform init                              # hierdurch wird ein Verzeichnis .terraform im aktuellen Verzeichnis angelegt
                                            # providerspezifische Informationen werden nachgeladen
terraform plan -var instance_type=t2.micro  # hier sieht man was geschehen wird
terraform apply                             # erzeugt den Execution Plan
```

ausgeführt. Dabei werden alle `*.tf` und `*.tfvars` Dateien berücksichtigt, die sich im aktuellen Verzeichnis befinden (Convention-over-Configuration). Anschließend ist die Maschine auf AWS nutzbar.

Eine Best-Practice ist die Aufteilung des Codes auf mehrere Dateien

* `vars.tf`
* `outputs.tf`
* `main.tf`

... das verbessert die Übersicht und durch die Konvention findet man sich in fremden Projekten auch schneller zurecht. Eine Wiederverwendung läßt sich Module erreichen.

> Beachte in dem Beispiel, daß eine Variable `instance_type` verwendet wird, die zur Ausführungszeit gesetzt sein muß. Das geschieht
> * in einer `*.tfvar` Datei, die
>   * sich im gleichen Ordner befindet
>   * per `terraform apply -var-file ~/my-values.tfvar` angegeben wird
> * als Parameter an `terraform apply -var instance_type=t2.micro`
> * über eine Umgebungsvariable (`export TF_VAR_instance_type=t2.micro`)

Bei `terraform plan` wird angezeigt, was bei `terraform apply` geschehen wird. Beachte hierbei, daß die Konfiguration das Ziel beschreibt. Abhängig vom aktuellen Zustand (gespeichert in einer `*.tfstate` Datei) werden dann die notwendigen Aktionen berechnet. Der Plan ist natürlich nur gültig solange keine Änderung erfolgt. Ändert jemand anschließend die Umgebung, dann muß der Plan natürlich anders aussehen ... Terraform hat hier optimistisches Locking implementiert.

Mit `terraform destroy` wird die Infrastruktur wieder abgebaut.

Die Definition des Providers (`provider "aws"`) ist notwendig, weil die Ressourcen teilweise doch anbieterabhängig sind.

> Von wegen _providerunabhängig_? hab ich dann überhapt etwas gewonnen?
> sicherlich kann ich dann keinen provider-unabhängen IaC-Code schreiben, aber ich kann mit Terraform zumindest ein Multi-Cloud-Szenario abbilden. In diesem Beispiel sieht man aber, daß Teile des Code (`dnsimple_record.example`) durchaus provider-unabhängig sind:

    ```json
    resource "aws_instance" "example" {
      ami = "ami-40d28157"
      instance_type = "t2.micro"
    }
    resource "dnsimple_record" "example" {
      domain = "example.com"
      name = "test"
      value = "${aws_instance.example.public_ip}"
      type
    }
    ```

---

## Provisioning

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Verwendet man bereits vorkonfigurierte Images (z. B. mit [Packer](packer.md)), dann ist man evtl. nicht mehr auf Konfiguration Management Tools (wie Ansible, Puppet, Chef, ...) angewiesen.

---

## State

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der aufs Filesystem oder remote (z. B. S3) abgelegt werden kann. Dieser State bestimmt die zu triggernden Aktionen bei einem `terraform apply`. Wenn der State verloren geht (wird gelöscht oder `terraform apply` wird von einem anderen Rechner ausgeführt, der keinen Zugriff auf den State hat), dann kann es zu Fehlermeldungen wie diesen führen, wenn die Aktionen durchgeführt werden:

```
keys already exist under service/petclinic/; delete them before managing this prefix with Terraform
```

Das liegt daran, daß Terraform eine Resource anlegen will, die im Backend (z. B. Consul) aber schon vorhanden ist. Über den State hätte Terraform gewußt, daß die Resource schon existiert und hätte die Aktion gar nicht erst ausführen wollen.

> ERGO: Terraform liest nicht den aktuellen State vom Backend, sondern aus der `tfstate` Datei - vielleicht ist das so eine Art optimistisches Locking?

---

## Terraform Enterprise

Hat folgende zusätzliche Features

* Berechtigungen
* Workflows
* [Auditierung](https://www.terraform.io/docs/enterprise/private/logging.html#audit-logs)
  * wer hat wann was geändert

### Workspace

Ein Workspace umfaßt

* Terraform Konfiguration
* Variablen
* State
* Logs

> "We recommend that organizations break down large monolithic Terraform configurations into smaller ones, then assign each one to its own workspace and delegate permissions and responsibilities for them. TFE can manage monolithic configurations just fine, but managing smaller infrastructure components like this is the best way to take full advantage of TFE's governance and delegation features. For example, the code that manages your production environment's infrastructure could be split into a networking configuration, the main application's configuration, and a monitoring configuration. After splitting the code, you would create "networking-prod", "app1-prod", "monitoring-prod" workspaces, and assign separate teams to manage them. Much like splitting monolithic applications into smaller microservices, this enables teams to make changes in parallel. In addition, it makes it easier to re-use configurations to manage other environments of infrastructure ("app1-dev," etc.)."

Ein Workspace referenziert ein VCS ... hier gibt es unterschiedliche Organisationsformen für die verschiedenen Umgebungen (Environment = Workspace, DEV - TEST - LIVE), die man unterhalten muß:

* [Repository Struktur](https://www.terraform.io/docs/enterprise/workspaces/repo-structure.html)

### Workflow

* [UI/VCS-driven run workflow (DEFAULT)](https://www.terraform.io/docs/enterprise/run/ui.html)
* [API-driven run workflow](https://www.terraform.io/docs/enterprise/run/api.html)
* [CLI-driven run workflow](https://www.terraform.io/docs/enterprise/run/cli.html)
