<?php
require_once('../../../conf/mapbender.conf');

function trashmail_check($email) {
  $connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
  $connection = pg_connect($connection_string);

  $blacklist_this = false;

  if($connection) {
    pg_prepare('', "SELECT COUNT(*) FROM klarschiff.klarschiff_trashmail_blacklist WHERE $1 LIKE '%@' || pattern OR $2 LIKE '%.' || pattern");
    $result = pg_execute('', array($_REQUEST['email'], $_REQUEST['email']));
    if($row = pg_fetch_assoc($result)) {
      $blacklist_this = $row["count"] !== '0';
    }
    pg_close($connection);
  }

  return $blacklist_this ? '1001#1001#Ihre E-Mail-Adresse wird nicht akzeptiert, da sie auf unserer Trashmail-Blacklist steht.' : false;
}

