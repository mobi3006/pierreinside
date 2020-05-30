# Plant UML

* [Homepage](http://plantuml.com)

Ich mag UML-Diagramme sehr gerne, um Zusammenhänge zu visualisieren. Meistens nutze ich hierfür [DrawExpress](http://www.drawexpress.com/), weil es auf meinem iPad wunderbar zu benutzen ist und ich in Besprechungen häufiger mein iPad dabei habe als meinen Laptop.

Alternativen

* Lucid-Chart ... never ever - ganz fürchterlich (auch wenn es eine Jira-Integration hat)
* [draw.io](http://draw.io) scheint eine sehr brauchbare Alternative zu sein
* Visio, das ich vor ewigen Zeit mal gemocht habe :-)
* [Dia](https://wiki.gnome.org/Apps/Dia)
* [Graphviz](https://www.graphviz.org/documentation/)

Ein Vorteil ist, daß man bei Drawexpress das Layout selbst machen muß, d. h. man schiebt die Elemente an die richtige Position und kann damit sehr genau bestimmen wie es aussieht. Während des Denkprozesses ist das eher hilfreich, weil man damit Zusammenhänge/Strukturen besser ordnen kann. Dieser Vorteil wird allerdings zum Nachteil, wenn man nachträglich Änderungen durchführen will, denn dann kann eine kleine Änderung sehr schnell auswendig werden. Hier ist Plant UML ein sehr nützliches Tool, da das Layout komplett automatisiert wird - eine Textdatei beschreibt die Semantik. Für eine langfristige wartbare Dokumentation (z. B. für ein Blog oder ein Buch) ist das sehr vorteilhaft.

---

## Getting Started

Man benötigt Java und das `plantuml.jar`-file, um aus einer textuellen Beschreibung (Datei `sequenceDiagram.txt`)

```plantuml
@startuml
Alice -> Bob: test
@enduml
```

in eine schöne Grafik `sequenceDiagram.png` zu generieren:

```bash
java -jar plantuml.jar sequenceDiagram.txt
```

### Visual Studio Code

Es gibt eine Extension, mit der sich mit dem Befehl _PlantUML: Preview Current Diagram_ Previews generieren lassen.

---

## Customizing

### Layout

* [ASCII Art](http://plantuml.com/de/ascii-art)
