CREATE OR REPLACE PACKAGE qa_ddml
   AUTHID CURRENT_USER
IS
--=========================================================================================
-- Shareplex
--=========================================================================================
-- NAME: qa_ddml
--
-- PURPOSE: To build a dml/ddl for all tables in schema with all datatypes
--
-- NOTES:
-- (1) 
--   output_flag    (TRUE/FALSE) flag that determines whether output should be displayed.
--   random_flag    (TRUE/FALSE) flag that determines whether random data should be used.
--
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
--
-- (2) Here is a sample SQL*Plus script to execute it:
--   DML:
--     BEGIN
--       qa_ddml.iud
--      (
--      p_sch                   VARCHAR2           := NULL,             --schema name
--      p_tab                   VARCHAR2,                               --table name
--      p_ins                   INT                := 10,               --insert N of records
--      p_upd                   INT                := 5,                --update N of records
--      p_del                   INT                := 3,                --delete N of records
--      p_com                   INT                := 1,                --commit every p_com times(0-no commit)
--      p_rol                   INT                := 0,                --rollback every p_rol times
--      p_noth                  INT                := 0,                --do nothing every p_noth times
--      p_null                  INT                := 0,                --insert/update to NULL every p_null column(0-random)
--      p_long                  INT                := 1000,             --max long size
--      p_varr_rand             BOOLEAN            := TRUE,             --random number of varray elements (TRUE/FALSE)
--      p_null_varr             INT                := 0,                --insert/update to NULL every p_null_varr varray element(0-random)
--      p_prb                   BOOLEAN            := FALSE,            --partial rollback (TRUE/FALSE)
--      p_clob                  VARCHAR2           := 'clob_file_0.1m', --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
--      p_blob                  VARCHAR2           := 'blob_file_0.1m', --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
--      p_dbms_lob_trim         BOOLEAN            := TRUE,             --dbms_lob.trim  (TRUE/FALSE)
--      p_dbms_lob_erase        BOOLEAN            := FALSE,            --dbms_lob.erase  (TRUE/FALSE)
--      p_dbms_lob_writeappend  BOOLEAN            := TRUE,             --dbms_lob.writeappend (TRUE/FALSE)
--      p_dbms_lob_write        BOOLEAN            := TRUE,             --dbms_lob.write (TRUE/FALSE)
--      p_trim                  INT                := 0,                --truncates the LOB to p_trim bytes
--      p_writeappend           INT                := 32000,            --writes p_writeappend of data from the buffer to the end of a LOB
--      p_write_amt             INT                := 30000,            --writes p_write of data to the LOB from p_write_off offset
--      p_write_off             INT                := 100,              --offset to writes p_writeappend of data
--      p_ins_flag              VARCHAR2           := 'r',              --insert flag (r-regular, d-direct)
--      p_upd_flag              VARCHAR2           := 'n'               --update flag (n-update nonkey cols, k-update key cols only, a-update all cols))
--      );
--     END;
--
--   BULKDML:
--     BEGIN
--       qa_ddml.bulkdml
--      (
--      p_sch     => 'SP_DDL',   --name of the schema (default USER schema)
--      p_tab     => 'QA_TEST',  --name of the table
--      p_ins     => 'r',        --insert flag (r-regular, d-direct)
--      p_rows    => 10          --number of bulk dmls
--      );
--     END;
--
--  DDL:
--     BEGIN
--       qa_ddml.ddl
--      (
--      p_sch     => 'SP_DDL',      --name of the schema (default USER schema)
--      p_tab     => rt.table_name, --name of the table
--      p_ddl     => 'drop',        --ddl type - ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY
--      p_col_cnt => 10             --number of columns
--      );
--     END;
--
--  CREATE TABLE:
--     BEGIN
--       qa_ddml.create_tab
--      (
--      p_schname  => 'SP_DDL',   --name of the schema (default USER schema)
--      p_tabname  => 'qa_ilya', --name of the table 
--      p_colname  => 'C',       --name of the column (default COL)
--      p_colnum   =>  1000,     --number of columns (default 10)
--      p_pknum    =>  32,       --number of PKs (default 1)
--      p_start    =>  3,        --start PK col number (default 1)
--      p_varr_max =>  10,       --max number of VARRAY columns (default 10)
--      p_lob_out  =>  0,        --number of disable storage in row LOB columns (default 0)
--      p_clause   =>  NULL      --any text that can be legally appended to a CREATE statement (default NULL)
--      );
--     END;
--
--  DROP OBJECT:
--     BEGIN
--       qa_ddml.drop_obj
--      (
--      p_sch  => 'SP_DDL',--name of the schema (default USER schema)
--      p_obj  => 'TABLE', --object type
--      p_name => 'QA_TEST'--object name 
--      );
--     END;
--
--  DROP COLUMN TYPE:
--     BEGIN
--       qa_ddml.drop_col
--      (
--      p_sch  => 'SP_DDL',  --name of the schema (default USER schema)
--      p_tab  => 'QA_TEST', --table name
--      p_name => 'VARRAY'   --column type (VARRAY/LOB/BFILE/CHAR...)
--      );
--     END;
--
--  EXECUTE DDL:
--     BEGIN
--       qa_ddml.exec_ddl
--      (
--      p_ddl_string     => 'drop table qa_ilya',  --any DDL that can be legally run
--      p_ddl_type       => 'EXECUTE IMMEDIATE'    --ddl type - 'EXECUTE IMMEDIATE'/'DBMS_SQL.NATIVE'/'DBMS_SQL.V7'
--      );
--     END;
--
--  IS ANY p_coltype COLUMN
--     BEGIN
--       qa_ddml.is_col
--       (
--      p_sch            => 'SP_DDL',  --name of the schema (default USER schema)
--      p_tab            => 'QA_TEST', --table name
--      p_coltype        => 'LONG'     --column type (LONG/LOB/NUMBER/CHAR...)
--      );
--     END;
--
--  MISC
--
--  PRINT LINE:
--     BEGIN
--       qa_ddml.putline
--      (
--      p_str  => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'  --string can be > 255
--      );
--     END;
--
--   ORACLE VERSION:
--     BEGIN
--       qa_ddml.oraver;
--     END;
--
--  VERSION:
--     BEGIN
--       qa_ddml.version;
--     END;    
--
--  HELP: Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)
--     BEGIN
--       qa_ddml.help;
--     END;
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--  Public declarations of types, cursors, variables, exceptions
--  procedures, and functions
------------------------------------------------------------------------------

   -- Flag that determines whether output should be displayed.
   output_flag        BOOLEAN                            := FALSE;
   -- Flag that determines whether random data should be used.
   random_flag        BOOLEAN                            := TRUE;
   g_table_name       all_objects.object_name%TYPE       := 'QA';
   g_col_name         all_tab_columns.column_name%TYPE   := 'COL_ADD';
   g_seed             NUMBER                             := NULL;

   TYPE stortab IS TABLE OF VARCHAR2 (50);

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
      p_long                  INT                := 1000,             --max long size
      p_varr_rand             BOOLEAN            := TRUE,             --random number of varray elements (TRUE/FALSE)
      p_null_varr             INT                := 0,                --insert/update to NULL every p_null_varr varray element(0-random)
      p_prb                   BOOLEAN            := FALSE,            --partial rollback (TRUE/FALSE)
      p_clob                  VARCHAR2           := 'clob_file_0.1m', --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_blob                  VARCHAR2           := 'blob_file_0.1m', --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_dbms_lob_trim         BOOLEAN            := TRUE,             --dbms_lob.trim  (TRUE/FALSE)
      p_dbms_lob_erase        BOOLEAN            := FALSE,            --dbms_lob.erase  (TRUE/FALSE)
      p_dbms_lob_writeappend  BOOLEAN            := TRUE,             --dbms_lob.writeappend (TRUE/FALSE)
      p_dbms_lob_write        BOOLEAN            := TRUE,             --dbms_lob.write (TRUE/FALSE)
      p_trim                  INT                := 0,                --truncates the LOB to p_trim bytes  
      p_writeappend           INT                := 32000,            --writes p_writeappend of data from the buffer to the end of a LOB
      p_write_amt             INT                := 30000,            --writes p_write of data to the LOB from p_write_off offset
      p_write_off             INT                := 100,              --offset to writes p_writeappend of data 
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
      p_rows      INT := 1
   );

-------------------------------------
-- NAME   : ddl
-- PURPOSE: Build ddl
-- NOTES  : Supported DDLs: 
-- ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY
-------------------------------------
   PROCEDURE ddl (
      p_sch       VARCHAR2 := NULL,
      p_tab       VARCHAR2,
      p_ddl       VARCHAR2,
      p_col_cnt   INT := 1
   );

-------------------------------------
-- NAME   : create_tab
-- PURPOSE: Build create table with PK
-------------------------------------
   PROCEDURE create_tab (
      p_schname          VARCHAR2 := NULL,
      p_tabname          VARCHAR2,
      p_colname          VARCHAR2 := 'COL',
      p_colnum           INT := 10,
      p_pknum            INT := 1,
      p_start            INT := 1,
      p_varr_max         INT := 10,
      p_lob_out          INT := 0,
      p_clause           VARCHAR2 := NULL
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
-- NAME   : help
-- PURPOSE: Package help
--          Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)
-------------------------------------
   PROCEDURE help;

