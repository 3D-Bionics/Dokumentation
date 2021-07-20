---
title: System Requierements Specification
subtitle: 3D-Bionics Hand
version: 1.5
institution: Technische Hochschule Aschaffenburg
date: Stand 2.07.2021
toc: True
toc-title: Inhaltsverzeichnis
---

# Einleitung

##  Ziel

Das Ziel der System Requirements Specification ist es, das Start-Up 3D-Bionics mit der Bionic Hand als Produkt, vollständig in seinen Funktionen und Anwendungsbereichen zu definieren und einen Einblick zu schaffen, für welche Zielgruppen es geeignet ist. Der primäre Anspruch ist es, interessierten Bastlern einen grundlegenden Einblick in den 3D-Druck, die Elektrotechnik, sowie in die Mikrocontrollerentwicklung zu geben. Durch die Wahl der Pakete, kann der Nutzer zwischen verschiedenen Einblickstiefen und Blickwinkeln entscheiden.

##  Anwendungsbereiche

Das Produkt richtet sich in erster Linie an Interessenten aus den Bereichen 3D-Druck und Mikrocontrollerprogrammierung. So können unsere Open-Source-Dateien als Vorlage für eigene Änderungen oder Anpassungen genutzt werden. Das Produkt kann somit als Baukasten verstanden werden, dessen einzelne Bestandteile individuell anpassbar sind.

##  Definitionen und Akronyme

**Nutzer / Kunde** = Mit Nutzer / Kunde werden alle Personengruppen beschrieben, die dieses Produkt verwenden.

**Kontrollsoftware** = Die Kontrollsoftware ist die Software, die der Nutzer ausführt, um die Bionic Hand zu steuern. Diese Software kommuniziert über die serielle Schnittstelle mit dem Arduino, worüber die Hand gesteuert wird.

**Arduino / Mikrocontroller =** Arduinos sind Mikrocontroller, die es in vielen verschieden Ausführungen gibt. Im Fall der Bionic Hand kommt ein Arduino Nano zum Einsatz. Der Arduino ist für die Steuerung der Servomotoren in der Hand verantwortlich.

**Servomotor** = Servomotoren sind kleine Elektromotoren, die im Unterarm der Bionic Hand verbaut sind und an den Fäden der Finger ziehen, um diese zu bewegen.

# Allgemeine Beschreibung

##  Produktperspektive

Unser Produkt lässt sich in verschiedenen Versionen kaufen. Je nach Paket ist es nötig noch weitere Teile eigenständig zu erwerben. Sollte der Kunde sich für unser „Free“ – Paket entscheiden, liegt es in seiner Verantwortung die notwendigen Hardwareteile zur Verfügung zu stellen. Die Pakete „DIY“ und „Fertigbau“ sind nicht von Drittanbieterprodukten abhängig und sind somit vollkommen eigenständig.

##  Produktfunktionen

