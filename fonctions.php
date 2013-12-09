<?php
function getCommunesSet($nbcom){
	$str_query = '	SELECT 	min(osm_id * -1) osm_id,
							ref_insee
					FROM 	tmp_admin_rel
					WHERE 	ref_insee IS NOT NULL AND
							ref_insee != \'\' AND
							osm_id < 0
					GROUP BY 2
					EXCEPT
					SELECT 	osm_id,ref_insee
					FROM 	admin_8_v1
					ORDER BY 1
					LIMIT '.$nbcom.';';

	$rq = pg_query($GLOBALS['pgc'],$str_query);
	if (!$rq) die;
	$res = pg_fetch_all($rq);
	return $res;
}
?>