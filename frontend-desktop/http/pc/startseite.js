function checkBrowser(name) {  
  var agent = navigator.userAgent.toLowerCase();  
  if (agent.indexOf(name.toLowerCase()) > -1) {  
    return true;  
  }
  return false;  
}

var isSafari = /Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor);
var isIEten = /msie 10.0/.test(navigator.userAgent.toLowerCase());
var isIEeleven = /rv:11/.test(navigator.userAgent.toLowerCase());

document.getElementById('results_container').style.width = '297px';

if (isIEten || isIEeleven) {
  document.getElementById('results_container').style.width = '298px';
}

if (isSafari) {
  document.getElementById('results_container').style.width = '298px';
  document.getElementById('results_container').style.marginTop = '42px';
}

if (checkBrowser('firefox')) {
  document.getElementById('statistics').style.marginTop = '-10px';
}

function eye_catcher() {
  var map;

  var getNextMeldung = function() {
    if(window.foo === true) {
      return;
    }

    $.ajax({
      url: 'next_meldung.php',
      cache: false,
      success: function(data) {
        var x = data.x - map.getExtent().getWidth() * markerOffset;
        map.setCenter(new OpenLayers.LonLat(
          x,
          data.y));
      }
    });
  };

  map = new OpenLayers.Map('map', {
    projection: new OpenLayers.Projection('EPSG:25833'),
    maxResolution: 7.0555555556,
    resolutions: [7.0555555556,
      5.2916666667, 3.5277777778, 2.6458333333, 1.7638888889,
      0.8819444444, 0.3527777778, 0.1763888889],
      units: 'm',
      numZoomLevels: 8,
      maxExtent: new OpenLayers.Bounds(200000, 5880000, 480000, 6075000),
      controls: []
  });

  var stadtplan = new OpenLayers.Layer.TMS('Stadtplan', 'http://geo.sv.rostock.de/geodienste/stadtplan/tms/', {
    layername: 'stadtplan_EPSG25833',
    type: 'png',
    transitionEffect: 'resize',
    tileSize: new OpenLayers.Size(256, 256),
    serverResolutions: [529.166666667,
      352.777777778, 264.583333333, 176.388888889, 88.1944444444,
      52.9166666667, 35.2777777778, 28.2222222222, 22.9305555556,
      17.6388888889, 12.3472222222, 8.8194444444, 7.0555555556,
      5.2916666667, 3.5277777778, 2.6458333333, 1.7638888889,
      0.8819444444, 0.3527777778, 0.1763888889]
  });
  stadtplan.setOpacity(0.6);

  var isIEtenOrEleven = /(msie 10.0|rv:11)/.test(navigator.userAgent.toLowerCase());
  var clusterRules = [
    // Rule für Clusteranzeige
    new OpenLayers.Rule({
    filter: new OpenLayers.Filter.Comparison({
      type: OpenLayers.Filter.Comparison.GREATER_THAN,
      property: "count",
      value: 1
    }),
    symbolizer: {
      externalGraphic: "../pc/media/icons/generalisiert.png",
      graphicWidth: 44,
      graphicHeight: 44,
      graphicXOffset: -22,
      graphicYOffset: -22,
      label: (isIEtenOrEleven ? "܁ \n" : "") +"${count}",
      fontFamily: "Verdana",
      fontSize: "158%",
      fontWeight: "bold",
      labelAlign: "cm",
      cursor: "default"
    }
  }),
  // Rule für Standardanzeige
  new OpenLayers.Rule({
    elseFilter: true,
    symbolizer: {}
  })
  ];
  var klarschiffDefaultStyle;
  if ($.browser.msie && $.browser.version.search(/^8.+/) > -1) {
    klarschiffDefaultStyle = new OpenLayers.Style({
      graphicWidth: 36,
      graphicHeight: 43,
      graphicXOffset: -4,
      graphicYOffset: -41,
      fontSize: "1.6em",
      fontWeight: "bold",
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png"
    }, {
      rules: clusterRules
    });
  } else if ($.browser.msie && $.browser.version.search(/^9.+/) > -1) {
    klarschiffDefaultStyle = new OpenLayers.Style({
      graphicWidth: 36,
      graphicHeight: 43,
      graphicXOffset: -4,
      graphicYOffset: -41,
      labelYOffset: -10,
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png"
    }, {
      rules: clusterRules
    });
  } else {
    klarschiffDefaultStyle = new OpenLayers.Style({
      graphicWidth: 36,
      graphicHeight: 43,
      graphicXOffset: -4,
      graphicYOffset: -41,
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png"
    }, {
      rules: clusterRules
    });
  }

  var ows_namespace = window.location.protocol +"//" + window.location.host +"/ows/klarschiff";
  var ows_url = ows_namespace +"/wfs";
  var meldungen = new OpenLayers.Layer.Vector('Meldungen', {
    protocol: new OpenLayers.Protocol.WFS({
      version: "1.1.0",
      url: ows_url,
      featureType: "vorgaenge",
      featureNS: ows_namespace,
      srsName: "epsg:25833"
    }),
    strategies: [
      new OpenLayers.Strategy.BBOX(),
      new OpenLayers.Strategy.Cluster({
        threshold: 2,
        distance: 60
      })
    ],
    styleMap: new OpenLayers.StyleMap(klarschiffDefaultStyle)
  });

  // Workaround für XML-Bug in Internet Explorer 11
  var _class = OpenLayers.Format.XML;
  var originalWriteFunction = _class.prototype.write;
  var patchedWriteFunction = function() {
    var child = originalWriteFunction.apply( this, arguments );
    child = child.replace( new RegExp( 'xmlns:NS1="" NS1:', 'g' ), '' );
    return child;
  }
  _class.prototype.write = patchedWriteFunction;

  map.addLayers([stadtplan, meldungen]);

  map.setCenter(new OpenLayers.LonLat(312963, 5997651), 4);

  getNextMeldung();
  setInterval(getNextMeldung, 6000);
}

$(document).ready(function() {
  var platzhalter = 'Stadtteil, Straße oder Adresse eingeben…';
  var sucheingabefeld = $('input[name="searchtext"]');
  if (checkBrowser('msie')) {
    sucheingabefeld.attr('value',platzhalter);
    sucheingabefeld.css('color', '#888888');
    sucheingabefeld.click(function () {
      $('#results_container').css('display', 'none');
      $(this).attr('value', '');
      sucheingabefeld.css('color', '#000000');
    });
    sucheingabefeld.focus(function () {
      $('#results_container').css('display', 'none');
      $(this).attr('value', '');
      sucheingabefeld.css('color', '#000000');
    });
  }
  else {
    sucheingabefeld.focus();
    sucheingabefeld.attr('placeholder',platzhalter);
    $.Placeholder.init();
  }
});
