<?php
// récupération depuis osm.org et mise en cache des 
// XMLs de la version 1 de chaque relation administrative
// appui sur une liste des IDs de relations stockée dans une base PG
// source pour cette liste : tmp_admin_rel.csv

// connexion PG
// positionne une variable 'pgc' en retour de la fonction PHP pg_connect()
include 'connexion.php';

include 'fonctions.php';

$paquet = 2000;
$a_relation_id = getCommunesSet($paquet);
$paquet = count($a_relation_id);

$root_saved_files = 'c:\\gps\\animfla\\xml_v1\\';
$compteur = 0;
foreach ($a_relation_id as $r){
	$save_dir = $root_saved_files.substr($r['osm_id'],-2).'\\';
	if (!is_dir($save_dir)) mkdir($save_dir);
	$old_save_file = $root_saved_files.$r['osm_id'].'.xml';
	$save_file = $save_dir.$r['osm_id'].'.xml';
	print_r($r['osm_id']."\n");

	if (!file_exists($save_file)){
		$url = 'http://www.openstreetmap.org/api/0.6/relation/'.$r['osm_id'].'/1';

		$ch = curl_init();
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	
		$res = curl_exec($ch);
		curl_close($ch);
		sleep (1);

		$handle = fopen($save_file,'w');
		fwrite($handle,$res);
		fclose($handle);
	} else {
		$res = file_get_contents($save_file);
	}
	if (strlen($res) > 0){
		$x = new SimpleXMLElement($res);
		$user = (string) $x->relation[0]['user'];
		$uid = (string) $x->relation[0]['uid'];
		$timestamp = (string) $x->relation[0]['timestamp'];
		$changeset = (string) $x->relation[0]['changeset'];
	} else {
		$user = '#redacted#';
		$uid = -1;
		$timestamp = -1;
		$changeset = -1;
	}
	$str_query = "INSERT INTO admin_8_v1 VALUES(".$r['osm_id']
												.",'"
												.$timestamp
												."',"
												.$uid
												.",'"
												.pg_escape_string($user)
												."',"
												.$changeset
												.",'"
												.$r['ref_insee']
												."');";
	print_r('.');
	$rq = pg_query($GLOBALS['pgc'],$str_query);
	
	$compteur += 1;
	print_r($compteur .'/'.$paquet."\n");
}

?>