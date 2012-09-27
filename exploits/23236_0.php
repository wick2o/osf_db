<?php

  $MSGKEY = 519052;

  $msg_id = msg_get_queue ($MSGKEY, 0600);

  if (!msg_send ($msg_id, 1, 'AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHH', false, true, $msg_err))
    echo "Msg not sent because $msg_err\n";

  if (msg_receive ($msg_id, 1, $msg_type, 0xffffffff, $_SESSION, false, 0, $msg_error)) {
    echo "$msg\n";
  } else {
    echo "Received $msg_error fetching message\n";
    break;
  }

  msg_remove_queue ($msg_id);

?>
