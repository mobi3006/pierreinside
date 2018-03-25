# Angular

Angular JS (Version 1) bzw. Angular (Version 2) ist ein Framework von Google zur Erstellung von Single-Page-Applications.

> "Of course, there are other options (some of them very good), but there’s value in a large ecosystem and developer community, and React & Angular dominate usage. There is not even a close third. The only library more popular than these two is jQuery (yes, still)." ([Angular 2 vs React: The Ultimate Dance Off](https://medium.com/javascript-scene/angular-2-vs-react-the-ultimate-dance-off-60e7dfbc379c), Oktober 2016)

## Einordnung

Man unterscheidet im JavaScript-Bereich ganz stark zwischen einer Bibliothek (z. B. jQuery, React) und einem Framework (z. B. Angular). Ein Framework erleichtert den Einstieg, weil bereits bestimmte Konzepte/Vorgaben geschaffen sind - eine Bibliothek bietet mehr Freiheiten. Bei React hat man für bestimmte Aufgaben (z. B. State-Management) externe Bibliotheken und hat hier die Qual der Wahl die tatsächlich passende zu finden (z. B. Redux für State-Management).

Für Einsteiger in diesem Bereich ist ein Framework sicherlich geeigneter, um hier nicht in der Flut der einsatzbaren Bibliotheken zu ertrinken.

Seit der Version 2.0 kann man in AngularJS auch in TypeScript programmieren, was den Einstieg für Java-Entwickler besonders angenehm macht. Dennoch soll Angular hohe Einstiegshürden haben.

Alternativen:

* [React vs. Angular](https://javascriptreport.com/why-is-react-more-popular-than-angular/)
  * > "It’s true that React is only a UI library. It doesn’t prescribe routing, state management, data fetching or even language choice. Angular, on the other hand, does make decisions about these things."
* [React vs. Vue.js](https://javascriptreport.com/how-is-react-different-from-vue/)
  * > "If you have a team that is already familiar with React, there is no net advantage to switching to Vue (caveats below). If you have a team that is building front end applications for the first time or are thinking of migrating away from a framework like Backbone or AngularJS, then you should consider Vue, although React retains the advantages I noted above."
* Vue.js
  * soll besonders einfach zu erlernen sein
  * Bibliothek
  * > "Aus meiner Sicht gibt es zwei Faktoren, die das Wachstum von Vue vorantreiben. Erstens wünschen sich viele Entwickler immer noch ein A-bis-Z-Framework, d.h. ein Framework, das von Routing über Templating bis hin zu Backend-Datenabruf alles erledigt. Vue tut genau das, was es für einen Anfänger in der Entwicklung sehr einfach macht, da sie nur noch eine Wahl treffen müssen: Vue verwenden und alle anderen, restlichen Entscheidungen werden für sie getroffen." ([entwickler.de](https://entwickler.de/online/javascript/javascript-vue-579827096.html))
* Meteor

Für meinen Einstieg in die Ssingle-Page-Applikationen im JavaScript-Ökosystem habe ich mich dann letztlich für Angular 2 entschieden, weil es mir mit TypeScript einen leichteren Einstieg ermöglicht. Mit JavaScript hatte ich bisher bei den wenigen Versuchen immer ein wenig Probleme.

## Getting started

### NodeJS Installation

[siehe hier](nodejs.md)
 
### AngularJS Installation

Hier installiert man das AngularJS-CLI (Command-Line-Interface) über den Node-Paketmanager `sudo npm install -g @angular/cli`.

### TypeScript Installation

Mit `sudo npm install -g typescript` wird der TypeScript Support hinzugefügt ... `tsc -v` liefert die installierte Version.

### Angular Projekt `goals` anlegen und starten

```bash
ng new goals
ng serve --open
```

Im Browser kann man dann die Webanwendung über http://localhost:4200 nutzen ... jede Änderung am Code wird automatisch compiliert und ist innerhalb weniger Augenblicke sichtbar in der Webanwendung, die automatisch ein Reload macht.

## `ng` - CLI for AngularJS

* https://github.com/angular/angular-cli/blob/master/README.md

## Aufbau einer Angular Anwendung

* besteht aus Komponenten - die Root-Komponente ist die App-Component (`src/app/app.component.ts`), die ganz am Anfang des Applikationsstarts geladen wird

## Entwicklungsumgebung

Mein Lieblingseditor für Textdateien Visual Studio Code besitzt auch Angular Tooling. Folgende Extensions habe ich installiert:

* TSLint

## Mobile Apps und Desktop-Applikationen

Mit Cordova, Electron, Ionic stehen Tools zur Verfügung, mit deren Hilfe sich aus einer Webapplikation mobile Apps und auch Desktopapplikationen auf Knopfdruck bauen lassen.

## Offline-Fähigkeit

Stichwort Progressive Web Apps (PWA) - Angular ist in diesem Bereich angeblich "gut positioniert".