<?php
# License:
# Copyright (c) 2009, Open Source Geospatial Foundation
# This program is dual licensed under the GNU General Public License 
# and Simplified BSD license.  
# http://svn.osgeo.org/mapbender/trunk/mapbender/license/license.txt

require_once dirname(__FILE__) . "/../../core/globalSettings.php";
require_once dirname(__FILE__) . "/class_connector.php";
require_once dirname(__FILE__) . "/class_user.php";
require_once dirname(__FILE__) . "/class_Uuid.php";
require_once dirname(__FILE__) . "/class_administration.php";
require_once dirname(__FILE__) . "/class_georss_factory.php";
require_once dirname(__FILE__) . "/class_mb_exception.php";
require_once dirname(__FILE__) . "/../classes/class_universal_wms_factory.php";

class wms {
	var $lastURL;
	var $wms_id;
	var $wms_status;
	var $wms_version;
	var $wms_title;
	var $wms_abstract;
	var $wms_getcapabilities;
	var $wms_getcapabilities_doc;
	var $wms_getmap;
	var $wms_getfeatureinfo;
	var $wms_getlegendurl;
	var $wms_upload_url;
	var $wms_timestamp;
	var $wms_timestamp_create;
	var $wms_srs = array();
	var $wms_termsofuse;
	  
	var $fees;
	var $accessconstraints;
	var $contactperson;
	var $contactposition;
	var $contactorganization;
	var $address;
	var $city;
	var $stateorprovince;
	var $postcode;
	var $country;
	var $contactvoicetelephone;
	var $contactfacsimiletelephone;
	var $contactelectronicmailaddress;
	  
	var $wms_keyword = array();
	var $data_type = array(); 
	var $data_format = array();
	var $objLayer = array(); 
	  
	var $wms_supportsld;
	var $wms_userlayer;
	var $wms_userstyle;
	var $wms_remotewfs;
		
	var $gui_wms_mapformat;
	var $gui_wms_featureinfoformat;
	var $gui_wms_exceptionformat;
	var $gui_wms_epsg;
	var $gui_wms_sldurl;
	  
	var $default_epsg = 0;
	var $overwrite = true;
	
	// write a GeoRSS feed?
	const GEORSS = true;
	// append items to the feed when a new WMS is inserted?
	const GEORSS_APPEND_ON_INSERT = true;
	// append items to the feed when an existing WMS is updated?
	const GEORSS_APPEND_ON_UPDATE = true;
	// append items to the feed only when an existing WMS is updated 
	// and new layers have been added?
	const GEORSS_APPEND_ON_UPDATE_NEWLAYERS = true;
	  
	function wms() {
	} 
    /**
     *
     * @generate RSS formated date 
     *
     * @param int $timestamp The UNIX_TIMESTAMP
     *
     * @return string
     *
     */
    private static function rssDate($timestamp=null)
    {
        /*** set the timestamp ***/
        $timestamp = ($timestamp==null) ? time() : $timestamp;

        /*** Mon, 02 Jul 2009 11:36:45 +0000 ***/
        return date(DATE_RSS, $timestamp);
    }
    
	public static function getWmsMetadataUrl ($wmsId) {
		#return preg_replace(
		#	"/(.*)frames\/login.php/", 
		#	"$1php/mod_layerMetadata.php?id=", 
		#	LOGIN
		#) . $wmsId;
		return LOGIN."/../php/mod_showMetadata.php?resource=wms&id=".$wmsId;
	}
	public static function getLayerMetadataUrl ($layerId) {
		#return preg_replace(
		#	"/(.*)frames\/login.php/", 
		#	"$1php/mod_layerMetadata.php?id=", 
		#	LOGIN
		#) . $wmsId;
		return LOGIN."/../php/mod_showMetadata.php?resource=layer&id=".$layerId;
	}
	public static function isOwsProxyUrl ($getmap) {
//		$e = new mb_notice("isOwsProxyUrl? " . $getmap);
		$result = preg_match("/^.*owsproxy.([^i][\w\d]+)\/([\w\d]{32})\/?.*$/", $getmap);
//		$e = new mb_notice("result: " . $result);
		return $result;
	}

	private function replaceSessionIdInOwsProxyUrl ($getMap) {
//		$e = new mb_notice("replaceSessionIdInOwsProxyUrl: ");
		$e = new mb_notice("before: " . $getMap);
		$pattern = '/(^.*owsproxy.)([^i][\w\d]+)(\/)([\w\d]{32})(\/?.*)$/';
		$getMap1= preg_replace($pattern, "$1",$getMap);
		$getMap2=  preg_replace($pattern, "$3$4$5",$getMap);
		$getMap = $getMap1.session_id().$getMap2;
		$e = new mb_notice("after: " . $getMap);
		return $getMap;
	}
	
	public static function getHashFromOwsProxyUrl ($getMap) {
//		$e = new mb_notice("replaceSessionIdInOwsProxyUrl: " . $getMap);
		$result = preg_replace("/^.*owsproxy.([^i][\w\d]+)\/([\w\d]{32})\/?.*$/", "$2", $getMap);
//		$e = new mb_notice("result: " . $result);
		return $result;
	}
	
	private function getWmsIdByOwsProxyHash($md5) {
		$sql = "SELECT wms_id FROM wms WHERE wms_owsproxy = $1";
		$v = array($md5);
		$t = array("s");
		$res = db_prep_query($sql, $v, $t);
		$row = db_fetch_row($res);
		if ($row["wms_id"]) {
			return $row["wms_id"];
		}
		return null;
	}
	
	private function updateOwsProxyUrl ($url) {
		// is OWS proxy URL?
		if (self::isOwsProxyUrl($url)) {

			// No WMS id could be found
			if (!$this->wms_id) {
				$e = new mb_notice("No WMS id could be found!");
				return $url;
			}			
			// Update session id in OWS proxy URL
			$new_proxy_url = $this->replaceSessionIdInOwsProxyUrl($url);

			// If new url is a valid proxy URL, return true
			if (self::isOwsProxyUrl($new_proxy_url)) {
				return $new_proxy_url;
			}
			else {
//				$e = new mb_notice("new URL is not an OWS proxy URL!");
			}
			// new URL is not an OWS proxy URL; 
			// some error must have occured.
			// no update
			return $url;
		}
		// no OWS proxy URL, no update necessary
//		$e = new mb_notice("URL is not an OWS proxy URL!");
		return $url;
	}
	
	function updateAllOwsProxyUrls () {
		$wmsId = $this->wms_id;

		// if WMS id is unknown, try to 
		// find it via OWS proxy entry
		//FIXME -Funktion berichtigen 
		if (!$wmsId) {
			$md5 = wms::getHashFromOwsProxyUrl($url);
			if ($md5) {
				$wmsId = $this->getWmsIdByOwsProxyHash($md5);
				if (!is_null($wmsId)) {
					$this->wms_id = $wmsId;
				}
			}
		}

		$this->wms_getmap = 
			$this->updateOwsProxyUrl($this->wms_getmap);
		$this->wms_getfeatureinfo = 
			$this->updateOwsProxyUrl($this->wms_getfeatureinfo);
		$this->wms_getlegendurl = 
			$this->updateOwsProxyUrl($this->wms_getlegendurl);
		
		for ($i = 0; $i < count($this->objLayer); $i++) {
			for ($j = 0; $j < count($this->objLayer[$i]->layer_style); $j++) {
				$this->objLayer[$i]->layer_style[$j]["legendurl"] = 
					$this->updateOwsProxyUrl($this->objLayer[$i]->layer_style[$j]["legendurl"]);
			}
		}
	}
	
	public static function getConjunctionCharacter ($url) {
		if (mb_strpos($url, "?") !== false) { 
			if (mb_substr($url, mb_strlen($url)-1, 1) == "?") { 
				return "";
			}
			else if (mb_substr($url, mb_strlen($url)-1, 1) == "&"){
				return "";
			}
			else {
				return "&";
			}
		}
		else {
			return "?";
		}
		return "";
	}

	public function getLayerById ($id) {
		$adm = new administration();
		for ($i = 0; $i < count($this->objLayer); $i++) {
			if (strval($this->objLayer[$i]->layer_uid) === strval($id)) {
				if ($adm->getLayerPermission(
							$this->wms_id, 
							$this->objLayer[$i]->layer_name, 
							Mapbender::session()->get("mb_user_id")
				)) {
					return $this->objLayer[$i];
				}
				else {
					throw new AccessDeniedException ($id);
				}
			}
		}
		throw new Exception ("Layer not found.");
	}
	public function &getLayerReferenceById ($id) {//this is done to update one layer with the metadata editor!
		$adm = new administration();
		for ($i = 0; $i < count($this->objLayer); $i++) {
			if (strval($this->objLayer[$i]->layer_uid) === strval($id)) {
				if ($adm->getLayerPermission(
							$this->wms_id, 
							$this->objLayer[$i]->layer_name, 
							Mapbender::session()->get("mb_user_id")
				)) {
				/*//
				// update GeoRSS feed if wished
				//
				$geoRssFactory = new GeoRssFactory();
				$geoRss = $geoRssFactory->loadOrCreate(GEO_RSS_FILE);
				if (!is_null($geoRss)) {
					$currentLayer = $this->objLayer[$i];
					$geoRssItemUpdatedLayer = new GeoRssItem();
					$geoRssItemUpdatedLayer->setTitle("UPDATED LAYER: " . $currentLayer->layer_title." (".$currentLayer->layer_uid.")");
					$geoRssItemUpdatedLayer->setDescription($currentLayer->layer_abstract);
					$geoRssItemUpdatedLayer->setUrl(self::getLayerMetadataUrl($currentLayer->layer_uid));
					$geoRssItemUpdatedLayer->setPubDate(self::rssDate());
					for ($j = 0; $j < count($currentLayer->layer_epsg); $j++) {
						$currentEpsg = $currentLayer->layer_epsg[$j];
						if ($currentEpsg["epsg"] === "EPSG:4326") {
							$currentBbox = new Mapbender_bbox(
								$currentEpsg["minx"],
								$currentEpsg["miny"],
								$currentEpsg["maxx"],
								$currentEpsg["maxy"],
								$currentEpsg["epsg"]
							);
							$geoRssItemUpdatedLayer->setBbox($currentBbox);
							break;
						}
					}
					$geoRss->appendTop($geoRssItemUpdatedLayer);
					//return the reference to the layer which will be updated*/
					return $this->objLayer[$i];
				}
				else {
					throw new AccessDeniedException ($id);
				}
			}
		}
		throw new Exception ("Layer not found.");
	}


	public function getLayerByPos ($pos) {
		for ($i = 0; $i < count($this->objLayer); $i++) {
			if (strval($this->objLayer[$i]->layer_pos) === strval($pos)) {
				return $this->objLayer[$i];
			}
		}
		return null;
	}

	function createOlObjFromWMS($base){
	 	if(!$this->wms_title || $this->wms_title == ""){
			echo "alert('Error: no valid capabilities-document !!');";
			die; exit;
		}
		// wms_title and abstract have previously been urlencoded
		// this solution may not yet be the ultimate one
		
		$add_wms_string  = "var wms_".$this->wms_id." = new OpenLayers.Layer.WMS(";
		// WMS-title
		$add_wms_string .= "'" . addslashes($this->wms_title) . "',";
		// Base-URL of service
		$add_wms_string .= "'" . $this->wms_getmap ."',";
		// Additional URL params
		$add_wms_string .= "{layers:'";
		for($i=1;$i<count($this->objLayer);$i++){
			$add_wms_string .= addslashes($this->objLayer[$i]->layer_name);
			if($i!=count($this->objLayer)-1) {
				$add_wms_string .= ",";
			}
		}
		$add_wms_string .= "',";
		// This is hardcoded, exactly as for Mapbender WMS
		$add_wms_string .= "transparent: 'true',";
		$add_wms_string .= "format: '".$this->gui_wms_mapformat."'},";
		// OpenLayers-Layer options
		$add_wms_string .= "{";
		$add_wms_string .= 	"transitionEffect:'resize',";
		$add_wms_string .= 	"ratio:1.2,";
		$add_wms_string .= 	"singleTile:true,";
		// baselayer?				
		if($base) {
			$add_wms_string .= 	"isBaseLayer:true,";
		} else {
			$add_wms_string .= 	"isBaseLayer:false,";
		}
		// visible or not?
		if($this->gui_wms_visible=="1") {
			$add_wms_string .= 	"visibility:true,";
		} else {
			$add_wms_string .= 	"visibility:false,";
		}

		// max extent
		for ($i = 0; $i < count($this->objLayer[0]->layer_epsg); $i++) {
			$rootLayerEpsg = $this->objLayer[0]->layer_epsg[$i];
			if ($rootLayerEpsg["epsg"] === "EPSG:4326") {
				$add_wms_string .= "maxExtent: new OpenLayers.Bounds(" .
					$rootLayerEpsg["minx"] . "," .
					$rootLayerEpsg["miny"] . "," .
					$rootLayerEpsg["maxx"] . "," .
					$rootLayerEpsg["maxy"] .
				"),";
			}
		}

		// initial transparency
		$add_wms_string .= 	"opacity:" . strval(round($this->gui_wms_opacity/100, 2));

		$add_wms_string .= "}";
		$add_wms_string .= ");";
		
		$queryLayers = array();
		for ($i = 0; $i < count($this->objLayer); $i++) {
			$layer = $this->objLayer[$i];
			if ($layer->layer_queryable 
				&& $layer->gui_layer_queryable 
				&& $layer->gui_layer_querylayer
			) {
				$queryLayers[]= $layer->layer_name;
			}
		}
		$queryLayerString = implode(",", $queryLayers);
		$add_wms_string .= "wms_" . $this->wms_id . ".params.QUERY_LAYERS = '$queryLayerString';";

		// TODO why ol_map
		$add_wms_string .= "ol_map.addLayer(wms_".$this->wms_id.");";
		echo $add_wms_string;
	}	
	
	/**
	 * Compares this WMS to another WMS.
	 * 
	 * @return boolean false, if
	 * 					- the capabilities URLs don't match
	 * 					- the layer count is different
	 * 					- the layer names are different
	 * 
	 * @param $anotherWms wms this is just another WMS object
	 */
	public function equals ($anotherWms) {
		// If the getMap URLs are not equal, the WMS are not equal.
		if ($this->wms_getmap != $anotherWms->wms_getmap) {
//			$e = new mb_notice($this . " != " . $anotherWms . " (getMap URL)");
			return false;
		}

		// If the layer count is different, the WMS are not equal.
		if (count($this->objLayer) != count($anotherWms->objLayer)) {
//			$e = new mb_notice($this . " != " . $anotherWms . " (layer count: " . count($this->objLayer) . ":" . count($anotherWms->objLayer). ")");
// removing this check because you can also load single layers of WMS!
// so you might load different layers of the WMS at different times,
// they need to be grouped under the same WMS
//			return false;
		}
		
		// If the layer names are different, the WMS are not equal.
		for ($i = 0; $i < count($this->objLayer); $i++) {
			$name1 = $this->objLayer[$i]->layer_name;
			$name2 = $anotherWms->objLayer[$i]->layer_name;
			if ($name1 != $name2) {
//				$e = new mb_notice($this . " != " . $anotherWms . " (layer names, " . $name1 . " vs. " . $name2 . ")");
// removing this check because you can also load single layers of WMS!
// so you might load different layers of the WMS at different times,
// they need to be grouped under the same WMS
//				return false;
			}
		}
		
//		$e = new mb_notice($this . " == " . $anotherWms);
		return true;
	}  
	
	/**
	 * Removes duplicate WMS from an array of WMS. To find duplicates,
	 * two WMS are compared via equals().
	 * 
	 * @return wms[]
	 * @param $wmsArray wms[]
	 */
	public static function merge ($wmsArray) {
//		$e = new mb_notice("before: " . implode(", ", $wmsArray));
		if (!is_array($wmsArray)) {
			$e = new mb_notice("class_wms.php: merge(): parameter is NOT an array.");
			return array();
		}
		if (count($wmsArray) == 0) {
			$e = new mb_notice("class_wms.php: merge(): parameter is an EMPTY array.");
			return array();
		}

		$newWmsArray = array();

		while (count($wmsArray) > 0) {
			$currentWms = array_pop($wmsArray);

			$isNewWms = true;

			if (get_class($currentWms) != "wms") {
				$e = new mb_notice("class_wms.php: merge(): current WMS is not a WMS object, but a " . get_class($currentWms));
			}
			else {
				$index = null;
				for ($i = 0; $i < count($newWmsArray) && $isNewWms; $i++) {
					if ($currentWms->equals($newWmsArray[$i])) {
						$isNewWms = false;
						$index = $i;
					}
				}
				if ($isNewWms) {
					$e = new mb_notice("adding WMS " . $currentWms);
					$newWmsArray[]= $currentWms;
				}
				else {
					$existingWms = $newWmsArray[$index];

					$len = count($currentWms->objLayer);
					for ($i = 0; $i < $len; $i++) {
						$currentWmsLayer = $currentWms->objLayer[$i];
						$found = false;
						$lenExist = count($existingWms->objLayer);
						for ($j = 0; $j < $lenExist; $j++) {
							$existingWmsLayer = $existingWms->objLayer[$j];
							if ($currentWmsLayer->equals($existingWmsLayer)) {
								$found = true;
								break;
							}
							if ($existingWmsLayer->layer_pos > $currentWmsLayer->layer_pos) {
								break;
							}
						}
						if (!$found) {
							array_splice($existingWms->objLayer, $j, 0, array($currentWmsLayer));
						}
					}
				}
			}
		}
		// reversal of the array, because the elements were popped 
		// from another array before.
		$e = new mb_notice("after: " . implode(", ", array_reverse($newWmsArray)));
		return array_reverse($newWmsArray);
	}

	private function formatExists ($type, $format) {
		for ($i = 0; $i < count($this->data_type); $i++) {
			if ($type == $this->data_type[$i] && $format == $this->data_format[$i]) {
				$e = new mb_warning("WMS format already exists ($type, $format). Violation of WMS spec. Ignoring this WMS format.");
				return true;
			}
		}
		return false;
	}

	public function __toString () {
		return strval($this->wms_title);
	}
	
