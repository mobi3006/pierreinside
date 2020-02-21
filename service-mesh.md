# Service Mesh - Handling per Sidecars

Bei der Umsetzung von Microservices entsteht ein Netz aus Services (= Service Mesh). Netzwerk-Kommunikation ist bei Cloud-Native Applikationen im Gegensatz zu monlithischen Architekturen nicht mehr nur ein Nebenschauplatz oder ein einzelner technischer Concern (für den Zugriff auf die Datenbank), sondern die grundlegende Infrastruktur, ohne die kein Use-Case funktioniert, da der Use-Case von mehreren interagierenden Services implementiert wird. Ohne Use-Case kein Nutzen.

> "You want your network to be as intelligent and resilient as possible. You want your network to route traffic away from failures to increase the aggregate reliability of your cluster. You want your network to avoid unwanted overhead like high-latency routes or servers with cold caches. You want your network to ensure that the traffic flowing between services is secure against trivial attack. You want your network to provide insight by highlighting unexpected dependencies and root causes of service communication failure. You want your network to let you impose policies at the granularity of service behaviors, not just at the connection level. And, you don’t want to write all this logic into your application. You want Layer 5 management. You want a services-first network. You want a service mesh." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

---

## Motivation

Microservices - insbesondere in elastischen - Umgebungen werden immer komplexer und einen Teil dieser Komplexität

* Security (Policy Checks)
* Lastverteilung, Fail-over (Resilience)
* Traffic-Management
  * Canary Releases
  * A/B Testing
  * Request Routing in Abhängigkeit von Location, Service-Version, Endgerät, ...
* Monitoring/Telemetrie
* Authentifizierung
* Authorisierung
* SSL/Zertifikate
* Metriken
  * technisch
    * Response-Times
  * business
    * Quota
    * Anzahl von Aufrufen
* risikofreie Migration auf neue Services oder sogar neue Architekturen/Technologien - Canary Deployments (mit Service Splitter)
* Routing von Traffic auf Entwickler-Maschinen

möchte man aus den Services raushalten. Hierzu werden den Services sog. Sidecars beigestellt, die als Proxy rund um die Kommunikation anderer Service und des Service selbst dienen. Müssen sich die Services (und die dahinterstehenden Applikations-Teams) stattdessen um diese Aspekte selbst kümmern, ist entsprechendes Knowhow notwendig, die Lösungen divergieren, die Aspekte müssen mehrfach gewartet und getestet werden.

Sicherlich kann der Aufwand durch die Verwendung von Bibliotheken/Frameworks reduziert werden, ABER:

> "The problem with microservices frameworks is that there’s too much infrastructure code in services, duplication of code, and inconsistency in what frameworks provide and how they behave. Getting teams to update their frameworks can be an arduous process.
When these distributed systems concerns are embedded into your service code, you need to chase your engineers to update and correct their libraries, of which there might be a few, used to varying degrees. Getting a consistent and recent version deployed can take some time. Enforcing consistency is challenging. These frameworks couple your services with the infrastructure [...] When infrastructure code is written into the application, different services teams must get together to negotiate things like timeouts and retries. A service mesh control plane removes this. Service meshes are deployed as infrastructure that reside outside of your applications. [...] Microservices frameworks come with their set of challenges. Service meshes move these concerns into the service proxy and decouple them from the application code." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

> "Die Stärken einer transparenten Sidecar-Infrastruktur liegen auf der Hand: Die Entwicklung von Anwendungen wird von wiederkehrenden Aufgaben befreit und kann sich auf das Wesentliche – die Business-Logik – konzentrieren. Istio bietet so über Pilot, Mixer und den Envoy Proxy die notwendigen Funktionen für Betrieb und Überwachung eines Service Meshs für die Anwendung transparent an. Auch die Migration von bestehenden Anwendungen lässt sich recht einfach verwirklichen. Alle Features stehen unabhängig von Programmiersprache und Laufzeitumgebung zur Verfügung. Für OPs-Kollegen steht wiederum ein mächtiges Tool zur Verfügung, das es ermöglicht, Anwendungen genau zu überwachen und gezielt über das Regelwerk mit dem Service Mesh zu interagieren." ([jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261))

Je mehr Microservices man betreiben und somit managen muß, desto mehr profitiert man vom Sidecar-Ansatz.

### Sidecar-Proxy vs. Container-Orchestrator

Der Container-Orchestrator sorgt dafür, daß die Infrastruktur den definierten Erwartungen entspricht. Er startet und stoppt bei Bedarf Services. Er hat aber kein Wissen über die Anwendungslogik und kann somit Dinge wie Traffic-Management, Authentifizierung/Authorisierung, ... nicht abbilden. Diese Aspekte sind typischerweise in den Anwendungen implementiert ... zukünftig aber ausgelagert in Sidecar-Proxies.

