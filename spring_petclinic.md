# Spring Petclinic

* Kurzeinführung (Slides): https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application

Dieses Beispielprojekt zeigt Spring-Best-Practices. Ein sehr guter Einstieg, wenn man sich in das Spring-Ökosystem einarbeiten will.

## Varianten

Dieses Projekt gibt es in [verschiedenen Ausführungen](https://github.com/spring-projects/spring-petclinic):

* [mit Microservices](https://github.com/spring-petclinic/spring-petclinic-microservices)
* mit Angular
* mit ReactJS
* mit Kotlin
* ...

## Spring Petclinic Microservices

### Getting Started

```bash
git clone git@github.com:spring-petclinic/spring-petclinic-microservices.git
cd spring-petclinic-microservices
mvn clean install -PbuildDocker
docker-compose up
```

Nach kurzer Zeit ist die gesamte Landschaft einsatzbereit.

### IDEA

Das Projekt verwendet Lombok, das als Plugin in [IDEA](idea.md) installiert werden muß - ansonsten zeigt das Projekt Fehler an.