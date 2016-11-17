# Terminal Multiplexer
Ich habe vor einigen Jahren mal ``screen`` ausprobiert ... fand es faszinierend, hatte aber keinen richtigen Einsatzzweck. Für mich hat [Terminator](terminator.md) besser gepaßt.

Jetzt - einige Jahre weiter - will ich dem Thema mal wieder eine Chance geben ... und tatsächlich habe ich derzeit auf Remote-Maschienen gelegentlich lang laufende Prozesse (Installationen, Datenmigrationen, Datenimports, ...), die übers Wochenende laufen. Wenn ich das aus meiner SSH-Shell machen und mich abmelde, dann stirbt auch der Prozess. Tools wie ``screen`` und ``tmux`` lösen dieses Problem.

---

# TMux
Nach der Installation per ``sudo apt-get install tmux`` wird der ``tmux``-Server per tmux gestartet. Danach befindet man sich in einem Terminal-Window, das kaum anders aussieht als das bisherige. Aber einige interessante Features mitbringt:

* https://www.youtube.com/watch?v=BHhA_ZKjyxo
* Cheat Sheet: https://tmuxcheatsheet.com/




