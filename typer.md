# CLI mit Typer

* [Homepage](https://typer.tiangolo.com/)

---

## CLI Auto-Completion

Typer bringt Auto-Completion für die meisten gängigen Shells mit.

Angenommen die Typer-CLI ist in `main.py` implementiert. Dann läßt sich die CLI-Auto-Completion per `python main.py --install-completion bash` einrichten. Anschließend muß nur die Shell neu gestartet werden bzw. ein `source ~/.bashrc` reicht aus.

> Unter Windows mit cygwin hat die Konfiguration nicht out-of-the-box funktioniert, da der Pfad in `~/.bashrc` nicht cygwin-like war. Außerdem waren die Line-Endings der unter `/cygdrive/c/cygwin64/home/foo/.bash_completions/main.py.sh` bereitgestellten Shell-Scipt im Windows-Style ... das führte zu Fehlern bei der Ausführung. Nachdem ich die Datei auf LF-Endings umgestellt hatte, funktionierte die Auto-Completion einwandfrei.
