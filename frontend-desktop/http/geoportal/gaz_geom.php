<?php
# $Id$
# http://www.mapbender.org/index.php/gaz_service.php
# Copyright (C) 2002 CCGIS 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

(isset($_SERVER["argv"][1]))? ($user_id = $_SERVER["argv"][1]) : ($e = new mb_exception("geom: user lacks!"));
(isset($_SERVER["argv"][2]))? ($sstr = $_SERVER["argv"][2]) : ($e = new mb_exception("geom: string lacks!"));
(isset($_SERVER["argv"][3]))? ($epsg = $_SERVER["argv"][3]) : ($e = new mb_exception("geom: epsg lacks!"));


require_once(dirname(__FILE__)."/../../core/globalSettings.php");
require_once(dirname(__FILE__)."/../../conf/geoportal.conf");
require_once(dirname(__FILE__)."/../classes/class_mb_exception.php");

$con = pg_connect("host=".GEOMDB_HOST." port=".GEOMDB_PORT." dbname=".GEOMDB_NAME." user=".GEOMDB_USER." password=".GEOMDB_PASSWORD)
or die('Verbindungsaufbau fehlgeschlagen: ' . pg_last_error());

function replaceChars($text){
	$search = array( "�",  "�",  "�",  "�",  "�",  "�",  "�","tr." );
	$repwith = array("ae", "oe", "ue", "AE", "OE", "UE", "ss","tr");
	
	if(CHARSET=="UTF-8")
		$text = utf8_decode($text);

	$ret = str_replace($search, $repwith, $text);

	if(CHARSET=="UTF-8")
		$ret = utf8_encode($ret);

	return $ret;
}
/******* conf ***********************************/
$factor = 1;
if (intval($epsg) == 4326) $factor = 0.00001; 
/******* wohnpl�tze *******************/
$bufferWP = 1000*$factor;
$arrayWP = array();
$arrayWPKey = array();

/******* gemeinde *********************/	
$bufferG = 100*$factor;
$arrayG = array();
$toleranceG = 100*$factor;

/******* kreis *********************/	
$bufferK = 100*$factor;
$arrayK = array();
$toleranceK = 1000*$factor;
/******* verbandsgemeinde *********************/	
$bufferV = 100*$factor;
$arrayV = array();
$toleranceV = 1000*$factor;
/******* strasse *********************/	
$bufferSTR = 100*$factor;
$arraySTR = array();
$toleranceSTR = 100*$factor;
/******* Strasse / Hsnr ****************/
$bufferSH = 100*$factor;
$arraySH = array();
$toleranceSH = 1000*$factor;

