
// Start pc/config_projekt.php

<?php
/**
 * @file
 * Lädt die projektspezifischen Datebankinhalt, die zur Laufzeit
 * im Browser benötigt werden und hinterlegt diese im Javascript-Array
 * ks_lut
 */
require_once(dirname(__FILE__)."/../php/mb_validateSession.php");
require_once(dirname(__FILE__)."/../classes/class_element.php");
require_once(dirname(__FILE__)."/../classes/class_wms.php");

// Der Name des GUI-Elementes (ol_map) ist hier hardkodiert!!!
$gui_id = Mapbender::session()->get("mb_user_gui");
$e_id = "kartenelemente";

$ol_config = array();

// Kleiner Hack, um an die Element-Vars für das Element ol_map zu gelangen
print("var options = Mapbender.modules." . $e_id . ";\n");
include('../include/dyn_js_object.php');

$lut = array();

$connection = pg_connect("host=localhost port=5432 dbname=klarschiff_frontend user=klarschiff_frontend password=klarschiff_frontend");
$res = db_query("SELECT * FROM klarschiff.klarschiff_kategorie ORDER BY name");
while($row = db_fetch_assoc($res)) {
  $lut["kategorie"][$row["id"]] = array(
    "name" => $row["name"],
    "parent" => $row["parent"],
    "childcount" => 0,
    "typ" => $row["vorgangstyp"],
    "aufforderung" => $row["aufforderung"],
    "naehere_beschreibung_notwendig" => $row["naehere_beschreibung_notwendig"]
  );
}

foreach($lut["kategorie"] as $key => $val) {
  $parent = $val["parent"];
  if($parent) {
    $childcount = $lut["kategorie"][$parent]["childcount"];
    $lut["kategorie"][$parent]["childcount"] = $childcount + 1;
  }
}
pg_close($connection);

$connection = pg_connect("host=localhost port=5432 dbname=klarschiff_frontend user=klarschiff_frontend password=klarschiff_frontend");
$res = db_query("SELECT * FROM klarschiff.klarschiff_vorgangstyp");
while($row = db_fetch_assoc($res)) {
  $lut["typ"][$row["id"]] = $row;
}
pg_close($connection);

$connection = pg_connect("host=localhost port=5432 dbname=klarschiff_frontend user=klarschiff_frontend password=klarschiff_frontend");
$res = db_query("SELECT * FROM klarschiff.klarschiff_status");
while($row = db_fetch_assoc($res)) {
  $lut["status"][$row["id"]] = $row;
}
pg_close($connection);

$meldung = null;

$connection = pg_connect("host=localhost port=5432 dbname=klarschiff_frontend user=klarschiff_frontend password=klarschiff_frontend");
if (isset($_GET["meldung"])){
  $sql = "SELECT id, ST_X(the_geom) as x, ST_Y(the_geom) as y FROM klarschiff.klarschiff_wfs WHERE id=$1";
  $v = array($_GET["meldung"]);
  $t = array('i');
  $res = db_prep_query($sql, $v, $t);
  while($row = db_fetch_assoc($res)) {
    $meldung = $row;
  }
}

if(isset($_GET['x']) && isset($_GET['y'])) {
  $meldung = array(
    'x' => floatval($_GET['x']),
    'y' => floatval($_GET['y'])
  );
}

$bbox = null;
if(!empty($_GET["BBOX"])) {
  if(substr($_GET["BBOX"],0,3) == "BOX") {
    $bbox = array();
    foreach(explode(",",substr($_GET["BBOX"],4,-1)) AS $i) {
      foreach(explode(" ",$i) AS $j) {
        $bbox[] = $j;
      }
    }
  }
}
pg_close($connection);
?>

var ks_lut = <?php echo json_encode($lut); ?>;

var ks_config = $.extend({}, options);
var ks_meldung = <?php echo json_encode($meldung); ?>;
var ks_bbox = <?php echo json_encode($bbox); ?>;

// Ende pc/config_project.php
