KsMobil.SuchItemView = M.ListItemView.design({
    childViews: 'label',

    events: {
        tap: {
            target: KsMobil.SuchController,
            action: 'showResult'
        }
    },

    label: M.LabelView.design({
        computedValue: {
            valuePattern: '<%= label %>',
            operation: function(v) {
                return v;
            }
        }
    })
});
