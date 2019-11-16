# Velocity Berlin 2019

---

## Tutorial - GitOps 101

* Zeit: Dienstag nachmittag
* [Inhalt](https://conferences.oreilly.com/velocity/vl-eu/public/schedule/detail/79407)
* [Tools](https://www.weave.works/technologies/gitops/)

### Speaker Michael Hausenblas

> "Michael Hausenblas is a developer advocate at AWS, part of the container service team, focusing on container security. Michael shares his experience around cloud native infrastructure and apps through demos, blog posts, books, and public speaking engagements as well as contributes to open source software. Previously, was at Red Hat, Mesosphere, MapR, and in two research institutions in Ireland and Austria." ([O'Reilly](https://conferences.oreilly.com/velocity/vl-eu/public/schedule/detail/79407))

### Outline

* Overview and motivation (what is GitOps, why is it relevant, for whom is it useful)
* Immutability and declarative control loops
* An example GitOps pipeline in action
* Challenges and limitations

---

## Tutorial - Bridging the gap between brownfield and greenfield applications with a service mesh

* Zeit: Dienstag nachmittag
* [Inhalt](https://conferences.oreilly.com/velocity/vl-eu/public/schedule/detail/79079)

### Outline

> "Learn how to maintain and secure networks between brownfield and greenfield applications, how to implement modern reliability and observability practices in legacy applications, and how a service mesh can simplify migration strategies
Discover available services" ([O'Reilly](https://conferences.oreilly.com/velocity/vl-eu/public/schedule/detail/79079))

### Session

* https://app.netlify.com/sites/silly-kare-e51a3e/deploys
* der Demand für Technologien wie Service Mesh, Cloud wurde nicht ausgelöst, weil es hype ist, sondern weil immer mehr Leute die Services nutzen ... das Smartphone hat das Internet als Use-Case erkannt und seitdem steigen die Skalierbarkeitsanforderungen dramatisch (wenn man Erfolg hat) neu erfunden
* Service Mesh vereinfacht die Implementierung dramatisch ... eine Datenbank wird einfach auf `localhost` angenommen - der Proxy kümmert sich um das Routing
* Security ... durch die Elastizität sind Firewall-Regeln kaum noch handelbar
* Services Meshes ermöglicht die Einführung neuer Architektur und Technologien in einem smooth way ohne Big Bang. Die Migrationslogik steckt in den Proxies

### Übung - Vorbereitung

Entweder nimmt man die Entwicklungsumgebung unter https://instruqt.com/hashicorp/tracks/app-migration oder installiert die Tools lokal:

* docker
* docker-compose
* https://shipyard.demo.gs/
* consul

Anschließend noch `git clone git@github.com:nicholasjackson/consul-migrating-brownfield-to-greenfield.git`.

### Übung - docker-compose

Starten Anwendung folgendermaßen starten:

* cd consul-migrating-brownfield-to-greenfield.git
* cd examples/getting_started
* docker-compose up

Consul ist erreichbar (http://localhost:8500/ui) und die Fake-Web-App (http://localhost:9090/ui). Doch WEB Adressiert API direkt - ohne ein Service mesh.

Das haben wir dann geändert - das Service-Mesh wanach haben wir die direkte Adressierung des API service vom Web-Service (abgeschaltet - docker-compose.yaml)

> UPSTREAM_URIS: http://api:9090 => UPSTREAM_URIS: http://localhost:9091

und nach einem `docker-compose down` neu gestartet. Das funktionierte, weil die Sidecar-Proxies bereits konfiguriert waren:

```hcl
connect {
    sidecar_service {}
}
```

### Übung - Kubernetes

Starten der Landscape:

```bash
cd examples/kubernetes
yard up
```

Kubernetes Admin Console findet man anschließend unter http://localhost:8443/.

---

## Session - Creating a scalable monitoring system that everyone will love

* Zeit: Mittwoch 11:35 - 12:15, Hall A6
* [Inhalt](https://conferences.oreilly.com/velocity/vl-eu/public/schedule/detail/78701)

---

## Session - The observability graph: Knowledge graphs for automated infrastructure observability

* Zeit: Mittwoch, 13:25 - 14:05, M1
* 