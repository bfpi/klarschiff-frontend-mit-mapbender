KsMobil.StartingPage = M.PageView.design({
    childViews: 'logo message',

    events: {
        pageshow: {
            target: KsMobil.AppController,
            action: 'init'
        }
    },

    logo: M.ImageView.design({
    }),

    message: M.LabelView.design({
        value: 'Lade...',
        contentBinding: {
            target: KsMobil.AppController,
            property: 'message'
        },
        cssClass: 'message'
    })
});
