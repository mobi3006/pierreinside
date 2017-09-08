# JPA
* Refcardz: https://dzone.com/refcardz/getting-started-with-jpa
* [Flush and Clear Anti-Patterns](http://www.developerfusion.com/article/84945/flush-and-clear-or-mapping-antipatterns/)

# Konzepte

## PersistenceContext (Unit-of-Work)

Der PersistenceContext verwaltet eine Menge von Entities (Unit of Work). Hier steckt die eigentliche Logik drin - nicht im Entity Manager. Wird eine Transaktion erzeugt, so wird ein neuer Persistence Context erzeugt und damit verbinden - wird die Transaction committed, dann wird der Persistence Context persistiert (= flush). Flushen ist in manchen Fällen (z. B. SQL-Queries, automatisierte Erzeugung von IDs, Logik in EntityCallbacks) aber zwischendurch notwendig ... bei `FlushModeType.AUTO` entscheidet der EntityManager wann geflushed werden sollte (bei `FlushModeType.COMMIT` wird immer erst beim Committen der Transaktion geflushed).

Beim lesenden Zugriff dient der PersistenceContext als First Level Cache (L1 - https://dzone.com/articles/jpa-caching), d. h. eine Finder-Methode wird IMMER die exakt gleiche Instanz eines Entity zurückliefern. Auf diese Weise arbeiten alle Applikationskomponenten auf dem gleichen Objekt sofern sie den gleichen PersistenceContext verwenden.

> ACHTUNG: Bei JTA Transaction Management kann EINE PersistenceContext-Instanz kann von MEHREREN EntityManager-Instanzen geshared werden (aka PersistenceContext Propagation) ... es handelt sich hier nicht zwangsläufig um eine 1:1 Beziehung (die aber prinzipiell auch möglich ist)

## Shared Cache - optional aber Default
* https://abhirockzz.wordpress.com/2016/05/22/notes-on-jpa-l2-caching/

Neben dem PersistenceContext (= First-Level-Cache - gebunden an EINE Transaktion) gibt es im Java-Layer noch einen Shared-Cache (Second-Level-Cache - L2), der über verschiedene/alle PersistenceContexts/Transaktionen auf Ebene der `EntityManagerFactory` geteilt wird.

Da dieser Cache allerdings mehrere Transaktionen bedient kann es bei einem zwischenzeitlichen `em.flush(); em.clear()` zu der Situation kommen, daß der transaktionale Cache (der PErsistenceContext des EntityManagers) die Instanz nicht mehr enthält. Der 2nd-Level-Cache enthält aber KEINE Informationen aus der aktuellen - noch nicht committeten Transaktion. Er liefert dann veraltete Informationen. 

### EclipseLink - Deaktivierung
* https://wiki.eclipse.org/EclipseLink/FAQ/How_to_disable_the_shared_cache%3F

Bei EclipseLink lässt sich der SharedCache folgendermaßen abschalten

* Entity-spezifisch: `@Cacheable(false)`
* applikationsspezifisch: `<shared-cache-mode>NONE</shared-cache-mode>`

## EntityManager
Der EntityManager (mit der `Hibernate Session` gleichzusetzen) ist die Schnittstelle der Anwendung zur Datenbank. Hierüber werden Queries gebaut und abgesetzt. Alle gelesenen Entities landen im PersistenceContext und stehen von da an unter EntityManager Kontrolle, d. h. alle Änderungen daran werden bei Bedarf auf die Datenbank geflushed und evtl. später auch committed.

Alle über den EntityManager geladenen Entitäten sind automatisch im Persistenzkontext DIESER EntityManager-Instanz (aka managed by EntityManager aka attached to EntityManager - im Gegensatz zu detached Entitäten), d. h. Änderungen an diesen Objekten haben potentiell (sofern die dahinterliegende Transaktion auch committet wird) Einfluß auf die zu speichernden Daten. Der EntityManager ist die In-Memory Repräsentation der Änderungen (Change-Set), die der Client auf der Datenbank durchführen will. Der EntityManager schreibt die Änderungen aber nicht sofort auf die Datenbank, sondern erst wenn er es muß (z. B. beim Commit), wenn er explizit gefordert wird (`em.flush()`) oder wenn er es für nötig hält (z. B. bei Datenbank-Queries ... siehe Abschnitt *"Warum flusht der EntityManager bei einer Query?"*). Bei lesenden Zugriffen dient der Entity Manager als Cache - wird beispielsweise eine Query abgesetzt, die Entities liefern soll, dann liefert die Datenbank-Query zunächst mal die IDs der Entitäten ... je nachdem ob die Entitäten bereits im Persistenzkontext liegen oder nicht wird die Entität von der Datenbank gelesen oder aus dem Persistenzkontext. 

Das macht diesen Ansatz recht attraktiv, weil der Entwickler eines Services - sobald die Transaktion gestartet ist und der EntityManager aufgebaut ist - transparent in seiner objektorientierten Welt arbeiten kann. Die sog. Unit-of-Work (= Change-Set) wird automatisch gepflegt und beim Commit der Transaktion tatsächlich persistiert (evtl. auch schon früher ... durch ein Flush).

### 1:1 Beziehung - EntityManager und Transaktion
Der EntityManager verwaltet Transaktionen (`EntityTransaction tx = em.getTransaction().begin()`,  `tx.commit()`, `tx.rollback()`) und ist somit eng von Natur aus schon eine 1:1 oder eine 1:n Verknüfpung.

Mit einem `em.clear()` könnte man theoretisch eine `EntityManager`-Instanz für verschiedene Transaktionen wiederverwenden (mit großem Aufwand vielleicht sogar bei parallel laufenden Transaktionen). Besser - weil so designed - ist 

* Erzeugung einer neuen `EnitytManager`-Instanz pro Transaktion
* keine Reuse der EntityManager-Instanz für weitere Transaktionen

Eine Transaktion kann nicht auf zwei unterschiedliche EntityManager-Instanzen aufgeteilt werden, da die Transaktionssteuerung Teil des EntityManagers ist (`em.getTransaction().begin()`).

ACHTUNG: auch lesende Zugriffe sollten in einer Transaktion laufen, da sie für das IsolationLevel relevante Locks setzen!!! Insofern sollte man auch für lesende Zugriffe nicht einfach einen EntityManager wiederverwenden. **JEDE BUSINESS-TRANSAKTION verwendet seine EIGENE EntityManager-Instanz!!!**

* https://stackoverflow.com/questions/26327274/do-you-need-a-database-transaction-for-reading-data

### em.persist(entity) vs. em.merge(entity)
* [StackOverflow](https://stackoverflow.com/questions/1069992/jpa-entitymanager-why-use-persist-over-merge)

`em.persist(person)` übernimmt das übergebene Person-Objekt in den Persistenz-Kontext. Nachfolgende Änderungen daran (`person.setName("obiwan")`) wandern direkt in den Persistenz-Kontext und beeinflussen die später in die Datenbank geschriebene Zeile.

`em.merge(person)` hingegen sorgt dafür, daß eine Kopie von `person` angelegt wird und DIESE Kopie in den Persistenzkontext übernommen wird. Nachfolgende Änderungen an `person` haben KEINEN Einfluß auf die später in die Datenbank geschriebene Zeile.

## em.remove(entity)
Diese Operation kennzeichnet das `entity` als zu löschendes.

## em.clear()
* [Flush and Clear Anti-Patterns](http://www.developerfusion.com/article/84945/flush-and-clear-or-mapping-antipatterns/)

Bei dieser Aktion werden ALLE Entities aus dem Persistenz-Kontext detached. Für das Programmiermodell ist das eine sehr gefährliche Aktion, weil der Nutzer einer detachten Entity (vielleicht an einer ganz anderen Stelle im Aufrufstack) davon nichts mitbekommt. Somit 

* werden nachfolgende Änderungen - in der Annahme, daß die Entity attached ist - nicht mehr persistiert
```
Person person = em.find(Person.class, 1L);
callMethodThatClearsTheEntityManager(em);
person.setName("Pierre");                 // <== wird nicht persistiert
```

* führen lesende Zugriffe auf noch nicht geladenen Lazy-Properties zu einer Exception

```
Person person = em.find(Person.class, 1L);
callMethodThatClearsTheEntityManager(em);
person.getBankAccounts();                 // <== EXCEPTION
```

EXTREM schwierig wird das Programmiermodell, wenn man den JPA-Shared-Cache (L2-Cache) verwendet, weil dann bei Finder-Methoden folgendes passiert (unter der Annahme, daß das Entity in der Transaktion geändert wurde):

* die Datenbank liefert die ID des Entities
* da das Entity aufgrund des `em.clear()` nicht mehr in L1-Cache (PersistenceContext) ist, wird der Shared-Cache genutzt, der evtl. eine alte Version des Entities enthält
* bei einem nachfolgenden update auf dem Entity kommt es - im besten Fall zu einer `OptimisticLockException` ... im worst-case wird das Entity mit einem alten Wert überschrieben

Aus Ressourcengründen macht es gelegentlich Sinn `em.clear()` aufzurufen, um die geladenen - und nicht mehr benötigten Entities - vom Heap zu werfen. Dann macht es meistens Sinn, vorher ein `em.flush()` aufzurufen, um die bereits gemachten Änderungen nicht zu verlieren. 

EMPFEHLUNG: 
* schärfe das Problemverständnis
* versuche KLARE Regeln aufzustellen, in welchem Layer zu welchem Zweck `em.clear()` wie aufzurufen ist
* muß es ein `em.clear()` sein oder genügt vielleicht ein weniger invasiver Eingriff (z. B. gezieltes detachen bestimmter Entities in einer Methode, die das Laden diese Entities ausgelöst hat)

### em.flush()
Beim Flush werden Änderungen an Entitäten in die Datenbank geschrieben - hier kommen dann auch erst Datenbankcontraints ins Spiel. Ob die Änderungen nur für die laufende Transaktion oder auch parallel Transaktionen sichtbar sind, hängt vom Isolation-Level ab. Bei einem Isolationlevel "READ UNCOMMITED" sind die Änderungen beispielsweise schon für parallele Transaktionen sichtbar ... es könnte aber sein, daß diese dann eine temporäre Welt sehen, die SO nie existieren wird, weil am Ende ein Rollback gemacht wird.

Wenn die Transaktion committed wird, erfolgt spätestens (automatisch) ein `flush`. Man kann konfigurieren, wann der EntityManager einen Flush auslösen soll:

* FlushModeType.COMMIT: Flush-only-on-commit
* FlushModeType.AUTO: Flush-decision-by-EntityManager

#### Warum flusht der EntityManager bei einer Query (`FlushModeType.AUTO`)?
> "JPA AUTO causes a flush to the database before a query is executed. **Simple operations like find don't require a flush since the library can handle the search, however queries would be much more complicated, and so if AUTO is set, it will flush it first.** If the mode is set to COMMIT, it will only flush the changes to the database upon a call to commit or flush. If COMMIT is set, and a query is run, it will not return results that have not been flushed." (https://stackoverflow.com/questions/24759664/what-is-the-difference-between-auto-commit-flushmodes)

Datenbankabfragen gehen auch beim Einsatz von JPA normalerweise über die Datenbank. Die Datenbank liefert aber zunächst mal nur IDs zurück und der EntityManager schaut dann in seinem PersistenceContext nach, ob diese Instanz bereits als Java-Objekt bereitgestellt wurde oder nicht.

* Fall 1: Datenbank-Zeile (= Entity) wurde bereits zu einem Objekt
  * in dem Fall muß ganau die gleiche Instanz des Objekts an den Aufrufer zurückgegeben werden (es erfolgt kein erneutes Lesen/Abgleichen der Daten!!!), weil eine Instanz einer Entity nur ein einziges mal in einem PersistenceContext existieren darf (das gilt nur dür attachte Entities - nicht für detached Entities).
* Fall 2: Datenbank-Zeile (= Entity) wird zum ersten Mal über eine Query bereitgestellt
  * in diesem Fall wird die Zeile in ein Objekt umgewandelt (evtl. nicht vollständig - Lazy-Loading), in den PersistenceContext eingehangen und an den Aufrufer zurückgeliefert.
  
Da die Datenbankabfragen über die Datenbank abgebildet werden (dafür ist die relationale Sichweise optimiert), müssen neu angelegte Entities auch in der Datenbank (evtl. noch nicht für andere - Isolation-Level!!!) sichtbar sein. Deshalb muß bei einer Query evtl. vorab ein flush gemacht werden, das vom EntityManager automatisch getriggert wird.
  
#### Sollte man explizit im Anwendungscode flushen?
> Ich lasse hier Isolation-Level READ-UNCOMMITTED außer Acht ... bei diesem Ansatz kann es vielleicht mehr Sinn machen, explizit zu flushen (ich habe damit keine Erfahrungen)

Normalerweise sollte man dem EntityManager überlassen ... ABER ...

> "In some cases anyway you want the SQL instructions to be executed immediately; generally when you need the result of some side effects, like an autogenerated key, or a database trigger. [...] What em.flush() does is to empty the internal SQL instructions cache, and execute it immediately to the database. [...] Apart from triggering side effects, another reason to use flush() is if you want to be able to read the effects of an operation in the database using JPQL/HQL (e.g. in a test). **JPA cannot use cached data when executing these queries, so only stuff that's actually in the DB will be read.**"

Bei `FlushModeType.AUTO` wird vor jeder Query ein Flush getriggert. Sollte das mal nicht reichen (oder man verwendet grundsätzlich `FlushModeType.COMMIT`), dann kann es Sinn machen, `em.flush()` manuell zu triggern. Insbesondere in Tests, die die Datenbank am Ende des Tests unverändert zurücklassen sollen (und deshalb ein `em.getTransaction().rollback()` triggern) ist das `em.flush()` ein guter Freund. 

Tut man es hingegen im Produktivcode, dann sollte man das mit Bedacht machen. Letztlich überstimmt man - sofern `FlushModeType.AUTO` verwendet wird - die Entscheidung des EntityManagers, der auf Optimierung getrimmt ist ... vielleicht resultiert daraus eine schlechtere Performance.

### em.close()
Ein nicht geschlossener EntityManager verbraucht Resssourcen ... VERMEIDEN!!! 

Ausserdem könnten darin noch Transaktionen laufen, die nicht per Rollback/Commit beendet wurden. In diesem Fall könnte es sein, daß der EntityManager eine Datenbank-Connection aus dem limitierten (!!!) Connection-Pool verbrät (jede Connection verbraucht auf Datenbankseite relativ viele Ressourcen - deshalb ist die Connection-Pool-Größe passend zu wählen), die anderen 

> "In EclipseLink by default a connection is only held for the duration of an active (dirty) transaction. i.e. from the first modification or lock, until the commit or rollback. For non-transactional queries a connection is acquired on demand and returned after the query execution. This allows for maximal usage of connection pooling. So, normally em.close() does nothing. You can configure this using the "eclipselink.jdbc.exclusive-connection.mode" persistence unit property. "Always" will hold a connection for the life of the EntityManager." (https://stackoverflow.com/questions/13707183/when-is-a-connection-returned-to-the-connection-pool-in-a-jpa-application)

# SQL Queries
* [Heise Artikel von Thorben Janssen](https://www.heise.de/developer/artikel/Datenbankabfragen-mit-JPA-mehr-als-nur-em-find-und-JPQL-3787881.html)

# Konzeptuelle Probleme

## Lazy-Loading
Sind Relationen (statisch) lazy modelliert, dann werden sie erst beim tatssächlichen Zugriff über die Anwendnung aufgelöst. Das sorgt dafür, daß eine weitere Query pro Relation läuft - bei einer Vielzahl von verknüpften und zugegriffenen Entities sorgt das für viele Queries ... ein eager-Loading wäre mit performanteren Queries möglich gewesen.

Leider hat man in einer Anwendung evtl. mehere Useage-Szenarien und müßte/wollte das im Einzelfall entscheiden - geht aber nicht. 

## Detached Entities
... sehen nicht anders aus als attached entities. Das kompliziert das Programmiermodell, weil man im Applikationscode evtl. von einem attached Entity ausgeht, das aber zur Laufzeit detached ist. Das hat u. a. folgende Auswirkungen

* Änderungen werden nicht mehr persistiert
* Entity-Instanzen werden nicht mehr geshared
* navigation auf lazy-loaded entities führt zu einer Exception

# Bewertung
JPA ist ganz schön zu modellieren und versteckt das dahinterliegende relationale Modell. Für die Entwicklung der OO-Anwendungen ist das ganz nett ... zudem hat man ganz brauchbare Zusatzfeatures

* lazy-Loading
* Change-Set-Persistence (man muß sich nicht selbst um die Unit-of-Work kümmern)

Das ist grundsätzlich eine schöne Sache und es funktioniert auch gut mit geringen Datenmengen, ohne daß man tiefes Wissen über O/R-Mapping haben muß ...

> "The simplicity of the entrance into the world of O/R mapping however gives a wrong impression of the complexity of these frameworks. Working with more complex applications you soon realize that you should know the details of framework implementation to be able to use them in the best possible way." (http://www.developerfusion.com/article/84945/flush-and-clear-or-mapping-antipatterns/) 

Schwierig wird es dann aber, wenn man auf riesigen Datenmengen 

* noch performante Queries braucht
  * das Programmiermodell verleitet dazu auf riesigen Result-Sets rumzurüdeln wo es eigentlich ein schnelle Bulk-`UPDATE` tun würde - in einem Bruchteil der Zeit und ganz ohne geladene (fette) Entities (vielleicht nur mit IDs oder gar ganz ohne)
* Ressourcen reduzieren muß (`em.clear()` ist doch sehr gefährlich)