/****** Workflow *********************************/
/**/
$astr = split(",",replaceChars($sstr));
if(count($astr) == 1){
	$astr[0] = trim($astr[0]);
	$plz = getPlz($astr[0]);
	$hsnr = getNr($astr[0]);
	if($plz != false){
		//checkSize($astr[0]);
		checkWP($plz, strtoupper(getCity($astr[0])));
		checkGfromWP();
	}
	else if($hsnr != false){
		
	}
	else if($hsnr == false && $plz == false){
		checkWP(false,strtoupper($astr[0]));
		checkG(strtoupper($astr[0]));
		checkGfromWP();
		checkK(strtoupper($astr[0]));
		checkVg($astr[0]);
	}
}
else if(count($astr) == 2){
	$astr[0] = trim($astr[0]);
	$astr[1] = trim($astr[1]);
	$ckeys = array();
	$cnames = array();
	$cmissing = array();
	
	$myplz = false;
	$mycity = false;
	$mystr = false;
	$mynr = false;
	$myzs = false;
	$both = array();
	
	// 1. 
	if(getPlz($astr[0])){
		$myplz = getPlz($astr[0]);
		if(getNr($astr[1])){
			$mynr = getNr($astr[1]);
			$myzs = getAppendix($astr[1]);
			$mystr = getStrn($astr[1]);
		}
		else{
			$mystr = trim($astr[1]);	
		}
	}
	else if(getNr($astr[0])){
		$mynr = getNr($astr[0]);
		$myzs = getAppendix($astr[0]);
		$mystr = getStrn($astr[0]);
		if(getPlz($astr[1])){
			$myplz = getPlz($astr[1]);
		}
		else{
			$mycity = trim($astr[1]);
		}
	}
	else{
		if(getPlz($astr[1])){
			$myplz = getPlz($astr[1]);
		}
		if(getNr($astr[1])){
			$mynr = getNr($astr[1]);
			$myzs = getAppendix($astr[1]);
			$mystr = getStrn($astr[1]);
			$mycity = getCity($astr[0]);
		}
		else{
			array_push($both,$astr[0]);
			array_push($both,$astr[1]);	
		}
	}
	// workflow
	if(count($both) == 2){
		$a = "%".strtoupper(trim($both[0]))."%";
		$b = "%".strtoupper(trim($both[1]))."%";
		$v = array($a, $a);
		$t = array('s', 's');
		$sql = "SELECT DISTINCT * FROM (SELECT DISTINCT gem_schl_neu, gemeinde AS gem FROM gis.verwaltungseinheit ";
		$sql .= "WHERE gemeinde_upper LIKE $1";
		$sql .= "UNION SELECT DISTINCT gem_schl_neu, gemeinde_gem_teile AS gem FROM gis.wohnplatz ";
		$sql .= "WHERE gemeinde_gem_teile_upper LIKE $2) AS str";
		$res = db_prep_query($sql,$v,$t);
		while($row = db_fetch_array($res)){
			array_push($ckeys, $row['gem_schl_neu']);
			array_push($cnames, encode($row['gem']));
			array_push($cmissing, $b);
		}
		$v = array($b, $b);
		$t = array('s', 's');
		$sql = "SELECT DISTINCT * FROM (SELECT DISTINCT gem_schl_neu, gemeinde AS gem FROM gis.verwaltungseinheit ";
		$sql .= "WHERE gemeinde_upper LIKE $1";
		$sql .= "UNION SELECT DISTINCT gem_schl_neu, gemeinde_gem_teile AS gem FROM gis.wohnplatz ";
		$sql .= "WHERE gemeinde_gem_teile_upper LIKE $2) AS str";
		$res = db_prep_query($sql,$v,$t);
		while($row = db_fetch_array($res)){
			array_push($ckeys, $row['gem_schl_neu']);
			array_push($cnames, encode($row['gem']));
			array_push($cmissing, $a);
		}
		
		if(count($ckeys)>0){
			for($i=0; $i<count($ckeys); $i++){	
				
				$v = array($ckeys[$i], $cmissing[$i]);
				$t = array('i', 's');
				$sql = "SELECT DISTINCT str_name_ewois, ";
				$sql .= "SRID(the_geom) AS srid, AsGML(the_geom) AS gml ,";
				$sql .= "(xmin(the_geom) - ".$bufferSH.") as minx, ";
				$sql .= "(ymin(the_geom) - ".$bufferSH.") as miny, ";
				$sql .= "(xmax(the_geom) + ".$bufferSH.") as maxx, ";
				$sql .= "(ymax(the_geom) + ".$bufferSH.") as maxy ";
				$sql .= "FROM gis.strassenschluessel WHERE gem_schl = $1 ";
				$sql .= " AND (str_name_ewois_upper LIKE $2)";
				if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
					$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
				}				
				$res = db_prep_query($sql,$v,$t);
				while($row = db_fetch_array($res)){
					$show = encode($row["str_name_ewois"])."  ".$cnames[$i];
					stack_it($arraySTR,"str",$show,"str",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
				}
			}

		}
	}
	else{
//	echo $myplz ."#";
//	echo $mycity ."#";
//	echo $mystr ."#";
//	echo $mynr ."#";
//	echo $myzs ."#";
//	print_r($both);	
		checkSH($mystr,$mynr,$myzs,$myplz,$mycity);
	}
}	

 

//$fillSH = checkSH("Akazienweg",30,false,56075,"Koblenz"); 

xml_output();

