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

### Gartenbeleuchtung

Will man im Garten dimmbare und farbige Lampen verbauen, so kommt man an Smart-Home Zigbee-Lampen fast nicht vorbei. Es gibt auch andere unterstützte Protokolle, doch Zigbee scheint die meiste Unterstützung zu haben. Die Wahrscheinlichkeit einer langfristigen Unterstützung ist einfach höher als bei einer weniger beliebten Lösung oder gar bei einer propritären Lösung eines Herstellers.

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
  * allerdings gibt es einige Sonderimplementierungen (sog. Profile wie ZLL, ZHA), so daß die Kompatibilität nicht immer gewährleistet ist ... TOLLER Standard. Ikea-Lampen Tradfri sprechen ZHA, doch die Hue Bridge kann nur ZLL.
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

## Amazon Echo - die Sprach-Steuerzentrale

Amazon Echo bietet (wie Google Home, Apple ...) eine komfortable Möglichkeit, um Smart-Home-Geräte per Sprache zu steuern und komplexere Routinen zu "programmieren".

> Im Vergleich zu *Home Assistant* sind die Möglichkeiten eingeschränkt, aber dafür muß man auch nur einen Bruchteil der Zeit investieren.

Letztlich bietet Echo aber zunächst mal nur die Sprachintegration ... eine Steuerung der Geräte muß in vielen Fällen über sog. WLAN-Bridges erfolgen, die per WLAN mit dem Echo gekoppelt sind. Die Bridge stellt also per WLAN die Verbidnung zum Echo her und per Funkprotokoll die Verbindung zum Endgerät. Einzige Bedingung ist, daß die Bridge zu Echo kompatibel ist.

Amazon Echo Plus 2020 enthält bereits eine Zigbee-Bridge und kann somit out-of-the-box zur Steuerung verwendet werden.

> allerdings ist der Echo Plus im Vergleich zur Hue Bridge in der Funktionsvielfalt leicht eingeschränkt

Das war mein Einstieg in die Smart-Home-Welt ... Echo Plus + Hue Bluetooth war für 60 Euro ein echtes Schnäppchen.

