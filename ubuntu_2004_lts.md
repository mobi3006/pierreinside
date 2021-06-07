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

## Inbetriebnahme from-scratch

### Pre-Test - Ubuntu 20.04 LTS

Eine Woche vor dem offiziellen Release habe ich die Distribution einem ersten Test unterzogen. Auf meinem privaten Laptop.

Installation in der VirtualBox (8 GB RAM, 4 CPUs, 50 GB static Storage) lief wie erwartet einwandfrei ... inklusive zähem Download der ISO-Datei habe ich für die Erstinstallation mit Updates deutlich unter einer Stunde gebraucht.

> **WICHTIGE EINSTELLUNG:**
> Für effizientes Arbeiten ist die VirtualBox-Einstellung "View - Auto-resize Guest Display" erforderlich, denn ansonsten muß man i. a. im Gast-Fenster scrollen, um Teile des Screens zu erreichen. Diese Einstellung ist per Default nicht eingeschaltet und ich vergesse es immer wieder :-(

Welche Software muß ich anschließend noch installieren und - was aufwendiger ist - konfigurieren:

* awesome Window Manager
  * für 20.04-LTS gibt es bereits Pakete, so daß es sich leicht installieren läßt
  * `sudo apt install awesome`
  * anschließend abmelden und bei der Anmeldung `awesome` als Window-Manager (statt Ubuntu bzw. Ubuntu on Wayland)
  * habe ich jetzt auch den `x-terminal-emulator`, um bei meinem Terminal "Split Horizontally" und "Split Vertically" durchzuführen oder muß ich diese Erweiterung noch explizit installieren ([siehe hier](https://techpiezo.com/linux/change-default-terminal-emulator-in-ubuntu/))
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

### Integration meiner Daten und Konfiguration

Nachdem der erste Test von Focal Fossa so positiv verlaufen ist und ich die Software problemlos installieren konnte, möchte ich nun mein Home-Verzeichnis (inkl. aller Konfigurationen) aus einem Ubuntu 18.04 LTS System in ein Ubuntu 20.04 LTS übernehmen. Darin befinden sich nicht nur meine Git-Repositories, sondern auch meine ssh-Keys und die ganzen Konfigurationsdateien der Tools, mit denen ich arbeite. Im besten Fall kann ich danach einfach loslegen ... in der Theorie, mal sehen wie gut es klappt (einige Tools haben nun natürlich eine höhere Version und dann könnten die Konfigurationsdateien inkompatibel sein).

Prinzipiell gefällt mir mittlerweile die Idee gut, die Home-Verzeichnisse in eine eigene Partition zu legen, weil mir das zukünftig solche Migrationen erleichtert. Außerdem kann ich auf diese Weise auch viel leichter meine Home-Partition erweitern, indem ich einfach eine neue Festplatte anlege, sie in mein System einbinde, alle Daten per `rsync` kopiere und dann die alte Home-Partition aus meinem System entferne. Das erscheint mir deutlich einfacher als meine [bisherigen Resize-Versuche - siehe hier](virtualbox.md).

Ich erzeuge einen Festplatten-Clon meiner alten Festplatte per `VBoxManage.exe clonevdi ubuntu-18.04.vdi ubuntu-20.04-home.vdi`. Das dauert auch nicht lang - je nach Größe der Datei und der GEschwindigkeit der Festplatte ... eine 50 GB Datei war bei mir in unter 60 Minuten durch.

* ACHTUNG: ein Clonen einer kopierten `vdi`-Datei, deren Original aber in meinem VirtualBox eingebunden war, ist mit der Fehlermeldung "already exists" fehlgeschlagen ... auf dem Original hat es funktioniert :-)

> Ein einfaches Kopieren der `*.vdi` Datei ist nicht ausreichend, da die Platte dann weiterhin die gleiche UUID hat und das beim Einbinden in VirtualBox (parallel zum Original) zu einer Fehlermeldung "already exists" kommt ([wie hier beschrieben](https://tecadmin.net/change-the-uuid-of-virtual-disk/)). Deshalb verwenden wir `clonevdi`.

Anschließend verschiebe ich die Festplatte in das Verzeichnis, in dem sich auf die System-Platte von Ubuntu-20.04 befindet und binde die Festplatte per VirtualBox-UI als weitere SATA-Controlled-Platte in meine Ubuntu 20.04 System ein:

... BILD PENDING ...

Anschließend starte ich das System und kann die neue Festplatte mit

```bash
mkdir ~/otherStorage
sudo mount /dev/sdb1 ~/otherStorage
```

einbinden und auf alle Daten zugreifen.

So soll das natürlich nicht bleiben - stattdessen will ich alles unter `/home` (nahezu leer, denn ich habe Ubuntu 20.04 ja neu aufgesetzt) löschen und stattdessen die Partition der neuen Festplatte als `/home` einbinden. Das mache ich so:

```bash
sudo rm -rf /home
sudo mount /dev/sdb1 /home
```

Damit ich das nicht immer wieder nach einem Reboot machen muß, ermittle ich per `blkid /dev/sdb1` die UUID der Partition und hänge an `/etc/fstab` folgende Zeile an:

```
UUID=<UUID_ERMITTELT_PER_BLKID>   /home   ext4   defaults   0   2
```

Dann nochmal restarten - Voila :-)
