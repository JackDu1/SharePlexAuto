REM -----------------------------------------------------------------------
REM Filename:   qa_ddlreg_drop_roles_users_pubsyns.sql
REM Purpose:    drop QA_DDL% roles/users/public synonyms on source and target
REM
REM Date:       08/20/06
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET time on
SET timing on
SET serveroutput on size 1000000 format wrapped
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

DECLARE
   l_drop            LONG;
   c_name   CONSTANT VARCHAR2 (20) := 'QA_DDL';
BEGIN
   FOR rt IN (SELECT   '"' || role || '"' role
                  FROM dba_roles
                 WHERE UPPER (role) LIKE c_name || '%'
              ORDER BY role)
   LOOP
      l_drop := 'DROP ROLE ' || rt.role || ' CASCADE';
      --qa_ddml.exec_ddl (p_ddl_string => l_drop, p_ddl_type => 'DBMS_SQL.V7');
      DBMS_OUTPUT.put_line ('Execute -> ' || l_drop);
      EXECUTE IMMEDIATE l_drop;
   END LOOP;

   FOR x IN (SELECT COUNT (role) cnt
               FROM dba_roles
              WHERE UPPER (role) LIKE c_name || '%')
   LOOP
      IF x.cnt = 0
      THEN
         DBMS_OUTPUT.put_line ('Passed:: Drop ' || c_name || '_X role(s)');
      ELSE
         DBMS_OUTPUT.put_line ('Failed:: Drop ' || c_name || '_X role(s)');
      END IF;
   END LOOP;

   FOR rt IN (SELECT   '"' || synonym_name || '"' synonym_name
                  FROM all_synonyms
                 WHERE owner = 'PUBLIC'
                   AND UPPER (synonym_name) LIKE c_name || '%'
              ORDER BY synonym_name)
   LOOP
      l_drop := 'DROP PUBLIC SYNONYM ' || rt.synonym_name;
      --qa_ddml.exec_ddl (p_ddl_string      => l_drop,
      --                  p_ddl_type        => 'EXECUTE IMMEDIATE'
      --                 );
      DBMS_OUTPUT.put_line ('Execute -> ' || l_drop);
      EXECUTE IMMEDIATE l_drop;
   END LOOP;

   FOR x IN (SELECT COUNT (synonym_name) cnt
               FROM all_synonyms
               WHERE owner = 'PUBLIC'
                   AND UPPER (synonym_name) LIKE c_name || '%')
   LOOP
      IF x.cnt = 0
      THEN
         DBMS_OUTPUT.put_line ('Passed:: Drop ' || c_name || '_X public synonym(s)');
      ELSE
         DBMS_OUTPUT.put_line ('Failed:: Drop ' || c_name || '_X public synonym(s)');
      END IF;
   END LOOP;

   FOR rt IN (SELECT   '"' || username || '"' username
                  FROM all_users
                 WHERE UPPER (username) LIKE c_name || '%'
              ORDER BY username)
   LOOP
      l_drop := 'DROP USER ' || rt.username || ' CASCADE';
      --qa_ddml.exec_ddl (p_ddl_string      => l_drop,
      --                  p_ddl_type        => 'DBMS_SQL.NATIVE'
      --                 );
      DBMS_OUTPUT.put_line ('Execute -> ' || l_drop);
      EXECUTE IMMEDIATE l_drop;
   END LOOP;

   FOR x IN (SELECT COUNT (username) cnt
               FROM all_users
              WHERE UPPER (username) LIKE c_name || '%')
   LOOP
      IF x.cnt = 0
      THEN
         DBMS_OUTPUT.put_line ('Passed:: Drop ' || c_name || '_X user(s)');
      ELSE
         DBMS_OUTPUT.put_line ('Failed:: Drop ' || c_name || '_X user(s)');
      END IF;
   END LOOP;

END;
/

SET verify on
SET feedback on
SET heading on


