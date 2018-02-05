# awesome - Windowmanager

* Keybindings: https://www.cheatography.com/fievel/cheat-sheets/awesome-window-manager-3-x/pdf/
  * die meisten findet man auch über ``man awesome``

## Motivation

Ich bin Softwareentwickler und bin es gewohnt mit Shortcuts statt mit der Maus zu arbeiten. An meinem Arbeitsplatz verwende ich nicht mal eine Maus, sondern eine Tastatur mit Trackpoint, weil ich den gelegentlichen Griff zur Maus optimieren wollte. Insofern wollte ich auch einen Fenstermanager, der die Tastaturbedienung unterstützt. Mit den sog. Tile-Window-Managern bin ich sehr gut klargekommen.

## Konzepte

**Window:**

Ein Window ist das UI eines Programms. Ein Window ist immer der Master ... das die meiste Aufmerksamkeit hat.

**Layout:**


**Client:**


**Tag:**

---

## Installation

```bash
sudo apt-get update
sudo apt-get install awesome
sudo apt-get install awesome-extra
```

Mit dem `awesome-extra` Paket kommen auch Komponenten wie [Vicious](https://github.com/Mic92/vicious) mit, mit denen sich der Window-Manager noch mehr personalisieren läßt (z. B. Memory/CPU-Widget).

### Upgrade

Jahrelang hatte ich mit der Version 3 gearbeitet habe ([Ubuntu 14.10](ubuntu_1410_lts.md) + [Ubuntu 16.04](ubuntu_1604_lts.md)) hatte ich mit [IDEA IntelliJ](idea.md) ein paar Probleme in der Bedienung der Menüs (wurden auf der falschen Stelle aufgeklappt) ... die üblichen Java-Probleme unter awesome ließen sich nicht mit `wmname` lösen. Deshalb habe ich der Version 4 eine Chance gegeben. Folgendermaßen habe ich den Umstieg problemlos erledigt (vorher habe ich die `~/.config/awesome` verschoben, um Migrationsprobleme zu vermeiden und meine persönliche Konfiguration nicht zerschiessen zu lassen):

```bash
sudo add-apt-repository ppa:klaus-vormweg/awesome -y
sudo apt-get update
sudo apt-get install awesome -y
```

Danach einmal ab- und wieder anmelden und voilà ... problemlos. Die ersten Tests mit IDEA sahen vielversprechend aus. Jetzt nur noch die persönliche Konfiguration migrieren und dabei vielleicht etwas über die neuen Möglichkeiten lernen (siehe: .

## Konfiguration

Gleich am Anfang kopiert man am besten die Default `rc.lua` in die perönliche Konfiguration (`cp /etc/xdg/awesome/rc.lua ~/.config/awesome/`). Auf diese Weise hat man einen guten Startpunkt, um die Konfiguration nach seinem Geschmack anzupassen ... die Syntax/Aufbau dieser Datei ist allerdings ein wenig gewöhnungsbedürftig - ich schaffe es immer wieder die Datei zu zerstören, deshalb mache ich immer nur kleine Änderungen und löse dann eine Syntaxprüfung aus.

### Vicious - Widgets

[Vicious](https://github.com/Mic92/vicious) ist im `awesome-extra` Package entahlten und bringt nützliche Widgets wie CPU, Memory, ... mit.

Nach der Installation des Packages (`sudo apt-get install awesome-extra`) müssen die Module in die lokale Konfiguration kopiert werden (`cp -a /usr/share/awesome/lib/vicious ~/.config/awesome/`).

Über `local vicious = require("vicious")` ganz oben in der persönlichen `rc.lua` wird die Vicious-Library geladen.

Ein Widget wird dann folgendermaßen erzeugt:

```properties
memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memwidget, vicious.widgets.mem, "$1 ($2MB/$3MB)", 13)
```

### Task-Switcher

Per Default unterstützt awesome nur den Wechsel zwischen zwei Tasks. So kann man das erweitern:

* http://stackoverflow.com/questions/11697102/awesome-alttab-just-switches-between-two-apps
