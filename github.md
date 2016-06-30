# GitHub
GitHub ist mehr als nur ein Git-Repository ... es bietet viele Tools, die man für die Softwareentwicklung und Dokumentation brauchen kann :-)

GitHub ist auch Bestandteil der [GitBook-Toolchain](gitbook.md).

---

# Features

* Git-Repository (public und private)
* Remote-Editierung (direkt auf dem Remot-Repository) über eine Weboberfläche 
* gute Kollaboration
  * Integration von passiven Nutzern sehr leicht (passive Nutzer werden leicht aktiven Nutzern - das ist der Grundgedanke des Open-Source)
  * Kommentare/Diskussionen
  * Online-Issue-Tracking (für z. B. TODO-Listen)
  * Online-Wiki ... dabei handelt es sich auch um ein Git-Repository
* Gist: hierbei handelt es sich um kleine Schnipsel, die man verteilen oder beispielsweise in eine Dokumentation integrieren kann. Man könnte Gists zur Modularisierung einsetzen: https://gist.github.com/mobi3006/f94d4a11851932a681c9ce5f9e216b04
* GitHub-API: https://developer.github.com/

---

# Verbindungsaufbau
Die Authentifizierung kann über (ODER) 

* username/password
* ssh-key

erfolgen.

## Erstellung ssh-key
[siehe ssh](ssh.md) 

### Connection prüfen

Bei GitHub darf man sich NICHT mit dem Usernamen (= Email-Adresse) anmelden, sondern IMMER über den User ``git``:

    ssh -T git@github.com
    
