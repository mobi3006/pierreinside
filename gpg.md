# GPG - GNU Privacy Guard

## Getting Started

* Key-Pair erzeugen und im GPG store speichern: `gpg --full-generate-key`
* aktuelle public GPG keys anzeigen: `gpg --list-keys`
  * exportieren: `gpg --output foo-bar.pub --armor --export foo-bar@example.com`
    * beispielsweise zur Weitergabe
* aktuelle private GPG keys anzeigen: `gpg --list-secret-keys`
  * [exportieren](https://makandracards.com/makandra-orga/37763-gpg-extract-private-key-and-import-on-different-machine): `gpg --export-secret-keys foo-bar@example.com > foo-bar.priv`
    * beispielsweise zur Speicherung in einem Passwort Manager

---

## Einsatzbereiche

### eMail-Verschlüsselung

### Passwort-Manager pass

[siehe eigener Abschnitt](password-manager.md)
