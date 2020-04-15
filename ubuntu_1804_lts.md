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

## FAQ

Frage 1: Ich verwende NAT und im Homeoffice über VPN habe ich immer wieder Probleme Hostnamen aus dem Private Network aufzulösen. Nicht immer, aber irgendwann passiert es dann mal und dann muß ich die Netzwerkverbindung neu initialisieren (`sudo systemctl stop systemd-resolved && sudo systemctl start systemd-resolved`). Was ist das Problem?

Antwort 1: Der `systemd-resolved` ist ein DNS-Cache, den Ubuntu verwendet ... deshalb ist der Prozess auch an den Port `53` auf Deinem System gebunden. Bei einem `netstat -taupen | grep 53` bekomme ich folgende Ausgabe:

```
3:tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      102        410742     28695/systemd-resol
```

Die Konfiguration ist unter `/etc/systemd/resolved.conf` zu finden ... wenn man daran etwas ändert muß man den Service per `systemctl restart systemd-resolved` neu starten. [Hier](https://ohthehugemanatee.org/blog/2018/01/25/my-war-on-systemd-resolved/) findet man einen guten Artikel. Eine Anpassung von `/etc/systemd/resolved.conf` wie in den Antworten geschrieben hat noch nicht geholfen.. Schau mal in `/var/log/syslog`, ob da was zu finden ist.

Frage 2: Mein System scheint immer mal wieder einzufrieren ... es wird der Login-Screen gezeigt und nach erfolgreichem Login erhalte ich einen einfarbigen dunklen Bildschirm. Im `/var/log/syslog` sehe ich

```
Jan 14 08:37:06 workbench kernel: [ 3540.582228] INFO: rcu_sched detected stalls on CPUs/tasks:
Jan 14 08:37:06 workbench kernel: [ 3540.582237] 	0-...!: (1 GPs behind) idle=e8c/0/0 softirq=16644/16644 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582240] 	1-...!: (4 GPs behind) idle=82c/0/0 softirq=17176/17176 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582242] 	2-...!: (8 GPs behind) idle=ca0/0/0 softirq=20991/20992 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582244] 	3-...!: (1 GPs behind) idle=1a0/0/0 softirq=22994/22994 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582247] 	4-...!: (12 GPs behind) idle=9f4/0/0 softirq=21277/21277 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582249] 	5-...!: (12 GPs behind) idle=74c/0/0 softirq=18478/18478 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582251] 	7-...!: (1 GPs behind) idle=1c8/0/0 softirq=32111/32112 fqs=0 
Jan 14 08:37:06 workbench kernel: [ 3540.582252] 	(detected by 6, t=53708 jiffies, g=20124, c=20123, q=6)
Jan 14 08:37:06 workbench kernel: [ 3540.582256] Sending NMI from CPU 6 to CPUs 0:
Jan 14 08:37:06 workbench kernel: [ 3540.582315] NMI backtrace for cpu 0 skipped: idling at native_safe_halt+0x12/0x20
Jan 14 08:37:06 workbench kernel: [ 3540.583261] Sending NMI from CPU 6 to CPUs 1:
Jan 14 08:37:06 workbench kernel: [ 3540.583311] NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0x12/0x20
Jan 14 08:37:06 workbench kernel: [ 3540.584349] Sending NMI from CPU 6 to CPUs 2:
Jan 14 08:37:06 workbench kernel: [ 3540.585016] systemd[1]: systemd-logind.service: Watchdog timeout (limit 3min)!
Jan 14 08:37:06 workbench kernel: [ 3540.585030] systemd[1]: systemd-logind.service: Killing process 1155 (systemd-logind) with signal SIGABRT.
Jan 14 08:37:06 workbench kernel: [ 3540.588064] NMI backtrace for cpu 2
Jan 14 08:37:06 workbench kernel: [ 3540.588065] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G         C  E    4.15.0-62-generic #69-Ubuntu
Jan 14 08:37:06 workbench kernel: [ 3540.588066] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
Jan 14 08:37:06 workbench kernel: [ 3540.588066] RIP: 0010:reschedule_interrupt+0x0/0xa0
Jan 14 08:37:06 workbench kernel: [ 3540.588067] RSP: 0018:ffff9e18c318be58 EFLAGS: 00000046
Jan 14 08:37:06 workbench kernel: [ 3540.588068] RAX: ffffffff853bb0f0 RBX: 0000000000000002 RCX: 0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588068] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588069] RBP: ffff9e18c318be80 R08: ffffffffffffffff R09: 0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588069] R10: 0000000000000000 R11: 00000000000007c0 R12: 0000000000000002
Jan 14 08:37:06 workbench kernel: [ 3540.588070] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588071] FS:  0000000000000000(0000) GS:ffff8bbcbfe80000(0000) knlGS:0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588071] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jan 14 08:37:06 workbench kernel: [ 3540.588072] CR2: 00007fc43b9be4f0 CR3: 0000000067e0a005 CR4: 00000000000606e0
Jan 14 08:37:06 workbench kernel: [ 3540.588072] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jan 14 08:37:06 workbench kernel: [ 3540.588073] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Jan 14 08:37:06 workbench kernel: [ 3540.588073] Call Trace:
Jan 14 08:37:06 workbench kernel: [ 3540.588073]  ? native_safe_halt+0x12/0x20
Jan 14 08:37:06 workbench kernel: [ 3540.588074]  default_idle+0x20/0x100
Jan 14 08:37:06 workbench kernel: [ 3540.588074]  arch_cpu_idle+0x15/0x20
Jan 14 08:37:06 workbench kernel: [ 3540.588075]  default_idle_call+0x23/0x30
Jan 14 08:37:06 workbench kernel: [ 3540.588075]  do_idle+0x172/0x1f0
Jan 14 08:37:06 workbench kernel: [ 3540.588075]  cpu_startup_entry+0x73/0x80
Jan 14 08:37:06 workbench kernel: [ 3540.588076]  start_secondary+0x1ab/0x200
Jan 14 08:37:06 workbench kernel: [ 3540.588076]  secondary_startup_64+0xa5/0xb0
Jan 14 08:37:06 workbench kernel: [ 3540.588076] Code: 48 89 3c 25 f8 3f 00 00 65 48 8b 24 25 98 5b 01 00 57 e8 c4 08 00 00 e9 eb e4 ff ff 0f 1f 44 00 00 66 2e 0f 1f 84 00 00 00 00 00 <0f> 1f 00 68 02 ff ff ff fc f6 44 24 10 03 74 10 0f 01 f8 0f 1f
```

Dann hilft nur ein Reboot ...

Beobachtungen:

* passiert nur, wenn das Host-System (meiner VirtualBox) gesperrt ist (Win-L)
* manchmal verliere ich kurzzeitig die WLAN-Verbindung

Ich habe auch schon sowas gesehen:

```
Jan 14 11:50:08 workbench kernel: [10946.514078] clocksource: timekeeping watchdog on CPU6: Marking clocksource 'tsc' as unstable because the skew is too large:
Jan 14 11:50:08 workbench kernel: [10946.514079] clocksource:                       'kvm-clock' wd_now: 9f7fd12d7b9 wd_last: 25fd713400f mask: ffffffffffffffff
Jan 14 11:50:08 workbench kernel: [10946.514080] clocksource:                       'tsc' cs_now: 17ecc61b7c15 cs_last: 5b2d10ee003 mask: ffffffffffffffff
Jan 14 11:50:08 workbench kernel: [10946.514081] tsc: Marking TSC unstable due to clocksource watchdog
Jan 14 11:50:08 workbench kernel: [10946.514510] 03:01:35.931255 timesync vgsvcTimeSyncWorker: Radical host time change: 8 398 702 000 000ns (HostNow=1 578 999 013 139 000 000 ns HostLast=1 578 990 614 437 000 000 ns)
Jan 14 11:50:08 workbench kernel: [10946.514551] 03:01:35.931323 timesync vgsvcTimeSyncWorker: Radical guest time change: 8 353 359 671 000ns (GuestNow=1 578 999 008 454 132 000 ns GuestLast=1 578 990 655 094 461 000 ns fSetTimeLastLoop=false)
Jan 14 11:50:08 workbench systemd-resolved[7909]: Grace period over, resuming full feature set (UDP+EDNS0) for DNS server 10.....
Jan 14 11:50:08 workbench systemd[1]: Starting Daily apt download activities...
```
