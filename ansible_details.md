# Ansible Details

Ansible ist sehr sehr sehr flexibel und erlaubt viele unterschiedliche Konzepte wie Dinge strukturiert werden. Der Ansatz Convention-over-Configuration erhöht die Einstiegshürde für Newbies noch weiter.

Mir (Ansible-Newbie) ist noch nicht klar wie Skripte strukturiert sein sollten, so daß über Configuration-File, Inventory-File, `hosts`, `tags`, CustomFacts, ... sicher entschieden werden kann welche Systeme mit welchen Updates versehen werden. Ich bin gespannt, ob sich das irgendwann gut anfühlt. Letztlich wird das ein entscheidendes Kriterium sein, denn als Admin muß man das Tool beherrschen und nicht andersrum.

## Convention-over-Configuration

Convention-over-Configuration wirkt auf den Gelegenheitsnutzer und Newbie immer ein wenig wie Magic. Man muss die Konventionen eben kennen, um zu wissen wie das Skript nun tickt.

Letztlich - und das kann man als generelle Regel sehen - lassen sich Konventionen i. a. über Umgebungsvariablen übersteuern und damit explizit machen (die unterstützten Umgebungsvariablen befinden sich hier: https://github.com/ansible/ansible/blob/devel/lib/ansible/constants.py). Auf diese Weise ist die Anpassung der Konfiguration OHNE PERSISTENTE Änderung möglich. Das halte ich für eine sehr gute Entscheidung. 

```
ANSIBLE_CONFIG=my.cfg
ANSIBLE_INVENTORY=myInventory
```

---

# Configuration

* http://docs.ansible.com/ansible/intro_configuration.html

Ansible bringt eine Default Konfiguration unter `/etc/ansible/ansible.cfg` mit. Allerdings wird man seine eigene verwenden wollen und die wird an folgenden Stellen gesucht:

* ANSIBLE_CONFIG (an environment variable)
* ansible.cfg (in the current directory)
* .ansible.cfg (in the home directory)
* /etc/ansible/ansible.cfg

---

# Inventory

Ansible bringt bei der Installation das Inventory-File `/etc/ansible/hosts`. Über die Variable `ANSIBLE_INVENTORY=myInventory` oder den Parameter `ansible-playbook -i myInventory` kann das übersteuert werden.
