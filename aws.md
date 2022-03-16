# Amazon Web Services

Amazon war der Vorreiter des heutigen _Cloud Computings_ (ca. im Jahre 2005). Heutzutage führt fast kein Weg daran vorbei (es gibt viele Cloud-Anbieter). Der Vorteil ist besteht in

* schnelle (dyniamische) Bereitstellung von Hardware
* exzellente Komponenten und Tooling, um den gesamten Softwareentwicklungszyklus zu unterstützen

Während man früher nur als Großunternehmen relevante Software bereitstellen konnte, ist das heute bereits Ein-Mann-Startups möglich.

---

## Getting Started

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

### Getting Started with Docker, maven, Java

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

## Kosten

Zum Ausprobieren kann man sich einen kostenlosen (12 Monate) Free-Tier-Account anlegen. Will man aber Business auf der Platform betreiben, dann möchte man natürlich wissen, welche Kosten auf einen zukommen. Leider ist das allerdings nicht ganz einfach ... erstens muß man natürlich wissen, welche Last man bewältigen muß und zweitens muss man sich mit den AWS Tools ganz gut auskennen, um wirklich zuverlässige Zahlen zu bekommen.

### Cost Explorer

Hier kann man den aktuellen Verbrauch, den historischen und einen Forecast sehen. Man kann hier jede Menge filtern und gruppieren.

### CloudWatch

* [Cloudwatch in AWS Console](https://console.aws.amazon.com/cloudwatch)

* Ressource Gruppen
  * per Region
* Dashboard mit Widgets

---

## Konzepte

### Oranisationsebenen

* [Konzept Regionen und Availability Zones](https://docs.aws.amazon.com/de_de/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)

* alle Regionen sind unabhängig voneinander und man muß bei der Nutzung der AWS Console (Web-UI) die entsprechende Region auswählen
* Region (z. B. us-east-1, us-east-2, us-west-1, eu-west-1)
  * jede Region ist ein unterschiedlicher geografischer Bereich
  * in jeder region gibt es wiederum mehrere physisch isolierte Standorte (Availability Zones)
    ** us-east-1a
    ** us-east-1b
    ** ...
    ** us-east-1f

### Availability Zones

* [AWS Regions and Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html)

Amazon muß natürlich auch selbst mal Wartungsarbeiten durchführen (oder hat auch mal ungeplante Ausfälle, z. B. durch Brand) und damit Infrastruktur vom Netz nehmen. Amazon empfiehlt die Verwendung von drei sog. Availability Zones und garantiert, daß IMMER mind. eine verfügbar ist. Bei der Verteilung der Microservices auf die verschiedenen Zones sollte man also **darauf achten, daß in jeder Zone mind. ein Knoten jedes Services deployed ist**.

Der Elastic Load Balancer (ELB), der häufig der einzige öffentliche Zugangspunkt für Requests ist, sorgt dafür, daß die Requests aus dem Internet in die tatsächlich verfügbare Availability Zones delegiert werden und so keine Requests verlorengehen.

Eine Region (z. B. eu-central-1) hat mehrere Availability-Zones (z. B. eu-central-1a, eu-central-1b, eu-central-1c) - Regionen und Availability Zones sind voneinander isoliert, so daß der Ausfall einer Region/Zone keinen Einfluß auf andere hat. Die Entfernung zwischen Client und Server entscheidet letztendlich über die Signallaufzeit und hat somit entscheidenden Einfluß auf die zu erwartende Latenz. Deshalb wird man versuchen, die Nutzer aus verschiedenen Regionen (z. B. eu-central-1, eu-west-1, us-east-1) zu bedienen.

### Auto-Scaling-Group (ASG)

Vorteil einer Cloud-Lösung gegenüber Bare-Metal ist, daß die Cloud-Lösung on-demand skaliert werden kann. Eine Auto-Scaling-Group übernimmt die automatische Skalierung der Instanzen, d. h. man gibt z. B. an, daß man

* mind. 2 Instanzen
* max. 10 Instanzen

laufen lassen will. Die ASG sorgt dann aufgrund von Lastmetriken und Healthchecks für die automatische Erzeugung/Zerstörung von Instanzen. Auf diese Weise kann man dynamisch auf Lastspitzen reagieren, ohne die Kosten aus dem Ruder laufen zu lassen (denn die Instanzen werden auch reduziert, wenn keine Last anfällt).

---

## S3

Dieser Dienst bietet einen File-Server in Form von sog. S3-Buckets. Der Names des Buckets muß global eindeutig sein.

### Minio

* [Verwendung der aws-CLI](https://docs.minio.io/docs/aws-cli-with-minio.html)

Minio ist eine S3 kompatible Implementierung, die man beispielsweise in Hybrid-Szenarien (in denen sowohl AWS als auch Onprem supported werden muß) einsetzen kann. Minio kann über die `aws`-CLI mit der gleichen Konfiguration (in `~/.aws`) verwendet werden. Man muß nur per Parameter den Parameter `--endpoint-url`-Parameter verwenden, um den "S3"-Server zu definieren.

```bash
aws --profile play.min.io --endpoint-url https://play.min.io:9000 s3 ls
```

Bei dieser Verwendung werden weitere Konfigurationen (AWS-Credentials, Region des Buckets, ...) aus `~/.aws/config`

```ini
[play.min.io]
region = us-east-1
```

und `~/.aws/credentials`

```ini
[play.min.io]
aws_access_key_id = Q3AM3UQ867SPQQA4AAAA
aws_secret_access_key = zuf+tfteSlswRu7BJ86wekitnifILAaBbZbb
```

beigesteuert.

---

## Elastic Load Balancer (ELB)

* [siehe in separater Seite](proxy.md)
* [AWS - ELB](https://aws.amazon.com/de/elasticloadbalancing/)

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

Diese ELBs werden u. a. eingesetzt, um Verfügbarkeit durch Availability-Zones zu garantieren.

---

## Monitoring

Verwendet man AWS-Services wie S3, RDS, ... so erfolgt das Monitoring über AWS-Cloudwatch, das ähnlich zu [Instana](instana.md) ist.

### Instana Integration

Verwendet man [Instana](instana.md), so möchte man die Monitoring-Daten zentral in Instana sammeln. Hierzu muß man eine AWS-Cloudwatch-Instana-Bridge verwenden, die die Daten von Cloudwatch ausliest und nach Instana transferiert. Hierbei werden die REST-Interfaces genutzt.

---

## FAQ

*Frage 1:* Ich habe ein Key-Pair generiert bekommen mit PuTTY aber keinen Zugriff hin - was mache ich falsch?
*Antwort 1:* PuTTY verwendet ein anderes Format für den Private Key - nämlich `ppk`. Deshalb muß man den `pem`-encoded Schlüssel per PuTTYgen in ein `ppk` konvertieren. Das kann man dann bei der ssh-Authentifizierung von PuTTY verwenden - [siehe Doku](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console)

*Frage 2:* Ich habe ein Key-Pair generiert und den private Key runtergeladen - wie komme ich an den Public Key ran?
*Antwort 2:* Der Public Key wird automatisch in dem erstellten Image beim entsprechenden User unter `~/.ssh/authorized_keys` eingetragen. Sollte man das Image gelöscht haben, will den Key aber für ein anderes Image wiederverwenden (und manuell in `~/.ssh/authorized_keys` eintragen), dann kann man aus dem Private Key den Public Key erzeugen per `ssh-keygen -y -f publicKey.pem`.
