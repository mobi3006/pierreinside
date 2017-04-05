# Ansible Details
Ansible ist sehr sehr sehr flexibel und erlaubt viele unterschiedliche Konzepte wie Dinge strukturiert werden. Der Ansatz Convention-over-Configuration erhöht die Einstiegshürde für Newbies noch weiter.

Mir als Newbie ist noch nicht klar wie man seine Skripte so strukturiert, daß man letztlich sicher definieren kann welche Systeme nun mit welchen Updates versehen werden. Aber ich habe Ansible auch bisher nur lokal bzw. kleine Landschaften genutzt.

# Configuration
* http://docs.ansible.com/ansible/intro_configuration.html

Ansible bringt eine Default Konfiguration unter `/etc/ansible/ansible.cfg` mit. Allerdings wird man seine eigene verwenden wollen und die wird an folgenden Stellen gesucht:

* ANSIBLE_CONFIG (an environment variable)
* ansible.cfg (in the current directory)
* .ansible.cfg (in the home directory)
* /etc/ansible/ansible.cfg

Letztlich - und das kann man als generelle Regel sehen - lassen sich Konfigurationen immer über Umgebungsvariablen übersteuern (die unterstützten Umgebungsvariablen befinden sich hier: https://github.com/ansible/ansible/blob/devel/lib/ansible/constants.py). Auf diese Weise ist die Anpassung der Konfiguration OHNE PERSISTENTE Änderung möglich. Das empfinde ich selbst als sehr gute Entscheidung. 
