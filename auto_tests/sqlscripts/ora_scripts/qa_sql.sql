CREATE OR REPLACE PACKAGE qa_sql
   AUTHID CURRENT_USER
IS
--=========================================================================================
-- Shareplex
--=========================================================================================
-- NAME: qa_sql
--
-- PURPOSE: To build a dml/ddl for all tables in schema with all datatypes
--
-- NOTES:
-- (1) 
--   random_flag    (TRUE/FALSE) flag that determines whether random data should be used.
--
--   g_output (F/ile/, D/isplay/, E/xecute/, S/Execute with NO DDL short description/, R/Execute and Display/, O/Execute and File) output type 
--   g_seed seed number
--   all tables should start or equal to g_table_name
--   all DDL columns should start with  g_col_name
--
--   all supported DDL datatypes | max size:
--   'varchar2|2000'  
--   'number|38'
--   'date'
--   'char|2000'
--   'timestamp|9'
--   'float|38'
--   'varchar|2000'
--   'integer'
--
--   all supported DDL types:
--    ADD_LONG     --add long column
--    ADD_BFILE    --add bfile column
--    ADD          --add random p_col_cnt number of columns with random size from the stortab list
--    DROP         --drop last p_col_cnt columns
--    SET_UNUSED   --set unused last p_col_cnt columns
--    DROP_UNUSED  --drop unused columns p_col_cnt times
--    TRUNCATE     --truncate p_tab table p_col_cnt times
--    MODIFY       --modify last p_col_cnt columns
--    MODIFY_LOB   --modify last p_col_cnt LOB column
--    MOVE_LOB     --move last p_col_cnt LOB column
--
-- (2) Here is a sample SQL*Plus script to execute it:
--   DML:
--     BEGIN
--       qa_sql.iud
--      (
--      p_sch                   => 'SP_IOT',   --schema name
--      p_tab                   => 'QA_TEST,   --table name
--      p_ins                   => 10,         --insert N of records
--      p_upd                   => 5,          --update N of records
--      p_del                   => 3,          --delete N of records
--      p_com                   => 1,          --commit every p_com times(0-no commit)
--      p_rol                   => 0,          --rollback every p_rol times
--      p_noth                  => 0,          --do nothing every p_noth times
--      p_null                  => 0,          --insert/update to NULL every p_null column(0-random)
--      p_sleep                 => 0,          --sleep time (in seconds)
--      p_long                  => 1000,       --max long size
--      p_nested_upper          => INT         --upper bound for nested type (20)
--      p_varr_rand             => TRUE,       --random number of varray elements (TRUE/FALSE)
--      p_null_varr             => 2,          --insert/update to NULL every p_null_varr varray element
--      p_null_udt              => 2,          --insert/update to NULL every p_null_udt udt element
--      p_prb                   => FALSE,      --partial rollback (TRUE/FALSE)
--      p_clob                  => 'EMPTY',    --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
--      p_blob                  => 'EMPTY',    --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
--      p_dbms_lob_trim         => FALSE,      --dbms_lob.trim   (TRUE/FALSE)
--      p_dbms_lob_erase        => FALSE,      --dbms_lob.erase  (TRUE/FALSE)
--      p_dbms_lob_append       => FALSE,      --dbms_lob.append (TRUE/FALSE)
--      p_dbms_lob_copy         => FALSE,      --dbms_lob.copy   (TRUE/FALSE)
--      p_dbms_lob_writeappend  => FALSE,      --dbms_lob.writeappend (TRUE/FALSE)
--      p_dbms_lob_write        => FALSE,      --dbms_lob.write (TRUE/FALSE)
--      p_ers_amt               => 3200,       --lob amount to erase
--      p_ers_pos               => 100,        --lob position to erase
--      p_trim                  => 0,          --truncates the LOB to p_trim bytes
--      p_writeappend           => 32000,      --writes p_writeappend of data from the buffer to the end of a LOB
--      p_write_amt             => 30000,      --writes p_write of data to the LOB from p_write_off offset
--      p_write_off             => 100,        --offset to writes p_writeappend of data
--      p_length                => 'm',        --data length (r-random, m-max)
--      p_rand_str              => 'a',        --random strings values  'a','A' alpha characters only (mixed case)
--                                                                   -- 'l','L' lower case alpha characters only
--                                                                   -- 'p','P' any printable characters
--                                                                   -- 'u','U' upper case alpha characters only
--                                                                   -- 'x','X' any alpha-numeric characters (upper)
--      p_ins_flag              => 'r',        --insert flag (r-regular, d-direct)
--      p_upd_flag              => 'n'         --update flag (n-update nonkey cols, k-update key cols only, a-update all cols))
--      );
--     END;
--
--   BULKDML:
--     BEGIN
--       qa_sql.bulkdml
--      (
--      p_sch      => 'SP_DDL',   --name of the schema (default USER schema)
--      p_tab      => 'QA_TEST',  --name of the table
--      p_ins      => 'r',        --insert flag (r-regular, d-direct)
--      p_rows     => 10,         --number of bulk dmls
--      p_rand_str => 'a',        --random strings values  'a','A' alpha characters only (mixed case)
--                                                     -- 'l','L' lower case alpha characters only
--                                                     -- 'p','P' any printable characters
--                                                     -- 'u','U' upper case alpha characters only
--                                                     -- 'x','X' any alpha-numeric characters (upper)
--      );
--     END;
--
--  DDL:
--     BEGIN
--       qa_sql.ddl
--      (
--      p_sch        => 'SP_DDL',      --name of the schema (default USER schema)
--      p_tab        => rt.table_name, --name of the table
--      p_ddl        => 'drop',        --ddl type ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY/MODIFY_LOB/MOVE_LOB
--      p_col_cnt    => 10             --number of columns
--      p_lob_clause => '(NOCACHE)'    --lob clause, default NULL
--      );
--     END;
--
--  CREATE TABLE:
--     BEGIN
--       qa_sql.create_tab
--      (
--      p_schname        => 'SP_DDL',        --name of the schema (default USER schema)
--      p_tabname        => 'qa_ilya',       --name of the table 
--      p_colname        => 'C',             --name of the column (default COL)
--      p_colnum         =>  1000,           --number of columns (default 10)
--      p_pknum          =>  32,             --number of PKs (default 0)
--      p_start          =>  3,              --start PK col number (default 0)
--      p_varr_max       =>  5,              --max number of VARRAY columns (default 5)
--      p_udt_max        =>  5,              --max number of UDT columns (default 5)
--      p_nest_max       =>  5,              --max number of TABLE TYPE columns (default 5)
--      p_lob_max        =>  5,              --max number of LOB columns (default 5)
--      p_lob_out        =>  0,              --number of disable storage in row LOB columns (default 0)
--      p_lob_securefile =>  FALSE,          --LOB column in securefile tablespace (TRUE/FALSE)
--      p_column         =>  NULL,           --any additional column (default NULL)      
--      p_cr_tab         =>  'CREATE TABLE', --create table clause (default CREATE TABLE)
--      p_clause         =>  NULL            --any text that can be legally appended to a CREATE statement (default NULL)
--      );
--     END;
--
--  DROP OBJECT:
--     BEGIN
--       qa_sql.drop_obj
--      (
--      p_sch  => 'SP_DDL', --name of the schema (default USER schema)
--      p_obj  => 'TABLE',  --object type
--      p_name => 'QA_TEST' --object name 
--      );
--     END;
--
--  DROP COLUMN TYPE:
--     BEGIN
--       qa_sql.drop_col
--      (
--      p_sch  => 'SP_DDL',  --name of the schema (default USER schema)
--      p_tab  => 'QA_TEST', --table name
--      p_name => 'VARRAY'   --column type (VARRAY/LOB/BFILE/CHAR...)
--      );
--     END;
--
--  EXECUTE DDL:
--     BEGIN
--       qa_sql.exec_ddl
--      (
--      p_ddl_string  => 'drop table qa_ilya',  --any DDL that can be legally run
--      p_ddl_type    => 'EXECUTE IMMEDIATE'    --ddl type - 'EXECUTE IMMEDIATE'/'DBMS_SQL.NATIVE'/'DBMS_SQL.V7'
--      );
--     END;
--
--  MOVE/MODIFY LOB columns:
--     BEGIN
--       qa_sql.lob
--      (
--      p_sch        => 'SP_DDL',  --name of the schema (default USER schema)
--      p_tab        => 'QA_TEST', --table name
--      p_ddl        => 'MOVE',    --supported LOB DDLs (MOVE/MODIFY)
--      p_lob_clause =>  NULL      --any text that can be legally appended to an ALTER TABLE DDL LOB statement (default NULL)
--      );
--     END;
--
--  IS ANY p_coltype COLUMN
--     BEGIN
--       qa_sql.is_col
--       (
--      p_sch      => 'SP_DDL',  --name of the schema (default USER schema)
--      p_tab      => 'QA_TEST', --table name
--      p_coltype  => 'LONG'     --column type (LONG/LOB/NUMBER/CHAR...)
--      );
--     END;
--
--  MISC
--
--   ORACLE VERSION:
--     BEGIN
--       qa_sql.oraver;
--     END;
--
--   ORACLE COMPRESSION
--     BEGIN
--       qa_sql.compression
--       (
--        p_tblsp      => 'SPLEX_DDL_ALL'  --tablespace (default SLPEX_DDL_ALL)
--       );
--     END;
--
--   CHECK IF COMPRESSION IS BASIC
--     BEGIN
--       qa_sql.is_basic_compr
--       (
--        p_tblsp      => 'SPLEX_DDL_ALL', --tablespace (default SLPEX_DDL_ALL)
--        p_sch        => 'SP_DDL',        --user
--        p_tab        => 'TEST'           --table name
--       );
--     END;
--
--
--  VERSION:
--     BEGIN
--       qa_sql.version;
--     END;    
--
--  QUOTES:
--     BEGIN
--       qa_sql.quotes('test');
--     END;
--
--  PRINT LINE:
--     BEGIN
--       qa_sql.putline
--      (
--      p_str  => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'  --string can be > 255
--      );
--     END;
--
--  HELP: Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)
--     BEGIN
--       qa_sql.help;
--     END;
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   1/22/08     Initial creation
-- Ilya Rubijevsky   2/09/11     Removed add LONG column on 11g
-- Ilya Rubijevsky   4/19/11     Added compression condition
-- Ilya Rubijevsky   1/31/13     Fixed nested table clause
-- Ilya Rubijevsky   06/28/13    Added nested table DML support
-- Ilya Rubijevsky   08/04/13    Removed sys.anyData.convertDate(NULL) from DMLs 
--                               due to ORA-01858 in 12c
--============================================================================
------------------------------------------------------------------------------
--  Public declarations of types, cursors, variables, exceptions
--  procedures, and functions
------------------------------------------------------------------------------

   -- Flag that determines whether random data should be used.
   random_flag        BOOLEAN                            := TRUE;
   g_table_name       all_objects.object_name%TYPE       := 'QA';
   g_col_name         all_tab_columns.column_name%TYPE   := 'COL_ADD';
   g_seed             NUMBER                             := NULL;
   g_output           CHAR(1)                            := 'E';

   TYPE stortab IS TABLE OF VARCHAR2 (200);

   --All supported DDL datatypes
   stor_table                 stortab
      := stortab ('varchar2|2000',
                  'number|38',
                  --'clob',
                  'date',
                  'char|2000',
                  'timestamp|9',
                  --'blob',
                  'float|38',
                  'varchar|2000',
                  --'bfile',
                  'integer'
                 );

-------------------------------------
-- NAME   : iud
-- PURPOSE: Build insert/update/delete
-------------------------------------
   PROCEDURE iud (
      p_sch                   VARCHAR2           := NULL,             --schema name
      p_tab                   VARCHAR2,                               --table name
      p_ins                   INT                := 10,               --insert N of records
      p_upd                   INT                := 5,                --update N of records
      p_del                   INT                := 3,                --delete N of records
      p_com                   INT                := 1,                --commit every p_com times(0-no commit)
      p_rol                   INT                := 0,                --rollback every p_rol times
      p_noth                  INT                := 0,                --do nothing every p_noth times
      p_null                  INT                := 0,                --insert/update to NULL every p_null column(0-random)
      p_sleep                 INT                := 0,                --sleep time (in seconds)
      p_long                  INT                := 1000,             --max long size
      p_nested_upper          INT                := 20,               --upper bound for nested type
      p_varr_rand             BOOLEAN            := TRUE,             --random number of varray elements (TRUE/FALSE)
      p_null_varr             INT                := 2,                --insert/update to NULL every p_null_varr varray element
      p_null_udt              INT                := 2,                --insert/update to NULL every p_null_udt udt element
      p_prb                   BOOLEAN            := FALSE,            --partial rollback (TRUE/FALSE)
      p_clob                  VARCHAR2           := 'EMPTY',          --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_blob                  VARCHAR2           := 'EMPTY',          --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_xml                   VARCHAR2           := NULL,             --XML location for ins/upd external XML files
      p_dbms_lob_trim         BOOLEAN            := FALSE,            --dbms_lob.trim        (TRUE/FALSE)
      p_dbms_lob_append       BOOLEAN            := FALSE,            --dbms_lob.append      (TRUE/FALSE)
      p_dbms_lob_copy         BOOLEAN            := FALSE,            --dbms_lob.copy        (TRUE/FALSE)
      p_dbms_lob_erase        BOOLEAN            := FALSE,            --dbms_lob.erase       (TRUE/FALSE)
      p_dbms_lob_writeappend  BOOLEAN            := FALSE,            --dbms_lob.writeappend (TRUE/FALSE)
      p_dbms_lob_write        BOOLEAN            := FALSE,            --dbms_lob.write       (TRUE/FALSE)
      p_ers_amt               INT                := 3200,             --lob amount to erase
      p_ers_pos               INT                := 100,              --lob position to erase
      p_trim                  INT                := 0,                --truncates the LOB to p_trim bytes  
      p_writeappend           INT                := 32000,            --writes p_writeappend of data from the buffer to the end of a LOB
      p_write_amt             INT                := 30000,            --writes p_write of data to the LOB from p_write_off offset
      p_write_off             INT                := 100,              --offset to writes p_writeappend of data 
      p_rand_str              VARCHAR2           := 'a',              --random strings values  'a','A' alpha characters only (mixed case)
                                                                                            -- 'l','L' lower case alpha characters only
                                                                                            -- 'p','P' any printable characters
                                                                                            -- 'u','U' upper case alpha characters only
                                                                                            -- 'x','X' any alpha-numeric characters (upper)
      p_length                VARCHAR2           := 'm',              --data length (r-random, m-max)
      p_ins_flag              VARCHAR2           := 'r',              --insert flag (r-regular, d-direct)
      p_upd_flag              VARCHAR2           := 'n'               --update flag (n-update nonkey cols, k-update key cols only, a-update all cols))
    );

-------------------------------------
-- NAME   : bulkdml
-- PURPOSE: Build bulk dml
-------------------------------------
   PROCEDURE bulkdml (
      p_sch       VARCHAR2 := NULL,
      p_tab       VARCHAR2,
      p_ins       VARCHAR2 := 'r',
      p_rows      INT := 1,
      p_rand_str  VARCHAR2 := 'a'
   );

-------------------------------------
-- NAME   : ddl
-- PURPOSE: Build ddl
-- NOTES  : Supported DDLs: 
-- ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY
-------------------------------------
   PROCEDURE ddl (
      p_sch        VARCHAR2 := NULL,
      p_tab        VARCHAR2,
      p_tblsp      VARCHAR2 := 'SPLEX_DDL_ALL',
      p_ddl        VARCHAR2,
      p_col_cnt    INT := 1,
      p_lob_clause VARCHAR2 := NULL
   );

-------------------------------------
-- NAME   : lob
-- PURPOSE: Modify/Move LOB columns
-- NOTES  : Supported DDLs:
-- MODIFY/MOVE
-------------------------------------
   PROCEDURE lob (
      p_sch        VARCHAR2 := NULL,
      p_tab        VARCHAR2,
      p_ddl        VARCHAR2,
      p_lob_clause VARCHAR2 := NULL
   );

-------------------------------------
-- NAME   : part
-- PURPOSE: ALTERING PARTITION TABLES
-- NOTES  : Supported DDLs:
-- ADD/COALESCE/SPLIT/MERGE/DROP/RENAME/TRUNCATE/MODIFY_PART/MODIFY_SUBPART/MOVE_PART/MOVE_SUBPART
-------------------------------------
   PROCEDURE part (
      p_sch        VARCHAR2 := NULL,
      p_tab        VARCHAR2,
      p_ptn_name   VARCHAR2 := NULL,
      p_ptn_type   VARCHAR2 := 'PARTITION',
      p_ddl        VARCHAR2,
      p_ptn_clause VARCHAR2 := NULL
   );