	function createObjFromXML($url){
		if (func_num_args() == 2) { //new for HTTP Authentication
            		$auth = func_get_arg(1);
			$x = new connector($url,$auth);
		}
		else {
			$x = new connector($url);
		}
		$data = $x->file;
		if ($data=='401') {
			echo "<br>HTTP Error:<b>".$data." - Authorization required. This seems to be a service which needs HTTP Authentication!</b><br>";
		}
		if(!$data){
			$this->wms_status = false;
			return false;
		}
		else {
			$this->wms_status = true;
		}
			
		$values = null;
		$tags = null;
		$admin = new administration();
		$this->wms_getcapabilities_doc = $data;
		$this->wms_upload_url = $url;
		
		$this->wms_id = "";
		$parser = xml_parser_create("");
		xml_parser_set_option($parser,XML_OPTION_CASE_FOLDING,0);
		xml_parser_set_option($parser,XML_OPTION_SKIP_WHITE,1);
		xml_parser_set_option($parser,XML_OPTION_TARGET_ENCODING,CHARSET);
		xml_parse_into_struct($parser,$data,$values,$tags);

		$code = xml_get_error_code($parser);
		if ($code) {
			$line = xml_get_current_line_number($parser); 
			$mb_exception = new mb_exception(xml_error_string($code) .  " in line " . $line);
		}
		
		xml_parser_free($parser);
		
		$section = null;
		$format = null;
		$cnt_format = 0;
		$parent = array();
		$myParent = array();
		$cnt_layer = -1;
		$request = null; 
		$layer_style = array();
		$cnt_styles = -1;
		
		$this->wms_getfeatureinfo = "";
		$this->gui_wms_featureinfoformat = "";

		foreach ($values as $element) {
			if(mb_strtoupper($element[tag]) == "WMT_MS_CAPABILITIES" && $element[type] == "open"){
				$this->wms_version = $element[attributes][version];
			}
			if(mb_strtoupper($element[tag]) == "TITLE" && $element[level] == '3'){
				$this->wms_title = $this->stripEndlineAndCarriageReturn($element[value]);
			}
			if(mb_strtoupper($element[tag]) == "ABSTRACT" && $element[level] == '3'){
				$this->wms_abstract = $this->stripEndlineAndCarriageReturn($element[value]);
			}
			if(mb_strtolower($element[tag]) == "fees"){
				$this->fees = $element[value];
			}
			if(mb_strtolower($element[tag]) == "accessconstraints"){
				$this->accessconstraints = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactperson"){
				$this->contactperson = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactposition"){
				$this->contactposition = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactorganization"){
				$this->contactorganization = $element[value];
			}
			if(mb_strtolower($element[tag]) == "address"){
				$this->address = $element[value];
			}
			if(mb_strtolower($element[tag]) == "city"){
				$this->city = $element[value];
			}
			if(mb_strtolower($element[tag]) == "stateorprovince"){
				$this->stateorprovince = $element[value];
			}
			if(mb_strtolower($element[tag]) == "postcode"){
				$this->postcode = $element[value];
			}
			if(mb_strtolower($element[tag]) == "country"){
				$this->country = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactvoicetelephone"){
				$this->contactvoicetelephone = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactfacsimiletelephone"){
				$this->contactfacsimiletelephone = $element[value];
			}
			if(mb_strtolower($element[tag]) == "contactelectronicmailaddress"){
				$this->contactelectronicmailaddress = $element[value];
			}
	  		if(mb_strtolower($element[tag]) == "keyword" && $section != 'layer'){
				$this->wms_keyword[count($this->wms_keyword)] = $element[value];
			}
			
			/*map section*/
			if($this->wms_version == "1.0.0"){
		 		if(mb_strtoupper($element[tag]) == "MAP" && $element[type] == "open"){
					$section = "map";
				}
				if($section == "map" && mb_strtoupper($element[tag]) == "GET"){
					$this->wms_getmap = $element[attributes][onlineResource];
				}
				if($section == "map" && mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "open"){
					$format = "map";
				}
				if(mb_strtoupper($element[tag]) != "FORMAT" && $section == "map" && $format == "map"){
					if (!$this->formatExists("map", trim($element[tag]))) {
						$this->data_type[$cnt_format] = "map";
						$this->data_format[$cnt_format] = trim($element[tag]);
						$cnt_format++;
					}
				}
				if(mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "close"){
					$format = "";
				}
				if(mb_strtoupper($element[tag]) == "MAP" && $element[type] == "close"){
					$section = "";
				}
			}
			else{
				if(mb_strtoupper($element[tag]) == "GETMAP" && $element[type] == "open"){
					$section = "map";
				}
				if($section == "map" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "open"){
					$request = "get";
				}
				if($section == "map" && $request == "get" && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->wms_getmap = $element[attributes]["xlink:href"];
				}
				if($section == "map" && mb_strtoupper($element[tag]) == "FORMAT"){
					if (!$this->formatExists("map", trim($element[value]))) {
						$this->data_type[$cnt_format] = "map";
						$this->data_format[$cnt_format] = trim($element[value]);
						$cnt_format++;
					}
				}
				if($section == "map" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "close"){
					$request = "";
				}
				if(mb_strtoupper($element[tag]) == "GETMAP" && $element[type] == "close"){
					$section = "";
				}
			}
			/*capabilities section*/
			if($this->wms_version == "1.0.0"){
				if(mb_strtoupper($element[tag]) == "CAPABILITIES" && $element[type] == "open"){
					$section = "capabilities";
				}
				if($section == "capabilities" && mb_strtoupper($element[tag]) == "GET"){
					$this->wms_getcapabilities = $element[attributes][onlineResource];
				}
				if(mb_strtoupper($element[tag]) == "CAPABILITIES" && $element[type] == "close"){
					$section = "";
				}
			}
			else{
				if(mb_strtoupper($element[tag]) == "GETCAPABILITIES" && $element[type] == "open"){
					$section = "capabilities";
				}
				if($section == "capabilities" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "open"){
					$request = "get";
				}
				if($section == "capabilities" && $request == "get" && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->wms_getcapabilities = $element[attributes]["xlink:href"];
				}
				if($section == "capabilities" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "close"){
					$request = "";
				}
				if(mb_strtoupper($element[tag]) == "GETCAPABILITIES" && $element[type] == "close"){
					$section = "";
				}
			}
			/*featureInfo section*/
			if($this->wms_version == "1.0.0"){
				if(mb_strtoupper($element[tag]) == "FEATUREINFO" && $element[type] == "open"){
					$section = "featureinfo";
				}
				if($section == "featureinfo" && mb_strtoupper($element[tag]) == "GET"){
					$this->wms_getfeatureinfo = $element[attributes][onlineResource];
				}
				if($section == "featureinfo" && mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "open"){
					$format = "featureinfo";
				}
				if(mb_strtoupper($element[tag]) != "FORMAT" && $section == "featureinfo" && $format == "featureinfo"){
					if (!$this->formatExists("featureinfo", trim($element[tag]))) {
						$this->data_type[$cnt_format] = "featureinfo";
						$this->data_format[$cnt_format] = trim($element[tag]);
						$cnt_format++;
					}
				}
				if(mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "close"){
					$format = "";
				}
				if(mb_strtoupper($element[tag]) == "FEATUREINFO" && $element[type] == "close"){
					$section = "";
				}
			}
			else{
				if(mb_strtoupper($element[tag]) == "GETFEATUREINFO" && $element[type] == "open"){
					$section = "featureinfo";
				}
				if($section == "featureinfo" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "open"){
					$request = "get";
				}
				if($section == "featureinfo" && $request == "get" && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->wms_getfeatureinfo = $element[attributes]["xlink:href"];
				}
				if($section == "featureinfo" && mb_strtoupper($element[tag]) == "FORMAT"){
					if (!$this->formatExists("featureinfo", trim($element[value]))) {
						$this->data_type[$cnt_format] = "featureinfo";
						$this->data_format[$cnt_format] = trim($element[value]);
						$cnt_format++;
					}
				}
				if($section == "featureinfo" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "close"){
					$request = "";
				}
				if(mb_strtoupper($element[tag]) == "GETFEATUREINFO" && $element[type] == "close"){
					$section = "";
				}
			}
			/*exception section*/
			if($this->wms_version == "1.0.0"){
				if(mb_strtoupper($element[tag]) == "EXCEPTION" && $element[type] == "open"){
					$section = "exception";
				}
				if($section == "exception" && mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "open"){
					$format = "exception";
				}
				if(mb_strtoupper($element[tag]) != "FORMAT" && $section == "exception" && $format == "exception"){
					$this->data_type[$cnt_format] = "exception";
					$this->data_format[$cnt_format] = trim($element[tag]);
					$cnt_format++;
				}
				if($section == "exception" && mb_strtoupper($element[tag]) == "FORMAT" && $element[type] == "close"){
					$format = "";
				}
				if(mb_strtoupper($element[tag]) == "EXCEPTION" && $element[type] == "close"){
					$section = "";
				}
			}
			else{
				if(mb_strtoupper($element[tag]) == "EXCEPTION" && $element[type] == "open"){
					$section = "exception";
				}
				if($section == "exception" && mb_strtoupper($element[tag]) == "FORMAT"){
					$this->data_type[$cnt_format] = "exception";
					$this->data_format[$cnt_format] = trim($element[value]);
					$cnt_format++;
				}
				if(mb_strtoupper($element[tag]) == "EXCEPTION" && $element[type] == "close"){
					$section = "";
				}
			}
	      /*legend section*/
	      if($this->wms_version == "1.0.0"){
	      
	      }
	      else{
	        if(mb_strtoupper($element[tag]) == "GETLEGENDGRAPHIC" && $element[type] == "open"){
				$section = "legend";
			}
	        if($section == "legend" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "open"){
				$request = "get";
			}
			if($section == "legend" && $request == "get" && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
				$this->wms_getlegendurl = $element[attributes]["xlink:href"];
			}
	        if($section == "legend" && mb_strtoupper($element[tag]) == "GET" && $element[type] == "close"){
				$request = "";
			}
			if(mb_strtoupper($element[tag]) == "GETLEGENDGRAPHIC" && $element[type] == "close"){
				$section = "";
			}         
	      }
			/* sld section */	      
			if(mb_strtoupper($element[tag]) == "USERDEFINEDSYMBOLIZATION" && $element[type] == "complete"){
				$this->wms_supportsld = $element[attributes]["SupportSLD"];
				$this->wms_userlayer = $element[attributes]["UserLayer"];
				$this->wms_userstyle = $element[attributes]["UserStyle"];
				$this->wms_remotewfs = $element[attributes]["RemoteWFS"];
			}
	      	      
			/*layer section*/				
			if(mb_strtoupper($element[tag]) == "LAYER"){
				$section = "layer";
				if ($element[type] == "open") {
					$cnt_epsg = -1;
					//new for resolving metadataurls and dataurls
					$cnt_metadataurl = -1;
					$cnt_dataurl = -1;
					$cnt_layer++;
					$parent[$element[level]+1] = $cnt_layer;
					$myParent[$cnt_layer]= $parent[$element[level]];
					$this->addLayer($cnt_layer,$myParent[$cnt_layer]);
					$this->objLayer[$cnt_layer]->layer_queryable = $element[attributes][queryable];
				}
				if ($element[type] == "close") {
				
				}
			}
			/* attribution */
			if(mb_strtoupper($element[tag]) == "ATTRIBUTION"){
				if ($element[type] == "open") {
					$section = "attribution";
				}
				if ($element[type] == "close") {
					$section = "layer";
				}
			}
			/* styles */
			if(mb_strtoupper($element[tag]) == "STYLE"){
				$section = "style";
				if($cnt_layer != $layer_style){
					$layer_style = $cnt_layer;
					$cnt_styles = -1;
				}
				if ($element[type] == "open") {
					$cnt_styles++;
				}
				if ($element[type] == "close") {
					$section = "layer";
				}
			}
			if($section == "style"){
				if(mb_strtoupper($element[tag]) == "NAME"){
					$this->objLayer[$cnt_layer]->layer_style[$cnt_styles]["name"] = ($element[value] ? $element[value] : 'default');
				}
				if(mb_strtoupper($element[tag]) == "TITLE"){
					$this->objLayer[$cnt_layer]->layer_style[$cnt_styles]["title"] = ($element[value] ? $element[value] : '');
				}
	      			if(mb_strtoupper($element[tag]) == "LEGENDURL" && $element[type] == "open"){
					$legendurl = true;
				}
				if($legendurl && mb_strtoupper($element[tag]) == "FORMAT"){
					$this->objLayer[$cnt_layer]->layer_style[$cnt_styles]["legendurlformat"] = $element[value];
				}
				if($legendurl && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->objLayer[$cnt_layer]->layer_style[$cnt_styles]["legendurl"] = $element[attributes]["xlink:href"];
				}
				if(mb_strtoupper($element[tag]) == "LEGENDURL" && $element[type] == "close"){
					$legendurl = false;
				}   
			}
			/* end of styles */
			if($section == "layer"){
				if(mb_strtoupper($element[tag]) == "NAME"){
					$this->objLayer[$cnt_layer]->layer_name = $element[value];
				}
				if(mb_strtoupper($element[tag]) == "TITLE"){
					$this->objLayer[$cnt_layer]->layer_title = $this->stripEndlineAndCarriageReturn($element[value]);
				}
				if(mb_strtoupper($element[tag]) == "ABSTRACT"){
					$this->objLayer[$cnt_layer]->layer_abstract = $this->stripEndlineAndCarriageReturn($element[value]);
				}
				if(mb_strtoupper($element[tag]) == "KEYWORD"){
					array_push($this->objLayer[$cnt_layer]->layer_keyword, trim($element[value]));
				}
	      			if(mb_strtoupper($element[tag]) == "DATAURL" && $element[type] == "open"){
					$dataurl = true;
					$cnt_dataurl++;
				}
				if($dataurl && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->objLayer[$cnt_layer]->layer_dataurl[$cnt_dataurl]->href = $element[attributes]["xlink:href"];
				}
			    	if(mb_strtoupper($element[tag]) == "DATAURL" && $element[type] == "close"){
					$dataurl = false;
			   	}   
				
				if(mb_strtoupper($element[tag]) == "METADATAURL" && $element[type] == "open"){
					$metadataurl = true;
					$cnt_metadataurl++;
					$this->objLayer[$cnt_layer]->layer_metadataurl[$cnt_metadataurl]->type = $element[attributes]["type"];
				}
				if($metadataurl && mb_strtoupper($element[tag]) == "FORMAT"){
					$this->objLayer[$cnt_layer]->layer_metadataurl[$cnt_metadataurl]->format = $element[value];
				}
				if($metadataurl && mb_strtoupper($element[tag]) == "ONLINERESOURCE"){
					$this->objLayer[$cnt_layer]->layer_metadataurl[$cnt_metadataurl]->href = $element[attributes]["xlink:href"];
				}
			    	if(mb_strtoupper($element[tag]) == "METADATAURL" && $element[type] == "close"){
					$metadataurl = false;
				}   
				
				if(mb_strtoupper($element[tag]) == "SRS"){
					// unique srs only, see http://www.mapbender.org/index.php/Arrays_with_unique_entries
					$this->wms_srs = array_keys(array_flip(array_merge($this->wms_srs, explode(" ", strtoupper($element[value])))));
				}						      
				if(mb_strtoupper($element[tag]) == "LATLONBOUNDINGBOX"){
					$cnt_epsg++;
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["epsg"] = "EPSG:4326";
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["minx"] = $element[attributes][minx];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["miny"] = $element[attributes][miny];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["maxx"] = $element[attributes][maxx];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["maxy"] = $element[attributes][maxy];
				}
				if(mb_strtoupper($element[tag]) == "BOUNDINGBOX" && $element[attributes][SRS] != "EPSG:4326"){
					$cnt_epsg++;
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["epsg"] = $element[attributes][SRS];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["minx"] = $element[attributes][minx];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["miny"] = $element[attributes][miny];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["maxx"] = $element[attributes][maxx];
					$this->objLayer[$cnt_layer]->layer_epsg[$cnt_epsg]["maxy"] = $element[attributes][maxy];
					// a default epsg for mapbender
					if($cnt_layer == 0 && $this->default_epsg == 0 && mb_strlen(trim($element[attributes][SRS]))>= 10){
						$this->default_epsg = $cnt_epsg;
					}
				}
				if(mb_strtoupper($element[tag]) == "SCALEHINT"){
					if($element[attributes][max]>1000) $max = 0; else $max = $element[attributes][max]; 	
					if($element[attributes][min]>1000) $min = 0; else $min = $element[attributes][min]; 	
					$this->objLayer[$cnt_layer]->layer_minscale = round(($min * 2004.3976484406788493955738891127));
					$this->objLayer[$cnt_layer]->layer_maxscale = round(($max * 2004.3976484406788493955738891127));
					$this->objLayer[$cnt_layer]->layer_minscale = sprintf("%u", $this->objLayer[$cnt_layer]->layer_minscale);
					$this->objLayer[$cnt_layer]->layer_maxscale = sprintf("%u", $this->objLayer[$cnt_layer]->layer_maxscale);
				}
			} 
			else {
				continue;
			}
		}
		if(!$this->wms_title || $this->wms_title == "" || !$this->wms_getmap || $this->wms_getmap == ""){
			$this->wms_status = false;
			$this->optimizeWMS();
			$e = new mb_exception("class_wms: createObjFromXML: WMS " . $url . " could not be loaded.");
			return false;
		}
		else{
			$this->wms_status = true;
			$this->optimizeWMS();
			$e = new mb_notice("class_wms: createObjFromXML: WMS " . $url . " has been loaded successfully.");
			return true;
		}
	}
	/**
	 * private function
	 */
	function optimizeWMS() {
		/*define defaults for wms-version 1.0.0*/
		$map_default_ok = false;
		$featureinfo_default_ok = false;
		$exception_default_ok = false;
		if($this->wms_version == "1.0.0"){
			$map_default = "PNG";
			$featureinfo_default = "MIME";
			$exception_default = "INIMAGE";
		}
		/*define defaults for wms-version 1.1.0 and 1.1.1*/
		else{
			$map_default = "image/png";
			$featureinfo_default = "text/html";
			$exception_default = "application/vnd.ogc.se_inimage";
		}
		#some default
		$this->gui_wms_visible = 1;
		$this->gui_wms_opacity = 100;
		/*if the rootlayer has no epsg...*/
		if($this->objLayer[0]->layer_epsg[0]["epsg"] == ""){
			$this->objLayer[0]->layer_epsg = $this->objLayer[1]->layer_epsg;
			for($i=0;$i<count($this->objLayer[0]->layer_epsg);$i++){
				for($j=1; $j<count($this->objLayer); $j++){
					if($this->objLayer[0]->layer_epsg[$i]["epsg"] == $this->objLayer[$j]->layer_epsg[$i]["epsg"]){
						if($this->objLayer[$j]->layer_epsg[$i]["minx"]<$this->objLayer[0]->layer_epsg[$i]["minx"]){
							$this->objLayer[0]->layer_epsg[$i]["minx"] = $this->objLayer[$j]->layer_epsg[$i]["minx"];
						}
						if($this->objLayer[$j]->layer_epsg[$i]["miny"]<$this->objLayer[0]->layer_epsg[$i]["miny"]){
							$this->objLayer[0]->layer_epsg[$i]["miny"] = $this->objLayer[$j]->layer_epsg[$i]["miny"];
						}
						if($this->objLayer[$j]->layer_epsg[$i]["maxx"]>$this->objLayer[0]->layer_epsg[$i]["maxx"]){
							$this->objLayer[0]->layer_epsg[$i]["maxx"] = $this->objLayer[$j]->layer_epsg[$i]["maxx"];
						}
						if($this->objLayer[$j]->layer_epsg[$i]["maxy"]>$this->objLayer[0]->layer_epsg[$i]["maxy"]){
							$this->objLayer[0]->layer_epsg[$i]["maxy"] = $this->objLayer[$j]->layer_epsg[$i]["maxy"];
						}
					}
				}
			}
		}
		for($i=0;$i<count($this->objLayer);$i++){
			if(count($this->objLayer[$i]->layer_epsg) == 0 && count($this->objLayer[0]->layer_epsg) > 0){
				$this->objLayer[$i]->layer_epsg = $this->objLayer[0]->layer_epsg; 
			}
			if(!is_int($this->objLayer[$i]->layer_parent)){
				$this->objLayer[$i]->layer_abstract = $this->wms_abstract;
				for ($r = 0; $r < count($this->wms_keyword); $r++) {
					array_push($this->objLayer[$i]->layer_keyword, trim($this->wms_keyword[$r]));
				}
			}
			if($this->objLayer[$i]->layer_name == ""){
				$this->objLayer[$i]->layer_name = $this->objLayer[$i]->layer_title;
			}
			if($this->objLayer[$i]->layer_minscale == ""){
				$this->objLayer[$i]->layer_minscale = 0;
			}
			if($this->objLayer[$i]->layer_maxscale == ""){
				$this->objLayer[$i]->layer_maxscale = 0;
			}
			if($this->objLayer[$i]->layer_queryable == ""){
				$this->objLayer[$i]->layer_queryable = 0;
			}
			$this->objLayer[$i]->gui_layer_minscale = $this->objLayer[$i]->layer_minscale;
			$this->objLayer[$i]->gui_layer_maxscale = $this->objLayer[$i]->layer_maxscale;
			$this->objLayer[$i]->layer_searchable = 1;
		}
		for($i=0;$i<count($this->data_format);$i++){
			if(mb_strtolower($this->data_type[$i]) == 'map' && mb_strtoupper($this->data_format[$i]) == mb_strtoupper($map_default)){
				$this->gui_wms_mapformat = mb_strtolower($map_default);
				$map_default_ok = true;
			}
			if(mb_strtolower($this->data_type[$i]) == 'featureinfo' && mb_strtoupper($this->data_format[$i]) == mb_strtoupper($featureinfo_default)){
				$this->gui_wms_featureinfoformat = mb_strtolower($featureinfo_default);
				$featureinfo_default_ok = true;
			}		
			if(mb_strtolower($this->data_type[$i]) == 'exception' && mb_strtolower($this->data_format[$i]) == mb_strtolower($exception_default)){
				$this->gui_wms_exceptionformat = mb_strtolower($exception_default);
				$exception_default_ok = true;
			}		
		}
		if($map_default_ok == false){
			for($i=0;$i<count($this->data_format);$i++){
				if(mb_strtolower($this->data_type[$i]) == "map" ){$this->gui_wms_mapformat = $this->data_format[$i]; break;}
			}
		}
		if($featureinfo_default_ok == false){
			for($i=0;$i<count($this->data_format);$i++){
				if(mb_strtolower($this->data_type[$i]) == "featureinfo" ){$this->gui_wms_featureinfoformat = $this->data_format[$i]; break;}
			}
		}
		if($exception_default_ok == false){
			for($i=0;$i<count($this->data_format);$i++){
				if(mb_strtolower($this->data_type[$i]) == "exception" ){$this->gui_wms_exceptionformat = $this->data_format[$i]; break;}
			}
		}
		
		if(count($this->objLayer[0]->layer_epsg)>1){
			$this->gui_wms_epsg = $this->objLayer[0]->layer_epsg[$this->default_epsg][epsg];
		}
		else{
			$this->gui_wms_epsg = $this->objLayer[0]->layer_epsg[0][epsg];
		}
		/*the queryable layers*/
		for($i=0; $i<count($this->objLayer); $i++){
			if($this->objLayer[$i]->layer_queryable == 1){
				$this->objLayer[$i]->gui_layer_queryable = 1;
			}
			else{
				$this->objLayer[$i]->gui_layer_queryable = 0;
			}
		}
		for($i=0; $i<count($this->objLayer); $i++){
				$this->objLayer[$i]->layer_pos=$i;
		}
		
		// check if gui_layer_title isset
		for($i=0; $i<count($this->objLayer); $i++){
			$this->objLayer[$i]->gui_layer_title = $this->objLayer[$i]->gui_layer_title != "" ?
				$this->objLayer[$i]->gui_layer_title :
				$this->objLayer[$i]->layer_title;
		}
		
		/* fill sld variables when empty */
		if($this->wms_supportsld == ""){
				$this->wms_supportsld = 0;
		}
		if($this->wms_userlayer == ""){
				$this->wms_userlayer = 0;
		}
		if($this->wms_userstyle == ""){
				$this->wms_userstyle = 0;
		}
		if($this->wms_remotewfs == ""){
				$this->wms_remotewfs = 0;
		}
	  }
	
