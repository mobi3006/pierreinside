# Ansible

Ansible wird zum automatisierten Provisioning von Systemen eingesetzt.

In einem Multimachine-Vagrant-Projekt, das aus 5 verschiedenen Images bestand und dessen Provisioning eine knappe Stunde dauerte, haben wir Shellscripting zum Provisioning eingesetzt. Das hatte einige Vorteile, **aber auch einen ganz entscheidenden Nachteil**: Fehlende Idempotenz.

---

## Wichtige Konzepte

### Idempotenz

Idempotenz erlaubt es ein Script mehrfach hintereinander ablaufen zu lassen, ohne daß sich das Ergebnis verändert. Einige Praxisbeispiele:

* Beispiel 1: [für meinen Workbench-Anwendnungsfall besonders wichtig](workbench.md)
  * Skripte entwickeln sich weiter und neu entwickelte Teile sollen auch sofort genutzt werden können. Ohne Idempotenz darf/kann ich bereits ausgeführte Schritte nicht einfach wiederholen, sondern muß sie auskommentieren (o. ä. ... was evtl. gar nicht so einfach ist).
  * enthält ein Skript `mkdir /tmp/test`, so ist das nicht idempotent. Bei der zweiten Ausführung schlägt das Kommando fehl, weil das Verzeichnis schon existiert. Ohne Idempotenz-Support muß man dann mühselig (und fehlerträchtig) entsprechende `if`-clauses einbauen oder andere Befehle nutzen.
* Beispiel 2:
  * Bricht das Provisioning nach 20 Minuten Laufzeit mit einem Fehler ab, dann bedeutet das nach Beheben des Fehlers oftmals (wenn man nicht mehrere Minuten in das manuelle Anpassen der Scripte investieren will), daß das Image komplett platt gemacht und neu aufgebaut wird ... also wieder 20 Minuten warten bis man überhaupt wieder so weit ist wie man schon mal war.

Fehlende Idempotenz hat zumeist zur Folge, daß die Skripte nicht regelmäßig ausgeführt werden (weil: zu umständlich) und das wiederum hat zur Folge, daß man bei jeder Ausführung Schlimmstes befürchten muß.

Ansible unterstützt Idempotenz (`state=present`):

```
lineinfile: 
    dest=~/.zshrc
    state=present
    line='ZSH_THEME=robbyrussell'
```

### AdHoc vs. Playbook

* http://docs.ansible.com/ansible/intro_adhoc.html

AdHoc-Kommandos werden per ``ansible`` (`--args` aka `-a`)

     ansible all --args "/bin/echo hello"

abgeschickt und sind so komfortabel wie Shell-Kommandos ... nur eben mit der Mächtigkeit sehr viele Hosts mit der Abarbeitung des Kommandos zu beauftragen.

Ein Playbook hingegen ist eher für umfangreichere Aktionen gedacht:

    ansible-playbook myplaybook.yml

Hierzu wird eine Playbook-Datei benötigt.

### Multimachine

Während man es bei Shellscripting und Vagrantscripting gewohnt ist auf EINER Maschine zu arbeiten, ist Ansible dazu gedacht Kommandos auf vielen Maschinen (evtl. Tausende) gleichzeitig auszuführen. Das erleichtert insbesondere die Wartung von Serverfarmen. Hierzu lassen sich Maschinen über das Inventory-File (``/etc/ansible/hosts``) kategorisieren, so daß per

    ansible webservers -a "/bin/df -h"

alle als Webserver kategorisierte Maschinen ihre Plattenbelegung ausgeben.

### Local vs. Remote

Ansible unterscheidet zwischen

* **Local-Verbindung:** hierbei wird das Ansible-Skript/Kommando nicht per ssh zum Zielrechner (= localhost) gebracht ... insofern muß die ssh-Infrastruktur auch nicht existieren. Allerdings funktionieren dann Properties wie ``remote_user`` nicht ... stattdessen wird ``become`` verwendet, um in eine andere Rolle zu schlüpfen (beispielsweise als ``root`` zu agieren)
* **Remote-Verbindung:** hierbei wird das Kommando auf dem Zielrechner per ``ssh -c ...`` ausgeführt. Das kann auch passieren, wenn der Zielrechner ``localhost`` ist.

