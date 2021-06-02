# Babun

* [Homepage](http://babun.github.io/)
  * übrigens eine [GitHub-Page](githubPages.md)

Babun ist ein Tool, das [cygwin](cygwin.md) enthält ... aber zudem noch ein paar nette Features mitbringt. 

... aber leider auch ein paar ziemliche Probleme mit sich bringt (siehe unten). Deshalb bin ichs mittlerweile leid unter Windows arbeiten zu wollen ... Office ok, Surfen ok, aber niemals nicht Software entwickeln

---

## Features

* CLI-Paketmanager (``pact``) - unter cygwin kann die Installation von Paketen nur über den GUI-Installer erfolgen. Ich mag diesen GUI-Installer nicht - außerdem ist mit einem CLI-Paketmanager scripten möglich.
* Auto-Update
* Open-Babun-Here context menu 
* [zsh + oh-my-zsh](zsh.md) out-of-the-box (git-aware prompt!!!)

---

## Installation

> Die Installation von Babun beeinflußt eine evtl. vohandene Cygwin-Installation nicht.

* zip-File downloaden
* ``install.bat /t "C:\target_folder"``aufrufen. Danach sieht das Filesystem folgendermaßen aus:

    ${INSTALL_DIR}/
      cygwin/
        etc/
        home/
        usr/
        ... das übliche ...
      babun.bat
      rebase.bat
      update.bat
      uninstall.bat

---

## Babun-Admin-Tool babun

### babun check

Mittels

    babun check

wird die Konfiguration überprüft ... bei einem Proxy-Problem sieht das Ergbenis dann beispielsweise so aus:

    { ~ }  » babun check                                                                            
    Executing babun check
    Source consistent [OK]
    Prompt speed      [OK]
    File permissions  [OK]
    Connection check  [FAILED]
    Update check      [FAILED]
    Hint: adjust proxy settings in 
      ~/.babunrc and execute 'source ~/.babunrc'

### babun update

Beim ``babun check`` erfolgt auch eine Prüfung auf Babun-Updates. Sollte

    Cygwin check      [OUTDATED]

erscheinen, dann erfolgt der Update von Babun und dem darunterliegenden Cygwin per 

    babun update

### babun shell

Die [zsh mit oh-my-zsh](zsh.md) ist die Default-Shell. Will man eine andere verwenden, dann geht das per 

    babun shell /bin/bash 

oder über die Anpassung der ``/etc/passwd`` per

    chsh -s ${which zsh}

### HTTP-Proxy Konfiguration

... erfolgt in ``~/.babunrc`` ... dort sind die notwendigen Einstellungen auch schon dokumentiert :-)

---

### Paketmanager pact

* ``pact --help``: Anzeiger aller Kommandos
* ``pact install openssh``: Paket ``openssh`` installieren

---

## Probleme

### Verwendung von Cygwin-Pfaden

Ein

``java -jar /cygdrive/c/libs/MyComponent.jar``

und

``java -jar /c/libs/MyComponent.jar``

schlägt unter einer zsh-Shell mit

```
Error: Unable to access jarfile /cygdrive/c/libs/MyComponent.jar
```

fehl, obwohl die Datein bei ``ls /cygdrive/c/libs/MyComponent.jar`` bzw. ``ls /c/libs/MyComponent.jar`` problemlos gefunden wird.

Ein

```
java -jar /c/libs/MyComponent.jar
```

hingegen funktioniert.

Sicherlich kann man damit umgehen, wenn man auf der Shell arbeitet. Will man allerdings Skripte unter Windows-Babun wiederverwenden, die auch in Linux-Systemen (Staging, Live) verwendet werden und die laufen aus diesem Grund nicht, dann ist das ein **NO-GO**.

In einigen meiner Skripte verwende ich:

```
_script=$(readlink -f "$0")
_scriptpath=$(dirname "${_script}")
```

um dann Dateien relativ zum Pfad des ausgeführten Skripts referenzieren zu können:

```
java -jar ${_scriptpath}/../libs/MyComponent.jar
```

Das funktioniert unter Linux ganz prima ... unter Windows-Babun out-of-the-box leider nicht, weil als ``${_scriptpath}`` der elende Cygwin-Path ermittelt wird (``/cygdrive/c/libs/MyComponent.jar``).

Ich will jetzt aber keine Babun-spezifische Logik in meine Skripte einbauen (``cygpath -u``), weil die eigentlich für Linux entwickelt werden und die Nutzung unter Windows nur ein Synergieeffekt (Abfallprodukt) darstellt.
