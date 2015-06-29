<?php
/**
 * @file
 * Frontend-Fassade für Absetzen von Lob, Hinweisen oder Kritik zu einer Meldung
 */

require_once("backend_tunnel.php");
require_once('trashmail.php');

$data = array(
  "id" => $_REQUEST["id"],
  "email" => $_REQUEST["email"],
  "freitext" => $_REQUEST["freitext"]
);

/*****************************************************************************/
/*                     VALIDIERUNG & TRANSFORMIERUNG                         */
/*****************************************************************************/
$trashmail_check = trashmail_check($data['email']);
if($trashmail_check) {
  die($trashmail_check);
}

$backend_data = array(
  "vorgang" => $data["id"],
  "email" => $data["email"],
  "freitext" => $data["freitext"]
);

$answer = returnRelay($backend_data, "lobHinweiseKritik");

print(utf8_decode($answer['content']));
