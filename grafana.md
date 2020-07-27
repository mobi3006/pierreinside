# Grafana

Mit Grafana lassen sich schöne Dashboards fürs Monitoring von Metriken erstellen. Datenbasis sind i. a. Time-Series-Databases, die eine hohe Abtastrate (im Sekundenbereich) haben.

> ACHTUNG: arbeitet man mit Werten, die eine sehr niedrige Auflösung haben (geringe Abtastrate), dann kann es schon mal irritieren, weil die Graphen vielleicht seltsam aussehen. In dem Fall sollte man den Rollup entsprechend vergößern, um seltsame Artefakte zu verhindern. Beispiel: schreibt man alle 30 Minuten einen einzelnen Wert weg und verwendet einen Rollup von Sekunden, dann kann es dazu führen, daß mehrere Punkte sichtbar sind ... auch wenn es nur ein einziger Wert war - liegt daran, daß eigentlich mit einem Kurvenverlauf gerechnet wird und Interpolation verwendet wird, um die Kurve stetig zu machen. Bei einer hohen Abtastrate würde diese Eigenart nie auffallen.

Die Y-Werte sind für mich kaum nachvollziehbar ... auch wenn ich Werte im gleichen Y-Bereich darstelle, ändert sich der Y-Achsen-Wertebereich teilweise dramatisch, wenn ich die zeitliche Ausdehnung des Graphen verändere (z. B. von 1h auf 7 Tage). Unter der Annahme, daß alle Werte zwischen 500.000ms und 1.000.000ms liegen, hätte ich gehofft, daß die y-Achse IMMER von 0 bis 1.000.000ms geht ... ist aber leider ganz anders und so kann ich mit den Werten gar nicht soviel anfangen ... ich sehe eigentlich nur, daß die Werte schwanken und viel oder wenig ... aber der absolute Wert ist nicht zu gebrauchen. Meine Vorstellung war, daß Ich konnte mir das nicht erklären und habe folgende Erklärungsversuche gefunden:

* [Y Axis values change depending on time range](https://community.grafana.com/t/y-axis-values-change-depending-on-time-range/5429/4)

---

## Konzepte

### Dashboard

Sammlung von Panels. Panels können interaktiv sein, d. h. man wählt

* Variablenbelegung
* Zeitraum

### Panel

Ein Panel stellt die eigentliche Information dar, z. B. ein Graph oder eine Tabelle. In diesem Panel lassen sich mehrere Queries übereinanderlegen. Eine Query allerdings kann sogar dafür sorgen, daß mehrere Graphen aus unterschiedlichen Quellen/Instanzen (z. B. Hosts) stammen (wirkte auf mich zunächst mal wie Magie).



### Versionskontrolle

Bei der Editierung von Dashboards (und der darin befindlichen Panels) über das Web-UI kann man beim Speichern eine "Commit-Message" angeben. Versionen lassen sich vergleichen und wiederherstellen.

### Kiosk-Mode

Dieser Modus ist für Überwachungsmonitore geeignet, bei denen die Ansichten rollierend wechseln.

### Variablen

Man kann Dashboard-spezifische Variablen definieren und dann in der Definition der Panels verwenden. Im Dashboard lassen sich dann einzelne/mehrere/alle Werte der Variablen in den Panels gleichzeitig anzeigen. So lassen sich die Werte sehr gut miteinander vergleichen.

### JSON-Definition

Die Dashboards können als JSON-File exportiert und importiert werden. Auf diese Weise lassen sich Dashboards unter eine externe Versionskontrolle stellen (z. B. [git](git.md)) und Grafana-Server from-scratch aufsetzen.

### Snapshot

Mit einem Snapshot kann man einen (festen) Zeitausschnitt per (Deep-) Link an andere verschicken oder einfach abspeichern.

### Transformationen

Die Raw-Werte aus der angezapften Data-Source lassen sich vor der Visualisierung im Grafana-Dashboard noch aufbereiten.

> "Transformations allow you to join, calculate, re-order, hide and rename your query results before being visualized. Many transforms are not suitable if your using the Graph visualization as it currently only supports time series."

### Annotate Events

Die Panels in den Dashboards lassen sich mit Anmerkungen versehen - auf diese Weise lassen sich Analyseergebnisse gut teilen.

---

## Instana-Dashboards

* [unterstützte Features](https://grafana.com/grafana/plugins/instana-datasource)
* [Instana Plugin für Grafana - Source Code](https://github.com/instana/instana-grafana-datasource)

Grafana kann [Instana](instana.md) als DataSource einbinden (hierzu braucht es dann einen API-Token) und auf diese Weise lassen sich Daten aus Instana (Build-In Metriken und Custom-Metriken) schön übersichtlicht mit zeitlichem Verlauf auflisten. Instana bietet zwar schon einiges an zeitlicher grafischer Aufbereitung, doch für Custom-Metriken (z. B. aufgezeichnet über Statsd oder die REST-API) ist Grafana das Mittel der Wahl.

> ACHTUNG: die Möglichkeiten der Visualisierung hängt auch von der Data-Source ab ...

### Instana Plugin für Grafana

Für die Integration von Instana in Grafana sind folgende Dinge notwendig:

* Erzeugung eines API-Tokens in Instana
* Installation des Instana Plugins
* Konfiguration des Instana Plugins mit
  * Instana-Server-URL
  * API-Token mit den notwendigen Permissions

### Background Infos

* Instana-Plugin verwendet die Instana-REST-API
  * sehr praktisch, wenn man wissen will wie man die Instana-REST-API benutzt

### Panel-Definition

* basieren auf Dynamic Focus Queries
* erlaubt Auto-Completion
