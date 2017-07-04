#!/usr/bin/ksh
# ==============================================================================
# Name:              Test setup - create tables on src/trg (rmd)                 
# ID:                14702                                                       
# Author:            Ilya Rubizhevsky                                            
# Short Desc:        Test setup - create tables on source / target (Disable Row Movement)
# Lowest SPO:        4.5                                                         
# Lowest DB:         9.2.0 Enterprise Edition 32                                 
# ==============================================================================
. $AUTO_ROOT_DIR/splex.ksh
config=$1
export TESTCASE_ID=14702
export debug_level=0
oracle_vars $config
# ==============================================================================
run_sql_file src 0 $config $AUTO_SRC_SP_USER log 
run_sql_file dst 0 $config $AUTO_DST_SP_USER log 

if [[ -n $AUTO_SECUREFILE_LOB ]]; then
  run_sql_file src 0 ${AUTO_SECUREFILE_LOB}_ofu.sql $AUTO_SRC_SP_USER log 
  run_sql_file dst 0 ${AUTO_SECUREFILE_LOB}_ofu.sql $AUTO_DST_SP_USER log
  run_sql_file src 0 ${AUTO_SECUREFILE_LOB}_comp.sql $AUTO_SRC_SP_USER  log
fi

run_sql_file src 0 qa_compare_all.sql $AUTO_SRC_SP_USER log 
stop_test 