-------------------------------------
-- NAME   : create_tab
-- PURPOSE: Build create table with PK
-------------------------------------
   PROCEDURE create_tab (
      p_schname         VARCHAR2 := NULL,
      p_tabname         VARCHAR2,
      p_colname         VARCHAR2 := 'COL',
      p_colnum          INT      := 10,
      p_pknum           INT      := 0,
      p_start           INT      := 0,
      p_varr_max        INT      := 5,
      p_udt_max         INT      := 5,
      p_nest_max        INT      := 5,
      p_lob_max         INT      := 5,
      p_lob_out         INT      := 0,
      p_lob_securefile  BOOLEAN  := FALSE,
      p_column          VARCHAR2 := NULL,
      p_cr_tab          VARCHAR2 := 'CREATE TABLE', 
      p_clause          VARCHAR2 := NULL
   );

-------------------------------------
-- NAME   : drop_obj
-- PURPOSE: Drop object
-------------------------------------
   PROCEDURE drop_obj (
      p_sch            VARCHAR2 := NULL,
      p_obj            VARCHAR2,
      p_name           VARCHAR2
   );

-------------------------------------
-- NAME   : drop_col
-- PURPOSE: Drop column type
-------------------------------------
   PROCEDURE drop_col (
      p_sch            VARCHAR2 := NULL,
      p_tab            VARCHAR2,
      p_coltype        VARCHAR2
   );

-------------------------------------
-- NAME   : exec_ddl
-- PURPOSE: Execute ddl by using
--          "p_ddl_type" ddl
-------------------------------------
   PROCEDURE exec_ddl (
      p_ddl_string     VARCHAR2,
      p_ddl_type       VARCHAR2 := 'EXECUTE IMMEDIATE'
   );

-------------------------------------
-- NAME   : is_col
-- PURPOSE: Is any p_coltype column
-------------------------------------
   FUNCTION is_col (
      p_sch         VARCHAR2 := NULL, 
      p_tab         VARCHAR2, 
      p_coltype     VARCHAR2
   ) 
   RETURN INTEGER;

-------------------------------------
-- NAME: putline
-- PURPOSE: extension of DBMS_OUTPUT.put_line package
--        controling by output_flag
-------------------------------------
   PROCEDURE putline (
      p_str           VARCHAR2
  );

-------------------------------------
-- NAME: quotes
-- PURPOSE: RETURN '"' || p_str || '"'
-------------------------------------
   FUNCTION quotes (p_str IN VARCHAR2)
      RETURN VARCHAR2;

-------------------------------------
-- NAME   : version
-- PURPOSE: Package version
-------------------------------------
   PROCEDURE version;

-------------------------------------
-- NAME   : oraver
-- PURPOSE: Oracle version
-------------------------------------
   FUNCTION oraver RETURN INTEGER;

-------------------------------------
-- NAME   : compression
-- PURPOSE: Oracle compression
-------------------------------------
   FUNCTION compression (
      p_tblsp            VARCHAR2 := 'SPLEX_DDL_ALL'
   )
   RETURN VARCHAR2;

-------------------------------------
-- NAME: is_basic_compr
-- PURPOSE: to check if the table or tablespace compression is Basic
-------------------------------------
   FUNCTION is_basic_compr (
      p_tblsp           VARCHAR2 := 'SPLEX_DDL_ALL',
      p_sch             VARCHAR2,
      p_tab             VARCHAR2
   )
      RETURN BOOLEAN;

-------------------------------------
-- NAME   : help
-- PURPOSE: Package help
--          Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)
-------------------------------------
   PROCEDURE help;

END qa_sql;
/

CREATE OR REPLACE PACKAGE BODY qa_sql
IS
--============================================================================
-- NAME: qa_sql
--============================================================================
------------------------------------------------------------------------------
--  Private declarations of types, cursorss, variables, exceptions
--  procedures, and functions
------------------------------------------------------------------------------
   g_clob   CLOB;
   g_blob   BLOB;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE version
   IS
--============================================================================
-- NAME: version
-- PURPOSE: To display version number 
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   BEGIN
      DBMS_OUTPUT.put_line ('QA_SQL Package - Version 1.0.0 - Jan 22, 2008');
   END version;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE putlinef (p_str VARCHAR2)
   IS
--============================================================================
-- NAME: putlinef
-- PURPOSE: send output to the specified file
--        
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      c_file  CONSTANT VARCHAR2 (30) := 'qa_sql.out';
      c_dir   CONSTANT VARCHAR2 (30) := 'LOB_FILES';
      l_fid   UTL_FILE.file_type;
   BEGIN

      l_fid := UTL_FILE.fopen (c_dir, c_file, 'A', 32767);
      UTL_FILE.put_line (l_fid, p_str);
      UTL_FILE.fclose (l_fid);

   EXCEPTION
     WHEN OTHERS
     THEN
       DBMS_OUTPUT.put_line (   'Failure to write output to '
                              || c_dir
                              || '/'
                              || c_file
                              || ' '
                              || REPLACE(SQLERRM, 'ORA')
                             );

        IF UTL_FILE.is_open (l_fid) THEN
           UTL_FILE.fclose (l_fid);
        END IF;

   END putlinef;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE putline (p_str VARCHAR2)
   IS
--============================================================================
-- NAME: putline
-- PURPOSE: extension of DBMS_OUTPUT.put_line package, no wrapping
--        
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_len   PLS_INTEGER    := 255;
      l_str   VARCHAR2 (255);
   BEGIN
      IF LENGTH (p_str) > l_len
      THEN
         l_str := SUBSTR (p_str, 1, l_len);
         DBMS_OUTPUT.put_line (l_str);
         putline (SUBSTR (p_str, l_len + 1));
      ELSE
         l_str := p_str;
         DBMS_OUTPUT.put_line (l_str);
      END IF;
   END putline;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE run (p_query IN VARCHAR2)
   IS
--============================================================================
-- NAME: run
-- PURPOSE: execute or dump output to screen or file
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      output_param_not_found   EXCEPTION;
      l_output                 VARCHAR2 (1)    := UPPER (g_output);
      l_query                  VARCHAR2(32767) := p_query;

   BEGIN

      IF l_output NOT IN ('F', 'D', 'E', 'R', 'S', 'O')
      THEN
         RAISE output_param_not_found;
      END IF;

      IF l_output = 'F'
      THEN
         putlinef (l_query);
      ELSIF l_output = 'D'
      THEN
         putline (l_query);
      ELSIF l_output = 'R'
      THEN
         EXECUTE IMMEDIATE l_query;
         putline (l_query);
      ELSIF l_output = 'E'
      THEN
         EXECUTE IMMEDIATE l_query;
      ELSIF l_output = 'S'
      THEN
         EXECUTE IMMEDIATE l_query;
      ELSIF l_output = 'O'
      THEN
         EXECUTE IMMEDIATE l_query;
         putlinef (l_query);
      END IF;

   EXCEPTION
      WHEN output_param_not_found
      THEN
         --
         -- Invalid g_output flag.
         --
         DBMS_OUTPUT.put_line
            ('Warning -> Invalid g_output flag - must specify F/ile/, D/isplay/, E/xecute/, S/Execute with NO DDL short description/, R/Execute and Display/, O/Execute and File'
            );
         --help;
   END run;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE out (p_query IN VARCHAR2)
   IS
--============================================================================
-- NAME: out
-- PURPOSE: dump output to screen or file
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      output_param_not_found   EXCEPTION;
      l_output                 VARCHAR2 (1)    := UPPER (g_output);
      l_query                  VARCHAR2(32767) := p_query;

   BEGIN

      IF l_output NOT IN ('F', 'D', 'E', 'R', 'S', 'O')
      THEN
         RAISE output_param_not_found;
      END IF;

      IF l_output = 'F'
      THEN
         putlinef (l_query);
      ELSIF l_output = 'D'
      THEN
         putline (l_query);
      ELSIF l_output = 'R'
      THEN
         --EXECUTE IMMEDIATE l_query;
         putline (l_query);
      ELSIF l_output = 'E'
      THEN
         --EXECUTE IMMEDIATE l_query;
         NULL;
      ELSIF l_output = 'S'
      THEN
         --EXECUTE IMMEDIATE l_query;
         NULL;
      ELSIF l_output = 'O'
      THEN
         --EXECUTE IMMEDIATE l_query;
         putlinef (l_query);
      END IF;

   EXCEPTION
      WHEN output_param_not_found
      THEN
         --
         -- Invalid g_output flag.
         --
         DBMS_OUTPUT.put_line
            ('Warning -> Invalid g_output flag - must specify F/ile/, D/isplay/, E/xecute/, S/Execute with NO DDL short description/, R/Execute and Display/, O/Execute and File'
            );
         --help;
   END out;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE gen_seed
   IS
--============================================================================
-- NAME: gen_seed
-- PURPOSE: To generate seed for DBMS_RANDOM
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_seed    NUMBER;

   BEGIN
      SELECT (USERENV ('SESSIONID') + TO_NUMBER(TO_CHAR(SYSTIMESTAMP,'SSFF')))
        INTO l_seed
        FROM DUAL;

      IF NOT random_flag
      THEN
         l_seed := 123456789;
      END IF;

      DBMS_RANDOM.seed (NVL(g_seed, l_seed));
      --DBMS_OUTPUT.put_line ('seed -> ' || NVL(g_seed, l_seed));
     out ('seed -> ' || NVL(g_seed, l_seed));

   END gen_seed;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION quotes (p_str IN VARCHAR2)
      RETURN VARCHAR2
   IS
--============================================================================
-- NAME: quotes
-- PURPOSE: RETURN '"' || p_str || '"'
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
   BEGIN
      RETURN '"' || p_str || '"';
   END quotes;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION is_num (p_string IN VARCHAR2)
   RETURN BOOLEAN
   IS
--============================================================================
-- NAME: is_num
-- PURPOSE: to check if the contents of a VARCHAR field is Numeric
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_number   NUMBER;
   BEGIN
      l_number := p_string;
      RETURN TRUE;
   EXCEPTION
      WHEN OTHERS
      THEN
         RETURN FALSE;
   END is_num;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE dbms_lob_loadfromfile (p_filename VARCHAR2, p_glob IN OUT CLOB)
   IS
--============================================================================
-- NAME: dbms_lob_loadfromfile
-- PURPOSE: generic procedure to load BLOB/CLOB from file
--
-- NOTES:
--       for CLOBs, it reads data from external file, performs any character
--       set translation that's mecessary, and writes the data to the CLOB col
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      -- Input Directory as specified in create directory
      c_dir         CONSTANT VARCHAR2(30) := 'LOB_FILES';
      l_bfile       BFILE;
      l_src_offset  INTEGER := 1;
      l_dst_offset  INTEGER := 1;
      l_lang_cont   INTEGER := DBMS_LOB.default_lang_ctx;
      l_warn_msg    INTEGER;

   BEGIN
      l_bfile := BFILENAME (c_dir, p_filename);

      IF (DBMS_LOB.fileexists (l_bfile) = 1)
      THEN
         -- If the file is already open, close the file.
         IF DBMS_LOB.FILEISOPEN(l_bfile) = 1 THEN
            DBMS_LOB.FILECLOSE(l_bfile);
         END IF;
         --DBMS_LOB.CREATETEMPORARY(p_glob,TRUE,DBMS_LOB.SESSION);
         -- Open the file.
         DBMS_LOB.fileopen (l_bfile);
         --DBMS_LOB.loadfromfile (p_glob, l_bfile, DBMS_LOB.getlength (l_bfile));
         DBMS_LOB.loadclobfromfile (p_glob, l_bfile, DBMS_LOB.LOBMAXSIZE, l_src_offset, l_dst_offset, NLS_CHARSET_ID ('US7ASCII'), l_lang_cont, l_warn_msg);
         -- Close the file.
         DBMS_LOB.fileclose (l_bfile);
         --DBMS_LOB.FREETEMPORARY(p_glob); 
      ELSE
        DBMS_OUTPUT.put_line ('File ' || p_filename || ' or Directory ' || c_dir || ' does not exist');
      END IF;
   EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Error: dbms_lob_loadfromfile ' || REPLACE(SQLERRM, 'ORA'));
        DBMS_LOB.fileclose (l_bfile);
   END dbms_lob_loadfromfile;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE dbms_lob_loadfromfile (p_filename VARCHAR2, p_glob IN OUT BLOB)
   IS
--============================================================================
-- NAME: dbms_lob_loadfromfile
-- PURPOSE: generic procedure to load BLOB/CLOB from file
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      -- Input Directory as specified in create directory
      c_dir     CONSTANT VARCHAR2(30) := 'LOB_FILES';
      l_bfile   BFILE;
   BEGIN
      l_bfile := BFILENAME (c_dir, p_filename);

      IF (DBMS_LOB.fileexists (l_bfile) = 1)
      THEN
         -- If the file is already open, close the file.
         IF DBMS_LOB.FILEISOPEN(l_bfile) = 1 THEN
            DBMS_LOB.FILECLOSE(l_bfile);
         END IF;
         --DBMS_LOB.CREATETEMPORARY(p_glob,TRUE,DBMS_LOB.SESSION);
         -- Open the file.
         DBMS_LOB.fileopen (l_bfile);
         DBMS_LOB.loadfromfile (p_glob, l_bfile,
                                DBMS_LOB.getlength (l_bfile));
         -- Close the file.
         DBMS_LOB.fileclose (l_bfile);
         --DBMS_LOB.FREETEMPORARY(p_glob); 
      ELSE
        DBMS_OUTPUT.put_line ('File ' || p_filename || ' or Directory ' || c_dir || ' does not exist');
      END IF;
   EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Error: dbms_lob_loadfromfile ' || REPLACE(SQLERRM, 'ORA'));
        DBMS_LOB.fileclose (l_bfile);
   END dbms_lob_loadfromfile;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION maxcolid (
      p_sch           VARCHAR2,
      p_tab           VARCHAR2
   )
      RETURN INTEGER
   IS
--============================================================================
-- NAME: maxcolid
-- PURPOSE: Get MAX (column_id)
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_retval   INTEGER;
      l_sch      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab      VARCHAR2 (100) := quotes (p_tab);
   BEGIN
      SELECT MAX (column_id)
        INTO l_retval
        FROM all_tab_columns
       WHERE owner = l_sch
         AND table_name = p_tab;

      RETURN l_retval;
   END maxcolid;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE sleep(p_sec IN NUMBER)
   IS
--============================================================================
-- NAME: sleep
-- PURPOSE: sleep time in seconds
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   2/18/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_start_time   NUMBER;
   l_curr_time    NUMBER;
   l_end_time     NUMBER;
  BEGIN
   SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'SSSSS'))
     INTO l_start_time
     FROM DUAL;

   -- Calculate end of sleep time
   l_end_time := l_start_time + p_sec;

   -- Loop until End Time is reached
   WHILE (1 = 1)
   LOOP
      -- Get current time
      SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'SSSSS'))
        INTO l_curr_time
        FROM DUAL;

      -- Compare to end time and exit if time is past
      IF (l_curr_time >= l_end_time)
      THEN
         EXIT;
      END IF;
   END LOOP;
  END sleep;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION oraver
      RETURN INTEGER
   IS
--============================================================================
-- NAME: oraver
-- PURPOSE: Get Oracle version
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_retval   INTEGER;
   BEGIN
      SELECT SUBSTR (VERSION, 1, INSTR (VERSION, '.') - 1)
        INTO l_retval
        FROM product_component_version
       WHERE UPPER (product) LIKE '%ORACLE%';

      RETURN l_retval;
   END oraver;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION compression (
      p_tblsp           VARCHAR2 := 'SPLEX_DDL_ALL'
   )
      RETURN VARCHAR2
   IS
--============================================================================
-- NAME: compression
-- PURPOSE: Get Compression level from Oracle
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   4/19/11    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_retval   VARCHAR2 (20);
   l_oraver   INT           := oraver;
 BEGIN
   IF l_oraver = 9 OR l_oraver = 10
   THEN
      l_retval := 'NOCOMPRESS';
   ELSE
      EXECUTE IMMEDIATE    'SELECT NVL(COMPRESS_FOR, ''NOCOMPRESS'') FROM USER_TABLESPACES WHERE TABLESPACE_NAME = '
                        || ''''||p_tblsp||''''
                   INTO l_retval;
   END IF;

   RETURN l_retval;

 EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN 'NOCOMPRESS';
 END compression;
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION is_basic_compr (
      p_tblsp           VARCHAR2 := 'SPLEX_DDL_ALL',
      p_sch             VARCHAR2,
      p_tab             VARCHAR2
   )
      RETURN BOOLEAN
   IS
