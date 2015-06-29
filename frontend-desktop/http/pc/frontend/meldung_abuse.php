<?php
/**
 * @file
 * Frontend-Fassade für Absetzen einer Missbrauchsmeldung
 */

require_once("backend_tunnel.php");
require_once('trashmail.php');

$data = array(
  "id" => $_REQUEST["id"],
  "email" => $_REQUEST["email"],
  "details" => $_REQUEST["details"]
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
  "text" => $data["details"],
  "email" => $data["email"]
);

$answer = returnRelay($backend_data, "missbrauchsmeldung");

print(utf8_decode($answer['content']));
