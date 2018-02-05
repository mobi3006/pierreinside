# Visual Studio Code

* [Homepage](https://code.visualstudio.com/?wt.mc_id=DX_841432&utm_source=vscom&utm_medium=ms%20web&utm_campaign=VSCOM%20Home)

Aus einem Atom-Fork hervorgegangen ... die out-of-the-box Git-Integration ist schon mal sehr beeindruckend. Zudem bringt es noch weitere meiner favorisierten Features mit (auto-reveal-in-sidebar, Terminal, git-diff ... lokale Änderungen werden im Editor markiert), die bei Atom nachträglich installiert werden müssen. 

## Installation

Hier gibt es abhängig vom Betriebssystem unterschiedliche Möglichkeiten. 

### Binaries

Auf allen Plattformen funktioniert der Download der Binaries von der Visual Studio Code Homepage. Damit bekommt man immer den aktuellsten Snapshot/Release, aber man muss es auch selbst aktualisieren (im Gegensatz zu einem Paketmanager wie `apt-get` oder `snap` ... die dafür aber evtl. auch ein wenig hinterherhinken).

### Ubuntu via Snap

* http://linuxbsdos.com/2017/05/25/how-to-install-visual-studio-code-on-ubuntu-16-10-17-04/

Snap ist ein Paketmanager, der von Canonical entwickelt wurde. Er benötigt den Daemon `spapd`, der unter Ubuntu per Default gestartet ist. Im Gegensatz zu anderen Paketarten (z. B. DEB Pakete) sind ALLE benötigten Ressourcen in einem Snap-Paket ... keine Probleme also mit Abhängigkeiten.

```bash
sudo snap install --classic vscode
```

## Konfiguration

Im Gegensatz zu Atom hat VSC keine grafische Darstellung der Konfiguration (File - Preferences - Settings) ... stattdessen wird die Konfiguration als Textdatei angezeigt.

Die Konfiguration kann auf verschiedenen Ebenen erfolgen:

* userspezifisch: `~/.config/Code - Insiders/User/settings.json`
* projektspezifisch (Projekt = Workspace): `${PROJECT_DIR}/.vscode/settings.json` 

Man überschreibt dann immer die Default-Setting, die man nicht ändern kann ... eine gute Idee.

## Meine Keybindings

* Eclipse Keymap ... Plugin nachinstalliert
* Terminal anzeigen/verstecken: Ctrl-^
* `Ctrl-3` Kommandos anzeigen/ausführen
* `Ctrl-Shift-r` Suche nach Ressourcen
* `Ctrl-r` switch folder/project
  * bei der Auswahl Ctrl drücken => weiteres Fenster wird geöffnet
* `Ctrl-e` Liste der geöffneten Files ... Navigation per Ctrl-(Shift)-e
* `Ctrl-,` Settings anschauen
* `Ctrl-.` Keybindings anschauen 

## Plugins

* Git benötigt auf dem Host-System das Tool `ssh-askpass`, um die Passphrase für das ssh-Zertifikat abzufragen

## Gimmicks

### VSC für Add-Hoc Editierungen

Wenn man viel auf der Kommandozeile unterwegs ist, braucht man immer wieder einen Editor für Dateien, die irgendwo im Filesystem liegen und somit nicht in der IDE der Wahl integriert sind. Meistens werden dann textbasierte Editoren wie `vi` oder `emacs` verwendet, die überall verfügbar und schnell geladen sind.

Mit

```bash
code-insiders --goto file1.txt
```

wird die angegebene Datei geöffnet. Leider dauert der Start von VSC im Vergleich zu `vi`/`emacs` leider 1-2 Sekunden, aber das ist aus meiner Sicht zu verschmerzen.

Ich habe mir ein kleines Shellscript (`visualStudioCode.sh`) geschrieben, um den Aufruf noch komfortabaler zu gestalten:

```bash
#!/bin/bash
if [ "$#" == "1" ]; then
   _options="--goto ${1}"
fi
~/programs/VSCode-linux-x64/code-insiders --disable-gpu ${_options}
```

Dieses Shellscript habe ich zudem noch als `alias v=${PATH_TO}/visualStudioCode.sh`, so daß ich nun per `v file1.txt` ganz schnell eine beliebige Datei mit VSC bearbeiten kann.

Nochmal interessanter wird es dadurch, daß auch Zeileneinsprünge möglich sind. Hat man beispielsweise einen String mit `grep` gesucht hat:

```bash
╭─pfh@workbench ~/temp
╰─➤  grep -ri Sonne *
test/pierre.txt:35:Sonne scheint
```

Per `v test/pierre.txt:35` wird VSC direkt an der richtigen Stelle geöffnet. 

... echtes Workbench Feeling :-)

### VSC als Difftool

VCS unterstützt Parameter über die Command-Line

```bash
code-insiders --diff file1.txt file2.txt
```

... auf diese Weise kann man den Editor sehr gut als Difftool (statt GNU `diff`) verwenden. 

> Kleine Einschränkung: im Vergleich zu `diff` startet dieses Difftool mit einer Verzögerung von 1-2 Sekunden (je nach Rechner) ... aus meiner Sicht ist das zu verschmerzen

## FAQ

**Frage 1:** Dateien werden manchmanl nicht in einem neuen Tab geöffnet, sondern ein bestehender Tab wird wiederverwendet (die darin angezeigte Datei wird ausgetauscht).

**Antwort 1:** VSC kennt den sog. Preview-Modus - erkennbar an der kursiven Schrift auf dem Editor-Tab. In diesem Modus erfolgt per Default ein Austausch des Contents. Will man immer ein neues Tab geöffnet haben, so sollte man die Einstellung `"workbench.editor.enablePreview": false` verwenden.

**Frage 2:** Nach dem Start geht die CPU-Auslastung gleich auf 50% hoch (bei 4 Kernen) - nach Beendigung geht sie wieder runter. Da meine Linux-Umgebung in einer VirtualBox läuft habe ich die Einstellung `-disable-gpu` verwendet. Vielleicht würden die Aufgaben normalerweise von der GPU übernommen ... jetzt muß es eben die CPU machen?

**Antwort 2:** Die Lösung ist viel einfacher - ich hatte das Java Extension Pack installiert und das scannt/verarbeitet dann alle `pom.xml` und Java-Klassen. Nach der Deaktivierung war der CPU-Verbrauch nach dem Start wieder normal. Ich hatte das mal reingenommen, weil ich bei einem sehr großen Projekt extreme Probleme mit meinem Eclipse hatte (lange Buildzeiten + UI nicht mehr bedienbar) - jetzt verwende ich [IDEA](idea.md) ... deshalb brauche ich das Java Extension Pack nicht mehr.

**Frage 3:** Mein Config-Verzeichnis von VSC (`~/.config/Code - Insiders`) ist mit über 3 GB extrem groß. Was verbraucht soviel Platz?

**Antowrt 3:** Das Verzeichnis `~/.config/Code - Insiders/User/workspaceStorage` enthielt sehr viele Workspaces und insgesamt knapp 3GB. Viele Workspaces waren sehr alt und nicht mehr genutzt. Ich habe sie gelöscht (bis auf einen) und danach hatte das Config-Verzeichnis nur noch eine Größe von 0,3 GB.