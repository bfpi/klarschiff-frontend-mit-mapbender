<?php
require_once dirname(__FILE__)."/solrSearch.conf";
require_once dirname(__FILE__)."/inc/functions.php";

echo "<br/>\nclear index.\n";
include dirname(__FILE__)."/clearIndex.php";

$conn = pg_connect("host=".HOST." port=".PORT." dbname=".NAME." user=".USER." password=".PASS."");
if(!$conn) die("Error: pg_connect!");
echo "<br/>connect ok";

$csv = "";
$count = 0;
$colArray = array_merge(explode(",",COLUMNS),array("geom"));

// SELECT ALL DATA FROM DB
$result = pg_query($conn, "SELECT ".COLUMNS.",st_box2d(geom) AS bbox, st_dimension(geom) AS dimension FROM ".SCHEMA.".".TABLE.";");

echo "<br/>Numrows :".pg_num_rows($result);
echo "<br/>Last error : ".pg_last_error();

// GET ALL DATA AND FILL THE CSV
while($row = pg_fetch_assoc($result)) {
  if($row["dimension"] == 0 AND substr($row["bbox"],0,3) == "BOX") {
    $tmp = split(",",substr($row["bbox"],4,-1));
    $row["geom"] = "BOX(".$tmp[0].",".$tmp[0].")";
  } else {
    $row["geom"] = $row["bbox"];
  }
  /***********************************************************************
   * C L E A N
   ***********************************************************************/
  if(!empty($row["poi_titel"])) {
    $row["stadtteil_name"] = "";
    $row["strasse_name"] = "";
  } else if(!empty($row["stadtteil_name"])) {
    $row["strasse_name"] = "";
    $row["poi_titel"] = "";
    $row["poi_alternativtitel"] = "";
  } else if(!empty($row["strasse_name"])) {
    $row["stadtteil_name"] = "";
    $row["poi_titel"] = "";
    $row["poi_alternativtitel"] = "";
    $row["hausnummer"] = "";
    $row["hausnummerzusatz"] = "";
  }

  /***********************************************************************
   * B O O S T - START
   ***********************************************************************/
  if(!empty($row["stadtteil_name"])) {
    $row["stadtteil"] = $row["stadtteil_name"];		
    $row["strasse"] = $row["stadtteil_name"];
  } else if(!empty($row["strasse_name"])) {
    $row["strasse"] = $row["strasse_name"];
  }
  /***********************************************************************
   * B O O S T - END
   ***********************************************************************/


  $csv_line = "";

  foreach($colArray AS $col) {
    $csv_line .= ",".prepareCol(@$row[$col]);
  }

  $csv.= "\n".substr($csv_line,1);

  if(CSV_MAX_COUNT <= $count++) {
    echo "*";
    updateLucene($colArray,$csv);
    //http_post(UPDATE_URL,"<commit/>","Content-Type: text/xml\r\n");
    $count = 0;
    $csv = "";
  }
}

// IF CSV NOT EMPTY
if(!empty($csv)) {
  echo "*";
  updateLucene($colArray,$csv);
}

// COMMIT DATA
$response = http_post (UPDATE_URL,"<commit/>","Content-Type: text/xml\r\n");

echo "<br/>\ndone\n";


?>
