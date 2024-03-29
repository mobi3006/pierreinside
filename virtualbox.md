# VirtualBox

Sun's kostenlose Virtualisierungssoftware, deren Installer mit 70 MB erstaunlich klein ist (ein Adobe Reader hat heutzutage schon 25 MB, ein Druckertreiber hatte letzhin 50 MB).

Der Nahtlos-Modus macht die Integration in das Wirtsbetriebssystem nahezu perfekt - einzig: die Taskumschaltung innerhalb der VM (mit Alt-Tab) berücksichtigt nur die Programme der VM und im Wirt ist berücksicht nur seine eigenen Programme. Vielleicht ist das auch besser so, doch für eine richtig nahtlose Integration wäre das vielleicht ein nettes Feature. Ich bin mir aber nicht ganz sicher, ob ich das selber wollte - derzeit fällt es mir aber immer wieder auf und ich muss dann erst meine Maus aus dem Focus des VM-Fensters bewegen, um an die Windows-Programme zu kommen.

Nach jetzt 6-monatiger Nutzung bin ich immer noch begeistert von VirtualBox und weine VMWare keine Träne hinterher. Das hat sich auch nach einigen Jahren nicht geändert :-)

---

## Virtualisierung Background Informationen

Hypervisor-Typen

- Typ 1: läuft direkt auf der Hardware ohne weiteres typisches Betriebssystem
  - VmWare ESX
  - Xen
- Typ 2: setzt auf einem Betriebssystem auf, über das der Zugriff auf die Hardware erfolgt
  - VirtualBox
  - VMWare Workstation

---

## Basis-Installation

verlief problemlos - click and go. Hier sollte man dann auch gleich das _Extension Pack_ (USB2/3-Support, RDP-Verbindungen zum Gast, PXE-Support, Plattenverschlüsselung) installieren.

### PUE Lizenz des Extension Packs

In der iX stand mal, daß VirtualBox mit dieser Lizenz "[...] theoretisch sogar in Großunternehmen auf jedem PC installiert werden - dofern jeder Anwender dies selbst erledigt" (iX 9/2016).

---

## Image-Container anlegen

Hinsichtlich Zuordnung von Plattenplatz kann man es wohl sehr komplex treiben, doch hält man sich an die Anfänger-Vorgaben (die physische lokale Platte zu verwenden), dann ist der erste Image-Container nach 2 Minuten fertig :-)

Per Default wird ein Verzeichnis ``~/.VirtualBox`` angelegt, in dem sich zwei Unterverzeichnisse ``Machines`` und ``HardDisks`` befinden. In ``HardDisks`` liegen die eigentlichen Daten des Images in einer einzigen Datei (die Festplatte des Gastes sozusagen), in ``Maschines`` befindet sich die Konfiguration, LogFiles und Snapshots.

---

## Datei-Sharing

### Shared Folder

Über Shared Folder kann man Verbindung zum Wirtssystem aufnehmen. In einem Linux-Gastsystem mounted man den Shared-Folder per

```bash
mount -t vboxsf $SHARED_FOLDER_NAME $DIRECTORY
```

Allerdings müssen die Gasterweiterungen installiert sein, sonst steht das VBoxSF-Filesystem (VirtualBoxSharedFilesystem) nicht zur Verfügung.

Man kann auch die Option Automatisch einbinden wählen, dann wird das Verzeichnis automatisch als

```bash
/media/sf_<ORDNER_NAME>
```

gemounted. Allerdings hat man dann nicht soviele Konfigurationsmöglichkeiten wie über das "manuelle" (bzw. auch hier kann man das automatische Mounten bei Systemstart aktivieren) Mounten in Linux.

#### Symbolische Links und HardLinks

