# Shellprogrammierung
* ShellCheck: https://linuxundich.de/gnu-linux/shellcheck-hilft-beim-schreiben-handwerklich-sauberer-shell-skripte/

---

# Fail-Fast
Shellskripte brechen in der Default-Konfiguration der Shells nicht ab, wenn ein Kommando fehlschlägt. Der daraus resultierende Exit-Code <> 1 wird einfach ignoriert. Das ist insbesondere bei komplexeren Skripten ein Problem, weil man am Ende nicht weiß, ob tatsächlich alles geklappt hat.

Deshalb sollte man die Option

```

