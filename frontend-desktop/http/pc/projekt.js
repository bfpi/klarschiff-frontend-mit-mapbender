
// Start pc/projekt.js

var filter = null;

// Variablen mit Eingabefeld-Platzhaltern
var placeholder_betreff = "Bitte geben Sie einen Betreff an.";
var placeholder_details = "Bitte beschreiben Sie Ihre Meldung genauer.";
var placeholder_email = "Bitte geben Sie Ihre E-Mail-Adresse an.";
var placeholder_begruendung = "Bitte geben Sie eine Begründung an.";
var placeholder_freitext = "Bitte tragen Sie hier Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung ein.";

// Variablen mit Fehlertexten
var hauptkategorieLeer = "Sie müssen eine Hauptkategorie auswählen.";
var unterkategorieLeer = "Sie müssen eine Unterkategorie auswählen.";
var betreffLeer = "Sie müssen einen Betreff angeben.";
var detailsLeer = "Sie müssen Ihre Meldung genauer beschreiben.";
var emailFalsch = "Die angegebene E-Mail-Adresse ist syntaktisch falsch. Bitte korrigieren Sie Ihre Eingabe.";
var emailLeer = "Sie müssen Ihre E-Mail-Adresse angeben.";
var begruendungLeer = "Sie müssen eine Begründung angeben.";
var freitextLeer = "Sie müssen Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung angeben.";

/**
 * für IE Schriftgröße für Labels der Stadtteile festlegen
 */
function checkBrowser(name) {  
  var agent = navigator.userAgent.toLowerCase();  
  if (agent.indexOf(name.toLowerCase()) > -1) {  
    return true;  
  }
  return false;  
}

/**
 * Baut Gesamtfilter aus Filterfragmenten für WFS-Layer.
 * Die Filterfragmente werden mit OR verbunden und als neuer Filter
 * der Filterstrategie gesetzt.
 * @returns null
 */
var buildFilter = function() {
  var layer = map.getLayer(mb_ol_config.layers["Meldungen"].id);
  // Alle angehakten Teilfilter abholen...
  var cbs = $('#kartenelemente input');
  var filters = [];
  cbs.each(function() {
    var self = $(this);
    if (self.is(':checked')) {
      var id = self.attr('name');
      filters.push(ks_config.filter[id].filter);
    }
  });

  if (!filter) {
    filter = new OpenLayers.Filter.Logical({
      type: OpenLayers.Filter.Logical.OR
    });
    layer.filter = filter;
  }
  filter.filters = filters;

  if (map.getExtent())
    layer.refresh({force: true});
},

preAddMap = function() {
  var ows_namespace = window.location.protocol +"//"+ window.location.host +"/ows/klarschiff";
  var ows_url = ows_namespace +"/wfs";
  var extra_config = {
    layers: {			
      "POI": {
        type: "WMS",
        url: "http://geo.sv.rostock.de/geodienste/klarschiff_poi/ows",
        layers: "abfallbehaelter,ampeln,beleuchtung,brunnen,denkmale,hundetoiletten,recyclingcontainer,sitzgelegenheiten,sperrmuelltermine",
        format: "image/png",
        transparent: true,
        displayInLayerSwitcher: false,
        isBaseLayer: false,
        minScale: 1100,
        singleTile: true
      },
      "Meldungen": {
        //filter: filter,
        type: "Vector",
        styleMap: "klarschiff",
        strategies: {
          BBOX: {},
          Cluster: {
            threshold: 2,
            distance: 60
          }
        },
        protocol: {
          type: "WFS",
          options: {
            version: "1.1.0",
            url: ows_url,
            featureType: "vorgaenge",
            featureNS: ows_namespace,
            srsName: "epsg:25833"
          }
        }},
        "GeoRSS-Polygone": {
          type: "Vector",
          styleMap: "rss",
          visibility: false,
          strategies: {
            BBOX: {}
          },
          protocol: {
            type: "WFS",					
            options: {
              version: "1.1.0",
              url: ows_url,
              featureType: "klarschiff_stadtteile_hro",
              featureNS: ows_namespace,
              srsName: "epsg:25833"
            }
          }},
          "SketchMeldung": {
            type: "Vector",
            geometryType: OpenLayers.Geometry.Point,
            displayInLayerSwitcher: false,
            styleMap: "klarschiff"},
            "SketchBeobachtungsfläche": {
              type: "Vector",
              geometryType: OpenLayers.Geometry.Polygon,
              styleMap: "rss",				
              displayInLayerSwitcher: false}
    },
    controls: {
      "Attribution": {
        type: "Attribution"
      },
      "SelectMeldung": {
        type: "SelectFeature",
        layer: "Meldungen",
        options: {
          multiple: false,
          autoActivate: true,
          box: false
        }},
        "SelectPolygon": {
          type: "SelectFeature",
          layer: "GeoRSS-Polygone",
          options: {
            multiple: true,
            toggle: true,
            box: false,
            clickout: false,
            autoActivate: false
          }},
          "DragFeature": {
            type: "DragFeature",
            layer: "SketchMeldung",
            options: {
              onStart: onNeueMeldungDragStart,
              onComplete: onNeueMeldungDragComplete
            }},
            "DrawBeobachtungsflaeche": {
              type: "DrawFeature",
              layer: "SketchBeobachtungsfläche",
              handler: OpenLayers.Handler.Polygon,
              options: {
                featureAdded: onRssNeueFlaeche
              }},
              "ScaleLine": {
                type: "ScaleLine",
                options: {
                  bottomInUnits: ""
                }
              }
    },
    markerSize: 60
  }

  $.extend(true, mb_ol_config, extra_config);

  var isIEtenOrEleven = /(msie 10.0|rv:11)/.test(navigator.userAgent.toLowerCase());
  clusterRules = [
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
        fontSize: "141%",
        fontWeight: "bold",
        labelAlign: "cm",
        cursor: "pointer",
        graphicTitle: "fasst " + "${count}" + " Meldungen zusammen:\nklicken zum Zoomen,\nin letzter Zoomstufe zum Anzeigen"
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
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png",
      cursor: "pointer",
      graphicTitle: "Meldung " + "${id}"
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
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png",
      cursor: "pointer",
      graphicTitle: "Meldung " + "${id}"
    }, {
      rules: clusterRules
    });
  } else {
    klarschiffDefaultStyle = new OpenLayers.Style({
      graphicWidth: 36,
      graphicHeight: 43,
      graphicXOffset: -4,
      graphicYOffset: -41,
      externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}.png",
      cursor: "pointer",
      graphicTitle: "Meldung " + "${id}"
    }, {
      rules: clusterRules
    });
  }
  mb_ol_styles = {
    rss: new OpenLayers.StyleMap({
      "default": new OpenLayers.Style({
        fontFamily: "Verdana",
        fontSize: "12px",
        fontStyle: "italic",
        fontWeight: "bold",
        fontColor: "#FFEAD7",
        label: "${bezeichnung}",
        labelAlign: "cm",
        fillColor: "#FF8700",
        fillOpacity: 0.5,
        strokeColor: '#FF8700',
        cursor: "pointer"
      }),
      "select": new OpenLayers.Style({
        fontFamily: "Verdana",
        fontSize: "12px",
        fontStyle: "italic",
        fontWeight: "bold",
        fontColor: "#FFD7FF",
        label: "${bezeichnung}",
        labelAlign: "cm",
        fillColor: "#FF00FF",
        fillOpacity: 0.5,
        strokeColor: '#FF8700',
        cursor: "pointer"
      }),
      "temporary": new OpenLayers.Style({
        fillColor: "#FF8700",
        fillOpacity: 0.5,
        strokeColor: '#FF8700',
        cursor: "pointer"
      })
    }),
    klarschiff: new OpenLayers.StyleMap({
      "default": klarschiffDefaultStyle,
      "select": new OpenLayers.Style({
        graphicWidth: 56,
        graphicHeight: 64,
        graphicXOffset: -14,
        graphicYOffset: -51,
        externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}_s.png",
        cursor: "pointer"
      }, {
        rules: clusterRules
      }),
      "temporary": new OpenLayers.Style({
        graphicWidth: 56,
        graphicHeight: 64,
        graphicXOffset: -14,
        graphicYOffset: -51,
        externalGraphic: "../pc/media/icons/${vorgangstyp}_${status}_s.png",
        cursor: "pointer",
        graphicTitle: "neue Meldung"
      })
    })
  };
},

