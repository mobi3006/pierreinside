# Golang

Ich bin zu Go gekommen, weil es derzeit hip ist, viele der von mir verwendeten Tools (HashiCorp-Stack) auf Go basieren und ich die Idee eines einzelnen Executables (Cross-Compiled auf meiner Linux-Maschine auch für Windows und MacOS) einfach genial finde. Außerdem möchte ich CLI's für meine Tools anbieten und einige meiner Shellskripte ablösen. Die Syntax und Konzepte haben mir bei Go auf Anhieb sehr gut gefallen.

Alternativ hierzu habe ich mir [Python](python.md) angeschaut, das ich in einem Raspberry Pi Projekt ausprobieren durfte. Das fand ich auch nicht schlecht, aber das ewige Nachinstallieren von Packages nervt ... das will ich meinen Kunden nicht zumuten. Für mein eigenes Scripting würde ich Python aber nicht ausschließen.

---

## Getting Started

### Ohne Installation

* [Online Playground](http://play.golang.org)
  * [Tutorial](http://tour.golang.org)

### Lokale Installation

* [Offizielle Dokumentation](https://golang.org/doc/install)

Nach dem [Download eines Tarballs](https://golang.org/doc/install) für mein Linux System

```bash
cd /tmp
wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz
tar xvfz go1.13.7.linux-amd64.tar.gz
mv go ~/programs/go-1.13.7
ln -s ~/programs/go-1.13.7 ~/programs/go
```

und setzen einiger Umgebungsvariablen (in der Shell-Konfigurationdatei)

```bash
export PATH=$PATH:~/programs/go/bin
```

konnte ich mein erstes Programm per (im richtigen wording wird hier ein Package `hello` angelegt)

```bash
mkdir -p de.cachaca.learn.go/src/hello
cd de.cachaca.learn.go/src/hello
```

mit folgendem Code

```Go
package main

import "fmt"

func main() {
   fmt.Printf("hello, world\n")
}
```

per `go build` compilieren (hierbei wird ein plattformabhängiges Executable erzeugt) und per `./hello` ausführen.

Um zuküntige Probleme zu vermeiden ergänze ich meine Shellkonfiguration zudem um

```
export GOBIN=$(go env GOPATH)/bin
export PATH=${PATH}:${GOBIN}
```

Danach funktioniert auch `go install`, um das Binary unter `~/go/bin/hello` abzulegen und aufrund der `PATH`-Anpassung kann ich dann `cd ~ && hello` ausführen.

### Tutorial Installation

Das [Tutorial](https://tour.golang.org/) läßt sich per `go get golang.org/x/tour` einfach lokal installieren. Dabei erhält man etwa diesen Output

```
go: finding golang.org/x/tour latest
go: downloading golang.org/x/tour v0.0.0-20200201212631-8f38c9a8d074
go: extracting golang.org/x/tour v0.0.0-20200201212631-8f38c9a8d074
go: downloading golang.org/x/tools v0.0.0-20190312164927-7b79afddac43
go: extracting golang.org/x/tools v0.0.0-20190312164927-7b79afddac43
go: downloading golang.org/x/net v0.0.0-20190311183353-d8887717615a
go: extracting golang.org/x/net v0.0.0-20190311183353-d8887717615a
go: finding golang.org/x/tools v0.0.0-20190312164927-7b79afddac43
go: finding golang.org/x/net v0.0.0-20190311183353-d8887717615a
...
```

Anschließend liegt unter `~/go/bin/tour` (gemäß des Defaultwerts von `GOBIN=~/go/bin`) und kann dann als Executable per `~/go/bin/tour` lokal ausgeführt werden. Es startet einen Webserver, der die HTML-Seite bereitstellt.

> Hintergrund: Bei diesem `go get` Kommando wurden Module ins lokale Go-Repository geladen (Konfiguriert per `export GOPATH`) und das Executable compiliert ... wenn ich es richtig verstanden habe.

---

## Konzepte

### Konventionen

* Verzeichnisstruktur
* Variablen, Konstanten und Funktionen mit Großbuchstaben werden exportiert

### Verzeichnisstruktur

Go-Sourcecode basiert auf einer festen Verzeichnisstruktur, die folgendermaßen aussieht:

* src/
  * foo/
    * bar/
      * go.mod
        * optionaler Modul-Deskriptor
      * hello.go
      * module-1/
      * module-2/
      * ...

Go verwendet neben dem Source-Code Verzeichnissen ein lokales Repository mit Binaries und Modulen. Standardmäßig befindet sich das in `~/go` - konfigurierbar über die Umgebungsvariable `export GOPATH`:

* ~/go/
  * bin/
  * pkg/
  * src/

Am besten fügt man `export PATH=${PATH}:$(go env GOPATH)/bin` zur Shellkonfiguration hinzu, denn dann liegen alle mit

* `go get`
* `go install`

ins lokale Repository installierten Go-Anwendungen im `PATH` und sind somit jederzeit im Zugriff.

### Konfiguration

Mit `go env` erhält man eine Übersicht über alle unterstützten Umgebungsvariablen, die in der Datei `go env GOENV` spezifiziert werden können.

> ACHTUNG: es handelt sich hier um GO-interne Umgebungsvariable ... sie sind nicht in der Shell verfügbar - mit `go env FOO` können sie aber abgefragt und in Shellskripte integriert werden.

### Repository, Modul, Package

* [Dokumentation](https://golang.org/doc/code.html)
* [Go Modules](https://blog.golang.org/using-go-modules)

... DrawExpress-Skizze ...

* Modul erstellen: `go mod init github.com/user/hello`
  * hierdurch wird ein [Modul-Deskriptor `go.mod`](https://golang.org/cmd/go/#hdr-The_go_mod_file) angelegt, der übrigens hierarchisch ausgelegt ist
    * im Modul-Deskriptor befindet sich die Modul-Spezifikation (z. B. Modulname) und Requirements wie Go-Version, Dependencies
  * unterhalb der Module können sich viele Pakete befinden
    * baut man ein solches Paket mit `go build`, dann wird man feststellen, daß kein Binary erzeugt wird. Das Binary landet dann nicht im Working-Directory, sondern im sog. Cache (auf meinem System unter `~/.cache/go-build/` ... konfiguriert in `go env GOCACHE`)
  * in Go-Code importiert man Module
* Modul bauen und installieren: `go install github.com/user/hello`
* verwendet man in einem Package eines Moduls einen `import`, dann wir bei `go build` der Modul-Deskriptor `go.mod`automatisch um die Dependency erweitert.

### Package

* `main` ist das Default-Package, das eine `main()` Funktion beherbergen muß - auf diese Weise können einfache Go-Programme ohne Module bereitgestellt werden
  * das `main`-Package wird nicht in ein Unterverzeichnis gepackt

### Wichtige Kommandos

* `go mod`
  * Modulhandling
* `go build`
  * hier werden Module gesucht
    * GOROOT: Go-Installation, z. B. `~/programs/go-1.13.7/src` (siehe `go env GOROOT`)
    * GOPATH: lokales Go-Repository, z. B. `~/go/src` (siehe `go env GOPATH`)
  * werden Module/Pakete vermißt - weil sie weder Bestandteil der Go Installation sind noch im lokalen Go-Repository liegen - dann lassen sie sich per `go get` nachinstallieren
* `go get`
  * Paketmanager
* `go test`
* `go install`
  * compiliert und installiert das Go-Programm ins lokale GO-Repository (`GOBIN`)
  * sollte ein Binary im Arbeitsverzeichnis liegen, dann wird es gelöscht ... will man es neu erzeugen, dann per `go build`

### Imports

* ein `import` in Go-Programmen referenziert ein Package
  * wenn es sich um ein Package handelt, das nicht zum aktuellen Modul gehört und auch kein Go-internes Paket ist, dann wird automatisch die letzte Version des entsprechenden Moduls in den Modul-Deskriptor eingetragen (so es sich um ein Modul handelt)
    * es werden nur direkte Dependencies in den Modul-Deskriptor eingetragen - keine transitiven. Die transitiven Abhängigkeiten werden über die Modul-Deskriptoren der explizit referenzierten Module aufgelöst. Da der Source-Code (und somit die `go.mod`-Dateien) der expliziten Module nach `${GOPATH}/pkg` runtergeladen werden ist das kein Problem
    * bei `go build` wird in einem solchen Fall automatisch der Source Code des Pakets nach `${GOPATH}/pkg` runtergeladen und somit als Source-Code zur Compilierung zur Verfügung stehen
    * gibt es keine Binaries???

### Call by Value vs. Call by Reference

* Funktionen und Methoden können entweder einen Parameter per Copy oder als Referenz (= Pointer) erhalten. Bei der Übergabe als Pointer, ist der Parameter In- und Output-Parameter, d. h. Änderungen am Wert sind nach außen sichtbar. Bei der Übergabe als Copy wird der Wert kopiert und der aufgerufenen Funktion/Methode steht nur eine Kopie zur Verfügung. In folgendem Beispiel werden die beiden Übergabevarianten gezeigt:
* Beispiel aus der [Go-Tour](https://tour.golang.org/methods/5)

```go
package main

import (
  "fmt"
  "math"
)

type Vertex struct {
  X, Y float64
}

// Call-by-Value
func Abs(v Vertex) float64 {
  return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// Call-by-Reference
func Scale(v *Vertex, f float64) {
  v.X = v.X * f
  v.Y = v.Y * f
}

func main() {
   v := Vertex{3, 4}
   Scale(&v, 10)
  fmt.Println(Abs(v))
}
```

### Objektorientierung

* nicht klassenbasiert, sondern `struct` und `interface` basiert
* Methoden sehen ganz ähnlich wie `func` aus - in folgendem Beispiel wird eine Funktion `Abs()` definiert und eine Methode `Scale(f float64)` auf dem `Vertex struct`:

    ```go
    type Vertex struct {
      X, Y float64
    }

    func (v Vertex) Abs() float64 {
      return math.Sqrt(v.X*v.X + v.Y*v.Y)
    }

    func (v *Vertex) Scale(f float64) {
      v.X = v.X * f
      v.Y = v.Y * f
    }

    func main() {
      v := Vertex{3, 4}
      v.Scale(10)
      fmt.Println(v.Abs())
    }
    ```

  * mit einem ganz wichtigen Unterschied:
    * [Tour Link](https://tour.golang.org/methods/6)
    * [Tour Link](https://tour.golang.org/methods/7)
  * "all methods on a given type should have either value or pointer receivers" ([Link](https://tour.golang.org/methods/8))
* Datentypen (`struct`) können Methoden besitzen, die aber implizit dem Typen zugeordnet sind ... es gibt im Gegensatz zu Java kein `implements`, das die Zuordnung explizit machen würde
* Polymorphie über Interfaces (`type Tier interface {}`) - zur Laufzeit an Implementierung gebunden (Dynamic Binding)
* keine Vererbung - stattdessen Komposition über Embedding (Form von Mixins)
* [hier eine ganz allgemeine Implementierung](https://tour.golang.org/methods/10):

```go
package main

import "fmt"

type I interface {
  M()
}

type T struct {
  S string
}

// T implementiert das Interface I,
// es erfolgt keine explizite Kennzeichnung
func (t T) M() {
  fmt.Println(t.S)
}

func main() {
  var i I = T{"Hallo Pierre"}
  i.M()
}
```

```Go
```

### Best Practices

* https://golang.org/doc/effective_go.html

---

## Visual Studio Code

Ich bin seit Monaten ein großer Fan [dieses Editors](visualStudioCode.md) und natürlich möchte ich ihn auch für Go-Code verwenden. Da ich noch keine Go-Extensions kenne verwende ich zunächst mal die offizielle Extension von Microsoft `ms-vscode.go`.

Nun habe ich schon mal

* Syntax-Highlightning
* Auto-Vervollständigung
* ordentliche Fehlermeldungen im Editorfenster (mit Hovering)
* im "Output"-Fenster detailierte Informationen über die im Hintergrund ausgeführten Aktionen (z. B. "Finished running tool: /home/pfh/programs/go/bin/go vet .")
  * sollte es fehlen ... den Output erhält man über "View - Output"

---

## FAQ

Frage 1: wie die compilierten Go-Binaries von Git excluden?

Antwort 1: beispielsweise folgendes in `.gitignore` eintragen:

```
# we ignore all files
**/*

# ... except ...
!**/*.go
!**/*.md
!.gitignore
```