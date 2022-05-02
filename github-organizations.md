# GitHub Organizations and Enterprise

Jeder kennt GitHub für seine privaten oder öffentlichen Repositories oder als Nutzer solcher Repositories.

Will man GitHub aber im Unternehmen oder in einem Open-Source-Projekt mit anderen kollaborieren, dann kommen viele neue Fragestellungen hinzu. Der wichtigste Aspekt in diesem Zusammenhang ist die Sicherheit, denn natürlich sollte man dem Least-Privileges-Principle folgen.

---

## Konzepte

### Github Oranization

Jeder Account kann in eine Organisation umgewandelt werden und das ist sogar kostenlos.

> Man sollte für jede Unternehmung (in dessen Kontext man mit anderen Personen als Member oder Outside-Collaborator zusammenarbeitet) einen separaten Accounts anlegen und diesen dann in eine Organisation umwandeln. Der Account selber unterliegt anschließend nämlich einigen Restriktionen. Den eigenen GitHub Account fügt man anschließend als Member (oder in der Admin Rolle als Owner) hinzu ... und natürlich seine Kollaborateure.

### GitHub Enterprise

Es gibt den sog. *GitHub Enterprise Server* und die *Github Enterprise Cloud* ... eine SaaS Lösung.

Der Begriff GitHub Enterprise wird neben den Software-Produkten allerdings auch bei den Billing Plans benutzt. Es bezeichnet hier ein sehr umfangreiches Feature-Set.

Zudem gibt es den sog. GitHub-Enterprise-Account, den man benötigt, um verschiedene GitHub-Organisationen zu managen und Enterprise-Managed-Users einzusetzen.

> Der Begriff *GitHub Enterprise* ist also ein wenig überstrapaziert, was hier und da zu Verwirrung führt.

### Usermanagement

Hier gibt es zwei disjunkte Ansätze, die nicht vermischt werden können:

* **Open-Source-Ansatz:** In diesem Fall verwenden die Member/Outside Collaborators Personal GitHub Accounts und werden zu einer Organisation/Enterprise eingeladen. Über SSO ist es sogar möglich den Personal Account mit einer Enterprise Identity zu linken, um so nur Usern den Zugriff auf Ressourcen der Organisation zu gewähren, die sich zusätzlich zum GitHub Account auch an einem Active Directory eines Unternehmens authentifiziert und damit identifiziert haben.
* **Closed-Source-Ansatz:** In diesem Fall erstellt/löscht das Active Directory des Unternehmens die GitHub-User-Accounts (sog. Enterprise-Managed-Users (EMU)) und bestimmt über deren Settings/Policies. Es sind User-Accounts, die im GitHub-Ecosystem nur eingeschränkt funktionieren. Man kann hier keine Public-Repos anlegen oder bei anderen GitHub-Organisationen mitarbeiten. Diese Accounts sind einzig und allein im Kontext des Unternehmens nutzbar (ok ... man kann auch Public Repos lesen). [Hier erfährt](https://docs.github.com/en/enterprise-cloud@latest/admin/identity-and-access-management/managing-iam-with-enterprise-managed-users/about-enterprise-managed-users#abilities-and-restrictions-of-managed-users) man mehr über die Limitierungen.
  * für diesen Ansatz benötigt man einen speziellen GitHub Enterprise Account, bei dem dann das EMU Feature aktiviert ist
  * [Konfigurieren von GitHub Enterprise Managed User](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/active-directory/saas-apps/github-enterprise-managed-user-tutorial.md)

Aus meiner Sicht ist der Closed-Source-Ansatz sehr sicher für Unternehmen, um ihre Assets (Source-Code) zu schützen und dennoch auf einer der besten Plattformen unterwegs zu sein. Allerdings kann man sich dann schon fragen warum man nicht GitLab verwendet, das im Unternehmensbereich zusätzlich Features im Bereich Sicherheit mitbringt.

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
