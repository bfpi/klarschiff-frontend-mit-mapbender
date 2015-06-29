<?php
require_once dirname(__FILE__)."/solrSearch.conf";
require_once dirname(__FILE__)."/inc/functions.php";

$response = http_post(
  UPDATE_URL."/?commit=true",
  "<delete><query>*:*</query></delete>",
  "Content-Type: text/xml\r\n"
);

// print_r($response["headers"],true)
echo "\ndone\n";
?>
