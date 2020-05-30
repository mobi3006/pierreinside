# Consul-Template

Zur besseren Integration von Consul und Vault in typische Konfigurationsszenarien, die auf Konfigurationsdateien beruht, verwendet man `consul-template`.

Das wird in zwei unterschiedlichen Weisen verwendet:

* als Binary
  * on One-Shot Mode: einmaliges Ausführen
  * in Observer Mode: immer wenn sich verwendete Konfigurationen in Consul/Vault verändern, dann erfolgt eine erneute Ausführung
* als Service

Über Binary-Observer-Mode und als Service lassen sich auch Konfigurationsänderungen in Echtzeit an die beteiligten Service weitergeben.

---

## Getting Started

* [Getting Started - Documentation](https://github.com/hashicorp/consul-template)

Download des GO-Executables `consul-template`.

Angenommen man hat

* in Consul einen Key `consul_foo` mit dem Wert `consul_bar`
* in Vault einen Key `vault_foo` mit dem Wert `vault_bar`

hinterlegt und `my.cfg.tpl` sieht folgendermaßen aus:

```text
Das ist der Wert aus Consul: {{ key "consul_foo" }}
Das ist der Wert aus Vault: {{ with secret "vault_foo" }}
```

dann wird hierdurch

```bash
consul-template \
    -template=my.cfg.tpl:my.cfg \
    -once \
    -vault-retry-attempts=2 \
    -consul-retry-attempts=2
```

eine Datei `my.cfg` erstellt, die folgendermaßen aussieht:

```text
Das ist der Wert aus Consul: consul_bar
Das ist der Wert aus Vault: vault_bar
```

erstellt.

Läßt man `-once` weg, so läuft der Prozess weiter und erzeugt bei Änderungen in Consul/Vault eine neue `my.cfg` Datei.

---

## Syntax

