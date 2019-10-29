# Hashicorp Packer

Mit diesem Tool werden Images unterschiedlichster Art gebaut: Docker, AMI, VMWare, Virtualbox, ...

---

## Getting Started

Packer besteht - Hashicorp typisch - nur aus einzigen Executable - somit keine Library-Abhängigkeiten - download, unzip and ready to use :-)

---

## CLI

Am besten installiert man sich die Shell-Autocompletion `packer -autocomplete-install` ... und die nächste gestartete Shell stell Auto-Completion zur Verfügung

* `packer validate example.json`
* `packer build example.json`

---

## Templates

* [Doku](https://packer.io/docs/templates/index.html)

Ein Packer-Template ist eine JSON-Datei (z. B. `example.json`), in der die komplette Bauenaleitung steht. Per `packer build example.json` wird daraus dann ein Image gebaut.

---

## Builder

Die (mandatory) Builder-Sektion legt fest

* welches Image ist die Quelle?
* welcher Image-Typ soll erstellt werden?
* ...

### Docker Builder

* https://www.packer.io/docs/builders/docker.html

Die Konfiguration von Docker Images basiert NICHT auf `Dockerfile` sondern auf einer JSON Beschreibung der Builder- und Provisioning Scripts. Hierüber werden Docker-Container gestartet, dann erfolgt das Provisioning (per Ansible, Chef, Shellscripting, ...) und zum Schluß wird aus dem laufenden System ein Image extrahiert und zur Wiederverwendung ins Repository gelegt.

Damit ist die Sprache zunächst mal unabhängig vom Image-Typ - allerdings erfolgt die Konfiguration in einer eigenen DSL.

> ich bin gespannt wie gut sich das anfühlt bei der Fehlersuche ... da hab ich mit einer in ANT eingebetteten DSL schon mal unangenehme Erfahrungen gemacht.

### Virtualbox Builder

Dieser Builder ist einer der wenigen Packer-Builder, die nicht einfach in einer VM laufen kann, weil er eine VirtualBox-Installation benötigt und deshalb am besten auf Bare-Metal ausgeführt wird. Wer nicht über Bare-Metal verfügt, kann sich bei [packet](https://www.packet.com/) einen entsprechenden Dienst kaufen.

---

## Provisioning

Provisioning bezeichnet die Detailkonfiguration des Images (z. B. installierte Software, Konfiguration). Hier werden u. a. folgende Ansätze unterstützt:

* Shell
* Ansible
* Chef
* Puppet
* Salt
* ...

### Ansible Provisioning

---

## Post-Processors

Nach der Fertigstellung des Images werden die Artefakte in einem Repository gespeichert - das erledigen die Post-Processors:

* Docker Push
* Amazon Import
* Vagrant Cloud
* Google Compute Export
* vSphere
* ...

---

## Jenkins Integration

Packer läßt sich beispielsweise folgendermaßen in eine Jenkins-Pipeline integrieren:

```json
pipeline {
    environment {
        PATH="${tool('packer')}:$PATH"
    }
    stage('Build docker image') {
        environment {
            PACKER_NEXUS = credentials("bla")
            PACKER_ANSIBLE_VAULT = credentials("blub")
        }
        steps {
            dir('packer') {
                sh "set -e; packer version"
                sh "set -e; packer validate config.json"
                sh "set -e; packer build config.json"
            }
        }
    }
}
```
