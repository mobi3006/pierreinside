# GitHub als Endanwender

GitHub ist mehr als nur ein Git-Repository ... es bietet viele Tools, die man für die Softwareentwicklung und Dokumentation brauchen kann :-)

GitHub ist auch Bestandteil der [GitBook-Toolchain](gitbook.md).

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