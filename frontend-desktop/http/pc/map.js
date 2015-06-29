
/** File: map.js
 * Openlayers-spezifische Funktionen
 */

/** Function: prepareElements
 * Verschiebt die Mapbender-Elemente anhand ihres Target-Attributs in die 
 * entsprechenden Mapbender-Elemente
 */
var prepareElements = function() {
  // Move all elements to the element with the id given
  // in the target attribute
  $('body *').each(function(){
    var self = $(this),
    api = self.data('api');

    if(api && api.target && api.target.length)
      var target = $("#" + api.target[0])
    target && self.appendTo(target);
  });
};


/**
 * @fn prepareMap = function(mapElement)
 * Erzeugt aus dem globalen Konfigurationsarray mb_ol_config eine vollständige
 * OpenLayers-Karte samt Layern und OL-Controls
 */
var prepareMap = function(mapElement) {
  // Projektion ermitteln
  // BBOX ermitteln
  ol_options = {
    theme: mb_ol_config["theme"],
    projection: mb_ol_config["projection"],
    units: mb_ol_config["projection_units"],
    maxExtent: new OpenLayers.Bounds(
      mb_ol_config["maxExtent"][0],
      mb_ol_config["maxExtent"][1],
      mb_ol_config["maxExtent"][2],
      mb_ol_config["maxExtent"][3]),
      restrictedExtent: new OpenLayers.Bounds(
        mb_ol_config["maxExtent"][0],
        mb_ol_config["maxExtent"][1],
        mb_ol_config["maxExtent"][2],
        mb_ol_config["maxExtent"][3]),
        scales: mb_ol_config["scales"]
  }

  // Map-Objekt erzeugen, ohne es zu an ein
  // div zu binden. Idee: Rendern erst am 
  // Schluss, um unnötiges mehrfaches Rendern
  // beim Karten-Aufbau zu vermeiden.
  map = new OpenLayers.Map(ol_options);

  // Alle Layer erzeugen
  var layerFactory = new OLLayerFactory();
  $.each(mb_ol_config.layers, function(name, def) {
    def["name"] = name;
    var layer = layerFactory.createLayer(def);
    this.id = layer.id;
    if(name === "Stadtplan") {
      layer.attribution = 'Kartenbild © Hansestadt Rostock (<a href="http://creativecommons.org/licenses/by/3.0/deed.de" target="_blank" style="color:#006CB7;text-decoration:none;">CC BY 3.0</a>) | Kartendaten © <a href="http://www.openstreetmap.org/" target="_blank" style="color:#006CB7;text-decoration:none;">OpenStreetMap</a> (<a href="http://opendatacommons.org/licenses/odbl/" target="_blank" style="color:#006CB7;text-decoration:none;">ODbL</a>) und <a href="https://geo.sv.rostock.de/uvgb.html" target="_blank" style="color:#006CB7;text-decoration:none;">uVGB-MV</a>';
    }
    if(name === "Luftbild") {
      layer.attribution = '© GeoBasis-DE/M-V';
    }
    layer && map.addLayer(layer);
  });

  // Alle Controls erzeugen
  // Controls sind OpenLayers.Control-Instanzen
  var controlFactory = new OLControlFactory();
  $.each(mb_ol_config.controls, function(name, def) {
    var control = controlFactory.createControl(def);
    this.id = control.id;
    control && map.addControl(control);
  });

  // höchste Zoomstufe ermitteln
  var clusterMaxZoom = map.getNumZoomLevels() - 1;

  var clusterLayer = map.getLayer(mb_ol_config.layers["Meldungen"].id);

  // Workaround für XML-Bug in Internet Explorer 11
  var _class = OpenLayers.Format.XML;
  var originalWriteFunction = _class.prototype.write;
  var patchedWriteFunction = function() {
    var child = originalWriteFunction.apply( this, arguments );
    child = child.replace( new RegExp( 'xmlns:NS1="" NS1:', 'g' ), '' );
    return child;
  }
  _class.prototype.write = patchedWriteFunction;

  // Karte an div binden und rendern.
  // Vorher div-Inhalt (Bitte warten...) 
  // löschen.
  mapElement.empty();
  map.render(mapElement.get(0));

  // Auf Ausgangsview zoomen
  // Intervalschaltung, da wir warten müssen, bis die Karte mitbekommen hat,
  // dass sie im neuen Element sitzt...	
  intervalId = setInterval("setupStartExtent()", 250);
};

/**
 * Versucht, den StartExtent anzuzeigen. Da die Karte evt. noch nicht auf die
 * Größe des neuen DIVs gesetzt wurde, wird ein updateSize ausgeführt und bei
 * Erfolgt der StartExtent gesetzt. Muss als Interval ausgeführt werden!
 */
var setupStartExtent = function() {
  map.updateSize();
  var size = map.getSize();

  if(size.w > 1 && size.h > 1) {
    // var bbox = OpenLayers.Bounds.fromArray(array)
    // map.setCenter or map.zoomToExtent

    if(ks_bbox !== null && ks_bbox.length == 4) {
      // PUNKT
      if(ks_bbox[0] == ks_bbox[2]) {
        var ll = new OpenLayers.LonLat(parseFloat(ks_bbox[0]), parseFloat(ks_bbox[1]));
        map.setCenter(ll, 6);
        // POLYGON
      } else {
        var bbox = OpenLayers.Bounds.fromArray(ks_bbox);
        var zoom = Math.min(6,map.getZoomForExtent(bbox));
        map.setCenter(bbox.getCenterLonLat(),zoom);
      }
    } else if(ks_meldung !== null) {
      var ll = new OpenLayers.LonLat(parseFloat(ks_meldung['x']), parseFloat(ks_meldung['y']));
      map.setCenter(ll, 7);
      var layer = map.getLayer(mb_ol_config.layers["Meldungen"].id);
      var callback = function(event) {
        if(event.feature.cluster) {
          $(event.feature.cluster).each(function() {
            if(ks_meldung.id === this.attributes.id) {
              onMeldungSelect(this);
              layer.events.unregister('featureadded', window, callback);
            }
          });
        }
        else if(ks_meldung.id === event.feature.attributes.id) {
          event.feature.layer.drawFeature(event.feature, 'select');
          onMeldungSelect(event.feature);
          layer.events.unregister('featureadded', window, callback);
        }
      };
      layer.events.register('featureadded', window, callback);
    } else {
      var startExtent = new OpenLayers.Bounds(
        mb_ol_config["startExtent"][0],
        mb_ol_config["startExtent"][1],
        mb_ol_config["startExtent"][2],
        mb_ol_config["startExtent"][3]);
        map.zoomToExtent(startExtent);
    }
    clearInterval(intervalId);
  }

};

$(function() {



  // Step 1: Move every element to its target
  prepareElements();

  var mapElement = $('#ol_map');
  if(mapElement.length) {
    if(typeof(preAddMap) == "function")
      preAddMap();
    prepareMap(mapElement);
    if(typeof(prepareProject) == "function")
      prepareProject(mapElement);
  } else {
    alert("Kann Kartenelement #ol_map nicht finden!");
  }
});

//Ende pc/map.js
