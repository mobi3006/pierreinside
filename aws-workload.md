# AWS Workload

Es gibt verschiedene Ansätze Workloads in AWS abzubilden. Mit Workloads meine ich Workflows, die das Business abbilden, z. B. einen Microservice oder einen Batch-Job.

Man hat 3 Optionen:

* Compute Instanzen via EC2
* Containers via
  * [EKS - Elastic Kubernetes Service](aws-eks.md)
  * ECS - Elastic Container Service
* [Serverless](aws_serverless.md)

Die Ansätze unterscheiden sich im wesentlichen im Abstraktionsgrad und das sorgt letztlich für Unterschiede im Konfigurationsaufwand und der Flexibilität - hier sollte man einen guten Trade-off finden. Man muss also die Anforderungen der Anwednung in verschiedenen Aspekten kennen (z. B. Performance, Ausfallsicherheit) und die eigenen Anforderungen hinsichtlich Developemnt/Betrieb (z. B. Know-How, Kosten, Maintenance) und gegeneinander abwägen. Es gibt immer verschiedene Optionen.

Natürlich kann ich einen Docker Container auf einer EC2 Instanz deployen. Allerdings bietet AWS mit EKS (via Fargate oder EC2) und ECS bereits fertige Lösungen, die neben dem Start auch noch weitere wichtige Aspekte (z. B. Konfiguration, Secret-Management, Skalierung, Health-Checks, Self-Healing) mitbringen. Deshalb macht es dann Sinn, sich für einen höherwertigeren Ansatz zu entscheiden.

> Serverless bedeutet hier nicht, dass es keine Server gibt - stattdessen muss man keine Server selbst managen ... das übernimmt die AWS-Platform.

Das generelle Ziel des Cloudcomputings ist in der Anzahl der Ressourcen nicht limitiert zu sein und so Lastspitzen leicht ausgleichen zu können, ohne das a-priori planen zu müssen. Computing on-demand. Um dies kosteneffizient umsetzen zu können, ist elastische Skalierung (up and down) erforderlich.

---

# Compute via EC2

Dieser Ansatz bildet die OnPrem gehostete Serverfarm (z. B. via VMWare) in der AWS Cloud ab. Deshalb war das der natürliche Einstiegpunkt, wenn man von OnPrem in die Cloud wechselte. Anwendungen waren meistens als langlaufende stateful Service-Anwendungen und liefen dauerhaft auf einer/mehreren physikalischen Instanzen.

Die Serverless-Ansätze liefern mittlerweile die Grundlage für Event-Driven kurzlebigen Prozessierungen, die nach wenigen Sekunden oder Minuten beendet sind. Nichtsdestotrotz ist EC2 immer noch der unterliegende Building-Block, auf dem die anderen Ansätze basieren (als Backend sozusagen).

Der Nachteil von EC2 ist, dass hier nach Laufzeit (in Abhängigkeit von der Leistungsfähigkeit) der Instanz abgerechnet wird (Status Running). Auch wenn die Instanz nichts zu tun hat, kostet sie Geld. Das ist bei anderen Workload-Solutions (z. B. Serverless, Containers) kosteneffizienter, weil sie elastisches Scaling unterstützten bzw. bereits eingebaut haben.

> Hängt ein EBS-Volume an einer STOPPED Instanz, dann kostet das EBS Volume aber weiterhin.

## Typen

Die wichtigste Entscheidung bei einer EC2-Instanz ist die Art von Instanz (z. B. `t3.medium`, `a1.large`):

* Instanztyp (z. B. `t3`, `a2`) bestehend aus
  * Instanz-Family (z. B. `t`, `a`)
  * Generation (z. B. `3`, `2`)
* Instanzgröße (z. B. `medium`, `large`)

Die Instanzen sind für unterschiedliche Anwendungszwecke optimiert und haben unterschiedliche Kosten. Auf diese Weise kann man den Best-Fit (Features, Preis) finden und bei Bedarf ohne weitere Aufwand anpassen.

## stop vs stop-hibernate

Bei einem "stop " wird die Instanz runtergefahren, d. h. der Memory geht verloren - bei einem stop-hibernate bleibt der Memory nach einem start erhalten. Hierzu muss die Instanz allerdings mit Hibernation-Support konfiguriert worden sein.

## On-Demand vs. Spot Instanzen

