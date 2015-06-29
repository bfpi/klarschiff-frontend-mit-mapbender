<?php
    require_once('../../conf/mapbender.conf');

    $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
    $connection = pg_connect($connection_string);
    Header("Content-Type: text/xml; charset=utf-8");
    echo '<?xml version="1.0" encoding="utf-8"?>
          <rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:georss="http://www.georss.org/georss">
          <channel>
          <title>Klarschiff: Meldungen</title>
          <atom:link href="http://demo.klarschiff-hro.de/pc/rss.php" rel="self" type="application/rss+xml" />
          <link>http://demo.klarschiff-hro.de</link>
          <description>Meldungen im Bürgerbeteiligungsportal Klarschiff</description>
          <language>de-de</language>
          <copyright>Hansestadt Rostock</copyright>
          <image>
            <url>http://demo.klarschiff-hro.de/pc/media/rss-logo.png</url>
            <title>Klarschiff: Meldungen</title>
            <link>http://demo.klarschiff-hro.de</link>
          </image>
          ';
    $query = pg_query("SELECT v.id, v.datum::timestamp, v.vorgangstyp AS typ, v.status, hk.name AS hauptkategorie, uk.name AS unterkategorie, v.betreff_vorhanden, v.betreff_freigegeben, v.titel AS betreff, v.details_vorhanden, v.details_freigegeben, v.details, v.foto_vorhanden, v.foto_freigegeben, v.foto_thumb, v.bemerkung, wfs.unterstuetzer AS unterstuetzungen, ST_X(ST_Transform(v.the_geom,4326)) AS x, ST_Y(ST_Transform(v.the_geom,4326)) AS y FROM klarschiff.klarschiff_vorgang v, klarschiff.klarschiff_kategorie uk, klarschiff.klarschiff_kategorie hk, klarschiff.klarschiff_wfs wfs WHERE v.archiviert IS NOT TRUE AND v.status IN ('offen','inBearbeitung','wirdNichtBearbeitet','abgeschlossen') AND v.kategorieid = uk.id AND uk.parent = hk.id AND v.id = wfs.id ORDER BY v.datum DESC");

    while ($result = pg_fetch_array($query)) {
        $title = "#".$result['id']." ".ucfirst($result['typ'])." (".$result['hauptkategorie']." – ".$result['unterkategorie'].")";
        switch($result['status']) {
            case ("inBearbeitung"):
                $status = "in Bearbeitung";
            break;
            case ("wirdNichtBearbeitet"):
                $status = "wird nicht bearbeitet";
            break;
            default:
                $status = $result['status'];
            break;
        }
        if ($result['betreff_vorhanden'] == 't' && $result['betreff_freigegeben'] == 't' && $result['betreff'] != '')
            $betreff = $result['betreff'];
        else if ($status == 'offen' && $result['betreff_vorhanden'] == 't' && $result['betreff_freigegeben'] == 'f')
            $betreff = "<i>redaktionelle Prüfung ausstehend</i>";
        else if ($status != 'offen' && $result['betreff_vorhanden'] == 't' && $result['betreff_freigegeben'] == 'f')
            $betreff = "<i>redaktionell nicht freigegeben</i>";
        else
            $betreff = "<i>nicht vorhanden</i>";
        if ($result['details_vorhanden'] == 't' && $result['details_freigegeben'] == 't' && $result['details'] != '')
            $details = $result['details'];
        else if ($status == 'offen' && $result['details_vorhanden'] == 't' && $result['details_freigegeben'] == 'f')
            $details = "<i>redaktionelle Prüfung ausstehend</i>";
        else if ($status != 'offen' && $result['details_vorhanden'] == 't' && $result['details_freigegeben'] == 'f')
            $details = "<i>redaktionell nicht freigegeben</i>";
        else
            $details = "<i>nicht vorhanden</i>";
        if ($result['foto_vorhanden'] == 't' && $result['foto_freigegeben'] == 't')
            $foto = "<br/><img src='http://demo.klarschiff-hro.de/fotos/".$result['foto_thumb']."' alt='".$result['foto_thumb']."'>";
        else if ($status == 'offen' && $result['foto_vorhanden'] == 't' && $result['foto_freigegeben'] == 'f')
            $foto = "<i>redaktionelle Prüfung ausstehend</i>";
        else if ($status != 'offen' && $result['foto_vorhanden'] == 't' && $result['foto_freigegeben'] == 'f')
            $foto = "<i>redaktionell nicht freigegeben</i>";
        else
            $foto = "<i>nicht vorhanden</i>";
        if ($result['bemerkung'] != '')
            $bemerkung = $result['bemerkung'];
        else
            $bemerkung = "<i>nicht vorhanden</i>";
        if ($result['unterstuetzungen'] > 0)
            $unterstuetzungen = $result['unterstuetzungen'];
        else
            $unterstuetzungen = "<i>bisher keine</i>";
        $link = htmlentities(strip_tags("http://demo.klarschiff-hro.de/frames/login.php?mb_user_myGui=Klarschiff&name=public&password=public&meldung=".$result['id']), ENT_QUOTES);
        $date = date('D, d M Y H:i:s O', strtotime($result['datum']))."\n";

        echo "<item>";
        echo "<title>$title</title>";
        echo "<description><![CDATA[<b>Status:</b> ".$status."<br/><b>Unterstützungen:</b> ".$unterstuetzungen."<br/><b>Betreff:</b> ".$betreff."<br/><b>Details:</b> ".$details."<br/><b>Foto:</b> ".$foto."<br/><b>Info der Verwaltung:</b> ".$bemerkung."<br/><a href='".$link."' target='_blank'>Meldung in Klarschiff ansehen</a>]]></description>";
        echo "<link>$link</link>";
        echo "<guid>$link</guid>";
        echo "<pubDate>$date</pubDate>";
        echo "<georss:point>".$result['y']." ".$result['x']."</georss:point>";
        echo "</item>";
    }
echo "</channel></rss>";
pg_close($connection);
