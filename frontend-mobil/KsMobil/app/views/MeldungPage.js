m_require('app/controllers/MeldungController.js');
m_require('app/views/MeldungView.js');

KsMobil.MeldungPage = M.PageView.design({
  childViews: 'header content toolbar',

  header: M.ToolbarView.design({
    anchorLocation: M.TOP,
    childViews: 'backButton titleLabel',

    backButton: M.ButtonView.design({
      value: 'zurück',
      icon: 'arrow-l',
      anchorLocation: M.LEFT,
      events: {
        'tap': {
          target: KsMobil.MeldungController,
          action: 'backToMap'
        }
      }
    }),

    titleLabel: M.LabelView.design({
      anchorLocation: M.CENTER,
      contentBinding: {
        target: KsMobil.MeldungController,
        property: 'feature'
      },
      computedValue: {
        valuePattern: 'x', // This needs to evaluate to true...
        operation: function(feature) {
          if(!feature) {
            return 'Titel';
          }
          return '<img id="meldung_details_icon" src="../pc/media/icons/' +
            feature.attributes.vorgangstyp +'_'+ feature.attributes.status +'_layer.png"></img>' +
            (feature.attributes.vorgangstyp == 'idee' ? 'Idee' : 'Problem') + 
            ' (#' + feature.attributes.id + ' – ' + feature.attributes.datum_erstellt + ')';
        }
      }
    })
  }),

  content: KsMobil.MeldungView.design({
    contentBinding: {
      target: KsMobil.MeldungController,
      property: 'feature'
    }
  }),

  toolbar: M.ToolbarView.design({
    anchorLocation: M.BOTTOM,
    childViews: 'buttons',
    cssClass: 'meldungActions',

    buttons: M.ButtonGroupView.design({
      anchorLocation: M.CENTER,
      numberOfLines: 2,
      buttonsPerLine: 3,
      childViews: 'unterstuetzenButton meldenButton lobenHinweisenKritisierenButton prevMeldungButton currentMeldungButton nextMeldungButton',

      unterstuetzenButton: M.ButtonView.design({
        value: 'Unterstützung',
        events: {
          'tap': {
            target: KsMobil.MeldungController,
            action: 'unterstuetzen'
          }
        }
      }),

      meldenButton: M.ButtonView.design({
        value: 'Missbrauch',
        events: {
          'tap': {
            target: KsMobil.MeldungController,
            action: 'missbrauchMelden'
          }
        }
      }),

      lobenHinweisenKritisierenButton: M.ButtonView.design({
        value: 'Lob/Hinweise/Kritik',
        events: {
          'tap': {
            target: KsMobil.MeldungController,
            action: 'lobenHinweisenKritisieren'
          }
        }
      }),

      prevMeldungButton: M.ButtonView.design({
        cssClass: 'recorder-meldung-button',
        value: 'Vorherige',
        events: {
          'tap': {
            target: KsMobil.MeldungController,
            action: 'lobenHinweisenKritisieren'
          }
        }
      }),

      currentMeldungButton: M.ButtonView.design({
        cssClass: 'recorder-meldung-button current-meldung-button'
      }),

      nextMeldungButton: M.ButtonView.design({
        cssClass: 'recorder-meldung-button',
        value: 'Nächste',
        events: { 'tap': { } }
      })
    })
  })
});
