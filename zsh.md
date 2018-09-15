# zsh + oh-my-zsh

* https://github.com/robbyrussell/oh-my-zsh

Die Linux-Konsolen sind von jeher sehr mächtig. Die ``zsh`` in Kombination mit ``oh-my-zsh`` macht es noch ein bisschen mehr sexy und komfortabel. Insbesondere für Konsolennutzer (u. a. Entwickler) das von unschätzbarem Wert ... die armen Windows-Nutzer (arbeiten ja meist eh mit cygwin) mit ihrer schnöden Windows-Shell (Powershell soll ja ein bisschen mächtiger sein).

---

## Getting started

Die zsh Shell installieren

```bash
apt-get install -y zsh
```

und die oh-my-zsh Erweiterungen hinzufügen

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Dadurch wird `~/.zshrc` und ein Verzeichnis `~/.oh-my-zsh` angelegt, das die ganzen oh-my-zsh Erweiterungen enthält ... in `.zshrc` werden diese Erweiterungen (Themes, Custom-Scripts, Templates, ...) in die Shell eingebunden.

Zu guter letzt wird die ZSH-Shell als Default-Shell für den aktuellen User festgelegt:

```bash
sudo chsh -s $(which zsh) $(whoami)
```

Jetzt nur noch and der grafischen Linux Oberfläche ab- und wieder anmelden - das Terminal sollte nun eine oh-my-zsh-Shell präsentieren.

---

## Konfiguration

Die Konfiguration erfolgt in ``~/.zshrc``.

### GRML-Konfiguration

> ACHTUNG: das würde ich zunächst mal nicht machen, weil einfach sehr viel mitbringt ... ich empfehle oh-my-zsh erst mal in der Standardausstattung kennenzulernen. Die Standard `.zshrc` wird aber nach `.zshrc_old` gesichert ... es gibt also einen Weg zurück

Eine sehr umfassende Konfiguration erfolgt in der Distribution GRML, die zsh als default-Shell verwendet. Über

```bash
wget -O ~/.zshrc \
    https://raw.githubusercontent.com/grml/grml-etc-core/master/etc/zsh/zshrc
```

wird das GRML-zsh-Template heruntergeladen und in ``~/.zshrc`` abgelegt.

---

## Themes

* https://github.com/robbyrussell/oh-my-zsh/wiki/themes
* https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes

zsh kommt mit hunderten von Themes ... das Standard-Theme `robbyrussell` hat mir ganz gut gefallen, aber für die tägliche Arbeit mit `git` verwende ich lieber `gnzh`.

### gnzh

Dieses Theme hat aus meiner Sicht den Vorteil, daß der Prompt in einer eigenene Zeile steht:

```bash
╭─pfh@muli ~  
╰─➤  
```

Insbesondere beim meinem [Awesome](awesome.md) Fenstermanager mit der automatischen Anordnung der Fenster ist das von Vorteil, da die Fenster teilweise recht schmal sind. Mit diesem Layout sieht man dann die meisten Kommandos auch ohne Zeilenumbruch, was bei Screen-Sharing mit Kollegen (oder bei Präsentationen) ganz praktisch ist.

### intheloop

* kommt mit dem git-Plugin, das die Arbeit mit Git komfortabler gestaltet

---

## Plugins

* [Plugin Collection](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins)

Die meisten Plugins enthalten eine gute README Datei.