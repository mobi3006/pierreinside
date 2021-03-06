# docker network

* https://entwickler.de/online/development/docker-netzwerk-container-microservices-126443.html
* http://blog.sequenceiq.com/blog/2014/08/12/docker-networking/
* sehr guter Beitrag: http://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach?rq=1
* http://www.linuxjournal.com/content/concerning-containers-connections-docker-networking

## Getting Started

Ein Container kann ein Netzwerk konfiguriert haben - muß aber nicht. Man kann auch nachträglich ein Netzwerk erzeugen (oder ein bestehendes verwenden) und einkonfigurieren.

Beim Start eines Containers kann das zu verwendende Netzwerk per ``--network=blablubb`` angegeben werden:

```bash
docker run --network=isolated_nw -itd --name=container3 busybox
```

Alle Container des gleichen Netzwerks können automatisch miteinander kommunizieren.

Je nach Netzwerkkonfiguration wird ein neues Netzwerkdevice erzeugt, das man per `sudo ifconfig` sehen kann:

```bash
╰─➤  sudo ifconfig
br-37a31f7f9696: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.18.0.1  netmask 255.255.0.0  broadcast 0.0.0.0
        inet6 fe80::99:994ff:fe1a:4a71  prefixlen 64  scopeid 0x20<link>
        ether 99:42:94:1a:4a:71  txqueuelen 0  (Ethernet)
        RX packets 800513  bytes 173457174 (165.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 728155  bytes 294072701 (280.4 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Auf dem Docker Host werden IpTables-Einträge für die Kommunikation mit den Containern angelegt - siehe `iptables -t nat -L`.

## Docker Host Konfiguration

Unter Ubuntu findet man die `/etc/default/docker`, in der wichtige Konfigurationsparameter für den Docker Daemon hinterlegt sind. Folgende Einstellungen sind netzwerktechnisch besonders interessant:

```properties
DOCKER_OPTS="--dns 8.8.8.8 --dns 8.8.4.4"
DOCKER_NETWORK_OPTIONS=-ip=0.0.0.0
```

## Netzwerktypen

Docker bringt Ünterstützung für folgende Netzwerktypen ... jeder Netzwerktyp ist einem sog. *Diver* zugeordnet, hat einen Namen, eine ID :

* docker0 ... veraltet
* Bridge
  * ausreichend für kleine Netzwerke, die nur auf einem einzigen Host laufen
* Overlay
  * für verteilte Netzwerke (nicht nur auf einem Host)
* MACVLAN

Nach der Installation von Docker sind bereits folgende Netzwerk-Interfaces im System registriert:

* `docker0`: Default Bridge-Network - veraltet

Zudem existieren schon folgende Docker-Netzwerke:

* bridge
  * Details zum Treiber findet man per `docker inspect bridge`
* host
  * Details zum Treiber findet man per `docker inspect host`
* none

Welche Netzwerke die Docker Container verwendet ermittelt man per `docker network ls`. Details erhält man über die Netzwerk-ID (z. B. `94d431c39280`) per `docker network inspect 94d431c39280`.

### Netzwerkinterfaces

Netzwerkkommunikation läuft IMMER über ein Netzwerkinterface ... der Docker-Container hat welche und der Docker-Host auch. Eine Übersicht über alle vorhanden Netzwerkinterfaces erhält man per `ifconfig`

```bash
╰─➤  ifconfig
Link encap:Ethernet  HWaddr 02:42:f3:9b:4e:95
          inet addr:172.18.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          inet6 addr: fe80::42:f3ff:fe9b:4e95/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:79 errors:0 dropped:0 overruns:0 frame:0
          TX packets:88 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:8368 (8.3 KB)  TX bytes:28157 (28.1 KB)

docker0   Link encap:Ethernet  HWaddr 02:42:5a:d2:50:1f
          inet addr:172.22.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

