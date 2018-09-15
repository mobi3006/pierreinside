# Dell C2665dnf

Ich hatte diesen Farbdrucker im Jahr 2015 wegen folgender Eigenschaften erworben:

* Laserdrucker - bei meinem niedrigen Druckvolumen trocknet Tinte ein (hauptsächlich in den Düsen)
* Farbe - die Kinder brauchen für die Schule immer mal wieder gute Farbausdrucke (auch zum Lernen ist das besser)
  * für schwarz-weiß-Ausdrucke verwende ich meinen druckgünstigen Kyocera FS-920 (15 Euro für eine Tonerkartusche, die tausende Seiten druckt)
* Scanner mit Ablage auf [Synology Fileserver](synology.md) ... nutze ich sehr regelmäßig
* Netzwerkfähig

Seitdem bin ich sehr zufrieden.

## August 2016 - Schwarz-Toner getauscht

Nach nur 150 Seiten schwarz-Druck war der Toner schon leer (bei der Auslieferung sind nur ganz kleine Tonerkassetten drin). Ich bestellte [diesen No-Name Toner von Colour Direct](https://www.amazon.de/gp/product/B00KS8IJO8/ref=oh_aui_search_detailpage?ie=UTF8&psc=1). Alles prima ... tolles DRuckergebnis.

## Frühjahr 2018 - Tonertausch mit schlechten Ergebnissen

Nach 600 Seiten Farbausdruck wollte das rot nicht mehr so richtig ... und Cyan war auch schon recht leer. Ich war nicht bereit 180 Euro für Original-Dell-Toner-Kartuschen-Set auszugeben und begab mich auf die Recherche nach kompatiblem Toner. Nach Lesen vieler Rezensionen (mit leider unzufriedenstellenden Berichten) entschied ich mich für [diesen No-Name-Toner von Perfect Print](https://www.amazon.de/gp/product/B00L2DHBYC/ref=oh_aui_search_detailpage?ie=UTF8&psc=1) ... 4 Tonerkartuschen für 6000/4000 Seiten bei einem Preis von 40 Euro ... das sollte ein Versuch wert sein.

Leider war ich mit dem Druckergebnis gar nicht zufrieden ... rot kam gar nicht raus. Ich schob es auf eine schlechte Charge und gab dem Toner eine weitere Chance. Doch auch diesmal war das Ergebnis unbefriedigend. Ich hatte keine Ahnung und in den Foren las ich immer wieder was von Ausbau der Bildtrommel ... doch da traute ich mich nicht ran und so vegetierte der Drucker wochenlang vor sich hin. Irgendwann überkam mich die Motivation (oder besser: Robin machte Druck) und ich investierte einen Sonntagnachmittag.

### Einstellung Kein-Dell-Original-Toner

Diese Einstellung im Menü des Druckers brachte keine Verbesserung ... gefühlt wurde nur der Tonerstand nicht mehr angezeigt.

### Testseite

Selbst die Testseite brachte kein rot raus ... damit konnte ich den Rechner (Druckertreiber) als Fehlerquelle ausschließen.

### Contamination Check

* [hier las ich was über diesen Test](https://www.dell.com/community/Drucker/C2665dnf-druckt-kein-yellow-mehr-an/td-p/5209825)
* Ausschalten; 4,5 und 6 gedrückt halten und dabei Einschalten; Passwort "225"; "Test Print" auswählen; "Contamination Chk" auswählen
* das Ergebnis waren vier Seiten
  * grau
  * gelb
  * blau
  * rot ... tatsächlich es kam rot/violett raus - die Bildtrommel schied für mich aus

### Farbkorrektur

Im Menü kann man eine Farbkorrektur über die Farbregistrierungstabelle vornehmen. Mehrfach startete ich die automatische Farbkorrektur, doch die Verbesserungen waren gering. Die manuelle Anpassung brachte dann endlich deutliche Verbesserungen. So konnte ich den Drucker endlich wieder in Betrieb nehmen. Sicher ... die Original-Farben sind bestimmt besser ... aber 150 Euro mehr sind sie mir derzeit nicht wert. Viellecht probiere ich es beim nächsten mal aber doch aus.