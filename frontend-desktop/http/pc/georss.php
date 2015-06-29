<?php
/**
 * @file
 * georss.php - Proxy für die GeoRSS-Auslieferung
 *
 * GET-Parameter: id=<number>
 */

require_once('../../conf/mapbender.conf');

$WFS_URL = "http://localhost/ows/klarschiff/wms/reflect?layers=klarschiff:vorgaenge_rss&format=rss";

function get_rss_data($id) {
  $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
  $connection = pg_connect($connection_string);

  // Retrieve all data from georss_polygone
  $data = array();
  pg_prepare("", "SELECT g.ideen, g.ideen_kategorien, g.probleme, g.probleme_kategorien, ST_AsText(g.the_geom) AS wkt FROM klarschiff.klarschiff_geo_rss g WHERE md5(g.id::varchar)=$1");
  $result = pg_execute("", array($id));
  if($row = pg_fetch_assoc($result)) {
    $data = $row;
  }
  pg_close($connection);
  return($data);
}

$xml_out = "";
$id = isset($_REQUEST["id"]) ? $_REQUEST["id"] : "";

if($id != "" && count($data = get_rss_data($id))) {
  $cql_filter = "";

  $IDEE_KAT = "";
  $PROB_KAT = "";



  if($data["ideen"] == "t") {
    $cql_filter .= "vorgangstyp = 'idee'";

    $ideen_kategorien = explode(",",$data["ideen_kategorien"]);
    foreach($ideen_kategorien AS $ideeKategorie) {
      if($ideeKategorie != "") {
        $IDEE_KAT .= " OR hauptkategorieid = " . $ideeKategorie;
      }
    }

    if($IDEE_KAT != "") {
      $cql_filter .= " AND (".substr($IDEE_KAT,3).")";
    }
  }

  if($data["probleme"] == "t") {
    if($data["ideen"] == "t") {
      $cql_filter = "((" . $cql_filter . ") OR (";
    }

    $cql_filter .= "vorgangstyp = 'problem'";


    $probleme_kategorien = explode(",",$data["probleme_kategorien"]);
    foreach($probleme_kategorien AS $problemKategorie) {
      if($problemKategorie != "") {
        $PROB_KAT .= " OR hauptkategorieid = " . $problemKategorie;
      }
    }

    if($PROB_KAT != "") {
      $cql_filter .= " AND (".substr($PROB_KAT,3).")";
    }


    if($data["ideen"] == "t") {
      $cql_filter .= "))";
    }
  }

  if(strlen($cql_filter)) {
    $cql_filter .= " AND ";
  }
  $cql_filter .= "WITHIN(the_geom, " . $data["wkt"] . ")";

  $ch = curl_init();
  curl_setopt_array($ch, array(
    CURLOPT_URL => $WFS_URL,
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => "cql_filter=" . urlencode($cql_filter),
    CURLOPT_HEADER => false,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_USERAGENT => $_SERVER['HTTP_USER_AGENT']));

  // Relay answer and
  // Manipulate the referer-feed-URL
  $xml_out  = curl_exec($ch);
  print $xml_out;
  // $search   = '|link....CDATA.htt.+]](.+)|';
  // $replace  = 'link><![CDATA[http://www.klarschiff-hro.de/pc/georss.php?id='.$id.']]${1}';
  // $xml_out = preg_replace($search, $replace, $xml_out);
  // $search   = '|<atom:link href="htt.+"(.+)|';
  // $replace  = '<atom:link href="http://www.klarschiff-hro.de/pc/georss.php?id='.$id.'"${1}';
  // print preg_replace($search, $replace, $xml_out);
  // Didn't work out: After the substitution of this data from the xml-file,
  //    only chromium was able to read the feed, but still with the error
  //    concerning the printing the coordinates at the end of each topic
} else {
  header("HTTP/1.0 404 Not Found");
?>
<html>
  <head>
  </head>
  <body>
    <h1>Fehler</h1>
    <p>Der angeforderte RSS-Feed konnte nicht gefunden werden.</p>
  </body>
</html>
<?php
}
