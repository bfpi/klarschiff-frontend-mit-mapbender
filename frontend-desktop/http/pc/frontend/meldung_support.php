<?php
/**
 * @file
 * Frontend-Fassade für das Absetzen von Unterstützungsmeldungen.
 */
require_once("backend_tunnel.php");
require_once('trashmail.php');

$data = array(
  "id" => $_REQUEST["id"],
  "email" => $_REQUEST["email"]
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
  "email" => $data["email"]
);

$answer = returnRelay($backend_data, "unterstuetzer");

print(utf8_decode($answer['content']));


