# Password Manager

Heutzutage hat man hunderte von Accounts und sollte

* niemals die gleichen Passwörter verwenden
* komplexe/lange Passwörter verwenden
* sie regelmäßig wechseln

Zudem verlangen Passwort-Policies die Einhaltung bestimmter Regeln, so daß das eigene Passwort-Konzept evtl. nicht ausreichend sein könnte.

Das hat zur Konsequenz, daß man um einen Passwort-Store nicht mehr rumkommt.

---

## Selbst gebastelte Lösungen

Zwei Files nehmen, die sich referenzieren und schon hat man seinen eigenen Store gebastelt. ABER: das ist viel zu unsicher und zu unkomfortabel in der Nutzung. Es besteht eine große Gefahr, daß man bei der manuellen Pflege einen Fehler macht. Zudem können keine Passwörter erzeugt werden (auch hier gibt es externe Lösungen).

Kurz und büdig: unkomfortabel und unsicher

---

## Code-Meter Hardware Token

* [Website](https://www.wibu.com/de/produkte/codemeter/cmdongle.html)

Das war mein Einstieg in die "gemanagete" Passwort-Manager-Welt. Hat eine Zeitlang gut funktioniert, doch dann wurden die Software-Updates weniger und mit der Umsetllung der Browser Updates auf hoher Release-Ferquenzen was das alles nicht mehr so toll in der Nutzung. Zu häufig hatte ich auch Probleme bei der Erkennung des USB-Sticks.

Kurz und bündig: ich habe mich nicht mehr sicher gefühlt und die Gefahr Passwörter zu verlieren, weil die Software nicht mehr funktionierte oder der USB-Stick kaputt ist war mir zu gross.

---

## 1Password

Das war einer der ersten managed Software-Passwort-Manager, die ich genutzt habe. Sehr einfach in der Bedienung und integriert in die Webbrowser, so daß Passwörter generiert werden konnten, bei der Änderung per Website sofort geändert wurden und Passwörter natürlich automatisch beim Login auf eienr Website eingetragen wurden.

Perfekt aus meiner Sicht ... ja is sich der Hersteller überlegte daraus einen SaaS-Produkt zu machen, um meine Passwörter in der Cloud zu hosten. Das kam für mich gar nicht in Frage. Glücklicherweise kann ich meine alte Software noch verwenden, doch es ist nur eine Frage der Zeit, daß die verschlüsselung der Datei nicht mehr sicher genug ist.

---

## Bitwarden

Ein Tool, zu dem ich gar kein Vertrauen habe ... zu häufig habe ich es erlebt, daß Passwörter einfach verschwunden waren. Mein Eindruck ist, daß die Nutzung per App und Webbrowser-Plugin zu Schiefständen führt.

---

## Pass

* [Youtube](https://www.youtube.com/watch?v=hlRQTj1D9LA)

DER Unix Passwort Manager.

Hier werden die Passwörter in einer GPG verschlüsselten Datei gespeichert ... nicht anders als bei allen anderen Lösungen. ABER: hierbei handelt es sich um einen OFFENEN Standard - ich bin nicht auf den Support des Herstellers angewiesen, sondern kann Standardtools verwenden.

### Getting Started

Bei der Erzeugung eines GPG-Keys

```bash
gpg --full-generate-key
```

wird eine GPG-ID erzeugt ... die sieht ungefähr so aus: `0D2740AEE2781B3`. Hat man seine GPG-ID nicht aufgesschrieben, so kann man die Info aus dem GPG-Store per

```bash
gpg --list-secret-keys --keyid-format LONG
```

extrahieren.

Mit dieser GPG-ID kann der `pass` Store initialisiert werden:

```bash
pass init "0D2740AEE2781B3"
```

Damit erfolgt auch gleichzeitig die Verknüpfung zum GPG-Key, mit dem das erzeugte `pass`-Passwortfile verschlüsselt/entschlüsselt wird.

> Ein GPG-Key sollte eine Passphrase verwenden, um gegen Diebstahl des Passwortfiles abgesichert zu sein.

Über

```bash
pass insert facebook.com
```

kann man interaktiv ein Passwort hinterlegen, das als `~/.password-store/facebook.com.gpg` in einer eigenen Datei gespeichert wird. Übrigens kann man per `pass` alle angelegten Einträge sehen.

Das dechiffrierte Passwort erhält man per

```bash
pass facebook.com
```

> Man kann auch `gpg` CLI verwenden, um den Inhalt der verschlüsselten Datei lesen zu können `gpg -d ~/.password-store/facebook.com.gpg` ... die Verknüpfung zum GPG-Key (der im GPG-Store gehalten wird) erfolgt über `~/.password-store/.gpg-id`

Natürlich werden Folder auch unterstützt ... `pass insert social-media/twitter.com` ... durch die Ablage als einzelne Dateien wird die Reorganisation zum Kinderspiel ... komplett ohne UI

### Webbrowser Integration

Auch wenn `pass` zunächst mal nur ein Command-Line-Tool ist, so besitzt es über Extensions die Möglichkeit einer komfortablen Integration ins tägliche Arbeiten außerhalb des Terminal:

* Chrome Plugin
* Firefox Plugin

### dmenu Integration

Auf diese Weise kann man den Zugriff auf den Passwort-Store auch aus einer grafischen Oberfläche starten.

### Migration

`pass` bietet komfortable Migrationsmöglichkeiten, um Passwörter aus anderen Passwortmanagern (z. B. 1Password, Keypass) zu exportieren.