getKategorien = function(parent, typ) {
  var kategorien = {}
  kategorien[0] = "auswählen…";
  for(var i in ks_lut.kategorie) {
    if (ks_lut.kategorie[i].parent == parent) {
      if (parent == undefined && ks_lut.kategorie[i].typ != typ) {
        continue;
      }
      kategorien[i] = ks_lut.kategorie[i].name;
    }
  }
  return kategorien;
},

  /**
   * Event-Handler (OpenLayers), wird bei der Selektion einer Meldung ausgeführt.
   * Zeigt die Meldungsdetails an.
   * @param feature
   * @returns null
   */
onMeldungSelect = function(feature) {
  // Alles abwählen
  var selectControl = map.getControl(mb_ol_config.controls["SelectMeldung"].id);
  selectControl.unselectAll();
  // Variablen für Meldungsattribute und Index beim Blättern
  var attribs;
  var currentIndex;
  if (feature.cluster) {
    // Wenn nicht letzte Zoomstufe, nur zoomen und raus
    if(map.getZoom() < map.getNumZoomLevels() - 1) {
      map.panTo(feature.geometry.getBounds().getCenterLonLat());
      map.zoomIn();
      return;
    }
    currentIndex = 0;
    attribs = feature.cluster[0].data;
  } 
  else {
    attribs = feature.data;
  }
  var dlg = showMeldung($.extend({}, attribs));
  unhideFeatureUnderDialog(feature, dlg);
  if (feature.cluster) {
    enhanceDialogForCluster(dlg, feature.cluster, currentIndex);
  }
},

enhanceDialogForCluster = function(dlg, cluster, currentIndex) {
  dlg.find('#meldung_details_recorder').show().text("Meldung "+ (currentIndex + 1) +" von "+ cluster.length);
  var showClusterMeldung = function(index) {
    var detailsClicked = $('#meldung_details').is(":visible");
    var dlg = showMeldung($.extend({}, cluster[index].data));
    enhanceDialogForCluster(dlg, cluster, currentIndex);
    if(detailsClicked) $('#meldung_details_show').click();
  }
  if(currentIndex > 0) {
    dlg.find('#meldung_details_prev').show().button().click(function() {
      showClusterMeldung(--currentIndex);
    });
  }
  else {
    dlg.find('#meldung_details_prev').show().button({ disabled: true });
  }
  if(currentIndex < cluster.length - 1) {
    dlg.find('#meldung_details_next').show().button().click(function() {
      showClusterMeldung(++currentIndex);
    });
  }
  else {
    dlg.find('#meldung_details_next').show().button({ disabled: true });
  }
},

showMeldung = function(attribs) {
  var schwellenwert = typeof ks_config.schwellenwert !== 'undefined' ?
    ks_config.schwellenwert : 20;
  var img = '<img id="meldung_details_icon" src="../pc/media/icons/'+
    attribs.vorgangstyp +'_'+ attribs.status +'_layer.png"></img>';

  var title = img + (attribs.vorgangstyp == 'idee'? "Idee" : "Problem") +
    " (Meldung " + attribs.id + " – " + attribs.datum_erstellt + ") " +
    "<a class='directlink' title='Permalink auf Meldung " + attribs.id + 
    "' href='" + Mapbender.loginUrl + "?mb_user_myGui=Klarschiff&" +
    "name=public&password=public&meldung=" + attribs.id + "'>LINK</a>";
  //attribs.unterstuetzer = Math.round(5+(Math.random()*(10)));
  attribs.schwellenwert = schwellenwert;

  if (ks_lut.kategorie[attribs.kategorieid].parent) {
    attribs.unterkategorie = ks_lut.kategorie[attribs.kategorieid].name;
    var hk = ks_lut.kategorie[attribs.kategorieid].parent;
    attribs.hauptkategorie = ks_lut.kategorie[hk].name;
  } else {
    attribs.hauptkategorie = ks_lut.kategorie[attribs.kategorieid].name;
    attribs.unterkategorie = "auswählen…";
  }
  attribs.status_id = attribs.status;
  attribs.status = ks_lut.status[attribs.status_id].name;
  var dlg = $('#meldung_show').empty()
  .removeClass('idee')
  .removeClass('problem')
  .addClass(attribs.vorgangstyp);

  $('#template_meldung_show')
  .tmpl(attribs)
  .appendTo(dlg);

  var schwellenwertClass = "unter-schwellenwert";
  if (parseInt(attribs.unterstuetzer) >= schwellenwert) {
    schwellenwertClass = "ueber-schwellenwert";
  }
  dlg.find('span.meldung_unterstuetzer').addClass(schwellenwertClass);

  $('#meldung_details').hide();
  dlg.addClass("teaser");
  $('#meldung_details_show').button({
    icons: {
      secondary: 'ui-icon-circle-triangle-s'
    }
  }).click(function() { meldungDetailsClick(dlg) });
  // auf Fall prüfen, in dem die Buttons deaktiviert werden sollen
  if (attribs.status_id == 'gemeldet')
    var buttonsDeaktivieren = true;

  // je nach Fall Deaktivierungen durchführen und/oder weitere Dialoge aufbauen
  if (buttonsDeaktivieren) {
    $('#meldung_actions').buttonset().buttonset('enable');
    $('#meldung_unterstuetzen').button('option', 'disabled', true);
    $('#meldung_melden').button('option', 'disabled', true);
    $('#meldung_lobenhinweisenkritisieren').button('option', 'disabled', true);
  }
  else {
    $('#meldung_actions').buttonset().buttonset('enable');
    $('#meldung_unterstuetzen').click(meldungSupportDialog);
    $('#meldung_melden').click(meldungAbuseDialog);
    $('#meldung_lobenhinweisenkritisieren').click(meldungLobHinweiseKritikDialog);
  }

  // Dialog Titel geben und öffnen
  dlg.dialog('option', 'title', title)
  .dialog('option', 'height', 'auto')
  .dialog('option', 'width', dlg.data('oWidth'))
  .dialog("open");
  return dlg;
},

