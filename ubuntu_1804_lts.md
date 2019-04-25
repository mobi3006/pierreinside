# Ubuntu 18.04 LTS

Im Januar 2019 habe ich mich zu einem Upgrade von [Ubuntu 16.04 LTS](ubuntu_1604_lts.md) auf diese Version entschlossen.

---

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

### Langsame IO Performance - I/O Scheduler

- [Linux I/O schedulers](https://wiki.ubuntu.com/Kernel/Reference/IOSchedulers)
- [Improving Linux System Performance with I/O Scheduler Tuning](https://blog.codeship.com/linux-io-scheduler-tuning/)
- [Change IO scheduler in Linux](https://www.golinuxcloud.com/how-to-change-io-scheduler-permanently-linux/)

> "Next is the IO scheduler which determines how your operating system is going to talk to the disk. There are different types of IO scheduler with each having various tunables to optimize the IO performance based on your requirement." ([golinuxcloud](https://www.golinuxcloud.com/how-to-improve-disk-io-performance-in-linux/))

Ich konnte bisher immer einen 10 MB großen Dump in meinen MySQL-Docker Container schnell einspielen (15 Sekunden) - z. B. beim Hochfahren der MySQL Instanz. Nach dem Upgrade dauerte es ewig (60 Sekunden) - [ähnlich wie dieser Benutzer](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1812569) ... der I/O Scheduler (`/sys/block/sda/queue/scheduler` - wird pro Device konfiguriert ... hier `sda`) scheint große Unterschiede zu machen:

- `cfq`: 60 Sekunden
  - cfg = completely fair queuing
  - "CFQ and deadline, are impossible to suggest specific use cases for. The reason for this is that the exact behaviour depends on both the Linux kernel you’re using and the associated workload. There are kernel versions where CFQ has terrible performance, and deadline is clearly better because of bugs in the CFQ implementation in that version. In other situations, deadline will add latency exactly the opposite of what people expect when the system has a high level of concurrency. And you’re not going to be able to usefully compare them with any simple benchmark. The main differences between CFQ and deadline only show up when there are many concurrent read and write requests fighting for disk time. Which is optimal is completely dependent on that mix." ([golinuxcloud](https://www.golinuxcloud.com/how-to-improve-disk-io-performance-in-linux/))
- `deadline`: ???
- `noop`: 15-20 Sekunden
  - "The noop scheduler, which just pushes data quickly toward the hardware, can improve performance if your hardware has its own large cache to worry about." ([golinuxcloud](https://www.golinuxcloud.com/how-to-improve-disk-io-performance-in-linux/))
  - "Avoid using the none/noop I/O schedulers for a HDD as sorting requests on block addresses reduce the seek time latencies and neither of these I/O schedulers support this feature." ((Linux I/O schedulers)[https://wiki.ubuntu.com/Kernel/Reference/IOSchedulers])
- es gibt prinzipiell noch weitere, aber nicht in meiner Ubuntu Distribution

Interessanterweise hatte die Einstellung auf meine Maven-Builds keinen Einfluss (bei einem 8 Minuten Build ohne Tests) - vermutlich, weil dies vergleichsweise (im Vergleich zum Dump-Restore) wenig I/O.

Temporär kann man die Einstellung als `root` per `echo noop > /sys/block/sda/queue/scheduler` verändern.

Eine permanente Änderung erfolgt in Grub als Kernel Parameter:

- in `/etc/default/grub` die `GRUB_CMDLINE_LINUX_DEFAULT` anpassen: z. B. `elevator:sda=noop`
- `sudo update-grub`

---