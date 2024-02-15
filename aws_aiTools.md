# AWS AI Tools

2023 war das Jahr der AI Tools ... angefangen mit ChatGPT haben die Tools auch in die Software-Entwicklung Einzug gehalten. Ich hatte mal GitHub Copilot getestet und war sehr begeistert bei Bash/Python Code.

---

## Amazon CodeWhisperer in VSCode

* [How to setup CodeWhisperer for Visual Studio Code | Features | Hands-On](https://www.youtube.com/watch?v=C4kr79qWqAc)

Ich verwende VSCode und habe dort den CodeWhisperer mit einer eigenen [**personal** AWS-Builder-ID](https://docs.aws.amazon.com/signin/latest/userguide/create-aws_builder_id.html) konfiguriert.

CodeWhisperer kann

* Code erzeugen ... hierbei werden evtl. auch Lizenzen angezeigt
* Code erklären

### Nutzung

* Tastenkombination "Option-C" (MacOS), um Vorschläge zu generieren (man kann aber auch Auto-Vorschläge einkonfigurieren)
* Tastenkombination "Pfeil links" und "Pfeil rechts", um zwischen verschiedenen Vorschlägen zu navigieren

Wenn man in eine Datei `python.py` folgende eintippt

> # implement function process_csv to extract data from a csv file and return average income of the employees

dann wird `import csv` vorgeschlagen und der nachfolgende Code verwendet diese Library. Nimmt man diesen Vorschlag nicht an und schreibt stattdessen `import pandas` (auch wenn das nicht vorgeschlagen wurde), dann wird anschliessend Code für diese Library generiert. Genial ...