# GitHub Pages

* https://pages.github.com/
* http://jmcglone.com/guides/github-pages/
* https://www.thinkful.com/learn/a-guide-to-using-github-pages/

GitHub Pages ist ein Hosting-Service, der statische Webseiten bereitstellt.

## User-Pages

    https://username.guthub.io
    
verfügbar. Durch DNS-Konfiguration (CNAME) läßt sich die Seite auch unter einer Custom-Domain (z. B. ``mobi3006.cachaca.de``) bereitstellen, so daß GitHub nicht mehr sichtbar ist.

## Repo Pages

https://tispayments-intern.github.io/landingpages

## Project-Pages

Zudem lassen sich noch sog. Projektseiten erstellen (https://help.github.com/articles/creating-project-pages-manually/), um mehrere unterschiedliche Content-Kategorien anzubieten. Projektseiten sind unter

    http(s)://<username>.github.io/<projectname>

verfügbar.

---

## Getting started ...

Anlegen eines GitHub Repository mit dem Namen

    username.github.io

und eine ``index.html`` anlegen (geht auch über die Weboberfläche von GitHub). Die neue Seite ist sofort unter

    http://username.github.io

verfügbar.

---

## Einsatzbereiche

### Static-Site-Generatoren

Verwendet man [Static-Site-Generatoren](staticSiteGenerators.md) wie [Hugo](hugo.md) (Jekyll gehört tatsächlich auch zum GitHub-Ökosystem) o. ä., die HTML-Seiten generieren, dann läßt sich das Deployment sehr komfortabel über ein ``git push`` abbilden. Dadurch entfällt das teilweise umständliche/langsame transferieren der Seite per SCP/FTP auf den Webserver (siehe http://jekyllrb.com/docs/deployment-methods/).

Mit [Jekyll](jekyll.md) ist die Integration noch komfortabler, da GitHub Pages auf Jekyll basiert. Die Jekyll-Verzeichnisstruktur wird interpretiert und daraus automatisch eine Website generiert.