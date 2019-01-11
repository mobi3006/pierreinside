# Ubuntu 18.04 LTS

Im Januar 2019 habe ich mich zu einem Upgrade von [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) auf diese Version entschlossen.

## Upgrade

Zunächst habe ich mein Virtualbox mal auf den neuesten Stand gebracht (5.2.22) Virtualbox Guest Extensions wieder installiert. Danach erfolgte der Ubuntu Upgrade (mit `apt` statt mit `apt-get`):

```bash
sudo bash
apt update && apt dist-upgrade && apt autoremove
```

Das hat hat ganz gut funktioniert. Abgesehen von

- lokalen Änderungen in `/etc/resolvconf/resolv.conf.d/head` - habe ich verworfen
- einige Third Party Sourcen wurden disabled
  - meine MySQL Workbench war anschließend weg und ich mußte sie neu installieren
- beim Start meines Virtual Box Images erhalte ich die Warnung `failed to connect to lvmetad` - ein Problem, das scheinbar viele mit dem 18.04 haben

Danach habe ich die Virtualbox Guest Extensions nochmal installiert, weil ich einen neuen Kernel bei dem Upgrade bekommen habe.
