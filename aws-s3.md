# AWS S3

Hierbei handelt es sich im wesentlich um ein Network-Filesystem, das aus weltweit eindeutigen Buckets besteht, die wiederum Dateien (= Objects) enthalten. Strenggenommen kennt S3 keine Folder - das was den Anschein eines Folders macht ist in Wahrheit nur ein Namensprefix.

Diese Buckets können

* versioniert
* verschlüsselt
* repliziert (intra-Account + Cross-Account)
* auf andere Speichermedien ausgelagert (um Kosten zu sparen)

Bucket sind privat oder öffentlich.

Das besondere an Buckets ist, dass sie in einer Region gespeichert werden (die Latency wird dadurch evtl. negativ beeinflusst), der Name aber global eindeutig sein muss. Durch die Eindeutigkeit durch den Namen ist die ARN eines Buckets sehr einfach z. B. `arn:aws:s3:::reportbucket987966` ... hier sind keine AWS-Account-ID und Region enthalten - über den Namen kann AWS das dann leicht sehr herausfinden (wenn nötig).

---

# Versionierung

Versionierung wird auf dem Bucket enabled ... nicht auf einzelnen Objekten. Schaltet man irgendwann die Versionierung auf einem Bucket ein, dann bekommen die bereits existierenden Objekte die Version `null`. Löscht man ein versioniertes File, so sieht man es nicht mehr in der Normal-Ansicht ... erst wenn man _Show Versions_ selektiert, dann sieht man die älteren Versionen. Ein Delete auf einem Bucket mit Version-enabled setzt nur einen Delete-Marker ... so kann man sicher löschen, da man immer wieder restoren kann.

Wie so häufig ist das AWS UI nicht besonders intuitiv. Wenn man ein gelöschtes Objekt restoren will, dann muss man auf der Version mit dem Delete-Marker ein Delete mit der Confirmation "permanently delete" ausführen. Klingt erstmal genau falsch ... hier hätte man doch auch einfach einen Restore-Button spendieren können. Dieses "permanently delete"-Handling liegt daran, dass AWS bei eingeschaltetem "Show Versions" keinen Delete-Marker setzt, sondern tatsächlich physisch löscht. Alles in allem hätte man das UI bei einer so wichtigen Aktion besser gesatlten können ...

> Löscht man hingegen ein ganzes Bucket, dann hat man kein Backup mehr ... **ACHTUNG**

Will man auf ältere Versionen eines Objekts zugreifen so benötigt man neben der `s3:GetObject` noch die `s3:GetObjectVersion` Permission.

## 2FA für Löschungen

Man kann auf einem S3-Bucket eine Zwei-Faktor-Authentifizierung für Löschungen erzwingen (aktuell aber nicht via Admin Console).

## Lock

Man kann auch Objekte durch ein Lock-Feature auf Objekt und Bucket-Level vor Änderungen schützen.

---

# Tagging

Wie so fast jede AWS Ressource lassen sich auch S3-Buckets taggen. Auf diese Weise lassen sich

* Permissions steuern (Tag-Based-Access-Control)
* Kosten im Blick behalten

---

# Private vs Public

Defaultmässig sind neue Buckets aus Sicherheitsgründen nicht public, d. h. man kann sie aus dem Internet nicht lesen.

Zustätzlich hat ein Bucket keine Bucket-Policy attached, so dass niemand Berechtigungen hat, darauf zuzugreifen. Hier benötigt man einen Bucket-Policy oder ACLs.

Will man also einen Bucket öffentlich verfügbar machen (z. B. um Fotos zu teilen), dann muss man

1. den Bucket PUBLIC machen
2. eine Bucket Policy konfigurieren, die JEDEM den lesenden Zugriff erlaubt

---

# Bucket Policy vs ACL

Es wird mittlerweile empfohlen keine ACLs mehr zu verwenden, sondern stattdessen Bucket Policies. Mit Bucket Policies gehören ALLE Objekte dem Account in dem der Bucket angelegt wird - bei ACLs können die Objekte unterschiedlichen AWS Accounts gehören (z. B. definiert über den _Object Writer_).

Zugriffsberechtigungen werden entweder über ACLs (auf Object-Ebene) oder Bucket Policies (auf Bucket-Ebene für ALLE Objekte) definiert.

Für die Erstellung der Bucket-Policy kann der Policy-Generator verwendet werden. I. a. erteilt man eine IAM-Role oder einer Usergruppe Zugriffsberechtigungen.

---

# Static Website


---

# Presigned URLs

Hiermit kann man einzelne Files eines privaten Buckets für eine kurze Zeit (max. 12 Stunden) zur Nutzung ohne Authentifizierung (durch den Nutzer) als URL bereitstellen. Die Authentifizierung erfolgt mit der Identität des Herausgebers - sie ist in der URL verbacken.

---

# S3 für Big-Data

* [Why and When to Avoid S3 as a Data Platform for Data Lakes](https://towardsdatascience.com/why-and-when-to-avoid-s3-as-a-data-platform-for-data-lakes-c802947664e4)

Für Big Data Analysen bietet AWS Tools, um die Daten performant aus den Textdateien (JSON) zu suchen.

Interessant ist hierbei, dass S3 eigentlich ein Object-Store ist, der für gezieltes Lesen kleinerer Datenblöcke nicht unterstützt und ein Update auf einer Datei ist abgebildet als Schreiben der gesamten Datei (Konzept "Dateien sind Immutable"). Allerdings bietet S3 auch Vorteile:

* auf JEDEM Prefix eines Buckets die VOLLE Lese/Schreib-Perfomance. Auf diese Weise können viele Lesevorgängen GLEICHZEITIG durchgeführt werden.
* S3 bietet mit verschieden teuren/Leistungsfähigen Storage-Typen (mit automatisierter Lifecycle-Policy, um Daten umzulagern) ein ideales Umfeld für alternde Daten, die zwar evtl. behalten werden müssen, aber dennoch billig in der Speicherung sein sollten (aka Cold Storage).

Aus diesem Grund hat man Wege erfunden, die Nachteile zu adressieren ... weil die Vorteile signifikant sind.

---

# AWS CLI

## aws s3 mv vs aws s3 sync

Ein `aws s3 mv` verschiebt ein Objekt in einen anderen Bucket oder eine andere Stelle im aktuellen Bucket.

Wenn man Versioning auf dem Bucket enabled hat, dann bekommt das verschobene Objekt einen Delete-Marker und die History wird nicht übernommen. Benötigt man die History, dann sollte man stattdessen ein `aws s3 sync --delete` verwenden.

---

# Minio

* [Verwendung der aws-CLI](https://docs.minio.io/docs/aws-cli-with-minio.html)

Minio ist eine S3 kompatible Implementierung, die man beispielsweise in Hybrid-Szenarien (in denen sowohl AWS als auch Onprem supported werden muß) einsetzen kann. Minio kann über die `aws`-CLI mit der gleichen Konfiguration (in `~/.aws`) verwendet werden. Man muß nur per Parameter den Parameter `--endpoint-url`-Parameter verwenden, um den "S3"-Server zu definieren.

```bash
aws --profile play.min.io --endpoint-url https://play.min.io:9000 s3 ls
```

Bei dieser Verwendung werden weitere Konfigurationen (AWS-Credentials, Region des Buckets, ...) aus `~/.aws/config`

```ini
[play.min.io]
region = us-east-1
```

und `~/.aws/credentials`

```ini
[play.min.io]
aws_access_key_id = Q3AM3UQ867SPQQA4AAAA
aws_secret_access_key = zuf+tfteSlswRu7BJ86wekitnifILAaBbZbb
```

beigesteuert.