meldungDetailsClick = function(dlg) {
  var self = $(this);
  var contentHeight = dlg.css('height', 'auto').height();
  var outerHeight = dlg.parent().height();
  var extraHeight = outerHeight - contentHeight;
  $('#meldung_details').toggle();
  dlg.toggleClass("teaser");
  //Trigger resize
  contentHeight = dlg.css('height', 'auto').height();
  dlg.dialog('option', 'height', Math.min($('body').height() - 20 - extraHeight, contentHeight + extraHeight));

  if (dlg.parent().offset().top + dlg.parent().height() > $('body').height()) {
    dlg.dialog('option', 'position', {
      my: 'top',
      at: 'top',
      of: $('body'),
      offset: '0 10'});
  }
  $('.ui-button-icon-secondary')
  .toggleClass("ui-icon-circle-triangle-s")
  .toggleClass("ui-icon-circle-triangle-n");
  var label = self.find('.ui-button-text');
  if (label.html() == "Details") {
    label.html("keine Details");
  } else {
    label.html("Details");
  }
};

  /**
   * Verschiebt Karte und ggf. Dialog soweit, dass
   * das Meldungs-Feature nicht verdeckt wird.
   * @returns null
   */
unhideFeatureUnderDialog = function(feature, dlg) {
  // Prüfen, ob das dlg-Element in einem Dialog-Rahmen steckt.
  dlgParent = dlg.parent('.ui-dialog');
  if (dlgParent)
    dlg = dlgParent;

  featureOffset = map.getPixelFromLonLat(new OpenLayers.LonLat(
    feature.geometry.x,
    feature.geometry.y));	
    dlgOffset = dlg.offset();
    mapOffset = $(map.div).offset();

    if (dlgOffset.left - mapOffset.left > mb_ol_config.markerSize) { // Move map to left		
      // dx := X-Abstand zwischen Feature und linken Dialogrand
      var dx = dlgOffset.left - (mapOffset.left + featureOffset.x);
      if (dx < mb_ol_config.markerSize) {
        map.pan(mb_ol_config.markerSize - dx, 0);
      }
    } else { // Move map as far left as possible, then dialog to the right
      map.pan(featureOffset.x, 0);
      dlg.animate({
        left: mb_ol_config.markerSize
      });
    }
},

  /**
   * Setzt Unterstützungsmeldung an Server ab.
   * @returns null
   */
meldungSupportDialog = function() {
  var showDlg = $('#meldung_show');
  var id = $('input[name="id"]').val();
  var email = $('input[name="meldung_actions_email"]').val();
  showDlg.dialog("close");

  var dlg = $('<div></div>')
  .attr("id", 'meldung_support')
  .append($('#template_meldung_support').tmpl({id: id, email: email}))
  .dialog({
    title: "Meldung unterstützen",
    width: 400,
    buttons: {
      "unterstützen": meldungSupportSubmit,
      "abbrechen": function() {
        $(this).remove();
        showDlg.dialog('open');
      }
    },
    close: function(evt, ui) {
      $(this).dialog('destroy').remove();
      onMeldungShowClose({originalEvent: true});
    }
  });

  $('input[name="email"]').attr("placeholder", placeholder_email);
  $.Placeholder.init();
},

meldungSupportSubmit = function() {
  var dlg = $('#meldung_support');
  var id = $('input[name="id"]').val();
  var email = $('input[name="email"]', dlg).val();

  // clientseitige Validierung
  var filter = /^\S+@\S+\.[A-Za-z]{2,6}$/;
  if (!email || email === placeholder_email) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailLeer");
    return;
  }
  else if (!filter.test(email)) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailFalsch");
    return;
  }
  else $('input[name="email"]', dlg).removeClass("error");

  dlg.dialog('option', 'buttons', {});
  dlg.html('Bitte warten, die Unterstützungsmeldung wird gerade abgesetzt…');
  dlg.dialog('option', 'title', 'Unterstützungsmeldung');
  onMeldungShowClose({originalEvent: true});
  $.ajax({
    url: "../pc/frontend/meldung_support.php",
    type: "post",
    data: {
      id: id,
      email: email
    },
    complete: function(jqXHR, status) {
      dlg.empty();
      response = jqXHR.responseText;
      var message = "Die Unterstützungsmeldung wurde erfolgreich abgesetzt. Sie erhalten in Kürze eine E-Mail, in der Sie Ihre Unterstützungsmeldung noch einmal bestätigen müssen.";
      if (response.length > 0) {
        var messages = response.split('#');
        message = messages[2];
      }
      dlg.html(message);
      dlg.dialog('option', 'buttons', {
        schließen: function() {
          $(this).dialog('close');
        }
      });
    }
  });
},


  /**
   * Zeigt Dialog für Missbrauchsmeldung
   */
meldungAbuseDialog = function() {
  var showDlg = $('#meldung_show');
  var id = $('input[name="id"]').val();
  var email = $('input[name="meldung_actions_email"]').val();	
  showDlg.dialog("close");

  var dlg = $('<div></div>')
  .attr("id", 'meldung_abuse')
  .append($('#template_meldung_abuse').tmpl({id: id, email: email}))
  .dialog({
    title: "Missbrauch melden",
    width: 400,
    buttons: {
      "melden": meldungAbuseSubmit,
      "abbrechen": function() {
        $(this).remove();
        showDlg.dialog('open');
      }
    },
    close: function(evt, ui) {
      $(this).dialog('destroy').remove();
      onMeldungShowClose({originalEvent: true});
    }
  });

  $('input[name="email"]').attr("placeholder", placeholder_email);
  $('textarea[name="details"]').attr("placeholder", placeholder_begruendung);
  $.Placeholder.init();
},

  /**
   * Setzt Missbrauchsmeldung ab.
   */
meldungAbuseSubmit = function() {
  var dlg = $('#meldung_abuse');
  var id = $('input[name="id"]', dlg).val();
  var email = $('input[name="email"]', dlg).val();
  var details = $('textarea[name="details"]', dlg).val();

  // clientseitige Validierung
  var filter = /^\S+@\S+\.[A-Za-z]{2,6}$/;                                                                 
  if (!email || email === placeholder_email) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailLeer");
    return;
  }
  else if (!filter.test(email)) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailFalsch");
    return;
  }
  else $('input[name="email"]', dlg).removeClass("error");
  if (!details || details === placeholder_begruendung) {
    $('textarea[name="details"]', dlg).addClass("error");
    eingabeFehlerPopup("begruendungLeer");
    return;
  }
  else $('textarea[name="details"]', dlg).removeClass("error");

  dlg.dialog('option', 'buttons', {});
  dlg.html('Bitte warten, die Missbrauchsmeldung wird gerade abgesetzt…');
  dlg.dialog('option', 'title', 'Missbrauchsmeldung');
  onMeldungShowClose({originalEvent: true});
  $.ajax({
    url: "../pc/frontend/meldung_abuse.php",
    type: "post",
    data: {
      id: id,
      email: email,
      details: details
    },
    complete: function(jqXHR, status) {
      dlg.empty();
      response = jqXHR.responseText;
      var message = "Die Missbrauchsmeldung wurde erfolgreich abgesetzt. Sie erhalten in Kürze eine E-Mail, in der Sie Ihre Missbrauchsmeldung noch einmal bestätigen müssen.";
      if (response.length > 0) {
        var messages = response.split('#');
        message = messages[2];
      }
      dlg.html(message);
      dlg.dialog('option', 'buttons', {
        schließen: function() {
          $(this).dialog('close');
        }
      });	
    }
  });
},

  /**
   * Zeigt Dialog für Lob, Hinweise oder Kritik zu einer Meldung
   */
