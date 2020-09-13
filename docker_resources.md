# Docker Ressources

* https://dzone.com/articles/java-inside-docker-what-you-must-know-to-not-fail?edition=286882&utm_source=weekly%20digest&utm_medium=email&utm_campaign=wd%202017-03-22

Man kann die für Docker-Container bereitgestellten Ressourcen über Betriebssystem `ulimits` oder Docker-Parameter (`docker run --it -m=100M --memory-swap=100M ubuntu free -h`) einschränken. Wenn ein Container dann allerdings diese Grenze überschreitet, dann wird er vom Betriebssystem hart abgeschossen.

Läßt man eine Java-Vm in dem Container laufen, dann muß man diese VM entsprechend auch auf Java-Seite einschränken, sonst stöt sie evtl. gegen die Docker/OS-seitig festgelegte Grenze und wird hart beendet. Erschwerend kommt hinzu, daß Java den gesamten (nicht nur den evtl. per `ulimit` reduzierten) Maschinenspeicher "sieht" und - sofern keinen expliziten Memory-Restriktionen vorgegeben sind - den maximalen Speicher selbst bestimmt. Der Wert hängt ab 

* vom physikalischen Speicher ab
* einigen VM-Einstellungen (z. B. `-client` vs. `-server`)

Das führt dann schon mal schnell dazu, daß es einfach nicht mehr paßt. Daher:

> "When running a Java application inside containers, we should set the maximum heap size (-Xmx parameter) ourselves based on the application needs and the container limits [...] The Java JVM, until now, didn’t provide support to understand that it’s running inside a container — and that it has some resources that are memory and CPU restricted. Because of that, you can’t let the JVM ergonomics make the decision by itself regarding the maximum heap size." (Rafael Benevides, https://dzone.com/articles/java-inside-docker-what-you-must-know-to-not-fail)

## Docker Parameter
Bei 

```
docker run --it -m=100M ubuntu free -h
```

bekommt der Docker-Container nicht nur 100MB Speicher, sondern zusätzlich noch 100MB Swap-Space ... der Aufruf ist also semantisch identisch zu `docker run --it -m=100M --memory-swap=100M ubuntu free -h`. Die Java-VM darf dann also 200 MB allokieren.

> BEACHTE: die Java-VM bekommt von dieser Limitierung nichts mit und allokiert evtl. mehr als 200MB ... sie wird dann abgeschossen vom Docker/OS
