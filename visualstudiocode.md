# Visual Studio Code
* [Homepage](https://code.visualstudio.com/?wt.mc_id=DX_841432&utm_source=vscom&utm_medium=ms%20web&utm_campaign=VSCOM%20Home)

Aus einem Atom-Fork hervorgegangen ... die out-of-the-box Git-Integration ist schon mal sehr beeindruckend. Zudem bringt es noch weitere meiner favorisierten Features mit (auto-reveal-in-sidebar, Terminal, git-diff ... lokale Änderungen werden im Editor markiert), die bei Atom nachträglich installiert werden müssen. 

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

```
code-insiders --goto file1.txt
```

wird die angegebene Datei geöffnet. Leider dauert der Start von VSC im Vergleich zu `vi`/`emacs` leider 1-2 Sekunden, aber das ist aus meiner Sicht zu verschmerzen.

Ich habe mir ein kleines Shellscript (`visualStudioCode.sh`) geschrieben, um den Aufruf noch komfortabaler zu gestalten:

```
#!/bin/bash
if [ "$#" == "1" ]; then
   _options="--goto ${1}"
fi
~/programs/VSCode-linux-x64/code-insiders --disable-gpu ${_options}
```

Dieses Shellscript habe ich zudem noch als `alias v=${PATH_TO}/visualStudioCode.sh`, so daß ich nun per `v file1.txt` ganz schnell eine beliebige Datei mit VSC bearbeiten kann.

Nochmal interessanter wird es dadurch, daß auch Zeileneinsprünge möglich sind. Hat man beispielsweise einen String mit `grep` gesucht hat:

```
╭─pfh@workbench ~/temp  
╰─➤  grep -ri Sonne *    
test/pierre.txt:35:Sonne scheint
```

Per `v test/pierre.txt:35` wird VSC direkt an der richtigen Stelle geöffnet. 

... echtes Workbench Feeling :-)

### VSC als Difftool
VCS unterstützt Parameter über die Command-Line 

```
code-insiders --diff file1.txt file2.txt
```

... auf diese Weise kann man den Editor sehr gut als Difftool (statt GNU `diff`) verwenden. 

> Kleine Einschränkung: im Vergleich zu `diff` startet dieses Difftool mit einer Verzögerung von 1-2 Sekunden (je nach Rechner) ... aus meiner Sicht ist das zu verschmerzen

## FAQ

**Frage 1:** 

Dateien werden manchmanl nicht in einem neuen Tab geöffnet, sondern ein bestehender Tab wird wiederverwendet (die darin angezeigte Datei wird ausgetauscht).

**Antwort 1:**

VSC kennt den sog. Preview-Modus - erkennbar an der kursiven Schrift auf dem Editor-Tab. In diesem Modus erfolgt per Default ein Austausch des Contents. Will man immer ein neues Tab geöffnet haben, so sollte man die Einstellung `"workbench.editor.enablePreview": false` verwenden.


