# Terraform

* [YouTube - eine tolle Einführung](https://www.youtube.com/watch?v=SLB_c_ayRMo)
* [YouTube - eine weitere Einführung](https://www.youtube.com/watch?v=7xngnjfIlK4)
  * [Dokumentation](https://courses.devopsdirective.com/terraform-beginner-to-pro/lessons/00-introduction/01-main)
* [Homepage by HashiCorp](https://www.terraform.io/)
* [Dokumentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

Terraform ist ein Infrastructure-as-Code (IaC) Tool, um auf [verschiedenen Infrastructure-as-a-Service Platformen](https://www.terraform.io/docs/providers/index.html) (AWS, Google Cloud Platform, Microsoft Azure, VSphere, ... On-Premise) komplexe Infrastruktur- und Applikations-Landschaften reproduzierbar aus wiederverwendbaren Komponenten aufzubauen. Wer schon mal versucht hat in AWS eine Infrastruktur aus EC2, Security-Groups, Route Tables, Router, Internet Gateway, ... zusammenzuklicken und dann auch zu maintainen (Komponenten hinzufügen/wegnehmen/umkonfigurieren ... ohne DOWNTIME), der wird dazu erstens schnell keine Lust mehr haben und zweitens in schlimme Qualitätsprobleme laufen. Ohne IaC-Tools wie Terraform geht das einfach nicht.

Ganz abgesehen von diesen Aspekten, muß man Arbeiten an kritischen Systemen immer mit dem 4-Augen-Prinzip machen. Mit IaC ist man dazu gezwingen, Änderungen am Code durchzuführen und kann dann - unter Einhaltung eines GitOps-Workflows - mit Reviews der Pull-Requests arbeiten.

> "terraform is used for the environment/server provisioning part [...], but not so often for app deployment." ([StackOverflow](https://stackoverflow.com/questions/37297355/how-to-deploy-and-redeploy-applications-with-terraform))

 Terraform ist KEIN Konfigurationsmanagement-Tool, es baut die Infrastruktur auf (z. B. virtuelle Maschinen, Datenbank-Server-Instanz, Datenbank-User) und delegiert die Konfiguration an entsprechende Konfiguration-Management Tools ([Ansible](ansible.md), Chef, Puppet, ...).

> BTW: Terraform verwendet sehr ähnliche Konzepte wie bei [Nomad](nomad.md) ... auch ein HashiCorp Produkt.

Terraform ist zwar Cloud-Provider unabhängig, dennoch würde ich nicht sagen, dass es einen Vendor-Lockin verhindert. Man kann zwar eine vergleichbare Lösung für eine andere Cloud-Platformen bauen, aber das bedeutet in jedem Fall Development-Aufwand. Für Multi-Cloud-Ansätze ist es ideal.

---

# Konzepte

Man beschreibt den Zielzustand in einer deklarativer Form. Terraform berechnet aus dem aktuellen Zustand (abgebildet in einer `terraform.tfstate` JSON Datei) einen Execution Plan, d. h. die Aktionen, die notwendig sind, um vom aktuellen Zustand zum neuen Zielzustand zu gelangen. Nachdem dem Approval des Plans erfolgt die Anwendung (Terraform Apply Phase), um den neuen Zielzustand zu erreichen. Im besten Fall bildet der neue Zielzustand den neuen State.

> Man nennt den Terraform Code auch eher Terraform Configuration, da es sich um eine deklarative Beschriebung des Zielzustands handelt. Die Implementierung liegt in den Terraform Provider und bereitgestellten Modulen.

Der Terraform State enthält das Mapping der Deklaration zu den tatsächlichen Ressourcen (z. B. von einer Ressourcen im Statefile hin zum S3-Bucket in AWS). Auf manuelle Änderungen sollte man grundsätzlich verzichten. Ändert man eine Ressource dennoch manuell, so wird das nächste Terraform Apply diese manuelle Änderung wieder rückgängig machen.

> In den meisten Fällen kann man mit manuellen Änderungen Terraform nicht außer Tritt bringen. Im Terraform Plan wird man dann aber sehen, dass Terraform die manuelle Änderung eleminiert. Dieses tolerante Vorgehen hat den Vorteil, dass man auch mal eben eine Ressource manuell ändern kann, um etwas zu testen. **DENNOCH** sollte das nur in Ausnahmefällen geschehen ... alles **MUSS** in Code abgebildet werden ("Once you start using Terraform, you should only use Terraform" - Buch: *Terraform - Up and Running: Writing Infrastructure as Code*).

Terraform bzw. die Terraform-Provider können sehr zuverlässig Abhängigkeiten zwischen den Ressourcen selbständig erkennen und Optimierungen durch Parallelisierung vornehmen. In manchen Fällen muss oder kann man Terraform in Form von Meta-Directiven (`depends-on` oder `lifecycle`) helfen, die richtige Reihenfolge einzuhalten. Gelegentlich dauert die Erstellung einer Ressource aber auch länger, so dass die Ausführung des Plans warten muss bis die Ressource verfügbar ist - das klappt gelegentlich nicht ... ist dann aber wahrscheinlich eher ein Bug im jeweiligen Terraform Provider.

Ziel der Ausführung ist die Vermeidung von Downtimes. Das muss der Entwickler von Terraform-Code immer im Blick haben. Manche Änderungen sind allerdings konzeptionell destruktiv (Änderung des EC2-AMI ist nur durch Terminierung und Neuanlage einer EC2-Instanz möglich). Hier muß dann evtl. der Überbau (z. B. ALB) so gestaltet sein, dass das ohne Downtime möglich ist.

Terraform weiß was es in der jeweiligen Situation am besten tut. Aber Terraform ist natürlich nicht fehlerfrei - insofern **MUSS** man vor einem Terraform Apply den Plan sehr gut studieren. **Ein blindes Terraform Apply kann zum Desaster führen!!!**

Besonders praktisch ist `terraform destroy`, bei dem Terraform ALLE gemanagten Ressourcen löscht ... das verhindert auch unnötige Kosten.

> Ein Terraform Destroy ist auf einer Spielumgebung ein nettes Feature ... in einer relevanten Umgebung muss man sich schon sehr sicher sein was man tut und ob das nicht doch irgendwelche Seiteneffekte hat (manchmal nutzt man ja vielleicht Infrastruktur implizit mit). Aus diesem Grund kommt ein Destroy im echten Leben selten vor. Allerdings nutzt man natürlich die kleinen Destroys von einzelnen Komponenten immer wieder.

Ein Terraform Projekt sollte vollständig self-containing sein, d. h. man checkt es von seinem VCS aus und kann es ohne zusätzliche manuelle Installation von Komponenten starten. Die einzige Voraussetzung ist ein `terraform`-Binary. Zu diesem Zweck unterstützt Terraform

* Anforderungen an die Version des `terraform`-Binary (`terraform.required_version`)
* Dependency-Spezifikation (`terraform.required_providers`)
* Schnittstellen Spezifikation
  * Input Values über `var`
  * Output Values über `output`
* Kollaboration
  * remote State Spezifikation (`terraform.backend`)
  * State-Locking

Zum Zwecke der Wiederverwendung größerer Blöcke werden `module` unterstützt. Module werden dabei entweder lokal, auf der HashiCorp-Cloud oder in eine VCS gehostet. Letztlich wird der Code dieser Remote-Module runtergeladen und dann wie lokale Module genutzt. Das ist sehr stringent.

Terraform stellt KEINE Anforderungen was wo definiert wird ... im Extremfall hat man alles in einer einzigen Datei beliebigen Namens definiert. Best-Practice ist das natürlich nicht. Diese Freiheit macht es manchmal ein bisschen schwierig, sich im Code zurechtzufinden. 

## Deklarativ vs Imperativ

Bei komplexen Konfigurationen sind deklarative Ansätze den imperativen Ansätzen deutlich überlegen. Beim deklarativen Ansatz kann man die DSL als Blackbox nutzen und die Komplexität an den Terraform Provider delegieren. Bei einem imperativen Ansatz (z. B. Ansible) muss die Logik und das Fehlerhandling selbst implementiert werden. Das Abstraktionslevel ist in diesem Fall niedriger. Hinsichtlich Wiederverwendung ist das hohe Abstraktionslevel bei einem komplexen System, das zuverlässig funktionieren muss (wie Infrastruktur), ein großer Vorteil ... die Qualität des Toolings (z. B. Terraform Provider) muss natürlich stimmen.

---

# Installation

Terraform besteht nur aus einem einzigen Binary ([Go ist die Sprache](https://de.wikipedia.org/wiki/Go_(Programmiersprache)), in der es programmiert ist - ganz typisch ist, daß ein einziges Binary entsteht), [das für verschiedene Plattformen angeboten wird](https://releases.hashicorp.com/terraform/) - toll ... so einfach kann das sein :-)

```bash
wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip
unzip terraform_0.11.10_linux_amd64.zip
chmod 755 terraform
```

> ACHTUNG: will man Terraform-State mit anderen Benutzern teilen (z. B. über S3 Bucket), dann sollte man entweder die gleiche Terraform-Version verwenden oder in Terraform eine State-Version explizit konfigurieren. Bei Terraform-Versionen < 1.0 war diese Anforderung ZWINGEND, da die Versionen weder Backward- noch Forward-kompatibel waren. Seit 1.0 ist daas deutlich entspannter - donnoch besser nicht machen. Am besten verwendet man `tfenv` mit einer `.terraform-version` Datei, um immer die richtige Version auch lokal zu verwenden. 

---

# Getting Started

* [Terraform Doku](https://www.terraform.io/intro/getting-started/build.html)
* [mein eigenes Terraform Projekt](https://github.com/mobi3006/terraform-fls15)
* [MUSTHAVE: HashiCorp Certified: Terraform Associate - Hands-on Labs](https://www.udemy.com/course/terraform-hands-on-labs/learn/lecture/30158642)

Terraform besteht aus einem überschaubaren Syntax. Das wichtigste Element sind die Terraform-Provider ... sie liefern die Features, um aus einer Spezifikation zu lauffähigen Infrastruktur-Komponenten zu gelangen.

Ein Beispiel (z. B. `main.tf`)

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

Nach diesen Kommandos der `terraform`-CLI ...

```bash
terraform verify                            # Syntaxprüfung
terraform init                              # hierdurch wird ein Verzeichnis .terraform im aktuellen Verzeichnis angelegt
                                            # providerspezifische Informationen/Module werden nachgeladen
terraform plan -var instance_type=t2.micro  # hier sieht man was geschehen wird
                                            # ... aws_access_id, aws_secret_key und instance_type werden interaktiv abgefragt
                                            # ... oder können per -var-file foo.tfvar contributed werden
terraform apply                             # erzeugt den Execution Plan
```

ist die spezifizierte EC2-Instanzt auf AWS nutzbar.

> Ich verwende statt `terraform plan && terraform apply` lieber `terraform plan -out=tfplan && terraform apply tfplan` (`tfplan` ist eine Binärdatei), da hier in diesem Fall sicher sein kann, daß tatsächlich auch der von mir erstellte Plan umgesetzt wird und nichts anderes. Insbesondere wenn ich noch interaktiv Variablenwerte bereitstellen muss ist das die bessere Variante. Den erstellten binären `tfplan` kann man leicht per `terraform show -json tfplan | jq` sichtbar machen.

Bei diesen Kommandos werden **die meisten** Terraform relevanten Dateien (`*.tf`, `terraform.tfvars`, `*.auto.tfvars`) im aktuellen Verzeichnis automatisch berücksichtigt.

Das aktuelle Verzeichnis bildet das sog. Root-Module ab, da JEDES Verzeichnis mit Terraform-Code grundsätzlich ein Modul darstellt. Man kann in Terraform also gar nicht keine Module verwenden. In dem obigen Beispiel wird eine Konfigurationsvariable `instance_type` verwendet, die zur Ausführungszeit gesetzt sein muß. Das geschieht

* ENTWEDER: in einer `*.tfvar` Datei, die per Parameter `terraform apply -var-file ~/my-values.tfvar` angegeben wird
* ODER: als Parameter an `terraform apply -var instance_type=t2.micro`
* ODER: über eine Umgebungsvariable (`export TF_VAR_instance_type=t2.micro`)

Terraform schreibt nicht vor wie die Dateien zu heißen haben oder wie sie strukturiert sein sollen (Convention-over-Configuration). Hier ist der Entwickler vollkommen frei. Das macht es manchmal schwer sich in fremdem Terraform-Code zurechtzufinden. In einem Team sollte man sich auf minimale Konventionen halten und Best-Preactices verwenden. Diese Freiheitsgrade machen es aber Newbes und Junior häufig sehr schwer lesbaren und wartbaren Code zu schreiben.

> Ich halte diese Freiräume in der Benennung der Datei für einen guten Schachzug. Es ermöglicht eine freie semantische Benennung, ohne den Nutzer zu gängeln und dadurch dann wiederum Verstöße überprüfen zu müssen. Dennoch gibt es Best-Practices (`main.tf`, `output.tf`, `variables.tf`, ...), an die man sich halten sollte. Es verbleiben dennoch viele Freiheiten.

Eine Best-Practice ist die Aufteilung des Codes auf mehrere Dateien mit diesem Namensschema:

* `vars.tf`
* `main.tf`
* `outputs.tf`

... das verbessert die Übersicht und durch die Konvention findet man sich in fremden Projekten auch schneller zurecht. Eine Wiederverwendung läßt sich Module erreichen.

Bei `terraform plan` wird angezeigt, was bei `terraform apply` geschehen wird. Beachte hierbei, daß die Konfiguration (der Code) das Ziel beschreibt. Abhängig vom aktuellen Zustand (gespeichert in einer `*.tfstate` Datei) werden dann die notwendigen Aktionen berechnet. Der Plan ist natürlich nur gültig solange keine Änderung erfolgt. Ändert jemand anschließend die Umgebung, dann muß der Plan natürlich anders aussehen ... Terraform hat hier optimistisches Locking implementiert.

Bei einem `terraform plan` wird der Terraform State - sollte er auf einem Remote-Filesystem (z. B. S3) liegen ... nur so ist Arbeiten im Team möglich - runtergeladen, aber wohl nicht mehr auf dem Filesystem abgelegt (aus sicherheitsgründen). Braucht man das Terraform Statefile lokal, so kann man es per

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

---

# terraform CLI en Detail

* `terraform show`
  * detailierte Anzeige des States ... wenn es sich um einen Remote State handelt, dann wird der automatisch aufgelöst
* `terraform show tfstate.backup`
  * detailierte Anzeige des States, der im File `tfstate.backup` abgebildet ist
* `terraform state list`
  * welche Resourcen sind unter Terraform-Control
* `terraform taint aws_instance.web_server` - **DEPRECATED** ... ersetzt durch `terraform apply -replace="MY_RESOURCE"`
  * hiermit markiert man eine Ressource als nicht fully functional, so dass sie beim nächsten `terraform apply` gelöscht und neu erzeugt wird
  * das passiert terraform-intern, wenn eine Komponente erzeugt aber nicht vollständig konfiguriert werden konnte ... dann markiert Terraform die Komponente als tainted. Das kann man dann über den State sehen `terraform state show MY_RESOURCE`
* `terraform import`
  * Importieren eines Resource in den State ... hiermit bringt man eine vorher manuell gemanagte Resource unter Terraform-Control
* `terraform validate`
  * syntaktische Überprüfung des Terraform Codes
* `terraform fmt`
  * Formatierung des Terraform Codes gemäß [dieses Styles](https://developer.hashicorp.com/terraform/language/syntax/style)

## Statefile runterladen

Mit

```
terraform init
terraform state pull > /tmp/terraform.tfstate
```

kann das Statefile runtergeladen (wenn man es nicht eh schon lokal hat), mit Kommandos wie `terraform state list -state=/tmp/terraform.tfstate` angesehen oder auch per `terraform state mv -state=/tmp/terraform.tfstate` verändert werden.

In den meisten Fällen hat man mit dem State nur indirekt (beim `terraform plan`, `terraform show`) zu tun oder nutzt maximal `terraform state list`. In Migrationsszenarien wird man aber auch mal den State manipulieren müssen oder sogar Statefiles mergen. Das ist natürlich eine sehr kritische Angelegenheit und muss entsprechend sorgfälig gemacht werden, da hier Bulk-Changes ohne explizites Review erfolgen.

## Execution Scope einschränken

Mit `terraform plan -target module.eks` kann der Scope des Plans/Apply eingeschränkt werden (auf bestimmte Ressourcen). Dadurch geht die Ausführung natürlich schneller. Manchmal benötigt man es aber auch, um ein Layer vor einem anderen zu deployen. Allerdings muss man dann die Abhängigkeiten zwischen den Layern selbst berücksichtigen und dabei können leicht Fehler entstehen.

> Aus meiner Sicht führt das am Konzept (definieren eines Ziels und Terraform kümmert sich um die richtige Reihenfolge) von Terraform vorbei und deshalb versuche ich das zu vermeiden ... manchmal geht es aber evtl. nicht anders (`depends_on` könnte helfen).

---

# Terraform Sprache HCL (HashiCorp Control Language)

HCL stellt eine Domain-Specific-Language (DSL) dar, die von der Terraform-CLI interpretiert wird.

Es lonht sich, hier mal einen Blick reinzuwerfen nachdem man die ersten Schritte gegangen ist - dann versteht man den Code tatsächlich besser:

* [HCL language/syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration)

## JSON statt HCL - BESSER NICHT

Anstatt HCL könnte man auch JSON verwenden (dann müssen die Dateien allerdings mit `.tf.json` anstatt `.tf` enden). Aus meiner Sicht ist aber

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

deutlich schwieriger zu lesen als die HCL Variante:

```
variable "example" {
  default = "hello"
}

resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-abc123"
}
```

## Statischer Block

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

* `resource` ein Block-Typ mit 2 Labels:
  * `aws_instance`: definiert die Ressource des Providers (Provider `aws` + Komponente `instance`)
  * `example`: ein frei definierbarer Name
* `network_interface` ein Block mit **0 Labels!!!**

## Resource

Die Definition einer Resource

```json
resource "aws_instance" "application_server" {
  ami           = "ami-2757f631"
  instance_type = "${var.instance_type}"
}
```

referenziert den Ressource-Type (hier `aws_instance` - [Dokumentation](https://www.terraform.io/docs/providers/aws/r/instance.html)). Die ressource-type-spezifischen Properties werden in Form einer Map übergeben (z. B. `{ ami = "ami-2757f631"`). Der erste Teil des Ressource-Types (hier `aws`) referenziert Provider (hier [aws](https://www.terraform.io/docs/providers/aws/index.html)), der auch explizit konfiguriert werden sollte (im besten Fall mit Bedingungen an die Version). Zudem hat die Ressource einen Namen (hier `application_server`), über den die Properties per `aws_instance.application_server.instance_type` referenziert werden können.

> ACHTUNG: es heißt `aws_instance.application_server.instance_type` und NICHT `resource.aws_instance.application_server.instance_type`, da `resource` der Default ist sofern nichts anderes angegeben wird. Bei anderen Komponenten, muss man aber den Typ davor schreiben (z. B. bei einer Data-Source: `data.template_file.nomad-job-template.rendered`). Mir gefällt dieser implizite Name bestehend aus Provider-Komponente und frei wählbarem Namen sehr gut, weil die Provider-Komponenten schon auch gleich den Kontext enthält, der dann im frei wählbaren Teil nicht wiederholt werden muss. Damit wird immer ein Kontext erzwungen.

Zudem gibt es weitere Meta-Properties wie z. B. `depends_on`, `lifecycle`, `count`, die providerunabhängig sind.

## Variablen

* [Udemy-Kurs - terraform-hands-on-labs](https://www.udemy.com/course/terraform-hands-on-labs/learn/lecture/30158642#overview)

Mit Variablen werden Module in verschiedenen Kontexten wiederverwendbar. Variablen können primitiv sein

* String
  * `name = "Pierre"`
* Number
  * `age = 25`
* Boolean
  * `is_male = true`

wie z. B.

```
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

und komplex

* List
* Set
* Map
* Object
* Tuple

wie z. B.

```
variable "games" {
  type = map(object({
    iam_role_policies : list(string)
    iam_role_boundary : string
    iam_role_trusted_principals : list(string)
  }))
  default = {}
}
```

In jedem Fall sollte man die Datentypen definieren, so daß der Nutzer auch weiß was er bereitstellen muss.

Eine Variable können mit dem Attribute `sensitive = true` gekennzeichnet werden, um Secrets zu schützen (beim Output werden sie maskiert).

Die Belegung der Variablen erfolgt

* über Default-Values
* `terraform.tfvars`-Datei ... eine Datei mit diesem Namen wird automatisch angewendet
* `foobar.tfvars`-Datei ... diese Datei muss EXPLIZIT per `terraform plan -var-file foobar.tfvars` angegeben werden
* Umgebungsvariable `TF_VAR_variable1=foobar`

Es kommt immer wieder vor, dass man Datentypen transformieren muss, um

* output Werte eines Moduls (das man evtl. nicht mal unter Kontrolle hat) in eine andere Darstellung zu transformieren
* redundante variablen Definitionen zu vermeiden
  * Beispiel: man könnte aus einer
  
      ```
      variable "cars_detailed_list" {
        type = list(object({
          brand = string
          type  = string
          color = string
          age   = number
        }))
      ```

    ein Set der genutzten Farben extrahieren:

      ```
      my_set = toset([for car in var.cars_detailed_list : car.color])
      ```

In diesem Zusammenhang sind auch die [Terraform-Functions](https://developer.hashicorp.com/terraform/language/functions) interessant:

* `toset`
* `merge`
*  ...


## Dependencies

Durch die Referenzierung von Provider-Komponenten (Ressourcen, Data-Sources, ...) ergibt sich eine implizite Abhängigkeit, die Terraform erkennt und entsprechend auflöst, so daß - unabhängig von der Definition in der `.tf`-Datei - eine valide Reihenfolge bei der auszuführenden Aktionen abgeleitet wird. Alles, was voneinander unabhängig ist, kann parallel ausgeführt werden, um die Zeit bis zur Bereitstellung der Ziel-Umgebung zu verringern.

> Die Planung und Ausführung kann teilweise sehr lange dauern (teilweise Stunden) ... trotz Parallelisierung. 

In Ausnahmefällen müssen Abhängigkeiten explzit über `depends_on` angegeben werden ... 

* entweder weil Terraform keine Chance zur Ableitung hat
  * beispielsweise kann eine Applikation, die in einer anzulegenden EC2-Instanz läuft, einen S3-Bucket voraussetzen. Diese semantische Abhängigkeit kann Terraform am Code nicht erkennen
* oder der Provider einen Bug hat
  * in solchen Fällen kann man auch mit einem `local-exec`-Provider ein Sleep einbauen ... unschön, aber möglich.

Manchmal passiert es auch, dass Terraform zwar die Abhängigkeit erkennt, aber die Anlage einer Ressource besonders lange dauert und das Monitoring nicht korrekt funktioniert (AWS-Aktionen werden i. a. auch asnychron ausgeführt), so dass Terraform fortsetzt, ohne die Fertigstellung abzuwarten. Dann kann es es Problemen/Abbrüchen mit merkwürdigen Fehlermeldungen kommen.

## Locals

Bei `locals` handelt es sich um Konstanten oder wiederverwendbare Werte (z. B. Transformationen von Datentypen oder Datenmengen), die per

```
locals {
  my_const  = "pierre"
  full_name = "${var.surname} ${var.lastname}"
}
```

deklariert und über

```
param = local.my_const
```

genutzt werden.

`locals` werden auch gerne für die Aufbereitung von Variablen oder anderen Datenstrukturen verwendet. Will man seinen Code beispielsweise über ein yaml-File konfigurieren (diese DSLs sind sehr schön lesbar), dann liest man es ein und transformiert die Daten in HCL Datenstrukturen:

```
locals {
  models = yamldecode(file("${path.module}/config.yaml")).models
  destinations = merge([for file in fileset("models", "*.yaml"): yamldecode(file("models/${file}"))]...)
  email2github_id = {for item in data.github_organization.org.users: lower(item.email) => item.login}
}
```

## Data Sources - für Templates

Über `data` lassen sich Dateien aus Templates erstellen.

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

Hier sieht man auch sehr schön die übergreifende Adressierung ... von `nomad_job.my-service` nach `data.template_file.my-service-nomad-job-template`.

> **BEACHTE:** der Typ ist Teil des Namens, d. h. `data.template_file.my-service-nomad-job-template` und nicht `template_file.my-service-nomad-job-template` - das ist bei `resource` nicht der Fall (weil das der Default ist)

## Data Sources - für Infrastruktur-Informationen

Data Sources stellen Terraform aktuelle statische und dynamische Informationen aus der Umgebung bereit. Diese Bereitstellung erfolgt über read-only Queries, die die Data Source zur Ausführungszeit gegen die APIs der Laufzeitumgebung macht. Dies ist **KOMPLETT** entkoppelt vom Terraform State und dem Lesen von Remote-Statefiles auf jeden Fall vorzuziehen!!!

Data Sources haben folgende Ziele

* Integration von nicht terraform-managed Ressources
* Informationen über Ressourcen, die in anderen Infrastruktur-Layern deployed wurden
  * ist eine Ressource terraform-managed und man hat Zugriff auf den State, dann sollte kann man natürlich auch eine Abfrage des Remote-Terraform-States in Betracht ziehen

Mit dem nachfolgenden Snippet kann man bekommt man Informationen darüber welche Ubuntu-AMI's zur Verfügung stehen (statische Informationen also) ... die Werte im Block beschreiben die Query (schon ein bissl strange)

```
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

Man kann natürlich auch dynamische Informationen auslesen, z. B. welche Region im aktuellen Executions Context verwendet wird:

```
data "aws_region" "current" {}
```

Mit

```
variable "private_subnets" {
  default = {
    "subnet_1" = 1
    "subnet_2" = 2
    "subnet_3" = 3
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public_subnets" {
  for_each                = var.private_subnets
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
}
```

kann sogar Code geschrieben werden, der in **JEDER** beliebigen Region mit unterschiedlichen Availability Zones läuft. Das erspart letztlich Konfigurationsarbeit und verhindert Copy/Paste-Probleme.

## Data-Sources für externe Programmaufrufe

* [external Provider](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external)

Manchmal benötigt man eben doch Logik, die sich schlecht in einer deklarativen Sprache wie HCL abbilden lässt. Für diesen Zweck bietet sich der `external`-Provider an, der eine Data-Source bereitstellt. Auf diese Weise kann man Bash/Python-Code ausführen lassen ... Input und Output Parameter werden dabei unterstützt.

Alternativ kann man hier `provisioners` verwenden.

## Module

* [terraform docu](https://learn.hashicorp.com/tutorials/terraform/module?in=terraform/modules)
* [terraform docu - lokale Module](https://learn.hashicorp.com/tutorials/terraform/module-create?in=terraform/modules)
* [Udemy-Kurs](https://www.udemy.com/course/terraform-hands-on-labs/learn/lecture/29599500)

Grundsätzlich ist jedes Verzeichnis mit Terraform Dateien ein Modul. Es geht also gar nicht ohne Module in Terraform.

> Aber natürlich muss ein Modul auch für die Wiederverwendung vorbereitet sein, aber das sind eher Design-Anforderungen als technische Requirements.

Über Module wird ein Template-Mechnismus bereitgestellt, über den sich wiederverwendbare Komponenten abbilden lassen. Aus atomaren Sprachelementen (`resource`, `data`, `var`, `output`, ...), die eine Lösung formen, entstehen komplexe wiederverwendbare Komponenten, die über Parameter an den jeweiligen Use-Case angepasst werden.

> Letztlich ist ein Modul nicht mehr als eine implizite Kopieranleitung, die man explizit auch mit Codegenerierung erreichen könnte

Die Endstufe eines Moduls sieht man bei [mineiros-io](https://github.com/mineiros-io/terraform-github-repository/blob/main/examples/public-repository/main.tf), die eine DSL in Terraform-Code um ein Modul bereitstellen. So kann Terraform-Code aussehen.
Diese Art von Wrapper-Modul ist ganz typische, um komplexere Strukturen wiederzuverwenden ... so ist es [auch bei AWS (beispielsweise beim Modul "terraform-aws-modules/security-group/aws")](https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/main.tf).

Module werden folgendermaßen verwendet:
 
```json
module "my_use_case" {
  source = "./my-reusable-code"

  variable1 = "value1"
}
```

> `source` kann ein relatives lokales `./my-reusable-code` Verzeichnis, absolutes lokales `/home/pfh/my-terraform-module` Verzeichnis sein, aber auch eine http-Url (`source = "git::https://example.com/vpc.git"`), ein Branch `git::https://example.com/vpc.git?ref=feature/new-style`, ein Tag `"git::https://example.com/vpc.git?ref=v1.2.0"`, ein Zip-File `https://mvnrepository.com/artifact/.../my-module-2.3.5.zip`.

Beim `terraform init` werden alle Module von den Sourcen runtergeladen und im Verzeichnis `.terraform/modules` abgelegt. Hier liegt dann also der komplette Source Code lokal und wird bei der Ausführung von `terraform plan/apply` verwendet.

> Anfänger wundern sich immer mal wieder warum der geänderte Code gar nicht angewandt wird ... liegt dann häufig daran, dass der neue Code nicht neu runtergeladen wurde. Ein `terraform init --upgrade` löst das Problem.

Bei `terraform init` wird tatsächlich der Source-Code der genutzten Module (extern und intern) nach `.terraform/modules` geschrieben. Man kann hier also auch schnell mal nachschauen wie das Module implementiert ist ... nicht nur das, denn auch Dokumentation und Beispiele liegen für viele Module bereit. Genial.

Ein Blick in die [Terraform Registry](https://registry.terraform.io/) ist zu empfehlen, um fertige professionelle Module zu finden ... man muss ja das Rad nicht neu erfinden.

Die Verwendung eines (lokalen) relativen Moduls (`./my-reusable-code`) ermöglicht die Modularisierung in einem einzelnen Git-Repository (fungiert dann als sog. Root-Module), ohne daß der Code verstreut ist. Auf diese Weise lassen sich komplette Systeme kompakt beschreiben, ohne dabei Redundanzen einbauen zu müssen.

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

Auf diese Weise könnte man ein "Public" Root-Modul anbieten, das intern aber weitere Module (z. B. `my-seconds-terraform-module`) verwendet, die aber private sind. Und natürlich können Modules wieder weitere Module verwenden. Dadurch entstehen lange Ketten von Ressourcen-Bezeichnern wie diese (beachte: 3 mal `module`):

```
module.eks.module.eks.module.eks_node_group["for"].data.aws_iam_policy_document.assume_role_policy[0]
```

> Die Kennzeichnung `public` und `private` unterstützt Terraform nicht ... wäre dann eher eine Konvention.

Input-Variablen (z. B. in `variables.tf`) und Output-Values (z. B. in `output.tf`) definieren den Contract eines Callers zum Module und enthält gleichzeitig die Dokumentation dieser Schnittstelle durch `description`. Auch alle anderen typischen Konzepte (`main.tf`, ...) stehen einem Module zur Verfügung ... genauso wie dem Root-Module (das ohne weitere Module verwendet wird). So einfach und doch so mächtig.

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

### Provider in Modulen

* [Providers Within Modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)

Einen `provider` Block sollte ein - zur Wiederverwendung entworfenes Modul - nicht haben. Die Definition und damit die Instantierung sollte im Caller erfolgen ... dort werden die Version und die Konfiguration festgelegt - ansonsten wäre das Modul kaum wiederverwendbar (Dependency-Injection!!!). Das Modul "erbt" dann die konfigurierte Provider-Instanz und verwendet sie weiter.

Allerdings hat das Terraform, das den Provider verwendet, eigene Erwartungen ... der Code ist evtl. für eine bestimmte Version geschrieben und getestet worden. Diese Erwartungen sollte das Modul **EXPLIZIT** definieren:

* `required_providers`
* Version einschränken (`version = "~> 5.0"` - alle 5er Versionen des Providers werden akzeptiert und sind kompatibel)
  * die Version sollte nicht zu restriktiv gesetzt werden - das würde die Nutzbarkeit deutlich reduzieren

Diese Erwartungen werden zur Ausführungszeit überprüft ... somit wird ein `terraform plan/apply` im Konfliktfall verhindert.

> Man erkennt hier, dass wiederverwendbare Module auf backward-kompatibles Verhalten der Provider angewiesen sind.

Man kann sogar unterschiedliche Provider Instanzen erzeugen und unterschiedlich benennen. Das kann Sinn machen, wenn man Ressourcen in unterschiedlichen Regionen anlegen muss.

Die unterschiedlichen Alias-Provider werden dann explizit bei einem [Aufruf übergeben](https://developer.hashicorp.com/terraform/language/modules/develop/providers#passing-providers-explicitly):

```json
module "project" {
  source    = "git::https://github.com/foobar.git?ref=12345"
  providers = {
    github  = github.alias1
  }
}
```

oder aber auch bei einer Ressource

```json
resource "aws_s3_bucket" "example" {
  provider = aws.us-east-1
  bucket   = "XXXXXXXXXXXXXXXXXXX"
}
```

Das Modul signalisiert per

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws,
        aws.us-east-1,
      ]
    }
  }
}
```

daß es mit mehreren AWS-Instanzen umgehen kann bzw. diese auch erwartet.

Allerdings macht das den Code nicht unbedingt besser verständlich ... besser man kann darauf verzichten.

Allerdings lassen sich damit Anforderungen hinsichtlich Multi-Region oder sogar Multi-Cloud Support umsetzen (z. B. Desaster-Recovery).

## Functions

* [Dokumentation](https://www.terraform.io/language/functions)

Terraform bietet kleine Helferfunktionen, denn auch eine deklarative Sprache kommt nicht ohne aus. Die werden u. a. benötigt, wenn Modul- oder Resource-Parameter einen bestimmten Typ (z. B. Set) erwarten und man aber eine List hat.

Ein Beispiel mit gleich mehreren Funktionen (`toset()`, `lookup()`, `templatefile()`):

```
variable "aws_region" {
  default = "us-east-1"
}
variable "aws_regions" {
  default = [ "us-east-1", "us-east-2", "us-west-1"]
}
variable "aws_amis" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0739f8cdb239fe9ae"
    "us-west-2" = "ami-008b09448b998a562"
    "us-east-2" = "ami-0ebc8f6f580a04647"
  }
}

locals {
  ami_via_dict   = var.aws_amis[var.aws_region]
  ami_via_lookup = lookup(var.aws_amis, "das_gibt_es_nicht", "ami-0739f8cdb239fe9ae")
  user_datai_script = templatefile(
     "user_data.tftpl", { department = "sales", name = "pierre" })
  aws_regions_set = toset(var.aws_regions)
}
```

Natürlich kann man mit einem `var.aws_amis[var.aws_region]` den Wert aus einer Map ermitteln. Wenn es aber keinen Wert gibt, dann ist das Ergebnis `null`. In Terraform kann man das aber schlecht prozedural verwerten und einen Default setzen. Aus diesem Grund gibt hier beispielsweise eine `lookup(var.aws_amis, var.aws_region, "das-ist-ein-default-wert")` verwenden, um den Default ohne prozedurale Elemente zu setzen.

> Die Functions sind der Workaround, um mit den Limitierungen einer deklarativen Sprache leben zu können.

## Expressions

Da Terraform keine prozeduralen Bestandteile hat, müssen Expressions oder Meta-Tags (wie `count`, `for_each`) herhalten.

Die einfachste Variante ist der ternäre Operator:

```
locals {
  maennlich = var.anrede = 'Herr' ? true : false
}
```

Hier eine [`for`-Expression](https://developer.hashicorp.com/terraform/language/expressions/for):

```
variable "aws_amis" {
  type = map(any)
  default = {
    "us-east-1" = "ami-0739f8cdb239fe9ae"
    "us-west-2" = "ami-008b09448b998a562"
    "us-east-2" = "ami-0ebc8f6f580a04647"
  }
}

locals {
  ami_list = [for k,v in var.aws_amis : v]
  ami_set = toset([for k,v in var.aws_amis : v])
}
```

Auf diese Weise kann man Datenstrukturen parsen (hier eine Map) und andere überführen. Durch eine geschickte Wahl der Basis-Datenstrukturen lassen sich somit redundante Konfigurationen vermeiden.

## Schleifen per for_each

* [`for_each`](https://youtu.be/7xngnjfIlK4?t=4556)

Auf diese Weise ist es möglich variablen-gesteuert VIELE Ressourcen mit einem einzigen `resource`-Statement anzulegen:

```
resource "aws_instance" "server" {
  for_each = local.subnet_ids

  ami           = "ami-0ab1a82de7ca5889c"
  instance_type = "t2.micro"
  subnet_id     = each.key
```

## Schleifen per Dynamic Blocks

Neben den statischen Blocks gibt es auch [dynamische Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks), um dynamisch - einer for-Schleife ähnlich - Blöcke zu erzeugen.

Diesen redundanten Code

resource "aws_security_group" "main" {
    arn                    = "arn:aws:ec2:us-east-1:4711:security-group/sg-0815"
    description            = "Managed by Terraform"
    egress                 = []
    id                     = "sg-0815"
    ingress                = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 443"
            from_port        = 443
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 443
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = "Port 80"
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    name                   = "core-sg"
    owner_id               = "1234567"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-8263821392"
}
```

schreibt man eleganter als

```hcl
locals {
  ingress_rules = [{
      port        = 443
      description = "Port 443"
    },
    {
      port        = 80
      description = "Port 80"
    }
  ]
}

resource "aws_security_group" "main" {
  name   = "core-sg"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

> **ACHTUNG:** statte `each.value` muss man den dynamic Identifikator `ingress` verwenden, um die Werte zu referenzieren, z. B. `ingress.value` ... `each.value` funktioniert by `dynamic`-Blocks nicht. Das hat allerdings auch den Vorteil, dass man innerhalb eine `for_each`-Ressource (in der man `each.value` verwendet) noch beliebig viele `dynamic` Blocks verwenden kann.

Man verwendet Danymic Blocks immer dann, wennn innerhalb einer Ressource Schleifen auf der Konfiguration gebraucht werden.

> imperative Konstrukte wie Schleifen wirken in deklarativen "Sprachen" wie HCL immer ein bisschen seltsam - wie ein Bruch im Konzept

## Meta-Argument count

* [`count`](https://youtu.be/7xngnjfIlK4?t=4546)

kann man beispielsweise auch mit `${count.index}`
  
```
resource "aws_instance" "server" {
  count = 4
  ami = "ami-0ab1a82de7ca5889c"
  instance_type = "t2.micro"
  tags = {
    Name = "Server ${count.index}"
  }
```

## Meta-Argument depends_on

* [`depends_on`](https://youtu.be/7xngnjfIlK4?t=4428)

In den meisten Fällen erkennt Terraform die Dependencies automatisch und kann das Terraform apply in der richtigen Reihenfolge anwenden. In manchen Fällen sind die Abhängigkeiten aber nicht durch die Spezifikation im Terraform-Code ersichtlich und man muss ein `depends_on` hinzufügen.

Beispiel:

* eine Anwendung, die über ein EKS-Cluster deployed wird, benötigt einen Bucket
* im Code der Anwendung wird dieser Bucket erzeugt und parallel dazu die Anwendung deployed

Die Dependency aus der Anwendung auf den Bucket ist im Terraform Code nicht zu sehen - das ist Teil der Anwendungs-Konfiguration. Um zu verhindern, dass die Anwendung ausgerollt und gestartet wird, ohne einen vorhandenen Bucket, definiert der Terraform-Code der Anwendung ein `depends_on` auf den Bucket.

Während dieses Beispiel sehr einleuchtend ist, gibt es manchmal Situationen nicht so offensichtliche Dependency-Problemstellungen. Definiert man auf einem Bucket eine Ressource-Policy (per `aws_s3_bucket_policy`), so handelt es sich dabei um eine implizite Dependency, da der Bucket referenziert wird

```
resource "aws_s3_bucket_policy" "hello-world-website-allow-access-from-public" {
  bucket = aws_s3_bucket.hello-world-website.id
  policy = data.aws_iam_policy_document.hello-world-website-allow-access-from-public.json
}
```

Die Dependency erkennt Terraform auch. Da die Anlage eines Buckets allerdings ein paar Minuten dauern kann, kommt es gelegentlich vor, dass das Terraform Apply fehlschlägt, weil Terraform den Code zur Anlage des Buckets schon ausführt hat ... der Bucket aber noch nicht erstellt wurde (AWS braucht manchmal eben länger). Grundsätzlich könnte der AWS-Provider bei manchen Aktionen einfach ein bisschen länger warten (evtl. mit Retries) und dann wäre alles gut. Keine Ahnung, ob das ein Bug im AWS-Terraform-Provider ist oder konzeptueller Art. Jedenfalls muss man in einem solchen Fall Terraform Plan/Apply einfach nochmal laufen lassen.

## Lifecycle Direktiven

* [`lifecycle`](https://youtu.be/7xngnjfIlK4?t=4602)


Das `lifecycle.create_before_destroy` hilft beispielsweise bei der Abbildung von Zero-Downtime:

```
resource "aws_instance" "server" {
  ami           = "ami-0ab1a82de7ca5889c"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true                       # <====== wichtige Konfiguration
    ignore_changes = [
      tags
    ]
  }
```

Mit einem `lifecycle.prevent_destroy` kann man datentragende Ressourcen (z. B. Datenbanken wie DynamoDB) vor einer unbeabsichtigten Zerstörung bewahren (bei einigen Dutzend zu löschenden Ressourcen, könnte einem das durch die Lappen gehen).

Auf diese Weise kann man terraform Hinweise für die Reihenfolge der Plan-Ausführung geben ... die Spezifikation wird semantisch angereichert.

---

# Terraform Provider

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

In diesem Beispiel ist die Version nicht eindeutig definiert - es wird nur gefordert, dass die Version 4.0 oder höher ist. Bei einem `terraform init -upgrade` würde dann die Version evtl. hochgezogen

Gibt man keine explizite Version des Providers an, dann sollten man gelegentlich per `terraform init -upgrade` die Provider Versionen hochziehen. Dadurch wird dann auch eine `.terraform.lock.hcl` Datei upgedated, die die Dependencies beschreibt. Diese Datei sollte man unter Versionskontrolle stellen, damit man zumindest mitbekommt (im PR beispielsweise), dass sich die Version ändern würde und man eine explizite Entscheidung treffen kann. Das könnte beispielsweise einen expliziten Test triggern oder zumindest sollte man dann mal die Release Notes lesen.

> Wenn ein expliziter `required_providers` Block fehlt oder auch einzelne im Code genutzte Provider fehlen, dann macht das nichts. Terraform scannt alle notwendigen Provider aus dem Code und installiert diese automatisch beim `terraform init`. Allerdings kann man mit dem `required_providers` die Versionen beeinflussen - tut man das nicht, dann wir immer die `latest` Version verwendet, die aber evtl. nicht mit dem Terraform Code kompatibel ist.

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

## Custom-Provider

Man kann auch seinen eigenen Provider `terraform-provider-<NAME>_vX.Y.Z` contributen ([hier gehts zur Doku](https://www.terraform.io/docs/extend/writing-custom-providers.html)). Diese werden dann aber bei `terraform init` nicht automatisch aus dem Internet geladen - stattdessen muß man sie in `~/.terraform.d/plugins` ablegen.

---

# Extended Features

## yaml

* [Umwandlung der Formate](https://www.hcl2json.com/)

Das yaml-Format eignet sich besonders für sprechende DSLs und Spezifikationen. Hier geht es i. a. darum möglichst einfach zu sein, weil man sich an einen Endanwender richtet, der nicht umbedingt einen syntaktischen Helfer (IDE) nutzen will, um die Spezifikation syntaktisch korrekt auszudrücken.

Ein

```
pierre:
  alter: 23
  hobbies:
    - fussball
    - kochen
  freunde:
    - robin
    - jonas
    - nora
  autos:
    - ford:
        farbe: blau
    - mercedes:
        farbe: anthrazit
    - polo:
        farbe: rot
```

lässt sich deutlich leichter lesen (und mit weniger Fehlern schreiben) als die gleich Darstellung in HCL (DEM Hauptformat in Terraform):

```
"pierre" = {
  "alter" = 23
  "freunde" = ["robin", "jonas", "nora"]
  "hobbies" = ["fussball", "kochen"]
  "autos" "ford" {
    "farbe" = "blau"
  }
  "autos" "mercedes" {
    "farbe" = "anthrazit"
  }
  "autos" "polo" {
    "farbe" = "rot"
  }
}
```

oder in JSON

```
{
  "pierre": {
    "alter": 23,
    "freunde": [
      "robin",
      "jonas",
      "nora"
    ],
    "hobbies": [
      "fussball",
      "kochen"
    ],
    "autos": [
      {
        "ford": {
          "farbe": "blau"
        }
      },
      {
        "mercedes": {
          "farbe": "anthrazit"
        }
      },
      {
        "polo": {
          "farbe": "rot"
        }
      }
    ]
  }
}
```

Die Klammerungen entfallen bei yaml und machen die Konfiguration sehr übersichtlich (die Einrückungen machen die Klammern obsolet).

Insofern macht es durchaus Sinn, yaml zur Spezifikation komplexer Zusammenhänge zu verwenden. Hier muss man die Quelle aber dann in einer Form bringen, die sich in Terraform verarbeiten lässt. Hierzu verwedent man die Function `yamldecode` (oder auch `yamlencode`):

```
raw_pierre = yamldecode(file("${path.module}/pierre.yaml"))
```

und liest die Daten dann gezielt per

```
local.raw_pierre.pierre.alter
```

Es kann hierbei natürlich passieren, dass bestimmte Daten nicht gesetzt sind. Das sollte man in seinem Code mit der `try`-Function abfangen und dann Default-Werte nutzen:

```
try(local.raw_pierre.pierre.anzahl_handys, null)
```

## JSON

Viele REST-APIs liefern JSON-Format und deshalb muss Terraform (deren Provider ja intern dann auch die REST-APIs der BAckend-Services verwenden) gut mit JSON umgehen können.

Terraform bietet hierzu die Functions `jsondecode` und `jsonencode`.

---

# State

* [Udemy Kurs](https://www.udemy.com/course/terraform-hands-on-labs/learn/lecture/29554226)

Terraform verwaltet einen State (z. B. `terraform.tfstate`), der als `json`-Datei abgespeichert wird. Per Default liegt er lokal auf dem Filesystem - besser ist es aber, ihn Remote (z. B. S3, Terraform Cloud) abzulegen.

> **ACHTUNG:** der State enthält Secrets in Plaintext - sollte also am besten verschlüsselt werden. Hier eignet sich S3 besonders gut, denn hier kann man am Bucket die Verschlüsselung aktiviert und kann das so schon mal nicht vergessen.

Dieser State beschreibt den aktuellen Zustand der unter Terraform stehenden Umgebung und ist die Basis, um aus der Ziel-Definition (Terraform-Dateien) die zu triggernden Aktionen bei einem `terraform apply` abzuleiten - es wird ein Diff zwischen dem neuen Ziel-Status und dem aktuellen Status gemacht. Hinzu kommt - wenn das möglich ist - noch der tatsächliche Zustand auf dem Zielsystem ... das ist aber nur bei relativ einfachen Abweichungen möglich ... hilft aber sehr, wenn das Zielsystem doch mal manuell verändert hat (zum Testen manchmal ganz praktisch). Die manuellen Änderungen werden dann beim nächsten `terraform apply` verworfen, sofern sie von terraform gemanaged werden.

> Terraform erkennt das in der Regel und zeigt die Änderungen mit einem `Note: Objects have changed outside of Terraform. Terraform detected the following changes made outside of Terraform since the last "terraform apply"` an.

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

## Isolation Best Practices

Packt man die Beschreibung der gesamten Infrastruktur (für alle Stages) in ein einziges Deployment-Modul, so ist das Risiko etwas kaputtzumachen (es wird dann auch nur ein einziges State-File verwendet) vergleichsweise hoch und der Plan dauert auch länger. Wenn man nur eine kleine Änderung an den Edge-Proxies vornehmen will, dann ist es vielleicht besser nur das oberste Layer der Infrastruktur auszurollen und nicht die tieferen Schichten. Das hat auch etwas mit der Änderungshäufigkeit der verschiedenen Layer zu tun ... je tiefer desto seltener.

Welches Level der Isolation verwendet wird, liegt in der Entscheidung des Nutzers - Terraform kann hier keine Vorgaben machen ... dennoch gibt es Best-Practices:

* Separierung von Stages (DEV, TEST, LIVE)
* Layering ... alles was man typischerweise gemeinsam deployed (weil es konsistent zueinander sein muß)

Diskussion über Monoilith vs. Layers:

* [www.padok.fr](https://www.padok.fr/en/blog/terraform-iac-multi-layering)
* [Happy Terraforming! Real-world experience and proven best practices](https://www.hashicorp.com/resources/terraforming-real-world-experience-best-practices)

## Isolation über Workspaces

Über Workspaces lassen sich State-Files separieren, um so beispielsweise unterschiedliche Landschaften (Live-Environment, Test-Environment, DEV-Environment) voneinander trennen.

## Remote-State lesen

Hat man ein Layering in irgendeiner Form implementiert, so benötigen die übergeordneten Layer Zugriff auf die Definition (z. B. VPC-ID) der untergeordneten Layer. Hier **KANN** man den Remote-State auf diese Weise lesen:

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

Aus dem eigenen Terraform Modul referenziert man VPC-id aus dem anderen State per `vpc_id = data.terraform_remote_state.our_vpc.outputs.aws_vpc.main_vpc`.

> Mittlerweile versuche ich das zu vermeiden. Das erfordert den Zugriff auf dieses Statefile (den mir der Verantwortliche evtl. gar nicht geben mag - State enthält sensitive Daten - Separation of Concerns) und Refactorings wirken sich direkt aus ... ziehen einen Rattenschwanz hinter sich her (häufig tut man es dann nicht). Stattdessen versuche ich weitestgehend Data-Sources zu verwenden, um Informationen direkt aus den deployten Infrastruktur-Komponenten auszulesen. Diese Schnittstelle ist deutlich stabiler und offenbart zudem keine Internas nach außen. Lese ich einen Remote State, dann kann ich ALLES lesen ... nicht nur den Public-Teil.

## Import

* [import Kommando](https://www.terraform.io/cli/import)
* [Importing Existing Infrastructure Into Terraform – Step by Step](https://spacelift.io/blog/importing-exisiting-infrastructure-into-terraform)

In Migrationsprojekten (hin zu Terraform) oder wenn der Terraform-Provider nun eine weitere Ressource unterstützt kann es erforderlich sein, eine bisher nicht über Terraform gemanagte Ressource per `terraform import` in den State zu übernehmen, um sie nicht löschen und neu anlegen zu müssen. Hier gibt es zwei Möglichkeiten:

* **Option 1:** `terraform import` Kommando
  * das `terraform import` Kommando bringt die Ressource allerdings nur in den Terraform-State. Ein `terraform state show` zeigt sie aber schon mal an und ein `terraform destroy` könnte sie damit also auch löschen. ABER: damit die Ressource beim nächsten terraform plan/apply nicht gleich wieder gelöscht wird, muss entsprechender Terraform Code manuell erstellt werden
* **Option 2:** [`import` Directive](https://developer.hashicorp.com/terraform/language/import)
  * der Vorteil dieses Ansatzes ist, dass man sich den Terraform Code durch ein `terraform plan -generate-config-out=generated-resources.tf` seit Terraform 1.5 [generieren lassen kann](https://developer.hashicorp.com/terraform/language/import/generating-configuration)

## Import am Beispiel GitHub

* [Beispiel 1](https://wahlnetwork.com/2020/09/01/using-terraform-to-manage-git-repositories/)
* [Beispiel 2](https://nakamasato.medium.com/how-to-start-managing-github-repository-and-branch-protection-by-terraform-a7a1ae24d8b)

Zunächst legt man die Resource `module.repositories.github_repository.football` im Terraform-Code an . Anschließend kann man das Repository `football` (https://github.com/football) per

```bash
terraform import module.repositories.github_repository.football football
```

importieren. Damit hat man das Repo und seine Metadaten unter Terraform-Control ... nicht aber die Branches, die per `terraform import github_branch.football terraform:feature-branch:master` importiert werden müssen. I. a. will man nur einzelne Branches unter Terraform-Control stellen, um dort die Permissions (über Teams), Branch-Protection für eine handvoll langlebiger Branches (`master`, `development`, ...), ... zu pflegen. Feature/Bugfix-Branches werden von den Entwicklern selbst maintained (angelegt/gelöscht).

---

# State-Speicherung auf AWS S3

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

## Locking

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

---

# VSCode Integration

Visual Studio Code ist DER Editor meiner Wahl und natürlich editiert man heutzutage keinen Code ohne

* Auto-Vervollständigung
* Syntax-Highlightning
* Syntax-Check

---

# Code Formatierung

Ich hasse diese elenden Diskussionen zur Codeformatierung. Das will jeder anders haben und letztlich spielt es keine Rolle solange die Formatierung brauchbar ist. Einheitlichkeit ist mir lieber als persönliche Vorlieben. Deshalb verwende ich `terraform fmt` zur Formatierung ... keinen anderen Schnick-Schnack.

## Automatisierung

Am besten verwendet man [Git-Pre-Commit-Hooks](https://githooks.com/), um den Terraform-Code (am besten grundsätzlich alle Codes) zu validieren und formatieren.

> ACHTUNG: wenn nicht alle Entiwckler die gleichen Pre-Commit-Hooks verwenden, dann kann das zu großen Problemen führen, weil sich Formatierungsänderungen mit Refactorings mischen.

---

# Refactorings

Nach einem Refactoring sollte man immer ein `terraform get` machen, da beispielsweise ein Umbenennen eines lokalen Moduls im `.terraform/modules/modules.json` repräsentiert werden muss. Ansonsten scheitern `terraform plan` und/oder `terraform apply`.

Man sollte sich angewöhnen, vor dem `terraform apply` ein Backup vom State zu machen. Am besten man legt den State auf S3 ab - das Einschalten der Versionierung NICHT VERGESSEN (ich glaube das ist nicht die Standard-Einstellung!!!).

## Monolithen-Module refactorn

* [howto](https://learn.hashicorp.com/tutorials/terraform/organize-configuration?in=terraform/modules)

---

# Debugging

Per `export TF_LOG=TRACE` lässt sich der `terraform`-Kommando Aufruf maximal gesprächig machen. Darin sieht man dann sogar die Requests/Reponses, die die Provider an die Remote-API versenden.

Alle Log-Levels (nach Gesprächigkeit abfallend):

* TRACE
* DEBUG
* INFO
* WARN
* ERROR <=== Default

Durch Setzen von `export TF_LOG_PATH=/tmp/terraform.log` lässt sich der verbose Logtext in eine Datei umleiten und an der Console sieht man nur noch das Nötigste (was man bei `ERROR` sieht).

> Die Debugging-Möglichkeiten erinnern eher an die 1980er Jahre ... da ist man in 2020 eigentlich anderes gewohnt.

## Terraform Console

Bei `terraform console` handelt es sich um eine CLI-Tool (im weitesten Sinne eine "Entwicklungsumgebung"), mit dem man leicht Terraform Expressions testen kann. Auf diese Weise kann man den aktuellen State sehr schön analysieren (anstatt per `terraform show` ALLE Ressourcen auf einmal angezeigt zu bekommen), indem man sich eine Ressource ausgeben lässt.

Ausserdem lassen sich auf diese Weise Expressions (z. B. Inline `for` zur Transformation von Datenstrukturen) schön testen.

---

# Provisioning von Servern

* [Supported Provisioning-Ansätze](https://www.terraform.io/docs/provisioners/index.html)

Terraform ist geeignet, um die Infrastruktur bereitzustellen und verschiedene Infrastrukturkomponenten ineinander zu stöpseln.

Software-Installationen und -Konfigurationen werden i. a. nicht mit Terraform abgebildet, sondern per

* [Packer](packer.md) (vorkonfigurierte Images)
* Konfiguration-Management-Tools wie Ansible, Puppet, Chef, ...
* Cloud-Init-, User-data-Skripte

Terraform ist für Software-Deployments nicht unbedingt der geeignete Ansatz ... auch wenn es geht (z. B. mit den `provisioners` Direktive). Allerdings 

* liegen Software-Komponenten auf einem höheren Layer ... sie basieren auf der Infrastruktur, die Terraform bereitstellt
* diese Software-Komponenten haben i. a. einen anderen Release-Lifecycle, einen anderen Owner und andere Trigger-Events

Man kann vieles auch in Terraform machen ... aber man sollte nicht alles machen, was geht. Das sieht man sehr schön, wenn man eine Python-AWS-Lambda deployen will. Das erste Deployment funktioniert problemlos:

```
resource "aws_lambda_function" "hello_world" {
  runtime       = "python3.8"
  function_name = "hello-world-python"
  handler       = "hello-world.lambda_handler"
  filename      = "${path.module}/../hello-world-python/hello-python.zip"
}
```
 Wenn man dann aber Änderungen am Code vornimmt, dann werden die aber nicht deployed, weil Terraform keine Änderung erkennt. Der Zustand des `hello-world.py` ist einfach nicht im Terraform State. Mit folgendem Trick kann man das ändern. Nach `filename` fügt man noch folgende Zeile ein:

 ```
  source_code_hash = filebase64sha256("${path.module}/../hello-world-python/hello-python.zip")
``` 

Nun ist der `source_code_hash` (ein Fingerprint des `hello-python.zip`) Teil des Terraform State und wenn sich daran was ändern, dann bekommt Terraform das auch mit und deployed den geänderten Source Code.

## provisioners

> Dieser Ansatz sollte die letzte Option sein ([Provisioners are a Last Resort](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#provisioners-are-a-last-resort)), da Terraform für Konfiguration-Management und Deployment von Software Komponenten nicht die erste Wahl ist.

---

# Terraform Versionen

In den 0.x Tagen von Terraform war es unabdingbar, dass der State zur Terraform Version passte. Das hat - wenn terraform plan/apply nicht durch einen automatisierten Workflow, sondern auf Entwickler Maschinen ausgeführt wurde - unweigerlich zu Problemen geführt.

Hier hat es sich als hilfreich erwiesen eine Datei `.terraform-version` im Root Verzeichnis zu hinterlegen, um das explizit zu dockumentieren. Tools wie `tfenv` (siehe unten) sorgen dann dafür, dass die richtige Terraform Version notfalls installiert wird und verwendet wird.

> Mit der Version 1.x ist es nicht mehr unbedingt erforderlich genau die gleiche Version zu verwenden.

Das hört sich einfacher an als es in Wirklichkeit ist - keine Rocket-Science, aber es erfordert Disziplin, wenn man beispielsweise verschiedene Deploy-Stages hat, die absichtlich mit unterschiedichen Terraform-Versionen betrieben werden. Terraform wird nämich das State-File auf die höchste Version migrieren und damit ist der State für ältere Versionen evtl. nicht mehr zu gebrauchen. Am besten führt man die Terraform-Kommandos nicht von einem frei-konfigurierbaren Rechner aus (also nicht von einem Entwickler-Laptop), sondern von einem CI/CD-Server wie beispielsweise einem [Jenkins-Server](jenkins.md). Dadurch wird dann auch sichergestellt, dass der Rollout-Prozess immer mit der gleichen Qualität ausgeführt wird.

## tfenv

Mit [tfenv](https://github.com/tfutils/tfenv) hat man ein Tool, das die `.terraform-version` ausliest und bei Bedarf die Terraform Version switched oder sogar die passende Terraform Version installiert.

Das vereinfacht die Nutzung ungemein.

> Grundsätzlich bin ich aber ein Freund der Automatisierung und würde am liebsten vollständig auf die lokale Ausführung verzichten.

---

# Terraform Enterprise

Hat folgende zusätzliche Features

* Berechtigungen
* Workflows
* [Auditierung](https://www.terraform.io/docs/enterprise/private/logging.html#audit-logs)
  * wer hat wann was geändert

## Workspace

Ein Workspace umfaßt

* Terraform Konfiguration
* Variablen
* State
* Logs

> "We recommend that organizations break down large monolithic Terraform configurations into smaller ones, then assign each one to its own workspace and delegate permissions and responsibilities for them. TFE can manage monolithic configurations just fine, but managing smaller infrastructure components like this is the best way to take full advantage of TFE's governance and delegation features. For example, the code that manages your production environment's infrastructure could be split into a networking configuration, the main application's configuration, and a monitoring configuration. After splitting the code, you would create "networking-prod", "app1-prod", "monitoring-prod" workspaces, and assign separate teams to manage them. Much like splitting monolithic applications into smaller microservices, this enables teams to make changes in parallel. In addition, it makes it easier to re-use configurations to manage other environments of infrastructure ("app1-dev," etc.)."

Ein Workspace referenziert ein VCS ... hier gibt es unterschiedliche Organisationsformen für die verschiedenen Umgebungen (Environment = Workspace, DEV - TEST - LIVE), die man unterhalten muß:

* [Repository Struktur](https://www.terraform.io/docs/enterprise/workspaces/repo-structure.html)

## Workflow

* [UI/VCS-driven run workflow (DEFAULT)](https://www.terraform.io/docs/enterprise/run/ui.html)
* [API-driven run workflow](https://www.terraform.io/docs/enterprise/run/api.html)
* [CLI-driven run workflow](https://www.terraform.io/docs/enterprise/run/cli.html)

---

# Terraform vs. Vagrant

[Vagrant](vagrant.md) ist eher für den kleinen lokalen Einsatz gedacht ... Entwicklungsumgebungen automatisieren - keine komplexen Landschaften (ganze Datacenter). Entwicklungsumgebungen verwenden andere Ansätze (z. B. Shared Folder) als komplexe remote Enterprise Umgebungen.

ABER: ganz grundsätzlich falsch ist es nicht, daß die beiden Tools ähnlich sind.

---

# Best Practices

## Use Modules

"[...] to limit the scope of potential changes" ([Terraform Doku](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules))

## No Nested Modules

"We started nesting modules inside other smaller modules. Updating code or resolving conflicts in the matryoshka doll structure became a nightmare." [Regis Wilson](https://medium.com/driven-by-code/the-terrors-and-joys-of-terraform-88bbd1aa4359)

## terraform state mv

* [Dokumentation](https://www.terraform.io/cli/commands/state/mv)

Wenn man interne Refactorings an Terraform-Code vornimmt, dann sollte man verhindern, daß Ressourcen gelöscht und neu angelegt werden ... nur weil man den Code restrukturiert hat (z. B. neue Module eingeführt) oder Ressourcen umbenannt hat.

> "When you create modules from already existing infrastructure, your resource's IDs will change. Because of this, you must let Terraform know that you intend to move resources rather than replace them, or Terraform will destroy and recreate your resources with the new ID. In previous versions of Terraform, you would use the `terraform state mv` command to individually move your resources to their new module address so Terraform can correctly track the infrastructure." ([Terraform Doku](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules))

Bewertung des `terraform state mv` Ansatzes:

* Vorteile
  * einfach zu nutzen
  * Lock-Support, denn vor jedem Kommando wird ein Lock angefordert und anschließend wieder gelöscht
* weiss-noch-nicht
  * es wird der Remote State verändert
* Nachteile:
  * jedes Kommando wird atomar abgebildet und schreibt somit eine eigene neue Version des Statefiles. Hat man den State in S3, dann bedeutet das einen Network-Full-Roundtrip (langsam) und **VOR ALLEM** noch zig neue Versionen des Statefiles ... das will man eigentlich nicht.

> Man kann den State auch durch Download und Upload des terraform Statefiles (JSON Format) erreichen ... dann kann man diese beiden angesprochenen Problem lösen. Allerdings rät HashiCorp davon explizit ab "While the format of the state files are just JSON, direct file editing of the state is discouraged." ([Hashicorp Doku](https://developer.hashicorp.com/terraform/language/state))

Alternativ ([hier beschrieben](https://support.hashicorp.com/hc/en-us/articles/4418624552339-How-to-Merge-State-Files)) kann man das Statefile mit einem `terraform state pull > /tmp/source.tfstate` runterladen und dann via `terraform state mv --state=/tmp/source.tfstate -state-out=/tmp/destination.tfstate module.bar prefixed.foo.me.module.bar` verschieben und dabei umbenennen ... so kann man natürlich auch Statefiles mergen. Das muss man dann für jede Top-Level Resource machen ... am besten Scripten. BEACHTE: hier arbeitest Du lokal auf den Files ... du hast also alles unter Kontrolle.

> **ACHTUNG:** beim Mergen muss man aufpassen, dass jeder Resourcenname unique sein muss und zudem dann natürlich zum Code passen muss, der dann später auf diesem State einen Terraform-Plan erstellt.

Alternativ kann man `moved` Direktiven verwenden. Diese Refactoring-Hints kann man auch [in Code packen](https://learn.hashicorp.com/tutorials/terraform/move-config?in=terraform/modules#move-your-resources-with-the-moved-configuration-block) - [YouTube - Using Moved Blocks in Terraform](https://www.youtube.com/watch?v=fDPB7xbckVM):

```hcl
moved {
  from = aws_instance.example
  to = module.ec2_instance.aws_instance.example
}
```

Insgesamt gestaltet sich dieses Vorgehen mühselig und fehleranfällig. Hier sollte Hashicorp dringend nachbessern. Ich erwarte hier eigentlich Refactoring-Tools, die sich ähnlich leicht bedienen lassen wie in einer IDE beim Refactoring von Code beliebiger Hochsprachen. Zumal man auf dieser Ebene keine a-priori-Tests hat und jede einzelne Änderungen kritisch beäugen muss ... im worst-case zerstört man sich so die LIVE-Umgebung und es kommt zur Downtime. 

## Loops

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

# Kritische Betrachtung

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

## Refactorings

Nach einem refactoring sollte man immer ein `terraform get` machen, da beispielsweise ein Umbenennen eines lokalen Moduls im `.terraform/modules/modules.json` repräsentiert werden muss. Ansonsten scheitern `terraform plan` und/oder `terraform apply`.

Mit dem GitHub-Provider hatte ich lokale Modules verwendet, um das Usermanagement in einer GitHub-Organization abzubilden. Eine Umbenennung (ein internes Refactoring) des Moduls `organization` nach `usermanagement` führte allerdings dazu, daß die User gelöscht und neu angelegt wurden. Leider ist diese Aktion nicht Seiteneffektfrei:

* die wurden nicht einfach neu angelegt, sondern erhielten neue Einladungen, die sie erst explizit bestätigen mußten, um wieder Teil der Organisation zu werden
* mein Skript lief nicht fehlerfrei durch (ich hatte nach dem Refactoring `terraform get` vergessen) und so was das Löschen ausgeführt, aber das Anlegen nicht - im worst-case hätte das zu Downtimes für einzelne User geführt

Wer weiß welche Seiteneffekte ich nicht bemerkt habe ...

Refactorings sind in Infrastruktur häufig nicht Seiteneffektfrei wie [in diesem humorvollen Terraform-Artikel beschrieben](https://medium.com/driven-by-code/the-terrors-and-joys-of-terraform-88bbd1aa4359).

## Automated Workflows - auf JEDEN Fall

Aus meiner Sicht sollten Infrastruktur-Änderungen **IMMER** über einen automatisierten Rollout mit Review-Zwang laufen. Die Pläne **MÜSSEN** sorgfältig gelesen und verstanden werden.

Der Rollout (`terraform apply`) von einer lokalen Maschine ist natürlich verlockend, doch sind die möglichen Probleme weitreichend. Wie schnell hat man die falsche Terraform Version verwendet oder den falschen AWS-Account konfiguriert? Zumindest bis zum `terraform plan` sollte man alles lokal machen können, da es die Fehlersuche und die Feedbackschleife deutlich verbessert. Das `terraform apply` sollte aber nicht lokal laufen ... zumindest nicht für kritische Komponenten.