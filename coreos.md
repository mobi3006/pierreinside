# CoreOS
* http://www.linux-magazin.de/Ausgaben/2014/10/Core-OS

# Idee und Konzepte
* schlankes Open-Source-Betriebssystem (es gibt auch eine Commercial Version - insbes. mit Support), das voll auf Docker setzt
* bringt von Haus aus kaum Funktionalität mit - stattdessen laufen benötigte Feaatures in Docker-Containern (z. B. Service-Discovery) - Betriebssystem und Business-Apps sind durch Docker voneinander entkoppelt.
* Komponenten:
  * Kernel (= Linux)
  * systemd
  * etcd
  * ssh
  * docker engine
  * Update Agent 
* basiert auf Chrome OS, das Google entwickelt hat, um in seinen Chrome-Geräten (Chromebook) mit besonders wenig Speicher eingesetzt zu werden
* Root-Dateisystem ``/`` ist nur im Lesemodus eingehangen ... man kann gar keine Konfigurationsänderungen dort persistieren
* Updates werden über den Update-Agent von außen getriggert. Bei einem Update wird das Root-Dateisystem nicht verändert, sondern ein neues angelegt - neben das alte gelegt und nur entsprechend im Bootloader verlinkt
  * dadurch sind Restores einer beliebigen älteren Version denkbar einfach
  * da CoreOS recht klein ist, ist es kein Problem viele Versionen vorzuhalten
  * führt den Docker-Gedanken ephemeral Containers (Container als Wegwerfprodukt) ins Betriebssystem fort. Die "teure" Konfiguration wird persistent außerhalb der Betriebssystem-Dateien in ``Etcd`` gespeichert und wird dann nur in das Betriebssystem eingehangen

---

# Getting Started ...
Da ich mich noch für keinen Cloud-Provider entschieden habe

---

# Etcd
* der Name steht für ``etc distributed`` (in Anlehnung an das unter Linux übliche Konfigurationsverzeichnis ``/etc``) 
* Key-Value-Store zur Speicherung der OS-Konfiguration
* Etcd ist clusterfähig, d. h. Änderungen auf einem Knoten werden automatisch auf die clustered Knoten repliziert, d. h. der Administrator muß sich darum gar nicht kümmern. Tools wie cfEngine, Puppet, Chef, Ansible, Salt werden für diesen Aspekt nicht benötigt
  * das ist aufgrund der Volatilität der Landschaft (typisch für skalierende Anwendungen)
* HTTP Schnittstelle, so daß auch Docker-Container diese Komponente für persistente clusterfähige Konfiguration nutzen könnten
* es gibt einen Master ... fällt der aus, so wird automatisch ein neuer gewählt (Master-Election)

## Etcd-Discovery

--- 

# Fleet
* Fleet ist ein Systemd-Dienst, der für die gleichzeitige Ausführung von (Wartungs-) Aufgaben im CoreOS-Cluster verantwortlich ist
* Fleet-Instanzen auf allen Knoten kommunizieren miteinander und führen dann über die lokalen Systemd-Instanzen Befehle aus
* ``fleetctl`` als Scheduler/Controller zur Verwaltung des Deployment-Clusters
  * Alternativen:
    * [Kubernetes](kubernetes.md)
    * Mesos
    * Docker Swarm 

--- 

# Cloud-Provider Support
Jeder größere Cloud-Provider unterstützt CoreOS Images (Amazon EC2, Microsoft Azure, Google Compute Engine, DigitalOcean, ...)



------------------

# Cloud Software
## OpenStack - on premise
Ist ein Cloud-Computing Betriebssystem, um private (on-premise) Clouds aufzubauen