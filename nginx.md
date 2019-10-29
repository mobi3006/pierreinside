# NGINX

Dieser sehr schlanke Webserver wird nicht nur gern als solcher eingesetzt, sondern auch als

* Http-Proxy
  * Public Frontchannel-Proxy: nginx ist der einzige Service, der für einen Nutzer nach außen sichtbar ist. Er routet die Http-Requests in das Backend
    * nginx hat als einziger Server ein offizielles Server-Zertifikat
    * in diesem Zuge erfolgt im nginx dann die SSL-Terminierung, z. B. werden Client-Zertifikate aus dem HTTPS-Protokoll in den weitergeschickten HTTP-Header gepackt

---

## Name-based virtual Servers

In einer nginx Konfiguration (`app.conf`) können mehrere (virtuelle) Server (`server/server_name`) definiert werden. Wenn unterschiedliche DNS-Namen (z. B. `intern.cachaca.de` + `extern.cachaca.de`) auf die gleiche IP-Adresse geroutet wird, dann können entsprechende virtuelle Server-konfigurationen für diese beiden Namen existieren, so daß Requests in Abhängigkeit der verwendeten URL unterschiedlich behandelt/weiterverarbeitet werden.

---

## Request-Prozessierung

* [How nginx processes requests](http://nginx.org/en/docs/http/request_processing.html)
* [Location Section](https://www.digitalocean.com/community/tutorials/understanding-nginx-server-and-location-block-selection-algorithms)

### URL rewriting

* [Beispiel](https://superuser.com/questions/435916/nginx-rewrite-rule-to-remove-path-node)

Eine URL kann per `rewrite` umgeschrieben werden, um Pfade zu ergänzen bzw. rauszuschneiden. Auf diese Weise lassen sich die URLs, die der Nutzer verwendet, von der Verzeichnisstruktur komplett entkoppeln.

### `root` vs. `alias`

* [NGINX Doku - alias](http://nginx.org/en/docs/http/ngx_http_core_module.html#alias)
* [techcoil.com](https://www.techcoil.com/blog/understanding-the-difference-between-the-root-and-alias-directives-in-nginx/)

> "The root directive and alias directives are both used to indicate where in the filesystem to serve resources from, the difference being that when using root, the entire URI is still appended to the root; whereas when using alias, the location part is dropped." ([StackOverflow](https://serverfault.com/questions/748634/how-to-alias-directories-in-nginx))