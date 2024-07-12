# Amazon Web Services

Amazon war der Vorreiter des heutigen _Cloud Computings_ (ca. im Jahre 2005). Heutzutage führt fast kein Weg daran vorbei (es gibt viele Cloud-Anbieter). Der Vorteil ist besteht in

* schnelle (dynamische) Bereitstellung von Ressourcen
* up-/downscaling zur Kostenoptimierung
* serverless computing
* exzellente Komponenten und Tooling, um den gesamten Softwareentwicklungszyklus zu unterstützen

Während man früher nur als Großunternehmen relevante Software bereitstellen konnte, ist das heute bereits Ein-Mann-Startups möglich. Der Grund liegt vor allem in:

* Abstraktion
* bereitgestellte Services
  * man kann sehr leicht mit anderen Lösungen experimentieren - anschließend kann man seine Lösung migrieren und sich dabei auf die Applikationen fokussieren, ohne ein Infrastruktur-Projekt vorab finalisieren zu müssen. Das bringt Agilität und Innovation.
* Kostenoptimierung
* "unendliche" Ressourcen, die SOFORT verfügbar sind

AWS betreibt hierzu riesige Data-Centers, die die Ineffizienz eines eigenen Data-Centers (geplant für Peaks) durch On-Demand-Verteilung auf eine Vielzahl von Kunden lösen. Hätte jeder Kunden zur gleichen Zeit den Peak, dann wäre auch das AWS-Data-Center am Ende. Da das aber super unwahrscheinlich ist, funktioniert das Konzept eines "moderaten" Data-Centers, das über smarte Lösungen auf Effinzienz getrimmt ist. Auf diese Weise entsteht eine Win-Win-Situation.

Das führende Konzept im AWS-Umfeld ist die Abstraktion. Verschiedene AWS-Produkte bieten unterschiedliche Abstraktionslevel. Auf niedrigstem Abstraktionslevel hat man EC2 Instanzen, die man vollständig in seinem VPS kontrollieren kann, auf höchstem Abstraktionslevel hat man serverless Lambdas, die zwar auch auf EC2 abgearbeitet werden ... aber man muss sich nicht darum kümmern. Über das schlanke WebUI der Admon Console lassen sich die Services konfigurieren.

> Serverless ist ein gutes Beispiel für eat-your-own-dogfood. AWS bildet hier eine Abstraktionsebene, die darunter existierende Produkte (z. B. EC2) verwendet. Hier wird auch deutlich, dass AWS nicht **DIE** Platform ist, sondern weitere Abstraktionen ermöglicht und auch fördert. Dem Platform Engineering, mit dem ich mich derzeit beschäftige, könnte man entgegnen, dass AWS doch die Platform ist. Ja, AWS ist eine Platform. Doch die Anwendungslandschaft eines Unternehmens bietet evtl. weitere sinnvolle Möglichkeiten zur Abstraktion aufbauend auf der AWS-Platform.

Verwendet man Infrastructure-as-Code, dann kommen mit terraform-module, Helm-Charts, ... weitere Abstraktionslayer dazu. Auf diese Weise lassen sich komplexe Lösung mit wenigen Zeilen Code (= Konfiguration) abbilden.

Ganz grundsätzlich hat man im Cloud-Computing nur relativ wenig unter Kontrolle. Das Shared-Responsibility Model regelt für welche Aspekte AWS zuständig ist und für welche der Kunde (Applikationsentwickler). Meistens bleibt die Verantwortung des Kunden auf einem hohen Abstraktionslevel, so dass sich die darunterliegende Platform verändern kann, ohne dass der Kunde etwas bemerkt. Abstraktion reduziert die Komplexität auf ein Minimum und macht es handelbar für die Nutzer.

Cloud-Computing ermöglich Pay-as-you-Go, d. h. die Ressourcen von AWS im Datacenter sind nahezu unerschöpflich und der Kunde zahlt nur, was er nutzt. Bei einem OnPrem-Ansatz muss man eine sehr sorgfältige Ressourcenplanung machen, die auch Peak-Zeiten abdecken muss. Auf diese Weise entstehen häufig Hardware-Anforderungen, die man in 99% gar nicht benötigt. Zudem muss die Hardware alle 3-5 Jahre erneuert werden - hier sind Migrationen erforderlich. All die Dinge sorgen für Investitions- oder Projektkosten, die in der Cloud nahezu komplett entfallen.

---

# Getting Started

