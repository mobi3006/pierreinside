# Vagrant Box bauen
* https://blog.engineyard.com/2014/building-a-vagrant-box

Die Nutzung vorhandener Vagrant Boxes ist manchmal nicht genug ... stattdessen werden eigene Boxen gebraucht, die für einen bestimmten Einsatz bereits vorkonfiguriert sind (beispielsweise in eine Unternehmens-Infrastruktur eingebettet ist oder eine Entwicklungsumgebung für mitbringt). 

Ich habe das bisher nur für VirtualBox als Virtualisierungsprovider genutzt.

# Provider Virtualbox
## Image vorbereiten
Zunächst wird das Image (in Virtualbox laufend) so vorbereitet wie man es gerne from-scratch hätte (User, Software, Filesystem, Netzwerk, ...).

Zum Schluß sollte man das Image noch ein wenig für die Paketierung optimieren (damit das Box-Paket später kleiner ist):

* `sudo apt-get autoremove` (distributionsabhängig)
* `sudo apt-get clean` (distributionsabhängig)

## Box erzeugen
Hier zu wird das Kommando `vagrant package` benutzt.

