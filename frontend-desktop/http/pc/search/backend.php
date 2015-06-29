<?php
require_once dirname(__FILE__)."/solrSearchBackend.conf";
require_once dirname(__FILE__)."/inc/functions.php";
require_once dirname(__FILE__)."/inc/ColognePhonetic.php";

class Server {
  private static $inst = null;
  private $searchtext = "";
  private $phonetic = null;

  public static function singleton() {
    if(is_null(self::$inst)) {
      self::$inst = new Server();
    }
    return self::$inst;
  }

  public function __construct() {
    $this->phonetic = Text_ColognePhonetic::singleton();

  }

  public function parseSearchtext($searchtext) {

    if(preg_match("/^[\d]+$/",$searchtext) OR trim($searchtext) == "") {
      return false;
    }

    $words = preg_split("/[^a-z0-9äöüÄÖÜß]/i", strtolower($searchtext));

    for($i=0;$i<count($words);$i++) {
      $word = $this->cutStreet($words[$i]);

      if($words[$i] != $word) {
        $this->addPhonetic("str",false,false);
      }

      $this->addPhonetic($word);
    }

    return true;
  }

  public function cutStreet($word) {
    return preg_replace("/strasse$|straße$|str$/i","",$word);
  }

  public function addPhonetic($word,$inject = true, $truncate = true) {
    if(trim($word)=="") {
      return null;
    }

    if(preg_match("/[\d]+/",$word) AND strlen($word) <= 2) {
      $line = "";
      foreach(array("stadtteile","pois","strassen","adressen") AS $table) {
        $line .= " OR $table:$word";

      }
      $this->searchtext .= " AND (".substr($line,4).")";
      return true;
    }

    $phonWord = $this->phonetic->encode($word);
    $line = "";

    foreach(array("stadtteile","pois","strassen","adressen") AS $table) {
      $line .= " OR";

      if(trim($phonWord)!="") {
        if($inject) {
          $line .= " $table:".$this->truncate($phonWord,$truncate)." OR $table:".$this->truncate($word,$truncate)." OR $table:$word";
        } else {
          $line .= " $table:".$this->truncate($word,$truncate);
        }
      } else {
        $line .= " $table:".$this->truncate($word,$truncate);
      }
    }

    $this->searchtext .= " AND (".substr($line,4).")";
    return true;
  }

  public function getSearchtext() {
    if(!empty($this->searchtext)) {
      return substr($this->searchtext,4);
    }
    return "";
  }

  public function truncate($word,$truncate = true) {
    if($truncate)
      return "*".$word."*";
    else
      return $word;
  }

}

$server = Server::singleton();
$result = "";

// SUCHBEGRIFFE BEARBEITEN
if($server->parseSearchtext($_REQUEST["searchtext"])) {
  $url = "http://localhost:8080/solr/select?".http_build_query(
    array(
      "q" => $server->getSearchtext(),
      "rows" => "5",
      "defType" => "edismax", // edismax, lucene
      "wt" => "json",
      "fl" => "*"
    )
  );

  $result = http_post($url,"");
  $json = json_decode($result["content"]);

  $result = "";
  $json_result = array();


  // ERGEBNISSE VORHANDEN	
  foreach ($json->response->docs AS $doc) {
    $bbox = $doc->geom;
    $bbox = str_replace(" ", ",", $bbox);
    $bbox = str_replace("BOX(", "", $bbox);
    $bbox = str_replace(")", "", $bbox);

    $bbox_array = array();
    if(substr($doc->geom,0,3) == "BOX") {
      foreach(explode(",",substr($doc->geom,4,-1)) AS $i) {
        foreach(explode(" ",$i) AS $j) {
          $bbox_array[] = $j;
        }
      }
    }

    // POI
    if(!empty($doc->poi_titel)) {
      $result .= str_replace("#ZUSATZ#",$doc->zusatz,
        str_replace("#NAME#", $doc->poi_titel, str_replace("#BBOX#", $bbox, str_replace("#BBOXS#",implode(",",$bbox_array),RES_POI)))
      );
      $json_result[] = array("label" => $doc->poi_titel." ".$doc->zusatz, "bbox" => $bbox_array);

      // STADTTEIL
    } else if(!empty($doc->stadtteil_name)) {
      $result .= str_replace("#ZUSATZ#",$doc->zusatz,
        str_replace("#NAME#", $doc->stadtteil_name, str_replace("#BBOX#", $bbox, str_replace("#BBOXS#",implode(",",$bbox_array),RES_STADTTEIL)))
      );
      $json_result[] = array("label" => $doc->stadtteil_name." ".$doc->zusatz, "bbox" => $bbox_array);
      // STRASSE
    } else if(!empty($doc->strasse_name)) {
      $result .= str_replace("#ZUSATZ#",$doc->zusatz,
        str_replace("#NAME#", $doc->strasse_name, str_replace("#BBOX#", $bbox, str_replace("#BBOXS#",implode(",",$bbox_array),RES_STRASSE)))
      );
      $json_result[] = array("label" => $doc->strasse_name." ".$doc->zusatz, "bbox" => $bbox_array);
      // ADRESSE
    } else {
      $result .= str_replace("#ZUSATZ#",$doc->zusatz,
        str_replace("#NAME#", $doc->strasse." ".$doc->hausnummer.$doc->hausnummerzusatz, str_replace("#BBOX#", $bbox, str_replace("#BBOXS#",implode(",",$bbox_array),RES_ELSE)))
      );
      $json_result[] = array("label" => $doc->strasse." ".$doc->hausnummer.$doc->hausnummerzusatz." ".$doc->zusatz, "bbox" => $bbox_array);
    }
  }	
}

echo json_encode(array(
  "result" => $result,
  "array" => $json_result,
  "debug" => $debug
));
?>
