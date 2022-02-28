# Postman

Postman ist ein sehr beliebtes Tool, um komfortabel Webservices aufrufen zu können. `curl`/`wget` sind die beliebten CLI-Alternativen.

Für eine interaktive Nutzung einer REST-API ist Postman sehr angenehm - für eine Automatisierung bevorzugen ich noch die CLI Tools (Postman liefert aber auch hier gute Dienste, da sich Requests als `curl` generieren lassen), aber Postman lässt sich auch automatsieren und sogar eine Testautomatsierung ist möglich.

---

## OpenAPI

Hat man eine Schnittstellendefintion in Open API vorliegen, so kann man die ganz einfach als Zeichenkette importieren (Import - Raw Text) und hat gleich eine sehr komfortable UI-Schnittstelle. Ich habe das beispielsweise bei der [Instana API](instana.md) und [GitHub](https://github.com/github/rest-api-description) so gemacht.

---

## Konfiguration

### Variablen

Man möchte natürlich nicht für jeden Request immer wieder die gleichen Daten eingeben müssen. Vor allem, wenn die sich mal ändern (z. B. API-Keys oder Access Keys) wäre das sehr aufwendig :-(

Deshalb bietet Postman Variablen an, die auf verschiedenen Ebenen (global bis sehr fein-granular) gesetzt werden können und dann per `{{variable}}`, `:repo` eingebunden werden.

> {{baseUrl}}/repos/:owner/:repo/contents/:path?ref=cillum null

### Authorization

Bei Instana habe ich es beispielsweise so gemacht, daß ich die Authorisierung auf der höchsten Ebene (dem Instana Paket) gemacht habe und in den Requests dann als Authorization nur "Inherit from Parent" angegeben haben.

---

## Tips und Tricks

* ich kann empfehlen, das "Code" Widget immer geöffnet zu haben, um den zum Request passenden `curl` Code (oder auch andere Sprachen) zu sehen. Das hilft bei der Fehleranalyse ungemein. Insbes. wenn der Request aus Variablen, Parametern, Authorization-Headern, ... besteht. Letztlich zeigt der Code an wie die Werte tatsächlich gesetzt sind.