END qa_ddml;
/

CREATE OR REPLACE PACKAGE BODY qa_ddml
IS
--============================================================================
-- NAME: qa_ddml
--============================================================================
------------------------------------------------------------------------------
--  Private declarations of types, cursorss, variables, exceptions
--  procedures, and functions
------------------------------------------------------------------------------
   g_clob   CLOB;
   g_blob   BLOB;

   PROCEDURE version
   IS
--============================================================================
-- NAME: version
-- PURPOSE: To display version number 
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   BEGIN
      DBMS_OUTPUT.put_line ('QA_DDML Package - Version 1.0.0 - Aug 01, 2006');
   END version;

   PROCEDURE gen_seed
   IS
--============================================================================
-- NAME: gen_seed
-- PURPOSE: To generate seed for DBMS_RANDOM
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_seed1   NUMBER;
      l_seed2   NUMBER;
      l_seed    NUMBER;
   BEGIN
      SELECT USERENV ('SESSIONID')
        INTO l_seed1
        FROM DUAL;

        SELECT TO_NUMBER(TO_CHAR(SYSTIMESTAMP,'SSFF'))
        INTO l_seed2
        FROM DUAL;

      IF random_flag
      THEN
         l_seed := l_seed1 + l_seed2;
      ELSE
         l_seed := 123456789;
      END IF;

     -- DBMS_RANDOM.INITIALIZE(NVL(g_seed, l_seed));
      DBMS_RANDOM.seed (NVL(g_seed, l_seed));
      --DBMS_OUTPUT.put_line ('seed -> ' || NVL(g_seed, l_seed));
      putline ('seed -> ' || NVL(g_seed, l_seed));

-- EXCEPTION
--   WHEN NO_DATA_FOUND THEN
--     RAISE;
--   WHEN OTHERS THEN
--     RAISE;
   END gen_seed;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE putline_new (p_str VARCHAR2)
   IS
--============================================================================
-- NAME: putline_new
-- PURPOSE: extension of DBMS_OUTPUT.put_line package
--        controling by output_flag with wrapping
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_str   LONG DEFAULT p_str;
      l_instr PLS_INTEGER;

   BEGIN
    IF output_flag
    THEN
     LOOP
      EXIT WHEN l_str IS NULL;
      l_instr := INSTR(TRANSLATE(SUBSTR(l_str,1,250),chr(10)||chr(32),chr(44)||chr(44)),chr(44),-1);
      IF l_instr = 0 OR LENGTH(l_str) <= 250 THEN
         l_instr := 250;
      END IF;
      DBMS_OUTPUT.put_line(SUBSTR(l_str,1,l_instr));
      l_str := SUBSTR(l_str,l_instr+1);
     END LOOP;
    END IF;
-- EXCEPTION
--   WHEN NO_DATA_FOUND THEN
--     RAISE;
--   WHEN OTHERS THEN
--     RAISE;
   END putline_new;


--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE putline (p_str VARCHAR2)
   IS
--============================================================================
-- NAME: putline
-- PURPOSE: extension of DBMS_OUTPUT.put_line package
--        controling by output_flag no wrapping
-- NOTES:
--
-- MODIFICATION HISTORY
-- PERSON            DATE       COMMENTS
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_len   PLS_INTEGER    := 255;
      l_str   VARCHAR2 (255);
   BEGIN
      IF output_flag
      THEN
         IF LENGTH (p_str) > l_len
         THEN
            l_str := SUBSTR (p_str, 1, l_len);
            DBMS_OUTPUT.put_line (l_str);
            putline (SUBSTR (p_str, l_len + 1));
         ELSE
            l_str := p_str;
            DBMS_OUTPUT.put_line (l_str);
         END IF;
      END IF;
