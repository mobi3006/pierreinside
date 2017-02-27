# Logging
Logging macht ja jeder ...

... doch die Logs wollen auch gelesen bzw. ausgewertet werden. Bei der Fehleranalyse interessiert man sich i. a. nur für sehr wenige Logeinträge, d. h. man liest auch nur sehr wenige. 

Wo ist allerdings die Grenze zum Monitoring. Wenn eine Exception tausendfach/millionenfach auftritt ... wie bekommt man das mit, wenn man das Monitoring keinen Trigger liefert? In manchen Fällen ist das Logging einfach fehlerhaft (z. B. `error` statt `warning`) und müßte korrigiert werden.

Deshalb empfehle ich folgendes:

* richtiges Log-Level verwenden
* Logging automatisiert auswerten (zusätzlich zum Monitoring)
* gelegentlich einfach mal reinschauen und kontinuierliche Verbesserungen durchführen

---

# Graylog
[siehe eigener Abschnitt](graylog.md)

---

# ELK-Stack

