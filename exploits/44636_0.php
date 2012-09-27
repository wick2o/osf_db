&lt;?php

$base_dir = DIR_WS_INCLUDES . &#039;auto_loaders/&#039;;
if (file_exists(DIR_WS_INCLUDES . &#039;auto_loaders/overrides/&#039; . $loader_file)) {
  $base_dir = DIR_WS_INCLUDES . &#039;auto_loaders/overrides/&#039;;
}

include($base_dir . $loader_file);

