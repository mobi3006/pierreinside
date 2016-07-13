# Linux Initialisierung
# BIOS
Im BIOS sind Informationen über die eingebauten Laufwerke hinterlegt. Die wichtigste Information ist an welchem Interface das Boot-Laufwerk mit der primären Partition hängt, denn von dort wird der Master-Boot-Record gelesen, um die weitere Systeminitialisierung zu triggern.

---

# Master-Boot-Record: Bootloader
* https://de.wikipedia.org/wiki/Master_Boot_Record

> Auf einem Speichermedium können mehrere Betriebssysteme parallel liegen.

Ein Laufwerk (z. B. Festplatte) hat auf den ersten 512 Bytes den sog. Master-Boot-Record. Dort legt man i. a.  den sog. Bootloader ab, der die weitere Systeminitialisierung triggert. Jede Partition (= Volume) kann dann weitere Boot Records haben. Der Bootloader verweist auf diese Boot Records, die jeweils für das Starten eines Betriebssystems zuständig sind.

Der Master-Boot-Record der primären Partition des Boot-Laufwerks entscheidet - evtl. durch Interaktion des Benutzers - welches Betriebsssystem gestartet wird.

## GRUB Bootloader
Bei Linux-System wird häufig der [GRUB](https://de.wikipedia.org/wiki/Grand_Unified_Bootloader) Bootloader verwendet, der vor einiger Zeit [LILO](https://de.wikipedia.org/wiki/Linux_Loader) abgelöst hat.

Der GRUB-Bootloader ist - im Gegensatz zum LILO - in der Lage, das Filesystem des Laufwerks zu lesen und so den Kernel zu lesen, der für die weitere Initialisierung zuständig ist.

---

# Linux Kernel
Linux ist der Name des Kernels ... der Kernel bildet den Kern des Betriebssystems.

---
# Linux Services
## systemd
* https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units

Viele Linux-Distributionen sind vom ``SysV``-Initialisierungsprozess auf ``systemd`` umgestiegen (z. B. Ubuntu, Fedora, Suse). Ubuntu hatte zwischendurch ``Upstart`` verwendet.

### Targets
Aus den Runleveln (SysV) wurden die sog. Targets (z. B. ``multi-user.target``). Darüber werden Units gruppiert, um zu enthscheiden welche Services in welchen Situationen gestartet werden.

Jedes System hat ein Default-Target

```bash
systemctl get-default
```

Die vorhandenen Targets werden über

```bash
systemctl list-unit-files --type=target
```

angezeigt.

### Units
Als Units bezeichnet man die Dinge, die von systemd gemanaged werden. Hierzu gehören folgende Kategorien

* Daemon-Prozesse
* Services
* Mounts
* Sockets
* Devices
* ...

Eine Übersicht über die Units erhält man per

```bash
sudo systemctl list-units --all
```

oder

```bash
sudo systemctl list-unit-files
```

### Unit: Service
systemd erwartet für jeden Service eine Konfigurationsdatei, die folgendermaßen aussehen kann (wird per ``systemctl cat myapp.service`` angezeigt):

    [vagrant@management system]$ systemctl cat sshd.service
    # /usr/lib/systemd/system/sshd.service
    [Unit]
    Description=OpenSSH server daemon
    Documentation=man:sshd(8) man:sshd_config(5)
    After=network.target sshd-keygen.service
    Wants=sshd-keygen.service

    [Service]
    EnvironmentFile=/etc/sysconfig/sshd
    ExecStart=/usr/sbin/sshd -D $OPTIONS
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=process
    Restart=on-failure
    RestartSec=42s

    [Install]
    WantedBy=multi-user.target

Über ``systemctl list-dependencies myapp.service`` werden die Services aufgelistet, von denen der Service abhängig ist:

    [vagrant@management system]$ systemctl list-dependencies sshd.service
    sshd.service
    ● ├─sshd-keygen.service
    ● ├─system.slice
    ● └─basic.target
    ●   ├─microcode.service
    ●   ├─rhel-autorelabel-mark.service
    ●   ├─rhel-autorelabel.service
    ●   ├─rhel-configure.service
    ●   ├─rhel-dmesg.service
    ●   ├─rhel-loadmodules.service
    ●   ├─paths.target
    ●   ├─slices.target


### Client ``systemctl``
* https://wiki.ubuntuusers.de/systemd/systemctl/

Systemd-basierte Linux-Systeme bieten den ``systemctl`` Client, mit dem sich einzelne Units aber auch das gesamte System beeinflussen läßt (z. B. System anhalten ``systemctl halt``).

Per 

```bash
systemctl start myapp.service
```

wird der Service ``myapp.service`` gestartet ... in Kurzform ``systemctl start myapp``.

Ein paar typische Aktionen auf Services sind

* ``start``
* ``status``
* ``is-active``
* ``stop``
* ``reload``
* ``reload-or-restart``
* ``enable``
  * hierüber wird konfiguriert, daß der Service beim Start des Systems automatisch gestartet wird ... per ``disable`` wird diese Konfiguration rückgängig gemacht
  * dabei wird ein symbolischer Link in ``/lib/systemd/`` angelegt
* ``is-enabled``
* ``disable
* ``list-dependencies``
* ``mask`` bzw. ``unmask``
  * verhindern, daß ein Service gestartet werden kann
* ``edit``
  * Unit-Datei editieren

Dazu kommen noch ein paar serviceunabhängige Kommandos:

* ``sudo systemctl daemon-reload``
  * Unit-Dateien nachladen/aktualisieren
* ``

### systemctl: wichtige Konfigurationsdateien
* Konfiguration von systemd: ``/etc/systemd/``
* symbolische Links auf die bei Systemstart zu startenden Services/Daemons (je nach Distribution unterschiedlich)
  * ``/lib/systemd/``
  * ``/system``
  * ``/etc/systemd/system``