function checkMinLength($str) {
	if (strlen($str) < 3) {
		//errorOutput();
		null_output();
		die();
	} 
}
//Strasse Hausnummer
function checkSH($s,$h,$z,$p,$o){
	global $bufferSH, $arraySH, $epsg;
	
	if ($o && $s) {
		$str_schl = array();
		$str_schl_gem = array();
		$ckeys = array();
		$cnames = array();
		$a = "%".strtoupper(trim($o))."%";
		$v = array($a, $a);
		$t = array('s', 's');
		$sql = "SELECT DISTINCT * FROM (SELECT DISTINCT gem_schl_neu, gemeinde AS gem FROM gis.verwaltungseinheit ";
		$sql .= "WHERE gemeinde_upper LIKE $1";
		$sql .= "UNION SELECT DISTINCT gem_schl_neu, gemeinde_gem_teile AS gem FROM gis.wohnplatz ";
		$sql .= "WHERE gemeinde_gem_teile_upper LIKE $2) AS str";
		$res = db_prep_query($sql,$v,$t);
		while($row = db_fetch_array($res)){
			array_push($ckeys, $row['gem_schl_neu']);
			array_push($cnames, $row['gem']);
		}
	
		if(count($ckeys)>0){
			for($i=0; $i<count($ckeys); $i++){	
				
				$v = array($ckeys[$i], "%". strtoupper(trim($s)). "%");
				$t = array('i', 's');
				$sql = "SELECT DISTINCT str_schl_alt ";
				$sql .= "FROM gis.strassenschluessel WHERE gem_schl = $1 ";
				$sql .= " AND str_name_ewois_upper ILIKE $2";
				$res = db_prep_query($sql,$v,$t);
				while($row = db_fetch_array($res)){
					array_push($str_schl, $row['str_schl_alt']);
					array_push($str_schl_gem, $cnames[$i]);
				}
			}
			if (count($str_schl > 0)) {
				$v = array($h);
				$t = array('i');
				$sql = "SELECT DISTINCT name, hausnummer, zusatz, plz, post_ortsname, ";
				$sql .= "SRID(the_geom) AS srid, AsGML(the_geom) AS gml ,";
				$sql .= "(xmin(the_geom) - ".$bufferSH.") as minx, ";
				$sql .= "(ymin(the_geom) - ".$bufferSH.") as miny, ";
				$sql .= "(xmax(the_geom) + ".$bufferSH.") as maxx, ";
				$sql .= "(ymax(the_geom) + ".$bufferSH.") as maxy ";
				$sql .= "FROM gis.hauskoordinaten ";
				$sql .= "WHERE hausnummer = $1 AND strschl IN (";

				for($i=0; $i<count($str_schl); $i++){	
					if($i > 0){$sql .= ",";}
					$sql .= "$".($i+2);
					array_push($v,$str_schl[$i]);
					array_push($t,'i');
				}
				$sql .= ")";
				if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
					$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
				}				

				$res = db_prep_query($sql,$v,$t);
				while($row = db_fetch_array($res)){
					

#$show = $row["name"]." ".$row["hausnummer"];
				if($row["zusatz"] != 'null'){
				#	$show .= $row["zusatz"];
				
$show = utf8_decode($row["name"])." ".$row["hausnummer"].$row["zusatz"];
//$show = $row["name"]." ".$row["hausnummer"].$row["zusatz"]; TODO: exchange this, when the hauskoordinaten table is delivered in a homogenous encoding! 
}
	else
{$show = $row["name"]." ".$row["hausnummer"];}	
		$show .= ", " . $row["plz"]. " " . $row["post_ortsname"];
			

	stack_it($arraySH,"haus",$show,"sh",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
				}
			}
		}
	
	}
	else {
		//is this 'else' obsolete?
		$sql = "SELECT DISTINCT name, hausnummer, zusatz, plz, post_ortsname, ";
		$sql .= "SRID(the_geom) AS srid, AsGML(the_geom) AS gml ,";
		$sql .= "(xmin(the_geom) - ".$bufferSH.") as minx, ";
		$sql .= "(ymin(the_geom) - ".$bufferSH.") as miny, ";
		$sql .= "(xmax(the_geom) + ".$bufferSH.") as maxx, ";
		$sql .= "(ymax(the_geom) + ".$bufferSH.") as maxy ";
		$sql .= "FROM gis.hauskoordinaten ";
		$sql .= "WHERE name ILIKE $1 AND hausnummer = $2 ";
		$v = array("%".$s."%",$h);
		$t = array('s','i');
		if($z){
			$sql .= "AND zusatz = $" . (count($v)+1);
			array_push($v,$z);
			array_push($t,'s');
		}
		if($p){
			$sql .= "AND plz = $" . (count($v)+1);
			array_push($v,$p);
			array_push($t,'i');
		}
		if($o){
			$sql .= "AND post_ortsname ILIKE $" . (count($v)+1);
			array_push($v,"%".$o."%");
			array_push($t,'s');
		}
		#$sql .= " GROUP BY the_geom, name, hausnummer, zusatz, plz, post_ortsname";	
		if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
			$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
		}				
		$res = db_prep_query($sql,$v,$t);
		while($row = db_fetch_array($res)){
			
			$show = utf8_encode($row["name"])." ".$row["hausnummer"];
			//$show = $row["name"]." ".$row["hausnummer"]; TODO: see above
			if($row["zusatz"] != null){
				$show .= $row["zusatz"];	
			}
			$show .= ", " . $row["plz"]. " " . $row["post_ortsname"]; 
			stack_it($arraySH,"haus",$show,"sh",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
		}
	}
	return true;
}
//Wohnplatz
function checkWP($plz,$name){	
	global $bufferWP, $arrayWP, $arrayWPKey, $epsg;
	$v = array();
	$t = array();
	checkMinLength($name);
	$sql = "SELECT DISTINCT gemeinde_gem_teile, gem_schl_neu, postleitzahl,";
	$sql .= "SRID(the_geom) AS srid, AsGML(the_geom) AS gml ,";
	$sql .= "(xmin(the_geom) - ".$bufferWP.") as minx, ";
	$sql .= "(ymin(the_geom) - ".$bufferWP.") as miny, ";
	$sql .= "(xmax(the_geom) + ".$bufferWP.") as maxx, ";
	$sql .= "(ymax(the_geom) + ".$bufferWP.") as maxy ";
	$sql .= "FROM gis.wohnplatz WHERE ";
	if($plz == false){
		$sql .= "gemeinde_gem_teile_upper ILIKE $1 ";
		array_push($v,"%".$name."%");
		array_push($t,'s');
	}
	else if($name == false){
		$sql .= "postleitzahl = $1 ";
		array_push($v,$plz);
		array_push($t,'i');
	}
	else{
		$sql .= "postleitzahl = $1 AND gemeinde_gem_teile_upper ILIKE $2 ";
		array_push($v,$plz);
		array_push($t,'i');
		array_push($v,"%".$name."%");
		array_push($t,'s');
	}
	$sql .= "GROUP BY the_geom, gemeinde_gem_teile, gem_schl_neu, postleitzahl";	
	if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
		$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
	}				
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		$show = encode($row["gemeinde_gem_teile"]);
		$show.= " (Wohnplatz)";
		if(intval($row['postleitzahl'])> 1){ $show .= " (".$row['postleitzahl'].")"; }
		stack_it($arrayWP,"wohnplatz",$show,"wp",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
		if(!in_array($row["gem_schl_neu"],$arrayWPKey)){
			array_push($arrayWPKey,$row["gem_schl_neu"]);
		}
	}
	return true; 
}
function checkGfromWP(){
	global $arrayWPKey, $bufferG, $arrayG, $toleranceG, $epsg;
	if(count($arrayWPKey) == 0){
		return false;	
	}
	$v = array();
	$t = array();
	$sql = "SELECT DISTINCT gemeinde, ";
	$sql .= "SRID(the_geom) AS srid, AsGML(Simplify(the_geom,$toleranceG)) AS gml ,";
	$sql .= "(xmin(the_geom) - ".$bufferG.") as minx, ";
	$sql .= "(ymin(the_geom) - ".$bufferG.") as miny, ";
	$sql .= "(xmax(the_geom) + ".$bufferG.") as maxx, ";
	$sql .= "(ymax(the_geom) + ".$bufferG.") as maxy ";
	$sql .= "FROM gis.verwaltungseinheit WHERE gem_schl_neu IN(";
	for($i=0; $i<count($arrayWPKey); $i++){
		if($i > 0){$sql .= ",";}
		$sql .= "$".($i+1);
		array_push($v,$arrayWPKey[$i]);
		array_push($t,'i');
	}
	$sql .= ") GROUP BY the_geom, gemeinde";
	if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
		$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
	}				
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		stack_it($arrayG,"gemeinde",encode($row["gemeinde"]." (Wohnplatz)"),"g",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
	}
}
function checkG($str){
	global $bufferG, $arrayG, $toleranceG, $arrayWPKey, $epsg;
	checkMinLength($str);
	$tmp = array();
	$sql = "SELECT DISTINCT gemeinde, gem_schl_neu, ";
	$sql .= "SRID(the_geom) AS srid, AsGML(Simplify(the_geom,$toleranceG)) AS gml ,";
	$sql .= "(xmin(the_geom) - ".$bufferG.") as minx, ";
	$sql .= "(ymin(the_geom) - ".$bufferG.") as miny, ";
	$sql .= "(xmax(the_geom) + ".$bufferG.") as maxx, ";
	$sql .= "(ymax(the_geom) + ".$bufferG.") as maxy ";
	$sql .= "FROM gis.verwaltungseinheit WHERE gemeinde_upper ILIKE $1 ";
	#$sql .= "GROUP BY the_geom, gemeinde, gem_schl_neu";
	if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
		$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
	}				
	$v = array("%".$str."%");
	$t = array('s');
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		stack_it($arrayG,"gemeinde",encode($row["gemeinde"]." (Gemeinde)"),"g",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
		$tmp[count($tmp)] = $row["gem_schl_neu"]; 
	}
	$arrayWPKey = array_diff($arrayWPKey,$tmp);
}

