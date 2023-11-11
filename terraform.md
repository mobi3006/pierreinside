
# Terraform

* [YouTube - eine tolle Einführung](https://www.youtube.com/watch?v=SLB_c_ayRMo)
* [YouTube - eine weitere Einführung](https://www.youtube.com/watch?v=7xngnjfIlK4)
  * [Dokumentation](https://courses.devopsdirective.com/terraform-beginner-to-pro/lessons/00-introduction/01-main)
* [Homepage by HashiCorp](https://www.terraform.io/)
* [Dokumentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

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

> mit `terraform plan -target module.eks` kann man den Scope des Plans bzw. des Apply einschränken (auf bestimmte Ressourcen), so dass die Ausführung deutlich schneller geht. Auf diese Weise kann man auch eine Layer-Struktur bilden, um den Scope eines Apply einzuschränken. Allerdings muss man dann die Abhängigkeiten zwischen den Layern selbst berücksichtigen und dabei können Fehler entstehen. Deshalb versuche ich das zu vermeiden.

Dabei werden alle `*.tf`-Dateien, `terraform.tfvars` und `foo.auto.tfvars` Dateien berücksichtigt, die sich im aktuellen Verzeichnis befinden (Convention-over-Configuration).

> Ich halte diese Freiräume in der Benennung der Datei für einen guten Schachzug. Es ermöglicht eine freie semantische Benennung, ohne den Nutzer zu gängeln und dadurch dann wiederum Verstöße überprüfen zu müssen. Dennoch gibt es Best-Practices (`main.tf`, `output.tf`, `variables.tf`, ...), an die man sich halten sollte. Es verbleiben dennoch viele Freiheiten.

Anschließend ist die Maschine auf AWS nutzbar.

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

### VSCode Integration

Visual Studio Code ist DER Editor meiner Wahl und natürlich editiert man heutzutage keinen Code ohne

* Auto-Vervollständigung
* Syntax-Highlightning
* Syntax-Check

### Code Formatierung

Ich hasse diese elenden Diskussionen zur Codeformatierung. Das will jeder anders haben und letztlich spielt es keine Rolle solange die Formatierung brauchbar ist. Einheitlichkeit ist mir lieber als persönliche Vorlieben. Deshalb verwende ich `terraform fmt` zur Formatierung ... keinen anderen Schnick-Schnack.

### Automatisierung

Am besten verwendet man [Git-Pre-Commit-Hooks](https://githooks.com/), um den Terraform-Code (am besten grundsätzlich alle Codes) zu validieren und formatieren.

> ACHTUNG: wenn nicht alle Entiwckler die gleichen Pre-Commit-Hooks verwenden, dann kann das zu großen Problemen führen, weil sich Formatierungsänderungen mit Refactorings mischen.

### Resource

Die Definition einer Resource

```json
resource "aws_instance" "application_server" {
  ami           = "ami-2757f631"
  instance_type = "${var.instance_type}"
}
```

referenziert den Ressource-Type (hier `aws_instance` - [Dokumentation](https://www.terraform.io/docs/providers/aws/r/instance.html)), der ressource-type-spezifische Properties akzeptiert/benötigt (z. B. `ami`). Der erste Teil des Ressource-Types (hier `aws`) ist referenziert i. a. den Provider (hier [aws](https://www.terraform.io/docs/providers/aws/index.html)). Zudem hat die Ressource einen Namen (hier `application_server`), über den die Properties per `resource.aws_instance.application_server.instance_type` referenziert werden können.

> mir gefällt dieser implizite Name bestehend aus Provider-Komponente und frei wählbarem Namen sehr gut, weil die Provider-Komponenten schon auch gleich den Kontext enthält, der dann im frei wählbaren Teil nicht wiederholt werden muss. Damit wird der Kontext immer erzwungen.

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

Manchmal muß man allerdings Abhängigkeiten explzit über `depends_on` definieren, wenn Terraform keine Chance zur Ableitung hat. Beispielsweise kann eine Applikation, die in einer anzulegenden EC2-Instanz läuft, einen S3-Bucket voraussetzen. Eine solche Abhängigkeit könnte eine explizite Abhängigkeitsdefinition erfordern. Die AWS-Aktionen werden i. a. auch asnychron ausgeführt ... es kann also sein, dass eine Aktion noch nicht fertig ist bevor eine darauf aufbauende Aktion startet. Das führt dann manchmal zu merkwürdigen Fehlermeldungen.

> Bisher hatte ich das Gefühl, dass das in manchen Fällen ein Bug im Terraform-Provider ist, der vielleicht einfach ein bisschen länger warten müsste, bevor er mit einer Fehlermeldung abbricht.

### Locals

Bei Locals handelt es sich um Konstanten, die per

```
locals {
  my_const = "pierre"
}
```

deklariert und über

```
param = local.my_const
```

genutzt werden.

### Data Sources - für komplexe Datenstrukturen 

Über `data` lassen sich komplexe Datenstrukturen bereitstellen.

Hier ein Beispiel wie man ein aus einem Template **gerendertes** File referenziert (beachte im folgenden `...nomad-job-template.rendered`):

```json
data "template_file" "my-service-nomad-job-template" {
  template = "${file("${path.module}/nomad.tmpl.hcl")}"
  vars {
    mem = "512M"
  }
}

resource "nomad_job" "my-service" {
  jobspec = "${data.template_file.nomad-job-template.rendered}"
}
```

Hier sieht man auch sehr schön die übergreifende Adressierung (von `nomad_job.my-service` nach `data.template_file.my-service-nomad-job-template`) via `data.template_file.my-service-nomad-job-template`.

> zu beachten ist, dass man dem Namen ein `data.` voranstellen muss - das ist bei `resource` nicht der Fall (weil das der Standard-Fall ist ... da wollte man sich die Redundanz sparen)

### Variablen

Variablen können folgende Datentypen haben

* Primitive Typen
  * String
  * Number
  * Boolean
* Komplexe Typen
  * List
  * Set
  * Map
  * Object
  * Tuple

Eine Variable kann mit dem Attribute `sensitive = true` gekennzeichnet werden, um Secrets zu schützen (beim Output werden sie maskiert).

Die Belegung der Variablen erfolgt

* über Default-Values
* `terraform.tfvars`-Datei ... eine Datei mit diesem Namen wird automatisch angewendet
* `foobar.tfvars`-Datei ... diese Datei muss EXPLIZIT per `terraform plan -var-file foobar.tfvars` angegeben werden
* Umgebungsvariable `TF_VAR_variable1=foobar`

### Data Sources - für Infrastruktur-Informationen

Data Sources stellen Terraform aktuelle statische und dynamische Informationen aus der Umgebung bereit. Diese Bereitstellung erfolgt über read-only Queries, die die Data Source zur Ausführungszeit gegen die APIs der Laufzeitumgebung macht. Dies ist **KOMPLETT** entkoppelt vom Terraform State.

Data Sources haben das Ziel, nicht terraform-managed Ressources in Terraform zu integrieren.

Ist eine Ressource terraform-managed und man hat Zugriff auf den State, dann sollte kann man natürlich auch eine Abfrage des Remote-Terraform-States in Betracht ziehen

### Module

* [terraform docu](https://learn.hashicorp.com/tutorials/terraform/module?in=terraform/modules)
* [terraform docu - lokale Module](https://learn.hashicorp.com/tutorials/terraform/module-create?in=terraform/modules)

Über Module wird ein Template-Mechnismus bereitgestellt, über den sich wiederverwendbare Komponenten abbilden lassen. Aus atomaren `resourcen` entstehen komplexe Komponenten, die über Parameter an den jeweiligen Use-Case angepasst werden. 

> Letztlich ist ein Modul nicht mehr als eine impliziete Kopieranleitung, die man explizit auch mit Codegenerierung erreichen könnte

Die Endstufe eines Moduls sieht man bei [mineiros-io](https://github.com/mineiros-io/terraform-github-repository/blob/main/examples/public-repository/main.tf), die eine DSL in Terraform-Code um ein Modul bereitstellen. So kann Terraform-Code aussehen.
Diese Art von Wrapper-Modul ist ganz typische, um komplexere Strukturen wiederzuverwenden ... so ist es [auch bei AWS (beispielsweise beim Modul "terraform-aws-modules/security-group/aws")](https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/main.tf).

 Jede Sammlung von `*.tf` Dateien in einem Verzeichnis ist ein Modul ... man verwendet Module dementsprechend IMMER automatisch. Deshalb referenziert man in `source = "/home/pfh/my-terraform-module"` auch ein Verzeichnis und nicht eine einzelne Datei.

So sieht die Wiederverwendung eines Moduls aus:

```json
module "use-my-terraform-module" {
  source = "./my-terraform-module"
  // verschiedene Quellen sind möglich
  //    source = "/home/pfh/my-terraform-module"
  //    source = "https://mvnrepository.com/artifact/.../config-2.3.5.zip"
  //    source = "git://"
  
  variable1 = "value1"
}
```

In diesem Fall werden alle Platzhalter `variable1` im Terraform Ordner `./my-terraform-module` mit `value1` ersetzt. Bei `source` handelt es sich um ein Meta-Argument, das das zu verwendende Modul referenziert.

Die Verwendung eines (lokalen) relativen Moduls (`./my-terraform-module`) ermöglicht die Modularisierung in einem einzelnen Git-Repository (fungiert dann als sog. Root-Module), ohne daß der Code verstreut ist. Auf diese Weise lassen sich komplette Systeme kompakt beschreiben, ohne dabei Redundanzen einbauen zu müssen.

```
.
├── README.md
├── main.tf
├── variables.tf
├── my-terraform-module
├──── main.tf
├──── variables.tf
├── my-seconds-terraform-module
├──── main.tf
├──── variables.tf
```

Praktisch ist, daß man bei `source` auch eine Sammlung von Terraform Scripten in Form einer `zip`-Datei angeben kann (um sie beispielsweise über einen Artifakt-Repository beizusteuern). In dem Fall wird die Zip-Datei bei `terraform apply` entpackt und die Platzhalter werden ersetzt. Auf diese Weise kann man eine Sammlung von Konfigurationsdateien in einem `zip`-File bereitstellen und dann mit Werten belegen.

> vor einer solchen Aufgabe steht man häufig, wenn man Software stage-abhängig konfigurieren muß

Module können selbst wieder Variablen (`variables.tf`) und Output (`output.tf`) definieren. Dieser Mechanismus definiert den Contract eines Callers zum Module und enthält gleichzeitig die Dokumentation dieser Schnittstelle durch `description`. Auch alle anderen typischen Konzepte (`main.tf`, ...) stehen einem Module zur Verfügung ... genauso wie dem Root-Module (das ohne weitere Module verwendet wird). So einfach und doch so mächtig.

Und natürlich können Modules wieder weitere Module verwenden.

> **ALLERDINGS:** einen `provider` Block sollte ein - zur Wiederverwendung entworfenes Modul - nicht haben - es erbt diesen vom Caller, denn hier erfolgt häufig die Konfiguration des Nutzungskontextes und den kennt ein wiederverwendbares Modul natürlicherweise nicht. Allerdings muß das Modul einen `required_providers` Block enthalten, um die Version des Providers zu spezifizieren. Es macht durchaus Sinn, daß jedes Modul die Version eines Providers eigenständig definiert, denn es enthält "Code", der sich von der Version des Providers abhängig ist (Contract).

Verwendet man externe Module (von der Hashicorp-Cloud, git-repository oder aus einem zip-Artefakt), dann müssen die durch ein `terraform init` (oder `terraform get`) zunächst runtergeladen und lokal (in `.terraform`) abgespeichert werden.

Auf diese Weise lassen sich auch Layer (z. B. Backend, Middleware, Frontend) implementieren. Benötigt man Daten aus einem Modul (= Layer) in einem anderen, dann muß man in Daten explizit übergeben:

```
├── main.tf
├── middleware
├──── main.tf
├──── variables.tf
├──── output.tf
├── frontend
├──── main.tf
├──── variables.tf
├──── output.tf
```

Die `./main.tf` agiert als Controller, um die Daten aus `./middleware/output.tf` and `./frontend/main.tf` zu übergeben - ein direkter Zugriff von `./frontend/main.tf` auf `./middleware/output.tf` ist nicht möglich. Außerdem ist es nicht erwünscht, da `frontend` und `middleware` nichts voneinander wissen sollten (Dependency Injection).

Die in `output.tf` definierten Ausgaben stehen anderen Modulen und - natürlich dem menschlichen Benutzer - als Input Werte zur Verfügung. Am Ende werden sie auch auf der Konsole ausgegeben, so dass ich als User z. B. die public IP Adresse einer EC2 Instanz ausgegeben bekommt, um dann ein ssh connect darauf machen zu können. 

### Functions

* [Dokumentation](https://www.terraform.io/language/functions)

Terraform bietet kleine Helferfunktionen, denn auch eine deklarative Sprache kommt nicht ohne aus. Die werden u. a. benötigt, wenn Modul- oder Resource-Parameter einen bestimmten Typ (z. B. Set) erwarten und man aber eine List hat.

```
locals {
  subnet_ids = toset([
    "subnet-id-275637812",
    "subnet-id-8273678216"
  ])
}
```

### Refactorings

Nach einem refactoring sollte man immer ein `terraform get` machen, da beispielsweise ein Umbenennen eines lokalen Moduls im `.terraform/modules/modules.json` repräsentiert werden muss. Ansonsten scheitern `terraform plan` und/oder `terraform apply`.

Man sollte sich angewöhnen, vor dem `terraform apply` ein Backup vom State zu machen. Am besten man legt den State auf S3 ab - das Einschalten der Versionierung NICHT VERGESSEN (ich glaube das ist nicht die Standard-Einstellung!!!).

### Monolithen-Module refactorn

* [howto](https://learn.hashicorp.com/tutorials/terraform/organize-configuration?in=terraform/modules)

---

## HCL - HashiCorp Control Language

Es lonht sich, hier mal einen Blick reinzuwerfen nachdem man die ersten Schritte gegangen ist - dann versteht man den Code tatsächlich besser:

* [HCL language/syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration)

Das wichtigste Konstrukt ist der BLOCK:

```
resource "aws_instance" "webserver" {
  ami = "abc123"

  network_interface {
    # ...
  }
}
```

In diesem Beispiel ist

* `resource` ein Block mit 2 Labels:
  * `aws_instance`: definiert die Ressource des Providers (Provider `aws` + Komponente `instance`)
  * `example`: ein frei definierbarer Name
* `network_interface` ein Block mit 0 Labels

Neben den statischen Blocks gibt es auch [dynamische Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks), um dynamisch - einer for-Schleife ähnlich - Blocks zu erzeugen.

> imperative Konstrukte wie Schleifen wirken in deklarative "Sprachen" wie HCL immer ein bisschen seltsam - wie ein Bruch im Konzept. 

Es gibt auch Meta-Argumente wie

* [`depends_on`](https://youtu.be/7xngnjfIlK4?t=4428)
* [`count`](https://youtu.be/7xngnjfIlK4?t=4546)
  * kann man beispielsweise auch mit `${count.index}`
  
    ```
    resource "aws_instance" "server" {
      count = 4
      ami = "ami-0ab1a82de7ca5889c"
      instance_type = "t2.micro"
      tags = {
        Name = "Server ${count.index}"
      }
    ```

* [`for_each`](https://youtu.be/7xngnjfIlK4?t=4556)

    ```
    resource "aws_instance" "server" {
      for_each = local.subnet_ids

      ami           = "ami-0ab1a82de7ca5889c"
      instance_type = "t2.micro"
      subnet_id     = each.key
    ```

* [`lifecycle`](https://youtu.be/7xngnjfIlK4?t=4602)

    ```
    resource "aws_instance" "server" {
      ami           = "ami-0ab1a82de7ca5889c"
      instance_type = "t2.micro"

      lifecycle {
        create_before_destroy = true
        ignore_changes = [
          tags
        ]
      }
    ```

Anstatt HCL kann man auch JSON verwenden (dann müssen die Dateien allerdings mit `.tf.json` anstatt `.tf` enden):

```
{
  "resource": {
    "aws_instance": {
      "example": {
        "instance_type": "t2.micro",
        "ami": "ami-abc123"
      }
    }
  }
}
```

 ... ist aber deutlich schwieriger zu lesen als die HCL Variante:

```
variable "example" {
  default = "hello"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-abc123"
}
```

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
* GitHub
* ...

Zur Einbindung eines Providers fügt man folgende Zeilen seinem Terraform Code hinzu:

```tf
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
```

Anschließend müssen die meisten Provider noch konfiguriert werden:

```tf
provider "github" {
    organization = var.github_organization
    token = var.github_token
}
```

> Secrets übergebe ich während des Testens ungern als `-var token=my-secret` (weil in der Command History sichtbar) - stattdessen lasse ich mich interaktiv danach fragen.

Beim `terraform init` werden

* das Provider-Binary (passend zur Rechner-Architektur) runtergeladen (nach `.terraform/providers`)
* alle verwendeten Terraform-Module in der passenden Version runtergeladen (nach `.terraform/modules`) - hier hat man also auch Zugrif auf den Code der Module in Form von `foo.tf` Dateien

> In diesem Beispiel werden die `latest` Versions gezogen, weil keine Versionen explizit angegeben wurden. Im Produktivbetrieb sollte man aber explizite Versionen verwenden, da man einen Rollout i. a. über verschiedene Stages zieht (DEV, TEST, LIVE) und nach einem erfolgreichen Abnahmetest auf der TEST-Stage nicht plötzlich eine ganz andere `latest`-Version (nicht abgenommen) beim Rollout auf LIVE nutzen möchte.

```log
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

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der als `json`-Datei abgespeichert wird. Per Default liegt er lokal auf dem Filesystem - besser ist es aber, ihn Remote (z. B. S3, Terraform Cloud) abzulegen.

> **ACHTUNG:** der State enthält Secrets in Plaintext - sollte also am besten verschlüsselt werden. Hier eignet sich S3 besonders gut, denn hier kann man am Bucket die Verschlüsselung aktiviert und kann das so schon mal nicht vergessen.

Dieser State beschreibt den aktuellen Zustand der unter Terraform stehenden Umgebung und ist die Basis, um aus der Ziel-Definition (Terraform-Dateien) die zu triggernden Aktionen bei einem `terraform apply` abzuleiten - es wird ein Diff zwischen dem neuen Ziel-Status und dem aktuellen Status gemacht. Hinzu kommt - wenn das möglich ist - noch der tatsächliche Zustand auf dem Zielsystem ... das ist aber nur bei relativ einfachen Abweichungen möglich ... hilft aber sehr, wenn das Zielsystem doch mal manuell verändert hat (zum Testen manchmal ganz praktisch). Die manuellen Änderungen werden dann beim nächsten `terraform apply` verworfen, sofern sie von terraform gemanaged werden.

Per Default wird der State lokal abgelegt (= Local Backend) - arbeitet das Team verteilt oder will man Datenverlusten vorbeugen, sollte man den State zentral (z. B. Consul, S3, Terraform Cloud) speichern (= Remote Backend). Dann muß man sich allerdings auch mit dem Thema [State Locking](https://www.terraform.io/docs/state/locking.html) beschäftigen.

Per Default wird der State in einer Datei im aktuellen Verzeichnis gespeichert ... was man explizit auch so konfigurieren kann:

```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}
```

> **ACHTUNG:** sind Secrets in dem State enthalten, dann enthält der State diese Werte im Klartext (!!!) => evtl. sollte man über eine Verschlüsselung des States (z. B. [mit S3-Backend](https://docs.aws.amazon.com/AmazonS3/latest/dev/UsingServerSideEncryption.html)) nachdenken. In keinem Fall sollte man den State in einem Version-Control-System halten - am besten gleich `*.tfstate*` in die `.gitignore` aufnehmen.

Wenn der State verloren geht (wird gelöscht oder `terraform apply` wird von einem anderen Rechner ausgeführt, der keinen Zugriff auf den State hat), dann kann das zu großen Problemen führen, weil falsche Aktionen "berechnet" werden. Typisch sind dann Fehlermeldungen wie diese:

```
keys already exist under service/petclinic/; delete them before managing this prefix with Terraform
```

Das liegt daran, daß Terraform eine Resource anlegen will, die aber schon vorhanden ist. Über den State hätte Terraform gewußt, daß die Resource schon existiert und hätte die Aktion gar nicht erst ausführen wollen.

> ERGO: Terraform liest den aktuellen State nicht aus der deployten Landschaft (wäre recht aufwendig, fehlerträchtig - ausserdem könnte Terraform dann manuell erzeugte Infrastruktur nicht von Terraform-erzeugter Infrastruktur unterscheiden), sondern aus der State-Datei. Das hat zudem zur Konsequenz, daß Änderungen, die nicht in der zentralen State-Datei erfolgt sind (z. B. manuelle Änderungen, Änderungen über andere Wege als Terraform) nicht berücksichtigt werden können. Diese Änderungen werden dann überschrieben!!!

Über `terraform show` kann man den aktuellen State auf der Console ausgeben. Das hilft bei der Fehlersuche ungemein.

Manche Probleme kann Terraform nicht beim `terraform plan` finden, da sie von der tatsächlichen Ausführung während des `terraform apply` abhängig sind (z. B. aufeinander aufbauende Ressourcen oder wenn diese mit dem aktuellen Setup in Konflikt stehen). In diesen Fällen bricht `terraform apply` an einer beliebigen Stelle ab, hat dann die Infrastruktur und den Terraform State aber schon teilweise angepaßt (der Zustand der Infrastruktur ist inkonsistent und damit potentiell fehlerhaft - man sollte das Problem zügig beheben). Aufgrund der typischen Idempotenz von Terraform Code beseitigt man i. d. R. nur das Problem und führt dann `terraform apply` erneut aus. Letztlich beschreibt der Terraform Code das Endergebnis und Terraform sorgt für die Umsetzung.

### Zentrale Speicherung auf S3

Mit einer Konfiguration wie dieser

```hcl
terraform {
  backend "s3" {
    bucket = "my-bucket"
    key = "terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
}
```

kann man den State verschlüsselt in S3 ablegen ... für die Arbeit im Team ist es unabdingbar, den State an zentraler Stelle abzulegen, damit die anderen User auch Zugriff haben (und natürlich kann es immer mal passieren, dass die Festplatte schlapp macht).

Hatte man vorher den State lokal, dann "migriert" man ihn nach obiger Konfiguration per `terraform init -migrate-state` in den Bucket übertragen.

> letztlich ist das nur ein Copy-Kommando wie `aws s3 cp terraform.tfstate s3://my-bucket/terraform.tfstate`

Entkoppelte Terraform-Bundles (mit eigenem State) können den State eines anderen Bundles (remote) abfragen und sich so notwendige Informationen beschaffen. Auf diese Weise entsteht eine lose Kopplung ... mit allen Vor- und Nachteilen.

### Import

* [import Kommando](https://www.terraform.io/cli/import)

In Migrationsprojekten (hin zu Terraform) oder wenn der Terraform-Provider nun eine weitere Ressource unterstützt kann es erforderlich sein, eine bisher nicht über Terraform gemanagte Ressource per `terraform import` in den State zu übernehmen, um sie nicht löschen und neu anlegen zu müssen.

### Import am Beispiel GitHub

* [Beispiel 1](https://wahlnetwork.com/2020/09/01/using-terraform-to-manage-git-repositories/)
* [Beispiel 2](https://nakamasato.medium.com/how-to-start-managing-github-repository-and-branch-protection-by-terraform-a7a1ae24d8b)

Zunächst legt man die Resource `module.repositories.github_repository.football` im Terraform-Code an . Anschließend kann man das Repository `football` (https://github.com/football) per

```bash
terraform import module.repositories.github_repository.football football
```

importieren. Damit hat man das Repo und seine Metadaten unter Terraform-Control ... nicht aber die Branches, die per `terraform import github_branch.football terraform:feature-branch:master` importiert werden müssen. I. a. will man nur einzelne Branches unter Terraform-Control stellen, um dort die Permissions (über Teams), Branch-Protection für eine handvoll langlebiger Branches (`master`, `development`, ...), ... zu pflegen. Feature/Bugfix-Branches werden von den Entwicklern selbst maintained (angelegt/gelöscht).

### Locking

Alle Aktionen, die innerhalb eines `terraform apply` vollzogen werden, führen zu Updates an der Runtime-Umgebung und zu Updates an dem State. Man muß verhindern, daß mehr als ein `terraform apply` auf EINEM State-File parallel ausgeführt werden, denn ansonsten schleichen sich Inkonsistenten (im State-File oder in der Runtime-Umgebung) durch Concurrent Updates ein.

> Man stelle sich nur mal vor, daß ein `terraform destroy` gar nicht alles zerstört, weil ein Teil der Infrastruktur durch ein `terraform apply` auf einem anderen Server ausgeführt wurde. Infrastruktur läuft dann einfach weiter und wir zahlen dafür. Noch schlimmer sind natürlich Fehlkonfigurationen von kritischen Systemen, die dann zu Datenverlust, Downtime oder Unzuverlässigkeit führen.

 Man kann das beispielweise durch Ausführung der Updates auf einem zentralen (serialisierenden) Server (z. B. [Jenkins-Server](jenkins.md)) umsetzen. Sicherer/Besser ist die Verwendung von pessimistischem Locking, d. h. . Für den Lock-Ansatz gibt es verschiedene Lösungen

* Terraform Pro
* Terraform Enterprise
* [Terragrunt](https://github.com/gruntwork-io/terragrunt)

Verwendet man AWS, dann kann pessimistisches Locking über DynamoDB implementieren:

```
terraform {
  backend "s3" {
    bucket         = "foobar.tfstate"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "foobar_terraform.state-lock"
  }
}
```

So stellt man sicher, dass keine zwei Updates auf dem State parallel laufen.

### Isolation Best Practices

Packt man die Beschreibung der gesamten Infrastruktur (für alle Stages) in ein einziges Deployment-Modul, so ist das Risiko etwas kaputtzumachen (es wird dann auch nur ein einziges State-File verwendet) vergleichsweise hoch und der Plan dauert auch länger. Wenn man nur eine kleine Änderung an den Edge-Proxies vornehmen will, dann ist es vielleicht besser nur das oberste Layer der Infrastruktur auszurollen und nicht die tieferen Schichten. Das hat auch etwas mit der Änderungshäufigkeit der verschiedenen Layer zu tun ... je tiefer desto seltener.

Welches Level der Isolation verwendet wird, liegt in der Entscheidung des Nutzers - Terraform kann hier keine Vorgaben machen ... dennoch gibt es Best-Practices:

* Separierung von Stages (DEV, TEST, LIVE)
* Layering ... alles was man typischerweise gemeinsam deployed (weil es konsistent zueinander sein muß)

Diskussion über Monoilith vs. Layers:

* [www.padok.fr](https://www.padok.fr/en/blog/terraform-iac-multi-layering)
* [Happy Terraforming! Real-world experience and proven best practices](https://www.hashicorp.com/resources/terraforming-real-world-experience-best-practices)

### Isolation über Workspaces

Über Workspaces lassen sich State-Files separieren, um so beispielsweise unterschiedliche Landschaften (Live-Environment, Test-Environment, DEV-Environment) voneinander trennen.

### Remote-State lesen

Hat man ein Layering in irgendeiner Form implementiert, so benötigen die übergeordneten Layer Zugriff auf die Definition (z. B. VPC-ID) der untergeordneten Layer. Hier verwendet man in Terraform folgenden `data`-Ansatz (siehe oben):

```
data "terraform_remote_state" "our_vpc" {
  backend = "s3"
  config = {
    bucket = "my-terraform-state"
    key    = "abc.tfstate"
    region = "eu-central-1"
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.role_name}"
 }
}
```

Dann kann man die VPC-id per `vpc_id = data.terraform_remote_state.our_vpc.outputs.aws_vpc.main_vpc` in den Code des übergeordneten Layers einbauen.

### Terraform Versionen

In den 0.x Tagen von Terraform war es unabdingbar, dass der State zur Terraform Version passte. Das hat - wenn terraform plan/apply nicht durch einen automatisierten Workflow, sondern auf Entwickler Maschinen ausgeführt wurde - unweigerlich zu Problemen geführt.

Hier hat es sich als hilfreich erwiesen eine Datei `.terraform-version` im Root Verzeichnis zu hinterlegen, um das explizit zu dockumentieren. Tools wie `tfenv` (siehe unten) sorgen dann dafür, dass die richtige Terraform Version notfalls installiert wird und verwendet wird.

> Mit der Version 1.x ist es nicht mehr unbedingt erforderlich genau die gleiche Version zu verwenden.

Das hört sich einfacher an als es in Wirklichkeit ist - keine Rocket-Science, aber es erfordert Disziplin, wenn man beispielsweise verschiedene Deploy-Stages hat, die absichtlich mit unterschiedichen Terraform-Versionen betrieben werden. Terraform wird nämich das State-File auf die höchste Version migrieren und damit ist der State für ältere Versionen evtl. nicht mehr zu gebrauchen. Am besten führt man die Terraform-Kommandos nicht von einem frei-konfigurierbaren Rechner aus (also nicht von einem Entwickler-Laptop), sondern von einem CI/CD-Server wie beispielsweise einem [Jenkins-Server](jenkins.md). Dadurch wird dann auch sichergestellt, dass der Rollout-Prozess immer mit der gleichen Qualität ausgeführt wird.

### tfenv

Mit [tfenv](https://github.com/tfutils/tfenv) hat man ein Tool, das die `.terraform-version` ausliest und bei Bedarf die Terraform Version switched oder sogar die passende Terraform Version installiert.

Das vereinfacht die Nutzung ungemein.

> Grundsätzlich bin ich aber ein Freund der Automatisierung und würde am liebsten vollständig auf die lokale Ausführung verzichten.

---

## Terraform CLI

* `terraform show`
  * detailierte Anzeige des States ... wenn es sich um einen Remote State handelt, dann wird der automatisch aufgelöst
* `terraform show tfstate.backup`
  * detailierte Anzeige des States, der im File `tfstate.backup` abgebildet ist
* `terraform state list`
  * welche Resourcen sind unter Terraform-Control
* `terraform import`
  * Importieren eines Resource in den State ... hiermit bringt man eine vorher manuell gemanagte Resource unter Terraform-Control
* `terraform validate`
  * syntaktische Überprüfung des Terraform Codes
* `terraform fmt`
  * Formatierung des Terraform Codes gemäß [dieses Styles](https://developer.hashicorp.com/terraform/language/syntax/style)

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

### Use Modules

"[...] to limit the scope of potential changes" ([Terraform Doku](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules))

### No Nested Modules

"We started nesting modules inside other smaller modules. Updating code or resolving conflicts in the matryoshka doll structure became a nightmare." [Regis Wilson](https://medium.com/driven-by-code/the-terrors-and-joys-of-terraform-88bbd1aa4359)

### terraform state mv

* [Dokumentation](https://www.terraform.io/cli/commands/state/mv)

Wenn man interne Refactorings an Terraform-Code vornimmt, dann sollte man verhindern, daß Ressourcen gelöscht und neu angelegt werden ... nur weil man den Code restrukturiert hat.

> "When you create modules from already existing infrastructure, your resource's IDs will change. Because of this, you must let Terraform know that you intend to move resources rather than replace them, or Terraform will destroy and recreate your resources with the new ID. In previous versions of Terraform, you would use the terraform state mv command to individually move your resources to their new module address so Terraform can correctly track the infrastructure." ([Terraform Doku](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules))

Diese Refactoring-Hints kann man auch [in Code packen](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules#move-your-resources-with-the-moved-configuration-block):

```hcl
moved {
  from = aws_instance.example
  to = module.ec2_instance.aws_instance.example
}
```

Hierfür sollte es aber eigentlich Support von einer IDE geben!!! ... da Änderungen am State im Desaster enden können.

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

---

## Kritische Betrachtung

[Dieser Artikel](https://medium.com/driven-by-code/the-terrors-and-joys-of-terraform-88bbd1aa4359) drückt meine Schmerzen/Erfahrungen ganz gut aus (die nachfolgenden Zitate sind alle aus diesem Artikel):

> "Suddenly, Terraform appeared out of the chaos and stood on a hill in the sunlight, posing dramatically with its curly hair blowing gently in the wind. Our hero comes to save the day! The promise of Terraform was too much to resist: We could abstract our infrastructure into text files and check them into our version control system (VCS). We could keep track of which infrastructure pieces were created and when (the so-called state file), we could automatically (in most cases) keep a dependency-graph of all the interconnected “fiddly bits” and glue together in one place, and we could run so-called plans to verify drift or to test changes to infrastructure before applying them. We thought we were entering a new golden age by choosing Terraform as the base on which to deploy our automation platform."

ABER in Real-Life (in komplexen Projekten):

> "Changing the order of dependencies, updating resource names, refactoring code into modules: all of these caused massive headaches and slowed down our building and deployments. This made manual changes to our infrastructure increasingly tempting, which made updating the code harder to maintain, and so on. This vicious cycle was difficult to get out of."

Terraform wirkt so einfach und gnadenlos besser als alles was wir vorher benutzten. Doch der Teufel steckt im Detail und man sollte die Best-Practices schon beherzigen und das Tool auch wirklich gut kennen bevor man sich davon abhängig macht. Es besteht ein großes Risiko, daß ein Fehler im eigenen "Coding" oder in den terraform-Providern zu einem Desaster führt. Wenn man Terraform als Black-Box benutzt und nur die Spitze des Eisbergs kennt, dann ist das zu blauäugig:

> "We should not pray for easier tooling - We should pray to be stronger engineers"

Außerdem ist auch nicht jede Komponente für eine Verwaltung mit Terraform geeignet:

> "This is a difficult statement for us to make, and it was a tough and bitter pill to swallow. In our zeal to “AUTOMATE ALL THE THINGS,” we forgot to stop and think whether that was practical or even useful. One general example is the Relational Database Service (RDS). While it is true that you can build RDS instances from a terraform module, the question is whether you should."

Die Einfachheit ist verlockend ... einfach mal das AMI einer EC2 Instanz ändern bedeutet nur eine String im Textfile auszutauschen. Die Konsequenz ist allerdings, daß die Instanz gelöscht und from Scratch neu angelegt wird. Tut man das über die AWS Admin Console, dann werden uns die Konsequenzen während dieser 2 Minuten Aktion vielleicht noch klar und vielleicht werden wir sogar gewarnt. In Terraform muss man den Plan schon intensiv studieren, um die Konsequenzen eines schnellen `terraform apply` abschätzen zu können.

> "The overarching theme of this section is that Terraform is really good at managing resources that are generic, repeatable, and resilient to downtime. Resources in your cloud that are unique unicorns, long-lived stable infrastructure that can’t tolerate downtime, or resources that are created once and never updated again are a bad fit."

### Refactorings

Nach einem refactoring sollte man immer ein `terraform get` machen, da beispielsweise ein Umbenennen eines lokalen Moduls im `.terraform/modules/modules.json` repräsentiert werden muss. Ansonsten scheitern `terraform plan` und/oder `terraform apply`.

Mit dem GitHub-Provider hatte ich lokale Modules verwendet, um das Usermanagement in einer GitHub-Organization abzubilden. Eine Umbenennung (ein internes Refactoring) des Moduls `organization` nach `usermanagement` führte allerdings dazu, daß die User gelöscht und neu angelegt wurden. Leider ist diese Aktion nicht Seiteneffektfrei:

* die wurden nicht einfach neu angelegt, sondern erhielten neue Einladungen, die sie erst explizit bestätigen mußten, um wieder Teil der Organisation zu werden
* mein Skript lief nicht fehlerfrei durch (ich hatte nach dem Refactoring `terraform get` vergessen) und so was das Löschen ausgeführt, aber das Anlegen nicht - im worst-case hätte das zu Downtimes für einzelne User geführt

Wer weiß welche Seiteneffekte ich nicht bemerkt habe ...

Refactorings sind in Infrastruktur häufig nicht Seiteneffektfrei wie [in diesem humorvollen Terraform-Artikel beschrieben](https://medium.com/driven-by-code/the-terrors-and-joys-of-terraform-88bbd1aa4359).