* [AWS Account anlegen](https://aws.amazon.com)
  * 12 Monate kostenlos, wenn man nur `t2.micro` Instanzen startet
    * man muß aber AUF JEDEN FALL eine Kreditkarte hinterlegen
  * auf jeden Fall sollte man ein [Budget und Notifications](https://console.aws.amazon.com/billing/home?#/preferences) definieren, um keine bösen Überraschungen zu erleben
* Image aussuchen
* Instanz `t2.micro` (ist im kostenlosen Paket enthalten) starten (z. B. `ubuntu-xenial-16.04-amd64-server-20180814`)
  * hierbei kann man einen SSH-Schlüssel generieren lassen bzw. einen schon vorhandenen Schlüssel verwenden
    * der private Teil muß runtergeladen und in `~/.ssh/foo.pem` mit den Berechtigungen `400` abgelegt werden. Folgende `~/.ssh/config` anlegen:

```properties
Host    foo
    Hostname    ec2-18-222-xyz-ij.us-east-2.compute.amazonaws.com
    User ubuntu
    IdentityFile    ~/.ssh/foo.pem
    IdentitiesOnly yes
```

* per `ssh foo` eine ssh-Console starten
* ready to use

## Getting Started with Docker, maven, Java

Aufsetzend auf dem AMI `Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-0552e3455b9bc8d50` konnte ich eine Entwicklungsumgebung innerhalb von 5 Minuten folgendermaßen aufsetzen:

```bash
ssh foo
sudo bash
apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce
apt-get install docker-compose
usermod -aG docker ubuntu
apt-get install openjdk-8-jdk
apt-get install maven
```

Die von meinen Docker Services bereitgestellten Ports mußten dann noch über die AWS-Management-UI als Inbound Rules der Security Group eingetragen werden.

---

# Migration nach AWS

Unternehmen, die aus der OnPrem-Welt kommen, müssen ihre Lösungen (sofern sie keine hybride Cloud betreiben wollen) in die Cloud migrieren. Der gängigste Ansatz ist ein Lift-and-Shift-Ansatz. Hierbei wird die existierende Lösung nahezu 1:1 in der Cloud abgebildet. Auf diese Weise kann die Migration relativ schnell erfolgen, ohne sie mit einem Redesign der Lösungen zu verknüpfen. Dadurch erreicht man eine schnelle Ablösung der OnPrem Infrastruktur, doch auf Kosten einer Applikationslandschaft, die noch auf OnPrem zugeschnitten ist. Im nachhinein sollte man die Lösungen refactorn, um den Nutzen der Cloud wirklich spüren zu können. Bei diesem Ansatz basieren die Lösungen dann auf einem statischen statt elastischen Setup und dadurch sind die Runtime-Kosten deutlich höher als OnPrem. Zudem können selbstentwickelte Komponenten durch AWS-Produkte abgelöst werden.

Die Migration ist in den meisten Unternehmen wahrscheinlich eine lange Reise, die i. a. Jahre dauert.

---

# Templates

Manuelles Zusammenclicken einer ganzen Landschaft ist aufwendig und fehleranfällig ... insbesondere für Newbies. Entweder macht man das

* automatisiert per 
  * [terraform](terraform.md)
  * oder Cloudformation 
* interaktiv über die AWS-WebUI, indem man ein Template auswählt

---

# Kosten

Zum Ausprobieren kann man sich einen kostenlosen (12 Monate) Free-Tier-Account anlegen. Will man aber Business auf der Platform betreiben, dann möchte man natürlich wissen, welche Kosten auf einen zukommen. Leider ist das allerdings nicht ganz einfach ... erstens muß man natürlich wissen, welche Last man bewältigen muß und zweitens muss man sich mit den AWS Tools ganz gut auskennen, um wirklich zuverlässige Zahlen zu bekommen.

## Cost Explorer

Hier kann man den aktuellen Verbrauch, den historischen und einen Forecast sehen. Man kann hier jede Menge filtern und gruppieren.

---

# Konzepte

## Oranisationsebenen

* [Konzept Regionen und Availability Zones](https://docs.aws.amazon.com/de_de/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)

* manche Services sind Global, d. h. die Ressourcen existieren in diesem Account nur ein einziges Mal (z. B. IAM)
* alle Regionen sind unabhängig voneinander und man muß bei der Nutzung der AWS Console (Web-UI) die entsprechende Region auswählen
* Region (z. B. us-east-1, us-east-2, us-west-1, eu-west-1)
  * jede Region ist ein unterschiedlicher geografischer Bereich
  * in jeder region gibt es wiederum mehrere physisch isolierte Standorte (Availability Zones)
    ** us-east-1a
    ** us-east-1b
    ** ...
    ** us-east-1f
  * in jeder Availability Zone gibt es zumeist mehrere Data-Center
* Edge Locations: AWS unterstützt sog. Edge-Locations, die zum Cachen von Ressourcen nah (Reduktion der Latency) beim Enduser genutzt werden (z. B. von CloudFront). AWS kümmert sich hier um die Replikation über sein schnelles Backbone-Netz

## ELB - Elastic LoadBalancer

* [siehe in separater Seite](proxy.md)
* [AWS - ELB](https://aws.amazon.com/de/elasticloadbalancing/)

In AWS ist die Elastizität der große Vorteil. Man kann nach Bedarf weitere Instanzen hochfahren und wieder runterfahren. Davon soll der Kunde nichts mitbekommen. Das funktioniert natürlich nur, wenn die Services im Backend für den Nutzer verborgen sind. AWS bewerkstelligt das mit sog. Loadbalancern (z. B. Application Loadbalancer), mit dem der Nutzer kommuniziert. Im Hintergrund werden die Requests an die aktuell existierenden und gesunden Backend Services weitergeleitet. Die Antworten gehen dann wiederum durch den Loadbalancer zum Nutzer zurück.

Auf diese Weise werden Ausfälle von Services (z. B. EC2) in Availability-Zones-under-Maintenance oder auch die Elastizität verborgen. Der ELB ist highly-scalable und hochverfügbar - managed von AWS selbst ... hier kann nichts schiefgehen, wenn man die Ressourcen im Hintergrund sinnvoll auf Availability-Zones verteilt hat. Health-Checks sind hier ganz enstcheident, denn der ELB entscheidet mit diesen Informationen welche Komponenten im Backend für die Requestverarbeitung genutzt werden. Eine neue EC2 Instanz ist vielleicht schon hochgefahren, aber die Applikation steht evtl. noch nicht zur Verfügung (weil die Initialisierung länger dauert). Dem Nutzer soll ein zuverlässiger Dienst angeboten werden ... deshalb muss hier alles sauber funktionieren.

Man kann private und public Loadbalancer haben. Ein public Loadbalancer bekommt eine Public-IP-Adresse, einen DNS-Eintrag und wird mit dem Internet-Gateway verbunden, so dass der Traffic aus dem Internet auch in die Subnetze geroutet werden kann.

Ein ELB hat folgende Komponenten:

* Port (und IP-Adresse)
* Target-Group
  * Backend Ressourcen, die vom ELB verborgen werden
* Routing-Rules
  * hier kann man die URL-Paths verwenden, um Requests unterschielich zu routen
  * darüber lassen sich auch Sticky-Sessions abbilden

Amazon bietet folgende Arten von Loadbalancers:

* Application Load Balancer
  * arbeitet auf HTTP/HTTPS-Ebene (Layer 7)
  * unterstützt die Terminierung der SSL-Verbindung
  * unterstützt Sticky-Sessions über Cookies, die vom Load-Balancer generiert werden
    * im elastischen Umfeld will man aber eigentlich auf Stickiness verzichten
  * Routingoptionen
    * host-basiert
      * es könnte sein, daß mehrere Domains auf einen Loadbalancer geroutet werden (über DNS), dann kann der ELB über den Hostnamen ein entsprechendes Routing anbieten
    * pfad-basiert
* Network Load Balancer

## Availability Zones

* [AWS Regions and Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

Amazon muß natürlich auch selbst mal Wartungsarbeiten durchführen (oder hat auch mal ungeplante Ausfälle, z. B. durch Brand) und damit Infrastruktur vom Netz nehmen. Amazon empfiehlt die Verwendung von drei sog. Availability Zones und garantiert, daß IMMER mind. eine verfügbar ist. Bei der Verteilung der Microservices auf die verschiedenen Zones sollte man also **darauf achten, daß in jeder Zone mind. ein Knoten jedes Services deployed ist**.

Der Elastic Load Balancer (ELB), der häufig der einzige öffentliche Zugangspunkt für Requests ist, sorgt dafür, daß die Requests aus dem Internet in die tatsächlich verfügbare Availability Zones delegiert werden und so keine Requests verlorengehen.

Eine Region (z. B. eu-central-1) hat mind. 3 Availability-Zones (z. B. eu-central-1a, eu-central-1b, eu-central-1c) - Regionen und Availability Zones sind voneinander isoliert, so daß der Ausfall einer Region/Zone keinen Einfluß auf andere hat. Die Entfernung zwischen Client und Server entscheidet letztendlich über die Signallaufzeit und hat somit entscheidenden Einfluß auf die zu erwartende Latenz. Deshalb wird man versuchen, die Nutzer aus verschiedenen Regionen (z. B. eu-central-1, eu-west-1, us-east-1) zu bedienen.

## Auto-Scaling-Group (ASG)

Vorteil einer Cloud-Lösung gegenüber Bare-Metal ist, daß die Cloud-Lösung on-demand skaliert werden kann. Eine Auto-Scaling-Group übernimmt die automatische horizontale Skalierung der Instanzen, d. h. man gibt z. B. an, daß man

* mind. 2 Instanzen
* max. 10 Instanzen

laufen lassen will. Die ASG sorgt dann aufgrund von Lastmetriken und Healthchecks für die automatische Erzeugung/Zerstörung von Instanzen. Auf diese Weise kann man dynamisch auf Lastspitzen reagieren, ohne die Kosten aus dem Ruder laufen zu lassen (denn die Instanzen werden auch reduziert, wenn keine Last anfällt).

Eine ASG braucht ein Launch-Template, um zu wissen welche EC2 Instanzen erzeugt werden sollen. Die Konfiguration des Launch-Templates ist natürlich sehr ähnlich zur Konfiguration einer neuen EC2 Instanz (Instanz-Typ, Security-Group, EBS-Volume, IAM-Role, ...).

Die ASG muss angelegt werden und benötigt dazu folgende Informationen:

* das VPC
* Availability-Zones
* das Launch-Template
* ELB + TargetGroup
* Skalierungsparameter (z. B. minimum 2 Instanzen, maximum 10 Instanzen)
* HealthChecks
* ScalingPolicy
  * hier kann man besipielsweise auch CloudWatch Metriken zur Skalierungsentscheidung verwenden (z. B. CPU-Usage)

---

# S3

* [aws-s3.md](aws-s3.md)

Dieser Dienst bietet einen File-Server in Form von sog. S3-Buckets. Der Names des Buckets muß global eindeutig sein.

---

# Monitoring

Verwendet man AWS-Services wie S3, RDS, ... so erfolgt das Monitoring über AWS-Cloudwatch, das ähnlich zu [Instana](instana.md) ist. Basierend auf einer Baseline, die den Normalzustand (Healthy-State) repräsentiert, definiert man Alarme für den Fall, dass Metriken einer Ressource/Anwendung signifikant vom Normalzustand abweichen. Das sind dann Indikatoren, dass der Kunde evtl. bereits Probleme feststellt oder bald feststellen wird.

Die Messpunkte werden in einer Timeseries-Datenbank gesammelt und mit Tooling visuell dargestellt (in sog. Dashboards, die man sich selbst zusammenstellen kann). Alarme sorgen dafür, dass niemand die Graphen überwachen muss.

AWS kann natürlich nur ganz allgemeine Metriken seiner Services überwachen. Die Applikationsentwickler können das Monitoring signifikant verbessern indem sie Applikationsspezifische KPIs nach Cloudwatch reporten und in das Monitoring einhängen.

## CloudWatch

* [Cloudwatch in AWS Console](https://console.aws.amazon.com/cloudwatch)

CloudWatch ist die AWS-interne Monitoring Lösung mit Metrics-Collection, Alarms, Notifications, Self-Healing, ...

## Instana Integration

Verwendet man [Instana](instana.md), so möchte man die Monitoring-Daten zentral in Instana sammeln. Hierzu muß man eine AWS-Cloudwatch-Instana-Bridge verwenden, die die Daten von Cloudwatch ausliest und nach Instana transferiert. Hierbei werden die REST-Interfaces genutzt.

---

# Logging

via Cloudwatch

---

# Shared Responsibility Model

* [AWS - Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)

AWS bietet die Platform, auf der die Kundenlösungen aufsetzen. AWS hat seinen Teil zu einem sicheren und zuverlässigen Betrieb sicherzustellen (z. B. dass die Festplatten funktionieren, die Hypervisor-Technologie mit den letzten Security-Patches laufen oder die SDKs mit den sicheren Library-Versionen laufen) aber der Kunden hat auf SEINEM Layer die Verantwortung dafür zu übernehmen (z. B. dass die EC2-System mit den latest Security-Patches laufen oder welche Benutzergruppen Zugriff auf bestimmte Ressourcen bekommen).

---

# FAQ

*Frage 1:* Ich habe ein Key-Pair generiert bekommen mit PuTTY aber keinen Zugriff hin - was mache ich falsch?
*Antwort 1:* PuTTY verwendet ein anderes Format für den Private Key - nämlich `ppk`. Deshalb muß man den `pem`-encoded Schlüssel per PuTTYgen in ein `ppk` konvertieren. Das kann man dann bei der ssh-Authentifizierung von PuTTY verwenden - [siehe Doku](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console)

*Frage 2:* Ich habe ein Key-Pair generiert und den private Key runtergeladen - wie komme ich an den Public Key ran?
*Antwort 2:* Der Public Key wird automatisch in dem erstellten Image beim entsprechenden User unter `~/.ssh/authorized_keys` eingetragen. Sollte man das Image gelöscht haben, will den Key aber für ein anderes Image wiederverwenden (und manuell in `~/.ssh/authorized_keys` eintragen), dann kann man aus dem Private Key den Public Key erzeugen per `ssh-keygen -y -f publicKey.pem`.
