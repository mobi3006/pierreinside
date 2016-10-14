# terminator
Konfigurierbares Konsolenfenster unter Windows.

# Layout
Bestimmt die Anordnung der Fenster/Widgets.

## Custom Command
Wird das Fenster innerhalb des Layouts erstmalig geöffnet, so wird dieses Kommando ausgeführt. Es ist zu beachten, daß keinerlei Shell-Umgebungsvariablen und Alias genutzt werden können. Außerdem muß am Ende - sofern man das Fenster behalten will (ansonsten wird es geschlossen - ein ``; bash`` o. ä. stehen muß (siehe http://superuser.com/questions/788877/terminator-custom-commands-cause-shell-to-close).

```
cd ~/src/cachaca/setenv.sh; bash
```

## Working Directory
Das hat bei mir gar nicht funktioniert ...

---

# Profile
Jedes Widget hat ein genau ein Profile. Im Profile sind folgende Aspekte definiert

* Farben
* Hintergrundbild
* Scrollverhalten
* ...

---

# Start
Beim Start kann man per

```
terminator -l programming -p cloud
```

das Layout (``programming``) und das Profil (``cloud``) übergeben, um so eine vorkonfigurierte Umgeung zu erhalten.