Die Bionic Hand ist ein Baukastenset, um die Fähigkeiten der Nutzer in den Bereichen 3D-Druck, Mikrocontrollerprogrammierung und Elektrotechnik zu vertiefen. Sobald die Hardware der Hand fertig gestellt wurde, lässt sich durch Anpassungen der Software noch viel verändern. Durch die serielle Schnittstelle zwischen dem PC und dem Controller, lassen sich die Finger alle einzeln ansteuern. Zu diesem Zweck wird ebenfalls eine Software mit graphischer Nutzeroberfläche zur Verfügung gestellt. Auch ist es möglich, die Hand über vorgefertigte Positionen zu steuern. Diese Positionen werden in [3.1.2](#vorgefertigte-positionen) und [3.1.3](#schere-stein-papier) näher erklärt.

##  Benutzercharakteristika

Die Zielgruppen lassen sich grob in zwei Gruppen einteilen. Die Hauptnutzergruppe sind Privatpersonen, die zum größten Teil aus interessierten Jugendlichen und jungen Erwachsenen besteht, die einen leichten Einstieg in den 3D-Druck oder die Mikrocontrollerprogrammierung suchen. Die zweite große Gruppe besteht aus Bildungseinrichtungen und Jugendwerkstätten, die unser Produkt als Lehrwerkzeug nutzen können.

##  Allgemeine Beschränkungen

Da die Bionic Hand lediglich zum Weiterbilden und Experimentieren entwickelt wurde und hier ihre Stärken liegen, kann die Hand nicht als Prothese genutzt werden. Dafür fehlt es dem Produkt an Stärke und Robustheit. Außerdem werden die nötigen Richtlinien für Medizinprodukte nicht erfüllt.

##  Voraussetzungen und Abhängigkeiten

Welche Voraussetzungen es gibt, um das Produkt nutzen zu können, hängt stark vom gewählten Paket ab. Da im kostenlosen Paket ausschließlich 3D-Druck Dateien enthalten sind, ist ein 3D-Drucker, Filament, ein Mikrocontroller nach Wahl und elektrische Bauteile, wie Servomotoren nötig. Eine weitere Voraussetzung, die bei allen Paketen anfällt, ist ein funktionsfähiger PC, um den Mikrocontroller zu programmieren und die Hand anzusteuern, sowie eine externe Stromquelle mit 5V und mindestens 1 Ampere. Bei den anderen beiden Paketen sind der PC und die Stromquelle die einzigen Voraussetzungen.

#  Spezifische Anforderungen

##  Funktionale Eigenschaften

###  Fingersteuerung

Eine grundlegende Eigenschaft der Bionic Hand ist es, jeden einzelnen Finger steuern zu können. Für die Finger lässt sich alles zwischen 0% und 100%, in einer Schrittweite von fünf Prozent, einstellen, wobei 0% vollständig gestreckt und 100% vollständig eingeklappt ist.

###  Vorgefertigte Positionen

Die vorgefertigten Positionen sind von 3D Bionics erstellte Gesten, die die Position jedes Fingers bestimmen. So gibt es beispielsweise die Position „Peace“, bei der der Zeigefinger und der Mittelfinger gestreckt werden, während alle anderen Finger eingeklappt werden. Diese Positionen lassen sich mit der graphischen Benutzeroberfläche an der Hand ausführen. Der Nutzer kann später auch noch eigene Positionen für die Hand programmieren.

#### Schere Stein Papier

Die Funktion „Schere Stein Papier“ ist eine speziell vorgefertigte Position, da auch hier Positionen für die Finger im Code hinterlegt sind. Bei „Schere Stein Papier“ wird aber zufällig eine der drei Positionen, Schere, Stein oder Papier ausgewählt, welche dann von der Hand angezeigt wird. So kann der Nutzer mit der Bionic Hand das bekannte Spiel „Schere Stein Papier“ spielen.

### Graphische Benutzeroberfläche

Die graphische Benutzeroberfläche ist dafür zuständig, die Hand einfach und schnell zu steuern. Dort lässt sich zum Beispiel jeder Finger, wie in 3.1.1 bereits erklärt, ansteuern. Des Weiteren sind auch die vorgefertigten Positionen aus [3.1.2](#vorgefertigte-positionen) und „Schere Stein Papier“ aus [3.1.3](#schere-stein-papier) auf der Benutzeroberfläche zu finden. Die Benutzeroberfläche wird als dynamisches Terminal User Interface realisiert.

##  Nichtfunktionale Eigenschaften

###  Kommunikation über serielle Schnittstelle

Die serielle Schnittstelle stellt sicher, dass die Kontrollsoftware problemlos mit dem Arduino kommunizieren kann. Somit muss für die Steuerung der Hand kein Arduino Code geschrieben werden.

###  Unterstützung verschiedener Betriebssysteme

Die Kontrollsoftware läuft auf allen gängigen Plattformen, welche den Python-Interpreter unterstützen.

###  Lesbarkeit des Codes

Da die Bionic Hand unter anderem ein Lehrprodukt ist, ist es enorm wichtig, dass der Code für die Steuerung der Hand leicht zu verstehen und gut auskommentiert ist. Außerdem sollte der Code so aufgebaut ist, dass es möglichst einfach für den Nutzer ist, die Steuerungssoftware weiterzuentwickeln.
