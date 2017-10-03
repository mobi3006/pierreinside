# AngularJS
Seit der Version 2.0 kann man auch in TypeScript programmieren, was den Einstieg für Java-Entwickler besonders angenehm macht.

# Getting started ...

## Vorbedingungen
* NodeJS
* Node Paketmanager:
  * https://de.wikipedia.org/wiki/Node_Package_Manager

Zunächst versuchte ich es mit `apt-get install nodejs`. Doch bei meinem Ubuntu 17.04 wurde dadurch nur nodejs in Version 4.x installiert. AngularJS benötigt aber mindestens 6.9.x. Deshalb habe ich es wieder deinistalliert (`apt-get remove nodejs`). 

Ich wollte nicht den Tar-Ball von AngularJS installieren, sondern diese Paketmanager-Variante, weil sich das einfacher updaten läßt. Deshalb bin ich einer Anleitung im Internet gefolgt (https://webcheerz.com/install-nodejs-and-npm-on-ubuntu/), um ein PPA-Repository zu verwenden:

```
sudo apt-get update
sudo apt-get install python-software-properties
sudo curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
apt-get install nodejs
```

## AngularJS Installation
Hier installiert man das AngularJS-CLI (Command-Line-Interface):

```
sudo npm install -g @angular/cli
```

## AngularJS Projekt `goals` anlegen und starten
```
ng new goals
ng serve --open
```

Im Browser kann man dann die Webanwendung über http://localhost:4200 nutzen ... jede Änderung am Code wird automatisch compiliert und ist innerhalb weniger Augenblicke sichtbar in der Webanwendung, die automatisch ein Reload macht.

# `ng` - CLI for AngularJS
* https://github.com/angular/angular-cli/blob/master/README.md
