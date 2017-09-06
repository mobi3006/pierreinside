# JPA
* Refcardz: https://dzone.com/refcardz/getting-started-with-jpa

# Konzepte

## PersistenceContext

Der PersistenceContext verwaltet eine Menge von Entities (Unit of Work). Hier steckt die eigentliche Logik drin - nicht im Entity Manager. Wird eine Transaktion erzeugt, so wird ein neuer Persistence Context erzeugt und damit verbinden - wird die Transaction committed, dann wird der Persistence Context persistiert (= flush). Flushen ist in manchen Fällen (z. B. SQL-Queries, automatisierte Erzeugung von IDs, Logik in EntityCallbacks) aber zwischendurch notwendig ... bei `FlushModeType.AUTO` entscheidet der EntityManager wann geflushed werden sollte (bei `FlushModeType.COMMIT` wird immer erst beim Committen der Transaktion geflushed).

Beim lesenden Zugriff dient der PersistenceContext als First Level Cache (L1 - https://dzone.com/articles/jpa-caching), d. h. eine Finder-Methode wird IMMER die exakt gleiche Instanz eines Entity zurückliefern. Auf diese Weise arbeiten alle Applikationskomponenten auf dem gleichen Objekt sofern sie den gleichen PersistenceContext verwenden.

> ACHTUNG: Bei JTA Transaction Management kann EINE PersistenceContext-Instanz kann von MEHREREN EntityManager-Instanzen geshared werden (aka PersistenceContext Propagation) ... es handelt sich hier nicht zwangsläufig um eine 1:1 Beziehung (die aber prinzipiell auch möglich ist)

## Shared Cache - optional
Neben dem PersistenceContext (= First-Level-Cache) gibt es im Java-Layer noch einen Shared-Cache (Second-Level-Cache - L2), der über verschiedene/alle PersistenceContexts geteilt wird . 

### EclipseLink - Deaktivierung
* https://wiki.eclipse.org/EclipseLink/FAQ/How_to_disable_the_shared_cache%3F

Bei EclipseLink lässt sich der SharedCache folgendermaßen abschalten

* Entity-spezifisch: `@Cacheable(false)`
* applikationsspezifisch: `<shared-cache-mode>NONE</shared-cache-mode>`

## EntityManager
Der EntityManager ist die Schnittstelle der Anwendung zur Datenbank. Hierüber werden Queries gebaut und abgesetzt. Alle gelesenen Entities landen im PersistenceContext und stehen von da an unter EntityManager Kontrolle, d. h. alle Änderungen daran werden bei Bedarf auf die Datenbank geflushed und evtl. später auch committed.

Alle über den EntityManager geladenen Entitäten sind automatisch im Persistenzkontext DIESER EntityManager-Instanz (aka managed by EntityManager aka attached to EntityManager - im Gegensatz zu detached Entitäten), d. h. Änderungen an diesen Objekten haben potentiell (sofern die dahinterliegende Transaktion auch committet wird) Einfluß auf die zu speichernden Daten. Der EntityManager ist die In-Memory Repräsentation der Änderungen, die der Client auf der Datenbank durchführen will. Der EntityManager schreibt die Änderungen aber nicht sofort auf die Datenbank, sondern erst wenn es explizit gefordert ist (z. B. beim Commit) oder wenn er es für nötig hält (z. B. bei Datenbank-Queries). Bei lesenden Zugriffen dient der Entity Manager als Cache - wird beispielsweise eine Query abgesetzt, die Entities liefern soll, dann liefert die Datenbank-Query zunächst mal die IDs der Entitäten ... je nachdem ob die Entitäten bereits im Persistenzkontext liegen oder nicht wird die Entität von der Datenbank gelesen oder aus dem Persistenzkontext. 

Das macht diesen Ansatz recht attraktiv, weil der Entwickler eines Services - sobald die Transaktion gestartet ist und der EntityManager aufgebaut ist - transparent mit den attachten Entitäten arbeiten kann).

### 1:1 Beziehung - EntityManager und Transaktion
Mit einem `em.clear()` könnte man theoretisch eine `EntityManager`-Instanz für verschiedene Transaktionen wiederverwenden. Besser - weil so designed - ist die Erzeugung einer neuen `EnitytManager`-Instanz pro Transaktion.

Eine Transaktion kann nicht auf zwei unterschiedliche EntityManager-Instanzen aufgeteilt werden, da die Transaktionssteuerung Teil des EntityManagers ist (`em.getTransaction().begin()`).

ACHTUNG: auch lesende Zugriffe sollten in einer Transaktion laufen, da sie für das IsolationLevel relevante Locks setzen!!! Insofern sollte man auch für lesende Zugriffe nicht einfach einen EntityManager wiederverwenden. **JEDE BUSINESS-TRANSAKTION verwendet seine EIGENE EntityManager-Instanz!!!**

* https://stackoverflow.com/questions/26327274/do-you-need-a-database-transaction-for-reading-data

