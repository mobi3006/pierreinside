# Bitbucket
Mit BitBucket steht ein Git/Mercurial-Hoster zur Verfügung, der kostenlos private Repositories ermöglicht. GitHub ist zwar einer der bekanntesten Git-Repository-Hoster, dafür sind aber nur öffentliche Repositories kostenlos.

BitBucket liefert aber nicht nur Git-Repositories, sondern auch 

* JIRA (Bug-Tracking) mit Git-Workflows
* Confluence (Wiki)
* Pipeline (Build-and-Deployment)

Deshalb ist diese Plattform auf jeden Fall einen Blick wert ...

---

# Getting Started
Nach Anlage eines BitBucket-Accounts hinterlegt man am besten gleich mal den ssh-Key für eine passwortlose Authentifizierung.

Über die Webapplikation läßt sich schnell eine privates/public Repository anlegen und per Git-Client lokal clonen:

    git clone git@bitbucket.org:mobi3006/de.cachaca.learn.kubernetes.git

---

# Verbindungsaufbau
Die Authentifizierung kann über (ODER) 

* username/password ... bei Verwendung des HTTPS-Protokolls (``git clone https://mobi3006@bitbucket.org/mobi3006/de.cachaca.learn.kubernetes.git``) oder SSH-Protokolls
* ssh-key ... bei Verwendung des SSH-Protokolls (``git clone git@bitbucket.org:mobi3006/de.cachaca.learn.kubernetes.git``)

erfolgen.

## Erstellung ssh-key
[siehe ssh](ssh.md) 

### Connection prüfen

Bei GitHub darf man sich NICHT mit dem Usernamen (= Email-Adresse) anmelden, sondern IMMER über den User ``git``:

    ssh -T git@bitbucket.com
    