-- EXCEPTION
--   WHEN NO_DATA_FOUND THEN
--     RAISE;
--   WHEN OTHERS THEN
--     RAISE;
   END putline;


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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      -- Input Directory as specified in create directory
      l_dir         CONSTANT VARCHAR2(30) := 'LOB_FILES';
      l_bfile       BFILE;
      l_src_offset  INTEGER := 1;
      l_dst_offset  INTEGER := 1;
      l_lang_cont   INTEGER := DBMS_LOB.default_lang_ctx;
      l_warn_msg    INTEGER;

   BEGIN
      l_bfile := BFILENAME (l_dir, p_filename);

      IF (DBMS_LOB.fileexists (l_bfile) = 1)
      THEN
         -- If the file is already open, close the file.
         IF DBMS_LOB.FILEISOPEN(l_bfile) = 1 THEN
            DBMS_LOB.FILECLOSE(l_bfile);
         END IF ;
         -- Open the file.
         DBMS_LOB.fileopen (l_bfile);
         --DBMS_LOB.loadfromfile (p_glob, l_bfile, DBMS_LOB.getlength (l_bfile));
         DBMS_LOB.loadclobfromfile (p_glob, l_bfile, DBMS_LOB.LOBMAXSIZE, l_src_offset, l_dst_offset, NLS_CHARSET_ID ('US7ASCII'), l_lang_cont, l_warn_msg);
         -- Close the file.
         DBMS_LOB.fileclose (l_bfile);
      ELSE
        DBMS_OUTPUT.put_line ('File ' || p_filename || ' or Directory ' || l_dir || ' does not exist');
      END IF;
   EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Error:' || SQLERRM);
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      -- Input Directory as specified in create directory
      l_dir     CONSTANT VARCHAR2(30) := 'LOB_FILES';
      l_bfile   BFILE;
   BEGIN
      l_bfile := BFILENAME (l_dir, p_filename);

      IF (DBMS_LOB.fileexists (l_bfile) = 1)
      THEN
         -- If the file is already open, close the file.
         IF DBMS_LOB.FILEISOPEN(l_bfile) = 1 THEN
            DBMS_LOB.FILECLOSE(l_bfile);
         END IF ;
         -- Open the file.
         DBMS_LOB.fileopen (l_bfile);
         DBMS_LOB.loadfromfile (p_glob, l_bfile,
                                DBMS_LOB.getlength (l_bfile));
         -- Close the file.
         DBMS_LOB.fileclose (l_bfile);
      ELSE
        DBMS_OUTPUT.put_line ('File ' || p_filename || ' or Directory ' || l_dir || ' does not exist');
      END IF;
   EXCEPTION
     WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('Error:' || SQLERRM);
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_retval   INTEGER;
   BEGIN
      SELECT MAX (column_id)
        INTO l_retval
        FROM all_tab_columns
       WHERE owner = p_sch
         AND table_name = p_tab;

      RETURN l_retval;
   END maxcolid;

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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
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
      p_long                  INT                := 1000,             --max long size
      p_varr_rand             BOOLEAN            := TRUE,             --random number of varray elements (TRUE/FALSE)
      p_null_varr             INT                := 0,                --insert/update to NULL every p_null_varr varray element(0-random)
      p_prb                   BOOLEAN            := FALSE,            --partial rollback (TRUE/FALSE)
      p_clob                  VARCHAR2           := 'clob_file_0.1m', --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_blob                  VARCHAR2           := 'blob_file_0.1m', --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)
      p_dbms_lob_trim         BOOLEAN            := TRUE,             --dbms_lob.trim  (TRUE/FALSE)
      p_dbms_lob_erase        BOOLEAN            := FALSE,            --dbms_lob.erase  (TRUE/FALSE)
      p_dbms_lob_writeappend  BOOLEAN            := TRUE,             --dbms_lob.writeappend (TRUE/FALSE)
      p_dbms_lob_write        BOOLEAN            := TRUE,             --dbms_lob.write (TRUE/FALSE)
      p_trim                  INT                := 0,                --truncates the LOB to p_trim bytes
      p_writeappend           INT                := 32000,            --writes p_writeappend of data from the buffer to the end of a LOB
      p_write_amt             INT                := 30000,            --writes p_write of data to the LOB from p_write_off offset
      p_write_off             INT                := 100,              --offset to writes p_writeappend of data
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_delete                     LONG;
      l_insert                     LONG;
      l_insert1                    LONG;
      l_insert2                    LONG;
      l_update                     LONG;
      l_update1                    LONG;
      l_update2                    LONG;
      l_pkname                     LONG;
      l_keyname                    LONG;
      l_clob                       VARCHAR2 (100) := UPPER (p_clob);
      l_blob                       VARCHAR2 (100) := UPPER (p_blob);
      l_upd_flag                   VARCHAR2 (1)   := UPPER (p_upd_flag);
      l_ins_flag                   VARCHAR2 (1)   := UPPER (p_ins_flag);
      l_clob_name                  VARCHAR2 (100);
      l_blob_name                  VARCHAR2 (100);
      l_rowid                      VARCHAR2 (100); 
      l_sch                        VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab                        VARCHAR2 (100) := quotes (p_tab);
      l_null_col                   INT;
      l_cnt                        INT            := 0;
      l_loop                       INT            := 1;
      l_ins                        INT            := 0;
      l_upd                        INT            := 0;
      l_del                        INT            := 0;
      l_maxcol                     INT            := maxcolid (l_sch, p_tab);
      l_blob_cnt                   INT            := 0;
      l_clob_cnt                   INT            := 0;
      l_tab_cnt                    INT            := 1;
      l_lob_amt                    INT            := 3200; --32000; 
      l_lob_pos                    INT            := 100;
      l_bfile                      BFILE;
      unique_constraint_violated   EXCEPTION;
      PRAGMA EXCEPTION_INIT (unique_constraint_violated, -00001);
      updating_partition_key       EXCEPTION;
      PRAGMA EXCEPTION_INIT (updating_partition_key, -14402);
      check_constraint_violated   EXCEPTION;
      PRAGMA EXCEPTION_INIT (check_constraint_violated, -02290);
   BEGIN
      l_ins := p_ins;
      l_upd := p_upd;
      l_del := p_del;
      l_cnt := 0;

      gen_seed;

      LOOP
         l_cnt := l_cnt + 1;
         EXIT WHEN l_ins = 0 AND l_upd = 0 AND l_del = 0;

         BEGIN
            l_pkname   := NULL;
            l_keyname  := NULL;
            l_clob_name := NULL;
            l_blob_name := NULL;
            l_clob_cnt := 0;
            l_blob_cnt := 0;
            l_tab_cnt := 1;
            l_insert1 := NULL;
            l_update1 := NULL;

          IF l_ins_flag NOT IN ('D','R')
          THEN
             DBMS_OUTPUT.put_line ('Warning -> Invalid p_ins_flag flag - must specify D/irect/ or  R/egular/');
             help;
             EXIT;
          END IF;

          IF l_upd_flag NOT IN ('N','K','A')
          THEN
             DBMS_OUTPUT.put_line ('Warning -> Invalid p_upd_flag flag - must specify N/onkey/, K/ey only/ or A/ll/');
             help;
             EXIT;
          END IF;

            IF l_ins_flag = 'D'
            THEN
               l_insert := 'insert /*+ append */ into ' || l_sch || '.' || l_tab || ' values (';
            ELSIF l_ins_flag = 'R'
            THEN
               l_insert := 'insert into ' || l_sch || '.' || l_tab || ' values (';
            END IF;

            l_update1 := NULL;
            l_update := 'update ' || l_sch || '.' || l_tab || ' set ';
            l_delete := 'delete from ' || l_sch || '.' || l_tab;

            FOR rx IN
               (SELECT  all_tab_columns.data_type, all_tab_columns.data_length,
                        all_tab_columns.column_id, all_tab_columns.nullable,
                        '"' || all_tab_columns.column_name || '"' column_name,
                        DECODE (all_cons_columns.column_name, NULL, 0, 1) pkcol,
                        NVL(RPAD('9',all_tab_columns.data_precision,'9')/POWER(10,all_tab_columns.data_scale),9999999999) maxval
                   FROM all_tab_columns,
                        (SELECT '"' || column_name || '"' column_name
                           FROM all_cons_columns
                          WHERE owner = l_sch
                            AND constraint_name =
                                   (SELECT constraint_name
                                      FROM all_constraints
                                     WHERE owner = l_sch
                                       AND table_name = p_tab
                                       AND constraint_type = 'P')) all_cons_columns
                  WHERE all_tab_columns.owner = l_sch
                    AND all_tab_columns.table_name = p_tab
                    AND '"' || all_tab_columns.column_name || '"' = all_cons_columns.column_name(+)
               ORDER BY all_tab_columns.column_id)
            LOOP
               IF (rx.pkcol = 1)
               THEN
                  l_pkname := l_pkname || rx.column_name || ',';
               END IF;

               IF (p_null = 0)
               THEN
                  l_null_col := FLOOR(dbms_random.value(1, l_maxcol));
               ELSE
                  l_null_col := p_null;
               END IF;

               IF     rx.nullable = 'Y'
                  AND MOD (rx.column_id, l_null_col) = 0
                  --AND rx.data_type NOT LIKE '%SCAL%'
                  --AND rx.data_type NOT LIKE '%OBJ%'
                  AND rx.data_type NOT LIKE '%LOB%'
               THEN
                  l_insert1 := l_insert1 || 'NULL,';
                  l_update1 := l_update1 || rx.column_name || ' = '|| 'NULL,';
               ELSE
                  IF (rx.data_type IN ('NUMBER', 'FLOAT', 'INTEGER'))  
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'dbms_random.value(1,'
                        || rx.maxval
                        || '),';
                   END IF;
                     l_insert1 :=
                        l_insert1 || 'dbms_random.value(1,' || rx.maxval
                        || '),';
                  ELSIF rx.data_type = 'DATE' 
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'trunc(sysdate)+dbms_random.value+dbms_random.value(1,1000),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'trunc(sysdate)+dbms_random.value+dbms_random.value(1,1000),';
                  ELSIF rx.data_type LIKE 'TIMESTAMP%'
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'trunc(systimestamp)+dbms_random.value+dbms_random.value(1,1000),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'trunc(systimestamp)+dbms_random.value+dbms_random.value(1,1000),';
                  ELSIF (rx.data_type IN ('CHAR', 'VARCHAR2', 'VARCHAR')) 
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'dbms_random.string(''A'','
                        || rx.data_length
                        || '),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'dbms_random.string(''A'','
                        || rx.data_length
                        || '),';
                  ELSIF (rx.data_type = 'LONG') 
                  THEN
                     l_insert1 :=
                           l_insert1
                        || 'rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || p_long
                        || ',DBMS_RANDOM.STRING(''A'',10)),';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || p_long
                        || ',DBMS_RANDOM.STRING(''A'',10)),';
                  ELSIF (rx.data_type = 'RAW' OR rx.data_type = 'LONG RAW')
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'RAWTOHEX(rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || rx.data_length
                        || ',DBMS_RANDOM.STRING(''A'',10))),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'RAWTOHEX(rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || rx.data_length
                        || ',DBMS_RANDOM.STRING(''A'',10))),';
                  ELSIF (rx.data_type = 'XMLTYPE')
                  THEN
                   IF    (l_upd_flag = 'K' AND (rx.pkcol = 1))
                      OR (l_upd_flag = 'N' AND (rx.pkcol = 0))
                      OR l_upd_flag = 'A'
                   THEN
                     l_keyname := l_keyname || rx.column_name || ',';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'xmltype(''<?xmlversion="1.0"?><dummy/>''),';
                   END IF;
                     l_insert1 :=
                           l_insert1
                        || 'xmltype(''<?xmlversion="1.0"?><dummy/>''),';
                  ELSIF (rx.data_type = 'ROWID')
                  THEN
                     execute immediate 'select rowidtochar(rowid) from dual' into l_rowid;
                     l_insert1 :=
                           l_insert1
                        || ''''
                        || l_rowid
                        || ''''
                        || ',';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || ''''
                        || l_rowid
                        || ''''
                        || ',';
                  ELSIF (rx.data_type = 'CLOB')
                  THEN
                     IF l_clob_cnt = 0
                     THEN
                        l_clob_name := rx.column_name;
                        l_clob_cnt := 1;
                     END IF;
                     IF    (l_clob = 'EMPTY') 
                        OR (l_clob = 'NULL' AND rx.nullable = 'N') 
                        OR (NOT is_num(p_clob)) 
                     THEN
                       l_insert1 := l_insert1 || 'empty_clob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_clob(),';
                     ELSIF l_clob = 'NULL' AND rx.nullable = 'Y'                        
                     THEN
                       l_insert1 := l_insert1 || 'NULL,';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                     ELSIF is_num(p_clob)
                     THEN
                       l_insert1 :=
                           l_insert1
                        || 'rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || to_number(p_clob)
                        || ',DBMS_RANDOM.STRING(''A'',10)),';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || to_number(p_clob)
                        || ',DBMS_RANDOM.STRING(''A'',10)),';
                     END IF;
                  ELSIF (rx.data_type = 'BLOB')
                  THEN
                     IF l_blob_cnt = 0
                     THEN
                        l_blob_name := rx.column_name;
                        l_blob_cnt := 1;
                     END IF;
                     IF    (l_blob = 'EMPTY') 
                        OR (l_blob = 'NULL' AND rx.nullable = 'N')
                        OR (NOT is_num(p_blob))
                     THEN
                       l_insert1 := l_insert1 || 'empty_blob(),';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'empty_blob(),';
                     ELSIF l_blob = 'NULL' and rx.nullable = 'Y'
                     THEN
                       l_insert1 := l_insert1 || 'NULL,';
                       l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                     ELSIF is_num(p_blob)
                     THEN
                       l_insert1 :=
                           l_insert1
                        || 'RAWTOHEX(rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || to_number(p_blob)
                        || ',DBMS_RANDOM.STRING(''A'',10))),';
                       l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || 'RAWTOHEX(rpad(DBMS_RANDOM.STRING(''A'',10),'
                        || to_number(p_blob)
                        || ',DBMS_RANDOM.STRING(''A'',10))),';
                     END IF;
                  ELSIF rx.data_type LIKE '%FILE%'
                  THEN
                     l_insert1 := l_insert1 || 'NULL,';
                     l_update1 := l_update1 || rx.column_name || ' = ' || 'NULL,';
                  ELSIF (rx.data_type LIKE '%UDT%')
                  THEN
                     l_insert1 := l_insert1 || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch
                        || '.'
                        ||rx.data_type
                        || '(';
                     FOR rv IN (SELECT attr_type_name, LENGTH, 
                                       NVL (  RPAD ('9', PRECISION, '9')
                                            / POWER (10, NVL (scale, 0)),
                                            9999999999
                                           ) maxval
                                  FROM all_type_attrs
                                 WHERE owner = l_sch
                                   AND type_name = rx.data_type
                              ORDER BY attr_no)
                     LOOP
                              IF (rv.attr_type_name IN ('NUMBER', 'FLOAT', 'INTEGER'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || 'dbms_random.value(1,'
                                    || rv.maxval
                                    || '),';
                                 l_update1 :=
                                       l_update1
                                    || 'dbms_random.value(1,'
                                    || rv.maxval
                                    || '),';
                              ELSIF (rv.attr_type_name = 'DATE')
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                 l_update1 :=
                                       l_update1
                                    || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                              ELSIF (rv.attr_type_name IN ('CHAR', 'VARCHAR2'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || 'dbms_random.string(''A'','
                                    || rv.LENGTH
                                    || '),';
                                 l_update1 :=
                                       l_update1
                                    || 'dbms_random.string(''A'','
                                    || rv.LENGTH
                                    || '),';
                              ELSIF (rv.attr_type_name LIKE '%UDT%')
                              THEN
                                 l_insert2 := NULL;
                                 l_update2 := NULL;
                                 l_insert1 := l_insert1 || l_sch || '.' || rv.attr_type_name || '(';
                                 l_update1 :=
                                       l_update1
                                    || l_sch
                                    || '.'
                                    ||rv.attr_type_name
                                    || '(';
                                 FOR rv1 IN (SELECT attr_type_name, LENGTH,
                                                   NVL (  RPAD ('9', PRECISION, '9')
                                                        / POWER (10, NVL (scale, 0)),
                                                        9999999999
                                                       ) maxval
                                              FROM all_type_attrs
                                             WHERE owner = l_sch
                                               AND type_name = rv.attr_type_name
                                          ORDER BY attr_no)
                                 LOOP
                                          IF (rv1.attr_type_name IN ('NUMBER', 'FLOAT', 'INTEGER'))
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || 'dbms_random.value(1,'
                                                || rv1.maxval
                                                || '),';
                                             l_update2 :=
                                                   l_update2
                                                || 'dbms_random.value(1,'
                                                || rv1.maxval
                                                || '),';
                                          ELSIF (rv1.attr_type_name = 'DATE')
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                             l_update2 :=
                                                   l_update2
                                                || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                          ELSIF (rv1.attr_type_name IN ('CHAR', 'VARCHAR2'))
                                          THEN
                                             l_insert2 :=
                                                   l_insert2
                                                || 'dbms_random.string(''A'','
                                                || rv1.LENGTH
                                                || '),';
                                             l_update2 :=
                                                   l_update2
                                                || 'dbms_random.string(''A'','
                                                || rv1.LENGTH
                                                || '),';
                                          END IF;
                                 END LOOP;
                                 l_insert1 := l_insert1 || RTRIM (l_insert2, ',') || '),';
                                 l_update1 := l_update1 || RTRIM (l_update2, ',') || '),';
                              END IF;
                     END LOOP;
                     l_insert1 := RTRIM (l_insert1, ',') || '),';
                     l_update1 := RTRIM (l_update1, ',') || '),';
                  ELSIF (rx.data_type LIKE '%SCAL%')
                  THEN
                     l_insert1 := l_insert1 || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch
                        || '.'
                        ||rx.data_type
                        || '(';
                     FOR rv IN (SELECT elem_type_name, LENGTH, upper_bound,
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
                         l_loop := FLOOR(dbms_random.value(1, rv.upper_bound));
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
                                    || 'dbms_random.value(1,'
                                    || rv.maxval
                                    || '),';
                                 l_update1 :=
                                       l_update1
                                    || 'dbms_random.value(1,'
                                    || rv.maxval
                                    || '),';
                              ELSIF (rv.elem_type_name = 'DATE')
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                 l_update1 :=
                                       l_update1
                                    || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                              ELSIF (rv.elem_type_name IN ('CHAR', 'VARCHAR2'))
                              THEN
                                 l_insert1 :=
                                       l_insert1
                                    || 'dbms_random.string(''A'','
                                    || rv.LENGTH
                                    || '),';
                                 l_update1 :=
                                       l_update1
                                    || 'dbms_random.string(''A'','
                                    || rv.LENGTH
                                    || '),';
                              END IF;
                            END IF;
                        END LOOP;
                     END LOOP;
                     l_insert1 := RTRIM (l_insert1, ',') || '),';
                     l_update1 := RTRIM (l_update1, ',') || '),';
                  ELSIF (rx.data_type LIKE '%OBJ%')
                  THEN
                     l_insert1 := l_insert1 || l_sch || '.' || rx.data_type || '(';
                     l_update1 :=
                           l_update1
                        || rx.column_name
                        || ' = '
                        || l_sch
                        || '.'
                        ||rx.data_type
                        || '(';
                     FOR rv IN (SELECT elem_type_name, upper_bound
                                  FROM all_coll_types
                                 WHERE owner = l_sch
                                   AND type_name = rx.data_type)
                     LOOP
                      IF p_varr_rand
                      THEN
                         l_loop := FLOOR(dbms_random.value(1, rv.upper_bound));
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
                                 (SELECT attr_type_name, LENGTH,
                                         NVL (  RPAD ('9', PRECISION, '9')
                                              / POWER (10, NVL (scale, 0)),
                                              9999999999
                                             ) maxval
                                    FROM all_type_attrs
                                   WHERE owner = l_sch
                                     AND type_name = rv.elem_type_name
                                ORDER BY attr_no)
                              LOOP
                                 IF (rc.attr_type_name IN
                                        ('NUMBER',
                                         'FLOAT',
                                         'DECIMAL',
                                         'INTEGER',
                                         'SMALLINT'
                                        )
                                    )
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || 'dbms_random.value(1,'
                                       || rc.maxval
                                       || '),';
                                    l_update2 :=
                                          l_update2
                                       || 'dbms_random.value(1,'
                                       || rc.maxval
                                       || '),';
                                 ELSIF (rc.attr_type_name = 'DATE')
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                    l_update2 :=
                                          l_update2
                                       || 'sysdate+dbms_random.value+dbms_random.value(1,1000),';
                                 ELSIF (rc.attr_type_name IN
                                                         ('CHAR', 'VARCHAR2')
                                       )
                                 THEN
                                    l_insert2 :=
                                          l_insert2
                                       || 'dbms_random.string(''A'','
                                       || rc.LENGTH
                                       || '),';
                                    l_update2 :=
                                          l_update2
                                       || 'dbms_random.string(''A'','
                                       || rc.LENGTH
                                       || '),';
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

            --EXECUTE IMMEDIATE RTRIM ((l_insert || l_insert1), ',') || ')';
            --EXECUTE IMMEDIATE RTRIM ((l_update || l_update1), ',');
            IF l_ins > 0 AND l_insert1 IS NOT NULL
            THEN
               l_ins := l_ins - 1;

                   IF    (l_clob IN ('NULL', 'EMPTY') AND is_num (p_blob))
                      OR (l_blob IN ('NULL', 'EMPTY') AND is_num (p_clob))
                      OR (l_clob IN ('NULL', 'EMPTY') AND l_blob IN ('NULL', 'EMPTY'))
                      OR (is_num (p_clob) AND is_num (p_blob))
                   THEN
                     --putline(RTRIM ((l_insert || l_insert1), ',' ) || ')');
                     EXECUTE IMMEDIATE    RTRIM ((l_insert || l_insert1), ',' ) || ')';
                     --due to ORACLE bug#7006959 need to commit every transaction for DLOAD to avoid "ORA-12838: cannot read/modify an object after modifying it in parallel"
                     IF p_ins_flag = 'd' and oraver = 11
                     THEN
                        --putline ('commit;');
                        COMMIT;
                     END IF;
                   END IF;

                   IF     l_clob_cnt = 1
                      AND l_blob_cnt = 1
                      AND (NOT is_num (p_clob))
                      AND (NOT is_num (p_blob))
                      AND l_clob NOT IN ('NULL', 'EMPTY')
                      AND l_blob NOT IN ('NULL', 'EMPTY')
                   THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_insert || l_insert1),
                                                 ','
                                                )
                                       || ')'
                                       || ' returning '
                                       || l_clob_name
                                       || ','
                                       || l_blob_name
                                       || ' into :clob, :blob'
                                 USING OUT g_clob, OUT g_blob;

                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_clob, p_writeappend, RPAD ('*', p_writeappend, '*')); END IF;
                     --DBMS_LOB.append (g_clob, g_clob);
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_clob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_clob, g_clob);

                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_blob, p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*' ))); END IF;
                     --DBMS_LOB.append (g_blob, g_blob);
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_blob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_blob, g_blob);

                   ELSIF    (    l_clob_cnt = 1
                             AND l_blob_cnt = 0
                             AND (NOT is_num (p_clob))
                             AND l_clob NOT IN ('NULL', 'EMPTY')
                            )
                         OR (    l_clob_cnt = 1
                             AND l_blob_cnt = 1
                             AND (NOT is_num (p_clob))
                             AND (is_num (p_blob) OR l_blob IN ('NULL', 'EMPTY'))
                             AND l_clob NOT IN ('NULL', 'EMPTY')
                            )
                    THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_insert || l_insert1),
                                                 ','
                                                )
                                       || ')'
                                       || ' returning '
                                       || l_clob_name
                                       || ' into :clob'
                                 USING OUT g_clob;

                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_clob, p_writeappend, RPAD ('*', p_writeappend, '*')); END IF;
                     DBMS_LOB.append (g_clob, g_clob);
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_clob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_clob, g_clob);

                    ELSIF    (    l_clob_cnt = 0
                              AND l_blob_cnt = 1
                              AND (NOT is_num (p_blob))
                              AND l_blob NOT IN ('NULL', 'EMPTY')
                             )
                          OR (    l_clob_cnt = 1
                              AND l_blob_cnt = 1
                              AND (is_num (p_clob) OR l_clob IN ('NULL', 'EMPTY'))
                              AND (NOT is_num (p_blob))
                              AND l_blob NOT IN ('NULL', 'EMPTY')
                             )
                     THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_insert || l_insert1),
                                                 ','
                                                )
                                       || ')'
                                       || ' returning '
                                       || l_blob_name
                                       || ' into :blob'
                                 USING OUT g_blob;

                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_blob, p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*' ))); END IF;
                     DBMS_LOB.append (g_blob, g_blob);
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_blob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_blob, g_blob);

                  ELSIF l_clob_cnt = 0 AND l_blob_cnt = 0  
                  THEN
                     --putline(RTRIM ((l_insert || l_insert1), ',' ) || ')');
                     EXECUTE IMMEDIATE    RTRIM ((l_insert || l_insert1), ',' ) || ')';
                  END IF;
             ELSE
               l_ins := 0;
             END IF;

            --due to ORACLE bug#7006959 need to commit every transaction for DLOAD to avoid "ORA-12838: cannot read/modify an object after modifying it in parallel"
            IF p_ins_flag = 'd' and oraver = 11
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
                     EXECUTE IMMEDIATE    'select FLOOR(dbms_random.value(1,'
                                       || l_tab_cnt
                                       || ')) from dual'
                                  INTO l_tab_cnt;
                  END IF;

                  IF    l_clob = 'NULL' AND l_blob = 'NULL'
                     OR (is_num (p_clob) AND is_num (p_blob))
                  THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_update || l_update1), ',')
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
                                    || ')';
                  END IF;

                  IF     l_clob_cnt = 1
                     AND l_blob_cnt = 1
                     AND (NOT is_num (p_clob))
                     AND (NOT is_num (p_blob))
                     AND l_clob NOT IN ('NULL', 'EMPTY')
                     AND l_blob NOT IN ('NULL', 'EMPTY')
                  THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_update || l_update1),
                                                 ','
                                                )
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
                                       || l_clob_name
                                       || ','
                                       || l_blob_name
                                       || ' into :clob, :blob'
                                 USING OUT g_clob, OUT g_blob;

                     IF p_dbms_lob_write THEN DBMS_LOB.write(g_clob, p_write_amt, p_write_off, RPAD ('*', p_write_amt, '*')); END IF;
                     DBMS_LOB.append (g_clob, g_clob);
                     IF p_dbms_lob_erase THEN DBMS_LOB.erase (g_clob, l_lob_amt, l_lob_pos); END IF;
                     DBMS_LOB.copy(g_clob, l_clob_name, dbms_lob.getLength(l_clob_name));
                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_clob, p_writeappend, RPAD ('*', p_writeappend, '*')); END IF;
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_clob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_clob, g_clob);

                     IF p_dbms_lob_write THEN DBMS_LOB.write(g_blob, p_write_amt, p_write_off, UTL_RAW.cast_to_raw (RPAD ('*', p_write_amt, '*'))); END IF;
                     DBMS_LOB.append (g_blob, g_blob);
                     IF p_dbms_lob_erase THEN DBMS_LOB.erase (g_blob, l_lob_amt, l_lob_pos); END IF;
                     DBMS_LOB.copy(g_blob, g_blob, dbms_lob.getLength(l_blob_name));
                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_blob, p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*'))); END IF;
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_blob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_blob, g_blob);

                  ELSIF    (    l_clob_cnt = 1
                            AND l_blob_cnt = 0
                            AND (NOT is_num (p_clob))
                            AND l_clob NOT IN ('NULL', 'EMPTY')
                           )
                        OR (    l_clob_cnt = 1
                            AND l_blob_cnt = 1
                            AND (NOT is_num (p_clob))
                            AND (is_num (p_blob) OR l_blob IN ('NULL', 'EMPTY'))
                            AND l_clob NOT IN ('NULL', 'EMPTY')
                           )
                  THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_update || l_update1),
                                                 ','
                                                )
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
                                       || l_clob_name
                                       || ' into :clob'
                                 USING OUT g_clob;

                     IF p_dbms_lob_write THEN DBMS_LOB.write(g_clob, p_write_amt, p_write_off, RPAD ('*', p_write_amt, '*')); END IF;
                     DBMS_LOB.append (g_clob, g_clob);
                     IF p_dbms_lob_erase THEN DBMS_LOB.erase (g_clob, l_lob_amt, l_lob_pos); END IF;
                     DBMS_LOB.copy(g_clob, l_clob_name, dbms_lob.getLength(l_clob_name));
                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_clob, p_writeappend, RPAD ('*', p_writeappend, '*')); END IF;
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim (g_clob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_clob, g_clob);

                  ELSIF    (    l_clob_cnt = 0
                            AND l_blob_cnt = 1
                            AND (NOT is_num (p_blob))
                            AND l_blob NOT IN ('NULL', 'EMPTY')
                           )
                        OR (    l_clob_cnt = 1
                            AND l_blob_cnt = 1
                            AND (is_num (p_clob) OR l_clob IN ('NULL', 'EMPTY'))
                            AND (NOT is_num (p_blob))
                            AND l_blob NOT IN ('NULL', 'EMPTY')
                           )
                  THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_update || l_update1),
                                                 ','
                                                )
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
                                       || l_blob_name
                                       || ' into :blob'
                                 USING OUT g_blob;

                     IF p_dbms_lob_write THEN DBMS_LOB.write(g_blob, p_write_amt, p_write_off, UTL_RAW.cast_to_raw (RPAD ('*', p_write_amt, '*'))); END IF;
                     DBMS_LOB.append (g_blob, g_blob);
                     IF p_dbms_lob_erase THEN DBMS_LOB.erase (g_blob, l_lob_amt, l_lob_pos); END IF;
                     DBMS_LOB.copy(g_blob, g_blob, dbms_lob.getLength(l_blob_name));
                     IF p_dbms_lob_writeappend THEN DBMS_LOB.writeappend (g_blob, p_writeappend, UTL_RAW.cast_to_raw (RPAD ('*', p_writeappend, '*'))); END IF;
                     IF p_dbms_lob_trim THEN DBMS_LOB.trim( g_blob, p_trim); END IF;
                     dbms_lob_loadfromfile (p_blob, g_blob);

                  ELSIF    (l_clob_cnt = 0 AND l_blob_cnt = 0)
                        OR (l_clob IN ('NULL', 'EMPTY') AND is_num (p_blob))
                        OR (l_blob IN ('NULL', 'EMPTY') AND is_num (p_clob))
                        OR (l_clob IN ('NULL', 'EMPTY') AND l_blob IN ('NULL', 'EMPTY'))
                        OR (is_num (p_clob) AND is_num (p_blob))
                  THEN
                     EXECUTE IMMEDIATE    RTRIM ((l_update || l_update1), ',')
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
                                    || ')';
               END IF;
          ELSE
           --l_upd := l_upd - 1;
           l_upd := 0;
          END IF;

            IF l_del > 0
            THEN
               l_del := l_del - 1;
               EXECUTE IMMEDIATE    l_delete
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
                                 || ')';
            END IF;

            IF (MOD (l_cnt, p_com) = 0) 
            THEN
               --putline ('commit;');
               COMMIT;
            ELSIF (MOD (l_cnt, p_rol) = 0)
            THEN
               IF p_prb
               THEN
                  --putline ('rollback to sp;');
                  ROLLBACK TO sp;
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
            WHEN unique_constraint_violated OR dup_val_on_index 
            THEN
               --
               -- unique constraint violated.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> 1 record '
                                     || l_sch   
                                     || '.'   
                                     || l_tab
                                     || ' UNIQUE CONSTRAINT VIOLATED'
                                    );
            WHEN check_constraint_violated
            THEN
               --
               -- check constraint violated.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> 1 record '
                                     || l_sch
                                     || '.'
                                     || l_tab
                                     || ' CHECK CONSTRAINT VIOLATED'
                                    );
            WHEN updating_partition_key
            THEN
               --
               -- updating_partition_key.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> 1 record '
                                     || l_sch
                                     || '.'
                                     || l_tab
                                     || ' UPDATING PARTITION KEY COLUMN WOULD CAUSE A PARTITION CHANGE'
                                    );
            WHEN OTHERS
            THEN
               output_flag  := TRUE;
