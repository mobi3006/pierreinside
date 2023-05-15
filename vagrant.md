# Vagrant

Vagrant erlaubt das Skripten von virtualisierten Images (Linux und Windows). Es werden verschiedene Virtualisierungstools unterstützt, u. a. VirtualBox, VmWare, Microsoft Hyper-V. Somit erlaubt es plattformübergreifende Lösungen (Windows, MacOS, Linux).

---

## Getting Started

* [Official Getting Started](https://docs.vagrantup.com/v2/getting-started/index.html)

Vagrant bringt ein CLI (CommandLineInterface) mit. Per

```bash
vagrant init hashicorp/precise32
```

wird ein automatisch ein Vagrant-Projekt angelegt ... um genau zu sein wird ein simples `Vagrantfile` (Textdatei ... gut zum Versionieren) im aktuellen Verzeichnis abgelegt, das die VM-Box `hashicorp/precise32` startet - ansonsten sind die anderen Konfigurationen auskommentiert. Man sieht hier also schon mal eine Reihe nützlicher Konfigurationsmöglichkeiten. Hierin steht die Konfiguration des bei ``vagrant up`` zu erzeugenden Images. In diesem Fall wird das ``Ubuntu 12.04 LTS 32-bit`` Image mit dem Namen ``precise32`` des Users ``hashicorp`` (weitere findet man [hier](https://atlas.hashicorp.com/search)) als Basis referenziert. Über

```bash
vagrant up
```

bei dem folgendes passiert:

* eine neue Instanz des Projekts in Form einer virtuellen Maschine (VirtualBox - der Default-Provider) wird angelegt
  * sieht man dann auch im GUI von VirtualBox
  * hierzu wird die Box ``hashicorp/precise32`` vom öffentlichen Vagrant-Repository runtergeladen ... sofern noch nicht lokal vorhanden (Caching)
    * ACHTUNG: diese Images bestehen häufig aus mehreren Gigabyte)
* Minimalkonfiguration des Guest-Betriebssystems
  * ssh-key erzeugen und in `./.vagrant/foo/bar/private_key` abgelegt ... dieser wird später verwendet, um sich per `vagrant ssh` in die Maschine einzuloggen
  * Port
* das VM-Image wird gestartet
 und in der virtuellen Maschine installiert. Defaultmäßig wird das Netzwerk auf NAT konfiguriert (Virtualbox agiert hier als Router), so daß die Chancen für eine ordentliche Netzwerkanbindung ins Internet recht hoch sind.

Per

```bash
vagrant ssh
```

erhält man einen ssh-connect auf das Image connecten (in den User ``vagrant``). Die Authentifizierung erfolgt über automatisch bei Erstellung des Images erzeugte Zertifikate. Über ``sudo bash`` (bei Ubuntu ist das ``root`` user Passwort unbekannt ... oder gar nicht gesetzt?) bekommt man eine Root-Shell.

Per

```bash
vagrant suspend
```

wird der aktuelle Zustand des Images eingefroren. Per

```bash
vagrant resume
```

wird das Image gestartet und in den alten Zustand gebracht.

> Konvention ``VAGRANT_PROJECT_DIR``:
> im folgenden werde ich den Ordner, aus dem man vagrant up aufruft als VAGRANT_PROJECT_DIR bezeichnen

---

## CLI Kommandos

* https://docs.vagrantup.com/v2/cli/index.html

Hilfe zu einem Kommando:

```bash
vagrant <command> -h
```

### Typische Use-Cases

* ``vagrant box add myimage``
  * veröffentlicht den aktuellen Stand der Vagrant-Instanz, das dann per ``vagrant init myimage; vagrant up`` von anderen als Base-Image verwendet werden
  * siehe auch ``vagrant package``
* ``vagrant destroy``
  * Image löschen - das Vagrantfile wird nicht gelöscht, so daß beim nächsten `vagrant up` eine frische Instanz angelegt wird
    * da ja alles gescriptet ist, sollte man das (von Ausnahmen abgesehen) ohne Probleme tun können - KEINE ANGST
  * letztlich wird
    * ``.vagrant/machines/virtualbox/id`` gelöscht, das die VirtualBox-Instanz referenziert
    * das Image in ``$HOME/VirtualBox VMs`` gelöscht
  * bei Multi-Machine-Projekten kann man auch einzelne Maschinen löschen, z. B. ``vagrant destroy databaseServer``
* ``vagrant halt``
  * sauber runterfahren
  * solange kein anschließendes `vagrant destroy` stattfindet wird der alte Zustand beim nächsten ``vagrant up`` wiederhergestellt
  * bei Multi-Machine-Projekten kann man auch einzelne Maschinen hochfahren, z. B. ``vagrant up databaseServer``
* ``vagrant init``
  * erzeugt ein `Vagrantfile`
  * i. d. R. wird man mit einem Base-Image starten (``vagrant init hashicorp/precise32``), das man dann durch Provisioning erweitert
    * daraus lässt sich dann ein Box-File machen, das anderen für ihr ``vagrant init`` zur Verfügung steht
  * eine Liste öffentlicher Images findet man [hier](https://atlas.hashicorp.com/search)
* ``vagrant global-status``
  * das Ergebnis sieht dann so aus (ACHTUNG: dieser Status is gecacht und könnte veraltet sein):

      > id       name    provider   state    directory
      > ------------------------------------------------------------------------------------------------------
      > 8aeed75  db      virtualbox poweroff C:/Dev/database/tests/main-test/target/vagrant
      > bed23d2  default virtualbox poweroff D:/VirtualBoxImages/test
      > 7e3993a  default virtualbox running  C:/Dev/appserver

  * sehr praktisch, wenn man den Überblick über die verschiedenen Images verloren hat (wobei hier die VirtualBox-GUI auch weiterhilft). DENN: das Image läuft weiter solange man kein ``vagrant halt`` oder ``vagrant destroy`` darauf aufgerufen wird ... unabhängig von der Console, von der man es gestartet hat (deshalb kann man den Überblick auch schon mal verlieren - insbesondere bei Multi-Machine-Images). Irgendwann geht einem dann auch mal der Hauptspeicher aus ...
  * auf diese Weise kann man - ohne grosses Navigieren in die Ordner der Vagrant-Projekte - Maschinen steuern (z. B. ``vagrant halt 5200c28``) - sehr praktisch ist dann auch ``vagrant ssh 5200c28``, ohne erst in den Ordner des Vagrant-Projekts wechseln zu müssen
* ``vagrant list-commands``
  * Übersicht über alle vagrant commands
* ``vagrant package --output=my-env.box``
  * auf diese Weise lässt sich der aktuelle Stand des Images als Base-Images bereitstellen und so wiederverwenden, ohne alle Provisioning-Schritte erneut durchführen zu müssen
  * siehe auch ``vagrant box add``
* ``vagrant provision``
  * Provisioning auf einem laufenden System durchführen
  * bei Multi-Machine-Projekten kann man das Provisioning auch für einzelne Maschinen triggern, z. B. ``vagrant provision databaseServer``
* ``vagrant reload``
  * entspricht ``vagrant halt; vagrant up``
  * bei Multi-Machine-Projekten kann man das Reload auch für einzelne Maschinen triggern, z. B. ``vagrant reload databaseServer``
* ``vagrant resume``
  * eingefrorenen Zustand eines Images wiederherstellen
* ``vagrant ssh``
  * connect to vagrant image via ssh (authentication by certificates - automatically created)
  * bei Multi-Machine-Projekten muss man die Maschine mit angeben, z. B. ``vagrant ssh databaseServer``
* ``vagrant ssh-config``
  * zeigt an, was man in einem ssh-Client (z. B. Putty) konfigurieren müßte, um eine ssh-Verbindung zum Vagrant-Image aufzubauen. Darin befindet sich auch der zu verwendende Private-Key, der bei der Erstellung des Images unter ``.vagrant/.../virtualbox/private_key`` abgelegt wird 
* ``vagrant status``
  * Status der current Machine (in dessen VAGRANT_IMAGE_ROOT_DIR man gerade steht)
* ``vagrant suspend``
  * aktuellen Zustand des Images einfrieren
* ``vagrant up``
  * solange ``VAGRANT_PROJECT_DIR/.vagrant/machines/default/virtualbox/id`` eistiert und nicht leer ist, wird keine neue Installation (Base-Image, Provisioning, ...) angestoßen, sondern der aktuelle Zustand wiederverwendet. Will man neu aufsetzen, so sollte man ``vagrant destroy; vagrant up`` verwenden. 
  * OPTION: --no-provision
    * beim testen meiner Provisioning-Skripte hat sich diese Option bewährt, weil ich dadurch das Provisioning selbst per Skript starten konnte. Leider kann man das Provisioning nämlich bei ``vagrant up`` nicht mehr abbrechen (z. B. in einer Endlosschleife ... die man immer mal braucht, um zu prüfen, ob ein Service hochgefahren ist).

---

## Vagrantfile

Die Datei ``${VAGRANT_PROJECT_DIR}/Vagrantfile`` definiert den Aufbau und die Konfiguration des Images. Hieraus kann jederzeit ein frisches Image erstellt werden (zumindest wenn man es ordentlich gescriptet hat). Diese Datei sollte unter version-control stehen. Die Datei kann leicht geshared werden, um auf anderen Rechnern den definierten Zustand aufzubauen.

> ACHTUNG: komplexere Solutions benötigen i. d. R. weitere Dateien fürs Provisioning (Ansible-Skripte, Shell-Skripte, Konfigurationsdateien, ...), die auch benötigt werden und unter version-control stehen müssen.

### Konfiguration der VM mit VirtualBox als Provider

Hier kann man viele Parameter setzen - diese Parameter sind providerabhängig (z. B. Virtualbox, VmWare).

Die prinzipielles Strunktur ist folgendermassen:

    config.vm.define "BACKEND", primary: true do |backend|
        backend.vm.box = "centos7-64bit-base"
        ...
        config.vm.provider "virtualbox" do |v|
            v.customize [
                "modifyvm", :id,
                "--memory", 4000,
                "--cpuexecutioncap", "10"
            ]
    end

Als Parameter kann man diese verwenden: http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm

### Parametrisierung des Provisionings

Es können Parameter an Provisioning-Shell-Skripte übergeben werden:

    options = {}
    options[:assembly_name] = ENV['ASSEMBLY_NAME'] || 'project-stock-4.0.tar.gz'
    options[:tomcat_name] = ENV['TOMCAT_NAME'] || 'apache-tomcat-7.0.59'
    options[:domain_name] = ENV['DOMAIN_NAME'] || 'cachaca.de'

    Vagrant.configure(2) do |config|
            ...
            myimage.vm.provision "shell",
                path: "direct/scripts/setup-DirectRIv4.sh",
                :args =>
                    options[:assembly_name].to_s + " " +
                    options[:tomcat_name].to_s + " " +
                    options[:domain_name].to_s,
                privileged: true
            ...

Im Shellskript wird auf diese Parameter wie üblich zugegriffen (${1}, ${2}, ${3}). Das macht insbesondere bei Multi-Machine-Projects und bei dynamischen Vagranfiles (die sich beispielsweise durch Umgebungsvariablen anpassen lassen ) Sinn.

---

## Background Informationen

* das erzeugte VirtualBox-Image wird im Standard Verzeichnis von VirtualBox für Images abgelegt ... unter Windows ist das: ``${HOME}\VirtualBox VMs``
* über die VirtualBox Oberfläche ist das Image auch sichtbar (dort sind viele Zahlen drin: z. B. ``Mu2CertificationTools_default_1433340495394_70941``) ... aber ACHTUNG: besser man startet/stoppt das Image über das Vagrant-CLI, sonst kann das zu Seiteneffekten führen. Beim Starten des Images über das CLI wird kein Fenster für das Image gestartet (im Gegensatz zu einem Start - NICHT EMPFOHLEN - über das VirtualBox-GUI).

### Filesystem

So siehts auf dem Filesystem aus:

    VAGRANT_PROJECT_DIR/
        .vagrant/
            machines/
                default/
                    virtualbox/
                        id: referenziert die UUID der VirtualBox-VM
                        private_key: ssh private key
                        synced_folders: 
                          welche Verzeichnisse werden 
                          zwischen Wirt und Gast
                          synchron gehalten
        Vagrantfile
    ~/.vagrant.d/
        boxes/: hier liegen die Base-Images
        data/:
        gems/: Code/Module für Vagrant
        rgloader/:
        tmp/:

Bei der Verwendung von Virtualbox als Provider wird man noch folgende Struktur finden:

    ~/.VirtualBox VMs/: 
      hier wird Vagrant die Konfiguration und
      Festplatten-Files der Images ablegen
        vagrant_foo
        ...

---

## SSH

Bei der Erzeugung des Images per ``vagrant up`` werden von Vagrant i. d. R. Public/Private-Keys für den ssh-Connect erzeugt (hier für die Maschine INBOUND):

    ==> INBOUND: Waiting for machine to boot. This may take a few minutes...
        INBOUND: SSH address: 127.0.0.1:2222
        INBOUND: SSH username: vagrant
        INBOUND: SSH auth method: private key
        INBOUND:
        INBOUND: Vagrant insecure key detected. Vagrant will automatically replace
        INBOUND: this with a newly generated keypair for better security.
        INBOUND:
        INBOUND: Inserting generated public key within guest...
        INBOUND: Removing insecure key from the guest if it's present...
        INBOUND: Key inserted! Disconnecting and reconnecting using new SSH key...

Nach dem Start kann per

```bash
vagrant ssh
```

eine ssh-Verbindung aufgebaut werden. Voraussetzung dafür ist allerdings, daß ein CLI-ssh-Client verfügbar ist. Ich verwende unter Windows beispielsweise [cygwin](cygwin.md)/[babun](babun.md) als Command-Line-Tool, die dafür entsprechende Pakete haben.

Soll ein anderer SSH-Client (z. B. Putty) verwendet werden, so liefert

```bash
vagrant ssh-config
```

die notwendigen Informationen für den Zugriff (hier bei einem Multi-Machine-Setup ... Zugriff auf die Maschine ``MANAGEMENT``):

    $ vagrant ssh-config MANAGEMENT
    Host MANAGEMENT
      HostName 127.0.0.1
      User vagrant
      Port 2201
      UserKnownHostsFile /dev/null
      StrictHostKeyChecking no
      PasswordAuthentication no
      IdentityFile C:/src/mysolution
        /target/vagrant/.vagrant/machines/
          MANAGEMENT/virtualbox/private_key
      IdentitiesOnly yes
      LogLevel FATAL

### SSH-Keys

Vagrant erzeugt beim Image-Start auch gleich SSH-Keys. Der Private-Key wird z. B. unter

    .vagrant/.../virtualbox/private_key

abgelegt. Der Public-Key steht im erzeugten System unter ``/home/vagrant/.ssh/authorized_keys``, so daß ein ``vagrant ssh`` (macht eine Verbindung mit dem User ``vagrant`` auf) ohne Passwortabfrage erfolgt.

> Ich habe es mir zur Angewohnheit gemacht (mit [Ansible gescriptet](ansible.md)), 
> * den Inhalt von ``authorized_keys`` nach dem Bootstrapping unter ``/home/vagrant/.ssh/id_rsa.pub`` abzulegen
> * ``.vagrant/.../virtualbox/private_key`` (vom Host-System) unter ``/home/vagrant/.ssh/id_rsa`` (im Gastsystem) abzulegen

---

## Synced Folders

Per Default wird das ``VAGRANT_PROJECT_DIR`` im Linux-Image unter ``/vagrant`` als Synced-Folder eingebunden (read/write) - Achtung: der Zugriff kann je nach Vagrant-Virtualisierungsprovider (daraus leitet sich das Verfahren ab) recht langsam sein. Das vereinfacht der Datenaustausch, der vor allem dann wichtig ist, wenn das Image from-scratch aufgebaut und dann per custom-scripts angepaßt werden soll. Mit VirtualBox als Provider sind Synced-Folders über Shared-Folders abgebildet (ACHTUNG: langsam in 2014 - in 2021 akzeptable Performance ... auch bei intensiven IO-Arbeiten wie Maven-Builds), so daß Änderungen automatisch sofort sichtbar sind (das ist bei anderen Virtualisierungsprovidern wie VMWare evtl. nicht so ... vielleicht wird dort rsync o. ä. verwendet).

Mit

    Vagrant.configure(2) do |config|
        config.vm.synced_folder "src", "/src"
    end

kann man weitere SyncedFolders definieren - in diesem Fall wird ``VAGRANT_PROJECT/src`` des Wirt-Betriebssystems im Gast-Betriebssystem unter ``/src`` gemounted.

Synced-Folder unterstützt sehr viele Konfigurationsmöglichkeiten ... hier ein Beispiel für eine aufwendigere Konfiguration:

    config.vm.synced_folder 
      "./", 
      "/vagrant", 
      id: "vagrant-root", 
      owner: "vagrant", 
      group: "vagrant", 
      mount_options: ["dmode=755,fmode=755"]

---

## Base Images

Per

    vagrant init hashicorp/precise32

wird das Base-Image precise32 des Users hashicorp für das eigene Vagrant-Projekt verwendet. Beim ersten ``vagrant up`` wird dieses image aus dem Repository (in diesem Fall liegt das irgendwo im Internet) runtergeladen und installiert (ist im Vagrantfile ein ``config.vm.box_check_update = true`` definiert, dann wird bei jedem ``vagrant up`` auf ein Update des Box-Files im Repository geprüft). All nachfolgenden Starts eines neuen Projekts, das auf diesem Base-Image basiert, können die lokal gespeicherte Version verwenden. Die Base-Images (= Box-Datei) werden defaultmäßig lokal unter ``$HOME/.vagrant.d/boxes`` abgelegt - bzw. dort wo die Umgebungsvariable ``VAGRANT_HOME`` hinzeigt - http://docs.vagrantup.com/v2/other/environmental-variables.html). Sollte das Image auf dem Remote-Server erneuert worden sein wird es erneut runtergeladen (diese automatische Update-Funktion lässt sich aber natürlich deaktivieren - ``config.vm.box_check_update``). Dadurch dauert i. d. R. nur der erster Start um einiges länger.

Base-Images sind auf den Virtualisierungsprovider zugeschnitten ... man kann also kein VirtualBox-Base-Image mit einem VMWare-Provider verwenden. Über ``vagrant up --provider=vmware_fusion`` kann man explizit den Provider angeben, wenn nicht der Default-Provider verwendet werdenn soll. Man kann aber auch den Default-Provider (per Default VirtualBox) umdefinieren.

Man kann eigene Base Images veröffentlichen (public oder private) ... siehe unten.

---

## Netzwerk

* [Vagrant Dokumentation - Netzwerk](https://docs.vagrantup.com/v2/networking/)
* [Parallels Dokumentation - Netzwerk](https://kb.parallels.com/4948#section3)
* [Thomas Krenn - Virtualbox](https://www.thomas-krenn.com/de/wiki/Netzwerkkonfiguration_in_VirtualBox)

In Vagrant kann man im Vagrantfile ein oder mehrere Netzwerke definieren.

[Minimalanforderung für Vagrant](https://developer.hashicorp.com/vagrant/docs/networking) ist ein Shared-Network (= NAT-Network):

```
Vagrant assumes there is an available NAT device on eth0. This ensures that Vagrant always has a way of communicating with the guest machine. It is possible to change this manually (outside of Vagrant), however, this may lead to inconsistent behavior. Providers might have additional assumptions. For example, in VirtualBox, this assumption means that network adapter 1 is a NAT device.
```

Die Box bekommt dann entsprechend viele virtuelle Netzwerkkarten, die jeweils an ein Netzwerk gebunden sind. Vagrant kümmert i. a. sich um die korrekte Einbindung der Interfaces ins Gastbetriebssystem - es sein denn man schaltet das explizit per `auto_config: false` aus.

### Netzwerktypen

* NAT Network
  * hier wird ein virtuelles Netzwerk vom Hypervisior bereitgestellt, das dann aber über das Host-System routet
* Bridged Network
  * hier wird kein virtuelles Netzwerk (bereitgestellt durch den Hypervisior) verwendet
  * die VM hängt direkt im gleichen Netzwerk wie das Host-System (bei DHCP bekommt es die IP-Adresse genauso wie das Hostsystem vom Router zugewiesen)
  * hier definiert man auch welchen physikalischen Netzwerkadapter man verwendet (Netzwerkkabel oder Wifi)
* Host-Only Network

### Private Netzwerke

Solche Netzwerke sind von ausserhalb des Gastbetriebssysstem nicht oder zumindest nicht direkt (sondern nur per Port-Forwarding erreichbar über das Hostbetriebssystem), weil sie IP-Adressen verwenden, die nicht im Internet geroutet werden (weil sie privat sind). Der Hypervisor stellt ein virtuelles Subnetz für die VMs zur verfügung und fungiert als Router zwischen diesem Subnetz und dem Netzwerk des Host-Betriebssystems. Auf diese Weise erhält das Gastbetriebssystem Zugriff aufs Internet (über NAT). Der Hypervisor fungiert als Switch zu anderen virtuellen Images des gleichen privaten Netzwerks.

Hier ein paar Beispiele:

    Vagrant.configure("2") do |config|
      config.vm.network "private_network", type: "dhcp"
    end

    Vagrant.configure("2") do |config|
      config.vm.network "private_network", ip: "192.168.50.4"
    end

Konfiguriert man nur ein einziges private_network (``config.vm.network "private_network", ip: "192.168.50.4"``), so wird scheinbar zusätzlich zum Shared-NAT-Network ein Host-Only-Interface angelegt, das dann aber ein anderes Subnetz verwendet ... oder ist das nur in meinem Base-Image so (kann das sein, daß es vom Base-Image kommt?):

    [root@pep vagrant]# ifconfig
      enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
      inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
      inet6 fe80::a00:27ff:fe6d:6c73  prefixlen 64  scopeid 0x20<link>
      ether 08:00:27:6d:6c:73  txqueuelen 1000  (Ethernet)
      RX packets 902  bytes 98689 (96.3 KiB)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 648  bytes 90462 (88.3 KiB)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

      enp0s8: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
      inet 192.168.1.13  netmask 255.255.255.0  broadcast 192.168.1.255
      inet6 fe80::a00:27ff:fe41:bf8c  prefixlen 64  scopeid 0x20<link>
      ether 08:00:27:41:bf:8c  txqueuelen 1000  (Ethernet)
      RX packets 17  bytes 1771 (1.7 KiB)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 48  bytes 6534 (6.3 KiB)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

      lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
      inet 127.0.0.1  netmask 255.0.0.0
      inet6 ::1  prefixlen 128  scopeid 0x10<host>
      loop  txqueuelen 0  (Local Loopback)
      RX packets 0  bytes 0 (0.0 B)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 0  bytes 0 (0.0 B)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    [root@pep vagrant]# route
      Kernel IP routing table
      Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
      default         localhost       0.0.0.0         UG    1024   0        0 enp0s3
      10.0.2.0        0.0.0.0         255.255.255.0   U     0      0        0 enp0s3
      link-local      0.0.0.0         255.255.0.0     U     1003   0        0 enp0s8
      192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 enp0s8

### Public Netzwerke

Solche Netzwerke erhalten eine statische oder dynamische IP-Adresse und verstecken sich nicht hinter dem Software-Router (bereitgestellt durch den Hypervisor als virtualles Subnet), sondern sind direkt - ohne Portforwarding - erreichbar. Da Vagrant unsichere SSH-Keys verwendet kann man sich relativ leicht Zugriff auf eine Vagrant-Box mit Public-Network verschaffen ... aus diesem Grund sollte man sich das gut überlegen.

Unter VirtualBox und Parallels als Provider entsprechen PublicNetworks dem Bridged-Mode.

Hier ein paar Beispiele:

    Vagrant.configure("2") do |config|
      config.vm.network "public_network"
    end

    Vagrant.configure("2") do |config|
      config.vm.network "public_network", ip: "192.168.0.17"
    end

---

## Provisioning

* https://docs.vagrantup.com/v2/provisioning/index.html

Hiermit lassen sich die Base-Images an die eigenen Bedürfnisse anpassen. Defaultmäßig läuft das Provisioning nur, wenn ein neues Image erstellt wird ... nicht wenn ein vorhandenes neu gestartet oder resumed wird. Man kann das Provisioning aber auch explizit triggern (``vagrant up --provision, vagrant provision``).

### Tools

* [Ansible](ansible.md)
* [Salt](saltstack.md)
* Shell-Scripting
* Puppet
* CFEngine
* Chef
* Docker: um Docker-Images im Image zu installieren/konfigurieren/starten
* ... stetig wachsend

### Shell-Scripting

Beispielsweise so:

    Vagrant.configure("2") do |config|
      # ... other configuration
      config.vm.provision "shell", inline: "echo hello"
    end

Hier sollte man folgendes:

* per Default läuft das Script im privileged-Mode ab - kann man per privileged-Attribut abschalten ... dann läuft es mit dem User vagrant
* im privileged-Mode ist das aktuelle Verzeichnis ``/home/vagrant`` und nicht das Home-Verzeichnis des root-Users. Allerdings bin ich ein Freund von absoluten Pfaden beim Scripten und vermeide cd u. ä..

### Ansible

[siehe eigenes Kapitel](ansible.md)

---

## Multi-Machine-Projects

* https://docs.vagrantup.com/v2/multi-machine/index.html

Mit EINEM Vagrantfile kann man mehrere virtuelle Maschinen (die sog. mit unterschiedlichen Providern betrieben werden, z. B. VirtualBox und VMWare) starten. Auf diese Weise lassen sich komplexe Szenarien aus wiederverwendbaren Images aufbauen.

Im Vagrantfile verwendet man hierzu

    config.vm.define "Machine1" do |m1|
        m1.vm.box = "centos7-64bit-base"
        ...
    end

Die Konfigurationsparameter werden also mit einem Prefix versehen, das die Maschine identifiziert.

Bei den Vagrant-Kommandos muss dann i. a. auch ein Maschinenname mit angegeben werden (hierzu kann man auch reguläre Ausdrücke verwenden)

    vagrant ssh machine1

Bei einem

    vagrant up

auf einem Multi-Machine (also ohne Angabe eines Maschinennamens) werden alle Images gestartet.

### Parallelisierung

Bei komplexen Systemen kann man Zeit einsparen, wenn man die Maschinen - sofern das möglich ist aufgrund von Abhängigkeiten untereinander - parallel hochzieht. Bei heutigen Multicore-Prozessoren ist das prinzipiell möglich und bringt eine Menge (ich konnte dadurch in einem Projekt die Deployzeit von 50 Minuten auf 20 Minuten reduzieren).

Es hängt vom Virtualisierungsprovider ab, ob eine solche Parallelisierung out-of-the-box unterstützt wird oder nicht. Wenn es der Provider zulässt, so kann man es per

    vagrant up --parallel

einschalten.

Sollten Abhängigkeiten zwischen den Maschinen existieren, muß man die in der Provisioning-Logik lösen (beispielsweise warten bis ein Service bereitsteht oder Provisioning-Steps ganz ans Ende stellen).

VirtualBox unterstützt derzeit (4.3.x) keine Parallelisierung... wir haben uns mit einem Shellscript geholfen, das die Maschinen nacheinander anlegt und das Provisioning anschließend parallel fährt. Hier ist ein gutes Beispiel dafür: http://www.joemiller.me/2012/04/26/speeding-up-vagrant-with-parallel-provisioning/
mehr als nur VirtualBox ... andere Provider

Als sog. Provider der Virtualisierung kann man neben VrtualBox (das ist der Vagrant-Default) auch noch andere verwenden:

    VMWare: im Vergleich zu VirtualBox noch stabiler und performanter
        https://docs.vagrantup.com/v2/vmware/index.html
        https://www.vagrantup.com/vmware
    Docker
        https://docs.vagrantup.com/v2/docker/index.html
    AWS EC2
    Hyper-V (von Microsoft)
        https://docs.vagrantup.com/v2/hyperv/index.html

Um einen anderen Provider als VirtualBox zu verwenden, muß man das Vagrant Plugin System (https://docs.vagrantup.com/v2/plugins/index.html) verwenden.

---

## Plugins

Für Vagrant gibt es eine Reihe nützlicher Plugins: http://vagrant-lists.github.io/plugins.html

### Snapshot-Plugin

* https://github.com/dergachev/vagrant-vbox-snapshot

Installation über

```bash
vagrant plugin install vagrant-vbox-snapshot
```

Dieses praktische Plugin hilft bei der Verwendung von Snapshots (take, list, back, ...). Sehr praktisch, wenn man in den Images rumkonfiguriert und ohne minutenlanges neu-Provisioning neu anzufangen.
Fehlersuche

Die Fehlersuche gestalteten sich bei Vagrant anfangs nicht so komfortabel ... gelegentlich brachen die Deplyoments wegen fehlendem Hauptspeicher oder Netzwerkspeicher ab - LEIDER wurde an der Konsole rein gar nichts angezeigt. Das Image wurde in der VirtualBox-GUI als "angehalten" oder "Guru Meditation" angezeigt.

Ein paar Ansätze:

* über das VirtualBox-GUI bekommt man ein brauchbares Logfile, über das ich dann auch das Problem mit den fehlenden Ressourcen entdeckt habe.
* per ``vagrant up --debug`` kann man Vagrant geschwätziger machen oder eben die Langversion davon: ``export VAGRANT_LOG=debug; vagrant up`` (siehe http://docs.vagrantup.com/v2/other/environmental-variables.html)

### Hostmanager-Plugin

* https://github.com/devopsgroup-io/vagrant-hostmanager

Installation über

```
vagrant plugin install vagrant-hostmanager
```

Mit diesem Plugin kann auf den Guest-Systemen die ``/etc/hosts``-Datei automatisch befüllt werden. Bei Multi-Machine-Projekten ist das sehr praktisch.

### Dnsmasq

* https://github.com/mattes/vagrant-dnsmasq

---

## Box-Datei

Das Provisioning kann bei einem komplexen Image schon mal ein paar Minuten/Stunden dauern. Deshalb macht es manchmal Sinn den aktuellen Zustand nach einem Provisioning in einem Base-Image festzuhalten, damit man das Provisioning nicht immer wieder durchführen muss. Mit

    vagrant box add sprint1503 /home/pierre/sprintBoxes/sprint1503.box

kann ich den aktuellen Stand des Vagrant-Project-Deplyoments wegsichern, um ihn später per

    vagrant init sprint1503

schnell mal wieder lokal zu deployen (eine andere Frage ist hier natürlich, ob jeder selbst tun sollte oder ob man diese Deployments nicht zentral bereitstellen sollte). Das Deployment dauert dann nicht 30 Minuten, sondern nur noch 1 Minute.

### Anwendungsmöglichkeit 1

Ich als Softwareentwickler beispielsweise möchte bei umfangreichen Refactorings gerne den Stand vom letzten Sprintende-Tag (vor meinen Refactorings) anschauen, um zu prüfen, ob ein Problem durch mein Refactoring neu entstanden ist oder vorher schon vorhanden war.

### Anwendungsmöglichkeit 2

Bei schwierigen Problemen hilft es häufig, wenn man den Zeitraum des erstmaligen Auftretens eingrenzen kann. Könnte man schnell den Stand der letzten 3 Sprints wiederherstellen, so würde das schon mal eine gute Eingrenzung ermöglichen.
Push

---

## Push

Hierbei geht es nicht darum fertige Base-Images in ein Repository zu pushen, sondern darum den Code des Vagrant-Projects auf einen anderen Server zu transferieren, um das Projekt dort zu deployen (z. B. für die QA). Das Push muss im Vagrantfile konfiguriert werden - hier gibt man das Ziel oder eben verschiedene Ziele (z. B. staging, production). Mit einem

    vagrant push

oder

    vagrant push staging

wird das Projekt auf einen anderen Server (oder gar einem anderen Provider - z. B. Heroku) kopiert.

### Push-Provider

* Atlas
  * im Vagrantfile wird hierzu das Ziel spezifiziert:

        config.push.define "atlas" do |push|
          push.app = "username/application"
        end

* Heroku
* FTP

```
    config.push.define "ftp" do |push|
      push.host = "ftp.company.com"
      push.username = "username"
      push.password = "mypassword"
    end
```

* Local Exec
  * hier kann man ein Script verwenden, um das Image beispielsweise per SCP auf einen Fileserver zu kopieren

---

## Bewertung

Die Idee, ein ganzes System mit ein paar Zeilen Konfiguration (im Prinzip ists ja ein Einzeler) from-scratch aufzubauen ist wirklich bestechend. Auf diese Weise braucht man keine Angst zu haben, ein System durch falsch-Konfiguration zu zerstören, denn mit dem Vagrantfile (under version control) lässt es sich immer wíeder in den gewünschten validen Zustand zurückbringen. Allerdings muss man dann auch die Disziplin haben, alles zu scripten.

Mit diesem Ansatz ergeben sich viele interessante Einsatzbereiche.

Meine Erfahrungen waren sehr positiv. Wir konnten damit ein sehr komplexes Deployment (Deploymentzeit 50 Minuten ohne Parallelisierung, 30 Minuten mit Parallelisierung) per Multi-Machine-Images abbilden.

---

## Fragen

**Frage 1:** Ich habe ``vagrant suspend`` gemacht, doch bei ``vagrant resume`` wird ein from-scratch-Image erzeugt. Was ist da denn los?

**Antwort 1:** Einige User berichten, daß das unter cygwin gelegentlich passiert (siehe https://github.com/mitchellh/vagrant/issues/1454). Über das VirtualBox-GUI kann man die verschiedenen Instanzen dann auch sehen. Die Lösung besteht darin, daß man in den Vagrant Verwaltungsdaten ``VAGRANT_PROJECT_DIR/.vagrant/machines/default/virtualbox/id`` die richtige Instanz referenzieren muss (http://stackoverflow.com/questions/9434313/how-do-i-associate-a-vagrant-project-directory-with-an-existing-virtualbox-vm). Sollte man die UUID des Images nicht parat habe, dann hilft ein Blick in die VirtualBox-Image-Registry (``$HOME/.VirtualBox/VirtualBox.xml``) oder ein ``VBoxManage.exe list vms`` (über das CLI von VirtualBox).

**Antwort 1a:** Mir ist das mal passiert, weil ich das VirtualBox-GUI verwendet habe, um die Maschine in den Suspend-Modus zu bringen. Nach dem Tip in 1a wurde bei vagrant up folgendes ausgegeben:

    $ vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Resuming suspended VM...
    ==> default: Booting VM...
    ==> default: Waiting for machine to boot. This may take a few minutes...
    The guest machine entered an invalid state while waiting for it
    to boot. Valid states are 'restoring, running'. The machine is in the
    'saved' state. Please verify everything is configured
    properly and try again.

    If the provider you're using has a GUI that comes with it,
    it is often helpful to open that and watch the machine, since the
    GUI often has more helpful error messages than Vagrant can retrieve.
    For example, if you're using VirtualBox, run `vagrant up` while the
    VirtualBox GUI is open.

Letztlich habe ich keine Lösung gefunden ... aber die Erkenntnis gewonnen, daß man Vagrant-Images besser über CLI verwaltet als über das VirtualBox-GUI.

**Frage 2:** Manchmal hält meine Maschine beim Provisioning innerhalb eines ``vagrant up`` einfach kommentarlos an ... der Prozess wird nicht beendet und ich sehe das Log, an dem sich nichts mehr tut.

**Antwort 2:** Bisher handelte es sich dann um fehlenden Hauptspeicher ... konnte ich dann in der Virtualbox-GUI sehen "Zeige Log ...": 

> Unable to allocate and lock memory. The virtual machine will be paused. Please close applications to free up memory or close the VM"

**Frage 3:** Das Provisioning lässt sich nicht mehr stoppen - selbst nach eine Ctrl-C läuft es weiter. Was kann ich tun?

**Antwort 3:** Bisher halte ich das Image über das VirtualBox-GUI an ... es sollte aber auch möglich sein, über eine separate Command-Line ein ``vagrant halt`` abzusetzen.

**Frage 4:** Vagrant erzeugt und startet ein neues VirtualBox-Image, aber es wird gar nicht im VirtualBox-GUI angezeigt. Und die VMs werden auch nicht in ``~/VirtualBox VMs`` angelegt, sondern irgendwo anders ... aber wo - ich sehe nur, daß Festplattenspeicher verbraten wird? Mit ``vagrant destroy -f`` verschwinden die Images auch (zumindest wird wieder Festplattenspeicher freigegeben).

**Anwort 4:** Daß die Images nicht in der VirtualBox-GUI angezeigt werden, liegt vermutlich daran, daß sie nicht in ``~/VirtualBox VMs`` angelegt werden. Zunächst muss man mal rausfinden, wo die Metadaten und - vor allem - die Festplatten der Images angelegt werden. Hier ein paar Optionen:

* Option 0: VBoxManage list systemproperties - gibt vielleicht den Ordner an
* Option 1: Wenn das Image läuft, dann findet man das am leichtesten mit dem ProcessExplorer raus. Man muss allerdings den passenden VirtualBox-Prozess finden. Hierzu am besten mal alle anderen VirtualBox-Images runterfahren, um die Auswahl schon mal einzuschränken. Dann wird schaut man sich die Filehandles oder die Parameters des Executable an.
* Option 2: auf der gesamten Festplatte nach "VirtualBox VMs" zu suchen.

Ich hatte das Problem beispielsweise, wenn ich mich per SSH auf meine Windows-Maschine verbunden habe und dann per Vagrant Images gestartet habe ... diese wurden dann seltsamerweise in ``C:\Windows\System32\config\systemprofile\VirtualBox VMs`` abgelegt (dieses Problem wurde auch hier diskutiert: https://forums.virtualbox.org/viewtopic.php?f=6&t=55522).

**Frage 5:** Wie bekomme ich Vagrant dazu die VirtualBox-Images in ``~/VirtualBox VMs`` abzulegen, wenn ich mich per ssh auf das Windows-Image verbinde?

**Antwort 5:** Ich habe den in http://superuser.com/questions/721371/how-to-run-a-virtualbox-vm-on-windows-through-ssh diskutierten Workaround verwendet:

      mklink /J "C:\Windows\System32\config\systemprofile\VirtualBox VMs"
        "C:\Users\pierre\VirtualBox VMs"

Zudem muss man sicherstellen, daß in ``~/.VirtualBox/VirtualBox.xml`` dieser Eintrag drin ist:

    <SystemProperties defaultMachineFolder="C:\Users\pierre\VirtualBox VMs"

Das sollte man durch folgenden Aufruf erreichen (ACHTUNG: unbedingt einen Windows-Pfad angeben - keinen cygwin Pfad!!!):

    VBoxManage.exe setproperty machinefolder "C:\Users\pierre\VirtualBox VMs"

**Frage 6:** Ich habe mit Vagrant über ssh eine VirtualBox-Image erzeugt, doch wird es nicht im VirtualBox-GUI angezeigt. Wenn ich das aber nicht über ssh mache, sondern direkt auf dem Rechner, dann ist das Image sichtbar.

**Antwort 6:** Letztlich muss ein Image in ``~/.VirtualBox/VirtualBox.xml`` eingetragen sein, um im VirtualBox-GUI sichtbar zu sein (probiers mal aus, einfach mal nur eine Maschine aus ``~/VirtualBox VMs`` zu kopieren ... sie wird nicht im GUI zu sehen sein).
Die Frage ist also warum die Maschine nicht unter MachineRegistry registriert wird, wenn man über ssh verbunden ist.

**Frage 7:** Mein Vagrant-Projekt fährt nicht mehr hoch - ich bekomme die Fehlermeldung "VM must be created before running this command. Run `vagrant up` first." - was kann passiert sein?

**Antwort 7:** Mir ist es immer wieder mal passiert (VirtualBox 4.3.x), daß die Verbindung zwischen Vagrant und VirtualBox-Images abgerissen war. Diese Verbindung liegt in ``VAGRANT_PROJECT/.vagrant/machines`` ... in meinem Fall waren diese Verzeichnisse leer, aber die VirtualBox-Images waren weiter vorhanden (in ``~/VirtualBox VMs``). Passiert ist das beispielsweise nach einem Systemabsturz bei laufenden Images ... Problem ist, daß die Images dann noch (viel) Platz wegnehmen aber durch Vagrant-Mitteln (vagrant destroy) nicht mehr gelöscht werden können. Hier hilft dann nur die VirtualBox-GUI (blöd nur, wenn die Images dort nicht angezeigt werden - siehe Frage 6) oder der Dateiexplorer.

**Frage 8:** Ich bekomme eine ganz komische Fehlermeldung bei ``vagrant up`` - ich kann nichts damit anfangen.

**Antwort 8:** Vielleicht hilft ein Blick in das Log von Virtualbox (ich hatte schon desöfteren, daß dort gute Hinweise standen ... z. B. zu wenig Hauptspeicher auf dem Hostsystem, Festplatte des Hostsystems voll).Wenn gar nichts mehr geht:

* ``$VAGRANT_PROJECT/.vagrant`` löschen
* ``~/VirtualBox VMs/vagrant_foo`` löschen (ACHTUNG: keine Images löschen, die noch gebraucht werden)
* alle Vagrant-Prozesse killen, die relevant sein könnten

**Frage 9:** Seit ich auf VirtualBox 5.0.20 umgestiegen bin habe ich gelegentliche Abbrüche beim Shutdown des Images ("Memory Allocation..."). Wenn ich das Image dann neu starte, dann bleibt er im Consolen-Modus mit einer Fehlermeldung hängen. Ein Restart bringt auch nichts ... immer wieder Consolen-Modus.

**Antwort 9a:** Folgendermaßen kommt man aus der Konsolen-Modus-Schleife raus:
* mit Strg-Alt-1 die virtuelle Console 1 öffnen
* per ``vagrant/vagrant`` anmelden
* zum root werden per ``sudo bash``
* ``shutdown -r 0``

**Frage 10:** Ein `vagrant provision` funktioniert nicht. Es dauerte ewig und gibt dann die Meldung "Vagrant gathered an unknown Ansible versionand falls back on the compatibility mode '1.8'"

**Antwort 10:** Mit einem `vagrant provision --debug` konnte ich den Output schon mal geschwätziger machen und sah dann, daß dort scheinbar das `/home/vagrant/.zshrc` ausgeführt wurde ... doch scheinbar leider nicht in einer ZSH Shell ... `bindkey: command not found`. Es hatte den Anschein als würde das Ansible Skript unter dem User `vagrant` ausgeführt (paßt auch zur Ausgabe von `vagrant ssh-config` passen) und dabei wurden das `/home/vagrant/.zshrc` Skript gezogen (der `vagrant` User hat `zsh` als Default-Shell). Dabei wurde das Kommando `bindkey` (verwendet in `.zshrc`) nicht gefunden.