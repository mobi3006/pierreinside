# Konfiguration Management
Konfiguration Management erfährt im Zuge des Cloud Computings Renaissance. Um Elastizität (Anpassung der genutzten Ressourcen an die vorhandene Last) zu erreichen werden Instanzen einer Applikation hoch- und runtergefahren. Eine Anpassung der Konfiguration sollte mittlerweile ohne Downtime möglich sein, um so schnell reagieren zu können. Zudem wird clusterfähige Konfiguration (viele Knoten) benötigt.

---

# Netflix Archaius
Hierbei handelt es sich um einen dateibasierten Ansatz, der sich wunderbar in vorhandene Applikationen integriert, die i. a. auch schon auf Property-Files setzen ... allerdings werden die dann nur zur Deployzeit ausgelesen.

Archaius liest die Konfigurationsdateien in regelmäßigen Abständen aus und aktualisiert sie demenstprechend.

---

# Zookeeper
Eine der ersten Konfigurationsdatenbanken ... mittlerweile in die Jahre gekommen, komplex und ressourcenhungrig (Java basiert) - dafür aber großes Featureset.

---

# etcd
``etcd`` ist Bestandteil des CoreOS und damit bekannt geworden. 

HTTP-Schnittstelle.

