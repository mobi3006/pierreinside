# ssh

## Clientsicht

### Public-Private-Key-Generierung

* https://wiki.ubuntuusers.de/SSH/

Will man ohne Password auf einen anderen Rechner zugreifen, dann tut man das i. d. R. über Public-Private-Keys. Es gibt viele Use-Cases, in denen diese Variante genutzt wird:

* ssh-connects zwischen Rechnern
* Git-Cliets nutzen (``git clone``, ``git push``)
* Ansible-Skripte ... hier ist die Verwendung eines passwortlosen Zugriffs besonders zentral, weil die Skripte ja vollautomatisiert ohne Interaktion mit dem Benutzer ausgeführt werden sollen. Ist der Private-Key mit einer Passphrase geschützt (das ist EMPFOHLEN!!!), dann wird noch der SSH-Agent benötigt.

Public-Private-Key erzeugen:

```bash
ssh-keygen -t rsa -b 4096 -C "anyEmailOfMyUser@example.com"
```

Dabei wird eine Passphrase (ein Kennwort) abgefragt, mit dem der Private-Key geschützt ist. der erzeugte Public-Private-Key wird unter ``~/.ssh/id_rsa`` bzw. ``~/.ssh/id_rsa.pub`` abgelegt. Entscheidend sind nun auch die Permissions (**ansonsten verweigert der ssh-Client die Nutzung!!!**):

* Verzeichnis ``~/.ssh`` sollte die Permissions 700 haben
* die Key-Dateien sollten die Permissions 600 haben

### Fingerprints von Keys

Die Vergleichbarkeit von Keys ist für menschliche Benutzer kaum zu bewerkstelligen. In manchen Situationen (GitHub: *Ist der Public-Key als autorisierter User eingetragen?*) muß der User aber die Keys miteinander vergleichen können. Hierzu gibt es die sog. Fingerprints, die eine Kurzform des Keys darstellen (aber auch eindeutig sind):

* MD5-Fingerprint erzeugen: ``ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub``
  * liefert sowas in der Art: ``4096 MD5:32:fd:81:0c:6c:63:7b:36:8f:a1:12:f3:d2:5f:88:23 myuser@mydomain.com (RSA)``
* SHA-256-Fingerprint erzeugen: ``ssh-keygen -l -E sha256 -f ~/.ssh/id_rsa.pub``
  * liefert sowas in der Art: ``4096 SHA256:juG69ZMq226OfvWN4Pezg2Q8l+5vv1234pDemtJLDz0 myuser@mydomain.com (RSA)``

### Verwendung mehrerer SSH-Keys

Für einen User können mehrere SSH-Keys hinterlegt werden (z. B. wenn ein User in verschiedenen Rollen arbeitet). Natürlich können dann nicht alle Key-Dateien den gleichen namen ``id_rsa`` haben. In folgender Situation mit zwei Public-Private-Key-Paaren

    ~/.ssh/
      myroleA_rsa
      myroleA_rsa.pub
      myroleB_rsa
      myroleB_rsa.pub
      
muß bei der Kommunikation mit einem Server die zu verwendende Identität angegeben werden:

```bash
ssh -i ~/.ssh/myroleB_rsa git@github.com
```

Ein bissl umständlich ... alternativ könnte man einen symbolischen Link erzeugen:

```bash
ln -s ~/.ssh/myRoleB_rsa ~/.ssh/id_rsa
ln -s ~/.ssh/myRoleB_rsa.pub ~/.ssh/id_rsa.pub
```

Die beste Lösung besteht in der Verwendung eine ``~/.ssh/config`` Datei, mit der man die zu verwendenden Keys und Optionen angeben kann:

```properties
### default for all ##
Host *
    ForwardX11 no
Host mynas mynas-alias
    HostName 192.168.1.100
    User pfh
    IdentityFile ~/.ssh/nas.key
Host yournas
    HostName 192.168.1.99
    User pfh
    IdentityFile ~/.ssh/yournas.key
```

Danach kann man sich geschmeidig mit ``ssh mynas`` und ``ssh yournas`` einloggen (hier findet man weitere Details: http://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/)

### SSH-Agent

Der SSH-Agent ist ein Identity Store für Private Keys.

Anwendungsfälle:

* anderen Prozessen (z. B. einem Docker Container) Zugriff auf die Private Keys geben ohne den Prozess mit diesem User laufen zu lassen (Background: die files in `~/.ssh/` sind i. a. nur für den Benutzer selbst lesbar)
* Private Keys mit Passphrase erwarten beim (jedem?!?) Zugriff auf den Key die interaktive Eingabe der Passphrase. Das ist nicht nur nervig, sondern auch nicht immer möglich.

Der SSH-Agent wird folgendermaßen gestartet:

```bash
eval $(ssh-agent -s)
```

Anschließend sind die beiden Umgebungsvariablen

* `SSH_AGENT_PID`
  * Agent-Prozess-ID
* `SSH_AUTH_SOCK`
  * Socker (File), das man an (vertrauswürdige) Prozesse zum Teilen der Identities übergeben kann

und diesem den SSH-Private-Key übergeben

```bash
ssh-add ~/.ssh/id_rsa
```

Hierbei wird man ein letztes mal nach der Passphrase gefragt. Wenn die paßt, dann wird der private Key ohne Passphrase im Identity Store (Memory) gespeichert.

Ein paar nützliche Kommandos:

* Liste hinterlegter Private-Keys anzeigen: `ssh-add -l`
* Private-Key löschen

---

## Serversicht

### ssh-Server installieren

Ein ssh-Server ist Voraussetzung für Ansible ... auch wenn der Target-Host der Ansible-Kommandos ``localhost`` ist.

```bash
sudo apt-get install openssh-server
```

Ich teste den Zugriff per

```bash
    ssh localhost
```

Dabei kann ich gleich auch den Fingerprint des Host akzeptieren, damit dieser in die Liste der ``~/.ssh/known_hosts`` aufgenommen wird. Beim nächsten ssh-connect mit dem gleichen Client-User wird nicht mehr nachgefragt, ob ich diesem ssh-Server vertraue (Ansible wird das tun, wenn mein Playbook ausgeführt wird).

### Passwortlosen ssh-Zugriff erlauben

Der Public-Key jedes zugreifenden Users muß im zugegriffenen User-Home-Verzeichnis des Servers unter ``~/.ssh/authorized_keys`` abgelegt werden. Hier veranschaulicht, wenn User *userA* sich per ssh als *userB* am gleichen Rechner verbindet:

    /home/userA/.ssh/
      id_rsa
      id_rsa.pub
      known_hosts
    /home/userB/.ssh/
      authorized_keys
      
Nun muß man den ``/home/userA/.ssh/id_rsa.pub`` in die ``authorized_keys`` des userB reinbekommen:

    su - root    # oder sudo bash
    cat /home/userA/.ssh/id_rsa.pub >> /home/userB/.ssh/authorized_keys
