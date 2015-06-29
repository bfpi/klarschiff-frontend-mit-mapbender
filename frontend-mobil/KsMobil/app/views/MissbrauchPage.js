m_require('app/controllers/MeldungController.js');

KsMobil.MissbrauchPage = M.PageView.design({
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
            value: 'Missbrauch'
        })
    }),

    content: M.ScrollView.design({
        childViews: 'email details hinweis actions',

        email: M.TextFieldView.design({
            inputType: M.INPUT_EMAIL,
            label: 'E-Mail-Adresse',
            initialText: 'Bitte geben Sie Ihre E-Mail-Adresse an.',
            cssClassOnInit: 'initial-text'
        }),

        details: M.TextFieldView.design({
            label: 'Begründung',
            hasMultipleLines: true,
            initialText: 'Bitte geben Sie eine Begründung an.',
            cssClassOnInit: 'initial-text'
        }),
        
        hinweis: M.LabelView.design({
            value: '<b>Hinweis:</b> Einen Missbrauch können und sollten Sie dann melden, wenn durch Betreff, Details oder Foto Persönlichkeitsrechte verletzt werden (z. B. wenn auf dem Foto Gesichter oder Kfz-Kennzeichen zu erkennen sind). <span style="font-style:italic;color:#d81920">Achtung: Wenn Sie einen Missbrauch melden, wird die betroffene Meldung <b>sofort</b> und so lange <b>deaktiviert</b> (und damit unsichtbar), bis wir Ihren Missbrauchshinweis bearbeitet haben.</span>',
            cssClass: "hinweis"
        }),

        actions: M.ButtonGroupView.design({
            anchorLocation: M.CENTER,
            childViews: 'senden abbrechen',

            senden: M.ButtonView.design({
                value: 'melden',
                events: {
                    tap: {
                        target: KsMobil.MeldungController,
                        action: 'missbrauchSenden'
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
