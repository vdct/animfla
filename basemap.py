def basemap(dateval):
	import sys
	import datetime
	import mapnik
	d0 = datetime.date(2008,2,1)
	f = open('dateinc.inc', 'w')
	ddif = dateval - d0
	f.write(str(ddif.days))
	f.close()
	f = open('texte_date.inc', 'w')
	td = datetime.date.today()
	if ((dateval - td).days > 0):
		f.write(td.strftime('\'%Y-%m-%d\''))
	else:
		f.write(dateval.strftime('\'%Y-%m-%d\''))
	f.close()	
#	bbox = mapnik.Envelope(mapnik.Coord(80000,6000000), mapnik.Coord(1250000,7150000))
#	proportions 4x3
	xmin = -49000
	xmax = 1391000
	ymin = 6040000
	ymax = 7120000
#	proportions 16x9
	xmin = -289000
	xmax = 1631000
	ymin = 6040000
	ymax = 7120000
	e = open('extent.inc', 'w')
	e.write(str(xmin) + ',' + str(ymin) +',' + str(xmax) + ',' + str(ymax))
	e.close()
	bbox = mapnik.Envelope(mapnik.Coord(xmin,ymin), mapnik.Coord(xmax,ymax))
	mapfile = "animfla.xml"
#	m = mapnik.Map(640, 480)
#	m = mapnik.Map(800, 600)
	m = mapnik.Map(1280, 720)
#	m = mapnik.Map(960, 540)
	mapnik.load_map(m, mapfile)
	m.zoom_to_box(bbox) 
	mapnik.render_to_file(m, 'png\\'+dateval.strftime('%Y%m%d')+'.png', 'png')

	