/* vim: set ts=4 sw=4: */
m_require('app/views/MapView.js');
m_require('app/controllers/MapController.js');

KsMobil.MapPage = M.PageView.design({
    childViews: 'map toolbar',

    self: this,

    events: {
        pageshow: { 
            action: function(isFirstTime) {
                // Call both controllers
                var c = KsMobil.MapController;
                c.init.call(c, isFirstTime);
                c = KsMobil.MeldungController;
                c.init.call(c, isFirstTime);
            }
        }
    },

    header: M.ToolbarView.design({
        childViews: 'search',
        anchorLocation: M.TOP,

        search: M.SearchBarView.design({
            anchorLocation: M.CENTER
        })
    }),

    map: KsMobil.OpenlayersMapView.design({
        events: {
            'select': {
                target: KsMobil.MeldungController,
                action: 'selectMeldung'
            }
        }
        //TODO: Refactor fixed layers, styles stuff here
    }),

    toolbar: M.ToolbarView.design({
        childViews: 'toggleView',
        anchorLocation: M.TOP,
        cssClass: 'map-toolbar',

        toggleView: M.ToggleView.design({
            childViews: 'normalButtons meldungButtons',
            anchorLocation: M.CENTER,

            normalButtons: M.ButtonGroupView.design({
                anchorLocation: M.CENTER,
                childViews: 'location search layer problem idee',
                cssClass: 'map-buttons',
                
                location: M.ButtonView.design({
                    value: 'Standort aktualisieren',
                    icon: 'location',
                    isInline: true,
                    isIconOnly: true,
                    events: {
                        'tap': {
                            target: KsMobil.MapController,
                            action: function() {
                                var controller = KsMobil.MapController;
                                var control = controller.map.getControlsBy("id", "locate-control")[0];
                                controller.position = null;
                                if(!control.active) {
                                    control.activate();
                                }
                            }
                        }
                    }
                }),

                search: M.ButtonView.design({
                    value: 'Standortsuche aufrufen',
                    icon: 'lucene',
                    isInline: true,
                    isIconOnly: true,
                    events: {
                        'tap': {
                            target: KsMobil.MapController,
                            action: 'search'
                        }
                    }
                }),

                layer: M.ButtonView.design({
                    value: 'Kartenhintergrund ändern',
                    icon: 'layer-switch',
                    isInline: true,
                    isIconOnly: true,
                    events: {
                        'tap': {
                            target: KsMobil.MapController,
                            action: 'toggleBaseLayer'
                        }
                    }
                }),

                problem: M.ButtonView.design({
                    value: 'Problem melden',
                    icon: 'problem',
                    isIconOnly: true,
                    events: {
                        'tap': {
                            target: KsMobil.MeldungController,
                            action: 'problemMelden'
                        }
                    }
                }),

                idee: M.ButtonView.design({
                    value: 'Idee melden',
                    icon: 'idee',
                    isInline: true,
                    isIconOnly: true,
                    events: {
                        'tap': {
                            target: KsMobil.MeldungController,
                            action: 'ideeMelden'
                        }
                    }
                })
            }),

            meldungButtons: M.ButtonGroupView.design({
                anchorLocation: M.CENTER,
                childViews: 'edit cancel',
                cssClass: 'map-buttons',

                edit: M.ButtonView.design({
                    value: 'beschreiben…',
                    events: {
                        'tap': {
                            target: KsMobil.MeldungController,
                            action: 'weiter'
                        }
                    }
                }),

                cancel: M.ButtonView.design({
                    value: 'abbrechen',
                    events: {
                        'tap': {
                            target: KsMobil.MeldungController,
                            action: 'abbrechen'
                        }
                    }
                })
            })
        })
    })
});

