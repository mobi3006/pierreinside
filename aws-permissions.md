# AWS Permissions

Sicherheit ist das höchste Gut in unternehmenskritischen Anwendungen.

> nach meinem Empfinden sind die Möglichkeiten vielfältig, sehr komplex und verteilt - es ist unmöglich einen vollständigen klaren Überblick zu bekommen. Ich bin mir nicht sicher, ob das der Sicherheit genüge tut. Hier braucht es klare Konzepte ... ein "ich probier mal was" ist da sehr kontraproduktiv und kann im Zweifel Sicherheitslöcher öffnen oder viel technical Debt einführen.

---

# AWS Account

Ein AWS Account beherbegt die AWS Ressourcen und hat ein Usermanagement (= Identity and Access Management - IAM). Die meisten Ressourcen sind in einer speziellen Region beherbergt ... andere hingegen (z. B. IAM) sind global. In großen Lösungen verwendet man häufig sehr viele Accounts, um eine separation-of-concerns zu erreichen ... manchmal sogar so viele, daß man eine "AWS Organization" drüberlegt und den Control-Tower-Service zum Management verwendet.

> Dennoch benötigt man manchmal Zugriff aus einem Account auf die Ressourcen in einem anderen Account. Diese Cross-Account Zugriffe sind möglich.

Jeder Account hat eine ID. Die ID spielt in den ARNs (ARN = AWS Resource Names) eine zentrale Rolle - hieraus leiten sich die ARNs von Ressourcen ab (dadurch werden sie i. a. weltweit unique):

* `arn:aws:iam::123456789012:user/pierre`
* `arn:aws:iam::123456789012:role/DeveloperAccessRole`

Grundsätzlich spielen IDs (z. B. ARNs) im Umfeld von AWS eine wichtige Rolle, die AWS ist modular aufgebaut. In dem Sinne baut man ein komplexes Gebilde aus atomaren Elementen zusammen, die über IDs eine Beziehung herstellen. Beispiel: eine Security-Gruppe um eine EC2 Instanz.

---

# AWS Organization

