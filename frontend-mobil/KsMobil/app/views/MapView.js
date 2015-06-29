var gmap = null;

KsMobil.OpenlayersMapView = M.View.extend({
    type: 'KsMobil.OpenlayersMapView',

    map: null,
    selectControl: null,

    recommendedEvents: ['select'],
    
    render: function() {
        this.html += '<div id="' + this.id + '" class="ol-map-container">';
        this.html += '<div id="' + this.id + '_map" class="ol-map"></div><a id="impressum" href="impressum.html" target="_blank">Impressum</a><div id="navigation" data-role="controlgroup" data-type="vertical"><a href="#" data-role="button" data-theme="a" data-inline="true" data-icon="zoom-in" id="plus" data-iconpos="notext">in Karte hineinzoomen</a><a href="#" data-role="button" data-theme="a" data-inline="true" data-icon="zoom-out" id="minus" data-iconpos="notext">aus Karte herauszoomen</a></div></div>';
        return this.html;
    },

    initMap: function(mapOptions, layers, styling, controls) {
        var self = this;

        var opts = $.extend({
            div: this.id + '_map',
            theme: null,
            controls: []
        }, mapOptions);

        this.map = new OpenLayers.Map(opts);

        $.each(layers, function(key, layer) {
            self.map.addLayer(layer);
        });

        $.each(controls, function(key, control) {
            self.map.addControl(control);
        });

        this.map.zoomToMaxExtent();
        return this.map;
    },

    /**
     * Determine and switch to next baselayer.
     */
    toggleBaseLayer: function() {
        if(this.map === null) {
            return;
        }
        var next = this.nextBaselayer();
        if(next.name == "Luftbild") {
            this.map.getLayersByName("POI")[0].setVisibility(false);
        };
        if(next.name == "Stadtplan") {
            this.map.getLayersByName("POI")[0].setVisibility(true);
        };
        this.map.setBaseLayer(next);
        return next;
    },

    nextBaselayer: function(baselayer) {
        var prev = null;
        var next = null;
        var pastCurrentBaseLayer = false;
        $.each(this.map.layers, function(key, layer) {
            if(layer.isBaseLayer) {
                if(layer === this.map.baseLayer) {
                    pastCurrentBaseLayer = true;
                    return true;
                }
                if(!pastCurrentBaseLayer) {
                    prev = layer;
                    return true;
                }
                if(pastCurrentBaseLayer) {
                    next = layer;
                    return false;
                }
            }
        });
        return next ? next : prev;
    }
});