	function displayWMS(){
		echo "<br>id: " . $this->wms_id . " <br>";
		echo "version: " . $this->wms_version . " <br>";
		echo "title: " . $this->wms_title . " <br>";
		echo "abstract: " . $this->wms_abstract . " <br>";
		echo "maprequest: " . $this->wms_getmap . " <br>";
		echo "capabilitiesrequest: " . $this->wms_getcapabilities . " <br>";
		echo "featureinforequest: " . $this->wms_getfeatureinfo . " <br>";
		echo "gui_wms_mapformat: " . $this->gui_wms_mapformat . " <br>";
		echo "gui_wms_featureinfoformat: " . $this->gui_wms_featureinfoformat . " <br>";
		echo "gui_wms_exceptionformat: " . $this->gui_wms_exceptionformat . " <br>";	
		echo "gui_wms_epsg: " . $this->gui_wms_epsg . " <br>";
		echo "wms_srs: " . implode(", ", $this->wms_srs) . " <br>";
		echo "gui_wms_visible: " . $this->gui_wms_visible . " <br>";
		echo "gui_wms_opacity: " . $this->gui_wms_opacity . " <br>";
		echo "support_sld: " . $this->wms_supportsld . " <br>";
		
		for($i=0; $i<count($this->data_type);$i++){
			echo $this->data_type[$i]. " -> ".$this->data_format[$i]. "<br>";
		}
		for($i=0; $i<count($this->objLayer); $i++){
			echo "<hr>";
			echo "id: <b>".$this->objLayer[$i]->layer_id ."</b> parent: <b>".$this->objLayer[$i]->layer_parent."</b> name: <b>".$this->objLayer[$i]->layer_name;
			echo "</b> title: <b>".$this->objLayer[$i]->layer_title. "</b> queryable: <b>".$this->objLayer[$i]->layer_queryable."</b> minScale: <b>". $this->objLayer[$i]->layer_minscale."</b> maxScale: <b>".$this->objLayer[$i]->layer_maxscale."</b>";
			echo "<br>dataurl: <b>".$this->objLayer[$i]->layer_dataurl[0]->href. "</b>";
			echo "<br>MetadataUrls:<br>";
			echo "<table border='1'>";
			echo "<tr><td>link</td><td>type</td><td>format</td></tr>";
			for($j=0; $j<count($this->objLayer[$i]->layer_metadataurl);$j++){
				echo "<tr><td>".$this->objLayer[$i]->layer_metadataurl[$j]->href."</td><td>".$this->objLayer[$i]->layer_metadataurl[$j]->type."</td><td>".$this->objLayer[$i]->layer_metadataurl[$j]->format."</td></tr>";
			}
			echo "</table>";
			echo "<br>BBOXes:<br>";
			echo "<table border='1'>";
			for($j=0; $j<count($this->objLayer[$i]->layer_epsg);$j++){
				echo "<tr><td>".$this->objLayer[$i]->layer_epsg[$j][epsg]."</td><td>".$this->objLayer[$i]->layer_epsg[$j][minx]."</td>";
				echo "<td>".$this->objLayer[$i]->layer_epsg[$j][miny]."</td><td>".$this->objLayer[$i]->layer_epsg[$j][maxx]."</td>";
				echo "<td>".$this->objLayer[$i]->layer_epsg[$j][maxy]."</td></tr>";
			}
			echo "</table>";
			echo "layerstyle:";
			echo "<table border='1'>";
			echo "<tr><td>name</td><td>title</td><td>legendurl</td><td>legendurlformat</td></tr>";
			for($j=0; $j<count($this->objLayer[$i]->layer_style);$j++){
				echo "<tr><td>".$this->objLayer[$i]->layer_style[$j][name]."</td><td>".$this->objLayer[$i]->layer_style[$j][title]."</td><td>".$this->objLayer[$i]->layer_style[$j][legendurl]."</td><td>".$this->objLayer[$i]->layer_style[$j][legendurlformat]."</td></tr>";
			}
			echo "</table>";
	        echo "<hr>";
	        echo "<hr>";
		}
	} 
	  function addLayer($id,$parent){	
		$this->objLayer[count($this->objLayer)] = new layer($id,$parent);
	  }
	  /**
	   * private function
	   */
	  function stripEndlineAndCarriageReturn($string) {
	  	return preg_replace("/\n/", "", preg_replace("/\r/", " ", $string));
	  }
		function createJsObjFromWMS($parent=0){
			echo $this->createJsObjFromWMS_($parent);
		}
		

	function newLayer ($currentLayer, $currentExtent) {
		$pos = $currentLayer["extension"]["LAYER_POS"];
		$parent = $currentLayer["extension"]["LAYER_PARENT"];
		$this->addLayer($pos, $parent); 

		// set layer data
		$layerIndex = count($this->objLayer) - 1;
		$newLayer = $this->objLayer[$layerIndex];
		$newLayer->layer_uid = $currentLayer["extension"]["LAYER_ID"];
		$newLayer->layer_name = $currentLayer["name"];
		$newLayer->layer_title = $currentLayer["title"];
		$newLayer->gui_layer_title = $currentLayer["title"];
		$newLayer->layer_dataurl[0]->href = $currentLayer["dataurl"];
		$newLayer->layer_pos = $currentLayer["extension"]["LAYER_POS"];
		$newLayer->layer_queryable = $currentLayer["queryable"];
		$newLayer->layer_minscale = $currentLayer["extension"]["MINSCALE"];
		$newLayer->layer_maxscale = $currentLayer["extension"]["MAXSCALE"];
		$newLayer->layer_metadataurl[0]->href = $currentLayer["metadataurl"];
//		$newLayer->layer_searchable = $currentLayer["searchable"];
		$newLayer->gui_layer_wms_id = $currentLayer["extension"]["WMS_ID"];
		$newLayer->gui_layer_status = $currentLayer["extension"]["GUI_STATUS"];
		if ($styleIndex >= 0 && $styleIndex < count($currentLayer["style"])) {
			$newLayer->gui_layer_style = $currentLayer["style"][$styleIndex]["name"];
		}
		else {
			$newLayer->gui_layer_style = "";
		}
		$newLayer->gui_layer_selectable = $currentLayer["extension"]["GUI_SELECTABLE"];
		if (isset($currentLayer["extension"]["OVERVIEWHIDDEN"])) {
			$newLayer->gui_layer_visible = ($currentLayer["extension"]["OVERVIEWHIDDEN"] === "1") ? false : true;
		}
		else {
			$newLayer->gui_layer_visible = $currentLayer["visible"];
		}
		if (isset($currentLayer["extension"]["WFSFEATURETYPE"])) {
			$newLayer->gui_layer_wfs_featuretype = strval($currentLayer["extension"]["WFSFEATURETYPE"]);
		}
		else {
			$newLayer->gui_layer_wfs_featuretype = "";
		}
		$newLayer->gui_layer_queryable = $currentLayer["extension"]["GUI_QUERYABLE"];
		$newLayer->gui_layer_querylayer = $currentLayer["extension"]["QUERYLAYER"];
		$newLayer->gui_layer_minscale = $currentLayer["extension"]["GUI_MINSCALE"];
		$newLayer->gui_layer_maxscale = $currentLayer["extension"]["GUI_MAXSCALE"];
		$newLayer->layer_abstract = $currentLayer["abstract"];

		//
		// set layer epsg
		//
		$tmpEpsgArray= array();
		$newLayer->layer_epsg = array();
		if ($currentLayer["extension"]["EPSG"]) {
			$layerEpsgArray = array();
			$layerMinXArray = array();
			$layerMinYArray = array();
			$layerMaxXArray = array();
			$layerMaxYArray = array();
			if (!is_array($currentLayer["extension"]["EPSG"])) {
				$layerEpsgArray[0] = $currentLayer["extension"]["EPSG"];
				$layerMinXArray[0] = $currentLayer["extension"]["MINX"];
				$layerMinYArray[0] = $currentLayer["extension"]["MINY"];
				$layerMaxXArray[0] = $currentLayer["extension"]["MAXX"];
				$layerMaxYArray[0] = $currentLayer["extension"]["MAXY"];
			}
			else {
				$layerEpsgArray = $currentLayer["extension"]["EPSG"];
				$layerMinXArray = $currentLayer["extension"]["MINX"];
				$layerMinYArray = $currentLayer["extension"]["MINY"];
				$layerMaxXArray = $currentLayer["extension"]["MAXX"];
				$layerMaxYArray = $currentLayer["extension"]["MAXY"];
			}

			for ($i=0; $i < count($layerEpsgArray); $i++) {
				$currentLayerEpsg = array();
				$currentLayerEpsg["epsg"] = $layerEpsgArray[$i];
				$tmpEpsgArray[]= $layerEpsgArray[$i];
				if ($layerMinXArray[$i] == 0
					&& $layerMinYArray[$i] == 0
					&& $layerMaxXArray[$i] == 0
					&& $layerMaxYArray[$i] == 0
					) {
					$currentLayerEpsg["minx"] = null;
					$currentLayerEpsg["miny"] = null; 
					$currentLayerEpsg["maxx"] = null;
					$currentLayerEpsg["maxy"] = null;
				}
				else {
					$currentLayerEpsg["minx"] = floatval($layerMinXArray[$i]);
					$currentLayerEpsg["miny"] = floatval($layerMinYArray[$i]); 
					$currentLayerEpsg["maxx"] = floatval($layerMaxXArray[$i]);
					$currentLayerEpsg["maxy"] = floatval($layerMaxYArray[$i]);
				}
				array_push($newLayer->layer_epsg, $currentLayerEpsg);
			}
		}
		for ($i = 0; $i < count($currentLayer["epsg"]); $i++) {
			if (!in_array($currentLayer["epsg"][$i], $tmpEpsgArray)) {
				$newLayer->layer_epsg[]= array(
					"epsg" => $currentLayer["epsg"][$i],
					"minx" => null,
					"miny" => null,
					"maxx" => null,
					"maxy" => null
				);
			}
		}

		//
		// set layer style
		//
		for ($i = 0; $i < count($currentLayer["style"]); $i++) {
			$newLayer->layer_style[$i] = array();
			$newLayer->layer_style[$i]["name"] = $currentLayer["style"][$i]["name"];
			$newLayer->layer_style[$i]["title"] = $currentLayer["style"][$i]["title"];
			$newLayer->layer_style[$i]["legendurl"] = $currentLayer["style"][$i]["legendurl"];
			$newLayer->layer_style[$i]["legendurl_format"] = $currentLayer["style"][$i]["legendurl_type"];
		}
	}
	
	  function createJsObjFromWMS_($parent=0){
		$str = "";
	  	if(!$this->wms_title || $this->wms_title == ""){
			$str .= "alert('Error: no valid capabilities-document !!');";
			die; exit;
		}
			if($parent){
				$str .=  "parent.";
			}
			// wms_title and abstract have previously been urlencoded
			// this solution may not yet be the ultimate one
			
			$add_wms_string = "add_wms(" .
					"'" . $this->wms_id ."'," .
					"'" . $this->wms_version ."'," .
					"'" . addslashes($this->wms_title) . "'," .
					"'" . addslashes($this->wms_abstract) ."'," .
					"'" . $this->wms_getmap ."'," .
					"'" . $this->wms_getfeatureinfo ."'," .
					"'" . $this->wms_getlegendurl ."'," .
					"'" . $this->wms_filter ."'," .
					"'" . $this->gui_wms_mapformat . "'," .
					"'" . $this->gui_wms_featureinfoformat . "'," .
					"'" . $this->gui_wms_exceptionformat . "'," .
					"'" . $this->gui_wms_epsg ."'," .
					"'" . $this->gui_wms_visible ."'," .
					"'" . $this->gui_wms_opacity ."'," .
					"'" . $this->gui_wms_sldurl ."" .
					"');";
			$str .=  $add_wms_string;
			
		for($i=0;$i<count($this->data_format);$i++){
			if($parent){
				$str .=  "parent.";
			}		
			$str .= "wms_add_data_type_format('". $this->data_type[$i] ."','". $this->data_format[$i] ."');";		
		}
		for($i=0; $i<count($this->objLayer); $i++){
			if($parent){
				$str .= "parent.";
			}
			$str .=  "wms_add_layer('". 
				$this->objLayer[$i]->layer_parent ."','". 
				$this->objLayer[$i]->layer_uid ."','". 
				addslashes($this->objLayer[$i]->layer_name) . "','". 
				addslashes($this->objLayer[$i]->layer_title) ."','". 
				$this->objLayer[$i]->layer_dataurl[0]->href ."','". 
				$this->objLayer[$i]->layer_pos ."','". 
				$this->objLayer[$i]->layer_queryable ."','". 
				$this->objLayer[$i]->layer_minscale . "','". 
				$this->objLayer[$i]->layer_maxscale ."','". 
				$this->objLayer[$i]->layer_metadataurl[0]->href ."','". 
// will be added later, not needed now TODO check if more than one metadataUrl is usefull here
//				$this->objLayer[$i]->layer_searchable ."','". 
				$this->objLayer[$i]->gui_layer_wms_id ."','". 
				$this->objLayer[$i]->gui_layer_status ."','".
				$this->objLayer[$i]->gui_layer_style ."','".  
				$this->objLayer[$i]->gui_layer_selectable ."','". 
				$this->objLayer[$i]->gui_layer_visible ."','". 
				$this->objLayer[$i]->gui_layer_queryable ."','". 
				$this->objLayer[$i]->gui_layer_querylayer ."','". 
				$this->objLayer[$i]->gui_layer_minscale ."','". 
				$this->objLayer[$i]->gui_layer_maxscale ."','".
				$this->objLayer[$i]->gui_layer_wfs_featuretype ."','".
				$this->objLayer[$i]->gui_layer_title ."');";
				
			for($j=0; $j<count($this->objLayer[$i]->layer_epsg);$j++){
				$currentEpsg = $this->objLayer[$i]->layer_epsg[$j];
				if($i==0){
					if($parent){
						$str .= "parent.";
					}
					$str .= "wms_addSRS('". 
						$currentEpsg["epsg"] ."',". 
						(is_null($currentEpsg["minx"]) ? "null" : $currentEpsg["minx"]) .",". 
						(is_null($currentEpsg["miny"]) ? "null" : $currentEpsg["miny"]) .",". 
						(is_null($currentEpsg["maxx"]) ? "null" : $currentEpsg["maxx"]) .",". 
						(is_null($currentEpsg["maxy"]) ? "null" : $currentEpsg["maxy"]) .");";
				}
				if (!is_null($currentEpsg["epsg"])) {
					if($parent){
						$str .=  "parent.";
					}
					$str .= "layer_addEpsg('". 
						$currentEpsg["epsg"] ."',". 
						(is_null($currentEpsg["minx"]) ? "null" : $currentEpsg["minx"]) .",". 
						(is_null($currentEpsg["miny"]) ? "null" : $currentEpsg["miny"]) .",". 
						(is_null($currentEpsg["maxx"]) ? "null" : $currentEpsg["maxx"]) .",". 
						(is_null($currentEpsg["maxy"]) ? "null" : $currentEpsg["maxy"]) .");";
				}
			}
			for($j=0; $i==0 && $j<count($this->wms_srs);$j++){
				$found = false;
				for ($k = 0; $k < count($this->objLayer[$i]->layer_epsg); $k++){
					if ($this->objLayer[$i]->layer_epsg[$k]["epsg"] === $this->wms_srs[$j]) {
						$found = true;
						break;
					}
				}
				if ($found) {
					continue;
				}
				
				if($parent){
					$str .= "parent.";
				}
				$str .= "wms_addSRS('". 
				$this->wms_srs[$j] ."', null, null, null, null);\n";
			}
			for($j=0; $j<count($this->objLayer[$i]->layer_style);$j++){
				if($parent){
				$str .= "parent.";
				}
				$str .= "wms_addLayerStyle('".$this->objLayer[$i]->layer_style[$j]["name"].
					"', '".$this->objLayer[$i]->layer_style[$j]["title"].
					"', ".$j.
					",".$i.
					",'".$this->objLayer[$i]->layer_style[$j]["legendurl"].
					"', '".$this->objLayer[$i]->layer_style[$j]["legendurlformat"]."');";
			}
		}
		return $str;
	  }
	  
	  function createJsLayerObjFromWMS($parent=0, $layer_name){
	  	if(!$this->wms_title || $this->wms_title == ""){
			echo " alert('Error: no valid capabilities-document !!');";
			die; exit;
		}
			if($parent){
				echo "parent.";
			}
			// wms_title and abstract have previously been urlencoded
			// this solution may not yet be the ultimate one
			print("add_wms('". 
			$this->wms_id ."','".
			$this->wms_version ."','".
			preg_replace("/'/", "", $this->wms_title) ."','".
			preg_replace("/'/", "", $this->wms_abstract) ."','". 
			$this->wms_getmap ."','" .
			$this->wms_getfeatureinfo ."','".
			$this->wms_getlegendurl ."','".
			$this->wms_filter ."','".
			$this->gui_wms_mapformat ."','". 
			$this->gui_wms_featureinfoformat ."','". 
			$this->gui_wms_exceptionformat . "','". 
			$this->gui_wms_epsg ."','". 
			$this->gui_wms_visible ."','".
			$this->gui_wms_opacity ."','".
			$this->gui_wms_sldurl ."');");
			
		for($i=0;$i<count($this->data_format);$i++){
			if($parent){
				echo "parent.";
			}		
			echo "wms_add_data_type_format('". $this->data_type[$i] ."','". $this->data_format[$i] ."');";		
		}
		for($i=0; $i<count($this->objLayer); $i++){
			if($this->objLayer[$i]->layer_name == $layer_name|| $this->objLayer[$i]->layer_pos == 0){
			
				if($parent){
					echo "parent.";
				}
			 print ("wms_add_layer('". 
				$this->objLayer[$i]->layer_parent ."','". 
				$this->objLayer[$i]->layer_uid ."','". 
				$this->objLayer[$i]->layer_name . "','". 
				addslashes($this->objLayer[$i]->layer_title) ."','". 
				$this->objLayer[$i]->layer_dataurl[0]->href ."','". 
				$this->objLayer[$i]->layer_pos ."','". 
				$this->objLayer[$i]->layer_queryable ."','". 
				$this->objLayer[$i]->layer_minscale . "','". 
				$this->objLayer[$i]->layer_maxscale ."','". 
				$this->objLayer[$i]->layer_metadataurl[0]->href ."','". 
// will be added later, not needed now TODO check if more than one metadataUrl is usefull here
//				$this->objLayer[$i]->layer_searchable ."','". 
				$this->objLayer[$i]->gui_layer_wms_id ."','". 
				$this->objLayer[$i]->gui_layer_status ."','".
				$this->objLayer[$i]->gui_layer_style ."','". 
				$this->objLayer[$i]->gui_layer_selectable ."','". 
				$this->objLayer[$i]->gui_layer_visible ."','". 
				$this->objLayer[$i]->gui_layer_queryable ."','". 
				$this->objLayer[$i]->gui_layer_querylayer ."','". 
				$this->objLayer[$i]->gui_layer_minscale ."','". 
				$this->objLayer[$i]->gui_layer_maxscale ."','".
				$this->objLayer[$i]->gui_layer_wfs_featuretype ."','".
				$this->objLayer[$i]->gui_layer_title ."');");
			for($j=0; $j<count($this->objLayer[$i]->layer_epsg);$j++){
				if($i==0){
					if($parent){
					echo "parent.";
					}
					print("wms_addSRS('". 
						$this->objLayer[$i]->layer_epsg[$j]["epsg"] ."','". 
						$this->objLayer[$i]->layer_epsg[$j]["minx"] ."','". 
						$this->objLayer[$i]->layer_epsg[$j]["miny"] ."','". 
						$this->objLayer[$i]->layer_epsg[$j]["maxx"] ."','". 
						$this->objLayer[$i]->layer_epsg[$j]["maxy"] ."');");
				}
				if($parent){
				echo "parent.";
				}
				print("layer_addEpsg('". 
					$this->objLayer[$i]->layer_epsg[$j]["epsg"] ."','". 
					$this->objLayer[$i]->layer_epsg[$j]["minx"] ."','". 
					$this->objLayer[$i]->layer_epsg[$j]["miny"] ."','". 
					$this->objLayer[$i]->layer_epsg[$j]["maxx"] ."','". 
					$this->objLayer[$i]->layer_epsg[$j]["maxy"] ."');");
			}
			for($j=0; $j<count($this->objLayer[$i]->layer_style);$j++){
				if($parent){
				echo "parent.";
				}
				print("wms_addLayerStyle('".$this->objLayer[$i]->layer_style[$j]["name"]."', '".$this->objLayer[$i]->layer_style[$j]["title"]."', ".$j.",".$i.",'".$this->objLayer[$i]->layer_style[$j]["legendurl"]."', '".$this->objLayer[$i]->layer_style[$j]["legendurlformat"]."');");
			}
		   }	
		}
	  }
	  
	  
	/**
	* writeObjInDB
	*
	* this function exports the information from the xml to the mapbender database 
	*/
	function writeObjInDB($gui_id){
		global $con;
		if (func_num_args() == 2) { //new for HTTP Authentication
			$auth = func_get_arg(1);
			$username = $auth['username'];
			$password = $auth['password'];
			$authType = $auth['auth_type'];
		}
		else {
			$username = '';
			$password = '';
			$authType = '';		
		}
		$admin = new administration();
		$uuid = new Uuid();
		$this->checkObj();
		db_begin();
	
		# TABLE wms
		$sql = "INSERT INTO wms (wms_version, wms_title, wms_abstract, wms_getcapabilities, wms_getmap, ";
		$sql.= "wms_getfeatureinfo, wms_getlegendurl, wms_getcapabilities_doc, wms_upload_url, fees, ";
		$sql .= "accessconstraints, contactperson, contactposition, contactorganization, address, city, ";
		$sql .= "stateorprovince, postcode, country, contactvoicetelephone, contactfacsimiletelephone, contactelectronicmailaddress, ";
		$sql .= "wms_owner,wms_timestamp,wms_timestamp_create,wms_username,wms_password,wms_auth_type,";
		$sql .= "wms_supportsld, wms_userlayer, wms_userstyle, wms_remotewfs, uuid) ";
		$sql .= "VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30,$31,$32,$33)";
		$v = array(
			$this->wms_version,
			$this->wms_title,
			$this->wms_abstract,
			$this->wms_getcapabilities,
			$this->wms_getmap,
			$this->wms_getfeatureinfo,
			$this->wms_getlegendurl,
			$admin->char_encode($this->wms_getcapabilities_doc),
			$this->wms_upload_url,
			$this->fees,
			$this->accessconstraints,
			$this->contactperson,
			$this->contactposition,
			$this->contactorganization,
			$this->address,
			$this->city,
			$this->stateorprovince,
			$this->postcode,
			$this->country,
			$this->contactvoicetelephone,
			$this->contactfacsimiletelephone,
			$this->contactelectronicmailaddress,
			Mapbender::session()->get('mb_user_id'),
			strtotime("now"),
			strtotime("now"),
			$username,
			$password,
			$authType,
			$this->wms_supportsld,
			$this->wms_userlayer,
			$this->wms_userstyle,
			$this->wms_remotewfs,
			$uuid
		);
		$t = array(
			's','s','s','s','s','s','s','s','s','s','s','s','s','s','s','s',
			's','s','s','s','s','s','i','i','i','s','s','s','s','s','s','s','s'
		);
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();
			return null;
		}
		
		$myWMS = db_insert_id($con,'wms', 'wms_id');

		if ($authType != '') { //some authentication is needed! 
			$admin = new administration();
			echo "WMS ID: ".$myWMS;
			$admin->setWMSOWSstring($myWMS, 1);
		}

		# TABLE layer and gui_layer
		
		for($i=0; $i<count($this->objLayer); $i++){
			$this->insertLayer($i,$myWMS,$gui_id);
			$this->insertGuiLayer($i,$myWMS,$gui_id);
		}	
			
		
		#TABLE wms_srs
		$this->insertSRS($myWMS);	
		
		# TABLE wms_format	
		$this->insertFormat($myWMS);	
			
		# TABLE gui_wms
		
		$sql ="SELECT MAX(gui_wms_position) AS pos FROM gui_wms WHERE fkey_gui_id = $1";
		$v = array($gui_id);
		$t = array('s');
		$res = db_prep_query($sql,$v,$t);
		if (db_result($res, 0,"pos") > -1) {
			$position = db_result($res, 0,"pos") + 1;
		} 
		else { 
			$position = 0; 
		}
		