Da Zigbee allerdings kein richtiger Standard ist, sondern viele Inkompatibilitäten hat, sind [Ende 2020 nur relativ wenige Endgeräte Amazon-Echo-Plus-kompatibel](https://www.haus.de/smart-home/amazon-echo-als-smart-home-zentrale). Die Lichtsysteme von Hue, Osram Lightify, Ikea Tradfri, Nanoleaf, Innr gehören dazu ... aber das war es dann auch schon ... klingt eher nach einer enttäuschenden Marketingmaßnahme.

Die Phillips Hue Bridge (40 Euro) ist zu deutlich mehr Zigbee-Endgeräten kompatibel. Für den Einstieg reicht das aber erstmal - und war bei meiner Alexa "kostenlos" dabei.

### Integration neuer Geräte

Ich verwende die Hue App, um meine Zigbee-Geräte zu steuern. Es geht zwar auch mit der Alexa App, aber nur sehr eingeschränkt ... bei den RGB-Lampen kann ich nur einige vordefinierte Farben auswählen - die Hue App bietet alle Farben an. Zudem können Timer 

Sowohl Alexa-App als auch Hue-App bieten Gruppen bzw. Szenen an, mit denen sich Geräte in einer Gruppe zusammenfassen lassen und mit einem Knopfdruck ein-/ausgeschaltet werden.

Verwendet man nicht die Alexa-App zur Steuerung, will aber dennoch die Alexa-Sprachsteuerung verwenden, so muß müssen die Geräte und Szenen (z. B. "Terrasse an") sowohl in der Hue App als auch in der Alexa-App sichtbar bzw. gepflegt werden.

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
* [Touch Portal](touchPortal.md) liefert eine Möglichkeit, seine eigene Oberfläche zu designen

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

Das war mein Einstieg in die Smart-Home-Welt ... Echo Plus + Hue Bluetooth war für 60 Euro ein echtes Schnäppchen.

### Innr

* kompatibel mit Hue aber deutlich günstiger ... funktioniert also auch mit der Hue App

### Paulmann Plug & Shine

Ich habe für mich das Paulmann Plug & Shine System entdeckt, das auf 24V Basis funktioniert - sicher und komfortabel. Die Kabel müssen nicht 60cm verbuddelt werden und das System läßt sich aufgrund des (proprietären) Bussystems leicht erweitern. Außerdem steht eine Vielzahl verschiedenener Lampen zur Verfügung, so daß jeder etwas finden sollte. Mit jedem Zigbee 3.0 kompatiblen Controller lassen sich die Lampen steuern. Nicht alle Lampen haben eine Zigbee-Unterstützung (zumeist aber die dimmbaren und farbigen), die in den Lampen verbaut ist. Es gibt auch Zigbee-Controller, die sich im Bus zwischenschalten lassen, um alle nachfolgenden Lampen einheitlich steuern zu können (gibt es auch mit zwischengeschaltetem Dimmer ... vielleicht ist dies aber sogar teurer als Lampen mit integriertem Zigbee-Controller).

Die Lampen sind im Paulmann-Shop deutlich teurer als beim Wiederverkäufer (30-50%).

Die RGB-Farben sind bei 3,5 Watt Lampen sehr dunkel. Vor einer weißen Wand bekommen man schon recht wenig raus ... die Beleuchtung einer Pflanze kann man vergessen. Die weiße Beleuchtung der RGB-Lampen ist aber gut. Ich habe mich aus diesem Grund entschieden einfache weiße Lampen im hinteren Teil meines Gartens zu verwenden. Diese haben allerdings keinen Zigbee Controller integriert, weshalb ich mich entschlossen habe einen Paulmann Plug & Shine Zigbee Controller ins System zu integrieren.

Der Paulmann Plug & Shine Zigbee Controller wurde aber von der Hue App nicht automatisch gefunden. In einem [Forum](https://community.hom.ee/t/paulmann-plug-shine-zigbeecontroller-ip68-fuer-gartenbeleuchtung/21304/13) habe ich gelesen, daß fünfmaliges ein- (für mind. 3 Sekunden) und ausschalten zu einem Reset führt. Leider hat das auch nicht geklappt.

---

## Steckdosen

Ich habe einen alten (hässlichen) Powermanager, der derzeit noch auf meinem Schreibtisch steht und mich stört. Mittlerweile brauche ich auch gar keine 7 verschiedenen Gerätegruppen mehr. Ich komme mit 1-3 gut aus.

Ich habe noch ein paar 15 Jahre alte Funksteckdosen, die mit einem propritären Handsender bedient werden. Leider funktioniert der Funksender nicht so zuverlässig ... manchmal reagiert es gar nicht, manchmal nur nach nur nachdem ich meine Position verändere und manchmal klappt es auch mehrfach hintereinander. Kurz: ich bin genervt.

### Ledvance Smart+Plug

Ledvance bietet Produkte basierend aif Wifi, Bluetooth und Zigbee. Nachdem ich nun Hue Bluetooth erfolgreich an meinen Echo Plus koppeln konnte und das einwandfrei und zuverlässig funktioniert, habe ich mich nun für eine Zigbee-Steckdose entschieden.

Die Erstinbetriebnahme gestaltete sich seltsam, aber nicht problematisch - evtl. weil es das erste mal war. Nach dem Einstecken forderte ich "Alexa, suche Geräte", aber es wurde kein neues Gerät gefunden. Ich fand auch keinen Pairing-Schalter an der Steckdose ... also versuchte ich es mit dem Power-Schalter, den ich länger drückte und dann erneut "Alexa, suche Geräte". Kein Erfolg. Nach Abstöpseln und erneutem Anstöpseln, drückte ich den Power-Button nur 5 Sekunden und erneut "Alexa, suche Geräte" ... diesmal mit Erfolg. Alexa meldete, "Steckdose 1 gefunden".

> Beim nächsten mal werde ich erst die Suche starten und dann die Steckdose einstecken. Übrigens: 10 Sekunden auf den Power-Button drücken führt zu einem Reset.

In der Alexa-App am iPhone konnte ich die Steckdose nun auch sehen und ihr einen anderen Namen "Arbeitsplatz" geben. Sogleich wollte ich die Steckdose mit einer Routine verknüpfen, doch die Steckdose war innerhalb der Routinen als Gerät nicht aufzufinden. Also versuchte ich einfach mal "Alexa, Arbeitsplatz an" - ERFOLG.

Noch habe ich nicht herausgefunden, warum ich die Smart+Plug nicht in Routinen verwenden kann. Vielleicht brauche ich noch einen Alexa-Skill?
