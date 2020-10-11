# Mathematik

---

## Termumformungen

Ziel:

* Vereinfachung des Terms, um die Anzahl der Rechenoperationen beim Einsatzen konkreter Werte zu minimieren
* die Terme werden dadurch aber grundsätzlich auch sichtbar "kürzer"

### Beispiel

|Originalterm|Vereinfachter Term|
|------------|------------------|
|$$r²*s²+((-r)*s)²+s²*r²$$|$$=r²*s²+r²*s²+r²*s²=3*r²*s²$$|
|mit `r=2, s=3`|
|$$2²*3²+((-2)*3)²+2²*3² = 4*9+(-6)²+4*9 = 36 + 36 + 36 = 108$$|$$3*2²*3² = 3*4*9 = 108$$|
|Anzahl Rechenoperationen|
|$$5 + 3 + 3 = 11$$|$$2 + 2 = 4$$|

Der praktische Nutzen einer solchen Umformung besteht in Zeitgewinn (z. B. in einer Klausur) und - wenn man es mit dem Kopf macht - in einer geringeren Fehlerwahrscheinlichkeit.

In beiden Fällen hilft es also in Klassenarbeiten, in denen man keinen Computer mit der Berechnung beauftragen kann.

### Schreibweise

Einen Term der Art

> $$a²*b²+a*b$$

kann man als Funktion mit den beiden Unbekannten `a` und `b` verstehen und dementsprechend folgendermaßen schreiben:

> $$f(a, b)=a²*b²+a*b$$

Das hat den Vorteil, daß man dann eine Anwendung dieser Formel für die beiden Werte `a=2`und `b=4` mathematisch sauber als

> $$f(2, 4) = 2²*4²+2*4 = 4*16 + 8 = 64 + 8 = 72$$

schreiben kann, denn das Gleichheitszeichen bei folgender Schreibweise ist strenggenommen **FALSCH**

> $$a²*b²+a*b = 2²*4²+2*4$$

... es ist nur unter der Voraussetzung `a=2`und `b=4` korrekt.

> In der Schule wird leider häufig nicht so sehr auf diese Details geachtet. Ein Aspekt, den ich selber erst in der Uni kennenlernte ... der mir aber sehr geholfen hat, die Mathematik besser zu verstehen.

### KlaPoPuStri

Hiermit werden die Prioritäten (= Bindungen) festgelegt

> Klammern > Potenz > Punktoperationen (*, /) > Strichoperationen (+, -)

Mit diesem explitziten Regeln lassen sich Terme deutlich lesbarer schreiben - die Klammern werden weniger (für das menschliche Auge schneller erfaßbar):

> $$(((a)²*(b)²)+(a*b) = a²*b²+a*b$$

### Potenzen

#### Konkret

> $$(a*b)² = a²*b²$$

da (Kommuntativgesetz der Multiplikation)

> $$(a*b)² = (a*b)*(a*b) = a*b*a*b = a*a*b*b = a²*b²$$

#### Allgemein

Man erlernt die allgemeine Regel, um sich Schritte bei der Termumformung zu sparen ... das ist aber nur eine Beschleunigung des Rechenvorgangs und nicht unbedingt notwendig, aber in jedem zu empfehlen!!!

> $$(a*b)^n = a^n*b^n$$

### Kommutativgesetz

Gilt für die Multiplikation ($a*b=b*a)$) und Addition ($a+b=b+a)$):

$$4+(-2)=(-2)+4=2$$
$$4*(-2)=(-2)*4=-8$$

aber nicht für die Division und Subtraktion

$$4:(-2) <> (-2)+4$$
$$4-(-2)=(-2)-4$$

Gleichzeitig gilt es aber zu beachten, daß sich $a²*b²+a*b$ Multiplikation und Addition nicht wahlfrei zu beispielsweise $a²*a+b²*b$ vertauschen ("kommutieren") lassen (obwohl beide Rechenoperationen kommutativ sind). Hierbei würde die Punkt- vor Strichrechnung aus dem KlaPoPuStri verletzt, denn die Multiplikation bindet stärker als die Addition => ich kann nicht Teile der Multiplikation rauslösen und der Addition hinzufügen.

### Distributivgesetz

aka Ausmultiplizieren (macht den Term zunächst mal größer - ermöglicht dann aber Vereinfachungen mit weiteren Termen):

$$a*(b+c)=a*b + a*c$$
$$a*(b-c)=a*b - a*c$$

Beachte: das Gesetz kann in beide Richtungen angewandt werden (zwischen der linken und rechten Seite steht ja ein Gleichheitszeichen). Bei folgender Anwendung wird der Term durch die Anwendung kleiner:

$$3*a - 2*a = a*(3-2) = a*(1) = a$$

Dieser Betrachtungsweise sieht zunächst mal sehr kompliziert aus, denn es weiß ja schließlich jeder, daß $3*a - 2*a = a$ ($3 Äpfel - 2 Äpfel = 1 Apfel$). Total logo, aber dahinter steht eigentlich die Anwendung des Distributivgesetzes.

### Addition und Subtraktion von Termen mit Unbekannten

Bei einem Term der Art

$$2*a*b + a²*b + a*b² + a*b$$

lassen sich **nur Termteile mit der gleichen "Einheit" verrechnen**. In diesem Term gibt es 3 verschiedene Einheiten:

* $a*b$
* $a²*b$
* $a*b²$

Die Vereinfachung von obigem Term sieht also so aus:

$$2*a*b + a²*b + a*b² + a*b = 3*a*b + a²*b + a*b²$$

Mehr geht nicht.

Das kann man sich mit einem Alltagsproblem klar machen:

* FALSCH ist: $5m + 3cm + 2m = 10m$
* RICHTIG ist: $5m + 3cm + 2m = 7m + 3cm$

> **MERKE:** Betrachte eine Kombination aus Variablen als Einheit - nur **GLEICHE Einheiten** dürfen miteinander verrechnet werden!!!

Deshalb sollte man Einheiten immer normalisieren (alphabetisch ordnen), d. h.

$$2*a*b + b*a² + a*b² + b*a = 2*a*b + a²*b + a*b² + a*b$$

denn dann erkennt man schneller welche Einheiten gleich sind.
