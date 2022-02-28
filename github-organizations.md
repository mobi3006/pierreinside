# GitHub Organizations and Enterprise

Jeder kennt GitHub für seine privaten oder öffentlichen Repositories oder als Nutzer solcher Repositories.

Will man GitHub aber im Unternehmen oder in einem Open-Source-Projekt mit anderen kollaborieren, dann kommen viele neue Fragestellungen hinzu. Der wichtigste Aspekt in diesem Zusammenhang ist die Sicherheit, denn natürlich sollte man dem Least-Privileges-Principle folgen.

---

## Konzepte

### Github Oranization

Jeder Account kann in eine Organisation umgewandelt werden und das ist sogar kostenlos. Einzelne Features oder Quotas benütigen dann allerdings häufig höherwertige Billing Plans.

Aus meiner Erfahrung würde ich empfehlen, für jedes Projekt eine separate Organisation anzulegen.

**ACHTUNG:** Ein Account, der Member anderer Organisationen ist, kann nicht in eine Organisation umgewandelt werden. Insofern bietet es sich vielleicht an, verschiedene Account je nach Nutzungskontext zu verwenden. Ist man mit einem Account nur Outside Collaborator, dann kann man den Account in eine Organisation umwandeln.

### GitHub Members

Man muß zwischen Members und Outside Collaborators unterscheiden. Members haben mehr Rechte und sind der Standard-Use-Case. Sie können beispielsweise in Teams organisiert werden, um die Permission-Verwaltung zu vereinfachen ... diese Option steht bei Outside Collaborators nicht zur Verfügung. Das ist nur ein Beispiel.

Owner sind besondere Member ... sie agieren als Admin-User und können in einer Organisation alles tun. Will man sich die Verwaltung des Accounts teilen, dann kann man Billing Managers, GitHub-App-Managers, ... definieren, die dann in einem bestimmten Scope Admin-Berechtigungen haben ... aber nicht global.

### Outside Collaborators

Dieser Ansatz bietet sich an, wenn man mit externen Partnern zusammenarbeiten möchte, die keine Member-Berechtigungen erhalten sollen. Die Default-Permission bei Members ist beispielsweise "Read-Only" auf ALLE Repositories. Das möchte man solchen Partnern i. d. R. nicht erlauben. Deshalb muß man bei Outside Collaborators die Permissions auf JEDEM Repository definieren ... der Default ist somit "Keine Berechtigung".

---

## Betrieb einer GitHub Organisation

Die UI kann jeder nutzen, um User, Rollen, Permissions, ... zu managen. Das hat allerdings den großen Nachteil, daß Änderungen dann oftmals keinem 4-Augen-Prinzip (mit Abstimmungen und Reviews) unterworfen sind, Änderungen nicht nachvollziehbar sind und Dinge kaputtkonfiguriert werden.

[Terraform supported GitHub](https://registry.terraform.io/providers/integrations/github/latest). Auf diese Weise kann man Änderungen durch Code beschreiben und alle Änderungen wie bei Code üblich einem Review Prozess unterwerfen. Insbesondere bei kritischen Änderungen (Permissions) kann dieses Vorgehen sehr empfehlenswert sein und von manchen Auditoren (hinsichtlich Nachvollziehbarkeit) gefordert werden.

In GitHub kann man Repositories nicht gruppieren (im Gegensatz zu BitBucket beispielsweise), um beispielsweise auf einer Gruppe bestimmte Berechtigungen/Policies/... zu definieren. Deshalb ist es aufwendig und fehleranfällig, die Konsistenz der Konfiguration zu garantieren, wenn man keine Automatisierung wie Terraform verwendet. Letztlich ist der Source-Code eine äußerst kritische Komponente, die **IMMER** schützenswert ist. Deshalb sollte man hier auf professionelle Verwaltung setzen, d. h. Automatisierung, 4-Augen-Prinzip, Approvals, ... Im besten Fall gibt es sogar Tests, um zumindest die Sicherheitseinstellungen kontinuierlich - nach jeder Änderung - zu testen. Schnell sind wichtige Workflows gebrochen und dies fällt er