enp0s3    Link encap:Ethernet  HWaddr 08:00:27:52:75:ff
          inet addr:10.0.2.15  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::4b4:89c5:8cf5:eeb5/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:5154 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1971 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:4867163 (4.8 MB)  TX bytes:163591 (163.5 KB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:31 errors:0 dropped:0 overruns:0 frame:0
          TX packets:31 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:2700 (2.7 KB)  TX bytes:2700 (2.7 KB)

veth998e684: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 3e:8b:61:ed:d4:64  txqueuelen 0  (Ethernet)
        RX packets 26289  bytes 8082965 (7.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 18243  bytes 18891288 (18.0 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

oder auch `ip addr`

```bash
╰─➤  ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:52:75:ff brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 63024sec preferred_lft 63024sec
    inet6 fe80::4b4:89c5:8cf5:eeb5/64 scope link 
       valid_lft forever preferred_lft forever
3: br-4bd2f1095075: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:1f:1a:0d:32 brd ff:ff:ff:ff:ff:ff
    inet 172.19.0.1/16 scope global br-4bd2f1095075
       valid_lft forever preferred_lft forever
...
```

Diese Netzwerkinterfaces sind i. a. größtenteils nicht physikalisch vorhanden, sondern es handelt sich um virtuelle Devices. Diese virtuellen Devices werden von Docker automatisch auf dem Docker Host angelegt und zudem IPTables Einträge gemacht, um das  Routing entsprechend abzubilden.

All diese Interfaces lassen sich anpingen (z. B. `ping 172.18.0.1`).

#### Docker Bridged Netzwerk `br-1bb4da4d6e7c`

... hat die IP-Adresse `172.18.0.1` auf Docker-Host Seite.

Der Netwerkkonfiguration des Docker-Container, der dieses Interface verwendet sieht folgendermaßen aus:

```bash
╰─➤  docker network inspect 1bb4da4d6e7c
[
    {
        "Name": "dockerplatform_default",
        "Id": "1bb4da4d6e7c51f9322f62931fceb1f0dab96618a4d380fa2e5a1204ec53c3ed",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.18.0.0/16",
                    "Gateway": "172.18.0.1"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "0e5c4ecf01858f3841d38b7af4996524d1a13a119c97c346e058052bea59ef08": {
                "Name": "foo",
                "EndpointID": "48baca0856767cadab343fd270df278697a850894bc79fe9bf36602fa641d7fc",
                "MacAddress": "02:42:ac:12:00:02",
                "IPv4Address": "172.18.0.2/16",
                "IPv6Address": ""
            },
            "57ee4c967561f9286e9c201999109e0fb9c61b2b155167770f74e61847b89349": {
                "Name": "bar",
                "EndpointID": "21ca62b426b6021f55ef29b5327806a252ce87176c5445ae3b0aee38201f36e7",
                "MacAddress": "02:42:ac:12:00:03",
                "IPv4Address": "172.18.0.3/16",
                "IPv6Address": ""
            },
        },
        "Options": {},
        "Labels": {}
    }
]
```

d. h. der Docker-Container (in diesem Fall sind es sogar zwei, die in diesem Subnetz `172.18.0.0` hängen) verwendet die Docker-Host IP-Adresse des Netzwerkinterfaces als Gateway (`172.18.0.1`). Dadurch ist die non-internal Kommunikation mit der Außenwelt über den Docker Host sichergestellt. Interne Netzwerkkommunikation erfolgt über die internen IP-Adressen ... bei entsprechender Alias-Konfiguration (z. B. automatisch bei Verwendung von Docker-Compose) läßt sich der Container über einen logischen Names (`foo`) adressieren.

Im Docker-Host ist das Netzwerk folgendermaßen ins Routing eingebunden:

```bash
╰─➤  route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
10.0.2.0        *               255.255.255.0   U     100    0        0 enp0s3
link-local      *               255.255.0.0     U     1000   0        0 enp0s3
172.18.0.0      *               255.255.0.0     U     0      0        0 br-1bb4da4d6e7c
```

Aus diesem Grund kann ich den `foo`-Service per `ping 172.18.0.2` anpingen.

### host Netzwerk

Bei einem Host-Netzwerk (`docker run --net=host`) verhält sich der Container netzwerktechnisch wie der Docker Host, d. h.

* `localhost` im Container ist der Docker Host
* alle Ports, die der Container öffnet sind auch auf dem Docker-Host geöffnet - ACHTUNG: wenn der Container seinen Service an alle Netzwerkinterfaces bindet (`0.0.0.0`), dann sind die für alle erreichbar (evtl. sind Firewall-Regeln notwendig)

> ACHTUNG: braucht man nur den Zugriff auf den Docker Host aus einem Docker Container, dann kann man vielleicht auch ein Bridged Netzwerk verwenden und einen Alias auf das Loopback Device erstellen - [siehe Dokumentation](https://www.ibm.com/support/knowledgecenter/en/SSAW57_8.5.5/com.ibm.websphere.edge.doc/lb/tcfg_aliasloopback.html). In den neueren Docker-Versionen gibt es meines Wissens FQDN, die richtig geroutet werden ... allerdings ist das dann nur eine Option, die vom Container zum Host funktioniert ... allerdings nicht vom Host zum Container.

### bridge Netzwerk

Beim Bridge-Netzwerk erhalten beide Enden der Brücke eine eigene IP-Adresse, d. h.

* im Docker Host

### Iptables

Diese Einstellung auf dem Docker Host regelt Kommunikation auf unterster Ebene. Docker legt hier slebständig eigene Einträge ein, die über abstraktere Konfigurationen (z. B. in `docker run` oder `docker-compose.yml`) beschrieben werden. Deshalkb muß man selten in diese Konfiguration schauen, wenn man aber Fehler beheben will, dann kommt man hier nicht herum.

### Anpassung /etc/hosts im Docker-Container

Beim Start eines Docker-Containers kann man per `docker run --add-host host.docker.internal:172.22.0.1 ...` eine Anpassung der `/etc/hosts`-Datei im Docker-Container vornehmen.

## Docker-Network-Subsystem

Einen Überblick über das Subsystem liefert

```
pfh@workbench ~/src/docker-glassfish (git)-[master] % docker network ls
NETWORK ID          NAME                                  DRIVER              SCOPE
feaaabb8c54c        bridge                                bridge              local
17f602cb1018        decachacadocker_default               bridge              local
b1b9e2057c46        dockerglassfish_default               bridge              local
a44440574273        host                                  host                local
9f2ccc5be675        none                                  null                local
```

Hier sind alle erzeugten Netwerke sichtbar

```bash
docker network inspect bridge
```

läßt sich darstellen, welche laufenden Container das Docker-Network-Subsystem nutzen. So findet man beispielsweise raus, welche IP-Adressen die Container bekommen haben.

## Netzwerk erzeugen

Über

```bash
docker network create --driver bridge pierre_network
```

läßt sich eine Netzwerkinstanz mit dem Namen ``pierre_network`` erzeugen, so daß zwei Container mit diesem Netzwerk miteinander kommunizieren können:

```bash
pfh@workbench ~/src/docker-glassfish (git)-[master] % docker run -itd --name=pierre1 --network=pierre_network busybox
75e3645df6d29a62f3d0f47997f4da17955157bbb2af1a14db1f79847d5af946
pfh@workbench ~/src/docker-glassfish (git)-[master] % docker run -itd --name=pierre2 --network=pierre_network busybox
25c5bc67be10e0642fad23c071db9269121d38df3abc196bffb7211f39064e4c
```

Anschließend sieht dieses Netzwerk folgendermaßen aus:

```
pfh@workbench ~/src/docker-glassfish (git)-[master] % docker network inspect pierre_network
[
    {
        "Name": "pierre_network",
        "Id": "87e81b903a2dac1841f48faf22f9cdd098af49b232717e72208fe259adf5cc63",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": {},
            "Config": [
                {
                    "Subnet": "172.20.0.0/16",
                    "Gateway": "172.20.0.1/16"
                }
            ]
        },
        "Internal": false,
        "Containers": {
            "25c5bc67be10e0642fad23c071db9269121d38df3abc196bffb7211f39064e4c": {
                "Name": "pierre2",
                "EndpointID": "b8e198a341501e22b3400d87e22d9cca85eb3603fadcf6600609cec10ccc2361",
                "MacAddress": "02:42:ac:14:00:03",
                "IPv4Address": "172.20.0.3/16",
                "IPv6Address": ""
            },
            "75e3645df6d29a62f3d0f47997f4da17955157bbb2af1a14db1f79847d5af946": {
                "Name": "pierre1",
                "EndpointID": "1d102415128f20b9e4e11933c7806b34c020cae31d4b01ec584a06d95a2f3eb1",
                "MacAddress": "02:42:ac:14:00:02",
                "IPv4Address": "172.20.0.2/16",
                "IPv6Address": ""
            }
        },
        "Options": {},
        "Labels": {}
    }
]
```

Anschließend kann man beispielsweise folgendermaßen die Kommunikationswege prüfen:

```
pfh@workbench ~/src/docker-glassfish (git)-[master] % docker attach pierre1
/ # ping pierre2
PING pierre2 (172.20.0.3): 56 data bytes
64 bytes from 172.20.0.3: seq=0 ttl=64 time=0.094 ms
...
/ # ping 172.20.0.3
PING 172.20.0.3 (172.20.0.3): 56 data bytes
64 bytes from 172.20.0.3: seq=0 ttl=64 time=0.065 ms
...
```

Die Auflösung von ``pierre2`` nach ``172.20.0.3`` macht in User-defined-Networks der Docker-interne DNS, der auch in ``/etc/resolv.conf`` des Containers eingetragen ist (mehr Details https://docs.docker.com/engine/userguide/networking/configure-dns/). 

## Networking mit docker-compose

* https://docs.docker.com/compose/networking/

Docker-Compose erstellt beim Start sein eigenes Netzwerk, in dem die verschiedenen Container über deren Name erreichbar sind. Das ist auf jeden Fall schon mal komfortabler als in einem reinen Docker-Setup, in dem man das manuell konfigurieren muß (z. B. per ``docker run --link`` nachbilden). Die Container kommunizieren über dieses eigene Subnetzwerk. Da Docker-Compose kein HOST Netzwerk verwendet, sondern Bridge oder Overlay kommen sich die Container verschiedener Docker-Compose-Projekte bei den Ports auch nicht in die Quere. Ports müssen explizit an den Docker Host exponiert werden. Außerdem muß ich auch keinen Port zum Docker-Host exponieren ... und damit kann das natürlich auch mit den Ports des Docker-Host nicht in Konflikt stehen.

Mit einem Overlay-Netzwerk kann man sogar über Maschinengrenzen hinweg transparent (für die ``docker-compose.yml``) kommunizieren. Das ist beispielsweise bei Docker-Swarm relevant.