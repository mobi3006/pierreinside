# cygwin
cygwin bringt die linuxtypischen GNU-Tools nach Windows und ermöglicht Windows-Usern somit eine einigermaßen brauchbare Command-Line-Shell.

---

# Babun
Mich hat der Cygwin-Installer immer genervt. Erstens wußte ich nie wo ich ihn abgelegt hatte und zweitens war das GUI schlecht. Deshalb hatte ich großes Interesse am Babun-Paketmanager ``pact``.

---

# MinGW
Entstand aus cygwin (und ist damit von der Idee gleich)  ... braucht keine DLL mehr.

MingW kommt in der Default-Instalation mit Bash als Shell (``echo $SHELL``) aber ohne ``~/.bashrc`` daher und ohne ``~/.alias``. Will man das haben, so muß man sich die selbst erzeugen:

```
$ cat .bashrc
if [ -f ~/.alias ]; then
   source ~/.alias
fi
```

Ich habe MinGW für [Docker unter Windows](docker_windows.md) als preconfigured Shell benutzt, weil mein [Babun](babun.md) nicht mit Docker funktioniert hat.

