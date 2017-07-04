REM -----------------------------------------------------------------------
REM Filename:   qa_compare_all.sql
REM Purpose:    Compare source and target objects
REM
REM Date:       01/25/05
REM Modified:   09/08/09 Ilya removed CompareTableAnalyze
REM             04/14/10 Ilya removed increment_by from compare sequences
REM             04/22/10 Ilya removed max_value from compare sequences
REM             05/27/10 Ilya removed min_value from compare sequences
REM             05/07/12 Ilya removed index_owner from compare constraints (12g issue)
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading on

UNDEFINE p_service_name
UNDEFINE p_user_name
UNDEFINE p_table_name
DEFINE   p_service_name='&4'
DEFINE   p_user_name=UPPER('&3')
DEFINE   p_table_name='BIN'

COLUMN dummy          format a26 word_wrapped heading 'CompareTableStructure'
COLUMN table_name     format a30 word_wrapped heading 'TabName'
COLUMN column_name    format a20 word_wrapped heading 'ColName'
COLUMN data_type      format a10 word_wrapped heading 'Type'
COLUMN data_length    format 9990             heading 'Len'
COLUMN data_precision format 9990             heading 'Prec'
COLUMN nullable       format a3               heading 'Nul'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, column_name, data_type,
        DECODE (data_type,
                'VARCHAR2', char_length,
                'VARCHAR', char_length,
                'CHAR', char_length,
                'NUMBER', char_length,
                9999
               ) data_length,
        NVL(data_precision,38) data_precision
       ,nullable
   FROM all_tab_columns
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, column_name, data_type,
        DECODE (data_type,
                'VARCHAR2', char_length,
                'VARCHAR', char_length,
                'CHAR', char_length,
                'NUMBER', char_length,
                9999
               ) data_length,
        NVL(data_precision,38) data_precision
       ,nullable
   FROM all_tab_columns@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, column_name, data_type,
        DECODE (data_type,
                'VARCHAR2', char_length,
                'VARCHAR', char_length,
                'CHAR', char_length,
                'NUMBER', char_length,
                9999
               ) data_length,
        NVL(data_precision,38) data_precision
       ,nullable
   FROM all_tab_columns@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, column_name, data_type,
        DECODE (data_type,
                'VARCHAR2', char_length,
                'VARCHAR', char_length,
                'CHAR', char_length,
                'NUMBER', char_length,
                9999
               ) data_length,
        NVL(data_precision,38) data_precision
       ,nullable
   FROM all_tab_columns
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%');

COLUMN dummy        format a26 word_wrapped heading 'CompareTableStructure'
COLUMN table_name   format a25 word_wrapped heading 'TabName'
COLUMN degree       format a10 word_wrapped heading 'Parallel'
COLUMN cache        format a10 word_wrapped heading 'Cache'
COLUMN monitoring   format a10 word_wrapped heading 'Monitor'
COLUMN logging      format a10 word_wrapped heading 'Logging'
COLUMN row_movement format a10 word_wrapped heading 'RowMove'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, DEGREE, CACHE,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, MONITORING,
                        'monitoring'
                       ) MONITORING
           FROM v$instance s, v$instance@&&p_service_name t),
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, LOGGING, 1010, LOGGING,
                        'logging'
                       ) LOGGING
           FROM v$instance s, v$instance@&&p_service_name t),
        row_movement
   FROM all_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, DEGREE, CACHE,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, MONITORING,
                        'monitoring'
                       ) MONITORING
           FROM v$instance s, v$instance@&&p_service_name t),
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, LOGGING, 1010, LOGGING,
                        'logging'
                       ) LOGGING
           FROM v$instance s, v$instance@&&p_service_name t),
        row_movement
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, DEGREE, CACHE,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, MONITORING,
                        'monitoring'
                       ) MONITORING
           FROM v$instance s, v$instance@&&p_service_name t),
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, LOGGING, 1010, LOGGING,
                        'logging'
                       ) LOGGING
           FROM v$instance s, v$instance@&&p_service_name t),
        row_movement
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, DEGREE, CACHE,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, MONITORING,
                        'monitoring'
                       ) MONITORING
           FROM v$instance s, v$instance@&&p_service_name t),
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, LOGGING, 1010, LOGGING,
                        'logging'
                       ) LOGGING
           FROM v$instance s, v$instance@&&p_service_name t),
        row_movement
   FROM all_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%');

