# Smart-Home - Hausautomatisierung

Der Markt der Hausautomatisierung ist sehr fragmentiert und das macht die langfristige Entscheidung für eine Ecosystem so schwierig. Es ist sehr viel Bewegung im Markt und die Gefahr aufs falsche Pferd zu setzen groß. Durch den aktuellen Hype, an dem auch große Hersteller beteiligt sind, könnten sich allerdings langfristige Standards herauskristallisieren, die zumindest mittelfristig unterstützt werden.

Eines ist klar, die Technologie schreitet schnell voran und die Investion könnte in 5 Jahren schon nicht mehr unterstützt werden. Aus diesem Grund würde ich auf eine Technologie setzen, die nachrüstbar ist oder Erweiterungsmöglichkeiten bietet. Aus diesem Grund macht es wahrscheinlich keinen Sinn, Unterputz-Verkabelung zu planen - kabelelose Lösungen erscheinen hier sinnvoller. Zudem macht er wahrscheinlich keinen Sinn viele proprietäre Systeme zu verbauen, weil dann jeder seinen eigenen Ansatz hat. Die Steuerung über ein programmierbares Standard-Interface wie z. B. Handy macht deutlich mehr Sinn als ein proprietären Endgerät, das in 3 Jahren keine Updates mehr bekommt und für das es auch keine Ersatzteile gibt.

Heutzutage ist es aber nicht nur die Hardware, die nicht mehr unterstützt wird, sondern häufig die Software. Kauft man fürs ganze Haus die teuren Hue-Lampen, die derzeit ganz toll dimmbar in 16,7 Millionen Farben per App reguliert werden kann, dann kann es passieren, daß das System in 2 Jahren schon nicht mehr mit den aktuellen Handys unterstützt wird, weil die Hersteller neue Endgeräte verkaufen wollen und gar kein Interesse mehr an der Unterstützung der alten Systeme haben. Will man dann alle 2 Jahre alles austauschen ... und alle programmierten Routinen neu eingrichten müssen. Wenn das ein Hobby ist - ok ... wenn man aber einfach nur das Licht im Flur einschalten will, dann kann das ganz schön nerven. Das kenne ich aus eigener Erfahrung nur zu gut.

Die konsolidierte Steuerung der smarten Endgeräte ist ein wichtiger Aspekt. Ein Echo ermöglicht die Steuerung über Sprache, aber nur für die unterstützten Technologien. Aber immerhin unterstützen viele Smart-Anbieter Echo und somit ist man damit schon mal auf einem guten Web und schützt seine Investitionen. Sehr interessant ist hier auch [Homee](https://hom.ee/), die on-top-of Funkstandards eine einheitliche Steuerungs-App anbietet, so daß Routinen "programmiert" werden können.

---

## Use-Cases

Zu viel potentielle Intelligenz in den Systemen macht leider auch Probleme. Ich habe mal in einem voll verglasten Bankenhochhaus gearbeitet - sehr stylisch. Als dann die Sonne reinschen haben wir die Außenrollos runtergemacht, um noch etwas auf unseren Bildschirmen zu erkennen. Als der Wind eine gewisse Grenze überschritt, gingen die Rollos automatisch wieder hoch - niemand hat noch was auf dem Bildschirm erkannt. Die Leute haben dann die Fenster abgeklebt - sah von außen nicht mehr toll aus, man hat nicht mehr rausschauen können und die Klebestreifen hat auch keiner mehr abgemacht. Das tolle Büro mit Ausblick ist komplett verkümmert und die Leute wünschten sich in ihren abgedunkelten Keller zurück ;-)

Ehrlich gesagt habe ich auch meine Vorbehalte hier ... ich muß meinen leicht erreichbaren mechanischen Lichtschalter nicht über mein Handy oder die Alexa steuern. Ich habe schon genug Technik, die gelegentlich nicht funktioniert und bei dem mich das Bugfixing Stunden kostet.

