from urllib.request import urlopen
from xml.etree.ElementTree import parse
import datetime

now = datetime.datetime.now()

now_year = now.year
now_month = now.month
now_day = now.day

u = urlopen('https://gd2.mlb.com/components/game/mlb/year_' + now_year,
            '/month_' + now_month + '/day_' + now_day)
doc = parse(u)
