# Ubuntu 20.04 LTS - Focal Fossa

Insgesamt bin ich mit der Stabilität sehr zufrieden und das LTS ist - solange ich noch keine Automatisierung meines Setups habe - die bessere Entscheidung für meine Workbench, die ich für die Arbeit verwende. Ich habe dann keinen Nerv alle 6 Monate eine neue Version aufzusetzen ...

---

## Was mich an 18.04 LTS genervt hat

In den letzten zwei Jahren habe ich mit einem von 16.04 LTS upgegradeten System gearbeitet. Der Upgrade war nicht problemlos ([siehe hier](ubuntu_1804.md)).

Am meisten hat mich genervt, daß

* der Startup relativ lange gedauert hat wegen einem Scan am Anfang des Bootens
* dem `network-resolved`-Problem
* in meinem VirtualBox-Image war der Chromium-Browser sehr ressourcenhungrig - letztlich habe ich Internet-Browsing in meinen Office-Bereich (den Windows-Host) ausgelagert, da mein Linux-System mit mehreren geöffneten Fenstern (ich liebe die Chrome-Extension "Spaces") teilweise unbenutzbar war

Kein Problem war, der Unity-Desktop in der Virtualbox recht zäh war, da ich mit dem awesome-Windowmanager sehr zurfieden bin. Der lief einwandfrei :-)

---

## Pre-Test - Ubuntu 20.04 LTS

Eine Woche vor dem offiziellen Release habe ich die Distribution einem ersten Test unterzogen.

Installation in der VirtualBox (8 GB RAM, 4 CPUs, 50 GB static Storage) lief wie erwartet einwandfrei ... inklusive zähem Download der ISO-Datei habe ich für die Erstinstallation mit Updates deutlich unter einer Stunde gebraucht.

Welche Software muß ich anschließend noch installieren und - was aufwendiger ist - konfigurieren:

* awesome Window Manager
  * für 20.04-LTS gibt es bereits Pakete, so daß es sich leicht installieren läßt
  * `sudo apt install awesome`
  * anschließend abmelden und bei der Anmeldung `awesome` als Window-Manager (statt Ubuntu bzw. Ubuntu on Wayland)
* zsh
  * `sudo apt install zsh`
  * dann noch in `/etc/password` die `/bin/zsh` als Default-Shell einstellen
* Docker CE
  * `sudo apt install docker.io`
  * `sudo usermod -aG docker <MYUSERNAME>`
  * logout + login
  * `docker run hello-world`
* docker-compose
  * `sudo apt install docker-compose`
* Visual Studio Code mit Extensions
* Google Chrome mit Spaces Extension - ist das immer noch so langsam???
  * weder Chrome noch Chromium sind per Default installiert ... stattdessen Firefox
  * ich bin [dieser Anleitung](https://linuxconfig.org/how-to-install-google-chrome-web-browser-on-ubuntu-20-04-focal-fossa) gefolgt:

    ```bash
    sudo apt install gdebi-core wget
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo gdebi google-chrome-stable_current_amd64.deb
    google-chrome
    ```

* Java
* Go
* DBeaver

Besonders komfortabel empfand ich die Installationsvorschläge ... bei der Eingabe von `docker-compose` (das noch nicht installiert war) bekam ich diese Anzeige:

```bash
pfh@ubuntu2004beta:~/Desktop$ docker-compose

Command 'docker-compose' not found, but can be installed with:

sudo snap install docker          # version 18.09.9, or
sudo apt  install docker-compose  # version 1.25.0-1

See 'snap info docker' for additional versions.
```

Einfacher gehts ja wohl nicht :-)

Innerhalb von 2 Stunden waren die meisten meiner genutzten Anwendungen installiert ... jetzt fehlt nur noch meine spezifische Konfiguration. Da die allerdings in Konfigurationsdateien auf meinem alten System abliegt (oder teilweise schon in einem Git-Repository abliegt), sollte das nur noch Fleißarbeit sein.

Ich bin begeistert :-)
