#!/usr/bin/env python

import sqlite3 as sql
import sys
import argparse


if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	subparsers = parser.add_subparsers(dest='command', help='commands')

	list_parser = subparsers.add_parser('list', help='List software options')
	list_parser.add_argument('--filter', '-f', action='store', dest='filter_string', required=False, help='optional filter for output')

	search_parser = subparsers.add_parser('search', help='Search software for exploits')
	search_parser.add_argument('--software', '-s', action='store', dest='software_string', required=True, help='Name of software from list command')
	search_parser.add_argument('--connection', '-c', action='store', dest='connection_string', choices=('local','remote','both'), default='both', required=False, help='connection type of exploit')
	
	args = parser.parse_args()
	
	con = None
	
	try:
		con = sql.connect('sfocus.db')
		con.text_factory = str
		cur = con.cursor()
		
		
		if args.command == "list":
			if args.filter_string != None:
				cur.execute('select distinct info from vulnerable_yes where info like "%' + args.filter_string + '%" and info not like "-%" and info not like "+%" order by info asc')
			else:
				cur.execute('select distinct info from vulnerable_yes where info not like "-%" and info not like "+%" order by info asc')
			rows = cur.fetchall()
			for row in rows:
				print row[0]
		elif args.command == "search":
			if args.connection_string == "both":
				cur.execute('select vulnerable_yes.bid, vulnerable_yes.info, exploits.class, exploits.remote, exploits.local, exploit_files.info from vulnerable_yes INNER JOIN exploits on vulnerable_yes.bid = exploits.bid INNER JOIN exploit_files on vulnerable_yes.bid = exploit_files.bid where vulnerable_yes.info = "' + args.software_string + '" and vulnerable_yes.info not like "-%" and vulnerable_yes.info not like "+%" order by vulnerable_yes.bid desc')
			elif args.connection_string == "remote":
				cur.execute('select vulnerable_yes.bid, vulnerable_yes.info, exploits.class, exploits.remote, exploits.local, exploit_files.info from vulnerable_yes INNER JOIN exploits on vulnerable_yes.bid = exploits.bid INNER JOIN exploit_files on vulnerable_yes.bid = exploit_files.bid where vulnerable_yes.info = "' + args.software_string + '" and vulnerable_yes.info not like "-%" and vulnerable_yes.info not like "+%" and exploits.remote = "Yes" and exploits.local = "No" order by vulnerable_yes.bid desc')
			else:
				cur.execute('select vulnerable_yes.bid, vulnerable_yes.info, exploits.class, exploits.remote, exploits.local, exploit_files.info from vulnerable_yes INNER JOIN exploits on vulnerable_yes.bid = exploits.bid INNER JOIN exploit_files on vulnerable_yes.bid = exploit_files.bid where vulnerable_yes.info = "' + args.software_string + '" and vulnerable_yes.info not like "-%" and vulnerable_yes.info not like "+%" and exploits.remote = "No" and exploits.local = "Yes" order by vulnerable_yes.bid desc')
			rows = cur.fetchall()
			for row in rows:
				print "Class: %s Remote: %s Local %s File: ./exploits/%s" % (row[2],row[3],row[4],row[5])

	except sql.Error, e:
		print "Error %s:" % (e.args[0])
		sys.exit(1)
		
	finally:
		if con:
			con.close()
	
	