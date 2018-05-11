# Web Fonts

> ACHTUNG: bei der Verwendung von Webfonts Lizenzen beachten!!!

* Freie Webfonts
  * https://www.fontsquirrel.com/
  * [Google Hosted Web Fonts](https://fonts.google.com/)
    * hier übernimmt Google die Bereitstellung der Fonts - diese müssen nicht in der Applikation bereitgestellt werden

## Motivation

Eine Web-Applikation (Web-Seite) lebt natürlich auch vom Layout - hierzu gehören u. a. Schrift und Icons. Der Browser verwendet i. a. die vom System angebotenen Schriftarten ... bei heutiger Platform-Vielfalt (Windows, MacOS, Linux, ...) kann hat man dann entweder nur sehr wenige Schriftwarten zur Verfügung bzw. ein Layout, das auf der ein oder anderen Platform nicht mehr ordentlich aussieht.

Webfonts sollen das Problem lösen. Sie werden über CSS Files eingebunden

```html
<link rel="stylesheet" type="text/css" href="/webjars/font-awesome/4.7.0/css/font-awesome.min.css">
```

Icons werden auch über Webfonts angeboten und hier hat man i. a. keine systemseitige Unterstützung.

## Nachteile

Die Ladezeit erhöht sich - zumindest beim ersten Aufruf (danach wird CSS i. a. gecached) ... insbesondere im mobilen Umfeld könnte das problematisch sein.