* [YouTube - Digital Cloud Training - Create AWS Organization and Add Account](https://www.youtube.com/watch?v=T4U2YC4PJkY)

Es ist üblich, dass man im Business-Umfeld nicht nur einen AWS Account verwendet, sondern viele. Viele packen ihre Environments (z. B. DEV, TEST, LIVE) in separate Accounts ... das ist aber kein MUST-HAVE - man kann mit einem einzigen Account auskommen. Aber vielleicht hat man noch andere Aspekte, die man voneinander trennen möchte.

Mit "AWS Organization" lassen sich alle AWS Accounts eines Unternehmens per AFT-Control-Tower managen und policy-based controls (z. B. Tag-Policy, Service-Control-Policies) umsetzen.

## AWS Control Tower

* [YouTube - Digital Cloud Training - AWS Control Tower Overview and Landing Zone Hands-On](https://www.youtube.com/watch?v=3-aaw-B1j8Y)

Control-Tower managed eine AWS Organisation. Hierzu wird die Organisation in Organization-Units aufgeteilt, denen dann Accounts zugeordnet werden.

Es werden

* preventive Guardrails
  * Zugriffsrechte über Service-Control-Policies (SCP) einzuschränken
* detective Guardrails
  * um Compliance-Anforderungen zu prüfen

eingesetzt.

---

# IAM - Usermanagement

* [Udemy-Kurs *AWS Certified Solution Architect Associate*](https://www.udemy.com/course/aws-certified-solutions-architect-associate-saa-c02/learn/lecture/26098170#overview)
* [AWS IAM Introduction - Users, Groups, Policies](https://www.youtube.com/watch?v=PjKvwxTTSUk)

IAM ist ein globaler AWS-Service ... er ist nicht regional!!!

Hier werden User (und Passwörter), Gruppen, Rollen, Policies (= Permissions) gemanged. Nicht jeder, der AWS benutzen will braucht IAM - will man AWS aber mit anderen zusammen nutzen, dann kommt am IAM nicht vorbei.

## Konzept User

Jeder Account hat zumindest den Root User, der mit Allmachtsberechtigungen ausgestattet ist und die Verwaltung übernimmt. Über diesen Root User lassen sich weitere User anlegen, die i. a. eingeschränkte Berechtigungen haben.

> Niemand sollte mit dem Root-User arbeiten ... die Gefahr ist viel zu groß, dass dabei unbeabsichtigt Aktionen ausgeführt werden. Es benutzt ja auch niemand den Root-User auf seinem Betriebssystem. Mit dem Root-User wird ausschließlich das Core-Setup des Accounts gemacht und ein User angelegt, der per IAM-Policy über Administrative Permissions verfügt (denn die kann man dann auch leicht mal entziehen).

Ein User muss sich authentifizieren, um Zugriff auf die AWS Ressourcen zu erhalten. Will man Dinge scripten und als Batch (z. B. nachts laufen lassen), dann ist diese natürlich auch eine Authentifizierung nötig. Doch kann man das in vielen Fällen nicht interaktiv machen. Für solche Fälle bietet AWS u. a. Tokens wie den `AWS_ACCESS_KEY` an, den man für jeden User generieren kann.

> ACHTUNG: es wird abgeraten `AWS_ACCESS_KEY`s um größeren Stile zu nutzen. Besser is beispielsweise die Verwendung von IAM-Roles (bei der Nutzung von innerhalb AWS, z. B. durch einen anderen Service), die einem AWS Service assigned werden. Mit einem Identity-Provider (z. B. GitHub) kann Open-ID-Connect (OIDC) verwendet werden, um externen Systemen (z. B. GitHub) use-case-abhängige feingranulare Berechtigungen zu erteilen. Diese Ansätze kommen ohne Secret aus (sog. passwordless authorization) und sind damit deutlich sicherer. 

## Konzept Group

Eine Gruppe kann mehrere User beeinhalten - ein User kann in mehreren Gruppen sein. Über die Gruppe packt man User zusammen, die den gleichen Use-Case haben und damit auch die gleichen Berechtigungen brauchen. Dann muss man die Berechtigungen (= Policies nur noch an die Group hängen).

> Bei Federated-Users, bei denen das User-Management nicht in AWS erfolgt, verwendet man statt der User-Group eine IAM-Role, die der User assumen darf.

## Konzept Role

* [YouTube - Digital Cloud Training - Assume AWS IAM Role Using the AWS Management Console](https://www.youtube.com/watch?v=tg7Ahng08h8)

Eine IAM-Role ist vergleichbar mit einem User ... ist allerdings impersonated, d. h. sie ist nicht an einen User gebunden, sondern kann auch von einem Service genutzt werden. Auf diese Weise kann eine Person in unterschiedlichen Kontexten unterschiedliche Rollen annehmen, indem sie eine andere IAM-Role assumed. Das ist ein sehr viel flexiblerer Ansatz als wenn man einem User die Summer all seiner Permissions zuweist (auch wenn man das über User Groups abbildet). Im jeweiligen Arbeitskontext kann man eine Role verwenden, die über die in diesem Kontext notwendigen Permissions verfügt.

Benutzer, AWS Services und Anwendungen können eine Role (= IAM Identity) assumen (`sts:assumeRole`). An der Rolle hängen wiederum Berechtigungen (über Policies). Über die Rolle abstrahiert man von einem speziellen Benutzer ... stattdessen erhalten Benutzergruppen eine Rolle und darüber Berchtigungen. Man kann eine Rolle einnehmen (und auch wechseln), indem man die Role assumed. Dadurch wechselt man seinen Arbeitskontext und damit seine Berechtigungen.

Ein weiterer wichtiger Punkt ist, dass eine IAM-Role über keinen `AWS_ACCESS_KEY` verfügt. Jemand, der die Rolle assumen darf (bzw. dem dem die Rolle attached ist ... z. B. einer EC2 Instanz) kann sie ohne weitere Authentifikation nutzen (passwordless). Das macht das Management deutlich einfacher, ohne die Security negativ zu beeinflussen - ganz im Gegenteil wird die Sicherheit noch erhöht, weil keine Credentials gestohlen werden können (und im Zweifelsfall rotiert werden müssen).

> eine Role ist eine Art technischer Benutzer

Neben den Berechtigungen einer Role ist die Trust-Policy entscheidend. Sie beschreibt, wer die Rolle assumen darf.

Man kann sogar einem User aus einem anderen Account erlauben, eine Rolle zu assumen. Damit lassen sich Cross-Account-Zugriffe umsetzen (siehe unten).

### Assume Role

Das Einnehmen einer bestimmten Rolle ist der typische Weg, um

* als User in verschiedenen Kontexten zu arbeiten
* als Service Berechtigungen zu erhalten

Das zeigt sich auch schon im WebUI der AWS-Console wo man ein "Switch Role" ausführen kann. Es ist aber auch der typische Weg, wenn Services Berechtigungen benötigen.

Über die AWS-CLI kann man eine Rolle über `aws sts assume-role` einnehmen:

```bash
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
      --role-arn arn:aws:iam::123456789012:role/desiredRole \
      --role-session-name my-session \
      --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
      --output text))
```

Beim `aws sts assume-role` wird der AWS Secure-Token-Service (STS) kontaktiert, um temporäre kurzlebige Credentials für die assumed Role zu erzeugen. Im Beispiel geben wir diese temporären Credentials aus (`--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken] --output text`) und setze üblichen AWS Umgebungsvariablen (`export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s"`). Auf diese Weise wird der Execution Context (in Form von Umgebungsvariablen) konfiguriert - beim nächsten Kommando wird der API-Request signiert, um sicherzustellen, dass der Request von einem autorisierten User kommt. Ein nachfolgendes `aws sts get-caller-identity` würde also die assumed Rolle ausgeben.

> Man darf hier nicht außer Acht lassen, dass sich der User vorher authentifiziert haben muss (um nachzuweisen, dass er derjenige ist, der die Role assumen darf) oder daß die Role an der AWS-Resource attached sein muss (z. B. an einer EC2-Instanz). Hier handelt es sich um eine passwordless-authorization, d. h. zum assumen der Role muss keine weitere Authentifizierung erfolgen - es genügt einmalig seine Identität nachgewiesen zu haben, um anschließend die Rolle nutzen zu können.

### Trusted Entity

Die Zuweisung einer IAM Role erfolgt erfolgt über eine Trusted Entity Policy, die beschreibt wer die Rolle Nutzen kann. Das kann ein IAM User, ein Federated User, ein AWS Service, ein anderer AWS Account oder auch eine Trusted Entity aus einem externen System (z. B. ein GitHub-Repository/Branch oder ein GitHub-Environment).

## Konzept Policy

Eine Policy beschreibt Zugriffsrechte. Wer hat auf welche Ressource für welche Aktionen welche Berechtigung (oder eben explizit nicht)?

In AWS besteht eine Policy aus einem json Dokument. Man kann sich in der AWS Console mit dem [AWS Policy Generator](https://awspolicygen.s3.amazonaws.com) interaktiv eine Policy zusammenstellen und als JSON exportieren ... das vereinfacht die Erstellung erheblich.

> In json kann man keine Kommentare verwenden ... sehr schaden, denn manchmal würde man gerne etwas erklräen wollen. Allerdings gibt es bei den Statements eine `Sid`, in der man etwas Doku einbauen kann (z. B. `sid = "This is the web-server"`).

Ein Policy kann hängen für ... an ... ([gute Erklärung](https://cloudcasanova.com/s3-bucket-access-from-the-same-and-another-aws-account/))

* für Identity-Based-Policies an
  * einem User
  * einer Gruppe
    * ein User, der in der Gruppe ist erhält alle Policies, die an der Gruppe hängen (bedenke: ein)
  * einer Rolle
* für Resource-Based-Policies an
  * einer Ressource (z. B. S3 Bucket)
    * auf diese Weise kann man auch Cross-Account Zugriffe erlauben

> **ACHTUNG:** nicht alle Ressourcen unterstützen Resource-based-Policies (z. B. SSM Parameter Store). Insbesondere für Cross-Account-Zugriffe sind IAM-Policies keine gute Lösung, da die Permissions am User hängen ... am User EINES Accounts - will man das Cross-Account abbilden, dann müsste man die IAM-Policies in mehreren Accounts redundant pflegen (was mit Control-Tower auch möglich wäre).

Wenn Identity-Based-Policies verwendet werden, dann sollte man sie an eine Rolle (statt an User/Gruppe) hängen, denn dies ermöglicht die größte Wiederverwendung (von Usern, AWS Services und Anwendungen) und den wenigsten administrativen Aufwand (User kommen und gehen).

## Konzept Policy - Cross Account

Bei Cross-Account Zugriffen braucht man i. a. ZWEI Policies, jeweils eine pro beteiligtem Account.

Beispiel: ich möchte aus einem Account A auf den S3 Bucket in Account B zugreifen, dann benötigt man

* IAM-Cross-Account Policy in Account A für den Zugriff auf den Bucket in Account B
  * hierbei handelt es sich i. a. um eine Identity-Based-Policy, d. h. einem User/Gruppe/**Rolle** wird die Berechtigung erteilt
* Destination Access Policy in Account B für den Zugriff von Account A auf den Bucket
  * hierbei handelt es sich i. a. um eine Resource-Based-Policy, d. h. der Zugriff auf die Ressource wird erlaubt

**Warum macht man sowas?**

Accounts könnten grundsätzlich in der Verantwortung unterschiedlicher Gruppen/Unternehmen liegen, so dass BEIDE Seiten diesem Zugriff stattgeben müssen. Wenn man sich das als Brücke über einen Fluss vorstellt, so wird die Brücke von beiden Seiten gebaut ... nur DANN wird sie vollständig. Wird nur eine Seite der Brücke gebaut, dann gibt es keinen Weg über den Fluss.

## Konzept Permission-Bondary

* [YouTube - Digital Cloud Training - AWS IAM Permissions Boundary](https://www.youtube.com/watch?v=t8P8ffqWrsY)

Diese Konzept verhindert Permission-Escalation, d. h. selbst wenn man das Recht bekommt neue User oder Rollen anzulegen, dann kann man nicht mehr Permissions vergeben als diese Permission-Boundary erlaubt.

## Konzept ABAC (Attribute-Based-Access-Control)

* [Implementing AWS IAM Attribute-Based Access Control](https://youtu.be/aO6j68USsfY)

## Secure-Token-Service (STS)

Mit diesem Service lassen sich kurzlebige Tokens mit feingranularen Permissions automatisiert erzeugen.

---

# Externes Usermanagement via Federated Users

* [How to create and manage users within AWS IAM Identity Center](https://aws.amazon.com/blogs/security/how-to-create-and-manage-users-within-aws-sso/)
* [Identity providers and federation](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html)

In Enterprise-Umgebungen ist das Usermanagement häufig in einem Company Active-Directory abgebildet. Mit diesem User-Account erhält der User Zugriff auf die unternehmensinternen Daten (z. B. auf File-Shares). Nun möchte man natürlich nicht jeden User auch in AWS pflegen müssen (im worts-case mit nochmal anderen Credentials), denn das würde das Usermanagement in on/offboarding Szenarien sehr aufwendig, fehleranfällig und unsicher machen. AWS bietet hier Integrationen mit Identity Providers an. Der Identity-Provider kümmert sich via Authentifizierung um um die Feststellung der Identität und im Hintergrund wird ein sog. Federated-Users erzeugt, der die via IAM-Roles zugewiesenen Permissions erhält. Der Identity-Provider (= ActiveDirectory) ist für die Authentication und Authorization zuständig. Auf diese Weise wird auch Single-Sign-On (SSO) mit dem Company User unterstützt. Es werden auch andere Identity-Provider (Google, Facebook) unterstützt, so dass man dieses Konzept auch ohne großes Management seiner User nutzen kann.

> Man kann allerdings auch einem User aus einem anderen Account erlauben, eine Rolle zu assumen. Damit lassen sich Cross-Account-Zugriffe umsetzen.

Im Identity-Provider möchte man dann auch die Permissions für die einzelnen User verwalten. Hier kann man IAM Roles definieren und den Usern die nutzbaren Roles zuweisen.

---

# S3 - Cross Account Access

Ganz typisch bei Cross-Account Access ist, dass man in BEIDEN Accounts Berechtigungen erteilen muss - welche das hängt vom Ansatz ab, über den der Zugriff erfolgen soll.

## Option 1 - via 

In diesem Beispiel wird einem User aus Account B der Zugriff auf einen S3 Bucket in Account A ermöglicht:

* [Bucket owner granting cross-account bucket permissions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-walkthroughs-managing-access-example2.html)

## Option 2 - via assume external role

* [YouTube - Digital Cloud Training - Cross-Account Access to Amazon S3](https://www.youtube.com/watch?v=HP8XSRWrFQc)
* [YouTube - Digital Cloud Training - Use Cases for AWS Identity and Access Management (IAM) Roles](https://www.youtube.com/watch?v=PPkPcU1iX1g)
* [S3 bucket permissions for access cross-account](https://cloudcasanova.com/s3-bucket-access-from-the-same-and-another-aws-account/#s3-bucket-permissions-for-access-cross-account)

Würde man das mit einer Rolle machen, so könnte man sich den Policy-Part in Account B sparen.