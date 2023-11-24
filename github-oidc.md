# GitHub OIDC

Mit OIDC (basierend auf der [OAuth Idee](oauth.md)) lässt sich eine Authentifizierung und Authorisierung ganz ohne Passwörter bewerkstelligen. Ein Grundprinzip bei OAuth ist

> OAuth 2 versucht die Komplexität aus den Clients rauszuhalten und in die Server zu verlagern. Für den Enduser (z. B. Applikationsentwickler) wird es dadurch einfacher. Die Konfiguration erfolgt ZENTRAL (das ist der Vorteil hinsichtlich Sicherheit) im Backend.

---

## Nachteil von Passwörtern

### Konzeptuell

* unsicher (gleiche, zu einfache)
* long-lived
* werden selten geändert
* häufig personengebunden ... was natürlich schlecht ist, wenn eine Person mal nicht mehr dabei ist aber sein Passwort in automatisierten Prozessen verwendet wird (und damit dann auch ungültig wird) => Prozesse brechen
* müssen dann evtl. noch zusätzlich in einem Passwort-Store hinterlegt werden
* müssen manchmal geändert werden
* man verliert den Überblick wo sie überall verwendet werden und wo sie dann auch geändert werden müssen

### GitHub Implementierung

GitHub kennt zwar das Konzept der Secrets ... allerdings hat das gewisse Schwachstellen:

* shared Workflows in einem Repository MÜSSEN die Secrets von den Callern bekommen, d. h. die Secrets müssen entweder direkt in den Repos des Callers liegen oder von der GitHub Organisation an die Repos propagiert werden
* all Workflows eines Repos können die Secrets verwenden (zwar nicht im Klartext auslesen) - ohne Beschränkung. Zudem auf ALLEN Branches ... also auch auf Feature-Branches, die evtl. nicht unter 4-eyes Prinzip stehen. Somit könnte ein Angreifer die Secrets unbemerkt verwendem

---

## Lösung OIDC

* [Connecting GitHub Actions To AWS Using OIDC](https://www.youtube.com/watch?v=mel6N62WZb0)

Bei der Authentifizierung gibt es zwei wesentliche Beteiligte - am Beispiel eines typischen Szenario (GitHub => AWS) aus dem Bereich des Software-Deployments "Workflow A möchte ein Deployment auf AWS ausführen":

* derjenige, der Zugriff erhalten möchte (Caller)
  * ein GitHub Workflow
* derjenige, der den Zugriff gewährt (Resource Owner) und somit Aktionen erlaubt (Protected Resource)
  * AWS

Typisch ist, dass es zwei unterschiedliche Systeme sind, die

* Authorisierung i. a. unterschiedlich abgebildet haben (unterschiedliche Modelle/Granularitäten)
* von unterschiedlichen Firmen oder Gruppen verwaltet werden

Die Lösung von OIDC sieht folgendermassen aus:

* der Caller fragt bei SEINEM Authorization Server (= GitHub Identity Provider) nach einem bestimmten Zugriff auf ein Zielsystem (= Context) für einen bestimmten Use-Case (= Claim) an, z. B. ich will eine Lambda-Funktion in AWS auf Produktion deployen
* GitHub 