--============================================================================
-- NAME: is_basic_compr
-- PURPOSE: to check if the table or tablespace compression is Basic
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   4/21/11    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_cnt1     INT            := 0;
   l_cnt2     INT            := 0;
   l_cnt3     INT            := 0;
   l_oraver   INT            := oraver;
   l_sch      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
   l_tab      VARCHAR2 (100) := quotes (p_tab);
   l_maxcol   INT            := maxcolid (l_sch, p_tab);
 BEGIN
   IF l_oraver = 9 OR l_oraver = 10 
   THEN
      RETURN FALSE;
   ELSE
      EXECUTE IMMEDIATE    'SELECT NVL(COUNT(COMPRESS_FOR),0) FROM USER_TABLESPACES WHERE TABLESPACE_NAME = '
                        || ''''||p_tblsp||''''
                        || ' AND compress_for IN (''BASIC'', ''DIRECT LOAD ONLY'')'
                   INTO l_cnt1;

      EXECUTE IMMEDIATE    'SELECT NVL(COUNT(COMPRESS_FOR),0) FROM USER_TAB_PARTITIONS WHERE TABLE_NAME = '
                        || ''''||p_tab||''''
                        || 'AND compress_for IN (''BASIC'', ''DIRECT LOAD ONLY'')'
                   INTO l_cnt2;

      EXECUTE IMMEDIATE    'SELECT NVL(COUNT(COMPRESS_FOR),0) FROM USER_TABLES WHERE TABLE_NAME = '
                        || ''''||p_tab||''''
                        || 'AND compress_for IN (''BASIC'', ''DIRECT LOAD ONLY'')'
                   INTO l_cnt3;
   END IF;

   IF l_cnt1 > 0 OR l_cnt2 > 0 OR l_cnt3 > 0 OR l_maxcol > 255
   THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
 EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      RETURN FALSE;
 END is_basic_compr;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__-__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE iud (
      p_sch                   VARCHAR2           := NULL,             --schema name
      p_tab                   VARCHAR2,                               --table name
      p_ins                   INT                := 10,               --insert N of records
      p_upd                   INT                := 5,                --update N of records
      p_del                   INT                := 3,                --delete N of records
      p_com                   INT                := 1,                --commit every p_com times(0-no commit)
      p_rol                   INT                := 0,                --rollback every p_rol times
      p_noth                  INT                := 0,                --do nothing every p_noth times
      p_null                  INT                := 0,                --insert/update to NULL every p_null column(0-random)
      p_sleep                 INT                := 0,                --sleep time (in seconds)
      p_long                  INT                := 1000,             --max long size
      p_nested_upper          INT                := 20,               --upper bound for nested type
      p_varr_rand             BOOLEAN            := TRUE,             --random number of varray elements (TRUE/FALSE)
      p_null_varr             INT                := 2,                --insert/update to NULL every p_null_varr varray element
      p_null_udt              INT                := 2,                --insert/update to NULL every p_null_udt udt element
      p_prb                   BOOLEAN            := FALSE,            --partial rollback (TRUE/FALSE)
      p_clob                  VARCHAR2           := 'EMPTY',          --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_blob                  VARCHAR2           := 'EMPTY',          --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_xml                   VARCHAR2           := NULL,             --XML location for ins/upd external XML files
      p_dbms_lob_trim         BOOLEAN            := FALSE,            --dbms_lob.trim        (TRUE/FALSE)
      p_dbms_lob_append       BOOLEAN            := FALSE,            --dbms_lob.append      (TRUE/FALSE)
      p_dbms_lob_copy         BOOLEAN            := FALSE,            --dbms_lob.copy        (TRUE/FALSE)
      p_dbms_lob_erase        BOOLEAN            := FALSE,            --dbms_lob.erase       (TRUE/FALSE)
      p_dbms_lob_writeappend  BOOLEAN            := FALSE,            --dbms_lob.writeappend (TRUE/FALSE)
      p_dbms_lob_write        BOOLEAN            := FALSE,            --dbms_lob.write       (TRUE/FALSE)
      p_ers_amt               INT                := 3200,             --lob amount to erase
      p_ers_pos               INT                := 100,              --lob position to erase
      p_trim                  INT                := 0,                --truncates the LOB to p_trim bytes
      p_writeappend           INT                := 32000,            --writes p_writeappend of data from the buffer to the end of a LOB
      p_write_amt             INT                := 30000,            --writes p_write of data to the LOB from p_write_off offset
      p_write_off             INT                := 100,              --offset to writes p_writeappend of data
      p_rand_str              VARCHAR2           := 'a',              --random strings values  'a','A' alpha characters only (mixed case)
                                                                                            -- 'l','L' lower case alpha characters only
                                                                                            -- 'p','P' any printable characters
                                                                                            -- 'u','U' upper case alpha characters only
                                                                                            -- 'x','X' any alpha-numeric characters (upper)
      p_length                VARCHAR2           := 'm',              --data length (r-random, m-max)
      p_ins_flag              VARCHAR2           := 'r',              --insert flag (r-regular, d-direct)
      p_upd_flag              VARCHAR2           := 'n'               --update flag (n-update nonkey cols, k-update key cols only, a-update all cols))
   )
   IS
