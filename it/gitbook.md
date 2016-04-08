# GitBook

Ursprünglich wollte ich meine Seiten nicht bei GitHub hosten, da ich aber mit Hugo Probleme bei der Erstellung einer Menüstruktur hatte, habe ich mich dann doch mal mit GitBook beschäftigt. So könnte ich zumindest mal mit dem Markdown-Style in Fahrt kommen und mir dann aber mittelfristig eine andere Lösung überlegen (oder vielleicht gefällt es mir ja so gut, daß ich dabei bleibe).

## Installation

* http://toolchain.gitbook.com/setup.html

```
$ npm install gitbook-cli -g
C:\Users\MY_USER\AppData\Roaming\npm\gitbook ->
   C:\Users\MY_USER\AppData\Roaming\npm\node_modules\gitbook-cli\bin\gitbook.js
...
```

## Site erstellen, deployen, veröffentlichen

### Erstellung

    $ gitbook init ./gitbook
    Installing GitBook 2.6.7
    gitbook@2.6.7 ..\..\Programme\cygwin\tmp\tmp-8108lvZ454IipE6j\node_modules\gitbook
    ...

Danach habe ich ein Verzeichnis ./gitbook, in dem bereits zwei Markdown-Seiten liegen.

### Deployment - lokal

Per

```
gitbook server ./gitbook
```
    
kann ich das "Buch" lokal deployen, so daß ich per

```
http://localhost:4000
```

darauf zugreifen kann.

Statische Seiten generieren:

Per

    gitbook build ./gitbook

wird ein Verzeichnis ./gitbook/_book angelegt, das alle statisch

Publishing@GitBook:

Für die Veröffentlichung auf GitHub bzw. GitBook muß man sich initial mal bei GitBook anmelden ... keine Sorge man kann sich mit dem GitHub-Account anmelden (oder Facebook, ...)

Publishing@Self-Hosted-Webserver:

Bei

    gitbook build ./mybook

wird ein Verzeichnis ./mybook/_book erstellt, das die statischen Dateien enthält, die man auf JEDEN Webserver deployen kann. Deshalb ist man nicht gezwungen die Bücher bei GitHub zu hosten und bei GitBook zu deployen!!!
Integration in das GitHub-Tooling
ACHTUNG: GitBook kann genutzt werden, ohne die serverseitige GitHub/GitBook-Infrastruktur zu nutzen!!! Allerdings kann die angebotene Toolkette die Arbeit komfortabler machen ...

GitHub:

GitHub kann verwendet werden, um den Raw-Content (Markdown, AsciiDoc) zu speichern (inkl. Versionsverwaltung). Das kann in einem öffentlichen (man kann allerdings bestimmen, wer committen darf) oder privaten Repository erfolgen. Allerdings ist bei GitHub derzeit nur ein einziges private Repository kostenlos ...
Content

    http://toolchain.gitbook.com/pages.html

Filesystem-Organisation:

Unterhalb von $SITE_HOME (auf dem lokalen Rechner) liegt die Datei

    SUMMARY.MD

aus der das Inhaltsverzeichnis (später im linker Navigationsbereich dargestellt), aus dem man dann beliebig in auf die Filesystem-Ordnerstruktur verweisen kann. Yippppiiieeeh ... genau so habe ich mir das vorgestellt :-)

Unterstützte Input-Formate:

GitBook unterstützt folgende Input Formate

    Markdown (GitHub-Flavor)
    AsciiDoc

Unterstützte Output-Formate:

GitBook unterstützt folgende Output Formate

    HTML
    eBook
        epub
        mobi (Amazon-Kindle)
    PDF

Content schreiben:

Der Content kann mit jedem beliebigen Editor geschrieben werden. Auch wenn Markdown eine relativ eingeschränkte Syntax hat, muß man sie einhalten. Deshalb bieten sich Editoren an, die die Seite dann auch gleich darstellen, um so Fehler frühzeitig aufzudecken. GitBook bietet hier einen Editor kostenlos an (https://www.gitbook.com/editor).

