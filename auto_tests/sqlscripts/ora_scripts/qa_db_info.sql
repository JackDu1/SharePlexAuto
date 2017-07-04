REM -----------------------------------------------------------------------
REM Filename:   qa_db_info.sql
REM Purpose:    get db info
REM
REM Date:       06/22/06
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off

PROMPT
PROMPT =======================
PROMPT DB Supplemental Logging
PROMPT =======================

COLUMN supplemental_log_data_min format a10 word_wrapped heading 'Min'
COLUMN supplemental_log_data_pk  format a10 word_wrapped heading 'PK'
COLUMN supplemental_log_data_ui  format a10 word_wrapped heading 'UI'
COLUMN force_logging             format a10 word_wrapped heading 'Force'

SELECT   supplemental_log_data_min, supplemental_log_data_pk, supplemental_log_data_ui, force_logging
    FROM v$database;

SET feedback on
SET verify on

