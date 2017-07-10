# Transaktionen

Wenn wir im Java-Umfeld über Transaktionen sprechen, dann spielt es eine entscheidende Rolle, 

* um welche Art von Transaktion es sich handelt
  * Single Source:
  * Multiple Source: hier hat man es mit einer verteilten Transaktion zu tun (Stichwort JTA, XA)
* welche Komponente den Transaktionsmanager bereitstellt
  * Application-Managed-Transaction
  * Container-Managed-Transaction

# Application-Managed vs. Container-Managed
![JPA Transactions](images/jpaTransactions.jpg)

Bei einer **Application-Managed-Transaktion** kümmert sich der Applikationscode um den Lifecycle der Transaktion. Diese Variation von Transaktionssteuerung ist auch mit Java SE möglich.

Bei einer **Container-Managed-Transaktion** übernimmt diese Aufgabe der Application-Server, der zusätzlich auch noch JTA-Transaktionen nutzt, die verteilte Transaktionen über verschiedene Data-Sources unterstützt. Diese Variation von Transaktionssteuerung ist nur mit Java EE möglich (wegen der JTA-Integration). 


