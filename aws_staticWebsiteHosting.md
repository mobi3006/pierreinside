# AWS - Statische Webseiten

* [Dokumentation](https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html)

In einem S3 Bucket lassen sich statische Webseiten hosten (aber nur HTTP support ... für HTTPS sollte man Cloudfront vorschalten)... Du brauchst keinen Webserver zu konfigurieren.

---

## Getting Started

Defaultmäßig verfolgt AWS eine Whitelist-Policy, d. h. alles ist verboten bis es explizit erlaubt wird. Der S3-Bucket ist somit zunächst mal für niemanden sichtbar.

* neuen S3- Bucket anlegen
* Property "Static Website Hosting" im S3-Bucket aktivieren und folgende Einstellungen vornehmen
  * was die Einstiegsseite (z. B. `index.html` - muss sich im Bucket befinden)
* Permissions anpassen ... im einfachsten Fall löscht man die Einstellung "Block all public access" komplett

Anschließend ist die Seite über eine URL wie diese erreichbar

* http://mysite.s3-website.eu-central-1.amazonaws.com/

