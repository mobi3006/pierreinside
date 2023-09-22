# GitHub CLI `gh`

Anfangs habe ich die GitHub CLI `gh` nur für die Authentifizierung genutzt. Ich habe mich mit `gh auth login` angemeldet und konnte danach `gh`-Kommandos nutzen, ohne mich jedesmal neu anmelden zu müssen.

Nach einer Weile habe ich sie aber als Tool im Umgang mit Pull-Requests zu schätzen gelernt. Ich kann damit auf meinem Branch ganz leicht einen Pull-Request erstellen (`gh pr create`) und erhalte auch gleich eine URL ausgegeben, die ich an meine Kollegen weiterleiten oder selbst nutzen kann, um mir die Änderungen noch mal genauer anzusehen.

... ein nettes grafisches Tool (mit Mausbedienung) ist für gelegentliche Nutzung und den Einstieg wichtig - es ersetzt allerdings nicht die Kommandozeile für Power-User.

---

## Login und PATs

> PAT = Personal Access Token

Bei einem `gh auth login` erfolgt eine Authentifizierung interaktiv über den Webbrowser - die richtige Url wird automatisch im Browser geöffnet. Bei Headless Umgebungen muss man die Url [https://github.com/login/device](https://github.com/login/device) manuell im Browser öffnen und dann den ausgegebenen Code eingeben.

Die interaktiv eingegebenen Authentifizierungseinstellungen werden in `~/.config/gh/config.yml` gespeichert. Nach erfolgter Authentifizierung wird ein PAT (Personal Access Token) erzeugt und lokal gespeichert (`~/.config/gh/hosts.yml`) - mit `gh auth logout` kann man ihn löschen. Dieser Token wird für alle weiteren `gh`-Kommandos verwendet. Ich kann mir den Token auch per `gh auth token` ausgeben lassen und ihn beispielsweise explzit in aufrufen in dieser Form verwenden:

```
GITHUB_TOKEN=`gh auth token`
gh api https://does_not_matter:$\{GITHUB_TOKEN\}@api.github.com/repos/....
```

---

## Meine wichtigesten Use-Cases

### GitHub Überblick

* `gh status` - Zeigt den Status des GitHub-Accounts an
  * sehr praktisch, wenn man schauen will wie der Status der PRs ist (welche muss ich reviewen, welche sind noch offen, etc.)

### Shell Completion

* `gh completion --shell zsh` - Shell Completion für zsh

### Arbeit mit Pull Requests

* `gh pr create` - Erstellt einen Pull-Request in den Default Branch
* `gh pr create --base my_target_branch` - Erstellt einen Pull-Request in den angegeben Target-Branch
* `gh pr list` - Zeigt alle Pull-Requests an
* `gh pr status` - Zeigt den Status des aktuellen Pull-Requests an
* `gh pr checkout 119` - Wechselt auf den Branch des Pull-Requests mit der Nummer 119
* `gh pr diff` - Zeigt die Änderungen des aktuellen Pull-Requests an

### Arbeit mit Gists

* `gh gist create gists/gh-cli-install.yml` - Erstellt ein Gist aus einer Datei

---

## Konfiguration von Git

Verwendet man die `git`-CLI, so kann `gh` als Credential Helper per

```
gh auth setup-git
```

konfigurieren. Dabei wird die `~/.gitconfig` um Zeilen dieser Art erweitert:

```
[credential "https://github.com"]
    helper =
    helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
    helper =
    helper = !/usr/bin/gh auth git-credential
```

Bei jedem `git`-Kommando wird dann automatisch der Personal-Access-Token (PAT) von `gh auth login` wiederverwendet.

---

## gh api

> wenn die Response kein JSON liefert, dann einfach mal mit den Headers probieren: `--header Accept:application/vnd.github+json --header X-GitHub-Api-Version:2022-11-28`

GitHub bietet schon recht gute Tools und erweitert diese ständig, doch manche Dinge muss ich dann doch noch selbst über die REST oder GraphQL coden. Hierzu ist `gh api` das mittel der Wahl.

Der für einen Workflow automatisch generierte `GITHUB_TOKEN` hat nur sehr eingeschränkte Rechte, die evtl. für die Verwendung der REST-API nicht ausreichend ist. Hier sollte man sich bei Bedarf über eine GitHub App einen passenden Token generieren lassen.

Mit [jq](jq.md) lässt dich die JSON Response sehr gut parsen.

---

## Konfiguration von `gh`

Auf meinem Ubuntu befindet sich die Konfiguration in `~/.config/gh/config.yml`. Dort kann ich beispielsweise die Alias-Kommandos konfigurieren:

```
aliases:
   co: pr checkout
```
