# OAuth

## Buch OAuth 2 in Action

* https://www.manning.com/books/oauth-2-in-action
* Beispielcode in JavaScript (Node.js basiert): https://github.com/oauthinaction

## Motivation

Will man mit einem System arbeiten, so benötigt man häufig entsprechende Berechtigungen. Für diese Berechtigungen braucht es dann zunächst mal eine Identität, als die man sich mit einem Geheimnis authentifizieren muß. Hat man nun mehrere Systeme, mit denen man arbeiten muß, dann ist die Frage, ob jedes dieser Systeme ein eigenes User-Management implementieren sollte. Für den Benutzer hätte das die unangenehme Folge, daß er in jedem System einen Benutzer pflegen müßte und zudem wäre es sehr schwierig, wenn ein System A mit einem anderen System B im Auftrag/Kontext eines Nutzers agieren müßte. Dann bräuchte das System A nämlich die Credentials des Benutzers im System B. Und niemand möchte seine Credentials verraten ...

> "The OAuth 2.0 authorization framework enables a third-party application to obtain limited access to an HTTP service, either on behalf of a resource owner by orchestrating an approval interaction between the resource owner and the HTTP service, or by allowing the third-party application to obtain access on its own behalf." ([RFC 6749](https://tools.ietf.org/html/rfc6749))

Was möchte man erreichen:

> spezifizierbaren (READ, CREATE, UPDATE, DELETE, ...) temporären selbstinitiierten Zugriff auf genau spezifizierbare geschützte Ressourcen, der jederzeit widerrufen werden kann bzw. automatisch irgendwann abläuft

Und das liefert OAuth:

> "in OAuth, the end user delegates some part of their authority to access the protected resource to the client application to act on their behalf. To make that happen, OAuth introduces another component into the system: the *authorization server* [...] Fundamental to the power of OAuth is the notion of delegation. [...] a subset of a user's authization is delegated, but OAuth itself doesn't carry or convey the authorizations. Instead, it provides a means by which a client can request that a user delegate some of their authority to it. [...] OAuth 2.0 is designed for the world of web APIs, accessed by client software. The OAuth 2.0 framework in particular provides a set of tools for connecting such applications and APIs across a wide variety of use-cases. [...] The core OAuth 2.0 specification has somewhat accurately been described as a security protocol generator, because it can be used to design the security architecture for many different use-cases." ([OAuth 2 in Action](https://www.manning.com/books/oauth-2-in-action))

und das bedeutet ganz konkret

> "(a) photo-printing service (= client) can ask the user, 'Do you have any of your photos stored on this storage site? If so, we can totally print that.' The user is then sent to the photo-storage service, which asks, 'This printing service is asking to get some of your photos; do you want that to happen?' The user can then decide whether they want that to happen, deciding whether to delegate access to the printing service." ([OAuth 2 in Action](https://www.manning.com/books/oauth-2-in-action))

## Traditionelle unsichere Ansätze

* Credential Synchronisierung - verwenden der gleichen Credentials auf verschiedenen Systemen
  * in dem Fall müßte System A über das Klartext-Passwort des Users Alice auf System A verfügen, um es gegenüber System B zu verwenden - SCHLECHT, denn normalerweise sollte nicht einmal das System A über das Klartext-Passwort des Users Alice auf System A verfügen (deshalb verwendet man Digest Authentication)
  * zudem verwenden User häufig die gleichen Credentials auf unterschiedlichen Systemen - Sicherheitslücke wird noch größer
  * System A könnte auf System B mit vollen Rechten des Users Alice agieren - es besteht keine Möglichkeit, die Zugriffe einzuschränken (auf bestimmte Aktionen oder Ressourcen)
  * es besteht keine Möglichkeit für System B zu erkennen, ob der User selbst oder nur ein anderes System mit ihm interagiert
  * praktische Probleme wie Passwortänderung, unterschiedliche Passwort/Username-Policies
* Developer Keys
  * löst ein paar Probleme der Credential Synchronisierung, aber die Berechtigungen lassen sich aber Problem der Berechtigungseinschränkung noch nicht gelöst

## OAuth 1 vs OAuth 2

* [RFC 5849 - The OAuth 1.0 Protocol](https://tools.ietf.org/html/rfc5849)
  * Start 2006
  * löste einige proprietäre Lösungen ab (Google, Yahoo, ...)
* [RFC 6749 - The OAuth 2.0 Authorization Framework](https://tools.ietf.org/html/rfc6749)
  * Start 2012
* 1.0 = Protocol ... 2.0 = Framework

## Konzepte

* Resource Owner
  * ist der ursprüngliche Initiator des OAuth-Flows - er beauftragt den Client mit der Durchführung einer bestimmten Aktion gegen die Protected Resource
    * "ursprüngliche Initiator" heißt, daß der menschliche Benutzer am Anfang, die Übertragung der Authorisierung auf den Client triggert - der Client kann später allerdings jederzeit selbständig einen Zugriff auf die Protected Resource triggern bzw. einen Refresh Token beim Authorzation Server anfordern
  * nach erfolgreicher Identifikation (per Authentifizierung am Authorization Server) und Auswahl des entsprechenden Scopes (wird vom Client angefordert) erstellt der Authorization Server ein Authorization Objekt (je nach Authorization Grant Type: Authorization Code oder Access Token)
* Protected Resource
  * API-Ressource, die im Auftrag des Resource Owners vom Client genutzt werden soll
* Client
  * System, das im Auftrag des Resource Owners eigenständig die Protected Resource nutzen möchte
  * muß - je nach Authorization Code Grant Type - aus dem Authorization Code einen Access Token über den Authorization Server machen ... hierbei erhält der Client gleichzeitig einen Refresh Token
    * authentifiziert sich am Authorization Server ... warum?
  * muß den Token nicht verstehen/interpretieren - die Protected Resource muß den Token interpretieren bzw. das System, das die Protected Resource verwaltet
* Authorization Server
  * erstellt Authorization Objects wie Authorization Code bzw. OAuth Access Token
* Authorization Object
  * Objekt, das die Authorization Entscheidung repräsentiert
  * Authorization Code - optional (je nach Authorization Grant Type)
    * ist ein Authorization Object
    * darf nur einmalig verwendet werden
    * ist nicht das endgültige Authorization Object, sondern nur eine Zwischenlösung
    * existiert, damit der Client nach Ablauf eines Access Tokens ohne Interaktion mit dem Resource Owner weitere Access Tokens per Refresh Token ausstellen zu lassen
  * OAuth Access Token - mandatory
    * ist ein Authorization Object
    * repräsentiert die erteilte Zugriffsberechtigung, die dem Client vom Authorization Server im Auftrag des Resource Owners erteilt wurde
      * da es sich um eine Zeichenkette ohne Blanks handelt, ist die Interpretation der erteilten Berechtigungen nicht möglich - das wissen nur Authorization Server und Protected Resource
    * darf mehrfach verwendet werden - hat aber eine beschränkte Laufzeit
    * ist die Laufzeit abgelaufen, dann muß ein Refresh erfolgen - hierzu muß wendet sich der Client mit einem Refresh-Token (das ihn für die Erneuerung des Access Tokens berechtigt) an den Authorization Server
    * Typ des Access Tokens ist nicht Teil der OAuth Spezifikation - folgende Token Typen kommen zum Einsatz
      * [Bearer Token](https://tools.ietf.org/html/rfc6750)
        * jeder, der ihn hat, kann ihn nutzen, um Zugriff auf die Protected Resource zu erhalten
* OAuth Refresh Token
  * wird zwischen Client und Authorization Server ausgetauscht, um - ohne Interaktion mit dem Resource Owner - einen neuen Access Token auszustellen (kann einen geringeren Scope haben als der initiale Access Token)
  * bei der Ausstellung eines Access Tokens erhält der Client auch gleichzeitig einen Refresh Token, mit dem ein neuer Access Token angefordert werden kann
  * wenn der Zugriff auf die Resource fehlschlägt, dann könnte es daran liegen, daß der Access Token nicht mehr gültig ist und erneuert per Refresh Token werden muß
* Scope
  * Repräsentation von Berechtigungen auf die Protected Resource
  * Ausprägung von Scopes liegt ganz im Verantwortungsbereich der Protected Resource
* Authorization Grant
  * gesamte Prozess der OAuth Access Token Erstellung - hier gibt es vier verschiedene Ausprägungen - sog. Authorization Grant Type:
    * Authorization Code Grant
      * hierbei kommen zwei Authorization Objects zum Einsatz: Authorization Code (Zwischenstufe) und Access Token (Endstufe)
    * Implicit Grant
      * hierbei kommt kein Authorization Code (Zwischenstufe) zum Einsatz - es werden ausschließlich Access Tokens verwendet. Wenn das Access Token abläuft, dann muß der OAuth-Flow erneut über den Resource Owner laufen
    * Resource Owner Password Credentials
      * hierbei übergibt der Resource Owner seine Credentials an den Client - deshalb MUSS hier eine Vertrauensbeziehung bestehen, die nur zu internen Clients bestehen kann
      * mit den Credentials fordert der Client - ohne Interaktion mit dem Resource Owner - Access Tokens vom Authorization Server an
    * Client Credentials

## Eigenschaften

### Was ist OAuth 2

* User-to-System-Authorization-Delegation
* alle beteiligten Stakeholder sprechen über HTTP miteinander (auch der Resource Owner ... über den Browser) - da Geheimnisse ausgetauscht werden ist HTTPS erforderlich
  * HTTP-Redirects wird verwendet, um die Stakeholder über den Resource Owner zu verbinden und die Daten (Scope, State, Authorization Code, Tokens, ...) auszutauschen
* Protokoll (wie interagieren die Stakeholder, um ein Access Token zu erhalten?) und Framework (nicht alle Details sind vorgeschrieben - es existieren Freiheitsgrade) - daraus resultiert eine entsprechende Komplexität und Fallstricke (Do's and Don'ts)
  * flexibel
  * modular
* Ökosystem bestehend aus Erweiterungen, Profile, Protokolle on-top-of OAuth 2
* OAuth 2 versucht die Komplexität aus den Clients rauszuhalten und in die Server zu verlagern. Das reduziert die Einstiegshürde für Applikationsentwickler (implementieren i. a. die Clients) und erhöht die Sicherheit, da die Entwickler des Authorization Servers und der Protected Resource ein höheres Interesse/KnowHow an der Sicherheit haben als die Entwickler, die "nur" eine Integration schaffen wollen. Dadurch erhöht sich die Akzeptanz von OAuth (einer der Gründe für den Erfolg). Zudem gibt es wenige Authorization Server und Protected Resources im Vergleich zu Applikationen, die eine Integration schaffen.

### Was ist OAuth 2 NICHT

* User-to-User-Authorization-Delegation
* kein Authentication Protokoll, obwohl Authentifizierung im Protokoll eine wichtiges Rolle spielt (Resource Owner am Authorization Server UND Client am Authorization Server)
* OAuth 2 definiert nicht das Token Format (im Gegensatz zu anderen Security Protocols wie SAML, Kerberos WS-*)
* Nutzung außerhalb von HTTP ist nicht vorgesehen
* kryptografische Verfahren sind nicht vorgegeben

### Relevante Technologien

... beim Einsatz von OAuth 2 ... aber nicht explizit Teil der OAuth 2 Spezifikation:

* OpenID Connect - für Authentifizierung
* JSON Object Signing and Encryption (JOSE)
* Java Web Token (JWT)

## Getting Started

Eine OAuth Transaktion läuft folgendermaßen ab:

1. Resource Owner beauftragt den Client in seinem Sinne die Protected Resource zu verwenden
2. Client beauftragt den Authorization Server damit mit dem Resource Owner eine Authorisierung durchzuführen
   * indem der Resource Owner einen Redirect auf den Authorization Server erhält (mit Informationen über die zu erstellende Permission/Authorisierung)
3. Resource Owner erstellt eine Authorisierung in Form eines Authorization Codes
   * hierzu muß sich der Resource Owner zunächst identifizieren (durch Authentifizierung) ... ist das wirklich der Resource Owner?
   * der Resource Owner wird gefragt, ob er die erforderliche Berechtigung erteilen möchte
   * der Authorization Server erstellt den Authorization Code und sendet dem Resource Owner ein Redirect zum Client mitsamt dem Authorization Code
4. Client erhält das Token von Authorization Server
   * Client identifiziert sich am Authorization Server und übergibt den Authorization Code
   * Authorization Server wandelt den Authorization Code in einen Access Token um
5. Client zeigt den Access Token vor, um auf die Protected Resource zugreifen zu können

### Tokenerstellung

### Tokennutzung