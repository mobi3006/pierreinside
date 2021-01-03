# Open Broadcaster Software - OBS

* [Homepage](https://obsproject.com/de)

---

## Motivation

Als meine Kinder mit dem Streamen von PS4-Spielen auf Youtube begannen habe ich mir mal angeschaut wie die professionellen YouTuber das machen und bin auf OBS gestoßen.

Tatsächlich ist das YouTube-Streamin nur ein Anwendungsfall, auch in meinem Arbeitsumfeld lassen sich damit professionellere Videos umsetzen. Ich verwende seit einigen Jahren Camtasia, um Video zu schneiden und bin damit sehr zufrieden. Für Screen-Sharing-Sessions oder auch Präsentationen (ein spezielles Streaming) könnte ich mir den Einsatz von OBS sehr gut vorstellen.

---

## Konzepte

* Szene
  * Aufbau eines Screens
* Source
  * Webcam
  * Browser
  * Image
    * Slideshow
  * Video
  * Display Capture
  * Window Capture
  * Game Capture
  * Video Capture Device
    * beispielsweise HDMI-USB-Capturer
  * Background Color
  * Text
* Filter
  * Chroma Key (Green Screen)
* Szene =>* layered Sources
* Szene =>* Audio

---

## Plugins

* [Offizielle Hompage - Pluginübersicht](https://obsproject.com/forum/resources/categories/obs-studio-plugins.6/)

Am besten verwendet man die (evtl. bereitgestellten) Installer - ansonsten werden die Plugins einfach in das Installationsverzeichnis von OBS entpackt, also beispielsweise `C:\Program Files\obs-studio`

---

## MS Teams, Zoom, ... Input

Will man seine OBS-Szene als Input für Kollaborationstools wie MS Teams, Zoom, ... verwenden, dann muss

* in OBS *"Start Virtual Camera"*
* in MS Teams, Zoom, ... als Camera *"OBS Virtual Camera"*

ausgewählt werden.

> In Selbstdarstellung ist das Bild gespiegelt, d. h. man selbst sieht den Text nicht richtig und links ist rechts und andersrum. Die Konferenzteilnehmer sehen das Bild aber richtig herum.

---

## Schnellbedienung

Während einer Präsentation will man i. a. schnell und ohne Unterbrechung des Screens zwischen einen Screen-Sharing und einer Powerpoint-Präsentation umschalten. Das Umschalten sollte so smooth wie möglich sein, denn wildes hin und hergeschiebe von Fenstern wirkt nicht sehr professionell und sorgt für Verwirrung. Hilfreich ist in diesem Fall, wenn man leicht mit Short-Cuts oder Spezial-Devices (wie beispielsweise Elgato Stream Deck) umschalten kann.

### Elgato Stream Deck

... sehr teuer und nur begrenzt "programmierbar"

### Touch Portal

[siehe eigene Seite](touchPortal.md)

... das bessere Elgato Stream Deck
