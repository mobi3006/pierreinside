# Vault

* [Homepage](https://www.vaultproject.io)

Vault ist ein weiteres Tool aus dem Sortiment von HashiCorp. Ähnlich wie [Consul](consul.md) ist es ein Key/Value Store ... allerdings für das sichere Aufbewahren von Geheimnissen (z. B. Username/Password). Hierzu werden die Daten verschlüsselt gespeichert und selbst Vault kann die Daten nur dann lesen, wenn ein [Unsealing](https://www.vaultproject.io/docs/concepts/seal.html) stattgefunden hat.

---

## Getting Started

Wie so häufig kommt man am schnellsten mit [Docker](docker.md) voran:

```bash
docker run --cap-add=IPC_LOCK -d --net=host --name=myVault -e VAULT_DEV_ROOT_TOKEN_ID=root vault
```

oder - meine Präferenz - über eine `docker-compose.yml` Datei

```yaml
vault:
    image: vault
    ports:
        - "8200:8200"
    cap_add:
        - IPC_LOCK
    environment:
        VAULT_DEV_ROOT_TOKEN_ID: root
```

so daß der Container per `docker-compose up -d vault` im Development Mode gestartet werden kann (von dieser Startvariante gehe ich im folgenden aus). Will man den Container im `Server-Mode` starten, so verwendet man den Zusatzparameter `command` im `docker-compose.yml` File

```
command: server -config=/vault/config/vault-config.json
```

> ACHTUNG: der Container verliert seine Daten durch einen Restart, da er nur In-Memory Storage - lösbar durch Verwendung anderer Storage Backends (z. B. Consul oder File Storage mit einem persistenten Volume). Ohne den Parameter `VAULT_DEV_ROOT_TOKEN_ID` wird ein zufälliger [Token](https://www.vaultproject.io/docs/concepts/tokens.html) generiert (z. B. `b9f49ccd-aac7-e894-66e3-798a43022c2b`) und beim Startup im Log ausgegeben. Die Token Authentication Methode ist per Default eingeschaltet - man benötigt den Token beispielsweise beim Login über die WEB-UI.

Das WEB UI steht dann unter [http://localhost:8200/ui](http://localhost:8200/ui) zur Verfügung - per `root` Token kann man sich anmelden.

### Developer Mode

Wird Vault im [Developer-Mode](https://www.vaultproject.io/docs/concepts/dev-server.html) gestartet, so ist es automatisch unsealed, d. h. eine Eingabe des Master-Keys zum Entschlüsseln des Verschlüsselungs-Keys der Daten ist nicht mehr erforderlich.

### Docker Deployment - CLI

Wenn man das Kommandozeilen Interface verwenden möchte, dann erzeugt man am besten per `docker exec -it vault sh` und exportiert die folgenden Umgebungsvariablen:

```
export VAULT_ADDR=http://vault:8200
export VAULT_TOKEN=root
```

> Die `VAULT_ADDR` benötigt man nur, wenn der Container kein `https` verwendet, sondern nur `http` unterstützt. Ohne diese Konfiguration bekommt man Fehlermeldungen wie "Error listing secrets engines: Get https://127.0.0.1:8200/v1/sys/mounts: http: server gave HTTP response to HTTPS client". Man kann dann hier die Umgebungsvariable setzen (dauerhaft) oder bei den Befehlen `-address=http://vault:8200` angeben.

> Den `VAULT_TOKEN` kann man aus convenience Gründen verwenden - damit umgeht man ein explizites Login ( `vault login`). ABER ACHTUNG: in der Kammando-History ist dies sichtbar (sicherheitstechnisch bedenklich)!!! Alternativ dazu kann man den Token auch in die Datei `/root/.vault-token` packen, was den Sicherheitsaspekt nicht weniger kritisch macht. In Entwicklungsumgebungen ist das allerdings i. a.  unproblematisch.

Danach kann man Befehle wie diese absetzen:

```bash
vault secrets list
vault secrets enable -version=1 my-kv
```

### Docker Deployment - Consul Integration

Man kann das Docker-Deployment über Umgebungsvariablen und Parameter wie `--cap-add` anpassen. Zusätzlich kann man auch Konfigurationsdateien (json, hcl) über Volumes einbinden. So würde die Docker-Compose Konfiguration aussehen

```yaml
vault:
    image: vault
    ports:
        - "8200:8200"
    volumes:
        - ./vault-persistence:/vault/file
        - ./vault-config:/vault/config
    cap_add:
        - IPC_LOCK
    environment:
        VAULT_DEV_ROOT_TOKEN_ID: root
```

Bei dieser Konfiguration würde eine Datei `./vault-config/config.hcl` den Vault Container entsprechend konfigurieren. In diesem Beispiel wird Consul (statt der In-Memory Datenbank) als Storage Engine verwendet Consul muß natürlcih auch gestartet sein):

```hcl
storage "consul" {
  address = "consul:8500"
  path    = "vault/"
}
```

Anschließend sollte man unter `Key/Values - vault/logical` die Keys sehen. Im Vault WEB-UI sieht man sie auch weiterhin ... macht ja Sinn, d

---

## Konzepte

* Vault verschlüsselt die Werte bevor sie zum Backend Storage gesendet werden - dementsprechend speichert das Storage nur Bits ... eine Interpretation/Nutzung ist nicht möglich
* Vault verwaltet sog. Ressourcen - alles ist eine Ressource ... es gibt verschiedene Ressource-Typen (z. B. `vault_generic_secret`) mit unterschiedlichen Properties (z. B. `path`). Hier z. B. ein Secret

```
resource "vault_generic_secret" "mySecret" {
  path = "secret/myService/s1"

  data_json = <<EOT
{
  "s1": "4711"
}
```

---

## Nutzung

Vault stellt folgende Interfaces zur Verfügung

* [WEB UI](http://localhost:8200/ui)
* [CLI `vault`](https://www.vaultproject.io/intro/getting-started/first-secret.html)
* [REST interface](https://www.vaultproject.io/api/index.html)

---

## Authentication Method

Vault unterstützt viele Authentifizierungsmethoden

* [Token](https://www.vaultproject.io/docs/concepts/tokens.html)
  * im Developer-Mode standardmäßig freigeschaltet - es wird ein Token beim Start generiert und im Log ausgegeben
* Username/Password
* TLS Zertifikate
* AppRole
* LDAP
* [OpenID Connect](openIdConnect.md)
  * Okta
  * GitHub
* ...

---

### Authorization

ACL (Access Control List) definiert welche Berechtigungen ein User (identifiziert über Token)

Roles

---

## Storage

* In-Memory
* Festplatte
* Consul

Vault selbst speichert die Daten verschlüsselt - Vault hat nur Zugriff, wenn es über den Master-Key verfügt. Die Verschlüsselung erfolgt mit einem Key, der mit dem sog. Master-Key verschlüsselt ist. Dieser Master-Key muß Vault im sog. [Unsealing-Prozess](https://www.vaultproject.io/docs/concepts/seal.html) übergeben werden - das kann von verschiedenen Endgeräten verteilt erfolgen, um die Sicherheit zu erhöhen.

### Master-Key

Der Master-Key ist allerdings kein einzelner Schlüssel, der EINEM Operator zur Verfügung steht. Stattdessen kann das Secret auf verschiedene Stakeholder verteilt werden und eine bestimmte Anzahl genügt, um den Master-Key zu rekonstruieren. [Shamir Secret Sharing](https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing) ist das dahinterliegende Konzept.

### Auto-Unseal

Um ein Auto-Unseal zu unterstützen (und somit Auto-Setup zu unterstützen) wird das Secret von Personen auf Geräte/Services umverteilt.

---

## Secret Engines

Vault kann verschiedene Secret Engines einbinden:

* Generischer Key/Value-Store
  * in Version 1
  * in Version 2
    * ein solcher ist defaultmäßig beim Docker-Container (Stand September 2018) instantiiert
* AWS

Ein URL-Pfad-Prefix (z. B. `secret`, `aws`) ist an eine Secret Engine gebunden.

### Generischer Key/Value Store

### AWS

* [AWS Secret Store für dynamische Secrets](https://www.vaultproject.io/intro/getting-started/dynamic-secrets.html)

Der AWS Secret Store wird per `vault secrets enable -path=aws aws` eingeschaltet.

## Provisioning von Key/Values

### Terraform

* [Terraform - Vault Provider](https://www.terraform.io/docs/providers/vault/index.html)