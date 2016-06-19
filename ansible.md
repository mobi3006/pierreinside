# Ansible

In einem Multimachine-Vagrant-Projekt, das aus 5 verschiedenen Images bestand und dessen Provisioning eine knappe Stunde dauerte, haben wir Shellscripting zum Provisioning eingesetzt. Das hatte einige Vorteile, **aber auch einen ganz entscheidenden Nachteil**: Fehlende Idempotenz.

Bricht das Shellscript nach 20 Minuten Laufzeit mit einem Fehler ab, dann bedeutet das nach Beheben des Fehlers oftmals (wenn man nicht mehrere Minuten in das manuelle Anpassen der Scripte investieren will), daß das Image komplett platt gemacht und neu aufgebaut wird ... also wieder 20 Minuten warten bis man überhaupt wieder so weit ist wie man schon mal war.

---

# Getting Started - Linux-User

* http://docs.ansible.com/ansible/index.html

Ansible kennt das Controller-System und die Zielsysteme. Auf dem Controller-System muß  Ansible installiert werden ... auf den zu verwaltenden Systemen genügt ein SSH-Server und Python.

## Installation auf dem Controller-System
* http://docs.ansible.com/ansible/intro_installation.html

## Konfiguration des Controller-Systems

Die Kommandos aus dem Ansible-Playbook werden später über ssh auf die Zielsysteme übertragen und dort ausgeführt. Um eine scriptgesteuerte Ausführung zu ermöglichen, darf kein Passwort abgefragt werden. Das wird über die Verwendung von Public/Private Keys erreicht. Der Private-Key unterliegt strengster Geheimhaltung 

### SSH-Key erzeugen
* https://wiki.ubuntuusers.de/SSH/

Folgender Befehl erzeugt einen Public-Key und einen Private-Key:

```shell
    ssh-keygen -t rsa -b 4096 -C "info@cachaca.de"
```    
Dabei wird eine Passphrase abgefragt, die man später bei Verwendung des Private-Key eingeben muß. 

### SSH-Agent starten und konfigurieren
Der Private-Key ist durch eine Passphrase geschützt. Da Ansible-Playbooks aber i. d. R. vollautomatisiert im Hintergrund laufen und somit nicht ständig um die Eingabe dieser Passphrase betteln wollen, starten wir einen ssh-agent ...

    eval $(ssh-agent -s)
    
und geben ihm die Passphrase (wird im Speicher gehalten und nicht persistiert)

    ssh-add ~/.ssh/id_rsa
   
### Zielrechner definieren

Die Zielrechner können gruppiert werden - das ist sehr praktisch, wenn man mit einem Befehl gleich mehrere Rechner adressieren möchte.

**Option 1: sytemweit**

Unter ``/etc/ansible/hosts`` müssen die zu verwaltenden Rechner eingetragen werden. Im einfachsten Fall trägt man dort ``localhost`` ein

**Option 2: userspezifisch**

    $ echo "127.0.0.1" > ~/.ansible_hosts
    $ export ANSIBLE_INVENTORY=~/.ansible_hosts

### authorized_keys auf Zielrechnern anpassen

... damit die passwordfreie Authentifizierung auch funktioniert müssen die Public-Keys des Users,

## Das erste Kommando ...
Gib auf allen konfigurierten Zielsystemen den gleichen altbekannten Text aus:

    ansible all -a "/bin/echo hello"

---

# Getting Started - Windows-User

**YOU LOST** ... Ansible wird für Windows nicht unterstützt, d. h. eine Windows-Maschine kann nicht als Ansible-Controller agieren. Evtl. ist die Vagrant-Ansible-Integration vielleicht eine Alternative. 

---

# Wichtige Module

* alle Module: http://docs.ansible.com/ansible/list_of_all_modules.html

---

# Vagrant-Ansible-Integration

## Variante 1: Remote Ansible

* http://docs.ansible.com/ansible/guide_vagrant.html

Der typische Ansible-Ansatz ermöglicht die Ausführung von Kommandos via ssh. Insofern paßt es perfekt in ein Vagrant-Host/Guest-Szenario - der Host sendet via ssh (wird von Vagrant eh schon konfiguriert) die entsprechenden Shell-Kommandos zum Guest. 

Einzige Voraussetzung ist die Installation von Ansible auf dem Host-System. Leider wird diese Einschränkung für Windows-Host-Systeme zum Ausschlußkriterium, denn Ansible wird für Windows nicht unterstützt.

