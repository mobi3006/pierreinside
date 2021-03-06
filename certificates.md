# X.509 Zertifikate

---

## Formate

Zertifikates bzw. ihre Teile (Public-Key, Private-Key) können in folgenden Formaten gespeichert werden:

* PEM: Base64-encoded
* DER: binäres Format
* PKCS12: binäres Format
  * enthält i. d. R. Public- UND Private-Key (**VORSICHT!!!**)
 
```bash
35 pfh@workbench % cat client.key
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: DES-EDE3-CBC,2CC81378DD72C6F0

mgEvO33htovS4y09w8ggYFl+8PmJ89nx6/+O+mxjUgKbRc43yi7X4GOO6QIa0Ved
LQjuOjmJ7YFPvG3Kn+77VtsP07OHQYbPtYzzvNSZtNKraHvrv7QlOm26aExeE6dD
```

---

## OpenSSL

Um mit Zertifikaten rumzuspielen bietet sich das Docker-Image von [NGINX](https://hub.docker.com/_/nginx/) an, denn dort sind alle OpenSSL Tools vorhanden ... und so auch für Windows-Nutzer verfügbar.

### Befehle

* ``openssl x509 -in cert.pem -text -noout``
  * PEM-encoded Datei anschauen
* ``openssl x509 -in certificate.der -inform der -text -noout``
  * DER-encoded Datei anschauen
* ``openssl x509 -in cert.crt -outform der -out cert.der``
  * von PEM nach DER konvertieren
* ``openssl x509 -in cert.crt -inform der -outform pem -out cert.pem``
  * von DER nach PEM konvertieren
* ``openssl pkcs12 -export -in my.cert.pem -inkey my.key.pem -out my.p12`` 
  * PKCS12 Artefakt erstellen
* ``openssl pkcs12 -in my.p12 -out my.combo.pem``
  * PKCS12 nach PEM
* ``openssl rsa -check -in client.key.pem``
  * Passpphrase prüfen
* ``openssl rsa -des3 -in keyfilename -out newkeyfilename``
  * Passphrase ändern
* ``openssl s_client -connect localhost:443 -prexit``
  * Handshake/Debugging der SSL Verbidnung anschauen

### Aufbau einer eigenen CA

* [Getting Started](https://www.phildev.net/ssl/opensslconf.html)
* [OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/online/ch-openssl.html)
* [OpenSSL Template Beispiel](https://github.com/openssl/openssl/blob/master/apps/openssl.cnf)

Mit `openssl` lassen sich leicht mit Zertifikate oder CSRs (Certificate Sign Requests) anlegen. Will man das ein wenig automatisieren, so bietet es sich an eine gemeinsame Konfigurationsdatei [`ca.conf` nach diesem Schema](https://github.com/openssl/openssl/blob/master/apps/openssl.cnf) anzulegen (Linux Systeme mit installierten `openssl` bieten eine Default-Konfiguration unter `/etc/ssl/openssl.cnf`) und bei den Requests zu referenzieren:

```bash
openssl req \
        -new \
        -out my.csr \
        -key my.key \
        -config ca.conf             # <======== Referenzierung
```

Die Syntax dieser INI-type-Datei ist nicht besonders intuitiv, da manche Values (in dieser Key/Value-Datei) Sections referenzieren, ohne daß das ersichtlich ist:

```ini
[ ca ]
default_ca = CA_default

[ CA_default ]
dir = /root/ca
```

Außerdem kann man beim `openssl ca -extensions server_cert`-Kommando, direkt eine Sektion explizit referenzieren

```ini
[ server_cert ]
# Extensions for server certificates (`man x509v3_config`).
basicConstraints = CA:FALSE
nsCertType = server
nsComment = "OpenSSL Generated Server Certificate"
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer:always
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
```

oder das ist implizit gemacht - diese Sektion wird automatisch bei einem `openssl req -x509` verwendet:

```ini
[ req ]
# Extension to add when the -x509 option is used.
x509_extensions     = v3_ca

[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
```

> Dieses implizite Resolving ist nicht besonders intuitiv - bessert sich aber, wenn man für die verschiedenen Sub-Kommandos (`ca`, `req`, ...) unterschiedliche Template Dateien verwendet, die man mit `-config file` explizit referenziert.

Deshalb empfehle die Lektüre "Getting Started" (siehe oben).

---

## Java Keytool

Keytool ist ein Java-Tool, das die im Java-Umfeld üblichen binären JKS-Zertifikatsspeicher (**J**ava**K**ey**S**tore) lesen und schreiben kann.

Leider kann das Keytool von Oracle keine Zertifikate in das OpenSSL-Format exportieren. Das ist dann erelvant, wenn man beispielsweise Zertifikate aus einem Tomcat-Truststore (basiert auf JKS) in einen Apache Http Truststore (basiert auf PEM-codierten Zertifikatsspeicher) importieren möchte. Hierzu googled man am besten mal ... ich hatte da mal ein Java-Programm gefunden (... vielleicht hier: http://www.herongyang.com/crypto/Migrating_Keys_keytool_to_OpenSSL_3.html).

### Befehle

* https://www.sslshopper.com/article-most-common-java-keytool-keystore-commands.html

* ``keytool -list -keystore ./cacerts.jks -storepass changeit -v``
* ``keytool -import -trustcacerts -alias TestCA -file ca.pem -keystore cacerts.jks``
  * trusted einer weiteren CA

## Java Keystore/Truststores

* https://docs.oracle.com/javase/7/docs/technotes/guides/security/jsse/ReadDebug.html

Die Standard JDK Bibliotheken für den Aufbau von HTTP-Verbindungen berücksichtigen die typischen System-Properties zur Konfiguration von Keystore und Truststore:

* `javax.net.ssl.keyStore`
* `javax.net.ssl.keyStorePassword`
* `javax.net.ssl.trustStore`
* `javax.net.ssl.trustStorePassword`
* `javax.net.ssl.trustStoreType`
* `javax.net.debug`

### OpenJDK Besonderheit

Open JDK verwendet standardmäßig die Truststore-Konfiguration des Betriebssystems. Das vereinfach die Konfiguration für manche Szenarien. Durch

```bash
cp my-truststore.crt /usr/local/share/ca-certificates/
update-ca-certificates
```

wird der angegebene Truststore in die gesamte Java-Kommunikation eingebunden. In Docker-Umgebungen ist das sehr praktisch, da man so auf die explizite anwendungsspezifische Konfiguration über `javax.net.ssl.truststore` verzichten kann.

---

## Portecle

Mit diesem GUI Tool lassen sich viele Operationen auf und mit Zertifikaten durchführen, für die man ansonsten die etwas kryptischen CLI-Tools wie ``openssl``, ``keytool`` verwenden müßte. Letzteres ist sicherlich fürs Scripting praktischer, erfordert aber stundenlages Man-page lesen. 

---

## XCA

* https://sourceforge.net/projects/xca/

GUI-Tool zum Aufbau einer eigenen CA.

---

## Debugging SSL-Verbindungen

Mit ``openssl s_client`` (siehe oben, z. B. `openssl s_client -connect localhost:58443 -debug`) kann man sich den SSL-Handshake ansehen.

Zudem kann man die Verarbeitung (inkl. SSL-Handshake) bei einem `curl -vvv` sehr schön beobachten.
