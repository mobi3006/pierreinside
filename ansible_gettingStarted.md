# Ansible ... getting started

# Linux-Host: Getting Started ...
* http://docs.ansible.com/ansible/index.html

## Controller-Konzept
Ansible unterscheidet bei den beteiligten Rechnern zwischen *Controller-System* (steuert die Ausführung des Playbooks) und *Zielsystem*. 

Software-Voraussetzungen:

* Controller-System:
  * Ansible installiert (und Python)
  * ssh client installiert und passwortlose Authentifizierung möglich
* Zielsystem:
  *  SSH-Server installiert und Passwortlose Authentifizierung über Public-Private-Key möglich ... [näheres siehe Abschnitt ssh](ssh.md)
  *  Python installiert

## Installation auf dem Controller-System
* http://docs.ansible.com/ansible/intro_installation.html

## Konfiguration des Controller-Systems
Die Kommandos aus dem Ansible-Playbook werden später über ssh auf die Zielsysteme übertragen und dort ausgeführt. Um eine scriptgesteuerte Ausführung zu ermöglichen, darf kein Passwort abgefragt werden. Das wird über die Verwendung von Public/Private Keys erreicht ([siehe auch ssh](ssh.md)). 

### SSH-Key erzeugen
[siehe ssh](ssh.md)

### Zielrechner definieren (Inventory File)
* http://docs.ansible.com/ansible/intro_inventory.html

Die Zielrechner können gruppiert werden - das ist sehr praktisch, um mit einem Befehl gleich mehrere Rechner adressieren zu adressieren.

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

In diesem Zuge spricht man von 

* **Ansible-Remote:** in diesem Fall werden vom Controller Kommandos via ssh zum Zielsystem geschickt. Das Controller-System muß mit Ansible und Python ausgestattet sein
* **Ansible-Local:** in diesem Fall wird das Playbook auf den Zielrechner transportiert und dort lokal ausgeführt. Der Controller-System braucht kein Ansible/Python
  * **besonders für Controller auf Windows-Basis interessant**

## Vagrant + ansible_local
[siehe eigener Abschnitt](vagrant_ansibleIntegration.md)

## cygwin + ansible-remote
* https://www.azavea.com/blog/2014/10/30/running-vagrant-with-ansible-provisioning-on-windows/

Bei diesem Ansatz wird der Python-Paketmanager (``pip``) verwendet, um das ``ansible`` Paket unter [cygwin](cygwin.md) zu installieren.

Sicherstellen, daß die Umgebungsvariablen in [cygwin](cygwin.md)/[babun](babun.md) gesetzt sind:

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

Danach muß ``ansible-playbook`` noch in ``$PATH`` aufgenommen werden und los gehts ... äh, war da nicht noch was in obigem Link beschrieben? 