## Variante 2: Local Ansible

In diesem Fall muß Ansible auf dem Guest-System installiert werden. Das erfolgt 

* entweder automatisch durch die Option ``install``:


    config.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "playbook.yml"
       install = true
    end

* oder per Shellscript-Provisioning im Vagrantfile:


    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get install -y ansible
    SHELL


Die Local Ansible Variante hat den Vorteil, daß Ansible auf dem Host-System nicht erst installiert werden muß. Das hat folgende Vorteile:

* das Host-System wird nicht verändert
* die Installation kann komplett vagrant-scriptbasiert erfolgen
* **Windows-Host-Systeme können Ansible-Provisioning verwenden**

---

# Was macht Ansible so angenehm?

* **IDEMPOTENZ**
* Remote-Installationen möglich
* flache Lernkurve, Komplexität überschaubar
  * keine Agenten (Puppet) notwendig, die auf den Zielsystemen installiert sein müssen ... ssh + sudo + python 
  * die Reihenfolge der Taskausführung ist bei Ansible klar definiert (nämlich genau die aus dem Playbook)  
  * nur Push, kein Pull (kann auch als Nachteil gesehen werden)
  * kein interner Dependency Graph und den damit verbundenen Problemen (unsynchronisierte Redundanzen)
* gute Lesbarkeit
  * insbes. für Gelegenheitsanwender (z. B. Entwickler) interessant
* angeblich gute Fehlermeldungen (noch keine eigene Erfahrung damit gemacht)
* guter Support für On-Premise- und Cloud-Deployments
* gute Vagrant-Integration
* Ansible basiert auf Python ... für mich als nicht Ruby (Puppet) Entwickler könnte das Vorteile haben
* Templating basiert auf dem Jinja2-Templating (Subset von Django), mit dem viele Entwickler vertrauter sind

## Vergleich von Alternativen

* https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-overview/
* https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-hands-on-with-ansible/
* ein sehr ausführlicher Vergleich zwischen Ansible und Saltstack: http://ryandlane.com/blog/2014/08/04/moving-away-from-puppet-saltstack-or-ansible/


> "After three years of using Puppet at VMware and Virtual Instruments, the thought of not continuing to use the market leader in configuration management tools seemed like a radical idea when it was first suggested to me. After spending several weeks researching Ansible and using it hands-on, I came to the conclusion that Ansible is a perfectly viable alternative to Puppet. I tend to agree with Lyft’s conclusion that if you have a centralized Ops team in change of deployments then they can own a Puppet codebase. On the other hand if you want more wide-spread ownership of your configuration management scripts, a tool with a shallower learning curve like Ansible is a better choice." (*Dan Tehranian's Blog*, https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-hands-on-with-ansible/)

## Vorteile des Shellscriptings

Ganz ohne Frage ... Shellscripting hat ein paar Vorteile:

* ganz dicht am manuellen Aufsetzen - klar Scripting bedeutet dann oftmals auch, daß eine gewisse Art von Konfigurierbarkeit in die Scripte eingebaut wird, um sie an bestimmte Umgebungen anzupassen. Verzichtet man aber auf die Konfigurierbarkeit, dann genügt es, die für eine manuelle Installation/Konfiguration eines System erforderlichen Befehle, in eine Shelldatei zu packen. Viola :-)
* kein weiteres Layer zwischen den Befehlen und dem System ... ich bin mir aber nicht sicher, ob das wirklich ein Vorteil ist, denn Fehlersuche in Shellscripten ist wirklich alles andere als eine Freude ... insbes. aufgrund der fehlenden Idempotenz

---

# Was kann man von Ansible nicht erwarten?
* Abstraktion vom Package-Manager ... es gibt beispielsweise die Ansible-Module ``apt`` und ``yum`` (Puppet beispielsweise abstrahiert hier) ... keine Ahnung ob das von Vorteil oder Nachteil ist ...

> Configuration management abstractions generally lead to complicated, convoluted and difficult to understand code. (http://ryandlane.com/blog/2014/08/04/moving-away-from-puppet-saltstack-or-ansible/)


* Dry-Run-Mode zum Testen von Scripten ... mittlerweile gibt es das aber wohl: http://docs.ansible.com/ansible/playbooks_checkmode.html

---

