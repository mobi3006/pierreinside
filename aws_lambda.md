# AWS Lambda

Einer der wohl beliebtesten (neben AWS S3) serverless Ansätze. Hiermit lassen sich Event-Driven Architectures sehr effizient umsetzen (hierbei wird asynchrones Processing verwendet, das sehr effizient mit Ressourcen umgehen kann und für den Nutzer minimale Wartezeit erzeugen). Der Entwickler kann sich hier voll und ganz auf seinen Applikationscode fokussieren und muss sich nicht um Server kümmern. Man zahlt pro Request und Compute-Zeit ... ein faires Modell (insbes. für Startups) - im Extremfall zahlt man gar nichts.

> Natürlich führen im Hintergrund dennoch EC2 Instanzen und damit auch echte Hardware den Code aus. Aber diese Infrastruktur wird von AWS gemanaged und ist somit sogar nahezu vollkommen unsichtbar. Es ist eine Abstraktionsschicht, die die unterliegende Implementierung verbirgt. Auch S3, AWS RDS, DynamoDB, ... sind Serverless-Services.

Aus meiner Sicht diese Ansätze der größte Benefit der Cloud für Startups, die ohne oder minimalem Budget vollkommen ohne Risiko ihre Ideen anbieten und bei Erfolg automatisch skalieren. Bei Erfolg entstehen natürlich Kosten, aber die werden dann mit großer Wahrscheinlichkeit dann auch von den Nutzern oder einem Investor bezahlt.

> Auf diese Weise können professionelle Anwendungen entstehen, die auf den Kunden wie das Ergebnis einer mittelgroßen Unternehmung wirken, aber vielleicht nur das Ergebnis eines kleinen Studententeams ist. Hätte es sowas doch nur zu meiner Studienzeit gegeben ...

Deshalb ist AWS Lambda für mich ein Sinnbild wie die Cloud Innovation vorantreibt.

> Achtung: rekursive Aufrufe (entweder explizit oder implizit) können bei falschen oder fehlenden Abbruchbedingungen teuer werden.

---

## Überblick

* viele unterstützte Programmiersprachen
  * mit einem Docker Image Deployment lässt sich das unendlich erweitern
* Auto-Scaling
* 15 Minuten Compute-Time Maximum ... danach timeout
  * das sollte bei einer event-driven Architektur aber für die meisten Use-Cases ausreichen
* stateless
* synchron (BE AWARE: das könnte bis zu 15 Minuten dauern) und asynchron
  * User-triggered Lambda-Calls (z. B. im WebUI-Development Environment siehe unten) sind immer synchron
  * manche Services können nur asnchron als Trigger (S3, SNS, SQS, CloudWatch Events, EventBridge, AWS CodeCommit, AWS CodePipeline, ...) verwendet werden
  * bei synchronen Lambda-Calls muss sich der Client selbständig um einen evtl. Retry kümmern - bei asynchronen Calls übernimmt das die Lambda-Funktion selbst (sofern entsprechend konfiguriert)
    * aus diesem Grund sollten Lambda-Functions idempotent sein
    * man sollte eine Dead-Letter-Queue definieren, um die unverarbeiteten Calls aufzunehmen und dem User eine Chance zum Reprocessing zu geben
* der zugewiesene Memory bestimmt auch die bereitgestellte CPU Power

---

## Konzepte

### 15 Minuten

Lambda-Functions müssen nach 15 Minuten beendet sein ... danach werden sie hart abgebrochen. Das zwingt den Designer eines komplexen Workflows den Workflow in kleinere Teile zu stückeln, die alle innerhalb dieses Zeitfensters beendet werden können. Dies wiederum führt evtl. zu sehr kleinen Einheiten, die allesamt innerhalb weniger Sekunden beendet werden können. Dieses Design kann positive Auswirkungen auf die Skalierbarkeit der Anwendung und die Resilienz haben.

Man könnte sagen, dass die Limitierung auf 15 Minuten - gepaart mit der stateless Anforderung, den Designer der Anwedung zu einem besseren Design zwingt. Einzelne Steps eines komplexen Workflows können über Event-Queues aneinander gereiht werden.

### Permissions

Jede Lambda-Function hat eine IAM-Role attached, die regelt welche Berechtigungen die Lambda-Function hat, um andere Services aufzurufen. Es gibt einige Managed Policies für bestimmte Use-Cases (z. B. `AWSLambdaBasicExecutionRole` mit der man nach CloudWatch logs schreiben kann), die man leicht zur Role der Lambda-Function hinzufügen kann.

> Best-Practice: JEDE Lambda-Function hat seine eigene IAM-Role (Least-Privileges)

Um anderen Services Berechtigungen zum Aufruf der Lambda-Fucntion zu geben, verwendet man Resource-Based-Policies (ganz ähnlich wie für S3- Buckets).

### Lambda-Function Parameters

```
def lambda_handler(event, context):
  print(event.source)
  print(event.region)

  print(context.aws_request_id)
  print(context.function_name)
  print(context.memory_limit_in_mb)
  print(context.log_stream_name)
  print(context.log_group_name)
```

