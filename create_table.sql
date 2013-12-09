DROP TABLE IF EXISTS admin_8_v1 CASCADE;
CREATE TABLE admin_8_v1
(
	osm_id integer,
	v1_timestamp character varying,
	v1_user_id integer,
	v1_user_name character varying,
	v1_changeset integer,
	ref_insee character varying)
WITH (
	OIDS=TRUE
);

DROP TABLE IF EXISTS tmp_admin_rel CASCADE;
CREATE TABLE tmp_admin_rel
(
	osm_id integer,
	ref_insee character varying
)
WITH (
	OIDS=FALSE
);