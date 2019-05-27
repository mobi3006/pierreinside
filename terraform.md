
# Terraform

* [Homepage by HashiCorp](https://www.terraform.io/)

Tool um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ...) in der Cloud und On-Premise komplexe Landschaften für ein Applikationsdeployment vorzubereiten. Auf dieser Umgebung können die Applikationen dann aufsetzen.

> "terraform is used for the environment/server provisioning part [...], but not so often for app deployment." ([StackOverflow](https://stackoverflow.com/questions/37297355/how-to-deploy-and-redeploy-applications-with-terraform))

 Terraform ist KEIN Konfigurationsmanagement-Tool, es baut die Infrastruktur auf (z. B. virtuelle Maschinen, Datenbank-Server-Instanz) und delegiert die Konfiguration an entsprechende Konfiguration-Management Tools ([Ansible](ansible.md), Chef, Puppet, ...).

> BTW: Terraform verwendet sehr ähnliche Konzepte wie bei [Nomad](nomad.md) ... auch ein HashiCorp Produkt.

Terrform ist Cloud-Provider unabhängig ... damit verhindert es im Gegensatz zu den Cloud Pendants Amazon AWS CloudFormation oder Microsoft Azure-Resource-Manager den Vendor-Lock-In. Gelegentlich will/muß man sogar Multi-Cloud-Architekturen (Amazon-, Google-, Microsoft-Cloud in **EINER** Landschaft) abbilden.

---

## Konzept

Man beschreibt einen Zielzustand und Terraform berechnet daraus einen Execution Plan für verschiedene Deploy-Platformen - die Beschreibung ist unabhängig von der Ziel-Platform (geringer/kein Vendor-Lockin), der Execution Plan ist platform-spezifisch. Die Planung optimiert die Rollout-Zeit durch Parallelisierung unabhängiger Abschnitte des Execution Plans.

> ACHTUNG: Terraform berücksichtigt bei der Planung nur den State (gespeichert in einer Datei - abgelegt auf der lokalen Platte oder auf einem shared Bereich). Der tatsächliche Zustand der Runtime-Umgebung wird nicht berücksichtigt (wäre auch sehr schwierig). Das bedeutet im Umkehrschluß, daß manuelle Änderungen an der Runtime-Umgebung verloren gehen oder vielleicht sogar zu später fehlschlagenden `terraform apply` Kommandos führen können. Infrastructure-as-Code bedeutet auch,, daß man es konsequent anwendet!!!
>> "Once you start using Terraform, you should only use Terraform" (Buch: *Terraform - Up and Running: Writing Infrastructure as Code*)

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

ausgeführt. Dabei werden alle `*.tf`-Dateien, `terraform.tfvars` und `foo.auto.tfvars` Dateien berücksichtigt, die sich im aktuellen Verzeichnis befinden (Convention-over-Configuration). Anschließend ist die Maschine auf AWS nutzbar.

Eine Best-Practice ist die Aufteilung des Codes auf mehrere Dateien mit diesem Namensschema:

* `vars.tf`
* `outputs.tf`
* `main.tf`

... das verbessert die Übersicht und durch die Konvention findet man sich in fremden Projekten auch schneller zurecht. Eine Wiederverwendung läßt sich Module erreichen.

> Beachte in dem Beispiel, daß eine Variable `instance_type` verwendet wird, die zur Ausführungszeit gesetzt sein muß. Das geschieht
>
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

### Resource

Die Definition einer Resource

```json
resource "aws_instance" "application_server" {
  ami           = "ami-2757f631"
  instance_type = "${var.instance_type}"
}
```

referenziert den Ressource-Type (hier `aws_instance` - [Dokumentation](https://www.terraform.io/docs/providers/aws/r/instance.html)), der ressource-type-spezifische Properties akzeptiert/benötigt (z. B. `ami`). Der erste Teil des Ressource-Types (hier `aws`) ist zumeist ein Indiz auf den Provider (hier [AWS](https://www.terraform.io/docs/providers/aws/index.html)). Zudem hat die Ressource einen Namen (hier `application_server`), über den die Properties per `resource.aws_instance.application_server.instance_type` referenziert werden können.

Zudem gibt es weitere Meta-Properties wie z. B. `depends_on`, `lifecycle`, `count`, die providerunabhängig sind.

Das `lifecycle.create_before_destroy` hilft beispielsweise bei der Abbildung von Zero-Downtime.

### Variable

```json
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### Data

Über `data` lassen sich Daten zur Laufzeit sammeln und weiternutzen.

> ACHTUNG: diese Daten können zur `plan`- oder `apply`-Phase bereitstehen.

Hier ein Beispiel wie man ein aus einem Template **gerendertes** File referenziert (beachte im folgenden `...nomad-job-template.rendered`):

```json
data "template_file" "my-service-nomad-job-template" {
  template = "${file("${path.module}/nomad.tmpl.hcl")}"
  vars {
    docker_image = "https://..."
  }
}

resource "nomad_job" "my-service" {
  jobspec = "${data.template_file.nomad-job-template.rendered}"
}
```

Hier sieht man auch sehr schön die übergreifende Adressierung (von `nomad_job.my-service` nach `template_file.my-service-nomad-job-template`) via `data.template_file.my-service-nomad-job-template`.

### Module

Auf diese Weise lassen sich Teile der Konfiguration wiederverwenden. Jede Sammlung von `*.tf` Dateien ist ein Modul.

So sieht die Wiederverwendung eines Moduls aus:

```json
module "use-my-terraform-module" {
  source = "/home/pfh/my-terraform-module"
  // verschiedene Quellen sind möglich
  // source = "https://mvnrepository.com/artifact/.../config-2.3.5.zip"
  // source = "git://"
  
  variable1 = "value1"
}
```

In diesem Fall werden alle Platzhalter `variable1` im Terraform Ordner `/home/pfh/my-terraform-module` mit `value1` ersetzt. Bei `source` handelt es sich um ein Meta-Argument, das das zu verwendende Modul referenziert.

Praktisch ist, daß man bei `source` auch eine Sammlung von Terraform Scripten in Form einer `zip`-Datei angeben kann. In dem Fall wird die Zip-Datei bei `terraform apply` entpackt und die Platzhalter werden ersetzt. Auf diese Weise kann man eine Sammlung von Konfigurationsdateien in einem `zip`-File bereitstellen und dann mit Werten belegen.

> vor einer solchen Aufgabe steht man häufig, wenn man Software stage-abhängig konfigurieren muß.

---

## Provider

* [Übersicht über alle Provider](https://www.terraform.io/docs/providers/index.html)

Provider sind das eigentliche Salz in der Suppe ... sie stellen die Implementierung der Terraform-Beschreibung zur Verfügung und machen das eigentlich Doing. Ein Provider bietet dem Nutzer die Möglichkeiten Services (oder allgemeiner Ressourcen) in `HCL`-Sprache zu definieren und bei Ausführung des Terraform-Skripts (`terraform apply`) anzulegen/konfigurieren.

Viele Infrastrukturanbieter stellen Provider in Form von Modulen (werden bei `terraform init` aus dem Internet gezogen) für Terraform zur Verfügung:

* [AWS](https://www.terraform.io/docs/providers/aws/index.html)
* [Google]()
* [Nomad](https://www.terraform.io/docs/providers/nomad/index.html)
* [Consul](https://www.terraform.io/docs/providers/consul/index.html)
* [Vault](https://www.terraform.io/docs/providers/vault/index.html)
* [Terraform Enterprise](https://www.terraform.io/docs/providers/tfe/index.html)
* ...

Beim `terraform init` werden diese Module i. a. dynamisch aus dem Internet gezogen (in diesem Beispiel werden die `latest` Versions gezogen, weil keine Versionen explizit angegeben wurden):

```
pfh@workbench terraform init

Initializing modules...
- module.blablub
  Getting source "/home/.../blablub-config.zip"

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "nomad" (1.3.0)...
- Downloading plugin for provider "template" (2.1.2)...
- Downloading plugin for provider "consul" (2.3.0)...
- Downloading plugin for provider "vault" (1.8.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.consul: version = "~> 2.3"
* provider.nomad: version = "~> 1.3"
* provider.template: version = "~> 2.1"
* provider.vault: version = "~> 1.8"
```

Zudem gibt es Provider (z. B. [MySQL](https://www.terraform.io/docs/providers/mysql/index.html), die Ihre Services mit denen andere kombinieren (z. B. eine MySQL-Datenbank auf einem AWS-MySQL-Cluster anlegen).

### Custom-Provider

Man kann auch seinen eigenen Provider `terraform-provider-<NAME>_vX.Y.Z` contributen ([hier gehts zur Doku](https://www.terraform.io/docs/extend/writing-custom-providers.html)). Diese werden dann aber bei `terraform init` nicht automatisch aus dem Internet geladen - stattdessen muß man sie in `~/.terraform.d/plugins` ablegen.

---

## Provisioning

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Verwendet man bereits vorkonfigurierte Images (z. B. mit [Packer](packer.md)), dann ist man evtl. nicht mehr auf Konfiguration Management Tools (wie Ansible, Puppet, Chef, ...) angewiesen. Hat man sich allerdings gegen diesen sehr statischen Ansatz entschieden, so kann man über die Provisioners entsprechende Veränderungen am System über Skripte triggern. Hierbei stehen typische Configuration-Management-Tools (z. B. Chef, Salt)

---

## State

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der aufs Filesystem (Local - das ist der Default) oder remote (z. B. S3) abgelegt werden kann. Dieser State bestimmt die zu triggernden Aktionen bei einem `terraform apply`, indem ein Diff zwischen dem neuen Ziel-Status und dem aktuellen Status gemacht wird. Per Default wir der State lokal abgelegt - arbeitet das Team verteilt oder will man Datenverlusten vorbeugen, sollte man den State zentral (z. B. Consul, S3) speichern. Dann muß man sich allerdings auch mit dem Thema [State Locking](https://www.terraform.io/docs/state/locking.html) beschäftigen.

> ACHTUNG: sind Secrets in dem State enthalten, dann enthält der State diese Werte im Klartext (!!!) => evtl. sollte man über eine Verschlüsselung des States (z. B. [mit S3-Backend](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html)) nachdenken.

Wenn der State verloren geht (wird gelöscht oder `terraform apply` wird von einem anderen Rechner ausgeführt, der keinen Zugriff auf den State hat), dann kann es zu Fehlermeldungen wie diesen führen, wenn die Aktionen durchgeführt werden:

```
keys already exist under service/petclinic/; delete them before managing this prefix with Terraform
```

Das liegt daran, daß Terraform eine Resource anlegen will, die aber schon vorhanden ist. Über den State hätte Terraform gewußt, daß die Resource schon existiert und hätte die Aktion gar nicht erst ausführen wollen.

> ERGO: Terraform liest den aktuellen State nicht aus der deployten Landschaft (wäre recht aufwendig und fehlerträchtig), sondern aus der State-Datei. Das hat zudem zur Konsequenz, daß Änderungen, die nicht in der zentralen State-Datei erfolgt sind (z. B. manuelle Änderungen, Änderungen über andere Wege als Terraform) nicht berücksichtigt werden können. Diese Änderungen werden dann überschrieben!!!

### Workspaces

Über Workspaces lassen sich State-Files separieren, um so beispielsweise unterschiedliche Landschaften (Live-Environment, Test-Environment, DEV-Environment) voneinander trennen.

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
