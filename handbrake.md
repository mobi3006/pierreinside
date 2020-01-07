# Handbrake - Videokonvertierung

Videocodecs sind der graus ... will man Videos plattformübergreifend (Windows, Apple, Linux, Android, iOS, ...), deviceunabhängig (Laptop, Handy, Fire TV, ...) und altersunabhängig nutzen, dann ist der Ärger vorprogrammiert und häufig kommt man um eine explizite Konvertierung nicht herum.

Handbrake läßt sich gut dafür benutzen, um den Codec einer Datei rauszufinden - hierzu einfach importieren und das _Activity Log_ ansehen.

---

## Batchkonvertierung

Handbrake unterstützt eine Batchkonvertierung - allerdings muß/sollte man hierzu unter _Einstellungen - Output Files_ folgendes konfigurieren:

* Automatic File Naming
  * Default Path
  * File Format
    * ich nutze i. a. nur `{source}`, da ich den Namen der Original-Datei beibehalten will (und nicht noch `{title}`)
  * MP4 File Extension: `Always use MP4`

Mit diesen Einstellungen wird eine HEVC-encoded Datei `191231_171104.MOV` in eine Datei mit dem Namen `191231_171104.mp4` konvertiert.
