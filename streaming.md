# Streaming

Streaming unterscheidet sich von der Bereitstellung von Videos dadurch, daß Streams live sind und nicht erst noch geschnitten werden. Klingt erstmal nach weniger Arbeit für den Ersteller, dch braucht man hier viel mehr Erfahrung und nicht jeder Content eignet sich fürs Streaming. Streaming von Game-Videos ist bei den Youtubern der Neuzeit der letzte Schrei ... ich frage mich immer wieder warum meine Söhne sich anschauen, wie ein dummlabernder Mitzwanziger FIFA-Icon-Packs öffnet. Mann, mann, mann ... unkreativer kann man seine Zeit durch reines zuschauen nicht vergeuden. Vielleicht kann man die eigenen Kinder aber auf diese Weise zur Content-Erzeugung statt Konsumierung bewegen.

Früher hatte ich mal die Idee auf einem Youtube-Kanal lokale Fußballspiele (7. Liga) live zu übertragen. Nicht für mich, sondern um die Kinder kreativer zu machen ... ein eigener Fernsehkanal mit all den notwendigen Aufgaben. Mittlerweile spielen sie mehr Fußball und hätten dafür keine Zeit ... aber Corona läßt ja nicht mal das zu.

Deshalb habe ich mich mal mit Streaming beschäftigt.

---

## Streaming-Plattformen

