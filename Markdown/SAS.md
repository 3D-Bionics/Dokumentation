---
title: "System Architektur Spezifikation"
subtitle: "3D-Bionics Hand"
version: 1.0
date: Stand 20.07.2021
toc: True
toc-depth: 2
toc-title: Inhaltsverzeichnis

---

# Einleitung

## Zweckbestimmung

Das Dokument dient als umfassende Zusammenfassung und Überblick über die Architektur der **3D-Bionics Bionic Hand**. Die Architektur wird aus mehreren Blickwinkeln (Views) betrachtet um die verschiedenen Funktionen zu beschreiben. Es soll die Grundlage für die Entwicklung darstellen und wichtige, Architektur-spezifische Entscheidungen verständlich erklären.

## Geltungsbereich / Scope

Von diesem Dokument aus wird die Architektur und Implementierung für die Software des **3D-Bionics Bionic Hand** gesteuert. Darunter fallen:

* Hardware-Software Verbund
  * Kommunikationsstandart
  * Kontrolle der Software über die Hardware
* Modul-Aufbau
* Klassendeklarationen
* Benutze Dependencies
* Oberflächen Design

## Definitionen und Abkürzungen

- **Hand, Handmodell:** Das Produkt für welches die Architektur geschrieben ist. Eine mechanische Hand, gesteuert über einen Arduino + Servomotoren.

  - **Im Kontext der Kontrollsoftware**, bezeichnet es die interne Software-Repräsentation der Hand

- **Arduino:** Ein in dem Handmodell verbauter Mikrocontroller. Steuert die Servomotoren.

- **Servomotor, Servo:** In dem Handmodell verbaute Servomotoren, welche für die Bewegungen in der Hand zuständig sind.

- **Finger**

  Als Finger wird das mechanische Bauteil an dem Hand-Modell bezeichnet, welches über den Arduino bzw. einen Servomotor bewegt wird. Die Finger sind gleichnamig den Bezeichnungen und Positionen an einer echten Hand nachempfunden. Sie werden können im folgenden Text wie folgt abgekürzt werden.

  - Kleiner Finger: `kF`
  - Ring Finger: `rF`
  - Mittel Finger: `mF`
  - Zeige Finger: `zF`
  - Daumen: `dF`

- **Animation:** Eine Animation beschreibt eine Abfolge von mehreren Positionen der Finger um eine bestimmten Bewegungsablauf der Hand darzustellen.

- **Kontroll-App, Kontroll-Software:** Applikation über welche die Hand gesteuert werden kann

- **UI, Userinterface:** User-Interface der Kontroll-App

- **Communication-Framework, Comframe, COM:** Framework, welches die Kommunikation der Positionen der einzelnen Finger zwischen der Kontroll-Software und dem Arduino regelt. Es legt die Grundstruktur und unterliegende Protokolle fest.



## Überblick

Das SAS ist in 5 Teile untergliedert:

