<?php
require_once('../../../conf/mapbender.conf');

define('BUFFER', 10);

$included = strtolower(realpath(__FILE__))
  != strtolower(realpath($_SERVER['SCRIPT_FILENAME']));

function point_check(&$wkt, $displace) {
  $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
  $connection = pg_connect($connection_string);

  // Inside allowed area?
  if(!inside_allowed_area_check($wkt)) {
    return '1002#1002#Die neue Meldung befindet sich außerhalb Rostocks.';
  }

  pg_close($connection);
  return false;
}

function inside_allowed_area_check($wkt) {
  pg_prepare("", "SELECT ST_Within(ST_GeometryFromText($1, 25833), klarschiff.klarschiff_stadtgrenze_hro.the_geom) FROM klarschiff.klarschiff_stadtgrenze_hro");
  $result = pg_execute("", array($wkt));
  if($row = pg_fetch_assoc($result)) {
    return $row['st_within'] === 't';
  }
  return false;
}

if(!$included) {
  $wkt = $_REQUEST['point'];
  $ptc = point_check($wkt, false);
  if($ptc) {
    die($ptc);
  }
}

