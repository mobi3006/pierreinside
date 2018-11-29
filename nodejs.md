# NodedJS

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

## Motivation

NodeJS ist JavaScript for the Server - hiermit lassen sich Serveranwendungen und Command-Line-Tools mit JavaScript erstellen. Ein Command-Line Tool für meine Docker-basierte Entwicklungsumgebung sollte der erste Anwendungsfall sein.

## Aufbau einer Node Anwendung

* `package.json`
  * Build-Descriptor - ähnlich `pom.xml` bei Java-Maven-Anwendungen