function checkK($str){
	global $bufferK, $arrayK, $toleranceK, $epsg;
	checkMinLength($str);
	$sql = "SELECT DISTINCT kreis, ";
	$sql .= "SRID(the_geom) AS srid, AsGML(Simplify(the_geom,".$toleranceK.")) AS gml ,";
	$sql .= "(xmin(the_geom)-".$bufferK.") as minx, ";
	$sql .= "(ymin(the_geom)-".$bufferK.") as miny, ";
	$sql .= "(xmax(the_geom)+".$bufferK.") as maxx, ";
	$sql .= "(ymax(the_geom)+".$bufferK.") as maxy ";
	$sql .= "FROM gis.kreis_pl WHERE kreis_upper ILIKE $1 ";
	if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
		$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
	}				
	$v = array("%".$str."%");
	$t = array('s');
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		stack_it($arrayK,"kreis",encode($row["kreis"]." (Landkreis)"),"k",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
	}
}
function checkVg($str){
	global $bufferV, $arrayV, $toleranceV, $epsg;
	checkMinLength($str);
	$sql = "SELECT DISTINCT vg, ";
	$sql .= "SRID(the_geom) AS srid, AsGML(Simplify(the_geom,".$toleranceV.")) AS gml ,";
	$sql .= "(xmin(the_geom)-".$bufferV.") as minx, ";
	$sql .= "(ymin(the_geom)-".$bufferV.") as miny, ";
	$sql .= "(xmax(the_geom)+".$bufferV.") as maxx, ";
	$sql .= "(ymax(the_geom)+".$bufferV.") as maxy ";
	$sql .= "FROM gis.vg_fl WHERE vg ILIKE $1 ";
	if (isset($epsg) && is_numeric($epsg) && intval($epsg) != 31466) {
		$sql = str_replace("the_geom", "transform(the_geom,".$epsg.")", $sql);
	}				
	$v = array("%".$str."%");
	$t = array('s');
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		stack_it($arrayV,"verbandsgemeinde",encode($row["vg"]." (Verbandsgemeinde)"),"vg",$row["srid"],$row["minx"],$row["miny"],$row["maxx"],$row["maxy"],$row["gml"]);
	}
}
function stack_it(&$stack,$category,$showtitle,$prefix,$srid,$minx,$miny,$maxx,$maxy,$gml){
	$doc = new DOMDocument();
	$member = $doc->createElement("member");
	$doc->appendChild($member);
	$member->setAttribute('id',$prefix.count($stack));
	$fc = $doc->createElement("FeatureCollection");
	$member->appendChild($fc);
	$fc->setAttribute("xmlns:gml","http://www.opengis.net/gml");
	$bb = $doc->createElement("boundedBy");
	$fc->appendChild($bb);
	$box = $doc->createElement("Box");
	$bb->appendChild($box);
	$box->setAttribute('srsName',"EPSG:".$srid);
	$c = $doc->createElement("coordinates");
	$box->appendChild($c);
	$coords = $doc->createTextNode($minx.",".$miny." ".$maxx.",".$maxy);
	$c->appendChild($coords);
	$fm = $doc->createElement("featureMember");
	$fc->appendChild($fm);
	$wp = $doc->createElement($category);
	$fm->appendChild($wp);
	$title = $doc->createElement("title");
	$wp->appendChild($title);
	$ttitle = $doc->createTextNode($showtitle);
	$title->appendChild($ttitle);
	$geom = $doc->createElement("the_geom");
	$wp->appendChild($geom);		
	$myNode = @simplexml_load_string($gml);
	$mySNode = dom_import_simplexml($myNode);
	$domNode = $doc->importNode($mySNode, true);
	$geom->appendChild($domNode);	 
	array_push($stack,$member);		
}

