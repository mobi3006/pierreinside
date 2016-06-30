# ssh

# Clientsicht
## Public-Private-Key-Generierung
Will man ohne Password auf einen anderen Rechner zugreifen, dann tut man das i. d. R. über Public-Private-Keys. Es gibt viele Use-Cases, in denen diese Variante genutzt wird:

* ssh-connects zwischen Rechnern
* Git-Cliets nutzen (``git clone``, ``git push``)
* Ansible-Skripte ... hier ist die Verwendung eines passwortlosen Zugriffs besonders zentral, weil die Skripte ja vollautomatisiert ohne Interaktion mit dem Benutzer ausgeführt werden sollen. Ist der Private-Key mit einer Passphrase geschützt (das ist EMPFOHLEN!!!), dann wird noch der SSH-Agent benötigt.

Public-Private-Key erzeugen:

    ssh-keygen -t rsa -b 4096 -C "anyEmailOfMyUser@example.com"

Dabei wird eine Passphrase (ein Kennwort) abgefragt, mit dem der Private-Key geschützt ist. der erzeugte Public-Private-Key wird unter ``~/.ssh/id_rsa`` bzw. ``~/.ssh/id_rsa.pub`` abgelegt. Auf dieses Verzeichnis DARF nur der jeweilige Benutzer Zugriff haben (Permussions 700)!!!

## Verwendung mehrerer SSH-Keys
Für einen User können mehrere SSH-Keys hinterlegt werden (z. B. wenn ein User in verschiedenen Rollen arbeitet). Natürlich können dann nicht alle Key-Dateien den gleichen namen ``id_rsa`` haben. In folgender Situation mit zwei Public-Private-Key-Paaren

    ~/.ssh/
      myroleA_rsa
      myroleA_rsa.pub
      myroleB_rsa
      myroleB_rsa.pub
      
muß bei der Kommunikation mit einem Server die zu verwendende Identität angegeben werden:

    ssh -i ~/.ssh/myroleB_rsa git@github.com
    
Ein bissl umständlich ... alternativ könnte man einen symbolischen Link erzeugen:

    ln -s ~/.ssh/myRoleB_rsa ~/.ssh/id_rsa
    ln -s ~/.ssh/myRoleB_rsa.pub ~/.ssh/id_rsa.pub

## SSH-Agent - Passphraseabfrage umgehen
In manchen Fällen (z. B. [automatisiertes Scripting mit Ansible](ansible.md)) möchte man die Passphrase des Private-Keys nicht eingeben müssen. Hierzu kann man den SSH-Agent starten

    eval $(ssh-agent -s)
    
und diesem den SSH-Private-Key übergeben.

    ssh-add ~/.ssh/id_rsa

Dabei wird die Passphrase einmalig interaktiv vom Benutzer abgefragt. Danach liegt der Key entsperrt im Memory des Systems.

Liste hinterlegter Private-Keys anzeigen: ``ssh-add -l``

---

# Serversicht
## ssh-Server installieren
Ein ssh-Server ist Voraussetzung für Ansible ... auch wenn der Target-Host der Ansible-Kommandos ``localhost`` ist.

    sudo apt-get install openssh-server

Ich teste den Zugriff per

    ssh localhost
    
Dabei kann ich gleich auch den Fingerprint des Host akzeptieren, damit dieser in die Liste der ``~/.ssh/known_hosts`` aufgenommen wird. Beim nächsten ssh-connect mit dem gleichen Client-User wird nicht mehr nachgefragt, ob ich diesem ssh-Server vertraue (Ansible wird das tun, wenn mein Playbook ausgeführt wird).

## Passwortlosen ssh-Zugriff erlauben

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
