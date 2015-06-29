/**
 * Erstellt aus einer Mapbender-Layer-Definition
 * ein OpenLayers Layer-Objekt.
 * TODO: Standardoptionen anlegen und erweitern.
 */
var OLLayerFactory = function() {
  /**
   * Erzeugt einen OSM-Tile-Layer.
   */
  this.createOSMLayer = function(def) {
    var layer = new OpenLayers.Layer.OSM(
      def.name,
      def.url,
      {
        projection: def.projection
      }
    );
    return layer;
  },

  /**
   * Erzeugt einen WMS-Layer.
   */
  this.createWMSLayer = function(def) {
    var layer = new OpenLayers.Layer.WMS(
      def.name,
      def.url,
      {
        layers: def.layers,
        format: def.format
      },
      {
        transitionEffect: 'resize'
      }
    );
    return layer;
  },

  /**
   * Erzeugt einen Vector-Layer.
   */
  this.createVectorLayer = function(def) {
    var stdDef = {
      displayInLayerSwitcher: true,
      geometryType: null,
      protocol: {},
      strategies: {},
      styleMap: null,
      version: null,
      filter: null,
      visibility: true
    }
    var o = $.extend(true, stdDef, def);

    var protocol = null;
    if(o.protocol.type) {
      var protocolOptions = o.protocol.options ? o.protocol.options : {};
      protocol = new OpenLayers.Protocol[o.protocol.type](protocolOptions);
    }

    var strategies = []
    for(var i in o.strategies) {
      strategies.push(new OpenLayers.Strategy[i](o.strategies[i]))
    }

    if(mb_ol_styles[o.styleMap])
      o.styleMap = mb_ol_styles[o.styleMap];
    else
      o.styleMap = null;

    var layer = new OpenLayers.Layer.Vector(
      def.name,
      {
        displayInLayerSwitcher: o.displayInLayerSwitcher,
        filter: o.filter,
        geometryType: o.geometryType,
        protocol: protocol,
        strategies: strategies,
        styleMap: o.styleMap,
        version: o.version,
        visibility: o.visibility
      }
    );
    return layer;
  },

  /**
   * Eigentliche Fabrikfunktion.
   */
  this.createLayer = function(def) {
    var funcName = "create" + def.type + "Layer";
    if(typeof(this[funcName]) == 'function') {
      return this[funcName].apply(this, [def]);
    } else {
      console.error("Can not create layer of type " + def.type);
      return null;
    }		
  };
},

  /**
   * Erstellt aus einer Mapbender-Control-Definition
   * ein OpenLayers Control-Objekt.
   */
OLControlFactory = function() {
  /**
   * Erzeugt eine SelectFeature-Control.
   */
  this.createSelectFeatureControl = function(def) {
    var layer = map.getLayer(mb_ol_config.layers[def.layer].id);
    return new OpenLayers.Control.SelectFeature(layer, def.options);
  },

  /**
   * Erzeugt eine DragFeature-Control.
   */
  this.createDragFeatureControl = function(def) {
    var layer = map.getLayer(mb_ol_config.layers[def.layer].id);
    return new OpenLayers.Control.DragFeature(layer, def.options);
  },

  /**
   * Erzeugt eine DrawFeature-Control.
   */
  this.createDrawFeatureControl = function(def) {
    var layer = map.getLayer(mb_ol_config.layers[def.layer].id);
    return new OpenLayers.Control.DrawFeature(layer, def.handler, def.options);
  },

  /**
   * Erzeugt eine ScaleLine-Control
   */
  this.createScaleLineControl = function(def) {
    return new OpenLayers.Control.ScaleLine(def.options);
  },

  /**
   * Erzeugt ein Scale-Control
   */
  this.createScaleControl = function(def) {
    return new OpenLayers.Control.Scale(def.options);
  },

  this.createAttributionControl = function(def) {
    return new OpenLayers.Control.Attribution();
  }

  /**
   * Eigentliche Fabrikfunktion.
   */
  this.createControl = function(def) {
    var funcName = "create" + def.type + "Control";
    if(typeof(this[funcName]) == 'function') {
      return this[funcName].apply(this, [def]);
    } else {
      console.error("Can not create control of type " + def.type);
      return null;
    }
  };
};
