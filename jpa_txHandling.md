# TX Handling

---

# JPA
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

## Konzepte
**PersistenceContext:**

Der PersistenceContext verwaltet eine Menge von Entities (Unit of Work). Hier steckt die eigentliche Logik drin - nicht im Entity Manager. Wird eine Transaktion erzeugt, so wird ein neuer Persistence Context erzeugt und damit verbinden - wird die Transaction committed, dann wird der Persistence Context persistiert (= flush).

**Entity Manager:**


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

