# Heimnetzwerk
Zuhause habe ich leider keine durchgehende kabelgebundenes Netzwerk - bei Renovierungen achte ich allerdings darauf, das nachzuholen (gleich mit 10GBit Kabel - Cat 7 FSTP). Im Erdgeschoss kommt der DSL-Anschluss an und von dort habe ich Kabel in den zweiten Stock (über ein hohles Geländer) ... das ist schon mal sehr gut und mehr als ich mir hätte wünschen können in meinem 80er Jahre Haus.

# DSL Router 7390
Jahrelang hat dieser Router sehr gute Dienste geleistet, doch mittlerweile ist er schon ein wenig in die Jahre gekommen (Stand 2017). Folgende Punkte sind nicht mehr up-to-date:

* kein WLAN ac - Performance schlecht
  * das ist tasächlich ein Problem, da ich viele Videos auf meinem NAS habe, die nur ruckelnd daherkommen
  * allerdings hat auch mein Haupt-Laptop nur eine schlechte WLAN-Performance, da nur eine Antenne verbaut ... wird aber bald mal ausgetauscht
* kein Mesh-Support

# Alte Fritzbox als AccessPoint
Ich habe im zweiten Stock eine alte Fritzbox als AccessPoint eingerichtet. Das funktioniert prinzipiell, aber die alte Box kann halt keine aktuellen WLAN-Standards und kommt somit auf eine schlechte Performance. Das liegt sicherlich auch daran, daß das 2,4 GHz Netz von vielen meiner Nachbarn genutzt wird und die Box nicht automatisch zwiscchen den Kanälen umschalten kann. Selbst ein Raum vom AccessPoint entfernt habe ich weiter habe ich manchmal inakzeptable Geschwindigkeit.

# Fritz!WLAN Repeater 1750E als AccessPoint (aka LAN Brücke)
* [Fritz-Dokumentation](https://avm.de/service/fritzwlan/fritzwlan-repeater-1750e/wissensdatenbank/publication/show/903_FRITZ-WLAN-Repeater-per-LAN-mit-Router-z-B-FRITZ-Box-verbinden/)

Den Repeater 1750E kann man in verschiedenen Modi betreiben:

* [Repeater](https://avm.de/service/fritzwlan/fritzwlan-repeater-1750e/wissensdatenbank/publication/show/194_FRITZ-WLAN-Repeater-per-WLAN-mit-Router-z-B-FRITZ-Box-verbinden/)
* [LAN Brücke](https://avm.de/service/fritzwlan/fritzwlan-repeater-1750e/wissensdatenbank/publication/show/903_FRITZ-WLAN-Repeater-per-LAN-mit-Router-z-B-FRITZ-Box-verbinden/)
* [Mesh](https://avm.de/service/fritzos-690/faqs/welche-fritz-produkte-unterstuetzen-wlan-mesh/)

Der Modus *LAN-Brücke* funktioniert als AccessPoint und somit perfekt geeignte, um mein WLAN im zweiten Stock aufzuspannen. Außerdem unterstützt dieser Repeater 2,4 GHz und 5 GHz und Übertragungsraten bis zu 1300 MBit/s. Im Vergleich zu meinen [150 MBit/s meiner Fritzbox 7390](https://avm.de/service/fritzbox/fritzbox-7390/wissensdatenbank/publication/show/514_WLAN-Verbindungen-langsam-geringe-Datenrate/) ein Traum.

Aufgrund des Mesh-Supports ist der Repeater auch für einen zukünftigen Austausch des langsam veralteten DSL-Routers 7390 vorbereitet.

# Aktuelle Fritzbox - 2017
* https://avm.de/produkte/avm-produktvergleich/fritzbox/alle-anschluesse/

Alternativ zu einem Fritz!WLAN Repeater 1750E könnte ich meine aktuelle 7390 gegen einen neuen DSL-Router austauschen und aus der 7390 einen AccessPoint machen.

* 7590 und 7580:
  * mit [MU-MIMO](https://avm.de/mu-mimo/) höchste WLAN-Performance: 5GHz: 1.733 MBit/s + 2,4GHz: 800 MBit/s
  * das "VDSL-Supervectoring 35b" mit bis zu 300 MBit/s DSL kann ich an meinem Wohnort nicht gebrauchen
* 7490: 
  * ohne MU-MIMO - 5GHz: 1.300 + 2,4GHz: 450
  
Alle o. a. Router sind in folgenden Punkten:

* WLAN AC+N
* 2,4 + 5 GHz
* Dual WLAN
* 4 Gigabit LAN
* 2 USB (3.0???)
* Telefonanlage

## MU-MIMO vs. SU-MIMO
Statements von AVM: (https://avm.de/mu-mimo/)
* "Ein Router mit SU-MIMO versorgt die Netzwerkgeräte nacheinander mit Daten. Daher ist die im gesamten WLAN erreichbare Geschwindigkeit beim Einsatz mehrerer Geräte geringer."
* "Durch die gleichzeitige Übertragung mehrerer Datenströme per MU-MIMO lassen sich freibleibende Streams parallel für andere Geräte nutzen. Die WLAN-Kapazität wird besser ausgeschöpft und es entstehen weniger Verzögerungen. [...] Viele aktuelle WLAN-Geräte wie Smartphones, Tablets, PC-WLAN-Adapter etc. unterstützen bereits die neue MU-MIMO-Technologie. [...] Sind Notebook oder PC nicht MU-MIMO-fähig, bringt der FRITZ!WLAN Stick AC 430 MU-MIMO sie auf Touren."

# Powerline
* [Produkte von Fritz](https://avm.de/produkte/fritzpowerline/)

Von Powerline halte ich nicht viel. Ich hatte es selbst bisher noch nicht im Einsatz, aber alle Bekannten berichten von Problemen ... instabil und langsam. 