# GitBook
* https://www.gitbook.com/
* https://help.gitbook.com/

Ursprünglich wollte ich meine Seiten nicht bei GitHub hosten, da ich aber mit Hugo Probleme bei der Erstellung einer Menüstruktur hatte, habe ich mich dann doch mal mit GitBook beschäftigt. So könnte ich zumindest mal mit dem Markdown-Style in Fahrt kommen und mir dann aber mittelfristig eine andere Lösung überlegen (oder vielleicht gefällt es mir ja so gut, daß ich dabei bleibe).

Die Toolchain bestehend aus

* GitBookEditor: 
  * wird zum Schreiben des Contents (in Markdown) auf dem lokalen Rechner genutzt
  * verwendet Git zur lokalen Speicherung
  * verwendet GitHub zur remote Speicherung
  * ermöglicht die lokale Erstellung von HTML-Seiten, die man auf jeden beliebigen Webserver schieben kann 
* GitHub (https://github.com)
  * hier kann der per GitBookEditor erstellte Content zentral abgelegt werden 
  * die Markdown-Seiten werden hier auch schon in HTML gerendert
* GitBook
  * produziert automatisch (wenn man in GitBook das GitHub Repository konfiguriert und GitBook entsprechende Rechte eingeräumt hat) eine neue Version des Buches sobald in GitHub Änderungen committet wurden 
  * Bücher werden in verschiedenen Formaten erstellt (ePub, PDF, mobi)
  * unterstützt Webhooks, so daß nach der Erstellung eines Buchs weitere Aktionen getriggert werden können

---

# Installation GitBookEditor

* http://toolchain.gitbook.com/setup.html

```
$ npm install gitbook-cli -g
C:\Users\MY_USER\AppData\Roaming\npm\gitbook ->
   C:\Users\MY_USER\AppData\Roaming\npm\node_modules\gitbook-cli\bin\gitbook.js
...
```

---

# Book erstellen, deployen, veröffentlichen

## Erstellung

    $ gitbook init ./pierreinside
    Installing GitBook 2.6.7
    gitbook@2.6.7 ..\..\Programme\cygwin\tmp\tmp-8108lvZ454IipE6j\node_modules\gitbook
    ...

Dadurch wird ein Verzeichnis `./pierreinside`, in dem bereits zwei Markdown-Seiten liegen.

## Deployment - lokal

Per

```
gitbook serve ./pierreinside
```
    
kann ich das "Buch" lokal deployen, so daß ich per

```
http://localhost:4000
```

darauf zugreifen kann.

## Statische Seiten generieren

Per
```
gitbook build ./pierreinside
```
wird ein Verzeichnis `./pierreinside/_book` angelegt, das alle statisch

## Publishing@GitBook

Für die Veröffentlichung auf GitHub bzw. GitBook muß man sich initial mal bei GitBook anmelden ... keine Sorge man kann sich mit dem GitHub-Account anmelden (oder Facebook, ...)

## Publishing@Self-Hosted-Webserver

Bei

```
gitbook build ./pierreinside
```

wird ein Verzeichnis `./pierreinside/_book` erstellt, das die statischen Dateien enthält, die man auf JEDEN Webserver deployen kann. Deshalb ist man nicht gezwungen die Bücher bei GitHub zu hosten und bei GitBook zu deployen!!!


---

# Integration in das GitHub-Tooling
ACHTUNG: GitBook kann genutzt werden, ohne die serverseitige GitHub/GitBook-Infrastruktur zu nutzen!!! Allerdings kann die angebotene Toolkette die Arbeit komfortabler machen ...

## GitHub

GitHub kann verwendet werden, um den Raw-Content (Markdown, AsciiDoc) zu speichern (inkl. Versionsverwaltung). Das kann in einem öffentlichen (man kann allerdings bestimmen, wer committen darf) oder privaten Repository erfolgen. Allerdings ist bei GitHub derzeit nur ein einziges private Repository kostenlos ...

---

# Content

* http://toolchain.gitbook.com/pages.html

## Filesystem-Organisation

Unterhalb von $SITE_HOME (auf dem lokalen Rechner) liegt die Datei `SUMMARY.MD`, die das Inhaltsverzeichnis abbildet (später im linken Navigationsbereich dargestellt). Darin kann beliebig in die Filesystem-Ordnerstruktur referenziert werden. Yippppiiieeeh ... genau so habe ich mir das vorgestellt :-)

### Unterstützte Input-Formate

