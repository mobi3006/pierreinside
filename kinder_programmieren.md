# Kinder lernen programmieren

Seit einiger Zeit bin ich am Überlegen wie ich meinen Kindern den kreativen Umgang mit Computern (Laptop, Tablet, Handy, Spielekonsole) näherbringen kann. Sie konsumieren derzeit ausschließlich und ich möchte ihnen gerne zeigen, daß Computer da sind, um Probleme zu lösen, Dinge zu vereinfachen und die Erarbeitung und Umsetzung einer Lösung (allein oder noch besser im Team) viel Spaß macht.

Wir können Computer und das Internet nicht vor ihnen verbergen, sie sollen aber einen kritischen und durchaus positiven Umgang mit den neuen Technologien lernen.

Glücklicherweise gibt es mittlerweile eine Vielzahl guten Lernangebote im Internet, die zur Grundlagenausbildung genutzt werden können. Ich hätte mir gewünscht solch ein Angebot vor 35 Jahren gehabt zu haben als ich meinen ersten C64 hatte und die ersten Basic-Programme geschrieben habe. Ich mußte mich damals auf extrem unkindliche Art diesem Thema nähern. Tastatur und Befehle auf einem monochrom Bildschirm, Abtippen von Befehlen ohne Erklärung (ein einziger Fehler und das stundenlange Abtippen war vergebens). Der Frustrationsfaktor war damals extrem hoch und man mußte schon besonders selbstmotiviert sein, um nicht auszusteigen. Die Möglichkeiten sind 2017 paradiesisch ... selbst Kindergartenkinder können bereits mit den angebotenen Programmierumgebungen zurecht kommen, weil die Programmierung grafisch erfolgt. Die Konzepte stehen im Vordergrund und nicht, ob man schreiben kann oder englisch kann (die meisten richtigen Programmiersprachen basieren auf der englischen Sprache).

---

## Anforderungen

### Richtige Sprache

* der Einstieg in die Programmierwelt sollte in der Muttersprache erfolgen, damit sich der Schüler auf die Programmieraspekte fokussieren kann - das ist schon schwierig genug

### Richtige Programmiersprache

