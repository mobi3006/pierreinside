# Selenium mit Python

* [Dokumentation](https://www.selenium.dev/documentation/en/)

---

## Development Environment

* Python Entwicklungsumgebung
* Chrome Developer Extensions (HTML-Analyse, XPath, ...)
* Selenium IDE

---

## Getting Started

* [Tutorial](https://www.python-lernen.de/selenium-fernsteuern-browser.htm)

* Installation des Python-Module per `pip install selenium`
* Installation der Webdrivers ... Browser-spezifisch
  * [Chrome](https://chromedriver.chromium.org/downloads)

Dann noch das minimale Setup

```python
from selenium import webdriver

webdriver = webdriver.Chrome('./bin/chromedriver')
webdriver.get('https://www.google.de/')
```

So einfach :-)

---

## Webdriver Ansatz

Hiermit steigt man i. a. ein ... der Code simuliert die Browsernutzung durch einen User.

> WebDriver <-> Driver <-> Browser

In komplexeren Szenarien verwendet man zusätzlich noch einen Remote WebDriver

> WebDriver <-> Remote WebDriver <-> Driver <-> Browser

### Selenium IDE - Browser Extension

Es gestaltet sich häufig recht schwierig die richtigen HTML-Elemente auf einer Webseite zu finden, um sie per Skript fernzusteuern.

Die Selenium IDE kann hier gute Dienste erweisen. Sie bietet einen Recorder, der alle Clicks aufzeichnet und in einem Skript abspeichert. Somit hat man einen Einstiegspunkt für die skriptgesteuerte Implementierung in einer Programmiersprache.

### Navigation

* `webdriver.get('https://www.google.de/')`
* `webdriver.back()`
* `webdriver.refresh()`
* ...
* `webdriver.save_screenshot('./image.png')`
* ...
* `webdriver.quit()`

### Elemente einer HTML-Seite finden

* [Übersicht](https://www.selenium.dev/documentation/en/webdriver/locating_elements/#element-selection-strategies)

* `element = webdriver.find_element(By.ID, "cheese")`
* `element = driver.find_element(By.CSS_SELECTOR, 'h1')`
* `element = driver.find_element_by_xpath(...)`
