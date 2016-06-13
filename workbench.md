# Workbench4Devs
VirtualBox und Vagrant begeistern mich schon einige Zeit. Durch einen Jobwechsel wollte ich eine neue Workbench (OS, IDE) mit Docker-Support installieren. Ich kam auf die Idee, dies zu scripten, um so auch Dokumentation zu haben und unter Umständen das System auch neu aufzusetzen. 

Auf diese Weise könnte ich auch anderen Entwicklern den Einstieg in eine Linux-Entwicklungsumgebung (OS, Docker, Java-IDE, Svn, Git, ...) erleichtern.

Ich frage ich allerdings bereits am Anfang dieser Idee, ob ich denn dauerhaft die Muße haben werde alle Anpassungen an meiner Workbench auch zu scripten und - VOR ALLEM - auch zu testen, denn das ist häufig sehr aufwendig ...

---

# Ubuntu Desktop 16.04 LTS
Ich habe mich für das Ubuntu Desktop Image ``boxcutter/ubuntu1604-desktop`` (siehe  https://atlas.hashicorp.com/boxcutter/boxes/ubuntu1604-desktop) entschieden. Hierbei handelt es sich um die LongTimeSupport-Variante von Ubuntu, mit der ich bereits zuvor gute Erfahrungen gemacht habe.

## Vorbedingungen

Das Image möchte die VirtualBox-Guest-Additions in Version 5.x installieren ... deshalb muß mindestens VirtualBox 5.x installiert sein.

## Docker Support
* https://docs.docker.com/engine/installation/linux/ubuntulinux/

Diese Image bringt noch kein Docker out-of-the-box mit, doch das ist schnell eingerichtet:

---

# Vagrant-Ansible-Setup - ERFOLGLOS

Meine ursprüngliche Idee war, ein Vagrant-Ansible-Setup unter einem Windows-Host zu fahren. Für Windows gibt es keinen Ansible-Support. Deshalb blieb mir nur das Ansible-Remote-Provisioning, bei dem Ansible auf dem Guest-System (Linux) installiert wird und dann der übliche ssh-execute-command verwendet wird ([Details siehe hier](ansible.md)). Leider hat das auch nicht funktioniert ... nach einigen Versuchen war ich frustriert und habe aufgegeben.

---

# Ansible Setup

Nach dem gescheiterten Vagrant-Ansible-Setup habe ich mich entschieden das Basissystem als Virtualbox-Image per Hand zu installieren und dann gleich Ansible im Guest-System zum Laufen zu bringen:

    apt-get update -y
    apt-get install -y ansible
    
Die weitere Installation/Konfiguration erfolgte durch Ansible.


