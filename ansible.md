# Ansible

Ansible wird zum automatisierten Provisioning von Systemen eingesetzt.

In einem Multimachine-Vagrant-Projekt, das aus 5 verschiedenen Images bestand und dessen Provisioning eine knappe Stunde dauerte, haben wir Shellscripting zum Provisioning eingesetzt. Das hatte einige Vorteile, **aber auch einen ganz entscheidenden Nachteil**: Fehlende Idempotenz.

Bricht das Shellscript nach 20 Minuten Laufzeit mit einem Fehler ab, dann bedeutet das nach Beheben des Fehlers oftmals (wenn man nicht mehrere Minuten in das manuelle Anpassen der Scripte investieren will), daß das Image komplett platt gemacht und neu aufgebaut wird ... also wieder 20 Minuten warten bis man überhaupt wieder so weit ist wie man schon mal war.

---

# Linux-Host: Getting Started ...
* http://docs.ansible.com/ansible/index.html

## Controller-Konzept
Ansible kennt das Controller-System und die Zielsysteme. Software-Voraussetzungen:

* Controller-System:
  * Ansible installiert (und Python)
  * ssh client installiert und passwortlose Authentifizierung möglich
* Zielsystem:
  *  SSH-Server installiert und Passwortlose Authentifizierung über Public-Private-Key möglich ... [näheres siehe Abschnitt ssh](ssh.md)
  *  Python installiert

## Installation auf dem Controller-System
* http://docs.ansible.com/ansible/intro_installation.html

## Konfiguration des Controller-Systems
Die Kommandos aus dem Ansible-Playbook werden später über ssh auf die Zielsysteme übertragen und dort ausgeführt. Um eine scriptgesteuerte Ausführung zu ermöglichen, darf kein Passwort abgefragt werden. Das wird über die Verwendung von Public/Private Keys erreicht. Der Private-Key unterliegt strengster Geheimhaltung 

### SSH-Key erzeugen
[siehe separate Seite](ssh.md)

### Zielrechner definieren (Inventory File)
Die Zielrechner können gruppiert werden - das ist sehr praktisch, wenn man mit einem Befehl gleich mehrere Rechner adressieren möchte.

**Option 1: sytemweit**

Unter ``/etc/ansible/hosts`` müssen die zu verwaltenden Rechner eingetragen werden. Im einfachsten Fall trägt man dort ``localhost`` ein

**Option 2: userspezifisch**

    $ echo "127.0.0.1" > ~/.ansible_hosts
    $ export ANSIBLE_INVENTORY=~/.ansible_hosts

### authorized_keys auf Zielrechnern anpassen

... damit die passwortfreie Authentifizierung funktioniert muß der Public-Keys des Users auf dem Controller-Rechner in die ``~/.ssh/authorized_keys`` auf dem Zielrechner für den Zielnutzer aufgenommen werden. Ansonsten bekommt wird ein Fehler dieser Art ausgegeben:

    localhost | UNREACHABLE! => {
        "changed": false, 
        "msg": "ERROR! SSH encountered an unknown error during the connection. 
          We recommend you re-run the command using -vvvv, which will enable 
          SSH debugging output to help diagnose the issue", 
    "unreachable": true
    }
    
**ACHTUNG:** Will man später Tasks als User ``root`` durchführen (``remote_user: root``), so muß der Public-Key in ``/root/.ssh/authorized_keys`` eingetragen werden.

## Das erste Kommando ...
Gib auf allen konfigurierten Zielsystemen den gleichen altbekannten Text aus:

    ansible all -a "/bin/echo hello"

Damit kann getestet werden, ob Ansible und die System-Konfiguration (ssh-keys, ssh-agent) funktionieren.

**ACHTUNG:** sollte der ssh-agent nicht laufen und der Private-SSH-Key mit einer Passphrase geschützt sein, so wird interaktiv nach der Passphrase gefragt. Das widerspricht eigentlich der Ansible-Idee einer Vollautomatisierung ... der SSH-Agent löst dieses Problem.  

## Das erste Playbook (= Skript) ...
Die Skipte heißen bei Ansible Playbook. Das folgende Ansible-Playbook (``myplaybook.yml``)

```
---
- hosts: localhost
  remote_user: root
  tasks:
  - name: install midnight commander
    package: name=mc state=latest
    remote_user: root
```

wird per ``ansible-playbook myplaybook.yml`` ausgeführt und installiert das Paket *Midnight Commander*. Wenn es nicht funktionieren sollte, die Option ``-vvv`` bzw. ``-vvvv`` macht Ansible ein wenig geschwätziger.

--- 

# Windows-Host: Getting started ...
Windows-User werden von RedHat (dem Ansible-Sponsor)  derzeit nicht unterstützt ... ein Windows-System ist weder als Zielsystem noch als Controller offiziell vorgesehen.

Es gibt dennoch ein paar Ansätze, unter einem Windows-Host Linux-Zielsysteme zu steuern.

## cygwin + ansible_remote
* https://www.azavea.com/blog/2014/10/30/running-vagrant-with-ansible-provisioning-on-windows/

Bei diesem Ansatz wird der Python-Paketmanager (``pip``) verwendet, um das ``ansible`` Paket zu installieren.

Sicherstellen, daß die Umgebungsvariablen in cygwin/babun gesetzt sind:

    export PYTHONHOME=/usr
    export PYTHONPATH=/usr/lib/python2.7

[Cygwin](cygwin.md)/[Babun](babun.md) werden durch Installation folgender Pakete vorbereitet (hier mittels Babuns Paketmanager ``pact``):

    pact install 
      python 
      python-paramiko 
      python-crypto 
      gcc-g++ 
      wget 
      openssh 
      python-setuptools