COLUMN dummy      format a26 word_wrapped heading 'CompareTableComments'
COLUMN table_name format a20 word_wrapped heading 'TabName'
COLUMN table_type format a10 word_wrapped heading 'TabType'
COLUMN comments   format a25 word_wrapped heading 'Comments'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, table_type, comments
   FROM all_tab_comments
  WHERE owner = &&p_user_name 
    AND table_type = 'TABLE'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, table_type, comments
   FROM all_tab_comments@&&p_service_name
  WHERE owner = &&p_user_name 
    AND table_type = 'TABLE'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, table_type, comments
   FROM all_tab_comments@&&p_service_name
  WHERE owner = &&p_user_name 
    AND table_type = 'TABLE'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, table_type, comments
   FROM all_tab_comments
  WHERE owner = &&p_user_name 
    AND table_type = 'TABLE'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
;

COLUMN dummy       format a26 word_wrapped heading 'CompareColumnComments'
COLUMN table_name  format a15 word_wrapped heading 'TabName'
COLUMN column_name format a10 word_wrapped heading 'ColumnName'
COLUMN comments    format a35 word_wrapped heading 'Comments'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, column_name, comments
   FROM all_col_comments
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, column_name, comments
   FROM all_col_comments@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, column_name, comments
   FROM all_col_comments@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, column_name, comments
   FROM all_col_comments
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%');

COLUMN dummy           format a26 word_wrapped heading 'CompareLogGroups'
COLUMN table_name      format a20 word_wrapped heading 'TabName'
COLUMN log_group_name  format a20 word_wrapped heading 'LogGroupName'
COLUMN always          format a15 word_wrapped heading 'Cond/Uncond'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, log_group_name,
        DECODE (ALWAYS,
                'ALWAYS', 'Unconditional',
                'CONDITIONAL', 'Conditional',
                NULL, 'Conditional'
               ) ALWAYS
   FROM all_log_groups
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, log_group_name,
        DECODE (ALWAYS,
                'ALWAYS', 'Unconditional',
                'CONDITIONAL', 'Conditional',
                NULL, 'Conditional'
               ) ALWAYS
   FROM all_log_groups@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, log_group_name,
        DECODE (ALWAYS,
                'ALWAYS', 'Unconditional',
                'CONDITIONAL', 'Conditional',
                NULL, 'Conditional'
               ) ALWAYS
   FROM all_log_groups@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, log_group_name,
        DECODE (ALWAYS,
                'ALWAYS', 'Unconditional',
                'CONDITIONAL', 'Conditional',
                NULL, 'Conditional'
               ) ALWAYS
   FROM all_log_groups
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%');

COLUMN dummy               format a26 word_wrapped heading 'CompareNestedTable'
COLUMN table_name          format a15 word_wrapped heading 'TabName'
COLUMN table_type_owner    format a8  word_wrapped heading 'TabTypeOwner'
COLUMN table_type_name     format a15 word_wrapped heading 'TabTypeName'
COLUMN parent_table_name   format a15 word_wrapped heading 'ParentTabName'
COLUMN parent_table_column format a15 word_wrapped heading 'ParentTabCol'
COLUMN storage_spec        format a10 word_wrapped heading 'StorSpec'
COLUMN return_type         format a10 word_wrapped heading 'RetType'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, table_type_owner,
        table_type_name, parent_table_name, parent_table_column, storage_spec,
        return_type
   FROM all_nested_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, table_type_owner,
        table_type_name, parent_table_name, parent_table_column, storage_spec,
        return_type
   FROM all_nested_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, table_type_owner,
        table_type_name, parent_table_name, parent_table_column, storage_spec,
        return_type
   FROM all_nested_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, table_type_owner,
        table_type_name, parent_table_name, parent_table_column, storage_spec,
        return_type
   FROM all_nested_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%');

