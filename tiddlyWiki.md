# Tiddly Wiki
Ich bin ein großer Freund guter Dokumentation ... Dokumentation schreiben muß aber auch Spaß machen und das tut es nur, wenn das Tooling paßt.

Ich mag keine WYSIWYG Editoren, die ich mit der Maus bedienen muß und ich mag Dokumentation under-Version-Control. Deshalb finde ich Markdown einen sehr guten Ansatz ... ich verwende ihn beispielsweise bei [GitBook](gitbook.md).

In der Softwareentwicklung ist die Dokumentation über ein Wiki schon mal tausenmal besser als die Verwendung von Word-Dokumenten. Aber das Wiki ist erstens zumeist weit weg vom Code und zweitens nicht releasegebunden, d. h. ich weiß nicht, ob die Doku zu meinem Release paßt.

Deshalb sollte Dokumentation im Code enthalten sein. Tiddly Wiki ermöglich das mit der sehr schlanken Struktur (im Extremfall ein einziges HTML-File) und des on-thy-fly Renderings von WikiText (oder auch Markdown).

Ich habe es schon 2007 genutzt, war damals aber wieder davon abgekommen. Jetzt habe ich es für Software-Dokumentation wiederentdeckt.

--- 

# Technische Sicht
TiddlyWiki packt den gesamten Content (inkl. Bilder) in eine einzige HTML-Datei. Das Rendering übernimmt JavaScript-Code uns CSS, das auch Teil dieser Datei ist.

Einerseits ist das ein recht schlankes Konzeot ... eine einzige Datei, aber andererseits ist der Inhalt mit technischem Code verbacken. Dadurch sind Vergleiche von Versionen teilweise auch durch technischen Code verschmutzt.

## Tiddler
Ein Tiddler ist ein Content-Container ... ein TiddlyWiki besteht aus vielen Tiddlern. Folgende Tiddler-Types (Mime-Types) werden verwendet:

* TiddlyWiki 5 Tiddler (text/vnd.tiddlywiki) ... Inhalt in WikiText-Syntax
* Markdown Tiddler (text/x-markdown)
* JPEG Tiddler (image/jpeg)
* PNG Tiddler (image/png)
* HTML Tiddler (text/html)
* ...

---

# Markdown Support
* http://tiddlywiki.com/plugins/tiddlywiki/markdown/

TiddlyWiki verwendet standardmäßig die WikiText Syntax, die an Markdown angelehnt ist. Wer sich aber mal mit Markdwon angefreundet hat, der wird es vielleicht auch in einem TiddlyWiki nutzen wollen.

Mit dem Plugin lassen sich Markdown-Tiddlers erstellen und werden im Browser ordentlich gerendert.