		$sql ="INSERT INTO gui_wms (fkey_gui_id, fkey_wms_id, gui_wms_position, gui_wms_mapformat, ";
		$sql .= "gui_wms_featureinfoformat, gui_wms_exceptionformat, gui_wms_epsg)";
		$sql .= "VALUES($1,$2,$3,$4,$5,$6,$7)";
		$v = array(
			$gui_id,
			$myWMS,
			$position,
			$this->gui_wms_mapformat,
			$this->gui_wms_featureinfoformat,
			$this->gui_wms_exceptionformat,
			$this->gui_wms_epsg
		);
		$t = array('s','i','i','s','s','s','s');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
			return null;
		}
		db_commit();

		//
		// update GeoRSS feed
		//
		$geoRssFactory = new GeoRssFactory();
		$geoRss = $geoRssFactory->loadOrCreate(GEO_RSS_FILE);
		if (!is_null($geoRss)) {
			$geoRssItem = new GeoRssItem();
			$geoRssItem->setTitle("NEW WMS: " . $this->wms_title." (".$myWMS.")");
			$geoRssItem->setDescription($this->wms_abstract);
			$geoRssItem->setUrl(self::getWmsMetadataUrl($myWMS));
			$geoRssItem->setPubDate(self::rssDate());

			for ($j = 0; $j < count($this->objLayer[0]->layer_epsg); $j++) {
				$currentEpsg = $this->objLayer[0]->layer_epsg[$j];
				if ($currentEpsg["epsg"] === "EPSG:4326") {
					$currentBbox = new Mapbender_bbox(
						$currentEpsg["minx"],
						$currentEpsg["miny"],
						$currentEpsg["maxx"],
						$currentEpsg["maxy"],
						$currentEpsg["epsg"]
					);
					$geoRssItem->setBbox($currentBbox);
					break;
				}
			}
			//for debugging: 
			//print_r($geoRss);
			//die();
			$geoRss->appendTop($geoRssItem);
			$geoRss->saveAsFile();
		}
	    
	    //Changes JW
	    $this->wms_id = $myWMS;
	}
	function insertLayer($i,$myWMS){
		global $con;
		$uuid = new Uuid();
		$sql = <<<SQL

INSERT INTO layer 
(fkey_wms_id, layer_pos, layer_parent, layer_name, layer_title, 
layer_queryable, layer_minscale, layer_maxscale, layer_dataurl,
layer_metadataurl, layer_searchable, layer_abstract, uuid) 
VALUES
($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)

SQL;
		if($this->objLayer[$i]->layer_id != null){
			$tmpPos =  $this->objLayer[$i]->layer_id;
		}
		else {
			$tmpPos .= 0;
		}
		if($this->objLayer[$i]->layer_parent == '' && $this->objLayer[$i]->layer_parent != '0'){
			$this->objLayer[$i]->layer_parent = '';
		}
		$v = array($myWMS,$tmpPos,$this->objLayer[$i]->layer_parent,$this->objLayer[$i]->layer_name,
				$this->objLayer[$i]->layer_title,
				$this->objLayer[$i]->layer_queryable,$this->objLayer[$i]->layer_minscale,
				$this->objLayer[$i]->layer_maxscale,$this->objLayer[$i]->layer_dataurl[0]->href,
				$this->objLayer[$i]->layer_metadataurl[0]->href, $this->objLayer[$i]->layer_searchable,
				$this->objLayer[$i]->layer_abstract,
				$uuid);
		$t = array('i','i','s','s','s','i','i','i','s','s','i','s','s');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		else {
			# save the id of each layer: set param2 true		
			$this->objLayer[$i]->db_id = db_insert_id($con, 'layer','layer_id');
			$this->insertLayerEPSG($i);
			
			# TABLE layer_style for each layer
			$this->insertLayerStyle($i);
			
			# insert Keywords
			$this->insertLayerKeyword($i);	
	
			# insert dataurls
			#$this->insertLayerDataUrls($i);TODO: in the spec 1.3.0 the schema defines a 1:n relation, but in the table there is only one link possible - maybe we need only this one link
			# insert metadataurls
			$this->insertLayerMetadataUrls($i);
		}
	}
	function updateLayer($i,$myWMS){
		$sql = "SELECT layer_id FROM layer WHERE fkey_wms_id = $1 AND layer_name = $2";
		$v = array($myWMS,$this->objLayer[$i]->layer_name);
		$t = array('i','s');
		$res = db_prep_query($sql,$v,$t);
		if($row = db_fetch_array($res)){
			$l_id = $row['layer_id'];	
		}
		else{
			db_rollback();
			$e = new mb_exception("Not found: ".$this->objLayer[$i]->layer_name);
			return;	
		}	
		
		$sql = "UPDATE layer SET ";
		$sql .= "layer_pos = $1, ";
		$sql .= "layer_parent = $2, ";
		$sql .= "layer_title = $3, ";
		$sql .= "layer_queryable = $4, ";
		$sql .= "layer_minscale = $5, ";
		$sql .= "layer_maxscale = $6, ";
		$sql .= "layer_dataurl = $7, ";
		$sql .= "layer_metadataurl = $8, ";
		$sql .= "layer_searchable = $9, ";
		$sql .= "layer_abstract = $10 ";
		$sql .= "WHERE layer_id = $11";
		
		if($this->objLayer[$i]->layer_id != null){
			$tmpPos =  $this->objLayer[$i]->layer_id;
		}
		else {
			$tmpPos .= 0;
		}
		if($this->objLayer[$i]->layer_parent == '' && $this->objLayer[$i]->layer_parent != '0'){
			$this->objLayer[$i]->layer_parent = '';
		}
		$v = array($tmpPos,$this->objLayer[$i]->layer_parent,
				$this->objLayer[$i]->layer_title,
				$this->objLayer[$i]->layer_queryable,$this->objLayer[$i]->layer_minscale,
				$this->objLayer[$i]->layer_maxscale,$this->objLayer[$i]->layer_dataurl[0]->href,
				$this->objLayer[$i]->layer_metadataurl[0]->href, $this->objLayer[$i]->layer_searchable,
				$this->objLayer[$i]->layer_abstract, $l_id		
			);
		$t = array('i','s','s','i','i','i','s','s','i', 's','i');
		$e = new mb_notice("class_wms.php: update layer sql:".$sql);
		$e = new mb_notice("class_wms.php: layerid: ".$l_id." layersearchable: ".$this->objLayer[$i]->layer_searchable);
		$res = db_prep_query($sql,$v,$t);
		if($this->overwrite == true){
			$sql = "UPDATE layer SET ";
			$sql .= "layer_title = $1, ";
			$sql .= "layer_abstract = $2 ";
			$sql .= "WHERE layer_id = $3";
			
			$v = array($this->objLayer[$i]->layer_title,$this->objLayer[$i]->layer_abstract, $l_id);
			$t = array('s','s','i');
			$res = db_prep_query($sql,$v,$t);
		}
		if(!$res){
			db_rollback();	
		}
		else {
			
			# save the id of each layer: set param2 true
			$this->objLayer[$i]->db_id = $l_id;
			$this->insertLayerEPSG($i);
			$this->insertLayerMetadataUrls($i);
			# TABLE layer_style for each layer
			$this->insertLayerStyle($i);
			if($this->overwrite == true){
				$this->insertLayerKeyword($i);
				$this->insertLayerCategories($i);
			}
		}
	}
	function insertGuiLayer($i,$myWMS,$gui_id){
		# table gui_layer
		
		$sql = "INSERT INTO gui_layer (fkey_gui_id, fkey_layer_id, gui_layer_wms_id, ";
		$sql .= "gui_layer_status, gui_layer_selectable, gui_layer_visible, gui_layer_queryable, ";
		$sql .= "gui_layer_querylayer,gui_layer_minscale,gui_layer_maxscale, gui_layer_priority, gui_layer_style, gui_layer_title) ";
		$sql .= "VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)";
		if(count($this->objLayer[$i]->layer_style)>0){
			$layer_style_name = $this->objLayer[$i]->layer_style[0]["name"];
		}
		else{
			$layer_style_name = NULL;
		}
		$v = array($gui_id,$this->objLayer[$i]->db_id,$myWMS,1,1,1,$this->objLayer[$i]->layer_queryable,
			$this->objLayer[$i]->layer_queryable,$this->objLayer[$i]->layer_minscale,$this->objLayer[$i]->layer_maxscale,$i,$layer_style_name,$this->objLayer[$i]->gui_layer_title);
		$t = array('s','i','i','i','i','i','i','i','i','i','i','s', 's');
		$res = db_prep_query($sql,$v,$t);
		#$e = new mb_exception("name des insert styles und fkey_layer_id: ".$layer_style_name." --- ".$this->objLayer[$i]->db_id);
		if(!$res){
			db_rollback();	
		}	
	}
	function appendGuiLayer($i,$myWMS,$gui_id){
		# table gui_layer
		
		$sql = "INSERT INTO gui_layer (fkey_gui_id, fkey_layer_id, gui_layer_wms_id, ";
		$sql .= "gui_layer_status, gui_layer_selectable, gui_layer_visible, gui_layer_queryable, ";
		$sql .= "gui_layer_querylayer,gui_layer_minscale,gui_layer_maxscale, gui_layer_priority, gui_layer_style, gui_layer_title) ";
		$sql .= "VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)";
		if(count($this->objLayer[$i]->layer_style)>0){
			$layer_style_name = $this->objLayer[$i]->layer_style[0]["name"];
		}
		else{
			$layer_style_name = NULL;
		}
		$v = array($gui_id,$this->objLayer[$i]->db_id,$myWMS,0,0,0,$this->objLayer[$i]->layer_queryable,
			$this->objLayer[$i]->layer_queryable,$this->objLayer[$i]->layer_minscale,$this->objLayer[$i]->layer_maxscale,$i,$layer_style_name, $this->objLayer[$i]->gui_layer_title);
		$t = array('s','i','i','i','i','i','i','i','i','i','i','s', 's');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}	
	}
	function insertSRS($myWMS){
		for($i=0; $i<count($this->wms_srs);$i++){
			$sql ="INSERT INTO wms_srs (fkey_wms_id, wms_srs) values($1,$2)";		
			$v = array($myWMS,mb_strtoupper($this->wms_srs[$i]));
			$t = array('i','s');		
			$res = db_prep_query($sql,$v,$t);
			if(!$res){
				db_rollback();	
			}
		}	
	}
	function insertTermsOfUse ($myWMS) {
		if (!is_numeric($this->wms_termsofuse)) {
			return;
		}
		$sql ="INSERT INTO wms_termsofuse (fkey_wms_id, fkey_termsofuse_id) ";
		$sql .= " VALUES($1,$2)";
		$v = array($myWMS,$this->wms_termsofuse);
		$t = array('i','i');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		
	}
	function insertFormat($myWMS){
		for($i=0; $i<count($this->data_type);$i++){
			$sql ="INSERT INTO wms_format (fkey_wms_id, data_type, data_format) ";
			$sql .= " VALUES($1,$2,$3)";
			$v = array($myWMS,$this->data_type[$i],$this->data_format[$i]);
			$t = array('i','s','s');
			$res = db_prep_query($sql,$v,$t);
			if(!$res){
				db_rollback();	
			}
		}	
	}
	function isSupportedSRS($epsg,$layerId) {
		//request the original capabilities from service
        $sql = "SELECT layer.layer_name AS layer_name, wms.wms_getcapabilities_doc AS cap from layer,wms WHERE layer.layer_id=".$layerId." AND layer.fkey_wms_id=wms.wms_id";
        $res = db_query($sql);
        $row = db_fetch_array($res);
		//parse capabilities to php object - check if it is still loaded to db
		if ($row['cap'] == '') {
			$wmsCapXml=simplexml_load_string($this->wms_getcapabilities_doc);	
		}
		else {
			$wmsCapXml=simplexml_load_string($row['cap']);
		}
		
		if(!isset($wmsCapXml)) {
			$n = new mb_exception("Problem while parsing capabilities document with simplexml");
			echo "Problem while parsing capabilities document with simplexml<br>";
			return false;
       }
		
		//layer name from DB
		$layerName=$row['layer_name'];
		//defining the xpath for getting all Layer-tags
		$xpathLayerName="//Layer[./Name =\"".$layerName."\"]";
		
        $layerObject=$wmsCapXml->xpath($xpathLayerName);

        //for none named layer (only title is set)	
        if (empty($layerObject)){
        	$xpathLayerName="//Layer[./Title =\"".$layerName."\"]";
            $layerObject=$wmsCapXml->xpath($xpathLayerName);
        }

		if(!isset($layerObject[0])) {
			$n = new mb_notice("Layer has no name and title, BBOX will not be generated for ".$epsg);
			return false;	
		}
		
		//search for the SRS tag of specified layer		
		$srsElementArray=$layerObject[0]->xpath("SRS");
		foreach($srsElementArray as $srsElement) {
			//create an array of the given srsElements -> include also srs written as a space separated list  
			$srsArray = explode(" ",$srsElement);
			foreach($srsArray as $srs) {
				if(strtoupper($srs) == strtoupper($epsg)) {
					$n = new mb_notice("Requested SRS: ".$epsg." is supported by layer: ".$layerName." with layerId: ".$layerId);
					return true;
				}
			}
		}
		
		$n = new mb_notice("Requested SRS: ".$epsg." is not supported by layer: ".$layerName." with layerId: ".$layerId);
		return false;
	}
	//get all supported srs as an intersection of the supported srs of the root layer and the SRS_ARRAY defined in mapbender.conf  
	function getSupportedSRS($layerId, $confSrsArray) {
		//request the original capabilities from service
        $sql = "SELECT layer.layer_name AS layer_name, wms.wms_getcapabilities_doc AS cap FROM layer, wms ".
        		"WHERE layer.fkey_wms_id IN (SELECT layer.fkey_wms_id FROM layer WHERE layer.layer_id = " . $layerId . ") ".
        		"AND layer.layer_parent = '' AND layer.fkey_wms_id=wms.wms_id";
        $res = db_query($sql);
        $row = db_fetch_array($res);
        
		//parse capabilities to php object - check if it is still loaded to db
		if ($row['cap'] == '') {
			$wmsCapXml=simplexml_load_string($this->wms_getcapabilities_doc);	
		}
		else {
			$wmsCapXml=simplexml_load_string($row['cap']);
		}
		
		if(!isset($wmsCapXml)) {
			$n = new mb_exception("Problem while parsing capabilities document with simplexml");
			echo "Problem while parsing capabilities document with simplexml<br>";
			return false;
       }
		
       //layer name from DB
		$layerName=$row['layer_name'];
		//defining the xpath for getting all Layer-tags
		$xpathLayerName="//Layer[./Name =\"".$layerName."\"]";
		
		$layerObject=$wmsCapXml->xpath($xpathLayerName);
		
		//for none named layer (only title is set)
                if (empty($layerObject)){
                        $xpathLayerName="//Layer[./Title =\"".$layerName."\"]";
                    $layerObject=$wmsCapXml->xpath($xpathLayerName);
                }

		if(!isset($layerObject[0])) {
			$n = new mb_notice("Layer has no name and title, BBOX will not be generated for ".$epsg);
			return false;
		}
		
		$supportedSrsArray = array();
		
		//search for the SRS tag of specified layer		
		$srsElementArray=$layerObject[0]->xpath("SRS");
		
		foreach($srsElementArray as $srsElement) {
			//create an array of the given srsElements -> include also srs written as a space separated list  
			$srsArray = explode(" ",$srsElement);
			foreach($srsArray as $srs) {
				if(in_array(strtoupper($srs),$confSrsArray)) {
					array_push($supportedSrsArray, strtoupper($srs));
					$n = new mb_notice("Requested SRS: ".$epsg." is supported by layer: ".$layerName." with layerId: ".$layerId);
				}	
			}
		}
		
		if(count($supportedSrsArray) == 0) {
			$n = new mb_notice("Requested SRS: ".$epsg." is not supported by layer: ".$layerName." with layerId: ".$layerId);
		}
		
		return $supportedSrsArray;
	}
	function insertLayerEPSG($i) {
		$sql = "DELETE FROM layer_epsg WHERE fkey_layer_id = $1";
		$v = array($this->objLayer[$i]->db_id);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		for($j=0; $j<count($this->objLayer[$i]->layer_epsg);$j++){
			$sql = "INSERT INTO layer_epsg (fkey_layer_id, epsg, minx, miny, maxx, maxy) ";
			$sql .= "VALUES($1,$2,$3,$4,$5,$6)";
			$v = array($this->objLayer[$i]->db_id,$this->objLayer[$i]->layer_epsg[$j][epsg],
				$this->objLayer[$i]->layer_epsg[$j][minx],$this->objLayer[$i]->layer_epsg[$j][miny],
				$this->objLayer[$i]->layer_epsg[$j][maxx],$this->objLayer[$i]->layer_epsg[$j][maxy]
				); 
			$t = array('i','s','d','d','d','d');
			$res = db_prep_query($sql,$v,$t);
			if(!$res){
				db_rollback();	
			}
		}
		
//		GET SRS_ARRAY of mapbender.conf
		if(SRS_ARRAY != "") {
			$confSrsArray = split(",",SRS_ARRAY);
			foreach($confSrsArray as &$srs) {
				$srs = trim($srs);
			}
		}
		for ($index = 0; $index < sizeof($confSrsArray); $index++) {
			$confSrsArray[$index] = "EPSG:" . $confSrsArray[$index];
		}
		
		$sql_epsg = "SELECT * FROM layer_epsg WHERE fkey_layer_id = $1";
		$v_epsg = array($this->objLayer[$i]->db_id);
		$t_epsg = array('i');
		$res_epsg = db_prep_query($sql_epsg,$v_epsg,$t_epsg);
		$epsg = array();
		$minx = array();
		$miny = array();
		$maxx = array();
		$maxy = array();
		$cnt = 0;
		while($row_epsg = db_fetch_array($res_epsg)){
			array_push($epsg,strtoupper($row_epsg['epsg']));
			array_push($minx,$row_epsg['minx']);
			array_push($miny,$row_epsg['miny']);
			array_push($maxx,$row_epsg['maxx']);
			array_push($maxy,$row_epsg['maxy']);
			$cnt++;
		}

		//get all srs which are supported by the parent layer and in array SRS_ARRAY from mapbender.conf
		$supportedSrs = $this->getSupportedSRS($this->objLayer[$i]->db_id, $confSrsArray);
		
		for($k=0; $k < count($supportedSrs);$k++) {
			if(!in_array($supportedSrs[$k],$epsg) && $supportedSrs[$k] != '') {
				$n = new mb_notice("Calculation for: ".$supportedSrs[$k]);
				$pointMin = new Mapbender_point($minx[0], $miny[0], $epsg[0]);
				$pointMax = new Mapbender_point($maxx[0], $maxy[0], $epsg[0]);
				$pointMin->transform($supportedSrs[$k]);	
				$pointMax->transform($supportedSrs[$k]);
				
				if($pointMin->epsg != '' && $pointMin->x != '' && $pointMin->y != '' 
					&& $pointMax->x != '' && $pointMax->y != '') {
					$sql_bbox = "INSERT INTO layer_epsg (fkey_layer_id, epsg, minx, miny, maxx, maxy) ";
					$sql_bbox .= "VALUES($1,$2,$3,$4,$5,$6)";
					$v_bbox = array($this->objLayer[$i]->db_id,$pointMin->epsg,$pointMin->x,
									$pointMin->y,$pointMax->x,$pointMax->y); 
					$t_bbox = array('i','s','d','d','d','d');
					$res_bbox = db_prep_query($sql_bbox,$v_bbox,$t_bbox);
					$n = new mb_notice("Calculation for: ".$supportedSrs[$k]." finished successful.");
				}
				else {
					$e = new mb_exception("Could not transform ".strtoupper($epsg[0])." to ".$supportedSrs[$k].".");
				}
			}
		}
	}
	function insertLayerStyle($i){
		$sql = "DELETE FROM layer_style WHERE fkey_layer_id = $1";
		$v = array($this->objLayer[$i]->db_id);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		for($j=0; $j<count($this->objLayer[$i]->layer_style);$j++){
			$sql = "INSERT INTO layer_style (fkey_layer_id, name, title, legendurl, legendurlformat) ";
			$sql .= "VALUES($1,$2,$3,$4,$5)";
			$v = array($this->objLayer[$i]->db_id,$this->objLayer[$i]->layer_style[$j]["name"],
					$this->objLayer[$i]->layer_style[$j]["title"],$this->objLayer[$i]->layer_style[$j]["legendurl"],
					$this->objLayer[$i]->layer_style[$j]["legendurlformat"]				
				);
			$t = array('i','s','s','s','s');
			$res = db_prep_query($sql,$v,$t);
			if(!$res){
				db_rollback();	
			}
		}
	}
	
	function insertLayerCategories($i){
		global $con;

		$types = array("md_topic", "inspire", "custom");
		foreach ($types as $cat) {
			$sql = "DELETE FROM layer_{$cat}_category WHERE fkey_layer_id = $1";
			$v = array($this->objLayer[$i]->db_id);
			$t = array('i');
			$res = db_prep_query($sql,$v,$t);
			$attr = "layer_{$cat}_category_id";
			$k = $this->objLayer[$i]->$attr;
			for ($j = 0; $j < count($k); $j++) {
				$sql = "INSERT INTO layer_{$cat}_category (fkey_layer_id, fkey_{$cat}_category_id) VALUES ($1, $2)";
				$v = array($this->objLayer[$i]->db_id, $k[$j]);
				$t = array('i', 'i');
				if (isset($k[$j])) {
					$res = db_prep_query($sql,$v,$t);
					if(!$res){
						db_rollback();	
						return;
					}
				} else {
					$e = new mb_notice("class_wms: cat: ".$attr." was not set!");				
				}
			}
		}
	}	
	
	function insertLayerKeyword($i){
		global $con;
		$sql = "DELETE FROM layer_keyword WHERE fkey_layer_id = $1";
		$v = array($this->objLayer[$i]->db_id);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		
//		var_dump($this);
		$k = $this->objLayer[$i]->layer_keyword;
//		var_dump($k);
		for($j=0; $j<count($k); $j++){
			$keyword_id = "";
			
			while ($keyword_id == "") {
				$sql = "SELECT keyword_id FROM keyword WHERE UPPER(keyword) = UPPER($1)";
				$v = array($k[$j]);
				$t = array('s');
				$res = db_prep_query($sql,$v,$t);
				$row = db_fetch_array($res);
			//print_r($row);
				if ($row) {
					$keyword_id = $row["keyword_id"];	
				}
				else {
					$sql_insertKeyword = "INSERT INTO keyword (keyword)";
					$sql_insertKeyword .= "VALUES ($1)";
					$v1 = array($k[$j]);
					$t1 = array('s');
					$res_insertKeyword = db_prep_query($sql_insertKeyword,$v1,$t1);
					if(!$res_insertKeyword){
						db_rollback();	
					}
				}
			}

			// check if layer/keyword combination already exists
			$sql_layerKeywordExists = "SELECT * FROM layer_keyword WHERE fkey_layer_id = $1 AND fkey_keyword_id = $2";
			$v = array($this->objLayer[$i]->db_id, $keyword_id);
			$t = array('i', 'i');
			$res_layerKeywordExists = db_prep_query($sql_layerKeywordExists, $v, $t);
			$row = db_fetch_array($res_layerKeywordExists);
			//print_r($row);
			if (!$row) {
				$sql1 = "INSERT INTO layer_keyword (fkey_keyword_id,fkey_layer_id)";
				$sql1 .= "VALUES ($1,$2)";
				$v1 = array($keyword_id,$this->objLayer[$i]->db_id);
				$t1 = array('i','i');
				$res1 = db_prep_query($sql1,$v1,$t1);
				if(!$res1){
					db_rollback();	
				}
			}
		}
	}
	function insertLayerMetadataUrls($i){
		//first delete the old ones - but only those who have been harvested thru caps before!
		global $con;
		$sql = "DELETE FROM mb_metadata WHERE metadata_id IN (SELECT metadata_id FROM mb_metadata INNER JOIN";
		$sql .= " (SELECT * from ows_relation_metadata WHERE fkey_layer_id = $1) as relation ON ";
		$sql .= " mb_metadata.metadata_id = relation.fkey_metadata_id AND mb_metadata.origin = 'capabilities')";
		$v = array($this->objLayer[$i]->db_id);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		//origin 2 - set by mapbender metadata editor - new record
		//origin 3 - set by mapbender metadata editor - new linkage
		//harvest the record if some readable format is given - should this be adoptable?
		//parse the content if iso19139 is given
		//TODO: generate temporal uuid for inserting and getting the serial afterwards
		for($j=0; $j<count($this->objLayer[$i]->layer_metadataurl);$j++){

			//check for returned format?
			if (($this->objLayer[$i]->layer_metadataurl[$j]->type == 'ISO19115:2003' && $this->objLayer[$i]->layer_metadataurl[$j]->format =='text/xml') || ($this->objLayer[$i]->layer_metadataurl[$j]->type == 'TC211' && $this->objLayer[$i]->layer_metadataurl[$j]->format =='text/xml')) {
				//load metadata from link
				$metadataConnector = new connector($this->objLayer[$i]->layer_metadataurl[$j]->href);
				$metaData = $metadataConnector->file;
				//parse metadata
				try {
					//$iso19139Xml = simplexml_load_string($metaData);
					$iso19139Xml =  new SimpleXMLElement($metaData);
					if ($iso19139Xml == false) {
						throw new Exception('Cannot parse Metadata XML!');
					}
				}
				catch (Exception $e) {
    					$e = new mb_exception($e->getMessage());
				}
				if ($iso19139Xml != false) {
					//get elements for database from xml by using xpath
					//uuid
					$uuid = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString');
					//createdate
					$createdate = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:dateStamp/gco:Date');
					//changedate
					$changedate = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:dateStamp/gco:Date');
					//TODO: check if this is set, maybe DateTime must be searched instead?
					//title
					$title = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString');
					//dataset identifier - howto model into md_metadata?
					//check where datasetid is defined - maybe as RS_Identifier or as MD_Identifier see http://inspire.jrc.ec.europa.eu/documents/Metadata/INSPIRE_MD_IR_and_ISO_v1_2_20100616.pdf page 18
					$code = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:code/gco:CharacterString');
					$codeSpace = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString');
					$e = new mb_exception("class_wms.php: code: ".$code[0]);
					$e = new mb_exception("class_wms.php: codeSpace: ".$codeSpace[0]);
					if (isset($codeSpace[0]) && isset($code[0]) && $codeSpace[0] != '' && $code[0] != '') {
						
						$datasetid = $codeSpace[0]."#".$code[0];
						$e = new mb_exception("class_wms.php: datasetid: ".$datasetid);
					} else {
						
						$datasetid = 'undefined';# in sense of INSPIRE TODO control MD_Identifier too!
						$e = new mb_exception("class_wms.php: datasetid: ".$datasetid);
					}
					//abstract
					$abstract = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString');
					//searchtext -- use keywords!
					$keywords = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString');
					//type 
					$type = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode');
					//tmp_reference_1
					$tmp_reference_1 = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:beginPosition');
					//tmp_reference_2
					$tmp_reference_2 = $iso19139Xml->xpath('/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod/gml:endPosition');			//spatial_res_type
					//spatial_res_value
					//ref_system
					//format
					//inspire_charset
					//inspire_top_consistence
					//responsible_party
					//fees
					//"constraints"	
					//fill database with elements:
					$sql = "INSERT INTO mb_metadata (link, origin, md_format, data, linktype, uuid, title, createdate, changedate, abstract, searchtext, type, tmp_reference_1, tmp_reference_2, export2csw, datasetid) ";
					$sql .= "VALUES($1, 'capabilities', $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)";
					$v = array($this->objLayer[$i]->layer_metadataurl[$j]->href,
						$this->objLayer[$i]->layer_metadataurl[$j]->format,
						$metaData,
						$this->objLayer[$i]->layer_metadataurl[$j]->type,
						$uuid[0],
						$title[0],
						$createdate[0],
						$changedate[0],
						$abstract[0],
						$keywords[0],
						$type[0],
						$tmp_reference_1[0],
						$tmp_reference_2[0],
						't',
						$datasetid
					);
					$t = array('s','s','s','s','s','s','s','s','s','s','s','s','s','b','s');
					$res = db_prep_query($sql,$v,$t);
					if(!$res){
						db_rollback();	
					}
					//get last inserted serial_id
					$mdId = db_insert_id($con, 'mb_metadata','metadata_id');
					//insert into ows_relation_metadata (fkey_layer_id, fkey_metadata_id) values (20131,3);
					$sql = "INSERT INTO ows_relation_metadata (fkey_layer_id, fkey_metadata_id) values ($1, $2);";
					$v = array($this->objLayer[$i]->db_id, $mdId);
					$t = array('i','i');
					$res = db_prep_query($sql,$v,$t);
					if(!$res){
						db_rollback();	
					} else {
						$sql = "UPDATE mb_metadata SET harvestresult = 1 where metadata_id = $1";
						$v = array($mdId);
						$t = array('i');
						$res = db_prep_query($sql,$v,$t);
					}		
				}
			} else {//no readable format given - only store the links!
				//don't push single elements into database
				$sql = "INSERT INTO mb_metadata (link, origin, md_format, linktype) ";
				$sql .= "VALUES($1, 'capabilities', $2, $3)";
				$v = array($this->objLayer[$i]->layer_metadataurl[$j]->href,
					$this->objLayer[$i]->layer_metadataurl[$j]->format,
					$this->objLayer[$i]->layer_metadataurl[$j]->type		
				);
				$t = array('s','s','s');
				$res = db_prep_query($sql,$v,$t);
				if(!$res){
					db_rollback();	
				}
				//get last inserted serial_id
				$mdId = db_insert_id($con, 'mb_metadata','metadata_id');
				//insert into ows_relation_metadata (fkey_layer_id, fkey_metadata_id) values (20131,3);
				$sql = "INSERT INTO ows_relation_metadata (fkey_layer_id, fkey_metadata_id) values ($1, $2);";
				$v = array($this->objLayer[$i]->db_id, $mdId);
				$t = array('i','i');
				$res = db_prep_query($sql,$v,$t);
				if(!$res){
					db_rollback();	
				} else {
					//set harvest result to 0 cause this metadata format can not to be parsed
					$sql = "UPDATE mb_metadata SET harvestresult = 0 where metadata_id = $1";
					$v = array($mdId);
					$t = array('i');
					$res = db_prep_query($sql,$v,$t);
				}
			}
		}
	}
	



	function updateObjInDB($myWMS){
		if (!isset($this->wms_network_access) || ($this->wms_network_access == '')) {
			$this->wms_network_access = intval('0');
		}
		$admin = new administration();
		db_begin();
		
		$sql = "UPDATE wms SET ";
		$sql .= "wms_version = $1 ,";
		$sql .= "wms_getcapabilities  = $2 ,";
		$sql .= "wms_getmap  = $3 ,";
		$sql .= "wms_getfeatureinfo  = $4 ,";
		$sql .= "wms_getlegendurl  = $5 ,";
		$sql .= "wms_getcapabilities_doc = $6 ,";
		$sql .= "wms_upload_url = $7,  ";
		$sql .= "wms_owner = $8, ";
		$sql .= "wms_timestamp = $9, ";
		$sql .= "wms_supportsld = $10, ";
		$sql .= "wms_userlayer = $11, ";
		$sql .= "wms_userstyle = $12, ";
		$sql .= "wms_remotewfs = $13, ";
		$sql .= "wms_network_access = $14, ";
		$sql .= "fkey_mb_group_id = $15, ";
		$sql .= "uuid = $16 ";
		$sql .= " WHERE wms_id = $17";
	
		$v = array($this->wms_version,$this->wms_getcapabilities,
			$this->wms_getmap,$this->wms_getfeatureinfo,$this->wms_getlegendurl,
			$admin->char_encode($this->wms_getcapabilities_doc),$this->wms_upload_url,Mapbender::session()->get("mb_user_id"),strtotime("now"),
			$this->wms_supportsld,$this->wms_userlayer,$this->wms_userstyle,$this->wms_remotewfs,$this->wms_network_access, $this->fkey_mb_group_id ,$this->uuid ,$myWMS);
		$t = array('s','s','s','s','s','s','s','i','i','s','s','s','s','i','i','s','i');
	
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		
		if($this->overwrite == true){
			$sql = "UPDATE wms SET ";
			$sql .= "wms_title  = $1 ,";
			$sql .= "wms_abstract  = $2 ,";
			$sql .= "fees = $3, ";
			$sql .= "accessconstraints = $4, ";
			$sql .= "contactperson = $5, ";
			$sql .= "contactposition = $6, ";
			$sql .= "contactorganization = $7, ";
			$sql .= "address = $8, ";
			$sql .= "city = $9, ";
			$sql .= "stateorprovince = $10, ";
			$sql .= "postcode = $11, ";
			$sql .= "country = $12, ";
			$sql .= "contactvoicetelephone = $13, ";
			$sql .= "contactfacsimiletelephone = $14, ";
			$sql .= "contactelectronicmailaddress = $15, ";
			$sql .= "wms_network_access = $16, ";
			$sql .= "fkey_mb_group_id = $17, ";
			$sql .= "uuid = $18 ";
			$sql .= " WHERE wms_id = $19";
		
			$v = array($this->wms_title,$this->wms_abstract,$this->fees,$this->accessconstraints,
				$this->contactperson,$this->contactposition,$this->contactorganization,$this->address,
				$this->city,$this->stateorprovince,$this->postcode,$this->country,$this->contactvoicetelephone,
				$this->contactfacsimiletelephone,$this->contactelectronicmailaddress,$this->wms_network_access, $this->fkey_mb_group_id ,$this->uuid, $myWMS);
			$t = array('s','s','s','s','s','s','s','s','s','s','s','s','s','s','s','i','i','s','i');
			$res = db_prep_query($sql,$v,$t);
			if(!$res){
				db_rollback();	
			}
		}
		
		# delete and refill wms_termsofuse
		$sql = "DELETE FROM wms_termsofuse WHERE fkey_wms_id = $1 ";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		$this->insertTermsOfUse($myWMS);
		
		# delete and refill srs and formats
		$sql = "DELETE FROM wms_srs WHERE fkey_wms_id = $1 ";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		$this->insertSRS($myWMS);
		
		$sql = "DELETE FROM wms_format WHERE fkey_wms_id = $1 ";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
		$this->insertFormat($myWMS);
		
		# update gui_wms
		$this->update_gui_wms($myWMS);
		
		# update TABLE layer	
		$oldLayerNameArray = array();
		$v = array($myWMS);
		$t = array('i');
		$c = 2;
		$sql = "SELECT layer_id, layer_name, layer_title, layer_abstract FROM layer WHERE fkey_wms_id = $1 AND NOT layer_name IN(";
		for($i=0; $i<count($this->objLayer); $i++){
			if($i>0){$sql .= ',';}
			$sql .= "$".$c;
			array_push($v,$this->objLayer[$i]->layer_name);
			//$e = new mb_exception("class_wms: old layer name added for read: ".$this->objLayer[$i]->layer_name);
			array_push($t,'s');		
			$c++;
		}
		$sql .= ")";
		$res = db_prep_query($sql,$v,$t);
		while ($row = db_fetch_array($res)) {
			$oldLayerNameArray[]= array(
				"id" => $row["layer_id"],
				"name" => $row["layer_name"],
				"title" => $row["layer_title"],
				"abstract" => $row["layer_abstract"]
			);
			
		}
		
		# delete all layer which are outdated
		//first delete their metadataUrl entries*****
		$v = array($myWMS);
		$t = array('i');
		$c = 2;
		$sql = "DELETE FROM mb_metadata WHERE metadata_id IN (SELECT metadata_id FROM mb_metadata INNER JOIN (SELECT * from ows_relation_metadata WHERE fkey_layer_id IN " ;
		$sql .= "(SELECT layer_id FROM layer WHERE fkey_wms_id = $1 AND NOT layer_name IN (";
		for($i=0; $i<count($this->objLayer); $i++){
			if($i>0){$sql .= ',';}
			$sql .= "$".$c;
			array_push($v,$this->objLayer[$i]->layer_name);
			array_push($t,'s');		
			$c++;
		}
		$sql .= ") ) )";
		$sql .= " as relation ON  mb_metadata.metadata_id = relation.fkey_metadata_id AND mb_metadata.origin = 'capabilities')";
		$res = db_prep_query($sql,$v,$t);		
		//*******************************************
		//TODO: is this done for the keywords too? Maybe not, cause they are stored only once! Only the relations have to be deleted!
		//and then the layer entries
		$v = array($myWMS);
		$t = array('i');
		$c = 2;
		$sql = "DELETE FROM layer WHERE fkey_wms_id = $1 AND NOT layer_name IN(";
		for($i=0; $i<count($this->objLayer); $i++){
			if($i>0){$sql .= ',';}
			$sql .= "$".$c;
			array_push($v,$this->objLayer[$i]->layer_name);
			//$e = new mb_exception("class_wms: old layer name added for delete: ".$this->objLayer[$i]->layer_name);
			array_push($t,'s');		
			$c++;
		}
		$sql .= ")";
		
		$res = db_prep_query($sql,$v,$t);
		if(!$res){
			db_rollback();	
		}
			
		# update or insert?
		$sql = "SELECT layer_name FROM layer WHERE fkey_wms_id = $1";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		$exLayer = array();
		while($row = db_fetch_array($res)){
			array_push($exLayer,$row["layer_name"]);
		}
		
		$sql = "SELECT fkey_gui_id FROM gui_wms WHERE fkey_wms_id = $1";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		$exGui = array();
		while($row = db_fetch_array($res)){
			array_push($exGui,$row["fkey_gui_id"]);
		}
		$newLayerArray = array();
		for($i=0; $i<count($this->objLayer); $i++){
			if(in_array($this->objLayer[$i]->layer_name,$exLayer)){
				//echo "<br>update: ".$this->objLayer[$i]->layer_name;
				$this->updateLayer($i,$myWMS);
				for($j=0; $j<count($exGui); $j++){
					$this->updateGuiLayer($i,$myWMS,$exGui[$j]);
				}
			}
			else{
				//echo "<br>append: ".$this->objLayer[$i]->layer_name;
				$this->insertLayer($i,$myWMS);
				$newLayerArray[]= $i;
				for($j=0; $j<count($exGui); $j++){
					$this->appendGuiLayer($i,$myWMS,$exGui[$j]);
				}
			}
		}
		db_commit();
		//
		// update GeoRSS feed
		//
		$geoRssFactory = new GeoRssFactory();
		$geoRss = $geoRssFactory->loadOrCreate(GEO_RSS_FILE);
		
		if (!is_null($geoRss)) {

			$geoRssItem = new GeoRssItem();
			$geoRssItem->setTitle("UPDATED WMS: " . $this->wms_title." (".$myWMS.")");
			$geoRssItem->setDescription($this->wms_abstract);
			$geoRssItem->setUrl(self::getWmsMetadataUrl($myWMS));
			$geoRssItem->setPubDate(self::rssDate());
			for ($j = 0; $j < count($this->objLayer[0]->layer_epsg); $j++) {
				$currentEpsg = $this->objLayer[0]->layer_epsg[$j];
				if ($currentEpsg["epsg"] === "EPSG:4326") {
					$currentBbox = new Mapbender_bbox(
						$currentEpsg["minx"],
						$currentEpsg["miny"],
						$currentEpsg["maxx"],
						$currentEpsg["maxy"],
						$currentEpsg["epsg"]
					);
					$geoRssItem->setBbox($currentBbox);
					break;
				}
			}
			$geoRss->appendTop($geoRssItem);

			foreach ($newLayerArray as $newLayer) {
				$currentLayer = $this->objLayer[$newLayer];
				$geoRssItemNewLayer = new GeoRssItem();
				$geoRssItemNewLayer->setTitle("NEW LAYER: " . $currentLayer->layer_title." (".$currentLayer->layer_id.")");
				$geoRssItemNewLayer->setDescription($currentLayer->layer_abstract);
				$geoRssItemNewLayer->setUrl(self::getLayerMetadataUrl($currentLayer->layer_id));
				$geoRssItemNewLayer->setPubDate(self::rssDate());
				for ($j = 0; $j < count($currentLayer->layer_epsg); $j++) {
					$currentEpsg = $currentLayer->layer_epsg[$j];
					if ($currentEpsg["epsg"] === "EPSG:4326") {
						$currentBbox = new Mapbender_bbox(
							$currentEpsg["minx"],
							$currentEpsg["miny"],
							$currentEpsg["maxx"],
							$currentEpsg["maxy"],
							$currentEpsg["epsg"]
						);
						$geoRssItemNewLayer->setBbox($currentBbox);
						break;
					}
				}
				$geoRss->appendTop($geoRssItemNewLayer);
			}
			foreach ($oldLayerNameArray as $oldLayer) {
				$geoRssItemOldLayer = new GeoRssItem();
				$geoRssItemOldLayer->setTitle("DELETED LAYER: " . $oldLayer['title']." (".$oldLayer['id'].")");
				$geoRssItemOldLayer->setUrl(self::getLayerMetadataUrl($oldLayer['id']));
				$geoRssItemOldLayer->setDescription($oldLayer["abstract"]);
				$geoRssItemOldLayer->setPubDate(self::rssDate());
//				$geoRssItem->setUrl();
				$geoRss->appendTop($geoRssItemOldLayer);
			}
			$geoRss->saveAsFile();
		}
		return;	
	}

	function updateGuiLayer($i,$myWMS,$gui_id){
		$sql = "SELECT layer_id FROM layer WHERE fkey_wms_id = $1 AND layer_name = $2";
		$v = array($myWMS,$this->objLayer[$i]->layer_name);
		$t = array('i','s');
		$res = db_prep_query($sql,$v,$t);
		if($row = db_fetch_array($res)){
			$l_id = $row['layer_id'];	
		}
		else{
			db_rollback();
			$e = new mb_exception("Not found: ".$this->objLayer[$i]->layer_name. " in gui: ".$gui_id);
			return;	
		}
		
		$sql = "SELECT * FROM gui_layer WHERE fkey_layer_id = $1 and fkey_gui_id = $2";
		$v = array($l_id,$gui_id);
		$t = array('i','s');
		$res = db_prep_query($sql,$v,$t);		
		while($row = db_fetch_array($res)){

				$sql1 = "UPDATE gui_layer SET gui_layer_title = $1 ";
				$sql1 .= "WHERE fkey_layer_id = $2 and fkey_gui_id = $3";
				$v = array($this->objLayer[$i]->layer_title, $l_id,$gui_id);
				$t = array('s', 'i','s');
				$res1 = db_prep_query($sql1,$v,$t);
				if(!$res1){
					db_rollback();
				}

			if($this->objLayer[$i]->layer_queryable == 0){
				$sql1 = "UPDATE gui_layer set gui_layer_queryable = 0, gui_layer_querylayer = 0 ";
				$sql1 .= "WHERE fkey_layer_id = $1 and fkey_gui_id = $2";
				$v = array($l_id,$gui_id);
				$t = array('i','s');
				$res1 = db_prep_query($sql1,$v,$t);
				if(!$res1){
					
				db_rollback();
				}
			}
			if($this->objLayer[$i]->layer_queryable == 1){
				$sql1 = "UPDATE gui_layer set gui_layer_queryable = 1 ";
				$sql1 .= "WHERE fkey_layer_id = $1 and fkey_gui_id = $2";
				$v = array($l_id,$gui_id);
				$t = array('i','s');
				$res1 = db_prep_query($sql1,$v,$t);
				if(!$res1){
					
					db_rollback();
				}
			}
			if($row["gui_layer_minscale"] < $this->objLayer[$i]->layer_minscale){
				$sql1 = "UPDATE gui_layer set gui_layer_minscale = $1 ";
				$sql1 .= "WHERE fkey_layer_id = $2 and fkey_gui_id = $3";
				$v = array($this->objLayer[$i]->layer_minscale,$l_id,$gui_id);
				$t = array('i','i','s');
				$res1 = db_prep_query($sql1,$v,$t);
				if(!$res1){db_rollback();
				}
			}
			if($row["gui_layer_maxscale"] > $this->objLayer[$i]->layer_maxscale){
				$sql1 = "UPDATE gui_layer set gui_layer_maxscale = $1 ";
				$sql1 .= "WHERE fkey_layer_id = $2 and fkey_gui_id = $3";
				$v = array($this->objLayer[$i]->layer_maxscale,$l_id,$gui_id);
				$t = array('i','i','s');
				$res1 = db_prep_query($sql1,$v,$t);
				if(!$res1){db_rollback();
				}
			}		
		}
	}
	function update_gui_wms($myWMS){
		$mySubmit = null;
		$sql = "SELECT * FROM gui_wms where fkey_wms_id = $1";
		$v = array($myWMS);
		$t = array('i');
		$res = db_prep_query($sql,$v,$t);
		$cnt = 0;
		while($row = db_fetch_array($res)){	
			unset($mySubmit);
			$myGUI[$cnt] = $row["fkey_gui_id"];

			$sql = "UPDATE gui_wms SET ";
			$v = array();
			$t = array();
			$paramCount = 0;		

			for($i=0; $i<count($this->data_type); $i++){
				# gui_wms_mapformat
				if(mb_strtolower($this->data_type[$i]) == "map" && mb_strtolower($this->data_format[$i]) == mb_strtolower($row["gui_wms_mapformat"])){
					$myMapFormat = true;
				}
				# gui_wms_featureinfoformat
				if(mb_strtolower($this->data_type[$i]) == "featureinfo" && mb_strtolower($this->data_format[$i]) == mb_strtolower($row["gui_wms_featureinfoformat"])){
					$myFeatureInfoFormat = true;
				}
				# gui_wms_exceptionformat
				if(mb_strtolower($this->data_type[$i]) == "exception" && mb_strtolower($this->data_format[$i]) == mb_strtolower($row["gui_wms_exceptionformat"])){
					$myExceptionFormat = true;
				}
			}
			if(!$myMapFormat){
				$paramCount++;
				$sql .= "gui_wms_mapformat = $" . $paramCount . " ";
				$mySubmit = true;
				array_push($v, $this->gui_wms_mapformat);
				array_push($t, "s");
			}
			if(!$myFeatureInfoFormat){
				if($mySubmit){ $sql .= ",";}
				$paramCount++;
				$sql .= "gui_wms_featureinfoformat = $" . $paramCount . " ";
				array_push($v, $this->gui_wms_featureinfoformat);
				array_push($t, "s");
				$mySubmit = true;
			}
			if(!$myExceptionFormat){
				if($mySubmit){ $sql .= ",";}
				$paramCount++;
				$sql .= "gui_wms_exceptionformat = $" . $paramCount ." ";
				array_push($v, $this->gui_wms_exceptionformat);
				array_push($t, "s");
				$mySubmit = true;
			}
				
			# gui_wms_epsg
			for($j=0; $j<count($this->objLayer[0]->layer_epsg);$j++){
				if($this->objLayer[0]->layer_epsg[$j][epsg] == mb_strtoupper($row["gui_wms_epsg"])){
					$myGUI_EPSG = true;
				}
			}
			if(!$myGUI_EPSG){
				if($mySubmit){ $sql .= ",";}
				$paramCount++;
				$sql .= "gui_wms_epsg = $" . $paramCount . " ";
				array_push($v, $this->gui_wms_epsg);
				array_push($t, "s");
				$mySubmit = true;
			}
			$paramCount++;
			$sql .= " WHERE fkey_gui_id = $" . $paramCount . " ";
			array_push($v, $row["fkey_gui_id"]);
			array_push($t, "s");

			$paramCount++;
			$sql .= "AND fkey_wms_id = $" . $paramCount;
			array_push($v, $myWMS);
			array_push($t, "i");
			if($mySubmit){
				$res = db_prep_query($sql,$v,$t);
				if(!$res){
					db_rollback();	
					echo "<pre>".$sql."</pre><br> <br><p>";
				 	echo db_error(); 
				 	echo "<br /> UPDATE ERROR -> KILL PROCESS AND ROLLBACK....................no update<br><br>";
					$e = new mb_exception("class_wms.php: transaction: Transaction aborted, rollback.");
				}
			}
			$cnt++;
		}	
	}
	function getVersion() {
		return $this->wms_version;
	}
	
	function getCapabilities() {
		return $this->wms_getcapabilities;
	}
	
	function getCapabilitiesDoc() {
		return $this->wms_getcapabilities_doc;
	}

	/**
	* creatObjfromDB
	*
	*/ 
	  function createObjFromDB($gui_id,$wms_id){
	
		$sql = "Select * from gui_wms where fkey_wms_id = $1 AND fkey_gui_id = $2";
		$v = array($wms_id,$gui_id);
		$t = array('i','s');
		$res = db_prep_query($sql,$v,$t);
		
		$count=0;
		#$res_count=db_num_rows($res);
	    
	
		while($row = db_fetch_array($res)){
			$this->gui_wms_mapformat=$row["gui_wms_mapformat"];
			$this->gui_wms_featureinfoformat=$row["gui_wms_featureinfoformat"];
			$this->gui_wms_exceptionformat=$row["gui_wms_exceptionformat"];
			$this->gui_wms_epsg=$row["gui_wms_epsg"];
			$this->gui_wms_visible = $row["gui_wms_visible"];
			$this->gui_wms_opacity = $row["gui_wms_opacity"];
			$this->gui_wms_sldurl = $row["gui_wms_sldurl"];
	  
			$sql = "Select * from wms where wms_id = $1 ";
			$v = array($wms_id);
			$t = array('i');
			$res_wms = db_prep_query($sql,$v,$t);
			$count_wms=0;
			while($row2 = db_fetch_array($res_wms)){
				$this->wms_id = $row2["wms_id"];
				$this->wms_version = $row2["wms_version"];
				$this->wms_title = administration::convertIncomingString($this->stripEndlineAndCarriageReturn($row2["wms_title"]));
				$this->wms_abstract = administration::convertIncomingString($this->stripEndlineAndCarriageReturn($row2["wms_abstract"]));
				$wmsowsproxy = $row2["wms_owsproxy"];
				#$wmsowsproxy = "test";
				if($wmsowsproxy != ""){
					$owsproxyurl = OWSPROXY."/".session_id()."/".$wmsowsproxy."?";
					$this->wms_getmap = $owsproxyurl;
					$this->wms_getcapabilities =  $owsproxyurl;
					$this->wms_getfeatureinfo = $owsproxyurl;
					$this->wms_getlegendurl = $owsproxyurl;
				}
				else{
					$this->wms_getmap =  $row2["wms_getmap"];
					$this->wms_getcapabilities =  $row2["wms_getcapabilities"];
					$this->wms_getfeatureinfo = $row2["wms_getfeatureinfo"];
					$this->wms_getlegendurl = $row2["wms_getlegendurl"];
				}			
				// TO DO: Capabilities document needs to 
				// be encoded to the original encoding
				// if different from the database encoding
				$this->wms_getcapabilities_doc = $row2["wms_getcapabilities_doc"];
				$this->wms_filter = $row2["wms_filter"];
				$this->wms_supportsld = $row2["wms_supportsld"];
				$this->wms_userlayer = $row2["wms_userlayer"];
				$this->wms_userstyle = $row2["wms_userstyle"];
				$this->wms_remotewfs = $row2["wms_remotewfs"];
				$this->wms_timestamp_create = $row2["wms_timestamp_create"];
				$this->fees = $row2["fees"];
				$this->accessconstraints = $row2["accessconstraints"];
				$this->contactperson = $row2["contactperson"];
				$this->contactposition = $row2["contactposition"];
				$this->contactvoicetelephone = $row2["contactvoicetelephone"];
				$this->contactfacsimiletelephone = $row2["contactfacsimiletelephone"];
				$this->contactorganization = $row2["contactorganization"];
				$this->address = $row2["address"];
				$this->city = $row2["city"];
				$this->stateorprovince = $row2["stateorprovince"];
				$this->postcode = $row2["postcode"];
				$this->country = $row2["country"];
				$this->contactelectronicmailaddress = $row2["contactelectronicmailaddress"];
				
				$count_wms++;
			}
	
			### srs
			$srs_sql = "SELECT * FROM wms_srs WHERE fkey_wms_id = $1 ";
			$srs_v = array($wms_id);
			$srs_t = array('i'); 
			$srs_res = db_prep_query($srs_sql, $srs_v, $srs_t);
			$this->wms_srs = array();
			while($srs_row = db_fetch_array($srs_res)) {		
				$this->wms_srs[]= $srs_row["wms_srs"];
			}

			### formats
			$sql = "SELECT * FROM wms_format WHERE fkey_wms_id = $1 ";
			$v = array($wms_id);
			$t = array('i'); 
			$res_wms = db_prep_query($sql,$v,$t);
			$count_format=0;		
			while($row3 = db_fetch_array($res_wms)){		
				$this->data_type[$count_format] = $row3["data_type"];
				$this->data_format[$count_format] = $row3["data_format"];
				$count_format++;
			}
			$count++;
		}
		
		#layer
		$sql = "Select * from gui_layer JOIN layer ON gui_layer.fkey_layer_id = layer.layer_id where gui_layer_wms_id = $1 AND fkey_gui_id = $2 ";
		$sql .= " AND gui_layer_status = 1 ORDER BY gui_layer_priority, CAST(layer_pos AS numeric);";
		$v = array($wms_id,$gui_id);
		$t = array('i','s');
		$res = db_prep_query($sql,$v,$t);
		$count=0;
		
		while($row = db_fetch_array($res)){
			$layer_id = $row["fkey_layer_id"];		
			$sql = "Select * from layer where layer_id = $1";
			$v = array($layer_id);
			$t = array('i');
			$res_layer = db_prep_query($sql,$v,$t);
			$count_layer=0;
			while($row2 = db_fetch_array($res_layer)){
				$this->addLayer($row2["layer_pos"],$row2["layer_parent"]);
				$layer_cnt=count($this->objLayer)-1;
				$this->objLayer[$layer_cnt]->layer_uid = $layer_id;
				$this->objLayer[$layer_cnt]->layer_name = administration::convertIncomingString($row2["layer_name"]);
				$this->objLayer[$layer_cnt]->layer_title = administration::convertIncomingString($row2["layer_title"]);			
				$this->objLayer[$layer_cnt]->layer_dataurl[0]->href =$row2["layer_dataurl"];
				//load all metadataUrl elements from mb_metadata
				$sql = "SELECT metadata_id, link, linktype, md_format FROM mb_metadata INNER JOIN (SELECT * from ows_relation_metadata WHERE fkey_layer_id = $1) as relation ON  mb_metadata.metadata_id = relation.fkey_metadata_id AND mb_metadata.origin = 'capabilities'";
				$v = array($layer_id);
				$t = array('i');
				$res_metadataUrl = db_prep_query($sql,$v,$t);
				$count_metadataUrl = 0;
				while($row3 = db_fetch_array($res_metadataUrl)){
					$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->href = $row3["link"];
					$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->type = $row3["linktype"];
					$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->format = $row3["md_format"];
					
					$count_metadataUrl++;
				}
				//old one:
				//$this->objLayer[$layer_cnt]->layer_metadataurl[0]->href = $row2["layer_metadataurl"];
				$this->objLayer[$layer_cnt]->layer_searchable =$row2["layer_searchable"];
				$this->objLayer[$layer_cnt]->layer_pos =$row2["layer_pos"];						
				$this->objLayer[$layer_cnt]->layer_queryable =$row2["layer_pos"];
				$this->objLayer[$layer_cnt]->layer_queryable =$row2["layer_queryable"];
				$this->objLayer[$layer_cnt]->layer_minscale =$row2["layer_minscale"];
				$this->objLayer[$layer_cnt]->layer_maxscale = $row2["layer_maxscale"];
				$count_layer++;
			}
			$this->objLayer[$layer_cnt]->layer_uid = $layer_id;
			$this->objLayer[$layer_cnt]->gui_layer_wms_id = $row["gui_layer_wms_id"];
			$this->objLayer[$layer_cnt]->gui_layer_selectable = $row["gui_layer_selectable"];
			$this->objLayer[$layer_cnt]->gui_layer_title = $row["gui_layer_title"] != "" ? $row["gui_layer_title"] : $this->objLayer[$layer_cnt]->layer_title;
			$this->objLayer[$layer_cnt]->gui_layer_visible = $row["gui_layer_visible"];
			$this->objLayer[$layer_cnt]->gui_layer_queryable = $row["gui_layer_queryable"];
			$this->objLayer[$layer_cnt]->gui_layer_querylayer = $row["gui_layer_querylayer"];
			$this->objLayer[$layer_cnt]->gui_layer_minscale = $row["gui_layer_minscale"];
			$this->objLayer[$layer_cnt]->gui_layer_maxscale = $row["gui_layer_maxscale"];
			$this->objLayer[$layer_cnt]->gui_layer_style = $row["gui_layer_style"];
			$this->objLayer[$layer_cnt]->gui_layer_wfs_featuretype = $row["gui_layer_wfs_featuretype"];

			$sql = "Select * from layer_epsg where fkey_layer_id = $1 ORDER BY fkey_layer_id";
			$v = array($layer_id);
			$t = array('i');
			$res_layer_epsg = db_prep_query($sql,$v,$t);
			
			$count_layer_epsg=0;
			while($row2 = db_fetch_array($res_layer_epsg)){
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["epsg"]=$row2["epsg"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["minx"]=$row2["minx"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["miny"]=$row2["miny"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["maxx"]=$row2["maxx"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["maxy"]=$row2["maxy"];
				$count_layer_epsg++;
			}
			
			### handle styles
			$sql = "SELECT * FROM layer_style WHERE fkey_layer_id = $1 ";
			$v = array($layer_id);
			$t = array('i');
			$res_style = db_prep_query($sql,$v,$t);
			$count_layer_style = 0;
			while($row2 = db_fetch_array($res_style)){
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["name"] = $row2["name"] ? $row2["name"] : "default";
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["title"]=$row2["title"];
				if($wmsowsproxy != ""){
					if($row2["legendurl"]!=''){
						$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]=$owsproxyurl.
						"REQUEST=getlegendgraphic&VERSION=".$this->wms_version."&LAYER=".$this->objLayer[$layer_cnt]->layer_name."&FORMAT=".$row2["legendurlformat"].
						"&STYLE=".$row2["name"];
					}
				}
				else{
					if($row2["legendurl"]!=''){
						$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]=$row2["legendurl"];
						#$e = new mb_exception("legendurl = ".$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]);
					}
				}
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurlformat"]=$row2["legendurlformat"];
				$count_layer_style++;
			}
			$count++;
		}
	   }
	/** end createObjfromDB **/
	
	  /**
	* creatObjfromDBNoGui
	*
	*/ 
	//TODO Update while editing metadata of wms will update the metadata - delete entries and read new ones - then they will be visible and cannot be set to inactive!
	  function createObjFromDBNoGui($wms_id, $withProxyUrls = true){
	   	$sql = "Select * from wms where wms_id = $1 ";
		$v = array($wms_id);
		$t = array('i');
		$res_wms = db_prep_query($sql,$v,$t);
		$count_wms=0;
		while($row2 = db_fetch_array($res_wms)){
			$this->wms_id = $row2["wms_id"];
			$this->wms_version = $row2["wms_version"];
			$this->wms_title = administration::convertIncomingString($this->stripEndlineAndCarriageReturn($row2["wms_title"]));
			$this->wms_abstract = administration::convertIncomingString($this->stripEndlineAndCarriageReturn($row2["wms_abstract"]));
			$wmsowsproxy = $row2["wms_owsproxy"];
			#$wmsowsproxy = "test";
			//exchange the method urls with owsproxy urls if needed - default is to do it, but sometimes this is not usefull!
			if($wmsowsproxy != "" && $withProxyUrls){
				$owsproxyurl = OWSPROXY."/".session_id()."/".$wmsowsproxy."?";
				$this->wms_getmap = $owsproxyurl;
				$this->wms_getcapabilities =  $owsproxyurl;
				$this->wms_getfeatureinfo = $owsproxyurl;
				$this->wms_getlegendurl = $owsproxyurl;
			}
			else{
				$this->wms_getmap =  $row2["wms_getmap"];
				$this->wms_getcapabilities =  $row2["wms_getcapabilities"];
				$this->wms_getfeatureinfo = $row2["wms_getfeatureinfo"];
				$this->wms_getlegendurl = $row2["wms_getlegendurl"];
			}			
			// TO DO: Capabilities document needs to 
			// be encoded to the original encoding
			// if different from the database encoding
			$this->wms_getcapabilities_doc = $row2["wms_getcapabilities_doc"];
			$this->wms_upload_url = $row2["wms_upload_url"];
			$this->wms_filter = $row2["wms_filter"];
			$this->wms_supportsld = $row2["wms_supportsld"];
			$this->wms_userlayer = $row2["wms_userlayer"];
			$this->wms_userstyle = $row2["wms_userstyle"];
			$this->wms_remotewfs = $row2["wms_remotewfs"];
			$this->wms_timestamp = $row2["wms_timestamp"];
			$this->wms_timestamp_create = $row2["wms_timestamp_create"];
			$this->fees = $row2["fees"];
			$this->accessconstraints = $row2["accessconstraints"];
			$this->contactperson = $row2["contactperson"];
			$this->contactposition = $row2["contactposition"];
			$this->contactvoicetelephone = $row2["contactvoicetelephone"];
			$this->contactfacsimiletelephone = $row2["contactfacsimiletelephone"];
			$this->contactorganization = $row2["contactorganization"];
			$this->address = $row2["address"];
			$this->city = $row2["city"];
			$this->stateorprovince = $row2["stateorprovince"];
			$this->postcode = $row2["postcode"];
			$this->country = $row2["country"];
			$this->contactelectronicmailaddress = $row2["contactelectronicmailaddress"];
			$this->wms_network_access = $row2["wms_network_access"];
			$this->fkey_mb_group_id = $row2["fkey_mb_group_id"];
			$this->uuid = $row2["uuid"];
			
			#some default
			$this->gui_wms_visible = 1;
			$this->gui_wms_opacity = 100;
			$this->gui_wms_epsg=$row["gui_wms_epsg"];
			$this->gui_wms_sldurl = $row["gui_wms_sldurl"];
			
			if($this->wms_version == "1.0.0"){
                    $this->gui_wms_mapformat = "PNG";
                    $this->gui_wms_featureinfoformat = "MIME";
                    $this->gui_wms_exceptionformat = "INIMAGE";
            }
            /*define defaults for wms-version 1.1.0 and 1.1.1*/
            else{
                    $this->gui_wms_mapformat = "image/png";
                    $this->gui_wms_featureinfoformat = "text/html";
                    $this->gui_wms_exceptionformat = "application/vnd.ogc.se_inimage";
            }
			
			$count_wms++;
		}
	
		### formats
		$sql = "SELECT * FROM wms_format WHERE fkey_wms_id = $1 ";
		$v = array($wms_id);
		$t = array('i'); 
		$res_wms = db_prep_query($sql,$v,$t);
		$count_format=0;		
		while($row3 = db_fetch_array($res_wms)){		
			$this->data_type[$count_format] = $row3["data_type"];
			$this->data_format[$count_format] = $row3["data_format"];
			$count_format++;
		}

			
		$sql = "Select * from layer where fkey_wms_id = $1 ORDER BY layer_pos";
		$v = array($wms_id);
		$t = array('i');
		$res_layer = db_prep_query($sql,$v,$t);
		$count_layer=0;
		while($row2 = db_fetch_array($res_layer)){
			$this->addLayer($row2["layer_pos"],$row2["layer_parent"]);
			$layer_cnt=count($this->objLayer)-1;
			$this->objLayer[$layer_cnt]->layer_uid = $row2["layer_id"];
			$this->objLayer[$layer_cnt]->layer_name = administration::convertIncomingString($row2["layer_name"]);
			$this->objLayer[$layer_cnt]->layer_title = administration::convertIncomingString($row2["layer_title"]);
			$this->objLayer[$layer_cnt]->layer_abstract = administration::convertIncomingString($row2["layer_abstract"]);	
			$this->objLayer[$layer_cnt]->gui_layer_title = $this->objLayer[$layer_cnt]->layer_title;			
			$this->objLayer[$layer_cnt]->layer_dataurl[0]->href =$row2["layer_dataurl"];


			//load all metadataUrl elements from mb_metadata
			$sql = "SELECT metadata_id, link, linktype, md_format FROM mb_metadata INNER JOIN (SELECT * from ows_relation_metadata WHERE fkey_layer_id = $1) as relation ON  mb_metadata.metadata_id = relation.fkey_metadata_id AND mb_metadata.origin = 'capabilities'";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_metadataUrl = db_prep_query($sql,$v,$t);
			$count_metadataUrl = 0;
			while($row4 = db_fetch_array($res_metadataUrl)){
				$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->href = $row4["link"];
				$e = new mb_notice("nogui layer_metadataurl: ".$row4["link"]);
				$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->type = $row4["linktype"];
				$this->objLayer[$layer_cnt]->layer_metadataurl[$count_metadataUrl]->format = $row4["md_format"];
					
				$count_metadataUrl++;
			}
			//old one:
			//$this->objLayer[$layer_cnt]->layer_metadataurl[0]->href = $row2["layer_metadataurl"];
			$this->objLayer[$layer_cnt]->layer_searchable =$row2["layer_searchable"];
			$this->objLayer[$layer_cnt]->layer_pos =$row2["layer_pos"];						
			$this->objLayer[$layer_cnt]->layer_queryable =$row2["layer_queryable"];
			$this->objLayer[$layer_cnt]->layer_minscale =$row2["layer_minscale"];
			$this->objLayer[$layer_cnt]->layer_maxscale = $row2["layer_maxscale"];
			$this->objLayer[$layer_cnt]->uuid = $row2["uuid"];
			
			if($this->objLayer[$layer_cnt]->layer_minscale == ""){
				$this->objLayer[$layer_cnt]->layer_minscale = 0;
			}
			if($this->objLayer[$layer_cnt]->layer_maxscale == ""){
				$this->objLayer[$layer_cnt]->layer_maxscale = 0;
			}
			$this->objLayer[$layer_cnt]->gui_layer_minscale = $this->objLayer[$layer_cnt]->layer_minscale;
			$this->objLayer[$layer_cnt]->gui_layer_maxscale = $this->objLayer[$layer_cnt]->layer_maxscale;
			$this->objLayer[$layer_cnt]->gui_layer_queryable = $this->objLayer[$layer_cnt]->layer_queryable;
			$this->objLayer[$layer_cnt]->gui_layer_wms_id = $this->wms_id;
			
			$sql = "Select * from layer_epsg where fkey_layer_id = $1 ORDER BY fkey_layer_id";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_layer_epsg = db_prep_query($sql,$v,$t);
			
			$count_layer_epsg=0;
			while($row2 = db_fetch_array($res_layer_epsg)){
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["epsg"]=$row2["epsg"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["minx"]=$row2["minx"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["miny"]=$row2["miny"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["maxx"]=$row2["maxx"];
				$this->objLayer[$layer_cnt]->layer_epsg[$count_layer_epsg]["maxy"]=$row2["maxy"];
				$count_layer_epsg++;
			}
			### read out keywords
			$sql = "SELECT keyword FROM keyword, layer_keyword 
WHERE keyword_id = fkey_keyword_id AND fkey_layer_id = $1";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_layer_keywords = db_prep_query($sql,$v,$t);
			
			$count_layer_keywords=0;
			while($row2 = db_fetch_array($res_layer_keywords)){
				$this->objLayer[$layer_cnt]->layer_keyword[$count_layer_keywords]=$row2["keyword"];
				$count_layer_keywords++;
			}
			### read out layer_md_topic_category_id
			$sql = "SELECT fkey_md_topic_category_id FROM layer_md_topic_category WHERE fkey_layer_id =  $1";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_layer_md_topic_category = db_prep_query($sql,$v,$t);
			
			$count_layer_md_topic_category=0;
			while($row2 = db_fetch_array($res_layer_md_topic_category)){
				$this->objLayer[$layer_cnt]->layer_md_topic_category_id[$count_layer_md_topic_category]=$row2["fkey_md_topic_category_id"];
				$count_layer_md_topic_category++;
			}
			### read out layer_inspire_category_id
			$sql = "SELECT fkey_inspire_category_id FROM layer_inspire_category WHERE fkey_layer_id =  $1";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_layer_inspire_category = db_prep_query($sql,$v,$t);
			
			$count_layer_inspire_category=0;
			while($row2 = db_fetch_array($res_layer_inspire_category)){
				$this->objLayer[$layer_cnt]->layer_inspire_category_id[$count_layer_inspire_category]=$row2["fkey_inspire_category_id"];
				$count_layer_inspire_category++;
			}
			### read out layer_custom_category_id
			$sql = "SELECT fkey_custom_category_id FROM layer_custom_category WHERE fkey_layer_id =  $1";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_layer_custom_category = db_prep_query($sql,$v,$t);
			
			$count_layer_custom_category=0;
			while($row2 = db_fetch_array($res_layer_custom_category)){
				$this->objLayer[$layer_cnt]->layer_custom_category_id[$count_layer_custom_category]=$row2["fkey_custom_category_id"];
				$count_layer_custom_category++;
			}
			### handle styles
			$sql = "SELECT * FROM layer_style WHERE fkey_layer_id = $1 ";
			$v = array($this->objLayer[$layer_cnt]->layer_uid);
			$t = array('i');
			$res_style = db_prep_query($sql,$v,$t);
			$count_layer_style = 0;
			while($row2 = db_fetch_array($res_style)){
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["name"]=$row2["name"];
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["title"]=$row2["title"];
				if($wmsowsproxy != ""){
					if($row2["legendurl"]!=''){
						$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]=$owsproxyurl.
						"REQUEST=getlegendgraphic&VERSION=".$this->wms_version."&LAYER=".$this->objLayer[$layer_cnt]->layer_name."&FORMAT=".$row2["legendurlformat"].
						"&STYLE=".$row2["name"];
					}
				}
				else{
					if($row2["legendurl"]!=''){
						$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]=$row2["legendurl"];
						#$e = new mb_exception("legendurl = ".$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurl"]);
					}
				}
				$this->objLayer[$layer_cnt]->layer_style[$count_layer_style]["legendurlformat"]=$row2["legendurlformat"];
				$count_layer_style++;
			}
						
			$count_layer++;
		}
	
   }
	/** end createObjfromDBNoGui **/
	
	  /**
	* function checkObjExistsInDB()
	*
	* this function checks wether the onlineresource already exists in the database.
	*/ 
	function checkObjExistsInDB(){
	
		$sql = "Select * from wms where wms_getcapabilities = $1";
		$v = array($this->wms_getcapabilities);
		$t = array('s');
		$res = db_prep_query($sql,$v,$t);
		$res_count= db_num_rows($res);	  
		$wms_id=0;
		if($res_count>0){
			$count=0;
			while($row = db_fetch_array($res)){
				$wms_id=$row["wms_id"];
				$count++;
			}
		}
		return $wms_id;
	}
	
	function displayDBInformation(){
		echo $this->wms_getcapabilities;
		$sql="Select * from wms where wms_getcapabilities = $1";
		$v = array($this->wms_getcapabilities);
		$t = array('s');
		$res = db_prep_query($sql,$v,$t);
		$count=0;
		while($row = db_fetch_array($res)){
		echo "count: ".$count."<br>";
			$wms_id=$row["wms_id"];
			echo "version: " .$wms_id." <br>";
			echo "title: " .$row["wms_version"]. " <br>";
			echo "abstract: " . $row["wms_title"] . " <br>";
			echo "maprequest: " .$row["wms_abstract"] . " <br>";
			echo "capabilitiesrequest: " . $row["wms_getcapabilities"] . " <br>";
			echo "featureinforequest: " . $row["wms_getmap"]. " <br>";
			echo "gui_wms_mapformat: " . $row["wms_getfeatureinfo"] . " <br>---------<br>";
			$count++;
		}
	   echo "----<br> wms_id: ".$wms_id."<br>";
	   
	   $sql = "Select * from gui_wms where fkey_wms_id = $1";
	   $v = array($wms_id);
	   $t = array('i');
	   echo "sql: ".$sql." <br>---------<br>";
	   $res = db_prep_query($sql,$v,$t);
	   $res_count= db_num_rows($res); 
	   echo "result count: ".$res_count." <br>---------<br>";
	   
	   $count=0;
	   while($row = db_fetch_array($res)){
	    	echo "gui_wms_featureinfoformat: " . $row["gui_wms_featureinfoformat"]." <br>";
	    	echo "gui_wms_exceptionformat: " .  $row["gui_wms_exceptionformat"]. " <br>";
	    	echo "gui_wms_epsg: " .  $row["gui_wms_epsg"]. " <br>";
	      $count++;
	   }
		
	   #db_close($connect);
	}

	function checkObj(){
		if($this->wms_getcapabilities == '' || $this->wms_getmap == '' ){
			echo "<br>Missing parameters: <br>";
			$this->displayWMS();
			print_r($this);
			echo "<br> Data not committed<br>";
			die();
		}
	}
	
	public static function getWmsIdByLayerId ($id) {
		$sql = "SELECT DISTINCT fkey_wms_id FROM layer WHERE layer_id = $1";
		$res = db_prep_query($sql, array($id), array("i"));
		$row = db_fetch_assoc($res);
		if ($row) {
			return $row["fkey_wms_id"];
		}
		return null;
	}
	
	/**
	 * Selects all WMS of the current user from the database.
	 * Then it creates the corresponding WMS object and returns
	 * these objects as an array.
	 * 
	 * @return wms[]
	 * @param $appId String
	 */
	public static function selectMyWmsByApplication ($appId) {
		// check if user is permitted to access the application
		$currentUser = new User(Mapbender::session()->get("mb_user_id"));
		$appArray = $currentUser->getApplicationsByPermission(false);
		if (!in_array($appId, $appArray)) {
			$e = new mb_warning("class_wms.php: selectMyWmsByApplication(): User '" . $currentUser . "' is not allowed to acces application '" . $appId . "'.");
			return array();
		}
		
		// get WMS of this application
		$sql = "SELECT fkey_wms_id FROM gui_wms WHERE " . 
				"fkey_gui_id = $1 ORDER BY gui_wms_position";
		$v = array($appId);
		$t = array('s');
		$res = db_prep_query($sql,$v,$t);
		
		// instantiate PHP objects and store in array
		$wmsArray = array();
		while ($row = db_fetch_array($res)) {
			$currentWms = new wms();
			$currentWms->createObjFromDB($appId, $row["fkey_wms_id"]);
			array_push($wmsArray, $currentWms);
		}
		return $wmsArray;
	}
}
class layer extends wms {	
	var $layer_id;
	var $layer_parent;
	var $layer_name;
	var $layer_title;
	var $layer_abstract;
	var $layer_pos;
	var $layer_queryable;
	var $layer_minscale;
	var $layer_maxscale;
	var $layer_dataurl;
    	var $layer_dataurl_href;
    	var $layer_metadataurl;
	var $layer_searchable;
    	var $layer_keyword = array();
	var $layer_epsg = array();
	var $layer_style = array();
	var $layer_md_topic_category_id = array();
	var $layer_inspire_category_id = array();
	var $layer_custom_category_id = array();
	
	var $gui_layer_wms_id;
	var $gui_layer_status = 1;
	var $gui_layer_selectable = 1;
	var $gui_layer_visible = 0;
	var $gui_layer_queryable = 0;
	var $gui_layer_querylayer = 0;
	var $gui_layer_style = NULL;	
	
	function layer($id,$parent){
		$this->layer_id = $id;
		$this->layer_parent = $parent;	
		//var_dump($this);	
	}

	public function equals ($layer) {
		if (is_numeric($this->layer_uid) && $this->layer_uid === $layer->layer_uid) {
			return true;
		}
		return false;
	}

	public function __toString () {
		$e = new mb_exception("TITLE: " . $this->layer_title);
		return $this->layer_title;
	}
	
	public function getChildren () {
		$children = array();
		$wmsId = wms::getWmsIdByLayerId($this->layer_uid);
		$wmsFactory = new UniversalWmsFactory();
		$wms = $wmsFactory->createFromDb($wmsId);
		if (!is_null($wms)) {
			try {
				$currentLayer = $wms->getLayerById($this->layer_uid);
			}
			catch (Exception $e) {
				return $children;
			}
			for ($i = 0; $i < count($wms->objLayer); $i++) {
				$l = $wms->objLayer[$i];
				if ($l->layer_parent === $currentLayer->layer_pos) {
					// add this layer and add its children recursively
					$children = array_merge($children, array($l), $l->getChildren());
				}
			}
		}
		return $children;
	}
	
	public function getParents () {
		$parents = array();
		$wmsId = wms::getWmsIdByLayerId($this->layer_uid);
		$wmsFactory = new UniversalWmsFactory();
		$wms = $wmsFactory->createFromDb($wmsId);
		if (!is_null($wms)) {
			try {
				$currentLayer = $wms->getLayerById($this->layer_uid);
			}
			catch (Exception $e) {
				return $parents;
			}
			while (!is_null($currentLayer)) {
				$pos = $currentLayer->layer_parent;
				$currentLayer = $wms->getLayerByPos($pos);
				if (!is_null($currentLayer)) {
					$parents[]= $currentLayer;
				}
			}
		}
		return $parents;
	}
}

class AccessDeniedException extends Exception {
	public function errorMessage() {
		//error message
		$errorMsg = 'Error on line ' . $this->getLine() . ' in ' .
			$this->getFile() .
			': You are not allowed to access layer with ID: ' .
			$this->getMessage();
		return $errorMsg;
	}
}
?>