COLUMN dummy              format a26 word_wrapped heading 'CompareHashPartTable'
COLUMN table_name         format a30 word_wrapped heading 'TabName'
COLUMN partition_position format 9999990 heading 'PartPos'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, partition_position
   FROM all_tab_partitions
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, partition_position
   FROM all_tab_partitions@&&p_service_name
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, partition_position
   FROM all_tab_partitions@&&p_service_name
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, partition_position
   FROM all_tab_partitions
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%');

COLUMN dummy              format a26 word_wrapped heading 'ComparePartTable'
COLUMN table_name         format a30 word_wrapped heading 'TabName'
COLUMN partition_position format 9999990 heading 'PartPos'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, partition_position
   FROM all_tab_partitions
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, partition_position
   FROM all_tab_partitions@&&p_service_name
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, partition_position
   FROM all_tab_partitions@&&p_service_name
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%' 
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, partition_position
   FROM all_tab_partitions
  WHERE table_owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'SYS%');

COLUMN dummy      format a26 word_wrapped heading 'CompareIotTab'
COLUMN table_name format a25 word_wrapped heading 'TabName'
COLUMN iot_name   format a20 word_wrapped heading 'IOTName'
COLUMN iot_type   format a10 word_wrapped heading 'IOTType'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, iot_name, iot_type
   FROM all_tables
  WHERE owner = &&p_user_name
    AND table_name NOT LIKE 'SYS%'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, iot_name, iot_type
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name
    AND table_name NOT LIKE 'SYS%'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, iot_name, iot_type
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name
    AND table_name NOT LIKE 'SYS%'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, iot_name, iot_type
   FROM all_tables
  WHERE owner = &&p_user_name
    AND table_name NOT LIKE 'SYS%'
    AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%');

/*
COLUMN dummy         format a26 word_wrapped heading 'CompareTableAnalyze'
COLUMN table_name    format a25 word_wrapped heading 'TableName'
COLUMN last_analyzed format a30 word_wrapped heading 'LastAnalyzed'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, TRUNC (last_analyzed),
                        TRUNC (SYSDATE)
                       ) last_analyzed
           FROM v$instance s, v$instance@&&p_service_name t)
   FROM all_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, TRUNC (last_analyzed),
                        TRUNC (SYSDATE)
                       ) last_analyzed
           FROM v$instance s, v$instance@&&p_service_name t)
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, TRUNC (last_analyzed),
                        TRUNC (SYSDATE)
                       ) last_analyzed
           FROM v$instance s, v$instance@&&p_service_name t)
   FROM all_tables@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name,
        (SELECT DECODE (   SUBSTR (s.VERSION, 1, INSTR (s.VERSION, '.') - 1)
                        || SUBSTR (t.VERSION, 1, INSTR (t.VERSION, '.') - 1),
                        99, TRUNC (last_analyzed),
                        TRUNC (SYSDATE)
                       ) last_analyzed
           FROM v$instance s, v$instance@&&p_service_name t)
   FROM all_tables
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%' AND table_name NOT LIKE 'MDRT_%$%' AND table_name NOT LIKE 'SYS%');
*/

COLUMN dummy       format a26 word_wrapped heading 'CompareSynonyms'
COLUMN synonym_name format a20 word_wrapped heading 'SynonymName';
COLUMN table_owner format a10 word_wrapped heading 'TableOwner';
COLUMN table_name  format a25 word_wrapped heading 'TableName'
COLUMN db_link     format a20 word_wrapped heading 'DBLink'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms@&&p_service_name
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms
  WHERE owner = &&p_user_name AND table_name NOT LIKE '&&p_table_name%');

COLUMN dummy       format a26 word_wrapped heading 'CompareSynonyms'
COLUMN synonym_name format a20 word_wrapped heading 'SynonymName';
COLUMN table_owner format a10 word_wrapped heading 'TableOwner';
COLUMN table_name  format a25 word_wrapped heading 'TableName'
COLUMN db_link     format a20 word_wrapped heading 'DBLink'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms
  WHERE owner = 'PUBLIC' AND synonym_name like 'QA_DDL_SYN%' AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms@&&p_service_name
  WHERE owner = 'PUBLIC' AND synonym_name like 'QA_DDL_SYN%' AND table_name NOT LIKE '&&p_table_name%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms@&&p_service_name
  WHERE owner = 'PUBLIC' AND synonym_name like 'QA_DDL_SYN%' AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, synonym_name, table_owner, table_name, db_link
   FROM all_synonyms
  WHERE owner = 'PUBLIC' AND synonym_name like 'QA_DDL_SYN%' AND table_name NOT LIKE '&&p_table_name%');

