# Docker Registry

Die wohl bekanntest Docker-Reistry ist [dockerhub.com](https://hub.docker.com). Allerdings gibt es viele andere ... privat wie public. Die Cloud-Anbieter AWS (ECR), Google (GCR) und Azure (ACR) bieten alle ihre eigene Docker-Registry an.

---

## Quota / Fair-Rate-Limit

Der Zugriff auf die Docker Registries ist häufig durch eine [Quota](https://www.docker.com/pricing/resource-consumption-updates/) beschränkt, d. h. man kann nur x mal in y Minuten Images downloaden. Hier erfolgt eine Abstufung nach 

* nicht authentifzierte User
* authentifizierte User (login erforderlich)
* bezahlter Plan

In vielen Use-Cases ist das weniger dramatisch, da ein einmal runtergeladenes Docker Image in der lokalen Docker Registry gecacht wird.

In CI/CD Szenarien wird das allerdings schnell zum Problem, weil man hier i. a. Jobs auf ephemeral Workers laufen lässt, die keine Persistenz haben. Es erfolgt also kein dauerhaftes Caching. Hier kann man schnell an Grenzen stoßen.

---

## Verschiedene Anbieter

### DockerHub hub.docker.com

### Public AWS ECR public.ecr.aws

* [Announcing Pull Through Cache Repositories for Amazon Elastic Container Registry](https://aws.amazon.com/blogs/aws/announcing-pull-through-cache-repositories-for-amazon-elastic-container-registry/)

AWS repliziert (vielleicht ist es technisch auch ein On-Demand-Pull-Thorugh) Public-Docker-Images von hub.docker.com (getagged mit `PUBLIC DOCKER IMAGE`) in seine eigene Registry und bietet seinen AWS-Kunden deutlich höhere Quotas (teilweise unbeschränkt) an. AWS selbst hat mit DockerHub entsprechende Freikontingente.

> AWS ECR enthält dann allerdings nur die PUBLIC DOCKER IMAGES ... 

---

## Registry Auswahl

Bei einem 

```
docker pull ubuntu
```

wird das Image per default von [dockerhub.com](https://hub.docker.com) geladen. Will man ein Image von einer anderen Regsitry laden, so muss man die Domain voranstellen

```
docker pull public.ecr.aws/ubuntu/ubuntu
```

Man kann die Default-Domain allerdings auch im Docker Daemon konfigurieren:

* [Registry as a pull through cache](https://docs.docker.com/registry/recipes/mirror/#configure-the-docker-daemon)

---

## Registry Authentifizierung

Als anonymer User hat man häufig weniger Downloads zur Verfügung - Docker Images hochladen kann man i. a. nicht. Aus diesem Grund muss man sich i. a. authentifizieren.

Ganz naiv geht das so:

```
docker login -u $USERNAME -p $PASSWORD
```

Allerdings landet das Passwort dann in der Shell-History (kann man vermeiden indem man nur `docker login` verwendet und den Rest interaktiv eingibt) UND in `~/.docker/config.json`. Keine gute Idee.

> Das Secret in `~/.docker/config.json` (z. B. `"auth": "YWJjOnh5eg=="`) ist nur Base64 encoded und kann leicht mit `echo YWJjOnh5eg== | base64 -d -` decodiert werden. Heraus kommt dann `abc:xyz`, d. h. die Userid ist `abc` und das Passwort `xyz`.

Aus diesem Grund sollte man besser einen [Docker-Credential-Helper](https://github.com/docker/docker-credential-helpers) verwenden, der das Passwort verschlüsselt speichern kann. Ich verwende gerne `pass` als sicheren Secret-Store ([siehe hier](password-manager.md)) ... man kann aber auch andere verwenden. Nun benötigt man allerdings folgendes 

* eine Anwendung (sog. Docker-Credential-Helper), die auf dem Rechner installiert ist (im `PATH`)
* eine Hook-Konfiguration, um den Docker-Authentifizierungsprozess anzupassen (konfiguriert in `~/.docker/config.json#credsStore`)

[Hier](https://medium.com/@patelprayag1990/docker-login-into-aws-ecr-through-credential-helper-af50428cfa43) sehr schön beschrieben.

### pass als Docker-Credential-Store

* [Anleitung](https://github.com/docker/docker-credential-helpers/issues/102)

Schritte

* Installation des `docker-credential-pass` [Binary](https://github.com/docker/docker-credential-helpers/releases) in den `PATH`
* Installation und Initialisierung von `pass` ([siehe hier](password-manager.md))
* in `~/.docker/config.json` (oder auch für alle User in `/etc/docker/daemon.json`): `"credsStore": "pass"` hinzufügen
* restart des Docker Daemons

Anschließend kann man den Login interaktiv per

```
docker login
```

durchführen und das Password landet verschlüsselt im `~/.password-store`.

### AWS-ECR-Credentials-Helper

* [Motivation](https://medium.com/@jdolitsky/docker-credential-magic-a-magic-shim-for-docker-credential-helpers-deae9e78c2df)
* [Installation](https://github.com/awslabs/amazon-ecr-credential-helper)
* [YouTube Video](https://www.youtube.com/watch?v=ed6Nxpe0a6E)
* [Download](https://github.com/awslabs/amazon-ecr-credential-helper/releases)

Normalerweise würde man ein explizites `docker login` per (die Authentifizierung erfolgt entweder über Environment Variablen oder IAM Roles bereitgestellt)

```
aws ecr get-login-password | docker login --username AWS --password-stdin 1234567890.dkr.ecr.eu-central-1.amazonaws.com
```

ausführen, um anschließend per `docker pull 1234567890.dkr.ecr.eu-central-1.amazonaws.com/myimage` ein Docker Image zu ziehen. In manchen Use-Cases ist das "programmatisch" aber gar nicht möglich.

> Beispiel: Verwendet man in Nomad kann man den [Docker-Driver](https://developer.hashicorp.com/nomad/docs/drivers/docker), dann zieht der Nomad-Worker im Nomad-Lifecycle das Image. In diesem Fall entscheidet der Nomad-Broker darüber welcher Nomad-Worker geeignet ist den Service to hosten. Die gesamte Kommunikation verläuft Nomad-intern. Hier hat man keine Chance, auf dem Nomad-Worker ein `docker login` zu triggern. Ich wollte hier aber [keine expiliziten Credentials im Nomad-Job](https://developer.hashicorp.com/nomad/docs/drivers/docker#authentication) verwenden, sondern AWS-IAM-Roles verwenden, die an die AWS-EC2-Instanz attached sind.

Über einen Credential-Helper-Ansatz kann man auch das explitzite Login verzichten, weil das komplett im Docker-Workflow versteckt wird. Die Authentifizierungsmethoden bleiben die gleichen wie bei einem `docker login` (`~/.aws/credentials`, `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`, IAM Roles). Auf diese Weise kann man beispielsweise einer EC2 Instanz (z. B. im Nomad Worker) die Authentifzierung konfigurieren ... ausgeführt wird sie dann im Docker-Lifecycle.

```
A Docker credential helper to automatically manage credentials for Amazon ECR.

Once configured, the Amazon ECR Credential Helper lets you "docker pull" and
"docker push" container images from Amazon ECR without running "docker login".

Amazon ECR is a container registry and requires authentication for pushing and
pulling images.  You can use the AWS CLI or the AWS SDK to obtain a
time-limited authentication token.  This credential helper automatically
manages obtaining and refreshing authentication tokens when using the Docker
CLI.

For more information about Amazon ECR and how to use it, see the documentation
at https://docs.aws.amazon.com/AmazonECR/latest/userguide/.
```

> **ACHTUNG:** als ich es zum ersten mal verwenden wollte verwirrte mich, dass das Package in Amazonlinux, Ubuntu und Arch Linux `amazon-ecr-credential-helper` heisst ... das Binary dann aber `docker-credential-helper-ecr` (Package in Brew). Sollte für Deine Distribution kein Package zur Verfügung stehen, kannst man es sich aus dem [Source-Code](https://github.com/awslabs/amazon-ecr-credential-helper) bauen oder eins der [fertigen Binaries](https://github.com/awslabs/amazon-ecr-credential-helper/releases) verwenden.

Schritte ([siehe Homepage "Amazon ECR Docker Credential Helper"](https://github.com/awslabs/amazon-ecr-credential-helper)):

* Installation des `docker-credential-ecr-login` [Binary](https://github.com/awslabs/amazon-ecr-credential-helper/releases) in den `PATH`
* Variante 1: in `~/.docker/config.json` diese Konfiguration hinzufügen

   ```
   {
      "credsStore": "ecr-login"
   }
   ```

   Der `credsStore=ecr-login` kann ausschließlich bei der AWS-ECR-Docker-Registry verwendet werden. Zieht man bei dieser Konfiguration eine Docker-Image von DockerHub (z. B. `docker pull hello-world`), dann bekommt man folgende Warning in `~/.ecr/log/ecr-login.log`:

   ```
   "docker-credential-ecr-login can only be used with Amazon Elastic Container Registry."
   serverURL="https://index.docker.io/v1/
   ```

   Dennoch wird das Image erfolgreich runtergeladen.

* Variante 2: in `~/.docker/config.json` diese Konfiguration hinzufügen

   ```
   {
      "credHelpers": {
         "##########.dkr.ecr.########.amazonaws.com": "ecr-login"
      }
   }
   ```

  * diese Variante hat den Vorteil, dass man die Authentifizierungsmethode Registry-Spezifisch konfigurieren kann

> Das sollte ohne Restart des Docker Daemons funktionieren. Alternativ kann man die Änderung auch in `/etc/docker/daemon.json` machen ... dann benötigt man aber einen Restart des Docker Daemons.

Anschließend kann man ohne explizites `docker login` ein `docker pull ##########.dkr.ecr.########.amazonaws.com/myimage` ausführen.

> Das funktioniert dann auch im angesprochenen Nomad-Job, der auf dem Nomad-Worker gestartet wird.

Sollte es nicht funktionieren, dann helfen die Logfiles unter `~/.ecr/log/ecr-login.log` und `/var/log/syslog` sicherlich weiter.

