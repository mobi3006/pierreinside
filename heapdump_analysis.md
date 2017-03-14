# JVM Analyse
Folgende Aspekte können wir analysieren
* Thread Dump
* Heap Dump

---

# Threaddump Analyse
Threaddumps sind relativ klein und dementsprechend häufig in Textform, so daß man sie mit jedem Texteditor lesen kann.

> Ein Heapdump enthält auch Threadinformationen ... insofern ist der evtl. vorzuziehen. Allerdings sind Heapdumps i. a. binär und benötigen ein vergleichsweise aufwendiges Analysetool (z. B. JVisualVM, Eclipse Memory Analyzer).

## jstack
Mit 

```
jstack -l 2569
```

wird ein Threaddump erzeugt

---

# Heapdump Erzeugung
Heapdumps sind i. a. binär und benötigen ein vergleichsweise aufwendiges Analysetool (z. B. JVisualVM, Eclipse Memory Analyzer).

## OutOfMemoryError => Erzeuge Heapdump
Diese Einstellung sollte man immer verwenden:

```
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/tmp/heapdump.hprof
```

denn dadurch wird ein Heapdump erzeugt sobald die Java-VM in einen `OutOfMemoryError` läuft.