Wenn nicht explizit angegeben wurde, ob Ansible local oder remote verwenden soll, dann versucht Ansible ein Auto-Detection. Man kann Ansible aber auch unter die Arme greifen, um die Connection-Variante explizit zu bestimmen (``/etc/ansible/hosts``):

    localhost ansible_connection=local

Das Scripting unterscheidet sich bei den Ausführungsformen nicht. Allerdings benötigt die Remote-Ausführung ein erweitertes Setup (ssh-Infrastrutur).

> ACHTUNG: fürs Entwickeln der Skripte ist der Local-Mode sicherlich ganz brauchbar, aber integrativ sollte man dann tatsächlich auch im Remote-Mode testen

#### Remote-Mode

Über den Parameter `-vvvvvv` kann man die einzelnen Schritte erkennen, die Ansible für die Remote-Ausführung macht - hier am Beispiel `ansible ansible-target --args "/bin/echo hello" -vvvvvv`:

```
╭─pfh@workbench ~/.ssh  
╰─➤  ansible ansible-target --args "/bin/echo hello" -vvvvvv
Using /etc/ansible/ansible.cfg as config file
Loaded callback minimal of type stdout, v2.0
<ansible-target> ESTABLISH SSH CONNECTION FOR USER: admin
<ansible-target> SSH: ansible.cfg set ssh_args: 
      (-o)(ControlMaster=auto)
      (-o)(ControlPersist=60s)
<ansible-target> SSH: ansible_password/ansible_ssh_pass not set: 
      (-o)(KbdInteractiveAuthentication=no)
      (-o)(PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey)
      (-o)(PasswordAuthentication=no)
<ansible-target> SSH: ANSIBLE_REMOTE_USER/remote_user/ansible_user/user/-u set: (-o)(User=admin)
<ansible-target> SSH: ANSIBLE_TIMEOUT/timeout set: (-o)(ConnectTimeout=10)
<ansible-target> SSH: PlayContext set ssh_common_args: ()
<ansible-target> SSH: PlayContext set ssh_extra_args: ()
<ansible-target> SSH: found only ControlPersist; added ControlPath: 
      (-o)(ControlPath=/home/pfh/.ansible/cp/ansible-ssh-%h-%p-%r)
<ansible-target> SSH: EXEC ssh -C -vvv 
      -o ControlMaster=auto 
      -o ControlPersist=60s 
      -o KbdInteractiveAuthentication=no 
      -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey 
      -o PasswordAuthentication=no 
      -o User=admin 
      -o ConnectTimeout=10 
      -o ControlPath=/home/pfh/.ansible/cp/ansible-ssh-%h-%p-%r -tt ansible-target 
      '( umask 22 && mkdir -p "$( echo $HOME/.ansible/tmp/ansible-tmp-1490084266.37-148070795341843 )" 
      && echo "$( echo $HOME/.ansible/tmp/ansible-tmp-1490084266.37-148070795341843 )" )'
<ansible-target> PUT /home/pfh/temp/tmpY_WJOP TO 
     /home/admin/.ansible/tmp/ansible-tmp-1490084266.37-148070795341843/command
<ansible-target> SSH: ansible.cfg set ssh_args: 
      (-o)(ControlMaster=auto)
      (-o)(ControlPersist=60s)
<ansible-target> SSH: ansible_password/ansible_ssh_pass not set: 
      (-o)(KbdInteractiveAuthentication=no)
      (-o)(PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey)
      (-o)(PasswordAuthentication=no)
<ansible-target> SSH: ANSIBLE_REMOTE_USER/remote_user/ansible_user/user/-u set: (-o)(User=admin)
<ansible-target> SSH: ANSIBLE_TIMEOUT/timeout set: (-o)(ConnectTimeout=10)
<ansible-target> SSH: PlayContext set ssh_common_args: ()
<ansible-target> SSH: PlayContext set sftp_extra_args: ()
<ansible-target> SSH: found only ControlPersist; added ControlPath: 
      (-o)(ControlPath=/home/pfh/.ansible/cp/ansible-ssh-%h-%p-%r)
<ansible-target> SSH: EXEC sftp -b - -C -vvv 
      -o ControlMaster=auto 
      -o ControlPersist=60s 
      -o KbdInteractiveAuthentication=no 
      -o PreferredAuthentications=gssapi-with-mic,gssapi-keyex,hostbased,publickey 
      -o PasswordAuthentication=no 
      -o User=admin 
      -o ConnectTimeout=10 
      -o ControlPath=/home/pfh/.ansible/cp/ansible-ssh-%h-%p-%r '[ansible-target]'
```

