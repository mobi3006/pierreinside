# zsh + oh-my-zsh
* https://github.com/robbyrussell/oh-my-zsh

Die Linux-Konsolen sind ja von jeher sehr mächtig. Die ``zsh`` in Kombination mit ``oh-my-zsh`` macht es noch ein bisschen mehr sexy und komfortabel. Insbesondere für Konsolennutzer (u. a. Entwickler) das von unschätzbarem Wert ... die armen Windows-Nutzer (arbeiten ja meist eh mit cygwin) mit ihrer schnöden Windows-Shell (Powershell soll ja ein bisschen mächtiger sein). 

---

# Getting started ...
## Installation
Die zsh Shell installieren

    apt-get install -y zsh
    
dann die oh-my-zsh Erweiterungen hinzufügen

    bash -c
      "$(curl 
         -fsSL
         https://raw.githubusercontent.com
            /robbyrussell/oh-my-zsh/
            master/tools/install.sh)"

und zu guter letzt noch zsh als Default Shell festlegen:

    sudo csh -s $(which zsh) $(whoami)
      
## Konfiguration
Die Konfiguration erfolgt in ``~/.zshrc``.

* Theme: ein Beispiel ``ZSH_THEME="robbyrussell"``

# Themes
* https://github.com/robbyrussell/oh-my-zsh/wiki/themes
* https://github.com/robbyrussell/oh-my-zsh/wiki/External-themes

zsh kommt mit hunderten von Themes ...

## intheloop
* kommt mit dem git-Plugin, das die Arbeit mit Git komfortabler gestaltet

# Plugins
* https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins

Die meisten Plugins enthalten eine gute README Datei.

