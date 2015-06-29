/**
 * KsMobil - Die Mobilanwendung von Klarschiff Rostock.
 *
 * @author Christian Wygoda <christian.wygoda@wheregroup.com>
 * @author Niels Bennke <bennke@bfpi.de>
 */

var KsMobil  = KsMobil || {};

KsMobil.version = M.Application.config['version'];

// set title to explaining displayName instead of autogenrated short app name
M.Application.name = M.Application.config['displayName'];

var baseUrl = M.Application.config['baseUrl'];
if(baseUrl == null || baseUrl == '') {
  baseUrl = window.location.protocol + '//' + window.location.hostname
}
if(baseUrl.match(/[^/]$/)) baseUrl = baseUrl + '/';

KsMobil.URLS = {
    versions:                 baseUrl + 'frontend/getVersions.php',
    configuration:            baseUrl + 'frontend/getConfig.php',
    onlineCheck:              baseUrl,

    icons:                    baseUrl + 'images/icons/',
    meldungWFS:               baseUrl + 'ows/klarschiff/wfs',
    meldungWFSFeatureNS:      baseUrl + 'ows/klarschiff',

    pointCheck:               baseUrl + 'php/point_check.php',
    meldungSubmit:            baseUrl + 'php/meldung_submit.php',
    meldungSupport:           baseUrl + 'php/meldung_support.php',
    meldungAbuse:             baseUrl + 'php/meldung_abuse.php',
    meldungLobHinweiseKritik: baseUrl + 'php/meldung_lobhinweisekritik.php',
    meldungImage:             baseUrl + 'fotos/',

    search:                   baseUrl + 'search/server.php'
};

/**
 * Anwendungsklasse, definiert alle Seiten der Anwendung und die
 * Startseite.
 */

delete localStorage['configuration'];

KsMobil.app = M.Application.design({
    entryPage:                      'startingPage',
    startingPage:                   KsMobil.StartingPage,
    mapPage:                        KsMobil.MapPage,
    meldungPage:                    KsMobil.MeldungPage,
    unterstuetzenPage:              KsMobil.UnterstuetzenPage,
    missbrauchPage:                 KsMobil.MissbrauchPage,
    meldenPage:                     KsMobil.MeldenPage,
    lobenHinweisenKritisierenPage:  KsMobil.LobenHinweisenKritisierenPage,
    suchenPage:                     KsMobil.SuchenPage
});
