<?php
# $Id: mod_filteredUser_filteredGui.php 7230 2010-12-11 15:27:45Z christoph $
# http://www.mapbender.org/index.php/Administration
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

$e_id="filteredUser_filteredGui";
require_once(dirname(__FILE__)."/../php/mb_validatePermission.php");

/*  
 * @security_patch irv done 
 */
//security_patch_log(__FILE__,__LINE__); 
$filter1 = $_POST["filter1"];
$selected_user = $_POST["selected_user"];
$selected_gui = $_POST["selected_gui"];
$insert = $_POST["insert"];
$remove = $_POST["remove"];
$remove_gui = $_POST["remove_gui"];
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<?php
echo '<meta http-equiv="Content-Type" content="text/html; charset='.CHARSET.'">';	
?>
<title>Administration</title>
<?php
include '../include/dyn_css.php';
?>
<script language="JavaScript">
function validate(wert){
	if(document.forms[0]["selected_user"].selectedIndex == -1){
		document.getElementsByName("selected_user")[0].style.backgroundColor = '#ff0000';
		return;
	}else{
		if(wert == "remove"){
			if(document.forms[0]["remove_gui[]"].selectedIndex == -1){
				document.getElementsByName("remove_gui[]")[0].style.background = '#ff0000';
				return;
			}
			document.form1.remove.value = 'true';
			document.form1.submit();
		}
		if(wert == "insert"){
			if(document.forms[0]["selected_gui[]"].selectedIndex == -1){
				document.getElementsByName("selected_gui[]")[0].style.background = '#ff0000';
				return;
			}
			document.form1.insert.value = 'true';
			document.form1.submit();
		}
	}
}
/**
 * filter the Userlist by str
 */
function filterUser(list, all, str){
	str=str.toLowerCase();
	var selection=[];
	var i,j,selected;
	for(i=0;i<list.options.length;i++){
		if(list.options[i].selected)
			selection[selection.length]=list.options[i].value;
	}
	
	list.options.length = 0;
	for(i=0; i<all.length; i++){
		if(all[i]['name'].toLowerCase().indexOf(str)==-1)
			continue;
		selected=false;
		for(j=0;j<selection.length;j++){
			if(selection[j]==all[i]['id']){
				selected=true;
				break;
			}
		}
		var newOption = new Option(selected?all[i]['name']+" ("+all[i]['email']+")":all[i]['name'],all[i]['id'],false,selected);
		newOption.setAttribute("title", all[i]['email']);
		list.options[list.options.length] = newOption;
	}	
}
/**
 * add Mail adress on selection
 */
function updateMail(list, all){
	var j=0;
	for(var i=0; i<list.options.length;i++){
		if(list.options[i].selected){
			for(j=j;j<all.length;j++){
				if(all[j]['id']==list.options[i].value){
					list.options[i].text=all[j]['name']+" ("+all[j]['email']+")";
					list.options[i].selected = true;
					break;
				}
			}
		}
		else{
			for(j=j;j<all.length;j++){
				if(all[j]['id']==list.options[i].value){
					list.options[i].text=all[j]['name'];
					list.options[i].selected = false;
					break;
				}
			}
		}
	}
}
</script>

</head>
<body>
<?php

require_once(dirname(__FILE__)."/../php/mb_getGUIs.php");

$fieldHeight = 20;

$cnt_gui = 0;
$cnt_user = 0;
$cnt_group = 0;
$cnt_gui_user = 0;
$cnt_gui_group = 0;
$exists = false;
$cnt_gui_user = 0;
$cnt_gui_logged_user = 0;
$gui_id_array = array();

$logged_user_name = Mapbender::session()->get("mb_user_name");
$logged_user_id = Mapbender::session()->get("mb_user_id");