> "Service meshes are a dedicated layer for managing service-to-service communication, whereas container orchestrators have necessarily had their start and focus on automating containerized infrastructure, overcoming ephemeral infrastructure and distributed systems problems. Applications are why we run infrastructure, though. Applications have been and are still the North Star of our focus. There are enough service and application-level concerns that additional platforms/management layers are needed." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

---

## Service Mesh Konzepte

> "Common physical networking topologies include star, spoke-and-hub, tree (also called hierarchical), and mesh. [...] nodes in mesh networks connect directly and nonhierarchically such that each node is connected to an arbitrary number (usually as many as possible or as needed dynamically) of neighbor nodes so that there is at least one path from a given node to any other node to efficiently route data. Mesh networks generally self-configure, enabling dynamic distribution of workloads. This ability is particularly key to both mitigate risk of failure (improve resiliency) and to react to continuously changing topologies. It’s readily apparent why this network topology is the design of choice for service mesh architectures. [...] A service mesh data plane (otherwise known as the proxying layer) intercepts every packet in the request and is responsible for health checking, routing, load balancing, authentication, authorization, and generation of observable signals. Service proxies are transparently inserted, and as applications make service-to-service calls, applications are unaware of the data plane’s existence. Data planes are responsible for intracluster communication as well as inbound (ingress) and outbound (egress) cluster network traffic. Whether
traffic is entering the mesh (ingressing) or leaving the mesh (egressing), application service traffic is directed first to the service proxy for handling. In Istio’s case, traffic is transparently intercepted using iptables rules and redirected to the service proxy." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

### Control Plane vs. Data Plane

In Anlehnung an die Trennung physikalischer Netzwerke, erfolgt auch die Trennung softwareseitiger Netzwerke (SDN = Software Defined Network) in einem Service Mesh.

**Data Plane:**

* hier kommunizieren die Services untereinander

**Control Plane:**

Das Control Plane ist das Hirn, das die Steuerung 
> "A service mesh control plane is called for when the number of proxies becomes unwieldy or when a single point of visibility and control is required. Control planes provide policy and configuration for services in the mesh, taking a set of isolated, stateless proxies and turning them into a service mesh. Control planes do not directly touch any network packets in the mesh. They operate out-of-band.
Control planes typically have a command-line interface (CLI) and user interface with which to interact, each of which provides access to a centralized API for holistically controlling proxy behavior. You can automate changes to the control plane configuration through its APIs" (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

Im Gegensatz zu einem phyiskalischen Netzwerk gibt es beim SDN keine Trennung zwischen Out-of-Band-Network (OOB) und In-Band-Network.

---

## Optionen zur Umsetzung einer Service Mesh Implementierung

Client Frameworks verlagern die gesamte Logik in JEDEN Service ... das ist wie oben bereits begründet keine gute Option und führte zur Entstehung von Service Mesh Architekturen, die in verschiedenen Ausbaustufen existieren, die im folgenden vorgestellt werden.

### API-Gateway aka Edge Proxy aka Ingress Proxy

> "API gateways address some of these needs and are commonly deployed on a container orchestrator as an edge proxy. Edge proxies provide services with Layer 4 (L4) to L7 management, while using the container orchestrator for reliability, availability, and scalability of container infrastructure." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

Hierbei sitzt vor den Services einer Microservice-Architektur EIN Proxy - nur dieser ist nach außen bekannt und routet die Anfragen ins Backend.

### Router Mesh

In dieser Architektur wird das API-Gateway um einen zentralen Router erweitert, über den die Services untereinander und teilweise auch nach außen kommunizieren.

### Proxy per Node

In dieser Architektur wird der zentrale Proxy des Router Mesh durch einen Proxy pro virtueller oder physischer Maschine (auf der mehrere Service laufen) ersetzt.

### Sidecar-Proxy

In dieser Architektur erhält JEDER Service seinen eigenen Proxy, über den er Requests erhält und Requests verschickt.

> "Typische Vertreter, die beim Beherrschen eines Service Mesh helfen sollen, basieren auf einem leichtgewichtigen Reverse Proxy, der als eigenständiger Prozess parallel zum Service-Prozess arbeitet. Dieser sogenannte Sidecar-Prozess kann dabei unter Umständen in einem eigenen Container, neben dem eigentlichen Service Container, deployt werden. Jede eingehende und ausgehende Service-Kommunikation erfolgt somit über das Sidecar." ([jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261))

> "Proxies are generally considered stateless, but this is a thought-provoking concept. In the way in which proxies are generally informed by the control plane of the presence of services, mesh topology updates, traffic and authorization policy, and so on, proxies cache the state of the mesh but aren’t regarded as the source of truth for the state of the mesh." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

