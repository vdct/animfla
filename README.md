animfla
=======

Différents outils utilisés pour concevoir la vidéo : https://vimeo.com/80974060

- Disposer d'une base PostGIS, de php, python, et mapnik
- Télécharger les fonds GeoFLA Communes et Départements sur le site de l'IGN (Metro + DOMs)
- Charger ces fonds en les stockant sans projection : shp2pgsql_geofla.txt
- Créér dans la base PostgreSQL les tables requises : create_table.sql
- Charger le contenu de la table tmp_admin_rel à partir des sources : tmp_admin_rel.csv
- jouer le script de chargement des données sur les v1 des relations. Pas d'appel à l'API d'osm.org si le répertoire xml_v1 est présent
- jouer le script PATCH_admin_8_v1.sql pour renseigner la date des relations sans v1, et créer les entités Paris, Lyon, Marseille dans le GeoFLA
- jouer le script FLA_communes_date.sql pour fabriquer les couches de communes et depts avec translation des DOMs et calcul des dates de début et fin pour chaque dept., le tout en Lambert 93
- jouer la génération des images (une par jour) à l'aide de mapnik, piloté par python : 
	script loop_map.py pour parcourir les dates
		à chaque date, appel de basemap.py qui demande à mapnik la fabrication d'un png à l'aide de la config animfla.xml (créer au préalable un ss répertoire 'png')
- le fichier animfla référence un fichier de connexion PostgreSQL 'db.inc' à compléter