/*handle remove, update and insert*****************************************************************/
if($insert){
	if(count($selected_gui)>0){
		for($i=0; $i<count($selected_gui); $i++){
			$exists = false;
			$sql_insert = "SELECT * from gui_mb_user where fkey_mb_user_id = $1 and fkey_gui_id = $2";
			$v = array($selected_user,$selected_gui[$i]);
			$t = array('i','s');
			$res_insert = db_prep_query($sql_insert,$v,$t);
			while(db_fetch_row($res_insert)){$exists = true;}
			if($exists == false){
				$sql_insert = "INSERT INTO gui_mb_user(fkey_mb_user_id, fkey_gui_id) VALUES($1, $2)";
				$v = array($selected_user,$selected_gui[$i]);
				$t = array('i','s');
				$res_insert = db_prep_query($sql_insert,$v,$t);
			}
		}
	}
}
if($remove){
	if(count($remove_gui)>0){
		for($i=0; $i<count($remove_gui); $i++){
			$sql_remove = "DELETE FROM gui_mb_user WHERE fkey_gui_id = $1 and fkey_mb_user_id = $2";
			$v = array($remove_gui[$i],$selected_user);
			$t = array('s','i');
			db_prep_query($sql_remove,$v,$t);
		}
	}
}



/*get owner user **********************************************************************************/
$sql_user = "SELECT * FROM mb_user WHERE mb_user_owner = $1 ORDER BY mb_user_name";
$v = array($logged_user_id);
$t = array('i');
$res_user = db_prep_query($sql_user,$v,$t);
while($row = db_fetch_array($res_user)){
	$user_id[$cnt_user] = $row["mb_user_id"];
	$user_name[$cnt_user] = $row["mb_user_name"];
	$user_email[$cnt_user] = $row["mb_user_email"];
	$cnt_user++;
}



/*get allocated gui  ******************************************************************************/

$arrayGuis=mb_getGUIs($logged_user_id);
$v = array();
$t = array();
$sql_gui = "SELECT * FROM gui WHERE gui_id IN (";

for($i=0; $i<count($arrayGuis); $i++){
	if($i>0){ $sql_gui .= ",";}
	$sql_gui .= "$".($i + 1);
	array_push($v,$arrayGuis[$i]);
	array_push($t,'s');
}
$sql_gui.= ") ORDER BY gui_name";

$res_gui = db_prep_query($sql_gui,$v,$t);
while($row = db_fetch_array($res_gui)){
	$gui_id_array[$cnt_gui] = $row["gui_id"];
	$gui_name[$cnt_gui] = $row["gui_name"];
	$cnt_gui++;
}

/*get allocated gui from logged_user***************************************************************/

$sql_logged_user_mb_gui = "SELECT gui.gui_id, gui.gui_name, gui_mb_user.fkey_mb_user_id FROM gui_mb_user ";
$sql_logged_user_mb_gui .= "INNER JOIN gui ON gui_mb_user.fkey_gui_id = gui.gui_id ";
$sql_logged_user_mb_gui .= "WHERE gui_mb_user.fkey_mb_user_id = $1";
$sql_logged_user_mb_gui .= " ORDER BY gui.gui_name";
$v = array($logged_user_id);
$t = array('i');
$res_logged_user_mb_all_gui = db_prep_query($sql_logged_user_mb_gui,$v,$t);
while($row = db_fetch_array($res_logged_user_mb_all_gui)){
	$gui_id_logged_user[$cnt_gui_logged_user] = $row["gui_id"];
	$gui_name_logged_user[$cnt_gui_logged_user] =  $row["gui_name"];
	$cnt_gui_logged_user++;
}

