# Markdown
Markdown ist eine sehr einfache Beschreibungssprache von Dokumenten. Sie eignet sich besonders gut, um mit einem Standard-Editor wie vi (ohne WYSIWYG-Editor) komfortabel ansprechende professionelle Dokumentation zu schreiben. 

Auf Plattformen wie GitHub gehört sie zum Standard.

---

# Alternativen
* [reStructuredText](https://de.wikipedia.org/wiki/ReStructuredText)

---

# Syntax
* http://jinlaixu.net/books/gitbook-documentation/book/markdown.html
* https://daringfireball.net/projects/markdown/syntax
* GitHub/GitBook:  http://toolchain.gitbook.com/syntax/markdown.html

## YouTube-Videos einbetten
Am besten verwendet man pure-HTML ... das ist mächtiger (z. B. Größe) als die Markdown-Anweisung. 

Folgender Code

```HTML
<a href="http://www.youtube.com/watch?
feature=player_embedded&v=idLyobOhtO4" 
   target="_blank">
      <img
         src="http://img.youtube.com/vi/idLyobOhtO4/0.jpg"
         alt="Linus Torvalds über Git-Alternativen" 
         width="240" 
         height="180" 
         border="10" />
</a>
```

sieht dann so aus:

  <a href="http://www.youtube.com/watch?feature=player_embedded&v=idLyobOhtO4
  " target="_blank"><img src="http://img.youtube.com/vi/idLyobOhtO4/0.jpg"
  alt="Linus Torvalds über Git-Alternativen" width="240" height="180" border="10" /></a>

I like :-)

---

# Nicht-Standardisierte Erweiterungen
Der GitHub-Renderer unterstützt GitHub-spezifische Erweiterungen, die dann allerdings bei anderen Renderern zu Problemen führen können bzw. ignoriert werden.

## GitHub: Syntax-Highlightning
Code-Blöcke kann man auf zwei Arten formatieren:

* Einrückungen mit mehr als 4 Spaces
* 3 Backticks

**ACHTUNG:** Nur die Backtick-Variante unterstützt Syntax-Highlightning:

```java
public static void main(String[] args) {
    List<String> persons = Arrays.asList("Pierre", "Silke", "Robin", "Jonas", "Nora");
    for (String person : persons) {
        System.out.println(StringUtils.reverse(person));
    }
}
```

Folgende Sprachen werden unterstützt:

* https://highlightjs.org/static/demo/