COLUMN dummy             format a26 word_wrapped heading 'CompareConstraint'
COLUMN table_name        format a8  word_wrapped heading 'Table'
COLUMN constraint_name   format a8  word_wrapped heading 'ConName'
COLUMN constraint_type   format a8  word_wrapped heading 'ConType'
COLUMN r_owner           format a5  word_wrapped heading 'ROwn'
COLUMN r_constraint_name format a5  word_wrapped heading 'RCon'
COLUMN delete_rule       format a4  word_wrapped heading 'DlR'
COLUMN status            format a4  word_wrapped heading 'St'
COLUMN deferrable        format a4  word_wrapped heading 'Dfb'
COLUMN deferred          format a4  word_wrapped heading 'Dfd'
COLUMN validated         format a4  word_wrapped heading 'Val'
COLUMN generated         format a4  word_wrapped heading 'Gen'
COLUMN bad               format a4  word_wrapped heading 'Bad'
COLUMN rely              format a5  word_wrapped heading 'Rely'
--COLUMN index_owner       format a5  word_wrapped heading 'IOwn'
COLUMN index_name        format a5  word_wrapped heading 'INam'
COLUMN invalid           format a5  word_wrapped heading 'Invl'
COLUMN view_related      format a5  word_wrapped heading 'View'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, constraint_name,
        constraint_type, r_owner, r_constraint_name, delete_rule, status,
        deferrable, deferred, validated, generated, bad, rely, 
        --index_owner,
        index_name, invalid, view_related
   FROM all_constraints
  WHERE owner = &&p_user_name
    AND constraint_name NOT LIKE '%SYS%'
    AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, constraint_name,
        constraint_type, r_owner, r_constraint_name, delete_rule, status,
        deferrable, deferred, validated, generated, bad, rely, 
        --index_owner,
        index_name, invalid, view_related
   FROM all_constraints@&&p_service_name
  WHERE owner = &&p_user_name
    AND constraint_name NOT LIKE '%SYS%'
    AND table_name NOT LIKE '&&p_table_name%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, constraint_name,
        constraint_type, r_owner, r_constraint_name, delete_rule, status,
        deferrable, deferred, validated, generated, bad, rely, 
        --index_owner,
        index_name, invalid, view_related
   FROM all_constraints@&&p_service_name
  WHERE owner = &&p_user_name
    AND constraint_name NOT LIKE '%SYS%'
    AND table_name NOT LIKE '&&p_table_name%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, constraint_name,
        constraint_type, r_owner, r_constraint_name, delete_rule, status,
        deferrable, deferred, validated, generated, bad, rely, 
        --index_owner,
        index_name, invalid, view_related
   FROM all_constraints
  WHERE owner = &&p_user_name
    AND constraint_name NOT LIKE '%SYS%'
    AND table_name NOT LIKE '&&p_table_name%');

COLUMN dummy format a26 word_wrapped heading 'CompareTypeStructure'
COLUMN type_name format a20 word_wrapped heading 'TypeName'
COLUMN attr_name format a15 word_wrapped heading 'AttrName'
COLUMN attr_type format a10 word_wrapped heading 'AttrType'
COLUMN length format 9990 heading 'Len'
COLUMN precision format 9990 heading 'Prec'
COLUMN scale format 9990 heading 'Scale'

(SELECT 'Failed:: IN Src, NOT Trg' dummy, type_name, attr_name,
        attr_type_name, LENGTH, PRECISION, scale
   FROM all_type_attrs
  WHERE owner = &&p_user_name
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, type_name, attr_name,
        attr_type_name, LENGTH, PRECISION, scale
   FROM all_type_attrs@&&p_service_name
  WHERE owner = &&p_user_name)
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, type_name, attr_name,
        attr_type_name, LENGTH, PRECISION, scale
   FROM all_type_attrs@&&p_service_name
  WHERE owner = &&p_user_name
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, type_name, attr_name,
        attr_type_name, LENGTH, PRECISION, scale
   FROM all_type_attrs
  WHERE owner = &&p_user_name);