--============================================================================
-- NAME: 
-- PURPOSE: Build insert/update/delete
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_delete                     VARCHAR2(32767);
      l_insert                     VARCHAR2(32767);
      l_insert1                    VARCHAR2(32767);
      l_insert2                    VARCHAR2(32767);
      l_update                     VARCHAR2(32767);
      l_update1                    VARCHAR2(32767);
      l_update2                    VARCHAR2(32767);
      l_pkname                     VARCHAR2(32767);
      l_keyname                    VARCHAR2(32767);
      l_clob_name                  VARCHAR2(32767);
      l_blob_name                  VARCHAR2(32767);
      l_clob_blob_name             VARCHAR2(32767);
      l_clob_into                  VARCHAR2(32767);
      l_blob_into                  VARCHAR2(32767);
      l_clob_blob_into             VARCHAR2(32767);
      l_clob                       VARCHAR2 (100) := UPPER (p_clob);
      l_blob                       VARCHAR2 (100) := UPPER (p_blob);
      l_upd_flag                   VARCHAR2 (1)   := UPPER (p_upd_flag);
      l_ins_flag                   VARCHAR2 (1)   := UPPER (p_ins_flag);
      l_length                     VARCHAR2 (1)   := UPPER (p_length);
      l_rand_str                   VARCHAR2 (1)   := UPPER (p_rand_str);
      l_output                     VARCHAR2 (1)   := UPPER (g_output);
      l_rowid                      VARCHAR2 (100); 
      l_sch                        VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab                        VARCHAR2 (100) := quotes (p_tab);
      c_quote         CONSTANT     VARCHAR2 (1)   := CHR(39);
      l_null_col                   INT;
      l_cnt                        INT            := 0;
      l_loop                       INT            := 1;
      l_ins                        INT            := 0;
      l_upd                        INT            := 0;
      l_del                        INT            := 0;
      l_maxcol                     INT            := maxcolid (l_sch, p_tab);
      l_clob_cnt                   INT            := 0;
      l_blob_cnt                   INT            := 0;
      l_tab_cnt                    INT            := 1;
      l_ers_amt                    INT            := p_ers_amt; 
      l_ers_pos                    INT            := p_ers_pos;
      l_bfile                      BFILE;
      TYPE g_clob_t IS TABLE OF CLOB INDEX BY BINARY_INTEGER;
      TYPE g_blob_t IS TABLE OF BLOB INDEX BY BINARY_INTEGER;
      g_clobt                      g_clob_t;
      g_blobt                      g_blob_t;
      ins_param_not_found          EXCEPTION;
      upd_param_not_found          EXCEPTION;
      length_param_not_found       EXCEPTION;
      rand_str_param_not_found     EXCEPTION;

      TYPE storanydata       IS TABLE OF VARCHAR2 (100);
      TYPE storyminterval    IS TABLE OF VARCHAR2 (10);
      TYPE stordsinterval    IS TABLE OF VARCHAR2 (10);
      TYPE storstgeometry    IS TABLE OF VARCHAR2 (500);
      TYPE storsdogeometry   IS TABLE OF VARCHAR2 (500);

      --supported anydata types
      stor_anydata      storanydata
         := storanydata ('sys.anyData.convertNumber(15)',
                         'sys.anyData.convertNumber(NULL)',
                         'sys.anyData.convertRaw(utl_raw.cast_to_raw(''Raw test''))',
                         'sys.anyData.convertRaw(NULL)',
                         'sys.anyData.convertTimestamp(SYSTIMESTAMP)',
                         'sys.anyData.convertTimestamp(NULL)',
                         'sys.anyData.convertChar(''Char test'')',
                         'sys.anyData.convertChar(NULL)',
                         'sys.anyData.convertDate(SYSDATE)',
                         --'sys.anyData.convertDate(NULL)',
                         'sys.anyData.convertVarchar2(''Varchar2 test'')',
                         'sys.anyData.convertVarchar2(NULL)'
                         --'sys.anyData.convertCLOB(to_CLOB(''This is a long text that could be a clob''))',
                         --'sys.anyData.convertBLOB(to_BLOB(RAWTOHEX(''This is a long text that could be a blob'')))'
                        );

      --supported NUMTOYMINTERVAL types
      stor_yminterval      storyminterval
         := storyminterval ('YEAR',
                            'MONTH'
                           );

      --supported NUMTODSINTERVAL types
      stor_dsinterval      stordsinterval
         := stordsinterval ('DAY',
                            'HOUR',
                            'MINUTE',
                            'SECOND'
                           );

      --supported ST_GEOMETRY types
      stor_stgeometry      storstgeometry
           := storstgeometry (
                            'st_geometry (sdo_geometry (2001, null, null, sdo_elem_info_array (1,1,1), sdo_ordinate_array (10,5)))', --Point
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,10, 20,10)))', --Line segment
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (10,15, 15,20, 20,15)))', --Arc segment
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,25, 20,30, 25,25, 30,30)))', --Line string
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (10,35, 15,40, 20,35, 25,30, 30,35)))', --Arc string
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,4,3, 1,2,1, 3,2,2, 7,2,1), sdo_ordinate_array (10,45, 20,45, 23,48, 20,51, 10,51)))', --Compound line string
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,55, 15,55, 20,60, 10,60, 10,55)))', --Closed line string
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (15,65, 10,68, 15,70, 20,68, 15,65)))', --Closed arc string
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,4,2, 1,2,1, 7,2,2), sdo_ordinate_array (10,78, 10,75, 20,75, 20,78, 15,80, 10,78)))', --Closed mixed line
                            'st_geometry (sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,85, 20,90, 20,85, 10,90, 10,85)))', --Self-crossing line
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,1), sdo_ordinate_array (10,105, 15,105, 20,110, 10,110, 10,105)))', --Polygon
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,2), sdo_ordinate_array (15,115, 20,118, 15,120, 10,118, 15,115)))', --Arc polygon
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1005,2, 1,2,1, 7,2,2), sdo_ordinate_array (10,128, 10,125, 20,125, 20,128, 15,130, 10,128)))', --Compound polygon
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,3), sdo_ordinate_array (10,135, 20,140)))', --Rectangle
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,4), sdo_ordinate_array (15,145, 10,150, 20,150)))', --Circle
                            'st_geometry (sdo_geometry (2005, null, null, sdo_elem_info_array (1,1,3), sdo_ordinate_array (50,5, 55,7, 60,5)))', --Point cluster
                            'st_geometry (sdo_geometry (2005, null, null, sdo_elem_info_array (1,1,1, 3,1,1, 5,1,1), sdo_ordinate_array (65,5, 70,7, 75,5)))', --Multipoint
                            'st_geometry (sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 5,2,1), sdo_ordinate_array (50,15, 55,15, 60,15, 65,15)))', --Multiline
                            'st_geometry (sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 5,2,1), sdo_ordinate_array (50,22, 60,22, 55,20, 55,25)))', --Multiline - crossing
                            'st_geometry (sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,2, 7,2,2), sdo_ordinate_array (50,35, 55,40, 60,35, 65,35, 70,30, 75,35)))', --Multiarc
                            'st_geometry (sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 9,2,1), sdo_ordinate_array (50,55, 50,60, 55,58, 50,55, 56,58, 60,55, 60,60, 56,58)))', --Multiline - closed
                            'st_geometry (sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,2, 7,2,2), sdo_ordinate_array (50,65, 50,70, 55,68, 55,68, 60,65, 60,70)))', --Multiarc - touching
                            'st_geometry (sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 11,1003,3), sdo_ordinate_array (50,105, 55,105, 60,110, 50,110, 50,105, 62,108, 65,112)))', --Multipolygon - disjoint
                            'st_geometry (sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,3, 5,1003,3), sdo_ordinate_array (50,115, 55,120, 55,120, 58,122)))', --Multipolygon - touching
                            'st_geometry (sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,3, 5,1003,3), sdo_ordinate_array (50,125, 55,130, 55,128, 60,132)))', --Multipolygon - tangent * INVALID 13351
                            'st_geometry (sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 17,1003,1), sdo_ordinate_array (50,95, 55,95, 53,96, 55,97, 53,98, 55,99, 50,99, 50,95, 55,100, 55,95, 60,95, 60,100, 55,100)))', --Multipolygon - multi-touch
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,3, 5,2003,3), sdo_ordinate_array (50,135, 60,140, 51,136, 59,139)))', --Polygon with void
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,2003,3, 5,1003,3), sdo_ordinate_array (51,146, 59,149, 50,145, 60,150)))', --Polygon with void - reverse
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,1), sdo_ordinate_array (10,175, 10,165, 20,165, 15,170, 25,170, 20,165, 30,165, 30,175, 10,175)))', --Crescent (straight lines) * INVALID 13349
                            'st_geometry (sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,2), sdo_ordinate_array (14,180, 10,184, 14,188, 18,184, 14,180, 16,182, 14,184, 12,182, 14,180)))', --Crescent (arcs) * INVALID 13349
                            'st_geometry (sdo_geometry (2004, null, null, sdo_elem_info_array (1,1,1, 3,2,1, 7,1003,1), sdo_ordinate_array (10,5, 10,10, 20,10, 10,105, 15,105, 20,110, 10,110, 10,105)))', --Heterogeneous collection
                            'st_geometry (sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 11,2003,1, 31,1003,1), sdo_ordinate_array (50,168, 50,160, 55,160, 55,168, 50,168, 51,167, 54,167, 54,161, 51,161, 51,162, 52,163, 51,164, 51,165, 51,166, 51,167, 52,166, 52,162, 53,162, 53,166, 52,166)))' --Polygon+void+island touch
                           );

     --supported SDO_GEOMETRY types
      stor_sdogeometry      storsdogeometry
          := storsdogeometry (
                            'sdo_geometry (2001, null, null, sdo_elem_info_array (1,1,1), sdo_ordinate_array (10,5))', --Point
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,10, 20,10))', --Line segment
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (10,15, 15,20, 20,15))', --Arc segment
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,25, 20,30, 25,25, 30,30))', --Line string
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (10,35, 15,40, 20,35, 25,30, 30,35))', --Arc string
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,4,3, 1,2,1, 3,2,2, 7,2,1), sdo_ordinate_array (10,45, 20,45, 23,48, 20,51, 10,51))', --Compound line string
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,55, 15,55, 20,60, 10,60, 10,55))', --Closed line string
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,2), sdo_ordinate_array (15,65, 10,68, 15,70, 20,68, 15,65))', --Closed arc string
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,4,2, 1,2,1, 7,2,2), sdo_ordinate_array (10,78, 10,75, 20,75, 20,78, 15,80, 10,78))', --Closed mixed line
                            'sdo_geometry (2002, null, null, sdo_elem_info_array (1,2,1), sdo_ordinate_array (10,85, 20,90, 20,85, 10,90, 10,85))', --Self-crossing line
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,1), sdo_ordinate_array (10,105, 15,105, 20,110, 10,110, 10,105))', --Polygon
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,2), sdo_ordinate_array (15,115, 20,118, 15,120, 10,118, 15,115))', --Arc polygon
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1005,2, 1,2,1, 7,2,2), sdo_ordinate_array (10,128, 10,125, 20,125, 20,128, 15,130, 10,128))', --Compound polygon
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,3), sdo_ordinate_array (10,135, 20,140))', --Rectangle
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,4), sdo_ordinate_array (15,145, 10,150, 20,150))', --Circle
                            'sdo_geometry (2005, null, null, sdo_elem_info_array (1,1,3), sdo_ordinate_array (50,5, 55,7, 60,5))', --Point cluster
                            'sdo_geometry (2005, null, null, sdo_elem_info_array (1,1,1, 3,1,1, 5,1,1), sdo_ordinate_array (65,5, 70,7, 75,5))', --Multipoint
                            'sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 5,2,1), sdo_ordinate_array (50,15, 55,15, 60,15, 65,15))', --Multiline
                            'sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 5,2,1), sdo_ordinate_array (50,22, 60,22, 55,20, 55,25))', --Multiline - crossing
                            'sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,2, 7,2,2), sdo_ordinate_array (50,35, 55,40, 60,35, 65,35, 70,30, 75,35))', --Multiarc
                            'sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,1, 9,2,1), sdo_ordinate_array (50,55, 50,60, 55,58, 50,55, 56,58, 60,55, 60,60, 56,58))', --Multiline - closed
                            'sdo_geometry (2006, null, null, sdo_elem_info_array (1,2,2, 7,2,2), sdo_ordinate_array (50,65, 50,70, 55,68, 55,68, 60,65, 60,70))', --Multiarc - touching
                            'sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 11,1003,3), sdo_ordinate_array (50,105, 55,105, 60,110, 50,110, 50,105, 62,108, 65,112))', --Multipolygon - disjoint
                            'sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,3, 5,1003,3), sdo_ordinate_array (50,115, 55,120, 55,120, 58,122))', --Multipolygon - touching
                            'sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,3, 5,1003,3), sdo_ordinate_array (50,125, 55,130, 55,128, 60,132))', --Multipolygon - tangent * INVALID 13351
                            'sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 17,1003,1), sdo_ordinate_array (50,95, 55,95, 53,96, 55,97, 53,98, 55,99, 50,99, 50,95, 55,100, 55,95, 60,95, 60,100, 55,100))', --Multipolygon - multi-touch
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,3, 5,2003,3), sdo_ordinate_array (50,135, 60,140, 51,136, 59,139))', --Polygon with void
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,2003,3, 5,1003,3), sdo_ordinate_array (51,146, 59,149, 50,145, 60,150))', --Polygon with void - reverse
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,1), sdo_ordinate_array (10,175, 10,165, 20,165, 15,170, 25,170, 20,165, 30,165, 30,175, 10,175))', --Crescent (straight lines) * INVALID 13349
                            'sdo_geometry (2003, null, null, sdo_elem_info_array (1,1003,2), sdo_ordinate_array (14,180, 10,184, 14,188, 18,184, 14,180, 16,182, 14,184, 12,182, 14,180))', --Crescent (arcs) * INVALID 13349
                            'sdo_geometry (2004, null, null, sdo_elem_info_array (1,1,1, 3,2,1, 7,1003,1), sdo_ordinate_array (10,5, 10,10, 20,10, 10,105, 15,105, 20,110, 10,110, 10,105))', --Heterogeneous collection
                            'sdo_geometry (2007, null, null, sdo_elem_info_array (1,1003,1, 11,2003,1, 31,1003,1), sdo_ordinate_array (50,168, 50,160, 55,160, 55,168, 50,168, 51,167, 54,167, 54,161, 51,161, 51,162, 52,163, 51,164, 51,165, 51,166, 51,167, 52,166, 52,162, 53,162, 53,166, 52,166))' --Polygon+void+island touch
                           );
   BEGIN
      l_ins := p_ins;
      l_upd := p_upd;
      l_del := p_del;
      l_cnt := 0;

      gen_seed;

      IF l_ins_flag NOT IN ('D','R')
      THEN
         RAISE ins_param_not_found;
      END IF;

      IF l_upd_flag NOT IN ('N','K','A')
      THEN
         RAISE upd_param_not_found;
      END IF;

      IF l_length NOT IN ('M','R')
      THEN
         RAISE length_param_not_found;
      END IF;

      IF l_rand_str NOT IN ('A','P','L','U','X')
      THEN
         RAISE rand_str_param_not_found;
      END IF;

      LOOP
         l_cnt := l_cnt + 1;
         EXIT WHEN l_ins = 0 AND l_upd = 0 AND l_del = 0;

         BEGIN
            l_pkname         := NULL;
            l_keyname        := NULL;
            l_clob_name      := NULL;
            l_blob_name      := NULL;
            l_clob_blob_name := NULL;
            l_clob_into      := NULL;
            l_blob_into      := NULL;
            l_clob_blob_into := NULL;
            l_clob_cnt       := 0;
            l_blob_cnt       := 0;
            l_tab_cnt        := 1;
            l_insert1        := NULL;
            l_update1        := NULL;

            IF l_ins_flag = 'D'
            THEN
               --l_insert := 'insert /*+ append */ into ' || l_sch || '.' || l_tab || ' values (';
               l_insert := 'insert   /*+  append  */   into ' || l_sch || '.' || l_tab || ' values (';
            ELSIF l_ins_flag = 'R'
            THEN
               l_insert := 'insert into ' || l_sch || '.' || l_tab || ' values (';
            END IF;

            l_update1 := NULL;
            l_update := 'update ' || l_sch || '.' || l_tab || ' set ';
            l_delete := 'delete from ' || l_sch || '.' || l_tab;

            FOR rx IN
               (SELECT   all_tab_columns.data_type,
                        DECODE (l_length,
                                'R', ROUND (DBMS_RANDOM.value (1, all_tab_columns.char_length)),
                                'M', all_tab_columns.char_length
                               ) char_length,
                        DECODE (l_length,
                                'R', ROUND (DBMS_RANDOM.value (1, all_tab_columns.data_length)),
                                'M', all_tab_columns.data_length
                               ) data_length,
                        all_tab_columns.column_id, all_tab_columns.nullable,
                        '"' || all_tab_columns.column_name || '"' column_name,
                        DECODE (all_cons_columns.column_name, NULL, 0, 1) pkui,
                        NVL
                           (  RPAD ('9',
                                    DECODE (l_length,
                                            'R', ROUND (DBMS_RANDOM.value (1, all_tab_columns.data_precision)),
                                            'M', all_tab_columns.data_precision
                            ),
                                    '9'               
                                   )
                            / POWER (10, all_tab_columns.data_scale),
                            9999999999
                           ) maxval
                   FROM all_tab_columns,
                        (SELECT '"' || column_name || '"' column_name
                           FROM all_cons_columns
                          WHERE owner = l_sch
                            AND constraint_name IN
                                   (SELECT constraint_name
                                      FROM all_constraints
                                     WHERE owner = l_sch
                                       AND table_name = p_tab
                                       AND constraint_type IN  ('P', 'U'))) all_cons_columns
                  WHERE all_tab_columns.owner = l_sch
                    AND all_tab_columns.table_name = p_tab
                    AND '"' || all_tab_columns.column_name || '"' = all_cons_columns.column_name(+)
               ORDER BY all_tab_columns.column_id)
            LOOP
               IF (rx.pkui = 1)
               THEN
                  l_pkname := l_pkname || rx.column_name || ',';
               END IF;

               IF (p_null = 0)
               THEN
                  l_null_col := ROUND (dbms_random.value(1, l_maxcol));
               ELSE
                  l_null_col := p_null;
               END IF;

               IF     rx.nullable = 'Y'
                  AND MOD (rx.column_id, l_null_col) = 0
                  AND rx.data_type NOT LIKE '%LOB%'
               THEN
                  l_insert1 := l_insert1 || 'NULL,';
                  l_update1 := l_update1 || rx.column_name || ' = '|| 'NULL,';
               ELSE
                  IF (rx.data_type IN ('NUMBER', 'FLOAT', 'INTEGER', 'BINARY_FLOAT', 'BINARY_DOUBLE'))  
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || MOD(dbms_random.random,rx.maxval)||',';
                   END IF;
                     l_insert1 :=
                         l_insert1 || MOD(dbms_random.random,rx.maxval)||',';
                  ELSIF rx.data_type = 'DATE' 
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                  ELSIF rx.data_type LIKE 'TIMESTAMP%'
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || c_quote || TO_TIMESTAMP(systimestamp+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || c_quote || TO_TIMESTAMP(systimestamp+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                  ELSIF rx.data_type LIKE 'INTERVAL%' AND (rx.data_type LIKE '%YEAR%' OR rx.data_type LIKE '%MONTH%')
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        --updating NUMTOYMINTERVAL( 1-9, 'YEAR/MONTH' )
                        || c_quote || NUMTOYMINTERVAL( DBMS_RANDOM.VALUE (-999999999,999999999), ''||stor_yminterval (DBMS_RANDOM.VALUE (1, stor_yminterval.COUNT))||'' ) || c_quote ||',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        --inserting NUMTOYMINTERVAL( 1-9, 'YEAR/MONTH' )
                        || c_quote || NUMTOYMINTERVAL( DBMS_RANDOM.VALUE (-999999999,999999999), ''||stor_yminterval (DBMS_RANDOM.VALUE (1, stor_yminterval.COUNT))||'' ) || c_quote ||',';
                  ELSIF rx.data_type LIKE 'INTERVAL%' AND (rx.data_type LIKE '%DAY%' OR rx.data_type LIKE '%SECOND%')
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        --updating NUMTODSINTERVAL( 1-9, 'DAY/HOUR/MINUTE/SECOND' )
                        || c_quote || NUMTODSINTERVAL( DBMS_RANDOM.VALUE (-999999999,999999999), ''||stor_dsinterval (DBMS_RANDOM.VALUE (1, stor_dsinterval.COUNT))||'' ) || c_quote ||',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        --inserting NUMTODSINTERVAL( 1-9, 'DAY/HOUR/MINUTE/SECOND' )
                        || c_quote || NUMTODSINTERVAL( DBMS_RANDOM.VALUE (-999999999,999999999), ''||stor_dsinterval (DBMS_RANDOM.VALUE (1, stor_dsinterval.COUNT))||'' ) || c_quote ||',';
                  ELSIF (rx.data_type IN ('CHAR', 'VARCHAR2', 'VARCHAR')) 
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || c_quote || dbms_random.string(l_rand_str, rx.char_length) || c_quote || ',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || c_quote || dbms_random.string(l_rand_str, rx.char_length) || c_quote || ',';
                  ELSIF (rx.data_type IN ('NCHAR', 'NVARCHAR2'))
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || c_quote || dbms_random.string(l_rand_str, (rx.char_length)) || c_quote || ',';
                        --|| c_quote || dbms_random.string('A',(rx.char_length/3)) || c_quote || ',';
                        --|| 'N' || c_quote || dbms_random.string('A',(rx.char_length/3)) || c_quote || ',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || c_quote || dbms_random.string(l_rand_str, (rx.char_length)) || c_quote || ',';
                        --|| c_quote || dbms_random.string('A',(rx.char_length/3)) || c_quote || ',';
                        --|| 'N' || c_quote || dbms_random.string('A',(rx.data_length/3)) || c_quote || ',';
                  ELSIF (rx.data_type = 'LONG') 
                  THEN
                     l_insert1 :=
                           l_insert1
                        || c_quote || rpad(DBMS_RANDOM.STRING(l_rand_str, 10), p_long, DBMS_RANDOM.STRING(l_rand_str, 10)) || c_quote || ',';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || c_quote || rpad(DBMS_RANDOM.STRING(l_rand_str, 10), p_long, DBMS_RANDOM.STRING(l_rand_str, 10)) || c_quote || ',';
                  ELSIF (rx.data_type = 'RAW' OR rx.data_type = 'LONG RAW')
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'RAWTOHEX('|| c_quote || rpad(DBMS_RANDOM.STRING(l_rand_str, 10), rx.data_length, DBMS_RANDOM.STRING(l_rand_str, 10)) || c_quote || ')' || ',';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'RAWTOHEX('|| c_quote || rpad(DBMS_RANDOM.STRING(l_rand_str, 10), rx.data_length, DBMS_RANDOM.STRING(l_rand_str, 10)) || c_quote || ')' || ',';
                  ELSIF (rx.data_type = 'XMLTYPE') AND p_xml IS NULL
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'xmltype('||c_quote||'<?xmlversion="1.0"?><'||dbms_random.string(l_rand_str, ROUND (DBMS_RANDOM.value (1, 200)))||'/>'||c_quote||'),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'xmltype('||c_quote||'<?xmlversion="1.0"?><'||dbms_random.string(l_rand_str, ROUND (DBMS_RANDOM.value (1, 200)))||'/>'||c_quote||'),';

                  ELSIF (rx.data_type = 'XMLTYPE') AND p_xml IS NOT NULL
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkui = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkui = 0))
                      OR l_upd_flag = 'A'
                   THEN
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'XMLTYPE(bfilename(''LOB_FILES'', '''||p_xml||'''),nls_charset_id(''AL32UTF8'')),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'XMLTYPE(bfilename(''LOB_FILES'', '''||p_xml||'''),nls_charset_id(''AL32UTF8'')),';
                  ELSIF (rx.data_type = 'ROWID')
                  THEN
                     --execute immediate 'select rowidtochar(rowid) from dual' into l_rowid;
                     execute immediate 'select DBMS_ROWID.ROWID_CREATE(1, ROUND(DBMS_RANDOM.value (1, 9999)), ROUND(DBMS_RANDOM.value (1, 20)), ROUND(DBMS_RANDOM.value (1, 1000)), ROUND(DBMS_RANDOM.value (1, 20))) from dual' into l_rowid;
                     l_insert1 :=
                           l_insert1
                        || '''' || l_rowid || '''' || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || '''' || l_rowid || '''' || ',';
                  ELSIF (rx.data_type IN ('CLOB', 'NCLOB'))
                  THEN
                     l_clob_cnt := l_clob_cnt + 1;
                     IF    (l_clob = 'EMPTY') 
                     THEN
                       l_insert1 := l_insert1 || 'empty_clob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_clob(),';
                     ELSIF l_clob = 'NULL' AND rx.nullable = 'N'
                     THEN
                       l_insert1 := l_insert1 || c_quote || DBMS_RANDOM.STRING(l_rand_str, 10) || c_quote || ',';
                       l_update1 := l_update1 || rx.column_name || ' = ' || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_clob)) || c_quote || ',';
                     ELSIF l_clob = 'NULL' AND rx.nullable = 'Y'                        
                     THEN
                       l_insert1 := l_insert1 || 'NULL,';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                     ELSIF is_num(p_clob)
                     THEN
                       l_insert1 := l_insert1 || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_clob)) || c_quote || ',';
                       l_update1 := l_update1 || rx.column_name || ' = ' || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_clob)) || c_quote || ',';
                     ELSE
                       l_insert1 := l_insert1 || 'empty_clob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_clob(),';
                       IF l_clob_cnt < 2
                       THEN
                         l_clob_name := l_clob_name || rx.column_name ||',';
                         l_clob_into := l_clob_into||':clob'||l_clob_cnt||',';
                       END IF;
                     END IF;
                  ELSIF (rx.data_type = 'BLOB')
                  THEN
                     l_blob_cnt := l_blob_cnt + 1;
                     IF    (l_blob = 'EMPTY') 
                     THEN
                       l_insert1 := l_insert1 || 'empty_blob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_blob(),';
                     ELSIF l_blob = 'NULL' AND rx.nullable = 'N'
                     THEN
                       l_insert1 := l_insert1 || 'RAWTOHEX(' || c_quote || DBMS_RANDOM.STRING(l_rand_str, 10) || c_quote || ')'||',';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'RAWTOHEX(' || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_blob)) || c_quote || ')'||',';
                     ELSIF l_blob = 'NULL' and rx.nullable = 'Y'
                     THEN
                       l_insert1 := l_insert1 || 'NULL,';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                     ELSIF is_num(p_blob)
                     THEN
                       l_insert1 := l_insert1 || 'RAWTOHEX(' || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_blob)) || c_quote || ')'||',';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'RAWTOHEX(' || c_quote || DBMS_RANDOM.STRING(l_rand_str, to_number(p_blob)) || c_quote || ')' || ',';
                     ELSE
                       l_insert1 := l_insert1 || 'empty_blob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_blob(),';
                       IF l_blob_cnt < 2
                       THEN
                         l_blob_name := l_blob_name || rx.column_name ||',';
                         l_blob_into := l_blob_into||':blob'||l_blob_cnt||',';
                       END IF;
                     END IF;
                  ELSIF rx.data_type LIKE '%FILE%'
                  THEN
                     l_insert1 := l_insert1 || 'NULL,';
                     l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                  ELSIF (rx.data_type LIKE '%ANYDATA')
                  THEN
                     l_insert1 := l_insert1 || stor_anydata (DBMS_RANDOM.VALUE (1, stor_anydata.COUNT)) || ',';
                     l_update1 := l_update1 || rx.column_name || ' = ' || stor_anydata (DBMS_RANDOM.VALUE (1, stor_anydata.COUNT)) || ',';
                  ELSIF (rx.data_type LIKE 'ST_GEOMETRY')
                  THEN
                     l_insert1 := l_insert1 || stor_stgeometry (DBMS_RANDOM.VALUE (1, stor_stgeometry.COUNT)) || ',';
                     l_update1 := l_update1 || rx.column_name || ' = ' || stor_stgeometry (DBMS_RANDOM.VALUE (1, stor_stgeometry.COUNT)) || ',';
                 ELSIF (rx.data_type LIKE 'SDO_GEOMETRY')
                  THEN
                     l_insert1 := l_insert1 || stor_sdogeometry (DBMS_RANDOM.VALUE (1, stor_sdogeometry.COUNT)) || ',';
                     l_update1 := l_update1 || rx.column_name || ' = ' || stor_sdogeometry (DBMS_RANDOM.VALUE (1, stor_sdogeometry.COUNT)) || ',';
                  ELSIF (rx.data_type LIKE '%UDT%')
                  THEN
                     l_insert1 := 
                           l_insert1 
                        || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch || '.' ||rx.data_type || '(';
                     FOR rv IN (SELECT attr_no, attr_type_name, length, 
                                       NVL (  RPAD ('9', PRECISION, '9')
                                            / POWER (10, NVL (scale, 0)),
                                            9999999999
                                           ) maxval
                                  FROM all_type_attrs
                                 WHERE owner = l_sch
                                   AND type_name = rx.data_type
                              ORDER BY attr_no)
                     LOOP
                          IF MOD (rv.attr_no, p_null_udt) = 0
                          THEN
                            l_insert1 := l_insert1 || 'NULL,';
                            l_update1 := l_update1 || 'NULL,';
                          ELSE

                              IF (rv.attr_type_name IN ('NUMBER', 'FLOAT', 'INTEGER'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || MOD(dbms_random.random,rv.maxval)||',';
                                 l_update1 :=
                                       l_update1
                                    || MOD(dbms_random.random,rv.maxval)||',';
                              ELSIF (rv.attr_type_name = 'DATE')
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                 l_update1 :=
                                       l_update1
                                    || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                              ELSIF (rv.attr_type_name IN ('CHAR', 'VARCHAR2'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || c_quote || dbms_random.string(l_rand_str, rv.length) || c_quote || ',';
                                 l_update1 :=
                                       l_update1
                                    || c_quote || dbms_random.string(l_rand_str, rv.length) || c_quote || ',';
                               ELSIF (rv.attr_type_name = 'CLOB')
                               THEN
                                  l_insert1 := l_insert1 || 'empty_clob(),';
                                  l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_clob(),';
                               ELSIF (rv.attr_type_name = 'BLOB')
                               THEN
                                  l_insert1 := l_insert1 || 'empty_blob(),';
                                  l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_blob(),';
                              ELSIF (rv.attr_type_name LIKE '%UDT%')
                              THEN
                                 l_insert2 := NULL;
                                 l_update2 := NULL;

                                 l_insert1 := 
                                       l_insert1 
                                    || l_sch || '.' || rv.attr_type_name || '(';
                                 l_update1 :=
                                       l_update1
                                    || l_sch || '.' ||rv.attr_type_name || '(';
                                 FOR rv1 IN (SELECT attr_no, attr_type_name, length,
                                                   NVL (  RPAD ('9', PRECISION, '9')
                                                        / POWER (10, NVL (scale, 0)),
                                                        9999999999
                                                       ) maxval
                                              FROM all_type_attrs
                                             WHERE owner = l_sch
                                               AND type_name = rv.attr_type_name
                                          ORDER BY attr_no)
                                 LOOP
                                      IF MOD (rv1.attr_no, p_null_udt) = 0
                                      THEN
                                        l_insert2 := l_insert2 || 'NULL,';
                                        l_update2 := l_update2 || 'NULL,';
                                      ELSE
                                          IF (rv1.attr_type_name IN ('NUMBER', 'FLOAT', 'INTEGER'))
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || MOD(dbms_random.random,rv1.maxval)||',';
                                             l_update2 :=
                                                   l_update2
                                                || MOD(dbms_random.random,rv1.maxval)||','; 
                                          ELSIF (rv1.attr_type_name = 'DATE')
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                             l_update2 :=
                                                   l_update2
                                                || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                          ELSIF (rv1.attr_type_name IN ('CHAR', 'VARCHAR2'))
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || c_quote || dbms_random.string(l_rand_str, rv1.length) || c_quote || ',';
                                             l_update2 :=
                                                   l_update2
                                                || c_quote || dbms_random.string(l_rand_str, rv1.length) || c_quote || ',';
                                          ELSIF (rv1.attr_type_name = 'CLOB')
                                          THEN
                                             l_insert2 := l_insert2 || 'empty_clob(),';
                                             l_update2 := l_update2 || 'empty_clob(),';
                                          ELSIF (rv1.attr_type_name = 'BLOB')
                                          THEN
                                             l_insert2 := l_insert2 || 'empty_blob(),';
                                             l_update2 := l_update2 || 'empty_blob(),';
                                          END IF;
                                      END IF;
                                 END LOOP;
                                l_insert1 := l_insert1 || RTRIM (l_insert2, ',') || '),';
                                l_update1 := l_update1 || RTRIM (l_update2, ',') || '),';
                              END IF;
                            END IF;
                     END LOOP;
                     l_insert1 := RTRIM (l_insert1, ',') || '),';
                     l_update1 := RTRIM (l_update1, ',') || '),';
                  ELSIF (rx.data_type LIKE '%SCAL%')
                  THEN
                     l_insert1 := 
                           l_insert1 
                        || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch || '.' || rx.data_type || '(';
                     FOR rv IN (SELECT elem_type_name, length, NVL(upper_bound, p_nested_upper) upper_bound,
                                       NVL (  RPAD ('9', PRECISION, '9')
                                            / POWER (10, NVL (scale, 0)),
                                            9999999999
                                           ) maxval
                                  FROM all_coll_types
                                 WHERE owner = l_sch
                                   AND type_name = rx.data_type)
                     LOOP
                      IF p_varr_rand
                      THEN
                         l_loop := ROUND (dbms_random.value(1, rv.upper_bound));
                      ELSE
                         l_loop := rv.upper_bound;
                      END IF;

                        IF l_loop > 999
                        THEN
                           l_loop := 999;
                        END IF;

                        FOR k IN 1 .. l_loop
                        LOOP
                          IF MOD (k, p_null_varr) = 0
                          THEN
                            l_insert1 := l_insert1 || 'NULL,';
                            l_update1 := l_update1 || 'NULL,';
                          ELSE
                              IF (rv.elem_type_name IN ('NUMBER', 'FLOAT'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || MOD(dbms_random.random,rv.maxval)||',';
                                 l_update1 :=
                                       l_update1
                                    || MOD(dbms_random.random,rv.maxval)||',';
                              ELSIF (rv.elem_type_name = 'DATE')
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                 l_update1 :=
                                       l_update1
                                    || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                              ELSIF (rv.elem_type_name IN ('CHAR', 'VARCHAR2'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                   || c_quote || dbms_random.string(l_rand_str, rv.length) || c_quote || ','; 
                                 l_update1 :=
                                       l_update1
                                   || c_quote || dbms_random.string(l_rand_str, rv.length) || c_quote || ','; 
                               ELSIF (rv.elem_type_name = 'CLOB')
                               THEN
                                  l_insert1 := l_insert1 || 'empty_clob(),';
                                  l_update1 := l_update1 || 'empty_clob(),';
                               ELSIF (rv.elem_type_name = 'BLOB')
                               THEN
                                  l_insert1 := l_insert1 || 'empty_blob(),';
                                  l_update1 := l_update1 || 'empty_blob(),';
                              END IF;
                            END IF;
                        END LOOP;
                     END LOOP;
                     l_insert1 := RTRIM (l_insert1, ',') || '),';
                     l_update1 := RTRIM (l_update1, ',') || '),';
                  ELSIF (rx.data_type LIKE '%OBJ%')
                  THEN
                     l_insert1 := 
                           l_insert1 
                        || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch || '.' || rx.data_type || '(';
                     FOR rv IN (SELECT elem_type_name, NVL(upper_bound, p_nested_upper) upper_bound
                                  FROM all_coll_types
                                 WHERE owner = l_sch
                                   AND type_name = rx.data_type)
                     LOOP
                      IF p_varr_rand
                      THEN
                         l_loop := ROUND (dbms_random.value(1, rv.upper_bound));
                      ELSE
                         l_loop := rv.upper_bound;
                      END IF;

                        FOR k IN 1 .. l_loop
                        LOOP
                           l_insert2 := NULL;
                           l_update2 := NULL;

                          IF MOD (k, p_null_varr) = 0
                          THEN
                            l_insert2 := l_insert2 || l_sch || '.' || rv.elem_type_name || '()';
                            l_update2 := l_update2 || l_sch || '.' || rv.elem_type_name || '()';
                          ELSE
                            l_insert2 := l_insert2 || l_sch || '.' || rv.elem_type_name || '(';
                            l_update2 := l_update2 || l_sch || '.' || rv.elem_type_name || '(';

                              FOR rc IN
                                 (SELECT attr_type_name, length,
                                         NVL (  RPAD ('9', PRECISION, '9')
                                              / POWER (10, NVL (scale, 0)),
                                              9999999999
                                             ) maxval
                                    FROM all_type_attrs
                                   WHERE owner = l_sch
                                     AND type_name = rv.elem_type_name
                                ORDER BY attr_no)
                              LOOP
                                 IF (rc.attr_type_name IN ('NUMBER','FLOAT','DECIMAL','INTEGER','SMALLINT'))
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || MOD(dbms_random.random,rc.maxval)||',';
                                    l_update2 :=
                                          l_update2
                                       || MOD(dbms_random.random,rc.maxval)||','; 
                                 ELSIF (rc.attr_type_name = 'DATE')
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                    l_update2 :=
                                          l_update2
                                       || c_quote || TO_DATE(TRUNC(sysdate)+MOD(DBMS_RANDOM.random,100000))|| c_quote ||',';
                                 ELSIF (rc.attr_type_name IN ('CHAR', 'VARCHAR2'))
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || c_quote || dbms_random.string(l_rand_str, rc.length) || c_quote || ',';
                                    l_update2 :=
                                          l_update2
                                       || c_quote || dbms_random.string(l_rand_str, rc.length) || c_quote || ',';
                                 ELSIF (rc.attr_type_name = 'CLOB')
                                 THEN
                                    l_insert2 := l_insert2 || 'empty_clob(),';
                                    l_update2 := l_update2 || 'empty_clob(),';
                                 ELSIF (rc.attr_type_name = 'BLOB')
                                 THEN
                                    l_insert2 := l_insert2 || 'empty_blob(),';
                                    l_update2 := l_update2 || 'empty_blob(),';
                                 END IF;
                              END LOOP;

                              l_insert1 := l_insert1 || RTRIM (l_insert2, ',') || '),';
                              l_update1 := l_update1 || RTRIM (l_update2, ',') || '),';
                           END IF;
                        END LOOP;
                     END LOOP;

                     l_insert1 := RTRIM (l_insert1, ',') || '),';
                     l_update1 := RTRIM (l_update1, ',') || '),';
                 END IF;
               END IF;
            END LOOP;

            l_pkname := RTRIM (NVL(l_pkname, l_keyname), ',');
            l_clob_name := RTRIM (l_clob_name, ',');
            l_clob_into := RTRIM (l_clob_into, ',');
            l_blob_name := RTRIM (l_blob_name, ',');
            l_blob_into := RTRIM (l_blob_into, ',');
            l_clob_blob_name := LTRIM ( RTRIM ((l_clob_name || ',' || l_blob_name), ','), ',');
            l_clob_blob_into := LTRIM ( RTRIM ((l_clob_into || ',' || l_blob_into), ','), ',');

            --EXECUTE IMMEDIATE RTRIM ((l_insert || l_insert1), ',') || ')';
            --EXECUTE IMMEDIATE RTRIM ((l_update || l_update1), ',');
            IF l_ins > 0 AND l_insert1 IS NOT NULL
            THEN
               l_ins := l_ins - 1;

                   IF     l_clob_name IS NULL
                      AND l_blob_name IS NULL
                   THEN
                     run (RTRIM ((l_insert || l_insert1), ',' ) || ')');
                   ELSE
                     l_insert := RTRIM ((l_insert || l_insert1), ',') || ')' || ' returning ' || l_clob_blob_name || ' into ' || l_clob_blob_into; 
                   IF     l_clob_name IS NOT NULL
                      AND l_blob_name IS NOT NULL
                   THEN
                     EXECUTE IMMEDIATE l_insert USING OUT g_clobt(1), OUT g_blobt(1);
                     out (l_insert || '  USING OUT g_clobt(1), OUT g_blobt(1)');
                   ELSIF l_clob_name IS NOT NULL
                   THEN
                     EXECUTE IMMEDIATE l_insert USING OUT g_clobt(1);
                     out (l_insert || ' USING OUT g_clobt(1)');
                   ELSIF l_blob_name IS NOT NULL
                   THEN
                     EXECUTE IMMEDIATE l_insert USING OUT g_blobt(1);
                     out (l_insert || ' USING OUT g_blobt(1)');
                   END IF;

                   IF l_clob_name IS NOT NULL
                   THEN
                      FOR i IN g_clobt.FIRST .. g_clobt.LAST
                      LOOP
                         IF p_dbms_lob_writeappend
                         THEN
                            DBMS_LOB.writeappend (g_clobt (i), p_writeappend, RPAD ('*', p_writeappend, '*'));
                            out ('DBMS_LOB.writeappend (g_clobt (i),p_writeappend, RPAD (''*'', p_writeappend, ''*''))');
                         END IF;
                         IF p_dbms_lob_append
                         THEN
                            DBMS_LOB.append (g_clobt (i), g_clobt (i));
                            out ('DBMS_LOB.append (g_clobt (i), g_clobt (i))');
                         END IF;
                         IF p_dbms_lob_trim
                         THEN
                            DBMS_LOB.TRIM (g_clobt (i), p_trim);
                            out ('DBMS_LOB.TRIM (g_clobt (i), p_trim)');
                         END IF;
                         dbms_lob_loadfromfile (p_clob, g_clobt (i));
                         out ('dbms_lob_loadfromfile (p_clob, g_clobt (i))');
                      END LOOP;
                   END IF;

                   IF l_blob_name IS NOT NULL
                   THEN
                      FOR i IN g_blobt.FIRST .. g_blobt.LAST
                      LOOP
                         IF p_dbms_lob_writeappend
                         THEN
                            DBMS_LOB.writeappend (g_blobt (i), p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*')));
                            out ('DBMS_LOB.writeappend (g_blobt (i), p_writeappend, UTL_RAW.cast_to_raw (RPAD (''*'', p_writeappend, ''*'')))');
                         END IF;
                         IF p_dbms_lob_append
                         THEN
                            DBMS_LOB.append (g_blobt (i), g_blobt (i));
                            out ('DBMS_LOB.append (g_blobt (i), g_blobt (i))');
                         END IF;
                         IF p_dbms_lob_trim
                         THEN
                            DBMS_LOB.TRIM (g_blobt (i), p_trim);
                            out ('DBMS_LOB.TRIM (g_blobt (i), p_trim)');
                         END IF;
                         dbms_lob_loadfromfile (p_blob, g_blobt (i));
                         out ('dbms_lob_loadfromfile (p_blob, g_blobt (i))');
                      END LOOP;
                   END IF;

                 END IF;

             ELSE
               l_ins := 0;
             END IF;

            --due to ORACLE bug#7006959 need to commit every transaction for DLOAD to avoid ORA-12838: cannot read/modify an object after modifying it in parallel
            IF p_ins_flag = 'd' and oraver = 11 and oraver = 12
            THEN
               --putline ('commit;');
               COMMIT;
            END IF;

            IF p_prb
            THEN
               --putline ('savepoint sp;');
               SAVEPOINT sp;
            END IF;

            IF l_upd > 0 AND l_update1 IS NOT NULL
            THEN
               l_upd := l_upd - 1;
               EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || l_sch || '.' || l_tab INTO l_tab_cnt;
                  IF l_tab_cnt > 0
                  THEN
                    l_tab_cnt := ROUND(dbms_random.value(1,l_tab_cnt));
                  END IF;

                   IF     l_clob_name IS NULL
                      AND l_blob_name IS NULL
                   THEN
                          run   (RTRIM ((l_update
                              || l_update1), ',')
                              || ' where ('
                              || l_pkname
                              || ') in (SELECT '
                              || l_pkname
                              || ' FROM (SELECT '
                              || l_pkname
                              || ', ROWNUM AS RROW FROM '
                              || l_sch
                              || '.'
                              || l_tab
                              || ') WHERE RROW = '
                              || l_tab_cnt
                              || ')');
                  ELSE
                     l_update := RTRIM ((l_update 
                              || l_update1), ',')
                              || ' where ('
                              || l_pkname
                              || ') in (SELECT '
                              || l_pkname
                              || ' FROM (SELECT '
                              || l_pkname
                              || ', ROWNUM AS RROW FROM '
                              || l_sch
                              || '.'
                              || l_tab
                              || ') WHERE RROW = '
                              || l_tab_cnt
                              || ')'
                              || ' returning ' 
                              || l_clob_blob_name 
                              || ' into ' 
                              || l_clob_blob_into;

                     IF     l_clob_name IS NOT NULL
                         AND l_blob_name IS NOT NULL
                     THEN
                         out (l_update || ' USING OUT g_clobt(1), OUT g_blobt(1)');
                         EXECUTE IMMEDIATE l_update USING OUT g_clobt(1), OUT g_blobt(1); 
                     ELSIF l_clob_name IS NOT NULL
                     THEN
                         out (l_update || ' USING OUT g_clobt(1)');
                         EXECUTE IMMEDIATE l_update USING OUT g_clobt(1);
                     ELSIF l_blob_name IS NOT NULL
                     THEN
                         out (l_update || ' USING OUT g_blobt(1)');
                         EXECUTE IMMEDIATE l_update USING OUT g_blobt(1);
                     END IF;

                     IF l_clob_name IS NOT NULL
                     THEN
                        FOR i IN g_clobt.FIRST .. g_clobt.LAST
                        LOOP
                           dbms_lob_loadfromfile (p_clob, g_clobt (i));
                           out ('dbms_lob_loadfromfile (p_clob, g_clobt (i))');
                           IF p_dbms_lob_write
                           THEN
                              DBMS_LOB.WRITE (g_clobt (i), p_write_amt, p_write_off, RPAD ('*', p_write_amt, '*'));
                              out ('DBMS_LOB.WRITE (g_clobt (i), p_write_amt, p_write_off, RPAD (''*'', p_write_amt, ''*''))');
                           END IF;
                           IF p_dbms_lob_append
                           THEN
                              DBMS_LOB.append (g_clobt (i), g_clobt (i));
                              out ('DBMS_LOB.append (g_clobt (i), g_clobt (i))');
                           END IF;
                           IF p_dbms_lob_erase
                           THEN
                              DBMS_LOB.ERASE (g_clobt (i), l_ers_amt, l_ers_pos);
                              out ('DBMS_LOB.ERASE (g_clobt (i), l_ers_amt, l_ers_pos)');
                           END IF;
                           IF p_dbms_lob_copy
                           THEN
                              DBMS_LOB.COPY (g_clobt (i), l_clob_name, DBMS_LOB.getlength (l_clob_name));
                              out ('DBMS_LOB.COPY (g_clobt (i), l_clob_name, DBMS_LOB.getlength (l_clob_name))');
                           END IF;
                           IF p_dbms_lob_writeappend
                           THEN
                              DBMS_LOB.writeappend (g_clobt (i), p_writeappend, RPAD ('*', p_writeappend, '*'));
                              out ('DBMS_LOB.writeappend (g_clobt (i), p_writeappend, RPAD (''*'', p_writeappend, ''*''))');
                           END IF;
                           IF p_dbms_lob_trim
                           THEN
                              DBMS_LOB.TRIM (g_clobt (i), p_trim);
                              out ('DBMS_LOB.TRIM (g_clobt (i), p_trim)');
                           END IF;
                           --dbms_lob_loadfromfile (p_clob, g_clobt (i));
                           --out ('dbms_lob_loadfromfile (p_clob, g_clobt (i))');
                        END LOOP;
                     END IF;

                     IF l_blob_name IS NOT NULL
                     THEN
                        FOR i IN g_blobt.FIRST .. g_blobt.LAST
                        LOOP
                           dbms_lob_loadfromfile (p_blob, g_blobt (i));
                           out ('dbms_lob_loadfromfile (p_blob, g_blobt (i))');
                           IF p_dbms_lob_write
                           THEN
                              DBMS_LOB.WRITE (g_blobt (i), p_write_amt, p_write_off, UTL_RAW.cast_to_raw (RPAD ('*', p_write_amt, '*')));
                              out ('DBMS_LOB.WRITE (g_blobt (i), p_write_amt, p_write_off, UTL_RAW.cast_to_raw (RPAD (''*'', p_write_amt, ''*'')))');
                           END IF;
                           IF p_dbms_lob_append
                           THEN
                              DBMS_LOB.append (g_blobt (i), g_blobt (i));
                              out ('DBMS_LOB.append (g_blobt (i), g_blobt (i))');
                           END IF;
                           IF p_dbms_lob_erase
                           THEN
                              DBMS_LOB.ERASE (g_blobt (i), l_ers_amt, l_ers_pos);
                              out ('DBMS_LOB.ERASE (g_blobt (i), l_ers_amt, l_ers_pos)');
                           END IF;
                           IF p_dbms_lob_copy
                           THEN
                              DBMS_LOB.COPY (g_blobt (i), g_blobt (i), DBMS_LOB.getlength (l_blob_name));
                              out ('DBMS_LOB.COPY (g_blobt (i), g_blobt (i), DBMS_LOB.getlength (l_blob_name))');
                           END IF;
                           IF p_dbms_lob_writeappend
                           THEN
                              DBMS_LOB.writeappend (g_blobt (i), p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*')));
                              out ('DBMS_LOB.writeappend (g_blobt (i), p_writeappend, UTL_RAW.cast_to_raw (RPAD (''*'', p_writeappend, ''*'')))');
                           END IF;
                           IF p_dbms_lob_trim
                           THEN
                              DBMS_LOB.TRIM (g_blobt (i), p_trim);
                              out ('DBMS_LOB.TRIM (g_blobt (i), p_trim)');
                           END IF;
                           --dbms_lob_loadfromfile (p_blob, g_blobt (i));
                           --out ('dbms_lob_loadfromfile (p_blob, g_blobt (i))');
                        END LOOP;
                     END IF;

               END IF;
             ELSE
              --l_upd := l_upd - 1;
              l_upd := 0;
             END IF;

            IF l_del > 0
            THEN
               l_del := l_del - 1;
               run (l_delete
                   || ' where ('
                   || l_pkname
                   || ') in (SELECT '
                   || l_pkname
                   || ' FROM (SELECT '
                   || l_pkname
                   || ', ROWNUM AS RROW FROM '
                   || l_sch  
                   || '.'  
                   || l_tab
                   || ') WHERE RROW = '
                   || l_tab_cnt
                   || ')');
            END IF;

            --sleep time
            sleep(p_sleep);

            IF (MOD (l_cnt, p_com) = 0) 
            THEN
               --putline ('commit;');
               COMMIT;
            ELSIF (MOD (l_cnt, p_rol) = 0)
            THEN
               IF p_prb
               THEN
                  --putline ('rollback to sp;');
                  --ROLLBACK TO sp;
                  NULL;
               ELSE
                  --putline ('rollback;');
                  ROLLBACK;
               END IF;
            ELSIF (MOD (l_cnt, p_noth) = 0)
            THEN
               --putline ('null;');
               NULL;
            END IF;
         EXCEPTION
            WHEN OTHERS
            THEN

/*
               IF p_ins > 0
               THEN
                  out (RTRIM ((l_insert || l_insert1), ',' ) || ')');
               END IF;

               IF p_upd > 0
               THEN
                 out
                 (
                  RTRIM ((l_update || l_update1), ',')
                  || ' where ('
                  || l_pkname
                  || ') in (SELECT '
                  || l_pkname
                  || ' FROM (SELECT '
                  || l_pkname
                  || ', ROWNUM AS RROW FROM '
                  || l_sch                                       
                  || '.'                                       
                  || l_tab
                  || ') WHERE RROW = '
                  || l_tab_cnt
                  || ')'
                 );
               END IF;

               IF p_del > 0
               THEN
                out (l_delete
                  || ' where ('
                  || l_pkname
                  || ') in (SELECT '
                  || l_pkname
                  || ' FROM (SELECT '
                  || l_pkname
                  || ', ROWNUM AS RROW FROM '
                  || l_sch
                  || '.'
                  || l_tab
                  || ') WHERE RROW = '
                  || l_tab_cnt
                  || ')'
                 );
               END IF;
*/

                  DBMS_OUTPUT.put_line ('Skipped -> 1 record '
                  || l_sch
                  || '.'
                  || l_tab   
                  || ' '
                  || 'Bad row index = '
                  || NVL((l_ins+1), (l_upd+1))
                  || ' '
                  || REPLACE(SQLERRM, 'ORA')
                 );
         END;
      END LOOP;

     IF p_com <> 0
     THEN
         --putline ('commit;');
         COMMIT;
     END IF;

  IF l_output = 'S'
  THEN
                       out (   'Execute -> '
                            || l_sch
                            || '.'
                            || RPAD (l_tab, 33)
                            || ' I/U/D '
                            || TO_CHAR (p_ins)
                            || '/'
                            || TO_CHAR (p_upd)
                            || '/'
                            || TO_CHAR (p_del)
                            || ' C/R/N '
                            || TO_CHAR (p_com)
                            || '/'
                            || TO_CHAR (p_rol)
                            || '/'
                            || TO_CHAR (p_noth)
                            || ' If/Uf/CLOB/BLOB '
                            || l_ins_flag
                            || '/'
                            || l_upd_flag
                            || '/'
                            || l_clob
                            || '/'
                            || l_blob
                           );
    ELSE
      DBMS_OUTPUT.put_line (   'Execute -> '
                            || l_sch
                            || '.'
                            || RPAD (l_tab, 33)
                            || ' I/U/D '
                            || TO_CHAR (p_ins)
                            || '/'
                            || TO_CHAR (p_upd)
                            || '/'
                            || TO_CHAR (p_del)
                            || ' C/R/N '
                            || TO_CHAR (p_com)
                            || '/'
                            || TO_CHAR (p_rol)
                            || '/'
                            || TO_CHAR (p_noth)
                            || ' If/Uf/CLOB/BLOB '
                            || l_ins_flag
                            || '/'
                            || l_upd_flag
                            || '/'
                            || l_clob
                            || '/'
                            || l_blob
                           );
    END IF;

         EXCEPTION
            WHEN ins_param_not_found
            THEN
               --
               -- Invalid p_ins_flag flag.
               --
               DBMS_OUTPUT.put_line ('Warning -> Invalid p_ins_flag flag - must specify D/irect/ or  R/egular/');
               help;

            WHEN upd_param_not_found
            THEN
               --
               -- Invalid p_upd_flag flag.
               --
               DBMS_OUTPUT.put_line ('Warning -> Invalid p_upd_flag flag - must specify N/onkey/, K/ey only/ or A/ll/');
               help;

            WHEN length_param_not_found
            THEN
               --
               -- Invalid p_length param.
               --
               DBMS_OUTPUT.put_line ('Warning -> Invalid p_length param - must specify M/ax/ or R/andom/');
               help;

            WHEN rand_str_param_not_found
            THEN
               --
               -- Invalid p_rand_str param.
               --
               DBMS_OUTPUT.put_line ('Warning -> Invalid p_rand_str param - must specify A/alpha characters only (mixed case)/ or P/any printable characters/ or L/lower case alpha characters only/ or U/upper case alpha characters only/ or X/any alpha-numeric characters (upper)/');
               help;
   END iud;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   FUNCTION is_col (
      p_sch         VARCHAR2 := NULL, 
      p_tab         VARCHAR2, 
      p_coltype     VARCHAR2
   )
      RETURN INTEGER
   IS
--============================================================================
-- NAME: iscol
-- PURPOSE: Is any p_coltype column
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_retval   INTEGER;
      l_sch      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
   BEGIN
      SELECT COUNT (*)
        INTO l_retval
        FROM all_tab_columns
       WHERE owner = l_sch
         AND data_type LIKE '%'||UPPER(p_coltype)||'%'
         AND table_name = p_tab;

      RETURN l_retval;
   END is_col;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE ddl (
      p_sch        VARCHAR2 := NULL, 
      p_tab        VARCHAR2, 
      p_tblsp      VARCHAR2 := 'SPLEX_DDL_ALL',
      p_ddl        VARCHAR2,
      p_col_cnt    INT      := 1,
      p_lob_clause VARCHAR2 := NULL
   )
   IS
--============================================================================
-- NAME: ddl
-- PURPOSE: Build DDL on dif columns
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sql                      VARCHAR2(32767);
      l_sch                      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab                      VARCHAR2 (100) := quotes (p_tab);
      l_tblsp                    VARCHAR2 (100) := p_tblsp;
      l_ddl                      VARCHAR2 (20)  := p_ddl;
      l_maxcol                   NUMBER         := maxcolid (l_sch, p_tab);
      l_type                     VARCHAR2(200);
      l_isddl                    BOOLEAN        := TRUE;
      l_coln                     PLS_INTEGER;
      l_oraver                   INT            := oraver;
      j                          PLS_INTEGER    := 1;
      ddl_not_found              EXCEPTION;

   BEGIN

      gen_seed;

          IF UPPER (l_ddl) NOT IN
             ('ADD_LONG',
              'ADD_BFILE',
              'ADD',
              'DROP',
              'SET_UNUSED',
              'DROP_UNUSED',
              'TRUNCATE',
              'MODIFY',
              'MODIFY_LOB',
              'MOVE_LOB'
             )
          THEN
             RAISE ddl_not_found;
         END IF;

      FOR i IN 1 .. p_col_cnt
      LOOP
         BEGIN
           l_isddl := TRUE;
             IF UPPER(l_ddl) IN ('ADD','ADD_LONG','ADD_BFILE')
             THEN
               l_coln := GREATEST((l_maxcol + j), 0);
             ELSE
               l_coln := GREATEST((l_maxcol + i - p_col_cnt), 0);
             END IF;
            --add long column
            IF UPPER(l_ddl) = 'ADD_LONG'
            THEN
             IF l_oraver = 11 OR l_oraver = 12
             THEN
                DBMS_OUTPUT.put_line ('Warning -> disable ADD LONG column on 11g/12c');
             ELSIF is_col(l_sch, p_tab, 'LONG') = 0
             THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch   
                   || '.'   
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || l_coln
                   || ' long';
              ELSE
                DBMS_OUTPUT.put_line ('Warning -> a table may contain only one column of type LONG');
                --EXIT;
              END IF;
            --move LOB column
            ELSIF UPPER(l_ddl) = 'MOVE_LOB' 
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' MOVE LOB'
                   || '('
                   || g_col_name
                   || l_coln
                   || ')'
                   || ' STORE AS '
                   || quotes (SUBSTR (g_col_name
                   || l_coln
                   || '_'
                   || p_tab, 1, 30))
                   || p_lob_clause;
            --modify LOB column
            ELSIF UPPER(l_ddl) = 'MODIFY_LOB'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' MODIFY LOB'
                   || '('
                   || g_col_name
                   || l_coln
                   || ') '
                   || p_lob_clause;
            --add bfile column
            ELSIF UPPER(l_ddl) = 'ADD_BFILE'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || l_coln
                   || ' bfile';
            --add random p_col_cnt number of columns with random size from the stortab list
            ELSIF UPPER(l_ddl) = 'ADD'
            THEN
             l_type := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));
             IF ( instr( l_type, '|' ) > 0 )
             THEN
               IF UPPER(substr( l_type, 1, instr( l_type, '|' ) - 6 )) = 'SECUREFILE'
               THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || l_coln
                   || ' '
                   || substr( l_type, instr( l_type, '_' ) + 1, 4 )
                   || ' LOB ('
                   || g_col_name
                   || l_coln
                   || ') STORE AS SECUREFILE ('
                   || substr( l_type, instr( l_type, '|' ) + 1 )
                   || ')';
               ELSIF UPPER(substr( l_type, 1, instr( l_type, '|' ) - 1 )) = 'XMLTYPE'
               THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' ADD ('
                   || g_col_name
                   || l_coln
                   || ' XMLTYPE)'
                   || ' XMLTYPE '
                   || g_col_name
                   || l_coln
                   || ' STORE AS '
                   || UPPER(substr( l_type, instr( l_type, '|' ) + 1 ));
               ELSE
                l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || l_coln
                   || ' '
                   || substr( l_type, 1, instr( l_type, '|' ) - 1 )
                   || '('
                   || ROUND (DBMS_RANDOM.VALUE (1, substr( l_type, instr( l_type, '|' ) + 1 )))
                   || ')';
               END IF;
              ELSE
                l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || l_coln
                   || ' '
                   || l_type;
              END IF;
            --drop last p_col_cnt columns
            ELSIF UPPER(l_ddl) = 'DROP'
            THEN
/*
             IF is_basic_compr (l_tblsp, l_sch, p_tab)
             THEN
               l_ddl := 'SET_UNUSED';
               l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' SET UNUSED '
                   || '('
                   || g_col_name
                   || l_coln
                   || ')';
              ELSE
               IF l_oraver = 11 OR l_oraver = 12
               THEN
                --11g introduces a parameter ddl_lock_timeout.
                --This parameter controls how many seconds,DDL statement must wait before timing out
                execute immediate 'alter session set ddl_lock_timeout=1800';
               END IF;
*/
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' DROP COLUMN '
                   || g_col_name
                   || l_coln;
--              END IF;
            --set unused last p_col_cnt columns
            ELSIF UPPER(l_ddl) = 'SET_UNUSED'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' SET UNUSED '
                   || '('
                   || g_col_name
                   || l_coln
                   || ')';
            --modify last p_col_cnt columns
            ELSIF UPPER(l_ddl) = 'MODIFY'
            THEN
             l_type := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));
             IF ( instr( l_type, '|' ) > 0 )
             THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' MODIFY '
                   || '('
                   || g_col_name
                   || l_coln
                   || ' '
                   || substr( l_type, 1, instr( l_type, '|' ) - 1 )
                   || '('
                   || ROUND (DBMS_RANDOM.VALUE (1, substr( l_type, instr( l_type, '|' ) + 1 )))
                   || '))';
              ELSE
               IF UPPER(l_type) <> 'XMLTYPE'
               THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' MODIFY '
                   || '('
                   || g_col_name
                   || l_coln
                   || ' '
                   || l_type
                   || ')';
               END IF;
              END IF;
            --truncate p_tab table p_col_cnt times
            ELSIF UPPER(l_ddl) = 'TRUNCATE'
            THEN
               l_sql :=
                      'TRUNCATE TABLE ' 
                   || l_sch              
                   || '.'              
                   || l_tab;
            --drop unused columns p_col_cnt times
            ELSIF UPPER(l_ddl) = 'DROP_UNUSED'
            THEN
               IF l_oraver = 11 OR l_oraver = 12
               THEN
                --11g introduces a parameter ddl_lock_timeout.
                --This parameter controls how many seconds,DDL statement must wait before timing out 
                execute immediate 'alter session set ddl_lock_timeout=1800';
               END IF;
               l_sql :=
                      'ALTER TABLE ' 
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' DROP UNUSED COLUMNS';
            END IF;
               run (NVL(l_sql,'SELECT DUMMY FROM DUAL'));
         EXCEPTION
            WHEN OTHERS
            THEN
              IF (SQLCODE = -904) THEN
               --DBMS_OUTPUT.put_line ( 'Skipped -> ' || l_sql || ' ' || REPLACE(SQLERRM, 'ORA'));
                NULL; --invalid identifier
              --ELSIF (SQLCODE = -39726) THEN
              --  NULL; --unsupported add/drop column operation on compressed tables
              ELSE
               DBMS_OUTPUT.put_line ( 'Skipped -> ' || l_sql || ' ' || REPLACE(SQLERRM, 'ORA'));
               l_isddl := FALSE;
              END IF;
         END;
           IF l_isddl
           THEN
            j := j + 1;
           END IF;
      END LOOP;
      DBMS_OUTPUT.put_line (   'Execute -> '
                            || l_sch
                            || '.'
                            || RPAD (l_tab, 33)
                            || ' DDL= '
                            || TO_CHAR (l_ddl)
                            || ' COL#= '
                            || TO_CHAR (p_col_cnt)
                           );
      EXCEPTION
         WHEN ddl_not_found
         THEN
            --
            -- DDL parameter does not exist
            --
            DBMS_OUTPUT.put_line 
          ('Warning -> invalid '||l_ddl||' DDL parameter - must specify 
           ''ADD_LONG''
          ,''ADD_BFILE''
          ,''ADD''
          ,''DROP''
          ,''SET_UNUSED''
          ,''DROP_UNUSED''
          ,''TRUNCATE''
          ,''MODIFY''
          ,''MODIFY_LOB''
          ,''MOVE_LOB'''
          );
   END ddl;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE lob (
      p_sch        VARCHAR2 := NULL,
      p_tab        VARCHAR2,
      p_ddl        VARCHAR2,
      p_lob_clause VARCHAR2 := NULL
   )
   IS
