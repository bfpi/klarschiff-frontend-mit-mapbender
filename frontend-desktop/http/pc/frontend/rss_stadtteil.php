<?php

require_once('../../../conf/mapbender.conf');

if(isset($_POST["id"])) {
  $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
  $connection = pg_connect($connection_string);



  // Überprüfen ob es sich um Zahlen handelt.
  foreach(explode(",", $_POST["id"]) AS $id) {
    if(is_numeric($id)) {
      $ids[] = $id;
    }
  }

  // SQL aufbauen.
  $sql = "SELECT ST_AsText(ST_Multi(ST_Union(geom))) FROM (";

  for ($i = 0; $i < count($ids); $i++) {
    if($i > 0) {
      $sql .= " UNION ";
    }

    $sql .= " (
      SELECT ST_AsText(the_geom) AS geom
      FROM klarschiff.klarschiff_georss_polygone
      WHERE id = ".$ids[$i]."
    ) ";
  }

  $sql .= " ) as a;";




  // Wenn gültige id/s gefunden wurde/n, Anfrage an die Datenbank.
  if(!empty($ids)) {
    $result = pg_query($sql);

    if(pg_num_rows($result) == 1) {
      $row = pg_fetch_row($result);
      print(json_encode(array("geom" => $row[0])));
    }
  }

  pg_close($connection);

}
