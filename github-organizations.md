# GitHub Organizations and Enterprise

Jeder kennt GitHub für seine privaten oder öffentlichen Repositories oder als Nutzer solcher Repositories.

Will man GitHub aber im Unternehmen nutzen, dann kommen viele neue Fragestellungen hinzu.

---

## Konzepte

### Github Oranization

Eine Organisation

### Externe Collaborators



---

## Betrieb einer GitHub Organisation

Die UI kann jeder nutzen, um User, Rollen, Permissions, ... zu managen. Das hat allerdings den großen Nachteil, daß Änderungen dann oftmals keinem 4-Augen-Prinzip (mit Abstimmungen und Reviews) unterworfen sind, Änderungen nicht nachvollziehbar sind und Dinge kaputtkonfiguriert werden.

[Terraform supported GitHub](https://registry.terraform.io/providers/integrations/github/latest). Auf diese Weise kann man Änderungen durch Code beschreiben und alle Änderungen wie bei Code üblich einem Review Prozess unterwerfen. Insbesondere bei kritischen Änderungen (Permissions) kann dieses Vorgehen sehr empfehlenswert sein und von manchen Auditoren (hinsichtlich Nachvollziehbarkeit) gefordert werden.

