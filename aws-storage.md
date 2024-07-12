# AWS Storage

* [S3](aws-s3.md)
* EBS - Elastic Block Storage
* DynamoDB
* RDS/Aurora
* EFS - Elastic File System
* Amazon FSx

---

# Block vs Object

Bei einem Block Storage (z. B. EBS-Volume) wird ein Datei in vielen kleinen Blöcken gespeichert, beim Object Storage hingegen in einer EINZIGEN Einheit.

Aus diesem konzeptionellen Unterschied ergeben sich unterschiedliche Einsatzzwecke

* Object Storage: write-once-read-many (WORM)
  * das Ändern eines einzelnen Zeichens in einem 1 GB Objekt bedeutet, dass das ganze Objekt neu geschrieben werden muss
  * z. B. für Bilder
* Block Storage:
  * das Ändern eines einzelnen Zeichens in einem 1 GB Objekt bedeutet, dass das nur ein/wenige Blöcke neu geschrieben werden müssen => sehr viel effizienter bei hohen Änderungsraten
  * beim Lesen kann man direkt auf den wichtigen Block zugreifen
  * z. B. für Betriebssystem-Dateien (die häufiger geändert werden, z. B. log-files)

## Fotos/Videos - welcher Storage Typ

Für Fotos und Videos gilt das write-once-read-many (WORM) Paradigma. Man würde es in einem Object-Storage speichern und nicht in einem Block-Storage. Warum ist den EBS nicht geeignet?

* kann nur an eine einzige EC2 Instanz gehangen werden
  * S3 ist übers Internet von überall aus erreichbar
* kein Support für Replikation
  * kein Support für CloudFront
* kein elastisches Speichermedium (vordefinierte Größe)
* kein Support für eine Weitervearbeitung über Lambda-Trigger
* S3 unterstützt sehr kostengünstige Speicherung (für Daten, die selten gelesen werden)

---

# EBS - Elastic Block Storage

* verwendet man i. a. in EC2 Instanzen, wenn der Instanz-Speicher (integraler Part der EC2-Instanz ... hier liegt das Betriebssystem - ephemeral)
* ein EBS kann an eine EC2 Instanz attached werden ... es hat seinen eigenen Lifecycle, d. h. selbst wenn die Instanz terminiert bleibt das EBS-Volume erhalten und kann an die nachfolgende Instanz gehangen werden (mount)
* kann nur an eine EC2 Instanz gehangen werden => EFS kann mehrere EC2 Instanzen bedienen
  * Amazon hat ein EBS-multi-attach Feature angekündigt!
* support für Snapshots - werden automatisch von AWS auf S3 abgelegt

---

# EFS - Elastic File System

* [Amazon Elastic File System](https://aws.amazon.com/efs/)

* vergleichbar mit einem NFS (Network File System) ... viele Nutzer können gleichzeitig darauf zugreifen
* man muss vorher keine Größe bestimmen
  * es wächst und schrumpft je nach Nutzung (elastisch)
  * man zahlt nur was man tatsächlich nutzt