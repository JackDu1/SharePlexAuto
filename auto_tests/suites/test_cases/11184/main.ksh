#!/usr/bin/ksh
# ==============================================================================
# Name:              11184                                                       
# ID:                11184                                                       
# Author:            Tim Whetsel                                                 
# Short Desc:        Activate config with default options                        
# Lowest SPO:        4.0                                                         
# Lowest DB:         8.1.7 Enterprise Edition 32                                 
# ==============================================================================
. $AUTO_ROOT_DIR/splex.ksh
config=$1
export TESTCASE_ID=11184
export debug_level=0
oracle_vars $config
# ==============================================================================
#skip_test 999999 44

execute src 0 "activate config $config"
get_string_spctrl src 0 "list config" "^$config.*Active" PASS email

if [[ -n $AUTO_EXTENSIVE ]]; then
    send_unix src 0 "tail ${s_vardir0}/log/commands_log" log
    send_unix src 0 "ls -l ${s_vardir0}/log/${s_sid0}_log.rmp" log
    get_string_spctrl src 0 "list config" "Internal Name" PASS email
fi

check_log_on src 0
check_log_on dst 0

stop_test