--============================================================================
-- NAME: lob
-- PURPOSE: ALTERING LOB COLUMNS
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   4/21/11    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_ddl           VARCHAR2 (20)    := UPPER (p_ddl);
   l_sch           VARCHAR2 (100)   := NVL (UPPER (p_sch), USER);
   l_tab           VARCHAR2 (100)   := quotes (p_tab);
   l_random_num    NUMBER;
   ddl_not_found   EXCEPTION;
 BEGIN
   gen_seed;

   IF l_ddl NOT IN ('MODIFY', 'MOVE')
   THEN
      RAISE ddl_not_found;
   END IF;

   execute immediate 'select floor(dbms_random.value(1,10000000000)) from dual' into l_random_num;

        FOR x IN (SELECT      'ALTER TABLE '
                         || l_sch
                         || '.'
                         || l_tab
                         || ' '
                         || l_ddl
                         || ' LOB'
                         || '('
                         || column_name
                         || ')'
                         || DECODE(l_ddl, 'MOVE', ' STORE AS ' || (SUBSTR (column_name || '_' || l_random_num, 1, 30)))
                         || ' '
                         || p_lob_clause stmt
                    FROM all_tab_columns
                   WHERE owner = l_sch
                     AND table_name = p_tab
                     AND data_type LIKE '%LOB%'
                     --AND column_name LIKE g_col_name || '%'
                ORDER BY column_id)
        LOOP
            run (x.stmt);
        END LOOP;

   DBMS_OUTPUT.put_line (   'Execute -> '
                         || l_sch
                         || '.'
                         || RPAD (l_tab, 33)
                         || ' DDL= '
                         || TO_CHAR (l_ddl)
                         || ' LOB'
                        );
 EXCEPTION
   WHEN ddl_not_found
   THEN
      --
      -- DDL parameter does not exist
      --
      DBMS_OUTPUT.put_line
                         (   'Warning -> invalid '
                          || p_ddl
                          || ' DDL parameter - must specify ''MODIFY'',''MOVE'''
                         );
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Skipped -> ' || REPLACE (SQLERRM, 'ORA'));
 END lob;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE part (
      p_sch        VARCHAR2 := NULL,
      p_tab        VARCHAR2,
      p_ptn_name   VARCHAR2 := NULL,
      p_ptn_type   VARCHAR2 := 'PARTITION',
      p_ddl        VARCHAR2,
      p_ptn_clause VARCHAR2 := NULL
   )
   IS