* [Spot-Instanzen](https://aws.amazon.com/ec2/spot/pricing/)

On-Demand Instanzen stehen solange zur Verfügung wie ICH sie nutzen will. Bei SPOT Instanzen könnte es passieren, dass sie während der Nutzung gestopt werden, weil ein anderer Kunde mehr Ressourcen braucht und auch bereit ist mehr Geld zu zahlen. Die Anwendung, die auf einer solchen Instanz läuft, muss hierfür natürlich geeignet sein ... ganz grundsätzlich sollten das aber generell alle Anwendungen, denn es kann immer mal passieren, dass ein Server im laufenden Betrieb ausfällt (z. B. Stromausfall, Festplatte kaputt, Feuer). Mit SPOT Instanzen kann man viel Geld sparen - man gibt einen maximalen Preis an ... kann aber auch passieren, dass man eine solche Instanz nicht bekommt oder sie unter dem Hintern weggezogen bekommt.

## ssh Connect

Kann man über ein attached ssh-Key-Pair bekommen ... geht aber auch direkt aus AWS Management Console via Cloud Shell.

> Man sollte versuchen, ohne einen solche Zugriff auszukommen ... zumnindest wenn die Application, die man dort bereitstellt, einen gewissen Reifegrad hat. In Produktionsumgebungen ist es häufig sogar verboten auf diese Weise zuzugreifen. Dort hat man dann aber Monitoring-Lösungen, die bei der Fehlersuche helfen. Am besten man gewöhnt sich das gleich mal ab.

## User-Data Script

Hierbei handelt es sich um ein Shell-Script, das nach dem Boot-Vorgang gestartet wird.

## VPC

* eine EC2 Instanz muss einem VPC zugewiesen werden (jeder Account kommt mit einem VPC vorkonfiguriert, um den Einstieg zu erleichtern)

---

# Containers

Container bieten den Vorteil, dass sie neben der Anwendung auch gleichzeitig die Laufzeitumgebung und Konfiguration (häufig injected) mitbringen und somit sehr leicht von einem Server auf einen anderen geschoben werden können. Genau das machen sich Container-Lösungen zu nutze ... sie starten auf verschiedenen Compute-Enheiten beliegig viele Container. Sie können beliebig von einem System (z. B. DEV Stage) auf ein anderes System (z. B. LIVE Stage) gebracht werden. Dabei skalieren sowohl die Compute-Einheiten als auch die Anzahl der Container einer Anwendung. Dadurch kann dieser Ansatz nahezu beliebig skalieren ... nur die Kosten limitieren es.

Containers sind deutlich leichtgewichtiger als EC2 Instanzen. Sie können innerhalb weniger Millisekunden gestartet werden. Der Startup einer EC2 Instanz dauert vielleicht 30-120 Sekunden und damit schneckenlahm. Hat man eine Anwendung die für jede prozessierte Nachricht (Event-Driven-Applikation) einen neuen Container startet, dann macht das schon einen großen Unterschied ... es würde nicht funktionieren, wenn man für jede Nachricht eine neue EC2 Instanz starten müsste.

Für Container Deployments stellt Amazon zwei Ansätze bereit

* [EKS - Elastic Kubernetes Service](aws-eks.md)
* ECS - Elastic Container Service

Beide lassen sich auf

* selbst-gehosteten EC2 Instanzen
* via (serverless) Fargate

betreiben.

## Fargate

Mit Fargate lassen sich Docker Container Images im Kontext von Amazon ECS und Amazon EKS deployen. Es ist ein managed Service und insofern auch serverless.

---

# Serverless

Serverless ist schon länger ein Hype und tatsächlich hat es Vorteile hinsichtlich Wartung und Kosten, da die Bereitstellung von Ressourcen (vor der Serverless-Zeit per EC2-Instanz bereitgestellt) von Amazon erfolgt und man nur bezahlt was man nutzt.

Letztlich ist "serverless" ein wenig irreführend, denn auf unterster Ebene sind es dann doch Server, die genutzt werden. Allerdings wird dieses Layer von dem jeweiligen höherwertigen Layer (Lambda, Fargate) durch die AWS gemanaged. Durch den geringeren Aufwand auf Operating-Management (u. a. Patching, High-Availability, Skaling), kann man sich mehr auf die Applikation fokussieren. Den Komfort zahlt man allerdings muss weniger Flexibilität.

Serverless erinnert an PaaS Ansätze, bei denen der Entwickler eine Artefakt bereitstellt, das dann auf einer Platform deployed wird.

> Entscheidet man sich für einen serverless Ansatz, dann hat man hohen Komfort (wenig Administrative Tätigkeiten) aber auch weniger Kontrolle

> Während der EC2-Ansatz der typische Einstiegspunkt für Unternehmen ist, die schon auf OnPrem ihre Hardware selbst administriert haben und nun auf die Cloud umziehen wollen, ist der Serverless Ansatz der typische Einstiegpunkt für Startups, die auf der grünen Wiese anfangen und sich auf ihre Features fokussieren wollen. Obwohl das häufig so gelebt wird, sollte die man die Entscheidung für den richtigen Ansatz von den Anforderungen abhängig machen ... nicht von dem was man gerade hat - auch wenn das natürlich verlockend ist. KOmmen man von OnPrem, so sind die Anwendungen häufig auf die "alte" OnPrem-Welt zugeschnitten. Macht man eine 1:1 Migration, dann bleiben dabei viele Vorteile der Cloud und der AWS Features auf der Strecke. Aspekte wie elastisches Scaling hat man häufig OnPrem nicht ... darüber macht man die Cloud aber erst bezahlbar.

## Lambda

[AWS Lambda](aws_lambda.md)

## Fargate

Serverless Ansatz für Containers.