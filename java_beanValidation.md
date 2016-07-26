# Bean Validation
Java Bean Validation wird in [JSR-303](http://beanvalidation.org/1.0/spec/#d0e32) behandelt. Eine Implementierung ist in Java-JRE nicht enthalten, sondern muß extern hinzugefügt werden.

Verwendet man [Spring MVC](springMvc.md), so kann darüber die Parameterprüfung auf sehr angenehme (testbar, wiederverwendbar) Art durchgeführt werden.

---

# Referenzimplementierung: Hibernate Validator
* http://hibernate.org/validator/documentation/

```xml
<dependency>
  <groupid>org.hibernate</groupid>
  <artifactid>hibernate-validator</artifactid>
  <version>${version}</version>
</dependency>
```

---

# Eigene Validators

# Anpassung der Fehlermeldung
## i18n

