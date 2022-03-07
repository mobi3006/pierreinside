# AWS CLI

* [Udemy-Kurs *AWS Certified Solution Architect Associate*](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/26098170#overview)

* [Tutorial: Using the AWS CLI to Deploy an Amazon EC2 Development Environment](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-tutorial.html)
* [Install `awscli` auf Ubuntu 18.04 LTS - verschiedene Varianten](https://linuxhint.com/install_aws_cli_ubuntu/)

Mit der AWS CLI kann man all die Dinge machen, die man auch über die AWS Console per UI tun kann.

---

## Getting Started

Nach der Installation des Binary (übrigens ist die CLI in [Python](python.md) programmiert und hat deshalb auch perfekte Python Libraries via [Boto3](https://aws.amazon.com/de/sdk-for-python/)) muss die Shell noch mit Credentials bestückt werden.

Für den Zugriff benötigt man Security-Credentials (Access Keys = Tokens), die man beispielsweise manuell per AWS Console (Web-UI) manuell erzeugen kann. Ein `aws configure` führt interaktiv durch die Konfiguration - hier werden die Credentials abgefragt und am Ende eine Datei `~/.aws/config` geschrieben => damit ist die Konfiguration persistent.

### Installation per Python Paket Manager

Ich habe die Command-Line Tools von AWS über `pip` (Python Paket Manager) installiert wie [hier beschrieben](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-instaRll.html):

> Ich hatte den `pip` schon installiert - [so hätte ich ihn installieren können](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)

```bash
pip install awscli --upgrade --user
```

So bin ich an die aktuelle Version 1.16.96 gekommen (über diesen Weg werden auch Updates installiert) - auf diese Weise kann man auch ein Update machen.

> Die Option `--user` sorgte dafür, daß die Installation nur in meinem Home-Verzeichnis erfolgte (`~/.local/bin/aws`). Ich habe dieses Python Script in meinen `$PATH` gelegt, so daß ich es von überall aufrufen kann.

### Installation per Ubuntu Package Manager

> ACHTUNG: nicht zu empfehlen - alte Version!!!

Über meinen Ubuntu Package-Manager (auf Ubuntu 18.04 LTS)

```bash
sudo apt-get update
sudo apt-get install awscli
```

habe ich nur eine awscli-1.14.xxx bekommen.

### Konfiguration

Anschließend muß man die Credentials `~/.aws/credentials` noch einbinden.

Die Kommandos hängen davon ab, ob man die Python Installation verwendet hat oder die Package-Installation - [siehe Dokumentation](https://linuxhint.com/install_aws_cli_ubuntu/)):

```bash
# Option A
aws configure

# Option B
python -m awscli configure
```

> Als erfahrener AWSler kann man die dabei angelegten Dateien in `~/.aws` aber auch manuell anlegen.

Hier wird man interaktiv nach den Crentials (AWS Access Key ID, AWS Secret Access Key, Default region). Aus den Angaben werden die Dateien `~/.aws/credentials` und `~/.aws/config` erzeugt. Diese Credentials kann man sich in der AWS Console (Web UI) im Bereich "IAM - Access Management - Users - <USER> - Security Credentials - Access Keys" erzeugen lassen. Kein Problem, wenn man ihn mal vergißt - einfach neu erzeugen und in `~/.aws/credentials` eintragen. Hat man mehrere AWS Accounts, dann kann man die im [INI File Format](https://en.wikipedia.org/wiki/INI_file) konfigurieren

```ini
[default]
aws_access_key_id = bla
aws_secret_access_key = blubb

[mySecondAccount]
aws_access_key_id = what
aws_secret_access_key = isthat
```

Es kann sinnvoll sein, unterschiedeliche Konfigurationen (= Profile) zu verwenden ... je nach Nutzungskontext. Das läßt sich ganz einfach per `aws configure --profile foo-bar` umsetzen oder durch manuelle Editierung der `~/.aws/config` Datei. Das Default-Profile kann per `export AWS_PROFILE=foo-bar` gesetzt werden oder man [überschreibt](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) es für ein einziges Kommando: `aws iam get-user --user-name your_username@example.com --profile mySecondAccount`.


> AWS Roles verwendet man, wenn man seine Credentials nicht auf der Instanz hinterlegen möchte. Auf diese Weise kann man eine Role mit Permissions auf ein S3-Bucket anlegen und einer EC2-Instanz zuweisen. Dadurch hat die EC2-Instanz automatisch Zugriff auf das S3. Bucket. Mit [Terraform](terraform.md) läßt sich das auch schön automatosieren.

Der Python-Aws-CLI-Installer bringt auch gleich die passende [Shell-Auto-Completion](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html) mit. Unter `~/.local/bin/aws_completer.` sind die notwendigen Quellen abgelegt. Durch hinzufügen folgender Zeilen zur `~/.zshrc` wird die AWS-Auto-Completion automatisch aktiviert:

```bash
autoload bashcompinit && bashcompinit
complete -C '/home/pfh/.local/bin/aws_completer' aws
```

### Test

Anschließend sollte man Zugriff haben und folgenden Befehl ausführen können:

```bash
aws iam get-user --user-name your_username@example.com
```

> Will man verschiedene Konfigurationen verwenden, [dann kann man sog. Profile nutzen](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

---

## aws CLI im Detail

### Assume Role

* [komplettes Beispiel](https://www.hava.io/blog/what-is-aws-security-token-service-sts)

Viele Organisationen verwenden mehrere AWS Accounts. Der [Amazon STS service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) wird verwendet, um Token zu erzeugen, die kurzfristige Zugriffe auf Ressourcen zu gewähren (innerhalb eines Accounts aber auch Account-übergreifend).

Hierzu legt man eine Rolle an, die einem User (dessen Token man später verwenden wird) entsprechende Berechtigung erteilt.

Per

> aws sts assume-role --role-arn arn:aws:iam:xxxxxxxxxx:role/ROLENAME

kann man sich einen Token erzeugen (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), der die entsprechenden AWS-Kommandos (gemäß Berechtigung) ausführen kann.

---

## Token Erzeugung

Mit dem [Amazon STS service](https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html) lassen sich kurzlebige Tokens (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) mit eingeschränken Permissions per Code (und damit automatisierbar) ausstellen.

> Das ist ganz ähnlich zu [GitHUb Apps](https://docs.github.com/en/developers/apps/getting-started-with-apps/about-apps).

---

## aws-vault

* [Homepage](https://github.com/99designs/aws-vault)

Mit diesem Tool lassen sich AWS Credentials (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) sicher speichern und im `aws`-CLI verwenden:

> aws-vault exec mobi3006 -- aws s3 ls

Das Tools stellt allerdings nur das Tooling bereit, um die Credentials in Form von Umgebungsvariablen bereitzustellen. Die Credentials werden in einem separaten Storage (sog. Vaulting Backend) gespeichert. Typische Backends sind:

* macOS Keychain
* Windows Credential Manager
* Gnome Keyring, KWallet
* [pass](https://www.passwordstore.org/)

Letzteres ist besonders interessant auf reinen Linux-Headless Systemen.

> `aws-vault` ist in der Funktion vergleichbar mit einem ssh-Agent, allerdings ist der ssh-Agent direkt transparent in den `ssh` Workflow integriert ... wohingegen `aws-vault` dem Kommando vorangestellt werden muss.

### pass als aws-vault Backend

Dieser Command-Line Password Store verwendet GPG, um die Credentials sicher in einer Datei `~/.password-store` abzuspeichern, die man beispielsweise auch in einem Git Repository zur Verfügung stellen kann.

[mehr Details über `pass`](password-manager.md)

`pass` ist nicht das Default Backend von `aws-vault` und dementsprechend muss es im Kommando `aws-vault --backend=pass exec mobi3006 -- aws s3 ls` angegeben werden. Durch Setzen der Umgebungsvariable `export AWS_VAULT_BACKEND=pass` und `export AWS_ASSUME_ROLE_TTL=12h` kann man den Zugriff komfortabler gestalten.

### gpg

[siehe eigener Abschnitt](gpg.md)