Man sieht hier sehr schön wie die Kommunikation under-the-hood abläuft:

* `ssh -c`, um ein Zielverzeichnis (`~/.ansibe/tmp/ansible-tmp-foo`( für das auszuführende Kommando anzulegen
* `sftp`, um das Kommando zum Target-Host zu transportieren
  * kann man von SFTP auf SSH umkonfigurieren (Stichwort `scp_if_ssh=True`)
  * ACHTUNG: das Kommando-Verzeichnis wird i. a. am Ende wieder gelöscht (es sei denn man verwendet `export ANSIBLE_KEEP_REMOTE_FILES=1`)
* ssh-Connection Sharing über `ControlPath` erfolgt

---

## Getting Started

[siehe eigener Abschnitt](ansibel_gettingStarted.md)

---

## Ansible Runtime Engine für Playbooks

Das CLI ``ansible-playbook`` hat ein paar interessante Parameter:

```
--inventory-file
--limit
-vvvv
```

Diese Parameter sind insbes. für die Entwicklung von Ansible-Skripten durchaus hilfreich.

### LogLevel

Über ``-v`` wird das LogLevel definiert ... je mehr v's desto geschwätziger:

    ansible-playbook myplaybook.yml -vvvv

---

## Konfiguration

Die Konfiguration erfolgt in `ansible.cfg`. Hier werden verschiedene Locations herangezogen:

* im aktuellen Verzeichnis
* `/etc/ansible/ansible.cfg`

### Wichtige Parameter

### scp_if_ssh

In der Default-Einstellung wird SFTP verwendet, um das Ansible-Play vom Ansible-Controller zum Target-Host zu transportieren.

#### ANSIBLE_KEEP_REMOTE_FILES=1

Ansible bietet zur Spezifikation der Playbooks eine DSL an, aus der zur Ausführungszeit intern in Python-Code generiert wird. Im Ansible-Remote-Modus wird ein Python-Script (selbst im Fall eines einfachen `ansible ansible-target -a "/bin/echo hello"` ist dieses Script 90 Kilobyte groß) vom Ansible-Controller zum Target-Server transportiert und in `~/.ansible/tmp/ansible-tmp-foo/command` gespeichert.

Bei der Ausführung wird eine Result in JSON-Form ausgegben (hier im Falle eines erfolgreichen `echo hello`)

    ```json
    {
        "changed": true,
        "end": "2017-03-21 09:48:19.398800",
        "stdout": "hello",
        "cmd": ["/bin/echo", "hello"],
        "rc": 0,
        "start": "2017-03-21 09:48:19.397007",
        "stderr": "",
        "delta": "0:00:00.001793",
        "invocation": {
            "module_args": {
                "warn": true,
                "executable": null,
                "chdir": null,
                "_raw_params": "/bin/echo hello",
                "removes": null,
                "creates": null,
                "_uses_shell": false
            }
        },
        "warnings": []
    }
    ```

das der Ansible-Controller erhält.

Nach der Ausführung wird das Command-Skript per default gelöscht. Mit der Environment-Variable `export ANSIBLE_KEEP_REMOTE_FILES=1` kann das Löschen verhindert werden ... bei der Fehlersuche sehr hilfreich, denn dann kann man mal einen Blick in das generierte Python-Skript werfen!!!

Natürlich muß man seine Konsole nicht dauerhaft verändern - bei folgendem Aufruf wird die Command-datei nur für diesen einen Aufruf behalten:

    ```bash
    ANSIBLE_KEEP_REMOTE_FILES=1 ansible ansible-target -a "/bin/echo hello"
    ```

---

## Ansible Playbook DSL

* Beispiele: https://github.com/ansible/ansible-examples
* alle Module: http://docs.ansible.com/ansible/list_of_all_modules.html
* https://liquidat.wordpress.com/2016/01/26/howto-introduction-to-ansible-variables/

### YAML-Syntax

[siehe eigener Abschnitt](yaml.md)

> ACHTUNG: yaml ist bei den Einrückungen sehr strikt und Fehler in diesem Bereich sind schwer zu finden

### Module

Ansible DSL baut auf Modulen auf: http://docs.ansible.com/ansible/modules_by_category.html

Die sog. Core-Modules werden vom offiziellen Ansible-Team bereitgestellt und immer mit Ansible ausgeliefert. Drittanbieter können eigene Module bereitstellen/verkaufen, die dann aber extra installiert werden müssen.

### Variablen

* [Playbook-Variablen](http://docs.ansible.com/ansible/playbooks_variables.html)
* [alles über Variablen](https://liquidat.wordpress.com/2016/01/26/howto-introduction-to-ansible-variables/)

Variablen können auf sehr vielen Ebenen definiert werden. Vom Betriebssystem bis zum Playbook. Wenn sich die Variablen überschreiben (was durchaus gewollt sein kann), [wird es schnell mal schwierig](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) - dieses Feature sollte also mit Bedacht eingesetzt werden.

#### Gather Facts

Ansible sammelt (sog. *Gather Facts*) zu den Hosts Informationen (z. B. CPU, OS), die als Variablen zur Verfügung stehen. Diese Variablen können per 

    ansible -m setup localhost
    
Statt ``localhost`` kann jeder registrierte Host eingetragen werden (siehe ``/etc/ansible/hosts``). Auf diese Weise findet man beispielsweise heraus, daß es eine Variable ``ansible_kernel`` gibt, die die die Kernel-Version enthält (anstatt ``uname -r``).

#### Umgebungsvariablen

Umgebungsvariablen können über Gather Facts Informationen

```
vars:
   executingUser: "{{ ansible_env.HOME') }}"
```

oder über

```
    vars:
       executingUser: "{{ lookup('env','USER') }}"
```

abgefragt werden.

### Lookups

Über ``lookup`` lassen sich Inhalte von Dateien auslesen. Beispielsweise wird der Public-Key (in ``.ssh/id_rsa.pub``) ausgelesen und in die ``authorized_keys`` des Users ``vagrant`` auf einer anderen Maschine übertragen:

```
tasks:
  - set_fact:
      current_user_default_public_ssh_key: "{{ ansible_env.HOME }}/.ssh/id_rsa.pub"
  - authorized_key: 
      user: vagrant 
      key: "{{ lookup('file', current_user_default_public_ssh_key) }}/.ssh/id_rsa.pub"
```

---

## Inventory

* [Dokumentation](http://docs.ansible.com/ansible/intro_inventory.html)

Im Inventory-File (konfigurierbar über ``--inventory-file=/tmp/myinventory``) werden die Zielsysteme definiert, gruppiert und der Zugriff konfiguriert, u. a.

* Host und Port für den ssh-Zugriff
* Private-Keys
* ...

---

## Wiederverwendung

* http://docs.ansible.com/ansible/playbooks_roles.html

Über Rollen läßt sich in Ansible Modularisierung abbilden, um Wiederverwendung zu erreichen. Wiederverwendung ist sicherlich erst dann erforderlich, wenn man mehr macht als nur ein einziges Playbook zusammenzubasteln.

Verwendet man Playbook für verschiedene Use-Cases, dann ergibt sich allerdings sehr schnell der Wunsch nach einer Modularisierung (Beispiel: Sicherstellung einer Java-JDK-Installation).

### Includes

Modularisierung über Includes läßt sich auf allen abstrakten Ebenen verwenden:

* Playbooks verwenden weitere Playbooks

```yaml
- name: this is a playbook
  hosts: all
  tasks:
  - name: greetings
    shell: echo "hello world"
- include: otherPlaybook1.yml
- include: otherPlaybook2.yml
```

* Tasks verwenden weitere Tasks

```yaml
tasks:
  - include: java.yml
    vars:
        version: 8
        provider: oracle
```

* Handlers verwenden weitere Handlers

```yaml
handlers:
  - include: handlers/myhandler.yml
```

#### Parametrisierung

Da der Use-Case dem zu verwendenden Modul nicht bekannt ist, müssen die Module entsprechend parametrisiert werden. Damit lassen sich einfache Anpassungen vornehmen (auf der Ebene eines Attributwertes).

**Beispiel: Ensure-Java**

Die Sicherstellung einer passenden Java-Installation könnte ein wiederverwendbarer Baustein sein, der in vielen Playbooks benötigt wird. In manchen Situationen wird Java 7 und in anderen Java 8 benötigt. Das Modul ``ensureJdkInstallation.yml`` erhält hierzu einen Parameter ``version``:

```yaml
tasks:
  - include: ensureJdkInstallation.yml
    vars:
        version: 8
        provider: oracle
```

In ``java.yml`` wird der Parameter per ``{{ version }}`` erferenziert.

#### Conditionals

Mit *Conditionals* können beispielsweise Include-Anweisungen bestückt werden, um auf diese Weise  betriebssystemabhängige Weichen einzubauen:

```yaml
---

- include: centos7.yml
  when: ansible_distribution == "CentOS"
        and ansible_distribution_major_version == "7"
- include: ubuntu.yml
  when: ansible_distribution == "Ubuntu"
```

### Roles

Roles bauen einen Convention-over-Configuration-Mechanismus um Includes auf. Auf Basis einer vorgegebenen Ordnerstruktur erfolgt der Aufbau eines *Plays* (= Playbook zur Laufzeit) nahezu automatisch. Durch Verzicht auf explizite Konfiguration sind Skripte leichter erweiterbar/anpassbar. Das erinnert sehr stark an den Ansatz, den [Spring-Boot mit der annotationsbasierten ApplicationContext-Aufbau geht](springBoot.md).

#### Convention: Ordnerstruktur

Zentrales Element der Konvention ist die [Filesystem-Struktur](http://docs.ansible.com/ansible/playbooks_best_practices.html#directory-layout):

```struct
site.yml
webservers.yml
fooservers.yml
roles/
    myRole/
        files/
        templates/
        tasks/
        handlers/
        vars/
        defaults/
        meta/
```

Ausgehend davon werden sog. *Plays* (Playbooks zur Laufzeit) nach folgenden Regeln dynamisch zusammengebaut ([kopiert von hier](http://docs.ansible.com/ansible/playbooks_roles.html)):

* If ``roles/x/tasks/main.yml`` exists, tasks listed therein will be added to the play
* If ``roles/x/handlers/main.yml`` exists, handlers listed therein will be added to the play
* If ``roles/x/vars/main.yml`` exists, variables listed therein will be added to the play
* If ``roles/x/meta/main.yml`` exists, any role dependencies listed therein will be added to the list of roles (1.3 and later)
* Any copy, script, template or include tasks (in the role) can reference files in ``roles/x/{files,templates,tasks}/`` (dir depends on task) without having to path them relatively or absolutely

**Es besteht allerdings weiterhin die Möglichkeit, Tasks, Handlers, Variablen explizit in Playbooks zu verwenden.**

Das Playbook (``site.yml``) sieht dann beispielsweise so aus:

```yaml
---
- hosts: webservers
  roles:
     - common
     - webservers
```

Darin werden Rollen referenziert, wodurch der *Play* größer wird. In Rollen selbst können *Role Dependencies* (s. u.) definiert werden, die den Play ihrerseits erweitern.

Ansible wird dadurch sehr mächtig ... aber vielleicht auch sehr komplex.

#### Role Dependencies

Eine Rolle kann in ``<role>/meta/main.yml`` Abhängigkeiten auf weitere Rollen definieren ... diese Abhängigkeiten können parametrisiert werden.

#### Conditionals

Rollen können in Abhängigkeit bestimmter Zustände (z. B. Betriebssystem) gezogen werden.

Auf diese Weise lassen sich beispielsweise betriebssystemabhängige Weichen einbauen wie diese:

```yaml
---

- include: centos7.yml
  when: ansible_distribution == "CentOS" 
        and ansible_distribution_major_version == "7"
- include: ubuntu.yml
  when: ansible_distribution == "Ubuntu"
```

#### Ansible Galaxy

... ist ein Repository für Community-Developed Ansible Roles ...

### Role Java

In meinem ersten Ansible-Projekt stand ich vor der Aufgabe Java 8 auf mindestens CentOS zu installieren.

### Projektübergreifende Wiederverwendung

Die oben vorgestellte Wiederverwendung über Roles funktioniert gut, wenn das gesamte Projekt unter der eigenen Kontrolle ist. Wenn nun aber drei getrennte Projekte auf eine gemeinsame Scripting-Basis (im wesentlichen Roles) zugreifen sollen, dann hat Ansible derzeit noch keine passende Antwort.

Ansible Galaxy scheint in diese Richtung zu gehen ... 

---

## Best Practices

* Offizielle Best-Practices: http://docs.ansible.com/ansible/playbooks_best_practices.html
* Code-Beispiele: https://github.com/ansible/ansible-examples

### Nicht verwenden "remote_user: root"

Besser ist, sich als normaler User zu verbinden und dann gezielt für einzelne Kommandos per ``become`` in die Rolle des ``root`` zu schlüpfen.

### SSH-Agent starten und konfigurieren

[siehe separate Seite](ssh.md)

Um Ansible-Skripte komplett automatisiert (also nicht interaktiv) ausführen zu lassen, muß der SSH-Agent mit dem/den Private-Key(s) gefüttert werden, denn ansonsten muß der Benutzer die Passphrase (wenn vorhanden - RECOMMENDED!!!) interaktiv eingeben.

### Verwende Roles

* http://docs.ansible.com/ansible/playbooks_roles.html

Über Rollen läßt sich in Ansible Modularisierung abbilden, um Wiederverwendung zu erreichen. Wiederverwendung ist sicherlich erst dann erforderlich, wenn man mehr macht als nur ein einziges Playbook zusammenzubasteln.

weitere Details: siehe oben

---

## Bewertung

### Lernkurve

Man kommt tatsächlich sehr schnell (wenn man mal die Ansible-Infrastruktur mit ssh, sudo aufgebaut hat) zu brauchbaren Ergebnissen. Häufig braucht man gar nicht so viele Module ... es sind 5-10 Module, die wirklich ständig im Einsatz sind.

Ich arbeite an einer Infrastruktur bestehend aus Controller und verschiedenen Target-Hosts. Mir ist es schon häufiger passiert, daß

* ich vom Target-Host das Ansible-Skript starten wollte ... dort ist aber gar kein Ansible installiert
* ich vom Controller-System Remote-Konfigurationen angestoßen habe und die Änderungen lokal gesucht habe

An diese Denkweise muß man sich erst einmal gewöhnen. Insbesonder, wenn man - wie ich - im privaten Gebrauch ausschließlich lokal arbeitet ([um die Workbench aufzubauen](ubuntu_1604_lts.md)) und im geschäftlichen Umfeld ausschließlich remote.

### Pro

* **IDEMPOTENZ** ist leichter möglich als bei Shellscripts (der Entwickler muß die Skripte aber auch idempotent gestalten!!!)
* gute Dokumentation
* Remote-Installationen möglich
* flache Lernkurve (s. o.), Komplexität überschaubar
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
* die Fehlermeldungen sind meistens ganz brauchbar
* Ausgabe bei der Abarbeitung der Playbooks sehr übersichtlich:


    pfh@workbench ~/windows_de.cachaca.workbench (git)-[master] % ansible-playbook playbook.yml      

    PLAY ***************************************************************************

    TASK [setup] *******************************************************************
    ok: [localhost]

    TASK [system | update package meta-data] ***************************************
    ok: [localhost]

    TASK [system | install aptitude ... needed for succeeding "upgrade system"] ***
    ok: [localhost]

    TASK [system | upgrade system] *************************************************
    ok: [localhost]

    TASK [devcon | create directory strcuture for user pfh] ************************
    ok: [localhost] => (item=~/bin)
    ok: [localhost] => (item=~/src)
    ok: [localhost] => (item=~/temp)
    ok: [localhost] => (item=~/zipfiles)

### Contra

* manchmal (u. a. fehlende schließende Gänsefüßchen, falsche Einrückungen im Ansible-Playbook) sind die Fehlermeldungen wenig hilfreich

### Performance

Tatsächlich scheint mir die Performance nicht so berauschend. Für meinen Anwendungsfall (wenige Tasks auf wenigen Knoten) ist es aber ok.

Vielleicht helfen die Einstellungen ``pipelining = True`` und ``host_key_checking = False`` in ``ansible.cfg``.

---

## Alternativen

* https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-overview/
* https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-hands-on-with-ansible/
* ein sehr ausführlicher Vergleich zwischen Ansible und Saltstack: http://ryandlane.com/blog/2014/08/04/moving-away-from-puppet-saltstack-or-ansible/

> "After three years of using Puppet at VMware and Virtual Instruments, the thought of not continuing to use the market leader in configuration management tools seemed like a radical idea when it was first suggested to me. After spending several weeks researching Ansible and using it hands-on, I came to the conclusion that Ansible is a perfectly viable alternative to Puppet. I tend to agree with Lyft’s conclusion that if you have a centralized Ops team in change of deployments then they can own a Puppet codebase. On the other hand if you want more wide-spread ownership of your configuration management scripts, a tool with a shallower learning curve like Ansible is a better choice." (*Dan Tehranian's Blog*, https://dantehranian.wordpress.com/2015/01/20/ansible-vs-puppet-hands-on-with-ansible/)

### Alternative Shellscripting

Ganz ohne Frage ... Shellscripting hat ein paar Vorteile (die Nachteile habe ich umfassend in einem [eigenen Abschnitt](shellprogramming.md) aufgelistet:

* ganz dicht am manuellen Aufsetzen - klar Scripting bedeutet dann oftmals auch, daß eine gewisse Art von Konfigurierbarkeit in die Scripte eingebaut wird, um sie an bestimmte Umgebungen anzupassen. Verzichtet man aber auf die Konfigurierbarkeit, dann genügt es, die für eine manuelle Installation/Konfiguration eines System erforderlichen Befehle, in eine Shelldatei zu packen. Viola :-)
* kein weiteres Layer zwischen den Befehlen und dem System ... ich bin mir aber nicht sicher, ob das wirklich ein Vorteil ist, denn Fehlersuche in Shellscripten ist wirklich alles andere als eine Freude ... insbes. aufgrund der fehlenden Idempotenz

Ich habe ein komplexes Setup über Vagrant und Shellscripting-Provisioning umgesetzt (Laufzeit 50 Minuten). Erst danach habe ich Ansible kennengelernt. 

**Mein Fazit: Ansible ist der klare Sieger**