import psycopg
from psycopg.rows import dict_row
import os
import re
from config import *
import csv

def getQuery(file): 
	fullpath = os.path.join(sqlPath, file + '.sql')
	query = open(fullpath, 'r')
	return query.read()

def writeCSV(file, query):
	with open(file, 'w', newline='\n') as csvFile:
		columns = list(dict.keys(query[0]))
		writer = csv.DictWriter(csvFile, fieldnames=columns)
		writer.writeheader()
		for row in query:
			writer.writerow(row)

def sql(file, params):
	with psycopg.connect(f"dbname={db} user={user} password={password} host={host}", row_factory=dict_row) as conn:
		with conn.cursor() as cur:
			cur.execute(getQuery(file), params)
			query = cur.fetchall()		
			cur.close()
			return query
