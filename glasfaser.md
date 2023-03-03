# Glasfaser - Fiber-to-the-Home

* [guter Überblick](https://www.youtube.com/watch?v=RydpctjoNDo)

Endlich ist es auch für uns soweit ... der Glasfaserausbau soll im April 2023 starten und bis Juli 2024 abgeschlossen sein. Die Telekom macht den Ausbau und mein Anbieter 1und1 ist Kooperationspartner, so dass ich den Anschluss dort bekomme. Da ich mit 1und1 seit Jahren sehr zufieden bin, es günstiger ist und es weitere Features bietet (TV, SIM-Karten, Cloudspeicher), die ich tatsächlich nutze.

Derzeit (Stand Februar 2023) startet Glasfaser bei den üblichen Anbietern mit 50 MBit/s und geht bis 1000 MBit/s ... ist aber noch lange nicht am Ende der möglichen Bandbreite

## Warum denn überhaupt Glasfaser?

DSL (über Kupferleitungen) und Kabelanschluss (über Koax-Kabel) liefern doch schon tolle Bandbreiten. Warum denn noch einen weiteren Anschluss?

Die Bandbreite ist schon fast ausgereitzt. Insbes. beim Upload können die beiden Alternativen nicht mit Glasfaser mithalten. Es verlagert sich immer mehr Content ins Internet (TV, Musik, Spiele) und immer mehr Geräte sind in einer Famile im Einsatz. Das Homeoffice erfordert bei Remote-Video-Übertragungen eine hohe Bandbreite.

Mit grossen Upload-Bandbreiten steht auch einem Backup von Daten in die Cloud nichts mehr im Wege.

Mit Glasfaser investiert man in die Zukunft.

## Lohnt sich eine Hausanschluss wenn man ihn gar nicht benötigt

... weil man gar kein Internet nutzt (sowas gibts) oder eben mit dem günstigeren DSL klar kommt.

Das ist eine sehr gute Frage. Der Hausanschluss kostet Geld, keine Ahnung ob die von den Internet-Providern angegeben 800 Euro tatsächlich realistisch sind (ein Loch in die Hauswand und ein bisschen verkabeln sollte ja deutlich günstiger sein). Letztlich bekommt man den vielleicht auch schon für 400 Euro.

Wenn man gar kein Internet braucht ... wenn meine Recherchen stimmen, sollte sich der Hausanschluss ohne deutlichen Mehraufwand auch nachträglich machen lassen. Dann macht es wahrscheinlich keinen Sinn, jetzt einen Glasfaseranschluss zu beauftragen, wenn man ihn dann gar nicht nutzt ... nur im den Hausanschluss subventioniert zu bekommen. Allerdings kann es später mal schwierig sein, einen Elektriker dazu zu bewegen, solch einen kleinen Auftrag zu übernehmen ... wird ja immer schwieriger einen Handwerker zu kommen. Wegen eines 300 Euro Auftrags kommen viele schon nicht mehr oder man muss Wochen/Monate warten.

---

## Ausbau

> Es war echt schwierig mal verlässliche Informationen zu bekommen ... letztlich will jeder was verkaufen und dich binden. Ich bin mir immer noch nicht ganz sicher, ob ich es komplett verstanden habe.

Die Strasse wird aufgerissen und die Telekom verlegt die Kabel. Sinnvollerweise wird JEDES Haus bis zur Aussenwand mit Glasfaser versorgt (um später nicht nochmal die Strasse aufreissen zu müssen). Von der Strass bis zur Hauswand kommt eine [Rakete](https://www.youtube.com/watch?v=2VyOgErAKj8) zum Einsatz (keine Angst die wird langsam durchs Erdreich getrieben ... der Vorgarten/Terrasse bleibt nahezu unberührt. Das ist kostenlos für mich als Hauseigentümer.

Wenn man den Glasfaseranschluss nutzen will (die Kupferkabel bleiben natürlcih vor Ort so dass DSL weiterhin nutzbar ist), dann benötigt man noch

* einen [Hausanschluss](https://www.youtube.com/watch?v=RydpctjoNDo)
* einen Glasfasernutzungsvertrag einen Internet-Providers

Der Hausanschluss beinhaltet

* Glasfaser in der Strasse
* unterirdisch wird mit einer "Rakete" Zugang bis zur Aussenwand gebohrt und ein Loch zum Keller gebohrt (keine größeren Baumassnahmen auf dem Grundstück erforderlich)
* Loch in die Kellerwand
* Leerrohr plus Glasfaserbestückung bis ins Hausinnere
* verplombte Montagedose im Inneren des Kellers

Man kann nun 2 Varianten buchen

* Glasfaser OHNE Tarif (ausschließlich der Hausanschluss)
* Glasfaser mit Nutzungstarif (Hausanschluss + Glasfasernutzungsvertrag für 24 Monate)

Je nach Erschließungsgebiet ist "Glasfaser OHNE Tarif"

* kostenlos ... so ist das in Eppelheim (Telekom Hotline) - das ist aber NICHT bundesweit so
* kostet ca. 800 Euro

Bei einem SOFORTIGEN Glasfasernutzungsvertrag (zumindest bei Telekom oder 1und1) ist der Hausanschluss IMMER (bundesweit) kostenlos.

Angenommen man ist mit DSL (über Kupferkabel) zufrieden oder man braucht gar kein Internet, dann macht es dennoch Sinn

* kostenloses "Glasfaser OHNE Tarif" (wenn angeboten) zu beauftragen
* einen kleinen Glasfasernutzungsvertrag beim Internet-Provider seiner Wahl für 24 Monate abzuschließen

um einen Glasfaser-Hausanschluss zu erhalten.

> **ACHTUNG:** für Hauseigentümer ist das **EXTREM** wichtig, denn ein nachträglicher Hausanschluss ist mit immensen Kosten verbunden. Die Immobilie verliert dadurch an Wert

Die Verlegung im Haus macht bis zu 3m von der Hauswand entfernt die Telekom. Wenn der Internet-Router weiter entfernt aufgebaut werden soll, so muss der Eigentümer hier schon entsprechende Leerrohre vorbereiten.

Es gibt zwei verschiedene Anschlussvarianten

* GPON - passiv
* AON - aktiv

---

## Router

Die VDSL Internet-Router (z. B. [Fritzbox 7590](heimnetzwerk.md)) können für einen Glasfaseranschluss weiter genutzt werden. Da sie keinen Glasfaseranschluss haben, muss nur ein Glasfaser-Modem (aktive Komponente - braucht dementsprechend Stromversorgung) vorgeschaltet werden (liefert der Provider wohl mit), die einen Lichtwellenleiter und einen LAN-Anschluss bereitstellt.

Mit einem echten Glasfaser-Internet-Router kann man sich das Modem sparen und kommt mit einem Gerät aus. Man muss in dem Fall dann aber die Strecke von Router zu Hausanschluss per Lichtwellenleiter überbrücken.

---

## Internet-Provider

Hier wird es sehr interessant und ein wenig unklar.

Der Ausbau erfolgt bei uns durch die Telekom (in anderen Gebieten sind das Vodafone, Deutsche Glasfaser, O2, ...). Die Telekom hat mit 1und1 eine [gemeinsame Vermarktung vereinbart](https://www.telekom.com/de/medien/medieninformationen/detail/glasfaser-1und1-nutzt-netz-der-telekom-648622). Mit [Vodafone und Telefonica ist Open-Access](https://www.telekom.com/de/medien/medieninformationen/detail/telekom-und-vodafone-einigen-sich-auf-details-zur-glasfasernutzung-1009512) vereinbart, d. h. auch Kunden dieser Telekomunternehmen können die von der Telekom bereitgestellten Glasfaserleitungen nutzen.

Ich habe keine Ahnung wie teuer der Hausanschluss und wen man - neben einem Internet-Provider - beauftragen kann. Letztlich braucht man aber immer einen Internet-Provider, der Glasfaser Signale liefert, und solange der den Hausanschluss subventioniert, kann einem das auch egal sein.