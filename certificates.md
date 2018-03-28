# X.509 Zertifikate

---

## Formate

Zertifikates bzw. ihre Teile (Public-Key, Private-Key) können in folgenden Formaten gespeichert werden:

* PEM: Base64-encoded 
* DER: binäres Format
* PKCS12: binäres Format
  * enthält i. d. R. Public- UND Private-Key (**VORSICHT!!!**)
 
```
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