* Event Object
  * enthält Informationen über das Trigger-Event (z. B. S3-Bucket und das erzeugte Objekt)
* Execution Context
  * enthält Informationen über die Lambda-Function (z. B. Speicher, CloudWatch-LogStream) und sein Runtime-Environment (z. B. Python Version)
  * enthält bereits initialisierte Komponenten (z. B. Datenbank-Connection)
  * enthält `/tmp` Filesystem, das zum Teilen von Daten genutzt werden kann
  * der Execution Context steht nachfolgenden Requests ohne erneute Initialisierung zur Verfügung
    * DESHALB: hier SOLLTE die Initialisierung einer (teuren) Datenbank-Connection erfolgen, um beim nächsten Call die bestehende Connection weiternutzen zu können

      ```
      import os

      DB_URL = os.getenv("DB_URL)
      db_client = db.connect(DB_URL)

      def lambda_handler(event, context):
        db_client.get(...)
      ```

### Lambda-Destination

Für asynchrone Lambda-Calls kann man Destinations verwenden, um über erfolgreiche und fehlerhafte Event-Prozessierungen zu informieren. Destinations sind:

* Amazon SQS
* Amazon SNS
* AWS Lambda
* Amazon EventBridge

> Destinations sind relativ neu und ersetzen die Dead-Letter-Queue (die als Ziel auch nur SQS und SNS unterstützt), die man bei asynchronen Lambdas-Prozessierungen für den Fehlerfall verwendet.

Die Destination wird automatisch mit den Events gefüttert ... je nachdem ob die Verarbeitung des Events erfolgreich war oder fehlgeschlagen ist.

### Synchroner Call

```
aws lambda invoke \
   --function-name mobi3006-lambda-python \
   --cli-binary-format raw-in-base64-out \
   --payload '{"key1":"value1", "key2":"value2", "key3":"value3"}' \
   --log-type Tail \
   response.json
```

`--log-type Tail` funktioniert nur bei synchronen Calls und liefert Base64 encodierte Logs, die dann per

```
echo "TG9hZGluZyBm...foobar" | base64 -d
```

dekodiert werden können. Das ist sehr praktisch für die Fehleranalyse.

### Asynchroner Call

```
aws lambda invoke \
   --function-name mobi3006-lambda-python \
   --cli-binary-format raw-in-base64-out \
   --payload '{"key1":"value1", "key2":"value2", "key3":"value3"}' \
   --invocation-type Event \                                               <====
   response.json
```

In diesem Fall bekommt man bei einem erfolgreichen Aufruf eine HTTP 202 (Request wurde angenommen aber noch nicht verarbeitet) anstatt 200. Schlägt der Aufruf fehl, so bietet sich die Konfiguration einer Dead-Letter-Queue (deprecated) oder Destination an.

Bei asynchroner Verarbeitung übernimmt AWS Lambdy auch das Retry, wenn bei der Ausführung etwas schiefgehen sollte. Die Anzahl der Retries lassen sich konfigurieren Zumeinst erfolgt das Retry

### Lambda Polling

Events werden

* entweder von den AWS Services nach Lambda gepushed
* oder werden von Lambda gepolled (von SQS, Kinesis Data Streams, DynamoDB Streams)

### Event Source Mapping

Hierbei handelt es sich um eine AWS Lambda Komponente, die von einer Event Source (z. B. Queue) liest und eine Lamda-Function aufruft.

Wird beim Lambda Polling (von SQS, Kinesis Data Streams, DynamoDB Streams) eingesetzt.

### Lambda Layers

...

### Lambda Versions

* jedes mal wenn man den Code der Function verändert und den DEPLOY Button drückt, wird eine neue Version bereitgestellt
* es gibt auch die `LATEST` Version

### Environment Variablen

Über Umgebungsvariablen lässt sich eine Lambda-Function ohne Codeänderung beeinflussen. Hier können beispielsweise auch Secrets (über KMS encrypted) contributed werden.

### Cloudwatch Logs und Metrics

Ausgaben der Lamda Functions (z. B. via Python `print("Pierre")`) landen automatisch in CloudWatch. Hierzu wird bei der Anlage der Function über die WebUI (Admin-Console) eine Rolle mit der Berechtigung auf Cloudwatch angelegt.

### Tracing mit X-Ray

Muss man explizit in der Function einschalten. Im Hintergrund arbeitet dann ein X-Ray Daemon. Die ausführende IAM Role muss dann auch entsprechende Berechtigungen haben (z. B. Policy `AWSXRayDaemonWriteAccess`), um die Traces wegschreiben zu können.

> Enabled man X-Ray-Tracing über die Admin-Console, dann wird die Rolle **automatisch** um die notwendige Berechtigung erweitert.

### VPC

* Lambdas werden by default **ausserhalb** des eigenen VPCs gestartet - sie laufen stattdessen in einem AWS-managed VPC
  * deshalb können sie nicht auf Ressourcen innerhalb MEINES VPC (EC2, RDS, ...) zugreifen
  * sie können aber auf Public-Cloud (Internet-APIs zugreifen)
