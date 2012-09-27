<?php

        $uri = 'ftp://www.example.com/pub/pkg-shadow/shadow-4.1.4.3.tar.bz2';
        $proxy = 'tcp://proxy:8080';

        $opts = array(
                'ftp' => array(
                        'proxy' => $proxy
                )
        );

        $context = stream_context_create($opts);
        stream_context_set_params($context, array());

        $fh = fopen($uri, 'r', false, $context);
        while (!feof($fh)) {
                echo "foo\n";
                fread($fh, 4 * 1024);
        }

        fclose($fh);

?>

