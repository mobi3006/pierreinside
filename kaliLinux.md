# Kali Linux
Hierbei handelt es sich um eine Linux-Distribution, die viele Security-Tools bzw. Hacking-Tools mitbringt (je nachdem wie man es einsetzen will).

Kali Linux basiert auf den beiden Tools

* Metasploit
* Armitage

Die sind dort schon installiert und Kali Linux packt noch eine aufgeräumte Oberfläche dazu.

# Installation
## VirtualBox
* https://www.kali.org/downloads/

Kali-Linux stellt ein ISO-Image zur Verfügung, das leicht in einem VirtualBox-Image installiert werden kann.

## Docker Installation
* https://hub.docker.com/r/kalilinux/kali-linux-docker/

Für Kali Linux gibt es auch ein Docker Image, so daß man es schnell und schlank in einem Docker Container starten kann:

```
docker pull kalilinux/kali-linux-docker
docker run -t -i kalilinux/kali-linux-docker /bin/bash
root@0134d62d2319:/# apt-get install metasploit
```
