# Vault

* [Homepage](https://www.vaultproject.io)

Vault ist ein weiteres Tool aus dem Sortiment von HashiCorp. Ähnlich wie [Consul](consul.md) ist es ein Key/Value Store ... allerdings für das sicher Aufbewahren von Geheimnissen (z. B. Username/Password).

## Getting Started

Wie immer in der heutigen Zeit kommt man am schnellsten mit [Docker](docker.md) voran:

```bash
docker run --cap-add=IPC_LOCK -d --net=host --name=myVault vault
```

Das WEB UI steht dann unter [http://localhost:8200/ui](http://localhost:8200/ui) zur Verfügung (ACHTUNG: der Container verliert seine Daten durch einen Restart).
