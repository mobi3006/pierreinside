# Hausautomatisierung
Der Markt der Hausautomatisierung ist sehr fragmentiert und das macht die langfristige Entscheidung für eine Ecosystem so schwierig. Es ist sehr viel Bewegung im Markt und die Gefahr aufs falsche Pferd zu setzen groß.

## Funkprotokolle
* http://www.pc-magazin.de/ratgeber/funkprotokolle-ueberblick-rwe-zwave-homematic-1530051.html

Im Haus muß es i. a. ohne Kabel gehen (zumindest wenn man ein Haus nachrüsten möchte) ... deshalb sind Funkprotokolle hier besonders wichtig. Die Endgeräte sind

* Sensoren
* Motoren

und die sprechen dann den ein oder anderen Standard. 

**Endgeräte-Verfügbarkeit:** 

Am besten entscheidet man sich für einen offenen Standard, der weit verbreitet ist. Ärgerlich, wenn man nach Jahren einen Sensor austauschen will und es für den Funkstandard keine Hardware mehr gibt.

**Frequenzbereich:**

Je niederfrequenter (434 MHz oder 868 MHz) das Protokoll ist desto höher die Reichweite und Mauerdurchlässigkeit. 

**Lizenzkosten:**

Lizenzkosten können eine Rolle spielen - bei 434 MHz oder 868 MHz fallen sie beispielsweise nicht an. 

**Energieaufnahme:**

Die notwendige Energieaufnahme ist in diesem Bereich außerdem ein wichtiger Aspekt.

**Störungen:**

In manchen Frequenzbändern sind sehr viele Geräte (WLAN 2,4 GHz) unterwegs und es kommt dementsprechend häufig zu Störungen.

**Sicherheit:**

Hackerangriffe (z. B. Tür kann von Unberechtigten geöffnet werden) sind immer ein Thema.

### WLAN
* spielt in diesem Bereich keine Rolle - im Bereich Homeautomatisierung braucht niemand die Datenmengen, auf die WLAN ausgelegt ist
* hier gibt es kaum Endgeräte

### Bluetooth

### Z-Wave
* Standard G.9959 
* Allianz aus 160 Herstellern
* 600 zertifizierte Produkte
* 868 MHz (Europa), 908 MHz (USA) und 2,4 GHz (weltweit)
* Netzwerktopologie mit Zwischenknoten - Knoten A kann mit Knoten C über Knoten B kommunizieren ... obwohl Knoten A und C nicht direkt kommunizieren können
* Endgeräte recht günstig über Versandhandel zu beziehen
* auf Batteriebetrieb ausgelegt

### ZigBee
* Standard IEEE 802.15.4
  * allerdings gibt es einige Sonderimplementierungen, so daß die Kompatibilität nicht immer gewährleistet ist
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
* es gibt Aktoren, die ihre Funktion auch automon (ohne einen Trigger von außen) ausführen können
* Endgeräte recht günstig über Versandhandel zu beziehen
* große Internet-Community

### RWE SmartHome
* in Kooperation mit eQ-3 (entwickelt die Endgeräte)
* hohe Sicherheit (AES-128 Verschlüsselung)
* Endgeräte recht günstig über Versandhandel zu beziehen
* viele Engeräte - im Vergleich zu ZigBee und Z-Wave aber eher wenig
 
### KNX-RF
* drahtgebunden ... scheidet für eine Nachrüstung aus

### DECT
* im Frequenzband 1,9 GHz - vergleichsweise hohe Energieaufnahme
* Fritzbox unterstützt diesen Ansatz (Funkschalter, Dimmer)
* kaum Endgeräte vorhanden

## Eclipse SmartHome
Hierbei handelt es sich um ein Java-OSGI-basiertes Framework zur Integration Funkstandards/Hersteller/Endgeräte. Lösungen (u. a. OpenHAB) verwenden Eclipse SmartHome als Basis.

REST API

## OpenHAB
Lösung basierend auf [Eclipse SmartHome](https://eclipse.org/smarthome/) - Java-basiert.

### Unterstützte Funkstandards
* Z-Wave
* HomeMatic

### OpenHAB-Server@Raspberry
* http://docs.openhab.org/installation/rasppi.html
* https://github.com/openhab/openhabian

OpenHAB bringt eine eigene Rasbian Distribution namens *OpenHABian*mit.

### OpenHAB-Server@Synology
* https://github.com/openhab/openhab-syno-spk

OpenHAB läuft auch auf einem Synology.

### OpenHAB-Server@Docker
* https://github.com/openhab/openhab-docker
* http://docs.openhab.org/installation/docker.html#obtaining-the-official-image-from-dockerhub

### OpenHAB-Client for iOS
* https://github.com/openhab/openhab.ios

Basierend auf der REST-API.

### OpenHAB-Client for Windows
* https://github.com/openhab/openhab.windows

Basierend auf der REST-API.


