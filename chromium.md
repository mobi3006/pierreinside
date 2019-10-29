# Chromium Browser

ACHTUNG: Google Chrome und Chromium sind beides Browser aber nicht ein und dasselbe - der augenscheinlich auffälligste Unterschied ist das Logo, das entweder bunt (Google Chrome) oder blau (Chromium) ist!!!

---

## Konzepte

### User-Data-Directory vs. User vs. Profile

Ein User-Data-Directory (Standardmäßig in `/.config/chromium`) kann mehrere Profile enthalten. Das Standardprofil ist `Default` und befindet sich dann im Ordner `/.config/chromium/Default`. Ein Proifl umfasst die Historie, Extensions, Passwörter, UI-Konfiguration. Profil und User sind synonym - legt man ein neues Profil an, so wird ein neuer User angelegt.

> Über die URL `chrome://version/` kann man sich diese Informationen anzeigen lassen. Achtung: Bei Google Chrome liegt das User-Data-Verzeichnis in `~/.config/google-chrome`

Um Chromium mit einem expliziten Profil zu starten, verwendet man

```bash
chromium --profile-directory=monitoring
```

In diesem Fall wird das Profil in `/.config/chromium/monitoring` verwendet bzw. angelegt.

> ACHTUNG: beim nächsten Start wird das vorhergehende Profil zum Default-Profil, d. h. am besten startet man immer mit einem expliziten Profil.
