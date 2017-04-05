# Getting started - mit vorkonfiguriertem Vagrant-Image
Am besten erlernt man eine neue Technologie durch ausprobieren. Deshalb am bestern per Vagrant ein Linux-Image mit bereits eingebautem Docker-Support anlegen. Das ist eine Sache von 5 Sekunden Arbeit:

```
vagrant init box-cutter/ubuntu1404-docker
vagrant up
```

Und dann noch ein paar Sekunden/Minuten auf den Download des Images warten - währenddessen gleich einen DockerHub-Account anlegen.Dann per

```
vagrant ssh
```

ein SSH-Connect auf das neue Image machen. Anschließend werden die Credentials für DockerHub per

```
sudo docker login
```

abgefragt und in ``$HOME/.dockercfg`` abgelegt. Und nun noch einen Docker-Container starten:

```
sudo docker run ubuntu:14.04 /bin/echo 'Hello world'
```

Voila :-)

Aber nicht nur *Hello World* (für das man sicher keinen eigenen Container benötigt) geht so schnell. Auch diese Web-Applikation (eigentlich handelt es sich um das Docker-Images *training/webapp* mit einer Web-Applikation)

```
docker run -d -p 5000:5000 training/webapp python app.py
```

ist schnell mal deployed.

Je nach Netzwerkkonfiguration des Images (NAT, Bridge) kann vom Wirtsystem direkt über die IP-Adresse des Images auf ``http://localhost:5000`` zugegriffen werden (Bridge-Mode) oder es muß Port-Forwarding in das Images hinein konfiguriert werden.

---

# Getting started - from Scratch
From-Scratch meint hier, ohne vorinstalliertes Docker (im vorigen Beispiel war das bereits im VirtualBox-Image ``ubuntu1404-docker`` vorinstalliert) - natürlich kann man auch hier die Linux-Box per Vagrant erzeugen. Wie es danach weitergeht hängt von der verwendeten Linux-Distribution ab.

Aus konzeptioneller Sicht tut man folgendes:

* Docker-Package-Repository ins System integrieren
* Docker-Package installieren
* Docker-Daemon starten

## CentOS
* https://docs.docker.com/engine/installation/linux/centos/

Befehlsreihenfolge:

```
sudo yum update
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
 [dockerrepo]
 name=Docker Repository
 baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
 enabled=1
 gpgcheck=1
 gpgkey=https://yum.dockerproject.org/gpg
 EOF
sudo yum install docker-engine
sudo service docker start
sudo docker run hello-world
```

Wenn dann eine Erfolgsmeldung ala "*Hello from Docker.*" ... Voila geschafft.

Das ``sudo`` vor dem ``docker`` macht die ganze Sache ein wenig unhandlich. Derhalb legt man am besten eine User-Gruppe ``docker`` an und packt einzelne User dort hinein:

```
usermod -aG docker myuser
```

Zudem sollte man den Docker-Daemon beim Systemstart hochfahren:

```
chkconfig docker on
```
