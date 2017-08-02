# JPA
* Refcardz: https://dzone.com/refcardz/getting-started-with-jpa

# Konzepte

## EntityManager
Alle über den EntityManager geladenen Entitäten sind automatisch im Persistenzkontext DIESER EntityManager-Instanz, d. h. Änderungen an diesen Objekten haben potentiell (sofern die dahinterliegende Transaktion auch committet wird) Einfluß auf die zu speichernden Daten.

Das macht diesen Ansatz recht attraktiv, weil der Entwickler eines Services - sobald die Transaktion gestartet ist und der EntityManager aufgebaut ist - transparent mit den attachten  Entitäten arbeiten kann).

## em.persist() vs em.merge
* [StackOverflow](https://stackoverflow.com/questions/1069992/jpa-entitymanager-why-use-persist-over-merge)

`em.persist(person)` übernimmt das übergebene Person-Objekt in den Persistenz-Kontext. Nachfolgende Änderungen daran (`person.setName("obiwan")`) wandern direkt in den Persistenz-Kontext und beeinflussen die später in die Datenbank geschriebene Zeile.

`em.merge(person)` hingegen sorgt dafür, daß eine Kopie von `person` angelegt wird und DIESE Kopie in den Persistenzkontext übernommen wird. Nachfolgende Änderungen an `person` haben KEINEN Einfluß auf die später in die Datenbank geschriebene Zeile.

## em.flush()
Beim Flush werden Änderungen an Entitäten in der Datenbank sichtbar. Der Sichtbarkeitsscope hängt vom Isolation-Level ab. Bei einem Isolationlevel "READ UNCOMMITED" sind die Änderungen beispielsweise schon für parallele Transaktionen sichtbar ... es könnte aber sein, daß diese dann eine temporäre Welt sehen, die SO nie existieren wird, weil am Ende ein Rollback gemacht wird.

Wenn die Transaktion committed wird, erfolgt spätestens (automatisch) ein `flush`. Man kann konfigurieren, wann der EntityManager einen Flush auslösen soll:

* FlushModeType.COMMIT: Flush-on-commit
* FlushModeType.AUTO> Flush vor einer Query

> "JPA AUTO causes a flush to the database before a query is executed. **Simple operations like find don't require a flush since the library can handle the search, however queries would be much more complicated, and so if AUTO is set, it will flush it first.** If the mode is set to COMMIT, it will only flush the changes to the database upon a call to commit or flush. If COMMIT is set, and a query is run, it will not return results that have not been flushed." (https://stackoverflow.com/questions/24759664/what-is-the-difference-between-auto-commit-flushmodes)

