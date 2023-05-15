# Zero-Trust-Network

* [Motivation](https://www.youtube.com/watch?v=2LOe7glGj8U)

Im Zuge der Cloud-Migration braucht es neue Lösungen.

---

## Problem

* [Zscaler Private Access: Secure and Personalized Access to Internal Apps](https://www.youtube.com/watch?v=fzOaz3YcrPk)
* [Your Cloud Transformation Journey with Zscaler](https://www.youtube.com/watch?v=4QxL_0W5ulo)

Früher verwendete man (Castle-Ansatz)

* das lokale Firmennetz (working onsite)
* VPNs (working from remote)

um die OnPrem-Infrastruktur vor unbefugtem Zugriff zu schützen. Einmal authentifiziert (Network Access garantiert zunächst einmal Zugriff auf ALLE Applikationen in diesem Netzwerk) und im Firmennetz gab es dann aber nur noch dezentrale Prüfungen, ob jemand authorisiert üb er folgende Methoden

* IP-Adresse
* ssh-keys
* username/password
* Token

Mittlerweile laufen viele (oder sogar die meisten) Unternehmensanwendungen aber gar nicht mehr im eigenen Netz, sondern werden von SaaS/IaaS-Anbietern (Office 365, GitHub, Salesforce, SonarCloud, AWS, ...) in der Cloud bereitgestellt (manche Anwendungen werden aber evtl. für immer OnPrem verbleiben). Diese Anwendungen sind unternehmensintern, aber grundsätzlich dennoch private - niemand ausser den Mitarbeiten soll Zugriff haben.

Integrationen anderer Dienste (im Sinne von Cloud-Native) sind mit IP-Whitelisting-Methoden schwer zu realisieren, weil Cloud-Native Anwendungen häufig gar keine feste IP-Adresse haben und auch nicht supporten (oder nur gegen Aufpreis). Will man also beispielsweise eine Sonar-Cloud oder Lacework damit beauftragen den Code in GitHub zu scannen, dann funktioniert das nicht gut, wenn man den GitHub-Code über IP-Whitelisting geschützt hat.

---


---

## Zscaler

* [Unterschied VPN vs. Zscaler - Demo](https://www.youtube.com/watch?v=gvNMh4-8jiE)

Die Idee bei Zscaler ist der DNS und deshalb funktioniert es auch nur, wenn Full-Qualified-Domain-Names (FQDN) verwendet werden - IP-Adressen funktionieren nicht (und sind in einem skalierbaren Umfeld auch konzeptuell keine gute Idee). Der Zscaler Client sorgt dafür, dass auf dem Endgerät ein Zscaler DNS verwendet wird, der

* natürlich unternehmensinterne Domain Namen auflösen kann
* aber auch öffentliche Domain Namen auflöst

Der Zscaler DNS liefert dann eine öffentliche Zscaler IP-Adresse - die IP-Adresse eines Proxies (für `github.com` evtl. `100.85.2.4` statt der üblichen `140.82.121.3`). 

### Vorteil - Sicherheit

Der Proxy authorisiert dann beim HTTP-Request den Zugriff - und zwar bei JEDEM Zugriff. Deshalb nennt man das auch Zero-Trust ... es erfolgt keine längerfristige Vertrauensbeziehung wie das beispielsweise bei einer VPN-Verbindung der Fall war - einmal autorsiert = immer authorisiert.

In Zscaler-Speech ist man mit einer Application (z. B. GitHub-Organisation "foobar") verbunden ... nicht mit einem Netzwerk. Ein Portscan auf einem Zscaler-Endgerät liefert nichts - wohingegen ein VPN-Endgerät i. a. relativ viele Server/Ports liefert, die grundsätzlich mal alle adressiert werden können (aber HOFFENTLICH alle protected sind ... was natürlich nicht immer der Fall ist).

Auf diese Weise agiert Zscaler als zentraler Guard für jeglichen Zugriff (u. a. Blocking von Websites, Ports). Die Policies können jederzeit geändert werden und greifen schon beim nächsten Request.

Im Unternehmen hat man zudem unterschiedliche Rollen (Dev, QA, Cloud, Support, Manager, ...) mit unterschiedlichen Berechtigungen (Stichwort Separation-of-Concerns). Das kann man fein-granular mit Zscaler steuern und so sicherer und natürlich auch more compliant zu werden.

In der Zusammenarbeit mit Partnern (Integration Szenario) möchte man einem Partner evtl. Zugriff auf eine einzige kleine Anwendung geben - nicht auf das gesamte Netzwerk.

### Vorteil - Network Switching

Wechselt man bei einer VPN Verbindung das Netzwerk (von einem WLAN zu einem anderen oder zwischen WLAN und LTE), so bricht der VPN Tunnel ab und muss neu aufgebaut werden (mit einer nervigen Two-Factor-Authentication). Im mobilen Umfeld (z. B. Reisen mit der Bahn, kann das schon mal sehr nervig sein oúnd jeglichen Fokus zerstören). Im Zscaler-Umfeld ist das Problemlos, weil es nahtlos funktioniert ... entweder ist Internet da oder nicht - seamless.

### Vorteil - Scalability und Änderbarkeit

Hinter einem Zscaler-Anwendungs-Proxy kann man die Komplexität der dahinterliegenden Infrastruktur verbergen und auch für den Enduser transparent verändern. Das ermöglicht auch eine Änderung der Infrastruktur in Migrationsszenarien (Stichwort Cloud-Transformation).

Andererseits sind OnPrem-Anwendungen nicht mehr zu unterscheiden (seamless) von Cloud-Anwendungen ... man verwendet einen öffentlichen FQDN wie "https://myapp.mycompany.com" und nicht mehr "https://myapp.mycompany.loc".

### Vorteil - Administration

Zunächst mal bedarf es keines (zu administrierenden) VPN-Servers ... Zscaler hostet die notwendige Infrastruktur (als Dienstleistung gegen Bezahlung).

Die Reports eines VPN sind auf Low-Level ... Zscaler liefert Informnationen auf Applikationsebene. Hier kann man interessante Informationen rausziehen, um diese Applikationen evtl. weiter zu verbessern oder vielleicht sogar einzustellen (weil sie gar nicht mehr genutzt werden).

### Komponente Zscaler Internet Access (ZIA)

Zugriff auf External-Managed Applications (SaaS oder Internet generell).

### Komponente Zscaler Private Access (ZPA)

Zugriff auf unternehmensintern-Managed Applications (OnPrem oder in der Cloud, beispielsweise SaaS-Lösungen hosted auf AWS-Cloud).

Über dieses Komponente wird der Zugriff eines Users auf Unternehmensanwendungen geregelt. Policies entscheiden ZENTRAL wer auf was zugreifen darf ... kein IP-Whitelisting mehr und somit viel fein-granularer als das damals war. Zudem ganz unabhängig von lokalen Authorisierungen (über ssh-keys oder username/password), die aber natürlich weiterhin existieren können.

Anwendungen stehen erst nach Autorisierungsprüfung für einen Zugriff zur Verfügung wie an dieser Stelle im Video veranschaulicht:

* [Your Cloud Transformation Journey with Zscaler](https://youtu.be/4QxL_0W5ulo?t=360)

OnPrem Hosted Applications verwenden einen Tunnel vom OnPrem-Server in die Zscaler Cloud, der Zscaler-Agent auf dem OnPrem-Server baut den Tunnel auf und somit ist die Zscaler Integration unter der Kontrolle des Unternehmens.

### Architecture

* Control Plane
  * Administrationsoberfläche für Administratoren
  * Users und deren Berechtigungen (= Policies)
  * Central Authority
* Data Plane
  * Contentanalyse (Traffic)
* Statistics Plane
  * Logging

Ein paar interessante Fakten (oder Verkaufsargumente aus den Hochglanzprospekten)

* Zscaler arbeitet nur mit anonymisierten User-IDs, die nur die Central Authority identifizieren kann
* Zscaler Traffic ist AUSSCHLIESSLICH im Memory - es wird angebilich nichts auf eine Festplatte geschrieben
  * ausschließlich Logs MÜSSEN (z. B. wegen [SIEM](https://www.logpoint.com/de/was-ist-siem/)) persistiert werden. Das geschieht über Log-Router, die zum jeweiligen User wissen wo die Logs gespeichert werden dürfen (USA, Europa, China, Russland, Schweiz, Private)

---

## Cloudflare
