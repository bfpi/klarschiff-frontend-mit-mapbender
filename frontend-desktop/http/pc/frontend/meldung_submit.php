<?php
/**
 * @file
 * Front-Fassade für das Absetzen einer neuen Meldung.
 */

require_once('../../../conf/mapbender.conf');
require_once("backend_tunnel.php");
require_once('trashmail.php');

$data = array(
  "task" => $_REQUEST["task"],
  "typ" => $_REQUEST["typ"],
  "point" => $_REQUEST["point"],
  "hauptkategorie" => intval($_REQUEST["hauptkategorie"]),
  "unterkategorie" => intval($_REQUEST["unterkategorie"]),
  "betreff" => $_REQUEST["betreff"],
  "details" => $_REQUEST["details"],
  "email" => $_REQUEST["email"],
  "foto" => $_FILES["foto"]
);

function validate_meldung_in_aoi($point) {
  $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
  $connection = pg_connect($connection_string);

  // Retrieve all data from georss_polygone
  $data = array();
  pg_prepare("", "SELECT ST_Within(ST_GeometryFromText($1, 25833), klarschiff.klarschiff_stadtgrenze_hro.the_geom) FROM klarschiff.klarschiff_stadtgrenze_hro");
  $result = pg_execute("", array($point));
  if($row = pg_fetch_assoc($result)) {
    return ($row["st_within"] == 't');
  }
  pg_close($connection);

  return false;
}
/**
 * resize an image inPlace
 * @param String path to image to resize
 * @return the path to the scaled image
 * Throws exceptions on error
 */
function scaleImage($origImgPath,$maxWidth=360,$maxHeight=360){
  $origImgInfo = getimagesize($origImgPath);

  if($origImgInfo[0] > $maxWidth || $origImgInfo[1] > $maxHeight){


    $origImg = null;
    switch( $origImgInfo[2]){

    case IMAGETYPE_GIF:
      $origImg = imagecreatefromgif($origImgPath);
      break;

    case IMAGETYPE_JPEG:
      $origImg = imagecreatefromjpeg($origImgPath);
      break;

    case IMAGETYPE_PNG:
      $origImg = imagecreatefrompng($origImgPath);
      break;

    default:
      die("1110#1110#Der Dateityp des Fotos wurde nicht erkannt.");

    }


    //  width           height
    if($origImgInfo[0] > $origImgInfo[1]){

      $scaledWidth = $maxWidth;
      $scaledHeight = $origImgInfo[1] / ($origImgInfo[0]/$maxWidth);

    }else{
      // else works for < and ==

      $scaledHeight = $maxHeight;
      $scaledWidth = $origImgInfo[0] / ($origImgInfo[1]/$maxHeight);
    }


    if (($resizedImg = imagecreatetruecolor($scaledWidth,$scaledHeight))== false){
      die("1111#1111#Das Foto konnte nicht erstellt werden.");
    }

    if(imagecopyresized( $resizedImg, $origImg,0,0,0,0,$scaledWidth,$scaledHeight,$origImgInfo[0],$origImgInfo[1] ) == false){
      die("1112#1112#Das Foto konnte nicht skaliert werden.");
    }

    switch( $origImgInfo[2]){

    case IMAGETYPE_GIF:
      if(!imagegif($resizedImg,$origImgPath)){
        die("1113#1113#Das Foto konnte nicht als *.gif gespeichert werden.");
      }
      break;

    case IMAGETYPE_JPEG:
      if(!imagejpeg($resizedImg,$origImgPath)){
        die("1113#1113#Das Foto konnte nicht als *.jpeg gespeichert werden.");
      }
      break;

    case IMAGETYPE_PNG:
      if(!imagepng($resizedImg,$origImgPath)){
        die("1113#1113#Das Foto konnte nicht als *.png gespeichert werden.");
      }
      break;

    default:
      die("1110#1110#Der Dateityp des Fotos wurde nicht erkannt.");
    }
  }

  return $origImgPath;

}

/*****************************************************************************/
/*                     VALIDIERUNG & TRANSFORMIERUNG                         */
/*****************************************************************************/

$required_keys = array('email', 'task', 'point');
foreach($required_keys as $key) {
  if(!array_key_exists($key, $_REQUEST)) {
    die(sprintf('1100#1100#[%s] fehlt', $key));
  }
}

$trashmail_check = trashmail_check($data['email']);
if($trashmail_check) {
  die($trashmail_check);
}

switch($data["task"]) {
case "validate":
  $mydebug .= "\n\rvalidate";
  print json_encode(validate_meldung_in_aoi($data["point"]));
  break;
case "submit":
  $mydebug .= "\n\rvalidate";
  if(validate_meldung_in_aoi($data["point"])) {
    $backend_data = array(
      "typ" => $data["typ"],
      "kategorie" => $data["unterkategorie"] ? $data["unterkategorie"] : $data["hauptkategorie"],
      "oviWkt" => $data["point"],
      "autorEmail" => $data["email"],
      "betreff" => $data["betreff"],
      "details" => $data["details"]
    );

    $origImgPath = $data["foto"]["tmp_name"];
    $imgInfo = pathinfo($data['foto']['name']);
    if($data['foto'] != NULL && $data['foto']['name'] !== '' && !in_array(strtolower($imgInfo['extension']), array(
      'jpg', 'jpeg', 'png', 'gif'
    ))) {
      die("1110#1110#Der Dateityp des Fotos wurde nicht erkannt.");
    }
    $scaledImgPath = scaleImage($origImgPath,720,720);
    $fh = fopen($scaledImgPath, "r");
    if($fh) {
      $fd = fread($fh, filesize($scaledImgPath));
      $fd_base64 = base64_encode($fd);
      $backend_data["bild"] = $fd_base64;
    }

    relay($backend_data, "vorgang");
  } else {
    header('Content-type: text/html; charset=utf-8');
    print "1002#1002#Die neue Meldung befindet sich außerhalb Rostocks.";
  }
  break;
}