meldungLobHinweiseKritikDialog = function() {
  var showDlg = $('#meldung_show');
  var id = $('input[name="id"]').val();
  var email = $('input[name="meldung_actions_email"]').val();
  var zustaendigkeit = $('input[name="zustaendigkeit"]').val();
  showDlg.dialog("close");

  var dlg = $('<div></div>')
  .attr("id", 'meldung_lobhinweisekritik')
  .append($('#template_meldung_lobhinweisekritik').tmpl({id: id, email: email, zustaendigkeit: zustaendigkeit}))
  .dialog({
    title: "Lob, Hinweise oder Kritik zur Meldung",
    width: 400,
    buttons: {
      "senden": meldungLobHinweiseKritikSubmit,
      "abbrechen": function() {
        $(this).remove();
        showDlg.dialog('open');
      }
    },
    close: function(evt, ui) {
      $(this).dialog('destroy').remove();
      onMeldungShowClose({originalEvent: true});
    }
  });

  $('input[name="email"]').attr("placeholder", placeholder_email);
  $('textarea[name="freitext"]').attr("placeholder", placeholder_freitext);
  $.Placeholder.init();
},

  /**
   * Setzt Lob, Hinweise oder Kritik zu einer Meldung ab.
   */
meldungLobHinweiseKritikSubmit = function() {
  var dlg = $('#meldung_lobhinweisekritik');
  var id = $('input[name="id"]', dlg).val();
  var email = $('input[name="email"]', dlg).val();
  var freitext = $('textarea[name="freitext"]', dlg).val();

  // clientseitige Validierung
  var filter = /^\S+@\S+\.[A-Za-z]{2,6}$/;
  if (!email || email === placeholder_email) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailLeer");
    return;
  }
  else if (!filter.test(email)) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailFalsch");
    return;
  }
  else $('input[name="email"]', dlg).removeClass("error");
  if (!freitext || freitext === placeholder_freitext) {
    $('textarea[name="freitext"]', dlg).addClass("error");
    eingabeFehlerPopup("freitextLeer");
    return;
  }

  dlg.dialog('option', 'buttons', {});
  dlg.html('Bitte warten, Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung wird/werden gerade abgesetzt…');
  dlg.dialog('option', 'title', 'Lob, Hinweise oder Kritik');
  onMeldungShowClose({originalEvent: true});
  $.ajax({
    url: "../pc/frontend/meldung_lobhinweisekritik.php",
    type: "post",
    data: {
      id: id,
      email: email,
      freitext: freitext
    },
    complete: function(jqXHR, status) {
      dlg.empty();
      response = jqXHR.responseText;
      var message = "Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung wurde(n) erfolgreich abgesetzt und dem genannten Empfänger zugestellt.";
      if (response.length > 0) {
        var messages = response.split('#');
        message = messages[2];
      }
      dlg.html(message);
      dlg.dialog('option', 'buttons', {
        schließen: function() {
          $(this).dialog('close');
        }
      });	
    }
  });
},

openMeldungDialog = function(feature, targetId, dragControl) {
  var title = (feature.data.vorgangstyp == "idee" ? "Idee" : "Problem") + " beschreiben";
  var attribs = {
    typ: targetId,
    point: feature.geometry.toString()
  }
  var dlg = $('#meldung_edit');
  $('#template_meldung_edit')
  .tmpl(attribs)
  .appendTo(dlg);

  var insertOptions = function(target, parent) {
    var t = $('select[name="' + target + '"]');
    if (!t)
      return;
    t.empty();

    var kategorien = getKategorien(parent, feature.data.vorgangstyp);
    $.each(kategorien, function(key, val) {
      $('<option></option>')
      .attr('value', key)
      .html(val)
      .appendTo(t);
    });

    return t;
  };

  $('<option></option>')
  .attr('value', 0)
  .html("auswählen…")
  .appendTo($('select[name="unterkategorie"]'));

  $('input[name="email"]').attr("placeholder", placeholder_email);
  $.Placeholder.init();

  $(".betreff-pflicht, .details-pflicht, .pflicht-fussnote").css("visibility", "hidden");
  $('input[name="betreff"], textarea[name="details"], input[name="email"]').focus(function() {
    $(this).css({"color":"#000000"}); 
  }).blur(function() {
  });
  $("select[name='unterkategorie']").change(function() {
    var kategorie_id = $(this).val();
    var kategorie = ks_lut.kategorie[kategorie_id];

    if (!kategorie) {
      $(".betreff-pflicht, .details-pflicht, .pflicht-fussnote").css("visibility", "hidden");
      $('input[name="betreff"]').attr("placeholder", "");
      if ($('input[name="betreff"]').val() == placeholder_betreff) {
        $('input[name="betreff"]').val("");
      }

      $('textarea[name="details"]').attr("placeholder", "");
      if ($('textarea[name="details"]').val() == placeholder_details) {
        $('textarea[name="details"]').val("");
      }
      $.Placeholder.init();
      return;
    }

    if (kategorie.naehere_beschreibung_notwendig) {
      // unset labels that might have been set by kategorie.auffiorderung
      // then set them again 
      switch (kategorie.naehere_beschreibung_notwendig) {
        case "betreff":
          $(".details-pflicht").css("visibility", "hidden");
          $(".betreff-pflicht, .pflicht-fussnote").css("visibility", "visible");
          $('input[name="betreff"]').attr("placeholder", placeholder_betreff);
          $('textarea[name="details"]').attr("placeholder", "");
          if ($('textarea[name="details"]').val() == placeholder_details) {
            $('textarea[name="details"]').val("");
          }
          $.Placeholder.init();
          break;

        case "details":
          $(".betreff-pflicht").css("visibility", "hidden");
          $(".details-pflicht, .pflicht-fussnote").css("visibility", "visible");
          $('input[name="betreff"]').attr("placeholder", "");
          if ($('input[name="betreff"]').val() == placeholder_betreff) {
            $('input[name="betreff"]').val("");
          }
          $('textarea[name="details"]').attr("placeholder", placeholder_details);
          $.Placeholder.init();
          break;

        case "betreffUndDetails":
          $(".betreff-pflicht, .details-pflicht, .pflicht-fussnote").css("visibility", "visible");
          $('input[name="betreff"]').attr("placeholder", placeholder_betreff);
          $('textarea[name="details"]').attr("placeholder", placeholder_details);
          $.Placeholder.init();
          break;

        default:
          $(".betreff-pflicht, .details-pflicht, .pflicht-fussnote").css("visibility", "hidden");
          $('input[name="betreff"]').attr("placeholder", "");
          if ($('input[name="betreff"]').val() == placeholder_betreff) {
            $('input[name="betreff"]').val("");
          }
          $('textarea[name="details"]').attr("placeholder", "");
          if ($('textarea[name="details"]').val() == placeholder_details) {
            $('textarea[name="details"]').val("");
          }
          $.Placeholder.init();

      }
    }

  });
  insertOptions("hauptkategorie").change(function(e) {
    insertOptions("unterkategorie", e.currentTarget.value);
    $("select[name='unterkategorie']").change();

  });

  // Popup entfernen
  feature.popup.destroy();
  feature.popup = null;

  // Dialog Titel geben und öffnen
  if (typeof dlg.data('oHeight') !== 'undefined') {
    dlg.dialog('option', 'height', dlg.data('oHeight'));
  }
  dlg.dialog('option', 'title', title)
  .dialog('option', 'width', dlg.data('oWidth'))
  .dialog("open")
  .data('oHeight', dlg.dialog('option', 'height'));
  // URL aus dem Textfeld entfernen
  if ($("#meldung_edit form textarea").val() == window.location) {
    $("#meldung_edit form textarea").val("");
  }
  dragControl.deactivate();
  unhideFeatureUnderDialog(feature, dlg);
},

  /**
   * Event-Handler (jQuery), wird aufgerufen, wenn der Link zum Eintragen einer
   * neuen Meldung auf der Karte geklickt wird. Das Control zum abgreifen eines
   * neuen Kartenpunktes wird aktiviert und ruft als Event-Handler onNeueMeldung2
   * beim Click in die Karte auf.
   * @param event
   * @returns null
   */
