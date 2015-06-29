<?php
/**
 * @file
 * Front-Fassade für das Absetzen einer neuen Meldung.
 */

require_once('../../../conf/mapbender.conf');

$connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
$connection = pg_connect($connection_string);

pg_prepare("", "SELECT encode(foto_normal_jpg, 'base64') as b FROM klarschiff.klarschiff_vorgang WHERE id=88");
$result = pg_execute("", array());
// header('Content-Type: image/jpg');
while($row = pg_fetch_assoc($result)) {
  // print base64_decode($row['b']);
  print $row['b'];
}
pg_close($connection);

