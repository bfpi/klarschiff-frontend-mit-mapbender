m_require('app/controllers/MeldungController.js');

KsMobil.LobenHinweisenKritisierenPage = M.PageView.design({
    childViews: 'header content',

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
                    action: 'backToMeldung'
                }
            }
        }),

        titleLabel: M.LabelView.design({
            anchorLocation: M.CENTER,
            value: 'Lob/Hinweis/Kritik'
        })
    }),

    content: M.ScrollView.design({
        childViews: 'email freitext actions',

        email: M.TextFieldView.design({
            inputType: M.INPUT_EMAIL,
            label: 'E-Mail-Adresse',
            initialText: 'Bitte geben Sie Ihre E-Mail-Adresse an.',
            cssClassOnInit: 'initial-text'
        }),

        freitext: M.TextFieldView.design({
            label: 'Freitext',
            hasMultipleLines: true,
            initialText: 'Bitte tragen Sie hier Ihr Lob, Ihre Hinweise oder Ihre Kritik zur Meldung ein.',
            cssClassOnInit: 'initial-text'
        }),

        actions: M.ButtonGroupView.design({
            anchorLocation: M.CENTER,
            childViews: 'senden abbrechen',

            senden: M.ButtonView.design({
                value: 'senden',
                events: {
                    tap: {
                        target: KsMobil.MeldungController,
                        action: 'lobHinweiseKritikSenden'
                    }
                }
            }),

            abbrechen: M.ButtonView.design({
                value: 'abbrechen',
                events: {
                    tap: {
                        target: KsMobil.MeldungController,
                        action: 'backToMeldung'
                    }
                }
            })
        })
    })
});
