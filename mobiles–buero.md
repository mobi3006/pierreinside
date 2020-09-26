# iPad als mobiles Büro

Da ich mit meinen Kindern immer viel auf den Sportplätzen der näheren und weiteren Region, versuche ich die Wartezeit sinnvoll zu nutzen.

Mein iPad ist klein genug, um IMMER dabei zu sein und der Akku hält auch deutlich länger als bei meinem Laptop. Sollte der Akku doch mal zur Neige gehen, die Powerbank mit 3 Anschlüssen ist jederzeit bereit.

---

## Strom

Das iPad hält mal richtig lang. Für unterwegs habeich aber immer eine große Powerbank (20.000 mAh) dabei und im Auto kann ich über den Zigaretten-Adapter laden - zwei Geräte gleichzeitig.

Ich habe schon mal eine Solar-Powerbank gesehen ... vielleicht mal eine Überlegung, wenn meine ihren Geist aufgibt.

---

## Internet

Mein iPad Pro hat keine eigene SIM-Karte, so daß ich mein iPhone per Tethering für die Internet-Verbindung nutze. Klappt prima, doch der Akku meines iPhones ist dann auch recht schnell leer. Die Lösung besteht in einer Powerbank mit mehreren Anschlüssen, so daß ich das iPhone, iPad und Kamera gleichzeitig laden kann.

Derzeit bin ich bei Telefonica ... leider ist die Netzabdeckung nicht immer so besonders gut auf dem Land, so daß ich bald zur Telekom wechseln werde.

Mein nächstes iPad wird vermutlich mit SIM-Karte sein ... always-on ist die Devise 2020 ... das war bei meinem ersten iPad Pro vor 5 Jahren noch nicht so.

---

## Tastatur

Ich liebe es, meine Erlebnisse, Gedanken und Wissen in Form eines Blogs in Markdown festzuhalten oder auch mal einen Instagram Post zu verfassen. Mit der virtuallen Tastatur des iPads ist das eher Krampf als Freude. Deshalb habe ich mir eine kleine Bluetooth Tastatur zugelegt, mit der das deutlich angenehmer ist. Sollte sich das bewähren, kann ich auch mal über eine ins Cover integrierte Tasatur nachdenken, bei der ich dann vielleicht nicht mal einen Tisch benötige, sondern die Tastatur auch mal auf die Beine stellen.

---

## Kopfhörer

Für Telefonate und Videos braucht man natürlich Kopfhörer. Ich bin mit meinen Earpods recht zufrieden. Mit der integrierten Ladeschale halten sie sehr lang und zudem sind sie extrem bequem.

Sollte doch mal der Saft ausgehen ... Powerbank.

---

## Kabel

Kabel benötige ich eigentlich nur für die Stromversorgung der Geräteakkus - im normalen Gebrauch ist mein Büro kabellos :-)

---

## Use-Case Office

Mein iPad verfügt über Office 365, mit dem ich die üblichen Office-Tools (Word, Excel, Powerpoint) nutze, aber auch MS Team für Chat und Videotelefonie.

WhatsApp wird per Web-UI im Browser verwendet.

---

## Use-Case Weiterbildung

Mit dem iPad und einer Internetverbindung hat man schon beste Voraussetzungen an gute Quellen für Weiterbildung zu kommen.

### Bücher

Bücher lassen sich sehr bequem offline lesen ... sogar besser als in Buchform, da man zumeinst Annotation machen kann, Screenshots anfertigen kann oder auch Bookmarks setzen.

### Videos

... benötigen viel Bandbreite ... je nach Mobilfunk-Tarif kann das schnell eng werden.

### Coursera

Ich habe eine Coursera-Flatrate und das ist sehr praktisch. Die Videos lassen sich downloaden und verbrauchen dann keine Internet-Bandbreite.

Leider sind die integrierten IDE's (auch wenn es Webapplikationen sind) häufig nicht nutzbar auf dem iPad ... schade, vielleicht verbessert sich das noch.

---

## Use-Case Softwareentwicklung

Früher habe ich hauptsächlich Java verwendet ... das wäre auf dem iPad vielleicht nicht so gut gegangen, weil es relativ viele Ressourcen benötigt.

### Visual Studio Code

Auf dem Laptop ist Visual Studio Code meine präferierte Entwicklungsumgebung für viele Sprachen. Leider gibt es sie nicht für iOS ... vielleicht auch eine Frage der notwendigen Ressourcen.

Allerdings bietet Coder (https://github.com/cdr/code-server) eine Möglichkeit VisualStudioCode auf einer Cloud-Umgebung zu hosten und dann im Browser zu nutzen. Naja, brauch ich nicht unbedingt ... aber auf jeden Fall eine Option.

### IDE Pythonista

Zur Zeit ich mehr Python und das läßt sich ganz gut per Pythonista verwenden. Darin sind schon einige Libraries integriert.

ein paar Verbesserungswünsche

* Markdown-Preview-Ansicht
* Git Integration ... wie soll man seinen Code sonst mit anderen Devices sharen?

### Git Integration

Working Copy ist ein toller Git Client, doch scheinbar kann man die geclonten Repos nicht in andere Apps integrieren, da die Apps scheinbar in einer Sandbox laufen.

Ein Grund mehr für einen schlanken Cloud–Server, auf dem man dann die Git Repos cloned ... genutzt per ssh client. Doch wie editiert man den Code dann in einer IDE seiner Wahl? 

* [Lösungsmöglichkeiten](http://codenugget.co/2016/11/20/working-with-git-from-ios.html)

	> "Due to its closed nature, iOS data exchange between apps is still somewhat cumbersome, but gladly, Anders knows all the tricks of the trade: Working Copy registers itself as iOS Document Provider, has a built-in WebDAV server, and offers a pretty extensive URL schema. Yes, you can really integrate your Git work flow with iOS editors like Coda or Textastic. Sadly, there’s no such integration yet with Pythonista, but you can get really far with just using Working Copy’s URL scheme."

* per Web–IDE?

### Cloudserver

Natürlich ist das iPad hinsichtlich Betriebssystem und Ressourcen eingeschränkt und nicht alles ist damit machbar. Nicht jede Software ist hierfür verfügbar (z. B. Docker) ... muß es aber auch nicht - ich liebe es ja gerade, weil es so klein und leicht ist - brauche ich ein richtiges Betriebssystem, dann gehe ich per ssh und Webbrowser auf eine Cloud-Instanz (AWS, Digital-Ocean, ...), auf der ich dann auch meine Anwendungen starten und für die ganze Welt verfügbar machen kann.

### Cloudserver - DigitalOcean

Ein kleiner Server kostet gerade mal 5 Euro im Monat.

### ssh

### Drawexpress

Für Skizzen (Architekturschaubilder, Sequenzdiagramme) verwende ich Drawexpress ... eine iOS App, die seit vielen Jahren perfekt zu meiner Arbeitsweise paßt.

