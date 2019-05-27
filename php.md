# PHP

PHP ist eine Template-Engine, die beispielsweise zur Generierung von HTML-Seiten verwendet wird.

---

## Installation Linux

Per

```bash
sudo apt-get update && sudo apt-get install php
```

> Dadruch wird auch Apache Http Server installiert und beim Systemstart automatisch gestartet.

Anschließend eine Datei `/var/www/html/phpinfo.php` mit folgendem Inhalt anlegen:

```php
<?php
   phpinfo();
?>
```

und im Browser http://localhost/phpinfo.php aufrufen.