onNeueMeldung = function(event) {
  var dragControl = map.getControl(mb_ol_config.controls["DragFeature"].id);
  var targetLayer = map.getLayer(mb_ol_config.layers["SketchMeldung"].id);
  var targetId = $(event.currentTarget).attr('id');
  var mapDiv = $(map.div);

  // Alte Meldungen entfernen
  clearMeldungSketch();	

  // Mittelpunkt der Karte ermitteln.
  var p_center = map.getLonLatFromPixel(new OpenLayers.Pixel(
    mapDiv.width() / 2,
    mapDiv.height() / 2));

    // Neues Feature im Mittelpunkt anlegen.
    var feature = new OpenLayers.Feature.Vector(
      new OpenLayers.Geometry.Point(p_center.lon, p_center.lat),
      {
        vorgangstyp: targetId,
        status: "gemeldet"
      });
      feature.renderIntent = "temporary";

      // Feature zum Sketch-Layer hinzufügen.
      targetLayer.addFeatures(feature);
      var popupHeading = "<h2>" + (targetId == "problem" ? "Problem" : "Idee") + " melden</h2>";
      feature.popup = new OpenLayers.Popup.FramedCloud(
        feature.id + "_popup",
        feature.geometry.getBounds().getCenterLonLat(),
        null,
        popupHeading + '<div class="buttons"><a href="#" id="details">beschreiben</a><a href="#" id="verwerfen">abbrechen</a></div>',
        null,
        false);
        //feature.popup.minSize = new OpenLayers.Size(380, 130);
        feature.popup.autoSize = true;
        feature.popup.positionBlocks["tl"]["offset"] = new OpenLayers.Pixel(30, -55);
        feature.popup.positionBlocks["tr"]["offset"] = new OpenLayers.Pixel(0, -55);
        feature.popup.positionBlocks["bl"]["offset"] = new OpenLayers.Pixel(30, 0);
        feature.popup.positionBlocks["br"]["offset"] = new OpenLayers.Pixel(0, 0);
        map.addPopup(feature.popup);

        // Feature verschiebbar machen
        dragControl.activate();

        $("a#details").button().click(function() {
          var dlg = $('<div></div>')
          .html('Bitte warten, die Koordinaten der neuen Meldung werden gerade geprüft…')
          .dialog({
            title: 'Koordinatenprüfung',
            modal: true,
            closeOnEscape: false,
            open: function(event, ui) {
              $(this).find(".ui-dialog-titlebar-close").hide();
            },
            close: function(event, ui) {
              $(this).dialog('destroy').remove();
            }
          });

          var show_message = function(msg) {
            dlg.html(msg);
            dlg.dialog('option', 'buttons', {
              schließen: function() {
                $(this).dialog('close');
              }
            });
          }
          $.ajax({
            url: '../pc/frontend/point_check.php',
            data: {
              point: feature.geometry.toString()
            },
            context: this,
            success: function(data) {
              if (data.length > 0) {
                // Probleme!
                var messages = data.split('#');
                var message = messages[2];
                show_message(message);
              } else {
                // Keine Probleme
                dlg.dialog('close');
                openMeldungDialog(feature, targetId, dragControl);
              }
            },
            error: function() {
              show_message('Es trat ein allgemeiner Fehler auf.');
            }
          });
        });
        $("a#verwerfen").button().click(function() {
          clearMeldungSketch();
          dragControl.deactivate();
        });
        feature.popup.updateSize();
},


  /**
   * Löscht alle Meldungen im Sketch-Layer
   */
clearMeldungSketch = function() {
  var layer = map.getLayer(mb_ol_config.layers["SketchMeldung"].id);
  for(var i in layer.features) {
    var feature = layer.features[i];
    if (feature.popup) {
      feature.popup.destroy();
      feature.popup = null;
    }
    feature.destroy();
  }
},

  /**
   * Event-Handler (OpenLayers), wird beim Verschieben eines Features im 
   * SketchMeldung-Layer vor dem Verschieben ausgeführt.
   * @param feature
   * @param pixel
   * @returns null
   */
onNeueMeldungDragStart = function(feature, pixel) {
  if (feature.popup) {
    feature.popup.hide();
  }
},

  /**
   * Event-Handler (OpenLayers), wird beim Verschieben eines Features im 
   * SketchMeldung-Layer nach dem Verschieben ausgeführt.
   * @param feature
   * @param pixel
   * @returns null
   */
onNeueMeldungDragComplete = function(feature, pixel) {	
  if (feature.popup) {
    var ll = new OpenLayers.LonLat(feature.geometry.x, feature.geometry.y);
    feature.popup.lonlat = ll;
    feature.popup.updatePosition();
    feature.popup.show();
  }
},

  /**
   * Event-Handler, entfernt das Eingabeformular aus dem Eingabe-Dialog, da
   * dieser beim Öffnen des Dialogs dynamisch erstellt und  eingefügt wird.
   * @returns null
   */
onMeldungFormClose = function() {
  // Dialog leeren
  $('#meldung_edit').empty();
  // Sketch-Layer leeren
  clearMeldungSketch();
},

  /**
   * Event-Handler, wird beim Click auf den "Meldung absetzen"-Button ausgeführt,
   * um die Daten zum Server zu schicken.
   * TODO: Eingabe-Validierung.
   */
