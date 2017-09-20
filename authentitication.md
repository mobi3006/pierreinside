# Authentifizierung
* https://docs.oracle.com/javaee/7/tutorial/security-webtier002.htm

Verschiedene Authentifizierungsmechanismen:
* Basic-Authentication
  * Username + Base64 enkodiertes Passwort
* Form-Based-Authentication
  * Username + plain-text Passwort
* Digest-Authentication
  * Username + Digest (als Ersatz für das Passwort)
* Certificate-Based-Authentication

---

# Basic Authentication
* Client schickt auf Verlangen des Servers die Credentials
* Authentifizierung erfolgt auf Applikationsebene und nicht auf TCP-Ebene wie bei Certificate-Based-Authentication
* Basic Authentication ist Teil der Servlet/Spezifikation und wird dementsprechend in der `web.xml` definiert:

```
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

## URL
`https://Aladdin:OpenSesame@www.example.com/index.html`
