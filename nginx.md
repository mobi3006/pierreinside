# NGINX

Dieser sehr schlanke Webserver wird nicht nur gern als solcher eingesetzt, sondern auch als

* Http-Proxy
  * Public Frontchannel-Proxy: nginx ist der einzige Service, der für einen Nutzer nach außen sichtbar ist. Er routet die Http-Requests in das Backend
    * nginx hat als einziger Server ein offizielles Server-Zertifikat
    * in diesem Zuge erfolgt im nginx dann die SSL-Terminierung, z. B. werden Client-Zertifikate aus dem HTTPS-Protokoll in den weitergeschickten HTTP-Header gepackt

## Name-based virtual Servers

In einer nginx Konfiguration (`app.conf`) können mehrere (virtuelle) Server definiert werden. Durch Bindung an verschiedene Domainnamen (über die `host` Variable im Request-Header - müssen alle an den gleichen Rechner geroutet werden) oder Ports können für verschiedene URLs separate "Web-Applikationen"/Delegationsregeln definiert werden.

## Request-Prozessierung

* [How nginx processes requests](http://nginx.org/en/docs/http/request_processing.html)

