# Mobiles Frontend für Klarschiff

Klarschiff Mobil (KsMobil) ist eine HTML5-Anwendung, basierend auf folgenden Frameworks:

* [The-M-Project](http://www.the-m-project.org) - jQuery basiertes MVC-Framework
  für HTML5-Anwendungen
* [Openlayers](http://openlayers.org) - JavaScript-Mapping-Framework
* [PROJ4JS](https://github.com/proj4js/proj4js) - JavaScript Bibliothek zur 
  Transfomation von Koordinaten

Die Applikation wird mit dem Werkzeug [Espresso](https://github.com/mwaylabs/Espresso)
erzeugt.

## Verzeichnisstruktur

* **KsMobil:** Applikationsquellen
* **node\_modules/espresso:** via npm installiertes Paket von Espresso zur 
  Bereitstellung der Build-Umgebung sowie der notwendigen Ressourcen für 
  The-M-Project. Da die Integration als Git Submodul leider nicht mit alles
  enthaltenen Referenzen funktioniert.
* **OpenLayers:** Git Submodul zur Bereitstellung der Build-Umgebung für eine 
  angepasste Openlayers.js
* **proj4js:** Git Submodul für die aktuellen Quellen.
* **ksmobil.openlayers.build.cfg:** Konfigurationsdatei für ein individuelles 
  OpenLayers-Build
* **package.json:** Konfigurationsdatei für Espressoinstallation via npm.

## Einrichtung der Build- und Entwicklungsumgebung

### Voraussetzungen

Zur Installation und Anwendung der Build-Umgebung wird [Node.js](http://nodejs.org/) >= 0.10
und [NPM](http://npmjs.org/) benötigt. Letzteres wird durch die Installation von Node.js 
mit bereitgestellt.

1. Initialisierung der Git Submodule (Aufruf aus der Repository-Wurzel):

        git submodule update --init --recursive

1. Installation Espresso via npm:

        cd frontend-mobil
        npm install

1. Ggf. Installation gnulib via apt:

  Ab Version 0.9.3 von Node.js ist die Reihenfolge von Dateien in Dateilisten die via 
  `fs.readdir` abgefragt werden betriebssystemsabhängig. Beim Zusammenbau des Projektes via
  `espresso build` wird dadurch auf Linuxsystemen eine falsche (unsortierte) Reihenfolge der
  zusammenzufassenden Dateien verwendet.
  Mit Hilfe von `alphasort`, das durch das DEB-Paket `gnulib` bereitgestellt und von `fs.readdir`
  berücksichtigt wird, kann man das Problem beheben.

        sudo apt-get install gnulib

1. Erzeugen eines Alias zum vereinfachten Aufruf von Espresso:

        alias espresso=`pwd`/node_modules/espresso/bin/espresso.js

## Build erzeugen

Um ein neues Build aus dem aktuellen Programmcode zu erzeugen, wird im
Verzeichnis KsMobil das Espresso-Build-Tool benutzt:

    cd KsMobil
    espresso build

Das fertige Build wird dann im Verzeichnis KsMobil/build/{version} abgelegt. Beim 
Deployment auf den Webserver ist darauf zu achten, dass Proxies entsprechend
der Proxy-Konfiguration in der Datei KsMobil/config.json angelegt werden!

## Integration einer neuen Version von The-M-Project

Leider gibt es zur Zeit noch keinen Weg via Werkzeug oder Espresso das Framework zu
aktualisieren. Wenn also eine neue Version des Framworks integriert werden soll, 
muss hierzu wie folgt vorgegangen werden:

1. Installation der neueren Version von Espresso im Wurzelverzeichnis (die vorhandene
   Version wird dabei überschrieben):

        npm install espresso@x.y.z

1. Austausch des aktuellen Framwork-Verzeichnis im Projekt durch das aus der 
   neuen Espresso-Version:

        rm -rf frontend-mobil/KsMobil/frameworks/The-M-Project
        cp -R node_modules/espresso/frameworks/The-M-Project frontend-mobil/KsMobil/frameworks/

## Integration einer neuen Version von OpenLayers

Wenn eine neue Version von OpenLayers verwendet werden soll, muss hierzu das 
zugehörige Git Submodul aktualisiert werden. Anschließend kann dann eine neue 
Bibliotheksversion für KsMobil erzeugt werden. In der Datei 
`ksmobil.openlayers.build.cfg` ist hierfür eine OpenLayers-Build-Konfiguration
abgelegt, mit der ein angepasstes OpenLayers erstellt werden kann. Dazu muss das 
Build-Skript unter `OpenLayers/build/build.py` mit dieser Konfiguration ausgeführt
werden. Die Ausgabe sollte in das zugehörige frameworks-Verzeichnis erfolgen. 
Der Aufruf muss allerdings zwingend aus dem `OpenLayers/build`-Ordner erfolgen.

    cd OpenLayers/build/
    build.py ../../ksmobil.openlayers.build.cfg ../../KsMobil/frameworks/OpenLayers/OpenLayers.js

## Integration einer neuen Version von PROJ4JS

Zur Zeit gestalltet sich die Integration einer neueren Version als sehr schwierig,
da OpenLayers aktuell nur die Version bis 1.1.0 zu unterstützen scheint.
Diese alten Version sind noch in einem SVN-Repository verwaltet. Ab Version 1.3.0 
erfolgte der Schwenk auf Github. Die hier eingebundene Version wurde direkt von 
http://svn.osgeo.org/metacrs/proj4js/tags/proj4js-1.1.0/lib/proj4js-compressed.js 
geladen. 

Ab OpenLayers 3 scheint aber eine Unterstützung für die neueren Versionen
geplant zu sein. Soblad dies erfolgt ist könnte man PROJ4JS als Git Submodul einbinden
und sich die Aktualisierungen von dort aus dem entsprechenden `dist`-Verzeichnis ins 
Projekt kopieren.

    cp proj4js/dist/proj4.js KsMobil/frameworks/proj4js/

## Dateistruktur innerhalb der Anwendung

**KsMobil/config.json:** Konfigurationsdatei des Espresso-Build-Tools. Dies ist
  JSON-Datei, daher müssen Anführungszeichen der Form " verwendet werden!

**KsMobil/build:** Build-Verzeichnis. Hier werden statische Builds der Anwendung
  vom Espresso-Build-Tool abgelegt. Die einzelnen Builds werden in 
  Verzeichnissen abgelegt, entsprechend der Konfigurationsangbe in der config.json.
  Die Builds werden nicht im Repository geführt.

**KsMobil/frameworks:** Hier liegen die verwendeten Frameworks der Anwendung, das
  sind The-M-Project (inklusive jQuery Mobile), OpenLayers, PROJ4JS und ein 
  Framework zur Bereitstellung des statischen Impressums.

**KsMobil/app:** Das eigentliche Programmcodeverzeichnis der Anwendung.

**KsMobil/app/main.js:** Hier wird die Anwendung an sich definiert, d.h. alle
  Anwendungsseiten sowie die Auswahl der Startseite.

**KsMobil/app/controllers:** Hier liegen die Controller-Klassen der Anwendung.

**KsMobil/app/controllers/AppController.js:** Der Anwendungscontroller. Wird beim
  Start der Anwendung geladen, um die Aktualität der Anwendung zu überprüfen.
  Dazu wird ein Ajax-Request an die getVersions.php abgeschickt. Stellt der 
  Controller fest, dass Code oder Konfiguration andere Versionen als die vom
  Server aufweisen, werden Code und/oder Konfiguration neu geladen.
  Der Code wird im Cache gespeichert, die Konfiguration im LocalStorage.
  Nach der Prüfung wird die MapPage angezeigt.

**KsMobil/app/controllers/MapController.js:** Kartencontroller. Steuert
  Konfiguration der OpenLayers-Karte, Basiskartenwechsel, Zoom-Aktionen,
  Abwahl aller selektierten Features sowie Suche (TODO) und die Größenanpassung
  der Karte an den Viewport (Berechnung der Kartenhöhe minus der Toolbars).

**KsMobil/app/controllers/MeldungController.js:** MeldungController, steuert alle
  Aktionen rund um Meldungen.
  Der Controller fügt der Karte den Layer zum Zeichnen neuer Features hinzu.
  Steuert u.a. die Navigation zwischen den verschiedenen Seiten beim Auswählen
  eines Features, bei der Unterstützungs- und Missbrauchsmeldung und beim
  Absetzen einer neuen Meldung. Eingabevalidierung für neue Meldungen ist 
  ebenfalls in diesem Controller definiert.

**KsMobil/app/resources/base/style.css:** Stylesheet der Anwendung

**KsMobil/app/resources/base/images/:** Bilder für die Anwendung. Umfasst Logo
  und Icons.

**KsMobil/views:** Hier sind die Views der Anwendung hinterlegt. Das umfasst zum
  einen Pages, welche einzelne Seiten der Anwendung in ihrer Gesamtheit
  definieren als auch Views, welche einzelne, speziell angepasste Teile von
  Seiten definieren.

**KsMobil/views/MapPage.js:** Karten-Seite, definiert die Kartenansicht der
  Anwendung.

**KsMobil/views/MapView.js:** Karten-View, definiert einen auf OpenLayers
  basierenden View, welcher in der Karten-Seite verwendet wird.

**KsMobil/views/MeldenPage.js:** Definiert die Seite, welche für eine neue Meldung
  angezeigt wird.

**KsMobil/views/MeldenView.js:** Definiert den View, der das Formular für eine neue
  Meldung umsetzt.

**KsMobil/views/MissbrauchPage.js:** Definiert die Seite, welche die 
  Missbrauchsmeldung darstellt.

**KsMobil/views/StartingPage.js:** Startseite, zeigt Logo und Startmeldungen an.

**KsMobil/views/UnterstuetzenPage.js:** Definiert die Seite, welche die
  Unterstützungsmeldung anzeigt.