COLUMN dummy         format a26 word_wrapped heading 'CompareSeqStructure'
COLUMN sequence_name format a20 word_wrapped heading 'Sequence';
COLUMN cycle_flag    format a5 word_wrapped  heading 'CF';
COLUMN order_flag    format a5 word_wrapped  heading 'OF';
COLUMN cache_size    format 9999999999       heading 'CacheSize';
COLUMN last_number   format 9999999999       heading 'LastNumber';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, sequence_name,
         cycle_flag, order_flag, cache_size, last_number
   FROM all_sequences
  WHERE sequence_owner = &&p_user_name AND sequence_name NOT LIKE 'MDRS_%$%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, sequence_name,
         cycle_flag, order_flag, cache_size, last_number
   FROM all_sequences@&&p_service_name
  WHERE sequence_owner = &&p_user_name AND sequence_name NOT LIKE 'MDRS_%$%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, sequence_name,
         cycle_flag, order_flag, cache_size, last_number
   FROM all_sequences@&&p_service_name
  WHERE sequence_owner = &&p_user_name AND sequence_name NOT LIKE 'MDRS_%$%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, sequence_name,
        cycle_flag, order_flag, cache_size, last_number
   FROM all_sequences
  WHERE sequence_owner = &&p_user_name AND sequence_name NOT LIKE 'MDRS_%$%');

COLUMN dummy format a26 word_wrapped heading 'CompareSourceCode'
COLUMN type  format a10 word_wrapped heading 'Type';
COLUMN name  format a10 word_wrapped heading 'Name';
COLUMN line  format 9999999999       heading 'Line';
COLUMN text  format a25 word_wrapped heading 'Text';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, TYPE, NAME, line, text
   FROM all_source
  WHERE owner = &&p_user_name
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, TYPE, NAME, line, text
   FROM all_source@&&p_service_name
  WHERE owner = &&p_user_name)
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, TYPE, NAME, line, text
   FROM all_source@&&p_service_name
  WHERE owner = &&p_user_name
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, TYPE, NAME, line, text
   FROM all_source
  WHERE owner = &&p_user_name);

COLUMN dummy                       format a26 word_wrapped heading 'CompUserAttr'
COLUMN username                    format a10 word_wrapped heading 'UserName';
COLUMN account_status              format a10 word_wrapped heading 'AcctSt';
COLUMN default_tablespace          format a10 word_wrapped heading 'DefTbsp';
COLUMN temporary_tablespace        format a10 word_wrapped heading 'TempTbsp';
COLUMN profile                     format a8  word_wrapped heading 'Profile';
COLUMN initial_rsrc_consumer_group format a10 word_wrapped heading 'IniConsGroup';
COLUMN external_name               format a10 word_wrapped heading 'ExtName';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, username, account_status,
        default_tablespace, temporary_tablespace, profile,
        initial_rsrc_consumer_group, external_name
   FROM dba_users
  WHERE username LIKE UPPER ('&&3%')
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, username, account_status,
        default_tablespace, temporary_tablespace, profile,
        initial_rsrc_consumer_group, external_name
   FROM dba_users@&&p_service_name
  WHERE username LIKE UPPER ('&&3%'))
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, username, account_status,
        default_tablespace, temporary_tablespace, profile,
        initial_rsrc_consumer_group, external_name
   FROM dba_users@&&p_service_name
  WHERE username LIKE UPPER ('&&3%')
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, username, account_status,
        default_tablespace, temporary_tablespace, profile,
        initial_rsrc_consumer_group, external_name
   FROM dba_users
  WHERE username LIKE UPPER ('&&3%'));

COLUMN dummy             format a26 word_wrapped heading 'CompareRoleAttr'
COLUMN role              format a25 word_wrapped heading 'Role';
COLUMN password_required format a10 word_wrapped heading 'PasswReq';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, ROLE, password_required
   FROM dba_roles
  WHERE ROLE LIKE 'SP_DDL_ROLE%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, ROLE, password_required
   FROM dba_roles@&&p_service_name
  WHERE ROLE LIKE 'SP_DDL_ROLE%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, ROLE, password_required
   FROM dba_roles@&&p_service_name
  WHERE ROLE LIKE 'SP_DDL_ROLE%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, ROLE, password_required
   FROM dba_roles
  WHERE ROLE LIKE 'SP_DDL_ROLE%');

