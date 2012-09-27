Example Usage:

sf-search.py list
  * This will list all software included in the database
sf-search.py list -f "cisco vpn"
  * This will list all software using a filter of cisco vpn

Once you have picked the software your interested in you can then do the following

sf-search.py search -s "Computer Associates BrightStor Enterprise Backup 10.0"

sf-search.py search -s "Computer Associates BrightStor Enterprise Backup 10.0" -c remote
  * This will return only remote exploits
sf-search.py search -s "Computer Associates BrightStor Enterprise Backup 10.0" -c local
  * This will return only local exploits

-c defaults as both
