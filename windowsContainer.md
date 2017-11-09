# Windows Container
Windows bietet sog. Windows Server Container. Diese Container arbeiten alle auf dem gleichen Windows-Kernel ... ähnlich wie Linux-Container auf dem gleichen Linux-Kernel arbeiten.

Auf diese Weise können dann beispielsweise auch .NET-Anwendungen oder Anwendnungen, die eine native Visual-C-Bibliothek benötigen, im Container laufen.

Microsoft hat in sein Windows Server 2016 den Windows Server Container Support eingebaut:

![Windows-Container vs. Linux-Container](http://cdn.ttgtmedia.com/rms/editorial/Docker_Windows_Linux-580px-copyright.jpg)

Deshalb kann man unter Windows Server 2016 die Windows Server Container out-of-the-box laufen lassen. Für Nutzer anderer Windows-Versionen stellt Microsoft das schlanke Windows-Server-2016-Image namens Microsoft-Nano-Server bereit, das auf Hyper-V deployed wird und die Container-Umgebung für Windows-Server-Container bereitstellt.

# Docker for Windows
Mit Docker for Windows kann man 

* enteder Windows Server Container betreiben
* oder Linux Container betreiben
  * [siehe eigener Abschnitt](docker_windows.md)

das wird in der Konfiguration von Docker for Windows festgelegt - beides gleichzeitig geht leider nicht. 

# Microsoft-Nano-Server 
* http://www.searchdatacenter.de/definition/Microsoft-Nano-Server

Hierbei handelt es sich um ein Windows Server Image (ohne grafische Benutzeroberfläche, 400 MB), das auf Hyper-V deployed wird - ganz ähnlich zum linux-basierten MobyLinuxVM, das für Linux-Container verwendet wird.