/*get allocated gui from selected_user*************************************************************/
$arrayGuis=mb_getGUIs($logged_user_id);
$v = array();
$t = array();
if(count($user_id)>0){
	$sql_user_mb_gui = "SELECT gui.gui_id, gui.gui_name, gui_mb_user.fkey_mb_user_id FROM gui_mb_user ";
	$sql_user_mb_gui .= "INNER JOIN gui ON gui_mb_user.fkey_gui_id = gui.gui_id ";
	$sql_user_mb_gui .= "WHERE gui_mb_user.fkey_mb_user_id = $1 ";
	if(!$selected_user){array_push($v,$user_id[0]);}
	if($selected_user){array_push($v,$selected_user);}
	array_push($t,'i');
	$sql_user_mb_gui .= " AND gui.gui_id IN(";
	$c = 2;
	for($i=0; $i<count($arrayGuis); $i++){
		if($i>0){ $sql_user_mb_gui .= ",";}
		$sql_user_mb_gui .= "$".$c;
	 	array_push($v,$arrayGuis[$i]);
	 	array_push($t,'s');
		$c++;
	}
	$sql_user_mb_gui .= ") ORDER BY gui.gui_name";
	
	$res_user_mb_gui = db_prep_query($sql_user_mb_gui,$v,$t);
	while($row = db_fetch_array($res_user_mb_gui)){
		$gui_id_user[$cnt_gui_user] = $row["gui_id"];
		$gui_name_user[$cnt_gui_user] =  $row["gui_name"];
		$cnt_gui_user++;
	}

/*INSERT HTML*/
echo "<form name='form1' action='" . $self ."' method='post'>";


/*filterbox****************************************************************************************/
echo "<input type='text' value='' class='filter1' id='filter1' name='filter1' onkeyup='filterUser(document.getElementById(\"selecteduser\"),user,this.value);'/>";
/*insert all user in selectbox*************************************************************************************/
echo "<div class='text1'>USER: </div>";
echo "<select style='background:#ffffff' onchange='updateMail(this, user);submit();' class='select1' id='selecteduser' name='selected_user' size='10'>";
for($i=0; $i<$cnt_user; $i++){
	echo "<option value='" . $user_id[$i] . "' title='".$user_email[$i]."' ";
	if($selected_user && $selected_user == $user_id[$i]){
		echo "selected>".$user_name[$i]." (".$user_email[$i].")";
	}
	else
		echo ">" . $user_name[$i];
	echo "</option>";
}
echo "</select>";

/*insert allocated gui in selectbox****************************************************************/
echo "<div class='text2'>GUI: </div>";
echo "<select style='background:#ffffff' class='select2' multiple='multiple' name='selected_gui[]' size='$fieldHeight' >";
for($i=0; $i<$cnt_gui; $i++){
   echo "<option value='" . $gui_id_array[$i]  . "'>" . $gui_name[$i]  . "</option>";
}
echo "</select>";
/*Button*******************************************************************************************/
echo "<div class='button1' ><input type='button'  value='==>' onClick='validate(\"insert\")'></div>";
echo "<input type='hidden' name='insert'>";
echo "<div class='button2'><input type='button' value='<==' onClick='validate(\"remove\")'></div>";
echo "<input type='hidden' name='remove'>";

/*insert user_gui_dependence in selectbox**********************************************************/
echo "<div class='text3'>SELECTED GUI:</div>";
echo "<select style='background:#ffffff' class='select3' multiple='multiple' name='remove_gui[]' size='$fieldHeight' >";
for($i=0; $i<$cnt_gui_user; $i++){
   echo "<option value='" . $gui_id_user[$i]  . "'>" . $gui_name_user[$i]  . "</option>";
}
echo "</select>";
echo "</form>";

}else{
	echo "This user doesn't own other guis or other users.";
}

?>


<script type="text/javascript">
<!--
document.forms[0].selected_user.focus();
var user=[];
<?php
for($i=0; $i<$cnt_user; $i++){
	echo "user[".$i."]=[];\n";
	echo "user[".$i."]['id']='" . $user_id[$i]  . "';\n";
	echo "user[".$i."]['name']='" . $user_name[$i]  . "';\n";
	echo "user[".$i."]['email']='" . $user_email[$i]  . "';\n";
}
?>
// -->
</script>
</body>
</html>