# Hazelcast

... ist ein shared Cache. Hierbei wird ein Cluster aufgebaut - auf Persistenz der gechachten Daten wird i. a. verzichtet, da die Daten aufgrund der Synchronisierung zwischen den Cluster-Knoten repliziert sind. Der Ausfall eines oder mehrer Clusterknoten ist somit unproblematisch. Allerdings muß man darauf achten, daß nicht ALLE Clusterknoten down sind ... das kann - insbesondere bei einem Upgrade der Hazelcast-Version - manchmal eine Herausforderung sein.
