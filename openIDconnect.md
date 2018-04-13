# OpenID Connect

## OAuth 2 vs. OpenID Connect

OpenID Connect = OAuth2 + OpenID Provider

OpenID Connect ist ein vollständiges OAuth2-basiertes Authentifizierungsprotokoll, das für Authentification-as-a-Service Implementierungen verwendet werden kann:

> "[...] allows Clients to verify the identity of the End-User based on the authentication performed by an Authorization Server, as well as to obtain basic profile information about the End-User in an interoperable and REST-like manner. OpenID Connect allows clients of all types, including Web-based, mobile, and JavaScript clients, to request and receive information about authenticated sessions and end-users. The specification suite is extensible, allowing participants to use optional features such as encryption of identity data, discovery of OpenID Providers, and session management, when it makes sense for them." ([Website OpenID Connect](http://openid.net/connect/))

In OAuth2 dreht sich alles im Authorisierung - der Aspekt einer Identifizierung des Nutzers via Authentifizierung ist nicht Teil der OAuth2 Spezifikation. OpenID Connect basiert auf dem OAuth2-Framework, um ein Authentifizierungsprotokoll zu implementieren. Letztlich wird OAuth2 verwendet, um den Zugriff der Applikation (= Client) auf die Protected Resource "Identity Provider" zu authorisieren.

Im [Buch Auth2 in Action](https://livebook.manning.com/#!/book/oauth-2-in-action/chapter-13/28) wird gibt der Authorization Server beide Tokens (Accedd Token und ID Token) im gleichen Request an den Client. Das hat mich lange Zeit verwirrt, denn eigentlich hätte ich erwartet, daß erst mit dem Access Token ein Zugriff auf den Identity Provider möglich ist, der Informationen über den authentifizierten User in Form eines ID Tokens bzw. über die Identity Profile API bereitstellt.

> "We’ve conceptually combined the authorization server and protected resource into the Identity Provider, or IdP. It’s possible that the two aspects of the service, issuing tokens and serving user identity information, could be served by separate servers, but as far as the RP is concerned, they’re functioning as a single unit. We’re also going to add a second token alongside the access token, and we’ll use this new ID token to carry information about the authentication event itself."

Über das ID Token ist der User authentifiziert und über den AccessCode wird er für weitere Protected Resources (neben dem Identity Provider) authorisiert.

Die Zusammenhänge zwischen Authentifizierung und Authorisierung wirken ein wenig durcheinander. Letztlich bietet OpenID Connect Authentifizierung über OAuth2-Authorisierung, doch für die Authorisierung selbst wird eine Authentifizierung (der Resource Owner am Identity Provider) benötigt. Vielleicht kann man die OpenID Connect Authentifizierung als Meta-Authentifizierung bezeichnen, bei der konkrete Authentifizierungen (1. Resource Owners am Identity Provider + 2. Client am Authorization Server) an Drittsysteme (RelyingParty/Client) weitergegeben/delegiert werden kann. Auf diese Weise werden Grenzen zwischen Security Domains überwunden:

> "the resource owner authenticates to the authorization server’s authorization endpoint, the client authenticates to the authorization server at the token endpoint, and there may be others depending on the setup. We’re building authentication on top of authorization, and the authorization protocol itself relies on authentication, isn’t that a bit overcomplicated? [...] It may seem an odd setup, but notice that this setup can leverage the fact that the user is authenticating at the authorization server, but at no point are the end user’s original credentials communicated to the client application (our RP) through the OAuth 2.0 protocol. By limiting the information that each party needs, the transaction can be made much more secure and less prone to failure, and it can function across security domains. The user authenticates directly to a single party, as does the client, and neither needs to impersonate the other." ([Buch Auth2 in Action](https://livebook.manning.com/#!/book/oauth-2-in-action/chapter-13/32))

Die Stakeholder des OAuth2 Protokolls haben im OpenID Connect Kontext andere Bezeichnungen, weil es sich um einer Spezialisierung handelt. Dennoch ist es wichtig, die Abbildung der Stakeholder auf das OAuth2 Protokoll immer im Bliock zu haben, um die gegenseitigen Trustbeziehungen zu erkennen und das Überschreiten der Security Domain Boundary zu erkennen - was den Mehrwert des OpenID Connect Ansatzes ausmacht. Verliert man dieses Wissen aus dem Blick, so können sich - sofern man einen Authorization Server bzw. OpenID Provider implementiert - fatale Fehler einschleichen, die das System als Ganzes kompromittieren!!!

### ID Token vs. Access Token

Braucht es denn wirklich zwei Tokens, die letztlich häufig zum gleichen Zeitpunkt und von der gleichen Komponente (die sowohl IdentityProvider als auch Authorization Server repräsentiert) erstellt wird? Genügt hier nicht der AccessToken, der ja auch Informationen über den User enthält?

* auch wenn der AccessToken User Informationen trägt, so sagt er nichts darüber aus, ob tatsächlich in der laufenden Transaktion eine Identifikation des Users stattgefunden hat. Der Token kann sehr alt oder gar gestohlen (ausgestellt für einen anderen Client), so daß einen Identifizierung zusätzlichen Schutz bietet.
* da OAuth2 nichts über das Format des Access Tokens aussagt, könnte man alles in den Access Token packen, doch dadurch würde man der Protected Resource Informationen (Nutzer des Access Tokens) über die Identity offenbaren, was in manchen Szenarien vielleicht nicht gewünscht ist. Durch die Trennung kann die Identity-Information komplett beim Client verbleiben ... für die Protected Resource sollte das keine Rolle spielen - Hauptsache der User ist authorisiert

### OpenID vs. OpenID Connect

Es gibt auch nicht OpenID, doch OpenID Connect ist angeblich mehr API-friendly.

## Alternativen

* CAS
* Keycloak

## Konzepte

### Identity Provider = OpenID Provider

* ein Identity Provider verwendet Authentifizierung zur Identifikation eines Clients
* der Identity Provider kann innerhalb einer Anwendung implementiert sein (z. B. in einem Monolithen) oder aber auch als externer Service (Authentication as a Service - z. B. in einer Microservice Architektur) eingebunden werden

### OpenID Provider (OP)

* ist der Identity Provider im OpenID Connect Umfeld
* verschmilzt mit dem OAuth2-Authorization-Server
* bietet folgende REST-Endpunkte
  * authenticate
  * userInfo

### Authentication as a Service

Provider eines Service möchten evtl. kein eigenes User-Management betreiben, um den Nutzern das Management ihrer Credentials zu vereinfachen, z. B. sie können die Facebook Credentials verwenden.

### ID Token

* Identity Token
* ID Token wird nach der Identifizierung per Authentifizierung (des menschlichen Benutzers) durch den OpenID Provider (= Identity Provider) in Form eines JSON Web Tokens (JWT) an die Relying Party (die den OpenID Provider im Sinne eines Authentication-as-a-Service genutzt hat) übergeben. Die Relying Party nutzt den ID Token evtl. um eine Session zu erzeugen, aber danach nicht mehr (ist eher ein Wegwerfprodukt mit kurzer Laufzeit - wird auch )
* ID Token enthält u. a. folgende Informationen:
  * Issuer
  * Gültigkeitsdauer
  * Subject (Identity)
  * Audience - intendierte Nutzer des Tokens
  * Nonce
  * Claims
* signiert
* verläßt aus Sicherheitsgründen niemals die Relying Party (abgesehen vom OpenID Provider kennt den ID Token niemand)
* normalerweise kürzere Laufzeit als ein Access Token

### UserInfo Endpunkt

* der OpenID Provider stellt diesen Endpunkt zur Verfügung, um Claims abzufragen
* der Endpunkt ist eine Protected Resource im Sinne von OAuth2, d. h. beim Zugriff ist ein Access Token erforderlich

### Claim

* http://openid.net/specs/openid-connect-core-1_0.html#Claims

Informationen über die Identity

### Relying Party (RP)

Client, der dem ID Token vertraut

### Ablauf einer Authentifizierung/Authorisierung

* http://openid.net/specs/openid-connect-core-1_0.html#CodeFlowSteps

```
+--------+                                   +--------+
|        |                                   |        |
|        |---------(1) AuthN Request-------->|        |
|        |                                   |        |
|        |  +--------+                       |        |
|        |  |        |                       |        |
|        |  |  End-  |<--(2) AuthN + AuthZ-->|        |
|        |  |  User  |                       |        |
|   RP   |  |        |                       |   OP   |
|        |  +--------+                       |        |
|        |                                   |        |
|        |<--------(3) AuthN Response--------|        |
|        |                                   |        |
|        |---------(4) UserInfo Request----->|        |
|        |                                   |        |
|        |<--------(5) UserInfo Response-----|        |
|        |                                   |        |
+--------+                                   +--------+
```

Der menschliche User wird von der Relying Party OAUth2-like über HTTP-Redirect zum OpenID Provider (= Identity Provider) in den Flow eingebunden.

Authentifizierung kann über folgende OAuth2-Grant-Types erfolgen:

* [Authorization Code Flow (= Grant Type)](http://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth)
* [Implicit Flow (= Grant Type)](http://openid.net/specs/openid-connect-core-1_0.html#ImplicitFlowAuth)
* [Hybrid Flow](http://openid.net/specs/openid-connect-core-1_0.html#HybridFlowAuth)
  * basierend auf [OAuth 2.0 Multiple Response Type Encoding Practices](http://openid.net/specs/oauth-v2-multiple-response-types-1_0.html)

## OpenID Certification

* [... to be certified OpenID Provider or certified Relying Party](http://openid.net/certification/)

## OpenID Providers

### Google

* [Google OpenID Provider in Action ... sehr schön mit Beispiel-Requests](https://developers.google.com/identity/protocols/OpenIDConnect)
* [Google OAuth Playground](https://developers.google.com/oauthplayground)
* [OpenID Connect certified](http://openid.net/certification/)

Bevor ein Client den OpenID Provider von Google nutzen kann, muß bei Google eine Client Konfiguration angelegt werden, in der

* Credentials (clientID/username/password)
* Redirect-URL
* Branding (für die Login-Page)
  * natürlich muß die OAuth2 Login Page Vertrauen erwecken (schließlich soll der User hier seine Credentials preisgeben) - hier sollte also der OpenID Provider klar erkennbar sein (ordentliche URL, Server Zertifikat, ...)

hinterlegt werden.

#### Protected Resource - Todoist

[todoist](https://todoist.com/) ist eine beliebtes Getting Things Done (GTD) Tool, das unter Android, iOS und als Webapplikation läuft. Beim Login kann man wählen zwischen verschiedenen User-Managements:

* Todist
* Google via Google's OpenID Provider
* Facebook via Facebook Connect (Facebook nutzt nicht OpenID Connect, sondern [Facebook Connect](https://developers.facebook.com/docs/facebook-login))