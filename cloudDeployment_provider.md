# Cloud Deployment Provider

**Software-as-a-Service:**
* [GitHub](https://github.com/): Hosting von Source-Code ... und mehr
* [Travis-CI](https://travis-ci.org/)
  * hiermit lassen sich Builds von GitHub-Projekten automatisiert triggern - die Deployment-Artefakte werden nach GitHub-Releases geschoben
  * [kostenlos](https://travis-ci.org/) für public Repositories 
  * [Kommerziell](https://travis-ci.com/) für private Repositories 

**Infrastructure-as-a-Service:**
* [Amazon Web Services](https://aws.amazon.com) 
* [Digital Ocean](https://www.digitalocean.com/)
* [Scaleway](https://www.scaleway.com/) 
  * Bare Metal auf ARM-Architektur

**Platform-as-a-Service:**
* [Heroku](https://devcenter.heroku.com/categories/java)
* [CloudFoundry](https://www.cloudfoundry.org)

---

# Travis
* https://docs.travis-ci.com/


---

# Heroku
Heroku bietet ein komfortables Deployment in seiner Plattform an. Über ein CLI (sog. Toolbett) wird die Anwendnung gemanged (deploy, start, stop, scale, ...).

## Getting Started
* https://devcenter.heroku.com/articles/getting-started-with-java#set-up

Schritte:
* kostenlosen Account anlegen (ein Mini-Deployment mit SLA-Einschränkungen kann kostenlos betrieben werden)
* Toolbett installieren
* ``heroku create``
  * dabei wird ein Remote Git Repository angelegt und mit dem lokalen Git-Repository als Remote-Location verknüpft (https://git.heroku.com/myapp.git)
* ``git push heroku master``
* http://warm-eyrie-9006.herokuapp.com

## Vagrant Support
[Vagrant](vagrant.md) hat einen Heroku-Push-Provider, so daß Anwendungen komfortabel per

    vagrant push
    
auf Heroku deployed werden können.

