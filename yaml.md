# YAML
* http://docs.ansible.com/ansible/YAMLSyntax.html

## YAML vs. Property-File
Das YAML-Format hat durch die hierarchische Struktur insbes. bei komplexen Beschreibungen (z. [Ansible-Playbooks](ansible.md) oder [Spring-Boot-Konfigurationen](springBoot.md)) deutliche Vorteile hinsichtlich Übersichtlichkeit und Verständlichkeit gegenüber Property-Files.

Property-File:

    mail.sender.host=localhost
    ... beliebig viele weitere ANDERE properties ...
    mail.sender.port=4711

YAML-Format:

```yaml
mail:
  sender:
    host: localhost
    port: 4711
```

## Start YAML-Dokument
Ein YAML-Dokument startet mit

    ---

## Property
Ein einfaches Property wird als ``Key: Value`` geschrieben:

    employee: Pierre

oder komplexe (hier ein sog. Dictionary)

    lineinfile: 
      dest: /tmp/playbook.run.log 
      create: yes 
      state: present 
      line: pierre

, die aber auch in einer Zeile geschrieben werden können (dann aber ``=`` statt ``:``):

    lineinfile: dest=/tmp/playbook.run.log, create=yes, state=present, line='pierre'

Mir gefällt die Mehrzeilenversion besser.

### Liste
Ein Property kann eine Liste abbilden, wobei alle Elemente einer Liste haben ein ``-`` davor:

    kids:
      - Robin
      - Jonas
      - Nora

Eine alternative Schreibweise:

    kids: [ 'Robin', 'Jonas', 'Nora' ]
    
oder auch 

    kids: { 'Robin', 'Jonas', 'Nora' }


## Dictionary
Ein Dictionary ist eine Liste von Properties - es ähnelt einem Record in bestimmten Programmiersprachen. ``pierre`` ist in folgendem Beispiel ein Dictionary:

```yaml
pierre:
  name: Pierre Feld
  job: developer
```

Statt dieser hierarchischen Darstellung kann auch folgende verwendet werden:

    pierre: { name: Pierre Feld, job: developer }

## Komplexeres Beispiel
In diesem Beispiel sind ... enthalten
* einfache Properties: ``name``
* Listen von Dictionaries: ``pierre`` + ``robin``
* Listen: ``skills``

```yaml
- pierre:
  - name: Pierre Feld
  - job: developer
  - skills:
    - java
    - databases
    - git
- robin
  - name: Robin Feld
  - job: schoolboy
  - skills:
    - soccer
    - statistics
    - Clash of Clans
```

## MISC
### Zeilenumbrüche
Mit einem ``|`` oder ``>`` kann eine lange Zeile umgebrochen werden.

### Verwendung von Metazeichen
Die Zeichen ``:``, ``-`` ... sind Sonderzeichen der YAML-Syntax und müssen dementsprechend gequoted werden. Das kann beispielsweise über äußere ``"`` erfolgen

    foo: "this is a colon : for you"
    
, weil folgendes zu einem Syntaxfehler führt:

    foo: this is a colon : for you

