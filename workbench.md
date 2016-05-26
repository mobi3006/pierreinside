# Workbench4Devs
VirtualBox und Vagrant begeistern mich schon einige Zeit. Durch einen Jobwechsel wollte ich eine neue Workbench (OS, IDE) mit Docker-Support installieren. Ich kam auf die Idee, dies zu scripten, um so auch Dokumentation zu haben und unter Umständen das System auch neu aufzusetzen. 

Auf diese Weise könnte ich auch anderen Entwicklern den Einstieg in eine Linux-Entwicklungsumgebung (OS, Docker, Java-IDE, Svn, Git, ...) erleichtern.

## Ubuntu Desktop 16.04 LTS
Ich habe mich für das Ubuntu Desktop Image ``boxcutter/ubuntu1604-desktop`` (siehe  https://atlas.hashicorp.com/boxcutter/boxes/ubuntu1604-desktop) entschieden. Hierbei handelt es sich um die LongTimeSupport-Variante von Ubuntu, mit der ich bereits zuvor gute Erfahrungen gemacht habe.

### Probleme

Das Image möchte die VirtualBox-Guest-Additions in Version 5.x installieren ... deshalb muß mindestens VirtualBox 5.x installiert sein.

## Docker Support
* https://docs.docker.com/engine/installation/linux/ubuntulinux/

Diese Image bringt noch kein Docker out-of-the-box mit, doch das ist schnell eingerichtet:


