<?php

require_once('../../conf/mapbender.conf');

$connection_string = sprintf("host=%s dbname=%s user=%s password=%s", KS_DBSERVER, KS_DB, KS_OWNER, KS_PW);
$connection = pg_connect($connection_string);

pg_prepare("", 'SELECT v.id, ST_X(v.the_geom) as x, ST_Y(v.the_geom) as y, k.name as kategorie, hk.name as hauptkategorie, initcap(v.vorgangstyp) as vorgangstyp '
  .'FROM klarschiff.klarschiff_wfs v '
  .'INNER JOIN klarschiff.klarschiff_kategorie k ON v.kategorieid = k.id '
  .'INNER JOIN klarschiff.klarschiff_kategorie hk ON v.hauptkategorieid = hk.id '
  .'WHERE v.status <> \'gemeldet\' '
  .'ORDER BY RANDOM() LIMIT 1');
$result = pg_execute("", array());

$row = pg_fetch_assoc($result);
$row['x'] = intval($row['x']);
$row['y'] = intval($row['y']);
pg_close($connection);
header('Content-Type: application/json');
print(json_encode($row));

