# Camel
Bei Camel handelt es sich um eine API, um Systemintegration abzubilden.

# Konzepte
## Endpoints
Endpoints sind logische/adressierbare Namen, an denen eine Verarbeitungskette beginnt. Die Verarbeitungsschritte werden im sog. `RouteBuilder` definiert. Zur Laufzeit erfolgt die Verarbeitung dann in den sog. `Processor`s. 

## Processor
Prozessoren bilden einzelne Verarbeitungsschritte ab.

## Exchange
