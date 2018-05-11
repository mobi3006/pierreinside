# Authentifizierung

* https://docs.oracle.com/javaee/7/tutorial/security-webtier002.htm
* https://dzone.com/articles/my-security-notes

Verschiedene Authentifizierungsmechanismen:

* Basic-Authentication
  * Username + Base64 enkodiertes Passwort
  * bei Web-Applikationen werden die Credentials über ein Popup eingegeben (Nachteil: Layout kann nicht customized werden ... wirkt vielleicht nicht besonders vertrauenerweckend) - im Gegensatz zu Form-Based-Authentication
* Form-Based-Authentication
  * Username + plain-text Passwort
  * die Credentials werden beispielsweise über eine HTML-Form (Layout kann customized werden) mit einem HTTP-POST versendet
* Digest-Authentication
  * Username + Digest (als Ersatz für das Passwort)
* Certificate-Based-Authentication
* [OpenID Connect - Authentication-as-a-Service](oauth.md)

---

## Basic Authentication

* Client schickt auf Verlangen des Servers die Credentials
* Authentifizierung erfolgt auf Applikationsebene und nicht auf TCP-Ebene wie bei Certificate-Based-Authentication
* Basic Authentication ist Teil der Servlet/Spezifikation und wird dementsprechend in der `web.xml` definiert:

```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>all-content</web-resource-name>
        <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
        <role-name>user</role-name>
    </auth-constraint>
</security-constraint>

<login-config>
    <auth-method>BASIC</auth-method>
    <realm-name>foo-realm</realm-name>
</login-config>
```

### URL

`https://Aladdin:OpenSesame@www.example.com/index.html`