### em.persist(entity) vs em.merge(entity)
* [StackOverflow](https://stackoverflow.com/questions/1069992/jpa-entitymanager-why-use-persist-over-merge)

`em.persist(person)` übernimmt das übergebene Person-Objekt in den Persistenz-Kontext. Nachfolgende Änderungen daran (`person.setName("obiwan")`) wandern direkt in den Persistenz-Kontext und beeinflussen die später in die Datenbank geschriebene Zeile.

`em.merge(person)` hingegen sorgt dafür, daß eine Kopie von `person` angelegt wird und DIESE Kopie in den Persistenzkontext übernommen wird. Nachfolgende Änderungen an `person` haben KEINEN Einfluß auf die später in die Datenbank geschriebene Zeile.

## em.remove(entity)
Diese Operation kennzeichnet das `entity` als zu löschendes.

## em.clear()
Bei dieser Aktion werden ALLE Entities aus dem Persistenz-Kontext detached. Für das Programmiermodell ist das eine sehr gefährliche Aktion, weil der Nutzer einer detachten Entity (vielleicht an einer ganz anderen Stelle im Aufrufstack) davon nichts mitbekommt. Somit 

* werden nachfolgende Änderungen - in der Annahme, daß die Entity attached ist - nicht mehr persistiert
* führen lesende Zugriffe auf nochnicht geladenen Lazy-Properties zu einer Exception

```
Person person = em.find(Person.class, 1L);
callMethodThatClearsTheEntityManager(em);
person.setName("Pierre");                 // <== wird nicht persistiert
```

### em.flush()
Beim Flush werden Änderungen an Entitäten in der Datenbank sichtbar. Der Sichtbarkeitsscope hängt vom Isolation-Level ab. Bei einem Isolationlevel "READ UNCOMMITED" sind die Änderungen beispielsweise schon für parallele Transaktionen sichtbar ... es könnte aber sein, daß diese dann eine temporäre Welt sehen, die SO nie existieren wird, weil am Ende ein Rollback gemacht wird.

Wenn die Transaktion committed wird, erfolgt spätestens (automatisch) ein `flush`. Man kann konfigurieren, wann der EntityManager einen Flush auslösen soll:

* FlushModeType.COMMIT: Flush-on-commit
* FlushModeType.AUTO: Flush vor einer Query

> "JPA AUTO causes a flush to the database before a query is executed. **Simple operations like find don't require a flush since the library can handle the search, however queries would be much more complicated, and so if AUTO is set, it will flush it first.** If the mode is set to COMMIT, it will only flush the changes to the database upon a call to commit or flush. If COMMIT is set, and a query is run, it will not return results that have not been flushed." (https://stackoverflow.com/questions/24759664/what-is-the-difference-between-auto-commit-flushmodes)

#### Sollte man manuell flushen?
> "In some cases anyway you want the SQL instructions to be executed immediately; generally when you need the result of some side effects, like an autogenerated key, or a database trigger. [...] What em.flush() does is to empty the internal SQL instructions cache, and execute it immediately to the database. [...] Apart from triggering side effects, another reason to use flush() is if you want to be able to read the effects of an operation in the database using JPQL/HQL (e.g. in a test). **JPA cannot use cached data when executing these queries, so only stuff that's actually in the DB will be read.**"

Bei `FlushModeType.AUTO` wird vor jeder Query ein Flush getriggert. Sollte das mal nicht reichen (oder man verwendet grundsätzlich `FlushModeType.COMMIT`), dann kann es Sinn machen, `em.flush()` manuell zu triggern. Insbesondere in Tests, die die Datenbank am Ende des Tests unverändert zurücklassen sollen (und deshalb ein `em.getTransaction().rollback()` triggern) ist das `em.flush()` ein guter Freund. 

Tut man es hingegen im Produktivcode, dann sollte man das mit Bedacht machen. Letztlich überstimmt man - sofern `FlushModeType.AUTO` verwendet wird - die Entscheidung des EntityManagers, der auf Optimierung getrimmt ist ... vielleicht resultiert daraus eine schlechtere Performance.

### em.close()
Ein nicht geschlossener EntityManager verbraucht Resssourcen ... VERMEIDEN!!! 

Ausserdem könnten darin noch Transaktionen laufen, die nicht per Rollback/Commit beendet wurden. In diesem Fall könnte es sein, daß der EntityManager eine Datenbank-Connection aus dem limitierten (!!!) Connection-Pool verbrät (jede Connection verbraucht auf Datenbankseite relativ viele Ressourcen - deshalb ist die Connection-Pool-Größe passend zu wählen), die anderen 

> "In EclipseLink by default a connection is only held for the duration of an active (dirty) transaction. i.e. from the first modification or lock, until the commit or rollback. For non-transactional queries a connection is acquired on demand and returned after the query execution. This allows for maximal usage of connection pooling. So, normally em.close() does nothing. You can configure this using the "eclipselink.jdbc.exclusive-connection.mode" persistence unit property. "Always" will hold a connection for the life of the EntityManager." (https://stackoverflow.com/questions/13707183/when-is-a-connection-returned-to-the-connection-pool-in-a-jpa-application)

# SQL Queries
* [Heise Artikel von Thorben Janssen](https://www.heise.de/developer/artikel/Datenbankabfragen-mit-JPA-mehr-als-nur-em-find-und-JPQL-3787881.html)