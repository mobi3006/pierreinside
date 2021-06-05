# Jenkins Pipeline - Tipps und Tricks

* [MUST-HAVE](https://code-maven.com/jenkins)

In [diesem Abschnitt](jenkins.md) geht es um die Konzepte ... hier geht es im Code-Snippets und Erklärungen dazu.

## Declarative Pipeline

### Shell Skripte

Auch hier lassen sich Shell-Skripte per `sh` einbinden ... an vielen Stellen - auch in den `environment`-Abschnitten. Für kleine Snippets geht das so:

```
sh "echo ${BRANCH_NAME}"
```

> Umgebungsvariablen von Jenkins (z. B. `BRANCH_NAME`) lassen sich hier einfach per Shell-Resolving auflösen.

Verwendet man in dieser einfachen Form Anführungszeichen in der Payload, so muß man diese quoten:

```
sh "git tag -a 4711 -m \"New version 4771 tagged\" && git push origin 4711"
```

Bei größeren/komplexeren Skripten kann man es auch per

```
sh """
   echo "Hallo Pierre"
   echo "Du willst jetzt den branch ${BRANCH_NAME} bauen"
   echo 'viel Spass'
"""
```

>ACHTUNG: in obigem Beispiel gibt es Anführungszeichen auf zwei Ebenen (auf der Ebene 2 muß das Anführungszeichen NICHT gequotet werden). Ebene 1: `sh """` - hierbei handelt es sich um die [Groovy-Triple-Double-Quotes](https://groovy-lang.org/syntax.html#_triple_double_quoted_string). Ebene 2: `echo "Du willst jetzt den branch ${BRANCH_NAME} bauen"` - hierbei handelt es sich um die Shell-Double-Quotes. Auch mit den einfachen Anführungszeichen funktioniert die Ersetzung von `BRANCH_NAME` in `echo 'Du willst jetzt den branch ${BRANCH_NAME} bauen'` ... aber nur wenn man die Groovy-Triple-Double-Quotes verwendet. Verwendet man hingegen die [Groovy-Triple-Single-Quotes](https://groovy-lang.org/syntax.html#_triple_single_quoted_string), so funktioniert die Ersetzung von `BRANCH_NAME` nicht.

Sollen die Skripte auch noch einen Rückgabewert haben (im folgenden Beispiel die Anzahl der `*.log` Dateien), so kann das so erfolgen (hier sogar mit der Kennzeichnung des Shell-Typs "Bash"):

```
numberLogFiles = sh (
    script: """#!/bin/bash
               _pwd=`pwd`
               find . -name "*.log" | wc -l
            """,
    returnStdout: true
).trim()
```

> ACHTUNG: alles, was auf stdout geschrieben wird kommt dann in die Variable `numberLogFiles` (inkl. Zeilenumbrüche). Per Default ist der Datentyp ein String ... kann man aber auch noch per `as Integer` anpassen, so daß die Groovy Variable `numberLogFiles` ein Integer ist.

Macht man hingegen folgendes (Verwendung der Shell-Variable `_counter`):

```
numberLogFiles = sh (
    script: """#!/bin/bash
               _pwd=`pwd`
               _counter= `find . -name "*.log" | wc -l`
               echo \${_counter}
            """,
    returnStdout: true
).trim()
```

dann muß man das Dollar quoten - bei einer Groovy-Variablen oder einer Umgebungsvariablen hingegen nicht. Das macht es recht tricky, wenn man sich die Fallstricke mühsam erarbeiten muß :-(

**REGEL:**

* in Shell-Skripten können Groovy-Variablen und Umgebungsvariablen mit einfachem `${variable}` resolved werden ... Shell-Variablen müssen gequoted werden `\${variable}`.
