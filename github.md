# GitHub als Endanwender

GitHub ist mehr als nur ein Git-Repository ... es bietet viele Tools, die man für die Softwareentwicklung und Dokumentation brauchen kann :-)

GitHub ist auch Bestandteil der [GitBook-Toolchain](gitbook.md).

---

## Accounts

Man unterscheidet

* Personal Accounts
* Organization Accounts
  * man legt eine Organisation an indem man einen [Personal Account in eine Organisation umwandelt](github-organizations.md)
* Enterprise Accounts
  * hiermit kann man mehrere Organisationen managen

Zu jedem Account gehört ein GitHub Plan, der bestimmt

* wieviel es kostet
* welche Features man nutzen kann

Grunsätzlich möchte GitHub die Community fördern und somit bekommt man für Public Repositories viele Features kostenlos, für die man bei Nutzung Privater Repositories zahlen muss.

### Pricing Plans

Es ist nicht ganz einfach, die Pricing Plan zu durchschauen. Ein Beispiel:

> Codespaces sind kostenlos für "GitHub Free for Personal Accounts", sind aber nicht in "GitHub Free for Organization" enthalten. Für Organisationen muss man einen Team-Plan kaufen, um Codespaces nutzen zu können.

* Personal Account
  * Free
  * Pro
* Organisationen
  * Free
  * Team
* Enterprise

---

## Features

* Git-Repository (public und private)
* Remote-Editierung (direkt auf dem Remot-Repository) über eine Weboberfläche
* gute Kollaboration
  * Integration von passiven Nutzern sehr leicht (passive Nutzer werden leicht aktiven Nutzern - das ist der Grundgedanke des Open-Source)
  * Kommentare/Diskussionen
  * Online-Issue-Tracking (für z. B. TODO-Listen)
  * Online-Wiki ... dabei handelt es sich auch um ein Git-Repository
* Gist: hierbei handelt es sich um kleine Schnipsel, die man verteilen oder beispielsweise in eine Dokumentation integrieren kann. Man könnte Gists zur Modularisierung einsetzen: https://gist.github.com/mobi3006/f94d4a11851932a681c9ce5f9e216b04
* GitHub-API: https://developer.github.com/

---

## Verbindungsaufbau

Die Authentifizierung kann über (ODER)

* username/password
* ssh-key

erfolgen.

### Erstellung ssh-key

[siehe ssh](ssh.md)

#### Connection prüfen

Bei GitHub darf man sich NICHT mit dem Usernamen (= Email-Adresse) anmelden, sondern IMMER über den User ``git``:

```bash
ssh -T git@github.com
```

---

## Fork Repositories

* https://help.github.com/articles/fork-a-repo/

### Fork vs. Branch vs. Clone

Alle 3 Artefakte sind Kopien eines Origin-Repositories, allerdings unterscheiden sich die Konzepte darin wie nah das Artefakt am Origin-Repository ist:

* Fork: komplett getrennt vom Origin-Repository - auch remote an ganz anderer Stelle
  * Fork ist kein GIT Konzept, existiert aber für viele Distributed-VCS-Provider (u. a. GitHub)
* Branch: lebt im gleichen Origin-Repository
  * einen Remote-Branch kann man i. a. nur als registriertes Team-Mitglied anlegen - lokale Branches in einem geclonten Repository kann natürlich jeder anlegen ... die Branches existieren dann aber nur lokal
* Clone: nur eine lokale Kopie des Origin-Repositories

Man könnte sagen Fork ist schwergewichtiger als ein Branch.

**Fork oder Branch?**

* https://stackoverflow.com/questions/3611256/forking-vs-branching-in-github

Das wesentliche Entscheidungskriterium ist hier, ob man in dem Projekt das Recht hat eigene Remote-Branches anzulegen. Das ist meistens nur registrierten Team-Mitgliedern erlaubt. Hat man das Recht nicht, möchte aber Branches anlegen, dann bleibt nur der Fork als Lösung.

