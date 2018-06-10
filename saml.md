# SAML

SAML basiert - ähnlich wie [OAuth](oauth.md) bzw. [OpenIDConnect](openIdConnect.md) - auf der Idee eines zentralen Identity Providers (IDP), das die Authentifizierung und/oder Autorisierung im Stile eines Authentication-as-a-Service vornimmt und eine Sicherheitsbürgschaft in Form eines signierten SAML-Assertion ausstellt, die an Anwendungen weitergereicht wird. Auf diese Weise genügt dem User ein einziger Account, um sich an vielen Anwendungen "anmelden" zu können (die Anmeldung erfolgt allerdings gegen den IDP, der )

> Bei [OpenIDConnect](openIdConnect.md) tritt der ID Token an die Stelle des SAML-Tokens.

Die SAML Assertion enthält auch den Public-Key des Identity Providers, doch muß sich dieser auch im Truststore des Clients befinden.

## SAML vs. OpenID Connect

Im Gegensatz zu OpenID Connect geht SAML verstärkt auf den Autorisierungsaspekt ein. Über ACLs (Access Control List) sind grob- und/oder feingranulare Berechtigungen abbildbar.