GitBook unterstützt folgende Input Formate

* Markdown (GitHub-Flavor)
* AsciiDoc

### Unterstützte Output-Formate

GitBook unterstützt folgende Output Formate

* HTML
* eBook
  * epub
  * mobi (Amazon-Kindle)
* PDF

## Content erstellen

Der Content kann mit jedem beliebigen Editor geschrieben werden. Auch wenn Markdown eine relativ eingeschränkte Syntax hat, muß man sie trotzdem einhalten. Deshalb bieten sich Editoren an, die die Seite dann auch gleich darstellen, um so Fehler frühzeitig aufzudecken. GitHub bietet mit dem GitBook Editor ein sehr gutes Tool (siehe unten).

### GitBook Editor

* https://www.gitbook.com/editor

Eigentlich wollte ich die Markdown-Seiten mit dem Editor MEINER Wahl schreiben. Als ich dann aber mit GitBook anfing wollte ich dem diesem Editor mal eine Chance geben ... und tatsächlich adressiert er schon sehr viele Aspekte, die man ansonsten vermutlich über mehrere Tools (Editor mit Live-Vorschau, Git-Client) abbilden müßte ... hier ist alles integriert und somit für Newbies auf jeden Fall ein guter Startpunkt:

* Commit to Filesystem  - rote Umrandung in Abbildung unten
* Sync to RemoteRepo (auf GitHub) - grüne Umrandung in Abbildung unten
* Live-Preview
* WYSIWYG-Editor 
  * besonders gut gefallen haben mir die Shortcuts (Strg-B für Fettdruck, ...)
* Integration neuer Seiten ins Inhaltsverzeichnis (``SUMMARY.md``)
* farbige Anzeige noch nicht gespeicherter Seiten

> ACHTUNG:
> Die Änderungen im Editor sind außerhalb des Editor (Filesystem, ``gitbook serve`` zunächst nicht sichtbar. Erst nach dem Sync (grüne Umrandung) auf das Remote-Repository werden die Änderungen auch außerhalb sichtbar ([Details siehe](#256143)).

![Gitbook Editor commit und sync](images/gitbookEditorCommitSync.jpg)


#### Was bedeutet "Import"? Wo liegen die Dateien?
 
Bei meinem ersten Buch hatte ich meine Sourcen in ``C:\Dev\pierreinside`` liegen und hatte das in GitBook Editor importiert.

Nach einiger Zeit habe ich mir allerdings die Frage gestellt wo denn der Editor die Dateien lokal speichert. Ich hatte eigentlich erwartet, daß die Speicherung in ``C:\Dev\pierreinside`` erfolgt. Dort habe ich neu erstellte Dateien aber nicht gefunden ... in ``C:\Users\MY_USER\GitBook\Library\Import\pierreinside`` aber auch nicht. Selbst eine Suche auf der gesamten lokalen Festplatte war erfolglos. Irgendwo mußten sie aber persistiert sein. Ich habe den Rechner sogar mal runtergefahren und die Dateien waren weiterhin über den GitBook Editor sichtbar ... nur eben nie über den File-Explorer. Selbst nach einem Commit über den GitBook Editor waren die Dateien noch nicht über den File-Explorer sichtbar. Erst nachdem ich ein Sync aufs Remote-repository gemacht habe wurden die Dateien in ``C:\Users\MY_USER\GitBook\Library\Import\pierreinside`` angezeigt ... 

Das passte aber irgendwie zu meiner Beobachtung, daß bei neu angelegten Büchern gar nicht nach dem Speicherort gefragt wurde ... gefunden habe ich diese Bücher aber unter ``C:\Users\MY_USER\GitBook\Library\Import\`` - scheinbar ist das das einzige Verzeichnis, mit dem GitBook Editor arbeiten kann.

Zudem muß erst ein Sync auf das Remote-Repository erfolgen ... komisch ...

Diese Arbeitsweise bin ich so nicht gewohnt bei der Arbeit mit Git ... da ich aber ja nicht mit meinem Tooling arbeite, sondern mit dem Tooling von GitHub mag das der eingeschlagene Weg sein.


---

# Fazit
Ich bin wirklich richtig begeistert von der Toolchain. Außerdem ist das Editieren von Markdown (insbes. mit dem *GitBook Editor*) eine wahre Freude. Zukünftig werde ich deutlich schneller meine Artikel verfassen können und zudem mit noch mehr Freude.

Mal sehen ob ich dauerhaft bei GitBook bleibe ...