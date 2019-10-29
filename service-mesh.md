# Service Mesh - Handling per Sidecars

Bei der Umsetzung von Microservices entsteht ein Netz aus Services (= Service Mesh)

---

## Motivation

Microservices - insbesondere in elastischen - Umgebungen werden immer komplexer und einen Teil dieser Komplexität (Security, Lastverteilung, Fail-over, Monitoring, Authorisierung, SSL/Zertifikate, Metriken) möchte man aus den Services raushalten. Hierzu werden den Services sog. Sidecars beigestellt, die als Proxy rund um die Kommunikation anderer Service und des Service selbst dienen.

Müssen sich die Services (und die dahinterstehenden Applikations-Teams) um diese Aspekte selbst kümmern, ist entsprechendes Knowhow notwendig, die Lösungen divergieren, die Aspekte müssen mehrfach gewartet und getestet werden.

---

## Sidecar-Proxy Pattern

### Alternative - API-Gateway

---

## Implementierungen

### Istio

* [jaxenter - Teil 1](https://jaxenter.de/istio-einfuehrung-microservices-cloud-teil-1-71261)


