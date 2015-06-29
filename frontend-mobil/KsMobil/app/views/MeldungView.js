KsMobil.MeldungView = M.View.extend({
    type: 'KsMobil.MeldungView',

    value: null,

	render: function() {
		this.html += '<div id="' + this.id + '" class="meldung-view">';
        this.html += 'Hello World';
        this.html += '</div>';
        return this.html;
	},

    renderUpdate: function() {
        var me = $('#' + this.id);
        me.empty();
        var l = KsMobil.configuration;
        var template = l.meldung_template;
        var attribs = $.extend({}, this.value.attributes);
        attribs.hauptkategorie = l.kategorie[attribs.hauptkategorieid].name;
        attribs.unterkategorie = l.kategorie[attribs.kategorieid].name;
        attribs.schwellenwert = KsMobil.configuration.schwellenwert;
        $.tmpl(template, attribs).appendTo(me);

        if(attribs.vorgangstyp === 'idee') {
            var schwellenwertClass = "unter-schwellenwert";
            if(parseInt(attribs.unterstuetzer) >= attribs.schwellenwert) {
                schwellenwertClass = "ueber-schwellenwert";
            }
            me.find('span.meldung_unterstuetzer').addClass(schwellenwertClass);
        }
    }
});

