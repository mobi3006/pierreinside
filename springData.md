# Spring Data

* Refcardz: https://dzone.com/refcardz/core-spring-data

Spring Data ermöglicht die Persistenz von POJOs in Repositories untschiedlicher Couleur:

* relationale Datenbank: [Spring Data JPA](http://projects.spring.io/spring-data-jpa)
* NoSQL Datzenbanken
  * [Elasticsearch](http://projects.spring.io/spring-data-elasticsearch)
  * [Cassandra](http://projects.spring.io/spring-data-cassandra)
  * [Neo4j](http://projects.spring.io/spring-data-neo4j)
  * [Redis](http://projects.spring.io/spring-data-redis)
  * [Solr](http://projects.spring.io/spring-data-solr)
  * ...

## 10000 feet view

```java
@Entity
public class Person {

   private @Id @GeneratedValue String id;
   private String firstName;
   private String lastName;

   public Person(String firstName, String lastName) {
      this.firstName = firstName;
      this.lastName = lastName;
   }
}

---

public interface PersonRepository
   extends CrudRepository<Person, String> {}
}
```

Das ist alles, was man benötigt, um eine Person dann per

```
bla
```

in einer relationalen Datenbank (über das Modul ``spring-data-jpa``) zu persistieren.

So einfach kann Softwareentwicklung im 21. Jahrhundert sein.

## Spring Data Elasticsearch

## Anwendungsbeispiele

### Caching