Leider unterstützt das VBoxSF-Filesystem in Version 3.1.2 keine symbolischen Links und auch keine HardLinks im SharedFolder - das schränkt die Nutzung von einem Linux-Gastsystem deutlich ein :-( Mehr dazu siehe hier: http://www.virtualbox.org/ticket/818 - das Anlegen eines solchen Links wird mit der Meldung ``Operation not permitted`` quittiert.

#### Owner und Group

Beim mounten per ``mount -t vboxsf SHARED_FOLDER_NAME MOUNTPOINT`` werden alle Dateien dem User Root zugeschlagen. Durch Verwendung folgender Mountoptionen lässt sich das ändern:

```bash
mount -t vboxsf -o uid=1000,gid=100 WINDOWS_C /mnt/WINDOWS_C/
```

``uid`` und ``gid`` kann man aus ``/etc/passwd`` erfahren. In der ``/etc/fstab`` sieht das dann folgendermassen aus:

```
WINDOWS_C     /mnt/WINDOWS_C     vboxsf     uid=1000,gid=100      0 1
```

#### Performance

* [Performance-Vergleich - files sharing](https://jsosic.wordpress.com/tag/shared-folders/)

Leider ist die Performance auf einem `vboxsf`-Shared-Folder ganz schlecht ... es genügt, um Konfigurationsdateien zu lesen. Will man allerdings I/O-intensivere Aktionen (z. B. Java-Compilierung) durchführen, dann ist es zu langsam.

> für einen Maven-Build, der auf meinem Linux Filesystem 20 Sekunden dauert, habe ich 8 Minuten benötigt

### CIFS Sharing

Hierzu kann man beispielsweise auf seinem Windows-Host ein Verzeichnis freigeben. Danach muß man ein Verzeichnis in seinem Home-Verzeichnis erstellen `mkdir /home/pfh/windows_shared_folder` (oder zumindest in einem Verzeichnis, auf das man Schreibberechtigung hat). Über den Windows-Rechnernamen und den Namen des Verzeichnisses (z. B. `\\workbench\shared-folder`) kann man dann das Verzeichnis mounten::

```
sudo mount -t cifs -o username=windows_username,uid=1000,gid=1000 //workbench/shared_folder /home/pfh/windows_shared_folder
```

> Hierzu muß allerdings `/sbin/mount.cifs` vorhanden sein - sollte es fehlen, dann bekommt man es per `apt-get install cifs-utils smbclient`.

Leider ist die Performance nicht so gut wie ich erhofft hätte. Für einen Maven-Build, der auf meinem Linux Filesystem 20 Sekunden dauert, habe ich mit dem CIFS-Share über 3 Minuten benötigt. Immerhin deutlich besser als mit VirtualBox-Shared-Folder (8 Minuten) aber dennoch inakzeptabel langsam :-(

---

## Snapshots

Ein sehr angenehmes Features sind die Snapshots. Vor größeren Umbauten kann man hier einen Snapshot ziehen, auf den man dann wieder zurückwechseln kann.

> ACHTUNG: Nach einem Snapshot wird eine neue Virtualbox-Festplatte (Speicherort über *VirtualBox-Menü - Snapshot*) angelegt und dort werden die neuen Daten abgelegt. Die alte Festplatte wird ab dem Zeitpunkt nicht mehr angefaßt (das ist der alte Zustand!!!). GANZ WICHTIG: man sollte die Snapshots zeitnah löschen, so daß ein Merge in die alte Festplatte erfolgt - das Arbeiten mit mehreren Festplatten ist sicherlich nicht ganz optimal.

Wer dem beim Löschen eines Snapshots durchgeführten Merge nicht traut clont sein Image am besten vorher (Full Clone, nur aktueller Zustand, MAC-Adresse beibehalten).

### Performance

Beim Snapshotting sollte man aufpassen wo die neuen Festplatten abgelegt werden. Per Default ist das ``~/VirtualBox VMs/imageName\Snapshots``. Je nach Festplatten-Layout kann das die evtl. kleine System-Platte "vollmüllen" (ich mag solche Layouts nicht und kann den Sinn auch nicht nachvollziehen). Viel schlimmer ist allerdings, daß in Unternehmen nur bestimmte Verzeichnisse vom Virenscanner ausgenom,men sind (i. d. R. Developer-Verzeichnisse) und dieses evtl. nicht dabei ist. Dann sinkt natürlich die Performance.

### Performance beim Löschen von Snapshots

Beim Löschen eines Snapshots wird die neue Festplatte in die alte Festplatte gemergt.

Ich hatte mal eine 22 GB große "neue Festplatte" und eine 40 GB große "alte Festplatte" (beide lagen auf einer SSD aber in unterschiedlichen Partitionen). Das Löschen war mit weniger als 60 Sekunden schneller als ich erwartet hätte.

---

## VM per Skript starten

Um eine VM per Skript oder per Mausklick zu starten (ohne das VirtualBox-GUI zum Auswählen des Images zu starten:

```
VBoxManage startvm "NAME_DER_VM"
```

---

## Netzwerkkonfiguration

- https://www.thomas-krenn.com/de/wiki/Netzwerkkonfiguration_in_VirtualBox#Host-only_networking

In VirtualBox erfolgt die Netzwerkkonfiguration auf mehreren Ebenen:

- zentral über Image-Grenzen hinweg

![VirtualBox - zentrale Netzwerkkonfiguration](images/virtualBox_networkConfiguration_central.png)

- für jedes Image

![VirtualBox - Netzwerkkonfiguration pro Image](images/virtualBox_networkConfiguration_perImage.png)

Die Netzwerkkarten von Virtualbox haben unter Linux das Namensschema ``enp0sX`` (z. B. ``enp0s3``). Über entsprechende Routing-Tabellen erfolgt das Routing auf die entsprechende Netzwerkkarte (`route`).

| Netzwerktyp | Gast -> andere Gäste | Host -> Gast | Gast -> externes Netzwerk |
| -- | -- | -- | -- |
| Not attached | nein | nein | nein |
| Network Address Translation (NAT) | nein | nein | JA |
| Network Address Translation Service | JA | nein | JA |
| Bridged networking | JA | JA | JA |
| Internal networking | JA | nein | nein |
| Host-only networking | JA | JA | nein |

### NAT

- http://www.virtualbox.org/manual/ch09.html#changenat

Bei der Verwendung von NetworkAddressTranslation fungiert die VirtualBox-Software als Router (der das Gastnetzwerk mit dem Hostnetzwerk verbindet - beide haben ganz unterschiedliche IP-Adressen). Das Gastbetriebssystem erhält von VirtualBox eine IP-Adresse (per Default 10.0.2.15 ... wenn nur ein NAT-System existiert), die nichts mit der IP-Adresse des Hostsystem (z. B. 192.168.1.1) zu tun hat. Virtualbox agiert als Gateway (über die IP-Adresse 10.0.2.2), d. h. hierüber erfolgt die Einspeisung der Nachrichten in das Netzwerk des Hostsystems. Zudem stellt Virtualbox einen DNS-Server unter ``10.0.2.3`` bereit.

Für JEDES NAT-Netzwerk wird ein eigenes Gast-Netzwerk aufgebaut.

Das Gastbetriebssystem

- kann DHCP verwenden (der DHCP-Server wird dann von VirtualBox bereitgestellt)
- kann vom VirtualBox-Software-Router eine statische IP-Adresse erhalten ... dann sollte man aber [private IP-Adressen](http://de.wikipedia.org/wiki/Private_IP-Adresse) verwenden (keine öffentlichen)

In beiden Fällen sind die Gastbetriebssysteme und deren Services über diese IP-Adressen nicht von aussen nutzbar - Antworten auf vom Gastsystem initiierten Requests kommen aber an - über NetworkAddressTranslation. Über Port-Forwarding kann man Ports des Gastbetriebssystems (z. B. Port 80) an das Host-Betriebssystem (z. B. Port 8080) weiterleiten, so daß der Service des Gastbetriebssystems per ``localhost:8080`` (oder ip_address_host_machine:8080) erreichbar ist. Auf diese Weise kommt man auch von anderen Rechnern im Host-Netzwerk auf das Gastbetriebssystem ... zumindest wenn das keine Firewalleinstellungen auf dem Hostsystem verhindern.

#### Port-Forwarding bei NAT

Bei einer NAT-Einbindung des Gastbetriebssystems sind die Gastsystem-Services andere Rechner im Netzwerk, in das das Hostsystem eingebunden ist, nicht sichtbar/erreichbar, da die IP-Adresse des Gastbetriebssystems nur dem Host bekannt ist (entweder eine dynamische oder eine statische). Mit Port-Forwarding behelfen werden Ports aus dem Gastsystem an Ports des Host-Betriebssystems gebunden, so daß die Services über die IP-Adresse des Host-Systems auch von außen erreichbar sind.

Besonders interessant für meine Bedürfnisse ist das Port-Forwarding vom Wirtssystem an das Gastsystem, wenn kein richtiges Netzwerk vorhanden ist. Ich nutze ein Linux-Gastsystem in einem Windows-Wirtssystem und gebe ein paar Ports (von ssh-Server, Webserver, Datenbank) meines Linux-Gastsystems an das Windows-System weiter. Auf diese Weise kann ich dann per

```bash
http://localhost:1701/exponent-0.96.3/index.php
```

vom Browser des Hostsystems auf den Webserver innerhalb meines Gastbetriebsystems zugreifen.

**Virtualbox Version 4:**

Über die Administrationsoberfläche von VirtualBox lässt sich die Portweiterleitung komfortabel konfigurieren. In Version 3.x war das noch ein bisschen umstädnlicher (s. u.)

**Virtualbox Version 3:**

So wurden die Ports freigeschaltet (ACHTUNG: in Abhängigkeit der eingerichteten Netzwerkkarte muss "pcnet" durch "e1000" oder "e100" ersetzt werden):

```bash
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/mysql/Protocol" TCP
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/mysql/HostPort" 3306
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/mysql/GuestPort" 3306

VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/Protocol" TCP
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/HostPort" 22
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/ssh/GuestPort" 22

VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/httpd/Protocol" TCP
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/httpd/HostPort" 1701
VBoxManage setextradata "MY_VM_NAME" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/httpd/GuestPort" 80
```

**Wissenswertes:**

- diese Konfiguration wird in der Konfigurationsdatei der VM (VM_NAME.xml) gespeichert und lassen sich da natürlich auch bequem editieren (und vor allem in einer Versionsverwaltung wie Subversion versionieren)
- die Parameter von VBoxManage sind hier dokumentiert: http://www.virtualbox.org/manual/UserManual.html#vboxmanage
- die Änderungen an der VM per VBoxManage-Tool wirken sich erst nach einem Neustart bzw. Warmstart (Aufwachen aus dem Suspend-Modus) aus.
- Will man die aktuellen Einstellungen der VM erfahren: ``VBoxManage getextradata "MY_VM_NAME" enumerate``
  - ACHTUNG: VirtualBox sollte bei Eingabe dieser Befehle nicht laufen (und dementsprechend soll auch das Image MY_VM_NAME nicht laufen - es muss nicht komplett runtergefahren sein, der Suspend-Mode genügt). Bei VirtualBox 3.1.2 hatte ich einen BlueScreen nach Eingabe obiger Befehle und Neustart von VirtualBox. Nach dem Rechner-Restart klappte der Start von VirtualBox allerdings und auch das Port-Forwarding funktionierte.

### Netzwerkbrücke aka Bridged-Mode

Hier nutzt das Gastbetriebssystem die von VirtualBox emulierte Hardware - deshalb muss man auch die zu verwendende Hardware (Ethernet, WLAN) auswählen (und natürlich auch umstellen, wenn physisch auf ein anderes Interface gewechselt wird). Für das Gastbetriebssystem erscheint das Interface dann immer wie ein Ethernet-Anschluss, auch wenn es sich physisch um eine WLAN-Verbindung handelt.
Das Gastbetriebssystem bekommt eine eigene IP-Adresse vom DHCP-Server, den auch das Hostsystem verwendet. Auf diese Weise verhält sich das Gastbetriebssystem wie jeder andere Rechner im Netzwerk. Das Gastbetriebssystem ist von anderen Rechnern im Netz über diese IP-Adresse erreichbar (bei NAT geht das nicht ohne weiteres - hier kann man Port-Forwarding konfigurieren).

### Host-only

- https://www.thomas-krenn.com/de/wiki/Netzwerkkonfiguration_in_VirtualBox#Host-only_networking

In _VirtualBox - File - Preferences - Network - Host-Only Netwworks_ können verschiedene Host-Only-Netzwerke definiert werden:

![VirtualBox Host-Only-Network](images/virtualBox_hostOnlyNetworks.png)

Zu jedem Host-Only-Netzwerk wird das Subnetz und der DHCP-Server (vergibnt die IP-Adressen für die Images des Netzwerks) definiert

![VirtaulBox - Host-Only-Adapter](images/virtualBox_hostOnlyNetwork_adapter.png)

So verwendet man das Host-Only-Netzwerk in einem Image:

![VirtualBox - Host-Only-Adapter - Usage by Image](images/virtualBox_hostOnlyNetwork_usageByImage.png)

Jetzt können alle Images miteinander kommunizieren, die das gleiche Host-Only-Netzwerk verwenden.

> BTW: Host-Only-Netzwerke verwendet man häufig auch zusammen mit NAT-Netzwerken. Während man aus dem Gast über NAT ins Internet kommt, ermöglicht das Host-Only-Netzwerk eine Kommunikation vom Host in den Gast. Man spart sich somit das pflegeintensive Port-Forwarding - allerdings kommt man von außen (einem anderen Rechner) nicht an die Dienste innerlhalb des Images ... was bei Port-Forwarding geht. Im Linux-Image sieht das bei einem NAT und einem Host-Only-Netzwerk dann beispielsweise folgendermaßen aus:

```bash
╭─pfh@workbench ~/src  ‹master› 
╰─➤  route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         10.0.2.2        0.0.0.0         UG    100    0        0 enp0s3
10.0.2.0        *               255.255.255.0   U     100    0        0 enp0s3
link-local      *               255.255.0.0     U     1000   0        0 enp0s8
192.168.56.0    *               255.255.255.0   U     100    0        0 enp0s8
```

---

## Gast-Betriebssystem installieren - allgemein

Mein OpenSuse liegt als ISO-File auf der Platte - deshalb konfiguriere ich das CD-Laufwerk mit diesem ISO-File und starte das Image. Es wird von der gebundenen CD (in Form der ISO-Datei) gebootet und ich kann mein System installieren.

### Gasterweiterungen installieren

Zunächst startet das Image nur mit 800 x 600 Pixel und lässt sich auch nicht vergrössern (das Fenster wird schon größer, aber leider nicht der Gastbetriesbsystem-Bildschirm). Ein bisschen googeln zeigt, dass in den Gastbetriebssystemen der VirtualBox (wie bei VMWare auch) Gasterweiterungen installiert werden müssen. Hierzu wählt aus dem VM-Menü "Geräte - Gasterweiteerungen installieren" - im Hintergrund wird ein Image VBoxGuestAdditions.iso in den Manager für virtuelle Medien (Menüpunkt: Geräte - CD/DVD-ROM einbinden - CD/DVD-ROM-Abbild ... - CD/DVD-Abbilder) eingebunden (Achtung: im Linux-System findet noch kein Mounting dadurch statt - einzig: das ISO-File mit den Gasterweiterungen ist im Manager für virtuelle Medien eingetragen). Anschließend muss man es noch über den Manager für virtuelle Medien auswählen und mounted es (mkdir tools; sudo mount /dev/cdrom tools) und dann führt man das Installationsskript aus (cd tools; ./VBoxLinuxAdditions-x86.sh). Bei meinem Opensuse musste ich noch die Kernel-Sourcen und noch ein anderes Paket nachinstallieren und schon konnte ich im Gastbetriebssystem (über Yast) eine höhere Auflösung einstellen :-)

#### Problem: Gasterweiterungen werden nicht geladen

Ich hatte mal das Problem, dass ich plötzlich nicht mehr auf den Shared Folder zugreifen konnte. Ich rebootete das System und versuchte den Shared Folder zu mounten (mount -t vboxsf sharedFolderName myMountPoint ODER mount.vboxsf sharedFolderName myMountPoint), doch ich bekam die Nachricht

```bash
/sbin/mount.vboxsf: mounting failed with the error: No such device
```

Da ``lsmod | grep vbox`` weder ``vboxadd`` noch ``vboxvfs`` lieferte und auch ``modprobe vboxadd`` und ``modprobe vboxvfs`` nicht funktionierte, entschied ich mich, die Gasterweiterungen erneut zu installieren. Und das klappte tatsächlich :-) Warum die Gasterweiterungen plötzlich weg waren - ich weiss es nicht (vielleicht ein Linux-Update, das etwas zerstört hat ...).

### VPN im Gastbetriebssystem

Ich habe das bisher in der Variante "Bridge-Mode über Ethernet/WLAN" in einem Ubuntu-Gastbetriebssystem betrieben. Im Gastbetriebssystem muss zunächst eine normale Netzwerkverbindung hergestellt sein. Darauf aufesetzend wird dann ein VPN-Tunnel per ``nm-applet`` gestartet. Über das ``nm-applet`` erfolgt auch die Konfiguration. Siehe [hier](http://localhost:1701/exponent-0.96.3/index.php?section=466).

Am einfachste ist, wenn man NAT verwendet, dann muß man VPN nur im HOST System konfigurieren.

---

## Resizing der Festplatte

Es ist wirklich nervig und ineffizient, wenn man ständig Platzprobleme hat und aufräumen muss. Ist mir regelmäßig passiert und immer wieder ist es zu Problemen gekommen, weil man es eben recht selten machen muß ... ich scheue mich immer wider davor und deshalb habe ich es hier aufgeschrieben ... mit ein paar Background-Infos.

### Strategien

LVMs sind dafür designed Erweiterungen des Speicherplatzes zu ermöglichen, ohne bestehende Filesysteme zu verändern. Das ist die absolut sichere Variante. Hierzu wird eine neue Partition angelegt und dazu ein Volume erzeugt, das wiederum zur existierenden Volume-Group hinzugefügt wird.

Bei physischen Festplatten ist das besonders hilfreich, da auf diese Weise eine neue Festplatte hinzugefügt werden kann, ohne die Filesystemstruktur zu verändern, d. h. das `/home`-Filesystem kann einfach um Speicherplatz erweitert werden, der aber auf einem anderen physischen Device liegt.

Verwendet man virtuelle Festplatten, die i. d. R. in einer einzigen Datei (`my-virtual-disk.vdi`) liegen (zumindest bei meinen persönlichen Virtuellen Images ... im Enterprise Bereich ist das vielleicht anders) sieht die Sache evtl. anders aus. Diese Datei wird von der Virtualisierungslösung verwaltet und kann mit Bordmitteln leicht vergrößert werden (Virtualbox: `VBoxManage.exe modifyhd my-virtual-disk.vdi --resize 75000`). Auf diese Weise entsteht mehr Speicherplatz, der anschließend aber noch zugeteilt werden muß. Entweder tut man das durch Hinzufügen eines Logical-Volumes oder man erweitert die vorhandene Partition und das Filesystem über (GParted und `resize2fs`).

> Ich schätze die Änderung einer Partition und Vergößerung des Filesystems risikoreicher im Vergleich zum LVM-Ansatz ein. Durch die einfache Backup-Möglichkeit von virtuellen Festplatten (es muß nur eine einzige Datei kopiert werden) ist dieses Risiko nicht vorhanden (zumindest wenn man genügend Speicherplatz hat) und es stellt sich die Frage, ob bei diesem Setup eine LVM-Ansatz überhaupt Vorteile hat.

Es ist auch möglich, eine Partition eines LVM-Volumes mit `resize2fs` zu erweitern ... das funktioniert. Dann nutzt man allerdings nicht die Bordmittel des LVM, sondern behandelt es wie ein Nicht-LVM-System, indem man das Filesystem vergrößert.

> Dieser Ansatz funktioniert allerdings nur, wenn die vorhandene Partition und der nicht-allokierte Bereich zusammenhängen und verschmolzen werden können.

## Erweiterung über ein neues LVM-Volume

- [LVM Grundkonfiguration](https://www.thomas-krenn.com/de/wiki/LVM_Grundkonfiguration)
- [LVM Erweiterung](https://www.thomas-krenn.com/de/wiki/LVM_vergr%C3%B6%C3%9Fern)

Wenn man das Linux-System mit einem Logical-Volume-Manager aufgesetzt hat, dann kann man auch eine weitere Festplatte (= Partition) hinzufügen und in den LVM einhängen.

> habe ich noch nicht oft gemacht

### Erweiterung über Vergrößerung eines Filesystems

- [Anleitung 1](https://askubuntu.com/questions/101715/resizing-virtual-drive)
- [Anleitung 2](https://askubuntu.com/questions/88647/how-do-i-increase-the-hard-disk-size-of-the-virtual-machine)

> **Achtung:** Bei meinem Ubuntu 18.04 habe ich ein LVM-System installiert. Dennoch habe ich mich gegen den LVM-Ansatz (Anlage eines neuen Volumes, das zur Volume-Group hinzugefügt wird) entschieden ... ich arbeite selten mit den LVM-Tools und finde ein einziges Volume weniger verwirrend. Ich verwende Virtualbox und dementsprechend das Tool `VBoxManage`

Ich werde im folgenden meine Root-Partition/Filesystem erweitern. Um Datenverlust zu verhindern clone ich meine existierende Virtualbox-Festplatte (**GANZ WICHTIG:** vorher das Image runterfahren)

```bash
/cygdrive/c/Program\ Files/VirtualBox/VBoxManage.exe clonehd my-workbench.vdi my-workbench-new.vdi --variant Standard
```

und überprüfe sie per

```bash
/cygdrive/c/Program\ Files/VirtualBox/VBoxManage.exe showhdinfo my-workbench-new.vdi
```

Anschließend vergrößere ich die Storage-Datei

```bash
/cygdrive/c/Program\ Files/VirtualBox/VBoxManage.exe modifyhd my-workbench-new.vdi --resize 75000
```

, überprüfe die neue Größe per

```bash
/cygdrive/c/Program\ Files/VirtualBox/VBoxManage.exe showhdinfo my-workbench-new.vdi
```

und tausche in VirtualBox-Image die alte Storage-Datei durch die neue aus.

> Somit ist die alte Storage Datei mein Backup - es ist vor Veränderungen geschützt.

Problem ist nun, daß man eine gemountetes Filesystem/Partition nicht verändern kann. Unmounten der Root Partition eines laufenden Systems ist nicht möglich. Ich kann also nicht mein System einfach starten und dann Veränderungen am Filesystem vornehmen. Aus diesem Grund starte ich eine Live-CD und erweitert damit die Partition Filesystem des eigentlichen Systems.

> Ich habe ext4 als Filesystem ... das läßt sich im laufenden Betrieb erweitern - für die Erweiterung des Filesystems brauche ich das Live-System somit nicht.

Ich habe mich für [GParted-Live-CD](https://gparted.org/livecd.php) entschieden, da hier ein intuitives GUI bereitgestellt wird. 

Ich lade die GParted-Live-CD als ISO-Datei runter und binde sie in mein VirtualBox-Image als weitere Live-CD ein. Dann boote ich das Image und statt meines Systems startet dadurch das GParted-Live-System. Nach dem Bootvorgang `GParted` starten, um die vorhandene Root-Partition um den nicht-allokierten Platz des Virtualbox-Storage zu erweitern:

- zu erweiternde Partition deaktivieren (wird evtl. per default gemounted)
- Device erweitern
- Partition erweitern
- Aktionen (zwei) ausführen

GParted beenden und die Live-CD wieder als CD entfernen, so daß beim nächsten Boot mein System (anstatt GParted) startet. Booten des Images.

Nach dem Bootvorgang muß das Filesystem erweitert werden (die Partition wurde in GParted erweitert):

```bash
lvextend --resizefs -l +100%FREE /dev/mapper/ubuntu--vg-root
```

## Resizing auf die harte Tour (dd)

Im groben:

- neue (größere) virtuelle Festplatte erzeugen und ins Image einhängen
- Inhalt der alten (kleinen) Festplatte per dd auf die neue (große) Festplatte kopieren
- nicht genutzten Platz der großen Festplatte durch Resizing (per GParted) verwenden

Im Detail:

- Einbindung von ``gparted-live-0.11.0-7.iso`` als Linux-Live-System in das Image (dieses Live-Image soll später gestartet werden - also evtl. Boot-Reihenfolge so ändern, daß von CD gebootet wird)
- Anlage und Einbindung einer größeren virtuellen Festplatte ins Image
- Booten des GParted-Live-Systems
- Prüfung, welche Festplatte über welchen Device-Treiber erreichbar ist. Ich hatte die alte Festplatte am primären Master (``dev/sda``) und die neue Festplatte am primären Slave (``dev/sdb``).
- Kopieren der Daten von der alten Festplatte auf die neue:
  - ``sudo bash``
  - ``dd if=/dev/sda of=/dev/sdb``
- Reboot des GParted-Systems (damit die neue Festplatte richtig eingebunden wird - entscheidend sind hier die ``/dev/disk/by-id/*`` Informationen)
- Prüfung welche ID (im folgenden ID_NEUE_FESTPLATTE genannt), die neue Festplatte hat. Hierzu in ``/dev/disk/by-id/`` die ID der neuen Festplatte herausfinden und eintragen in
- neue Festplatte konfigurieren
  - mounten der neuen Festplatte
    - ``sudo bash``
    - ``mkdir neueFestplatte``
    - ``mount /dev/sdb2 neueFestplatte``
  - Bootvorgang der neuen Festplatte anpassen
    - ``vi ./neueFestplatte/boot/grub/menu.lst``
    - hier ID_NEUE_FESTPLATTE an alle relevanten Stellen eintragen (also dort wo bisher die ID der alten Festplatte stand)
    - ``vi /./neueFestplatte/etc/fstab``
    - hier ID_NEUE_FESTPLATTE an alle relevanten Stellen eintragen (also dort wo bisher die ID der alten Festplatte stand)
- per GParted-Tools die relevante Partition der neue Festplatte um den nicht genutzten Bereich erweitern
- System runterfahren
- GParted entfernen
- alte virtuelle Festplatte entfernen
- System neu starten
- Prüfung, ob nun mehr Platz frei ist: df -h

---

## Windows-Wirtssystem und Linux-Gastsystem - die perfekte Console für Windows

Verwendete Komponenten:

- VirtualBox Linux-Gastsystem
- Nicht-Fangen des Mauszeigers durch das Gastsystem (hierzu müssen die Gasterweiterungen installiert sein)
- Festplatten des Windows-Wirtssystems als Shared-Folders bereitstellen und in das Linux-Gastsystem einbinden
- Optional:
  - ssh-Server auf dem Linux-Gastsystem mit Port-Forwarding von VirtualBox
  - ssh-Client (z. B. Putty) mit X11-Forwarding
  - Xming (X-Server) auf dem Windows-Wirtssystem

So kann man die Konsole des Linux-System verwenden, um auf der Festplatte des Windows-Systems zu arbeiten. Durch die optionalen Komponenten kann man die Integration weiter optimieren, so dass die Konsole tatsächlich seamless in das Windows-System integriert ist (der eingebaute seamless-Mode von VirtualBox arbeitet noch nicht so gut). Als Goody erhält man die Möglichkeit per ssh-Client remote auf den Windows-Partitionen zu arbeiten.

Wenn jetzt noch die symbolic-Links bzw. HardLinks auf SharedFolders funktionieren würde (siehe oben), hätte man eine perfekte Konsole für das Windows-System. Ein Grund [cygwin](cygwin.md) zu nutzen bestünde dann nicht mehr.

---

## Erfahrungsberichte verschiedener Gastbetriebssysteme

### Gast-Betriebssystem installieren - OpenSuse 11.1

Ein wenig problematischer gestaltete sich die Netzwerkkonfiguration. In VMWare hatte alles out-of-the-box funktioniert und jetzt hatte ich doch Probleme. Man muss hier nämlich das Image umkonfigurieren, in Abhängigkeit davon, ob man eine Netzwerkverbindung per WLAN oder Netzwerkkabel aufbauen möchte. Es hatte zwar direkt nach der Installation über mein Netzwerkkabel funktioniert, doch als ich einen Tag später über den WLAN-Stick ins Internet gehen wollte klappte das nicht mehr und frustrierte mich doch sehr :-(

Schließlich hatte ich doch den piep-einfachen Bridged-Mode verwendet, der bei VMWare doch auch immer klappte. Nach mehrmaligem RTFM fand ich doch noch heraus, dass man den virtuellen Netzwerkadapter an ein physisches Gerät binden muss - in den VirtualBox Administrationstools:

![Bidged-Mode](images/virtualbox_bridgedMode.png)

So schaffte ich zumindest, aus dem Gastsystem wieder aufs Internet zugreifen zu können. Um beim Wechsel auf meine kabelgebundene Netzwerkverbindung nicht immer wieder das Image runterfahren zu müssen, habe ich einen Adapter für die kabelgebundene Variante und einen Adapter für die wireless-Variante konfiguriert:

![zwei Netzwerkadapter](images/virtualbox_networkConfiguration.png)

Doch leider klappte der Zugriff vom Host-System auf mein im Gastsystem mittlerweile wieder laufendes Exponent-CMS (LAMP - Linux, Apache, MySql, PHP) nicht. Da der Firefox 3.5 im Gastsystem doch sehr, sehr langsam mit meinem Exponent-System kommunizieren wollte (der Seitenaufbau war schnarch-lahm - keine Ahnung warum) war ich extrem frustriert und hielt schon Ausschau nach einem Ersatz-Laptop (oder gar einer fetten Workstation) - zugegeben: ich wollte mir auch endlich mal wieder was gönnen und nahm das Problem jetzt zum Anlass ...
Nachdem ich dann doch ein wenig ziellos bei der Rechnersuche war, widmete ich mich doch ein wenig entspannter dem Problem und gleich meine erste Vermutung stimmte: die Linux-Firewall verhinderte den Zugriff. Schnell eine Ausnahme eingebaut (Zugriff auf den HTTP-Server) und schon konnte ich die Seiten aus meinem Hostsystem (Windows XP) in gewohnter Geschwindigkeit editieren :-)

### Gast-Betriebssystem installieren - Ubuntu 14.04 LTS

Hier musste ich die 3D-Beschleunigung in den VM-Setting aktivieren, weil ansonsten der compiz-Prozess eine ganze CPU gebraucht hat und mein System extrem zäh war.

---

## Video Capture

Virtualbox bringt bereits Video Capturing mit, das man in einem laufenden Image jederzeit starten kann ... super praktisch. Das Aufzeichnungformat ist [WebM](https://de.wikipedia.org/wiki/WebM), das leider nicht von allen Browsern derzeit zuverlässig abgespielt werden kann (Stand Frühling 2017). Aber mit [Handbrake](https://handbrake.fr/) hat kann das leicht in MP4 transformiert werden.

---

## VirtualBox 4.x

Mit 4.0.2 hat sich die Folderstruktur geändert ... eigentlich eine gute Sache, denn alle Dateien eines Images sind nun in EINEM Ordner vereint.

### Upgrade 4.0.0 -> 4.1.8: FEHLGESCHLAGEN

Beim Wechsel von 4.0.0 auf 4.1.8 kam es bei mir unter einem Windows XP Wirtsystem zu einem Absturz (BlueScreen mit fw.sys ...) am Ende der Installation. Nach ein paar Abstürzen hintereinander wurde das System wieder stabiler ... nur leider hatte ich keine WLAN-Verbindung mehr. Erst nach einer Rückkehr auf 4.0.0 lief das WLAN wieder und die Bluescreen verschwanden. Auf einem anderen Rechner hatte ich eine laufende/stabile 4.1.8 und ich versuchte leider vergeblich, mein unter 4.0.0 laufendes Image zum Laufen zu bringen. Weder direkt noch über einen Export/Import.

### I/O-Performance

Die "normale virtuelle Plattenperformance" ist ganz ok ... nicht so gut wie nativ aber durchaus so gut, daß ich meine Entwicklungsumgebung innerhalb meine Gast-Linux ohne deutlichen Zeitverlust laufen lassen kann (z. B. auch maven builds die sehr viele Dateien erzeugen und dementsprechend viel I/O-Last erzeugen).

Die I/O-Performance sowohl über Shared Folders als auch über USB 2.0 ist sehr schlecht. Ein paar Beispiele:

- im Zuge meiner GIT-Recherchen habe ich feststellen müssen (siehe hier - Abschnitt Performance), daß ein git status über ein Shared Folder bzw. USB 2.0-Stick 30 Sekunden bzw. 0 -60 Sekunden (sehr schwankend) statt 1 Sekunde.
- ein ``mvn clean install`` auf der "normalen virtuellen Platte" dauerte 2 Minuten - auf einem Shared Folder 11 Minuten.

### USB 2.0

Vorab: hat man einen USB-Stick eingebunden, dann ist er für das Wirtsystem nicht nutzbar. Wer das nicht möchte, sollte den USB-Stick über SharedFolder einbinden.

Für USB 2.0 Support muss man das Extension-Pack installieren, in der VM-Konfiguration USB 2.0 aktivieren und einen Filter einrichten (ohne Filter hat es bei mir nicht funktioniert ... ich bin mir aber nicht ganz sicher, ob es wirklich daran lag, denn ich habe viel rumspielen müssen, um einen USB-Stick einzubinden - hat nicht sofort funktioniert). Nach einem Restart sollte man über das VM-Menü den USB-Stick aktivieren können - es poppt dann ein Fenster hoch.

---

## VMs zwischen Maschinen austauschen

Hierzu gibt es u. a. folgende Möglichkeiten

- VM als Appliance exportieren (z. B. im OVA-Format) und dann importieren
- VM anlegen und nur die Festplatte wiederverwenden 

---

## FAQ

**Frage 1:**

seit 4.3.20 habe ich das Problem, daß ich mein Gastbetriebssystem (Ubuntu 14.04 mit installierten Gast-Erweiterungen) nicht mehr über zwei Bildschirme ziehen kann ... es zieht sich immer wieder auf einem Bildschirm zusammen oder das Fenster ist zwar über zwei Bildschirme gezogen, aber das Gastbetriebssystem nutzt nicht beide Bildschirme (Ränder an den Seiten). Was ist da los?

**Antwort 1:**

Dieses Problem hat mich fast in den Wahnsinn getrieben. Ich war schon drauf und dran downzugraden. Jetzt habe ich einen verlässlichen Weg gefunden:

- Automatische Anpassung der Gastanzeige: ABSCHALTEN
- Fenster über zwei Bildschirme ziehen (rechts und links sind dann weisse Bereiche)
- Automatische Anpassung der Gastanzeige: ANSCHALTEN - dadurch schrumpft das Fenster auf einen Bildschirm zusammen
- Automatische Anpassung der Gastanzeige: ABSCHALTEN
- Fenster über zwei Bildschirme ziehen ... Voila

**Frage 2:**

Meine Images werden nicht mehr im VirtualBox-GUI angezeigt, aber ich habe sie nicht gelöscht. Wie bekomme ich die da wieder rein?

**Antwort 2:**

Mir ist das mal probiert als ich mit Vagrant (mit VirtualBox als Provider) rumgespielt habe. Die .vbox Dateien, in der sich die Konfiguration des Images befindet, war noch vorhanden (``$HOME/VirtualBox VMs/...``) - und die dort eingehangene Festplatte auch.
Durch einen Doppelclick aus dem Windows-Explorer auf die vbox-Datei erscheint das Image auch wieder im GUI.

**Frage 3:**

Wenn ich auf meinem Image NAT eingestellt habe und Port-Forwarding mache, dann komme ich nicht auf den forgewardeten Webserver (http://HOST_IP:FORWARD_PORT/application). Ich habe schon überprüft, ob der forgewardete Port vielleicht nur an das Localhost-Interface gebunden ist ... aber das ist nicht der Fall.

**Antwort 3:**

Ich habe noch keine Antwort gefunden ... mein Workaround ist die Änderung von NAT auf Bridged, so daß das Image eine eigene addressierbare IP hat und ich dann auch mit dem Standardport zugreife: http://IMAGE_IP:80/application.

**Frage 4:**

Ich habe Virtualbox 5.0.20 installiert. Zudem noch das Extension Pack. In meiner Ubuntu 14.04 LTS habe ich die Gästeerweiterungen installiert. Ich bekam zwar den Hinweis, daß die Kernel-Header-Dateien fehlten, aber die Installation klappte ohne Fehlermeldung. Nach dem Neustart war mein Bild aber noch immer in 640 x 480 Auflösung. Das war mir bisher noch nicht untergekommen ... bisher starteten die Maschinen dann immer in einer ordentlichen Auflösung. Wie bekomme ich eine normale Auflösung?

**Antwort 4:**

Mit "Anzeige - Automatische Anpassung der Gastanzeige" hat es funktioniert ... es hat dann aber 3-4 Sekunden gedauert bis die grauen Balken um den Screen weggingen ... puh

**Frage 5:**

Seit dem Update auf 5.0.20 habe ich Probleme mit der Genauigkeit der Maus. Wenn ich einen Test markieren will, dann wird die Zeile drüber markiert. Die Gästeerweiterungen sind installiert und up-to-date. Auch ein Restart des Systems hat nichts gebracht.

**Antwort 5:**

Bei mir hat es geholfen im Menü "Eingabe - Mauszeiger-Integration" kurzzeitig zu aktivieren und wieder zu deaktivieren. Danach war alles gut. Seltsam ... vielleicht ein Initialisierungsproblem???

**Frage 6:**

Ich wollte eine Appliance zwischen zwei Rechnern durch Neuanlage einer VM und Einbinden der Festplatte transportieren. Beim Start der Vm bekomme ich aber einer Fehlermeldung ``Could not find /dev/disk``.

**Antwort 6:**

In meinem Fall hatte ich die Festplatte als SATA-Platte eingebunden ... die Platte war in der alten VM aber als IDE-Platte eingebunden. Nachdem ich sie als IDE-Platte eingebunden habe, hat es einwandfrei funktioniert.

**Frage 6a:**

Ich wollte eine Appliance zwischen zwei Rechnern durch Export und Import transportieren. Beim Start der Vm bekomme ich aber einer Fehlermeldung ``Could not find /dev/disk``.

**Antwort 6a:**

Die Festplatte war korrekt als IDE (statt SATA) eingebunden. Allerdings funktionierte es nicht mit dem VMDK Format. Nach Verwendung der Original-VDI-Datei klappte der Start einwandfrei.

**Frage 7:**

Nach der Installation von VirtualBox 5.1 unter Windows bekomme ich in meinen Linux-Boxen mit UI öffnet sich beim Drücken der Windows-Taste immer das Windows-Start-Menü. Leider verwende ich [awesome](https://awesome.naquadah.org/) als Fenstermanager und dort ist die Windows-Taste als Meta-Key eingestellt.

**Antwort 7:**

Im Menü der Virtualbox-VM muß die Einstellung _Input - Keyboard - Keyboard Settings - Virtual Machine - Auto Capture Keyboard_ angehakt werden.

**Frage 8:**

Wie nutze ich mehrere Bildschirme unter VirtualBox 5.1.x ... ich schaffe das nicht mit den vielen View-Einstellungen?

**Antwort 8:**

In der VM muß die Anzahl der Bildschirme eingestellt werden (http://www.ashokraja.me/tips/How-to-enable-dual-or-multi-monitor-support-in-Oracle-Virtual-Box). Und dann sollte das auch mit den View-Einstellungen irgendwie funktionieren.
Ich konnte den Bildschirm sogar über 3 Bildschirme ziehen ... hierzu hilft es vielleicht - bei unterschiedlicher Größe der Bildschirme - die Bildschirme über die Windows 10 Settings leicht in der Höhe zu verschieben:

![Multiple Screens on Windows](images/windows10_multipleScreens.png)

**Frage 9:**

Einige Programme (z. B. Atom, GitBook Editor) zeigen nur einen schwarzen Bildschirm in meinem Linux-Guest-System.

**Antwort 9:**

Es gibt zwei Lösungsmöglichkeiten:

- Option 1 "zentral": in der VirtualBox-Display-Einstellung der VM die Option *Enable 3D Acceleration* rausnehmen. Achtung: bei einigen Windows-Managern oder Desktop-Environments (z. B. Gnome) wird das System dadurch schnarchlahm (siehe [meine Erfahrungen bei der Inbetriebnahme von Ubuntu 14 LTS](ubuntu_1410_lts.md)). 
- Option 2 "pro Applikation": wenn die Einstellung *Enable 3D Acceleration* in der VM erforderlich ist, dann kann man bei vielen Programmen die Option `--disable-gpu` (z. B. VisualStudio Code) setzen.

**Frage 10:**

Ich muß die Guest-Additions nach einem VirtualBox Update neu installieren. Das Mounten der `VBoxGuestAdditions.iso` über das Menü schlägt mit der kryptischen Fehlermeldung `VERR_PDM_MEDIA_LOCKED` fehl.

**Antwort 10:**

Am einfachsten die `C:\Program Files\VirtualBox\VBoxGuestAdditions.iso` in einem Shared Folder vom Wirtsystem bereitstellen und die Additions per

```bash
sudo bash
mount -o loop ./sf_windowsTransfer/VBoxGuestAdditions.iso /cdrom
./VBoxLinuxAdditions.run
```

installieren.

> Die Alternative `sudo apt-get install virtualbox-guest-additions-iso` installiert meistens nicht die richtige Version (kann man aber sicher mit entsprechendem Paketmanagement lösen)