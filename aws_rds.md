# AWS - RDS

---

## Unterstützte Datenbanken

---

## Ressourcen

Datenbanken laufen bei AWS auf EC2 Instanzen - hierfür gibt es spezielle `db.foo`-Instanztypen. Diesen Instanztypen sind bestimmte Ressourcen zugeordnet.

Bei der CPU hat man dann eine Grundleistung plus sog. CPU-Credits, mit denen mal zeitweise over-provisioning machen kann. Jeden Tag bekommt man wieder Credits hinzu - man kann die Credits aber nicht beliebig anhäufen (hier gibt es ein Limit). Hat man seine Credits aufgebraucht, dann geht die Performance der Datenbank so dermaßen in den Keller, daß man selbst beim erzeugen einer Datenbank-Connection in Timeouts läuft.

