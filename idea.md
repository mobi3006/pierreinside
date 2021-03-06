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

Mit dem Wechsel auf die 4.x Version von awesome ([siehe hier](ubuntu_1604_lts.md)) konnte ich das Problem beseitigen.

Ich habe nur noch gelegentlich das Problem, daß Popup-Fenster während des Tippens den Fokus verlieren und ich dann in den Editor schreibe. Das ist unangenehm, passiert aber nicht ständdig - mal sehen ob ich den Trigger noch finde.

### Problem 4: awesome ... geöffnete Fenster

Bei manchen Aktionen (Diff auf Files) wird ein weiteres Fenster geöffnet. Unter awesome hat man hier keine Fensterelemente zum Schließen. Mit Ctrl-F4 bekommt man es zu.

### Problem 5: Keyboard Shortcuts

IDEA verwendet andere Tastaturkürzel, aber als Eclipse Entwickler kann man über *File - Settings - Keymap* eine Eclipse-Tastaturbelegung einstellen ... für den Anfang sicherlich mal nicht schlecht.

### Problem 6: Autoscroll to/from Source

Diese Einstellung muß man in der Project-Ansicht als Autoscroll einstellen ... das Drücken des entsprechenden Icons in der Projekt-Ansicht ist nur einmalig (im Gegensatz zu Eclipse wo diese *Link Editor* eine dauerhafte Einstellung ist).

## Erster Eindruck

Als jahrelanger Eclipse-Nutzer (davor viele andere IDEs wie NetBeans, VisualCafe, JBuilder, Emacs, ...) findet man sich relativ schnell zurecht. Sicherlich sind einige Details anders abgebildet (z. B. der Build Prozess intern vs. maven) und man muß sich an einige Sachen gewöhnen (kein sofortiges Compilieren), aber zumindest kommt man recht schnell in einen Arbeitsmodus, auf dem sich aufbauen läßt.

Der Unterschiede ist nicht extrem aber viele kleine Dinge funktionieren einfach smoother.

## Konzepte

* Projekt, z. B. ein Git Repository
* Module - ähnlich zu einem Eclipse-Projekt
* Einstellungen werden in einer projektspezifischen Verzeichnis `.idea` gespeichert (ähnlich wie in Eclipse `.settings`)

## Maven

Mit der versteckten m2e Integration von Maven in Eclipse bin ich nie so richtig warm geworden.

Bei IntelliJ ist die Integration explizit über  "Maven Projects" ... das ist mir zumindest schon mal lieber - man hat das eher im Griff, wenn der Maven Build (am besten bei einem Projekt- oder Branchwechsel) und wann der IDEA Build genutzt wird.

Es werden Umgebungsvariablen wie beispielsweise ${MAVEN_OPTS} berücksichtigt ... auf diese Weise kann man Konfigurationen des Maven-CLI auch in der IDE wiederverwenden (war bei Eclipse übrigens genauso ... wenn nicht sogar noch maven-näher, da dort auch `~/.mavenrc` berücksichtigt wurde, was bei IntelliJ nicht der Fall ist).

## Fazit

Ich bin recht schnell mit der neuen IDE zurechtgekommen ... mein fehlendes Wissen über die Shortcuts bremsen mich derzeit noch aus. Trotz eingestellter Eclipse-Keymap sind nur die rudimentären Shortcuts gleich ... bei Refactorings hört es dann aber auf (vermutlich ist das Mapping der Funktionalität nicht so gut).

Die Warterei auf die IDE (durch lange Build-Zyklen) hat scheinbar ein Ende und ich komme nun mehr zum Arbeiten.

Folgende Dinge finde ich besonders hilfreich:

* Debugging-Informationen ... bei Eclipse mußte ich immer in den Views navigieren, um die Wertebelegung von Variablen zu sehen oder ein *Evaluate Expression* ausführen. Bei IDEA werden die Werte über den Editor gelegt:

 ![Debug Informationen](images/idea_debugInformations.png)