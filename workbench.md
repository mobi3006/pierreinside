# Workbench4Devs

# Vollautomatisierung from-scratch

Seit ca. 20 Jahren setze ich meine Entwicklungsumgebung manuell auf. Rechnerwechsel oder Distributionswechsel sind zwar selten ... aber wenn, dann kostet es doch recht viel Arbeit, alles wieder zum Laufen zu bekommen. Und das Schlimmste ist, daß man alle Probleme wieder neu lösen muß. Diese Know-How-Sammlung hilft mir dann zwar immer wieder auf die Sprünge, aber es ist doch erst mal eine hohe mentale Hürde, ein laufendes System aufzugeben.

Deshalb hatte ich die Vision, ein komplettes System from-scratch per Script aufzusetzen. Hauptsächlich wollte ich Ansible kennenlernen. Da mich VirtualBox und Vagrant  schon einige Zeit begeistern, wollte ich NOCH einen Schritt WEITER gehen und alles from-scratch scriptgesteuert aufbauen. Das Scripting wäre gleichzeitig auch eine gute Dokumentation (ausführbare Dokumentation).

Auf diese Weise könnte ich auch anderen Entwicklern den Einstieg in eine Linux-Entwicklungsumgebung (OS, Docker, Java-IDE, Svn, Git, ...) erleichtern.

Ich frage ich allerdings bereits am Anfang dieser Idee, ob ich denn dauerhaft die Muße haben werde alle Anpassungen an meiner Workbench auch zu scripten und - VOR ALLEM - auch zu testen, denn das ist häufig sehr aufwendig ...

... aber scheinbar bin ich nicht der Einzige:

* https://danielgroves.net/notebook/2014/05/development-environments/
* http://digitalshore.io/set-up-a-local-linux-development-environment-with-vagrant/
* ...

## Umsetzung Versuch 1 - Vollautomatisierung - ERFOLGLOS
Meine ursprüngliche Idee war, ein Vagrant-Ansible-Setup unter einem Windows-Host zu fahren. Für Windows gibt es keinen Ansible-Support. Deshalb schied das typische *Ansible-Remote-Provisioning* (über ssh in das Guest-System hinein) aus. Mir blieb nur das *Ansible-Local-Provisioning*, bei dem Ansible auf dem Guest-System (Linux) installiert wird und dann der übliche ssh-execute-command verwendet wird ([Details siehe hier](ansible.md)). Leider hat das auch nicht funktioniert ... nach einigen Versuchen war ich frustriert und habe aufgegeben.

# Umsetzung Versuch 2 - Halbautomatisierung

Nach dem gescheiterten Vagrant-Ansible-Setup habe ich mich entschieden zu folgender Vorgehensweise entschieden (ich hatte andere Prioritäten ... nämlich eine lauffähige neue Distribution, auf der ich neue Technologien in der Softwareentwicklung ausprobieren wollte):

* Basissystem als Virtualbox-Image manuell installieren
* SSH-Konfiguration zur Vorbereitung des Ansible-Einsatzes manuell durchführen
* mit Ansible alle Installationen und Konfigurationen vollautomatisiert durchführen lassen
* manuelle Nacharbeiten ... (in Zukunft immer weiter reduzieren)

Das erste System, das ich auf diese Weise aufsetze ist [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) ... in dem Link finden sich weitere Informationen.

# Umsetzung Versuch 3 - Vollautomatisierung
Der Nachteil des Ansible Ansatzes besteht darin, daß es recht schwierig ist, das Image per Vagrant vorzubereiten - letztlich bin ich daran damals auch gescheitert. 

Mittlerweile gibt es mit [Packer von HashiCorp](https://www.packer.io/) und Mobi Tools, mit denen man Images für verschiedene Hypervisor-Technologien (lokal/remote) basteln kann. Auf diese Weise könnte ich dann sogar meine Workbench auf einer Cloud-Maschine bereitstellen ... nur eine Idee.

"Packer does not replace configuration management like Chef or Puppet. In fact, when building images, Packer is able to use tools like Chef or Puppet to install software onto the image." (https://www.packer.io/intro/index.html)

Ansible hätte somit auch noch sein Daseinsberechtigung ...

---

# Ubuntu Desktop 14.10 LTS
[siehe extra Abschnitt](ubuntu_1410_lts.md)

---

# Ubuntu Desktop 16.04 LTS
[siehe extra Abschnitt](ubuntu_1604_lts.md)

---

# Chrome
Ich war jahrelanger zufriedener Nutzer von Firefox. Als Entwickler haben mich aber die Chrome-Tools sehr begeistert, so daß ich den Umstieg vollzogen habe.

## pierreinside als Suchmaschine
Um schnell in diesem GitBook suchen zu können, habe ich unter Einstellungen - Suchmaschinen verwalten ... eine neue Suchmaschine mit diesem Querystring

```
https://mobi3006.gitbooks.io/pierreinside/content/?q=%s
```

definiert und das Kürzel ``p`` zugewiesen.

Nun kann ich im Browser elegant per ``p wasichsuchenwill`` suchen.