Ich möchte meine Haustüre auch nicht per WLAN öffnen können. Wenn ich das kann, dann vielleicht auch die seltsame Gestalt, die vor meinem Grundstück seit Stunden umherschleicht. Ich als Softwareentwickler habe 2012 einen Fingerabdrucksensor zur Öffnung meiner Haustüre unter keinen Umstaänden haben wollen ... und ich will ihn auch 2020 immer noch nicht - aus Sicherheitsgründen.

Allerdings gibt es sicherlich auch nützliche Anwendungen ... wenn man beispielsweise 5 Schalter drücken muß, um am Beamer ein Film über Fire TV zu schauen. Man wird ja auch älter ... und dann ist es schon ganz hilfreich, wenn man sich die "Arbeit" erleichtern kann. Allerdings muß das dann auch PERFEKT funktionieren - wenn schon "intelligent", dann aber auch idiotensicher und tatsächlich die teilweise sehr persönlichen Vorlieben berücksichtigen ;-)

### Standby Strom

Viele Geräte verbrauchen im Standby-Strom. Kann man alle automatisch mit einer ferngesteuerten Steckdose gemeinsam zeitgesteuert abschalten, dann kann man hier vielleicht Strom sparen. Man sollte aber auch nicht vergessen, daß die Anschaffung eines solchen Systems Geld kostet und die Wartung Zeit in Anspruch nimmt. Und man sollte auch nicht vergessen, daß die fernsteuernde Controller auch Strom verbraucht. Diese Rechnung bleibt leider häufig aus und das ganze wird schöngerechnet, weil man es eben einfach haben will.

### Heizungs-Steuerung

Ich habe bereits eine Heizungssteuerung - zumindest im Wohnzimmer und im Bad, die den Heizkörper zeitgesteuert und temperaturabhängig steuert. Im Wohnzimmer würde ich aber gelegentlich - wenn ich besonders früh zu Bett gehe, das Thermostat manuell für diesen Tag runterregeln. Klar, kann ich auch manuell machen, soch leider vergesse ich das häufig und wenn ich dann schon im Bett liege, gehe ich dann doch nicht zwei Stockwerke runter und dann wieder hoch. Und das wird im Alter sicher nicht besser. Da wäre es schön, ich könnte das Thermostat übers Handy runterregulieren.