Python Paketmanager (``pip``) installieren  

    python /usr/lib/python2.7/site-packages/easy_install.py pip
    
und anschließend das Ansible-Paket

    pip install ansible

Danach muß ``ansible-playbook`` noch in ``$PATH`` aufgenommen werden. 

## Vagrant: Option ansible_remote
Könnte ansible_remote auch klappen, wenn cygwin+ansible_remote klappt? 

## Vagrant: Option ansible_local
Vagrant unterstützt neben dem normalen ``ansible``-Provider auch den sog. ``ansible_local``-Provider.

In diesem Fall muß Ansible auf dem Guest-System (= Linux-System) installiert werden. Das erfolgt 

* entweder automatisch durch die Option ``install`` (ACHTUNG: funktioniert nicht mit Vagrant 1.8.1 ... https://github.com/mitchellh/vagrant/issues/6858):


    config.vm.provision "ansible_local" do |ansible|
       ansible.playbook = "playbook.yml"
       install = true
    end

* oder per Shellscript-Provisioning im Vagrantfile - vorher muß natürlich das entsprechende Repository im Guest-System eingetragen sein (beim ``install_mode = default``) oder Ansible wird über den Python-Paketmanager installiert (beim ``install_mode = pip``):


    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get install -y ansible
    SHELL

Die ``ansible_local`` Variante hat den Charme, daß Ansible auf dem Host-System nicht installiert werden muß. Das hat folgende Vorteile:

* das Host-System wird nicht verändert
* die Installation kann komplett vagrant-scriptbasiert erfolgen
* auch **Windows-Host-Systeme** (für die es keinen offiziellen Ansible-Support gibt) **können Ansible-Provisioning verwenden** 

---

# Ansible Runtime Engine

## LogLevel
Über ``-v`` wird das LogLevel definiert ... je mehr v's desto geschwätziger:

    ansible-playbook myplaybook.yml -vvvv

---

# Ansible Playbook DSL

* Beispiele: https://github.com/ansible/ansible-examples
* alle Module: http://docs.ansible.com/ansible/list_of_all_modules.html
* https://liquidat.wordpress.com/2016/01/26/howto-introduction-to-ansible-variables/

## Module
Ansible DSL baut auf Modulen auf: http://docs.ansible.com/ansible/modules_by_category.html

## Idempotenz
Um die gewünschte Idempotenz zu erreichen, muß man sich als Linux-Scripting-Veteran vom Modul ``shell`` lösen (auch wenn es scher fällt) und geeignete Ansible-Module verwenden. 

Lösung 1: **NICHT** idempotent

    shell: echo "ZSH_THEME=robbyrussell" >> ~/.zshrc

    
Lösung 2: idempotent

    lineinfile: dest=~/.zshrc state=present line='ZSH_THEME=robbyrussell'

## Variablen
* http://docs.ansible.com/ansible/playbooks_variables.html

## Umgebungsinformationen
* http://docs.ansible.com/ansible/playbooks_variables.html

Ansible sammelt zu den Hosts Informationen (z. B. CPU, OS), die als Variablen zur Verfügung stehen. Diese Variablen können per 

    ansible -m setup localhost
    
Statt ``localhost`` kann jeder registrierte Host eingetragen werden (siehe ``/etc/ansible/hosts``). Auf diese Weise findet man beispielsweise heraus, daß es eine Variable ``ansible_kernel`` gibt, die die die Kernel-Version enthält (anstatt ``uname -r``).

Umgebungsvariablen werden per

    vars:
       executingUser: "{{ lookup('env','USER') }}"

abgefragt (hier: der ausführende User).

## SSH-Agent starten und konfigurieren
[siehe separate Seite](ssh.md)

---

# Vagrant-Ansible-Integration unter Windows-Host

Für eine komplette Automatisierung meiner [Workbench (VirtualBox-Linux-Image)](workbench.md) hatte ich die Idee, mittels Vagrant und Ansible ein komplett automatisiertes Setup zu scripten.

## Variante 1: Remote Ansible

* http://docs.ansible.com/ansible/guide_vagrant.html

Der typische Ansible-Ansatz ermöglicht die Ausführung von Kommandos via ssh. Insofern paßt es perfekt in ein Vagrant-Host/Guest-Szenario - der Host sendet via ssh (wird von Vagrant eh schon konfiguriert) die entsprechenden Shell-Kommandos zum Guest. 

Einzige Voraussetzung ist die Installation von Ansible auf dem Host-System. Leider wird diese Einschränkung für Windows-Host-Systeme zum Ausschlußkriterium, denn Ansible wird für Windows nicht unterstützt. Für mein Workbench-Szenario kam diese Lösung demnach nicht in Frage.

---

# Bewertung
## Was macht Ansible so angenehm?

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

## Alternative Shellscripting?

Ganz ohne Frage ... Shellscripting hat ein paar Vorteile:

* ganz dicht am manuellen Aufsetzen - klar Scripting bedeutet dann oftmals auch, daß eine gewisse Art von Konfigurierbarkeit in die Scripte eingebaut wird, um sie an bestimmte Umgebungen anzupassen. Verzichtet man aber auf die Konfigurierbarkeit, dann genügt es, die für eine manuelle Installation/Konfiguration eines System erforderlichen Befehle, in eine Shelldatei zu packen. Viola :-)
* kein weiteres Layer zwischen den Befehlen und dem System ... ich bin mir aber nicht sicher, ob das wirklich ein Vorteil ist, denn Fehlersuche in Shellscripten ist wirklich alles andere als eine Freude ... insbes. aufgrund der fehlenden Idempotenz

## Performance
Tatsächlich scheint mir die Performance nicht so berauschend. Für meinen Anwendungsfall (wenige Tasks auf wenigen Knoten) ist es aber ok.

