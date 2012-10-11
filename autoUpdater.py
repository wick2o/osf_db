#!/usr/bin/env python

import urllib, urllib2
import re
import os, sys
import HTMLParser
import sqlite3 as sql

def get_data_between(data, start_tag, end_tag):
	start = data.find(start_tag)
	if start !=1:
		start += len(start_tag)
		end = data[start:].find(end_tag)
		if end != -1:
			return data[start:start+end]
	return None

def remove_html_tags(data):
	p = re.compile(r'<.*?>')
	return p.sub('', data)
	
def main():
	con = None
	
	try:
		con = sql.connect('sfocus.db')
		con.text_factory = str
		cur = con.cursor()

		cur.execute('SELECT bid FROM exploits ORDER BY id DESC LIMIT 1')
		rows = cur.fetchall()
		start_bid = int(rows[0][0]) 

		current_bid = start_bid
		do_break = 0
		sql_commands = []
		
		while True:
			current_bid = current_bid + 1
			#print "working on current_bid: %s" % (current_bid)
			url = urllib.urlopen("http://www.securityfocus.com/bid/%s/info" % (current_bid))
			html_data = url.read()
			my_data = get_data_between(html_data, '<table cellpadding="4" cellspacing="0" border="0">', '</table>')
			if my_data != None:
				if "content you are trying to view does not exist" in my_data:
					do_break = do_break + 1
					pass
				else:
					do_break = 0
					dp = re.compile('<tr.*?>\s*?(<td.*?>(.*?)</td>\s*?<td.*?>(.*?)</td>\s*?)</tr>\s*?', re.I | re.S | re.M)
					my_res = dp.findall(my_data)
					#print remove_html_tags(my_res[0][1]).strip() # BugTraq ID
					#print remove_html_tags(my_res[0][2]).strip() # BugTraq ID Value
					#print remove_html_tags(my_res[1][1]).strip() # Class
					#print remove_html_tags(my_res[1][2]).strip() # Class Value
					#print remove_html_tags(my_res[2][1]).strip() # CVE
					#print remove_html_tags(my_res[2][2]).strip() # CVE Value
					#print remove_html_tags(my_res[3][1]).strip() # Remote
					#print remove_html_tags(my_res[3][2]).strip() # Remote Value
					#print remove_html_tags(my_res[4][1]).strip() # Local
					#print remove_html_tags(my_res[4][2]).strip() # Local Value
					#print remove_html_tags(my_res[5][1]).strip() # Published
					#print remove_html_tags(my_res[5][2]).strip() # Published Value
					#print remove_html_tags(my_res[6][1]).strip() # Updated
					#print remove_html_tags(my_res[6][2]).strip() # Updated Value
					#print remove_html_tags(my_res[7][1]).strip() # Credit
					#print remove_html_tags(my_res[7][2]).strip() # Credit Value
					cve_list = []
					cve_itms = remove_html_tags(my_res[2][2]).strip().split('\n')
					for itm in cve_itms:
						if itm.strip() != "":
							cve_list.append(itm.strip())
					sql_commands.append('INSERT INTO exploits (bid,class,cve,remote,local,published,updated) values ("%s","%s","%s","%s","%s","%s","%s");' % (current_bid, remove_html_tags(my_res[1][2]).strip(), ",".join(cve_list), remove_html_tags(my_res[3][2]).strip(), remove_html_tags(my_res[4][2]).strip(), remove_html_tags(my_res[5][2]).strip(), remove_html_tags(my_res[6][2]).strip()))
					#print remove_html_tags(my_res[8][1]).strip() # Vulnerable
			
					vuln_itms = remove_html_tags(my_res[8][2]).strip().split('\n') # Vulnerable Value
					vuln_prev_value = 0 #0:clear 1:plus 2:minus
					vuln_prev_header = ""
					for itm in vuln_itms:
						if itm.strip() != "":
							if itm.strip() == "+":
								vuln_prev_header = "+ "
								vuln_prev_value = 1
							elif itm.strip() == "-":
								vuln_prev_header = "- "
								vuln_prev_value = 2
						if itm.strip() != "" and itm.strip() != "+" and itm.strip() != "-":
							sql_commands.append('INSERT INTO vulnerable_yes (bid,info) values ("%s","%s%s");' % (current_bid, vuln_prev_header, itm.strip().replace('  ', ' ').replace('"','\"')))
							vuln_prev_value = 0
							vuln_prev_header = ""
					#print remove_html_tags(my_res[9][1]).strip() # Not Vulnerable
					non_vuln_itms = remove_html_tags(my_res[9][2]).strip().split('\n') # Not Vulnerable Value
					non_vuln_prev_vaule = 0 #0:clear 1:plus 2:minus
					non_vuln_prev_header = ""
					for itm in non_vuln_itms:
						if itm.strip() != "":
							if itm.strip() == "+":
								non_vuln_prev_header = "+ "
								non_vuln_prev_value = 1
							elif itm.strip() == "-":
								non_vuln_prev_header = "- "
								non_vuln_prev_vaule = 2
						if itm.strip() != "" and itm.strip() != "+" and itm.strip() != "-":
							sql_commands.append('INSERT INTO vulnerable_no (bid,info) values ("%s","%s%s");' % (current_bid, non_vuln_prev_header, itm.strip().replace('  ', ' ').replace('"','\"')))
							non_vuln_prev_value = 0
							non_vuln_prev_header = ""
					#This is where I try and download any exploit data
					url = urllib.urlopen("http://www.securityfocus.com/bid/%s/exploit" % (current_bid))
					html_data = url.read()
					my_data = get_data_between(html_data, '<div id="vulnerability">', '</div>')
					if my_data != None:
						if "no exploit code" in my_data:
							#print "No exploit is required for %s" % (current_bid)
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No exploit is required");' % (current_bid))
						elif "no exploit required" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No exploit is required");' % (current_bid))
						elif "No exploit code is" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No exploit is required");' % (current_bid))
						elif "SecurityFocus staff are not" in my_data:
							#print "No known exploit exists for %s" % (current_bid)
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No known exploit exists");' % (current_bid))
						elif "staff are currently unaware" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No known exploit exists");' % (current_bid))
						elif "No exploits for this" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No known exploit exists");' % (current_bid))
						elif "None published" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s", "None published");' % (current_bid))
						elif "No exploit is required" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","No exploit is required");' % (current_bid))
						elif "exploited with a web browser" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","Can exploit with a web browser");' % (current_bid))
						elif "no specific exploit" in my_data:
							sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","no specific exploit code required");' % (current_bid))
						else:
							sploit_data = get_data_between(my_data, '<ul>', '</ul>').strip()
							if sploit_data == "":
								my_sploit_data = get_data_between(my_data, '</span><br/><br/>', '<ul>').strip()
								if not "discussion" in my_sploit_data and not "discusssion" in my_sploit_data and not "See discusssion" and not "Discussion" in my_sploit_data and my_sploit_data.upper() != "X":
									if "staff are not aware" in my_sploit_data or "we are not aware" in my_sploit_data:
										sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","Staff not aware of any exploits");' % (current_bid))
									else:
										f = open(".\\exploits\\%s.txt" % (current_bid) , 'w')
										my_data_txt = get_data_between(my_data, '</span><br/><br/>', '<ul>').strip()
										f.write(HTMLParser.HTMLParser().unescape(my_data_txt).replace('<br/>','\n').encode("utf-8"))
										f.close()
										sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","%s.txt");' % (current_bid,current_bid))
							else:
								dp = re.compile('<UL>\s*?(<LI><(.*?)</a></LI>\s*?)\s*?</UL>', re.I | re.S | re.M)
								sploits = dp.findall(my_data)
								if sploits != None:
									idx = 0
									for itm in remove_html_tags(sploits[0][0]).strip().split('\n'):
										if itm.strip() != "":
											my_url =  "http://www.securityfocus.com%s" % (itm.strip())
											if os.path.splitext(my_url)[1] != "":
												my_url_fname = "%s_%s%s" % (current_bid,idx,os.path.splitext(my_url)[1])
												sql_commands.append('INSERT INTO exploit_files (bid,info) values ("%s","%s");' % (current_bid,my_url_fname))
												urllib.urlretrieve(my_url, my_url_fname)
												idx += 1
			else:
				pass
				
			if do_break == 5:
				break
				
		sql_commands = list(set(sql_commands))
		for sql_cmd in sql_commands:
			cur.execute("%s" % (sql_cmd))
			
		con.commit()
		
		
	except sql.Error, e:
		print "Error %s:" % (e.args[0])
		sys.exit(1)
		
	finally:
		if con:
			con.close()


if __name__ == "__main__":
	main()