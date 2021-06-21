# Best Practices

Als Newbe sollte man sich strikt an Best-Practices halten. Das gilt auch für erfahrene Software-Entwickler, die nun Python neu entdecken. Jede Sprache hat ihre Idiome, die es erfahrenen Python-Entwicklern einfachen machen, den Code zu lesen und zu verstehen. Wenn man sich selbst dann für Python-erfahren genug hält kann man sicher das ein oder andere anders machen.

---

## Coding Style

* [Official Python Code Style - PEP8]
* [Google Python Style Guide](https://github.com/google/styleguide/blob/gh-pages/pyguide.md)

Ich denke, man sollte das Rad nicht neu erfinden und sich an einen weit akzeptierten Styleguide halten - einen Custom-Styleguide zu entwerfen halte ich für Zeitverschwendung. Zur Not muss man seinen Style halt leicht modifizieren (fällt mir als Python Newbe vielleicht auch besonders leicht, da ich noch keinen eigenen Style habe).

Solche Prüfungen sollte die IDE auch unterstützen und überprüfen. Hierzu verwendet man sog. Linter. [Visual Studio Code unterstützt verschiedene Linter](https://code.visualstudio.com/docs/python/linting), der Default is Pylint, doch verwende ich für die Auto-Formatierung schon PEP8 und deshalb möchte ich auch diesen Coding Style verwenden:

* ich selektiere über die Command Palette "Python: Select Linter / pycodestyle"
  * laut Doku ist der PEP8 kompatibel
* die Aufforderung zur Installation nehme ich an
* anschließend enable ich Linting über Command Palette "Python: Enable/Disable Linting"

Danach sehe ich die Style-Abweichungen in der Status-Leiste und dem Problems Tab:

![Pylinter](images/vscode-pylinter-pep8.png)

Die Linter lassen sich über die VSCode `settings.json` den eigenen Ansprüchen entsprechend konfigurieren:

> "python.linting.pycodestyleArgs": ["--ignore=E303"]

Mit `yapf` kann ich die Formatierungsprobleme automatisch lösen - sehr praktisch.

---

## Formatting

In Python steht das `autopep8`-Package zur Verfügung, das sich bei Ausführung des Befehls "Format Document" automatisch installiert.

### Formatter der IDE

IDEs unterstützen i. d. R. Auto-Formatting. Das sollte man verwenden und regelmäßig durchführen.

### Bulk-Formatting

Immer wieder ein Streitpunkt unter Entwicklern ... Tabs oder Spaces, Einrückungen, ... blablabla. Ich mag den Ansatz von Golang, daß der Code immer automatisch formatiert wird und somit bei JEDEM Entwickler gleich aussieht. Ende der Diskussion.

Meine Empfehlung ist die Verwendung von [yapf](https://github.com/google/yapf/). Hierbei handelt es sich um ein Python-Package (`pip install yapf`), das den Code auto-formatiert. Ich verwende es i. a. so (`venv` ist der Ordner meiner virtuellen Python Umgebung ... den Python-Source-Code der Distribution möchte ich nicht umformatieren):

```bash
yapf --in-place --recursive --style="{based_on_style: google, indent_width: 3}" --exclude "venv/**" **/*.py
```

`yapf` ist über ein `.style.yapf` (beispielsweise im Root-Folder eines Projekts) konfigurierbar, so daß man dort obige CLI-Options auch so abbilden kann

```ini
[style]
based_on_style=pep8
indent_width=4
```

Ich habe diesen Alias in meiner Shell definiert:

```bash
alias yapfify="yapf --in-place --recursive --exclude 'venv/**' **/*.py"
```

Mit einem einfachen `yapfify` kann ich somit eine Formatierung vornehmen.

> Wenn man Bulk-Formatierungen vornimmt, sollte man das in einem eigenen Commit von anderen Änderungen separieren und in der Commit-Message entsprechend kennzeichnen. Am besten ist, wenn diese Formatierung IMMER vor einem Commit abläuft.

Eine Option ist die Verwendung eines Git-Commit-Hooks, um den Code beim Commit automatisch zu formatieren.
