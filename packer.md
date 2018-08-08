# Hashicorp Packer

Mit diesem Tool werden Images unterschiedlichster Art gebaut: Docker, AMI, VMWare, Virtualbox, ...

## Builder

### Docker Builder

* https://www.packer.io/docs/builders/docker.html

Die Konfiguration von Docker Images basiert NICHT auf `Dockerfile` sondern auf einer JSON Beschreibung der Builder- und Provisioning Scripts. Hierüber werden Docker-Container gestartet, die dann zu einem Image kondensiert werden. Damit ist die Konfiguration ähnlich zu einem virtuellen Image/Server.

Damit ist die Sprache zunächst mal unabhängig vom Image-Typ - allerdings erfolgt die Konfiguration in einer eigenen DSL.

> ich bin gespannt wie gut sich das anfühlt bei der Fehlersuche ... da hab ich mit einer in ANT eingebetteten DSL schon mal unangenehme Erfahrungen gemacht.

## Provisioning

Provisioning bezeichnet die Detailkonfiguration des Images (z. B. installierte Software, Konfiguration). Hier werden u. a. folgende Ansätze unterstützt:

* Shell
* Ansible
* Chef
* Puppet
* Salt
* ...

### Ansible Provisioning

## Post-Processors

Nach der Fertigstellung des Images werden die Artefakte in einem Repository gespeichert - das erledigen die Post-Processors:

* Docker Push
* Amazon Import
* Vagrant Cloud
* Google Compute Export
* vSphere
* ...

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