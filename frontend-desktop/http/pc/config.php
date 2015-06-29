
// Start pc/config.php

<?php
/** File: config.php
 * config.php lädt die GUI-Konfiguration für die Erstellung
 * der OpenLayers-Karte. Diese wird in das Javascript-Array
 * mb_ol_config abgespeichert.
 *
 * Author:
 * Christian Wygoda <christian.wygoda@wheregroup.com>
 */

require_once(dirname(__FILE__)."/../php/mb_validateSession.php");
require_once(dirname(__FILE__)."/../classes/class_element.php");
require_once(dirname(__FILE__)."/../classes/class_wms.php");

// Der Name des GUI-Elementes (ol_map) ist hier hardkodiert!!!
$gui_id = Mapbender::session()->get("mb_user_gui");
$e_id = "ol_map";

$ol_config = array();

// Kleiner Hack, um an die Element-Vars für das Element ol_map zu gelangen
print("var options = Mapbender.modules." . $e_id . ";\n");
include('../include/dyn_js_object.php');

//
// Get all WMS layers
//
$sql = "SELECT fkey_wms_id FROM gui_wms WHERE fkey_gui_id = $1 ORDER BY gui_wms_position";
$v = array($gui_id);
$t = array('s');
$res = db_prep_query($sql,$v,$t);

$ol_config["layers"] = array();

while($row = db_fetch_array($res)) {
  $wms = new wms();
  $wms->createObjFromDB(Mapbender::session()->get("mb_user_gui"),$row["fkey_wms_id"]);

  $layers = array();
  $bbox = null;
  $layerName = "";
  $count = 0;
  foreach($wms->objLayer as $layer) {
    if(!$layer->gui_layer_status)
      continue;

    $layers[] = $layer->layer_name;

    if($count == 0)
      $layerName = $layer->gui_layer_title;

    foreach($layer->layer_epsg as $epsg) {
      if($epsg["epsg"] == $wms->gui_wms_epsg)
        $bbox = array(
          floatval($epsg["minx"]),
          floatval($epsg["miny"]),
          floatval($epsg["maxx"]),
          floatval($epsg["maxy"]),
        );
    }
    $count++;
  }

  $ol_config["layers"][$layerName] = array(
    "type" => "WMS",
    "url" => $wms->wms_getmap,
    "version" => $wms->wms_version,
    "layers" => implode(",", $layers),
    "visibility" => ($wms->gui_wms_visible=="1" ? true : false),
    "mb_id" => $wms->wms_id,
    "projection" => $wms->gui_wms_epsg,
    "extent" => $bbox,
    "format" => $wms->gui_wms_mapformat
  );
}

if(count($ol_config["layers"])) {
  $layerNames = array_keys($ol_config["layers"]);
  $ol_config["maxExtent"] = $ol_config["layers"][$layerNames[0]]["extent"];
  $ol_config["projection"]  = $ol_config["layers"][$layerNames[0]]["projection"];
} else {
  $ol_config["maxExtent"] = array(-180, -90, 180, 90);
  $ol_config["projection"] = "EPSG:4326";
}

?>
var mb_ol_config = <?php print json_encode($ol_config); ?>;
$.extend(mb_ol_config, options);
OpenLayers.ImgPath = options.ImgPath;

// Ende pc/config.php
