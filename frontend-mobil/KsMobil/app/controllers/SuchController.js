/* vim: set ts=4 sw=4: */
/**
 * KsMobil.SuchController
 *
 * @author Christian Wygoda <christian.wygoda@wheregroup.com>
 */
KsMobil.SuchController = M.Controller.extend({
    searchResults: [],

    /**
     * Constructor.
     */
    init: function(isFirstTime) {
        if(isFirstTime) {
            var page = M.ViewManager.getPage('suchenPage');
            var self = this;
            $('#' + page.id).find('form').bind('submit', function() {
                self.search.call(self);
                return false;
            });
        }
    },

    search: function() {
        var value = M.ViewManager.getView('suchenPage', 'searchbar').value;
        if(value.trim() !== '') {
            M.LoaderView.show("suche…");
            //do ajax here
            $.ajax({
                url: KsMobil.URLS.search,
                data: {
                    searchtext: value
                },
                dataType: 'json',
                context: this,
                success: this.processResults,
                error: this.onSearchError
            });
        }
    },

    processResults: function(data) {
        M.LoaderView.hide();
        this.set('searchResults', data);
    },

    onSearchError: function() {
        M.LoaderView.hide();
        M.DialogView.alert({
            title: 'Fehler',
            message: 'Es trat ein Fehler bei der Suche auf.'
        });
    },

    showResult: function(id) {
        var li = $('#' + id);
        var pos = li.parent().find('li').index(li);
        var bbox = this.searchResults.array[pos].bbox;

        KsMobil.MapController.zoomTo(bbox, 18);
        this.switchToPage(M.ViewManager.getPage('mapPage'));
    }
});

