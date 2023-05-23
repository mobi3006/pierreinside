# Netzwerke in Ubuntu

> Leider verwendet jede Distribution (vielleicht sogar in jeder Version) wieder eigene Ansätze, eigene Tools, eigene Konfigurationsdateien. Zudem gibt es bei jeder Distribution wieder verschiedene Lösungswege. Das macht die Sache nicht gerade einfacher :-( ... insbesondere für den Gelegenheitsanwender ist das schwierig, denn wenn das Netzwerk einmal läuft muss man sich damit nicht mehr rumschlagen - das Wissen ist also schnell wieder ausgeleitet. 

* [How to restart network on Ubuntu 20.04 LTS Focal Fossa](https://linuxconfig.org/how-to-restart-network-on-ubuntu-20-04-lts-focal-fossa)

Ubuntu verwendet per Default in einem Ubuntu-Server

* [Netplan Netzwerk-Konfigurations-Abstraktionsschicht](https://wiki.ubuntuusers.de/Netplan/)
* und darunter als Netzwerkmanager
  * entweder [`systemd-networkd`](https://wiki.ubuntuusers.de/systemd/networkd/)
    * default bei einem Ubuntu Server
  * oder `network-manager`
    * default bei einem Ubuntu Desktop

Als Alternative zu `netplan` kann man [`/etc/network/interfaces`](https://wiki.ubuntuusers.de/interfaces/) verwenden ... hierzu muss man [netplan deaktivieren](https://wiki.ubuntuusers.de/Netplan/Deaktivieren/).

---

## netplan

Hierbei handelt es sich um eine sog. Netzwerk-Konfigurations-Abstraktionsschicht

systemd-networkd und network-manager bilden das Backend für [`netplan`](https://wiki.ubuntuusers.de/Netplan/) ... in der Konfiguration (`/etc/netplan/foo.yaml`) wählt man

* entweder `renderer: NetworkManager`
* oder `renderer: networkd`

---

## systemd-networkd

* [`systemd-networkd`](https://wiki.ubuntuusers.de/systemd/networkd/)

Neben `systemd-networkd` wird auch noch der `systemd-resolved` DNS-Dienst gestartet, der auf der IP-Adresse `127.0.0.53` und Port 53 lauscht. Er ist für die Namensauflösung zuständig.

> man kann sich aber auch für andere DNS-Resolver bzw. -Server wie [dnsmqsq](https://wiki.ubuntuusers.de/Dnsmasq/) oder [bind](https://wiki.ubuntuusers.de/DNS-Server_Bind/) entscheiden

Auf meinem Ubuntu 18.04 LTS hat mich der `systemd-resolved` immer geärgert, weil das resolving immer mal wieder nicht funktionierte. Ich habe keine Lösung dafür gefunden und verwende seitdem dnsmasq.

### Kommandos

* `networkctl list`

### systemd-networkd - Dummy-Interface einrichten

- [askubuntu - How to create a persistent dummy network interface](https://askubuntu.com/questions/1050353/ubuntu-18-04-how-to-create-a-persistent-dummy-network-interface)

Ich habe das mal verwendet, um an die IP-Adresse eines Dummy-Interfaces (`169.254.255.254`) meinen dnsmasq zu binden und die Docker Container damit auszustatten. Hierzu habe ich den Docker Daemon folgendermaßen konfiguriert (`/etc/docker/daemon.json`):

```
{
    "dns": ["169.254.255.254"]
}
```

---

## network-manager

### Wechsel von networkd zu network-manager

- disable und stop von `systemd-networkd` durch

   ```bash
   systemctl disable systemd-networkd.service
   systemctl stop systemd-networkd.service
   ```

- disable und stop von `systemd-resolved` durch ... wenn dadurch der Port 53 nicht freigegeben wird hilf vielleicht [dieser Link](https://www.linuxuprising.com/2020/07/ubuntu-how-to-free-up-port-53-used-by.html)

   ```bash
   systemctl disable systemd-resolved.service
   systemctl stop systemd-resolved.service
   ```

- install `network-manager` (`apt install network-manager`)
- configure `netplan` to use `NetworkManager`
