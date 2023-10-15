# Terraform AWS Provider

AWS zeichnet sich nicht unbedingt durch eine intuitive Oberfläche aus. Es ist sehr schwierig die Zusammenstöpselung der Komponenten über die Web-UI nachzuvollziehen. Die Traversierung ist nicht besonders leicht.

Dabei kann der Überblick schnell verlorengehen welche Ressourcen nun tatsächlich zusammengehören. Erstellt man beispielsweise eine EC2 Instanz, so wird dazu per Default auch eine Security-Group erstellt. Terminiert man später die EC2-Instanz, so bleibt die Security-Gruppe allerdings erhalten. Tut man das mehrfach so hat man schon nach kürzester Zeit einen Haufen Müll angesammelt, der nicht mehr benötigt wird aber die Sicht vernebelt.

So kann man kein System zuverlässig betreiben. Deshalb muss etwas wie Terraform her. So lassen sich die Komponenten viel leichter zusammenstecken, um eine Lösung zu formen. Nur so kann das wiederholbar zum Erfolg führen und nur so werden die Ressourcen auch mal wieder konsistent abgeräumt Lösche ich hier die EC2 Instanz, so habe ich zumindest im Code noch den Code zur Erstellung der Security Group und kann sie - soweit im Code nicht mehr referenziert - löschen und den Code ausrollen. Dann wird die Security Group auch in AWS gelöscht. Das System ist nur so überhaupt wartbar.

> AWS ist ohne Code und Automatisierung kaum zu betreiben - Himmelfahrtskommando

Allerdings darf man sich auch nicht auf Default-Ressourcen verlassen (z. B. Default-VPV, Default Route-Table, Default-Security-Groups), sondern muss diese im Terraform Code erstellen.