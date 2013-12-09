import sys
import datetime
import calendar
import basemap
if sys.argv[1] == 'journum':
	typedate = 'journum'
else:
	typedate = 'moisnum'

f = open('typedate.inc', 'w')
f.write(typedate)
f.close()
#for a in range(2013,2014):
#	for m in range(12,13):
for a in range(2008,2014):
	for m in range(1,13):
		if a == 2008 and (m == 1 or m == 2):
			continue
		if typedate == 'journum':
			cal = calendar.Calendar()
			days = cal.itermonthdays(a, m)
			for j in days:
				if j > 0:
					d = datetime.date(a, m, j)
					print d.strftime('%Y%m%d')
					basemap.basemap(d)
		else:
			d = datetime.date(a, m, 1)
			print d.strftime('%Y%m')
			basemap.basemap(d.strftime('%Y%m'))
		