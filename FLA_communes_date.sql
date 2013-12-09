DROP TABLE IF EXISTS communes_guyane_metro CASCADE;
CREATE TABLE communes_guyane_metro
AS
SELECT ST_TransScale (geometrie,54,180,0.25,0.25)::geometry(MultiPolygon,4326) geometrie,
	insee_com,
	nom_comm,
	code_dept
FROM	communes_geofla2013_guyane;

DROP TABLE IF EXISTS communes_guadeloupe_metro CASCADE;
CREATE TABLE communes_guadeloupe_metro
AS
SELECT ST_TransScale (geometrie,57,30,1,1)::geometry(MultiPolygon,4326) geometrie,
	insee_com,
	nom_comm,
	code_dept
FROM	communes_geofla2013_guadeloupe;

DROP TABLE IF EXISTS communes_martinique_metro CASCADE;
CREATE TABLE communes_martinique_metro
AS
SELECT ST_TransScale (geometrie,56.5,30,1,1)::geometry(MultiPolygon,4326) geometrie,
	insee_com,
	nom_comm,
	code_dept
FROM	communes_geofla2013_martinique;

DROP TABLE IF EXISTS communes_reunion_metro CASCADE;
CREATE TABLE communes_reunion_metro
AS
SELECT ST_TransScale (geometrie,-58.3,65.7,1,1)::geometry(MultiPolygon,4326) geometrie,
	insee_com,
	nom_comm,
	code_dept
FROM	communes_geofla2013_reunion;

DROP TABLE IF EXISTS fla_communes_date CASCADE;
CREATE TABLE fla_communes_date
AS
SELECT ST_Transform(c.geometrie,2154)::geometry(MultiPolygon,2154) geometrie,
	c.insee_com,
	c.nom_comm,
	code_dept,
	(substr(a.v1_timestamp,1,4)||substr(a.v1_timestamp,6,2))::integer moisnum,
	(substr(a.v1_timestamp,1,4)||substr(a.v1_timestamp,6,2)||substr(a.v1_timestamp,9,2))::integer journum,
	substr(a.v1_timestamp,1,10)::date - '2008-02-01'::date dateinc
FROM (SELECT geometrie,insee_com,nom_comm,substr(insee_com,1,3) code_dept FROM communes_guyane_metro
	UNION ALL
	SELECT geometrie,insee_com,nom_comm,code_dept FROM communes_geofla2013
	UNION ALL
	SELECT geometrie,insee_com,nom_comm,substr(insee_com,1,3) FROM communes_martinique_metro
	UNION ALL
	SELECT geometrie,insee_com,nom_comm,substr(insee_com,1,3) FROM communes_guadeloupe_metro
	UNION ALL
	SELECT geometrie,insee_com,nom_comm,substr(insee_com,1,3) FROM communes_reunion_metro) c	
LEFT OUTER JOIN	admin_8_v1 a
ON c.insee_com = a.ref_insee;

-- fond
DROP TABLE IF EXISTS fond_france_2154 CASCADE;
CREATE TABLE fond_france_2154
WITH (OIDS=TRUE)
AS
SELECT ST_Multi(ST_Union(geometrie))::geometry(MultiPolygon,2154) geometrie,
	code_dept
FROM	fla_communes_date
WHERE	code_dept like '97_'
GROUP BY code_dept
UNION
SELECT ST_Transform(ST_SetSRID(c.geometrie,4326),2154)::geometry(MultiPolygon,2154) geometrie,
	c.code_dept
FROM	departements_geofla2012 c;

-- contours de departements avec date des 100%
DROP TABLE IF EXISTS fla_dept_date CASCADE;
CREATE TABLE fla_dept_date
WITH (OIDS=TRUE)
AS
SELECT 	d.*,
		journum_debut,
		dateinc_debut,
		journum_100pct,
		dateinc_100pct
FROM 	fond_france_2154 d
LEFT OUTER JOIN	(SELECT 	f.code_dept,max(journum) journum_100pct,max(dateinc) dateinc_100pct
		FROM	fla_communes_date f
		LEFT OUTER JOIN (SELECT code_dept FROM fla_communes_date WHERE journum IS NULL) n
		ON f.code_dept = n.code_dept
		WHERE n.code_dept IS NULL
		GROUP BY 1) j
ON d.code_dept = j.code_dept
JOIN	(SELECT 	f.code_dept,min(journum) journum_debut,min(dateinc) dateinc_debut
		FROM	fla_communes_date f
		GROUP BY 1) j1
ON d.code_dept = j1.code_dept;

-- contributeurs
-- select v1_user_name,min(osm_id) from admin_8_v1 group by 1 order by 2