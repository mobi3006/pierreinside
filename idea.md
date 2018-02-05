# IntelliJ IDEA

## Umstieg von Eclipse auf IDEA - Motivation

* [Guide](https://zeroturnaround.com/rebellabs/getting-started-with-intellij-idea-as-an-eclipse-user/)

Ich war es mit Eclipse langsam leid bei sehr großen Anwendungen immer wieder in OutOfMemory Probleme zu laufen, obwohl es sich schon 6 GB gönnte. Lange wollte ich IDEA mal ausprobieren und jetzt war ich endlich genug angenervt. Zudem klappte die Einbindung meines selbstgeschriebenen AnnotationProcessors nicht ... bei den Kollegen mit IntelliJ klappte es out-of-th-box.

## Installation

keine besonderen Vorkommnisse (Ubuntu Linux) ...

## Konfiguration

`${IDEA_HOME}/bin/idea.vmoptions`

### Problem 1: Inotify Watches Limit

* https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit

Die Meldung wurde mir von IDEA angezeigt und die angegebene Lösung (`fs.inotify.max_user_watches = 524288`) klappte auf Anhieb.

### Problem 2: Eclipse Projekt einbinden

Bei `Open ...` konnte ich kein Projekt öffnen, das ich zuvor schon in Eclipse eingebunden hatte. Das gleiche Projekt frisch aus dem Git-Repository klappte. Nach Löschen von `.project` klappte es einwandfrei.

### Problem 3: awesome Windows Manager

Wenn ich das IDEA Fenster an eine andere Position verschiebe, dann werden die Menüs nicht mehr im Fenster angezeigt. Auch ein *Restart Awesome* hilft hier nicht weiter. Starte ich das Fenster aber direkt rechts, dann werden die Menüs auch richtig angezeigt ... sobald ich es einmal verschiebe nicht mehr.

Mir ist bekannt, daß awesome mit Java-Programmen immer wieder Probleme hatte ... bisher hatte `wmname` hier immer geholfen. Bei diesem Problem aber nicht. Allerdings habe ich auch ein relative altes `awesome` (3.5.6), so daß ein Upgrade auf 4.x vielleicht das Problem löst.

Hier ist auch von Problemen die Rede, die angeblich gelöst sind:

* https://github.com/awesomeWM/awesome/issues/255

### Problem 4: awesome ... geöffnete Fenster

Bei manchen Aktionen (Diff auf Files) wird ein weiteres Fenster geöffnet. Unter awesome hat man hier keine Fensterelemente zum Schließen. Mit Ctrl-F4 bekommt man es zu.

### Problem 5: Keyboard Shortcuts

IDEA verwendet andere Tastaturkürzel, aber als Eclipse Entwickler kann man über *File - Settings - Keymap* eine Eclipse-Tastaturbelegung einstellen ... für den Anfang sicherlich mal nicht schlecht.

### Problem 6: Autoscroll to/from Source

Diese Einstellung muß man in der Project-Ansicht als Autoscroll einstellen ... das Drücken des entsprechenden Icons in der Projekt-Ansicht ist nur einmalig (im Gegensatz zu Eclipse wo diese *Link Editor* eine dauerhafte Einstellung ist).

## Erster Eindruck

Als jahrelanger Eclipse-Nutzer (davor viele andere IDEs wie NetBeans, VisualCafe, JBuilder, Emacs, ...) findet man sich relativ schnell zurecht. Sicherlich sind einige Details anders abgebildet (z. B. der Build Prozess intern vs. maven) und man muß sich an einige Sachen gewöhnen (kein sofortiges Compilieren), aber zumindest kommt man recht schnell in einen Arbeitsmodus, auf dem sich aufbauen läßt.

## Konzepte

* Projekt, z. B. ein Git Repository
* Module - ähnlich zu einem Eclipse-Projekt
* Einstellungen werden in einer projektspezifischen Verzeichnis `.idea` gespeichert (ähnlich wie in Eclipse `.settings`)