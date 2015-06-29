<?php
require_once('../../../conf/mapbender.conf');
$connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
$connection = pg_connect($connection_string);

$result = pg_query("SELECT ST_AsText(the_geom) FROM klarschiff.klarschiff_stadtgrenze_hro LIMIT 1;");

if(pg_num_rows($result) == 1) {
  $row = pg_fetch_row($result);
  print(json_encode(array("geom" => $row[0])));
}

pg_close($connection);