Ein [Netatmo-Heizkörper-Thermostat](https://www.homeandsmart.de/netatmo-smarte-heizkoerperthermostate-sprachsteuerung-homekit) könnte hier helfen.

### Fazit

Ich gebe zu, daß ich derzeit noch keine ganz klaren Use-Cases habe - ich will einfach mal damit rumspielen, um zu erfahren, ob das wirklich alles Sinn macht. Deshalb habe ich mir im Haus ein Smart-Home-Zimmer eingerichtet, in dem ich rumspielen kann.

Man darf dabei allerdings nicht vergessen, daß dieser Hype teilweise auch recht teuer ist und sich die Kosten nicht immer rechnen.

---

## Relevante Aspekte

* http://www.pc-magazin.de/ratgeber/funkprotokolle-ueberblick-rwe-zwave-homematic-1530051.html

Im Haus muß es i. a. ohne Kabel gehen (zumindest wenn man ein Haus nachrüsten möchte) ... deshalb sind Funkprotokolle hier besonders wichtig. Die Endgeräte sind

* Sensoren
* Motoren

und die sprechen dann den ein oder anderen Standard.

### Endgeräte-Verfügbarkeit

Am besten entscheidet man sich für einen offenen Standard, der weit verbreitet ist. Ärgerlich, wenn man nach Jahren einen Sensor austauschen will und es für den Funkstandard keine Hardware mehr gibt.

### Frequenzbereich

Je niederfrequenter (434 MHz oder 868 MHz) das Protokoll ist desto höher die Reichweite und Mauerdurchlässigkeit.

### Lizenzkosten

Lizenzkosten können eine Rolle spielen - bei 434 MHz oder 868 MHz fallen sie beispielsweise nicht an.

Energieaufnahme

Die notwendige Energieaufnahme ist in diesem Bereich außerdem ein wichtiger Aspekt.

### Störungsanfälligkeit

In manchen Frequenzbändern sind sehr viele Geräte (WLAN 2,4 GHz) unterwegs und es kommt dementsprechend häufig zu Störungen.

### Sicherheit

Hackerangriffe (z. B. Tür kann von Unberechtigten geöffnet werden) sind immer ein Thema.

---

## Anbindungsvarianten

### WLAN

* spielt in diesem Bereich keine große Rolle ... dennoch schwenken immer mehr Hersteller darauf um, um den Einstieg in Smart Home zu erleichtern (jeder hat zuhause WLAN)
  * dennoch ... im Bereich Homeautomatisierung braucht niemand die Datenmengen, auf die WLAN ausgelegt ist

### Bluetooth

* [Einführung](https://www.homeandsmart.de/bluetooth-low-energy-smart-home)
* aufgrund von Bluetooth Low Energy wird dies immer beliebter
* die Reichweite ist allerdings stark begrenzt (10m)

### Z-Wave

* Standard G.9959
* Allianz aus 160 Herstellern
* 600 zertifizierte Produkte
* 868 MHz (Europa), 908 MHz (USA) und 2,4 GHz (weltweit)
* Netzwerktopologie mit Zwischenknoten - Knoten A kann mit Knoten C über Knoten B kommunizieren ... obwohl Knoten A und C nicht direkt kommunizieren können
* Endgeräte recht günstig über Versandhandel zu beziehen
* auf Batteriebetrieb ausgelegt

### ZigBee

* [guter Überblick](https://www.homeandsmart.de/zigbee-funkprotokoll-hausautomation)

* Standard IEEE 802.15.4
  * allerdings gibt es einige Sonderimplementierungen, so daß die Kompatibilität nicht immer gewährleistet ist ... TOLLER Standard
  * Zigbee 3.0 hat das wohl verbessert
* Allianz aus 250 Herstellern
* Leistungsaufnahme sehr gering - für den Batteriebetrieb geeignet und dadurch über Jahre wartungsfrei (verbessert durch den sog. Schalfmodus)
* 868 MHz (Europa), 915 MHz (USA) und 2,4 GHz (weltweit)
* gilt als nicht besonders sicher
* Netzwerktopologie mit Zwischenknoten - Knoten A kann mit Knoten C über Knoten B kommunizieren ... obwohl Knoten A und C nicht direkt kommunizieren können

### HomeMatic

* Firma eQ-3
* proprietäres Protokoll
* viele Endgeräte
* gute Sicherheit über AES-128-Verschlüsselung
* geringer Stromverbrauch
* auf Batteriebetrieb ausgelegt
* es gibt Aktoren, die ihre Funktion auch autonom (ohne einen Trigger von außen) ausführen können
* Endgeräte recht günstig über Versandhandel zu beziehen
* große Internet-Community

### Enocean

* [Einführung](https://www.homeandsmart.de/enocean-funkstandard-mit-autarker-energieversorgung)
* wenig energie notwendig ... selbst die wird aus der Umgebung gewonnen, z. B. durch  - klingt interessant

### RWE SmartHome

* in Kooperation mit eQ-3 (entwickelt die Endgeräte)
* hohe Sicherheit (AES-128 Verschlüsselung)
* Endgeräte recht günstig über Versandhandel zu beziehen
* viele Engeräte - im Vergleich zu ZigBee und Z-Wave aber eher wenig

### KNX-RF

* drahtgebunden ... scheidet für eine Nachrüstung aus

### DECT

* [Einführung](https://www.homeandsmart.de/dect-ule-smart-home-hausautomation)
* im Frequenzband 1,9 GHz
  * wenig genutzt => weitestgehend störungsfrei
* vergleichsweise hohe Energieaufnahme
* Fritzbox unterstützt diesen Ansatz (Funkschalter, Dimmer)
* kein Standard => kaum Endgeräte vorhanden bzw. trotz gleichem Namen nicht kompatibel zueinander
  * kein Investitionsschutz
* große Reichweite (bis zu 300m)

---

## Programmierschnittstellen

> Jetzt wirds schon wieder recht aufwendig ... mit entsprechendem Zeitaufwand kann man sicherlich ganz tolle Lösungen implementieren, die auch tatsächlich besser funktionieren können als die Standardlösungen von Anbietern, die dafür 200 Euro verlangen. Vergeßt bitte nicht den zeitlichen Aufwand, den man treiben muß, wenn man alles selbst betreuen will oder - wenn es dann tatsächlich in real Life genutzt wird - MUSS. Dann funktioniert nämlich grad die Steuerung der Rollos nicht, weil eine Library upgedated wurde. Es dauert Stunden bis man das rausgefunden hat ... während die Familie motzt, weil sie nicht zum Garten hinaus kommt. Beim nächsten mal verzichtet man dann auf das Update auf die neue Version und das System rottet so langsam vor sich hin. Irgendwann ist man Jahre hintendran und ein notwendiges Upgrade ist mit einer tagelangen Neuinstallation verbunden. Das kann Spaß machen, wenn man Lust drauf hat - hat man aber gerade ganz andere Projekte oder Sorgen, dann ist das echt Stress. Ich bin hier schon gelegentlich auf die Nase gefallen und bin deshalb weniger euphorisch ... Ein Spielprojekt ist das eine ... eine Lösung, die immer funktionieren muß, bedarf kontinuierlicher Pflege und Automatisierung (auch Testautomatiserung). Schnell wird Spaß zur Qual. Da sind betreute Lösungen, die vielleicht nicht 100% passen und zudem auch noch Geld kosten, die kostengünstigere Alternative. Vielleicht muß man sich da auch einfach die Kosten-Nutzen-Frage stellen. Ist mir die automatische Steuerung meiner 3 Steckdosen diesen Aufwand wert?

Programmierschnittstellen werden eingesetzt, um

* Geräte mit Controllern wie Echo zur Sprachsteuerung zu koppeln
* Daten von Sensoren abzufragen und über If-that-then-that (IFTTT) Regeln Aktionen über Geräte auszulösen

### Homee

* [Homee](https://www.homeandsmart.de/homee-smart-home-loesung)
* [schöne Motivation](https://www.youtube.com/watch?v=nDtMJB6OzCA)
* spricht mit Alexa
* modular aufgebaut ... sichtbar durch aufeinandergesteckte Würfel, wobei jeder Würfel mit einem Set an Features kommt (Basis-WLAN, Z-Wave, Zigbee, ...)
* Steuerung/Programmierung über Mobile App

### Home Assistant

* [Homepage](https://www.home-assistant.io/)
* Python basierte Lösung

### Eclipse SmartHome

Hierbei handelt es sich um ein Java-OSGI-basiertes Framework zur Integration Funkstandards/Hersteller/Endgeräte. Lösungen (u. a. OpenHAB) verwenden Eclipse SmartHome als Basis.

REST API

### OpenHAB

Lösung basierend auf [Eclipse SmartHome](https://eclipse.org/smarthome/) - Java-basiert.

#### Unterstützte Funkstandards

* Z-Wave
* HomeMatic

#### OpenHAB-Server@Raspberry

* http://docs.openhab.org/installation/rasppi.html
* https://github.com/openhab/openhabian

OpenHAB bringt eine eigene Rasbian Distribution namens *OpenHABian*mit.

#### OpenHAB-Server@Synology

* https://github.com/openhab/openhab-syno-spk

OpenHAB läuft auch auf einem Synology.

#### OpenHAB-Server@Docker

* https://github.com/openhab/openhab-docker
* http://docs.openhab.org/installation/docker.html#obtaining-the-official-image-from-dockerhub

#### OpenHAB-Client for iOS

* https://github.com/openhab/openhab.ios

Basierend auf der REST-API.

#### OpenHAB-Client for Windows

* https://github.com/openhab/openhab.windows

Basierend auf der REST-API.

---

## Amazon Echo

Amazon Echo ist EIN bietet (wie Google Home, Apple ...) eine komfortable Möglichkeit, um Smart-Home-Geräte per Sprache zu steuern und komplexere Routinen zu "programmieren". Letztlich bietet Echo aber zunächst man nur die Sprachintegration ... eine Steuerung der Geräte muß in vielen Fällen über sog. WLAN-Bridges erfolgen, die per WLAN mit dem Echo gekoppelt sind. Die Bridge stellt also per WLAN die Verbidnung zum Echo her und per Funkprotokoll die Verbindung zum Endgerät. Einzige Bedingung ist, daß die Bridge zu Echo kompatibel ist.

Amazon Echo Plus 2020 enthält bereits eine Zigbee-Bridge und kann somit out-of-the-box zur Steuerung verwendet werden.

> allerdings ist der Echo Plus im Vergleich zur Hue Bridge in der Funktionsvielfalt leicht eingeschränkt

Das war mein Einstieg in die Smart-Home-Welt ... Echo Plus + Hue Bluetooth war für 60 Euro ein echtes Schnäppchen.

Da Zigbee allerdings kein richtiger Standard ist, sondern viele Inkompatibilitäten hat, sind [Ende 2020 nur relativ wenige Endgeräte Amazon-Echo-Plus-kompatibel](https://www.haus.de/smart-home/amazon-echo-als-smart-home-zentrale). Die Lichtsysteme von Hue, Osram Lightify, Ikea Tradfri, Nanoleaf, Innr gehören dazu ... aber das war es dann auch schon ... klingt eher nach einer enttäuschenden Marketingmaßnahme.

Die Phillips Hue Bridge (40 Euro) ist zu deutlich mehr Zigbee-Endgeräten kompatibel.

---

## Lampen

Das schöne der meisten smarten Lampen ist die eingebaute Dimmer-Funktion und bei farbigen Lampen die Auswahl aus 16,7 Millionen Farben.

### Phillips Hue Zigbee

* basiert auf dem Zigbee-Funk-Protokoll ... man benötigt eine ZigBee-Bridge, um per App über WLAN Befehle an die ZigBee-Brdige zu übermitteln, die ihrerseits dann Funk-Signale (kein WLAN) an die ZigBee-Engeräte zu senden. Amazon Echo kann mit der ZigBee-Bridge gekoppelt werden, um die ZigBee-Geräte per Sprache zu steuern.
  * läßt sich mit der *Hue App* (ACHTUNG: Unterschied zu *Hue Bluetooth App*) steuern
  * Reichweite 30-100m
    * jedes einzelne Gerät dient als Repeater des Signals (Mesh-Netzwerk)
  * 50 Geräte an einer Bridge möglich
* für eine Fernsteuerung außerhalb des eigenen Netzes benötigt man einen Hue-Internet-Account
  * aus Sicherheitsgründen würde ich auf diesem Luxus grundsätzlich verzichten ... es gibt nicht unbedingt viele sinnvolle Use-Cases aus meiner Sicht

### Phillips Hue Bluetooth

* seit Oktober 2019 auf dem Markt (nach der ZigBee Version)
* basiert auf Bluetooth (Low Energy) ... es wird also keine ZigBee-Bridge benötigt
  * läßt sich mit der *Hue Bluetooth App* (ACHTUNG: Unterschied zu *Hue App*) steuern
* seit der 3. Generation der Lampen sind sowohl Bluetooth also auch ZigBee in einer Lampe verbaut ... sie lassen sich also auch per ZigBee-Bridge steuern
* funktionell ist die Steuerung per Bluetooth allerdings eingeschränkt
  * beschränkt auf 10 Lampen
  * Kombination mit weiterem Zubehör eingeschränkt
    * z. B. Hue Sync funktioniert nicht mit Bluetooth
  * Bluetooth-Reichweite ist auf 9m eingeschränkt
    * Steuerung von unterwegs nicht möglich

### Innr

* kompatibel mit Hue aber deutlich günstiger ... funktioniert also auch mit der Hue App

---

