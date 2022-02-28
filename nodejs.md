# NodedJS

---

## Installation

* NodeJS
* Node Paketmanager:
  * https://de.wikipedia.org/wiki/Node_Package_Manager

Zunächst versuchte ich es mit `sudo apt-get install nodejs`. Doch bei meinem Ubuntu 17.04 wurde dadurch nur nodejs in Version 4.x installiert - leider veraltet und nicht nutzbar für die meisten Bibliotheken im JavaScript Ökosystem. AngularJS benötigt beispielsweise mindestens 6.9.x. Deshalb habe ich es wieder deinistalliert (`sudo apt-get remove nodejs`).

Ich wollte nicht den Tar-Ball von NodeJS installieren, sondern diese Paketmanager-Variante, weil sich das einfacher updaten läßt. Deshalb bin ich einer Anleitung im Internet gefolgt (https://webcheerz.com/install-nodejs-and-npm-on-ubuntu/), um ein PPA-Repository zu verwenden:

```bash
sudo apt-get update
sudo apt-get install python-software-properties
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
sudo apt-get install nodejs
```

Danach sollte `nodejs --version` eine 7er Version ausgeben.

---

## Motivation

NodeJS ist JavaScript for the Server - hiermit lassen sich Serveranwendungen und Command-Line-Tools mit JavaScript erstellen. Ein Command-Line Tool für meine Docker-basierte Entwicklungsumgebung sollte der erste Anwendungsfall sein.

---

## Hello World from Scratch

```bash
mkdir hello-world
cd hello-world
npm init
```

Anschließend landet man in einem interaktiven Terminal-Script, das ein NPM-Skeleton erzeugt, das bereits alles notwendige enthält (ich gehe davon aus das Entry-Skript wurde in der interaktiven Session `hello-world.js` genannt):

```txt
package.json
hello-world.js
```

Kurzerhand steuern wir den Hellor-World Code per `echo 'console.log("Hello world")' > hello-world.js` bei (mit einem Editor geht es natürlich auch).

Der Code kann anschließend per `node hello-world.js` ausgeführt werden.

> Dieser Code ist so einfach, daß wir nicht einmal ein `npm install` brauchen

---

## Aufbau einer Node Anwendung

* `package.json`
  * Build-Descriptor - ähnlich `pom.xml` bei Java-Maven-Anwendungen