Aus diesem Grund habe ich mich für einen Fork der [Spring Petclinic](https://github.com/spring-projects/spring-petclinic) als Grundlage meines [Sandbox-Projekts](sandbox.md) entschlossen.

### Syncing a Fork

* https://help.github.com/articles/syncing-a-fork/

---

## REST API

Für die Automatisierung von Prozessen bietet sich die [REST-API](https://docs.github.com/en/rest) an. Sie liegt als [Open-API](https://github.com/github/rest-api-description) Beschreibung vor und kann somit leicht in [Postman](postman.md) importiert werden.

Solche Open-API sind dann häufig folgendermaßen strukturiert:

![Postman Open-API collection](images/postman-github.png)

Folder stellen Parameter zur Verfügung (hier `owner`, `repo`, `path`), die dann in den URLS per `:owner`, `:repo` und `:path` verwendet werden können. Auf diese Weise reduziert man die Redundanzen. So kann man den ganzen Baum - ab einer bestimmten Stelle - im Kontext dieser Parameter nutzen.

Bei der Nutzung eines anderen Repos muss man dann allerdings die oberen Folder kopieren ... das erfordert eine gewisse Disziplin.

### Authentifizierung

* [Vergleich verschiedener Methoden](https://dev.to/dtinth/authenticating-as-a-github-app-in-a-github-actions-workflow-27co)
  * mit dem Ergebnis ... **verwende GitHub-Apps**

Prinzipiell stehen folgende Varianten zur Verfügung:

* Personal-Access-Token
* Deploy-Keys
* OAuth-Token ... um beispielsweise anderen Diensten Zugriff zu gewähren
* GitHub-App-Access-Token

Seit [Ende 2020](https://docs.github.com/en/rest/overview/other-authentication-methods#basic-authentication) kann man sich nicht mehr per Username-Passwort authentifizieren.

> Ich denke das hängt auch damit zusammen, daß Two-Factor-Authentication der neue Standard ist, der bei Username-Passwort noch einen weiteren Faktor in Form des Tokens bräuchte.

**ACHTUNG:**

> bei einer fehlschlagenden Authentifizierung liefert die GitHub REST API kein HTTP 401 oder 403, sondern ein 404 ([siehe hier](https://docs.github.com/en/rest/overview/other-authentication-methods)). Das macht aus Sicherheitsgründen Sinn, denn mit einer 404 weiß man nicht mal ob es eine nicht-existierende Ressource ist oder ein Authentifizierungsproblem.

### Authentifizierung per Personal-Access-Token (PAT)

Der Personal-Access-Token ist ein Secret, das mit den Permissions des erzeugenden Users (zur Laufzeit ... nicht zum Erstellungszeitpunkt) genutzt wird. Der Gültigkeitsscope eines solchen Tokens kann allerdings eingeschränkt werden auf z. B.

* bestimmte Repositories
* bestimmte Bereiche (Content, Issues, Pull-Requests)

Es gibt "Classic Tokens" und mittlerweile auch "Fine-Grained" Tokens.

Über

> curl --location -u mobi3006 --request GET 'https://api.github.com/repos/mobi3006/trash-private/contents/README.md'

kann ich auf mein privates Repository zugreifen ... ich werde interaktiv nach einem Token gefragt - ich kann ein Personal-Access-Token oder ein von der GitHub-App ausgestelltes Ticken verwenden. Durch Verwendung von `-u mobi3006::${GITHUB_MOBI3006_PAT}` kann ich auch eine Umgebungsvariable verwenden.

Alternativ kann man auch

> curl --location --request GET 'https://api.github.com/repos/mobi3006/trash-private/contents/README.md' \
--header 'Authorization: Basic thiscouldbeyourbase64encodedsecret

verwenden.

**ACHTUNG: PATs sind einfach in der Erstellung und kurzfristigen Nutzung ... ABER:**

* sie werden ungültig, wenn der User nicht mehr existiert
  * insofern sind PATs nicht die erste Wahl, wenn es um nachhaltige Automatisierung in Enterprise Umgebungen geht
* es ist schwierig mit zeitlich begrenzten Tokens bei unternehmenskritischen Workflows zu arbeiten ... man stelle sich vor ein Hotfix kann nicht deplyoed werden, weil der Token abgelaufen ist und sich niemand mehr so richtig erinnert wo der zu konfigurieren ist
* wir ein PAT an verschiedenen Stellen benutzt, müssen auch alle Stellen geändert werden
* eine Änderung an den Berechtigungen des dahinterstehenden Users führt auch zu einer Berechtigungsänderung für den PAT (weil der ja direkt mit den Berechtigungen des Users gekoppelt ist). Somit kann das unerwünschte Seiteneffekte haben
* sie sind schwieriger zu verwalten und im Auge zu behalten
* automatisierte Prozesse will häufig nicht unter des Flagge des eigenen Users laufen lassen ... letztlich hat es die Maschine gemacht - evtl. getriggert von einem ganz anderen Benutzer
  * häufig werden hierfür technische User verwendet ... GitHub Apps sind die GitHub-Lösung, die ohne technischen User auskommt (und zudem noch Vorteile gegenüber diesem Ansatz hat ... Stichwort Quota)

**DESHALB** empfehle ich die Verwendung von GitHub Apps - sie sind  zu verwenden, die benutzerunabhängig sind.

### Authentifizierung per GitHub App

GitHub Apps werden im Account oder der Organisation konfiguriert (hauptsächlich Permissions) und installiert. Sie stehen öffentlich zur Verfügung und werden genutzt, um `GITHUB_TOKEN` für die Nutzung der REST-API auszustellen. Die Zugriff ist abgesichert über einen Private-Key, so daß nur der Inhaber diese Keys einen Token erhalten kann.

> Der Name GitHub-App suggeriert, daß dies Anwendungen sind, die etwas für den Client tun. Das ist irreführend ... GitHub-Apps stellen ausschießlich Tokens aus, die der Client dann nutzen kann, um Aktionen per REST-API durchzuführen.

![github-apps.PNG](images/github-apps.PNG)

Dieser Ansatz hat im Gegensatz zu allen anderen viele Vorteile:

* nicht User-gebunden (wenn der User mal nicht mehr im Unternehmen ist brechen die Prozesse nicht zusammen)
  * es wird keine Lizenz (= Seat) benötigt => keine Kosten
  * niemand muß Angst haben, daß SEIN Token für igendwelche Aktionen "missbraucht" wird - letztlich steht bei einem Personal-Access-Token immer der Inhaber als ändernder User in der Historie.
* die Quota der erlaubten Aufrufe ist deutlich höher als bei einem Nutzergebunden Token (PAT)
* die Berechtigungen können sehr fein-granular gesetzt werden
* die Gültigkeit des Tokens kann auf weniger Minuten/Stunden gesetzt werden ... bei Personal-Access-Tokens ist das Minimum 7 Tage