Innerhalb von [**Ziele und Beschränkungen**](#ziele-und-beschränkungen) werden die einzelnen Funktionsanforderungen beschrieben und unter welchen Beschränkungen die Implementierung dieser geschehen muss.

Der [**Use-Case View**](#use-case-view)  gibt einen Überblick über die tatsächliche Funktion des Programms anhand von verschiedenen Use-Cases.

Im [**System Architektur Überblick**](#system-architektur-überblick) wird ein grober Überblick über die Grundfunktionen und -Ideen sowie Aufbau des Projektes gegeben. Es wir sowohl die Hardware-Software-Beziehung beschrieben sowie der konzeptionelle Aufbau der Kontroll-Software.

Der [**Logical View**](#logical-view) teilt dass Programm in Module auf und beschreibt dessen Funktionen und die Verbindungen zwischen den einzelnen Modulen welche auch als Grundlage für die Implementierung dienen. Des Weiteren werden auch die wichtigsten Klassen genauer beschrieben sowie die Verwendung der verschiedenen Libraries erläutert.

Der Punkt [**Implementierung**](#implementierung) beschreibt die Grundstruktur des Programmcodes und die zugrundeliegenden Konventionen. Außerdem wird gezeigt, wie sich die Programmfunktionen in einzelne Programmcode-Module aufteilen.



# Ziele und Beschränkungen

Die Ziele und Beschränkungen sind innerhalb der System Requirement Spezification beschrieben.

# Use-Case View

Der **Use-Case** View gibt einen Überblick über die tatsächliche Funktion des Programms anhand von verschiedenen Use-Cases. Diese sind grundgebend für den restlichen Ablauf des SAS. Ebenfalls werden die Module benannt welche für die jeweilige Funktion verantwortlich sind.

### Einzelne Ansteuerung eines Fingers über die Kontroll Software

```mermaid
flowchart LR
a[UI zeigt Fingerposition] --> b(Auswahl neuer Position) --> c[Finger bewegt<br/>sich zu neuer Position]
```

### Ansteuerung der ganzen Hand über die Kontroll Software

```mermaid
flowchart LR
a[UI zeigt\nvorprogrammierte Hand Positionen] --> b(AuswahlPosition) --> d[Finger bewegen sich\n zu neuen Positionen]
```

### Ablauf einer Animation (mit Loop) über die Kontroll Software

```mermaid
graph LR
a[UI zeigt vorprogrammierte<br> Hand Animationen] --> b(Auswahl Position) --> loop(Auswahl ob Loop) 
loop -->|Nein| d[Finger bewegen sich<br> einmal wie in der<br> Animation beschrieben]
loop -->|Ja| e[Die Animation wird<br> kontinuirlich dargestellt]
```

### Festlegen einer vorprogrammierten Position oder Animation über Hardware-Button

```mermaid
flowchart LR
a(Hardware-Button wird gedrückt) --> b[Abspielen der nächsten<br> Position oder Animation<br> im Speicher des Arduino] --> d[Finger bewegen sich<br> zu neuen Positionen] --> e[Senden der neuen Position<br> an Kontroll-Software<br> wenn vorhanden / erreichbar]
```

# System Architektur Überblick

## Hardware-Software Verbund

### Zusammenhang des Systems

```mermaid
flowchart LR

Kontroll-Software <-->| Serial|Arduino <-->|Serial| Servo-Driver

Buttons --> Arduino

Servo-Driver .->|PWM| a(Servo 1) & b(Servo 2) & c(Servo 3) & d(Servo 4) & e(Servo 5)
```

Die Kontrollsoftware sendet über eine serielle-Schnittstelle Datenpakete an den Arduino, welcher die einzelnen Servo-Motoren über einen externen Servo-Driver ansteuert. 

Der Arduino (und damit die Servos) kann theoretisch auch über Buttons welche direkt an den Arduino angeschlossen sind angesteuert werden. In diesem Fall gibt der Arduino lediglich die neuen Positions-Werte der Finger an die Kontroll-App zurück.

## Kontroll-Software

### Aufbau

```mermaid
flowchart

ui[<b>User Interface] ---> ci(Select Position) --> cf[<b>Communication-Framework] <-->|Serial| Arduino
cf .-> |Updates Position| hm[<b>Hand-Model]
ui .->|Updates Position from| hm
```

Der Aufbau des Programms ähnelt des eines MVC-Paradigmas. Der Controller ist in diesem Fall das Communication-Framework. Es regelt die Kommunikation zwischen dem User-Interface und dem Arduino für die Hand Steuerung. Das Hand-Modell fungiert als Modell und repräsentiert die interne Position der Hand. Sie wird von dem Communication-Framework mit den Positionen des Arduino aktualisiert.



### Mögliches UI Design

![image-20210519002342806](/home/hegare/.config/Typora/typora-user-images/image-20210519002342806.png)

# Logical View

## Dependencies

### PowerBroker2 / SerialTransfer

Library, welche für das tatsächliche transferieren von Informationen zwischen Arduino und Kontroll-Software verantwortlich ist. Sie dient als Backend für das [Communication-Framework](#communication-framework). 

Es gibt eine separate Library für den Arduino und in Python.

#### Links

- [PowerBroker2/SerialTransfer](https://github.com/PowerBroker2/SerialTransfer)
- [PowerBroker2/pySerialTransfer](https://github.com/PowerBroker2/pySerialTransfer)

### NPYScreen

> Npyscreen is a python widget library and application framework for  programming terminal or console applications. It is built on top of  ncurses, which is part of the standard library.
>
> [Quelle](https://npyscreen.readthedocs.io/introduction.html)

Zuständig für:

- Anzeigen und Erstellen des Terminal User Interfaces (==Füge Funktionale Anfoderung aus SRS ein==)
- Managen des Main-Update-Loops, welchem auch das Communication-Framework untergestellt ist



## Module

#### Übersicht

```mermaid
graph TD

COM[<b>Communication Framework] .->|Defines| A_COM(Arduino-COM) & KS_COM(Kontroll-COM)
Hand[Hand-Modell] --- vorPos(Vorgefertigte Positionen)
Hard[<b>Hardware] --- scontrol(Servo Controller)
KS[<b>Kontroll-Software] --- term(Terminal User<br> Interface)

A_COM ---|for| Hard
KS_COM ---|for| KS
COM .->|Uses| Hand


```



### Communication Framework

Das Communication-Framework oder auch COM ist dafür zuständig die Positionen der einzelnen Finger zwischen der Kontroll-Software und dem Arduino zu managen. Es regelt die Kommunikation über die serielle Schnittstelle und legt das Protokoll der Übertragung fest.

Das Modul Communication-Framework beschreibt das Framework konzeptionell und legt die Anforderungen fest. Die eigentliche Implementierung des Frameworks ist in den Modulen [Arduino-Com](#arduino-com) und [Kontroll-COM](#kontroll-com) individuell realisiert.

### Hand-Modell

Das Modul **Hand-Modell** beschreibt die interne Repräsentation der Hand für die Kontroll-Software. Es dient außerdem als Basis für das gesendete Format des Hand-Modells für das Communication-Framework.

#### Vorgefertigte Positionen

Nach `SRS FA 3.1.2: Vorgefertigte Positionen` 

Das Submodul legt das Format für Repräsentation und Speicherung von vorgefertigten Positionen sowie für Animationen fest.

##### Schere Stein Papier

Nach `SRS FA 3.1.2.1: Schere Stein Papier`

Für "Schere Stein Papier" wird eine Position zufällig ausgewählt, um mit der Hand "Schere Stein Papier" spielen zu können.

### Hardware

Das Modul **Hardware** beschreibt alle Funktionalitäten welche direkt mit der Hardware zu tun haben. Dazu zählt zum einen die Programmierung des Arduinos sowohl die dafür benötigten Klassen zur Kontrolle der Servos (Submodul [Servo-Controller](#servo-controller)) sowie die Kommunikation zur Kontroll-Software (Submodul [Arduino-Com](#arduino-com)) 

#### Servo-Controller

Das Submodul **Servo-Controller** beschreibt die gleichnamige Klasse *ServoControll* welche als Interface für die fünf Servos der Finger dient. Das Ziel ist es die Servos über ein Array wie es in dem Modul [Hand-Modell](#hand-modell) beschrieben ist direkt anzusteuern.

#### Arduino-COM

Das Submodul **Arduino-COM** ist die Implementierung des [Communication-Frameworks](#communication-framework) auf dem Arduino.

### Kontroll-Software

Nach `SRS FA 3.1.3: Graphische Benutzeroberfläche`

#### Terminal User Interface

Das Modul **Terminal User Interface** beschreibt jegliche Funktionalität die für das Userinterface für die Kontroll-Software nötig ist. Dazu gehören:

- Forms und Widgetklassen für NPYScreen
- Callback-Definitionen für Interaktion mit der Software
- Einbindung des Kontroll-COM in die Kontroll-Sofware

#### Kontroll-COM

Das Submodul **Kontroll-COM** ist die Implementierung des [Communication-Frameworks](#communication-framework) für die Kontroll-Software.

## Modul: Hand-Modell

### Interne Repräsentation der Hand

Die Hand wird software-intern als die Position der fünf einzelnen Finger dargestellt.

Die Streckung der Finger wird als eine Prozent-Angabe repräsentiert wobei 0% für "Finger komplett entspannt" und 100% für "Finger komplett geschlossen" steht.

#### Eigenschaften

- **Format: ** `[Position kF, Position rF, ...]` 
- Die Reihenfolge innerhalb des Arrays ist **kF, rF, mF, zF, dF**

### Animationen

Animationen werden intern als Array von Positionen (wie oben beschrieben) abgespeichert. Die Positionen werden nach einander gesendet um eine kontinuierliche Bewegung darzustellen. Das Timing zwischen den einzelnen Positionen ist abhängig von der Sende-Rate der einzelnen Positions-Updates.

#### Beispiel:

```python
animation = [
    #[position kF,rF,mF,zF,dF] Format von Positionen
    [60, 50, 40, 30, 20],
    [70, 60, 50, 40, 30],
    [80, 70, 60, 50, 40],
    [90, 80, 70, 60, 50],
    ....
]
```

### Speicherung von vorgefertigten Positionen

Positionen oder Animationen werden zusammen mit einem Namen, innerhalb einer Map gespeichert. Die Kontroll-Software ließt diese Map aus um die Menü-Optionen zu generieren.


## Modul: Communication-Framework

> Das Communication-Framework oder auch COM ist dafür zuständig die Positionen der einzelnen Finger zwischen der Kontroll-Software und dem Arduino zu managen. Es regelt die Kommunikation über die serielle Schnittstelle und legt das Protokoll der Übertragung fest.
>
> Das Communication-Framework besteht aus zwei Teilen. Der Erste Teil befindet sich in der Kontroll-Software und der zweite im Arduino.

### Aufgaben nach SRS

- Positionen der einzelnen Finger über die Kontroll-Software an den Arduino weitergeben `SRS 3.1.1`
- Komplexere Positionsabläufe über die Kontroll-Software an den Arduino weitergeben `SRS 3.1.2`
- Das interne Hand-Modell mit Positions-Updates des Arduinos zu aktualisieren `SRS 3.1.3`
- Automatisches Aufbauen einer Verbindung zwischen Kontroll-Software und Arduino über eine serielle Verbindung `SRS 3.2.1`

### Kommunikations-Standard

#### Anforderungen

- Die Kommunikation läuft über eine serielle Schnittstelle zwischen Kontroll-Software und Arduino.
- Es werden nur dann Positionen gesendet wenn sich auch etwas an der Position der Finger verändert hat, oder sich etwas ändern soll
- Gesendete Positionen sind stets im Format wie es in [Hand-Modell / Format](#interne-repräsentation-der-hand) beschrieben wird 
- Eine Animation ist eine Liste von hintereinander gesendeten Positionen
- Das Communication-Framework hat eine interne Message-Queue, welche asynchron abgearbeitet werden kann. 



#### Sequenz eines Positionsupdates

```mermaid
sequenceDiagram
	UI ->> Kontroll-COM: neues Positionsupdate
	Kontroll-COM ->> Kontroll-COM: update Queue
    Kontroll-COM ->> Arduino-COM: sendet Position
    alt Kontrol-Software Mode
    	Arduino-COM ->> Arduino: Servo Update 	
    else Button Mode
   		Button ->> Arduino:  Instruction [5V Signal]
    end
    
    Arduino ->> Arduino: Set internal System Queue
    Arduino ->> Arduino: Update Servos
    
    Arduino-COM ->> Kontroll-COM: sendet neue Position
    Kontroll-COM ->> UI: Update Position
 	
```

## Klassen

### Kontroll-Software

```mermaid
classDiagram
class App{
	Hand hand_object
	COM comframe
	MainForm MainForm
	
}

class NPYScreenForm
class NPYScreenWidgets

class MainForm{
	Hand hand_object
	COM comframe
	handlers
	create()
	while_waiting()
	sendPos()
	updatePos()
}

MainForm <|-- NPYScreenForm :Baseclass
MainForm *-- "many"NPYScreenWidgets: has

class COM {
	<<interface>>
	-Hand hand_object
	-list queue
	-SerialTransfer link
	
	-connect(port)
	+reconnect(port)
	
	+attachHandTracker(port)
	
	+sendPos(positions)
	+sendHandPos()
	
	+processQueue()
	+queue_clear()
	
	-receivePos()
	-receiveDebug()
}

class SerialTransfer
COM *-- SerialTransfer

class Hand {
	list~int~ positions
	
	+setPos(positions) bool
	+setFinger(position) bool
	
	+getPos() list~int~
	+getFinger() int
	
	validatePos(positions)$ bool
	
}

COM *-- "1" Hand

App *-- "1" COM
App *-- "1" Hand : link to object
App *-- MainForm

%%MainForm .. COM
%%MainForm .. Hand
```





### Arduino



```mermaid
classDiagram
	class HandControll{
		
	}
	
	class ServoControll{
	<<interface>>
		
		+updatePos(int[5] position)
		
		-setServo(int servo, int pwm)
		-mapPosToPWM(int pos) int
		
	}
	
	ServoControll --* ServoDriver
	HandControll --o"1" ServoControll

```



# Implementierung

## Communication-Framework in Python











