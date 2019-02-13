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
    * man kann [Billing Alerts](https://console.aws.amazon.com/billing/home?#/preferences) konfigurieren
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

### AWS CLI

* [Tutorial: Using the AWS CLI to Deploy an Amazon EC2 Development Environment](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-tutorial.html)
* [Install `awscli` auf Ubuntu 18.04 LTS - verschiedene Varianten](https://linuxhint.com/install_aws_cli_ubuntu/)

Ich habe die Command-Line Tools von AWS über `pip` (Python Paket Manager) installiert wie [hier beschrieben](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html):

> Ich hatte den `pip` schon installiert - [so hätte ich ihn installieren können](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)

```bash
pip install awscli --upgrade --user
```

So bin ich an die aktuelle Version 1.16.96 gekommen (über diesen Weg werden auch Updates installiert).

> Die Option `--user` sorgte dafür, daß die Installation nur in meinem Home-Verzeichnis erfolgte (`~/.local/bin/aws`). Ich habe dieses Python Script in meinen `$PATH` gelegt, so daß ich es von überall aufrufen kann.

Über meinen Ubuntu Package-Manager (auf Ubuntu 18.04 LTS)

```bash
sudo apt-get update
sudo apt-get install awscli
```

habe ich nur eine awscli-1.14.xxx bekommen.

Anschließend muß man die Credentials `~/.aws/credentials` noch einbinden (die Kommandos hängen davon ab, ob man die Python Installation verwendet hat oder die Package-Installation - [siehe Dokumentation](https://linuxhint.com/install_aws_cli_ubuntu/)):

```bash
python -m awscli configure
```

Hier wird man interaktiv nach den Crentials (AWS Access Key ID, AWS Secret Access Key, Default region). Aus den Angaben werden die Dateien `~/.aws/credentials` und `~/.aws/config` erzeugt.

Anschließend sollte man Zugriff haben und folgenden Befehl ausführen können:

```bash
aws iam get-user --user-name your_username@example.com
```

> Will man verschiedene Konfigurationen verwenden, [dann kann man sog. Profile nutzen](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

---

## Konzepte

### Oranisationsebenen

- [Konzept Regionen und Availability Zones](https://docs.aws.amazon.com/de_de/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)

- alle Regionen sind unabhängig voneinander
- Region (z. B. us-east-1, us-east-2, us-west-1, eu-west-1)
  - jede Region ist ein unterschiedlicher geografischer Bereich
  - in jeder region gibt es wiederum mehrere physisch isolierte Standorte (Availability Zones)

### Availability Zones

Amazon muß natürlich auch selbst mal Wartungsarbeiten durchführen (oder hat auch mal ungeplante Ausfälle, z. B. durch Brand) und damit Infrastruktur vom Netz nehmen. Amazon empfiehlt die Verwendung von drei sog. Availability Zones und garantiert, daß IMMER mind. eine verfügbar ist. Bei der Verteilung der Microservices auf die verschiedenen Zones sollte man also **darauf achten, daß in jeder Zone mind. ein Knoten jedes Services deployed ist**.

Der Elastic Load Balancer (ELB), der häufig der einzige öffentliche Zugangspunkt für Requests ist, sorgt dafür, daß die Requests aus dem Internet in die tatsächlich verfügbare Availability Zones delegiert werden.

---

## S3

Dieser Dient bietet einen File-Server in Form von sog. S3-Buckets. Der Names des Buckets muß global eindeutig sein.

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

---

## FAQ

*Frage 1:* Ich habe ein Key-Pair generiert bekommen mit PuTTY aber keinen Zugriff hin - was mache ich falsch?
*Antwort 1:* PuTTY verwendet ein anderes Format für den Private Key - nämlich `ppk`. Deshalb muß man den `pem`-encoded Schlüssel per PuTTYgen in ein `ppk` konvertieren. Das kann man dann bei der ssh-Authentifizierung von PuTTY verwenden - [siehe Doku](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console)

*Frage 2:* Ich habe ein Key-Pair generiert und den private Key runtergeladen - wie komme ich an den Public Key ran?
*Antwort 2:* Der Public Key wird automatisch in dem erstellten Image beim entsprechenden User unter `~/.ssh/authorized_keys` eingetragen. Sollte man das Image gelöscht haben, will den Key aber für ein anderes Image wiederverwenden (und manuell in `~/.ssh/authorized_keys` eintragen), dann kann man aus dem Private Key den Public Key erzeugen per `ssh-keygen -y -f publicKey.pem`.