# docker network
Ein Container kann ein Netzwerk konfiguriert haben - muß aber nicht. Man kann auch nachträglich ein Netzwerk erzeugen (oder ein bestehendes verwenden) und einkonfigurieren.

Beim Start eines Containers kann das zu verwendende Netzwerk per ``--network=blablubb`` angegeben werden:

```
docker run --network=isolated_nw -itd --name=container3 busybox
```

Alle Container des gleichen Netzwerks können automatisch miteinander kommunizieren.

Auf dem Docker Host werden IpTables-Einträge für die Kommunikation mit den Containern angelegt - siehe `iptables -t nat -L`.

## Netzwerktypen
Docker bringt Ünterstützung für folgende Netzwerktypen ... jeder Netzwerktyp ist einem sog. *Diver* zugeordnet, hat einen Namen, eine ID :

* ~~docker0~~ ... veraltet
* Bridge
  * ausreichend für kleine Netzwerke, die nur auf einem einzigen Host laufen
* Overlay
  * für verteilte Netzwerke (nicht nur auf einem Host) 
* MACVLAN

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
## 
```

Hier sind alle erzeugten Netwerke sichtbar 

```
docker network inspect bridge
```

läßt sich darstellen, welche laufenden Container das Docker-Network-Subsystem nutzen. So findet man beispielsweise raus, welche IP-Adressen die Container bekommen haben.

## Netzwerk erzeugen
Über 

```
docker network create --driver bridge pierre_network
```

läßt sich eine Netzwerkinstanz mit dem Namen ``pierre_network`` erzeugen, so daß zwei Container mit diesem Netzwerk miteinander kommunizieren können:

```
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

Docker-Compose erstellt beim Start sein eigenes Netzwerk, in dem die verschiedenen Container über deren Name erreichbar sind. Das ist auf jeden Fall schon mal komfortabler als in einem reinen Docker-Setup (dort könnte man das per ``docker run --link`` nachbilden). Die Container kommunizieren über dieses eigene Netzwerk und dementsprechend kommen sich die Container verschiedener Docker-Compose-Projekte bei den Ports auch nicht in die Quere. Außerdem muß ich auch keinen Port zum Docker-Host exponieren ... und damit kann das natürlich auch mit den Ports des Docker-Host nicht in Konflikt stehen.

Mit einem Overlay-Netzwerk kann man sogar über Maschinengrenzen hinweg transparent (für die ``docker-compose.yml``) kommunizieren. Das ist beispielsweise bei Docker-Swarm relevant. 