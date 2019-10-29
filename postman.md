# Postman

Postman ist ein sehr beliebtes Tool, um komfortabel Webservices aufrufen zu können. `curl`/`wget` sind die beliebten CLI-Alternativen.

Für eine interaktive Nutzung einer REST-API ist Postman sehr angenehm - für eine Automatisierung bevorzugen ich noch die CLi Tools, aber Postman lässt sich auch automatsieren und sogar eine Testautomatsierung ist möglich.

## OpenAPI

Hat man eine Schnittstellendefintion in Open API vorliegen, so kann man die ganz einfach als Zeichenkette importieren und hat gleich eine sehr komfortable UI-Schnittstelle. Ich habe das beispielsweise bei der [Instana API](instana.md) so gemacht.

## Konfiguration

### Variablen

Man möchte natürlich nicht für jeden Request immer wieder die gleichen Daten eingeben müssen. Vor allem, wenn die sich mal ändern (z. B. API-Keys oder Access Keys) wäre das sehr aufwendig :-(

Deshalb bietet Postman Variablen an, die auf verschiedenen Ebenen (global bis sehr fein-granular) gesetzt werden können und dann per `{{variable}}` eingebunden werden.

### Authorization

Bei Instana habe ich es beispielsweise so gemacht, daß ich die Authorisierung auf der höchsten Ebene (dem Instana Paket) gemacht habe und in den Requests dann als Authorization nur "Inherit from Parent" angegeben haben.