meldungFormSubmit = function() {
  // Attributdaten aus Formular abholen
  var dlg = $(this);
  var postData = {
    task: "submit",
    typ: $('input[name="typ"]', dlg).val(),
    point: $('input[name="point"]', dlg).val(),
    hauptkategorie: $('select[name="hauptkategorie"]').val(),
    unterkategorie: $('select[name="unterkategorie"]').val(),
    betreff: $('input[name="betreff"]', dlg).val(),
    details: $('textarea[name="details"]', dlg).val(),
    email: $('input[name="email"]', dlg).val(),
    foto: null
  };

  // clientseitige Validierung
  var error = false;
  if (postData.hauptkategorie == "0") {
    $('select[name="hauptkategorie"]').addClass("error");
    eingabeFehlerPopup("hauptkategorieLeer");
    return;
  } else {
    $('select[name="hauptkategorie"]').removeClass("error");
  }
  if (postData.unterkategorie == "0") {
    $('select[name="unterkategorie"]').addClass("error");
    eingabeFehlerPopup("unterkategorieLeer");
    return;
  } else {
    $('select[name="unterkategorie"]').removeClass("error");
  }
  var filter = /^\S+@\S+\.[A-Za-z]{2,6}$/;
  if (!postData.email || postData.email === placeholder_email) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailLeer");
    return;
  }
  else if (!filter.test(postData.email)) {
    $('input[name="email"]', dlg).addClass("error");
    eingabeFehlerPopup("emailFalsch");
    return;
  }
  else $('input[name="email"]', dlg).removeClass("error");
  if ('undefined' !== typeof ks_lut.kategorie[parseInt(postData.unterkategorie)]) {
    switch (ks_lut.kategorie[parseInt(postData.unterkategorie)].naehere_beschreibung_notwendig) {

      case "betreff":
        if (!postData.betreff || postData.betreff === placeholder_betreff) {
          $('input[name="betreff"]').addClass("error");
          eingabeFehlerPopup("betreffLeer");
          return;
        }
        else $('input[name="betreff"]').removeClass("error");
        break;

      case "details":
        if (!postData.details || postData.details === placeholder_details) {
          $('textarea[name="details"]').addClass("error");
          eingabeFehlerPopup("detailsLeer");
          return;
        }
        else $('textarea[name="details"]').removeClass("error");
        break;

      case "betreffUndDetails":
        if (!postData.betreff || postData.betreff === placeholder_betreff) {
          $('input[name="betreff"]').addClass("error");
          eingabeFehlerPopup("betreffLeer");
          return;
        }
        else $('input[name="betreff"]').removeClass("error");
        if (!postData.details || postData.details === placeholder_details) {
          $('textarea[name="details"]').addClass("error");
          eingabeFehlerPopup("detailsLeer");
          return;
        }
        else $('textarea[name="details"]').removeClass("error");
        break;

    }
  }

  // Daten abschicken, Rückmeldung nur bei Fehler!
  $('form#meldung')
  .ajaxSubmit({
    url: "../pc/frontend/meldung_submit.php",
    type: "POST",
    beforeSubmit: function(arr, form, options) {
      dlg.parent().css("display", "none");
      $('body').spinner({
        title: "neue Meldung",
        message: "<p>Bitte warten, die Meldung wird gerade abgesetzt…</p>",
        error: function() {
          var d = dlg.parent();
          var display = d.data("olddisplay") ? d.data("olddisplay") : "block"; 
          dlg.parent().css("display", display);
          $('body').spinner("destroy");
        },
        success: function() {
          dlg.dialog("close");
          $('body').spinner("destroy");
        },
        timer: 3
      }).spinner("show");
    },
    success: function() {
      var layer = map.getLayer(mb_ol_config.layers["Meldungen"].id);
      layer.refresh({force: true});
      $('body').spinner("success", "<p>Es kann einige Minuten dauern, bis die Meldung auf der Karte erscheint. Sie erhalten in Kürze eine E-Mail, in der Sie Ihre Meldung noch einmal bestätigen müssen.</p>");
    },
    error: function() {
      $('body').spinner("error");}
  });
},

  /**
   * Event-Handler (jQuery), wird beim Schließen des Meldungs-Dialogs
   * ausgeführt. Entfernt die Dialoginhalte - diese werden beim Öffnen
   * des Dialogs jedes mal neu aufgebaut - und deselektiert das zugehörige
   * Feature.
   * @returns null
   */
onMeldungShowClose = function(event) {
  if (event.originalEvent) {
    // Dialog leeren
    $('#meldung_show').empty();

    // Feature abwählen
    var selectControl = map.getControl(mb_ol_config.controls["SelectMeldung"].id);
    selectControl.unselectAll();
  }
},

  /**
   * Erstellt Dialog zur thematischen Eingrenzung einer Beobachtungsfläche. Zur
   * Unterscheidung zwischen vorhandenen und neuen Flächen dient die Nutzung 
   * einer id für vorhandene Flächen oder eines Features für eine neue Fläche.
   * @param id int
   * @param feature OpenLayers.Feature
   * @param name
   * @param geom_string Polygon as string
   * @returns null
   */
beobachtungsflaechenDialog = function(id, feature, name, geom_string) {
  var titel = (id ? name: "thematische Eingrenzung");
  var dlg = $('<div></div>')
  .attr('id', 'beobachtungsflaechen_dialog')
  .attr('title', titel);

  $('#template_flaeche_abonnieren')
  .tmpl()
  .appendTo(dlg);

  $.each(["problem", "idee"], function(key, typ) {
    var target = $('div[name="' + typ + '_kategorie"]', dlg);
    $.each(ks_lut.kategorie, function(kategorie_id, kategorie) {
      if (!kategorie.parent && kategorie.typ == typ) {
        var nobr = $('<nobr>');
        $('<input>')
        .attr("name", typ + "_kategorie[" + kategorie_id + "]") // kategorie.name
        .attr("type", "checkbox")
        .val(kategorie_id)
        .appendTo(nobr);
        $('<label></label>').html(" " + kategorie.name).appendTo(nobr);
        nobr.appendTo(target);
        $('<br>').appendTo(target);
      }
    });
  });

  dlg.dialog({
    modal: true,
    width: 500,
    close: function() {
      if (feature)
        feature.destroy();
    },
    open: function() {
      var $btn_beobachten = dlg.siblings(".ui-dialog-buttonpane").find(":button:").first();
      if (dlg.find(" :checked").size() == 0) {
        $btn_beobachten.attr("disabled", true).addClass("ui-state-disabled");
      } else {
        $btn_beobachten.attr("disabled", false).removeClass("ui-state-disabled");
      }
      dlg.find(":checkbox").bind("change", function() {
        if (dlg.find(" :checked").size() == 0) {
          $btn_beobachten.attr("disabled", true).addClass("ui-state-disabled");
        } else {
          $btn_beobachten.attr("disabled", false).removeClass("ui-state-disabled");
        }
      });
    },
    buttons: {
      "beobachten": function() {
        var problem_kat_arr = [];
        var idee_kat_arr = [];
        var geom_as_text = null;

        $("div[name='problem_kategorie'] input:checked", dlg).each(function() {
          problem_kat_arr.push($(this).val());
        });

        $("div[name='idee_kategorie'] input:checked", dlg).each(function () {
          idee_kat_arr.push($(this).val());
        });

        if (feature && feature.geometry) {
          geom_as_text = feature.geometry.toString();
        } else if (geom_string) {
          geom_as_text = geom_string;
        }

        $.ajax({
          url: "../pc/frontend/rss_submit.php",
          type: "POST",
          dataType: "json",
          data: {
            id: id,
            geom: geom_as_text,
            //problem: $('input[name="problem"]', dlg).is(':checked') ? true : false,
            //idee: $('input[name="idee"]', dlg).is(':checked') ? true : false,
            problem_kategorie: problem_kat_arr,
            idee_kategorie: idee_kat_arr
          },
          beforeSend: function() {
            //dlg.parent().css("display", "none");
            dlg.dialog("close");
            $('body').spinner({
              title: "GeoRSS-Feed",
              message: "<p>Bitte warten, der GeoRSS-Feed wird gerade erstellt…</p>",
              error: function() {
                //var d = dlg.parent();
                //var display = d.data("olddisplay") ? d.data("olddisplay") : "block";
                //dlg.parent().css("display", display);
                $('body').spinner("destroy");
                dlg.dialog("show");
              },
              success: function() {								
                $('body').spinner("destroy");
              },
              timer: 3
            }).spinner("show");
          },
          error: function() {$('body').spinner("error");},
          success: function(data) {
            var feed_url = "../pc/georss.php?id=" + data.hash; 
            var message = "Der GeoRSS-Feed wurde erfolgreich erstellt und ist nun unter folgender Adresse abrufbar: ";
            message += '<a href="' + feed_url + '" target="_blank" style="color:#006CB7;text-decoration:none;">GeoRSS-Feed</a>';
            $('body').spinner("success", message); 
            showFlaecheActionBtns();
            hideFlaecheCtrlBtns();	
          }
        });
      },
      "abbrechen": function() { 
        $(this).dialog("close"); 
      }
    }
  });
},

  /**
   * Event-Handler (jQuery), wird nach dem Klick auf "Neue Fläche erstellen"
   * ausgeführt. Aktiviert das DrawFeature-Control und ändert den Mauszeiger auf
   * "Fadenkreuz".
   * @param event Klick-Event, unbenutzt.
   * @returns null
   */
