# HTTP
* Refcardz: https://dzone.com/refcardz/http-hypertext-transfer-0

HTTP ist ein schon recht altes Protokoll, zu dem es aber nur zwei Major Releases gibt:

* HTTP 1.x
* HTTP 2.x: seit 2015

Das neuere Protokoll ist soll den Anforderungen heutiger Webapplikationen gerecht werden und die Performance erhöhen.

## Urlencode
[siehe anderer Abschnitt](characterEncoding.md)

---

# Inputdaten
* https://stackoverflow.com/questions/14551194/how-are-parameters-sent-in-an-http-post-request

---

# Authentication
Es gibt verschiedenen Formen der Authentifizierung innerhalb des HTTP-Protokolls:

* [Basic Access Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
* [Digest Access Authentication](https://en.wikipedia.org/wiki/Digest_access_authentication)
* [Form-Based Authentication](https://en.wikipedia.org/wiki/Form-based_authentication)

## Basic Access Authentication
* https://en.wikipedia.org/wiki/Basic_access_authentication
* https://en.wikipedia.org/wiki/Basic_access_authentication#Client_side

In diesem Fall wird der HTTP-Header ``Authorization`` verwendet, um *username* und *password* [Base64-encoded](https://en.wikipedia.org/wiki/Base64) zum Server zu schicken:

    Authorization: Basic bXl1c2VybmFtZTpQYXNzMTIzNA
    
Statt den ``Authorization``-Header manuell in den HTTP-Request zu packen, kann man die Credentials auch in die URL packen:

    https://myusername:Pass1234@www.cachaca.de/index.html

... das hat den Vorteil, daß der Request bookmarkable ist.

## Digest Access Authentication
* https://en.wikipedia.org/wiki/Digest_access_authentication

## Form-Based Authentication
* https://en.wikipedia.org/wiki/Form-based_authentication

Bei der Verwendung von HTML-over-HTTP können die Credentials in eine HTML-Form gepackt werden:

    <form method="post" action="/login">
      <input type="text" name="username" required>
      <input type="password" name="password" required>
      <input type="submit" value="Login">
    </form>

---

# Tunnel-over-HTTP
HTTP bietet mit den Request-Body basierten Methoden (POST, PUT) die Möglichkeit beliebige Protokolle in den Nutzdaten zu verwenden. Da die meisten Unternehmens-Firewalls das HTTP-Protokoll als grundsätzlich gut bewerten (evtl. auf bestimmte Ports eingeschränkt), ist es attraktiv, HTTP nur als Transferprotokoll für ein beliebiges anderes Protokoll zu verwenden.

Ursprünglich sollte [Hypertext](https://de.wikipedia.org/wiki/Hypertext) (**H**yper**T**ext **T**ransfer **P**rotocol) übertragen werden (z. B. HTML-Dokumente) ... niemand wird aber daran gehindert auch Nicht-Hypertext zu übertragen ... und so genau definiert ist Hypertext auch nicht.

## HTML
Das HTTP-Protokoll wurde ursprünglich zur Übertragung von HTML-Dokumenten und Dateien entworfen. Insofern ist Tunneling hier vielleicht nicht ganz treffend ... aber letztlich sind HTML-Dokumente in diesem Kontext nicht anders zu bewerten als SOAP-Nachrichten oder Binärdaten (z. B. PDF-Dokumente).

## SOAP
SOAP ist eines dieser Protokolle, die HTTP als Tunnel verwenden.

## Videostreaming
[DASH](https://de.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP) (**D**ynamic **A**daptive **S**treaming over **H**TTP) verwendet HTTP, um Videos über HTTP zu streamen. Dazu wird die Datei in einzelne Segmente aufgeteilt, die jeweils einen kurzen Abschnitt des Original-Videos darstellen. 

--- 

# HTML-over-HTTP
Das ist einer der wichtigsten Anwendungsfälle. Ein Browser fragt eine Ressource per HTTP-GET ab und bekommt HTML zur Antwort, das er rendern muß.

Eine HTML-Seite selbst referenziert allerdings weitere Ressourcen (CSS, JavaScript, Bilder, ...), die der Browser dann auch noch benötigt. Entweder fragt er sie explizit an (HTTP/1) oder bekommt sie vom Server bereits gepusht (HTTP/2).

Caching spielt in diesem Zusammenhang eine wichtige Rolle.

---

# Latenz
Die Latenz spielt zwar für einen einzigen Request keine besonders große Rolle ... wenn aber für eine einzige HTML-Seite hunderte von Requests gefahren werden, kann es zum Problem werden ... 

Die Signallaufzeit wird u. a. durch die Entfernung von Client und Server bestimmt - auch wenn die Signale in Lichtgeschwindigkeit (Glasfaserkabel) über die Leitung rauschen kann das es schon ein paar Millisekunden ausmachen ob der Server in Eppelheim oder in Neuseeland steht.

## Caching
* Google Developers: https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching?hl=de

Viele der Ressourcen einer HTML-Seite sind relativ statisch, d. h. sie ändern sich nicht so häufig und könnten gecached werden (Browser, Proxy-Server, ...). Aus diesem Grund gibt es in HTTP-Response-Headern eine Vielzahl von Informationen, die das Caching ermöglichen sollen. Natürlich ist es am besten, wenn der Server (als Bereitsteller dieser Ressourcen) entscheidet wie lange eine Ressource gechaed werden kann. Das macht Sinn, weil er - in jedem Fall besser weiß als der Client - wie häufig sich die Ressource ändern wird.

Die Anforderungen in Richtung Caching hat sich durch die Verwendung mobiler Endgeräte, gestiegenen Anforderungen hinsichtlich Skalierbarkeit, Offline-Fähigkeit, ... deutlich erhöht. 

Ein paar wichtige HTTP-Response-Header:

* Cache-Control
  * ``max-age``: wie lange darf die Ressource gecached werden?
  * ``public`` vs. ``private``: darf die Ressource gecached werden, obwohl eine Authentifizierung notwendig war, um sie zu bekommen?
  * ``no-cache``
* ETag - Fingerprint der Ressource (aka Validierungstoken) ... dadurch kann zumindest das Senden der Ressource durch den Server unterbunden werden - wenn sich die Ressource nicht geändert hat, macht es ja keinen Sinn. Der Server würde in diesem Fall mit dem Status Code ``304 Not Modified`` antworten.
  * ACHTUNG: der ETag optimiert nur die Größe der Antwort - Caching hingegen verhindert, daß überhaupt ein Request zum Server geschickt wird (und dort evtl. hohe Last erzeugt)

### Cache-Annulierung
Was tun wir, wenn der Server eine neue Version einer Ressource (z. B. CSS-Datei) hat, die ``max-age`` aber noch nicht bei allen Clients abgelaufen ist. Der Server hat keinen Zugriff auf den Cache der Client ... die Clients könnte evtl. nicht mal erreichbar sein (Rechner runtergefahren, Firewall, ...).

Hierzu bedient man sich des Ansatze *Früher-an-später-denken* ... es werden immer Versionsnummern oder Fingerprints (z. B. ETag) in den Ressourcennamen integriert (z. B. ``style.5213tzf.css``). Auf diese Weise kann ein Reload der neuen Ressource bei Bedarf erzwungen werden. Bei einer Änderung bekommt die Ressource einen neuen Namen und muß dann vom Client runtergeladen werden. Man muß hier "nur" sicherstellen, daß die referenzierende Ressource (z. B. die HTML-Seite) nicht unkontrollierbar gecached wird (``no-cache`` oder ETag) ... bei dynamischen Ressourcen (z. B. JSF-generierte HTML-Seiten) ist das aber natürlich das Standardvorgehen.

## CDN - Content Delivery Network
Hierdurch soll die Signallaufzeit durch Erhöhung der  Geografische Nähe reduziert werden.

> "Die Auslieferung von statischen Assets via CDN ist der klassische Anwendnungsfall. Der initiale Request wird vom Origin beantwortet, die restlichen Requests für JavaScript, Bilder und CSS kommen vom CDN." ([javamagazin 5/2016](https://jaxenter.de/ausgaben/java-magazin-5-16), "Teil 10: Latenz - Loading ...")

### Option 1: URL-Rewriting
Der Origin entscheidet aufgrund der geografischen Informationen (z. B. über IP-Adresse) im Request, welcher CDN-Knoten der beste ist und paßt die URLs der verlinkten Ressourcen entsprechend an, so daß diese vom nächstgelegenen Knoten nachgeladen werden.

---

# Tooling
## UI
### Postman

* https://github.com/postmanlabs/postman-app-support/wiki
* [Chrome-Plugin](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop)

---

# HTTP/2
Webapplikationen sind im Jahre 2015 die Standardtechnologie für Software. Der alte HTTP 1.1 Standard wurde den Anforderungen insbes. hinsichtlich Performance nicht mehr gerecht. Die [Latenz](https://en.wikipedia.org/wiki/Latency_(engineering) ist hier ein wichtiger Faktor, der die Responsiveness einer Seite deutlich einschränken kann.  

Google war mit seinem SPDY (aka Speedy) Protokoll Vorreiter in der Implementierung von HTTP/2-Ideen.

## Multiplexing
In HTTP 1.1 wurde pro Verbindung vom Client zum Server nur eine einzige Anfrage bearbeitet. Bis zur Response vom Server war diese Verbindung blockiert. Dieses Problem ist als *Head-of-line-Blocking* bekannt 

Browser unterstützten nur 4-8 Verbindungen .. insofern stellte das ein Bottleneck dar. Insebsonder vor dem Hintergrund, daß eine typische HTML-Seite weitere Objekte referenziert (CSS, JavaScript, Bilder, ...), die erst nach dem Laden der HTML-Seite bekannt werden. Das führt zu einer Request-Salve für eine einzige HTML-Seite.

Die Antwort von HTTP/2 ist das **Multiplexing**, d. h. eine Verbindung kann für mehrere Anfragen/Antworten verwendet werden. 

Das hat außerdem den Vorteil, daß das [Slow-Start-Problem](https://en.wikipedia.org/wiki/TCP_congestion_control) (die Übertragung ist am Anfang langsam und wird dann immer schneller), das pro Verbindung existiert weniger dramatisch ist. Pro Server tritt der Slow-Start nur ein einziges Mal auf.

## Priorisierung von Ressourcen
Aufgrund der Vielzahl unterschiedlicher Informationstypen (CSS, JavaScript, Bilder) kann eine Priorisierung erfolgen (z. B. CSS höher priorisiert als Bilder ... dann kann der Browser schon mal mit dem Rendering beginnen). Der Borwser kann außerdem Abhängigkeiten definieren und so dem Verbindungscontroller eine bessere Priorisierung ermöglichen.

## Server-Push für Ressourcen
Ein Server kennt die Anwendung, die bereitgestellt wird, und kennt somit auch die Menge der Ressourcen, die der Client benötigen wird. Aus diesem Grund kann die Latenz (wie lange dauert es bis der Benutzer die Seite nutzen kann) reduziert werden, indem der der Server die notwendigen Ressourcen pusht.

---

# Server-Push-Technologien
Das typische Request-Response-Verfahren (Pull-Verfahren) bei HTTP wird den hetigen Anforderungen an Responsiveness nicht mehr gerecht. Statdessen benötigen wir ein Push-Verfahren wie es auch im Mode-View-Controller-Pattern vorgeschlagen wird. Der Server weiß wann sich neue Informationen für einen/mehrere Clients ergeben haben und liefert die Informationen gezielt weiter. Das erhöht sicherlich den serverseitigen Aufwand (auch den Entwicklungsaufwand), aber der Server wird auch andererseits in manchen Use-Cases (z. B. Chat-Webapplikation) entlastet, weil er keine nutzlosen Pull-Anfragen beantworten muß.

## WebSockets
... bieten die Möglichkeit zur Umsetzung von Server-Push