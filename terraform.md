
# Terraform

* [Homepage by HashiCorp](https://www.terraform.io/)

Tool um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ...) in der Cloud und On-Premise komplexe Infrastruktur- und Applikations-Landschaften aufzubauen. Wer schon mal versucht hat in AWS eine Infrastruktur aus EC2, Security-Groups, Route Tables, Router, Internet Gateway, ... zusammenzuklicken und dann auch zu warten (Komponenten hinzufügen/wegnehmen/umkonfigurieren ... ohne DOWNTIME und im 4-Augen-Prinzip), der wird schnell zu Tools wie terraform greifen, um das zu maintainen. Die Gefahr stundenlang die Fehler in einem Setup zu suchen ist recht hoch ... Fehler passieren schnell.

> "terraform is used for the environment/server provisioning part [...], but not so often for app deployment." ([StackOverflow](https://stackoverflow.com/questions/37297355/how-to-deploy-and-redeploy-applications-with-terraform))

 Terraform ist KEIN Konfigurationsmanagement-Tool, es baut die Infrastruktur auf (z. B. virtuelle Maschinen, Datenbank-Server-Instanz, Datenbank-User) und delegiert die Konfiguration an entsprechende Konfiguration-Management Tools ([Ansible](ansible.md), Chef, Puppet, ...).

> BTW: Terraform verwendet sehr ähnliche Konzepte wie bei [Nomad](nomad.md) ... auch ein HashiCorp Produkt.

Terraform ist Cloud-Provider unabhängig ... damit verhindert es im Gegensatz zu den Cloud Pendants Amazon AWS CloudFormation oder Microsoft Azure-Resource-Manager den Vendor-Lock-In. Gelegentlich will/muß man sogar Multi-Cloud-Architekturen (Amazon-, Google-, Microsoft-Cloud in **EINER** Landschaft) abbilden.

---

## Konzept

Man beschreibt einen Zielzustand (deklarativer Ansatz) und Terraform berechnet aus dem aktuellen Zustand (abgebildet in einer `terraform.tfstate` Datei) einen Execution Plan (die tatsächlichen Aktionen) für verschiedene Deploy-Platformen. Die Planung optimiert die Rollout-Zeit durch Parallelisierung unabhängiger Abschnitte des Execution Plans. Hierzu ist entsprechendes Wissen im Terraform Code notwendig. Ein Beispiel:

* eine Änderung eines EC2 Tags ist ohne Downtime möglich
* eine Änderung des EC2-AMI ist nur durch Terminierung und Neuanlage einer EC2-Instanz möglich

Terraform weiß was es in der jeweiligen Situation am besten tut.

> ACHTUNG: Terraform berücksichtigt bei der Planung nur den State (gespeichert in einer Datei - abgelegt auf der lokalen Platte oder auf einem shared Bereich). Der tatsächliche Zustand der Runtime-Umgebung wird nicht berücksichtigt (wäre auch sehr schwierig). Das bedeutet im Umkehrschluß, daß manuelle Änderungen an der Runtime-Umgebung verloren gehen oder vielleicht sogar zu später fehlschlagenden `terraform apply` Kommandos führen können. Infrastructure-as-Code bedeutet auch,, daß man es konsequent anwendet!!!
>> "Once you start using Terraform, you should only use Terraform" (Buch: *Terraform - Up and Running: Writing Infrastructure as Code*)

Im Gegensatz dazu werden in Ansible imperativ die durchzuführenden Schritte angegeben ... der DevOps muß also immer genau wissen welchen Zustand die Umgebung hat und welche Schritte auszuführen sind. Das ist natürlich deutlich fehleranfälliger (und benötigt viel Detailwissen - das zwischen allen DevOps-Mitarbeitern geteilt werden muß) als wenn dies - wie bei Terraform - aus der Beschreibung des Zielzustands und dem aktuellen Zustand berechnet wird. Zudem zeigt Terrform die durchführenden Aktionen nach einem `terraform plan` halbwegs übersichtlich an (kann man sogar als Input für einen Approval im Vier-Augen-Prinzip verwenden). Im Gegensatz zu Bash-Skripting hat Ansible aber zumindest auf ganz niederiger Ebene etwas wie die Beschreibung des Zielzustands:

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

Idempotenz ist bei Ansible aber deutlich besser umgesetzt als bei Bash-Scripting.

Besonders praktisch ist `terraform destroy`, bei dem Terraform ALLE gemanagten Ressourcen löscht ... das verhindert auch unnötige Kosten.

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
* [mein eigenes Terraform Projekt](https://github.com/mobi3006/terraform-fls15)

Diese Konfiguration (z. B. `main.tf`)

```json
provider "aws" {
  /*
    ACHTUNG: man sollte NIEMALS credentials in einer Terraform-Datei hinterlegen. Diese Dateien stehen 
             unter Versionskontrolle.
  access_key = "0123456789"
  secret_key = "9876543210"

  ... Stattdessen sollte man Variablen verwenden, die entweder aus einer anderen Quelle (z. B. S3)
      gelesen werden oder interaktiv eingegeben werden müssen.
  access_key = "${var.aws_access_id}"
  secret_key = "${var.aws_secret_key}"

  ... alternativ kann man auch ein profile in ~/.aws/config verwenden, das dann alle relevanten Infos
      enthält. Entweder stellt man das zu nutzdende Profil bei terraform plan -var default bereit oder
      man gibt es interaktiv ein.
      BTW: den Profilnamen möchte ich hier auch nicht hardcoden ... da andere User andere Profilnamen
      verwenden (handlet sich um eine lokale Konfiguration).
  */
  profile = "${var.aws_profile}"  
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
                                            # ... aws_access_id, aws_secret_key und instance_type werden interaktiv abgefragt
                                            # ... oder können per -var-file foo.tfvar contributed werden
terraform apply                             # erzeugt den Execution Plan
```

ausgeführt. Dabei werden alle `*.tf`-Dateien, `terraform.tfvars` und `foo.auto.tfvars` Dateien berücksichtigt, die sich im aktuellen Verzeichnis befinden (Convention-over-Configuration). Anschließend ist die Maschine auf AWS nutzbar.

> Ich verwende statt `terraform plan && terraform apply` lieber `terraform plan -out=tfplan && terraform apply tfplan` (`tfplan` ist eine Binärdatei), da hier in diesem Fall sicher sein kann, daß tatsächlich auch der von mir erstellte Plan umgesetzt wird und nichts anderes. Insbesondere wenn ich noch interaktiv Variablenwerte bereitstellen muss ist das die bessere Variante.

Eine Best-Practice ist die Aufteilung des Codes auf mehrere Dateien mit diesem Namensschema:

* `vars.tf`
* `main.tf`
* `outputs.tf`

... das verbessert die Übersicht und durch die Konvention findet man sich in fremden Projekten auch schneller zurecht. Eine Wiederverwendung läßt sich Module erreichen.

> Beachte in dem Beispiel, daß eine Variable `instance_type` verwendet wird, die zur Ausführungszeit gesetzt sein muß. Das geschieht
>
> * in einer `*.tfvar` Datei, die
>   * sich im gleichen Ordner befindet
>   * per `terraform apply -var-file ~/my-values.tfvar` angegeben wird
> * als Parameter an `terraform apply -var instance_type=t2.micro`
> * über eine Umgebungsvariable (`export TF_VAR_instance_type=t2.micro`)

Bei `terraform plan` wird angezeigt, was bei `terraform apply` geschehen wird. Beachte hierbei, daß die Konfiguration das Ziel beschreibt. Abhängig vom aktuellen Zustand (gespeichert in einer `*.tfstate` Datei) werden dann die notwendigen Aktionen berechnet. Der Plan ist natürlich nur gültig solange keine Änderung erfolgt. Ändert jemand anschließend die Umgebung, dann muß der Plan natürlich anders aussehen ... Terraform hat hier optimistisches Locking implementiert.

Mit `terraform destroy` wird die Infrastruktur wieder abgebaut. Das verwendet man in der Produktion aber quasi nie ... in Testumgebungen tut man dies um die Infrastruktur (i. a. bei einem Cloud-Provider) wieder runterzufahren und nicht weiter bezahlen zu müssen.

Die Definition des Providers (`provider "aws"`) ist notwendig, weil die Ressourcen (z. B. `aws_instance`) und deren Konfiguration (z. B. `ami`) natürlich vom Kontext abhängig sind ... ein Deployment auf AWS wird anders beschrieben (steuert der Nutzer per Terraform-Beschriebung bei) und auch implementiert (steuert Terraform bei) ist anderes als auf Azure - die Konzepte sind einfach zu unterschiedlich.

Sicherlich kann ich dann keinen vollständig provider-unabhängen IaC-Code schreiben, aber ich kann mit Terraform zumindest ein Multi-Cloud-Szenario abbilden. In diesem Beispiel sieht man aber, daß Teile des Code (`dnsimple_record.example`) durchaus provider-unabhängig sind:

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

referenziert den Ressource-Type (hier `aws_instance` - [Dokumentation](https://www.terraform.io/docs/providers/aws/r/instance.html)), der ressource-type-spezifische Properties akzeptiert/benötigt (z. B. `ami`). Der erste Teil des Ressource-Types (hier `aws`) ist referenziert i. a. den Provider (hier [aws](https://www.terraform.io/docs/providers/aws/index.html)). Zudem hat die Ressource einen Namen (hier `application_server`), über den die Properties per `resource.aws_instance.application_server.instance_type` referenziert werden können.

Zudem gibt es weitere Meta-Properties wie z. B. `depends_on`, `lifecycle`, `count`, die providerunabhängig sind.

Das `lifecycle.create_before_destroy` hilft beispielsweise bei der Abbildung von Zero-Downtime.

### Variable

```json
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### Dependencies

Durch die Referenzierung von Ressourcen ergibt sich eine implizite Abhängigkeit, die Terraform erkennt und entsprechend auflöst, so daß - unabhängig von der Definition in der `.tf`-Datei - eine valide Reihenfolge bei der Anlage/Löschung von Ressourcen abgeleitet wird. Alles, was voneinander unabhängig ist, kann parallel ausgeführt werden, um die Zeit bis zur Bereitstellung der Ziel-Umgebung zu verringern.

Manchmal muß man allerdings Abhängigkeiten explzit über `depends_on` definieren, wenn Terraform keine Chance zur Ableitung hat. Beispielsweise kann eine Applikation, die in einer anzulegenden EC2-Instanz läuft, einen S3-Bucket voraussetzen. Eine solche Abhängigkeit könnte eine explizite Abhängigkeitsdefinition erfordern.

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

Auf diese Weise lassen sich Teile der Konfiguration wiederverwenden. Jede Sammlung von `*.tf` Dateien ist ein Modul ... man verwendet Module dementsprechend IMMER automatisch. Deshalb referenziert man in `source = "/home/pfh/my-terraform-module"` auch ein Verzeichnis und nicht eine einzelne Datei.

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

In diesem Fall werden alle Platzhalter `variable1` im Terraform Ordner `/home/pfh/my-terraform-module` mit `value1` ersetzt. Bei `source` handelt es sich um ein Meta-Argument, das das zu verwendende Modul referenziert. Module stellen einen Template-Mechanismus zur Verfügung.

Praktisch ist, daß man bei `source` auch eine Sammlung von Terraform Scripten in Form einer `zip`-Datei angeben kann (um sie beispielsweise über einen Artifakt-Repository beizusteuern). In dem Fall wird die Zip-Datei bei `terraform apply` entpackt und die Platzhalter werden ersetzt. Auf diese Weise kann man eine Sammlung von Konfigurationsdateien in einem `zip`-File bereitstellen und dann mit Werten belegen.

> vor einer solchen Aufgabe steht man häufig, wenn man Software stage-abhängig konfigurieren muß.

---

## Provider

* [Übersicht über alle Provider](https://www.terraform.io/docs/providers/index.html)

Provider sind das eigentliche Salz in der Suppe ... sie stellen die Implementierung der Terraform-Beschreibung zur Verfügung und machen das eigentliche Doing. Ähnlich wie das Wissen eines Entwicklers häufig bei Programmiersprachen (i. a. recht einfach zu erlernen) im Wissen über die verwendeten Libraries/Frameworkds steckt, steckt das Wissen eines Terraform-Engineers in den Providern.

Viele Infrastrukturanbieter stellen Provider in Form von Modulen (werden bei `terraform init` aus dem Internet gezogen) für Terraform zur Verfügung:

* [AWS](https://www.terraform.io/docs/providers/aws/index.html)
* Google
* [Nomad](https://www.terraform.io/docs/providers/nomad/index.html)
* [Consul](https://www.terraform.io/docs/providers/consul/index.html)
* [Vault](https://www.terraform.io/docs/providers/vault/index.html)
* [Terraform Enterprise](https://www.terraform.io/docs/providers/tfe/index.html)
* ...

Beim `terraform init` werden diese Module i. a. dynamisch aus dem Internet gezogen ... es werden dabei immer die zur terraform-Version passenden Versionen verwendet.

> In diesem Beispiel werden die `latest` Versions gezogen, weil keine Versionen explizit angegeben wurden. Im Produktivbetrieb sollte man aber explizite Versionen verwenden, da man einen Rollout i. a. über verschiedene Stages zieht (DEV, TEST, LIVE) und nach einem erfolgreichen Abnahmetest auf der TEST-Stage nicht plötzlich eine ganz andere `latest`-Version (nicht abgenommen) beim Rollout auf LIVE nutzen möchte.

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

Zudem gibt es Provider (z. B. [MySQL](https://www.terraform.io/docs/providers/mysql/index.html), die Ihre Services mit denen anderer kombinieren (z. B. eine MySQL-Datenbank auf einem AWS-MySQL-Cluster anlegen).

### Custom-Provider

Man kann auch seinen eigenen Provider `terraform-provider-<NAME>_vX.Y.Z` contributen ([hier gehts zur Doku](https://www.terraform.io/docs/extend/writing-custom-providers.html)). Diese werden dann aber bei `terraform init` nicht automatisch aus dem Internet geladen - stattdessen muß man sie in `~/.terraform.d/plugins` ablegen.

---

## Provisioning von Servern

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Terraform ist geeignet, um die Infrastruktur bereitzustellen und verschiedene Infrastrukturkomponenten ineinander zu stöpseln. Software-Installationen und -Konfigurationen werden i. a. nicht mit Terraform abgebildet, sondern per

* [Packer](packer.md) (vorkonfigurierte Images)
* Konfiguration-Management-Tools wie Ansible, Puppet, Chef, ...
* Cloud-Init-, User-data-Skripte

---

## State

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der aufs Filesystem (Local - das ist der Default) oder remote (z. B. S3, Terraform Cloud) abgelegt werden kann. Dieser State beschreibt den aktuellen Zustand der Umgebung und ist die Basis, um aus der Ziel-Definition (Terraform-Dateien) die zu triggernden Aktionen bei einem `terraform apply` abzuleiten - es wird ein Diff zwischen dem neuen Ziel-Status und dem aktuellen Status gemacht. Per Default wird der State lokal abgelegt - arbeitet das Team verteilt oder will man Datenverlusten vorbeugen, sollte man den State zentral (z. B. Consul, S3) speichern. Dann muß man sich allerdings auch mit dem Thema [State Locking](https://www.terraform.io/docs/state/locking.html) beschäftigen.

> **ACHTUNG:** sind Secrets in dem State enthalten, dann enthält der State diese Werte im Klartext (!!!) => evtl. sollte man über eine Verschlüsselung des States (z. B. [mit S3-Backend](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html)) nachdenken. In keinem Fall sollte man den State in einem Version-Control-System halten.

Wenn der State verloren geht (wird gelöscht oder `terraform apply` wird von einem anderen Rechner ausgeführt, der keinen Zugriff auf den State hat), dann kann das zu großen Problemen führen, weil falsche Aktionen "berechnet" werden. Typisch sind dann Fehlermeldungen wie diese:

```
keys already exist under service/petclinic/; delete them before managing this prefix with Terraform
```

Das liegt daran, daß Terraform eine Resource anlegen will, die aber schon vorhanden ist. Über den State hätte Terraform gewußt, daß die Resource schon existiert und hätte die Aktion gar nicht erst ausführen wollen.

> ERGO: Terraform liest den aktuellen State nicht aus der deployten Landschaft (wäre recht aufwendig und fehlerträchtig), sondern aus der State-Datei. Das hat zudem zur Konsequenz, daß Änderungen, die nicht in der zentralen State-Datei erfolgt sind (z. B. manuelle Änderungen, Änderungen über andere Wege als Terraform) nicht berücksichtigt werden können. Diese Änderungen werden dann überschrieben!!!

Über `terraform show` kann man den aktuellen State auf der Console ausgeben. Das hilft bei der Fehlersuche ungemein.

### Locking

Alle Aktionen, die innerhalb eines `terraform apply` vollzogen werden, führen zu Updates an der Runtime-Umgebung und zu Updates an dem State. Man muß verhindern, daß mehr als ein `terraform apply` auf EINEM State-File parallel ausgeführt werden, denn ansonsten schleichen sich Inkonsistenten (im State-File oder in der Runtime-Umgebung) durch Concurrent Updates ein.

> Man stelle sich nur mal vor, daß ein `terraform destroy` gar nicht alles zerstört, weil ein Teil der Infrastruktur durch ein `terraform apply` auf einem anderen Server ausgeführt wurde. Infrastruktur läuft dann einfach weiter und wir zahlen dafür. Noch schlimmer sind natürlich Fehlkonfigurationen von kritischen Systemen, die dann zu Datenverlust, Downtime oder Unzuverlässigkeit führen.

 Man kann das beispielweise durch Ausführung der Updates auf einem zentralen (serialisierenden) Server (z. B. [Jenkins-Server](jenkins.md)) umsetzen oder man verwendet Locks. Für den Lock-Ansatz gibt es verschiedene Lösungen

* Terraform Pro
* Terraform Enterprise
* [Terragrunt](https://github.com/gruntwork-io/terragrunt)

### Isolation Best Practices

Packt man die Beschreibung der gesamten Infrastruktur (für alle Stages) in ein einziges Deployment-Modul, so ist das Risiko etwas kaputtzumachen (es wird dann auch nur ein einziges State-File verwendet) vergleichsweise hoch. Wenn man nur eine kleine Änderung an den Edge-Proxies vornehmen will, dann ist es vielleicht besser nur das oberste Layer der Infrastruktur auszurollen und nicht die tieferen Schichten. Das hat auch etwas mit der Änderungshäufigkeit der verschiedenen Layer zu tun ... je tiefer desto seltener.

Welches Level der Isolation verwendet wird, liegt in der Entscheidung des Nutzers - Terraform kann hier keine Vorgaben machen ... dennoch gibt es Best-Practices:

* Separierung von Stages (DEV, TEST, LIVE)
* Layering ... alles was man typischerweise gemeinsam deployed (weil es konsistent zueinander sein muß)

### Isolation über Workspaces

Über Workspaces lassen sich State-Files separieren, um so beispielsweise unterschiedliche Landschaften (Live-Environment, Test-Environment, DEV-Environment) voneinander trennen.

### Terraform Versionen

Man muß in jedem Fall sicherstellen, immer die zum State passende Terraform-Version zu verwenden ... man kann nicht einfach Version 0.13.1 verwenden, um beim nächsten mal 0.12.7 zu verwenden - das führt unweigerlich zu Problemen.

Das hört sich einfacher an als es in Wirklichkeit ist - keine Rocket-Science, aber es erfordert Disziplin, wenn man beispielsweise verschiedene Deploy-Stages hat, die absichtlich mit unterschiedichen Terraform-Versionen betrieben werden. Terraform wird nämich das State-File auf die höchste Version migrieren und damit ist der State für ältere Versionen evtl. nicht mehr zu gebrauchen. Am besten führt man die Terraform-Kommandos nicht von einem frei-konfigurierbaren Rechner aus, sondern von einem CI/CD-Server wie beispielsweise einem [Jenkins-Server](jenkins.md). Der stellt sicher, daß alle Schritte in Code gegossen sind und somit in der richtigen reihenfolge und mit dem richtigen `terraform`-Binary ausgeführt werden!!!

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

---

## Best Practices

### Loops

* [Gruntwork-Blog](https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9)

Häufig will man Listen verarbeiten und nicht für jedes Element eine eigene Variable anlegen. Also statt

```terraform
variable "user_name_1" {
    type = string
}
variable "user_name_2" {
    type = string
}
variable "user_name_3" {
    type = string
}
```

lieber

```terraform
variable "user_names" {
    type = list(string)
}
```

um dann den Wert einfach per `["pierre", "jonas", "robin"]` setzen zu können.

Im Terraform-Code muß man dann über diese Werte loopen können, um getrennte Ressourcen anlegen zu können ... in dem Fall User:

```terraform
resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
```
