# Handy 2019

Diesmal suche ich ein Handy für meine Frau und evtl. eins für meinen Sohn. Das Motorola G4 Play meiner Frau hat folgende Probleme

* einen schlechten WLAN-Chip
  * kein 5GHz Support
  * kommt auf maximal 40 MBit/s - wärend mein iPhone 7 400 MBit/s (an der gleichen Stelle im Haus)
  * ich habe ein Gäste-WLAN und ein normales WLAN ... ich kann nur das Gäste-WLAN konfigurieren ... bei dem anderen kommt gelegentlich die Fehlermeldung `IP Konfiguration fehlerhaft` oder es funktioniert einfach nicht (bekommt scheinbar keine IP-Adresse)
    * kann ich eine statische IP-Adresse verwenden?
* seit Android 7.1.1 keine Updates mehr
* Navigation in Google Maps - keine Sprachausgabe ... ich habe alles probiert

---

## Anforderungsprofil

* max. 5,2 Zoll (soll noch in die Hosentasche passen)
  * derzeit ist die Tendenz zu 6 Zoll Handys ... einen Trend, den ich nicht nachvollziehen kann
* schnelles WLAN
* guter Akku
* ordentliche Kamera
* optional: Fingerabdrucksensor

---

## Andoid One

Ich mag die Idee, ein Vanilla Android auf den Geräten zu nutzen, um die Upgradeproblematik (drei Jahre lang Sicherheits-Patches) zu lösen.  

### HTC U11 Life

* [Test von Chip](https://www.chip.de/test/HTC-U11-life-im-Test_126254649.html)

* 5,2 Zoll
* WLAN AC
* Goodies
  * gute Foto-Kamera
  * wasserdicht (IP67)
* keine Kopfhörerbuchse
  * kein Problem für meine Frau
  * Problem für meinen Sohn
* kein Problem: Rückseite anfällig für Fingerabdrücke - kommt eh immer eine Schutzhülle drum
* unschön: mittelmäßige Akkulaufzeit

  > "Anders als die Alltagsperformance lässt die Akkulaufzeit allerdings zu wünschen übrig. In unserem anspruchsvollen Online-Laufzeittest hält das HTC U11 life rund acht Stunden durch, das ist nur Mittelmaß. Das normale U11 zum Beispiel läuft über zehn Stunden. Da der Screen in diesem Test eingeschaltet ist und das Gerät ununterbrochen Videos und Webseiten aus dem Netz lädt, sollte das U11 life Standardnutzer dennoch mit einer Ladung über den Tag bringen. Wenn die effektive Kapazität des Akkus in zwei Jahren nachgelassen hat, kann das aber anders aussehen. Da Ladezeit liegt bei 160 Minuten, das ist für einen 2.600-Milliamperestunden-Akku relativ lang." ([Test von Chip](https://www.chip.de/test/HTC-U11-life-im-Test_126254649.html))

### Nokia 6.1

* leider zu groß ... 5,5 Zoll

---

## Normale Android Handys

### Sony Xperia XZ1

* 5,2 Zoll
* 64 GB Speicher - 230 Euro
* wassergeschützt

### Sony Xperia XA2

* 5,2 Zoll
* 64 GB Speicher - 230 Euro
* wassergeschützt

---

## iPhone 7

* 4,7 Zoll
* sehr teuer ... ich könnte auf 32 GB Speicher reduzieren ... dann sind sie refurbished für unter 300 Euro zu haben

---

## Android FAQ

*Frage 1:* Das WLAN meines Sohnes schaltet sich im Minutentakt ab (und dann auch wieder an) - ich sehe auch in den Ereignissen meiner Fritzbox, daß sich mein Gerät abgeschaltet hat. Was ist da los?

*Antwort 1:* Nachdem ich die üblichen verdächtigen wie Stromsparmodus und mein Gast-WLAN ausgeschlossen hatte, habe ich in den Android Einstellungen den Punkt "WLAN-Steuerungsverlauf" und "WLAN-Steuerung" (im Abschnitt Spezieller Zugriff) gefunden und dort gab es eine App "Token Wallpaper", die immer wieder das WLAN abgeschaltet hat und die entsprechende Berechtigung hatte:

> "Dieser App erlauben, WLAN ein- oder auszuschalten, nach WLAN zu suchen und eine Verbindung damit herzustellen, Netzwerke hinzuzufügen oder zu entfernen oder einen rein lokalen Hotspot zu starten."

Dieser App habe ich die Berechtigung entzogen und kurz darauf kam ein Popup, in dem diese App die Berechtigung zur Deaktivierung des WLAN anfragte "Zulassen, dass Token Wallpaper WLAN ausschaltet?". Über "App-Info im Appstore" fand ich keine Informationen - fast so als hätte ich sie gar nicht von dort installiert. Es kann aber sein, daß [Google diese App mittlerweile aus dem App-Store entfernt hat](https://www.e-recht24.de/news/hardware-software/11559-schaedliche-apps-google-raeumt-in-seinem-play-store-auf.html).

Beim Starten der App bekam ich die Meldung

> "Schädliche App erkannt - Diese App kann nicht autorisierte Abbuchungen auf deiner Mobilfunkabrechnung verursachen, indem sie eine Registrierung für wiederkehrende Gebühren tätigt. TROTZDEM ÖFFNEN - DEINSTALLIEREN"

In der Google Playstore App (der Dienst nennst sich Google Play Protect - läuft regelmäßig im Hintergrund ... hier sollte man also gelegentlich mal eine Blick reinwerfen) wurde diese App und noch eine weitere übrigens als schädlich DEUTLICH sichtbar angezeigt. Ich habe beide deinstalliert.

Glücklicherweise habe ich eine Drittanbietersperre bei meinem Mobilfunkanbieter ... es wurden bisher keine Beträge abgebucht.

> **ACHTUNG:** eine Drittanbietersperre das ist nicht der Standard, sondern muß explizit angefordert werden (und ist häufig auch erst nach 3 Monaten möglich).