COLUMN dummy      format a26 word_wrapped heading 'CompareObjPriv'
COLUMN table_name format a10 word_wrapped heading 'TableName'
COLUMN grantee    format a15 word_wrapped heading 'Grantee';
COLUMN privilege  format a15 word_wrapped heading 'Privilege';
COLUMN grantable  format a10 word_wrapped heading 'Grantable';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, grantee, PRIVILEGE,
        grantable
   FROM dba_tab_privs
  WHERE grantee LIKE UPPER ('&&3%')
    AND table_name NOT LIKE '&&p_table_name%'
    AND table_name <> 'LOB_FILES'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, table_name, grantee, PRIVILEGE,
        grantable
   FROM dba_tab_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%')
    AND table_name NOT LIKE '&&p_table_name%'
    AND table_name <> 'LOB_FILES')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, grantee, PRIVILEGE,
        grantable
   FROM dba_tab_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%')
    AND table_name NOT LIKE '&&p_table_name%'
    AND table_name <> 'LOB_FILES'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, table_name, grantee, PRIVILEGE,
        grantable
   FROM dba_tab_privs
  WHERE grantee LIKE UPPER ('&&3%')
    AND table_name NOT LIKE '&&p_table_name%'
    AND table_name <> 'LOB_FILES');

COLUMN dummy        format a26 word_wrapped heading 'CompareSystemPriv'
COLUMN grantee      format a20 word_wrapped heading 'Grantee';
COLUMN privilege    format a20 word_wrapped heading 'Privilege';
COLUMN admin_option format a10 word_wrapped heading 'AdmOption';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs
  WHERE grantee LIKE UPPER ('&&3%') AND upper(PRIVILEGE) NOT LIKE '%INHERIT%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%') AND upper(PRIVILEGE) NOT LIKE '%INHERIT%')
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%') AND upper(PRIVILEGE) NOT LIKE '%INHERIT%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs
  WHERE grantee LIKE UPPER ('&&3%') AND upper(PRIVILEGE) NOT LIKE '%INHERIT%');

COLUMN dummy        format a26 word_wrapped heading 'CompareRolePrivilege'
COLUMN granted_role format a15 word_wrapped heading 'GrantedRole';
COLUMN default_role format a15 word_wrapped heading 'DefRole';
COLUMN admin_option format a10 word_wrapped heading 'AdmOption';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, granted_role, default_role,
        admin_option
   FROM dba_role_privs
  WHERE grantee LIKE UPPER ('&&3%')
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, granted_role, default_role,
        admin_option
   FROM dba_role_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%'))
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, granted_role, default_role,
        admin_option
   FROM dba_role_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%')
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, granted_role, default_role,
        admin_option
   FROM dba_role_privs
  WHERE grantee LIKE UPPER ('&&3%'));

COLUMN dummy        format a26 word_wrapped heading 'CompareSystemRolePriv'
COLUMN grantee      format a20 word_wrapped heading 'Grantee';
COLUMN privilege    format a20 word_wrapped heading 'Privilege';
COLUMN admin_option format a10 word_wrapped heading 'AdmOption';

(SELECT 'Failed:: IN Src, NOT Trg' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs
  WHERE grantee LIKE UPPER ('&&3%')
    AND upper(privilege) NOT LIKE '%INHERIT%'
 MINUS
 SELECT 'Failed:: IN Src, NOT Trg' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%')
    AND upper(privilege) NOT LIKE '%INHERIT%'
)
UNION ALL
(SELECT 'Failed:: IN Trg, NOT Src' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs@&&p_service_name
  WHERE grantee LIKE UPPER ('&&3%')
    AND upper(privilege) NOT LIKE '%INHERIT%'
 MINUS
 SELECT 'Failed:: IN Trg, NOT Src' dummy, grantee, PRIVILEGE, admin_option
   FROM dba_sys_privs
  WHERE grantee LIKE UPPER ('&&3%')
    AND upper(privilege) NOT LIKE '%INHERIT%'
);

SET verify on
SET feedback on