/*
               IF p_ins > 0
               THEN
                 putline(RTRIM ((l_insert || l_insert1), ',' ) || ')');
               END IF;

               IF p_upd > 0
               THEN
                 putline
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
                 putline
                 (
                  l_delete
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
               putline
               (
                l_sch
                  || '.'
                  || l_tab   
                  || ' '
                  || 'Bad row index = '
                  || NVL((l_ins+1), (l_upd+1))
                  || ' '
                  || SQLERRM
               );
         END;
      END LOOP;

     IF p_com <> 0
     THEN
         --putline ('commit;');
         COMMIT;
     END IF;

      DBMS_OUTPUT.put_line (   'Execute -> '
                            || l_sch
                            || '.'       
                            || RPAD (l_tab, 33)
                            || ' INS/UPD/DEL '
                            || TO_CHAR (p_ins)
                            || '/'
                            || TO_CHAR (p_upd)
                            || '/'
                            || TO_CHAR (p_del)
                            || ' COM/ROL/NUL '
                            || TO_CHAR (p_com)
                            || '/'
                            || TO_CHAR (p_rol)
                            || '/'
                            || TO_CHAR (p_noth)
                            || ' INS/UPD/CLOB/BLOB '
                            || l_ins_flag
                            || '/'
                            || l_upd_flag
                            || '/'
                            || l_clob
                            || '/'
                            || l_blob
                           );
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_retval   INTEGER;
      l_sch                      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
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
      p_sch       VARCHAR2 := NULL, 
      p_tab       VARCHAR2, 
      p_ddl       VARCHAR2,
      p_col_cnt   INT      := 1
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sql                      LONG;
      l_sch                      VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_tab                      VARCHAR2 (100) := quotes (p_tab);
      l_maxcol                   NUMBER         := maxcolid (l_sch, p_tab);
      l_type                     VARCHAR2(50);
      no_such_column             EXCEPTION;
      invalid_modification_cols  EXCEPTION;
      PRAGMA EXCEPTION_INIT (no_such_column, -904);
      PRAGMA EXCEPTION_INIT (invalid_modification_cols, -22859);

   BEGIN

      gen_seed;

      FOR i IN 1 .. p_col_cnt
      LOOP
         BEGIN
          IF UPPER (p_ddl) NOT IN
             ('ADD_LONG',
              'ADD_BFILE',
              'ADD',
              'DROP',
              'SET_UNUSED',
              'DROP_UNUSED',
              'TRUNCATE',
              'MODIFY'
             )
          THEN
             DBMS_OUTPUT.put_line 
             ('Warning -> DDL parameter does not exist in database ''ADD_LONG'',''ADD_BFILE'',''ADD'',''DROP'',''SET_UNUSED'',''DROP_UNUSED'',''TRUNCATE'',''MODIFY'''
             );
             EXIT;
          ELSE
            --add long column
            IF UPPER(p_ddl) = 'ADD_LONG'
            THEN
             IF is_col(l_sch, p_tab, 'LONG') = 0
             THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch   
                   || '.'   
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || (l_maxcol + i + 1)
                   || ' long';
              ELSE
                DBMS_OUTPUT.put_line ('Warning -> a table may contain only one column of type LONG');
                EXIT;
              END IF;
            --add bfile column
            ELSIF UPPER(p_ddl) = 'ADD_BFILE'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || (l_maxcol + i + 1)
                   || ' bfile';
            --add random p_col_cnt number of columns with random size from the stortab list
            ELSIF UPPER(p_ddl) = 'ADD'
            THEN
             l_type := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));
             IF ( instr( l_type, '|' ) > 0 )
             THEN
                l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || (l_maxcol + i + 1)
                   || ' '
                   || substr( l_type, 1, instr( l_type, '|' ) - 1 )
                   || '('
                   || FLOOR(DBMS_RANDOM.VALUE (1, substr( l_type, instr( l_type, '|' ) + 1 )))
                   || ')';
              ELSE
                l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' ADD '
                   || g_col_name
                   || (l_maxcol + i + 1)
                   || ' '
                   || l_type;
              END IF;
            --drop last p_col_cnt columns
            ELSIF UPPER(p_ddl) = 'DROP'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' DROP COLUMN '
                   || g_col_name
                   || GREATEST((l_maxcol + i - p_col_cnt + 1), 0);
            --set unused last p_col_cnt columns
            ELSIF UPPER(p_ddl) = 'SET_UNUSED'
            THEN
               l_sql :=
                      'ALTER TABLE '
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' SET UNUSED '
                   || '('
                   || g_col_name
                   || GREATEST((l_maxcol + i - p_col_cnt + 1), 0)
                   || ')';
            --modify last p_col_cnt columns
            ELSIF UPPER(p_ddl) = 'MODIFY'
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
                   || (l_maxcol + i - p_col_cnt + 1)
                   || ' '
                   || substr( l_type, 1, instr( l_type, '|' ) - 1 )
                   || '('
                   || FLOOR(DBMS_RANDOM.VALUE (1, substr( l_type, instr( l_type, '|' ) + 1 )))
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
                   || GREATEST((l_maxcol + i - p_col_cnt + 1), 0)
                   || ' '
                   || l_type
                   || ')';
               END IF;
              END IF;
            --truncate p_tab table p_col_cnt times
            ELSIF UPPER(p_ddl) = 'TRUNCATE'
            THEN
               l_sql :=
                      'TRUNCATE TABLE ' 
                   || l_sch              
                   || '.'              
                   || l_tab;
            --drop unused columns p_col_cnt times
            ELSIF UPPER(p_ddl) = 'DROP_UNUSED'
            THEN
               l_sql :=
                      'ALTER TABLE ' 
                   || l_sch              
                   || '.'              
                   || l_tab
                   || ' DROP UNUSED COLUMNS';
            END IF;
         END IF;
            ----DBMS_OUTPUT.put_line ('Execute -> ' || l_sql);
            --DBMS_OUTPUT.put_line (l_sql||';');
            putline (l_sql||';');
            EXECUTE IMMEDIATE NVL(l_sql,'select dummy from dual');
         EXCEPTION
            WHEN no_such_column
            THEN
               --
               -- ORA-904: invalid identifier.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> alter table '
                                     || l_sch
                                     || '.'
                                     || l_tab
                                     || ' - '
                                     || g_col_name
                                     || GREATEST((l_maxcol + i - p_col_cnt + 1), 0)
                                     || ' no such column'
                                    );
            WHEN invalid_modification_cols 
            THEN
               --
               -- ORA-22859: invalid modification of columns.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> alter table '
                                     || l_sch
                                     || '.'
                                     || l_tab
                                     || ' - '
                                     || g_col_name
                                     || GREATEST((l_maxcol + i - p_col_cnt + 1), 0)
                                     || ' an attempt was made to modify a XMLTYPE'
                                    );
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ( l_sch
                                     || '.'
                                     || l_tab 
                                     || ' '
                                     || 'error on column'
                                     || ' - '
                                     || SQLERRM
                                    );
         END;
      END LOOP;
      DBMS_OUTPUT.put_line (   'Execute -> '
                            || l_sch
                            || '.'
                            || RPAD (l_tab, 33)
                            || ' DDL= '
                            || TO_CHAR (p_ddl)
                            || ' COL#= '
                            || TO_CHAR (p_col_cnt)
                           );
   END ddl;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__

   PROCEDURE bulkdml (
      p_sch       VARCHAR2 := NULL, 
      p_tab       VARCHAR2, 
      p_ins       VARCHAR2 := 'r',
      p_rows      INT      := 1
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sch                VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
      l_ptab               VARCHAR2 (100) := quotes (p_tab);
      l_tab                VARCHAR2 (100) := quotes ('TT' || LTRIM ((p_tab), SUBSTR (p_tab, 1, 3)));
      l_ins                VARCHAR2 (1)   := UPPER (p_ins);
      l_insert             VARCHAR2 (100);
      l_oraver             INT            := oraver;
      unique_constraint_violated   EXCEPTION;
      PRAGMA EXCEPTION_INIT (unique_constraint_violated, -00001);
   BEGIN
     IF l_ins NOT IN ('D','R')
     THEN
        DBMS_OUTPUT.put_line ('Warning -> Invalid p_ins flag - must specify D/irect/ or  R/egular/');
        help;
     ELSE
      IF is_col (l_sch, p_tab, 'LONG') = 0
      THEN
         DBMS_OUTPUT.put_line (   'CREATE TABLE '
                               || l_sch
                               || '.'
                               || l_tab
                               || ' AS SELECT * FROM '
                               || l_sch
                               || '.'
                               || l_ptab
                               || ' WHERE 1=0'
                              );

         EXECUTE IMMEDIATE    'CREATE TABLE '
                               || l_sch
                               || '.'
                               || l_tab
                               || ' AS SELECT * FROM '
                               || l_sch
                               || '.'
                               || l_ptab
                               || ' WHERE 1=0';

         --set p_null to 1001 to avoid insert NULL into PK cols
         iud (p_sch          => l_sch,
              p_tab          => ltrim(rtrim(l_tab,'"'),'"'),
              p_ins          => p_rows,
              p_upd          => 0,
              p_del          => 0,
              p_null_varr    => 5,
              p_null         => 1001
             );

            IF l_ins = 'D'
            THEN

               l_insert := 'insert /*+ append */ into ';
            ELSIF l_ins = 'R'
            THEN
               l_insert := 'insert into ';
            END IF;

         DBMS_OUTPUT.put_line (   l_insert
                               || l_sch
                               || '.'
                               || l_ptab
                               || ' SELECT * FROM '
                               --|| ' SELECT /*+ parallel(' || l_sch || '.' || l_tab || ',12) */ * FROM '
                               || l_sch
                               || '.'
                               || l_tab
                              );

         EXECUTE IMMEDIATE l_insert || l_sch || '.' || l_ptab || ' SELECT * FROM ' || l_sch || '.' || l_tab;
         --EXECUTE IMMEDIATE l_insert || l_sch || '.' || l_ptab || ' SELECT /*+ parallel(' || l_sch || '.' || l_tab || ',12) */ * FROM ' || l_sch || '.' || l_tab;
         IF l_oraver = 10 or l_oraver = 11
         THEN
            DBMS_OUTPUT.put_line ('DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE');
            EXECUTE IMMEDIATE 'DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE';
         ELSE
            DBMS_OUTPUT.put_line ('DROP TABLE ' || l_sch || '.' || l_tab);
            EXECUTE IMMEDIATE 'DROP TABLE ' || l_sch || '.' || l_tab;
         END IF;
      ELSE
         DBMS_OUTPUT.put_line ('Warning -> '|| l_sch || '.' || l_tab ||' Cannot bulk insert on table with LONG datatype');
      END IF;
     END IF;
 EXCEPTION
   WHEN unique_constraint_violated OR dup_val_on_index THEN
          --
          -- unique constraint violated.
          --
         IF l_oraver = 10 or l_oraver = 11
         THEN
            DBMS_OUTPUT.put_line ('DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE');
            EXECUTE IMMEDIATE 'DROP TABLE ' || l_sch || '.' || l_tab || ' PURGE';
         ELSE
            DBMS_OUTPUT.put_line ('DROP TABLE ' || l_sch || '.' || l_tab);
            EXECUTE IMMEDIATE 'DROP TABLE ' || l_sch || '.' || l_tab;
         END IF;
         DBMS_OUTPUT.put_line ( 'Skipped -> '
                                 || l_sch
                                 || '.'
                                 || l_tab
                                 || ' UNIQUE CONSTRAINT VIOLATED'
                              );
   WHEN OTHERS THEN
         DBMS_OUTPUT.put_line (l_sch
                               || '.'
                               || l_ptab
                               || ' '
                               --|| 'Bad row index = '
                               || ' '
                               || SQLERRM
                              );
         DBMS_OUTPUT.put_line ('DROP TABLE ' || l_sch || '.' || l_tab);
         EXECUTE IMMEDIATE 'DROP TABLE ' || l_sch || '.' || l_tab;
    -- RAISE;
   END bulkdml;