function null_output(){
	global $sstr, $arrayWP, $arrayG, $arrayK, $arraySH, $arraySTR, $arrayV;
	$doc = new DOMDocument('1.0');
	$doc->encoding = CHARSET;
	$result = $doc->createElement("result");
	$doc->appendChild($result);
	$ready = $doc->createElement('ready');
	$result->appendChild($ready);
	$tready = $doc->createTextNode("true");
	$ready->appendChild($tready);
	echo $doc->saveXML();
}






function xml_output(){
	global $sstr, $arrayWP, $arrayG, $arrayK, $arraySH, $arraySTR, $arrayV;
	$doc = new DOMDocument('1.0');
	$doc->encoding = CHARSET;
	$result = $doc->createElement("result");
	$doc->appendChild($result);
	for($i=0; $i<count($arrayWP); $i++){
		$domNode = $doc->importNode($arrayWP[$i], true);
		$result->appendChild($domNode);
	}
	for($i=0; $i<count($arrayG); $i++){
		$domNode = $doc->importNode($arrayG[$i], true);
		$result->appendChild($domNode);
	}
	for($i=0; $i<count($arrayK); $i++){
		$domNode = $doc->importNode($arrayK[$i], true);
		$result->appendChild($domNode);
	}
	for($i=0; $i<count($arraySH); $i++){
		$domNode = $doc->importNode($arraySH[$i], true);
		$result->appendChild($domNode);
	}
	for($i=0; $i<count($arraySTR); $i++){
		$domNode = $doc->importNode($arraySTR[$i], true);
		$result->appendChild($domNode);
	}
	for($i=0; $i<count($arrayV); $i++){
		$domNode = $doc->importNode($arrayV[$i], true);
		$result->appendChild($domNode);
	}
	$ready = $doc->createElement('ready');
	$result->appendChild($ready);
	$tready = $doc->createTextNode("true");
	$ready->appendChild($tready);
	echo $doc->saveXML();
}
function encode($s){
#	if(CHARSET == 'UTF-8'){
#		$s = utf8_encode($s);
#	}
	return $s;
}
function getPlz($str){
	$p = "/.*(\d{5}).*/";	
	$am = array();
 	if(preg_match($p, $str, $am)){
 		return $am[1];
 	}
 	else{
 		return false;
 	}
}
function getCity($str){
	$p = "/(^\d{5}){0,1}(.*)/";	
	$am = array();
 	if(preg_match($p, $str, $am)){
 		return trim($am[2]);
 	}
 	else{
 		return false;
 	} 
}
function getNr($str){
	$p = "/.*[^0-9](\d{1,4})[^0-9]*/";
	$am = array();
 	if(preg_match($p, $str, $am)){
 		return $am[(count($am)-1)];
 	}
 	else{
 		return false;
 	} 
}
function getStrn($str){
	$p = "/^(\D+)\d/";	
	$am = array();
 	if(preg_match($p, $str, $am)){
 		return trim($am[1]);
 	}
 	else{
 		return false;
 	} 
}
function getAppendix($str){
	$p = "/.*\d+.*(\D{1})/";	
	$am = array();
 	if(preg_match($p, $str, $am)){
 		return $am[1];
 	}
 	else{
 		return false;
 	}
}
function getCKeysByName($city){
	global $ckeys;
	$city = "%".strtoupper(trim($city))."%";
	$sql = "SELECT gem_schl_neu FROM gis.wohnplatz ";
	$sql .= "WHERE gemeinde_gem_teile_upper ILIKE $1 ";
	$v = array($city);
	$t = array('s');
	$res = db_prep_query($sql,$v,$t);
	while($row = db_fetch_array($res)){
		array_push($ckeys, $row['gem_schl_neu']);
	}
}
?>
