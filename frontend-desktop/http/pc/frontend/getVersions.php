<?php

include('../../../conf/ksmobil.conf');
$versions = array(
  'code' => KSMOBIL_VERSION_CODE,
  'configuration' => KSMOBIL_VERSION_DATA
);

header('Content-Type: application/json');
print(json_encode($versions));

