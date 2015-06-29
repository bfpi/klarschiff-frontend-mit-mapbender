m_require('app/controllers/MeldungController.js');
m_require('app/views/MeldenView.js');

KsMobil.MeldenPage = M.PageView.design({
    childViews: 'header content',

    events: {
        'pageshow': {
            target: KsMobil.MeldungController,
            action: 'formReset'
        }
    },

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
                    action: 'meldenAbbrechen'
                }
            }
        }),

        titleLabel: M.LabelView.design({
            anchorLocation: M.CENTER,
            contentBinding: {
                target: KsMobil.MeldungController,
                property: 'vorgangsTyp'
            },
            computedValue: {
                valuePattern: 'x', // This needs to evaluate to true...
                operation: function(typ) {
                    return typ == 'Idee' ? 'Idee' : 'Problem';
                }
            }
        })
    }),

    content: KsMobil.MeldenView.design({})
});
