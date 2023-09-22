# jq - Comamnd-Line JSON Processor

Das Parsing von Daten ist seit je her einer der wichtigsten Aspekte der Maschine-Maschine-Komminikation. Früher verwendete man XML, sind heute ist JSON, YAML, ... angesagter. Bei XML ist die Query Language XPath, bei JSON ist es [`jq`](https://jqlang.github.io/jq/).

Hier die Essenz des Ansatzes ([Quelle](https://jqlang.github.io/jq/manual/)):

```
"A jq program is a "filter": it takes an input, and produces an output. There are a lot of builtin filters for extracting a particular field of an object, or converting a number to a string, or various other standard tasks.

Filters can be combined in various ways - you can pipe the output of one filter into another filter, or collect the output of a filter into an array.

Some filters produce multiple results, for instance there's one that produces all the elements of its input array. Piping that filter into a second runs the second filter for each element of the array. Generally, things that would be done with loops and iteration in other languages are just done by gluing filters together in jq.

It's important to remember that every filter has an input and an output. Even literals like "hello" or 42 are filters - they take an input but always produce the same literal as output. Operations that combine two filters, like addition, generally feed the same input to both and combine the results. So, you can implement an averaging filter as add / length - feeding the input array both to the add filter and the length filter and then performing the division."
```

---

## Getting Started

* [Mini Tutorial](https://jqlang.github.io/jq/tutorial/) ... macht nur Lust auf [mehr](https://jqlang.github.io/jq/manual/)

Der einfachste jq Processor ist `.`:

```
jq '.' messages.json
```

oder auch

```
echo '[{"foo": 0}]' | jq
```

der nur ein Pretty Print des JSON macht. Der Input wird einfach schöner ausgegeben.

> auf der Linux-Shell verwendet man am beste immer einfache Anführungsstriche (`'`) um den Prozessor. Doppelte Anführungsstriche würden auf den Shells ignoriert und wir müssen aber den jq-Code vor einer Interpretation der Shell schützen.