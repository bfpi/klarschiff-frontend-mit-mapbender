<?php
# $Id: login.php 7138 2010-11-16 14:37:08Z christoph $
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

ob_start();

require_once dirname(__FILE__) . "/../../conf/mapbender.conf";

function auth_user($name,$pw){
  $setEncPw = false;
  $sql = "SELECT * FROM mb_user WHERE mb_user_name = $1 AND mb_user_password = $2";
  $v = array($name,md5($pw));
  $t = array('s','s');
  $res = db_prep_query($sql,$v,$t);
  if($row = db_fetch_array($res)){
    return $row;
  }
  else if(SYS_DBTYPE == 'pgsql' && $setEncPw == true){
    // 	unencrypted pw in postgres without md5-support?
    $sql = "SELECT * FROM mb_user WHERE mb_user_name = $1 AND mb_user_password = $2";
    $v = array($name,$pw);
    $t = array('s','s');
    $resn = db_prep_query($sql,$v,$t);
    if($rown = db_fetch_array($resn)){
      $sqlu = "UPDATE mb_user SET mb_user_password = $1 WHERE mb_user_id = $2";
      $vu = array(md5($pw),$rown["mb_user_id"]);
      $tu = array('s','i');
      $rowu = db_prep_query($sqlu,$vu,$tu);
      return $rown;
    }
  }
}

