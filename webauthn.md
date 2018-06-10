# Web-Authentication-API - WebAuthn

* [Homepage](https://www.w3.org/TR/webauthn/)
* [Wikipedia](https://en.wikipedia.org/wiki/WebAuthn)
* [fido alliance - Antriebsfeder von Webauthn](https://fidoalliance.org/)

Passwortlose Authentifizierung/Identitätsprüfung per Hardware:

* Fingerabdrucksensor (im Handy/Laptop)
* Gesichtserkennung (wie bei Windows Hello und iPhone X)
* Irisscan

Security-Keys auf Basis von [Universal Second Factor](https://de.wikipedia.org/wiki/U2F) gibt es schon lange (z. B. [U2F Security Keys (USB-Tokens)](https://www.yubico.com/solutions/fido-u2f/)), doch konnte die bisher nicht besonders gut in Web-Applikationen eingebunden werden, weil browser- und plattformübergreifende die Schnittstelle fehlte. Die Web-Authentication-API (eine Erweiterung der [Credential-Management-API](https://en.wikipedia.org/wiki/Credential_Management)) beseitigt dieses Problem - die neuesten Browser (Desktop/Mobile) unterstützen diesen Ansatz.

Zudem unterstützt Web-Authentication nicht nur USB-Hardware-Tokens (die eher anfällig sind, weil sie übertragbar sind - Verlust), sondern auch personalisierte Secret-Stores (z. B. durch Fingerprint geschützte Handys).

## Motivation

Einfache Credentials sind leicht zu knacken, weil

* oft zu einfach
  * 2-Factor-Authentication reduziert dieses Problem
* oft gleiche Credentials für verschiedene Services
  * 2-Factor-Authentication reduziert dieses Problem
  * Authentication-as-a-Service wie beispielsweise [OpenID Connect](openIdConnect.md) reduzieren dieses Problem

## Begriffe

### Fido (= Fast Identity Online)

Fido ist eine Allianz verschiedener Firmen, mit dem Ziel sichere Authentifzierung abzubilden.

### U2F

> Dieses Protokoll wurde urprünglich von Google und Yubico entwickelt und nach der erfolgreichen Einführung bei Google an die Fido Allianz übergeben.

Fido war mir bereits von ["U2F - Universal Second Factor"](https://de.wikipedia.org/wiki/U2F) bekannt und ich hatte bereits einen [YubiKey](http://www.yubico.com) als Second-Factor bei der VPN-Einwahl in ein Firmennetz verwendet.

Fido hat neben U2F auch UAF (User-Authentication-Framework) entwickelt, das noch einen Schritt weiter geht. Hierbei geht es um passwortlose Authentifizierung.

Im April 2018 hat Webauthn im W3C den Status "Candidate Recommendation" erlangt.

### UAF (Universal Authentication Framework)

UAF geht noch einen Schritt weiter als U2F ... hier werden nicht die Anzahl der Secrets (= Passwörter) erhöht, stattdessen erfolgt die AUthentifizierung passwortlos. Das Secret steckt im Client und verlässt diesen auch nicht (im Gegensatz zu Passwörtern oder ähnlichen Secrets. Hier kommen Public-Private-Key-Ansätze zum Einsatz.

### Webauthn

* macht den passwortlosen Login (UAF) nutzbar für Webapplikationen
* wird von der W3C standardisiert

### Fido 2.0 - Passwortless Authentication

* [Solution](https://www.yubico.com/solutions/fido2/)
* [Developer Informationen](https://developers.yubico.com/FIDO2/)

Fido 2.0 besteht aus

* Webauthn Spezifikation
* Client-to-Authentication-Protocol (CTAP) für die Schnittstelle zwischen Client (z. B. Browser) und Plattform (= Betriebssystem/Hardware)

Fido 2.0 Devices sind somit also Webauthn-Ready.

## Ansatz

* verwende Hardware-Authenticators zur Speicherung von Secrets (= Private-Key) und zur nachfolgenden Identifizierung einer vorgegebenen Identität (= Authentifizierung)
  * ACHTUNG: der Benutzer gibt eine Identität vor (z. B. einen Usernamen - es kann EIN Username für viele Services verwendet werden => der Benutzer kommt also eigentlich mit einem einzigen Usernamen aus). Per Web-Authentication wird die Identität verifiziert. Es ist also nicht so, daß ich mich mit dem Authenticator komplett automatisch anmelden kann - den Usernamen muß ich noch wissen!!!
* Zugriff auf die gespeicherten Secret auf der Hardware ist nur mit einem Super-Secret möglich
  * für das Super-Secret verwendet man am besten biometrische Informationen (z. B. Fingerabdruck), um die Übertragbarkeit zu verhindern
* ein Service, der die Identität eines Benutzers überprüfen will, geht folgendermaßen vor:
  * schick Challenge (Zufallszahl) zum Authenticator
  * Authenticator signiert die Challenge und schickt die Signatur zum Service
  * Service prüft die Signatur
    * die Signatur wird mit dem Public-Key dekodiert - wenn das Ergebnis mit dem Challenge-Wert übereinstimmt, ist die Identität verifiziert

## Unterstützte Authenticators Devices

> ACHTUNG: reine U2F-Devices (Second-Factor) reichen für Webauthn nicht aus - es muß hier expliziter Support für Fido 2.0/Webauthn bestehen.

* übertragbare Authenticators (i. a. mit einer PIN geschützt)
  * [Security-Key by Yubico für 20 Euro](https://www.yubico.com/product/security-key-by-yubico/)
    * kein Fingerabdruckleser - zur Authentifizierung drückt man einen Knopt auf dem USB-Stick
* personalisierte Authenticators - ein U2F-USB-Stick ist nicht personalisiert (jeder kann ihn verwenden, um sich zu identifizieren)
  * biometrische Verifikation
    * Fingerprint
      * viele Handys/Laptops bieten bereits Fingerabdrucksensoren und bieten somit Möglichkeiten ohne zusätzliche Hardware
      * USB-Keys mit Fingerprintsensoren
    * Iris-Scanner
  * Secret-based (PIN, Name des Lieblingshaustieres, ...)

## Unterstützte Browser

Browser müssen die Web-Authentication-API anbieten, um die passwortlose Authentifizierung über Webapplikationen zu ermöglichen:

* Mozilla Firefox 60
* Chrome 67
* Edge

> Apple ist scheinbar noch nicht im Boot (aber zumindest schon mal in der Evaluationsphase) - schade, denn die neuesten Geräte kommen all mit Touch ID oder sogar Face ID und bieten somit ideale Authenticators

## Deep Dive

* [sehr gute Einführung von Google I/O 2018](https://youtu.be/kGGMgEfSzMw?t=1013)
* basiert auf Public-Private-Key-Verschlüsselung

## Registrierung des Authenticator Devices

* jedes Authenticator Device muß sich einzeln bei JEDEM zu nutzenden Service registrieren
  * das ist ganz typisch und natürlich, daß man die Geräte als Authentifizierungsmechanismen registrieren muß (ähnlich wie auch 2-Factor-Devices wie YubiKeys)
* ein Authenticator Device (z. B. des Handy-Fingerabdrucksensor) wird für einen zu nutzenden Dienst (z. B. amazon.com) über ein Challenge-Response-Protokoll konfiguriert:
  * der Benutzer loggt sich einmalig bei Amazon über die herkömmliche Art (Username/Password) ein und triggert die Authenticator Device Registrierung
  * Amazon erzeugt daraufhin eine Challenge (sehr große Zufallszahl), persistiert sie zum User und schickt sie zusammen mit der UserInfo an die WebApp (Webapplikation/MobileApp)
  * die Challenge wird zur WebApp (Webapplikation/MobileApp) geschickt, die auf dem Desktop/Mobile Device des Benutzers läuft. Die WebApp verwendet die Web-Authentication-API Bibliothek (z. B. JavaScript), die den Zugang über den Browser zum Authenticator-Device bietet. Infolgedessen wird der Benutzer aufgefordert, das zu verwendende Secret (z. B. seinen Fingerabdruck, PIN) einzugeben. Hierbei werden - sofern das Authenticator Device über ein Display verfügt - Informationen zum freizuschaltenden Service angezeigt (Domainname, Username, ...).
  * sobald der Benutzer seine Zustimmung erteilt hat (durch Bereitstellung seines Secrets - z. B. Fingerabduck), erstellt der Authenticator ein Public-Private-Key-Paar, eine Credential ID und speichert diese Daten lokal zusammen mit dem Domainnamen des Services und der User Info zum Service
  * Public-Key, Credential ID und signierte Challenge wird von der WebAPp zum Service geschickt
  * der Service verifiziert die Signatur (mithilfe des mitgeschickten Public-Key), speichert die Credential-ID und den Public-Key und löscht die Challenge

### Identifizierung

> ACHTUNG: der Benutzer gibt eine Identität vor (es gibt aber scheinbar auch Username-less-Ansätze ... siehe unten in der Yubico-Demo), sie per Web-Authentication verifiziert werden kann. Es ist also nicht so, daß ich mich mit dem Authenticator komplett automatisch anmelden kann - den Usernamen muß ich noch wissen!!!

Will sich der Benutzer gegenüber Amazon identifizieren (um eine Bestellung abzugeben), so initiiert Amazon ein Challenge-Response-Protokoll:

* auf dem Amazon-Server wird eine Challenge (bestehend aus einer sehr großen Zufallszahl) für den potentiellen User erzeugt und persistiert
* die Challenge und die wird zur WebApp (Webapplikation/MobileApp) geschickt, die auf dem Desktop/Mobile Device des Benutzers läuft. Die WebApp verwendet die Web-Authentication-API Bibliothek (z. B. JavaScript), die den Zugang über den Browser zum Authenticator-Device bietet. Infolgedessen wird der Benutzer per Popup (o. ä.) aufgefordert, seine Identität zu bestätigen (z. B. per Fingerabdruck).
* nur mit dem richtigen Fingerabdruck wird der Private-Key für den Authenticator freigeschaltet, der eine Signatur zu Amazon schickt. Die Signatur wird dann mit dem registrierten Public-Key geprüft

## In Action

* [Demo auf Android Phone und Windows 10 per Windows Hello](https://fidoalliance.org/fido2/)

Im Juni 2018 wollte ich das mal in eine Web-Anwendung einbauen. Allerdings hatte ich hardwaretechnisch recht schlechte Voraussetzungen, da ich nur über Apple Geräte mit Fingerprintleser verfügte und Apple noch kein Webauthn unterstützt. Deshalb suchte ich nach einer Möglichkeit Google Chrome zu verwenden. Die schönste User Experience wäre eine Webapplikation auf einem mobilen Device gewesen, doch ich besaß auch kein Android-Gerät mit Fingerprintleser. Letztlich fand ich folgenden Lösungsansatz:

* Windows Laptop, so daß Windows Hello mit Fingerprintleser verwendet werden kann (Gesichtserkennung sollte dann ganz ähnlich funktionieren)
* Kensington VeriMark Fingerprint Key (mein Laptop hat keinen Fingerprint-Key), der als Authenticator in Windows registriert ist (Windows Hello)

Nach meinem Verständnis würde Windows in diesem Fall die Private-Keys verwalten und mit dem VeriMark schützen - [siehe hier](https://docs.microsoft.com/en-us/microsoft-edge/dev-guide/device/web-authentication).

### Yubico-Demo-Anwendung

* https://demo.yubico.com/webauthn/

Hier kann man seinen Authenticator registrieren und für den Login bei Yubico verwenden. Yubico bietet sogar die Möglichkeit zur username-less Authentifizierung, so daß man tatsächlich nicht mal mehr einen Usernamen wissen muß.

### java-webauthn-server

* https://developers.yubico.com/java-webauthn-server/

### ebay UAF Server - OpenSource

* https://github.com/eBay/UAF