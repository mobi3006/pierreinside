# Macbook

Ich bin kein Windows Liebhaber ... aber nutze dieses Betriebssystem aber seit Jahren und habe mich an dessen Eigenheiten gewöhnt. Als Entwicklungssystem präferiere ich allerdings Linux, weil es viele essentielle Features für Softwareentwickler und DevOps mitbringt. Nun habe ich 2021 mein erstes Macbook bekommen ... ich muss was für die Arbeit auf dem neuen M1 Chip testen. Gleichzeitig ein Test, ob ich zukünftig von Windows und Linux-Virtualbox auf MacOS umsteige.

---

## Erste Erfahrungen

Der Login nach dem Reboot dauert echt lang (über eine Minute) ... vielleicht liegts nur an der Firmen-Konfiguration, aber das enttäuscht mich schon ein wenig. Naja, das ständige Booten (a la Windows) sollte ja nun der Vergangenheit angehören.

Die Hardware ist schon klasse ... das Trackpad fühlt sich anders an als die typischen Windows-Laptop-Billigheimer. Der Druckpunkt ist anders ... wahrscheinlich nur eine Frage der Gewöhnung.

Das Intuitive Empfinden stellt sich nicht sofort ein. Klar, die Shortcuts sind anders und man muss sich auch erstmal auf der Oberfläche zurechtfinden ... daß aber essentielle Zeichen (~, [, ], {, }, |) auf der Tastatur nicht dargestellt werden und ich googlen muss - das hätte ich nicht erwartet.

Die nächste Hürde ist die Selektion von Text im Terminal ... clicke ich falsch? wie kann ich mehrere Wörter selektieren? Control-C ist gar nicht der Shortcut fürs kopieren, sondern Command-C.

> ... bin ich echt schon zu alt für einen Umstieg auf Macbook ... erste ZWeifel stellen sich ein

Ich habe einen der neuen M1 Prozessoren und möchte darauf Docker Container nutzen. Abgesehen davon, daß Docker nicht direkt unter MacOS läuft, sondern in einer Linux-Virtual-Machine, unterstützen nicht noch relativ wenige Docker Images diesen neuen M1 Chip (ARM based). Ähnlich verhält es sich mit Virtualbox ... der neue Prozessor wird von Virtualbox nicht unterstützt. Virtualbox startet zwar (wahrscheinlich über Rosetta - eine Software um Programme zu nutzen, die auf den Intel-Macbooks liefern ... ähnlich dem Windows Kompatibilitätsmodus), aber die Virtualisierung funktioniert nicht.

> Apple hält sich hält sich für den Mittelpunkt des Universums ... die Jünger sind so heiß auf diese Marke, daß sie sich alles erlauben können. Erst mal die Geräte schön verkaufen und dann die Software nachliefern.

Fazit nach dem ersten Tag:

* tolle Hardware (aber mit meinem Dell XPS bin ich auch sehr zufrieden ... abgesehen vom Gebläse - den M1 habe ich noch nicht unter Last bekommen, um das zu vergleichen)
* an die Eigenheiten wird man sich gewöhnen ... Shortcuts sind vermutlich besser unterstützt als unter Windows
* ein ordentliche betriebssystem, das eine gute Shell und Paketmanager bereit hält - Linux-Like

Für mich gibt es vermutlich keinen Grund weiterhin Windows Laptops zu nutzen ... solange meine geliebte VirtualBox Entwicklungsumgebung noch funktioniert - das hängt leider auch mit der Weiterentwicklung hinsichtlich Hypervisors zusammen.

---

## Virtualisierung

Mein geliebtes Virtualbox funktioniert prima auf den Intel Macbooks aber leider nicht mehr (nicht mal mit Rosetta) auf den neuen M1 Macbooks. Ich schätze daran wird sich auch so bald nichts ändern.

Als Alternativen standen schon kurz nach Einführung von M1 Parallels und VMWare Fusion zur Verfügung, die allerdings nicht kostenlos sind ... aber mit 100 Euro auch nicht besonders viel kosten.

Da Apple M1 im September 2021 noch recht jung ist, wird es in naher Zukunft sicherlich wieder einige Verbesserungen/Alternativen geben.
