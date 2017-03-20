# Networking

----

# Physische Devices
Ein Computer kommt i. a. mit mehreren physischen Netzwerkdevices daher (`ifconfig`):

* Kabel
* WLAN
* Loopback-Device

----

# Logische Devices
Verwendet man Tools wie Docker, VirtualBox, ... dann wird man nicht nur o. a. drei Devices sehen, sondern etliche mehr. Das sind sog. virtuelle Devices, die über Regeln (z. B. Linux: IPTables) auf die physischen Devices abgebildet werden oder - wie beispielsweise einem Host-Only-Netzwerk in Virtualbox - rein softwaretechnisch genutzt werden.

Die Software legt diese bei der Installation oder zur Laufzeit an, um die gewünschte  Netzwerkkonfiguration abzubilden. Virtualbox kennt beispielsweise 5 verschiedene Arten wie das Image in die Netzwerkinfrastruktur des Hosts integriert wird:

* not attached
* NAT
* NAT Service
* Bridge
* Internal
* Host-Only

Für jede dieser Arten erfolgt auf dem Host eine andere Konfiguration. Glücklicherweise macht das die Software i. a. auf Basis relativ abstrakter/komfortabler GUIs. Die darunterliegenden Internas muß man nur kennen, wenn es Probleme gibt ;-)

