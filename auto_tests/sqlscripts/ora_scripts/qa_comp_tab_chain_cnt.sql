REM -----------------------------------------------------------------------
REM Filename:   qa_comp_tab_chain_cnt.sql
REM Purpose:    compare count source and target tables
REM
REM Date:       03/22/06
REM Author:     Ilya Rubizhevsky
REM -----------------------------------------------------------------------

SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off

UNDEFINE p_service_name
UNDEFINE p_user_name
DEFINE   p_service_name='&4'
DEFINE   p_user_name=upper('&3')

SELECT (CASE
           WHEN src.num_rows <> dst.num_rows
              THEN 'Warning::'
           WHEN src.num_rows = dst.num_rows
              THEN 'Passed::'
        END
       ) "Result",
       src.table_name "TableName", src.num_rows "SrcCnt",
       src.chain_cnt "SrcChain",
       TRUNC (  100
              * NVL (src.chain_cnt, 0)
              / DECODE (src.num_rows, NULL, 1, 0, 1, src.num_rows),
              2
             ) "Src%Chain",
       dst.num_rows "DstCnt", dst.chain_cnt "DstChain",
       TRUNC (  100
              * NVL (dst.chain_cnt, 0)
              / DECODE (dst.num_rows, NULL, 1, 0, 1, dst.num_rows),
              2
             ) "Dst%Chain"
  FROM (SELECT '"'||table_name||'"' table_name, num_rows, chain_cnt
          FROM all_tables
         WHERE owner = &&p_user_name) src,
       (SELECT '"'||table_name||'"' table_name, num_rows, chain_cnt
          FROM all_tables@&&p_service_name
         WHERE owner = &&p_user_name) dst
 WHERE src.table_name = dst.table_name;

SET feedback on
SET verify on