onRssStartNeueFlaeche = function(event) {
  hideFlaecheActionBtns();
  showFlaecheCtrlBtns();
  $("#flaeche_cancel").unbind("click").click(onRssStopNeueFlaeche);

  var control = map.getControl(mb_ol_config.controls["DrawBeobachtungsflaeche"].id);
  var mapDiv = $(map.div);

  //	console.info(control);

  $("#flaeche_apply").click(function() {
    control.handler.finishGeometry();
    //		console.info(control.layer.features);
  });

  //	onRssStopSelect();

  control.activate();
  mapDiv.css('cursor', 'crosshair');

  $(document).bind('keydown.rss', function(event) {
    if (event.keyCode && event.keyCode === $.ui.keyCode.ESCAPE) {
      onRssStopNeueFlaeche();
      event.preventDefault();
    }
  });
},

  /**
   * Event-Handler (OpenLayers), wird nach Fertigstellen des Features aufgerufen.
   * Ändert Karten-Cursor auf auto zurück und zeigt Dialog zur thematischen
   * Eingrenzung an. Dem Dialog wird keine Feature-Id, sondern das neue Feature
   * übergeben, so dass dieser weiß, dass es sich um ein neues Feature handelt.
   * @param feature OpenLayers.Feature
   * @returns null
   */
onRssNeueFlaeche = function(feature) {		
  beobachtungsflaechenDialog(null, feature);
  onRssStopNeueFlaeche();
},

onRssStopNeueFlaeche = function() {
  showFlaecheActionBtns();
  hideFlaecheCtrlBtns();

  var control = map.getControl(mb_ol_config.controls["DrawBeobachtungsflaeche"].id);
  var mapDiv = $(map.div);

  control.deactivate();
  mapDiv.css('cursor', 'auto');

  $(document).unbind('.rss');
},

onRssStadtgebiet = function() {
  hideFlaecheActionBtns();
  beobachtungsflaechenDialog(-1, null, "thematische Eingrenzung", null);
  showFlaecheActionBtns();
},

onRssStartSelect = function() {
  hideFlaecheActionBtns();
  showFlaecheCtrlBtns();
  $("#flaeche_cancel").unbind("click").click(onRssStopSelect);	

  var layer = map.getLayer(mb_ol_config.layers["GeoRSS-Polygone"].id);
  var control = map.getControl(mb_ol_config.controls["SelectPolygon"].id);

  //	onRssStopNeueFlaeche();
  $("#flaeche_apply").unbind("click").click(function() {		
    onRssSelect(control.layer.selectedFeatures);
  });

  layer.setVisibility(true);
  control.activate();

  $(document).bind('keydown.rss', function(event) {
    if (event.keyCode && event.keyCode === $.ui.keyCode.ESCAPE) {
      onRssStopSelect();
      event.preventDefault();
    }
  });
},

onRssSelect = function(features) {
  //beobachtungsflaechenDialog(feature.data.id, null, feature.data.name);
  var IDs = "";
  for(var i=0; i<features.length; i++) {
    var idString = features[i].fid;
    if (idString.indexOf(".")!=-1) {
      IDs += "," + idString.substring(idString.indexOf(".")+1);
    }
  }

  hideFlaecheActionBtns();
  beobachtungsflaechenDialog(IDs, null, "thematische Eingrenzung", null);
  onRssStopSelect();
},

onRssStopSelect = function() {
  showFlaecheActionBtns();
  hideFlaecheCtrlBtns();	
  var layer = map.getLayer(mb_ol_config.layers["GeoRSS-Polygone"].id);
  var control = map.getControl(mb_ol_config.controls["SelectPolygon"].id);

  layer.setVisibility(false);
  control.unselectAll();
  control.deactivate();

  $(document).unbind('.rss');
},

// Hide and show buttons for Beobachtungsflaeche.
hideFlaecheActionBtns = function(buttonID) {
  $("button.flaecheAction").hide();
  $("button.flaecheAction").removeClass("ui-state-focus");
  if (buttonID) {
    $("button#"+buttonID).show();
  }
}

showFlaecheActionBtns = function() {
  $("button.flaecheAction").show();
}

hideFlaecheCtrlBtns = function() {
  $("button.flaecheCtrl").unbind("click").hide();
}

showFlaecheCtrlBtns = function() {
  $("button.flaecheCtrl").show();
}


