#!/usr/bin/ksh
# ==============================================================================
# Name:              DML on tabs with UDT datatypes                              
# ID:                18274                                                       
# Author:            Ilya Rubizhevsky                                            
# Short Desc:        DML on tabs with UDT datatypes                              
# Lowest SPO:        4.5                                                         
# Lowest DB:         10.1.0 Enterprise Edition 64                                
# ==============================================================================
. $AUTO_ROOT_DIR/splex.ksh
config=$1
export TESTCASE_ID=18274
export debug_level=0
oracle_vars $config
# ==============================================================================
function compare 
{ 
#SPO compare 
#splex_compare "compare config $config" "PASS" 
#send_unix dst 0 "grep insert ${AUTO_DST_VAR_DIR}/log/*-*.sql" log 
#send_unix dst 0 "grep delete ${AUTO_DST_VAR_DIR}/log/*-*.sql" log 
#send_unix dst 0 "grep rowid ${AUTO_DST_VAR_DIR}/log/*-*.sql" log 
#send_unix dst 0 "grep update ${AUTO_DST_VAR_DIR}/log/*-*.sql" log 
 
#in-house compare 
run_sql_file src 0 qa_analyze_tab.sql $AUTO_SRC_SP_USER log 
run_sql_file dst 0 qa_analyze_tab.sql $AUTO_DST_SP_USER log 
run_sql_file src 0 qa_comp_tab_chain_cnt.sql $AUTO_SRC_SP_USER log 
compare_count_all src 0 dst 0 $AUTO_SRC_ORA_SPADMIN_UID 
run_sql_file src 0 qa_comp_tab_all.sql $AUTO_SRC_SP_USER log 
run_sql_file src 0 qa_compare_all.sql $AUTO_SRC_SP_USER log 
 
check_log_on src 0 
check_log_on dst 0 
} 
run_sql_file src 0 qa_udt_ins.ilya $AUTO_SRC_SP_USER log 
flush_datasource 
compare 
#run_sql_file src 0 qa_udt_upd.sql $AUTO_SRC_SP_USER log 
#flush_datasource 
#compare 
##run_sql_file src 0 qa_udt_del.sql $AUTO_SRC_SP_USER log 
##flush_datasource 
##compare 
#run_sql_file src 0 qa_udt_iud.sql $AUTO_SRC_SP_USER log 
#flush_datasource 
#compare 
check_log_on src 0 
check_log_on dst 0 
 
stop_test 

