# Amazon Web Services

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

## FAQ

*Frage 1:* Ich habe ein Key-Pair generiert bekommen mit PuTTY aber keinen Zugriff hin - was mache ich falsch?
*Antwort 1:* PuTTY verwendet ein anderes Format für den Private Key - nämlich `ppk`. Deshalb muß man den `pem`-encoded Schlüssel per PuTTYgen in ein `ppk` konvertieren. Das kann man dann bei der ssh-Authentifizierung von PuTTY verwenden - [siehe Doku](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html?icmpid=docs_ec2_console)

*Frage 2:* Ich habe ein Key-Pair generiert und den private Key runtergeladen - wie komme ich an den Public Key ran?
*Antwort 2:* Der Public Key wird automatisch in dem erstellten Image beim entsprechenden User unter `~/.ssh/authorized_keys` eingetragen. Sollte man das Image gelöscht haben, will den Key aber für ein anderes Image wiederverwenden (und manuell in `~/.ssh/authorized_keys` eintragen), dann kann man aus dem Private Key den Public Key erzeugen per `ssh-keygen -y -f publicKey.pem`.