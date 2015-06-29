<?php
# $Id: ext_featureInfoTunnel.php 2894 2008-08-28 11:45:53Z verenadiewald $
# http://www.mapbender.org/index.php/ext_featureInfoTunnel.php
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
require_once(dirname(__FILE__)."/../php/mb_validateSession.php");
require_once(dirname(__FILE__) . "/../classes/class_stripRequest.php");
require_once(dirname(__FILE__) . "/../classes/class_connector.php");
if ($_GET["url"]) {
	$mr = new stripRequest(urldecode($_GET["url"]));
}
else {
	$mr = new stripRequest($_POST["url"]);
}

$nmr = $mr->encodeGET();
$isOwsproxyRequest = (mb_strpos($nmr,OWSPROXY) === 0);
if($isOwsproxyRequest){
	header("Location: ".$nmr);
}
else{
	$x = new connector($nmr);
	if (empty($x->file)) {
		//close window if featureInfo has no result
		//echo "<body onLoad=\"javascript:window.close()\">";
		echo "";
	} 
	else {
// Uebergabe von MB Nutzername/Passwort fuer ALB-Auskunft - rw.
		$pattern = "/(.*?)(name\s?=\s?[\"|\']usr[\"|\'] \s*value\s?=\s?[\"|\'][a-zA-Z0-9_*]+[\"|\'])(.*?)/";
		$content = $x->file;
		$newString = "\$1 name='usr' value='".$_SESSION['mb_user_name']."'\$3";
		$content = preg_replace($pattern,$newString,$content);
		$pattern2 = "/(.*?)(name\s?=\s?[\"|\']pwd[\"|\'] \s*value\s?=\s?[\"|\'][a-zA-Z0-9_*]+[\"|\'])(.*?)/";
		$newString2 = "\$1 name='pwd' value='".$_SESSION['mb_user_password']."'\$3";
		$content = preg_replace($pattern2,$newString2,$content);

// Abfrage welche Kodierung das MapServer Template ausweist - rw.
	if ((strpos(strtolower($content),'charset=utf-8',1)) > 0) {
	//	echo 'utf-8'.' Pos'.(strpos($content,'charset=UTF-8',1)); 
		echo $content;
	} elseif ((strpos(strtolower($content),'charset=iso-8859-1',1)) > 0) {
	//	echo 'iso-8859-1'.' Pos'.(strpos($content,'charset=ISO-8859-1',1));
 		echo utf8_encode ($content);
	} else {
	   	echo $content;
	}	
    }
}
?>