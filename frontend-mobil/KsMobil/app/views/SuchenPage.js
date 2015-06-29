m_require('app/controllers/SuchController.js');
m_require('app/views/SuchItemView.js');

KsMobil.SuchenPage = M.PageView.design({
    childViews: 'header content',

    events: {
        pageshow: {
            target: KsMobil.SuchController,
            action: 'init'
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
                    action: 'backToMap'
                }
            }
        }),

        titleLabel: M.LabelView.design({
            anchorLocation: M.CENTER,
            value: 'Standortsuche'
        })
    }),

    content: M.ScrollView.design({
        childViews: 'searchbar searchbutton results',

        searchbar: M.SearchBarView.design({
            label: 'Sucheingabefeld',
            initialText: 'Stadtteil/Straße/Adresse…',
            cssClassOnInit: 'initial-text'
        }),

        searchbutton: M.ButtonView.design({
            value: 'suchen',
            events: {
                tap: {
                    target: KsMobil.SuchController,
                    action: 'search'
                }
            }
        }),

        results: M.ScrollView.design({
            childViews: 'resultList',

            resultList: M.ListView.design({
                contentBinding: {
                    target: KsMobil.SuchController,
                    property: 'searchResults'
                },
                items: 'array',
                removeItemsOnUpdate: YES,
                listItemTemplateView: KsMobil.SuchItemView
            })
        })
    })
});
