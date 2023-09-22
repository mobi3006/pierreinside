# AWS S3

Hierbei handelt es sich im wesentlich um ein Network-Filesystem, das aus weltweit eindeutigen Buckets besteht, die wiederum Dateien enthalten.

Diese Buckets können

* versioniert
* verschlüsselt
* repliziert (intra-Account + Cross-Account)
* auf andere Speichermedien ausgelagert (um Kosten zu sparen)

Bucket sind privat oder öffentlich.

Das besondere an Buckets ist, dass sie in einer Region gespeichert werden, der Name aber global eindeutig sein muss.

---

## Static Website


---

## Presigned URLs

Hiermit kann man einzelne Files eines privaten Buckets für eine kurze Zeit (max. 12 Stunden) zur Nutzung ohne Authentifizierung (durch den Nutzer) als URL bereitstellen. Die Authentifizierung erfolgt mit der Identität des Herausgebers - sie ist in der URL verbacken.

---

## Queries

Für Big Data Analysen bietet AWS Tools, um die Daten performant aus den Textdateien (JSON) zu suchen.