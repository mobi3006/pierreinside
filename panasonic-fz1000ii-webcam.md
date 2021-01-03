# FZ1000 ii als Webcam - Recording und Streaming

Seit Corona bin ich im Homeoffice und habe dort regelmäßig Videokonferenzen. Die Qualität meiner im Laptop integrierten Webcam ist sehr mäßig (zugegebenermaßen auch die Lichtverhältnisse - das werde ich ändern) und da der Laptop immer seitlich steht und nicht mein Hauptmonitor ist, schaue ich dei Kollegen bei Pairing-Sessions am Code selten an. Deshalb sollte die Kamera über oder unter meinem Hauptbildschirm angebracht sein.

Da meine [alte GoPro](gopro.md) keinen HDMI-Ausgang hat, dachte ich an die [Lumix FZ1000 ii](panasonic-fz1000ii.md), die sehr gute Videos produziert.

Für Videokonferenzen ist das vielleicht übertrieben (es wird auch eine höhere Bandbreite benötigt), doch für Schulungsvideos oder als Vlogger könnte das sinnvoll sein.

---

## Konzept

* [Anleitung von Digisaurier](https://www.digisaurier.de/praxis-die-digitalkamera-im-einsatz-als-webcam/)
* [FZ1000 ii als Webcam - ausführliches Video](https://www.youtube.com/watch?v=yB8ADxs8rfg)

Die Kamera hat einen Mini-HDMI-Ausgang, der üblicherweise für den Anschluß an einen Fernseher gedacht ist. Diesen kann man allerdings auch in eine HDMI-USB-Capture-Device anschließen und so kommt das Sucher-Monitor-Signal in den Laptop ... im gleichen Format wie bei einer Webcam. Die Kamera wird somit gleich als Webcam erkannt und man kann sie in Videokonferenztools wie Zoom, MS Teams, ... verwenden. Außerdem kann man den Stream über Tools wie OBS aufnehmen oder direkt ins Internet (Youtube, Twitch, ...) streamen.

Drückt man an der Kamera den Video-Aufnahme-Button, so erfolgt die Speicherung der Daten wie üblich auf der Speicherkarte.

> **Einschränkung:** solche Capture-Devices können keine verschlüsselten HDMI-Streams (HDCP) verstehen ... es ist also nicht möglich, verschlüsselte Filme in den Laptop zu schleusen.

### Clean HDMI

* [Was ist Clean HDMI?](https://www.digitalkamera.de/Fototipp/Was_ist_Clean_HDMI_und_wofur_braucht_man_das/12005.aspx)
* [Clean HDMI Panasonic Lumix FZ 1000 ii](https://www.imaging-resource.com/news/2014/07/31/the-panasonic-fz1000-can-output-clean-hdmi-video)
  * diese Anleitung funktioniert auch bei Lumix FZ 1000 ii

Beim ersten Einsatz sah ich bei der Aufnahme tatsächlich den gesamten Bildschirm meiner Kamera - inklusive der On-Screen Info. Nach der Recherche fand ich heraus, daß meine Kamera auf ["Clean HDMI out"](https://www.dpreview.com/forums/post/42462762) umgestellt werden muß, um das reine HDMI-Signal zu erhalten.

> Bei der Lumix FZ 1000 ii kann das über *Settings - TV Anschluß - HDMI Info anzeigen - Off* eingestellt werden.

Unterstützt die Kamera das nicht, bleibt nur die Möglichkeit, die On-Screen Info weitestgehend abzuschalten.

---

## HDMI-USB-Capture-Device

Die Elgato-Produkte haben mir schon gut gefallen, doch die Preise sind auch recht happig. Der günstigste Capturer von Elgato kostet allerdings 150 Euro und für eine Spielerei (derzeit) war ich nicht bereit, diesen Preis zu zahlen. Also habe ich mich auf die Suche gemacht und einen [Capturer (China-Import)](https://www.youtube.com/watch?v=1StLMGj3kno) für 18 Euro gekauft (kann man aber auch schon für 10-15 Euro bekommen). Ich wollte unbedingt einen USB-2 Stick ausprobieren, da ich von diesen Anschlüssen viel mehr habe. Der hat auch auf Anhieb funktioniert und ich war begeistert ...

---

## Verarbeitung des Signals

Mit Tools wie [Open Broadcaster Software - OBS](obs.md) läßt sich das Video als Datei speichern oder direkt auf Youtube und Co streamen.

Ich bin gespannt wie es mit der Latenz aussieht ... insbesondere, wenn man Video und Audio aus unterschiedlichen Quellen verwendet.

---

## Dauerbetrieb

### Strom per DC-Koppler

Eine Webcam per Akku zu betreiben wäre sicherlich keine Freude ... der Akku hält im Video-Modus vielleicht 1-2 Stunden und dann muß er wieder aufgeladen werden. Auch wenn der Akku bei diesem Gerät im Body verbleiben kann würden unnötig viele Ladezyklen "verbraucht" (ein Akku hat nur begrenzt viele Ladezyklen).

Die bessere Variante für eine dauerhafte Nutzung ist ein DC-Koppler.

* die Leica V-Lux 5 ist ein Derivat der FZ1000 ii und somit sollte [dieses Netzteil](https://www.ebay.de/itm/Netzteil-fur-Panasonic-Lumix-DC-FZ1000-II-Leica-V-LUX-Typ-114-Netzadapter/324143566603?_trkparms=aid%3D1110006%26algo%3DHOMESPLICE.SIM%26ao%3D1%26asc%3D20200520130149%26meid%3D871b44c384c84e90b3c7890dc2b46653%26pid%3D100012%26rk%3D1%26rkt%3D12%26sd%3D223476354290%26itm%3D324143566603%26pmt%3D1%26noa%3D0%26pg%3D2047675%26algv%3DSimplAMLCvipPairwiseWebWithBBEV2bDemotion%26brand%3DSubtel&_trksid=p2047675.c100012.m1985) für 25 Euro funktionieren.

### Überhitzung

---

## Panasonic Image App

Ich habe mich immer gefragt warum man eine Kamera fernsteuern sollte. Nun habe ich einen Anwendungsfall.

Der Auto-Fokus funktioniert ja vielleicht out-of-the-box ... aber Zoom und Weißabgleich - dazu will man ja nicht hinter den Schreibtisch zur Befestigung klettern müssen.

Die App ermöglicht die Fernsteuerung der FZ1000 über Bluetooth oder Wifi. Ich bevorzuge Bluetooth, da das energiesparender ist und zudem kann ich mit meinem Handy in meinem WLAN-Heimnetzwerk verbleiben und so das Handy weiterhin wie üblich nutzen (ohne meine mobilen Daten zu verbrauchen).

### Inbetriebnahme Wifi

* Einstellungen - Wi-Fi - Wi-Fi-Funktion - Neue Verbindung - Aufnahme & Ansicht über Fernbedienung

Anschließend mit dem Endgerät (Handy, Tablet) das auf dem Kamera-Display angezeigte Wifi-Netz auswählen (diese SSIDs tragen i. a. den namen FZ10002-123456 ... der letzte Tel ist zufällig).

> **ACHTUNG:** das Netzwerk wird als "Unsecured Network" gekennzeichnet

Anschließend die Image App auf dem mobilen Endgerät starten. Die App verbindet sich nun automatisch über das WLAN direkt mit der Kamera - das muß in der Kamera interaktiv noch genehmigt werden. Diese Genehmigung ist anschließend aber dauerhaft gespeichert (solange man den Namen der Geräte nicht verändert).

Anschließend wählt man in der Image App die "Fernsteuerung" aus. Man wird dann gefragt, ob die Image App Bluetooth zur Kommunikation verwenden soll. Hier "OK" wählen.

Trotz Bluetooth-Konfiguration wird bei jedem Neustart der App eine Verbindung zum WLAN der Kamera zwingend benötigt - ansonsten funktioniert die Fernsteuerung nicht. Allerdings ist die Verbindung auch in

"To connect the camera, authorize the use of location on the Image App settings screen"

Im Endgerät unter "Einstellungen - Image App - Location" von "Never" (Default) auf "While Using the App" stellen

**Fazit:**

Der Verbindungsaufbau scheint mir start verbesserungswürdig. Plug-and-Play sieht aus meiner Sicht anders aus. Mich enttäuscht, daß ich die Fernbedienung nicht ohne Wifi durchführen kann und das Wifi "unsecure" ist.

### Bluetooth

Folgende Einstellungen habe ich an der FZ1000 vorgenommen

* Einstellungen - Bluetooth - SET
  * für die initiale Bluetooth-Pairing des Handys mit der Kamera
  * hierzu wird allerdings auch eine Wifi-Verbindung benötigt ... man wird dazu aufgefordert, das WLAN am Handy auf FZ10002-013516 (o. ä.) einzustellen, damit die Registrierung abgeschlossen werden kann. Danach sollte man unter "Einstellungen - Bluetooth - SET" den Namen des Handys sehen
* Einstellungen - Bluetooth - ON
* Einstellungen - Bluetooth - Automatische Übertragung - OFF
  * ansonsten werden meine Bilder der Speicherkarte in der Kamera automatisch auf mein Handy übertragen ... das will ich für den Webcam-Modus nicht - sonst ist mein Handy schnell voll und die Bluetooth-Banbreite wird anderweitig verbraucht
* Einstellungen - Bluetooth - Automatische Uhreinstellung - ON
  * mein Handy bekommt die Zeit vom Mobilfunkprovider ... die ist sicher immer genau ... und die richtige Uhrzeit ist bei Fotoaufnahmen immer wichtig (zumindest wenn man unterschiedliche Quellen später zusammenbringen will)

> **ACHTUNG:** die Kamera will sich standardmäßig IMMER über Wifi verbinden ... will man Bluetooth verwenden, so muß man das abbrechen und explizit Bluetooth auswählen

### Wifi

Hier hat man zwei Optionen:

* WLAN der Kamera
  * muß an der Kamera aktiviert werden
  * am Handy muß das WLAN-Netz der Kamera ausgewählt werden

Bei mir hat das nicht zuverlässig funktioniert ...

---

## Befestigung

Die Kamera verfügt über ein Stativ-Gewinde und läßt sich somit beispielsweise an einem modularen Multi-Mount-System wie das von [Elgato](https://www.elgato.com/de/multi-mount-system) oder aber auch einem Gorillapod wie das von [Lammcou](https://www.amazon.de/-/en/gp/product/B073N9687P/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1) komfortabel befestigen und ausrichten.
