# Travis CI

Travis ist eine Continuous Integration Plattform, die beispielsweise häufig von GitHub-Projekten genutzt wird. Nach einem Commit im VCS werden entsprechende Travis-Jobs gestartet, um den Code zu bauen, zu testen, zu deployen, ...

## Spezifikation von Build und Deployment

Die Spezifikation von Build und Deployment erfolgt in Form der Travis-DSL. Hierzu legt man i. a. eine Datei namens `.travis.yml` in sein Git-Repository (ganz ähnlich zu [Jenkins](jenkins.md)).

## Travis Integration von GitHub Projekten

Man kann sich bei Travis mit seinen GitHub-Credentials einloggen und kann dort einen Travis-Job für eins seiner GitHub-Projekte definieren (die GitHub Projekte werden im Travis angezeigt ... [OpenId Connect like](openIdConnect.md)).

### Docker-Image Build

Mit einer solchen `.travis.yml` baut Travis auch Docker-Images (siehe [mobi3006/docker-groovy](https://github.com/mobi3006/docker-groovy/blob/master/.travis.yml)):

```yml
language: bash
services: docker

env:
  - VERSION=jdk7
  - VERSION=jdk7 VARIANT=alpine
  - VERSION=jre7
  - VERSION=jre7 VARIANT=alpine
  - VERSION=jdk8
  - VERSION=jdk8 VARIANT=alpine
  - VERSION=jre8
  - VERSION=jre8 VARIANT=alpine

before_script:
  - env | sort
  - cd "${VERSION}${VARIANT:+-$VARIANT}"
  - image="groovy:${VERSION}${VARIANT:+-$VARIANT}"

script:
  - docker build -t "${image}" .
  - cd ../test
  - ./run.sh "${image}" "2.4.8"
```

Für das Upload/Publishing in ein Docker-Repository (wie beispielsweise Dockerhub) wird allerdings noch eine Konfiguration benötigt ([Details hier](https://docs.travis-ci.com/user/docker/#Pushing-a-Docker-Image-to-a-Registry)), denn dazu muß man sich authentifizieren.