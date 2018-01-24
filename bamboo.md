# Bamboo Build and Deployment Pipeline

## Konzepte

Man unterscheidet

* Build-Plans
* Branch-Plans
* Deploy-Projects

um eine Build und Deployment-Pipeline aufzubauen.

![Bamboo-Konzepte](/images/bambooPipeline.png)

## Variables

Man unterscheidet Variablen auf verschiedenen Ebenen:

* Configuration-Time-Variables (können auf jeder Ebene überschrieben werden):
  * globale Variablen
  * Build-Plan Variablen
  * Branch-Plan Variablen
* Runtime-Variables (von Bamboo bereitgestellte):
  * z. B. `bamboo.buildNumber`
* Deployment-Environment-Variables

Bamboo stellt selbst Variablen zur Verfügung - Variablen können aber auch am Build-Plan hängen und im Branch-Plan überschrieben werden.