--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
--__--__--__--__--__--__--__--__--__--__---__--__--__--__--__--__--__--__--__
   PROCEDURE create_tab (
      p_schname          VARCHAR2 := NULL,
      p_tabname          VARCHAR2,
      p_colname          VARCHAR2 := 'COL',
      p_colnum           INT := 10,
      p_pknum            INT := 1,
      p_start            INT := 1,
      p_varr_max         INT := 10,
      p_lob_out          INT := 0,
      p_clause           VARCHAR2 := NULL
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sch                   VARCHAR2 (100) := NVL (UPPER (p_schname), USER);
      l_tab                   VARCHAR2 (100) := quotes (p_tabname);
      l_sql                   LONG;
      l_pklist                LONG;
      l_loblist               LONG;
      l_col_attr              VARCHAR2 (100);
      l_type                  VARCHAR2 (50);
      l_column                VARCHAR2 (30);
      l_colsize               INT;
      i                       PLS_INTEGER    := 1;
      j                       PLS_INTEGER    := 1;
      n                       PLS_INTEGER    := 1;
      m                       PLS_INTEGER    := 1;
      no_pk_constraint_found  EXCEPTION;
      PRAGMA EXCEPTION_INIT (no_pk_constraint_found, -25175);

      stor_table_novar        stortab
      := stortab ('varchar2(20)',
                  'number(38)',
                  'date',
                  'char(20)',
                  'float(38)',
                  'varchar(20)',
                  'integer'
                 );
   BEGIN

      gen_seed;

      l_sql := 'CREATE TABLE ' || l_sch || '.' || l_tab || '(';

      WHILE i < (p_colnum + 1)
      LOOP
         l_type := stor_table (DBMS_RANDOM.VALUE (1, stor_table.COUNT));

         IF (INSTR (l_type, '|') > 0)
         THEN
            l_column := SUBSTR (l_type, 1, INSTR (l_type, '|') - 1);
            l_sql :=
                  l_sql
               || quotes (p_colname || i)
               || ' '
               || l_column
               || '('
               || FLOOR (DBMS_RANDOM.VALUE (1,
                                            SUBSTR (l_type,
                                                    INSTR (l_type, '|') + 1
                                                   )
                                           )
                        )
               || ')'
               || ',';
         ELSE
            l_column := l_type;
            --p_var_max limit for scal and obj varrays
            IF  (UPPER (l_column) LIKE '%SCAL%'
               OR UPPER (l_column) LIKE '%OBJ%')
            THEN
               m := m + 1;
            END IF;
            IF  (UPPER (l_column) LIKE '%SCAL%'
               OR UPPER (l_column) LIKE '%OBJ%')
               AND m > (p_varr_max + 1)
            THEN
               l_column := stor_table_novar (DBMS_RANDOM.VALUE (1, stor_table_novar.COUNT));
            END IF;
               l_sql := l_sql || quotes (p_colname || i) || ' ' || l_column || ',';
         END IF;

         -- remove lob and varray cols from PK list
         IF     j < (p_pknum + 1)
            AND i >= p_start
            AND UPPER (l_column) NOT IN ('CLOB', 'BLOB', 'BFILE')
            AND UPPER (l_column) NOT LIKE '%SCAL%'
            AND UPPER (l_column) NOT LIKE '%OBJ%'
         THEN
            l_pklist := l_pklist || quotes (p_colname || i) || ',';
            j := j + 1;
         END IF;
         --j := j + 1;

         IF UPPER (l_column) IN ('CLOB', 'BLOB') AND n < (p_lob_out + 1)
         THEN
            l_loblist :=
               l_loblist
            || ' LOB ('
            || quotes (p_colname || i)
            || ') STORE AS '
            || SUBSTR (UPPER (p_colname || i || '_' || p_tabname), 1, 30)
            || ' (DISABLE STORAGE IN ROW PCTVERSION 100) ';
            n := n + 1;
         END IF;

       i := i + 1;
      END LOOP;

      IF l_pklist IS NOT NULL
      THEN
         l_pklist :=
               ' CONSTRAINT '
            || quotes ('PK_' || p_tabname)
            || ' PRIMARY KEY('
            || RTRIM (l_pklist, ',')
            || ')) ';
      ELSE
         l_sql := RTRIM (l_sql, ',') || ')';
      END IF;

      l_sql := l_sql || l_pklist || p_clause || l_loblist;

      putline (l_sql||';');
      EXECUTE IMMEDIATE l_sql;
      DBMS_OUTPUT.put_line (   'Execute -> '
                            || 'CREATE TABLE '
                            || l_sch
                            || '.'
                            || l_tab
                           );
    EXCEPTION
            WHEN no_pk_constraint_found
            THEN
               --
               -- ORA-25175: no PRIMARY KEY constraint found.
               --
               DBMS_OUTPUT.put_line (   'Skipped -> create table '
                                     || l_sch
                                     || '.'
                                     || l_tab
                                     || ' no PRIMARY KEY constraint found'
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
      l_sql        LONG;
      l_sch        VARCHAR2 (100) := NVL (UPPER (p_sch), USER);
   BEGIN

      l_sql := 'DROP ' || upper(p_obj) || ' ' || l_sch || '.' || quotes (p_name);
      DBMS_OUTPUT.put_line ('EXECUTE IMMEDIATE -> '||l_sql||';');
      EXECUTE IMMEDIATE l_sql;

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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
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
            DBMS_OUTPUT.put_line ('Execute -> ' || x.stmt);
            EXECUTE IMMEDIATE x.stmt;
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------

      l_cur_name      pls_integer default dbms_sql.open_cursor;
      l_ignore        pls_integer;

 BEGIN

   IF UPPER (p_ddl_type) NOT IN
                     ('EXECUTE IMMEDIATE', 'DBMS_SQL.NATIVE', 'DBMS_SQL.V7')
   THEN
      DBMS_OUTPUT.put_line
         ('Warning -> DDL type does not exist ''EXECUTE IMMEDIATE'',''DBMS_SQL.NATIVE'',''DBMS_SQL.V7'''
         );
   ELSE
      IF p_ddl_string IS NOT NULL
      THEN
         putline (p_ddl_type || ' -> ' || p_ddl_string || ';');
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
-- ----------        ---------- ----------------------------------------------
-- Ilya Rubijevsky   6/12/06     Initial creation
--============================================================================
------------------------------------------------------------------------------
--- TYPES, CURSORS, VARIABLES
------------------------------------------------------------------------------
   BEGIN
    output_flag  := TRUE;
    version;
    putline('> PURPOSE: To build a dml/ddl for all tables in schema with all datatypes');
    putline('>');
    putline('> NOTES:');
    putline('> (1)');
    putline('>   output_flag      (TRUE/FALSE) flag that determines whether output should be displayed.');
    putline('>   random_flag      (TRUE/FALSE) flag that determines whether random data should be used.');
    putline('>');
    putline('>   g_seed seed number');
    putline('>   all tables should start or equal to g_table_name');
    putline('>   all DDL columns should start with  g_col_name');
    putline('>');
    putline('>   all supported DDL datatypes | max size:');
    putline('>   ''varchar2|2000''');
    putline('>   ''number|38''');
    putline('>   ''date''');
    putline('>   ''char|2000''');
    putline('>   ''timestamp|9''');
    putline('>   ''float|38''');
    putline('>   ''varchar|2000''');
    putline('>   ''integer''');
    putline('>');
    putline('>   all supported DDL types:');
    putline('>    ADD_LONG     --add long column');
    putline('>    ADD_BFILE    --add bfile column');
    putline('>    ADD          --add random p_col_cnt number of columns with random size from the stortab list');
    putline('>    DROP         --drop last p_col_cnt columns');
    putline('>    SET_UNUSED   --set unused last p_col_cnt columns');
    putline('>    DROP_UNUSED  --drop unused columns p_col_cnt times');
    putline('>    TRUNCATE     --truncate p_tab table p_col_cnt times');
    putline('>    MODIFY       --modify last p_col_cnt columns');
    putline('>');
    putline('> (2) Here is a sample SQL*Plus script to execute it:');
    putline('>   DML:');
    putline('>     BEGIN');
    putline('>       qa_ddml.iud');
    putline('>   insert NULL into MOD(g_col_null) - a NULL value is treated as random number');
    putline('>      (');
    putline('>      p_sch         => ''SP_DDL'',          --schema name');
    putline('>      p_tab         => ''QA_TEST'',         --table name');
    putline('>      p_ins         => 10,                --insert N');
    putline('>      p_upd         =>  5,                --update N');
    putline('>      p_del         =>  3,                --delete N');
    putline('>      p_com         =>  0,                --commit every p_com times');
    putline('>      p_rol         =>  0,                --rollback every p_rol times');
    putline('>      p_noth        =>  0,                --do nothing every p_noth times');
    putline('>      p_null        =>  0,                --insert/update to NULL every p_null column(0-random)');
    putline('>      p_long        =>  1000,             --max long size');
    putline('>      p_varr_rand   =>  TRUE,             --random number of varray elements (TRUE/FALSE)');
    putline('>      p_null_varr   =>  0,                --insert/update to NULL every p_null_varr varray element(0-random)');
    putline('>      p_prb         =>  FALSE,            --partial rollback (TRUE/FALSE)');
    putline('>      p_clob        =>  ''clob_file_0.1m'', --CLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)');
    putline('>      p_blob        =>  ''blob_file_0.1m'', --BLOB location for ins/upd external LOB files(>4000 bytes)/EMPTY/NULL/number(<4000 bytes)');
    putline('>      p_dbms_lob_trim => TRUE,             --dbms_lob.trim  (TRUE/FALSE)');
    putline('>      p_dbms_lob_writeappend  => TRUE,     --dbms_lob.writeappend (TRUE/FALSE)');
    putline('>      p_dbms_lob_write  => TRUE,           --dbms_lob.write (TRUE/FALSE)');
    putline('>      p_trim        => 1,                  --truncates the LOB to p_trim bytes');
    putline('>      p_writeappend => 32000,              --writes p_writeappend of data from the buffer to the end of a LOB');
    putline('>      p_write_amt   => 30000,              --writes p_write of data to the LOB from p_write_off offset');
    putline('>      p_write_off   => 100,                --offset to writes p_writeappend of data');
    putline('>      p_ins_flag    =>  ''r'',              --insert flag (r-regular, d-direct)');
    putline('>      p_upd_flag    =>  ''n'',              --update flag (n-update nonkey cols, k-update key cols only, a-update all cols)');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>   BULKDML:');
    putline('>     BEGIN');
    putline('>       qa_ddml.bulkdml');
    putline('>      (');
    putline('>      p_sch     => ''SP_DDL'',   --name of the schema (default USER schema)');
    putline('>      p_tab     => ''QA_TEST'',  --name of the table');
    putline('>      p_ins     => ''r'',        --insert flag (r-regular, d-direct)');
    putline('>      p_rows    => 10          --number of bulk dmls');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  DDL:');
    putline('>     BEGIN');
    putline('>       qa_ddml.ddl');
    putline('>      (');
    putline('>      p_sch     => ''SP_DDL'',      --name of the schema (default USER schema)');
    putline('>      p_tab     => rt.table_name, --name of the table');
    putline('>      p_ddl     => ''drop'',        --ddl type - ADD_LONG/ADD_BFILE/ADD/DROP/SET_UNUSED/DROP_UNUSED/TRUNCATE/MODIFY');
    putline('>      p_col_cnt => 10             --number of columns');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  CREATE TABLE:');
    putline('>     BEGIN');
    putline('>       qa_ddml.create_tab');
    putline('>      (');
    putline('>      p_schname  => ''SP_DDL'',  --name of the schema (default USER schema)');
    putline('>      p_tabname  => ''qa_ilya'', --name of the table');
    putline('>      p_colname  => ''C'',       --name of the column (default COL)');
    putline('>      p_colnum   =>  1000,     --number of columns (default 10)');
    putline('>      p_pknum    =>  32,       --number of PKs (default 1)');
    putline('>      p_start    =>  3,        --start PK col number');
    putline('>      p_varr_max =>  10,       --max number of VARRAY columns (default 10)');
    putline('>      p_lob_out  =>  0,        --number of disable storage in row LOB columns (default 0)');
    putline('>      p_clause   =>  NULL      --any text that can be legally appended to a CREATE statement (default NULL)');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  DROP OBJECT:');
    putline('>     BEGIN');
    putline('>       qa_ddml.drop_obj');
    putline('>      (');
    putline('>      p_sch  => ''SP_DDL'', --name of the schema (default USER schema)');
    putline('>      p_obj  => ''TABLE'',  --object type');
    putline('>      p_name => ''QA_TEST'' --object name');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  DROP COLUMN TYPE:');
    putline('>     BEGIN');
    putline('>       qa_ddml.drop_col');
    putline('>      (');
    putline('>      p_sch  => ''SP_DDL'',  --name of the schema (default USER schema)');
    putline('>      p_tab  => ''QA_TEST'', --table name');
    putline('>      p_name => ''VARRAY''   --column type (VARRAY/LOB/BFILE/CHAR...)');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  EXECUTE DDL:');
    putline('>     BEGIN');
    putline('>       qa_ddml.exec_ddl');
    putline('>      (');
    putline('>      p_ddl_string     => ''drop table qa_ilya'',  --any DDL that can be legally run');
    putline('>      p_ddl_type       => ''EXECUTE IMMEDIATE''    --ddl type - ''EXECUTE IMMEDIATE''/''DBMS_SQL.NATIVE''/''DBMS_SQL.V7''');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>  IS ANY p_coltype COLUMN:');
    putline('>     BEGIN');
    putline('>         qa_ddml.is_col');
    putline('>         (');
    putline('>        p_sch            => ''SP_DDL'',  --name of the schema (default USER schema)');
    putline('>        p_tab            => ''QA_TEST'', --table name');
    putline('>        p_coltype        => ''LONG''     --column type (LONG/LOB/NUMBER/CHAR...)');
    putline('>        );');
    putline('>       END;');
    putline('>  MISC');
    putline('>');
    putline('>  PRINT LINE:');
    putline('>     BEGIN');
    putline('>       qa_ddml.putline');
    putline('>      (');
    putline('>        p_str  => ''aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa''  --string can be > 255');
    putline('>      );');
    putline('>     END;');
    putline('>');
    putline('>   ORACLE VERSION:');
    putline('>     BEGIN');
    putline('>       qa_ddml.oraver;');
    putline('>     END;');
    putline('>');
    putline('>  VERSION:');
    putline('>     BEGIN');
    putline('>       select qa_ddml.version from dual;');
    putline('>     END;');
    putline('>');
    putline('>  HELP: Set an appropriate DBMS_OUTPUT buffer (via SERVEROUTPUT ON in SQL*Plus)');
    putline('>     BEGIN');
    putline('>       qa_ddml.help;');
    putline('>     END;');
 END help;

BEGIN
-------------------------------------
-- * Package Initialization Code * --
-------------------------------------
   NULL;
   --gen_seed;
END qa_ddml;
/


