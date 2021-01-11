# Streaming

Streaming von Game-Videos ist bei den Youtubern der Neuzeit der letzte Schrei ... ich frage mich immer wieder warum meine Söhne sich anschauen, wie ein dummlabernder Mitzwanziger FIFA-Icon-Packs öffnet. Mann, mann, mann ... unkreativer kann man seine Zeit durch reines zuschauen nicht vergeuden. Vielleicht kann man die eigenen Kinder aber auf diese Weise zur Content-Erzeugung statt Konsumierung bewegen.

Früher hatte ich mal die Idee auf einem Youtube-Kanal lokale Fußballspiele (7. Liga) live zu übertragen. Nicht für mich, sondern um die Kinder kreativer zu machen ... ein eigener Fernsehkanal mit all den notwendigen Aufgaben. Mittlerweile spielen sie mehr Fußball und hätten dafür keine Zeit ... aber Corona läßt ja nicht mal das zu.

Deshalb habe ich mich mal Game-Streaming beschäftigt.

---

## Alternative 1: PS4 Share Button

Die einfachste Variante ist, in der PS4 seine Youtube-Credentials zu hinterlegen und den Share-Button zu drücken. Dann geht das Video live und andere können teilnehmen. Doch besonders professionell ist das natürlich nicht, da man die Spieler nicht sieht, keine Chats beantworten kann, keine coolen Memes einspielen kann ... weit von dem heutzutage üblichen Standard entfernt. So bekommt man ganz sicher keine Follower und schon gar keine Donations :-(

---

## Alternative 2: PS4 Remote Play

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

---

## Optimierung 1: HDMI-Capture-Card + OBS

> Vorteil zum "PS4 Remote Play": minimale Verzögerung ... denn man will das Spiel ja weiterhin gut spielen können. Außerdem benötigt man für einen richtigen Youtube-Kanal einen Computer für die Betreuung der Follower.

Mit [OBS](obs.md) habe ich zumindest schon mal ein Tool kennengelernt, mit dem sich professionelle Streams realisieren lassen. Hierzu benötigt man

* Laptop plus externer Monitor
* Headset wenn man allein ist oder Mikrofon/Webcam getrennt
  * ich würde empfehlen, zumindest zu zweit zu sein, da Moderation und Spielen gleichzeitig auf Dauer wohl auch für die heutige Generation zu stressig ist ;-)
  * wenn man echte Follower hat, dann gibt es zudem noch Mod's, die den Chat verwalten und bei Gewinnspielen unterstützen
* HDMI-Capture-Card, um den HDMI-Stream der PS4 in den Laptop zu bekommen und minimale Verzögerung zu haben. Das PS4-Bild wird dann auf dem Laptop Bildschirm (oder besser: einem großen externen Bildschirm dargestellt). OBS kann dieses Signal als Quelle nutzen und in den Stream integrieren (neben der Webcam und dem Mikrofon und ...)
  * ich habe mir eine HDMI-Capture-Card (HDMI-to-USB2) für knapp 20 Euro gekauft ... bei Elgato zahlt man das 10-fache
