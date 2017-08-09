# JPA - TX Handling

---

* [kumaranuj - SEHR GUTER ARTIKEL](http://www.kumaranuj.com/2013/06/jpa-2-entitymanagers-transactions-and.html)
* http://piotrnowicki.com/2012/11/types-of-entitymanagers-application-managed-entitymanager/

JPA kennt drei Formen von Entity Managern (EM):

* Java-EE-Ansatz: Container Managed (CM) EM - basieren auf JTA Transaktionen (die es nicht im Java SE gibt)
  * transaction scoped CM EM
  * extended scoped CM EM
* Application Managed (AM) EM

JPA kennt folgende Transaction Management Typen:

* RESOURCE LOCAL
  * hier übernimmt i. a. der Datenbanktreiber das Transaktionmanagement
  * man ist damit beschränkt auf EINE transaktionale Ressource (i. a. die Datenbank-Connection)
* JTA (= GLOBAL)
  * hier übernimmt der JEE Container das Transaktionmanagement
  * hier kann man mehrere transaktionale Ressourcen (Database Connection, JMS Connection, ...) an eine Transaktion binden, um so beispielsweise über das XA-Protokoll eine verteilte Transaktion abzubilden.

## Container managed transaction scoped EM
Das ist die am häufigsten anzutreffende Form von Entity Managern. Diese EM sind stateless und dadurch threadsafe - jeder Methodenaufruf läuft in einer eigenen Transaktion und am Ende der Methode wird die Transaktion beendet (commit/rollback). Aber der (veränderte) Zustand der Entitäten muß natürlich irgendwo gespeichert werden ... er wird ja i. a. nicht sofort für alle sichtbar in die Datenbank geschrieben. Der Status liegt im ``PersistenceContext``, der an der JTA-Transaktion hängt (ACHTUNG: solche EntityManager benötigen JTA-Transactions!!!).

```
@Stateless
public class EmployeeServiceImpl implements EmployeeService {

    @PersistenceContext(
       unitName="EmployeeService", 
       type=PersistenceContextType.TRANSACTION) 
    EntityManager em;   // stateless ... deshalb als Instance-Property möglich

    public void assignEmployeeToProject(int empId, int projectId) { 
        Project project = em.find(Project.class, projectId); 
        Employee employee = em.find(Employee.class, empId); 
        project.getEmployees().add(employee); 
        employee.getProjects().add(project);
    } 
```

Die Unit-of-Work der Transaktion wird in der JTA-Transaktion gehalten - deshalb kann der `EntityManager` bzw. `PersistenceContext` auch in ``@Stateless`` Beans wiederverwendet werden. Die Separierung parallel laufender Conversations erfolgt also über die JTA-Transaktion (die vermutlich über ThreadLocals abgebildet ist).

Beim committen der Transaktion wird der Zustand des ``PersistenceContext`` persistiert und der ``PersistenceContext`` wird nicht mehr benötigt.
 
## Container managed extended scoped EM
Während der Transaction scoped Entity Manager der PersistenceContext an einen Service-Aufruf gebunden ist, erweitert der **Extended Scope** die Gültigkeit des PersistenceContext auf mehrere Aufrufe.
 
 ```
 @Stateful 
public class LibraryUserManagementService implements UserManagementService { 

    @PersistenceContext(
       unitName="UserService" , 
       type=PersistenceContextType.EXTENDED) 
    EntityManager em;

    LibraryUser user; 

    public void init(String userId) { 
        user = em.find(LibraryUser.class, userId); 
    } 

    public void setUserName(String name) { 
        user.setName(name); 
    } 

    public void borrowBookFromLibrary(BookId bookId) { 
        Book book = em.find(Book.class, bookId); 
        user.getBooks().add(book); 
        book.setLendingUser(user); 
    } 

    // ... 

    @Remove 
    public void finished() { 
    } 
}
```

## Application scoped Entity Manager
Solche EntityManager werden nicht vom Container (EJB/Spring) injected, sondern über die Klasse ``Persistence`` und eine ``EntityManagerFactory`` selbst erzeugt:

```
EntityManagerFactory emf = 
   Persistence.createEntityManagerFactory("myPersistenceUnit"); 
   EntityManager em = emf.createEntityManager(); 
```

Hierfür wird allerdings eine Datei ``persistence.xml`` benötigt.

# Isolation Level
* https://vladmihalcea.com/2014/10/23/hibernate-application-level-repeatable-reads/

Generell kennt JPA vier Isolation Levels:

* `javax.sql.Connection.TRANSACTION_READ_COMMITTED`: Dirty reads are prevented; non-repeatable reads and phantom reads can occur.
* `javax.sql.Connection.TRANSACTION_READ_UNCOMMITTED`: Dirty reads, non-repeatable reads and phantom reads can occur.
* `javax.sql.Connection.TRANSACTION_REPEATABLE_READ`: Dirty reads and non-repeatable reads are prevented; phantom reads can occur.
* `javax.sql.Connection.TRANSACTION_SERIALIZABLE`: Dirty reads, non-repeatable reads, and phantom reads are prevented.

Isolation Levels sind IMMER auf der Datenbank und nicht im EntityManager implementiert, da Datenbanken verschiedene Clients bedienen (z. B. auch SQL-Navigatoren).

Viele Datenbanken implementieren weitere Isolation Levels (z. B. [Microsoft SQL Server: SNAPSHOT ISOLATION](http://www.databasejournal.com/features/mssql/snapshot-isolation-level-in-sql-server-what-why-and-how-part-1.html)) bzw. spezielle Interpretationen/Implementierungen (z. B. [MySQL mit Repeatable-Read Umsetzung über Snapshots und ohne READ-Lock](https://dev.mysql.com/doc/refman/5.7/en/innodb-consistent-read.html)). 

Der Grund besteht in einer besseren Performance oder der Vermeidung von Deadlock-Situationen bei weiterhin guter Datenkonsistenz.

## MySQL Repeatable-Read - non-locking reads
* https://dev.mysql.com/doc/refman/5.7/en/innodb-transaction-isolation-levels.html
* https://dev.mysql.com/doc/refman/5.7/en/innodb-consistent-read.html

MySQL verwendet eine spezielle Implementierung basierend auf Snapshots, um Repeatable-Read umzusetzen. Auf diese Weise wird vermieden, daß lesende Zugriffe zu Locks führen und damit schreibende Zugriffe blockieren. Das erhöht den Durchsatz dramatisch und reduziert die Anfälligkeit für Deadlocks - zudem wird das Programmiermodell einfacher, weil Deadlock-Szenarien seletener auftreten können. Folgendes ist somit kein Problem:

* TX 1 - a: lese Person P1
* TX 2 - a: lese Person P1
* TX 2 - b: ändere Person P1

Bei einer Standard-Repeatable-Read-Implementierung über READ-Locks müßte in "TX 2 - b" auf das Löschen des in "TX 1 - a" erzeugten READ-Locks gewartet werden. Bei der MySQL-Implementierung ist kein Warten notwendig.

Das Programmiermodell wird dadurch vereinfach:

* wÜrden TX 1 und TX 2 innerhalb eines Threads abgearbeitet (z. B. mit einer REQUIRES_NEW Semantik), dann würde das in einer Standard-Reapeatable-Read-Implementierung zu einem Deadlock führen. Bei MySQL ist das problemlos möglich!!!

Bei der MySQL-Implementierung ist dieses Nutzungsszenario unkritisch.

# Lang Laufende Transaktionen
... sollte man grundsätzlich versuchen zu vermeiden.

ABER: in manchen Fällen mag es nicht anders gehen, daß man transaktionales Verhalten über mehrere HTTP-Requests implementiert. 

* https://vladmihalcea.com/2014/09/22/preventing-lost-updates-in-long-conversations/