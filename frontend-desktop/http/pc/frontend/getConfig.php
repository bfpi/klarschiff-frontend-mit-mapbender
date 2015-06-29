<?php

require_once('../../../conf/mapbender.conf');
include('../../../conf/ksmobil.conf');

$connectionString = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
$connection = pg_connect($connectionString);

$config = array(
);

$res = pg_query('SELECT * FROM klarschiff.klarschiff_vorgangstyp');
while($row = pg_fetch_assoc($res)) {
  $config['vorgangstyp'][$row['ordinal']] = $row;
}

$res = pg_query('SELECT * FROM klarschiff.klarschiff_status');
while($row = pg_fetch_assoc($res)) {
  $config['status'][$row['nid']] = $row;
}

$res = pg_query('SELECT * FROM klarschiff.klarschiff_kategorie ORDER BY name');
while($row = pg_fetch_assoc($res)) {
  $config['kategorie'][$row['id']] = $row;
}

pg_close($connection);

$connectionString = sprintf("host=%s dbname=%s user=%s password=%s", DBSERVER, DB, OWNER, PW);
$connection = pg_connect($connectionString);

$res = pg_query("SELECT e_content FROM mapbender.gui_element WHERE fkey_gui_id = 'Klarschiff' AND e_id = 'template_meldung_show_mobil'");
$row = pg_fetch_assoc($res);
$config['meldung_template'] = $row['e_content'];

$res = pg_query("SELECT var_value FROM mapbender.gui_element_vars WHERE fkey_gui_id = 'Klarschiff' AND fkey_e_id = 'kartenelemente' AND var_name ='schwellenwert'");
$row = pg_fetch_assoc($res);
$config['schwellenwert'] = $row ? intval($row['var_value']) : 20;

pg_close($connection);

$config['version'] = KSMOBIL_VERSION_DATA;

header('Content-Type: application/json');
print(json_encode($config));