function redirectToLogin ($name = "") {
  if (isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == "on") {
    header ("Location: https://".$_SERVER['HTTP_HOST'].dirname($_SERVER['SCRIPT_NAME'])."/login.php?name=".$name);
  }
  else {
    header ("Location: http://".$_SERVER['HTTP_HOST'].dirname($_SERVER['SCRIPT_NAME'])."/login.php?name=".$name);
  }
  die;
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<!-- 
Licensing: See the GNU General Public License for more details.
http://www.gnu.org/copyleft/gpl.html
or:
mapbender/licence/ 
-->
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="expires" content="0">
<META http-equiv="Content-Style-Type" content="text/css">
<META http-equiv="Content-Script-Type" content="text/javascript">
<?php
echo '<meta http-equiv="Content-Type" content="text/html; charset='.CHARSET.'">';	
?>
<meta name="keywords" content="Portal,Bürgerbeteiligung,Karte,Probleme,Ideen,Verwaltung" />
<meta name="description" content="Klarschiff: Portal zur Bürgerbeteiligung. Melden Sie via Karte Probleme und Ideen im öffentlichen Raum, die dann von einer kommunalen Verwaltung bearbeitet werden." />
<meta name="author" content="Hansestadt Rostock" />
<title>Klarschiff – Portal zur Bürgerbeteiligung – Frontend</title>
<script type="text/javascript" src="../extensions/jquery-ui-1.8.1.custom/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="../extensions/jquery-ui-1.8.1.custom/js/jquery-ui-1.8.1.custom.min.js"></script>
<script type="text/javascript" src="../extensions/jquery-ui-1.8.1.custom/development-bundle/ui/jquery.ui.tabs.js"></script>
<link rel="stylesheet" type="text/css" href="../extensions/jquery-ui-1.8.1.custom/development-bundle/themes/base/jquery.ui.all.css" />
<link rel="stylesheet" type="text/css" href="../extensions/jquery-ui-1.8.1.custom/development-bundle/themes/base/jquery.ui.tabs.css" />
<?php
$css_folder = "";
echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"login.css\">";
echo "<link rel=\"shortcut icon\" type=\"image/x-icon\" href=\"/favicon.ico\">";
$name = $_REQUEST["name"];
$password = $_REQUEST["password"];


if(!isset($name) || $name == ''){
  echo "<script type='text/javascript'>";
  echo "<!--". chr(13).chr(10);
  echo "function setFocus(){";
  echo "if(document.loginForm){";
  echo "document.loginForm.name.focus();";
  echo "}";
  echo "}";
  echo "// -->". chr(13).chr(10);
  echo "</script>";
}
else{
  echo "<script type='text/javascript'>";
  echo "<!--". chr(13).chr(10);
  echo "function setFocus(){";
  echo "if(document.loginForm){";
  echo "document.loginForm.password.focus();";
  echo "}";
  echo "}";
  echo "// -->". chr(13).chr(10);
  echo "</script>";
}

?>

<script type='text/javascript'>
$(document).ready(function () {
  $(function() {
    $("#guiListTabs").tabs({
      event: 'mouseover'
    });
    //$("a", ".gui_list").button();
    //$("a", ".gui_list").click(function() { return false; });

  });
});
</script>

<?php 

echo "</head>";
echo "<body onload='setFocus()'>";
echo "<div id='head'></div>";
echo "<div id='main'>";
if(!isset($name) || $name == '' || !isset($password) || $password == ''){
  echo "<form name='loginForm' action ='login.php' method='POST'>"; # per ant gesetzte Zeile, "login.php.path" 
  echo "<div class='content'>Das gewählte Angebot verwendet <span class='bold'>Cookies</span> und ist nicht nutzbar, wenn deren Annahme und Speicherung deaktiviert ist. Um das Angebot nutzen zu können, <span class='bold'>aktivieren</span> Sie bitte die Annahme und Speicherung von Cookies in Ihrem Browser. Rufen Sie anschließend die ursprünglich gewählte Seite (<span class='italic'>nicht</span> die vorliegende Seite) erneut auf. Die Anmeldungsmaske unten besitzt für Sie übrigens keine Relevanz.</div>";
  echo "<br/>";
  echo "<div class='headline'>Anmeldung</div>";
  echo "<div class='content' style='margin-top:10px;font-size:80%'>";
  echo "<div class='subheadline'>Benutzername</div>";
  echo "<input title='Eingabefeld für Benutzername' type='text' name='name' class='login_text' value='" . htmlentities($name, ENT_QUOTES, "UTF-8") . "' style='margin-top:5px;font-family:Verdana;font-size:100%;width:201px;height:22px'><br/>";
  echo "</div>";
  echo "<div class='content' style='margin-top:10px;font-size:80%'>";
  echo "<div class='subheadline'>Passwort</div>";
  echo "<input title='Eingabefeld für Passwort' type='password' name='password' class='login_text' style='margin-top:5px;font-family:Verdana;font-size:100%;width:201px;height:22px'><br/>";
  echo "</div>";
  echo "<div class='content' style='margin-top:15px;font-size:80%'>";
  echo "<input type='submit' class='myButton' value='anmelden' title='bei Frontend-Administrationsportal anmelden' style='font-family:Verdana;font-size:100%;width:200px;height:22px;cursor:pointer'>";
  echo "</div>";
  echo "</form>";
}
if(isset($name) && $name != '' && isset($password) && $password != ''){
  require_once dirname(__FILE__)."/../../core/system.php";

  $sql_count = "SELECT mb_user_login_count FROM mb_user WHERE mb_user_name = $1";
  $params = array($name);
  $types = array('s');
  $res_count = db_prep_query($sql_count,$params,$types);
  if($row = db_fetch_array($res_count)){
    if($row["mb_user_login_count"] > MAXLOGIN){
      echo "Permission denied. Login failed ".MAXLOGIN." times. Your account has been deactivated. Please contact your administrator!";
      die;
    }
  }

  require_once dirname(__FILE__)."/../../lib/class_Mapbender.php";
  require_once dirname(__FILE__)."/../../lib/class_Mapbender_session.php";
  $row = auth_user($name, $password);

  // if given user data is found in database, set session data (db_fetch_array returns false if no row is found)
  if($row){
    require_once dirname(__FILE__) . "/../../core/globalSettings.php";
    # These lines will create a new session if a user logs in who is not the owner 
    # of the session. However, in Geoportal-RLP this is intended, 
    #
    #		if (Mapbender::session()->get("mb_user_id") !== false && $row["mb_user_id"] !== Mapbender::session()->get("mb_user_id")) {
    #			session_write_close();
    #			session_id(sha1(mt_rand()));
    #			session_start();
    #		}
    include(dirname(__FILE__) . "/../../conf/session.conf");
  }
  else {
    redirectToLogin($name);
  }
  if(Mapbender::session()->get("mb_user_id")){
    if($row["mb_user_login_count"] <= MAXLOGIN){
      $sql_del_cnt =  "UPDATE mb_user SET mb_user_login_count = 0 WHERE mb_user_id = $1";
      $v = array(Mapbender::session()->get('mb_user_id'));
      $t = array("i");
      db_prep_query($sql_del_cnt, $v, $t);
      require_once(dirname(__FILE__)."/../php/mb_getGUIs.php");
      $arrayGUIs = mb_getGUIs($row["mb_user_id"]);
      new mb_notice("login.setSession.mb_user_guis: ".serialize($arrayGUIs)." in session: " .session_id());
      Mapbender::session()->set("mb_user_guis",$arrayGUIs);
      Mapbender::session()->set("mb_login",$login);
      # a gui is explicitly ordered
      if((isset($_REQUEST["mb_user_myGui"]) || Mapbender::session()->get("mb_user_myGui")) && in_array($_REQUEST["mb_user_myGui"], $arrayGUIs)){
        unset($arrayGUIs);
        if(isset($_REQUEST["mb_user_myGui"])){ $arrayGUIs[0] = $_REQUEST["mb_user_myGui"];}
        else{ $arrayGUIs[0] = Mapbender::session()->set("mb_user_myGui");}
      }
      #only one gui is provided
      if(count($arrayGUIs) == 1){
        if (isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] == "on") {
          $myURL = "Location: https://".$_SERVER['HTTP_HOST'].dirname($_SERVER['SCRIPT_NAME'])."/index.php?".strip_tags (SID)."&gui_id=".$arrayGUIs[0];
        }
        else {
          $myURL = "Location: http://".$_SERVER['HTTP_HOST'].dirname($_SERVER['SCRIPT_NAME'])."/index.php?".strip_tags (SID)."&gui_id=".$arrayGUIs[0];
        }
        # remove name and password from url, because url params are parsed later and written in javascript
        $cleanUrl = preg_replace("/name=[^&]*&/","",$_SERVER["QUERY_STRING"]);
        $cleanUrl = preg_replace("/password=[^&]*&/","",$cleanUrl);

        $myURL .= "&".$cleanUrl;

        header ($myURL);
        die;
      }
      # list all guis of this user and his groups
      else{	   
        require_once(dirname(__FILE__)."/../php/mb_listGUIs.php");
        mb_listGUIs($arrayGUIs);
      }
    }
  }
  else{
    Mapbender::session()->kill();
    $sql_set_cnt = "UPDATE mb_user SET mb_user_login_count = (mb_user_login_count + 1) WHERE mb_user_name = $1";
    $v = array($name);
    $t = array('s');
    db_prep_query($sql_set_cnt,$v,$t);				
    redirectToLogin($name);
  }
}
?>
</div>
</body>
</html>