* eine interpretierte Sprache ist besser geeignet als eine compilierte Sprache, weil eine (nicht ganz intuitive) Hürde schon mal wegfällt
* es sollte verhindert werden, daß man vorm Start viele Dinge installieren muß - im besten Fall kann man im Browser programmieren
  * [Python 3 Browser-IDE](https://repl.it/languages/python3)
* die Sprache sollte einfach sein und doch viele Möglichkeiten eröffnen
* Python ist aus meiner Sicht die beste Sprache zum Lernen, da
  * sehr einfach
  * viele Paradigmen (prozedural, objektorientiert, funktional)
  * viele Bibliotheken

### Interessante Projekte

* klar, die Syntax und minimale Datenstrukturen MUSS man einfach lernen - aber das sollte in wenigen Tagen möglich sein
* sehr schnell sollte man ein richtiges kleines Projekt machen, das einerseits begeistert (cool) aber andererseits nicht überfordert
  * [Spielekonsole Pico](https://github.com/mobi3006/pico)

---

## Überblick

Auf [code.org](https://code.org/educate/curriculum/3rd-party) findet man einen sehr guten Überblick über die englischsprachigen Angebote, die teilweise aber auch auf deutsch übersetzt sind. Viele Angebote sind kostenlos.

---

## Code.org

* https://code.org/

Dieser Ansatz wird in den USA sehr stark genutzt (25% der amerikanischen Schüler arbeitet mit dieser Plattform). Aber auch in Deutschland können wir diese Umgebung nutzen ... die deutsche Sprache wird unterstützt kann aber noch verbessert werden (daran kann man sogar mitwirken!!!).

### Lehrerbereich

Mit dem Lehrer-Account verwaltet man die Kurse und Programmieraufgaben, an denen die Schüler arbeiten. Hierzu legt man Kurse an und teilt die Schüler entsprechend ein.

Über das sog. Dashboard erhält man einen Überblick wie erfolgreich die Kinder die Aufgaben bewältigt haben. So kann man beispielsweise - im Falle einer vollkommen selbständigen Bearbeitung durch die Kinder - Hilfestellung geben, nachfragen wo es gerade Probleme gibt, ... 

Lehrer werden im Vermitteln durch Video und PDF Material und sogar durch lokalen Workshops (nur in den USA - durch sog. Computer Science Fundamentals Facilitators - TODO-LINK) unterstützt.  

### Schülerbereich

Die Schüler loggen sich mit ihrem Account ein. Das schöne ist, daß die Kinder hierzu keinen eigenen Account bei code.org anlegen müssen. Stattdessen hat jeder Kurs eine Kennung (z. B. `QNFKJS`) und dann öffnet der Schüler die URL https://code.org/sections/QNFKJS und loggt sich mit einem Geheimnis, das der Lehrer festgelegt hat, ein. Diese Geheimnisse können Bildern oder Texte sein ... so können auch schon die Kleinsten eigenständig loslegen.

Die Programmierumgebung ist komplett browserbasiert und kann auf unterschiedlichsten Plattformen (Windows-Linux-MacOS, Laptop-Tablet-Handy) genutzt werden. Somit kann eigentlich jeder Teilnehmen ... der Bildschirm sollte allerdings nicht zu klein sein, dann ansonsten passen Spielbrett und Codeeditor nicht nebeneinander - was die Aufgabe deutlich erschwert.

### Pädagogisches Konzept

Man unterscheidet

* komplette Kurse - gehen über viele Wochen
* einzelne Programmierstunden (aka Hour of Code) ... ganz praktisch als Apetizer oder um zwischendurch mal in einer anderem anderen Spielgenre (als dem aus dem Kurs) unterwegs zu sein 
* Projekte
* Labs
  * App Lab - hier entstehen mobile Apps
  * Game Lab
  * Web Lab - hier verwendet man Webtechnologien (HTML, CSS)

In den Kursen geht es in den Anfängerkursen zumeist um die Bewegung von Figuren auf einem Spielfeld. Die Themenbereiche sind für die Kinder sehr interessant, weil sie für sie interessanten Bereichen entlehnt sind (Minecraft, Star Wars, Eiskönigin, Angry Birds, ...). Das finde ich sehr gut, denn daraus sind die Kinder gleich viel interessierter.

Als Computersprache kommt JavaScript zum Einsatz, d. h. zumeist im Hintergrund werden JavaScript-Funktionen aufgerufen um tatsächlich den Helden auf dem Spielfeld zu bewegen.

#### Kurse

Man sieht hier, daß ein richtiges Konzept zugrundeliegt. Die Kurse sind unterteilt in ()

* Elementary School (Kindergarten bis 5. Klasse)
  * Grundlagen Kurse (aka Computer Science Fundamentals)
    * 15-50 Teilelemente (teilweise länger als eine Schulstunde) 
  * Express-Kurse
  * viele Sprachen unterstützt
    * hier können die Kinder aber auch gleich ihre Englischkenntnisse verbessern
* Middle School (6. bis 10. Klasse)
  * Computer Science Discoveries (Aufbaukurs)
  * nur Englisch
* High School (9. bis 12. Klasse)
  * Computer Science Principles (für Profis)
  * nur Englisch

Es gibt zu jedem Kurs zusätzliches Material (PDF, Video) für die Lehrer und auch die Schüler bekommen hilfreiche Zusatzinformationen in der Programmierumgebung

#### Projekte

Man kann hier eigene Programmierprojekte anlegen und auch die von anderen einsehen und verändern (eigene Versionen davon machen).

---

## CodeMonkey

* [Website](http://www.playcodemonkey.com)
* kostenpflichtig ... ein paar Sachen sind aber kostenlos
* sehr schöne Umgebung - niedliche Tiere
* es wird an Spielen

Hier wird nicht mehr grafisch programmiert, sondern tatsächlich textuell (Sprache ist CoffeScript). Aus diesem Grund halte ich es - im deutschsprachigen Raum - erst für Kinder ab der 5. Klasse geeignet (wenn das Englisch schon besser wird).

---

## Hacker School

* [Website](https://hacker-school.de/)
* Kurse für wenig Geld (z. B. 8h Python für 30 Euro) ... Preise lassen sich selbständig festlegen

---

## Hasso Plattner Institut

* [Python Kurs](https://open.hpi.de/courses/pythonjunior2020)
  * [gleicher Kurs ... im März 2021 laufend](https://lernen.cloud/courses/pythonjunior-schule2021)

---

## Devoxx4kids

* [Website](http://www.devoxx4kids.de/)

---

## Python Bücher

* [Buch: Programmieren mit Python - supereasy](https://www.amazon.de/Programmieren-mit-Python-supereasy/dp/3831034575/ref=pd_sim_4?_encoding=UTF8&pd_rd_i=3831034575&pd_rd_r=0671b0b2-b66b-11e8-b7b1-1f841b9564db&pd_rd_w=soYkA&pd_rd_wg=aTAco&pf_rd_i=desktop-dp-sims&pf_rd_m=A3JWKAKR8XB7XF&pf_rd_p=a1f1e800-ed31-44e7-8f29-5b327ba0187a&pf_rd_r=WCJX42PT49VD9KM4WVX6&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=WCJX42PT49VD9KM4WVX6)