> "In sidecar proxy deployments, you’ll typically find that local TCP connections are established between the service and sidecar proxy, whereas mutual Transport Layer Security (mTLS) connections are established between proxies" (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

In den Sidecar-Proxies lassen sich auch Fehler injezieren oder die Latenz künstlich zu erhöhen, um beispielsweise das Fehlerhandling eines Clients zu testen oder einen Chaos Monkey Ansatz zu fahren. Auf diese Weise könnte man auch einen Test-Mock injezieren, um so spezielle Situationen zu testen oder einen Use-Case nutzbar zu machen, ohne bereits alle Services dieser Use-Cases implementiert zu haben.

#### Sidecar-Proxy vs. API-Gateway

> "With respect to service meshes, one of the more notable lines of delineation is that API gateways, in general, are designed for accepting traffic from outside of your organization/network and distributing it internally. API gateways expose your services as managed APIs, focused on transiting north/south traffic (in and out of the service mesh). They aren’t as well suited for traffic management within the service mesh (east/west) necessarily, because they require traffic to travel through a central proxy and add a network hop. Service meshes are designed foremost to manage east/west traffic internal to the service mesh. Given their complementary nature, API gateways and service meshes are often found deployed in combination." (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

---

## Implementierungen

Einige Implementierungen funktionieren nur auf Container-Orchestrators ... andere auch auf anderen Platformen.

Service Mesh Implementierungen sind häufig in folgenden Programmiersprachen geschrieben - aus Performancegründen:

* C++
* Go
* Rust

### Istio

* [Homepage](https://istio.io/)
* [jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261)
* [jaxenter - Teil 2](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-2-72168)

**Architektur:**

> "Istio brings a collection of control-plane components (Mixer, Pilot, and Citadel) to pair by default with Envoy (a data plane) packaged together as Istio" (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

* Envoy Proxy

  > "Der Envoy Proxy, aus Performanzgründen in C++ entwickelt, wird als eigener (Docker) Container zusammen mit dem Container des Microservice gemeinsam in einen Kubernetes Pod deployt. Durch Veränderung der Einstellungen der IP-Tables kann sich das Sidecar unmerklich für den Microservice als “Man-in-the-Middle” in die Kommunikation einschalten. Mit diesem Modell können die Istio-Funktionalitäten auch noch nachträglich in vorhandene Microservice-Anwendungen integriert werden, ohne dafür die Microservices selbst zu verändern. Der Envoy steht in enger Kommunikation mit dem Mixer. Beide tauschen eine Menge an Telemetrieinformationen untereinander aus, welche dem Mixer erlauben, die gewünschten Policys zu ermitteln und diese an alle beteiligten Envoys weiterzuleiten. Darüber hinaus kümmert sich der Envoy noch um die Service Discovery, Load Balancing, Health Checks und Metrics. Zur Verbesserung der Resilienz werden Circuit-Breaker-Aufgaben von Envoy übernommen zusammen mit der Möglichkeit, per Fault Injection diese auch zu testen." ([jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261))

* Mixer

  > "Weiterführende Aufgaben des Mixer liegen darin, die Plattformunabhängigkeit von Istio herzustellen. Damit werden Eigenschaften und Eigenheiten der Laufzeitumgebungen von Envoy und den anderen Steuerungskomponenten von Istio fern gehalten. Die gesammelten Telemetriedaten werden an Monitoring-Systeme geschickt, um diese mit den notwendigen Informationen über das Verhalten des Service Mesh zu versorgen." ([jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261))

* Pilot

  > "Das Service Discovery wird durch den Pilot übernommen, indem dieser die Envoy Proxys mit den notwendigen Informationen versorgt. Diese Informationen ermöglichen dem Envoy unter anderem die Resilienz-Patterns (etwa Timeout, Retry und Circuit Breaker) umzusetzen. Auch die Themen A/B-Deployment und Canary Releasing wird durch dieses Zusammenspiel ermöglicht. Jeder Envoy verwaltet Load-Balancer-Informationen, die er vom Pilot erhält, wodurch der Envoy die Last optimal im Service Mesh verteilt." (([jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261)))

### Consul Connect und Envoy

* [Homepage Consul Connect](https://www.hashicorp.com/products/consul/service-mesh)

Connect ist ein Feature von Consul - Envoy läuft derzeit nicht unter Windows

### Linkerd

> "Linkerd contains both its proxying components (linkerd) and its control plane (namerd) packaged together simply as “Linkerd,”" (Buch O'Reilly: The Enterprise Path to Service Mesh Architectures)

* kann man in zwei Modi betreiben
  * Node Proxy Model
  * Proxy Sidecar

### Conduit

Kubernetes-only ... Conduit und Linkerd sind in Linkerd 2.0 ein gemeinsames Produkt.

---

## Einführung eines Service Mesh

Entweder führt man das Service Mesh gleich zu Beginn einer Architektur ein (Greenfield) oder - und das wird häufiger gemacht - man führt es in eine bestehende Architektur ein (Brownfield). Im Brownfield Fall geht man häufig auch sehr vorsichtig mit der Einführung neuer Features um. Hier lernt man mit der Anwendung und kann so Probleme/Risiken nach und nach entdecken.
