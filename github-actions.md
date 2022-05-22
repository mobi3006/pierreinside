# GitHub Actions

Hierbei handelt es sich um die Automatisierungstechnologie von GitHub.

> Eigentlich würde der Name "GitHub Workflows" viel besser passen, weil auf höchstem Abstraktionsgrad der Workflow steht. Technisch gesehen ist eine Action in diesem Kontext nur eine vordefinierte Folge von Operationen, die in einer Library zur Verfügung gestellt wird. Ich denke "Action" klingt einfach eher nach "mach was" und lässt sich so besser verkaufen.

---

## Konzept

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

### Permissions

* [GitHub Doku](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#permissions)

By Default hat ein Workflow nur Permissions, um auf das eigene Repository (inkl. Secrets) zuzugreifen. Wird der Zugriff auf ein anderes Repository benötigt, so bieten sich GitHub Apps an, die dann im Auftrag handeln.

> Bei der Ausführung des Workflows sorgt GitHub dafür, daß die Ausführungsengine einen `GITHUB_TOKEN` erhält. Mit der `permissions:` Direktive lassen sich die Permissions steuern.

---

## Runners

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

### Self-Hosted Runners

Neben den von GitHub gehosteten Runners kann man auch eigene Runner (auf der eigenen Infrastruktur) bereitstellen. Ich würde das vermeiden wollen, weil man dann natürlich für das skalierbare Hosting und die Maintenance verantwortlich ist und der Weiterentwicklung des GitHub Ecosystems hinterher rennt.

GitHub supported diesen Ansatz mit einem Agent, den man mit einem einzigen Kommando installieren kann. Auf diese Weise kann man sogar den eigenen Laptop zum GitHub Runner machen. Zum rumspielen ganz praktisch.

---

## Workflows in depth

### Templates

Wenn man einen neuen Workflow über die GitHub-UI anlegt, dann bekommt man passende Template vorgeschlagen. Diese Templates bieten erleichern die Entwicklung eines eigenen Workflows.

Über [eigene Starter Workflows](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization) in einem `.github` Repository lassen sich die von GitHub bereitgestellten Workflow-Templates erweitern.

### Wiederverwendung über Actions

In einem Workflow verwendet man die sog. Actions, die im [GitHub Marketplace](https://github.com/marketplace?type=actions) bereitgestellt werden. Natürlich kann jeder auch seine eigenen Actions implementieren und diese

* im Marketplace
* in einem Repository

anbieten.

Sie werden dann folgendermassen genutzt

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

Daneben gibt es noch sog. [Docker Container Actions](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action) ... dabei wird die Action von einem Docker Container ausgeführt.

### Wiederverwendung von Workflows

* [GitHub Docu - Reusing workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows)

Innerhalb eines Workflows kann man einen **PUBLIC** Workflow (der `on.workflow_call` definiert hat ... also aus einer Workflow heraus aufgerufen werden darf) eines anderen Repositories (sogar eines speziellen Branches) per

```yaml
jobs:
  call-workflow:
    uses: octo-org/example-repo/.guthub/workflows/called-workflow.yml@main
```

aufrufen und so wiederverwenden. Das Repository `octo-org/example-repo` agiert sozusagen als Library.

> **ACHTUNG:** Sollte es sich um ein **INTERNAL** Repository (Enterprise Account) handeln (statt **PUBLIC**), dann muss der [Nutzung explizit im bereitstellenden Repo zugestimmt werden](https://docs.github.com/en/enterprise-cloud@latest/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#allowing-access-to-components-in-an-internal-repository)

### Starter Workflows

* [GitHub Docu - Creating starter workflows for your organization](https://docs.github.com/en/actions/using-workflows/creating-starter-workflows-for-your-organization)
* [GitHub Docu - Using starter workflows](https://docs.github.com/en/actions/using-workflows/using-starter-workflows)

GitHub hat spezielle Repositories for verschiedene Aspekte. Das `.github` Repository enthält wiederverwendbare Templates.

---

## Workflow Syntax

* [GitHub Docu](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions

### Jobs

Können in

* GitHub-hosted Runners (VMs)
* Self-hosted Runners
* Docker Containers

ausgeführt werden. Das wird über die `runs-on` oder `container` Definition festgelegt.

### Triggers

* [Workflow Trigger](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#on)

Über `workflow_call` lassen sich auch manuell getriggerte Workflows abbilden, die dann auch Parameter erhalten können.

### Workflow-Steps

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

### Bedingte Ausführung

Per `if:` lassen sich Steps überspringen oder auch ausführen, wenn ein vorheriger Step fehlgeschlagen ist (Exception Handling).

---

## GitHub Secrets

Für eine Integration mit anderen Systemen benötigt man entsprechende Credentials. Hierfür bietet GitHub einen Secret Store auf verschiedenen Ebenen (Repo, Organisation)

---

## Vergleich zu Jenkins

Ich bin mit der Pipeline-Syntax von Jenkins nie so richtig warm geworden. Die GitHub-Workflows find ich viel klarer und einfacher zu programmieren. In den Workflows kann man Shell-Scripting verwenden oder anderes Tooling, das vom Runner bereitgestellt wird.