--============================================================================
-- NAME: part
-- PURPOSE: ALTERING PARTITION TABLES
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sql                      VARCHAR2(32767);
      l_ddl                      VARCHAR2 (20) := UPPER (p_ddl);
      l_sch                      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab                      VARCHAR2 (100) := quotes (p_tab);
      ddl_not_found              EXCEPTION;

   BEGIN

      gen_seed;

          IF l_ddl NOT IN
             ('ADD',
              'SET',
              'COALESCE',
              'SPLIT',
              'MERGE',
              'DROP',
              'RENAME',
              'EXCHANGE',
              'TRUNCATE',
              'MODIFY',
              'MOVE'
             )
          THEN
             RAISE ddl_not_found;
          END IF;

                l_sql :=
                      'ALTER TABLE '
                   || l_sch
                   || '.'
                   || l_tab
                   || ' '
                   || l_ddl
                   || ' '
                   || p_ptn_type
                   || ' '
                   || p_ptn_name
                   || ' '
                   || p_ptn_clause;

           run (l_sql);

         EXCEPTION
         WHEN ddl_not_found
         THEN
            --
            -- DDL parameter does not exist
            --
            DBMS_OUTPUT.put_line
          ('Warning -> invalid '||p_ddl||' DDL parameter - must specify ''ADD'',''SET'',''COALESCE'',''SPLIT'',''MERGE'',''DROP'',''RENAME'',''EXCHANGE'',''TRUNCATE'',''MODIFY'',''MOVE'''
          );
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ( 'Skipped -> ' || l_sql || ' ' || REPLACE(SQLERRM, 'ORA'));
         END part;


