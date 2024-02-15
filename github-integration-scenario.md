# GitHub Authentifizierung und Authorisierung

* [GitHub Dokumentation - Authentication](https://docs.github.com/en/authentication)

Im heutigen Service-Umfeld spielt die Integration von Diensten eine entscheidende Rolle, d. h. GitHub muss sich als Baustein in das Tooling eines Software-Develoment-Lifecycles (SDLC) einfügen, denn meistens entscheidet sich ein GitHub Nutzer nicht für das GESAMTE GitHub Feature-Set. Ein Besipiel:

* Kunde nutzt GitHub Repositories für VCS
* Kunde nutzt keine GitHub-Hosted Runners
* Kunde nutzt JIRA statt GitHub-Issues
* Kunde nutzt Snyk/Lacework für Code-Analyse statt GitHub-Dependabot

In manchen Bereichen (z. B. Hosting) bietet GitHub auch gar keine Lösung an und der Kunde muss dann AWS oder Azure als Deployment-Target einbinden. 

Hierzu bedarf es im allgemeinen zweier Aspekte

* man muss sich als eine bestimmte Identität ausweisen => Authentifizierung
* man muss entsprechende Berechtigungen erhalten => Authorisierung

Bevor man Berechtigungen erhält muss man sich als berechtigte Person identifizieren.

---

# Anwendungsszenarien

* interaktiver Modus durch menschlichen Benutzer (zumeist mit 2FA)
* Integration von Backend Diensten (nicht interaktiv)
  * GitHub als Resource Owner einer Protected Resource
  * GitHub als Client

In Integrationsszenarien ist man dann entweder in der Rolle des Clients (z. B. mein GitHub Workflow soll Aktionen in einem AWS Account ausführen können) oder des Ressource Owner (z. B. Jira möchte die Pull-Requests aus GitHub lesen können, um sie im Ticket anzuzeigen).

---

# Möglichkeiten

> **ACHTUNG:** bei einer fehlschlagenden Authentifizierung liefert die GitHub REST API kein HTTP 401 oder 403, sondern ein 404 ([siehe hier](https://docs.github.com/en/rest/overview/other-authentication-methods)). Das macht aus Sicherheitsgründen Sinn, denn mit einer 404 weiß man nicht mal ob es eine nicht-existierende Ressource ist oder ein Authentifizierungsproblem.

* [Vergleich verschiedener Methoden](https://dev.to/dtinth/authenticating-as-a-github-app-in-a-github-actions-workflow-27co)
  * mit dem Ergebnis ... **verwende GitHub-Apps**

Prinzipiell stehen folgende Varianten zur Verfügung:

* Username-Passwort
  * seit [Ende 2020](https://docs.github.com/en/rest/overview/other-authentication-methods#basic-authentication) kann man sich nicht mehr per Username-Passwort über die CLI (`git`, `gh`) authentifizieren. Ich denke das hängt auch damit zusammen, daß Two-Factor-Authentication der neue Standard ist, der bei Username-Passwort noch einen weiteren Faktor in Form des Tokens bräuchte.
* SSL-Zertifikate
  * häufig beim Zugriff auf Source Code verwendet (`git clone git@github.com:my-org/my-repo.git`)
    * alternativ: per https url (`git clone https://github.com/my-org/my-repo.git`)
* Personal-Access-Token
  * mittlerweile kann man die auch mit fine-graned Permissions ausstatten
* OAuth-Token ... um beispielsweise anderen Diensten Zugriff zu gewähren
  * GitHub Apps sind der bevorzugte Weg, da die Permissions feingranularer eingestellt werden können
* **GitHub-App** erzeugte (i. a. short-lived) Access-Token
* Deploy-Keys
* SAML SSO
  * hierbei delegiert man die Anmeldung für github.com an einen externen Identity Provider (z. B. Microsoft ActiveDirectory), der sich dann aber auch ums User-Management kümmert (User anlegen und löschen). Auch als Enterprise Managed User bekannt.
* OpenID Connect - [siehe hier](github-aws-oidc.md)

Verwendet man personifizierte Ansätze (Username-Passwort, PAT, SSL-Zertifikat), dann braucht man eine Person (die vielleicht irgendwann nicht mehr da ist). Will man das in-personifizieren, dann kann man theoretisch einen technischen GitHub User anlegen - der dann allerdings auch einen Seat/Account benötigt (Kosten). Die Antwort auf technische Benutzer sind OAuth/GitHub-Apps.

Für GitHub Workflows stellt die GitHub-Platform immer einen `GITHUB_TOKEN` aus mit eingeschränkten Berechtigungen aus. Die harte Einschränkung ist, dass man mit diesem Token nur auf Ressourcen des Repositories zugreifen kann. Cross-Repo-Zugriffe sind nicht möglich - sie müssen über eine [eigene GitHub-App abgebildet werden](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#granting-additional-permissions). Den per Default ausgestellten Token kann man hinsichtlich seiner [Permissions im Workflow Code anpassen](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#permissions-for-the-github_token).

Neben den offensichtlichen Vorteilen einer GitHub App gegenüber personalisierten Zugriffen gibt es den Vorteil eines deutlich höheren Rate-Limits auf die GitHub-API, d. h. mit einem Token einer GitHub App kann man mehr Zugriffe in einem bestimmten Zeitfenster durchführen.

**TL;DR:** GitHub bevorzugt die Authentifizierung über GitHub App

## Username/Password

Mit Username/Password bekommt man ALLE Rechte, die dem jeweiligen Benutzer zugeordnet sind. Im interaktiven Modus z. B. bei Benutzung der Web-UI ist natürlich die richtige Wahl.

Nachteile:

* möchte man eber einer Software den Zugriff gewähren, dann möchte man die Berechtigung auf das Minimum einschränken. Mit Username/Password kann man das nicht. 
* Probleme, wenn das Password mal geändert werden muss
* mit diesen Credentials kann sich der andere über OAuth bei anderen Diensten authentifizieren und Accounts anlegen oder sich einloggen
* hat man das Passwort auch noch für andere Logins verwendet (ist NATÜRLICH ein no-go ... findet aber immer noch statt), dann sind diese auch in Gefahr
* personengebundene Authentifizierung führt zu Problemen, wenn die Person das Unternehmen/Gemeinschaft verlässt => dann brechen die Workflows ... absolut zu vermeiden.

DESHALB: gib dein Password niemals aus der Hand - Integrationsszenarien MÜSSEN anders abgebildet werden

## Personal Access Tokens (PAT)

Füher boten die GitHub PATs nur sehr grob-granulare Berechtigungen ... seit 2023 hat sich das geändert, so dass auch recht fein-granulare (least-privileges principle) Berechtungen möglich sind - entspricht den Berechtigungenslevel einer GitHub App.

Die Nachteile sind ganz ähnlich wie bei Username/Password.

Einige Vorteile im Vergleich zu Username/Password:

* niemand erfährt das Passwort
  * eine Anmeldung bei anderen Diensten mit dem GitHub Password ist nicht möglich
  * eine Password-Änderung ist kein Problem ... der PAT bleibt ja gleich

## OAuth App

* [OAuth 2 Explained In Simple Terms](https://www.youtube.com/watch?v=ZV5yTm4pT8g)
* [Using OAuth apps](https://docs.github.com/en/apps/oauth-apps/using-oauth-apps)

Für die Integration von Diensten, die im Hintergrund laufen ist eine interaktive Authentifizierung (aus der sich dann auch die Authorisierung auf verschiedenen Aktivitäten ableitet) keine Option. Wie soll ein Backend-Batch-Prozess nachts um 3:00 Uhr eine Authentifizierung einfordern? Aus diesem Grund haben sich Backend-Integrationen entwickelt, die **einmalig** die explizite Zustimmung des Rechteinhabers einfordern, um anderen Services die Berechtigung zu erteilen. Hierdurch entsteht eine Trust-Beziehung.

Folgende Situiation angenommen:

> Service A -------> GitHub mit OAuth App B

Die OAuth-App kann man sich als freundliches Trojanisches Pferd vorstellen. Die externe Anwendung (z. B. Jira-Server) verwendet die Jira-OAuth-App, um sich Tokens mit der passenden Berechtigung ausstellen zu lassen. Hierzu muss die externe Anwendung über ein entsprechendes Secret verfügen, mit dem es sich als zugelessener (freundlicher) Client ausweist. Die Aktionen finden dann mit der Identität des Users statt.

> Wenn man dem Anbieter traut, dann ist es ein freundliches Trojanisches Pferd - es birgt allerdings auch die Gefahr, dass man sich ein feindlichers Trojanisches Pferd installiert.

Für die Konfiguration ist ein folgendes wichtig

* Callback-URL ... notwendig für den sog. OAuth-Dance
* Client ID
* Client Secret

Der Initiator des OAuth-Dance ist der Client (Service A), der durch Angabe von ClientID und ClientSecret Zugriff auf GitHub haben möchte. Die via OAuth APP im GitHub Account des Users (bzw. einer Organisation) dient als Mittelsmann, um als Partner im OAuth Dance zu agieren. Der User wird durch eine Weiterleitung auf die GitHub-Login Seite am OAuth-Dance beteiligt. Hier muss er sich über den Browser mit seinen GitHub-Credentials zu authentifizieren. Wenn das geklappt hat, wird dem Nutzer eine Liste der vom Initiator angeforderten Berechtigungen gezeigt. Stimmt der User hier zu, dann hat er den Client für die angefragten Aktionen authorisiert. Im weiteren Verlauf ist die Interaktion des Users nicht mehr erforderlich. Die OAuth-App hat dem Client ein OAuth-Token ausgestellt, das ihn berechtigt, die angeforderten Aktionen im Sinne des eigentlichen Users auszuführen auszuführen. 

Kurzum: der OAuth Dance regelt die Berechtigungserteilung durch den User

> Im Gegensatz zu einer GitHub App sind die Berechtigungen nicht im vorhinein beschränkt, d. h. der Client könnte jede beliebige Berechtigung anfodern (sie würde dem User präsentiert). Stimmt der User dem zu, dann ist die Berechtigung erteilt.

Man sieht hier allerdings, dass der User aktiv einbezogen werden muss - letztlich erteilt er selbst die Berechtigung durch Click auf einen Button. Diese Beteiligung des Users ist allerdings nur solange notwendig bis der User die Berechtigung erteilt hat. Danach wird er nicht mehr gebraucht und die Somit ist das zunächst mal wieder personengebunden. Installiert man die OAuth App allerdings auf Organisationsebene, so erfolgt die Berechtigungserteilung weiterhin interaktiv durch einen Benutzer.

### gh CLI

Die `gh`-CLI verwendet diesen OAuth Flow über `gh auth login` ([siehe hier](github-cli.md)), um den User dazu aufzufordern, `gh` Berechtigungen für den Zugriff auf seinen GitHub Account zu erteilen. Als Resultat erhält `gh` einen kurzlebigen OAuth-Token, der im GitHub Web-UI unter [Web Sessions](https://github.com/settings/sessions) registriert ist und verwaltet werden kann (z. B. revoke). Das Management übernimmt i. a. die `gh`-CLI im Hintergrund.

### 3rd Party OAuth Apps

Anbieter von integrierbaren Diensten (z. B. Jira) bieten ihre OAuth-Apps im [GitHub Marketplace](https://github.com/marketplace) an (z. B. [JIRA](https://github.com/marketplace/jira-software-github)).

## GitHub App

In einer GitHub-Organisation oder einem GitHub-Account kann man

* eine GitHub-App erstellen
  * ... und anschließend in der Organisation oder dem Personal-Account installieren
* eine GitHub-App vom [GitHub Marketplace](https://github.com/marketplace) installieren
  * **ACHTUNG:** dieser App sollte man **UNBEDINGT** vertrauen und nur mit den minimalen Permissions versehen (die Permissions sind in der App konfiguriert - bei der Installation kann man nur noch einschränken für welche Repositories es gilt). Es handelt sich hier um ein trojanische Pferd, das man IM eigenen Account/Organisation installiert und später nicht mehr kontrollierbare Zugriffe macht!!!
  * (payed) GitHub Apps sind möglicherweise nicht im Marketplace zu sehen, obwohl sie im GitHub Ecosystem registriert sind (z. B. [Jellyfish App](https://github.com/apps/jellyfish))

## OAuth App vs GitHub App

* [GitHub - Differences between GitHub Apps and OAuth apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/differences-between-github-apps-and-oauth-apps)

> "OAuth apps can only act on behalf of a user while GitHub Apps can either act on behalf of a user or independently of a user. GitHub Apps use fine-grained permissions, give the user more control over which repositories the app can access, and use short-lived tokens. ([Creating an OAuth app](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app))

> "GitHub Apps are preferred over OAuth apps. GitHub Apps use fine-grained permissions, give the user more control over which repositories the app can access, and use short-lived tokens." ([Differences between GitHub Apps and OAuth apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/differences-between-github-apps-and-oauth-apps))

## User vs Organization

All die oben dargestellten Authentifizierungsmöglichkeiten gibt es

* sowohl auf User-Ebene
* als auch auf Organization-Ebene

Hier am Beispiel einer OAuth App:

* [User-Ebene](https://docs.github.com/en/apps/oauth-apps/using-oauth-apps/installing-an-oauth-app-in-your-personal-account)
* [Organization-Ebene](https://docs.github.com/en/apps/oauth-apps/using-oauth-apps/installing-an-oauth-app-in-your-organization)
