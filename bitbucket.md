# Bitbucket aka Stash

HINWEIS: Die (selbstgehostete) On-Premise-Version von BitBucket wird unter dem Namen **Stash** vertrieben.

Mit BitBucket steht ein Git/Mercurial-Hoster zur Verfügung, der kostenlos private Repositories ermöglicht. GitHub ist zwar einer der bekanntesten Git-Repository-Hoster, dafür sind aber nur öffentliche Repositories kostenlos.

BitBucket liefert aber nicht nur Git-Repositories, sondern auch 

* JIRA (Bug-Tracking) mit Git-Workflows
* Confluence (Wiki)
* Pipeline (Build-and-Deployment)

Deshalb ist diese Plattform auf jeden Fall einen Blick wert ...

---

## Getting Started

Nach Anlage eines BitBucket-Accounts hinterlegt man am besten gleich mal den ssh-Key für eine passwortlose Authentifizierung.

Über die Webapplikation läßt sich schnell eine privates/public Repository anlegen und per Git-Client lokal clonen:

```bash
git clone git@bitbucket.org:mobi3006/de.cachaca.learn.kubernetes.git
```

---

## Verbindungsaufbau

Die Authentifizierung kann über (ODER) 

* username/password ... bei Verwendung des HTTPS-Protokolls (``git clone https://mobi3006@bitbucket.org/mobi3006/de.cachaca.learn.kubernetes.git``) oder SSH-Protokolls
* ssh-key ... bei Verwendung des SSH-Protokolls (``git clone git@bitbucket.org:mobi3006/de.cachaca.learn.kubernetes.git``)

erfolgen.

### Erstellung ssh-key

* [siehe ssh](ssh.md) 

### Connection prüfen

Bei GitHub darf man sich NICHT mit dem Usernamen (= Email-Adresse) anmelden, sondern IMMER über den User ``git``:

```bash
ssh -T git@bitbucket.com
```

## Branch Typen

Man unterscheidet

* Release-Branches
* Feature-Branches
* Bugfix-Branches
* Hotfix-Branches

die nach einem Commit unterschiedlich behandelt werden könnnen. Letztlich wird darüber nur der Branchname prefixed (z. B. `bugfix/myfix`). Über den Branchnamen können dann entsprechende Trigger in der Build-Pipeline definiert werden. So wird man beispielsweise bei einem Release-Branch ein Deployment triggern und bei einem Feature-Branch evtl. nicht. Letztlich hat da entsprechende Freiheiten in der Build-Pipeline, die man u. a. mit [Bamboo](bamboo.md) abbilden kann. 

## Automatisches Mergen

* [Automatic Branch merging](https://confluence.atlassian.com/bitbucketserver0414/automatic-branch-merging-895367651.html):

Stash unterstützt automatisches Mergen in jüngere Release-Branches - Voraussetzung dafür ist die Verwendung von Pull-Requests für Merges. Das reduziert den manuellen Aufwand bei der Pflege mehrerer Branches enorm. Hierzu leitet es i. a. aus den Branchnamen die Mergerichtung ab:

```properties
1.0
  => 1.1
     => 1.2
        => 1.2.1
```

Wenn man also nach Branch `1.0` committed, dann wird Stash diese Änderung automatisch nach `1.1`, `1.2` und `1.2.1` mergen. Treten dabei Merge-Konflikte auf, so muß man den Merge manuell durchführen. Beispielsweise indem vom Zielbranch ein Branch erstellt wird (aka Merge-Branch) und dann dorthin gemergt wird `cd MERGE_BRANCH && git pull origin SOURCEBRANCH`. Dann löst man die Konflikte auf, commited, erstellt einen Pull-Request und mergt den.