--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__

 PROCEDURE bulkdml (
      p_sch       VARCHAR2 := NULL, 
      p_tab       VARCHAR2, 
      p_ins       VARCHAR2 := 'r',
      p_rows      INT      := 1,
      p_rand_str  VARCHAR2 := 'a'
   )
   IS
--============================================================================
-- NAME: bulkdml
-- PURPOSE: Bulk Insert
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_sch      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
   l_ptab     VARCHAR2 (100) := quotes (p_tab);
   l_tab      VARCHAR2 (100)
                   := quotes ('TT' || LTRIM ((p_tab), SUBSTR (p_tab, 1, 3)));
   l_ins      VARCHAR2 (1)   := UPPER (p_ins);
   l_rand_str VARCHAR2 (1)   := UPPER (p_rand_str);
   l_insert   VARCHAR2 (100);
   l_oraver   INT            := oraver;
 BEGIN
   IF l_ins NOT IN ('D', 'R')
   THEN
      DBMS_OUTPUT.put_line
         ('Warning -> Invalid p_ins flag - must specify D/irect/ or  R/egular/'
         );
      HELP;
   ELSE
      IF is_col (l_sch, p_tab, 'LONG') = 0
      THEN
         run (   'CREATE TABLE '
              || l_sch
              || '.'
              || l_tab
              || ' AS SELECT * FROM '
              || l_sch
              || '.'
              || l_ptab
              || ' WHERE 1=0'
             );
         --set p_null to 1001 to avoid insert NULL into PK cols
         iud (p_sch            => l_sch,
              p_tab            => LTRIM (RTRIM (l_tab, '"'), '"'),
              p_ins            => p_rows,
              p_upd            => 0,
              p_del            => 0,
              p_null_varr      => 3,
              p_null_udt       => 3,
              p_nested_upper   => 20,
              p_null           => 1001,
              p_rand_str       => l_rand_str
             );

         IF l_ins = 'D'
         THEN
            l_insert := 'insert /*+ append */ into ';
         ELSIF l_ins = 'R'
         THEN
            l_insert := 'insert into ';
         END IF;

         run (   l_insert
              || l_sch
              || '.'
              || l_ptab
              || ' SELECT * FROM '
              || l_sch
              || '.'
              || l_tab
             );

         IF l_oraver = 10 OR l_oraver = 11 OR l_oraver = 12
         THEN
            run ('DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE');
         ELSE
            run ('DROP TABLE ' || l_sch || '.' || l_tab);
         END IF;
      ELSE
         DBMS_OUTPUT.put_line
                           (   'Warning -> '
                            || l_sch
                            || '.'
                            || l_tab
                            || ' Cannot bulk insert on table with LONG datatype'
                           );
      END IF;
   END IF;
 EXCEPTION
   WHEN OTHERS
   THEN
      IF l_oraver = 10 OR l_oraver = 11 OR l_oraver = 12
      THEN
         run ('DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE');
      ELSE
         run ('DROP TABLE ' || l_sch || '.' || l_tab);
      END IF;

      DBMS_OUTPUT.put_line (   'Skipped -> '
                            || l_sch
                            || '.'
                            || l_ptab
                            || ' '
                            --|| 'Bad row index = '
                            || ' '
                            || REPLACE (SQLERRM, 'ORA')
                           );
 END bulkdml;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
PROCEDURE create_tab (
   p_schname         VARCHAR2 := NULL,
   p_tabname         VARCHAR2,
   p_colname         VARCHAR2 := 'COL',
   p_colnum          INT := 10,
   p_pknum           INT := 0,
   p_start           INT := 0,
   p_varr_max        INT := 5,
   p_udt_max         INT := 5,
   p_nest_max        INT := 5,
   p_lob_max         INT := 5,
   p_lob_out         INT := 0,
   p_lob_securefile  BOOLEAN  := FALSE,
   p_column          VARCHAR2 := NULL,
   p_cr_tab          VARCHAR2 := 'CREATE TABLE',
   p_clause          VARCHAR2 := NULL
)
IS
--============================================================================
-- NAME: create_tab
-- PURPOSE: Build create table with PK
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   l_sch                    VARCHAR2 (100) := NVL (UPPER (p_schname), USER);
   l_tab                    VARCHAR2 (100) := quotes (p_tabname);
   l_sql                    VARCHAR2(32767);
   l_pklist                 VARCHAR2(32767);
   l_loblist                VARCHAR2(32767);
   l_nestlist               VARCHAR2(32767);
   l_varrlist               VARCHAR2(32767);
   l_colnum                 INT            := p_colnum;
   l_type                   VARCHAR2 (50);
   l_column                 VARCHAR2 (50);
   l_lob_store              VARCHAR2 (200);
   l_output                 VARCHAR2 (1)   := UPPER (g_output);
   l_db_block_size          INT            ;--:= blsize;
   pk_cnt                   PLS_INTEGER    := 0;
   lob_dsbl_cnt             PLS_INTEGER    := 0;
   col_cnt                  PLS_INTEGER    := 1;
   var_cnt                  PLS_INTEGER    := 1;
   udt_cnt                  PLS_INTEGER    := 1;
   nest_cnt                 PLS_INTEGER    := 1;
   lob_cnt                  PLS_INTEGER    := 1;
   long_raw_cnt             PLS_INTEGER    := 0;
   long_cnt                 PLS_INTEGER    := 0;

