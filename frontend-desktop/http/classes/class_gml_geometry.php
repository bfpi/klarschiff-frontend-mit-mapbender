<?php
# $Id: class_gml2.php 3099 2008-10-02 15:29:23Z nimix $
# http://www.mapbender.org/index.php/class_gml2.php
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

require_once(dirname(__FILE__)."/../../core/globalSettings.php");
require_once(dirname(__FILE__)."/../classes/class_connector.php");
require_once(dirname(__FILE__)."/../classes/class_json.php");
require_once(dirname(__FILE__)."/../classes/class_gml_feature_collection.php");

abstract class GmlGeometry {

	abstract public function toGml2 ();

	abstract public function toGml3 ();
	
	abstract public function toGeoJSON ();
	
	//abstract public function getBbox ();
	
	public $srs;
	
	public $latLonSrs = array(
		"urn:x-ogc:def:crs:EPSG:4326",
		"urn:x-ogc:def:crs:EPSG:31467"
	);
}
?>