Youtube ist schon ein ewiger Player für die Bereitstellung von Videos - mittlerweile kann man dort auch streamen. Den Streaming-Markt haben nun aber auch andere Mitbewerber (allen voran [twitch](https://twitch.com)) entdeckt und buhlen um die Gunst der scheinbar unendlichen Anzahl an Zuschauern, die gern auch mal zu Abonnenten werden oder Donations bereitstellen. Auf diese Weise werden die meisten wahrscheinlich nicht reich, aber wenn man eh tut, was man gerne macht, ein nettes Zubrot und ein gutes Feedback.

Die Platformen unterstützden das mehr oder weniger gut - viele sind also auf Kommerzialisierung ausgelegt, um so Talente auf ihre Platform zu bekommen ... eine Win-Win-Situation also.

### Youtube

Mein erster Versuch mit OBS auf Youtube zu streamen war eher enrüchternd - zugegeben: ich hatte NULL Erfahrung. Es dauerte ein paar Stunden bis ich überhaupt einen Stream anlegen konnte. Danach mußte ich den Stream erst im Youtube Studio anlegen, um den Stream-Key dann in OBS zu hinterlegen und den Stream zu starten. Mein Stream war 10 Sekunden verzögert und Youtube meldete, daß die Videodaten nicht ausreichen, um einen kontinuierlichen Flow zu erzeugen. Also stellte ich die Bitrate auf 4500 Mbit wie von Youtube empfohlen. Doch das Video war immer noch ruckelig und fror teilweise ein - meine Netzwerkverbindung war ok, doch die CPU/GPU war schon recht ausgelastet (ich hatte mehrere Videoquellen in meinem Stream). Ich reduzierte dann die Output-Auflösung von 1080p auf 720p und von 60 FPS auf 30 FPS. Damit erreichte ich ein ordentliches Erlebnis.

### Twitch

Bei Twitch gin es schneller, Account anlegen und in OBS den Twitch-Account verknüpfen. Daraufhin bekam ich ein Stream-Fenser und ein Chat-Fenster in OBS dazu, das ich in der Oberfläche andockte. Schon konnte ich den Stream starten ... er war sofort öffentlich und da ich "Fortnite" als Tag verwendete kamen auch gleich 5 potentielle Zuschauer, denen ich aber nichts zeigen konnte ... ich war ja nur bei der Einrichtung der Umgebung.

---

## Game-Streaming

Hat man das Spiel schon auf seinem Rechner, mit dem man auch streamt, installiert vereinfacht das natürlich die Frage "Wie bekomme ich den Output meiner Konsole (PS4) in den Computer?".

Viele Spiele gibt es auch für den PC ... man muß sie dann aber evtl. kaufen (wer will schon für ein Spiel nochmal zahlen, wenn er es schon für die Spielekonsole gekauft hat?). Einige Spiele sind sogar über den Microsoft Store (z. B. Fortnite) verfügbar.

Fortnite (aus dem Microsoft Store - schlappe 30 GB Installationsdatei) war das erste Spiel, das ich am Laptop mit PS4 Controller gespielt habe. Die Bluetooth-Verbindung war schnell hergestellt, doch Fortnite wollte weiterhin nur mit der Maus/Tastatur gespielt werden. Nach ein bisschen googeln fand ich heraus, daß der PS4-Controller nicht so gut unterstützt wird - im Gegensatz zu einem XBox-Controller. Es wird empfohlen, die Software DS4Windows zu verwenden:

> "Ob via Kabel oder per Bluetooth: Sie werden feststellen, dass der Einsatz des PS4-Controllers am PC in vielen Spielen gar nicht oder nur fehlerhaft möglich ist. Der Grund: Microsoft verwendet bei Windows die Xinput-Schnittstelle, um Gamecontroller anzuschließen. Die meisten Spiele verlangen daher nach einem Xinput-kompatiblen Gamecotnroller, etwa den Gamepads der Xbox One oder der Xbox 360. Sony unterstützt Xinput offiziell nicht, weshalb der PS4-Controller beispielsweise von Spielen wie FIFA 19 nicht erkannt wird. Das macht aber nichts! Es gibt eine Reihe von Programmen, die in die Bresche springen. Das wohl beste ist das kostenlose Programm DS4Windows." ([heise.de](https://www.heise.de/tipps-tricks/PS4-Controller-am-PC-nutzen-so-klappt-s-4208440.html))

---

## PS4 Streaming

### Alternative 1: PS4 Share Button

Die einfachste Variante ist, in der PS4 seine Youtube-Credentials zu hinterlegen und den Share-Button zu drücken. Dann geht das Video live und andere können teilnehmen. Doch besonders professionell ist das natürlich nicht, da man die Spieler nicht sieht, keine Chats beantworten kann, keine coolen Memes einspielen kann ... weit von dem heutzutage üblichen Standard entfernt. So bekommt man ganz sicher keine Follower und schon gar keine Donations :-(

### Alternative 2: PS4 Remote Play

* [Installation und Konfiguration](https://remoteplay.dl.playstation.net/remoteplay/lang/en/ps4_win.html)
* [Youtube Tutorial](https://www.youtube.com/watch?v=8Sg-Jc4wdPU)

> Einschränkung: nicht alle Spiele unterstützen Remote Play

Mit diesem Ansatz kommt man um eine HDMI-Capture-Card herum und kann die PS4-Spiele innerhalb eines Netzwerks (z. B. in einem anderen Raum) per Controller spielen.

> Frage: wird der Stream zunächst auf Sony Server geladen, um von dort wieder runtergeladen zu werden (es wird eine Internet-Upload-Bandbreite von 12 MBit/s gefordert)? Kann ich mir nicht vorstellen ... die Latenz wäre zu hoch.

* Playstation 4
  * Kontoverwaltung - als Primäre PS4 aktivieren
  * optional: Energiespar-Einstellungen - im Ruhemodus verfügbare Funktionen
    * mit dem Internet verbunden bleiben
    * Einschalten der PS4 aus dem Netzwerk aktivieren
    * auf diese Weise kann man die PS4 sogar remote aufwecken
  * Remote-Play-Verbindungseinstellungen - Remote Play aktivieren
* Laptop
  * [Sony Remote Play Software](https://www.playstation.com/de-de/remote-play/) installieren (kostenlos) und starten
    * mit PSN Account anmelden
    * in den Einstellungen die Auflösung überprüfen
    * Controller koppeln

### Optimierung 1: HDMI-Capture-Card + OBS

> Vorteil zum "PS4 Remote Play": minimale Verzögerung ... denn man will das Spiel ja weiterhin gut spielen können. Außerdem benötigt man für einen richtigen Youtube-Kanal einen Computer für die Betreuung der Follower.

Mit [OBS](obs-studio.md) habe ich zumindest schon mal ein Tool kennengelernt, mit dem sich professionelle Streams realisieren lassen. Hierzu benötigt man

* Laptop plus externer Monitor
* Headset wenn man allein ist oder Mikrofon/Webcam getrennt
  * ich würde empfehlen, zumindest zu zweit zu sein, da Moderation und Spielen gleichzeitig auf Dauer wohl auch für die heutige Generation zu stressig ist ;-)
  * wenn man echte Follower hat, dann gibt es zudem noch Mod's, die den Chat verwalten und bei Gewinnspielen unterstützen
* HDMI-Capture-Card, um den HDMI-Stream der PS4 in den Laptop zu bekommen und minimale Verzögerung zu haben. Das PS4-Bild wird dann auf dem Laptop Bildschirm (oder besser: einem großen externen Bildschirm dargestellt). OBS kann dieses Signal als Quelle nutzen und in den Stream integrieren (neben der Webcam und dem Mikrofon und ...)
  * ich habe mir eine HDMI-Capture-Card (HDMI-to-USB2) für knapp 20 Euro gekauft ... bei Elgato zahlt man das 10-fache

---

## OBS Steuerung mit Touch Portal

Für einen Szenenwechsel während des Streamings ist die Bedienung von OBS über Maus zu unkomfortabel. Auch Shortcuts nerven beim gleichzeitigen streamen und zocken ... das lenkt nur ab und die Moderation gerät ins Stocken - wenig professionell.

Elgator bietet das sog. Streamdeck, das auf Tastendruck OBS steuern kann. Diese Geräte kosten ein Vermögen und sind auf 6 oder 12 Buttons limitiert. Mit TouchPortal habe ich eine Lösung gefunden, die deutlich flexibler ist und ähnlich gut auf einem Tablet funktioniert.
