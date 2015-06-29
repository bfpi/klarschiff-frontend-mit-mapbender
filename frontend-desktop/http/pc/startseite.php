<?php

require_once('../../conf/mapbender.conf');

$openlayers = KS_PC_APP_BASE . '/pc/OpenLayers-2.13.1/OpenLayers.js';
$jquery = KS_PC_APP_BASE . '/extensions/jquery-ui-1.8.1.custom/js/jquery-1.4.2.min.js';
$karte_url = KS_PC_APP_BASE . '/frames/login.php?mb_user_myGui=Klarschiff&name=public&password=public';

$connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
$connection = pg_connect($connection_string);

// neue Meldungen letzten Monat
pg_prepare('', "SELECT COUNT(id) FROM klarschiff.klarschiff_vorgang WHERE datum >= (now() - (INTERVAL '1' MONTH)) AND status IN ('offen','inBearbeitung','wirdNichtBearbeitet','abgeschlossen')");
$result = pg_execute("", array());
$row = pg_fetch_assoc($result);
$letzten_monat_neu = $row['count'];

// Meldungen erledigt letzten Monat
pg_prepare('', "SELECT COUNT(id) FROM klarschiff.klarschiff_vorgang WHERE datum_statusaenderung >= (now() - (INTERVAL '1' MONTH)) AND status = 'abgeschlossen'");
$result = pg_execute("", array());
$row = pg_fetch_assoc($result);
$letzten_monat_erledigt = $row['count'];

// neue Meldungen seit 28.03.2012
pg_prepare('', "SELECT COUNT(id) FROM klarschiff.klarschiff_vorgang WHERE datum::date >= '2012-03-28 00:00:00.0'::date AND status IN ('offen','inBearbeitung','wirdNichtBearbeitet','abgeschlossen')");
$result = pg_execute("", array());
$row = pg_fetch_assoc($result);
$seit_start_neu = $row['count'];

// kürzlich gemeldet
pg_prepare('', "SELECT v.id, v.vorgangstyp AS typ, v.status, x.name AS hauptkategorie, k.name AS unterkategorie FROM klarschiff.klarschiff_vorgang v, klarschiff.klarschiff_kategorie k, klarschiff.klarschiff_kategorie x WHERE v.archiviert IS NOT TRUE AND v.status IN ('offen','inBearbeitung','wirdNichtBearbeitet','abgeschlossen') AND v.kategorieid = k.id AND k.parent = x.id ORDER BY v.datum DESC LIMIT 5");
$result = pg_execute("", array());
$counter = 0;
$id = array();
$typ = array();
$status = array();
$hauptkategorie = array();
$unterkategorie = array();
$bildpfad = array();
while ($row = pg_fetch_assoc($result)) {
  $id[$counter] = $row['id'];
  $typ[$counter] = $row['typ'];
  $status[$counter] = $row['status'];
  $hauptkategorie[$counter] = $row['hauptkategorie'];
  $unterkategorie[$counter] = $row['unterkategorie'];
  $bildpfad[$counter] = "media/icons/" . $row['typ'] . "_" . $row['status'] . "_layer.png";
  $counter++;
}

pg_close($connection);

print '<?xml version="1.0" encoding="utf-8" ?>';

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta name="keywords" content="Portal,Bürgerbeteiligung,Karte,Probleme,Ideen,Verwaltung" />
<meta name="description" content="Melden Sie via Karte Probleme und Ideen im öffentlichen Raum, die dann von einer kommunalen Verwaltung bearbeitet werden." />
<meta name="author" content="Hansestadt Rostock" />
<title>Klarschiff – Portal zur Bürgerbeteiligung – Frontend</title>
<link rel="stylesheet" type="text/css" media="all" href="startseite.css" />
<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
<link rel="alternate" type="application/atom+xml" title="Klarschiff: Meldungen" href="rss.php" />
<script type="text/javascript" src="jquery/jquery-1.6.2.min.js"></script>
<script type="text/javascript" src="search/inc/search.js"></script>
</head>
<body onload="eye_catcher();">
<div id="header">
  DEMO
</div>
<div id="menu">
  <ul id="menu_list">
    <li class="menu_item first">
    <a href="<?php print $karte_url ?>" target="_self">Karte</a>
    </li>
    <li class="menu_item">
    <a href="hilfe.html" target="_blank">Hilfe</a>
    </li>
    <li class="menu_item">
    <a href="datenschutz.html" target="_blank">Datenschutz</a>
    </li>
    <li class="menu_item">
    <a href="impressum.html" target="_blank">Impressum</a>
    </li>
    <li class="menu_item last">
    <a href="nutzungsbedingungen.html" target="_blank">Nutzungsbedingungen</a>
    </li>
  </ul>
</div>
<div id="eye-catcher">
  <div class="overlay guide">
    <span class="bold"><span class="italic">Klarschiff</span> –
      <br/>
      Bürgerbeteiligung</span>
    <br/>
    <br/>
    Rufen Sie die <a href="<?php print $karte_url ?>" target="_self"><span class="bold">Karte</span></a> auf <span class="bold">→</span> setzen Sie Ihre Meldung an die passende Stelle <span class="bold">→</span> beschreiben Sie Ihre Meldung kurz <span class="bold">→</span> verfolgen Sie, wie die Stadtverwaltung die Bearbeitung übernimmt.
    <br/>
    <br/>
    Eine genaue Anleitung finden Sie <a href="hilfe.html" target="_blank"><span class="bold">hier</span></a>.
  </div>
  <div class="overlay news">
    <span class="bold">Achtung!</span>
    <br/>
    <br/>
    Da es sich bei der vorliegenden Anwendung lediglich um eine <span class="bold">Demo</span> zu Anschauungs- und Testzwecken handelt, werden eingehende Meldungen naturgemäß <span class="bold">nicht</span> als reale Fälle angesehen und von der Stadtverwaltung auch <span class="bold">nicht</span> als solche bearbeitet.
  </div>
  <div id="map" onclick="location.href='<?php print $karte_url ?>';" title="Karte aufrufen…"></div>