* über Konfiguration kann man eine Lambda-Function (komfortabel über die Admin-Konsole) in einem privaten VPC starten
  * damit verliert man aber den Zugriff aufs Internet, den man über NAT/InternetGateway selbst konfigurieren muss
  * damit verliert man aber den Zugriff auf AWS Services (z. B. DynamoDB), den man über VPC-Endpoints selbst konfigurieren muss
  * dafür bekommt man aber Zugriff auf die Ressourcen innerhalb des 
* man bekommt eine Integration mit den Ressourcen aus dem eigenen VPC durch entsprechende Konfiguration von ENI mit einer Security-Group drumherum (die der Lambda-Function den Zugriff erlaubt). Um die Ressource des VPC erweitert man die - vermutlich bestehende - Security-Group um eine Kommunikation mit der ENI-SecurityGroup.
  * die Lambda-Function braucht in diesem Fall die `AWSLambdaVPCAccessExecutionRole` 

### Concurrency

Lambdas skalieren automatisch, d. h. die Lambda-Functions werden dann parallel ausgeführt. Allerdings geschieht das nur bis zu einem regionen-abgängigen Maximum. Wenn das erreicht ist, dann bekommt man einen "Rate Exceeded" Fehler.

### Docker Container

Die Lambda Function kann in verschiedenen Sprachen zur Verfügung gestellt werden oder aber auch in einem Docker Image, von dem Lambda dann einen Docker Container startet. Das macht Sinn, wenn die Function noch weitere Laufzeitkomponenten oder Konfigurationen benötigt. Auf diese Weise könnte man den Code beispielweise auch lokal sehr schön testen - allerdings kostet der Download des Image auch ein bisschen Geschwindigkeit.

### Deployment Package

Neben der Lamda Function kann das Deployment Package weitere Komponenten bereitstellen, die zur Ausführungszeit benötigt werden (z. B. Libraries).

Im Extremfall verwendet man eine Docker Image, das sogar OS-Packages bereitstellen kann.

> Auf diese Weise kann die Lambda-Function stabiler gemacht werden ... ansonsten muss sie in dem Execution Environment laufen, das von AWS defaultmäßig bereitgestellt wird ... und das kann sich jederzeit ändern

---

## Development Environment

Die AWS-Console bietet hier eine - im Gegensatz zu vielen anderen Bereichen - eine Art Entwicklungsumgebung an, über die man die Function bearbeiten, testen (mit einem Editor zur Erzeugung eines Trigger Events) und deployen kann. Hier bekommt man sogar einen Direct-Link in die CloudWatch-Logs und X-Ray Trails ...

Legt man die Lambda-Function per AdminConsole-WebUI an, so wird automatisch eine IAM-Rolle angelegt, mit der die Function läuft. Dadurch erhält die Function automatisch Zugriff auf CloudWatch, um Logging durchzuführen. Ähnlich verhält es sich mit vielen weiteren Integrationen auf Trigger/Destination-Ebene ... die Permissions werden häufig automatisch erweitert.

> Wenn man Terraform verwendet und die Policies manuell erstellen muss, dann kann man sich das Leben mit der UI ein wenig vereinfachen.

Alles in allem ist die WebUI in diesem Bereich sehr komfortabel ... das ist man bei AWS gar nicht gewohnt.

> in diesem Bereich sieht man sehr deutlich, dass AWS kein konsistentes UI hat. Die User-Experiance spielt für AWS scheinbar keine große Rolle oder ist so dezentralisiert, dass einfach ganz unterschiedliche Interaktions-Patterns entstehen. Bei AWS

---

## Bereitstellung für Enduser

Eine Lambda-Function ist über CLI/SDK direkt aufrufbar. Meistens will man aber nicht diese proprietären Tools verwenden, sondern einen HTTP-Request.

Hierzu kann man verwenden:

* ALB
* API-Gateway

Der Aufruf der Lambda-Function ist in diesem Fall synchron, d. h. der Aufrufer muss aktiv auf die Bereitstellung des Ergebnis warten.

### ALB

* der HTTP-Request in JSON umgewandelt (da Lambda einen JSON Payload erwartet)
  * die entgegengesetzte Transformation geschieht dann wieder
  * schaltet man am ALB "Multi-Header-Values" ein, dann kann man mehrere Query-String-Parameters mit dem gleichen Namen in einen Request packen und so vielleicht eine Batch Funktionalität abbilden.

Letztlich muss man

* den ALB mit HTTP enabled konfigurieren
* die Requests über eine zu erstellende TargetGroup zur Lambda-Funktion routen

---

## Cron-Triggered Execution

Über die EventBridge lässt sich ein cron-ähnlicher Trigger für eine Lambda-Function umsetzen.

> Übrigens kann man damit auch auf andere AWS Events (EC2 Instanz shutdown, CodeCommit, S3, ...) reagieren, um Aktionen in Form von Lambda-Functions zu triggern.