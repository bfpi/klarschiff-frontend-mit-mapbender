/* vim: set ts=4 sw=4: */
/**
 * KsMobil.AppController
 * Handles application caching, update checking updating the
 * application.
 *
 * @author Christian Wygoda <christian.wygoda@wheregroup.com>
 * @author Niels Bennke <bennke@bfpi.de>
 */
KsMobil.AppController = M.Controller.extend({
    onlineStatus: M.OFFLINE,
    message: 'lade…',
    messages: {
        CHECK_ONLINE: 'überprüfe Online-Status…',
        STATUS_ONLINE: 'online…',
        ERROR_OFFLINE: 'Fehler: offline',
        CHECK_VERSION: 'überprüfe Programmversion…',
        ERROR_VERSION: 'Fehler: Programmversion nicht ermittelt',
        ERROR_UPDATE: 'Fehler: Konfiguration nicht geladen'
    },
    versions: null,

    /**
     * Constructor.
     */
    init: function(isFirstTime) {
        // Load local configuration
        KsMobil.configuration = null;
        if(localStorage['configuration']) {
            KsMobil.configuration = JSON.parse(localStorage['configuration']);
        }

        // Are we online?
        this.set('message', this.messages.CHECK_ONLINE);
        M.Environment.getConnectionStatus({
            target: this,
            action: 'onlineCheckCallback'
        });
    },

    /**
     * Callback for online test.
     */
    onlineCheckCallback: function(status) {
        this.onlineStatus = status;
        if(this.onlineStatus === M.ONLINE) {
            this.set('message', this.messages.STATUS_ONLINE);
            this.checkForUpdate();
        } else {
            this.set('message', this.messages.ERROR_OFFLINE);
        }
    },

    /**
     * Checks the server for versions and triggers updates if needed.
     */
    checkForUpdate: function() {
        this.set('message', this.messages.CHECK_VERSION);
        $.ajax({
            url: KsMobil.URLS.versions,
            dataType: 'json',
            success: this.checkForUpdateSuccessCallback,
            error: this.checkForUpdateErrorCallback,
            context: this
        });
    },

    /**
     * Error callback for version update check.
     * If we still have an configuration from an earlier run, try to
     * start anyway.
     */
    checkForUpdateErrorCallback: function() {
        if(KsMobil.configuration && KsMobil.configuration.version) {
            this.go();
        } else {
            this.set('message', this.messages.ERROR_VERSION)
        }
    },

    /**
     * Success callback for version update check. Stores remote versions
     * and starts code update.
     */
    checkForUpdateSuccessCallback: function(remoteVersions) {
        this.versions = remoteVersions;

        this.updateCode();
    },

    /**
     * Code update function. If remote and local code version differ,
     * invalidate cache and reload application.
     * If not, start configuration update.
     */
    updateCode: function() {
        if(KsMobil.version !== this.versions.code) {
            // Force cache reload
            this.updateConfiguration(); //WILL HAVE TO GO LATER
        } else {
            this.updateConfiguration();
        }
    },

    /**
     * Configuration update. If remote and local configuration version differ, 
     * download new configuration from remote.
     * Otherwise switch to map view.
     */
    updateConfiguration: function() {
        if(!(KsMobil.configuration && KsMobil.configuration.version === 
             this.versions.configuration)) {
            $.ajax({
                url: KsMobil.URLS.configuration,
                dataType: 'json',
                success: this.updateConfigurationSuccess,
                error: this.updateConfigurationError,
                context: this
            });
        } else {
            this.go();
        }
    },

    /**
     * Success callback for configuration update.
     * Set new local configuration and store in LocalStorage for future use.
     * Then switch to map view.
     */
    updateConfigurationSuccess: function(config) {
        KsMobil.configuration = config;

        localStorage['configuration'] = JSON.stringify(config);

        this.go();
    },

    /**
     * Error callback for configuration update. Set error message and die.
     */
    updateConfigurationError: function() {
        this.set('message', ERROR_UPDATE);
    },

    /**
     * Switch to map view.
     */
    go: function() {
        this.switchToPage(M.ViewManager.getPage('mapPage'));
    },

    /**
     * Decodes error messages into error code and error message
     */
    decodeError: function(message) {
        var error = {};

        var parts = message.split('#');
        if(parts.length < 3) {
            error.code = -1;
            error.message = message;
        } else {
            error.code = parts[0];
            error.message = parts[2];
        }
        return error;
    }
});
