#!/usr/bin/ksh
# ==============================================================================
# Name:              Test setup                                                  
# ID:                14634                                                       
# Author:            Ilya Rubizhevsky                                            
# Short Desc:        Test setup - create users, link and pakage on source and target
# Lowest SPO:        5.0                                                         
# Lowest DB:         9.2.0 Enterprise Edition 32                                 
# ==============================================================================
. $AUTO_ROOT_DIR/splex.ksh
config=$1
export TESTCASE_ID=14634
export debug_level=0
oracle_vars $config
# ==============================================================================
execute src 0 "set param SP_OCT_REPLICATE_ALL_DDL 0" 
if [[ -n $AUTO_EXTENSIVE ]]; then 
        send src 0 "list param capture" log 
fi 
get_string_spctrl src 0 "list param capture" "SP_OCT_REPLICATE_ALL_DDL.*0" PASS email 

execute src 0 "activate config demo.conf" 
get_string_spctrl src 0 "list config" "^demo.conf.*Active" PASS email 
 
if [[ -n $AUTO_EXTENSIVE ]]; then 
    send_unix src 0 "tail ${s_vardir0}/log/commands_log" log 
    send_unix src 0 "ls -l ${s_vardir0}/log/${s_sid0}_log.rmp" log 
    get_string_spctrl src 0 "list config" "Internal Name" PASS email 
fi 
 
run_sql_file src 0 qa_create_db_link.sql $AUTO_SRC_ORA_SPADMIN_UID log 
run_sql_file src 0 qa_db_info.sql $AUTO_SRC_ORA_SPADMIN_UID log 
 
run_lob_script src 0 $AUTO_SRC_ORA_SPADMIN_UID $AUTO_SRC_ORA_SPADMIN_PWD qa_dummy.sql 
run_lob_script dst 0 $AUTO_DST_ORA_SPADMIN_UID $AUTO_DST_ORA_SPADMIN_PWD qa_dummy.sql 
run_sql_file src 0 qa_drop_create_sp_ddl_all_user.sql $AUTO_SRC_ORA_SPADMIN_UID log 
run_sql_file dst 0 qa_drop_create_sp_ddl_all_user.sql $AUTO_DST_ORA_SPADMIN_UID log 
 
#drop QA_DDL... roles and users 
run_sql_file src 0 qa_ddlreg_drop_roles_users_pubsyns.sql $AUTO_SRC_ORA_SPADMIN_UID log 
run_sql_file dst 0 qa_ddlreg_drop_roles_users_pubsyns.sql $AUTO_DST_ORA_SPADMIN_UID log 
 
send_sql_cmd src 0 "GRANT READ, WRITE ON DIRECTORY LOB_FILES TO sp_otest WITH GRANT OPTION;" $AUTO_SRC_ORA_SPADMIN_UID log 
send_sql_cmd dst 0 "GRANT READ, WRITE ON DIRECTORY LOB_FILES TO sp_otest WITH GRANT OPTION;" $AUTO_DST_ORA_SPADMIN_UID log 
 
if [[ -n $AUTO_QA_SQL ]]; then 
 run_sql_file src 0 $AUTO_QA_SQL $AUTO_SRC_SP_USER log 
 run_sql_file dst 0 $AUTO_QA_SQL $AUTO_DST_SP_USER log 
else 
 run_sql_file src 0 qa_sql.sql $AUTO_SRC_SP_USER log 
 run_sql_file dst 0 qa_sql.sql $AUTO_DST_SP_USER log 
fi 
 
run_sql_file src 0 qa_check_qa_sql_status.sql $AUTO_SRC_SP_USER log 
run_sql_file dst 0 qa_check_qa_sql_status.sql $AUTO_DST_SP_USER log 

run_sql_file src 0 qa_ddml.sql $AUTO_SRC_SP_USER log 
run_sql_file dst 0 qa_ddml.sql $AUTO_DST_SP_USER log 
 
run_sql_file src 0 qa_compare_all.sql $AUTO_SRC_SP_USER log 
 
check_log_on src 0 
check_log_on dst 0 
 
stop_test 
 