prepareProject = function(mapElement) {


  // Event-Handler für SelectControl
  var selectControl = map.getControl(mb_ol_config.controls["SelectMeldung"].id);
  selectControl.onSelect = onMeldungSelect;

  // Baselayerauswahl
  var target = $('#map_toggle');
  var buttonset = $('<div></div>').addClass('buttonset');

  for(var i in map.layers) {
    var layer = map.layers[i];		
    if (layer.isBaseLayer && layer.displayInLayerSwitcher) {
      buttonset.append($('<input/>')
                       .attr('type', 'radio')
                       .attr('id', 'bl_' + layer.id)
                       .attr('name', 'baselayer')
                       .attr('checked', (layer == map.baseLayer ? true : false))
                       .click(function() {
                         // TODO: Change-Layer-Events von OpenLayers.Map abfangen.
                         var id = $(this).attr('id').slice(3);
                         var layer = map.getLayer(id);
                         if (layer.name == 'Luftbild') {
                           map.getLayersByName("POI")[0].setVisibility(false);
                         }
                         else {
                           map.getLayersByName("POI")[0].setVisibility(true);
                         }
                         map.setBaseLayer(layer);
                       }));
                       buttonset.append($('<label></label>')
                                        .attr('for', 'bl_' + layer.id)
                                        .html(layer.name));			
    }		
  }
  buttonset.buttonset();
  target.append(buttonset);

  // Button für die Rückkehr zur Startseite
  var target = $('#back_to_start');
  target.append($('<a></a>').attr('href', window.location.protocol +"//"+ window.location.host));
  var button = $('<div></div>').addClass('button');
  button.append($('<span></span>').html('Startseite'));
  button.button();
  $('#back_to_start a').append(button);

  // Vorbereitung für Accordion
  var w = $('#widgets');
  $("> div", w).each(function() {
    var self = $(this),
    title = self.attr('title'),
    h = $('<h3></h3>')
    .append($('<a></a>')
            .html(title))
            .appendTo(w);
            self.addClass('cnt')
            .appendTo(w);
  });

  /*********************************/

  // Standortsuche
  $('#standortsuche button')
  .button({
    icons: {primary: 'ui-icon-search'},
    text: false
  })
  .click(function() {
    var standort = $.trim($('#standortsuche input[type="text"]').val());
    if (standort != "") {
      //TODO: Fehlermeldung anzeigen, falls notwendig
      $.ajax({
        url: "server/location.php",
        data: {standort: standort},
        dataType: 'json',
        type: 'POST',
        success: zoomToPosition
      });
    }
  });

  // Neue Meldung
  $('#melden a').click(onNeueMeldung);

  $('#beobachtungsflaechen button').button();
  $('#flaeche_action').hide();

  // Neue Fläche
  $('#flaeche_stadtgebiet').click(onRssStadtgebiet);
  $('#flaeche_stadtteil').click(onRssStartSelect);
  $('#flaeche_neu').click(onRssStartNeueFlaeche);

  // Kartenelemente
  var kartenelemente = $('#kartenelemente');
  var kol = $('<ol></ol>');
  for(var id in ks_config.filter) {
    var checkbox = $('<input/>')
    .attr('type', 'checkbox')
    .attr('name', id);
    if (ks_config.filter[id].enabled)
      checkbox.attr('checked', 'checked');			

    var div = $('<div></div>')
    .attr('id', id);
    div.append(checkbox)
    .append($('<label></label>')
            .attr('for',  id)
            .html(ks_config.filter[id].label));
            $.each(ks_config.filter[id].icons, function(key, val) {
              div.append($("<img/>")
                         .attr("src", "../pc/media/icons/" + val));
            });
            kol.append(div);
  }

  var generalisiert = $('<div></div>')
  .attr('id', 'generalisiert');
  generalisiert.append($('<label></label>').html('zusammengefasste Meldungen'));

  generalisiert.append($("<img/>").attr("src", "../pc/media/icons/generalisiert_layer.png"));
  kol.append(generalisiert);

  $('input', kol).click(function() { buildFilter(); });
  kartenelemente.append(kol);

  $('#sonderseiten button').button();

  buildFilter();
  window.setInterval(buildFilter, (ks_config.reload_interval || 30)*1000);

  // Accordion bauen
  $('#widgets').accordion({
    collapsible: true,
    autoHeight: false
  });

  // Sidebar-Toogle
  var toggle = $('#sidebar_toggle');
  toggle.click(function() {
    var sidebar = $(this).parent();
    var tw = $(this).width();
    var sw = sidebar.width();
    if (sidebar.hasClass("sidebar-open")) {
      sidebar.animate({
        "margin-right": -(sw-tw)
      });
      sidebar.toggleClass("sidebar-open sidebar-closed");
    } else {
      sidebar.animate({
        "margin-right": 0
      });
      sidebar.toggleClass("sidebar-open sidebar-closed");
    }
  });

  // Anzeige einer bestehenden Meldung	
  $('<div></div>')
  .attr('id', 'meldung_show')
  .data('oWidth', 500)
  .dialog({
    autoOpen: false,
    width: 500,
    height: 'auto',
    abeforeclose: onMeldungShowClose
  }).bind('dialogclose', onMeldungShowClose);


  // Dialog für neue Meldung
  $('<div></div>')
  .data('oWidth', 500)
  .attr('id', 'meldung_edit')
  .dialog({
    autoOpen: false,
    width: 500,
    close: onMeldungFormClose,
    buttons: {
      "melden": meldungFormSubmit,
      "abbrechen": function() {$(this).dialog("close");}
    }
  });
};



/**
 * Hinweis-Pop-up bei erstmaligem Klick auf neue Meldung
 */
var zeigeHinweisPopup = true;
hinweisPopup = function() {
  if (zeigeHinweisPopup == true) {
    var dlg = $('<div></div>')
    .attr("id", 'hinweis-popup')
    .html('Bitte setzen Sie in der Karte das Symbol durch Verschieben mit gedrückter linker Maustaste an den Ort des Problems / der Idee.<br/><br/>Teilen Sie bitte pro Meldung nur ein Problem / eine Idee aus den vorgegebenen Kategorien mit.<br/><br/>Sehen Sie bitte von Meldungen ab, die komplexe städtebauliche oder verkehrsplanerische Sachverhalte behandeln.')
    .dialog({
      title: 'Hinweise',
      width: 600,
      modal: true,
      closeOnEscape: false,
      open: function(event, ui) {
        $(this).find(".ui-dialog-titlebar-close").hide();
      },
      close: function(event, ui) {
        $(this).dialog('destroy').remove();
      }
    });

    dlg.dialog('option', 'buttons', {
      schließen: function() {
        $(this).dialog('close');
      }
    });
  }
  zeigeHinweisPopup = false;
};



/**
 * Eingabefehler-Pop-up bei fehlender oder falscher Eingabe in Pflichtfelder
 * @returns null
 */
eingabeFehlerPopup = function(eingabeFehlerTyp) {
  switch(eingabeFehlerTyp) {
    case "emailFalsch":
      var eingabeFehlerText = emailFalsch;
      break;
    case "emailLeer":
      var eingabeFehlerText = emailLeer;
      break;
    case "begruendungLeer":
      var eingabeFehlerText = begruendungLeer;
      break;
    case "freitextLeer":
      var eingabeFehlerText = freitextLeer;
      break;
    case "hauptkategorieLeer":
      var eingabeFehlerText = hauptkategorieLeer;
      break;
    case "unterkategorieLeer":
      var eingabeFehlerText = unterkategorieLeer;
      break;
    case "betreffLeer":
      var eingabeFehlerText = betreffLeer;
      break;
    case "detailsLeer":
      var eingabeFehlerText = detailsLeer;
      break;
  }

  var dlg = $('<div></div>')
  .attr("id", 'eingabefehler-popup')
  .html(eingabeFehlerText)
  .dialog({
    title: 'Eingabefehler',
    modal: true,
    closeOnEscape: false,
    open: function(event, ui) {
      $(this).find(".ui-dialog-titlebar-close").hide();
    },
    close: function(event, ui) {
      $(this).dialog('destroy').remove();
    }
  });

  dlg.dialog('option', 'buttons', {
    schließen: function() {
      $(this).dialog('close');
    }
  });
};


$(document).ready(function() {
  $("input[name='idee_alle']").live("click", function() {
    if ($(this).attr("checked")) {
      $("div[name='idee_kategorie'] input").each(function() {
        $(this).attr("checked", true);
      });			
    } else {
      $("div[name='idee_kategorie'] input").each(function() {
        $(this).attr("checked", false);
      });
    }
  })

  $("input[name='problem_alle']").live("click", function() {
    if ($(this).attr("checked")) {
      $("div[name='problem_kategorie'] input").each(function() {
        $(this).attr("checked", true);
      });			
    } else {
      $("div[name='problem_kategorie'] input").each(function() {
        $(this).attr("checked", false);
      });
    }
  })

  $("a.gotoBBOX").live("click", function() {
    var bboxString = $(this).attr("name");
    var bboxArray = bboxString.split(",");

    if (bboxArray.length == 4) {
      // PUNKT
      if (bboxArray[0] == bboxArray[2]) {	
        var ll = new OpenLayers.LonLat(parseFloat(bboxArray[0]), parseFloat(bboxArray[1]));
        map.setCenter(ll, 7);
        // POLYGON
      } else {
        var bbox = OpenLayers.Bounds.fromArray(bboxArray);
        var zoom = Math.min(7, map.getZoomForExtent(bbox));
        map.setCenter(bbox.getCenterLonLat(), zoom);
      }
    }
    return false;
  })

});	

// Ende pc/projekt.js
