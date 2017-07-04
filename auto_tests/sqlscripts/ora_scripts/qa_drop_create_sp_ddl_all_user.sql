REM -----------------------------------------------------------------------
REM Filename:   qa_drop_create_sp_ddl_all_user.sql
REM Purpose:    drop/create sp_ddl_all user
REM
REM Date:       09/15/06
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

DEFINE p_usr='SP_DDL_ALL'
DEFINE p_usr_s='SP_DDL_ALL_SRC'
DEFINE p_usr_d='SP_DDL_ALL_DST'
DEFINE p_tbs='SPLEX_DDL_ALL'

DECLARE
   l_sql   LONG;

   PROCEDURE create_user (p_username IN VARCHAR2, p_tablespace IN VARCHAR2)
   IS
      l_cnt    INTEGER;
      l_user   VARCHAR2 (30) := UPPER (p_username);
      l_pass   VARCHAR2 (30) := LOWER (p_username);
   BEGIN
      BEGIN
         SELECT COUNT (*)
           INTO l_cnt
           FROM DUAL
          WHERE EXISTS (SELECT NULL
                          FROM all_users
                         WHERE username = l_user);

         IF (l_cnt = 1)
         THEN
            DBMS_OUTPUT.put_line ('Message:: user ' || l_user || ' exists...');
         END IF;

         IF (l_cnt = 0)
         THEN
            l_sql :=
                  'CREATE USER '
               || l_user
               || ' IDENTIFIED BY '
               || l_pass
               || ' PROFILE DEFAULT ACCOUNT UNLOCK';
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            EXECUTE IMMEDIATE l_sql;

            l_sql :=
                  'ALTER USER '
               || l_user
               || ' DEFAULT TABLESPACE '
               || UPPER (p_tablespace)
               || ' TEMPORARY TABLESPACE TEMP'
               || ' QUOTA UNLIMITED ON '
               || p_tablespace;
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            EXECUTE IMMEDIATE l_sql;

            l_sql := 'GRANT CONNECT, RESOURCE, DBA TO ' || l_user;
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            EXECUTE IMMEDIATE l_sql;

            l_sql := 'GRANT READ, WRITE ON DIRECTORY LOB_FILES TO ' || l_user || ' WITH GRANT OPTION';
            DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            EXECUTE IMMEDIATE l_sql;

            --l_sql := 'GRANT CREATE TABLE TO ' || l_user;
            --DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            --EXECUTE IMMEDIATE l_sql;

            --l_sql := 'GRANT CREATE VIEW TO ' || l_user;
            --DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
            --EXECUTE IMMEDIATE l_sql;
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (l_sql);
            DBMS_OUTPUT.put_line (SQLERRM);
      END;
   END create_user;

   PROCEDURE kill_session (p_username IN VARCHAR2)
   IS
      l_wait    BOOLEAN       := FALSE;
      l_cnt     NUMBER        := 0;
      l_cnt_max NUMBER        := 20;
      l_user   VARCHAR2 (30) := UPPER (p_username);
   BEGIN
    WHILE (NOT l_wait AND NOT (l_cnt > l_cnt_max))
    LOOP
       BEGIN
          -- Try to get status<>KILLED, if OK, set l_wait = TRUE
          -- else EXCEPTION will automatically fire.
      FOR ks IN (SELECT SID, serial#, username
                   FROM v$session
                  WHERE username IS NOT NULL
                    AND username = l_user
                    AND SID <> (SELECT SID
                                  FROM v$mystat
                                 WHERE ROWNUM = 1)
                    AND status <> 'KILLED')
      LOOP
         l_sql :=
               'alter system kill session '
            || ''''
            || ks.SID
            || ','
            || ks.serial#
            || ''' immediate';

         EXECUTE IMMEDIATE l_sql;

         DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
      --DBMS_LOCK.sleep (10);
      END LOOP;

            l_wait := TRUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_wait := FALSE;
               DBMS_LOCK.sleep (10);
               DBMS_OUTPUT.put_line
                                  ('Execute -> wait 10s for session marked <> KILLED');
               l_cnt := l_cnt + 1;
         END;
      END LOOP;

   END kill_session;

   PROCEDURE drop_user (p_username IN VARCHAR2)
   IS
      l_wait    BOOLEAN       := FALSE;
      l_cnt     NUMBER        := 0;
      l_cnt_max NUMBER        := 20;
      l_user   VARCHAR2 (30) := UPPER (p_username);
   BEGIN
      WHILE (NOT l_wait AND NOT (l_cnt > l_cnt_max))
      LOOP
         BEGIN
            -- Try to get status<>KILLED, if OK, set l_wait = TRUE
            -- else EXCEPTION will automatically fire.
            FOR ot IN (SELECT   username
                           FROM all_users
                          WHERE username = l_user
                       ORDER BY username)
            LOOP
               l_sql := 'drop user ' || ot.username || ' cascade';
                IF (l_cnt = 0)
                THEN
                   DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));
                END IF; 
               EXECUTE IMMEDIATE l_sql;
            END LOOP;

            l_wait := TRUE;
         EXCEPTION
            WHEN OTHERS
            THEN
               l_wait := FALSE;
               DBMS_LOCK.sleep (10);
               DBMS_OUTPUT.put_line
                                  ('Execute -> wait 10s for status <> KILLED');
               l_cnt := l_cnt + 1;
         END;
      END LOOP;

      --DBMS_OUTPUT.put_line ('Execute -> ' || LOWER (l_sql));

      FOR un IN (SELECT   username
                     FROM all_users
                    WHERE username = l_user
                 ORDER BY username)
      LOOP
         DBMS_OUTPUT.put_line (   'Failed:: user '
                               || un.username
                               || ' still exists...'
                              );
      END LOOP;
   END drop_user;
BEGIN
   BEGIN
      kill_session ('&&p_usr');
      kill_session ('&&p_usr_s');
      kill_session ('&&p_usr_d');
      drop_user ('&&p_usr');
      drop_user ('&&p_usr_s');
      drop_user ('&&p_usr_d');
      create_user ('&&p_usr', '&&p_tbs');
   EXCEPTION
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (l_sql);
         DBMS_OUTPUT.put_line (SQLERRM);
   END;
END;
/

SET heading on
SET feedback on
SET verify on
