# AWS CLI

Mit der AWS CLI kann man all die Dinge machen, die man auch über die AWS Console per UI tun kann.

---

## Getting Started

Nach der Installation des Binary (übrigens ist die CLI in [Python](python.md) programmiert und hat deshalb auch perfekte Python Libraries via [Boto3](https://aws.amazon.com/de/sdk-for-python/)) muss die Console noch konfiguriert werden.

Für den Zugriff benötigt man Security-Credetials (Access Keys = Tokens), die man beispielsweise manuell per AWS Console erzeugen kann. `aws configure` führt interaktiv durch die Konfiguration, an dessen Ende eine Datei `~/.aws/config` geschrieben wird => damit ist die Konfiguration persistent.

Je nach bereitgestellten Permissions sind dann Kommandos wie `aws s3 ls` möglich.

Es kann sinnvoll sein, unterschiedeliche Konfigurationen (= Profile) zu verwenden ... je nach Nutzungskontext. Das läßt sich ganz einfach per `aws configure --profile foo-bar` umsetzen oder durch manuelle Editierung der `~/.aws/config` Datei. Das Default-Profile kann per `export AWS_PROFILE=foo-bar` gesetzt werden.

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

> aws-vault ist in der Funktion vergleichbar mit einem ssh-Agent, allerdings ist der Scope größer

### pass Backend

Dieser Command-Line Password Store verwendet GPG, um die Credentials sicher in einer Datei `~/.password-store` abzuspeichern, die man beispielsweise auch in einem Git Repository zur Verfügung stellen kann.

> pass bietet komfortable Migrationsmöglichkeiten, um Passwörter aus anderen Passwortmanagern (z. B. 1Password, Keypass) zu exportieren.

`pass` ist nicht das Default Backend von `aws-vault` und dementsprechend muss es im Kommando `aws-vault --backend=pass exec mobi3006 -- aws s3 ls` angegeben werden. Durch Setzen der Umgebungsvariable `export AWS_VAULT_BACKEND=pass` kann man komfortabler gestalten.
