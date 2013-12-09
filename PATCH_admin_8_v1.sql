-- redacted
update admin_8_v1 set v1_timestamp = '2009-02-15T11:40:16Z' where osm_id = 77988 and v1_timestamp = '-1'
update admin_8_v1 set v1_timestamp = '2009-02-15T13:15:16Z' where osm_id = 78000 and v1_timestamp = '-1'
update admin_8_v1 set v1_timestamp = '2009-02-15T13:16:16Z' where osm_id = 78001 and v1_timestamp = '-1'
update admin_8_v1 set v1_timestamp = '2009-02-18T11:16:16Z' where osm_id = 79041 and v1_timestamp = '-1'

-- Paris
DELETE FROM communes_geofla2013
WHERE insee_com = '75056';
INSERT INTO communes_geofla2013 (insee_com,nom_comm,geometrie)
SELECT '75056','PARIS',ST_Multi(ST_Union(geometrie))::geometry(MultiPolygon,4326)
FROM communes_geofla2013
WHERE code_dept = '75'
GROUP BY code_dept;

-- Lyon
DELETE FROM communes_geofla2013
WHERE insee_com = '69123';
INSERT INTO communes_geofla2013 (insee_com,nom_comm,geometrie)
SELECT '69123','LYON',ST_Multi(ST_Union(geometrie))::geometry(MultiPolygon,4326)
FROM communes_geofla2013
WHERE insee_com like '69%' AND nom_comm like 'LYON%'
GROUP BY 1;

-- Marseille
DELETE FROM communes_geofla2013
WHERE insee_com = '13055';
INSERT INTO communes_geofla2013 (insee_com,nom_comm,geometrie)
SELECT '13055','MARSEILLE',ST_Multi(ST_Union(geometrie))::geometry(MultiPolygon,4326)
FROM communes_geofla2013
WHERE insee_com like '13%' AND nom_comm like 'MARSEIL%'
GROUP BY 1;