</div>
<div id="main">
  <div class="column left">
    <span class="bold">Statistik</span>
    <br/>
    <div id="statistics">
      <div class="statistics_block">
        <div class="statistics_number red"><?php print $letzten_monat_neu ?></div>
        <div class="statistics_text">neue Meldungen letzten Monat</div>
        <div class="divider"></div>
        <div class="clear"></div>
      </div>
      <div class="statistics_block following">
        <div class="statistics_number green"><?php print $letzten_monat_erledigt ?></div>
        <div class="statistics_text">Meldungen erledigt letzten Monat</div>
        <div class="divider"></div>
        <div class="clear"></div>
      </div>
      <div class="statistics_block following">
        <div class="statistics_number yellow"><?php print $seit_start_neu ?></div>
        <div class="statistics_text">neue Meldungen seit 28.03.2012</div>
        <div class="divider"></div>
        <div class="clear"></div>
      </div>
    </div>
  </div>
  <div class="column right">
    <span class="bold">Kürzlich gemeldet</span><img id="rss" src="media/rss.png" alt="rss-feed" title="Meldungen als RSS-Feed abonnieren…" onclick="window.open('rss.php');" />
    <div class="issue" onclick="location.href='<?php print $karte_url ?>&meldung=<?php print $id[0] ?>';" title="Karte aufrufen mit Fokus auf diese Meldung…">
      <div class="issue_icon"><img src=<?php print $bildpfad[0] ?> alt="icon" /></div>
      <div class="issue_text"><?php print $hauptkategorie[0] ?><br/><?php print $unterkategorie[0] ?></div>
      <div class="divider"></div>
      <div class="clear"></div>
    </div>
    <div class="issue following" onclick="location.href='<?php print $karte_url ?>&meldung=<?php print $id[1] ?>';" title="Karte aufrufen mit Fokus auf diese Meldung…">
      <div class="issue_icon"><img src=<?php print $bildpfad[1] ?> alt="icon" /></div>
      <div class="issue_text"><?php print $hauptkategorie[1] ?><br/><?php print $unterkategorie[1] ?></div>
      <div class="divider"></div>
      <div class="clear"></div>
    </div>
    <div class="issue following" onclick="location.href='<?php print $karte_url ?>&meldung=<?php print $id[2] ?>';" title="Karte aufrufen mit Fokus auf diese Meldung…">
      <div class="issue_icon"><img src=<?php print $bildpfad[2] ?> alt="icon" /></div>
      <div class="issue_text"><?php print $hauptkategorie[2] ?><br/><?php print $unterkategorie[2] ?></div>
      <div class="divider"></div>
      <div class="clear"></div>
    </div>
    <div class="issue following" onclick="location.href='<?php print $karte_url ?>&meldung=<?php print $id[3] ?>';" title="Karte aufrufen mit Fokus auf diese Meldung…">
      <div class="issue_icon"><img src=<?php print $bildpfad[3] ?> alt="icon" /></div>
      <div class="issue_text"><?php print $hauptkategorie[3] ?><br/><?php print $unterkategorie[3] ?></div>
      <div class="divider"></div>
      <div class="clear"></div>
    </div>
  </div>
  <div class="column center">
    <div id="search">
      <span class="bold">Adressensuche</span>
      <br/>
      <div id="search_block">
        <input id="searchtext" size="20" type="text" name="searchtext" title="Stadtteil, Straße oder Adresse eingeben…" />
        <div class="results" id="results_container"></div>
      </div>
    </div>
    <div id="start">
      <div id="start_block">
        <a id="start_button" href="<?php print $karte_url ?>" target="_self">Karte aufrufen</a>
      </div>
    </div>
  </div>
</div>
<div class="footer small_footer">
  <span class="bold"><span class="italic">Klarschiff</span> mobil</span>
  <br/>
  <br/>
  Wenn Sie diese Website mit einem Smartphone oder Tablet besuchen, wird automatisch die <a href="/mobil" target="_self"><span class="bold">mobile Version</span></a> von <span class="italic">Klarschiff</span> gestartet.
</div>
<div class="footer large_footer">
  <span class="bold"><span class="italic">Klarschiff</span> aus Sicht der Verwaltung</span>
  <br/>
  <br/>
  Falls Sie daran interessiert sind, wie die „Rückseite“ von <span class="italic">Klarschiff</span> aussieht, also die Verwaltungsanwendung, dann rufen Sie dieses als <a href="/backend" target="_blank"><span class="bold">Backend</span></a> bezeichnete Anwendung doch einfach auf.
</div>
<script type="text/javascript" src="<?php print $openlayers; ?>"></script>
<script type="text/javascript" src="<?php print $jquery; ?>"></script>
<script type="text/javascript">var markerOffset = <?php print LP_MARKER_OFFSET ?>;</script>
<script type="text/javascript" src="startseite.js"></script>
</body>
</html>
