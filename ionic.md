# ionic Framework für Single Page Applications

Ionic basiert auf Angular - bietet aber im Gegensatz dazu auch UI-Komponenten und ein paar sehr interessante Services rund um die komfortable/schnelle Erstellung von Cross-Platform-Applications, die auch auf Gerätehardware (Kamera, GPS, ...) zugreifen können.

## Installation

Nach der [Installation von NodeJS](nodejs.md) werden die notwendigen ionic JavaScript Bibliotheken per `sudo npm install -g cordova ionic` installiert.

## Getting started

* https://ionicframework.com/docs/intro/installation/

```bash
ionic start myFirstIonicApp tabs
cd myFirstIonicApp
ionic serve
```

Hiermit started die App im Browser und verwendet das UI-Layout der Default Platform - mit `ionic lab` könnte man alle Plattformen nebeneinander sehen.

Danach ist die erste Webapp unter http://localhost:8100/ verfügbar.

## Aufbau

Ionic basiert auf [Angular](angular.md) und die Struktur einer App ist dementsprechend Angular-like.

## Ionic Creator - UIs bauen

Für einen Prototyp ist das sicher mal einen Blick wert ... für professionelle UIs kommt man aber um das coden einer UI nicht herum.

## Native Mobile Apps

* https://ionicframework.com/docs/intro/deploying/

Hierfür braucht man lokal die entsprechenden SDKs oder man verwendet die ionic Pro SaaS, um entsprechende Pakete bauen zu lassen.

Letztlich basiert der Ansatz auf WebViews, d. h. die Browser-Engine des Endgeräts wird als Runtime-Engine für die Webapplikation verwendet. Im Gegensatz zu wirklich native Applications (wie die beispielsweise von React Native erzeugt werden) hat das natürlich Performancenachteile ... mittlerweile ist die Performance i. a. aber kein Problem, da die Endgeräte über eine bessere Hardware verfügen und die WebView-Performance auch deutlich verbessert wurde. Bei speziellen Applikationstypen kann es aber dennoch zu Nachteilen kommen.

> "Angular 2 kann sich auch in Sachen Performance durchaus mit den Besten messen." ([Manfred Steyer - JAXenter](https://jaxenter.de/angular-2-plattform-steyer-44668))

### Ionic Native

Bibliothek um Hardware (Kamera, Touch ID, Bluetooth, ...) auf der jeweiligen Plattform einzubinden. OAuth Unterstützung vorhanden.

### Testen auf Endgeräten - Ionic View App

Die entwickelten Apps lassen sich ja schon ganz gut im Browser testen, für manche Features mit Hardwareanbindung braucht es dann aber eine Installation auf dem jeweiligen Endgerät. Hier kann der umständliche/problematische Weg über den jeweiligen AppStore (via Beta-Provisioning) der Anwendung mit der Ionic View App umgangen werden, die die Software von Ionic-Servern zieht. Auf diese Weise kann man die App ganz leicht von ausgewählten Testern auf ihre Endgeräten testen lassen.