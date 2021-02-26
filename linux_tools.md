# Linux Tools

---

## ssh agent

[siehe hier](ssh.md)

---

## netcat

Mit `nc` lassen sich Nachrichten über UDP üder TCP verschicken, um so beispielsweise Kommunikationsstrecken zu prüfen (gestartete Services, offene Ports, offene Firewall, ...):

```bash
echo -e '{"host":"myserver.example.com","message":"hello Graylog"}' \
   | nc -u myserver.example.com 514
```

In diesem Beispiel wird eine JSSOn Nachricht über UDP verschickt, um die Funktionsfähigkeit des Graylog-Servers (unter `myserver.example.com`) zu prüfen.

