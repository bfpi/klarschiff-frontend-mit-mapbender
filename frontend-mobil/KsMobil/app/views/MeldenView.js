KsMobil.MeldenView = M.ScrollView.design({

    childViews: 'hauptkategorie unterkategorie email betreff details'
        + ' foto hinweis aufforderung actions',

    /**
     * Pflichtangaben:
     *  Hauptkategorie
     *  Unterkategorie
     *  E-Mail-Adresse
     */

    hauptkategorie: M.SelectionListView.design({
        label: 'Hauptkategorie',
        selectionMode: M.SINGLE_SELECTION_DIALOG,
        initialText: 'auswählen…',
        contentBinding: {
            target: KsMobil.MeldungController,
            property: 'hauptkategorien'
        },
        events: {
            'change': {
                target: KsMobil.MeldungController,
                action: 'updateUnterkategorien'
            }
        }
    }),

    unterkategorie: M.SelectionListView.design({
        label: 'Unterkategorie',
        selectionMode: M.SINGLE_SELECTION_DIALOG,
        initialText: 'auswählen…',
        contentBinding: {
            target: KsMobil.MeldungController,
            property: 'unterkategorien'
        },
        events: {
            'change': {
                target: KsMobil.MeldungController,
                action: 'updateEingabehinweise'
            }
        }
    }),

    email: M.TextFieldView.design({
        inputType: M.INPUT_EMAIL,
        label: 'E-Mail-Addresse',
        initialText: 'Bitte geben Sie Ihre E-Mail-Adresse an.',
        cssClassOnInit: 'initial-text'
    }),

    /**
     * Optionale Angaben
     *  Betreff
     *  Details
     *  Foto
     */
    betreff: M.TextFieldView.design({
        label:'Betreff'
    }),

    details: M.TextFieldView.design({
        label: 'Details',
        hasMultipleLines: true
    }),

    foto: M.View.design({
        html: '<label class="ui-input-text">Foto <span style="font-style:italic;color:#d81920">(Dateigröße maximal 2 MB!)</label>'
            + '<form>'
            + '<input name="foto" type="file" />'
            + '</form>'
    }),

    /**
     * Hinweis
     */
    hinweis: M.LabelView.design({
        value: '<b>Hinweis:</b> Vor der Veröffentlichung werden eingegebene Texte sowie das Foto redaktionell geprüft.',
        cssClass: "hinweis"
    }),

    aufforderung: M.LabelView.design({
        value: "* Pflichtangabe bei dieser Unterkategorie",
        cssClass: "aufforderung"
    }),

    /**
     * Buttons
     */
    actions: M.ButtonGroupView.design({
            anchorLocation: M.CENTER,
            childViews: 'submit cancel',

            submit: M.ButtonView.design({
                value: 'melden',
                events: {
                    'tap': {
                        target: KsMobil.MeldungController,
                        action: 'validateMeldung'
                    }
                }
            }),

            cancel: M.ButtonView.design({
                value: 'abbrechen',
                events: {
                    'tap': {
                        target: KsMobil.MeldungController,
                        action: 'meldenAbbrechen'
                    }
                }
            })
    })
})
