# Http

---

# Authentication
Es gibt verschiedenen Formen der Authentifizierung innerhalb des HTTp-Protokolls:

* [Basic Access Authentication](https://en.wikipedia.org/wiki/Basic_access_authentication)
* [Digest Access Authentication](https://en.wikipedia.org/wiki/Digest_access_authentication)
* [Form-Based Authentication](https://en.wikipedia.org/wiki/Form-based_authentication)

## Basic Access Authentication
* https://en.wikipedia.org/wiki/Basic_access_authentication
* https://en.wikipedia.org/wiki/Basic_access_authentication#Client_side

In diesem Fall wird der HTTP-Header ``Authorization`` verwendet, um *username* und *password* [Base64-encoded](https://en.wikipedia.org/wiki/Base64) zum Server zu schicken:

    Authorization: Basic bXl1c2VybmFtZTpQYXNzMTIzNA
    
Statt den ``Authorization``-Header manuell in den HTTP-Request zu packen, kann man die Credentials auch in die URL packen:

    https://myusername:Pass1234@www.cachaca.de/index.html

... das hat den Vorteil, daß der Request bookmarkable ist.

## Digest Access Authentication
* https://en.wikipedia.org/wiki/Digest_access_authentication



## Form-Based Authentication
* https://en.wikipedia.org/wiki/Form-based_authentication

In diesem Fall packt man die Credentials in ein HTML-Form:

    <form method="post" action="/login">
      <input type="text" name="username" required>
      <input type="password" name="password" required>
      <input type="submit" value="Login">
    </form>

---

# Tooling
## UI
### Postman
* https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop

