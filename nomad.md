# Nomad by HashCorp

* [Homepage](https://www.nomadproject.io/)

Nomad ist ein weiteres Tool aus dem Sortiment von HashiCorp. Es wird als Scheduler für Services (gestartet über einen sog. [Driver](https://www.nomadproject.io/docs/drivers/index.html)) verwendet. Einfacher ausgedrückt: hiermit werden Prozesse auf Worker-Maschinen gestartet.

Nomad sorgt auch selbständig dafür, daß die gewünschte Anzahl an Service-Knoten läuft, indem es kontinuierlich einen HealthCheck macht und bei Bedarf neue Knoten startet. Außerdem werden die Services auf Knoten gestartet, die die notwendigen Voraussetzungen (Betriebssystem, Ressourcen, ...) erfüllen. 

Sowohl Nomad Server als auch Nomad Clients/Worker werden in Produktiv-Szenarien auf verschiedene Regions verteilt (z. B. AWS: Availability Zones). Auf diese Weise wird die Verfügbarkeit verbessert.

Beim Rollout einer neuen Version bietet Nomad in der [Job Stanza](https://www.nomadproject.io/docs/job-specification/update.html) Unterstützung für

* Blue/Green Deployments
* Rollling Deployments
* Canary Deployments

> BTW: Nomad verwendet sehr ähnliche Konzepte wie bei [Terraform](terraform.md) ... auch ein HashiCorp Produkt.

---

## Architektur und Konzepte

* [Nomad Dokumentation - Architektur](https://www.nomadproject.io/docs/internals/architecture.html)
* [Nomad Dokumentation - Scheduling](https://www.nomadproject.io/docs/internals/scheduling.html)

Nomad besteht aus

* Nomad Server Cluster (mind. 3 Knoten)
  * Gehirn der Orchestrierung
  * erhalten Aufträge als Jobs per Nomad CLI oder Rest-API
  * interpretiert den Nomad Job und verteilt die Aufgaben auf die Nomad Client Agents, die es dann lokal ausführen
  * es gibt einen sog. Leader unter den Cluster Knoten, die anderen nennt man Follower
    * "The leader is responsible for processing all queries and transactions. Nomad is optimistically concurrent, meaning all servers participate in making scheduling decisions in parallel. The leader provides the additional coordination necessary to do this safely and to ensure clients are not oversubscribed." ([siehe hier](https://www.nomadproject.io/docs/internals/architecture.html))
  * Cluster Nodes natürlich auf verschiedene Datacenter verteilt, um entsprechende Ausfallsicherheit zu garantieren
* Nomad Client Agent
  * registrieren einen Nomad Client (aka Worker) beim Nomad Server Cluster und informieren regelmäßig über
    * Hardware Ressourcen
    * zur Verfügung stehende Driver (z. B. Docker)
  * führt die `tasks` der Jobs (mit dem `driver` als Controller lokal aus)  * berichtet über die verfügbaren Resourcen und die laufenden Services
  * aktualisiert u. U. Loadbalancer
* Region -> Nomad Server Cluster -> Nomad Server (verteilt auf unterschiedlicher Datacenter)
  * Föderation zwischen Regionen sind möglich
  * "Regions are fully independent from each other, and do not share jobs, clients, or state. They are loosely-coupled using a gossip protocol, which allows users to submit jobs to any region or query the state of any region transparently. Requests are forwarded to the appropriate server to be processed and the results returned. Data is not replicated between regions." ([siehe hier](https://www.nomadproject.io/docs/internals/architecture.html))

### Ports

Das sind die Standardports von Nomad Client und Server:

* 4646:
  * WEB UI (e. g. http://myserver:4646/ui)
  * REST interface (e. g. http://myserver:4646/v1/agent/health?type=server)
* 4647
  * Nomad Server RPC Check
* 4648
  * Nomad Server Serf Check

---

## Verfügbare Resourcen

Der Nomad Server Node muß wissen welche Target Nodes für die Ausführung von Aufgaben zur Verfügung stehen. Hierzu informiert der Nomad Client Agent kontinuierlich über die tatsächlich verfügbaren Resourcen (CPU, Speicher, Network-I/O, Plattenplatz, ...). Steht dann eine Aufgabe an, dann kann der Nomad Server einen passenden Target Node auswählen.

---

## Start Services auf Worker Maschinen

Für den Start eines Services auf einer Nomad Client Maschine (= Nomad Worker) stehen verschiedene [Driver](https://www.nomadproject.io/docs/drivers/index.html) zur Verfügung:

* Docker
  * derzeit (April 2019) kann Nomad **unter Windows** keine Docker-Linux container starten
* Java
* ...

Hierbei kümmert sich Nomad (definiert im Nomad-Job) auch um die Ressourcenzuweisung (z. B. Memory).

---

## Jobs

### Beschreibung

Die Beschreibung erfolgt in der HashiCorp Configuration Language (HCL).

> Job-Datei -> ein Job ->* group -> Evaluation -> Allocation ->* task

es wird der gewünschte Zustand beschrieben - Nomad ermittelt daraus in der Planungsphase die tatsächlichen Aktionen im Vergleich zum aktuell laufenden Setup. Sollte ein Service unhealthy werden (über einen im Job definierten Health-Check - kann unterschiedlich komplex sein - bei Spring Applikationen bietet sich die Actuator Health Endpoint an), den der Service anbieten muß), dann triggered Nomad automatisch ein Deployment.

Im Job werden die notwendigen Ressource-Anforderungen (Hardware, Architektur, Software (Betriebssystem, Kernel, Driver)) für einen Service definiert ... das ermöglicht dem Nomad Server einen passenden Nomad Client (= Worker) zu finden und mit einer Task zu beauftragen. Der Worker verwendet eine sog. Allokation, um die Task abzuarbeiten - ist die Task fertig, dann wird die Allokation gelöscht.

* [kleines Beispiel](https://www.nomadproject.io/docs/job-specification/index.html)
* [`job`](https://www.nomadproject.io/docs/job-specification/job.html)
* [`update`](https://www.nomadproject.io/docs/job-specification/update.html)
  * Canary Deployments ... zeichnen sich dadurch aus, daß eine weitere Instanz gestartet wird ... zusätzlich zu den existierenden. Wenn die Canary Instanz für gut befunden wurde (siehe `health_check` Property), dann erfolgt ein Rolling Update
* `group`
  * ["The group stanza defines a series of tasks that should be co-located on the same Nomad client. Any task within a group will be placed on the same client."](https://www.nomadproject.io/docs/job-specification/group.html)
  * jede Task-Group hat eine entsprechende Allokation auf der zum Job-Ausführungszeitpunkt ausgewählten Nomad-Client
* `task`
  * kleinste ausführbare Einheit
  * wird von einem `driver` ausgeführt

Für jede Service-Instanz wird eine eigene Allokation erzeugt, d. h. zur Ausführungszeit werden aus einem Job 1-n Allokationen, die auf den Nomad-Workern ausgeführt werden. Hinter jedem laufenden Service steht eine Allokation.

### Ausführung

Nomad Jobs werden explizit durch den Admin (per `nomad job plan my-job.nomad`) oder durch Nomad selbst (wenn ein Service nicht mehr erreichbar ist ... hierzu benötigt der Service entsprechende Health-Check Services) geplant (sog. Evaluation), d. h. hier wird ermittelt, welche Aktionen (sog. Allocation ... auf den Nomad-Clients kann man die Allocation-Logs auf dem Filesystem ansehen) auszuführen sind. Beispiel:

> Ein Service soll nun mit 3 Instanzen bereitgestellt werden (ist jetzt so im Job geändert worden). Derzeit laufen aber nur 2.

In diesem Fall würde in dem Plan ermittelt, daß eine weitere Instanz zu starten ist.

Den Evaluation-Plan macht der sog. Evaluation Broker - ein Scheduler, der den fertigen Plan (enthält auch schon die zu nutzenden Worker Nodes) zum Leading Nomad Server zwecks Ausführung schickt. Bis hierher wurden noch keine Resourcen reserviert, d. h. es kann vorkommen, daß Evaluation Plans erstellt wurden, die im Konflikt stehen. Dieses optimistische Planing wird vom Leading Nomad Server aufgelöst ... entweder kommen dann Pläne nur teilweise oder gar nicht zur Ausführung.

Vor der Ausführung eines Jobs via `nomad job run my-job.nomad`, sollte man den Plan generieren lassen und prüfen.

Unter `/var/lib/nomad/alloc` findet man die Allokationen des Jobs. Hier sind u. a. auch Log-Files zu finden.

---

## Nomad Befehle

* [Dokumentation](https://www.nomadproject.io/docs/commands/index.html)

Die Nomad-Befehle werden mit dem Binary `nomad` abgesendet und vom Nomad Agent (auf Server oder Client) interpretiert/ausgeführt.

* `nomad agent`
  * startet einen Nomad Agent (i. a. wird man den Agent als Service beim Rechnerstart starten)
* `nomad agent-info`
  * Ausgebe sieht auf einem Nomad Server Agent natürlich anders aus als auf einem Nomad Client Agent
* `nomad status`
  * `nomad status myservice`
* `nomad server`
* `nomad job plan my-job.nomad`
  * hierbei wird auch ein "Job Modify Index" angegeben, den man als Bedingung für die Ausführung eines Jobs angeben kann (siehe unten)
* `nomad job run my-job.nomad`
  * noch besser: `nomad job run -check-index 41047 my-job.nomad`
    * Ausführung mit optimistischem Locking ... die Planung, die der Admin i. a. kritisch beäugt, werden die durchzuführenden Aktionen ermittelt und ausgegeben. Wenn der Admin diese für sinnvoll hält, dann startet er die Job-Ausführung. Die Situation kann sich dann aber geändert haben und der Admin würde in dieser neuen Situation den Job nicht zur Ausführung bringen. Genau für diesen Fall kann man die Ausführung eines Jobs an einen bestimmten Status (sog. Job Modify Index) binden ... hat sich der Status mittlerweile geändert, erfolgt keine Ausführung.
  * mit diesem Kommando kann auch ein Re-Deployment des Services getriggert werden, z. B. wenn man die Konfiguration geändert hat, die in einem [Consul](consul.md) liegt und bei Start der Anwendung einmalig gezogen wird. Ohne eine Änderung am aktuellen Status, muß keine neue Allokation erzeugt werden.
* `nomad job stop myService`
  * wenn ein Service nicht startet (z. B. weil ein Fehler in der Konfiguration vorliegt oder die Applikation einen Fehler hat), dann würde aufgrund des automatischen Re-Deployments von Nomad (wenn der Zielzustand nicht erreicht ist - Healthcheck) immer wieder eine erneute Allokation gestartet. In diesem Fall macht es Sinn, die Ausführung des Jobs zu stoppen. Ansonsten würde sich der Nomad-Server in einer Endlosschleife befinden.

---

## Nomad UI

Jeder Nomad-Agent (auf Server und Client) bietet ein WEB-UI, das für Gelegenheitsnutzer zur Informationsbeschaffung ganz nützlich ist. Zur Administration (durch Admins) wird man dennoch zur CLI greifen ;-)