# GitHub - Copilot

AI während der Programmierung ... klingt nach dem Paradies. Wie ist es wirklich?

> GitHub pusht dieses Thema im August 2023 und ist sehr freigiebig mit Testlizenzen. So wie ich GitHub in den letzten Jahren kennengelernt habe wird sich Copilot sukzessive verbessern.

---

## Getting Started VSCode

* [Youtube - GitHub Copilot in 7 minutes](https://www.youtube.com/watch?v=hPVatUSvZq0)

Ich verwende für diesen ersten Test meinen Lieblingseditor Visual Studio Code.

> VSCode ist die am besten unterstützte IDE - zum Zeitpunkt des Tests war dort schon die Chat-Funktionalität enthalten, die in IntelliJ noch fehlte.

Ich installiere zunächst die Extension "GitHub Copilot" (ich verwende die Pre-Release Version, um tatsächlich die maximalen Features zu erhalten).

Nach der Installation ist ein Reload und eine GitHub Authentifizierung notwendig - die entsprechende Seite wird im Browser automatisch aufgerufen. Nach der Authentifizierung ist die Extension einsatzbereit und ich erkenne

* unten rechts im Tray ein neues Icon für den Copilot
* eine neue Extension namens Chat

Selbst beim Schreiben dieses Textes erhalte ich schon Vorschläge, die ich mit der Tab-Taste annehmen kann. Das ist schon mal ein guter Anfang.

> Nachdem ich Copilot installiert hatte musste ich ein paar Tage an Product-Owner-Themen arbeiten - ausserhalb von VSCode. Den Copilot hatte ich danach aus den Augen verloren und begann an einem Shellscript mit `gh`-CLI und `jq` zu arbeiten. Bisher hatte ich `jq` nur rudimentär genutzt, aber nun brauchte ich komplexere Filter. Ich las eine Stunde in der Doku, um das Konzept besser zu verstehen und mir einen Filter zusammenzubauen. Ich testete meinen Filter die ganze Zeit auf der Console - ausserhalb von VSCode. Nachdem ich der Meinung war, einen passenden Filter zu haben fing ich in VSCode mit dem Tippen und erhielt sofort einen Code-Snippet vorgeschlagen. Schon das allein hätte mich viel schneller in die Lösung starten lassen. Ich probierte die Auto-Vervollständigung über einen Prosa-Text ... der vorgeschlagene Code entsprach schon fast meiner Lösung. Ich war begeistert.

Erst danach beschäftigte ich mich intensiver mit dem Konzept und den Möglichkeiten des Copilot.

---

## Konzept

Copilot analysiert den Code rund um den Cursor und kennt somit den Kontext. Aus diesem Kontext versucht er - mit seinem Wissen über Sprachen/Tools - in Real-Time gute Vorschläge zu generieren (das Icon unten rechts ist ständig am rotieren - man braucht schon eine stabile Internet-Connection und viele Daten).

Angeblich lernt es nicht nur vom Server dazu, sondern auch vom Benutzer ... es soll den Programming-Style des Nutzers erlernen und dadurch immer persönlicher werden. Ich bin gespannt, ob das mal wieder nur so ein Hochglanz-Versprechen ist.

> Beim Lernen ist es auf das Feedback des Users angewiesen ... deshalb sollte man bei Vorschlägen (im Chat) auch ein Feedback geben, ob der Hinweis hilfreich war oder nicht.

---

## User-Experience

### Kommentare

Anstatt zu coden, kann man auch mit einem Kommentar beginnen und Copilot einen ersten Vorschlag machen lassen. Das Ergebnis sieht unterschiedlich aus

* generiertes Code Snippet
* generierter Prosa-Algorithmus. In einem Python-File wird aus dem Kommentar

  ```
  # write an algorithm to calculate first 10 prime numbers and print them
  ```
  
  folgender Algorithmus
  
  ```
   # 1. create a list of numbers from 1 to 100
   # 2. iterate over the list
   # 3. for each number, check if it is a prime number
   # 4. if it is a prime number, add it to the list of prime numbers
   # 5. if the list of prime numbers has 10 elements, stop iterating
   # 6. print the list of prime numbers
  ```

  Nachdem ich den ausgegebenen Algorithmus markiert und an Copilot "Start Chat Code" (rechte Maustaste) gesendet habe, erhalte ich auch richtigen Python Code, den ich an beliebige Stelle übernehmen kann.

### Feintuning - Code-Suggestions - Next/Previous

> ich habe leider eine deutsche Tastatur ... das ist es manchmal schwierig mit den Default-Bindings

Ich habe die Keybindings ("Code - Settings - Keyboard Shortcuts - `editor.action.inlineSuggest.show`") so angepasst, dass

* `Control + .` den nächsten Vorschlag anzeigt
* `Control + ,` den vorherigen Vorschlag anzeigt

### Feintuning - Code-Suggestions - Synthesizing

Über `Control + ENTER` kann man gleich 10 mögliche Auto-Suggestions in ein separates Tab generieren lassen, um den Code dann in aller Ruhe zu studieren und sich den passenden Code selbst zusammenzubauen.

---

## Copilot Labs

* [Youtube - Copilot in 7 minutes - Copilot Labs](https://youtu.be/hPVatUSvZq0?t=189)

Dies ist eine separate VSCode Extension, die interessante Features bereitstellt:

* Übersetzung von einer Programmiersprache in eine andere
* Brushes:
  * Refactorings (z. B. Types in einem JavaScript-File einfügen)
  * Debug-Code
  * Clean-Code
  * Make Robust
  * erzeugt Documentation