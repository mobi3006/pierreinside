# GitHub Actions und Workflows

* [CoderDave - GitHub Actions Tutorial | From Zero to Hero in 90 minutes](https://www.youtube.com/watch?v=TLB5MY9BBa4)

Hierbei handelt es sich um die Automatisierungstechnologie von GitHub.

> Eigentlich würde der Name "GitHub Workflows" viel besser passen, weil auf höchstem Abstraktionsgrad der Workflow steht. Technisch gesehen ist eine Action in diesem Kontext nur eine vordefinierte Folge von Operationen, die in einer Library zur Verfügung gestellt wird. Ich denke "Action" klingt einfach eher nach "mach was" und lässt sich so besser verkaufen.

---

# Konzept

Das zentrale Konzept sind Workflows, die als yaml-Datei im Repository abgelegt werden (im Verzeichnis `.github/workflows` und dann automatisch zur Ausführung zur Verfügung stehen bzw. automatisch getriggert werden. Das ist wirklich seamless :-)

> Das ist sehr viel klarer als in Jenkins, bei der man manuell einen Job definieren muss, der wiederum Teile seine Implementierung aus dem `Jenkinsfile` des Repos holt. In GitHub ist der Job automatisch schon durch die Definition eines Workflows vorhanden. ABER: GitHub hat natürlich den Vorteil, daß es Source-Code-Repository und Automatisierungstool in einem ist ... klar, daß das besser integriert ist.

Als Konsequenz ergibt sich daraus allerdings auch, daß Workflows Branch-abhängig sind. Das macht die Sache ein wenig komplexer und kann zum Vorteil aber auch zum Nachteil gereichen. Es ist nicht möglich wiederverwendbare Workflows einfach zentral (im Repository oder gar auf Organisation Level zu definieren). Wiederverwendung könnte man dann beispielsweise durch automatisiertes Copy/Paste per [Terraform](https://registry.terraform.io/providers/integrations/github/latest/docs) abbilden.

> Dieser Askpekt war bei Jenkins über ein Library Konzept möglich ... ein ähnliches Konzept habe ich bei GitHub noch nicht gefunden.

Ein Workflow definiert:

* Event Trigger (wann soll der Workflow ausgeführt werden)
* auf welcher Umgebung soll der Workflow ausgeführt werden (Linux, Windows, MacOS)?
* ein oder mehrere Jobs, die dann parallel auf separaten Runners ausgeführt werden
* pro Job verschiedene Steps - ein Step kann sein:
  * Shell Script (Bash ist die Default-Shell)
  * Action - das GitHub-Ecosystem bietet eine Fülle vordefinierter Actions (z. B. `actions/checkout@v3`)

Ein Workflow kann selbst wieder Workflows aufrufen, die im gleichen aber auch in einem anderen Repository liegen können. Auf diese Weise läßt sich eine Library-basierte Wiederverwendung abbilden.

Mit GitHub Workflows lassen sich beliebige Automatisierungen umsetzen. Natürlich sind sie in GitHub für CI (Build/Test von Artefakten) prädestiniert. Deployments werden spätestens seit Einführung von Environments auch sehr gut unterstützt.

## Permissions

* [GitHub - Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)
* [GitHub - workflow-syntax-for-github-actions - Permissions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#permissions)
* [GitHub - Security hardening for GitHub Actions](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

Eine Action bekommt vom GitHub-Framework zu Beginn immer einen `${{ scerets.GITHUB_TOKEN }}` beigesteuert und steht implizit zur Verfügung. Damit lassen sich dann Aktionen auf dem Repo oder API-calls oder ...  ausführen.

> Im Hintergrund wird eine GitHub App auf dem Repository installiert, das dann die Tokens erzeugt. Man kann die Permissions im Workflow steuern (über den `permissions:` Abschnitt)

Mit diesem Token hat man Zugriff **AUSSCHLIESSLICH** auf das eigene Repository.

> gibt man Secrets über Log-Output (innerhalb eines Workflows) aus, dann wird der Inhalt durch `****` ersetzt. Das funktioniert i. d. R. sehr gut - es ist aber nicht komplett unmöglich, daß Secrets im Log erscheinen. Man sollte hier den best-Practices folgen.

Für den Zugriff auf andere Repositories können [folgende Ansätze](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#considering-cross-repository-access) verwendet werden:

* GitHub App tokens - RECOMMENDED
* Personal Access Tokens ... Details im nächsten Kapitel
  * NICHT recommended, da dir Granularität nicht gut ist und der Token an einem echten Benutzer hängt (für Automatisierung geschäftkritischer Workflows SEHR unpraktisch ... plötzlich hat der Mitarbeiter gekündigt und seine gesamten Token sind sofort ungültig)
    * das stimmm im Januar 2023 so nicht mehr ... auch bei PATs lassen sich feingranulare Permissions vergeben
* SSH-keys an einem Personal Account
  * noch schlimmer als Personal Access Tokens: "Workflows should never use the SSH keys on a personal account."
* Repository Deploy Keys

## GitHub App Tokens

* [Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication)

Jeder Workflow erhält einen `GITHUB_TOKEN`, mit dem der Workflow automatisch Zugriff auf das aktuelle Repository hat. Dieser Token wird von einer GitHub App erzeugt, die automatisch (weitestgehend unsichtbar) installiert wird sobald man GitHub Actions auf dem Repository enabled. Der Token steht dem Workflow dann auch explizit als Secret zur Verfügung

> ${{ secrets.GITHUB_TOKEN }}

Für den REST-Zugriff per `curl` könnte man dieses Token dann folgendermassen verwenden (um einen GitHub Issue anzulegen):

```
curl \
   --request POST \
   --url https://api.github.com/repos/${{ github.repository }}/issues \
   --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}'
```

Ein solcher Token hat zunächst mal die [Standard-Permissions](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token) (wie sie GitHub definiert hat). Über die [`permissions` Direktive](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#permissions) im GitHub Workflow Script lassen sich die Permissions erweitern und reduzieren.

Benötigt nun ein Workflow erweiterten Zugriff (z. B. auf ein anderes Repository), dann muss man eine [GitHub App](https://docs.github.com/en/developers/apps/building-github-apps/authenticating-with-github-apps#authenticating-as-an-installation) mit den entsprechenden Permissions of die benötigten Repositories installieren, die dann Zugriff auf das Repository erhält. Diese App ist dann in jedem Repository zu sehen auf das es Zugriff bekommen hat.

Für die Nutzung der GitHub App ist natürlich eine Authentifizierung erforderlich. Mögliche Varianten:

* Client-Zertifikat

---

# GitHub Runners

* [GitHub-hosted Runners](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#choosing-github-hosted-runners)

GitHub Action Workflows werden in GitHub Runners ausgeführt, die verschiedene Laufzeitumgebungen (Linux, Windows, MacOS) in der Azure-Cloud bereitstellen. Es handelt sich hier um VMs (keine Docker Container). Per Default kann man passwortlos zum root werden und `sudo` ausführen.

Allerdings kommen die Runner nahezu nackt daher. Über Actions lassen sich dann Tools wie beispielsweise Python installieren:

```yaml
steps:
- uses: actions/setup-python@v3
  with:
    python-version: '3.8'
    architecture: 'x64'
```

In einigen GitHub Plans sind bereits CPU-Minuten für GitHub-Hosted Runners enthalten. Diese "kostenlosen" Maschinen sind i. a. etwas schwachbrüstig und ihnen fehlen einige Features (z. B. static IPs, die man evtl. für IP-Whitelisting benötigt). Will man dann die teuren/starken GitHub-Hosted-Runners verwenden, dann ist der Preis relativ hoch. Es macht dann auf jeden Fall Sinn, mal zu untersuchen, ob man mit Self-hosted Runners oder Hosted-Runners ausserhalb von GitHub (gibt es wohl auch schon) besser bedient ist.
 
## Self-Hosted Runners

Neben den von GitHub gehosteten Runners kann man auch eigene Runner (auf der eigenen Infrastruktur) bereitstellen. Ich würde das vermeiden wollen, weil man dann natürlich für das skalierbare Hosting und die Maintenance verantwortlich ist und der Weiterentwicklung des GitHub Ecosystems hinterher rennt.

> Wenn GitHub natürlich keinen entsprechenden Support für eine bestimmte Hardware bietet, so hat man keine andere Chance. Andere Dinge wie IP-Whitelisting oder Compliance Anforderungen können auch gegen die Verwendung von GitHub-Hosted-Runners sprechen.

GitHub supported diesen Ansatz mit einem nativen Agent, den man mit einem einzigen Kommando installieren kann. Auf diese Weise kann man sogar den [eigenen Laptop](https://youtu.be/TLB5MY9BBa4?t=4060) zum GitHub Runner machen. Zum Rumspielen sehr praktisch. Wenn man docker-basierte GitHub Actions ausführen will, dann muss natürlich auch Docker auf dem Laptop installiert sein.

> Es ist zu empfehlen auf dem Runner-System einen eigenen User anzulegen (und `sudo` zu limitieren ... manche Actions werden das benötigen), unter dem der Self-Hosted-Runner Prozess läuft - damit kann man den Zugriff schon mal gut einschränken und verhindert, dass unbeabsichtigte Dinge geschehen. Ich würde in einem Laptop-Szenario empfehlen, eine eigene VM (Virtualbox, Parallels) zu starten, um den Agent-Prozess in einer Sandbox einzusperren. Nichtsdestotz ist die VM dann dennoch im Netzwerk des Laptops ... hier sollte man sich überlegen, ob man das weiter absichern will.

Der Laptop ist natürlich nur für den Anfang geeignet. Später sollte man eine [Self-Hosted-GitHub-Runners Infrastruktur](https://youtu.be/TLB5MY9BBa4?t=4352) auto-skalierbar in die Cloud bringen.

GitHub rät davon ab Public Repositories auf Self-Hosted Runners auszuführen, da der Code Malware enthalten kann, die dann schon mal innerhalb der eigenen Infrastruktur ist und somit mehr Schaden anrichten kann. GitHub bietet [Self-Hosted-Runners-Hardening-Empfehlungen](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#hardening-for-self-hosted-runners).

## Self-Hosted Runners - EKS-Cluster

...

## Self-Hosted Runners - AWS-Technologies - Philips

* [GitHub Projekt](https://github.com/philips-labs/terraform-aws-github-runner)

Der Philips Konzern bietet eine AWS-basierte Lösung für automatisch skalierbare Self-Hosted GitHub-Runners als Open-Source Projekt an.

---

# Workflows in depth

## Templates

Wenn man einen neuen Workflow über die GitHub-UI anlegt, dann bekommt man passende Template vorgeschlagen. Diese Templates bieten erleichern die Entwicklung eines eigenen Workflows.

Über [eigene Starter Workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization) in einem `.github` Repository lassen sich die von GitHub bereitgestellten Workflow-Templates erweitern.

## Wiederverwendung über Actions

In einem Workflow verwendet man die sog. Actions, die beispielsweise über den [GitHub Marketplace](https://github.com/marketplace?type=actions) gesucht werden können. Letztlich sind die Actions wiederum in einem Repository bereitgestellt.

Verwendet man also die Action

```
- uses: actions/checkout@v3
```

dann ist die Implementierung der Action auf GitHub zu finden. In diesem Fall im GitHub Repository [`checkout`](https://github.com/actions/checkout) der GitHub Organisation oder des Users [`actions`](https://github.com/actions). Von diesem Repo wurde ein Release gebaut und als Tag [`v3`](https://github.com/actions/checkout/releases/tag/v3) bereitgestellt.

Man kann hier aber auch einen Branch wie `main` referenzieren

```
- uses: actions/checkout@main
```

Neben Community-Actions kann jeder aber auch seine eigenen privaten Actions (in einem privaten Repository) implementieren, ohne sie der Community öffentlich bereitzustellen.

Ein größeres Beispiel:

```yml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      # marketplace action
      - uses: actions/checkout@v3

      # repository action
      - uses: ./.github/actions/hello-world-action
```

Bei der Ausführung eines solchen Workflows durch eine `ubuntu-latest` Runner Instanz werden zu Beginn die notwendigen Repositories der Actions runtergeladen und der Ausführungsumgebung (= GitHub Runner) zur Verfügung. 

Von außen kann man einer Action nicht ansehen wie sie implementiert ist. Aufgrund des OpenSource-Ansatzes kann man sich die Implementierung aber in GitHub ansehen. Das ist auch eine gute Quelle zum Lernen.

Anstatt ein Action im eigenen Repo bereitzustellen kann man auch ein anderes Repo referenzieren. Auf diese Weise lässt sich beispielsweise ein Action-Library-Repo anlegen.

## Implementierung eigener Actions

* [Creating Actions](https://docs.github.com/en/actions/creating-actions)
* [Beispiele von GitHub](https://github.com/actions)

Actions lassen sich in einem Repository bereitstellen. Sie werden über

* JavaScript
* als Docker Container
  * [YouTube](https://www.youtube.com/watch?v=OHdyjuORZxU)
* als Composite Action
  * mit Shell-Scripting
  * durch Aufruf weiterer Actions

implementiert.

Man kann eine Action in ein spezifisches Repository packen (wie zum Beispiel bei [action/checkout](https://github.com/actions/checkout)) oder als Unterverzeichnis in einem bestehenden Repository.

GitHub Actions können optional im [GitHub Actions Marketplace](https://github.com/marketplace?type=actions) bereitgestellt werden, um sie anderen bekannt/nutzbar zu machen.

**Docker-Ansatz:**

Der Docker-Ansatz erscheint verlockend, weil man darüber Actions in jeder beliebigen Sprache implementieren kann (z. B. Python). 

Verwendet man den `Dockerfile` Ansatz (anstatt des Docker Image Ansatzes)

```
runs:
  using: docker
  image: Dockerfile
```

dann wird das Docker Image zu Beginn eines Workflows, das diese Action verwendet, neu gebaut. Das dauert dann je nach `Dockerfile` ein paar Sekunden ... für einen generellen Ansatz Actions über Docker zu implementieren ist das definitiv zu langsam. Man stelle sich einen Workflow vor, der 10 Docker-Actions implementiert und dann zu Beginn erstmal 2 Minuten die Images baut, um dann den Workflow in 10 Sekunden abzuarbeiten. Ein ziemlicher Overhead.

Alternativ dazu kann man in `action.yml` statt eines `Dockerfiles` das Docker Image referenzieren, das dann beispielsweise in einer Docker-Registry (z. B. DockerHub) gehostet wird. Die Bereitstellung der Action erfolgt dann über eine Docker-Registry:

```
runs:
  using: docker
  image: docker://gbeake/kyverno-cli:v1.0.0
```

In dem Fall wird das Image in DockerHub bereitgestellt ... das muss man dort aber selbst pushen (bzw. am besten per GitHub Workflow).

> Es gibt schon einige GitHub Actions, die intern über Docker Container implementiert sind ... das ist auch der Grund warum das Dockerhub Ratelimit (Beschränkung deer Downloads von Docker Images auf 100 pro 6 Stunden) in solchen Fällen problematisch werden kann.

## Wiederverwendung von Workflows

* [GitHub Docu - Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

Innerhalb eines Workflows kann man einen **PUBLIC** Workflow (der `on.workflow_call` definiert hat ... also aus einer Workflow heraus aufgerufen werden darf) eines anderen Repositories (sogar eines speziellen Branches) per

```yaml
jobs:
  call-workflow:
    uses: octo-org/example-repo/.guthub/workflows/called-workflow.yml@main
```

aufrufen und so wiederverwenden. Das Repository `octo-org/example-repo` agiert sozusagen als Library.

> **ACHTUNG:** Sollte es sich um ein **INTERNAL** Repository (Enterprise Account) handeln (statt **PUBLIC**), dann muss der [Nutzung explizit im bereitstellenden Repo zugestimmt werden](https://docs.github.com/en/enterprise-cloud@latest/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#allowing-access-to-components-in-an-internal-repository)

## Starter Workflows

Für Newbies, die noch keinen Sack voller eigener Workflows haben, oder die Workflows in einem neuen Bereich (z. B. AWS) implementieren wollen, stellt GitHub Templates zur Verfügung:

* [GitHub Docu - Creating starter workflows for your organization](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
* [GitHub Docu - Using starter workflows](https://docs.github.com/en/actions/using-workflows/using-starter-workflows)

## Wiederverwendung via Composite Actions vs. Workflows

* [YouTube Video - CoderDave](https://www.youtube.com/watch?v=xa9gYSCf8q0)
* [GitHub Blog](https://github.blog/2022-02-10-using-reusable-workflows-github-actions/)

* GitHub Composite Actions - generische Use-Cases
  * nesting bis zu 10 Levels möglich
  * keine Runner-Selection via `uses:` möglich ... der Execution Kontext wird in einem Workflow definiert
    * Actions sind halt rein auf Wiederverwendung in einem bereitgestellten Execution-Context ausgelegt - sie definieren selbst keinen solchen
  * keine Jobs - somit auch keine Parallelisierung ... Actions sind atomar
  * können keine Secrets aktiv lesen - müssen als Parameter contributed werden
  * kein Support von Conditionals (`if:`) ... das muss im caller geschehen
  * ALLE Steps sorgen nur für eine einzige Zeile Output
* GitHub Workflows - sehr spezifische Use-Cases
  * nesting weiterer Workflows nicht möglich
  * Parallelisierung über Jobs
  * Execution Context Definition über `uses:`
  * JEDER Step erzeugt eine eigene Zeile Output

Der aus meiner Sicht wichtigste Aspekt ist die des Execution Context. Eine Action läuft im Execution Context eines Workflows und hinterlässt dort seinen State, d. h. ein `git config --global user.name "Mona Lisa"` aus einer GitHub Action bleibt im Runner des Jobs nach Ausführung der Action bestehen. Will man also State-Veränderungen in eine wiederverwendbare Komponente packen, dann sind GitHub Actions das Mittel der Wahl.

Aus meiner Sicht bilden Actions generische Wiederverwendung an und Reusable Workflows bieten eine anwendungsspezifische Wiederverwendung. Best-Practices für einen Build/Release-Job würde ich deshalb als Reusable Workflow abbilden, der seinerseits aus Reusable Actions implementiert ist.

Technisch gesehen gibt es auch einige Einschränkungen

* Reusable Workflows können keine anderen Workflows aufrufen
* Composite Actions können weitere Composite Actions aufrufen ... aber nur bis zum Level 10

---

# Deployments via GitHub Workflows

Für die Umsetzung von Deployments steht immer wieder ein besonderer Schutz des Deployment Targets und Berechtigungen (wer darf es ausführen? wie kommt der Workflow an die Berechtigungen?) im Vordergrund. Hierzu benötigt man dann ein Approval durch eine Gruppe von Personen.

Das kann man über

* aktives Warten
* inaktives Warten implementieren

Beim aktiven Warten bleibt der GitHub Runner einfach aktiv und wartet - im schlimmsten Fall bis zum Timeout - bis der Benutzer den Workflow approved. In dieser Wartezeit verursacht der Workflow allerdings weiterhin Kosten.

Inaktives Warten bedeutet, dass der Runner erst dann gestartet wird, wenn der Reviewer sein Approval gegeben hat. 

## Active Waiting for Approval

z. B. über [`trstringer/manual-approval`](https://github.com/trstringer/manual-approval)

## Inactive Waiting via GitHub Environments

Inaktives Warten läßt sich über GitHub Environments abbilden, die ein Review einfordern. Beim Environment definiert man einen Review Request, wenn der Workflow nicht durch den Owner gestartet wurde. Im Workflow sieht man von dieser Logik nichts:

```
terraform_apply:
  needs: terraform_plan
  runs-on: ubuntu
  environment: live
```

---

# Workflow Syntax

* [GitHub Docu](https://docs.github.com/en/actions/using-workflows/about-workflows)

## Jobs

Können in

* GitHub-hosted Runners (VMs)
* Self-hosted Runners
* Docker Containers

ausgeführt werden. Das wird über die `runs-on` oder `container` Definition festgelegt. Ein Workflow kann mehrere Jobs enthalten, die per Default parallel ausgeführt werden. Über `needs: id` lassen sich Abhängigkeiten und über `needs.JOB.outputs.variable` Parameter übergeben.

Matrix ist ein schönes Konzept, um Jobs in verschiedenen Kombinationen laufen zu lassen:

```
jobs:
  backend:
    strategy:
      matrix:
        browser: [ "firefox", "chrome", "opera"]
```

Sehr hilfreich ist an dieser Stelle, dass diese Matrix nicht statisch sein muss. Sie kann auch während der Durchführung eines Workflows ermittelt werden:

* [Dynamic build matrix in GitHub Actions](https://www.cynkra.com/blog/2020-12-23-dynamic-gha/)
* [Dynamic number of jobs in a GitHub Action workflow](https://www.geekytidbits.com/dynamic-number-of-jobs-in-github-action-workflow/)

```
jobs:
  calculate-scope:
    runs-on: ubuntu
    outputs:
      service_list: ${{ steps.calculation.outputs.service_list }}
    steps:
      - name: which services to patch
        id: calculation
        run: |
          service_list="[ "
          delimiter=
          for service_version in ${supported[@]}; do
            service_list="${service_list}${delimiter}\"${service_version}\""
            delimiter=","
          done
          echo "service_list=${service_list}" >> $GITHUB_OUTPUT

  patch:
    needs: calculate-scope
    strategy:
      matrix:
        service: ${{ fromJson(needs.calculate-scope.outputs.service_list) }}
      max-parallel: 2
```

## Triggers

* [Workflow Trigger](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on)

Über `workflow_call` lassen sich auch manuell getriggerte Workflows abbilden, die dann auch Parameter erhalten können.

## Workflow-Steps

Hier verwendet man Actions aus dem GitHub Ecosystem (`uses`) oder Shell-Kommandos (`run`). Per Default verwendet `run` eine bash ... man kann hier aber auch [andere `shell`s definieren](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsshell), um beispielsweise Python Code zu verwenden (insbesondere die Verarbeitung komplexer Datenstrukturen gelingt damit einfach leichter):

```yaml
- name: python code
run: |
    name = "Pierre"
    print(f"Hello {name}")
shell: python
```

Über [Custom Shells](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#custom-shell) lassen sich auch weitere Scripting Sprachen integrieren.

GitHub bietet [Funktionen und Datenstrukturen](https://docs.github.com/en/actions/learn-github-actions/expressions).

## Bedingte Ausführung

Per `if:` lassen sich Steps überspringen oder auch ausführen, wenn ein vorheriger Step fehlgeschlagen ist (Exception Handling).

> **ACHTUNG:** in `if`-clauses darf nicht auf den `secrets`-Kontext zugegriffen werden

## Parameterübergabe

Zwischen Steps und Jobs müssen manchmal Parameter transportiert werden. Am einfachsten ist das zwischen Steps, die alle in einem gemeinsamen Job laufen und damit im gleichen Runner (-Kontext). Hier kann man einfach

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: A
        run: |
          echo "result_a=foo" >> $GITHUB_ENV
      - name: B
        run:
          echo ${{ env.result_a }}
          echo ${result_a}
```

> ACHTUNG: innerhalb einer Shell kann man die Environment Variablen auch per `${variable}` refernzieren ... man braucht per Konvention kein vorangestelltes `env` (`${env.variable}`).

Verwendet man statt einer `shell: bash` (das ist der default) einen `shell: python` dann kann das so aussehen:

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: K
        id: k
        run: |
          with open(os.environ["GITHUB_OUTPUT"], "a") as f:
            print(f"result_k=4711", file=f)
        shell: python
      - name: L
        id: calculate_next_version
        run: |
          echo ${{ steps.k.outputs.result_k }}
```

Für die Parameterübergabe über Jobgrenzen hinweg muss ein anderer Weg eingeschlagen werden, da diese Jobs auf unterschiedlichen Runner-Instanzen laufen und somit nicht den gleichen Kontext teilen. Das ganze macht natürlich nur Sinn, wenn die Jobs nicht gleichzeitig laufen ... also eine Abhängigkeit per `needs` definieren:

```
jobs:
  runner-selection:
    runs-on: ubuntu-latest
    outputs:
      runners: ${{ steps.derive_stage.outputs.runners }}
    steps:
      - name: derive from | ${{ inputs.target_environment }}
        id: derive_stage
        run: |
          _target=${{ inputs.target_environment }}
          STAGE=${_target%:*}
          echo "runners=[\"tag-a\", \"tag-b\", \"${STAGE}\"]" >> $GITHUB_OUTPUT

  dependent-job:
    needs: runner-selection
    runs-on: ${{ fromJson(needs.runner-selection.outputs.runners) }}
```

## Artefaktübergabe

Alle Artfakte innerhalb eines Jobs stehen jederzeit zur Verfügung, da die Ausführungumgebung die gleiche ist.

Unterschiedliche Jobs sind - aufgrund Ausführung auf unterschiedlichen Runners - voneinander getrennt. Ergebnisse in Form von einfachen Werten ist über die Workflow-Sprachmittel möglich (siehe oben). Zum Teilen Artefakten muss man

* [upload artifact im bereitstellenden Job](https://github.com/actions/upload-artifact)
* [download artifact im konsumierenden Job](https://github.com/actions/download-artifact)

verwenden.

---

# GitHub Secrets

Für eine Integration mit anderen Systemen benötigt man entsprechende Credentials. Hierfür bietet GitHub einen Secret Store auf verschiedenen Ebenen (Organisation, Repo, Environment).

Secrets können an einen Reusable Workflow per `secrets: inherit` komplett weitergegeben werden

```
jobs:
  call-workflow-passing-data:
    uses: octo-org/example-repo/.github/workflows/reusable-workflow.yml@main
    with:
      config-path: .github/labeler.yml
    secrets: inherit
```

oder aber per `secrets: MYSECRET` einzeln

```
jobs:
  call-workflow-passing-data:
    uses: octo-org/example-repo/.github/workflows/reusable-workflow.yml@main
    with:
      config-path: .github/labeler.yml
    secrets:
      envPAT: ${{ secrets.envPAT }}
```

Im Reusable Workflow muss man die zu verwendenden Secrets dann allerdings explizit in der `on` Section definieren:

```
name: My Reusable Workflow
on:
  workflow_call:
    inputs:
      ...
    secrets:
      envPAT:
        required: true
```

> Seltsamerweise funktioniert die Nutzung von Secrets nur in Reusable Workflows (`workflow_call`). Wenn man beispielsweise einen `workflow_dispatch` verwendet, dann kann man ausschliesslich auf `secrets.GITHUB_TOKEN` zugreifen aber nicht auf andere secrets. Wenn man sich aber einen `workflow_dispatch` workflow baut und die Secrets per `secrets: inherit` alle contributed, dann kann der aufgerufene `workflow_call` auf ALLE Secrets zugreifen. Ich bin also gezwungen aus rein technischen Gründen innerhalb eines Repsoitories einen Reusable Workflow zu implementieren. Was ist das denn für ein Quatsch?

---

# Best-Practices

### Online-IDE

GitHub stellt einen komfortablen Editor im Browser zur Verfügung, der den Marketplace ganz schön integriert und auch Fehler gut sichtbar macht.

Hierzu navigiert man einfach zum Workflow und drückt den Stift zum Editieren.

## VSCode Extension

## Fehlersuche per Logging

Das Debug-Level wird durch Setzen folgender Secrets angepaßt:

* `ACTIONS_STEP_DEBUG=true`
* `ACTIONS_RUNNER_DEBUG=true`

> Es handelt sich bei der Verwendung von Secrets vermutlich eher im eine Krücke ... weil das die derzeit einzige Möglichkeit ist, ohne Codeänderung Konfiguration zu contributen. LEIDER ist die Granularität dadurch nicht besonders gut (alle Workflows sind plötzlich im Debugmode). Ausserdem benötigt man Mainterer-Role, um überhaupt über "Settings - Secrets" darauf zugreifen zu können.

## Nektos Act Development environment

* [Nektos-Act@GitHub](https://github.com/nektos/act)
* [YouTube - Intro](https://www.youtube.com/watch?v=5hHYUNbdP6M)

... to run your workflows locally

---

# Vergleich zu Jenkins

Ich bin sehr begeistert von GitHub Workflows. Natürlich stößt man auch hier gelegentlich mal an Grenzen oder Inkonsistenzen, die man sich gerne anders wünscht. Es tut sich allerdings eine Menge im GitHub Ecosystem und so entstehen immer wieder sehr nützliche Verbesserungen. Der GitHub Support bemüht sich hier auch im Lösungen oder stellt sogar Feature-Requests ein ... aber natürlich dauert es dannn doch manchmal eine Ewigkeit bis nützliche Features umgesetzt sind. Es ist halt immer wieder eine Abwägung, ob das Feature in das Konzept von GitHub passt oder wie sehr es auch für andere Nutzer passt.

## Pipeline-Bereitstellung

Die automatische Integration aller `.github/worflows/*.yml` Dateien inklusive automatischer Ausführung macht den GitHub Ansatz besonders smooth.

Bei Jenkins konnte man den Pipeline-Code auch in ein `Jenkinsfile` packen, das unter Version-Control stand. Allerdings musste man manuell noch einen entsprechenden Jenkins-Job anlegen, um die Pipeline auch zur Ausführung zu bringen. Das hat mir gar nicht gefallen.

## Pipeline Syntax

Ich bin mit der Pipeline-Syntax von Jenkins nie so richtig warm geworden. Die GitHub-Workflows find ich viel klarer und einfacher zu programmieren.

## Wiederverwendung

In den Workflows kann man Shell-Scripting oder Python direkt verwenden. Über Docker lassen sich beliebige Sprachen problemlos integrieren.

Die Fehleranalyse empfand ich bei Jenkins immer recht schwierig. Der Glue-Code in deklarativen Pipelines und scripted Pipelines hat das aus meiner Sicht immer sehr erschwert. Häufig konnte man mit den Fehlermeldungen nicht viel Anfangen.

> Grundsätzlich bin ich eher ein Freund von Scripted Ansätzen (wie in Jenkins mit Groovy ... das mir als ehemaliger Java-Entwickler sehr nah ist), wenn die Logik komplexer wird. Hier sind deklarative Ansätze (Schleifen, Functions) deutlich im Nachteil ... auch wenn es ums Debugging und Testing geht. Dennoch haben mich die Scripted Pipelines in Jenkins nicht wirklich überzeugt ... fühlte sich immer wie ein Fremdkörper an. Häufig dauerte die Fehleranalyse ewig.

Notfalls kann man sogar Self-Hosted Runners mit Software bestücken und so einbinden, ohne explizite Referenzierung im Workflow File. Ich würde allerdings versuchen, darauf zu verzichten, da das unnötige Magic reinbringt. Bei Komponenten deren Installation/Konfiguration allerdings sehr lange dauert, kann das allerdings die Ausführungszeit der Workflows deutlich reduzieren.

## Dokumentation

... fand ich bei Jenkins sehr schwach - GitHub ist nicht perfekt, aber schon sehr gut

## Ecosystem

Das Ecosystem ist bei Jenkins und GitHub riesig. Ich schätze bei GitHub ist es sehr stark wachsend. Die Kopplung von Source Code Repository und SaaS-Ausführungsumgebung hat einen großen Charme. Die Open Source Community, die ja eh GitHub nutzt, wird darauf abfahren.

Hier wird Jenkins keine Chance haben ... da bin ich mir sicher.

Die ersten Monate der professionellen Nutzung haben schomn gezeigt wie schnell sich das Ecosystem weiterentwickelt. Ständig kommen neue Features für die komplette GitHub-Platform hinzu - siehe [Public Roadmap](https://github.com/orgs/github/projects/4247/views/1). Amazing.