BEGIN
   gen_seed;
   l_sql := p_cr_tab || ' ' || l_sch || '.' || l_tab || ' (';

   --IF compression <> 'NOCOMPRESS' AND l_colnum > 250
   --THEN
   --  l_colnum := 250;
   --END IF;

   WHILE col_cnt < (l_colnum + 1)
   LOOP

      l_type := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));

      IF (INSTR (l_type, '|') > 0)
      THEN
         l_column := SUBSTR (l_type, 1, INSTR (l_type, '|') - 1);
         l_sql :=
               l_sql
            || quotes (p_colname || col_cnt)
            || ' '
            || l_column
            || '('
            || ROUND (DBMS_RANDOM.VALUE (1,
                                         SUBSTR (l_type,
                                                 INSTR (l_type, '|') + 1
                                                )
                                        )
                     )
            || ')'
            || ',';
      ELSE
         l_column := l_type;

         --max limit for scal/obj varrays, UDTs and LOBs
         WHILE ((UPPER (l_column) LIKE '%SCAL%' OR UPPER (l_column) LIKE '%OBJ%') AND p_varr_max < var_cnt) --p_varr_max limit for scal and obj varrays
           OR (UPPER (l_column) LIKE '%UDT%' AND p_udt_max < udt_cnt)     --p_udt_max limit for UDTs
           OR (UPPER (l_column) LIKE '%GEOMETRY%' AND p_udt_max < udt_cnt)     --p_udt_max limit for GEOMETRY
           OR (UPPER (l_column) LIKE '%NEST%' AND p_nest_max < nest_cnt)  --p_nest_max limit for TABLE TYPEs
           OR (UPPER (l_column) LIKE '%LOB%' AND p_lob_max < lob_cnt)     --p_lob_max limit for LOBs
           OR (UPPER (l_column) = 'LONG' AND long_cnt = 1)                --a table may contain only one column of type LONG
           OR (UPPER (l_column) = 'LONG RAW' AND long_raw_cnt = 1)        --a table may contain only one column of type LONG RAW

         LOOP
            l_column := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));

            IF (INSTR (l_column, '|') > 0)
            THEN
               l_column :=
                     SUBSTR (l_column, 1, INSTR (l_column, '|') - 1)
                  || '('
                  || ROUND (DBMS_RANDOM.VALUE (1,
                                               SUBSTR (l_column,
                                                         INSTR (l_column, '|')
                                                       + 1
                                                      )
                                              )
                           )
                  || ')';
            END IF;
         END LOOP;

         IF (UPPER (l_column) LIKE '%SCAL%' OR UPPER (l_column) LIKE '%OBJ%')
         THEN
            var_cnt := var_cnt + 1;
         ELSIF (UPPER (l_column) LIKE '%UDT%') OR (UPPER (l_column) LIKE '%GEOMETRY%')
         THEN
            udt_cnt := udt_cnt + 1;
         ELSIF (UPPER (l_column) LIKE '%NEST%')
         THEN
            nest_cnt := nest_cnt + 1;
         ELSIF (UPPER (l_column) LIKE '%LOB%')
         THEN
            lob_cnt := lob_cnt + 1; 
         ELSIF (UPPER (l_column) = 'LONG')
         THEN
            long_cnt := 1;
         ELSIF (UPPER (l_column) = 'LONG RAW')
         THEN
            long_raw_cnt := 1;
         END IF;

         l_sql := l_sql || quotes (p_colname || col_cnt) || ' ' || l_column || ',';

      END IF;

      -- remove LOB, VARRAY, LONG, LONG RAW, BFILE, URITYPE, XMLTYPE, TABLE TYPEs, ANYDATA, ST_GEOMETRY, SDO_GEOMETRY, BINARY_FLOAT, BINARY_DOUBLE and UDT cols from PK list
      -- remove ROWID, UROWID from PK list to avoid SPO OOS
      IF     pk_cnt < p_pknum
         AND col_cnt >= p_start
         AND UPPER (l_column) NOT IN ('CLOB', 'BLOB', 'NCLOB', 'NBLOB', 'BFILE', 'LONG', 'LONG RAW', 'XMLTYPE', 'URITYPE' , 'ROWID', 'UROWID' ,'BINARY_FLOAT', 'BINARY_DOUBLE', 'TIMESTAMP WITH TIME ZONE')
         AND UPPER (l_column) NOT LIKE '%SCAL%'
         AND UPPER (l_column) NOT LIKE '%OBJ%'
         AND UPPER (l_column) NOT LIKE '%UDT%'
         AND UPPER (l_column) NOT LIKE '%NEST%'
         AND UPPER (l_column) NOT LIKE '%ANYDATA%'
         AND UPPER (l_column) NOT LIKE '%GEOMETRY%'
      THEN
         l_pklist := l_pklist || quotes (p_colname || col_cnt) || ',';
         pk_cnt := pk_cnt + 1;
      END IF;

      IF UPPER (l_column) LIKE '%NEST%'
      THEN
         l_nestlist :=
               l_nestlist
            || ' NESTED TABLE '
            || quotes (p_colname || col_cnt)
            || ' STORE AS '
            || quotes (SUBSTR (p_colname
            || col_cnt
            || '_'
            || p_tabname, 1, 30))
            || ',';
      ELSIF UPPER (l_column) LIKE '%VARR%'
      THEN
         l_varrlist :=
               l_varrlist
            || ' VARRAY '
            || quotes (p_colname || col_cnt)
            || ' STORE AS LOB '
            || quotes (SUBSTR (p_colname
            || col_cnt
            || '_'
            || p_tabname, 1, 30))
            || ',';
      END IF;

      IF UPPER (l_column) IN ('CLOB', 'BLOB') AND lob_dsbl_cnt < p_lob_out
      THEN
        IF p_lob_securefile
        THEN
         l_lob_store := ') STORE AS SECUREFILE ';
        ELSE
         l_lob_store := ') STORE AS '
            || quotes (SUBSTR (p_colname
            || col_cnt
            || '_'
            || p_tabname, 1, 30));
        END IF;
         l_loblist :=
               l_loblist
            || ' LOB ('
            || quotes (p_colname || col_cnt)
            || l_lob_store
            || ' (DISABLE STORAGE IN ROW PCTVERSION 100) ';
         lob_dsbl_cnt := lob_dsbl_cnt + 1;
      END IF;

      col_cnt := col_cnt + 1;
   END LOOP;

      IF p_column IS NOT NULL
      THEN
         l_sql :=
            l_sql
         || p_column
         || ',';
      END IF;

   IF l_pklist IS NOT NULL
   THEN
      l_pklist :=
            ' CONSTRAINT '
         || quotes ('PK_' || SUBSTR(p_tabname, 1, 27))
         || ' PRIMARY KEY('
         || RTRIM (l_pklist, ',')
         || ')) ';
   ELSE
         l_sql := RTRIM (l_sql, ',') || ')';
   END IF;
 
   l_nestlist := RTRIM (l_nestlist, ',');
   l_varrlist := RTRIM (l_varrlist, ',');

   l_sql := l_sql || l_pklist || l_loblist || p_clause || ' ' || l_nestlist || l_varrlist;
   run (l_sql);
 IF l_output = 'S'
 THEN
   out ('Execute -> ' || p_cr_tab || ' ' || l_sch || '.' || l_tab );
 ELSE
   DBMS_OUTPUT.put_line ('Execute -> ' || p_cr_tab || ' ' || l_sch || '.' || l_tab );
 END IF;

 EXCEPTION
    WHEN OTHERS
    THEN
      out (l_sql);
      --putline (   'Skipped -> create table '
      putline (   'Failed -> create table '
               || l_sch
               || '.'
               || l_tab
               || SQLERRM
               --|| ' '
               --|| REPLACE(SQLERRM, 'ORA')
               );

END create_tab;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE drop_obj (
                       p_sch  VARCHAR2 := NULL,
                       p_obj  VARCHAR2,
                       p_name VARCHAR2)
   IS
--============================================================================
-- NAME: drop_obj
-- PURPOSE: Drop object
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sch        VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
   BEGIN

      run (   'DROP '
           || UPPER(p_obj)
           || ' ' || l_sch
           || '.'
           || quotes (p_name)
           );

   END drop_obj;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE drop_col (
                       p_sch     VARCHAR2,
                       p_tab     VARCHAR2,
                       p_coltype VARCHAR2)
   IS
--============================================================================
-- NAME: drop_col
-- PURPOSE: Drop column
--
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sch                VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_ptab               VARCHAR2 (100) := quotes (p_tab);
   BEGIN

      FOR x IN (SELECT      'ALTER TABLE '
                         || l_sch
                         || '.'
                         || l_ptab
                         || ' DROP COLUMN '
                         || '"'||column_name||'"' stmt
                    FROM all_tab_columns
                   WHERE owner = l_sch
                     AND table_name = p_tab
                     AND data_type LIKE '%'||UPPER(p_coltype)||'%'
                ORDER BY column_id)
      LOOP
         BEGIN
            run (x.stmt);
         END;
      END LOOP;

   END drop_col;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE exec_ddl (
                       p_ddl_string VARCHAR2,
                       p_ddl_type   VARCHAR2 := 'EXECUTE IMMEDIATE')
   IS
--============================================================================
-- NAME: exec_ddl
-- PURPOSE: Execute ddl by using
--          "p_ddl_type" ddl
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------

      l_cur_name      pls_integer default dbms_sql.open_cursor;
      l_ignore        pls_integer;

 BEGIN

   IF UPPER (p_ddl_type) NOT IN ('EXECUTE IMMEDIATE', 'DBMS_SQL.NATIVE', 'DBMS_SQL.V7')
   THEN
      DBMS_OUTPUT.put_line
         ('Warning -> DDL type does not exist ''EXECUTE IMMEDIATE'',''DBMS_SQL.NATIVE'',''DBMS_SQL.V7''');
   ELSE
      IF p_ddl_string IS NOT NULL
      THEN
         out (p_ddl_type || ' -> ' || p_ddl_string || ';');
         --EXECUTE IMMEDIATE
         IF UPPER (p_ddl_type) = 'EXECUTE IMMEDIATE'
         THEN
            EXECUTE IMMEDIATE p_ddl_string;
         --DBMS_SQL.NATIVE
         ELSIF UPPER (p_ddl_type) = 'DBMS_SQL.NATIVE'
         THEN
            DBMS_SQL.parse (l_cur_name, p_ddl_string, DBMS_SQL.native);
            l_ignore := DBMS_SQL.EXECUTE (l_cur_name);
            DBMS_SQL.close_cursor (l_cur_name);
         --DBMS_SQL.V7
         ELSIF UPPER (p_ddl_type) = 'DBMS_SQL.V7'
         THEN
            DBMS_SQL.parse (l_cur_name, p_ddl_string, DBMS_SQL.v7);
            l_ignore := DBMS_SQL.EXECUTE (l_cur_name);
            DBMS_SQL.close_cursor (l_cur_name);
         END IF;
      END IF;
   END IF;

 EXCEPTION
    WHEN OTHERS
    THEN
      --out (p_ddl_string);
      putline (   'Skipped -> '
               --|| p_ddl_string
               || ' '
               || REPLACE(SQLERRM, 'ORA')
               );

 END exec_ddl;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE help
   IS
--============================================================================
-- NAME: help
-- PURPOSE: package help
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ---------------   -------    ----------------------------------------------
-- Ilya Rubijevsky   1/22/08    Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   BEGIN
    version;
    out('> PURPOSE: To build a dml/ddl for all tables in schema with all datatypes');
    out('>');
    out('> NOTES:');
    out('> (1)');
    out('>   random_flag      (TRUE/FALSE) flag that determines whether random data should be used.');
    out('>');
    out('>   g_output (F/ile/, D/isplay/, E/xecute/, S/Execute with NO DDL short description/, R/Execute and Display/, O/Execute and File');
    out('>   g_seed seed number');
    out('>   all tables should start or equal to g_table_name');
    out('>   all DDL columns should start with  g_col_name');
    out('>');
    out('>   all supported DDL datatypes | max size:');
    out('>   ''varchar2|2000''');
    out('>   ''number|38''');
    out('>   ''date''');
    out('>   ''char|2000''');
    out('>   ''timestamp|9''');
    out('>   ''float|38''');
    out('>   ''varchar|2000''');
    out('>   ''integer''');
    out('>');
    out('>   all supported DDL types:');
    out('>    ADD_LONG     --add long column');
    out('>    ADD_BFILE    --add bfile column');
    out('>    ADD          --add random p_col_cnt number of columns with random size from the stortab list');
    out('>    DROP         --drop last p_col_cnt columns');
    out('>    SET_UNUSED   --set unused last p_col_cnt columns');
    out('>    DROP_UNUSED  --drop unused columns p_col_cnt times');
    out('>    TRUNCATE     --truncate p_tab table p_col_cnt times');
    out('>    MODIFY       --modify last p_col_cnt columns');
    out('>    MODIFY_LOB   --modify last p_col_cnt LOB columns');
    out('>    MOVE_LOB     --move last p_col_cnt LOB columns');
    out('>');
    out('> (2) Here is a sample SQL*Plus script to execute it:');
    out('>   DML:');
    out('>     BEGIN');
    out('>       qa_sql.iud');
    out('>   insert NULL into MOD(g_col_null) - a NULL value is treated as random number');
    out('>      (');
    out('>      p_sch         => ''SP_DDL'',          --schema name');
    out('>      p_tab         => ''QA_TEST'',         --table name');
    out('>      p_ins         => 10,                --insert N');
    out('>      p_upd         =>  5,                --update N');
    out('>      p_del         =>  3,                --delete N');
    out('>      p_com         =>  0,                --commit every p_com times');
    out('>      p_rol         =>  0,                --rollback every p_rol times');
    out('>      p_noth        =>  0,                --do nothing every p_noth times');
    out('>      p_null        =>  0,                --insert/update to NULL every p_null column(0-random)');
    out('>      p_sleep       =>  0,                --sleep time (in seconds))');
    out('>      p_long        =>  1000,             --max long size');
    out('>      p_nested_upper=>  20,               --upper bound for nested type');
    out('>      p_varr_rand   =>  TRUE,             --random number of varray elements (TRUE/FALSE)');
    out('>      p_null_varr   =>  2,                --insert/update to NULL every p_null_varr varray element');
    out('>      p_null_udt    =>  2,                --insert/update to NULL every p_null_udt udt element');
    out('>      p_prb         =>  FALSE,            --partial rollback (TRUE/FALSE)');
    out('>      p_clob        =>  ''clob_file_0.1m'', --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)');
    out('>      p_blob        =>  ''blob_file_0.1m'', --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)');
    out('>      p_dbms_lob_trim => FALSE,             --dbms_lob.trim  (TRUE/FALSE)');
    out('>      p_dbms_lob_erase => FALSE,            --dbms_lob.erase  (TRUE/FALSE)');
    out('>      p_dbms_lob_append => FALSE,            --dbms_lob.append  (TRUE/FALSE)');
    out('>      p_dbms_lob_copy => FALSE,            --dbms_lob.copy  (TRUE/FALSE)');
    out('>      p_dbms_lob_writeappend  => TRUE,     --dbms_lob.writeappend (TRUE/FALSE)');
    out('>      p_dbms_lob_write  => TRUE,           --dbms_lob.write (TRUE/FALSE)');
    out('>      p_ers_amt        => 3200,             --lob amount to erase');
    out('>      p_ers_pos        => 100,              --lob position to erase');
    out('>      p_trim        => 1,                  --truncates the LOB to p_trim bytes');
    out('>      p_writeappend => 32000,              --writes p_writeappend of data from the buffer to the end of a LOB');
    out('>      p_write_amt   => 30000,              --writes p_write of data to the LOB from p_write_off offset');
    out('>      p_write_off   => 100,                --offset to writes p_writeappend of data');
    out('>      p_length      =  ''m'',              --data length (r-random, m-max)');
    out('>      p_rand_str    => ''a'',              --random strings values  ''a'',''A'' alpha characters only (mixed case)');
    out('>                                                                 -- ''l'',''L'' lower case alpha characters only');
    out('>                                                                 -- ''p'',''P'' any printable characters');
    out('>                                                                 -- ''u'',''U'' upper case alpha characters only');
    out('>                                                                 -- ''x'',''X'' any alpha-numeric characters (upper)');
    out('>      p_ins_flag    =>  ''r'',              --insert flag (r-regular, d-direct)');
    out('>      p_upd_flag    =>  ''n'',              --update flag (n-update nonkey cols, k-update key cols only, a-update all cols)');
    out('>      );');
    out('>     END;');
    out('>');
    out('>   BULKDML:');
    out('>     BEGIN');
    out('>       qa_sql.bulkdml');
    out('>      (');
    out('>      p_sch      => ''SP_DDL'',   --name of the schema (default USER schema)');
    out('>      p_tab      => ''QA_TEST'',  --name of the table');
    out('>      p_ins      => ''r'',        --insert flag (r-regular, d-direct)');
    out('>      p_rows     => 10,           --number of bulk dmls');
    out('>      p_rand_str => ''a''         --random strings values  ''a'',''A'' alpha characters only (mixed case)');
    out('>                                                       -- ''l'',''L'' lower case alpha characters only');
    out('>                                                       -- ''p'',''P'' any printable characters');
    out('>                                                       -- ''u'',''U'' upper case alpha characters only');
    out('>                                                       -- ''x'',''X'' any alpha-numeric characters (upper)');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  DDL:');
    out('>     BEGIN');
    out('>       qa_sql.ddl');
    out('>      (');
    out('>      p_sch     => ''SP_DDL'',      --name of the schema (default USER schema)');
    out('>      p_tab     => rt.table_name, --name of the table');
    out('>      p_ddl     => ''drop'',        --ddl type - ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY');
    out('>      p_col_cnt => 10             --number of columns');
    out('>      p_lob_clause => ''(NOCACHE)''       --LOB clause');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  CREATE TABLE:');
    out('>     BEGIN');
    out('>       qa_sql.create_tab');
    out('>      (');
    out('>      p_schname  => ''SP_DDL'',  --name of the schema (default USER schema)');
    out('>      p_tabname  => ''qa_ilya'', --name of the table');
    out('>      p_colname  => ''C'',       --name of the column (default COL)');
    out('>      p_colnum   =>  1000,     --number of columns (default 10)');
    out('>      p_pknum    =>  32,       --number of PKs (default 0)');
    out('>      p_start    =>  3,        --start PK col number');
    out('>      p_varr_max =>  5,        --max number of VARRAY columns (default 5)');
    out('>      p_udt_max  =>  5,        --max number of UDT columns (default 5)');
    out('>      p_nest_max =>  5,        --max number of TABLE TYPEs columns (default 5)');
    out('>      p_lob_max  =>  5,        --max number of LOB columns (default 5)');
    out('>      p_lob_out         =>  0,        --number of disable storage in row LOB columns (default 0)');
    out('>      p_lob_securefile  =>  FALSE,    --LOB column in securefile tablespace (TRUE/FALSE)');
    out('>      p_column          =>  NULL      --any additional column (default NULL)');
    out('>      p_clause          =>  NULL      --any text that can be legally appended to a CREATE statement (default NULL)');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  DROP OBJECT:');
    out('>     BEGIN');
    out('>       qa_sql.drop_obj');
    out('>      (');
    out('>      p_sch  => ''SP_DDL'', --name of the schema (default USER schema)');
    out('>      p_obj  => ''TABLE'',  --object type');
    out('>      p_name => ''QA_TEST'' --object name');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  DROP COLUMN TYPE:');
    out('>     BEGIN');
    out('>       qa_sql.drop_col');
    out('>      (');
    out('>      p_sch  => ''SP_DDL'',  --name of the schema (default USER schema)');
    out('>      p_tab  => ''QA_TEST'', --table name');
    out('>      p_name => ''VARRAY''   --column type (VARRAY/LOB/BFILE/CHAR...)');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  EXECUTE DDL:');
    out('>     BEGIN');
    out('>       qa_sql.exec_ddl');
    out('>      (');
    out('>      p_ddl_string     => ''drop table qa_ilya'',  --any DDL that can be legally run');
    out('>      p_ddl_type       => ''EXECUTE IMMEDIATE''    --ddl type - ''EXECUTE IMMEDIATE''/''DBMS_SQL.NATIVE''/''DBMS_SQL.V7''');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  MOVE/MODIFY LOB columns:');
    out('>     BEGIN');
    out('>       qa_sql.lob');
    out('>      (');
    out('>      p_sch        => ''SP_DDL'',  --name of the schema (default USER schema)');
    out('>      p_tab        => ''QA_TEST'', --table name');
    out('>      p_ddl        => ''MOVE'',    --supported LOB DDLs (MOVE/MODIFY)');
    out('>      p_lob_clause =>  NULL      --any text that can be legally appended to an ALTER TABLE DDL LOB statement (default NULL)');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  IS ANY p_coltype COLUMN:');
    out('>     BEGIN');
    out('>         qa_sql.is_col');
    out('>         (');
    out('>        p_sch            => ''SP_DDL'',  --name of the schema (default USER schema)');
    out('>        p_tab            => ''QA_TEST'', --table name');
    out('>        p_coltype        => ''LONG''     --column type (LONG/LOB/NUMBER/CHAR...)');
    out('>        );');
    out('>       END;');
    out('>  MISC');
    out('>');
    out('>   ORACLE VERSION:');
    out('>     BEGIN');
    out('>       qa_sql.oraver;');
    out('>     END;');
    out('>');
    out('>   ORACLE COMPRESSION:');
    out('>     BEGIN');
    out('>       qa_sql.compression;');
    out('>     END;');
    out('>');
    out('>   CHECK IF COMPRESSION IS BASIC');
    out('>     BEGIN');
    out('>       qa_sql.is_basic_compr');
    out('>       (');
    out('>        p_tblsp      => ''SPLEX_DDL_ALL'', --tablespace (default SLPEX_DDL_ALL)');
    out('>        p_sch        => ''SP_DDL'',        --user');
    out('>        p_tab        => ''TEST''           --table name');
    out('>       );');
    out('>     END;');
    out('>');
    out('>  VERSION:');
    out('>     BEGIN');
    out('>       select qa_sql.version from dual;');
    out('>     END;');
    out('>');
    out('>  QUOTES:');
    out('>     BEGIN');
    out('>       qa_ddml.quotes(''test'')');
    out('>     END;');
    out('>');
    out('>  PRINT LINE:');
    out('>     BEGIN');
    out('>       qa_ddml.putline');
    out('>      (');
    out('>        p_str  => ''aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa''  --string can be > 255');
    out('>      );');
    out('>     END;');
    out('>');
    out('>  HELP: Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)');
    out('>     BEGIN');
    out('>       qa_sql.help;');
    out('>     END;');
 END help;

BEGIN
-------------------------------------
-- * Package Initialization Code * --
-------------------------------------
   NULL;
   --gen_seed;
END qa_sql;
/


