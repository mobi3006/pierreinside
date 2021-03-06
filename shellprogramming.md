# Shellprogrammierung

* ShellCheck: https://linuxundich.de/gnu-linux/shellcheck-hilft-beim-schreiben-handwerklich-sauberer-shell-skripte/

---

## Motivation

Ich nutze Linux als Enticklungsumgebung und bin deshalb halbwegs vertraut mit den GNU-Tools, die ich immer wieder auf der Command-Line direkt nutze. Irgendwann waren mir die Kommandos aber zu lang, um sie immer wieder einzutippen. Das war mein Einstieg in die Shellprogrmmierung ...

Lange Zeit habe ich Shellscripting dann nur für mein persönliches Tooling benutzt. Irgendwann nutzte ich es dann aber auch im professionellen Umfeld, um Provisioning eines Linux-Images aus Vagrant heraus zu triggern. Hier haben wir dann irgendwann auf Ansible gewechselt, was aus meiner Sicht die richtige Entscheidung war.

Später kam dann Provisioning im Docker-Umfeld hinzu und der Aufbau einer komplexeren Entwicklungsumgebung.

---

## Kritik

Leider bin ich trotz dieser reichhaltigen Erfahrung noch immer kein Freund der Shellprogrammierung, weil

* Exception Handling ... Traps, Fail-Fast (`set +e`, `set +u`, ...) fühlen sich nicht besonders toll und stabil an. Selbst wenn man `set -e`, um fail-fast abzubilden, kann JEDER in seinem Script (das aufgerufen wird) ein `set +e` machen (weil sein Skript nicht fail-fast kompatibel ist) und vergessen `set -e` wieder zurückzustellen. Dadurch können kleinste Änderungen extreme Seiteneffekte haben.
  * die Default-Einstellung bei Bash-Scripten ist, daß Exit-Codes ungleich 0 einfach ignoriert werden - dadurch werden Fehler erst viel später bzw. gar nicht festgestellt - ANTI-PATTERN
* Shells sind untereinander nicht kompatibel (sh, bash, zsh) funktionieren im wesentlichen ähnlich, im Detail gibt es dann aber doch Unterschiede (z. B. if-clause, functions) ... Mit einem Shebang (#!/bin/bash) in den Scripten lässt sich das Problem nahezu umgehen, doch in beim Source (`source seten.sh`) hilft das nicht - hier kommt es auf die gewählte Shell des Ausführenden an
* GNU Tools sind nicht plattformunabhängig ... wer `curl` unter Linux, MacOS, Cygwin nutzen will dreht durch (https://daniel.haxx.se/blog/tag/securetransport/)
* Fehlersuche ist eine einzige Katastrophe ... trotz `set -x` fühle ich mich wie in den 80ern - `echo` ist mein einziger Freund
* Refactorings ... ich habe noch kein gutes Tool gefunden
* automatisiertes Testen ... geht das?
* Returnvalues eines Skripts - `echo` beißt sich leider mit Logging-Ausgaben. Selbst wenn man darauf verzichten kann ... es ist fragil. http://stackoverflow.com/questions/3236871/how-to-return-a-string-value-from-a-bash-function

Hier habe ich auch eine "schöne" Auflistung der Schwächen gefunden: http://mywiki.wooledge.org/BashWeaknesses 

Das sollte man wenigstens beherzigen:

* http://www.davidpashley.com/articles/writing-robust-shell-scripts/

Trotz all dieser Nachteile habe ich noch keine gute Alternative gefunden, wenn es um typische Dateioperationen (`cp`, `mv`, `ln`, `find`, `grep`, ...) geht. Für Contentbasierte Operationen (z. B. Suchen in XML-Files) ist es sicher nicht geeignet ... hier würde ich Perl, Python, Groovy, ... verwenden - das ist klar. Vielleicht ist Go eine Alternative ...

In diesem Beitrag ([When to use Bash and when to use Perl/Python/Ruby?](http://superuser.com/questions/414965/when-to-use-bash-and-when-to-use-perl-python-ruby)) wird das Thema diskutiert und insbesondere dieser Argumentation kann ich zustimmen:

> "Bash is closer to the file system and can be great for first draft solutions to problems which are NOT well defined. For this reason, a bash script might be a good first choice to prototype something in with the full intention of porting it to python once the problem is better understood." ([Travis](https://superuser.com/questions/414965/when-to-use-bash-and-when-to-use-perl-python-ruby/980247#980247))

---

## Tips

### Functions

#### Logging in Functions

Ein häufiger Tip ist `echo returnValue` zur Rückgabe von Parametern zu verwenden. Leider hat das den Nachteil, daß die darin verwendete ERSTE `echo`Ausgabe als Returnwert interpretiert wird. Dadurch ist Logging über `echo` in Funktionen nicht zu gebrauchen (viel zu fehleranfällig bzw. zu einschränkend). In diesem Beispiel:

```bash
getSurnameByEcho() {
   echo "getSurnameByEcho"    # dieser Wert wird der Rückgabwert
   echo "feldbusch"
}
nameByEcho=
surnameByEcho=$(getSurnameByEcho nameByEcho)
echo "surnameByEcho=${surnameByEcho}"
```

wird

```bash
surnameByEcho=getSurnameByEcho
feldbusch
```

ausgegeben - DAS WILL MAN NICHT.

Deshalb sollte man es eher auf diese Weise machen:

```bash
getSurnameByDeclare() {
   declare -n returnValue=${1}
   echo "getSurnameByDeclare"
   returnValue="feldbusch"
}
nameByDeclare=
getSurnameByDeclare nameByDeclare
echo "surnameByDeclare=${nameByDeclare}"
```

Hier hat man das gewünschte Ergebnis

```bash
getSurnameByDeclare
surnameByDeclare=feldbusch
```

und muß nicht auf `echo`-Logausgaben verzichten.

#### `_local` Variablen beeinflussen `${?}`

```bash
function myfunction() {
  _foo=`exit 1`
  if [ "${?}" == "1" ]; then
    echo "this was expected"
  else
    echo "error"
  fi

  local _bar=`exit 1`
  if [ "${?}" == "1" ]; then
    echo "this was expected"
  else
    echo "error: local has destroyed the semantic"
  fi
}
```

Beim Aufruf von `echo "controller: $(myfunction)"` wird leider folgendes ausgegeben:

```
controller: this was expected
error: local has destroyed the semantic
```

### Know-How

* http://wiki.bash-hackers.org/syntax/pe

### Fail-Fast

* http://www.davidpashley.com/articles/writing-robust-shell-scripts/

Shellskripte brechen in der Default-Konfiguration der Shells nicht ab, wenn ein Kommando fehlschlägt. Der daraus resultierende Exit-Code <> 1 wird einfach ignoriert. Das ist insbesondere bei komplexeren Skripten ein Problem, weil man am Ende nicht weiß, ob tatsächlich alles geklappt hat.

Deshalb sollte man die Option

### Shellcheck

* https://www.shellcheck.net/

Dieses Tool sollte man gelegentlich über die Skripte laufen lassen, um die Qualität zu prüfen.
