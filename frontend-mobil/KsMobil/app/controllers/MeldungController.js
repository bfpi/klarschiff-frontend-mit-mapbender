/* vim: set ts=4 sw=4: */
/**
 * KsMobil.MeldungController
 * Handles all logic related to Meldungen.
 *
 * @author Christian Wygoda <christian.wygoda@wheregroup.com>
 * @author Niels Bennke <bennke@bfpi.de>
 */
KsMobil.MeldungController = M.Controller.extend({
    feature: null,
    vorgangsTyp: null,

    mapPage: null,
    meldungPage: null,
    unterstuetzenPage: null,
    missbrauchPage: null,
    lobenHinweisenKritisierenPage: null,
    meldenPage: null,

    sketchLayer: null,
    dragControl: null,

    _idee: 'Idee',
    _problem: 'Problem',

    hauptkategorienCache: null,
    hauptkategorien: null,
    unterkategorienCache: null,
    unterkategorien: null,

    /**
     * Constructor. Caches page references, adds sketch layer to the map and
     * build lookup tables for select boxes.
     */
    init: function(isFirstTime) {
        if (isFirstTime) {
            this.mapPage                        = M.ViewManager.getPage('mapPage');
            this.meldungPage                    = M.ViewManager.getPage('meldungPage');
            this.unterstuetzenPage              = M.ViewManager.getPage('unterstuetzenPage');
            this.missbrauchPage                 = M.ViewManager.getPage('missbrauchPage');
            this.lobenHinweisenKritisierenPage  = M.ViewManager.getPage('lobenHinweisenKritisierenPage');
            this.meldenPage                     = M.ViewManager.getPage('meldenPage');

            var mc = KsMobil.MapController;

            this.sketchLayer = new OpenLayers.Layer.Vector('SketchMeldung', {
                geometryType: OpenLayers.Geometry.Point,
                displayInLayerSwitcher: false,
                styleMap: mc.styles.meldungen
            });
            mc.addLayer(this.sketchLayer);

            this.dragControl = new OpenLayers.Control.DragFeature(this.sketchLayer);
            mc.addControl(this.dragControl);

            this.buildLookups();
        }
    },

    /**
     * Builds lookup tables suitable for select boxes
     */
    buildLookups: function() {
        var self = this;
        this.hauptkategorienCache = {};
        this.unterkategorienCache = {};
        $.each(KsMobil.configuration.kategorie, function(idx, kategorie) {
            if (!kategorie.parent) {
                if (typeof self.hauptkategorienCache[kategorie.vorgangstyp] === 'undefined') {
                    self.hauptkategorienCache[kategorie.vorgangstyp] = [];
                }
                self.hauptkategorienCache[kategorie.vorgangstyp].push({
                    value: idx,
                    label: kategorie.name
                });
            } else {
                var index = kategorie.parent;
                if (self.unterkategorienCache[index] === undefined) {
                    self.unterkategorienCache[index] = [];
                }
                self.unterkategorienCache[index].push({
                    value: idx,
                    label: kategorie.name
                });
            }
        });
    },

    /**
     * Callback which switches to the MeldungPage when a Meldung gets
     * selected.
     */
    selectMeldung: function(callerId, event) {
        var feature;
        var currentIndex = 0;
        if (event.feature.cluster) {
            feature = event.feature.cluster[0];
            var map = KsMobil.MapController.map;
            feature = event.feature.cluster[0];
            // Wenn nicht letzte Zoomstufe, nur zoomen und raus
            if(map.getZoom() < map.getNumZoomLevels() - 1) {
                map.panTo(feature.geometry.getBounds().getCenterLonLat());
                map.zoomIn();
                return;
            }
        }
        else {
            feature = event.feature;
        }
        this.showMeldung(feature);
        if (event.feature.cluster) {
            this.enhancePageForCluster(event.feature.cluster, currentIndex);
        }
        this.switchToPage(this.meldungPage);
    },

    recorderButtons: Array("prevMeldungButton", "currentMeldungButton", "nextMeldungButton"),

    showMeldung: function(feature) {
        feature.attributes.img_url = 
            KsMobil.URLS.meldungImage + feature.attributes.foto_normal;
        this.set('feature', feature);
        this.set('vorgangsTyp', feature.attributes.vorgangstyp == 'idee' ?
                 this._idee : this._problem);

        var toolbar = M.ViewManager.getView('meldungPage', 'toolbar');
        // Soll kein Button sein, ist aber in Buttongroup, daher -> aus
        toolbar.buttons.currentMeldungButton.disable();

        // Recorder-Buttons verstecken, werden ggf. in enhancePageForCluster wieder angezeigt
        for(var i = 0; i < this.recorderButtons.length; i++) {
            $('#' + toolbar.buttons[this.recorderButtons[i]].id).hide()
        }

        // Buttons finden
        var buttonsAlle = $('.meldungActions > h1 > div > a');

        // auf Fall prüfen, in dem die Buttons deaktiviert werden sollen
        if (feature.attributes.status == 'gemeldet')
            var buttonsDeaktivieren = true;

        // je nach Fall Deaktivierungen durchführen oder nicht
        if (buttonsDeaktivieren)
            buttonsAlle.addClass('disabled');
        else
            buttonsAlle.removeClass('disabled');
    },

    enhancePageForCluster: function(cluster, index) {
        var toolbar = M.ViewManager.getView('meldungPage', 'toolbar');
        toolbar.buttons[this.recorderButtons[1]].setValue("Meldung "+ (index + 1) +"/"+ cluster.length);
        // Recoder-Buttons anzeigen
        for(var i = 0; i < this.recorderButtons.length; i++) {
            $('#' + toolbar.buttons[this.recorderButtons[i]].id).show()
        }
        var ctrl = this;

        if(index > 0) {
            toolbar.buttons.prevMeldungButton.enable();
            toolbar.buttons.prevMeldungButton.events.tap.action = function() {
                ctrl.showMeldung(cluster[--index]);
                ctrl.enhancePageForCluster(cluster, index);
                toolbar.buttons.prevMeldungButton.removeCssClass('ui-btn-active')
            };
        }
        else {
            toolbar.buttons.prevMeldungButton.disable();
        }

        if(index < cluster.length - 1) {
            toolbar.buttons.nextMeldungButton.enable();
            toolbar.buttons.nextMeldungButton.events.tap.action = function() {
                ctrl.showMeldung(cluster[++index]);
                ctrl.enhancePageForCluster(cluster, index);
                toolbar.buttons.nextMeldungButton.removeCssClass('ui-btn-active')
            };
        }
        else {
            toolbar.buttons.nextMeldungButton.disable();
        }
    },

    /**
     * Switches (back) to MapPage.
     */
    backToMap: function() {
        KsMobil.MapController.unselect();
        this.switchToPage(this.mapPage);
    },

    /**
     * Switches to unterstuetzenPage.
     */
    unterstuetzen: function() {
        var toolbar = M.ViewManager.getView('meldungPage', 'toolbar');
        if (!$('#' + toolbar.buttons.id).find('.ui-btn').hasClass('disabled')) {
            this.switchToPage(this.unterstuetzenPage);
        }
    },

    /**
     * Switches to missbrauchPage.
     */
    missbrauchMelden: function() {
        var toolbar = M.ViewManager.getView('meldungPage', 'toolbar');
        if (!$('#' + toolbar.buttons.id).find('.ui-btn').hasClass('disabled')) {
            this.switchToPage(this.missbrauchPage);
        }
    },

    /**
     * Switches to lobenHinweisenKritisierenPage.
     */
    lobenHinweisenKritisieren: function() {
        var toolbar = M.ViewManager.getView('meldungPage', 'toolbar');
        if (!$('#' + toolbar.buttons.id).find('.ui-btn').hasClass('disabled')) {
            this.switchToPage(this.lobenHinweisenKritisierenPage);
        }
    },

    /**
     * Switches (back) to MeldungPage.
     */
    backToMeldung: function() {
        this.switchToPage(this.meldungPage);
    },

    /**
     * Triggers a new Idee Meldung.
     */
    ideeMelden: function() {
        this.set('vorgangsTyp', this._idee);
        this.neueMeldung('idee');
    },

    /**
     * Trigger as new Problem Meldung.
     */
    problemMelden: function() {
        this.set('vorgangsTyp', this._problem);
        this.neueMeldung('problem');
    },


    /**
     * Start a new Meldung. Adds marker to the map at current position or
     * centered if position not visible.
     */
    neueMeldung: function(typ) {
        this.set('hauptkategorien', this.hauptkategorienCache[typ]);

        // Toggle toolbars
        M.ViewManager.getView('mapPage', 'toggleView').toggleView();

        this.dragControl.activate();
        var mc = KsMobil.MapController;
        var x, y;
        if (mc.positionPoint != undefined && mc.map.getExtent().containsLonLat(
            new OpenLayers.LonLat(mc.positionPoint.x, mc.positionPoint.y)))
                {
                    x = mc.positionPoint.x;
                    y = mc.positionPoint.y;
                }
                else {
                    x = mc.map.getCenter().lon;
                    y = mc.map.getCenter().lat;
                }
                this.feature = new OpenLayers.Feature.Vector(
                    new OpenLayers.Geometry.Point(x, y),
                    { vorgangstyp: typ, status: 'gemeldet' });
                    this.feature.renderIntent = 'temporary';

                    this.sketchLayer.addFeatures(this.feature);
    },

    formReset: function() {
        var form = M.ViewManager.getView('meldenPage', 'content');
        form.hauptkategorie.removeSelection();
        form.hauptkategorie.selection = null;
        form.hauptkategorie.initialText = 'auswählen…';
        form.hauptkategorie.themeUpdate();

        form.unterkategorie.selection = null;
        form.unterkategorie.initialText = 'auswählen…';
        this.updateUnterkategorien();
        form.unterkategorie.themeUpdate();

        $('#' + form.betreff.id).val("").attr("placeholder", "");
        $('#' + form.betreff.id).focus(function() {
            $(this).removeClass('initial-text');
        });
        $('#' + form.betreff.id).blur(function() {
            if ($(this).val() == "") {
                $(this).addClass('initial-text');
            }
        });
        $('#' + form.details.id).val("").attr("placeholder", "");
        $('#' + form.details.id).focus(function() {
            $(this).removeClass('initial-text');
        });
        $('#' + form.details.id).blur(function() {
            if ($(this).val() == "") {
                $(this).addClass('initial-text');
            }
        });
        $('input[name="foto"]').val("");

        // reset 'required'  status
        form.betreff.label = form.betreff.label.replace(/\**$/, "");
        form.details.label = form.details.label.replace(/\**$/, "");
        $('label[for="' +form.betreff.id +'"]').text(form.betreff.label);
        $('label[for="' +form.details.id +'"]').text(form.details.label);
    },

    /**
     * Validates Meldung input.
     */
    validateMeldung: function() {
        var form = M.ViewManager.getView('meldenPage', 'content'),
        data = {
            typ: this.vorgangsTyp.toLowerCase(),
            task: 'submit',
            hauptkategorie: form.hauptkategorie.getSelection(),
            unterkategorie: form.unterkategorie.getSelection(),
            point: this.feature.geometry.toShortString(),
            email: form.email.value,
            betreff: form.betreff.value,
            details: form.details.value
        };

        if (typeof data.hauptkategorie === 'undefined') {
            M.DialogView.alert({
                title: 'Fehler',
                message: 'Sie müssen eine Hauptkategorie wählen.'
            });
            return false;
        }

        if (typeof data.unterkategorie === 'undefined') {
            M.DialogView.alert({
                title: 'Fehler',
                message: 'Sie müssen eine Unterkategorie wählen.'
            });
            return false;
        }

        var kategorie = KsMobil.configuration.kategorie[data.unterkategorie];
        if (!kategorie) {
            return false;
        }
        switch (kategorie.naehere_beschreibung_notwendig) {
            case "betreffUndDetails":
                if (!data.betreff && data.betreff !== "0") {
                    M.DialogView.alert({
                        title: 'Fehler',
                        message: 'Sie müssen einen Betreff angeben.'
                    });
                    return false;
                }
                if (!data.details && data.details !== "0" ) {
                    M.DialogView.alert({
                        title: 'Fehler',
                        message: 'Sie müssen Ihre Meldung genauer beschreiben.'
                    });
                    return false;
                }
                break;

            case "betreff":
                if (!data.betreff && data.betreff !== "0") {
                    M.DialogView.alert({
                        title: 'Fehler',
                        message: 'Sie müssen einen Betreff angeben.'
                    });
                    return false;
                }
                break;

            case "details":
                if (!data.details && data.details !== "0" ) {
                    M.DialogView.alert({
                        title: 'Fehler',
                        message: 'Sie müssen Ihre Meldung genauer beschreiben.'
                    });
                    return false;
                }
                break;
        }

        if (!M.EmailValidator.pattern.exec(data.email)) {
            M.DialogView.alert({
                title: 'Fehler',
                message: 'Sie müssen Ihre E-Mail-Adresse angeben.'
            });
            return false;
        }
        this.meldungSenden(data);
    },

    /**
     * Sends a Meldung via Ajax
     */
    meldungSenden: function(data) {
        M.LoaderView.show();
        $('#' + this.meldenPage.id + ' form').ajaxSubmit({
            url: KsMobil.URLS.meldungSubmit,
            type: 'POST',
            data: data,
            context: this,
            success: this.meldungSendenSuccess,
            error: this.meldungSendenError
        });
    },

    /**
     * Success callback for meldungSenden.
     */
    meldungSendenSuccess: function(data) {
        var error = KsMobil.AppController.decodeError(data);
        if (error.code !== -1) {
            this.meldungSendenError(null, 'error', data);
        } else {
            M.LoaderView.hide();
            this.meldenAbbrechen();
            M.DialogView.alert({
                title: 'Meldung',
                message: 'Meldung erfolgreich abgesetzt.<br/>Sie erhalten eine E-Mail, in der Sie Ihre Meldung noch einmal bestätigen müssen.'
            });
            KsMobil.MapController.reloadMeldungen();
        }
    },

    /**
     * Error callback for meldungSenden.
     */
    meldungSendenError: function(jqXHR, textStatus, errorThrown) {
        M.LoaderView.hide();
        this.meldenAbbrechen();
        var error = KsMobil.AppController.decodeError(errorThrown);
        M.DialogView.alert({
            title: 'Fehler',
            message: errorThrown ? error.message
                : 'Es trat ein unbekannter Fehler auf.'
        });
    },

    /**
     * Sends a support message via Ajax.
     * Includes e-mail validation.
     */
    unterstuetzungSenden: function() {
        var self = this;
        var errors = [];

        var data = {
            id: this.feature.attributes.id,
            email: M.ViewManager.getView('unterstuetzenPage', 'email').value
        };

        if (!M.EmailValidator.pattern.exec(data.email)) {
            errors.push('<p>Sie müssen Ihre E-Mail-Adresse angeben.');
        }

        if (errors.length) {
            M.DialogView.alert({
                title: 'Fehler',
                message: errors.join('<br/>')
            });
        } else {
            M.LoaderView.show();
            $.ajax(KsMobil.URLS.meldungSupport, {
                type: 'POST',
                data: data,
                context: self,
                success: self.unterstuetzenSendenSuccess,
                error: self.unterstuetzenSendenError
            });
        }
    },

    /**
     * Success callback for unterstuetzenSenden.
     */
    unterstuetzenSendenSuccess: function(data) {
        var error = KsMobil.AppController.decodeError(data);
        if (error.code !== -1) {
            this.unterstuetzenSendenError(null, error, data);
        } else {
            M.LoaderView.hide();
            M.DialogView.alert({
                title: 'Unterstützung',
                message: 'Unterstützungsmeldung erfolgreich abgesetzt.<br/>Sie erhalten eine E-Mail, in der Sie Ihre Meldung noch einmal bestätigen müssen.'
            });
            this.backToMap();
        }
    },

    /**
     * Error callback for unterstuetzenSenden.
     */
    unterstuetzenSendenError: function(jqXHR, textStatus, errorThrown) {
        M.LoaderView.hide();
        this.backToMap();
        var error = KsMobil.AppController.decodeError(errorThrown);
        M.DialogView.alert({
            title: 'Fehler',
            message: errorThrown ? error.message
                : 'Es trat ein unbekannter Fehler auf.'
        });
    },

    /**
     * Sends a abuse message via Ajax.
     */
    missbrauchSenden: function() {
        var self = this;
        var errors = [];

        var data = {
            id: this.feature.attributes.id,
            email: M.ViewManager.getView('missbrauchPage', 'email').value,
            details: M.ViewManager.getView('missbrauchPage', 'details').value
        };

        if (!M.EmailValidator.pattern.exec(data.email)) {
            errors.push('<p>Sie müssen Ihre E-Mail-Adresse angeben.');
        }

        if (!data.details) {
            errors.push('<p>Sie müssen eine Begründung angeben.')
        }

        if (errors.length) {
            M.DialogView.alert({
                title: 'Fehler',
                message: errors.join('<br/>')
            });
        } else {
            M.LoaderView.show();
            $.ajax(KsMobil.URLS.meldungAbuse, {
                type: 'POST',
                data: data,
                context: self,
                success: self.missbrauchSendenSuccess,
                error: self.missbrauchSendenError
            });
        }
    },

    /**
     * Success callback for missbrauchSenden.
     */
    missbrauchSendenSuccess: function(data) {
        var error = KsMobil.AppController.decodeError(data);
        if (error.code !== -1) {
            this.missbrauchSendenError(null, error, data);
        } else {
            M.LoaderView.hide();
            M.DialogView.alert({
                title: 'Missbrauch',
                message: 'Missbrauchsmeldung erfolgreich abgesetzt.<br/>Sie erhalten eine E-Mail, in der Sie Ihre Meldung noch einmal bestätigen müssen.'
            });
            this.backToMap();
        }
    },

    /**
     * Error callback for missbrauchSenden.
     */
    missbrauchSendenError: function(jqXHR, textStatus, errorThrown) {
        M.LoaderView.hide();
        this.backToMap();
        var error = KsMobil.AppController.decodeError(errorThrown);
        M.DialogView.alert({
            title: 'Fehler',
            message: errorThrown ? error.message
                : 'Es trat ein unbekannter Fehler auf.'
        });
    },

    /**
     * Sends a Lob, Hinweise oder Kritik message via Ajax.
     */
    lobHinweiseKritikSenden: function() {
        var self = this;
        var errors = [];

        var data = {
            id: this.feature.attributes.id,
            email: M.ViewManager.getView('lobenHinweisenKritisierenPage', 'email').value,
            freitext: M.ViewManager.getView('lobenHinweisenKritisierenPage', 'freitext').value
        };

        if (!M.EmailValidator.pattern.exec(data.email)) {
            errors.push('<p>Sie müssen Ihre E-Mail-Adresse angeben.');
        }

        if (!data.freitext) {
            errors.push('<p>Sie müssen Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung angeben.')
        }

        if (errors.length) {
            M.DialogView.alert({
                title: 'Fehler',
                message: errors.join('<br/>')
            });
        } else {
            M.LoaderView.show();
            $.ajax(KsMobil.URLS.meldungLobHinweiseKritik, {
                type: 'POST',
                data: data,
                context: self,
                success: self.lobHinweiseKritikSendenSuccess,
                error: self.lobHinweiseKritikSendenError
            });
        }
    },

    /**
     * Success callback for lobHinweiseKritikSenden.
     */
    lobHinweiseKritikSendenSuccess: function(data) {
        var error = KsMobil.AppController.decodeError(data);
        if (error.code !== -1) {
            this.lobHinweiseKritikSendenError(null, error, data);
        } else {
            M.LoaderView.hide();
            M.DialogView.alert({
                title: 'Lob/Hinweise/Kritik',
                message: 'Lob, Hinweise oder Kritik erfolgreich abgesetzt<br/>und dem genannten Empfänger zugestellt.'
            });
            this.backToMap();
        }
    },

    /**
     * Error callback for lobHinweiseKritikSenden.
     */
    lobHinweiseKritikSendenError: function(jqXHR, textStatus, errorThrown) {
        M.LoaderView.hide();
        this.backToMap();
        var error = KsMobil.AppController.decodeError(errorThrown);
        M.DialogView.alert({
            title: 'Fehler',
            message: errorThrown ? error.message
                : 'Es trat ein unbekannter Fehler auf.'
        });
    },

    /**
     * Zoom in, centered on feature.
     */
    zoomIn: function() {
        ll = new OpenLayers.LonLat(
            this.feature.geometry.x,
            this.feature.geometry.y);
            KsMobil.MapController.zoomIn();
            KsMobil.MapController.setCenter(ll);
    },

    /**
     * Zoom out, centered on feature.
     */
    zoomOut: function() {
        ll = new OpenLayers.LonLat(
            this.feature.geometry.x,
            this.feature.geometry.y);
            KsMobil.MapController.zoomOut();
            KsMobil.MapController.setCenter(ll);
    },

    weiter: function() {
        M.LoaderView.show('Bitte warten, die Koordinaten der neuen Meldung werden gerade geprüft…');
        $.ajax(KsMobil.URLS.pointCheck, {
            data: {
                point: this.feature.geometry.toShortString()
            },
            context: this,
            success: this.onPointCheckSuccess,
            error: this.onPointCheckError,
        });
    },

    onPointCheckSuccess: function(data) {
        var error = KsMobil.AppController.decodeError(data);
        if (error.code !== -1) {
            this.onPointCheckError(null, 'error', data);
        } else {
            M.LoaderView.hide();
            this.weiter2();
        }
    },

    onPointCheckError: function(jqXHR, st, errorThrown) {
        M.LoaderView.hide();
        var error = KsMobil.AppController.decodeError(errorThrown);
        M.DialogView.alert({
            title: 'Fehler',
            message: errorThrown ? error.message
                : 'Es trat ein unbekannter Fehler auf.'
        });
        this.abbrechen();
    },

    /**
     * Switches to meldenPage after marker has been moved around.
     */
    weiter2: function() {
        this.switchToPage(this.meldenPage);
    },

    /**
     * Cancels a new Meldung.
     */
    abbrechen: function() {
        // Toggle toolbars
        if (!M.ViewManager.getView('mapPage', 'toggleView').isInFirstState) {
            M.ViewManager.getView('mapPage', 'toggleView').toggleView();
        }

        this.feature && this.feature.destroy();

        this.dragControl.deactivate();
        this.dragControl.over = false;
    },

    /**
     * Cancels a new Meldung and switches back to MapPage.
     */
    meldenAbbrechen: function() {
        this.abbrechen();
        this.backToMap();
    },

    /**
     * Updates subcategories when a new main category has been picked.
     */
    updateUnterkategorien: function() {
        var self = this,
        select = M.ViewManager.getView('meldenPage', 'content').hauptkategorie,
        hk = select.getSelection();
        if (typeof hk !== 'undefined') {
            var unterkategorien = $.extend({}, this.unterkategorienCache[hk]);
            unterkategorien[0].isSelected = true;
            this.set('unterkategorien', unterkategorien);
        } else {
            this.set('unterkategorien', []);
        }

        self.updateEingabehinweise();
    },
    updateEingabehinweise: function() {
        var self = this;
        var view =  M.ViewManager.getView('meldenPage', 'content');
        select = M.ViewManager.getView('meldenPage', 'content').unterkategorie;

        var $betreff = $("#"+ view.betreff.id);
        var $details = $("#"+ view.details.id);

        $betreff.attr("placeholder", "");
        $details.attr("placeholder", "");
        $(".aufforderung").css("visibility", "hidden");
        view.betreff.label = view.betreff.label.replace(/\**$/, "");
        view.details.label = view.details.label.replace(/\**$/, "");
        $('label[for="' +view.betreff.id +'"]').text(view.betreff.label);
        $('label[for="' +view.details.id +'"]').text(view.details.label);

        var kategorieId = select.getSelection();
        var kategorieId = $("#" + select.id).val();
        var kategorie  = KsMobil.configuration.kategorie[kategorieId];
        if (!kategorie && kategorie !== 0) {
            return;
        }

        switch(kategorie.naehere_beschreibung_notwendig) {

            case "betreff":
                $betreff.attr("placeholder", "Bitte geben Sie einen Betreff an.");
                $betreff.addClass('initial-text');
                view.betreff.label = view.betreff.label + "*";
                $('label[for="' +view.betreff.id +'"]').text(view.betreff.label);

                $(".aufforderung").css("visibility", "visible");

                break;
            case "details":
                $details.attr("placeholder", "Bitte beschreiben Sie Ihre Meldung genauer.");
                $details.addClass('initial-text');
                view.details.label = view.details.label + "*";
                $('label[for="' +view.details.id +'"]').text(view.details.label);

                $(".aufforderung").css("visibility", "visible");

                break;
            case "betreffUndDetails":
                $betreff.attr("placeholder", "Bitte geben Sie einen Betreff an.");
                $betreff.addClass('initial-text');
                $details.attr("placeholder", "Bitte beschreiben Sie Ihre Meldung genauer.");
                $details.addClass('initial-text');
                view.betreff.label = view.betreff.label + "*";
                $('label[for="' +view.betreff.id +'"]').text(view.betreff.label);

                view.details.label = view.details.label + "*";
                $('label[for="' +view.details.id +'"]').text(view.details.label);

                $(".aufforderung").css("visibility", "visible");
                break;
        }
    }
});

