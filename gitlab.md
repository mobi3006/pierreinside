# GitLab

GitLab ist eine Platform für den gesamten Software Development Lifecycle

* Requirements
* Planning
* Scrum/Kanban-Boards (Issue Tracker)
* Code + Review
* Build
* Deployment
* Testing
* Artifact Repository

---

## GitHub vs. GitLab

* GitHub
  * gehört zu Microsoft
  * bietet auch viele Dinge von GitLab (Source-Code-Repo, IssueTracker, CI/CD via Travis-Integration, Scrum/Kanban-Boards)
    * allerdings sind die über Plugins oder Webhooks umgesetzt => mehr Wartungsaufwand (im Vergleich zur managed GitLab-Platform)
* GitLab
  * kann genauso einfach genutzt werden wie GitHub ... einfach einen Account anlegen und anmelden
  * CI/CD-Ressourcen sind schon kostenlos dabei (2000 CI/CD minutes)
    * man kein seine eigenen Processing-Ressourcen integrieren (["own runners"](https://docs.gitlab.com/runner/))

---

## Pipeline

Deklarativer Ansatz durch Definition in einer yaml-Datei (z. B. `.gitlab-ci.yml`) beispielsweise innerhalb des Source-Code Repositories:

```yaml
stages:
    - build
    - test

build:
    stage: build
    script:
        - echo "Building"
        - mkdir pierre
        - touch pierre/info.txt
    # da die Stages in unterschiedlichen Docker-Containern abgearbeitet werden, müssen die Ergebnisse aus unterschiedlichen Stages "übergeben" werden
    artifacts:
        paths:
            - build/

test:
    stage: test
    script:
        - echo "Testing"
        - test -f pierre/info.txt
```

### Konzepte


### Ausführung in Docker-Containern

* scheinbar werden die Pipelines in Docker-Containern ausgeführt (basierend auf einem `ruby:2.6` Image)
  * vermutlich wird die deklarative `yaml`-DSL in Ruby-Code umgesetzt und im Image ausgeführt

### GitLab Runner

* [Dokumentation](https://docs.gitlab.com/runner/)
* [YouTube Video](https://www.youtube.com/watch?v=G8ZONHOTAQk)
* geschrieben in Go

GitLab stellt defaultmäßig die Prozessing-Ressourcen für Build- und Deployment als "Shared Runners" auf der Google Cloud Platform im Auto-Scaling-Mode bereit (ohne, daß man davon etwas mitbekommt). Jede CPU-Minute geht auf Kosten des CPU-Budgets, das im jeweiligen GitLab-Paket enthalten ist (z. B. 2000 CI Minuten im freien Account).

Auf diese Weise lassen sich auch Prozessing-Ressources (z. B. auf AWS oder dem eigenen Laptop) als Build/Deployment-Executors integrieren. Die GitLab-Platform agiert dann nur als GitLab-Koordinator.

Registriert man beispielsweise den eigenen Laptop, dann kann aus einer Vielzahl von Ausführungsumgebungen (= Executors) ausgewählt werden:

* Shell
* Docker
* Docker-Machine
* VirtualBox
* Paralels

Ähnlich wie 