# Texteditors
Meine Anforderungen an einen Texteditor:

* plattformübergreifend
* auch für Gelegenheitsnutzer intuitiv bedienbar (nicht wie vi oder emacs - wobei ich mich an ersteren mittlerweile gewöhnt habe)
* nach Möglichkeit kostenlos (aber ein paar Euro würde ich auch investieren)
* konfigurierbare Keybindings
* Syntaxhighlightning
* schneller Start ... ich will zumindest schnell einzelne Dateien von der Konsole öffnen können

# Sublime
Hiermit habe ich ein wenig rumgespielt, war aber nicht bereit, den Preis zu zahlen ... Atom ist meine neue Alternative. 

# Atom
Vom Aussehen ähnelt Atom auf jeden Fall schon mal Sublime ... 

## Getting Started
### Am Anfang nur Probleme :-(
Meine ersten Schritte waren ein wenig frustrierend, weil Atom in meinem VirtualBox Image mit Ubuntu und awesome Fenstermanager nicht starten wollte. Letztlich lag es wohl am VirtualBox und mit der Option ``--disable-gpu`` startete er dann auch wie gewünscht.

Da ich diesen Editor als vi Ersatz von der Konsole verwenden möchte, muß er schnell starten. Das ist leider ein wenig enttäuschend, weil er doch knapp 2 Sekunden braucht, um einen Editor Prozess zu starten und die Datei anzuzeigen (wenn schon ein Editor läuft und man die Option ``--add`` verwendet, dann geht es sehr schnell) ... nicht viel, aber es stört mich trotzdem. Es scheint auch nicht an der abgeschalteten GPU zu liegen, denn unter Windows ist es auch nicht schneller. 

Per ``atom --disable-gpu ~/.bashrc`` wollte ich dann meine erste Datei editieren. HA - PECH gehabt ... die Datei wurde nicht angezeigt ... stattdessen ein "Untitled" Tab. Und plötzlich hatte ich nach dem vierten Versuch auch noch vier Atom-Fenster .... nerv an. Nach einiger Zeit und Google habe ich dann rausgefunden, daß ich den Parameter ``--add`` verwenden muß, um die Fensterflut zu vermeiden.

Nun hatte ich aber immer noch nicht mit ``atom --disable-gpu --add ~/.bashrc`` meine Datei öffnen können. Wie konnte das so schwer sein. Ich installierte mal die Windows Variante und siehe da: ES GEHT ... unter Windows sogar ohne den ``--disable-gpu`` Schalter mit ``atom ~/.bashrc`` ... allerdings startet der Editor auch nicht schneller :-( Dafür sind die Keybindings allerdings anders ... mit Ctrl-q kann ich den Editor unter Linux verlassen aber nicht unter Windows ... **EY MANN**. Ich ließ dann mal die Option ``--disable-gpu`` weg (wird nicht benötigt, wenn schon ein Atom-Prozess läuft) und dann hats auch funktioniert ;-) **Das ist die Lösung:**

```
atom -a --disable-gpu ~/.bashrc   # FUNKTIONIERT NICHT :-(
atom --disable-gpu -a ~/.bashrc   # FUNKTIONIERT :-)
```

Nun ist der Editor einsatzbereit und ich werde ein wenig damit arbeiten ... hierzu muß ich sicherlich auch gleich mal die Keybindings ändern (Eclipse-ähnlich), denn mit denen kann ich wenig anfangen.

### Was mir aber gleich gefiel ...
* Syntaxhighlightning
* vergleichsweise schnelles Öffnen einer per Projekt eingebundenen Ressource
* Schriftgröße mit Ctrl-+ und Ctrl-- verändern ... in Präsentationen ist das ganz praktisch
* Markdown Preview

## Nützliche Pakete
MUST-HAVE:
* auto-reveal-in-sidebar
* opened-files
* advanced-open-file
  * Default input value: Project root
  * Ctrl-l: zum schnellen hochnavigieren
* GIT
  * tree-view-git-status
  * git-plus 
  * git-diff
    * mit _Show Icons in Editor Gutter_

NICE-TO-HAVE:
* eclipse-keybindings
* platformio-ide-terminal
* minimap

## APM Paketmanager
* installierte Pakete befinden sich in ``/home/pfh/.atom/packages``

```
apm install atom-shell-commands
```

### Eclipse Keybindings
Mit den Atom-Default-Keybindings konnte ich mich nicht anfreunden ... ich habe mich eben an die Eclipse Keybindings gewöhnt. Aber per `apm install eclipse-keybindings` findet sich ein Ausweg aus dieser Misere.

Leider war ein Umschalten zwischen den Tabs nicht per `Ctrl-F6` out-of-the-box möglich. Durch Hinzufügen von

```
'body':
  'ctrl-f6': 'pane:show-next-item'
  'ctrl-shift-f6': 'pane:show-previous-item'
```

konnte das Problem gemindert werden. Doch eigentlich wollte ich durch zweimaliges Drücken von `Ctrl-F6` zum ursprünglichen Tab zurückkehren ... der dafür zuständige Command `pane:show-next-recently-used-item` funktionierte aber nicht wie gewünscht.

---

# Visual Studio Code (VSC)
[ausgelagert in eigenen Bereich](visualStudioCode.md) 
