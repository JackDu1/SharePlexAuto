# ===================================================================================================================================================================================
# By: Sergio R. Vidales, Peter Hom, Ittai Shadmon
# Perfected by: Tim Whetsel
# 2015-5-5 Julia v13: Add function AddToParamDB by Candy 
# 2015_5-8 Julia v14: change local otest for Windows from otest.10.interval to otest.10.anydata (64bit) to solve issue on 2012R2 Oracle 12c Windows
# 2015_5_8 Julia v15: set local variable (typeset WrkOtestPrmFile=$1) in SetupLocal to avoid null value  
# 2015-5-13 Julia v16: Add function check_processlog_on by Candy 
# 2015-5-14 Julia v17 current: add Candy's fix AddToParamDB removing old entry to avoid duplicates, and include HostId local variable to comply with others
# 2015-6-06 Ilya v18 add new functions to support mss 1) function mss_cleansp, 2) function jdbc_compare
# 2015-8-11 Julia run ora_cleansp_pdb when ORACLE_SID is pdb
# 2015-8-13 Julia run localotest (SetupLocal) when ORACLE_SID is pdb
# 2015-9-09 Ilya v21 add new functions to support postgres -  function ppas_cleansp, run_ppas_file, set_ppas_env, check_ppas
# 2015-9-15 Ilya v22 added sdb and tdb into jdbc_compare function
# 2015-9-29 Julia v23 added rtrim option to jdbc_compare_rtrim function to be used on char or nchar where spaces are padded and could cause OOS when character sets are different 
# 2015-10-7 Ilya v24 change to use psql for ppas i/o isql
#           Julia v24 comment out post from LogIt to avoid automation issue 'cleanup_on_process_error" "Failed:: Process "post post" is an invalid proc to check 
# 2015-10-?? Ilya v25 changed psql command
# 2015-10-21 Ilya v26 changed SP_SYS_VARDIR to JDBC_COMPARE_VARDIR in jdbc_compare function
#                     changed logic for OOS in jdbc_compare function
# 2015-10-22 Ilya v27 add timeout in jdbc_compare function, since Kbai system hangs at jdbc_compare
# 2016-2-03 Julia v28 add JDBC_compare RAC support on source
# 2016-2-19 Julia v29 for splex_compare wait_for_process should use sp_desvr and sp_declt path $AUTO_SRC[DST]_OPT_DIR/.app-modules instead of $AUTO_SRC[DST]_OPT_DIR/bin
#                     also add flush_datasource_ot  = flush_datasource + wait_for_process $AUTO_DST_OPT_DIR/.app-modules/sp_xpst
#                     if AUTO_FLUSH_DATASOURCE_OT=1 is exported, run flush_datasource_ot instead of flush_datasource
# 2016-2-23 Kbai v30 added run_td_file function in order to run Automation on Teradata target.
# 2016-2-23 Kbai v30 added set_td_env&check_td functions to set env and check isql connection for run_td_file function.
# 2016-2-29 Julia change function _SPCTRL_CmdLocToRemote replace 8*) with *) to support version above 9
# 2016-2-29 Julia add Candy's change of flush_datasource & wait_4_all_post
# 2016-3-10 Julia argument name change by Candy n _wait_4_all_post
# 2016-3-10 kbai add td_cleansp function
# 2016-4-12 Add Candy's modification to flush_datasource and _wait_4_all_post (SPO-2033) to fix the bug Lighter ran into on exa2dbadm01/02
# 2016-5-12 Julia add -p[port#] in run_ppas_file when environment variable AUTO_PG_PORT is exported to establish remote connection to PostgreSQL Community Edition
#           In QA environment, PPAS is using port#5444 while PostgreSQL Community Edition is using default port#5432 and we have both dbs installed on spqslr71f 
# 2016-5-17 Julia having JDBC_compare to use port # from user exported AUTO_PG_PORT for PostgreSQL community edition where our port # is set to default 5432
# 2016-5-25 Julia add set_hana_env, check_hana, and run_hana_file to support remote SAP HANA sql scripts running from automation server 
#                 re-order check_oracle/mss/ppas/td/hana; set_oracle/mss/ppas/td/hana_env; run_sql/mss/ppas/td/hana_file   
# 2016-5-25 Julia add hana_cleansp  
# 2016-6-01 Juia v38 is missing Candy's sftp change in TransferFile_v1.py, merge it into v39.
# 2016-6-09 Julia v40 modify JDBC_compare for SAP HANA to pass in Hana user password which is different than username
#                     also use rtrim for Hana due to char datatype in col table is trimed 
#                     Log exact jdbc_compare command for each if condition
# 2016-6-14 Julia update Candy's get_remote_file using _GetOtestPlatform instead of rexec to get os, use old TransferFile.py for Windows and AIX, TransferFile_v1.py for the rest
# 2016-7-01 Julia set local OptDir=$AUTO_LOC_OPT_DIR_90 to enable using sp_ctrl command "view partitions all" 
# 2016-7-15 Julia v.43 modify run_mss_file to accept login other than $AUTO_DST_SP_USER and a password which is not the same as username (1. SQL Server can be source in 9.0+, 2. New test user ssc does not exist yet when autoamtion checks mss version)
# 2016-7-15 Julia v.43 create send_two command to handle remote sp_ctrl command with "set" or "where" condition that must be placed after [ on host] 
# 2016-7-19 Julia v43 modify run_mss_file to log output and errors, PASS|FAIL TC based on errors
# 2016-8-10 Candy v44 use AUTO_DST_PPAS_DB for ppas database in run_ppas_file function (old one use AUTO_DST_SP_USER)
# 2016-12-16 Julia: revert v47 change in v48, we should use rtrim for sap, beside the change was made at only srac block
# 2017-2-17 Candy v49: add functions for mysql: set_mysql_env, check_mysql, run_mysql_file, mysql_cleansp
# 2017-3-3 Candy v50: modify function jdbc_compare to supoort new jdbc compare
# 2017-4-21 Candy v51: add function run_msstest
# 2017-4-27 Candy v52: modify jdbc compare to support sqlserver capture
# 2017-5-15 Candy v53: add two parameters(-Xms1g -Xmx2g) in jdbc compare for mysql database; when target database is teradata, change qarun user as target database user in jdbc_compare
# ===================================================================================================================================================================================

# had to put here for new python harness. Usually mstrlib does it
. $AUTO_ROOT_DIR/syslib.ksh

################################################################################
#                       ROLL OUTS TO EVERYONE
################################################################################
#09-13-04 v 1.9.2.42.2.61.2.34  rel-2-0-1
#01-05-2004 v1.9.2.42.2.26       rel-2-0-1

#trap 'clean_on_trap;exit' 1 2 3 15

#############################################################################
#                           PUBLIC FUNCTIONS
#############################################################################

# ==============================================================================
# Name: debug_pause
# ==============================================================================

	function debug_pause
	{
		typeset req_level
		typeset enter

		req_level=$1

		#old --> if [ "$debug_on" -eq "$req_level" ]
                # Changed by tim 8/12/2003
                if [ "$debug_on" = "$req_level" ]
		then
                       	>& -   #pxh012
			echo "\n Debug is ON: Press Enter to continue.\c"
			read enter
		fi
	}

# ==============================================================================
# Name: clean_on_trap
# ==============================================================================

	function clean_on_trap
	{

		echo "CTRL+C or KILL signal detected"
		echo "cleaning ${curr_dir}/tmp/${AUTO_TESTER}* files before exiting....."
                echo "cleaning $AUTO_WORK_DIR/$AUTO_TESTER* files before exiting....."

		rm ${curr_dir}/${AUTO_TESTER}*
                rm ${curr_dir}/tmp/${AUTO_TESTER}*
                rm $AUTO_WORK_DIR/$AUTO_TESTER*
		echo "Exiting Automation....."
	}

# =============================================================
# Name: check_expect
# =============================================================

function check_expect
{
        typeset new_command
        new_command=$*
	echo "$new_command"

	debug_pause 1

        if [ "$PLATFORM" = "$WINDOWS" ];then
                echo COMMONDIR=$COMMONDIR
                $new_command | tee $COMMONDIR/${AUTO_TESTER}_wnt.log
                if [ $? -ne 0 ];then
                        if [ `egrep -c "Number of licenses exceeded" ${COMMONDIR}/${AUTO_TESTER}_wnt.log` -gt 0 ];then  
                                LogIt "Rerunning due to the Number of licenses exceeded error message"
                                $new_command
                                if [ $? -ne 0 ];then
                                        return 1
                                else    
                                        return 0
                                fi      
                        fi      
                else    
                        return 0
                fi      
        else    
                LogIt "Running $new_command"
                $new_command
                if [ $? -ne 0 ];then
                        return 1
                else    
                        return 0
                fi      
        fi      

}

# ==============================================================================
# Name: skip_test
# ==============================================================================

        function skip_test
        {
 [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
	typeset cr_num
                typeset testplan_id
                typeset curr_drop
                typeset drop_version

                cr_num=$1
                testplan_id=$2
                curr_tpid=`cat $AUTO_TEST_CASE_LOG | grep TESTPLAN_ID | cut -d= -f2`
                if [ "$curr_tpid" == "$testplan_id" ]
                then
                        cat $AUTO_TEST_CASE_LOG|sed s/BUG_ID=/BUG_ID=$cr_num/ > $AUTO_TEST_CASE_LOG
                        LogIt "Warning:: Test was skipped_test due to CR#$cr_num"
                        stop_test
                        exit 0
                fi
        }

# ==============================================================================
# Name: echo_sleep
# ==============================================================================

 function echo_sleep
 {
  if [ $1 -gt 0 -a $1 -lt 100000000 ];
  then
   S=$1
   echo "Seconds Remaining:  $S\c"
   sleep 1
   while [ $S -gt 0 ];
   do
	if [ $S -lt "10" ];
	then
		echo "\b\b\c"
		echo "   \c"
		echo "\b\b\c"
        elif [ $S -ge "10" -a $S -lt "100" ];
	  then
                echo "\b\b\b\c"
                echo "    \c"
                echo "\b\b\b\c"
        elif [ $S -ge "100" -a $S -lt "1000" ];
        then
                echo "\b\b\b\b\c"
                echo "     \c"
                echo "\b\b\b\b\c"
        elif [ $S -ge "1000" -a $S -lt "10000" ];
        then
                echo "\b\b\b\b\b\c"
                echo "      \c"
                echo "\b\b\b\b\b\c"
        elif [ $S -ge "10000" -a $S -lt "100000" ];
        then
                echo "\b\b\b\b\b\b\c"
                echo "       \c"
                echo "\b\b\b\b\b\b\c"
        elif [ $S -ge "100000" -a $S -lt "1000000" ];
        then
                echo "\b\b\b\b\b\b\b\c"
                echo "        \c"
                echo "\b\b\b\b\b\b\b\c"
        elif [ $S -ge "1000000" -a $S -lt "10000000" ];
        then
                echo "\b\b\b\b\b\b\b\b\c"
                echo "         \c"
                echo "\b\b\b\b\b\b\b\b\c"
        elif [ $S -ge "10000000" -a $S -lt "100000000" ];
        then
                echo "\b\b\b\b\b\b\b\b\b\c"
                echo "          \c"
                echo "\b\b\b\b\b\b\b\b\b\c"
        fi

	((S = $S - 1))
	echo "$S\c"
	sleep 1
   done
   echo ""
  else
      echo "Number of sec $1 is incorrect. Must be (1 - 99999999 sec). Exiting..."
      exit 0
  fi
}

# ==============================================================================
# Name: remove_if_exist
# ==============================================================================
function remove_if_exist {

    typeset file_name=$1

    if [ -e $file_name ]; then
       rm -fv $file_name
    fi

}


# ==============================================================================
# Name: check_if_exist
# ==============================================================================
function check_if_exist {

    typeset filename=$1

    typeset sleeptime=1
    typeset countermax=24
    typeset counter=1

    while (($counter < $countermax)); do

        if [ -s $filename ]; then
            counter=1000
            break
        fi

        sleep $sleeptime

        String="`date`: waiting for $filename to become nonzero size..."
        LogIt "$String"

        if [ $counter -eq 5 ]; then

            LogIt "`date`: waiting for ${filename} to become nonzero size..."

            SendEMail "${filename} in TC# $AUTO_CURRENT_TEST_ID is zero size" \
                      "`date`: waiting for ${filename} to become nonzero size..." 

        fi

        echo '-'"\b\c"
        sleep $sleeptime
        echo '\\'"\b\c"
        sleep $sleeptime
        echo "|\b\c"
        sleep $sleeptime
        echo "/\b\c"
        sleep $sleeptime

        counter=`expr $counter + 1`

    done
}

# ==============================================================================
# Name: check_result
# ==============================================================================
function check_result {

    typeset Message=$1
    typeset Result=$2

    if [ $Result -ne $TRUE ]; then
        LogIt "Failed:: $Message"
    else
        LogIt "Passed:: $Message"
    fi
}

# ==============================================================================
# Name: check_result_fail
# ==============================================================================
function check_result_fail {

    typeset message=$1
    typeset result=$2

    if [ $result -ne 0 ]; then
        LogIt "Passed:: $message"
    else
        LogIt "Failed:: $message"
    fi

}


# ==============================================================================
# Name: check_oracle
# ==============================================================================
function check_oracle {


    [[ -n $AUTO_SKIP_CHECK_ORACLE ]] && {
        LogIt "AUTO_SKIP_CHECK_ORACLE is set. check_oracle will not be executed."
        return
    }

    typeset Host=$1

    typeset sleeptime=5
    typeset counter=1


    while :
    do
        OUT=`tnsping $Host`

        if [ "$?" = "0" ]; then
            LogIt "`date`: $Host is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to Oracle in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            #echo '-'"\b\c"
            #sleep $sleeptime
            #echo '\\'"\b\c"
            #sleep $sleeptime
            #echo "|\b\c"
            #sleep $sleeptime
            #echo "/\b\c"
            #sleep $sleeptime

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_mss
# ==============================================================================
function check_mss {


    [[ -n $AUTO_SKIP_CHECK_MSS ]] && {
        LogIt "AUTO_SKIP_CHECK_MSS is set. check_mss will not be executed."
        return
    }

    typeset Host=$1
    typeset User=$2
    typeset Pwd=$3

    typeset sleeptime=5
    typeset counter=1


    while :
    do
        sqlcmd -S $Host -U $User -P $Pwd -Q "SELECT @@SERVERNAME;"
        #sqlcmd -S $AUTO_DST_HOST_NAME -U $AUTO_DST_SP_USER -P $AUTO_DST_SP_USER -Q "SELECT @@SERVERNAME;"
        #sqlcmd -S $d_host0 -U $User -P $User -q "SELECT @@SERVERNAME;"

        if [ "$?" = "0" ]; then
            LogIt "`date`: $Host is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to MSS in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_ppas
# ==============================================================================
function check_ppas {


    [[ -n $AUTO_SKIP_CHECK_PPAS ]] && {
        LogIt "AUTO_SKIP_CHECK_PPAS is set. check_ppas will not be executed."
        return
    }

    typeset Host=$1

    typeset sleeptime=5
    typeset counter=1

    . $AUTO_ROOT_DIR/local_psql

    while :
    do
        if [[ -n $AUTO_PG_PORT ]]; then
           psql -h $AUTO_DST_HOST_NAME -p $AUTO_PG_PORT -d $AUTO_DST_PPAS_DB -U $AUTO_DST_SP_USER -c "select version();"
        else
           psql -h $AUTO_DST_HOST_NAME -d $AUTO_DST_PPAS_DB -U $AUTO_DST_SP_USER -c "select version();"
        fi

        if [ "$?" = "0" ]; then
            LogIt "`date`: $AUTO_DST_HOST_NAME is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to Postgres in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_td
# ==============================================================================
function check_td {


    [[ -n $AUTO_SKIP_CHECK_TD ]] && {
        LogIt "AUTO_SKIP_CHECK_TD is set. check_td will not be executed."
        return
    }

    typeset Host=$1

    typeset sleeptime=5
    typeset counter=1


    while :
    do
        echo select user | isql $AUTO_DST_HOST_NAME

        if [ "$?" = "0" ]; then
            LogIt "`date`: $AUTO_DST_HOST_NAME is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to TD in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_hana
# ==============================================================================
function check_hana {


    [[ -n $AUTO_SKIP_CHECK_HANA ]] && {
        LogIt "AUTO_SKIP_CHECK_HANA is set. check_hana will not be executed."
        return
    }

    typeset Host=$1

    typeset sleeptime=5
    typeset counter=1


    while :
    do
        echo select database_name from sys.m_database | isql saphanavm06 system Shareplex1234

        if [ "$?" = "0" ]; then
            LogIt "`date`: $AUTO_DST_HOST_NAME is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to SAP HANA database in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_mysql
# ==============================================================================
function check_mysql {


    [[ -n $AUTO_SKIP_CHECK_MYSQL ]] && {
        LogIt "AUTO_SKIP_CHECK_MYSQL is set. check_mysql will not be executed."
        return
    }

    typeset Host=$1
    typeset User=$2
    typeset Pwd=$3

    typeset counter=1


    while :
    do
        mysql -h$Host -u$User -p$Pwd -e "select version();"

        if [ "$?" = "0" ]; then
            LogIt "`date`: $Host is up and running."
            break
        else

            if [ $counter -eq 1 ]; then
                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login to Mysql in TC# $AUTO_CURRENT_TEST_ID on $Host" \
                          "`date`: waiting for $Host to become available..."

            fi

            sleep 20

            counter=`expr $counter + 1`

        fi

    done

}

# ==============================================================================
# Name: check_host
# ==============================================================================
function check_host {

    typeset Host=$1

    typeset sleeptime=5
    typeset counter=1

    while :
    do

        OUT=`ping -c 5 $Host`

        if [ "$?" = "0" ]; then
            LogIt "`date`: $Host is up and running."
            break
        else

            if [ $counter -eq 1 ]; then

                LogIt "`date`: waiting for $Host to become available..."

                SendEMail "Can not login on $Host in TC# $AUTO_CURRENT_TEST_ID" \
                          "`date`: waiting for $Host to become available..."

            fi

            echo '-'"\b\c"
            sleep $sleeptime
            echo '\\'"\b\c"
            sleep $sleeptime
            echo "|\b\c"
            sleep $sleeptime
            echo "/\b\c"
            sleep $sleeptime

            counter=`expr $counter + 1`

       fi

       done

}

# ==============================================================================
# Name: set_oracle_env
# ==============================================================================

function set_oracle_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_oracle_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME 
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME 
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users, 
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_oracle_env' $HostType $HostId"
        LogIt "Function set_oracle_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Add these exports to env for local sql info
    . $AUTO_ROOT_DIR/local_sqlplus

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi

}

# ==============================================================================
# Name: set_mss_env
# ==============================================================================

function set_mss_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_mss_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users,
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_mss_env' $HostType $HostId"
        LogIt "Function set_mss_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi

}

# ==============================================================================
# Name: set_ppas_env
# ==============================================================================

function set_ppas_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_ppas_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users,
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_ppas_env' $HostType $HostId"
        LogIt "Function set_ppas_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi

}

# ==============================================================================
# Name: set_td_env
# ==============================================================================

function set_td_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_td_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users,
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_td_env' $HostType $HostId"
        LogIt "Function set_td_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi

}

# ==============================================================================
# Name: set_hana_env
# ==============================================================================

function set_hana_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_hana_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users,
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_hana_env' $HostType $HostId"
        LogIt "Function set_hana_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi

}

# ==============================================================================
# Name: set_mysql_env
# ==============================================================================

function set_mysql_env {

    typeset HostType=$1
    typeset HostId=$2
    typeset Logging=$3

    # Set the PLATFORM env var that expect scripts need
    SetPlatform $HostType || {
        LogIt "Failed:: 'splex.set_mysql_env $HostType'"
        exit 2
    }

    # Exports for all. This is to support new automation.
    # New automation does use some of these
    export d_host0=$AUTO_DST_HOST_NAME
    export d_sid0=$AUTO_DST_SID
    export s_host0=$AUTO_SRC_HOST_NAME
    export s_sid0=$AUTO_SRC_SID

    # Some day when we need sperate OS spadmin users,
    # these will have to be set to exports
    export this_spadmin=$spadmin
    export this_spapass=$spapass

    # Set "this_*" exports according to src or dst
    if [ "$HostType" = "src" ]; then
        export this_os=$AUTO_SRC_OS
        export this_hostname=$AUTO_SRC_HOST_NAME
        export this_ora_spadmin=$AUTO_SRC_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_SRC_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_SRC_OPT_DIR"
        export this_vardir="$AUTO_SRC_VAR_DIR"
        export this_sid="$AUTO_SRC_SID"
        export this_tns="$AUTO_SRC_TNS_NAME"
        export this_ora_home="$AUTO_SRC_ORA_HOME"
        export this_spo_ver="$AUTO_SRC_SPO_VER"
        export this_ora_s_ver="$AUTO_SRC_ORA_S_VER"

    elif [ "$HostType" = "dst" ]; then
        export this_os=$AUTO_DST_OS
        export this_hostname=$AUTO_DST_HOST_NAME
        export this_ora_spadmin=$AUTO_DST_ORA_SPADMIN_UID
        export this_ora_spapass=$AUTO_DST_ORA_SPADMIN_PWD
        export this_proddir="$AUTO_DST_OPT_DIR"
        export this_vardir="$AUTO_DST_VAR_DIR"
        export this_sid="$AUTO_DST_SID"
        export this_tns="$AUTO_DST_TNS_NAME"
        export this_ora_home="$AUTO_DST_ORA_HOME"
        export this_spo_ver="$AUTO_DST_SPO_VER"
        export this_ora_s_ver="$AUTO_DST_ORA_S_VER"
    else
        LogIt "Fail:: 'splex.set_mysql_env' $HostType $HostId"
        LogIt "Function set_mysql_env could not identify host"
        LogIt "Therefore, can not set the right environment!!!"
        exit 2
    fi

    # Print the this_* exports
    if [ "$Logging" == "" ]; then
        print "Current Environment:"
        print "########################################"
        print "HOSTNAME=$this_hostname"
        print "SID=$this_sid"
        print "TNS=$this_tns"
        print "SPO VERSION=$this_spo_ver"
        print "PLATFORM=$PLATFORM"
        print "SP_SYS_VARDIR=$this_vardir"
        print "PRODDIR=$this_proddir"
        print "ORACLE SPADMIN UID=$this_ora_spadmin"
        print "ORACLE SPADMIN PWD=$this_ora_spapass"
        print "ORACLE SHORT VER=$this_ora_s_ver"
        print "ORACLE HOME=$this_ora_home"
        print "OS SPADMIN UID=$this_spadmin"
        print "OS SPADMIN PWD=$this_spapass"
        print "########################################"
    fi


}

# ==============================================================================
# run_multi_otest
# ==============================================================================

function run_multi_otest {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    # Set local variables to arguments passed in
    typeset HostType=$1
    typeset HostId=$2
    typeset OrigOtestPrmFile=$3
    typeset NumSessions=$4
    typeset WaitFlag=$5

    # Local variables
    typeset otest_path
    typeset otest_app
    typeset Counter=1
    typeset WrkOtestPrmFile
    typeset OtestPlatform
    typeset OtestApp

    function ErrorOut {
        typeset CustomMsg=$1

        LogIt "Multi Otest Program exited out with an Error"

        [[ -n $CustomMsg ]] && LogIt "$CustomMsg"

        SendEMail "Multi Otest exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${AUTO_CURRENT_CONFIG}" \
             "ERROR: Multi Otest had problems\n$CustomMsg"

        LogIt "Failed:: multi_otest couldn't run."
    }

    set_oracle_env $HostType $HostId

    # Validates that the current OS is supported by otest. Also get the short
    # version of os name, this will be the directory where otest exists on Unix.
    OtestPlatform=$(_GetOtestPlatform "$this_os") || {
        LogIt "$this_os is not supported by otest."
        LogIt "Supported OS: AIX, HP-UX, SunOS, "
        print "OSF1, Windows, and Linux."
        return $FALSE
    }

    # Get the name of the otest executable file
    OtestApp=$(_GetOtestApp $OtestPlatform $this_ora_s_ver) || {
       LogIt "$this_ora_s_ver is not supported by otest."
       LogIt "Supported versions: 7, 8, 8i, 9i, and 10g"
       return $FALSE
    }

    # Check if tester wants to run the beta otest verion
    [[ -n "$AUTO_OTEST_BETA" ]] &&  OtestApp="$OtestApp.beta"

 
    # This will be the actual otest parameter file that is used.
    WrkOtestPrmFile="$AUTO_WORK_DIR/$AUTO_TEST_RUN_ID.$OrigOtestPrmFile"
    WrkOtestPrmFile="$WrkOtestPrmFile.multi_otest_param"

    # Remove working otest param file if old one exists and copy over a new one
    remove_if_exist $WrkOtestPrmFile

    Out=$(CopyFile ${AUTO_OTEST_PARM_DIR}/${OrigOtestPrmFile} $WrkOtestPrmFile) || {
        ErrorOut "$Out"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    function SetupLocal {
        # Change the name of the config in the working otest param file
        # Local otest will use the working config in the test dir
        # because otest will be run from this automation server
        # 5-8-2015 Julia declare local variable WrkOtestPrmFile, otherwise it has null value
        typeset WrkOtestPrmFile=$1

        change {config} $AUTO_CURRENT_CONF_TMP $WrkOtestPrmFile
        OtestPath=$AUTO_LOCAL_OTEST_DIR
        LocalFlag="LOCAL"
    }

    # Setup config and otest path according to platform
    if _IsWindows $OtestPlatform; then
        SetupLocal $WrkOtestPrmFile

    # for remote hp machines spe67 and spe68
    elif [[ $this_hostname = +(spe*) ]]; then
        SetupLocal $WrkOtestPrmFile 

    elif [[ -n $AUTO_MID_TIER ]]; then
        SetupLocal $WrkOtestPrmFile

    elif [[ -n $AUTO_SRC_PDB ]]; then
        SetupLocal $WrkOtestPrmFile

    else
        change {config} $AUTO_CURRENT_CONFIG $WrkOtestPrmFile

        # Right now HP itanium is in root otest dir
        [[ "$OtestPlatform" == "hpIT" ]] && {
            OtestPath=$AUTO_NIX_OTEST_DIR
        } || {
            # all others are in sub dir off otest root
            OtestPath=$AUTO_NIX_OTEST_DIR/$OtestPlatform
        }

        LocalFlag="REMOTE" # always run Unix on remote host
    fi

    LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
    LogIt "Running Otest $OtetApp `date` "
    LogIt "OTEST PARAMETERS:"
    LogIt "+++++++++++++++++++"
    LogIt "`cat $WrkOtestPrmFile`"

    debug_pause 1

    [[ -n $AUTO_OTEST_NOT_OCI_WRITE ]] &&  NotOciWrite='Y' || NotOciWrite='N'
    [[ -n $AUTO_OTEST_RAND_OCI_WRITE ]] &&  RandOciWrite='Y' || RandOciWrite='N'

    # Kick off each otest in the background
    while (($Counter <= $NumSessions)); do

        [[ -n "$AUTO_DEBUG" ]] && {
            # debug mode dumps otest output to file
            $AUTO_EXPECT_DIR/otest $WrkOtestPrmFile $OtestPath $OtestApp $LocalFlag $NotOciWrite $RandOciWrite 2>&1 > $AUTO_WORK_DIR/otest.$Counter &
        } || { 
            $AUTO_EXPECT_DIR/otest $WrkOtestPrmFile $OtestPath $OtestApp $LocalFlag $NotOciWrite $RandOciWrite >/dev/null &
        }
        Counter=`expr $Counter + 1`
        sleep 2
    done

    # wait for the last otest to complete if wait flag is set
    [[ -n "$WaitFlag" ]] && {
        print "Please standby. Multi otest is running. This may take a while."
        print "Waiting for $NumSessions otests to complete"
        wait
    } || {
        print "Multi otest is running."
        print "Note: Automation will continue executing the next commands"
        print "while the otests are running"

    }

    # you can only check the status of the last otest when it completes
    if (( $? != 0 )); then
        ErrorOut
    else
        LogIt "Passed:: Running Multi Otest Program"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}

# ==============================================================================
# run_ocitest
# ==============================================================================

	function run_ocitest
	{

		typeset host_type
		typeset host_id
  		typeset otest_param_file
                typeset otest_path
                typeset otest_app
                typeset local_op

		host_id=$2
		host_type=$1
		ocitest_param_file=$3
		ocitest_param_path=$AUTO_ROOT_DIR/ocitest
		ocitest_path=/qa/splex/ocitest

		set_oracle_env $host_type $host_id

		local_ocitest=$PWD/tmp/${AUTO_TESTER}_${this_hostname}_${this_sid}_${config}_ocitest_param
		remove_if_exist $local_ocitest

		cp ${ocitest_param_path}/${ocitest_param_file} ${local_ocitest}
		echo "========================="
                LogIt "Running Ocitest `date` "
                debug_pause 1

		change {config} $config $local_ocitest
		wait $!

		######### Begin determine the evironment and service name for SQLPLUS #################
                envlist=$AUTO_ROOT_DIR/env_list
                service_name=`grep "$this_hostname;" $envlist | grep $this_sid | awk -F";" '{ print $8 }'`
                . $AUTO_ROOT_DIR/local_sqlplus
		check_oracle $service_name
		######### End determine the evironment and service name for SQLPLUS #################

		LogIt "OCITEST PARAMETERS:"
		LogIt "+++++++++++++++++++++"
		LogIt "`cat $local_ocitest`"

		export OCI_SERVER=${service_name}
		export OCI_CONNECT=qarun/qarun
		export CONFIGFILE=Y
		export OTEST_FILE=Y
		${ocitest_path}/oci $local_ocitest
		if (( $? != 0 ))
                then
                        LogIt "Ocitest Program exited out with an Error"

                        #<TW 08.15.2003> Added call to SendEMail to replace old way of emailing message
                        SendEMail "Ocitest exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${config}" \
                                  "Ocitest Program exited out with an Error"

                        #<TW 08.15.2003>Old way of emailing message. Delete later
			#echo "Ocitest Program exited out with an Error" | mail $email -s "Ocitest exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${config}"



                else
                        LogIt "Passed:: Running Ocitest Program"
                fi

		echo "========================="
                LogIt "Done running Ocitest $otest_app `date` "
                debug_pause 1

	}

# ==============================================================================
# run_otest
# ==============================================================================

function run_otest {

    typeset host_type=$1
    typeset host_id=$2
    typeset OrigOtestPrmFile=$3

    typeset otest_path
    typeset otest_app
    typeset WrkOtestPrmFile
    typeset Log=$AUTO_TEST_CASE_LOG

    set_oracle_env $host_type $host_id

    function ErrorOut {
        typeset CustomMsg=$1

        LogIt "Otest Program exited out with an Error"

        [[ -n $CustomMsg ]] && LogIt "$CustomMsg"

        SendEMail "Otest exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${AUTO_CURRENT_CONFIG}" \
             "ERROR: Otest had problems\n$CustomMsg"

        LogIt "Failed:: run_otest couldn't run."
    }

    WrkOtestPrmFile=$AUTO_WORK_DIR/$AUTO_TEST_RUN_ID.$OrigOtestPrmFile.otest_param
    remove_if_exist $WrkOtestPrmFile

    Out=$(CopyFile $AUTO_OTEST_PARM_DIR/$OrigOtestPrmFile $WrkOtestPrmFile) || {
        ErrorOut "$Out"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validates that the current OS is supported by otest. Also get the short
    # version of os name, this will be the directory where otest exists on Unix.
    OtestPlatform=$(_GetOtestPlatform "$this_os") || {
        LogIt "$this_os is not supported by otest."
        LogIt "Supported OS: AIX, HP-UX, SunOS, "
        LogIt "OSF1, Windows, and Linux."
        return $FALSE
    }

    OtestApp=$(_GetOtestApp $OtestPlatform $this_ora_s_ver) || {
       LogIt "$this_ora_s_ver is not supported by otest."
       LogIt "Supported versions: 7, 8, 8i, 9i ,10g ,11g and 12c"
       return $FALSE
    }
    # Check if tester wants to run the beta otest verion
     [[ -n "$AUTO_OTEST_BETA" ]] &&  OtestApp="$OtestApp.beta" 

    function SetupLocal {
        # Change the name of the config in the working otest param file
        # Local otest will use the working config in the test dir
        # because otest will be run from this automation server
        # 5-8-2015 Julia declare local variable WrkOtestPrmFile, otherwise it has null value
        typeset WrkOtestPrmFile=$1

        change {config} $AUTO_CURRENT_CONF_TMP $WrkOtestPrmFile
        OtestPath=$AUTO_LOCAL_OTEST_DIR
        LocalFlag="LOCAL"
    }

    if _IsWindows $OtestPlatform; then
        SetupLocal $WrkOtestPrmFile

    # for remote hp machines spe67 and spe68
    elif [[ $this_hostname = +(spe*) ]]; then
        SetupLocal $WrkOtestPrmFile

    elif [[ -n $AUTO_MID_TIER ]]; then
        SetupLocal $WrkOtestPrmFile

    elif [[ -n $AUTO_SRC_PDB ]]; then
        SetupLocal $WrkOtestPrmFile

    else

        change {config} $config $WrkOtestPrmFile

        # Right now HP itanium is in root otest dir
        [[ "$OtestPlatform" == "hpIT" ]] && {
            OtestPath=$AUTO_NIX_OTEST_DIR
        } || {
            OtestPath=$AUTO_NIX_OTEST_DIR/$OtestPlatform
        }

        LocalFlag="REMOTE"
    fi

    LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
    LogIt "Running Otest $OtetApp `date` "

    debug_pause 1

    # See if otest_seed is in the environment
    if [ -n "$otest_seed" ]; then

        otest_tc=`echo $otest_seed | cut -d_ -f1`
        curr_seed=`echo $otest_seed | cut -d_ -f2`

        if [ "$otest_tc" == "$AUTO_CURRENT_TEST_ID" ]; then

            print "seed $curr_seed" > $WrkOtestPrmFile
            LogIt "+++++++++++++++++++++++++++++++++"
            LogIt "Found otest_seed variable in your environment"
            LogIt "For TestCase # $otest_tc, Otest seed # $curr_seed will be used"
            LogIt "++++++++++++++++++++++++++++++++"
        fi
    fi


    LogIt "OTEST PARAMETERS:"
    LogIt "+++++++++++++++++++"
    LogIt "`cat $WrkOtestPrmFile`"

    [[ -n $AUTO_OTEST_NOT_OCI_WRITE ]] &&  NotOciWrite='Y' || NotOciWrite='N'
    [[ -n $AUTO_OTEST_RAND_OCI_WRITE ]] &&  RandOciWrite='Y' || RandOciWrite='N'

    $AUTO_EXPECT_DIR/otest $WrkOtestPrmFile $OtestPath $OtestApp $LocalFlag $NotOciWrite $RandOciWrite

    if (( $? != 0 )); then

        ErrorOut "See test case log for otest output and errors."
        # remove the commented out code once this call to ErrorOut is varified as works.
        #LogIt "Otest Program exited out with an Error"

        #SendEMail "Otest exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${config}" \
        #          "Otest Program exited out with an Error"


    else
       LogIt "Passed:: Running Otest Program"
    fi

    LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++"
    LogIt "Done running Otest $otest_app `date` "

    debug_pause 1

}

# ==============================================================================
# run_msstest
# ==============================================================================
function run_msstest {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset host_type=$1
    typeset host_id=$2
    typeset OrigMsstestFile=$3

    set_mss_env $host_type $host_id

    typeset WrkMsstestFile
    typeset MsstestPlatform

    WrkMsstestFile=$AUTO_WORK_DIR/$AUTO_TEST_RUN_ID.$OrigMsstestFile.msstest_param
    remove_if_exist $WrkMsstestFile

    Out=$(CopyFile $AUTO_MSSTEST_PARM_DIR/$OrigMsstestFile $WrkMsstestFile) || {
        ErrorOut "$Out"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    MsstestPlatform=$(_GetOtestPlatform "$this_os") || {
        LogIt "$this_os is not supported by msstest. Msstest just supports windows platform"
        return $FALSE
    }

    if _IsWindows $MsstestPlatform; then
        typeset config_file=$AUTO_SRC_VAR_DIR/config/$AUTO_CURRENT_CONFIG
        typeset tmpconfig_file

        tmpconfig_file=$(echo ${config_file} | sed 's/\//\\\//g')

        change {config} $tmpconfig_file $WrkMsstestFile

        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "Running Msstest start `date` "

        $AUTO_EXPECT_DIR/msstest $WrkMsstestFile

        if (( $? != 0 )); then
            ErrorOut "See test case log for msstest output and errors."
            return $FALSE
        else
            LogIt "Passed:: Running Msstest Program"
        fi

        LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "Done running Msstest `date` "
    else
                LogIt "Supported OS: Windows. Others are not supported "
                return $FALSE
    fi

}

# ==============================================================================
# run_otest_failure
# ==============================================================================

        function run_otest_failure
        {

                typeset host_type
                typeset host_id
                typeset otest_param_file
                typeset otest_path
                typeset otest_app
                typeset local_op

                host_id=$2
                host_type=$1
                otest_param_file=$3
                otest_param_path=$AUTO_OTEST_PARM_DIR/otest_param

                set_oracle_env $host_type $host_id

#TODO: MAKE IT WORK ON WINDOWS
    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi


                local_op=$AUTO_WORK_DIR/${AUTO_TESTER}_${this_hostname}_${this_sid}_${config}_otest_failure
		remove_if_exist $local_op

                ######### Begin determine which platform you are using ################
		NT=0
                os=`/usr/bin/rexec -a -l ${spadmin} -p ${spapass} ${s_host0} uname -s`
                case $os in
                SunOS)
                        export plat="sun"
                        ;;
                AIX)
                        export plat="aix"
                        ;;
                OSF1)
                        export plat="osf"
                        ;;
                Linux)
                        export plat="linux"
                        ;;
                HP-UX)
                        tmp=`/usr/bin/rexec -a -l ${spadmin} -p ${spapass} ${s_host0} uname -r |cut -d. -f2`
                        if ( test $tmp -eq 10)
                        then
                                export plat="hp10"
                        elif (test $tmp -eq 11)
                        then
                                export plat="hp11"
                        else
                                echo "Unsupported HP platform release.\n"
                        fi
                        ;;
		Windows_NT*)

                        echo "Running otest on Windows platform...."
                        NT=1
			;;
                *)
                        echo "\n`uname -s` is an unsupported Unix platforms for otest. It needs"
                        echo "to be AIX, HP-UX, SunOS, OSF1, Window_NT or Linux.\n"
                        ;;
                        esac
                ######### End determine which platform you are using ################


                ######### Begin determine which Otest to run 7 or 8 or 8i #################
		if [ $NT -eq 1 ];then
                        otest_app=otest_40 
                        otest_path=$AUTO_LOCAL_OTEST_DIR
                else
               		prod_dir=`basename ${this_proddir} |awk -F'/' '{print $NF}'`
                	case $prod_dir in
                	opt7)
                        	otest_app=otest.7
                        	;;
                	opt8)
                        	otest_app=otest.8
                        	;;
                	opt8i)
                        	otest_app=otest.8i
                        	;;
                	opt9i)
                        	otest_app=otest.9i
                        	;;
                	*)
                        	echo "$prod_dir is not a standard name for the proddir. It needs"
                        	echo "to be opt7, opt8, opt8i or opt9i.\n"
                        	;;
                	esac
                	otest_path=$AUTO_NIX_OTEST_DIR/$plat
		fi
                echo $otest_app
                ######### End determine which Otest to run 7 or 8 or 8i #################

                echo "========================="
                LogIt "Running Otest $otest_app `date` "
                debug_pause 1

                ########## Determine if otest_seed variable exist and if so, include in parameter file ###########
                if [ -n "$otest_seed" ]
                then
                        otest_tc=`echo $otest_seed | cut -d_ -f1`
                        curr_seed=`echo $otest_seed | cut -d_ -f2`
                        if [ "$otest_tc" == "$AUTO_CURRENT_TEST_ID" ]
                        then
                                echo "seed $curr_seed" > $local_op
                                LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                                LogIt "Found otest_seed variable in your LogIt"
                                LogIt "For TestCase # $otest_tc, Otest seed # $curr_seed will be used"
                                LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        fi
                fi
                ########## End Determine if otest_seed variable exist and if so, include in parameter file ###########
                cat ${otest_param_path}/${otest_param_file} >> $local_op
                change {config} $config $local_op
		wait $!

                LogIt "OTEST PARAMETERS:"
                LogIt "+++++++++++++++++++++++"
                LogIt "`cat $local_op`"

                $AUTO_EXPECT_DIR/otest_failure $local_op $otest_path $otest_app $AUTO_TEST_CASE_LOG
                if (( $? != 0 ))
                then
                        #echo "Failed:: Running Otest Program" | tee -a $log_file
                        LogIt "Otest_Failure Program exited out with an Error"

                        SendEMail "Otest_Failure exited with Error in TC# $AUTO_CURRENT_TEST_ID on ${this_sid}@${this_hostname},  Current Config - ${config}" \
			"Otest_Failure Program exited out with an Error"


                else
                        LogIt "Passed:: Running Otest Program"
                fi

                echo "========================="
                LogIt "Done running Otest $otest_app `date` "
                debug_pause 1

        }


# ==============================================================================
# run_sql_config
# ==============================================================================

        function run_sql_config
        {
		typeset host_type
                typeset host_id
                typeset sql_file
                typeset sqluser
                typeset local_sf
                typeset user_table
                typeset user
                typeset table

		host_type=$1
                host_id=$2
		sql_file=$AUTO_SQL_DIR/$3
                sqluser=$4

		############# local_sf: local sql_file #####################

		set_oracle_env $host_type $host_id

		local_sf=$AUTO_WORK_DIR/${AUTO_TESTER}_${this_hostname}_${this_sid}_${config}_$3
		remove_if_exist $local_sf
		cp $sql_file $local_sf

		echo "========================="
		LogIt "Run_sql_config $sql_file `date` "
                debug_pause 1

		LogIt "SQL SCRIPT USED=${sql_file}"

		######### Begin determine the evironment and service name for SQLPLUS #################
                envlist=$AUTO_ROOT_DIR/env_list
                service_name=`grep "$this_hostname;" $envlist | grep $this_sid | awk -F";" '{ print $8 }'`
                . $AUTO_ROOT_DIR/local_sqlplus
		check_oracle $service_name
		######### End determine the evironment and service name for SQLPLUS #################

		# If a fifth parameter [ log ] is specified then do the first loop
		# and if not, then do the second loop

		if (( $# == 5 ))
		then
                	#cat ${AUTO_TESTER}_${s_sid0}_${s_host0}.atl | while read user_table
                	cat $AUTO_TABLE_LIST | while read user_table
                	do
                        	if [ -z ${user_table} ]
                        	then
                                	continue
                        	fi

			table=`echo $user_table | cut -d. -f2`
			user=`echo $user_table | cut -d. -f1`

			LogIt "SQL SCRIPT OUTPUT:"
			LogIt "++++++++++++++++++++++++++++++++++++++++++"

# TW removed having this dump oracle errors to dev/null.
# Otherwise no output of errors was being sent to STDOUT
#sqlplus ${sqluser}/${sqluser}@${service_name} <<HERE | tee -a $log_file | grep "ORA-" >/dev/null
sqlplus ${sqluser}/${sqluser}@${service_name} <<HERE | tee -a $AUTO_TEST_CASE_LOG | grep "ORA-"
start $local_sf $user $table $d_host0 $d_sid0
exit 0
HERE
				exit_status=$?
                        	if [ "$exit_status" = "0" ]
                        	then
                                	LogIt "Failed:: run_sql_config $local_sf $user $table"
                        	else
                                	LogIt "Passed:: run_sql_config $local_sf $user $table"
                        	fi

			done
		else
                	#cat ${AUTO_TESTER}_${s_sid0}_${s_host0}.atl | while read user_table
                	cat $AUTO_TABLE_LIST | while read user_table
                	do
                        	if [ -z ${user_table} ]
                        	then
                                	continue
                        	fi

			table=`echo $user_table | cut -d. -f2`
			user=`echo $user_table | cut -d. -f1`

sqlplus ${sqluser}/${sqluser}@${service_name} <<HERE
start $local_sf $user $table $d_host0 $d_sid0
exit 0
HERE
				exit_status=$?
                        	if [ "$exit_status" != "0" ]
                        	then
                                	LogIt "Failed:: run_sql_config $local_sf $table"
                        	else
                                	LogIt "Passed:: run_sql_config $local_sf $table"
                        	fi

			done

		LogIt "+++++++++++++++++++++++++++++++++++"

		fi
                #######################################################

                LogIt "Done run_sql_config $sql_file `date` "
		debug_pause 1
        }


# ==============================================================================
# run_sql_file_bg
# ==============================================================================
function run_sql_file_bg {

    LogFunctStart $0 "$@" 
    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 4"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId FileName OraUser"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_SQL_DIR/$3"
    typeset User=$4
    typeset Log=$5

    typeset Output # Output of running sqlplus

    # Make sure the sql script exists with or without ".sql" extention
    if [[ ! -f $File && ! -f "$File.sql" ]]; then
        LogIt "Failed:: $File sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi 

    set_oracle_env $HostType $HostId
    check_oracle $this_tns

    # Execute the script in the background
    print "start $File $d_host0 $d_sid0 $User $AUTO_DST_TNS_NAME;" |
       sqlplus -s $User/$User@$this_tns&

    LogIt "Passed:: $0 $File"

    LogFunctEnd $0 "$@"
}

# ==============================================================================
# run_sql_setup
# ==============================================================================

        function run_sql_setup
        {
                typeset host_type
                typeset host_id
                typeset sql_file
                typeset sqluser
                typeset local_sf

                host_type=$1
                host_id=$2
                sql_file=$AUTO_SQL_DIR/$3
                sqluser=$4

                ############# local_sf: local sql_file #####################

                set_oracle_env $host_type $host_id

                local_sf=$AUTO_WORK_DIR/${AUTO_TESTER}_${this_hostname}_${this_sid}_${config}_$3
                remove_if_exist $local_sf
                cp $sql_file $local_sf

                echo "========================="
                LogIt "Running Setup $sql_file `date` "
                debug_pause 1

                LogIt "SETUP SCRIPT USED=$sql_file"
                ######### Begin determine the evironment and service name for SQLPLUS #################
                envlist=$AUTO_ROOT_DIR/env_list
                service_name=`grep "$this_hostname;" $envlist | grep $this_sid | awk -F";" '{ print $8 }'`
                . $AUTO_ROOT_DIR/local_sqlplus
                check_oracle $service_name
                ######### End determine the evironment and service name for SQLPLUS #################

                # If a fifth parameter [ log ] is specified then do the first loop
                # and if not, then do the second loop

                if (( $# == 5 ))
                then
                LogIt "SQL SETUP SCRIPT OUTPUT:"
                LogIt "++++++++++++++++++++++++++++++++++++++++++++++++"
echo "service_name=$service_name"
sqlplus ${sqluser}/${sqluser}@${service_name} << HERE 2>&1 | tee -a $AUTO_TEST_CASE_LOG
-- set pages 0 echo off verify off feed off term off define off escape off scan off
start $local_sf $d_host0 $d_sid0
exit 0
HERE
                LogIt "++++++++++++++++++++++++++++++++++++++++++++++++"
                else
sqlplus ${sqluser}/${sqluser}@${service_name} << HERE
-- set pages 0 echo off verify off feed off term off define off escape off scan off
start $local_sf $d_host0 $d_sid0
exit 0
HERE
                fi
                #######################################################

                if [ "$?" != "0" ]
                then
                        LogIt "Failed:: $sql_file"
                else
                        LogIt "Passed:: $sql_file"
                fi

                LogIt "Done running setup $sql_file `date` "
                debug_pause 1
        }

# ==============================================================================
# run_sql_file
# ==============================================================================
function run_sql_file {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
    LogFunctStart $0 "$@" 
    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# >= 4 && $# <=7"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"Sql\" OraUser [log] [ignore] [pwd=mypass]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Required arguments 
    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_SQL_DIR/$3"
    typeset User=$4
    typeset Log=$5

    # Optional arguments
    typeset Log
    typeset Ignore
    typeset PwdSetFlag=$FALSE
    typeset PwdArgString="$User"

    # Parse out optional arguments
    for Arg; do
        case "$Arg" in
            LOG|Log|log ) Log="Log";;
            IGNORE|Ignore|ignore) Ignore="Ignore";; 
            pwd*) 
                PwdArgString="$Arg"
                PwdSetFlag=$TRUE;;
        esac
    done

    # Other local vars. Must be declared or previous call to this function
    # will leave them initialized
    typeset Output # Output of running sqlplus
    typeset ErrCodes


    Pwd=$(_GetOraPwd "$PwdArgString")

    # TODO
    # BECAUSE NEED TO APPEND .sql if not there
    #   maybe the start command will automaticlly append?
    # NEED TO DO THAT LATER
    # ALSO, shouldn't the && be ||????
    # Make sure the sql script exists with or without ".sql" extention
    if [[ ! -f $File && ! -f "$File.sql" ]]; then
        LogIt "Failed:: $File sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi 

    set_oracle_env $HostType $HostId
    check_oracle $this_tns

    typeset SqlCmd="start $File $d_host0 $d_sid0 $User $AUTO_DST_TNS_NAME"

    LogIt "Starting sqlplus `date`"
    Output=$(_ExecSql $User $Pwd $this_tns "$SqlCmd") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    LogIt "Ending sqlplus `date`"

    # Log option?    print to term & log. Or just term.
    [ -n "${Log:-}" ] && LogIt "$Output" || print "$Output"

    # If there is ouput from sqlplus, then check it for errors
    [[ -n "$Output" ]] && {

        # See if there are oracle error codes in sqplus output if Ignore is NOT set
        [ -z "${Ignore:-}" ] && {
            ErrCodes=$(print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-")
        }

        # check for hardcoded failures in sqlplus output
        [[ "$Output" = *(*Failed::*) ]] && ErrCodes="SQL Script printed failures.\n$ErrCodes"

    }

    # Pass or Fail script execution
    if [[  -n "$ErrCodes" ]]; then

        # Pass when oracle errors occur when object do not exist and have "drop"
        # in the sql script. This drop was causing false failures
        # in automation when scripts drop before creating object
        #
        # OO942 - Table view
        # 01917 - user
        # 02289 - sequence
        # 04043 - type
        [[ "$ErrCodes" = *(*ORA-(00942|01918|02289|04043)*) ]] && { 

            grep -i "drop" $File > /dev/null && {
                LogIt "Passed:: $0 $File"
            }

        } || {

            LogIt "=============== SQLPLUS OUTPUT ================"
            LogIt "$Output"
            LogIt "============ END SQLPLUS OUTPUT ==============="
            LogIt "\t$ErrCodes"
            LogIt "Failed:: $0 $File"
        }

    else
        LogIt "Passed:: $0 $File"
    fi
     
    LogFunctEnd $0 "$@"
    debug_pause 1

}


# ==============================================================================
# Name: run_mss_file
# ==============================================================================
function run_mss_file {

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments

    typeset ValArgPat="$# >= 4 && $# <=6"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"MssSql\" MssUser MssPwd|default=MssUser [log]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

   if [[ $5 == "log" || $5 == "Log" || $5 == "LOG" ]]; then

    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_MSS_DIR/$3"
    typeset User=$4
    typeset Pwd=$4
    typeset Log=$5

   else

    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_MSS_DIR/$3"
    typeset User=$4
    typeset Pwd=$5
    typeset Log=$6

   fi

    File=${File%%.sql*}


    typeset Output # Output of running sqlcmd

    # Make sure the sql script exists with ".sql" extention
    if [[ ! -f $File.sql ]]; then
        LogIt "Failed:: $File.sql mss sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi

    set_mss_env $HostType $HostId
    #check_mss $AUTO_DST_HOST_NAME
    check_mss $this_hostname $User $Pwd

    LogIt "Starting sqlcmd `date`"
    Output=$(sqlcmd -S $this_hostname -U $User -P $Pwd -e -i $File.sql -I -l90) || {
        LogIt "Failed:: $0 encountered errors while connecting to SQL Server"
        LogIt "$Output"
        LogFunctionEnd $0 "$@"
        return $FALSE
    }

    #sqlcmd -S $this_hostname -U $User -P $Pwd -e -i $File.sql -I -l90 | tee -a $AUTO_TEST_CASE_LOG
    #sqlcmd -S $d_host0 -U $User -P $User -i $File.sql -I -e | tee -a $AUTO_TEST_CASE_LOG

    LogIt "Ending sqlcmd `date`"


    # Log option?    print to term & log. Or just term.
    [ -n "${Log:-}" ] && LogIt "$Output" || print "$Output"

    # If there is ouput from sqlcmd, then check it for errors
    [[ -n "$Output" ]] && {
        # See if there are errors 
            ErrCodes=$(print "$Output" | egrep "Error Code")
    }

    if [[  -n "$ErrCodes" ]]; then {

            LogIt "=============== SQLCMD OUTPUT ================"
            LogIt "$Output"
            LogIt "============ END SQLCMD OUTPUT ==============="
            LogIt "\t$ErrCodes"
            LogIt "Failed:: $0 $File"
        }

    else
        LogIt "Passed:: $0 $File"
    fi


    LogFunctEnd $0 "$@"
    debug_pause 1
}


# ==============================================================================
# Name: run_ppas_file
# ==============================================================================
function run_ppas_file {

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments

    typeset ValArgPat="$# >= 4 && $# <=5"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"PgSql\" PgUser [log]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }


    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_PG_DIR/$3"
    typeset User=$4
    typeset Log=$5

    typeset Output # Output of running sqlcmd

    # Make sure the sql script exists with ".sql" extention
    if [[ ! -f "$File.sql" ]]; then
        LogIt "Failed:: $File postgres sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi

    . $AUTO_ROOT_DIR/local_psql
    set_ppas_env $HostType $HostId
    check_ppas $AUTO_DST_HOST_NAME

    LogIt "Starting psql `date`"
    LogIt "AUTO_PG_PORT=$AUTO_PG_PORT"

    if [[ -n $AUTO_PG_PORT ]]; then
       psql -h $AUTO_DST_HOST_NAME -p $AUTO_PG_PORT -d $AUTO_DST_PPAS_DB -U $AUTO_DST_SP_USER -c 'select version();' -a | tee -a $AUTO_TEST_CASE_LOG
       psql -h $AUTO_DST_HOST_NAME -p $AUTO_PG_PORT -d $AUTO_DST_PPAS_DB -U $AUTO_DST_SP_USER -f $File.sql -a | tee -a $AUTO_TEST_CASE_LOG

    else
       psql -h $AUTO_DST_HOST_NAME -d $AUTO_DST_PPAS_DB -U $AUTO_DST_SP_USER -f $File.sql -a | tee -a $AUTO_TEST_CASE_LOG
    fi

    LogIt "Ending psql `date`"

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: run_td_file
# ==============================================================================
function run_td_file {

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments

    typeset ValArgPat="$# >= 4 && $# <=5"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"TdSql\" TdUser [log]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }


    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_TD_DIR/$3"
    typeset User=$4
    typeset Log=$5

    typeset Output # Output of running sqlcmd

    # Make sure the sql script exists with ".sql" extention
    if [[ ! -f "$File.sql" ]]; then
        LogIt "Failed:: $File teradata sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi

    set_td_env $HostType $HostId
    check_td $AUTO_DST_HOST_NAME

    LogIt "Starting isql $File.sql `date`"
    isql $AUTO_DST_HOST_NAME -n -b < $File.sql | tee -a $AUTO_TEST_CASE_LOG

    LogIt "Ending isql `date`"

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: run_hana_file
# ==============================================================================
function run_hana_file {

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments

    typeset ValArgPat="$# >= 5 && $# <=6"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"HanaSql\" HanaUser HanaPwd [log]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }


    typeset HostType=$1
    typeset HostId=$2
    typeset File="$AUTO_HANA_DIR/$3"
    typeset User=$4
    typeset PWD=$5
    typeset Log=$6

    typeset Output # Output of running HanaFile

    # Make sure the sql script exists with ".sql" extention
    if [[ ! -f "$File.sql" ]]; then
        LogIt "Failed:: $File hana sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi

    set_hana_env $HostType $HostId
    check_hana $AUTO_DST_HOST_NAME

    LogIt "Starting isql $File.sql `date`"
    isql -n -v $AUTO_DST_HOST_NAME $User $PWD < $File.sql | tee -a $AUTO_TEST_CASE_LOG

    LogIt "Ending isql `date`"

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: run_mysql_file
# ==============================================================================
function run_mysql_file {

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments

    typeset ValArgPat="$# >= 4 && $# <=6"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId \"Mysql\" MysqlUser MysqlPwd|default=MysqlUser [log]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    for varArg in $@
    do
        varArg=${varArg##*( )}
        varArg=${varArg%%*( )}

        if [ "$varArg" == "" ]; then
            LogIt "Failed:: $varArg is an invalid variable"
            LogFunctEnd $0 "$@"
            return $FALSE
        fi
    done;


    if [[ $5 == "log" || $5 == "Log" || $5 == "LOG" ]]; then

        typeset HostType=$1
        typeset HostId=$2
        typeset File="$AUTO_MYSQL_DIR/$3"
        typeset User=$4
        typeset Pwd=$4
        typeset Log=$5

    else

        typeset HostType=$1
        typeset HostId=$2
        typeset File="$AUTO_MYSQL_DIR/$3"
        typeset User=$4
        typeset Pwd=$5
        typeset Log=$6

    fi

    File=${File%%.sql*}

    typeset Output # Output of running sqlcmd

    # Make sure the sql script exists with ".sql" extention
    if [[ ! -f $File.sql ]]; then
        LogIt "Failed:: $File.sql mysql sql script doesn't exist."
        LogFunctEnd $0 "$@"
        return $FALSE
    fi

    set_mysql_env $HostType $HostId
    #check_mss $AUTO_DST_HOST_NAME
    check_mysql $this_hostname $User $Pwd

    LogIt "Starting mysql $File.sql `date`"

    mysql -h$this_hostname -u$User -p$Pwd -D$AUTO_DST_MYSQL_DB < $File.sql | tee -a $AUTO_TEST_CASE_LOG

    Output=$?

    LogIt "Ending mysql $File.sql `date`"


    if (( $Output != 0 )); then
        LogIt "Failed:: $0 $File"
    else
        LogIt "Passed:: $0 $File"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# run_sqlload
# ==============================================================================
function run_sqlload {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    ############################################################################
    #Validation
    ############################################################################
    typeset ValArgPat="$# == 3 || $# == 4" 
    typeset UseMsg="usage: $0 Uid CtrlFile Direct=y|n [log]" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set local vars to arguments passed in
    typeset Uid=$1      # User id, also password
    typeset File=$2     # Control file
    typeset Direct=$3   # Direct load, y or n

    # Other local vars   
    typeset CtrlFile="$AUTO_LOAD_CTL_DIR/$File.ctl"    

    # The call to sqlloader function with all it's arguments
    typeset SqlLoader="_RunSqlLoader $AUTO_SRC_TNS_NAME $Uid $Uid $CtrlFile $Direct"
    typeset LoaderStatus     # status of sqlloader execution
    typeset Head             # Header of output
    typeset CmdOutput        # Output of the _RunSqlLoader call
    typeset Foot             # Footer of output

    # Check that the ctrl file exists
    _ValFileExists $0 "$CtrlFile" || {
        LogFunctEnd $0 "$@";
        return $FALSE
    }

    # Build output header and footer for output and log
    Head="load file: $CtrlFile\n"  
      Head="${Head}direct: $Direct\n"
      Head="${Head}SQL*Loader output:\n"
      Head="${Head}=============================================="

    Foot="=============================================="
    # Execute sqlloader

    CmdOutput=$($SqlLoader) 
    LoaderStatus=$?

    # Write it's stdout/stderr to log file and term
    if (( $# == 4 )); then
        LogIt "$Head"
        LogIt "$CmdOutput"
        LogIt "$Foot"

    # Write it's stdout/stderr to just to term
    else
        print "$Head"
        print "$CmdOutput"
        print "$Foot" 
    fi

    # Check output for specific SQL*Loader errors first. This is done because 
    # sqlloader is returning warn for things we want the testcase to fail for.
    if [[ "$CmdOutput" = +(*Loader-(502|553|509)*) ]]; then
      LogIt "Failed:: SQL*Loader output contains specific errors"
      Retcode=$FALSE

    # Sqlloader bug for direct load in 9i
    elif [[ "$LoaderStatus" == "1" && \
           "$CmdOutput" = +(*926*OCIDirPathFinish*) ]]; then

            LogIt "Passed:: SQL load succeeded."
            Retcode=$TRUE

    # Pass or fail the test based on SQL*Loaders exit status
    else

      case $LoaderStatus in
          0) LogIt "Passed:: SQL load succeeded."
             Retcode=$TRUE;;

          1) LogIt "Failed:: SQL*Loader exited with EX_FAIL."
             Retcode=$FALSE;;

          2) LogIt "Passed:: SQL*Loader exited with EX_WARN."
             Retcode=$TRUE;;
	   
          3) LogIt "Failed:: SQL*Loader exited with EX_FATAL."
	         Retcode=$FALSE;;

          *) LogIt "Failed:: SQL*Loader exited with return code of $LoaderStatus."
	         Retcode=$FALSE;;
      esac

    fi 

    LogFunctEnd $0 "$@"

    debug_pause 1

    return $Retcode
}




# ==============================================================================
# run_sqlload_all
# ==============================================================================
function run_sqlload_all {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    ############################################################################
    #Validation
    ############################################################################
    typeset ValArgPat="$# == 1 || $# == 2" 
    typeset UseMsg="usage: $0 Direct=y|n [log]" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset Direct=$1
    typeset Logging=$2

    typeset Log=$AUTO_TEST_CASE_LOG

    # Run SQL*Loader on each table in the table list file
    while read line; do

        Table=${line##*\.}  # chop off table name
        Uid=${line%%\.*}    # chop off user name
        Table=${Table%%\"}  # Remove the last quote if it exists
        Table=${Table##\"}  # Remove the first quote if it exists
        CtrlFile="$Table"   # Name of table is name of ctrl file

        run_sqlload $Uid $CtrlFile $Direct $Logging

    done < $AUTO_TABLE_LIST # END WHILE READ LINE

    LogFunctEnd $0 "$@"

    debug_pause 1

}


function _wait_for_capture_rac {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset MaxSeconds=$3

# per anne. added because capture takes so long to start on rac
typeset MaxSeconds=7200
    typeset CurrentSeconds=0
    typeset InitializingFlag=$FALSE
    typeset TempFile="$AUTO_WORK_DIR/CptrDetail.txt"


    # Endless loop. A condition will have to break it.
    while (($TRUE != $FALSE)); do

        # Reset the number of thread that are equal
        typeset NumThreadsEqual=0
        typeset NumThreads=0

        # Get show capture detail output from SPO and dump it to a file.
        Output=$(_SPCTRL_CmdLocToRemote $HostType $HostId "show capture detail" )
        echo "$Output" > $TempFile

        # Dump sp_ctrl output the first run through
        [[ "$CurrentSeconds" == 0 ]] && LogIt "$Output"

        # Sloppy way to get number of threads
        while read line; do
            [[ "$line" = +([1-9]*) ]] && ((NumThreads=$NumThreads + 1))

            # if capture is still initializing, then no need to continue checking threads.
            [[ "$line" = +(*Initializing*) ]] && {
                InitializingFlag=$TRUE
                break
            } || {
                InitializingFlag=$FALSE
            }

        done < $TempFile

        print "$CurrentSeconds seconds of $MaxSeconds seconds"
        echo "--------------------------------------------------------"
        print "Thread#\tOracle\tCapture\tStatus"
        echo "--------------------------------------------------------"

        # If initializing was found don't check if threads are equal. Just continue.
        [[ "$InitializingFlag" == "$TRUE" ]] && {
            print "Capture is still Initializing\n"

        } || {

            # Loop through the text file and check if threads are equal
            while read line; do

                # process only lines that begin with a number. These are threads.
                [[ "$line" = +([1-9]*) ]] && { 

                    Thread=`print "$line" | awk '{print $1}'`
                    OraRedo=`print "$line" | awk '{print $4}'`
                    Capture=`print "$line" | awk '{print $5}'`

                    # check if the current thread is equal
                    [[ "$OraRedo" == "$Capture" ]] && { 
                        # Redo/Cptr are equal for this thread. Incr num of equal threads found.
                        ((NumThreadsEqual=$NumThreadsEqual + 1))
                        print "$Thread\t$OraRedo\t$Capture\tIn Sync"
                    } || {  
                        print "$Thread\t$OraRedo\t$Capture\tOut of Sync"
                    }       
                }       
            done < $TempFile

            echo "--------------------------------------------------------\n"

            # check if all threads have passed being equal
            [[ $NumThreadsEqual == $NumThreads ]] && { 
                print "$NumThreadsEqual thread(s) out of $NumThreads threads are in sync."
                LogIt "Passed:: Oracle redo and capture are in sync for all threads"
                LogIt "$Output"
                break   
            } || {  
                print "$NumThreadsEqual thread(s) out of $NumThreads threads are in sync."
                print "Not all threads are in sync. Checking again in 5 seconds.\n\n\n"
            }       

        }       

        #warn and break loop if timeout reached
        [[ "$CurrentSeconds" -ge "$MaxSeconds" ]] && { 
            LogIt "Warning:: $0 reached timeout of $MaxSeconds."
            LogIt "$Output"
            break   
        }       

        ((CurrentSeconds=$CurrentSeconds + 5))

        sleep 5 

    done    

    rm $TempFile

}


function _wait_for_capture_non_rac {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset MaxSeconds=$3

    typeset CurrentSeconds=0

    # Loop forever 
    while (($TRUE != $FALSE)); do

        spctrlOut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "show capture detail" )

        OraRedo=`print "$spctrlOut" | grep "Oracle current redo log" | cut -d: -f2 | tr -d [:blank:]`
        Capture=`print "$spctrlOut" | grep "Capture current redo log" | cut -d: -f2 | tr -d [:blank:]`

        # Exit out function with warning if nothing was found in show capture detail
        [[ -z "$OraRedo" ]] && {

            LogIt "Warning:: No redo log found in 'show capture detail'"
            LogIt "\n########### show capture detail output #############"
            LogIt "$spctrlOut"
            LogIt "####################################################\n"
            break
        }

        print "$CurrentSeconds seconds of $MaxSeconds seconds"
        echo "---------------------------"
        print "ORACLE=$OraRedo"
        print "CAPTURE=$Capture\n"

        #pass and break loop if equal
        [[ "$OraRedo" == "$Capture" ]] && {
            LogIt "Passed::Oracle redo and capture in sync. $OraRedo:$Capture"
            break
        }

        #warn and break loop if timeout reached
        [[ "$CurrentSeconds" -ge "$MaxSeconds" ]] && {
            LogIt "Warning:: $0 reached timeout of $MaxSeconds. $OraRedo:$Capture"
            break
        }

        ((CurrentSeconds=$CurrentSeconds + 5))

        sleep 5

    done


}

# ==============================================================================
# Wait a default time or given time in seconds for Oracle Redo log and 
# capture redo log to be equal.
# ==============================================================================
function wait_for_capture {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    # Optional parameter to over ride default timeout. Pass in seconds.
    #  DEFAULT:1800 seconds(30mins)
    # Check if optional max timeout passed in or default to 90
    [[ $# == 3 ]] && MaxSeconds=$3 || MaxSeconds=1800

    # Run either RAC or non-RAC wait for capture function
    [[ "$AUTO_ORACLE_RAC" == "$TRUE" ]] && {
        _wait_for_capture_rac "$HostType" "$HostId" "$MaxSeconds"
    } || {
         _wait_for_capture_non_rac "$HostType" "$HostId" "$MaxSeconds"
    }

    LogFunctEnd $0 "$@"
}


# ==============================================================================
# run_trans
# ==============================================================================

function run_trans {

    LogFunctStart $0 "$@"
    debug_pause 1

    typeset HostType=$1
    typeset HostId=$2
    typeset FileName=$3
    typeset Schema=$4
    typeset Tblspc=$5
    typeset SqlUser=$6
    typeset OldUser=$7

    set_oracle_env $HostType $HostId

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle $this_tns

    # Build transfile path/name
    typeset SrcTransFile="$AUTO_SQL_DIR/transformation.SID" 
    typeset DstTransFile="$AUTO_DST_VAR_DIR/data/transformation.$AUTO_DST_SID"

    # Copy trans to dst
    LogIt "Copying $SrcTransFile to $AUTO_DST_HOST_NAME:$DstTransFile"
    OutPut=$(RemoteCopyFile $SrcTransFile $AUTO_DST_HOST_NAME $DstTransFile) || {
        LogIt "$OutPut"
        LogIt "Failed:: $SrcPathFile to $this_hostname"
        LogFunctEnd $0 "$@"
        return $FALSE 
    }

    LogIt "TRANSFORMATION SCRIPT OUTPUT:"
    LogIt "++++++++++++++++++++++++++++++++++++"

    $AUTO_EXPECT_DIR/ora_trans $FileName $SqlUser $Schema $Tblspc $OldUser $AUTO_TEST_CASE_LOG

    if (( $? != 0 )); then
        LogIt "Failed:: transformation $FileName"
    else
        LogIt "Passed:: transformation $FileName"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}




# ==============================================================================
# send_sql_cmd
# ==============================================================================
function send_sql_cmd {

    LogFunctStart $0 "$@"

    typeset UseMsg="usage: $0 src|dst HostId \"Sql\" OraUser [log]"
    typeset ValArgPat="$# >= 4 && $# <=6"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Required Arguemtns. Set arguments to local variables
    typeset HostType=$1
    typeset HostId=$2
    typeset SqlCmd=$3
    typeset User=$4

    # Optional arguments
    typeset Log
    typeset Ignore
    
    # Other local vars
    typeset Output
    typeset ErrCodes

    # Parse out optional arguments
    for Arg; do
        case "$Arg" in
            LOG|Log|log ) Log="Log";;
            IGNORE|Ignore|ignore) Ignore="Ignore";; 
        esac
    done

    set_oracle_env $HostType $HostName
    check_oracle $this_tns
    debug_pause 1

    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql $User $User $this_tns "$SqlCmd") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }
  
    # See if there are oracle error codes in sqplus output if Ignore is NOT set
    [ -z "${Ignore:-}" ] && {
        ErrCodes=$(print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-")
    }

    # Print output from sqlplus if log option passed in
    [ -n "${Log:-}" ] && LogIt "$Output"


    # Pass or Fail sqlplus and script execution
    if [[ -n "${ErrCodes}"  ]]; then

        LogIt "Failed:: $SqlCmd"
        
        # Print the Oracle errors only if no log option passed in
        [ -z "${Log:-}" ] && print "$ErrCodes" 
        # Always print Oracle errors to log
        print "$ErrCodes" >> $AUTO_TEST_CASE_LOG

    else
        LogIt "Passed:: $SqlCmd"
    fi
     
    LogFunctEnd $0 "$@"
    debug_pause 1
}




# ==============================================================================
# Name: send_trunc
# ==============================================================================
function send_trunc {
                
    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2
    typeset sqluser=$3

    typeset trunc_file
    typeset table

    set_oracle_env $host_type $host_id

    debug_pause 1

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle "$this_tns"

    while read table; do
        [ -z $table ] && continue
		
sqlplus $sqluser/$sqluser@$this_tns<<EOF
whenever sqlerror exit 1
     truncate table $table;
exit 0
EOF

        exit_status=$?
        [[ "$exit_status" != "0" ]] && {
            LogIt "Failed:: truncate $table"
        } || {
            LogIt "Passed:: truncate $table"
        }

    done < $AUTO_TABLE_LIST

    LogFunctEnd $0 "$@"
    debug_pause 1

}




# ==============================================================================
# diff_files
# ==============================================================================
function diff_files {       

    LogFunctStart $0 "$@"

    typeset file1=$1
    typeset file2=$2

    typeset result

    debug_pause 1

    if (( $# == 3 )); then

        diff $file1 $file2 | tee -a $AUTO_TEST_CASE_LOG

        if (( $? != 0 )); then
           LogIt "Failed:: Diff_files"
        else
           LogIt "Passed:: Diff_files"
        fi

    else

       diff $file1 $file2

       if (( $? != 0 )); then
           LogIt "Failed:: Diff_files"
       else
           LogIt "Passed:: Diff_files"
       fi

    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}



# ==============================================================================
# check_tnsnames
# ==============================================================================
function check_tnsnames {

    typeset host_type=$1
    typeset host_id=$2
    typeset sqlusr=$3

    typeset message

    LogFunctStart $0 "$@"
    set_oracle_env $host_type $host_id
    debug_pause 1

#TODO: MAKE IT WORK ON WINDOWS
    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    $AUTO_EXPECT_DIR/tnsnames $this_hostname $sqlusr $AUTO_DST_TNS_NAME $AUTO_TEST_CASE_LOG

    if (( $? != 0 )); then

        LogIt "Failed:: TNSNAMES Verification"
        message="Check tnsnames manualy on source and target"

        SendEMail "TNSNAME $AUTO_DST_TNS_NAME missing on ${this_hostname}" \
                  "$message" 

        print "\n*************************************************************"
        print "Test can not continue, Fix your tnsnames.ora file"
        print "*************************************************************\n"

        read enter

     else
        LogIt "Passed:: TNSNAMES Verification"
     fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}


# ==============================================================================
# check_sp_otest
# ==============================================================================
function check_sp_otest {

    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    debug_pause 1

    . $AUTO_ROOT_DIR/local_sqlplus



sqlplus ${dba}/${dbapass}@${this_tns}<<HERE | tee -a $AUTO_TEST_CASE_LOG | grep "ORA-" >/dev/null
SET serveroutput on size 1000000
SET verify off
SET linesize 132
SET pagesize 10000
SET feedback off
SET heading off

declare
   v_cnt number;
   v_status varchar2(100);
   v_create  long;
   v_grant   long;
begin
v_create :=  'create user sp_otest identified by sp_otest
               default tablespace splex_admin
               temporary tablespace temp';
v_grant := 'grant connect, dba to sp_otest with admin option';
   select count(username) into v_cnt
     from all_users
     where username = 'SP_OTEST';
 
                if v_cnt = 0
                then
                  dbms_output.put_line( 'create user sp_otest' );
                  EXECUTE IMMEDIATE v_create;
                  EXECUTE IMMEDIATE v_grant;
                  v_status := 'Passed:: Create SP_OTEST user';
                else
                  v_status := 'Passed:: SP_OTEST user already exist';
                end if;
                  dbms_output.put_line( v_status );

end;
/
 
set verify on
set feedback on
set heading on
HERE

    exit_status=$?

    if [ "$exit_status" = "0" ]; then
        LogIt "Failed:: create user sp_otest"

        SendEMail "Getting Oracle error during creation of SP_OTEST user at $this_tns" \
          "Getting Oracle Error during creation of SP_OTEST user. Please check it before you continue" 

        print "\n*************************************************************"
        print "Test can not continue, CHECK SP_OTEST in your database!!!"
        print "*************************************************************\n"

        read enter

	else
        LogIt "Passed:: create user sp_otest"
	fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}



# ==============================================================================
# Rewritten in python using pexpect/telnet tw 8-2009
# ==============================================================================
function fresh_install {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Set arguments to local variables
    typeset host_type=$1
    typeset host_id=$2

    # Other local variables
    typeset license_list=$AUTO_ROOT_DIR/license_list

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    python $AUTO_PYTHON_DIR/spo_install.py 2>&1 | tee $AUTO_TEST_CASE_LOG

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# fresh_install
# ==============================================================================
function fresh_install_old {

    # Set arguments to local variables
    typeset host_type=$1
    typeset host_id=$2
    typeset version=$3
    typeset media=$4

    # Other local variables
    typeset install_list
    typeset output
    typeset license

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    install_list=$AUTO_ROOT_DIR/install_list_${3}_${4}
    license_list=$AUTO_ROOT_DIR/license_list


    LogIt "Using install list $install_list"
    output=`grep $this_hostname $license_list`
    license=`echo $output | cut -d= -f2`
    LogIt "++++++++++++++++++++++++++++++++++++++++++++"
    LogIt "Fresh Install $this_hostname `date` "
    debug_pause 1
    grep $this_hostname $install_list | grep -w $this_sid | while read line
                do
                        echo $line | while read inst_host inst_sid inst_path inst_nis inst_ver
                        do
                                $AUTO_EXPECT_DIR/fresh_install_wlog $inst_path $inst_nis $inst_ver $AUTO_TEST_CASE_LOG "$license"
                                if (( $? != 0 ))
                                then
                                        LogIt "Failed:: Fresh Install"
                                else
                                        LogIt "Passed:: Fresh Install"
                                fi
                        done
                done
		### Write port number to paramdb file ###
		LogIt "Writing SP_COP_TPORT $PORTNUM to paramdb file"
		/usr/bin/rexec -a -l root -p $rootpass $this_hostname "echo "SP_COP_TPORT $PORTNUM" \
				 >> ${this_vardir}/data/paramdb"

		LogIt "Writing SP_COP_UPORT $PORTNUM to paramdb file"
		/usr/bin/rexec -a -l root -p $rootpass $this_hostname "echo "SP_COP_UPORT $PORTNUM" \
				 >> ${this_vardir}/data/paramdb"

		### Drop User QARUN ###
                $AUTO_EXPECT_DIR/drop_usr_qarun $AUTO_TEST_CASE_LOG
                if (( $? != 0 ))
                then
                        LogIt "Failed:: Drop qarun user"
                else
                        LogIt "Passed:: Drop qarun user"
                fi
                LogIt "Done Fresh Install on $this_hostname `date` "
                debug_pause 1

        }



# ==============================================================================
# ora_setup
# ==============================================================================
function ora_setup {

    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2
    typeset instl_option=$3

    set_oracle_env $host_type $host_id


    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    debug_pause 1

                case $instl_option in
                FRESH )
                        $AUTO_EXPECT_DIR/fresh_ora_setup $AUTO_TEST_CASE_LOG
                        if (( $? != 0 ))
                        then
                                LogIt "Failed:: Fresh Ora_setup"
                        else
                                LogIt "Passed:: Fresh Ora_setup"
                        fi
                        ;;
                UPGRADE )
                        $AUTO_EXPECT_DIR/upgrade_ora_setup $AUTO_TEST_CASE_LOG
                        if (( $? != 0 ))
                        then
                                LogIt "Failed:: Upgrade Ora_setup"
                        else
                                LogIt "Passed:: Upgrade Ora_setup"
                        fi
                        ;;
                esac

    LogFunctEnd $0 "$@"
    debug_pause 1

}



# ixs009
# ==============================================================================
# upgrade
# ==============================================================================
function upgrade {

    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2
    typeset version=$3
    typeset media=$4

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return $FLASE
    fi

    install_list=$AUTO_ROOT_DIR/install_list_${3}_${4}


                debug_pause 1

		grep $this_hostname $install_list | grep -w $this_sid | while read line
		do
			echo $line | while read inst_host inst_sid inst_path inst_nis menu_option
			do
                        	$AUTO_EXPECT_DIR/ora_upgrade_wlog $inst_path $inst_nis $menu_option $AUTO_TEST_CASE_LOG
                        	if (( $? != 0 ))
                        	then
                               		LogIt "Failed:: Upgrade to $version"
                        	else
                               		LogIt "Passed:: Upgrade to $version"
                        	fi
			done
		done

    debug_pause 1

    LogFunctEnd $0 "$@"
}



# ==============================================================================
# sp_apply
# ==============================================================================
function sp_apply {

    LogFunctStart $0 "$@"

    # Set arguments to local variables
    typeset host_type=$1
    typeset host_id=$2
    typeset major_version=$3

    # Other local variables
    typeset inst_path
    typeset patch_path
    typeset drop

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return $FLASE
    fi

    patch_list=$AUTO_ROOT_DIR/patch_list_${major_version}
    drop=`head -1 $patch_list`
    inst_path=/quest/habu-package/patches/$drop


    debug_pause 1
                ############### Begin: Determine the Shareplex version you are going to patch ################
                case $major_version in
                        3.2 )
                                spo_ver=B ;;
                        4.0 )
                                spo_ver=C ;;
                        4.5 )
                                spo_ver=D ;;
                esac
                ############### End: Determine the Shareplex version you are going to patch ################

                ############### Begin: Determine the Oracle version you are going to patch ################
                #splex_option=`basename $this_proddir |awk -F'/' '{print $NF}'`
                splex_option=`basename $this_proddir`
                case $splex_option in
                opt7)
                        o_ver=a
                        patch_file=Oracle7
                        ;;
                opt8)
                        o_ver=b
                        patch_file=Oracle8
                        ;;
                opt8i)
                        o_ver=c
                        patch_file=Oracle8i
                        ;;
                opt9i)
                        o_ver=d
                        patch_file=Oracle9i
                        ;;
                *)
                        echo "This version does not exist!"
                        exit 1
                        ;;
                esac
                ############### End: Determine the Oracle version you are going to patch ################

                grep $this_hostname $patch_list | grep -w $patch_file | while read line
                do
                        echo $line | while read inst_host patch_dir
                        do
                                patch_path=${inst_path}/${patch_dir}
                		LogIt "\nSelections: SPO version=$spo_ver, Oracle version=$patch_file, Patch dir=$patch_dir\n"
				sleep 2
                                $AUTO_EXPECT_DIR/sp_apply_wlog $patch_path $spo_ver $o_ver $AUTO_TEST_CASE_LOG
                                if (( $? != 0 ))
                                then
                                        LogIt "Failed:: Applying Patch $drop"
                                else
                                        LogIt "Passed:: Applying Patch $drop"
                                fi
                        done
                done

    LogFunctEnd $0 "$@"

                debug_pause 1

        }

# ixs014
# ==============================================================================
# Name: verify_patch
# ==============================================================================

function verify_patch {

    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2
    typeset drop=$3

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return $FLASE
    fi

                debug_pause 1

                output=`/usr/bin/rexec -a -l $spadmin -p $spapass \
                        $this_hostname "export SP_SYS_VARDIR=${this_vardir};" "${this_proddir}/bin/sp_ctrl "version full" on \
					${spadmin}/${spapass}@${this_hostname}:$PORTNUM"`
		echo $output | grep $drop
		if (( $? != 0 ))
                then
                	LogIt "Failed:: verify_patch"
                	LogIt "Expected Version: $drop"
                	LogIt "Actual Version: $output"
                else
                	LogIt "Passed:: verify_patch"
                	LogIt "Expected Version: $drop"
                	LogIt "Actual Version: $output"
                fi

    LogFunctEnd $0 "$@"
                debug_pause 1
        }

# ixs001
# ==============================================================================
# Name: optvar
# ==============================================================================

        function optvar
        {

		typeset sid
		typeset var
		typeset opt
		typeset sid_file

		sid=$1
		var=$2
		opt=$3
		sid_file=$AUTO_WORK_DIR/${AUTO_TESTER}_${AUTO_CURRENT_ENF}
		remove_if_exist $sid_file

		echo "$sid" > $sid_file
		if ( grep -q 734 $sid_file )
		then
			change $var 7 $AUTO_ENV_FILE.src
			change $var 7 $AUTO_ENV_FILE.dst
			change $opt 7 $AUTO_ENV_FILE.src
			change $opt 7 $AUTO_ENV_FILE.dst

		elif ( grep -q 80 $sid_file )
                then
                        change $var 8 $AUTO_ENV_FILE.src
                        change $var 8 $AUTO_ENV_FILE.dst
                        change $opt 8 $AUTO_ENV_FILE.src
                        change $opt 8 $AUTO_ENV_FILE.dst

		elif ( grep -q 81 $sid_file )
                then
                        change $var 8i $AUTO_ENV_FILE.src
                        change $var 8i $AUTO_ENV_FILE.dst
                        change $opt 8i $AUTO_ENV_FILE.src
                        change $opt 8i $AUTO_ENV_FILE.dst

		elif ( grep -q 9 $sid_file )
                then
                        change $var 9i $AUTO_ENV_FILE.src
                        change $var 9i $AUTO_ENV_FILE.dst
                        change $opt 9i $AUTO_ENV_FILE.src
                        change $opt 9i $AUTO_ENV_FILE.dst

		elif ( grep -q app $sid_file )
                then
                        change $var 8i $AUTO_ENV_FILE.src
                        change $var 8i $AUTO_ENV_FILE.dst
                        change $opt 8i $AUTO_ENV_FILE.src
                        change $opt 8i $AUTO_ENV_FILE.dst

                fi
	}

# ixs004
# ==============================================================================
# Name: get_string
# ==============================================================================
function get_string {

    LogFunctStart $0 "$@"

    typeset ValArgPat="$# == 6 || $# == 7" 
    typeset UseMsg="usage: $0 src|dst HostId Remote_Path Remote_File"
       UseMsg="${UseMsg} SearchString PASS|FAIL [SendEmail]" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments to local variables
    typeset HostType=$1
    typeset HostId=$2
    typeset RemPath=$3
    typeset RemFile=$4
    typeset SearchStr=$5
    typeset exp_result=$6
    typeset EmailFlag=$7

    set_oracle_env $HostType $HostId
    debug_pause 1

    # Other local variables
    typeset CmdOut          # Output of grep
    typeset Result          # status of grep
    typeset NotFoundMsg="$SearchStr not in $RemFile on $this_hostname"
    typeset FoundMsg="$SearchStr found in $RemFile on $this_hostname"
    typeset LocFile="$AUTO_WORK_DIR/${AUTO_TEST_RUN_ID}_${this_hostname}"
            LocFile="${LocFile}_.$RemFile"

    # Remove local file if it exists from previous test
    remove_if_exist $LocFile

    # Get the file from the remote host
    CmdOut=$(RemoteGetFile $this_hostname $RemPath/$RemFile $LocFile)

    # Search for the string in the file on local machine
    CmdOut=`grep "$SearchStr" $LocFile`
    CmdResult=$?

    # Function for passing test
    function _Pass {
        # Show the result of grep for search string
        LogIt "RESULT:\n $CmdOut"

        # Print correct pass msg depending on expected result
        [[ "$exp_result"  == "PASS" ]] && {
            LogIt "Passed: $FoundMsg"
        } || {
            LogIt "Passed: $NotFoundMsg"
        }

    }

    # Function for failing test
    function _Fail {

        # Send email if email flag was set
        [[ -n "$EmailFlag" ]] && {

         typeset MsgBod="Command: get_string $HostType $HostId $RemPath $RemFile"
                 MsgBod="${MsgBod} $SearchStr $exp_result $EmailFlag"

         SendEMail "GET_STRING \"$SearchStr\" from $RemFile on $this_hostname FAILED" \
                   "$MsgBod" $LocFile
        }

        # Print correct failure msg depending on expected result
        [[ "$exp_result"  == "PASS" ]] && {
            LogIt "Failed:: $NotFoundMsg"
        } || {
            LogIt "Failed:: $FoundMsg"
        }

    }

    # Pass or fail test depending on the users expected result
    case $exp_result in
        PASS ) (( $CmdResult == $TRUE )) && _Pass || _Fail ;;
        FAIL ) (( $CmdResult != $TRUE )) && _Pass || _Fail ;;
    esac

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: get_string_spctrl
# ==============================================================================

#TODO: re-organize this code
function get_string_spctrl {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3
    typeset String=$4
    typeset ExpResult=$5

    typeset result
    typeset output

    typeset counter=1
    typeset countermax
    typeset sleeptime=3


    # Set the max counter
    # TODO: just use the last element of argument array
    if [[ $6 = +([0-9]*) ]];then
        countermax=$6
    elif [[ $7 = +([0-9]*) ]];then
        countermax=$7
    else
        countermax=600
    fi

    debug_pause 1

    set_oracle_env $HostType $HostId

    typeset Host=$this_hostname
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset Port=$AUTO_SPO_PORT

    typeset RetVal=$TRUE

    ## IR 101212 Added SpoVer
    #SV=`echo $this_spo_ver | cut -c1-1`

    ## IR 101212 changed "show compare" to "repair status" if spo version >= 8.0 and checking Repaired
    #if (( "$SV" >= 8 )) && [[ "$String" == "Repaired" ]] && [[ "$Cmd" == "show compare" ]];  then
    #   Cmd="repair status"
    #fi

    case $ExpResult in
        SKIP|skip|Skip)
            SpctrlOut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "$Cmd")
            output=`print "$SpctrlOut" | grep "$String"`
            result=$?
            if [ $result -eq 0 ];then
                RetVal=$TRUE
                LogIt "Passed: GET_STRING_SPCTRL '$String' FROM '$Cmd'"
                LogIt "Passed: splex.get_string_spctrl '$String' FROM '$Cmd'"
                LogIt "RESULT:\n $output"

                if (( $# == 6 )); then
                    SendEMail "GET_STRING_SPCTRL $String FROM $Cmd ON $this_hostname; Condition for this test case already met, test case $AUTO_CURRENT_TEST_ID SKIPPED" "in subject\n$SpctrlOut"
                fi
                stop_test
                exit 0
            fi
        ;;

        PASS|pass|Pass)
            result=1
            while (( $result != 0 && $counter <= $countermax )); do

                SpctrlOut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "$Cmd")
                output=`print "$SpctrlOut" | grep "$String"`
                result=$?
                counter=`expr $counter + 1`
                sleep $sleeptime
            done

            if [ $result -eq 0 ];then
                RetVal=$TRUE
                LogIt "Passed: GET_STRING_SPCTRL '$String' FROM '$Cmd'"
                LogIt "RESULT:\n $SpctrlOut"
            else
                RetVal=$FALSE
                LogIt "Failed:: GET_STRING_SPCTRL '$String' FROM '$Cmd'"

                if (( $# == 6 )); then
                    SendEMail "GET_STRING_SPCTRL $String FROM $Cmd ON $this_hostname FAILED in $AUTO_CURRENT_TEST_ID" "in subject\n$SpctrlOut"
                fi
            fi
        ;;

 	       FAIL|fail|Fail)
            result=0
            while (( $result == 0 && $counter <= $countermax )); do

                SpctrlOut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "$Cmd")
                output=`print "$SpctrlOut" | grep "$String"`
                result=$?
                counter=`expr $counter + 1`
                sleep $sleeptime
            done

            if [ $result -ne 0 ];then
                RetVal=$TRUE
                LogIt "Passed: GET_STRING '$String' FROM '$Cmd'"
                LogIt "RESULT:\n $SpctrlOut"
            else
                RetVal=$FALSE
                LogIt "Failed:: GET_STRING_SPCTRL '$String' FROM '$Cmd'"
                LogIt "RESULT:\n $SpctrlOut"

                if (( $# == 6 )); then

                    SendEMail "GET_STRING_SPCTRL $String FROM $Cmd ON $this_hostname FAILED in $AUTO_CURRENT_TEST_ID" "in subject\n$SpctrlOut"
                fi
            fi
         ;;

    esac

    LogFunctEnd $0 "$@"

    debug_pause 1

    return $RetVal
}

# ixs005
# ==============================================================================
# Name: get_file
# ==============================================================================
function get_file {

    LogFunctStart $0 "$@"

    typeset ValArgPat="$# == 4 || $# == 5" 
    typeset UseMsg="usage: $0 src|dst HostId Remote_Path Remote_File" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Arguments set to local vars
    typeset HostType=$1
    typeset HostId=$2
    typeset RemPath=$3      # Remote path where file exists
    typeset RemFile=$4      # Remote file name

    set_oracle_env $HostType $HostId

    debug_pause 1

    # Path and file name of the local file
    typeset LocFile="$AUTO_WORK_DIR/${AUTO_TEST_RUN_ID}_${this_hostname}_"
        LocFile="${LocFile}.${RemFile}"

    remove_if_exist $LocFile

    # Get the file and pass or fail
    CmdOut=$(RemoteGetFile $this_hostname $RemPath/$RemFile $LocFile) && {

        # If fifth arguments then dump the files contents to the TC log
        if (( $# == 5 )); then
            LogIt "${this_hostname}:${RemPath}/${RemFile} contents: "
            LogIt "++++++++++++++++++++++++++++++++ "
            LogIt "`cat $LocFile`"
        fi

        LogIt "Passed:: GET_FILE $RemFile FROM $this_hostname"

    } || {
        LogIt "Failed:: GET_FILE $RemFile FROM $this_hostname"
        LogIt "$CmdOut"
    }

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ixs010
# ==============================================================================
# Name: put_file
# ==============================================================================
function put_file {

    LogFunctStart $0 "$@"

    typeset ValArgPat="$# == 4 || $# == 5" 
    typeset UseMsg="usage: $0 src|dst HostId Remote_Path Local_File" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset host_type=$1
    typeset host_id=$2
    typeset DstPath=$3
    typeset SrcPathFile=$4

    typeset FileName=${SrcPathFile##/*/}

    set_oracle_env $host_type $host_id

    debug_pause 1

    # Put the file and pass or fail
    OutPut=$(RemoteCopyFile $SrcPathFile $this_hostname $DstPath/$FileName) && {

        # if fifth argument was passed in then show the file contents
        if (( $# == 5 )); then
            LogIt "$SrcPathFile contents: "
            LogIt "`cat $SrcPathFile`"
        fi

        LogIt "Passed:: $SrcPathFile to $this_hostname"
    } || {

        LogIt "$OutPut"
        LogIt "Failed:: $SrcPathFile to $this_hostname"
        
    }

    LogFunctEnd $0 "$@"
    debug_pause 1

}


#TODO: REMOVE THIS FUNCTION. NOT NEED. DONE IN MSTRLIB INSTEAD
# ==============================================================================
# Name: check_testplan_id
# ==============================================================================

function check_testplan_id {

    #typeset curr_version
    typeset Id
    typeset Desc
    typeset testplan_id_list

    TPLst=$AUTO_ROOT_DIR/testplan_id_list

    # Anne wants to use the target machines version
    Line=`cat $TPLst | grep $AUTO_DST_BASE_VERSION | grep -m 1 $AUTO_MASTER_SUITE`
    Id=`print $Line | awk '{print $1}'`
    Desc=`print $Line | awk -F "\"" '{print $2}'`

    # Print warning if can't find it
    [[ -z "$Id" ]] && {
        print "\n\nWARNING: Couldn't find the test plan ID# for $AUTO_MASTER_SUITE"
        print "\tfor SPO v${AUTO_DST_BASE_VERSION}.X.X. Please have a test lead add it to the"
        print "\ttest plan list or you may not be able to insert test results into the TCM"
    }

    print "\nMaster suite name:\t\t$AUTO_MASTER_SUITE"
    print "Master suite description:\t${Desc}"
    print "Testing version:\t\t$AUTO_DST_BASE_VERSION"
    print "Test Plan ID:\t\t\t$Id"
    print "Is the above information correct ? (y/n): \c"

    read answer

    case $answer in
        Y|y)
            print "Continuing...." ;;

        N|n)
            print "\nAutomation will exit now so you can fix the problem....\n"
            kill $$
        ;;

        *)  continue ;;

    esac    
                    
}
        

# ixs002
# ==============================================================================
# Name: get_spctrl_log
# ==============================================================================

function get_spctrl_log {

    typeset cmd=$1
    typeset param=$2

    typeset output1
    typeset output2

    print "src $AUTO_SRC_OS"
    print "dst $AUTO_DST_OS"

#TODO: make it work on windows
    # Do not run on windows
    if _IsWindows $AUTO_SRC_OS -o _IsWindows $AUTO_DST_OS; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return $FLASE
    fi

    output1=`/usr/bin/rexec -a -l $spadmin -p $spapass \
       $s_host0 "export SP_SYS_VARDIR=${s_vardir0};" "$s_proddir0/bin/sp_ctrl "$cmd" on $spadmin/$spapass@$s_host0:$PORTNUM"`
    sleep 1 
    output2=`/usr/bin/rexec -a -l $spadmin -p $spapass \
       $d_host0 "export SP_SYS_VARDIR=${d_vardir0};" "$d_proddir0/bin/sp_ctrl "$cmd" on $spadmin/$spapass@$d_host0:$PORTNUM"`
    sleep 1
    LogIt "$param= `echo $output1 | tr -d '\n'`"
    LogIt "${param}_TARGET= `echo $output2 | tr -d '\n'`"
}

# ixs007
# ==============================================================================
# Name: create_atl
# ==============================================================================
function create_atl
{

    typeset config_file=$1
    typeset atl=$2
    typeset output
    typeset Line

    export AUTO_TABLE_LIST="$AUTO_WORK_DIR/$atl"

    print "AUTO_TABLE_LIST=$AUTO_TABLE_LIST"

    cat $config_file | grep '^[[:blank:]]*[^[:blank:]#]' | awk '{print $1}' | grep -v ":" | grep -v "^!" | grep -v "" > $AUTO_TABLE_LIST || {
        return 1
    } 
  

    export atl=$AUTO_TABLE_LIST

    return 0 
}

# ==============================================================================
# Name: oracle_vars
# ==============================================================================

function oracle_vars
{

    typeset output

    export oracle_conf_file=$1
    debug_pause 1

    # TW - isn't this the same????
    date=`date +%x`
    time=`date +%X`

    LogIt "#############################################################"
    LogIt "TEST START TIME=$date $time"
    LogIt "TESTCASE_ID=$AUTO_CURRENT_TEST_ID"
    #LogIt "`tr -s ' ' ' ' < $AUTO_CURRENT_TEST/main.ksh|head -9|tail -3|sed -e s/"# "//|sed -e s/":"/"="/`"
    LogIt "`tr -s ' ' ' ' < $AUTO_CURRENT_TEST/main.ksh|head -8|tail -2|tr -d '# ' | tr ':' '='`"
    LogIt "MASTER_SUITE_NAME=$master_suite_name"
    LogIt "SUITE_NAME=$suite_name"
    LogIt "TESTER=$AUTO_TESTER"
    LogIt "TESTER EMAIL=$AUTO_USER_EMAIL"
    LogIt "PLATFORM=$PLATFORM"
    LogIt "Source ORACLE_HOME=$AUTO_SRC_ORA_HOME"
    LogIt "Target ORACLE_HOME=$AUTO_DST_ORA_HOME"
    LogIt "DROP_VERSION=$AUTO_SRC_SPO_VER"
    LogIt "PORT=$AUTO_SPO_PORT"
    LogIt "BUG_ID="
    LogIt "SOURCE MACHINE NAME=$AUTO_SRC_HOST_NAME"
    LogIt "SOURCE ORACLE SID=$AUTO_SRC_SID"
    LogIt "SOURCE SP_SYS_VARDIR=$AUTO_SRC_VAR_DIR"
    LogIt "SOURCE PRODUCT DIRECTORY=$AUTO_SRC_OPT_DIR"
    LogIt "TARGET MACHINE NAME=$AUTO_DST_HOST_NAME"
    LogIt "TARGET ORACLE SID=$AUTO_DST_SID"
    LogIt "TARGET SP_SYS_VARDIR=$AUTO_DST_VAR_DIR"
    LogIt "TARGET PRODUCT DIRECTORY=$AUTO_DST_OPT_DIR"
    LogIt "CONFIG FILE NAME=${oracle_conf_file}"
    LogIt "$AUTO_SP_CTRL_INFO"
    LogIt "Comments:"
    LogIt "Comments:"
    LogIt "Comments:"
    LogIt "TESTPLAN_ID=$AUTO_TEST_PLAN_ID"

    check_if_exist $curr_config

    # Copy temp config over to test dir. This is to provide
    # compatibility with old code that needs this file here
    #cp "$AUTO_TEMP_DIR/$AUTO_CURRENT_CONF_TMP" "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"

    # Create table list in the tmp dir of current testcase
    # This is done here for every test case and not in the driver because the testcase
    # isn't known when the shareplex config is created and copied to server
    create_atl $AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP \
               "$AUTO_CURRENT_CONFIG.tab_list"

    debug_pause 1


}

# ==============================================================================
# Name: change
# ==============================================================================

	function change
	{
		typeset string1
		typeset string2
		typeset fname
                typeset TempFile

		string1=$1
		string2=$2
		fname=$3
        TempFile="$AUTO_WORK_DIR/$AUTO_TESTER_`basename $fname`_.tmp.$$"

		cat ${fname} | sed "s/${string1}/${string2}/g" > "$TempFile"
		mv $TempFile $fname

	}

# ixs012
# ==============================================================================
# Name: wait_for_process
# ==============================================================================

function wait_for_process {

    typeset HostType=$1
    typeset HostId=$2
    typeset String=$3

    LogFunctStart $0 "$@"

    debug_pause 1

    set_oracle_env $HostType $HostId   # pxh031

    # Extract process name from ps -ef command if it's windows
    _IsWindows $PLATFORM && String=${String##*/*/}

    # Execute expect script
    $AUTO_EXPECT_DIR/wait_for_process $String

    # See if expect script passed or failed
    if (( $? != 0 )); then
        LogIt "Failed:: 'splex.wait_for_process $HostType $HostId $String"
    else
        LogIt "Passed:: 'splex.wait_for_process $HostType $HostId $String"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Sends multiple commands to sp_ctrl on remote host
# ==============================================================================
function multi_send {

    typeset HostType=$1
    typeset HostId=$2
    typeset Commands=$3
    typeset Logging=${4:-""}

    LogFunctStart $0 "$@"

    debug_pause 1

    set_oracle_env $HostType $HostId   # pxh031

    # Execute expect script with or with out logging
    [[ -n "$Logging" ]] && {
        $AUTO_EXPECT_DIR/multisend.exp "$Commands" Log
    } || {
        $AUTO_EXPECT_DIR/multisend.exp "$Commands"
    }

    # See if expect script passed or failed
    if (( $? != 0 )); then
        LogIt "Failed:: '$0 $HostType $HostId $Commands"
    else
        LogIt "Passed:: '$0 $HostType $HostId $Commands"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}


# ixs013
# ==============================================================================
# Name: tar_all_logs
# ==============================================================================

        function tar_all_logs
        {
                typeset host_type
                typeset host_id
                typeset varlog

                host_type=$1
                host_id=$2

		set_oracle_env $host_type $host_id
		varlog=`echo $this_vardir | cut -d/ -f4`
		r_tar_file=${this_hostname}_varlog_${varlog}.tar

		$AUTO_EXPECT_DIR/ora_tar $this_hostname splexo splexo ${this_vardir}/log $r_tar_file
		$AUTO_EXPECT_DIR/ora_ftp $this_hostname splexo splexo ${this_vardir}/log ${r_tar_file}.Z
		cur_time=`date +"%d%b%y%H%M%S"`
		mv /log/${r_tar_file}.Z /log/${r_tar_file}_${cur_time}.Z
                LogIt "Vardir/log directory has been saved to /log/${r_tar_file}_${cur_time}.Z"
                /usr/bin/rexec -a -l splexo -p splexo $this_hostname "rm ${this_vardir}/log/*"
                LogIt "Removing all files from ${this_vardir}/log from $this_hostname"
        }

# ==============================================================================
# Name: tar_all_var
# ==============================================================================

        function tar_all_var
        {       
	typeset host_type
                typeset host_id
                typeset vardir

                host_type=$1
                host_id=$2

                LogIt "Starting tar_all_var `date` "
                debug_pause 1

                set_oracle_env $host_type $host_id

        # TODO: make it work on windows
        if _IsWindows $PLATFORM; then
           LogIt "$0 not supported for windows."
           LogIt "your var dir will not be archived!"
        fi
                vardir=`echo $this_vardir | cut -d/ -f4`
                r_tar_file=${AUTO_TESTER}.${AUTO_CURRENT_TEST_ID}.${config}.${AUTO_ENV_FILE}.tar

                $AUTO_EXPECT_DIR/ora_tar $this_hostname splexo splexo ${this_vardir} $r_tar_file
                $AUTO_EXPECT_DIR/ora_ftp $this_hostname splexo splexo ${this_vardir} ${r_tar_file}.Z

                cur_time=`date +"%d%b%y%H%M%S"`
                mv_tar_file=${AUTO_TESTER}.${AUTO_CURRENT_TEST_ID}.${config}.${AUTO_ENV_FILE}.${host_type}.vardir.${cur_time}.tar
                mv /debug/${r_tar_file}.Z /debug/${mv_tar_file}.Z

		if [ -e /debug/${mv_tar_file}.Z ] && [ -s /debug/${mv_tar_file}.Z ]
		then
                	LogIt "The whole VARDIR directory has been saved to /debug/${mv_tar_file}.Z"
			return 0
		else
                	LogIt "VARDIR directory could NOT be saved"
			return 1
		fi
			

                LogIt "Done tar_all_var `date` "
                debug_pause 1
        }       

# ==============================================================================
# Name: compare_run_sql
# ==============================================================================
function compare_run_sql {

    # Set arguments to local variables
    typeset host_type=$1
    typeset host_id=$2
    typeset src_sql_file=$AUTO_SQL_DIR/$3
    typeset dst_type=$4
    typeset dst_id=$5
    typeset dst_sql_file=$AUTO_SQL_DIR/$6
    typeset sqluser=$7
    typeset detail=$8

    # Other local variables
    typeset result
    typeset src_sql
    typeset dst_sql
    typeset src_sql_file
    typeset dst_sql_file
    typeset run_sql_comp_file

    LogFunctStart $0 "$@"
    set_oracle_env $host_type $host_id
    . $AUTO_ROOT_DIR/local_sqlplus
    debug_pause 1

    check_oracle $AUTO_SRC_TNS_NAME
    check_oracle $AUTO_DST_TNS_NAME

    src_sql=`cat $src_sql_file | sed 's/;//g'`
    dst_sql=`cat $dst_sql_file | sed 's/;//g'`


    LogIt "compare_run_sql results :"
    LogIt "+++++++++++++++++++++++++++++++++++++++"
    
    # Create DB link if needed
    run_sql_file src 0 qa_create_db_link.sql sp_otest log

x=`sqlplus ${sqluser}/${sqluser}@$AUTO_SRC_TNS_NAME<<EOF | grep SPACE | sed 's/SPACE//;s/[ 	]//g'
        whenever sqlerror exit 1
        ALTER SESSION SET global_names = FALSE;

        select 'SPACE' , count(*)
           from
           (
             ( $src_sql
               minus
               $dst_sql@$AUTO_DST_TNS_NAME )
              union
             ( $dst_sql@$AUTO_DST_TNS_NAME
               minus
               $src_sql )
           );

        exit 0
EOF`

    if [ "$x" == "0" ]; then
        LogIt "Passed:: Compare $src_sql and $dst_sql: equal"
    else
        if [ -z $x ]; then
            LogIt "Compare\t ${src_sql} and\t\n \t\t${dst_sql}:\t Not able to compare"
            LogIt "might contain LOBS or other large object types!"
        else
            LogIt "Failed::\t Compare ${src_sql} and\t\n \t\t${dst_sql}:\t NOT equal"

            if (( $# == 8 )); then

            				sqlplus ${sqluser}/${sqluser}@${AUTO_DST_TNS_NAME} <<EOF
               				-- set pages 0 echo off verify off feed off term off define off escape off scan off
               				whenever sqlerror exit 1
               				exit 0
               				SET verify off linesize 132 pagesize 10000 feedback off heading off

               				select 'Records in SOURCE that are not in TARGET' from dual;
               				SET heading ON

             				( $src_sql
               				minus
               				$dst_sql@$AUTO_DST_TNS_NAME );

               				SET heading OFF
               				select 'Records in TARGET that are not in SOURCE' from dual;
               				SET heading ON

             				( $dst_sql@$AUTO_DST_TNS_NAME
               				minus
               				$src_sql );

EOF
            fi # if (( $# == 8 ))

        fi # END if [ -z $x ]

    fi # END if [ "$x" == "0" ]


                LogFunctEnd $0 "$@"
                debug_pause 1
}

function compare_count_all {

    LogFunctStart $0 "$@"
    debug_pause 1

    typeset ValArgPat="$# >= 5" 
    typeset UseMsg="usage: $0 src HostId dst HostId [PASS|FAIL] [N]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }
    # Set args to local vars.
    # NOTE: arguments 1, 2, 3, and 4 are never used!
    typeset SrcType=$1
    typeset SrcId=$2
    typeset DstType=$3
    typeset DstId=$4
    typeset User=$5

    ### PARSE OUT OPTIONAL 6th and 7th arguments

    # Just the 5 required arguments
    if [[ $# == 5 ]]; then
        typeset ExpResult="PASS"
        typeset SkipTabLst="NONE"

    # Just the 5 required arguments and the 6th optional
    elif [[ $# == 6 ]]; then

        # If the 6th arg has numbers then it must be a table list
        if [[ $6 = +([0-9]*) ]]; then
            typeset ExpResult="PASS"
            typeset SkipTabLst=$6

        # 6th arg doesn't have numbers, must be expected result, no list
        else 
            typeset ExpResult=${6:-PASS}
            typeset SkipTabLst="NONE"
        fi 

    # Just the 5 required arguments and the 6th and 7th optional args 
    elif [[ $# == 7 ]]; then 
        typeset ExpResult=${6:-PASS}
        typeset SkipTabLst=${7:-NONE}
    fi

    # Initilize tables to skipp
    _InitGlobalArray "$SkipTabLst" ":"

    # Other local vars
    typeset SrcCount # Row count on source table
    typeset DstCount # Row count on the dest table
    typeset SrcTns="$AUTO_SRC_TNS_NAME" # Source tns service name
    typeset DstTns="$AUTO_DST_TNS_NAME" # Dst tns service name
    typeset Log="$AUTO_TEST_CASE_LOG"   # Test case log
    typeset Timer=0         # Timer for checking table, resets for each table
    typeset FailFlag=$FALSE # Will be TRUE if any table fails
    # A pretty line in report
    typeset L="========================================================================"
    typeset Report   # A report to printout the table row counts
    typeset TableNum=0   # Current table number
    typeset FaildTabs="\n$L\nFailed Tables\n$L\n"

    #CONSTANTS
    typeset MAX=90
    #typeset MAX=20
    typeset INTERVAL=10

    LogFunctStart $0 "$@"

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle $SrcTns
    check_oracle $DstTns

    # Print results header
    Report="`printf '%-34s\n'  "Select count Results:"`"
    Report="${Report}\n$L"
    Report="${Report}\n`printf '%-55s %-9s %-9s\n' "Table" "Source" "Target"`"
    Report="${Report}\n$L"

    # Compare the count of all tables in the table list
    while read Table; do

        # Skip lines with bad data
        _IsJunk "$Table" && continue

        # Initialize vars and things for a table
        Timer=0
        ((TableNum=$TableNum + 1)) 
        print "Comparing count for table #$TableNum: $Table"

        # Keep checking count of current table until desired result or timed out
        while [ $Timer -le $MAX ]; do

            # Get count on source or fail the table
            SrcCount=$(_GetTabCount "$SrcTns" "$User" "$User" "$Table") || {
                # Set fail flag if getting count fails
                FailFlag=$TRUE
            }

            # Get count on dest or fail the table
            DstCount=$(_GetTabCount "$DstTns" "$User" "$User" "$Table") || {
                # Set fail flag if getting count fails
                FailFlag=$TRUE
                break
            }

            # Don't check result of tables to skip
            _IsInArray "$TableNum" == $TRUE && break

            # Expect table counts to be equal
            if [[ "$ExpResult" == "PASS" ]]; then

                # Goto next table if counts are equal
                [[ "$SrcCount" == "$DstCount" ]] && break

                # Set up not equal message
                typeset Msg="$Table is not equal as expected"

            # Expect table counts to NOT be equal
            elif [[ "$ExpResult" == "FAIL"  ]]; then

                # Goto next table if counts are NOT equal
                [[ "$SrcCount" != "$DstCount" ]] && break

                # Set up not equal message
                typeset Msg="$Table is equal and was expected not to be."

            fi
                        
            # Expected result was not reached cause it got this far

            ((Timer=$Timer + $INTERVAL))

            # If timeout reached then fail this table and move to next
            if (( $Timer > $MAX )); then 
                # Write it to failed tables list
                FaildTabs="${FaildTabs}`printf '%-55s %-9s %-9s' "$Table" "$SrcCount" "$DstCount"`\n"
                FailFlag=$TRUE
                break

            # Check again after sleeping for a while
            else
                print "\n$Msg"
                print "Retrying in $INTERVAL seconds...\n"
                echo_sleep $INTERVAL 
            fi

        done # 

        # Print the result
        Report="${Report}\n`printf '%-55s %-9s %-9s\n' "$Table" "$SrcCount" "$DstCount"`"

    done < $AUTO_TABLE_LIST

    # Build report and show it
    Report="${Report}${FaildTabs}"
    LogIt "$Report"

    # Check fail flag to see if a table failed
    [[ "$FailFlag" == "$TRUE" ]] && {
        Subject="$0 FAILED in TC# $AUTO_CURRENT_TEST_ID on $SrcTns to $DstTns"
        SendEMail "$Subject" "Expected:$ExpResult\n\n$Report"
        LogIt "Failed:: Row counts"
    } || {
        LogIt "Passed:: $0"
    }

    LogFunctEnd $0 "$@"

}



# ==============================================================================
# Name: compare_count_table
# ==============================================================================
function compare_count_table {

    typeset src_type=$1
    typeset src_id=$2
    typeset dst_type=$3
    typeset dst_id=$4
    typeset table=$(_GetTabNameIfNum $5)
    typeset sqluser=$6
    typeset ExpResult=${7:-'PASS'}

    typeset src_table
    typeset dst_table
    typeset src_dst_diff_table

    LogFunctStart $0 "$@" 
    debug_pause 1

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle $AUTO_SRC_TNS_NAME
    check_oracle $AUTO_DST_TNS_NAME

    # Get count on source or fail the table
    SrcCount=$(_GetTabCount "$AUTO_SRC_TNS_NAME" "$sqluser" "$sqluser" "$table") || {
       # Set fail flag if getting count fails
       FailFlag=$TRUE
    }

    # Get count on dest or fail the table
    DstCount=$(_GetTabCount "$AUTO_DST_TNS_NAME" "$sqluser" "$sqluser" "$table") || {
       # Set fail flag if getting count fails
       FailFlag=$TRUE
    }
    
    # Counts are equal
    [[ "$SrcCount" == "$DstCount" ]] && {

        # Was it expected to pass
        [[ "$ExpResult" == "PASS" ]] && { 
            LogIt "Passed:: Compare count on $table equal"
            LogIt "         Comparison expected to pass"

        # Expected to fail
        } || {

            # If both tables do NOT have data issue warning
            [[ "$SrcCount" == "0" && "$DstCount" == "0" ]] && {
                LogIt "Warning:: Compare count on $table found 0 data on src and dst"
                LogIt "          Comparison expected to fail"

            # There is data, but they are same. So fail it
            } || {
                LogIt "Failed:: Compare count on $table equal"
                LogIt "         Comparison expected to fail"
            }
        }

    # Counts are not equal
    } || {

        # Were the counts expected to fail
        [[ "$ExpResult" == "FAIL" ]] && {
            LogIt "Passed:: Compare count on $table: NOT equal"
            LogIt "         Comparison expected to fail"
        } || {
            typeset Msg="Compare count $table FAILED in TC# $AUTO_CURRENT_TEST_ID"
            SendEMail "$Msg" "$Msg"
            LogIt "Failed:: Compare count on $table: NOT equal"
            LogIt "         Comparison expected to pass"
    
        }

    }

    LogFunctEnd $0 "$@"
    debug_pause 1
}


###############################################################################
# Disables an object in Shareplex so it won't be replicated.
# Pass in the object number that is listed in the AUTO_TABLE_LIST. First object
# is number 1 and so on.
###############################################################################
function disable_object {

    LogFunctStart $0 "$@"
    debug_pause 1


    typeset TabNumToFind=$1

    typeset CurrLineNum=0
    typeset Line
    typeset ObjId

    # Get the desired table from the list
    while read Line; do

        _IsJunk "$Line" && continue
        ((CurrLineNum=$CurrLineNum + 1))

        # Check if the current line is the line number that is desired
        if [[ "$CurrLineNum" == "$TabNumToFind" ]]; then

            set_oracle_env "src" "0"

            # Get the object id of the object
            ObjId=$(_GetObjId "$Line" $this_tns $this_spadmin $this_spapass ) || {
                LogIt "Failed:: Couldn't get object id for $Line:\n$ObjId"
                LogFunctEnd $0 "$@"
                return $FALSE
            }

            LogIt "Disabling object ID#: $ObjId"

            # Send command to shareplex to disable object
            typeset Cmd="set param SP_OPO_DISABLE_OBJECT_NUM $ObjId"

            CmdOutPut=$(_SPCTRL_CmdLocToRemote "dst" "0"  "$Cmd") || {
                LogIt "Failed:: sp_ctrl failed executing status\n$CmdOutPut"
                LogFunctEnd $0 "$@"
                return $FALSE
            }
            
            sleep 1


            # Verify setting it by checking it in sp_ctrl
            get_string_spctrl dst 0 "list param post" "SP_OPO_DISABLE_OBJECT_NUM.*$ObjId" PASS email

            break
        fi

    done < $AUTO_TABLE_LIST

    LogFunctEnd $0 "$@"

    return $TRUE
}


# ==============================================================================
# Name: compare_table_all
# ==============================================================================
function compare_table_all {

    LogFunctStart $0 "$@"
    debug_pause 1

    typeset ValArgPat="$# >= 5" 
    typeset UseMsg="usage: $0 src HostId dst HostId [PASS|FAIL] [N]"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments passed in to local variables
    typeset src_type=$1  # NOT USED!!!
    typeset src_id=$2    # NOT USED!!!
    typeset dst_type=$3  # NOT USED!!!
    typeset dst_id=$4    # NOT USED!!!
    typeset Uid=$5

    ### PARSE OUT OPTIONAL 6th and 7th arguments

    # Just the 5 required arguments
    if [[ $# == 5 ]]; then
        typeset ExpResult="PASS"
        typeset SkipTabLst="NONE"

    # Just the 5 required arguments and the 6th optional
    elif [[ $# == 6 ]]; then

        # If the 6th arg has numbers then it must be a table list
        if [[ $6 = +([0-9]*) ]]; then
            typeset ExpResult="PASS"
            typeset SkipTabLst=$6

        # 6th arg doesn't have numbers, must be expected result, no list
        else 
            typeset ExpResult=${6:-PASS}
            typeset SkipTabLst="NONE"
        fi 

    # Just the 5 required arguments and the 6th and 7th optional args 
    elif [[ $# == 7 ]]; then 
        typeset ExpResult=${6:-PASS}
        typeset SkipTabLst=${7:-NONE}
    fi

    # Initilize tables to skipp
    _InitGlobalArray "$SkipTabLst" ":"

    # Other local variables
    typeset DiffFile="$AUTO_WORK_DIR/${AUTO_TESTER}_$AUTO_SRC_HOST_NAME"
            DiffFile="${DiffFile}_${AUTO_SRC_SID}_${AUTO_CURRENT_CONFIG}.ctaf"

    # Sql executed to set up the session
    typeset PreSql="set heading off\n"
            PreSql="${PreSql}ALTER SESSION SET global_names = FALSE;\n"

    typeset Log=$AUTO_TEST_CASE_LOG
    typeset Sql          # the sql to get counts, initialize later in the loop
    export Failures=""      # Will hold all the failures to be emailed
    typeset TableNum=0   # Current table number
    typeset Result=""



    remove_if_exist $DiffFile

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle $AUTO_SRC_TNS_NAME
    check_oracle $AUTO_DST_TNS_NAME

    # Create DB link if needed
    #TODO: execute in co-process
    run_sql_file src 0 qa_create_db_link.sql sp_otest

    # Start SQL*Plus in a co-process or fail
    sqlplus -s /NOLOG |&
    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Uid $AUTO_SRC_TNS_NAME) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $AUTO_SRC_TNS_NAME"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Exec setup session commands
    Output=$(_CoProcExecSql "p" "p" "$PreSql") 

    LogIt "Compare results. Tables equal will $ExpResult" 
    LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++" 

    # Execute the compare sql for each table
    while read table; do

        # Skip lines with bad data
        _IsJunk "$table" && continue

        ((TableNum=$TableNum + 1))

        # Build sql statement using current table
        Sql="select 'result=' || count(*) from (\n"
        Sql="${Sql} ( select * from $table minus\n"
        Sql="${Sql}   select * from $table@$AUTO_DST_TNS_NAME ) union\n"
        Sql="${Sql} ( select * from $table@$AUTO_DST_TNS_NAME minus\n"
        Sql="${Sql}   select * from $table ));\n"

        # Execute the sql to get count.
        Output=$(_CoProcExecSql "p" "p" "$Sql") || { 

            #Ora errors that cause skipp for objects
            #Skip objects: Varray, Clob, Nclob, Blob, Long, Bfile
            err1="ORA-22992: cannot use LOB locators selected from remote tables"
            err2="ORA-00997: illegal use of LONG datatype"
            err3="ORA-22804: remote operations not permitted on object tables or user-defined"
            err4="ORA-00932: inconsistent datatypes"

            #Check the output for errors of objects we need to skip,
            #because this can not compare them.
            if [[ "$Output" = ?(*$err1*|*$err2*|*$err3*|*$err4*) ]]; then
                typeset ResultMsg="Skipped:: Compare"
                typeset DescMsg="NOT ABLE to compare might contain LOBS"
                printf '%-17s %-34s %-50s\n' "$ResultMsg" "$table" "$DescMsg" | tee -a $Log
                continue
            else
                printf '%-17s %-34s %-10s\n' "Warning::" "$table" "$Output" | tee -a $Log
                continue
            fi

        }

        
        NumDiffs=${Output#*result=} # Extract the number of differnet rows

        # Evaluate the results
        if [[ "$ExpResult" = @(FAIL|Fail|fail) ]]; then

            # Expected result is FAIL, so tables should not be equal. 
            # If tables are equal then fail it.
            [[ "$NumDiffs" == "0" ]] && {
    
                _IsInArray "$TableNum" == $TRUE && {
                    Result="Passed::" 
                } || {
                    Result="Failed::"
                    Failures="${Failures}$Result: $table EQUAL\n"
                }
 
                printf '%-17s %-34s %-10s\n' "$Result  Compare" "$table" "EQUAL" | tee -a $Log

            } || {      # Not Equal, so pass
                printf '%-17s %-34s %-10s\n' "Passed::  Compare" "$table" "NOT EQUAL" | tee -a $Log 
            }

           
        # All other results will expect the tables to be equal.
        else

            [[ "$NumDiffs" == "0" ]] && {
                printf '%-17s %-34s %-10s\n' "Passed::  Compare" "$table" "EQUAL" | tee -a $Log

            } || {      # Not equal so fail

                _IsInArray "$TableNum" == $TRUE && {
                    Result="Passed::" 
                } || {
                    Result="Failed::"
                    Failures="${Failures}`printf '%-10s %-34s %-10s\n' "$Result" "$table" "NOT EQUAL"`"
                }
 
                printf '%-17s %-34s %-10s\n' "$Result  Compare" "$table" "NOT EQUAL" | tee -a $Log
            }

        fi

    done < $AUTO_TABLE_LIST

    # Exit sqlplus co-process
    print -p "exit"

    # If a table compare failed then send an email
    [ -n "$Failures" ] && {
        typeset MailSub="$0 FAILED in TC# $AUTO_CURRENT_TEST_ID on"
          MailSub="${MailSub} $AUTO_SRC_SID@$AUTO_SRC_HOST_NAME and"
          MailSub="${MailSub} $AUTO_DST_SID@$AUTO_DST_HOST_NAME"

        SendEMail "$MailSub" "Tables equal will $ExpResult\n\n$Failures"
    }

    LogFunctEnd $0 "$@"
    debug_pause 1
}


# ixs017
# ==============================================================================
# Name: ora_cleansp
# ==============================================================================

function ora_cleansp {

    LogFunctStart $0 "$@"

    typeset host_type=$1
    typeset host_id=$2

    set_oracle_env $host_type $host_id

    # Do not run on windows
#    if _IsWindows $PLATFORM; then
#
#
#          run_sql_file $host_type 0  $AUTO_SRC_SP_ADMIN  log
#
#       print "$0 not supported for windows."
#       LogFunctEnd $0 "$@"
#       return
#
#
#    fi

    debug_pause 1

        if [ "$AUTO_SRC_PDB" = "1" ]; then

            $AUTO_EXPECT_DIR/ora_cleansp_pdb

            check_result ora_cleansp_pdb $?

            LogFunctEnd $0 "$@"

        else  

            $AUTO_EXPECT_DIR/ora_cleansp

            check_result ora_cleansp $?

            LogFunctEnd $0 "$@"
        fi    
    debug_pause 1

}

# ==============================================================================
# Name: mss_cleansp
# ==============================================================================

function mss_cleansp {

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    set_mss_env $HostType $HostId

    debug_pause 1

    $AUTO_EXPECT_DIR/mss_cleansp

    check_result mss_cleansp $?

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: ppas_cleansp
# ==============================================================================

function ppas_cleansp {

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    set_ppas_env $HostType $HostId

    debug_pause 1

    $AUTO_EXPECT_DIR/ppas_cleansp

    check_result ppas_cleansp $?

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: td_cleansp
# ==============================================================================

function td_cleansp {

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    set_td_env $HostType $HostId

    debug_pause 1

    $AUTO_EXPECT_DIR/td_cleansp

    check_result td_cleansp $?

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: hana_cleansp
# ==============================================================================

function hana_cleansp {

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    set_hana_env $HostType $HostId

    debug_pause 1

    $AUTO_EXPECT_DIR/hana_cleansp

    check_result hana_cleansp $?

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: mysql_cleansp
# ==============================================================================

function mysql_cleansp {

    LogFunctStart $0 "$@"

    typeset HostType=$1
    typeset HostId=$2

    set_mysql_env $HostType $HostId

    debug_pause 1

    $AUTO_EXPECT_DIR/mysql_cleansp

    check_result mysql_cleansp $?

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: check_lmt_setup - rewrite by Tim on 01/31/2004
# ==============================================================================
function check_lmt_setup {

    LogFunctStart $0 "$@"

    set -A VerArray # Array to hold the SPO version

    ##############################################################
    #                     SUB FUNCTIONS
    ##############################################################

    # Set each elements in SPO version array delimited by "."
    function _SetVerArray {


#TODO: add defaults to elements after set if they are null

        typeset SpoVersion=$1 # argument, SPO version x.x.x.x format

        # Save old value of the Input Field Seperator and set to it "."
        OIFS=$IFS && IFS=.

        # Set elements in array to the version split by a "."
        set -A VerArray $SpoVersion

        # Set IFS back to what it was
        IFS=$OIFS
    }

    # Returns 0 or 1 if oracle and spo versions are valid for running lmt setup
    function _ChkVersion {

        typeset OraVer=$1 # arg 1, Short oracle version in 8i, 9i, 806, etc format
        typeset SpoVer=$2 # arg 2, SPO version in x.x.x.x format

        _SetVerArray $SpoVer

        # True if SPO version is less than 5 and Oracle version is 9i
        if (( ${VerArray[0]} < 5 )) && [[ "$OraVer" == "9i" ]]; then
            return $TRUE

        # Oracle version 8i
        elif [[ "$OraVer" == "8i" ]]; then

            # SPO version is 4.5 and above
            if (( ${VerArray[0]} == 4 )) && (( ${VerArray[1]} >= 5 )); then

                # True if SPO version is (4).(5 or below).(3 or below)*
                if (( ${VerArray[2]} >= 3 )); then
                    return $TRUE

                # True if SPO version is (4).(5 or above).(below 3)*
                elif (( ${VerArray[1]} > 5 )) && (( ${VerArray[2]} < 3 )); then
                    return $TRUE

                # All other SPO versions are invalid
                else
                    return $FALSE
                fi

            # Anything other than 4.5 and below is invalid
            else
                return $FALSE

            fi

        # Oracle version that are not 9i or 8i are invalid
        else
            return $FALSE

        fi

    } # END _ChkVersion sub function


    ##############################################################
    #                   MAIN CONTROL
    ##############################################################

    # Check and run lmt setup on source and destination hosts
    for HostType in src dst; do
  
        set_oracle_env "$HostType" 0

        # Even if oracle and spo version are invalid for running lmtsetup, still
        # pass the test case but put message about it not being run
        # Also return TRUE(0). This all can be changed later.
        typeset FailMsg="Passed:: lmt setup is not available for SPO v$this_spo_ver"
                FailMsg="${FailMsg} on Oracle v$this_ora_s_ver."

        # Make sure Oracle and SPO versions are valid for running lmtsetup
        _ChkVersion "$this_ora_s_ver" "$this_spo_ver" || {
            LogIt "$FailMsg"
            LogFunctEnd $0 "$@"
            return $TRUE
        }

        # Set the name of lmt setup executable file according to platform
        [ "$PLATFORM" == "$WINDOWS" ] && LmtExe=lmt_setup.exe || LmtExe=lmt_setup.sh

        # Run lmtsetup
        lmt_setup $HostType 0 && {

          # And these scripts if lmt setup ran ok
          # TODO: run the scripts below in a sqlplus co-process
          run_sql_file $HostType 0 qa_check_create_qsa_ktfbue_view.sql    qarun log
          run_sql_file $HostType 0 qa_check_create_qsa_ktfbue_view.sql    qarun log
          run_sql_file $HostType 0 qa_check_grant_select_on_qsaktfbue.sql qarun log
          run_sql_file $HostType 0 qa_check_grant_select_on_qsaktfbue.sql qarun log

        }

    done

    LogFunctEnd $0 "$@"
} 


# ==============================================================================
# Name: lmt_setup
# ==============================================================================

function lmt_setup {

    typeset host_type=$1
    typeset host_id=$2

    set_oracle_env $host_type $host_id

    LogIt "Running expect script for lmt_setup on ${this_hostname} `date` "
    debug_pause 1

    $AUTO_EXPECT_DIR/lmt_setup

    ScriptResult=$? 

    check_result lmt_setup $ScriptResult

    LogIt "Done running expect script for lmt_setup on ${this_hostname} `date` "
    debug_pause 1

    return $ScriptResult
}

# ixs008
# ==============================================================================
# Name: start_cop
# ==============================================================================

#function start_cop {

#    typeset host_type=$1
#    typeset host_id=$2
#
#    LogFunctStart $0 "$@"
#    set_oracle_env $host_type $host_id
#    debug_pause 1
#
#    # Do not start cop on windows
#    if [ "$PLATFORM" = "$WINDOWS" ];then
#        LogIt "start_cop cannot be run on Windows"
#        return $FALSE
#    fi
#
#    # Call expect script, with or without logging, to start the cop
#    if (( $# == 3 )); then
#        $AUTO_EXPECT_DIR/ora_start_cop_wlog $AUTO_TEST_CASE_LOG
#    else
#        $AUTO_EXPECT_DIR/ora_start_cop
#    fi
#
#    # Pass or fail test depending on the expect scripts return value
#    if (( $? != 0 )); then
#        LogIt "Failed:: 'splex.start_cop $host_type $host_id'"
#    else
#        LogIt "Passed:: 'splex.start_cop $host_type $host_id'"
#    fi
#
#    LogFunctEnd $0 "$@"
#
#    debug_pause 1
#
#}

# ==============================================================================
# Name: send_unix   ixs006
# ==============================================================================

function send_unix {

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3

    typeset Result 

    LogFunctStart $0 "$@"

    set_oracle_env $HostType $HostId

    debug_pause 1

    # Run old Unix expect scripts for unix platform
    if [ "$PLATFORM" == "$UNIX" ]; then

        if (( $# == 4 )); then
            $AUTO_EXPECT_DIR/unix_wlog "$Cmd" $AUTO_TEST_CASE_LOG
        else
           $AUTO_EXPECT_DIR/unix "$Cmd"
        fi

        Result=$?

    # Run new expect scripts on just windows for now
    # TODO: run this script on Unix also
    else
        typeset Host=$this_hostname
        typeset Uid=$this_spapass
        typeset Pwd=$this_spapass
        typeset Plat=$PLATFORM
       
        if (( $# == 4 )); then
            # run with logging the session             
            Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $Host $Plat $Uid $Pwd "$Cmd" 1)
        else
            # run with out logging the session
            Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $Host $Plat $Uid $Pwd "$Cmd" 0 1)
        fi

        Result=$?
        LogIt "Command output:"
        LogIt "++++++++++++++++++++++++++++"
        LogIt "$Output"
    fi

    # Check if expect script  passed or failed
    if (( $Result != 0 )); then
        LogIt "NOT_SEND:: 'splex.send_unix $HostType $HostId $Cmd'"
    else
        LogIt "Passed:: 'splex.send_unis $HostType $HostId $Cmd'"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1
}

###############################################################################
# Author: Tim Whetsel    Date: Fri Oct 15 13:14:35 PDT 2004
# Description: Runs a remote shell script on Unix machine. Script must be 
#  located in AUTO_REMOTE_SCRIPT_DIR 
###############################################################################
function run_remote_script {

    LogFunctStart $0 "$@"

    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# >= 5 && $# <=6"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst ScriptName HostId Uid Pwd [MaxTimeout]\n" 
      UseMsg="${UseMsg}Note: Script must exist in $AUTO_REMOTE_SCRIPT_DIR\n"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }
 
    # Set arguments to local vars
    typeset HostType=$1
    typeset HostId=$2
    typeset Script=$3
    typeset Uid=$4
    typeset Pwd=$5

    # Check if optional max timeout passed in or default to 90
    [[ $# == 6 ]] && MaxTimeout=$6 || MaxTimeout=90

    set_oracle_env $HostType $HostId

    # Don't run it on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    typeset Host=$this_hostname
    typeset Cmd="$AUTO_REMOTE_SCRIPT_DIR/$Script"

    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $Host $PLATFORM $Uid $Pwd "$Cmd" 0 1 $MaxTimeout)

    Result=$?

    # Check if expect script  passed or failed
    if (( $Result != 0 )); then
        LogIt "Failed:: $Script \n$Output"
    else
        LogIt "Passed:: $Script \n$Output"
    fi

    LogFunctEnd $0 "$@"

}


###############################################################################
# Author: Tim Whetsel    Email: tim.whetsel@quest.com Date: June 30 2004
# Description: Deactivates the currently active config
# Arguments: None
###############################################################################
function action_on_active_config {

    LogFunctStart $0 "$@"

    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 1" 

    # Usage message for function
    typeset UseMsg="usage: $0 deactivate|purge|abort" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Get config name or fail if get_active_cfg_name fails
    ActiveCfgName=$(get_active_cfg_name $HostType $HostId) || {
        LogIt "$ActiveCfgName"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Exit funct if no active config was found
    [[ -z "$ActiveCfgName" ]] && {
        LogIt "Passed:: No active config was found"
        LogFunctEnd $0 "$@"
        return $TRUE
    }

    Cmd="$1 config $ActiveCfgName"

    # CHANGED TO USE execute BECAUSE "abort config name" was returning
    # Invalid argument from sp_ctrl when used this way
    #CmdOutPut=$(_SPCTRL_CmdLocToRemote src 0 "$Cmd") || {
    #    ErrMsg="Failed:: $0 couldn't execute sp_ctrl to $this_hostname"           
    #    SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
    #    print "$ErrMsg\n$CmdOutPut"
    #    LogFunctEnd $0 "$@"
    #    return $FALSE
    #}

    execute src 0 "$Cmd"

    LogIt "Passed:: config '$ActiveCfgName' was deactivated"

    LogFunctEnd $0 "$@"
    debug_pause 1

    return $TRUE

}

###############################################################################
# Author: Tim Whetsel    Email: tim.whetsel@quest.com Date: July 1, 2004
#
# Description: Prints the name of the active config. Returns 0 or 1 when it 
#   passes or fails respectivly.
#   
# Arguments: None
#
# Example: To capture the name of the config into a variable.
#   ActiveCfg=$(get_active_cfg_name src 0)
###############################################################################
function get_active_cfg_name {

    # Execute list config in sp_ctrl
    CmdOutPut=$(_SPCTRL_CmdLocToRemote src 0 "list config") || {
        ErrMsg="Failed:: $0 couldn't execute sp_ctrl to $this_hostname"           
        SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
        print "$ErrMsg\n$CmdOutPut"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Extract the active config name
    print "$CmdOutPut" | grep "Active" | awk '{print $1}'

    return $TRUE

}

function flush_datasource_ot {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Use wait for queue instead
    [[ "$AUTO_USE_WAIT_FOR_QUEUE" != "" ]] && {
        _wait_for_queque src 0
        _wait_for_queque dst 0
        return 0
    }

    # Skip waiting for queueus is flag is set
    [[ "$AUTO_SKIP_QUEUE_WAIT" != "" ]] && {
        LogIt "AUTO_SKIP_QUEUE_WAIT is set. Skipping"
        LogFunctEnd $0 "$@"
        return
    }

    # Optional argument ot override get_string_spctrl's default timeout
    [[ $1 = +([0-9]*) ]] && TimeOut=$1 || TimeOut=900

    # Export to override timeout
    [[ "$AUTO_FLUSH_TIMEOUT" != "" ]] && TimeOut=$AUTO_FLUSH_TIMEOUT


    debug_pause 1

    set_oracle_env src 0

    typeset DataSource="o.$this_sid"
    typeset FlushCmd="flush $DataSource"
        typeset NumOfPost
    typeset StopMsg="Stopped - due to flush"

    check_log_on src 0
    check_log_on dst 0

    LogIt "Flushing datasource:$DataSource...."

    # Execute flush command in sp_ctrl
    CmdOutPut=$(_SPCTRL_CmdLocToRemote src 0 "$FlushCmd") || {
        ErrMsg="Failed:: $0 couldn't execute $FlushCmd on $this_hostname"
        SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
        LogIt "$ErrMsg\n$CmdOutPut"
        LogFunctEnd $0 "$@"
        return $FALSE
    }


      wait_for_process dst 0 "ps -ef | grep $AUTO_DST_OPT_DIR/.app-modules/sp_xpst"

    LogIt "Waiting for poster '$StopMsg' on target...."


#--

#        NumOfPost=$(send_unix dst 0 "ps -ef | grep sp_xpst | grep $AUTO_SPO_PORT | wc -l")
#                while (( $NumOfPost > 0 )); do
#                        sleep 180
#                        NumOfPost=$(send_unix dst 0 "ps -ef | grep sp_?pst | grep $AUTO_SPO_PORT | wc -l")
#                done



#--

    # Wait for Poster to stop
    #CmdOutPut=$(get_string_spctrl dst 0 "status" "$StopMsg" PASS email $TimeOut) || {
    CmdOutPut=$(_wait_4_string dst 0 "status" "$StopMsg" $TimeOut) || {
        ErrMsg="Warning:: $0 timed out waiting for $StopMsg in status cmd on $this_hostname"
        SendEMail "$ErrMsg" "Automation will now monitor using qstatus. sp_ctrl reported:\n$CmdOutPut"
        LogIt "$ErrMsg\n$CmdOutPut"
        _wait_for_queque dst 0
    }

    LogIt "Restarting Poster...."

    # Start post
    _SPCTRL_CmdLocToRemote "dst" 0 "start post"

    # NOTE: might not be needed, or maybe increased
    sleep 2

    LogIt "Checking if Poster restarted...."
    check_process "dst" $HostId "Post" "$StopMsg"

    # See if process started
    [[ $? == $FALSE ]] && {
       # If it didn't then send email and wait for a while
        SendEMail "Poster failed to restart after flush" "See subject"
        LogIt "Failed:: poster failed to start after flush"
    } || {
        LogIt "Passed:: Flush datasource and poster restart successful"
    }

    LogFunctEnd $0 "$@"

}



function flush_datasource {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Use flush_datasource_ot instead
    [[ "$AUTO_FLUSH_DATASOURCE_OT" != "" ]] && {
       flush_datasource_ot
        return 0
    }

    # Use wait for queue instead
    [[ "$AUTO_USE_WAIT_FOR_QUEUE" != "" ]] && {
        _wait_for_queque src 0
        _wait_for_queque dst 0
        return 0
    }

    # Skip waiting for queueus is flag is set
    [[ "$AUTO_SKIP_QUEUE_WAIT" != "" ]] && {
        LogIt "AUTO_SKIP_QUEUE_WAIT is set. Skipping"
        LogFunctEnd $0 "$@"
        return
    }

    # Optional argument ot override get_string_spctrl's default timeout
    [[ $1 = +([0-9]*) ]] && TimeOut=$1 || TimeOut=900

    # Export to override timeout 
    [[ "$AUTO_FLUSH_TIMEOUT" != "" ]] && TimeOut=$AUTO_FLUSH_TIMEOUT


    debug_pause 1

    set_oracle_env src 0

#    typeset DataSource="o.$this_sid"
    [[ "$AUTO_SRC_DBTYPE" == "sqlserver" ]] && {
        typeset DataSource="r.$this_sid"
    } || {
        typeset DataSource="o.$this_sid"
    }
    typeset FlushCmd="flush $DataSource"
    typeset StopMsg="Stopped - due to flush"

    check_log_on src 0
    check_log_on dst 0

    #04/07/2016 added by Candy, check post number, avoid restart post failed issue.
    SpctrlOut=$(_SPCTRL_CmdLocToRemote dst 0 "status")
    PostNum=`print "$SpctrlOut" | grep "Post" | wc -l`

    LogIt "Flushing datasource:$DataSource...."

    # Execute flush command in sp_ctrl
    CmdOutPut=$(_SPCTRL_CmdLocToRemote src 0 "$FlushCmd") || {
        ErrMsg="Failed:: $0 couldn't execute $FlushCmd on $this_hostname"           
        SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
        LogIt "$ErrMsg\n$CmdOutPut"
        LogFunctEnd $0 "$@"
        return $FALSE
    }
    LogIt "Waiting for poster '$StopMsg' on target...." 

#2-29-2016 Candy's change
    # Wait for Poster to stop
    #CmdOutPut=$(get_string_spctrl dst 0 "status" "$StopMsg" PASS email $TimeOut) || {
#    CmdOutPut=$(_wait_4_string dst 0 "status" "$StopMsg" $TimeOut) || {
 #       ErrMsg="Warning:: $0 timed out waiting for $StopMsg in status cmd on $this_hostname"           
  #      SendEMail "$ErrMsg" "Automation will now monitor using qstatus. sp_ctrl reported:\n$CmdOutPut"
   #     LogIt "$ErrMsg\n$CmdOutPut"
    #    _wait_for_queque dst 0
   # }
   CmdOutPut=$(_wait_4_all_post dst 0 "status" "$StopMsg" $TimeOut $PostNum) || {
        ErrMsg="Warning:: $0 timed out waiting for $StopMsg in status cmd on $this_hostname"           
        SendEMail "$ErrMsg" "Automation will now monitor using qstatus. sp_ctrl reported:\n$CmdOutPut"
        LogIt "$ErrMsg\n$CmdOutPut"
        _wait_for_queque dst 0
    }

    LogIt "Restarting Poster...."

    # Start post
    _SPCTRL_CmdLocToRemote "dst" 0 "start post"

    # NOTE: might not be needed, or maybe increased
    sleep 2

    LogIt "Checking if Poster restarted...."
    check_process "dst" $HostId "Post" "$StopMsg"

    # See if process started
    [[ $? == $FALSE ]] && {
       # If it didn't then send email and wait for a while
        SendEMail "Poster failed to restart after flush" "See subject"
        LogIt "Failed:: poster failed to start after flush"
    } || {
        LogIt "Passed:: Flush datasource and poster restart successful"
    } 

    LogFunctEnd $0 "$@"

}


#2-29-2016 Candy's new function wait_4_all_post
# ==============================================================================
# Name: _wait_4_all_post
# Waits for the status of all post is stop due to flush.
# ==============================================================================
function _wait_4_all_post {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3
    typeset StopMsg=$4
    typeset PostSum=$6
    
    typeset counter=1
    typeset countermax
    typeset sleeptime=3


    # Set the max counter
    # TODO: just use the last element of argument array
    if [[ $5 = +([0-9]*) ]];then
        countermax=$5
    else
        countermax=600
    fi

    debug_pause 1

    set_oracle_env $HostType $HostId

    typeset Host=$this_hostname
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset Port=$AUTO_SPO_PORT
  
    typeset PostTmpList=$AUTO_WORK_DIR/post_tmp_list
    typeset SpctrlOut
    typeset Result=$FALSE
    typeset Flag=$TRUE
    typeset output
    typeset PostNo

    remove_if_exist $PostTmpList

    while (( $Result != $TRUE && $counter <= $countermax )); do
        Flag=$TRUE
        SpctrlOut=$(_SPCTRL_CmdLocToRemote dst 0 "status")
	PostNo=`print "$SpctrlOut" | grep "Post" | wc -l`

	if [ $PostNo -ne $PostSum ];then
		Flag=$FALSE;
                counter=`expr $counter + 1`
		continue;
	fi

        print "$SpctrlOut" | grep "Post" > $PostTmpList
	while read PostTmp; do
		output=`print "$PostTmp" | grep "$StopMsg"`
		if [ -z "$output" ]; then
	        	Flag=$FALSE;
			break;
		fi
	done < $PostTmpList
		
	Result=$Flag
	counter=`expr $counter + 1`
	sleep $sleeptime
    done

    return $Result
}



###############################################################################
# Author: Tim Whetsel    Email: tim.whetsel@quest.com Date: March 12, 2004
#
# Description: This function will wait for queues to empty. It also does 
#   a number of other checks, like check event_log and check for process
#   errors. If the message count of a queue says the same over a specified
#   number of seconds, then the function will perform checks, email user, and
#   wait for user interaction.
###############################################################################
function _wait_for_queque {


    typeset StartTime=`date +"%s"`

    HostType=$1
    HostId=$2

    ###########################################################################
    #                              FUNCTIONS 
    ###########################################################################

    # Function used to get the number of messages in a queue
    function _GetQueuesCount {

        typeset QueName=$1   # Name of queue 
        typeset Cmd          # sp_ctrl command to get queues
        typeset CmdOutPut    # output of command
        typeset ErrMsg       # Error message emailed and printed to term if sp_ctrl fails

        # Execute qstatus command in sp_ctrl
        CmdOutPut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "qstatus") || {
            
            ErrMsg="Failed:: wait_for_queue couldn't execute sp_ctrl to $this_hostname"           
            SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
            print "$ErrMsg\n$CmdOutPut"
            return $FALSE
        }

        # Extract queue count
        print "$CmdOutPut" | grep "$QueName" | cut -d: -f2 | awk '{print $1}'
 
        return $TRUE

    }

    function _IsMsgCntSame {

        # Set arguments to local vars
        typeset QueName=$1
        typeset CurMsgs=$2
        typeset PrevMsgs=$3

        # Only continue with this if it's number of messages queque
        # Uncomment this if you want to disable count check for backlog
        # That is what it used to do. Backlog will check forever.
        #[[ "$QueName" == "$NUM_MSG_STR" ]] || return $FALSE

        # Masage count is the same, return true
        [[ "$CurMsgs" == "$PrevMsgs"  ]] && return $TRUE 

        return $FALSE
    
    }

    function _IsTimeout {

        # Set arguments to local vars
        typeset QueName=$1
        typeset TimeSoFar=$2
    
        # Only continue with this if it's number of messages queque
        # Uncomment this if you want to disable timeout for backlog
        # That is what it used to do. Backlog will check forever.
        #[[ "$QueName" == "$NUM_MSG_STR" ]] || return $FALSE

        # Has the time limit been reached
        (( $TimeSoFar == $NO_DECREASE_TIME )) && return $TRUE

        return $FALSE

    }

    # This isn't complete. Anne told me that we don't need to do this anymore.
    # I left what I had done so far just incase we need it some day.
    # Will need some work though if it needs implemented
    function _SetParams {

        SET_PARAMS_FLAG=$TRUE

        typeset SleepTime=30 # Time to sleep between setting each param

        print "Number of messages is taking too long to empty."
        print "Parameters will be set on the destination."

        # Subject and body for email
        Subject="Warning:wait_for_queue is taking to long. Parameters will be set."
        Body="There is still $queue_n messages in 'Number of Messages' queue"
        Body="${Body}\nset param SP_OPO_READRELEASE_INTERVAL 1 on ${d_sid0}@${d_host0}"
        Body="${Body}\nset param SP_OPO_IDLE_LOGOUT 60 on ${d_sid0}@${d_host0}"
        Body="${Body}\nset param SP_OPO_READRELEASE_INTERVAL 100 on ${d_sid0}@${d_host0}"
        Body="${Body}\n\nIf you are using multi-threaded poster then the following will be set:"
        Body="${Body}\nset param SP_OPO_IDLE_LOGOUT 600000 on ${d_sid0}@${d_host0}"

        SendEMail "$Subject" "$Body"

        # Set parameters
        execute dst 0 "set param SP_OPO_READRELEASE_INTERVAL 1" log
        echo_sleep $SleepTime
        execute dst 0 "set param SP_OPO_IDLE_LOGOUT 60" log
        echo_sleep $SleepTime
        execute dst 0 "set param SP_OPO_READRELEASE_INTERVAL 100" log
        echo_sleep $SleepTime

        CmdOutPut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "status") || {

           ErrMsg="Failed:: wait_for_queue couldn't execute sp_ctrl to $this_hostname"
           SendEMail "$ErrMsg" "sp_ctrl reported:\n$CmdOutPut"
           print "$ErrMsg\n$CmdOutPut"
           return $FALSE
        }

        print "$opt" | grep "^MTPost"

        # If it is multi-threaded poster then set these parameters
        if [ $? -eq 0 ];then
           execute dst 0 "set param SP_OPO_IDLE_LOGOUT 600000" log
        fi

        Body="wait_for_queue function is exiting and the queues may not be empty"
        Body="${Body}\n$queue_n messages still in 'Number of messages' queue"
        Body="${Body}\nYou may want to check Shareplex for errors"

        LogIt "$Body"

        SendEMail "Warning:Queues may not be empty" "$Body"

    }

    function _WaitMsgBelowMax {

        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

        typeset QueName=$1
        typeset MaxAllowedMsgs=$2

        typeset KeepChecking=$TRUE
        typeset NumMsgs        # Number of messages in the queue
        typeset CntSameTime=0  # Total time wait for queue to empty
        set -A  PrevMsgsArray  # # msgs in previous iteration of loop 4 all
        typeset TmpCount       # Temp var to hold queues count

        # START WAIT TO EMPTY LOOP
        while [[ "$KeepChecking" == "$TRUE" ]]; do

            # Attempt to get the number of messages for the given queue
            TmpCount=$(_GetQueuesCount "$QueName") || {
                LogIt "ERROR: Couldn't get queue message count."
                LogFunctEnd $0 "$@"
                return $FALSE       
            }
    
            # Break checking the queue loop if there is not a queue.
            [[ -z "$TmpCount" ]] && {
                LogIt "WARN:No $QueName messages queue to check on ${this_hostname}."
                return $TRUE
            }

            # Split up the counts into an array
            set -A CurMsgsArray $TmpCount

            # Check each queue in queue type
            typeset i=0
            while (( $i < ${#CurMsgsArray[*]} )); do

                typeset CurrentMsg=${CurMsgsArray[$i]}

                # See if messages is below their max allowed
                if (( $CurrentMsg <= $MaxAllowedMsgs )); then

                    # Set flag to stop checking, but will still check next
                    KeepChecking=$FALSE

                    PrevMsgsArray[$i]=$CurrentMsg # Save msg count
                    ((i=$i+1))  # next message 
                    
                else

                    KeepChecking=$TRUE

                    # Is the message count the same as previous iteration?
                    if _IsMsgCntSame "$QueName" "$CurrentMsg" "${PrevMsgsArray[$i]}"; then

                        ((CntSameTime=$CntSameTime+$SLEEP_TIME))

                        # Has the timeout for count being the same been reached.
                        # If so send email, display msg, and prompt for user
                        if  _IsTimeout "$QueName" "$CntSameTime" ; then


                            typeset MsgSub="Possible Error: Queues are stuck"
                            typeset Msg="Message count in '$QueName' queue has"
                              Msg="${Msg} been at $CurrentMsg for "
                              Msg="${Msg} $CntSameTime seconds.\r\n Automation"
                              Msg="${Msg} will continue anyway."

                            LogIt "$Msg"

                            SendEMail "$MsgSub" "$Msg"
                            print "###########################################"
                            print "WARNING: Queues may be stuck at `date`"
                            print "###########################################"

                            check_log_on src 0
                            check_log_on dst 0

                            # Prompt user to ctrl-c or hit key to continue
                            #PromptUser

                            # Exit out of function if user hits a key
                            return $FALSE 

                        fi

                    # Count is not the same so reset "count same timer"
                    else

                        CntSameTime=0

                    fi # END - if _IsMsgCntSame 


                    PrevMsgsArray[$i]=$CurrentMsg # Save msg count
                    break

                fi # END - if $CurrentMsg <= $MaxAllowedMsgs


            done   # END - while $i < ${#CurMsgsArray[*]}
            
            print "\n++++++++++++++++++++++++++++++++++++"
            print "# of messages in '$QueName' queues:"
            print "${CurMsgsArray[*]}"
            print "++++++++++++++++++++++++++++++++++++\n"

            # Break now if done, no need to sleep 
            [[ "$KeepChecking" == "$FALSE" ]] && break

            print "waiting $SLEEP_TIME seconds to check again"
            sleep $SLEEP_TIME


        done
        # END WAIT TO EMPTY LOOP

        return $TRUE
    }
 
    function _ProcessQueue {

        typeset QueName=$1
        typeset MaxNumMsg=$2
        typeset TimesToCheck=$3
        typeset SLEEP_TIME=5            # Time to sleep #Ilya 03/31/15 to avoid "/qa/splex/v8.6/19991/main.ksh[16]: flush_datasource[4435]: _wait_for_queque[4844]: _ProcessQueue[4779]: sleep: one operand expected

        # START TIMES TO CHECK LOOP
        i=1 
        while (( $i <= $TimesToCheck )); do
            print "#############################################################################"
            print "Waiting for '$QueName' messages to be <= $MaxNumMsg: Check $i of $TimesToCheck"
            print "#############################################################################"
            _WaitMsgBelowMax "$QueName" $MaxNumMsg || break
            ((i=$i+1))
            print "\nWaiting $SLEEP_TIME seconds\n"
            sleep $SLEEP_TIME
        done
    
        print "#############################################################################"
        print "Done checking '$QueName' queue(s)"
        print "#############################################################################"
        # END TIMES TO CHECK LOOP

    }

    ###########################################################################
    #                                  MAIN
    ###########################################################################
    LogFunctStart $0 "$@"

    # Skip waiting for queueus is flag is set
    [[ "$AUTO_SKIP_QUEUE_WAIT" != "" ]] && {
        LogIt "AUTO_SKIP_QUEUE_WAIT is set. Skipping"
        LogFunctEnd $0 "$@"
        return
    }
        
    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 2" 

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments passed in to local variables
    typeset HostType=$1
    typeset HostId=$2

    check_log_on src 0
    check_log_on dst 0

    # CONSTANTS
    typeset SET_PARAMS_FLAG=$FALSE  # True if params got set
    typeset TIMES_TO_CHECK=4        # # of times to check the queues
    typeset BACK_LOG_STR="Backlog"  # Search string for Backlog queue
    typeset BACK_LOG_MAX=0          # Max # of msgs allowed in backlog queue
    typeset NUM_MSG_STR="Number of" # Search string for # of Messages queue
    typeset NUM_MSG_MAX=3           # Max # of msgs allowed in backlog queue 
    typeset SLEEP_TIME=5            # Time to sleep
    #typeset NO_DECREASE_TIME=15    # Seconds queue can have same # of msgs
    typeset NO_DECREASE_TIME=1800   # Seconds queue can have same # of msgs
    
    set_oracle_env $HostType $HostId

    _ProcessQueue "$BACK_LOG_STR" $BACK_LOG_MAX $TIMES_TO_CHECK
    _ProcessQueue "$NUM_MSG_STR" $NUM_MSG_MAX $TIMES_TO_CHECK

    LogFunctEnd $0 "$@"

    typeset EndTime=`date +"%s"`
    ((Seconds=$EndTime-$StartTime))
    LogIt "####################"
    LogIt " Function time: $Seconds"
    LogIt "####################"

    return $TRUE
}

# ==============================================================================
# Name: truncate_event_log
# ==============================================================================

function truncate_event_log {

    typeset host_type=$1
    typeset host_id=$2

    set_oracle_env $host_type $host_id 0

    typeset Host=$this_hostname
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset Port=$AUTO_SPO_PORT

    typeset Cmd="truncate log"

    SpctrlOut=$(_SPCTRL_CmdLocToRemote $host_type $host_id "$Cmd") && {
        print "Truncating event log successful"
    } || { 
        LogIt "Unable to truncate event log on $Host"
        LogIt "$SpctrlOut"
    }

}

# ==============================================================================
# Name: check_misc
# ==============================================================================

function check_misc {

    LogFunctStart $0 "$@"

    # Set arguments to local variables 
    typeset host_type=$1
    typeset host_id=$2

    # Other local variables
    typeset output
    typeset output2
    typeset misc_file
		
    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

		misc_file=$AUTO_WORK_DIR/${AUTO_TESTER}_${this_hostname}_${this_sid}_${AUTO_CURRENT_CONFIG}.misc
		remove_if_exist $misc_file

        debug_pause 1

		################# Checking that otest is mounted and available #############
		output=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "ls $AUTO_NIX_OTEST_DIR"`
		if [ -z "$output" ]
		then
			LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            LogIt "File system [ $AUTO_NIX_OTEST_DIR ] is not mounted, please mount"
            LogIt "it or else you will not be able to run otest"
			LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

            read enter	
		else
			LogIt "Found File system [ $AUTO_NIX_OTEST_DIR ]"
		fi
		################# Done checking that otest is mounted and available #############

		################# Checking rexec working  #############
		/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "uname -a"
		if [ $? -eq 1 ]; then 
            LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            LogIt "REXEC failed, please check that you can use rexec"
            LogIt "before you continue"
            LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
            read enter
        fi

		################# Done checking rcp rexec working  #############

    LogFunctStart $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: check_marker_file
# ==============================================================================
function check_marker_file
{

    host_type=$1
    host_id=$2

    typeset OutPut

    set_oracle_env $host_type $host_id

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    ############### Checking Marker file  #############
    OutPut=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "cat /var/adm/.splex/Shareplex.mark | grep $this_vardir"`
    if [ -z "$OutPut" ]
    then
        LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "From Shareplex.mark: $OutPut"
        LogIt "Could not find your VARDIR ( $this_vardir ) in the Shareplex.mark file"
        LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "PRESS enter to continue:"

	    read enter
    else
        LogIt "From Shareplex.mark: $OutPut"
        LogIt "VARDIR [ $this_vardir ] found in the Shareplex.mark file"
    fi
    ################# Done checking Marker file  #############

}


# ==============================================================================
# Name: check_fs
# ==============================================================================

function check_fs {       

    typeset host_type=$1
    typeset host_id=$2
    typeset file_sys=$3
    typeset high_mark=$4

    typeset number
    typeset plat

    LogFunctStart $0 "$@"
    set_oracle_env $host_type $host_id  #pxh031
    debug_pause 1

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    LogIt "Performing File system check..............."
    LogIt "High mark is $high_mark %"

    plat=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "uname -s"`

    case $plat in
        SunOS)
            number=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "df -k ${file_sys}" | awk '{print $5}' | grep "\%" | cut -d% -f1`
        ;;

        HP-UX)
            number=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "df -k ${file_sys}" | grep "\%" | tr -d '\n' | tr -d ' ' | cut -d% -f1`
        ;;

        AIX)
            number=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "df -k ${file_sys}" | awk '{print $4}' | grep -v Used | cut -d% -f1`
        ;;

        Linux)
            number=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "df -k ${file_sys}" | awk '{print $5}' | grep -v Use | cut -d% -f1`
        ;;

        OSF1)
            number=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "df -k ${file_sys}" | awk '{print $5}' | grep "\%" | cut -d% -f1`
            #number=`expr 100 - $number`
        ;;

        *)
            LogIt "Unsupported Platform, can not check File system "
            return 0
        ;;

    esac

    LogIt "File System is $number % full"

    if [ $number -ge $high_mark ]; then

        low_mark=`expr 100 - $number`

        SendEMail "The File system [ $file_sys ] on $this_hostname is less than $low_mark % available" \
                  "${number}% Used in $file_sys on $this_hostname"

        LogIt "*****************************************************"
        LogIt "$file_sys File system needs to be cleaned!           "
        LogIt "Please clean your the file system before you continue"
        LogIt "or you will run into problems with your testing      "
        LogIt "*****************************************************"

        read enter
        #exit 1

    else
        print "OK........"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: check_users
# ==============================================================================
function check_users {

    typeset host_type=$1
    typeset host_id=$2
    typeset user1=$3

    typeset output
    typeset group

    LogFunctStart $0 "$@"
    debug_pause 1

    set_oracle_env $host_type $host_id  #pxh031

    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    output=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "cat /etc/passwd | grep $user1"`

    if [ -z "$output" ]; then

        SendEMail "$user1 Problem on $this_hostname" \
                  "$user1 user does not exist on $this_hostname"

        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "$user1 user does not exist on $this_hostname"
        LogIt "Please fix your user before you continue    "
        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        read enter
        #exit 1
    fi

    LogIt "$user1 user exists on $this_hostname"

    group=`/usr/bin/rexec -a -l $spadmin -p $spapass $this_hostname "cat /etc/group | grep spadmin | grep $user1"`

    if [ -z "$group" ]; then

        SendEMail "$user1 Problem on $this_hostname" \
                  "$user1 is not part of spadmin group on $this_hostname"

        LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "$user1 is not apart of spadmin group on $this_hostname"
        LogIt "Please fix your user before you continue              "
        LogIt "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
	
        read enter
        #exit 1
    fi

    LogIt "$user1 is apart of spadmin group on $this_hostname"

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: check_sp_users
# ==============================================================================

function check_sp_users {

    typeset host_type=$1
    typeset host_id=$2
    typeset sqluser=$3

    typeset File
    typeset output_file
    typeset result
    typeset result2
    typeset sp_num

    LogFunctStart $0 "$@"
    debug_pause 1
    set_oracle_env $host_type $host_id


    File=${AUTO_SP_USERS_FILE:-$AUTO_ROOT_DIR/sp_users_var${this_ora_s_ver}}
    print "Using $File"

    typeset BaseName="$AUTO_WORK_DIR/$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID.$this_hostname"    
    output_file="$BaseName.sp_users"

    remove_if_exist $output_file

    . $AUTO_ROOT_DIR/local_sqlplus
    check_oracle $this_tns

#sqlplus ${sqluser}/${sqluser}@${this_tns} <<HERE | tee -a $output_file | grep "ORA-" >/dev/null
sqlplus ${sqluser}/${sqluser}@${this_tns} <<HERE
spool $output_file
set pages 0 echo off verify off feed off term off define off escape off scan off
select lower(username) from all_users where username like 'SP%' and instr(username, '_') = 3;
exit 0
HERE

    cat $File | while read line; do

        result=`grep -iw $line $output_file`

        if [ -z "$result" ]; then
            print "Could not find user - $line on $this_tns" >> $output_file
            LogIt "Could not find user - $line on $this_tns"
            LogIt "Please fix you environment and then continue\n"
        else
            LogIt "Found user - $line"
        fi

    done

    result2=`grep Could $output_file`

    grep Could $output_file

    if [ $? -eq  0 ]; then

        SendEMail "Some SP_* users missing from $this_tns" "$result2"

        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
        LogIt "Some SP_* missing from $this_tns !"
        LogIt "Please add those users before you continue,"
        LogIt "or else some of your tests will fail"
        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

        read enter
    fi 

    #rm $output_file
    LogFunctEnd $0 "$@"
    debug_pause 1

}

# ==============================================================================
# Name: check_sp_tablespaces
# ==============================================================================

        function check_sp_tablespaces
        {
                typeset host_type
                typeset host_id
                typeset sqluser
                typeset sp_users_file
                typeset output_file
                typeset not_found_file
                typeset high_mark_file
                typeset sp_user
                typeset sp_tablespace
                typeset high_mark
                typeset result
                typeset perc_used

                host_type=$1
                host_id=$2
                sqluser=$3
                high_mark=$4

                LogFunctStart $0 "$@"
                debug_pause 1
                set_oracle_env $host_type $host_id


                File=${AUTO_SP_TBL_SPACE_FILE:-$AUTO_ROOT_DIR/sp_tablespaces_var${this_ora_s_ver}}
                echo "\nUsing $File"

    typeset BaseName="$AUTO_WORK_DIR/$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID.$this_hostname"    
    output_file="$BaseName.sp_tblspc"
    not_found_file="$BaseName.sp_tblspc_not"
    high_mark_file="$BaseName.sp_tblspc_high"

                remove_if_exist $output_file
                remove_if_exist $not_found_file
                remove_if_exist $high_mark_file


                . $AUTO_ROOT_DIR/local_sqlplus
                check_oracle $this_tns

sqlplus ${sqluser}/${sqluser}@${this_tns} <<HERE
spool $output_file
set pages 0 echo off verify off feed off term off define off escape off scan off
select a.TABLESPACE_NAME,
 a.BYTES bytes_used,
 b.BYTES bytes_free,
 b.largest,
 round((a.BYTES/(a.BYTES+b.BYTES))*100,0) percent_used
from 
 (
  select  TABLESPACE_NAME,
   sum(BYTES) BYTES
  from  dba_data_files
  where TABLESPACE_NAME like 'SPLEX_%'
  group  by TABLESPACE_NAME
 )
 a,
 (
  select  TABLESPACE_NAME,
   sum(BYTES) BYTES ,
   max(BYTES) largest
  from  dba_free_space
  group  by TABLESPACE_NAME
 )
 b
where  a.TABLESPACE_NAME=b.TABLESPACE_NAME (+)
order  by a.TABLESPACE_NAME;
exit 0
HERE
                cat $File | while read sp_tablespace
                do
                        result=`cat $output_file | grep $sp_tablespace`
                        if [ -z "$result" ]
                        then
                                echo "Could not find TABLESPACE - $sp_tablespace " >> $not_found_file
                                LogIt "Could not find TABLESPACE - $sp_tablespace "
                                #echo "Please fix you environment and then continue\n"
                                #read enter
                        else
                                perc_used=`echo $result | grep ^SPLEX_ | awk -F" " '{print $5}'`
                                if [ $perc_used -ge $high_mark ]
                                then
					echo "TABLESPACE - $sp_tablespace is $perc_used % used, which is above the High Mark $high_mark" >> $high_mark_file
                    LogIt "TABLESPACE - $sp_tablespace is $perc_used % used, which is above the High Mark $high_mark"
                                else
                                        LogIt "TABLESPACE - ${sp_tablespace}, % Used - $perc_used "
                                fi
                        fi
                done

                if [ -s $not_found_file ]
                then

                    SendEMail "TABLESPACES missing from $this_tns" \
                              "in subject" $not_found_file

                        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        LogIt "Some TABLESPACES are missing from $this_tns !"
                        LogIt "Please add those tablespaces before you continue,"
                        LogIt "or else some of your tests will fail"
                        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        read enter
                fi

                if [ -s $high_mark_file ]
                then

                    SendEMail "Some TABLESPACES are FULL in $this_tns" \
                              "in subject" $high_mark_file


                        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        LogIt "Some TABLESPACES are FULL on $this_tns !!!"
                        LogIt "Please free some used space by truncating your tables,"
                        LogIt "in those tablespaces before you continue,"
                        LogIt "or else some of your tests will fail"
                        LogIt "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
                        read enter
                fi

                #rm $output_file
                #rm $not_found_file
                LogFunctEnd $0 "$@"
                debug_pause 1
        }

# ==============================================================================
# Name: check_sp_tables
# ==============================================================================

        function check_sp_tables
        {

                typeset host_type
                typeset host_id
                typeset sqluser
                typeset sp_users_file
                typeset output_file
                typeset not_found_file
                typeset sp_user
                typeset sp_table
                typeset sp_num
                typeset result
                host_type=$1
                host_id=$2
                sqluser=$3

                LogFunctStart $0 "$@"
                debug_pause 1
                set_oracle_env $host_type $host_id

                File=${AUTO_SP_TABLES_FILE:-$AUTO_ROOT_DIR/sp_tables_var${this_ora_s_ver}}
                echo "\nUsing $File"

    typeset BaseName="$AUTO_WORK_DIR/$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID.$this_hostname"    
    output_file="$BaseName.sp_tables"
    not_found_file="$BaseName.sp_tables_not_found"

		remove_if_exist $output_file
		remove_if_exist $not_found_file


                . $AUTO_ROOT_DIR/local_sqlplus
                check_oracle $this_tns

echo "tnsname=$this_tns"
sqlplus ${sqluser}/${sqluser}@${this_tns} <<HERE
whenever sqlerror exit 1
spool $output_file
set pages 0 echo off verify off feed off term off define off escape off scan off
select owner,TABLE_NAME from dba_tables where owner like 'SP_%';
exit 0
HERE
		if [ $? -ne 0 ]
        	then
                	LogIt "Could not login to $this_tns to perform check_sp_tables"
                	LogIt "Please check that you can login from the automation server like this:"
                	LogIt "#sqlplus ${sqluser}/${sqluser}@${this_tns}"
                	read enter
        	else

                	cat $File | while read line
                	do
                        	sp_user=`echo $line | cut -d. -f1`
                        	sp_table=`echo $line | cut -d. -f2`
                        	result=`cat $output_file | grep $sp_user | grep $sp_table`
                        	if [ -z "$result" ]
                        	then
                                	echo "Could not find table - $sp_table for user $sp_user" >> $not_found_file
                                	LogIt "Could not find table - $sp_table for user $sp_user"
                        	else
                                	LogIt "Found ${sp_user}.${sp_table}"
                        	fi
                	done

                	if [ -s $not_found_file ]
                	then
                            SendEMail "Some TABLES missing from $this_tns" \
                                      "in subject" $not_found_file


                            LogIt "+++++++++++++++++++++++++++++++++++++++++++++++"
                        	LogIt "Some TABLES missing from $this_tns !"
                        	LogIt "Please add those tables before you continue,"
                        	LogIt "or else some of your tests will fail"
                            LogIt "+++++++++++++++++++++++++++++++++++++++++++++++"
                        	read enter
                	fi
		fi

                LogFunctEnd $0 "$@"
                debug_pause 1
        }

# ==============================================================================
# Name: enter_func
# ==============================================================================
	function enter_func
	{
		typeset message
		message=$1
		echo "\n $message \n"
		read enter
	}

# ==============================================================================
# Name: check_log_on
# ==============================================================================

function check_log_on {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# >= 2 && $# <=3"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst 0 [expected string to be in event_log]\n" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }
 

    # Set local variables equal to arguments passed in
    typeset HostType=$1
    typeset HostId=$2
    typeset StrExpected=${3:-''}

    set_oracle_env $HostType $HostId 

    # Set vars according to host type
    [[ "$HostType" == "src" ]] && {
        typeset TmpLog="$AUTO_SRC_E_LOG_RECENT"
        typeset ELogHist="$AUTO_SRC_E_LOG_HIST"
        typeset ErrLog="$AUTO_SRC_E_LOG_ERRORS"
    } || {
        typeset TmpLog="$AUTO_DST_E_LOG_RECENT"
        typeset ELogHist="$AUTO_DST_E_LOG_HIST"
        typeset ErrLog="$AUTO_DST_E_LOG_ERRORS"
    }

    # Set some local vars equal to exports set in set_oracle_env
    # this is for making vars smaller
    typeset Host=$this_hostname
    typeset VarD=$this_vardir
    typeset Sid=$this_sid
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass

    # Other local variables
    typeset WrkDir="$AUTO_WORK_DIR"
    typeset cleanup=0
    typeset ErrFlag=$FALSE
    typeset Log=$AUTO_TEST_CASE_LOG
    typeset ErrList # Location and name of error list file

    # Remove files if they exist
    remove_if_exist $TmpLog
    remove_if_exist $ErrLog

    cleanup_on_process_error $HostType 0

    get_event_log $HostType
     _WriteEventLogHistory $HostType

    # See if we got the event_log or if it's empty. If so then return
    if [[ ! -f $TmpLog ||  ! -s $TmpLog ]]; then
        
        [[ -n "$StrExpected" ]] && {
            ErrFlag=$TRUE
            LogIt "Failed:: event_log is empty. Expected string, '$StrExpected' not found"
            LogFunctEnd $0 "$@"
            SendEMail "Failed:'$StrExpected' not in event_log" "event_log  is empty. expected $StrExepected"
            return $FALSE
        }    

        LogIt "############################################"
        LogIt "Event_log File does not exist or it is empty"
        LogIt "Exiting from Check_log_on function...       "
        LogIt "############################################"
        LogFunctEnd $0 "$@"
        return $TRUE
    fi

    # See if error list exists in testcase dir. If not use default.
    # This might not be used cause I remove any files older than 60 days
    # from the test case directory. No has complained yet.
    [ -f $AUTO_CURRENT_TEST/error_list ] && \
        export ErrList=$AUTO_CURRENT_TEST/error_list || \
        export ErrList=$AUTO_ROOT_DIR/error_list

    LogIt "Error List File = $ErrList"

    # Check the temp event_log for all errors listed in the error_list file
    while read error; do

        # Look for the current error in the temp event_log and save any
        # the errors to a file that lists just the errors found 
        [[ -n "$StrExpected" ]] && {
            # Filter out the expected strings too, we will deal with them after this
            egrep -i "$error" $TmpLog | grep -vP "$StrExpected|Notice"  >> $ErrLog
            GrepResult=$?
        } || {

            # Added to ignore kill events in event_log because some tests kill processes
            [[ -n "$AUTO_IGNORE_EVENT_KILL" ]] && {
                egrep -i "$error" $TmpLog | grep -vP "LockTableWait1|SIGKILL|Notice"  >> $ErrLog
                GrepResult=$?
            } || {
                egrep -i "$error" $TmpLog | grep -v "Notice" >> $ErrLog
                GrepResult=$?
            }

        }

        [[ "$GrepResult" == "$TRUE" ]] &&  ErrFlag=$TRUE

    done < $ErrList

    # Check for expected string and set fail flag if not found
    grep "$StrExpected" $TmpLog
    [[ $? == $FALSE ]] && ErrFlag=$TRUE

    # Check for deadlock
    grep "ORA-00060: deadlock detected" $TmpLog && {

        AUTO_DEADLOCK_FLAG=$TRUE

        # Send a warning email
        typeset DLMsg="Some processes may have stopped. If so, initrans will be set"
            DLMsg="${DLMsg} to 20 for all tables in your config"

        SendEMail "WARNING: Deadlock Detected" "$DLMsg"
    }

    # Send email about errors if error flag is set
    if [[ $ErrFlag == $TRUE ]]; then

        # Build email subject
        typeset EmailSub="Error: event_log on ${Sid}@${Host}"
            EmailSub="${EmailSub} has errors using cfg $AUTO_CURRENT_CONFIG"

        # Build email body
        typeset EmailBod="Below are the errors found in the event_log"
            EmailBod="${EmailBod} on $this_hostname\n"
            EmailBod="${EmailBod}Local error file: $ErrLog\n"
            EmailBod="${EmailBod}Local event_log: $TmpLog\n"
            EmailBod="${EmailBod}Local event_log history: $ELogHist\n\n"

        # Print event_log error file to term and test case log
        LogIt "+++ Start ${Host} event_log errors +++"
        LogIt "Filename:$ErrLog"
        LogIt "`cat $ErrLog`"
        LogIt "+++ End ${Host} event_log errors +++" 

        # Print the whole event_log to term and test case log
        LogIt "+++ Start ${Host} event_log +++"
        LogIt "Filename:$TmpLog"
        LogIt "`cat $TmpLog`"
        LogIt "++++++ End ${Host} event_log ++++++"
			
        # Send email and fail
        SendEMail "$EmailSub" "$EmailBod" $ErrLog
        LogIt "Failed:: Errors found in the event_log"

        # See if clean up or continue testing should be done
        case $AUTO_ERR_OPT in
            C|c)
                LogIt "#########################"
                LogIt "Running cleanup procedure"
                LogIt "#########################"
                cleanup_error src 0
                cleanup_error dst 0
            ;;

            Y|y) print " Test will continue........." ;;
            N|n) exit 127 # exit the test suite
        esac

    # NO ERRORS FOUND
    else
        LogIt "Passed:: No errors found in the event_log"

    fi # END IF ERRORS FOUND

    # Clean up temp files
    remove_if_exist $TmpLog
    remove_if_exist $ErrLog

    # Dump existing event_log on remote host to a history file
    #typeset Cmd="cat $VarD/log/event_log >> $VarD/log/event_log.history"
    #Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $Host $PLATFORM $Uid $Pwd "$Cmd" 1)

    get_trace_log $HostType

    truncate_event_log $HostType $HostId

    LogFunctEnd $0 "$@"

    debug_pause 1

}

# ==============================================================================
# Name: check_processlog_on
# ==============================================================================

function check_processlog_on {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"
    debug_pause 1
	
    typeset HostType=$1
    typeset HostId=$2
    typeset processType=$3
	
    set_oracle_env $HostType $HostId
	
    typeset ProcessErrList=$AUTO_ROOT_DIR/process_err_list
    typeset processError
    typeset tmp_error
    typeset processErrLog=$AUTO_WORK_DIR/$processType.error.log
    typeset PRemoteFile=$this_vardir/log/tmp_error_list.log
    typeset processTmplog=$this_vardir/log/$processType.tmp.log

    remove_if_exist $processErrLog
 
    #create a empty process log file, if there is no process log file under varlog, grep clause will not raise error.
    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "touch $processTmplog" 1
    
    while read processError; do
	tmp_error=`print "$processError" | grep $processType | awk -F "\"" '{print $2}'`
	[[ -n $tmp_error ]] && {
	    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "grep -nE \"$tmp_error\" $this_vardir/log/*$processType* >> $PRemoteFile" 1
	}
    done < $ProcessErrList
	
    get_remote_file "$HostType" "$PRemoteFile" "$processErrLog" "ascii"
	
    [[ -f $processErrLog && -s $processErrLog ]] && {
       # Print process error file to term and test case log
        LogIt "+++ Start ${Host} ${processType} errors log +++"
        LogIt "Filename:$processErrLog"
        LogIt "`cat $processErrLog`"
        LogIt "+++ End ${Host} ${processType} errors log +++"
		
	typeset EmailSub="Error: ${processType} errors log on ${Sid}@${Host}"
            EmailSub="${EmailSub} has errors using cfg $AUTO_CURRENT_CONFIG"

        # Build email body
        typeset EmailBod="Below are the errors found in ${processType} errors log"
            EmailBod="${EmailBod} on $this_hostname\n"
            EmailBod="${EmailBod}${processType} error log: $processErrLog\n\n"
		
		# Send email and fail
        SendEMail "$EmailSub" "$EmailBod" $processErrLog
        LogIt "Failed:: Errors found in ${processType} errors log"
	    
	case $AUTO_ERR_OPT in
            C|c)
                LogIt "#########################"
                LogIt "Running cleanup procedure"
                LogIt "#########################"
                cleanup_error src 0
                cleanup_error dst 0
            ;;

            Y|y) print " Test will continue........." ;;
            N|n) exit 127 # exit the test suite
        esac
    } || {
	LogIt "Passed:: No errors found in the $processType log"
    }
	
    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "rm $processTmplog" 1
    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "rm $PRemoteFile" 1
	
    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: check_process
# ==============================================================================

function check_process {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset host_type=$1
    typeset host_id=$2
    typeset process=$3
    typeset lookup=$4

    typeset output
    typeset RetVal=$TRUE

    set_oracle_env $host_type $host_id
    debug_pause 1

    # Get the status of shareplex using local sp_ctrl
    CmdOutPut=$(_SPCTRL_CmdLocToRemote $host_type $host_id "status") || {
        LogIt "Failed:: sp_ctrl failed executing status"
        LogIt "sp_ctrl returned:\n$CmdOutPut"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Get the lookup in sp_ctrl output
    #output=`print "$CmdOutPut" | grep "^$process.*$lookup" | awk '{print $1}'`
    # Removed the beginning of line character pattern to make this function
    # work with MTPost and Post.
    output=`print "$CmdOutPut" | grep "$process.*$lookup" | awk '{print $1}'`

    LogIt "$output"

    if [ -n "$output" ]; then
        LogIt "Process ${process} is still ${lookup}"
        RetVal=$FALSE
    else
        LogIt "Process ${process} is running"
        RetVal=$TRUE
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

    return $RetVal
}

# ==============================================================================
# Name: cleanup_on_process_error
# ==============================================================================

function cleanup_on_process_error {       

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    # Set arguments passed in to local variables
    typeset host_type=$1
    typeset host_id=$2

    # other local variables
    typeset Process
    typeset lookup
    typeset ErrLst="$AUTO_ROOT_DIR/process_error_list"
    typeset DebugOn="0x7f0001ff"
    typeset DebugOff="0x00000000"
    typeset DebugFlag # Will be set depending on the process with error
    typeset FailFlag="1"
    typeset WaitAfterReStart=300

    # Ititial email and warning message that process has error
    typeset MsgWarn="Debug parameter is going to be set"
        MsgWarn="${MsgWarn} and automation will attempt to restart the process"

    # Final email and message sent after process couldn't be restarted
    typeset Msg="The process is still Stopped. Debug parameter was already" 
        Msg="${Msg} set and restart was attemped. Automation will wait for "
        Msg="${Msg} your responce"

    debug_pause 1
    set_oracle_env $host_type $host_id

    # Set exports to local for easier readability
    typeset Host=$this_hostname
    typeset Sid=$this_sid
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset Port=$AUTO_SPO_PORT

    # Get the status of shareplex using local sp_ctrl
    CmdOutPut=$(_SPCTRL_CmdLocToRemote $host_type $host_id "status") || {
        LogIt "Failed:: sp_ctrl failed executing status"
        LogIt "sp_ctrl returned:\n$CmdOutPut"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # check the status for all error messages
    while read lookup; do

        # Search for the message in sp_ctrl output and get process name
        orig_output=`print "$CmdOutPut" | grep "$lookup" | awk '{print $1}'`

        # Check for next message if current lookup was not found
        [ -z "$orig_output" ] && {
                LogIt "Passed:: All processes running"
                continue
        } 

        # Convert process name to lowercase
        Process=`echo $orig_output | tr [:upper:] [:lower:]`

        # Decide what debug flag to use
        case $Process in
            capture) DebugFlag="SP_OCT_GEN_DEBUG"  ;;
            read)    DebugFlag="SP_ORD_DEBUG_FLAG" ;;
            --post)    DebugFlag="SP_OPO_DEBUG_FLAG" ;;
            mtpost)  DebugFlag="SP_OPO_DEBUG_FLAG" ;;
            *)
              LogIt "Failed:: Process \"$Process\" is an invalid proc to check"
              break
        esac

        # Send email notification right away
        MsgWarn="Debug parameter '$DebugFlag' is going to be set."
        MsgWarn="${MsgWarn}\n$Process will attempt to restart."
        SendEMail "$Process has $lookup on $Sid@$Host" "$MsgWarn\n$CmdOutPut"

        # Set debug flag on and restart the process
        LogIt "Failed:: $Process has $lookup"
        LogIt "$CmdOutPut"
        LogIt "Setting debug flag \"$DebugFlag\""

        # Set debug unless user exported flag not to
        [[ "$AUTO_SKIP_SET_DEBUG" != "" ]] && {
            LogIt "AUTO_SKIP_SET_DEBUG is set. Skipping"
        } || {
            _SPCTRL_CmdLocToRemote $host_type $host_id "set param $DebugFlag $DebugOn"
        }

        # If stopped and deadlock has been found, set initrans for all tables
        [[ $AUTO_DEADLOCK_FLAG == $TRUE ]] && {
            typeset AltSql="ALTER TABLE <TABLE> initrans 20"

            # Get active config
            ActiveCfgName=$(get_active_cfg_name $HostType $HostId) || {
                LogIt "$ActiveCfgName"
                LogIt "Failed:: Couldn't get currently active config"
                LogIt "Alter trans on 0 tables!"
            }

            # Create a table list file from config on this machine
            typeset OldLst=$AUTO_TABLE_LIST # Save old
            typeset NewLst="alter_trans_tables.tab_list" # set it to new list
            create_atl "$AUTO_WORK_DIR/$ActiveCfgName.tmp" "$NewLst"

            # Alter ExecSqlOnAllTables function to execute table file name
            ExecSqlOnAllTables dst 0 $this_spadmin $this_spapass "$AltSql" Log

            AUTO_DEADLOCK_FLAG=$FALSE
            AUTO_TABLE_LIST=$OldLst            # set it back to old list
            set_oracle_env $host_type $host_id 1 # set back to orignal host cause get_active_cfg_name set it to src
        }
 
        LogIt "Attempting to restart $Process"

        # Mutlithreaded poster command is same as post
        [ "$Process" == "mtpost" ] && {
            _SPCTRL_CmdLocToRemote $host_type $host_id "start post"
        } || {
            _SPCTRL_CmdLocToRemote $host_type $host_id "start $Process"
        } 

        LogIt "Waiting $WaitAfterReStart seconds"
        echo_sleep $WaitAfterReStart

        LogIt "Checking if $Process restarted"
        check_process $host_type $host_id "$orig_output" "$lookup"

        # See if process started
        if [ $? -eq $FALSE ]; then
            # If it didn't then send email and wait for a while
            SendEMail "$Process has $lookup on $Sid@$Host" "$Msg"
            LogIt "Failed:: $Process failed to start"
            FailFlag="0"
            break

        else
            LogIt "Passed:: $Process restarted successfully"
            LogFunctEnd $0 "$@"
            LogIt "Continuing with test..."

            # Turn debug flag off

            # Unset debug unless user exported flag not to
            [[ "$AUTO_SKIP_SET_DEBUG" != "" ]] && {
                LogIt "AUTO_SKIP_SET_DEBUG is set. Skipping"
            } || {
                _SPCTRL_CmdLocToRemote $host_type $host_id "set param $DebugFlag $DebugOff"
            }


        fi


    # End while read lookup; do loop
    done < $ErrLst

    # Wait for user to do something if process is still down
    if [[ "$FailFlag" == "0" ]]; then
        read UserIn?"Press Enter to continue, or Ctrl-C to abort> "
        _SPCTRL_CmdLocToRemote $host_type $host_id "set param $DebugFlag $DebugOff"

    fi

    LogFunctEnd $0 "$@"
    debug_pause 1

}





# ==============================================================================
# Name: send
# changed to use sp_ctrl on automation box because windows was having to many
# problems using telnet and sp_ctrl.
# ==============================================================================

function send {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3

    LogFunctStart $0 "$@"

    set_oracle_env $HostType $HostId

    debug_pause 1

    SpctrlOut=$(_SPCTRL_CmdLocToRemote "$HostType" 0 "$Cmd")
    print "$SpctrlOut" | grep -P "Unknown command"
    retVal=$?

    # Log the results of the sp_ctrl command if logging option passed in.
    if (( $# == 4 )); then
        LogIt "$SpctrlOut"
    fi

    # Pass or fail the execution of the expect script
    if (( "$retVal" == "$TRUE" )); then
        LogIt "Failed:: $0 '$Cmd'"
    else
        LogIt "Passed:: '$0 '$Cmd'"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}


# ==============================================================================
# Name: send_two
# change to use sp_ctrl on automation box because windows was having to many
# problems using telnet and sp_ctrl.
# 7-12-2016 Julia - use with "$cmd on usr/pwd@host:port set xxxx or where xxxx"#
# the client (sp_ctrl) does not parse the SQL-like syntax that comes after "set" or "where".  Everything after "set" or "where" is pushed over to the server (sp_cnc) for processing.  
# ==============================================================================

function send_two {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3
    typeset Cmd2=$4

    LogFunctStart $0 "$@"

    set_oracle_env $HostType $HostId

    debug_pause 1

    SpctrlOut=$(_SPCTRL_CmdLocToRemote "$HostType" 0 "$Cmd" "$Cmd2")
    print "$SpctrlOut" | grep -P "Unknown command"
    retVal=$?

    # Log the results of the sp_ctrl command if logging option passed in.
    if (( $# == 5 )); then
        LogIt "$SpctrlOut"
    fi

    # Pass or fail the execution of the expect script
    if (( "$retVal" == "$TRUE" )); then
        LogIt "Failed:: $0 '$Cmd' '$Cmd2'"
    else
        LogIt "Passed:: '$0 '$Cmd' '$Cmd2'"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}


# ==============================================================================
# Name: send
# Do not use. Old function that used expect and telnet
# ==============================================================================

function send_old {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3

    LogFunctStart $0 "$@"

    set_oracle_env $HostType $HostId

    debug_pause 1

    # Do not run on windows and if command is in the exclude list
    if _IsWindows $PLATFORM; then

        while read ExcludeStr; do

            _IsJunk "$ExcludeStr" && continue

            [[ $Cmd = +($ExcludeStr) ]] && { 
                LogIt "Skipped:: send $Cmd disabled for windows."
                LogFunctEnd $0 "$@"
                return $TRUE
            }       

        done < $AUTO_WIN_SEND_EXCLUDES
    fi

    # Run either the expect script for logging or without logging
    if (( $# == 4 )); then
        $AUTO_EXPECT_DIR/osend "$Cmd" "$AUTO_TEST_CASE_LOG"
    else
        $AUTO_EXPECT_DIR/osend "$Cmd"
    fi

    # Pass or fail the execution of the expect script
    if (( $? != 0 )); then
        LogIt "Failed:: '$0 $HostType $HostId $Cmd' `date`"
    else
        LogIt "Passed:: '$0 $HostType $HostId $Cmd' `date`"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}

# ==============================================================================
# Name: execute
# ==============================================================================

function execute {

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3

    LogFunctStart $0 "$@"

    set_oracle_env $HostType $HostId

    debug_pause 1

    # Redirect command to use send on windows do to so many problems with sp_ctrl on win telnet services.
    if _IsWindows $PLATFORM; then
        LogIt "$0 on windows is redirecting your sp_ctrl command to send."
        send $HostType $HostId "$Cmd" LOG
        return  $TRUE
    fi

    # Execute expect script
    $AUTO_EXPECT_DIR/execute $Cmd

    # Check if expect passed or failed
    if (( $? != 0 )); then
        LogIt "Failed:: 'splex.execute $HostType $HostId $Cmd'"
    else
        LogIt "Passed:: 'splex.execute $HostType $HostId $Cmd'"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1
}

# ==============================================================================
# Name: execute_wlog
# ==============================================================================

function execute_wlog {

    typeset host_type=$1
    typeset host_id=$2
    typeset comm_file=$3

    LogFunctStart $0 "$@"
    debug_pause 1

    set_oracle_env $host_type $host_id   # pxh031

    $AUTO_EXPECT_DIR/execute "$command" $AUTO_TEST_CASE_LOG

    if (( $? != 0 )); then    
        LogIt "Failed:: $command"
    else    
        LogIt "Passed:: $command"
    fi

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Name: clean_old_install
# ==============================================================================

        function clean_old_install
        {       
                typeset host_type
                typeset host_id 
                typeset comm_file

                host_type=$1
                host_id=$2
                command=$3

                set_oracle_env $host_type $host_id   # pxh031

#TODO: MAKE IT WORK ON WINDOWS
    # Do not run on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

                echo ==============================
                LogIt "Cleaning old install on $this_hostname `date` "
                debug_pause 1

		/usr/bin/rexec -a -l root -p $rootpass $this_hostname "rm -fr /splex/SharePlex-${curr_version}"
        	LogIt "Removing /splex/SharePlex-${curr_version}"
        	cur_time=`date +"%d%b%y%H%M%S"`
        	/usr/bin/rexec -a -l root -p $rootpass $this_hostname "mv /var/adm/.splex/Shareplex.mark \
                		/var/adm/.splex/Shareplex.mark.$cur_time"
        	LogIt "Backing up old Shareplex.mark file to /var/adm/.splex/Shareplex.mark.$cur_time"

                LogIt "Done sending $command. `date` "
                debug_pause 1
        }       

# ==============================================================================
# Name: stop_test
# ==============================================================================

function stop_test {

    typeset output
    typeset env_list

    rm $AUTO_TABLE_LIST
    enddate=`date +%x`
    endtime=`date +%X`
    LogIt "TEST END TIME=$enddate $endtime"

#    if [[ "$AUTO_SRC_PLATFORM" = "$WINDOWS"  || "$AUTO_DST_PLATFORM" = "$WINDOWS" ]]
#    then
#        /usr/bin/dos2unix $AUTO_TEST_CASE_LOG
#        chmod 666 $AUTO_TEST_CASE_LOG
#    fi
    exit 0
}

function count_chained_rows {


#export PS4="$LINENO: "
    LogFunctStart $0 "$@"
    debug_pause 1

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 3" 

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst HostId OraUser" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #alidate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set local env vars to local 
    typeset HostType=$1
    typeset HostId=$2
    typeset OraUid=$3

    set_oracle_env $HostType $HostId

    # Other local variables
    typeset TblFile=$AUTO_TABLE_LIST
    typeset ChainFile="$ORACLE_HOME/rdbms/admin/utlchain.sql"
    typeset Tables      # Tables list for pl/sql proc
    typeset Output      # Output of function and/or commands
    typeset PlSql       # Big PL/SQL command

    # Check that the table list file exists
    _ValFileExists $0 "$TblFile" || {
        LogFunctEnd $0 "$@";
        return $FALSE
    }

    # Create the tables array for oracle
    Tables=`awk '{ print $1 }' < $AUTO_TABLE_LIST| 
            awk ' BEGIN { RS="" }
            { gsub("\n","\047,\n\047",$0); }
            { print "storTab(\047"$0"\047);\n" }'`

    # TODO: split check_oracle in 2 functions, one to return TRUE/FALSE
    check_oracle $this_tns

    # Email subject and term message on failure
    typeset EmailSub="ERROR: $0 couldn't execute file:$ChainFile" \
    typeset EmailBod="$0 will be marked as Failed\n"

    # Start sqlplus in a co-process or fail 
    sqlplus -s /NOLOG |& 
    Output=$(_CoProcConnSqlPlus "p" "p" "$OraUid" "$OraUid" "$this_tns") || {
        LogIt "$Output"
        LogIt "Failed:: $0 - Coundn't connect to $this_tns"
        LogFunctEnd $0 "$@";
        return $FALSE
    }

    # Execute the utlchain.sql file
    Output=$(_CoProcExecSql "p" "p" "@ $ChainFile") || {

        # Conditions that test if utlchain.sql ran successfully
        Pass1="Table*created."
        Pass2="already*used*by*an*existing*object"

        # If the table wasn't created or didn't already exist, then fail 
        if [[ "$Output" != ?(*$Pass1*|*$Pass2*) ]]; then
       
            # Check for oracle errors and show them if found
            Errors=$(_GetOraErr "${Output}") && LogIt "$Errors"

            LogIt "Failed:: $Output"
            print -p "exit"  # exit sqlplus co-proc
            LogFunctEnd $0 "$@"
            return $FALSE
        fi

    }

    PLSql="
set serveroutput on size 1000000 verify off linesize 132 pagesize 10000 feedback off heading off
DECLARE
      cursor_name1     INTEGER;
      ret1             INTEGER;
      v_sql1           VARCHAR2 (2000);

      type storTab is table of varchar2(50);
      stor_table storTab := $Tables

      num_chained_rows NUMBER;
      num_total_rows   NUMBER;
      num_prc_rows     NUMBER;
      sum_chained_rows NUMBER :=0;
      sum_total_rows   NUMBER :=0;
      sum_prc_rows     NUMBER :=0;
      target_table     VARCHAR2(50);   
      val_lar          EXCEPTION; 
      PRAGMA EXCEPTION_INIT(val_lar,-0942); 
     
BEGIN
      -- Increase Buffer Size
      dbms_output.enable(1000000);
      
      -- Print Title
      dbms_output.put_line(chr(10));
      dbms_output.put_line(chr(9)||chr(9)||'Chained Row(s) on '||'$srcsid'||' '||'$srchost'||' '||' Tables');
      dbms_output.put_line(lpad('-',74,'-'));
      -- Print Header
      dbms_output.put_line(RPAD('TableName',35)||LPAD('ChainedRow(s)',15)||LPAD('TotalRow(s)',14)||LPAD('%Chained',10));
      dbms_output.put_line(lpad('-',74,'-'));
 
	-- Define sql for dynamic query
	v_sql1 := 'truncate table chained_rows';
	cursor_name1 := dbms_sql.open_cursor;
	dbms_sql.parse(cursor_name1,v_sql1,DBMS_SQL.V7);
	ret1 := dbms_sql.execute(cursor_name1);		
	dbms_sql.close_cursor(cursor_name1);

     for k in stor_table.first .. stor_table.last loop

   BEGIN

	--target_table := '\"'||RTRIM(t_name.table_name)||'\"';
        target_table := RTRIM(stor_table (k));
	-- Define sql for dynamic query
	v_sql1 := 'analyze table ' ||stor_table (k) || ' list chained rows';
	cursor_name1 := dbms_sql.open_cursor;
	dbms_sql.parse(cursor_name1,v_sql1,DBMS_SQL.V7);
	ret1 := dbms_sql.execute(cursor_name1);		
	dbms_sql.close_cursor(cursor_name1);

      SELECT COUNT(*) 
      INTO   num_chained_rows
      FROM   CHAINED_ROWS
      WHERE  owner_name||'.'||table_name = stor_table (k);

        cursor_name1 := dbms_sql.open_cursor;
        v_sql1 := 'select count(*) num_total_rows'||' from '||stor_table (k);
        dbms_sql.parse(cursor_name1, v_sql1, DBMS_SQL.V7);
        dbms_sql.define_column(cursor_name1, 1, num_total_rows);
        ret1 := dbms_sql.execute(cursor_name1);
        ret1 := dbms_sql.fetch_rows(cursor_name1);
        dbms_sql.column_value(cursor_name1, 1, num_total_rows);
        dbms_sql.close_cursor(cursor_name1);

      IF num_total_rows = 0 THEN
	 num_prc_rows := 0;
      ELSE
	 num_prc_rows := TRUNC((num_chained_rows/num_total_rows)*100,2);
      END IF;
      
      sum_chained_rows := sum_chained_rows + num_chained_rows;
      sum_total_rows := sum_total_rows + num_total_rows;

      dbms_output.put_line(RPAD(target_table,35)||LPAD(num_chained_rows,15)||LPAD(num_total_rows,14)||LPAD(to_char(num_prc_rows,'990.99'),10));	

    EXCEPTION 
    WHEN val_lar THEN 
     NULL; 
    END;		
	
  END LOOP;

      IF sum_total_rows = 0 THEN
	 sum_prc_rows := 0;
      ELSE
	 sum_prc_rows := TRUNC((sum_chained_rows/sum_total_rows)*100,2);
      END IF;

      dbms_output.put_line(lpad('-',74,'-'));
      dbms_output.put_line(RPAD('Total',35)||LPAD(sum_chained_rows,15)||LPAD(sum_total_rows,14)||LPAD(to_char(sum_prc_rows,'990.99'),10));	
      dbms_output.put_line(lpad('-',74,'-'));
END;
/
"

    # Execute the pl/sql in sqlplus co process
    Output=$(_CoProcExecSql "p" "p" "$PLSql") || {
        LogIt "Failed:: $Output"
        print -p "exit"  # exit sqlplus co-proc
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    LogIt "$Output"

    # Exit sqlplus co-process
    print -p "exit"

    LogFunctEnd $0 "$@"
    debug_pause 1
   
    return $TRUE

}

# ==============================================================================
# Name: analyze_table_all
# ==============================================================================
        function analyze_table_all
        {
                typeset host_type
                typeset host_id
                typeset sqluser
                typeset src_count
                typeset curr_config
                typeset x
                
                host_type=$1
                host_id=$2
		analyze_config=$3
                sqluser=$4

                echo ==============================
                LogIt "Starting analyze_table_all `date` "
                debug_pause 1

                . $AUTO_ROOT_DIR/local_sqlplus
        #        set_oracle_env $host_type $host_id

                ######### Begin determine the evironment and service name for SQLPLUS #################
                ######### End determine the evironment and service name for SQLPLUS #################
		create_atl $analyze_config ${AUTO_TESTER}_${s_sid0}_${s_host0}.analyze || {
                    print "Failed:: Couldn't create table list for analyze_table_all"
                    return 1
                }

                cat $AUTO_WORK_DIR/${AUTO_TESTER}_${s_sid0}_${s_host0}.analyze | while read table
                do
                        if [ -z $table ]
                        then
                                continue
                        fi

echo "OraHome=$ORACLE_HOME"
echo "path=$PATH"

#sqlplus ${sqluser}/${sqluser}@${service_name} <<HERE | tee -a $log_file | grep "ORA-" >/dev/null
`sqlplus ${sqluser}/${sqluser}@${service_name} <<HERE
        truncate table chained_rows;
        analyze table $table list chained rows into chained_rows;
        select count(*) from chained_rows;
exit 0
HERE` || {
    print "Failed:: analyze_table_all failed on $table"
    return 1
}
                      exit_status=$?


                        if [ "$exit_status" = "0" ]
                                then
                                        LogIt "Failed:: analyze table $table"
                        else
                                        LogIt "Passed:: analyze table $table"
                        fi
                done

                echo ==============================
                LogIt "Done analyze_table_all `date` "
                debug_pause 1
        }


###################################################################
# SendEMail "SUBJECT" "BODY" "path/file"
#
# This function will send an email to the tester.
#
# INPUT:
#     SUBJECT   = String to be the subject of the email
#     BODY      = String to be the body of the email
#     Path/File = Path to a file that will be appended to body
###################################################################
function SendEMail
{

    # Vars for args passed in
    typeset EmailSubjectIn
    typeset EmailBodyIn
    typeset EmailAttachmentIn

    # More local vars
    typeset EmailBody

    # Init locals to args passed in
    EmailSubjectIn=$1
    EmailBodyIn=$2
    EmailAttachmentIn=$3 

    typeset AutoHost=`hostname`

    # Build the body of the email message
    EmailBody="`date`\r\n"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Auto Server:"   $AutoHost`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Tester:"        $AUTO_TESTER`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "MasterSuite:"   $AUTO_MASTER_SUITE`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Suite Name:"    $AUTO_CURRENT_SUITE`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Test Case Id:"  $AUTO_CURRENT_TEST_ID`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Test Case Dir:" $AUTO_CURRENT_TEST`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Config:"        $AUTO_CURRENT_CONFIG`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Env:"           $AUTO_ENV_FILE`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Log:"           $AUTO_TEST_CASE_LOG`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Auto Log:"      $AUTO_SUITE_LOG`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Source Host:"   $AUTO_SRC_HOST_NAME`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Source Plat:"   $AUTO_SRC_PLATFORM`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Source SID:"    $AUTO_SRC_SID`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Dest Host:"     $AUTO_DST_HOST_NAME`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Dest Plat:"     $AUTO_DST_PLATFORM`"
    EmailBody="${EmailBody}`printf '%-20s %-20s\r\n' "Dest SID:"      $AUTO_DST_SID`"
    EmailBody="${EmailBody}\r\n######################################################\r\n"
    EmailBody="${EmailBody}Automation Message\r\n"
    EmailBody="${EmailBody}######################################################\r\n"

    # Append body argument to body
    if [ -n "$EmailBodyIn" ]
    then
        EmailBody="${EmailBody}$EmailBodyIn\n"
    fi

    # Append attachment argument to body
    if [ -n "$EmailAttachmentIn" ]
    then
        EmailBody="${EmailBody}\n\n######################################################\n"
        EmailBody="${EmailBody}Contents of file: $EmailAttachmentIn\n"
        EmailBody="${EmailBody}######################################################\n"

        if [ -s "$EmailAttachmentIn" ]
        then
            EmailBody="${EmailBody}`cat $EmailAttachmentIn`"    
        else
            EmailBody="${EmailBody}Can not display contents. $EmailAttachmentIn does not exists or is empty\n"
        fi

    fi
    # Send email
    #Ilya 031814
    #echo "$EmailBody" | mail $AUTO_USER_EMAIL -s "$EmailSubjectIn"
    echo "$EmailBody" | mail -s "$EmailSubjectIn" $AUTO_USER_EMAIL

}


function DropDBLink
{
   #Drop DB link if it exists

   typeset User=$1
   typeset Pwd=$2
   typeset ServiceName=$3
   typeset LinkName=$4

y=`sqlplus $User/$Pwd@$ServiceName<<EOF

DECLARE
    vLinkName     varchar2(150);
    vCount        integer;
    vCursorId     integer;
    vDdlCommand   varchar2(100);
    vResultOfDdl  integer;
    
BEGIN
  
    vLinkName := '$LinkName';

    -- Check if database link exists
    SELECT COUNT(*)
    INTO   vCount
    FROM   USER_DB_LINKS
    WHERE  DB_LINK = UPPER(vLinkName); 

    -- If link exists then drop it 
    IF vCount > 0 THEN
        dbms_output.put_line('Dropping database link:' || vLinkName);
        vCursorId := dbms_sql.open_cursor;
        vDdlCommand := 'drop database link ' || vLinkName;
        dbms_sql.parse ( vCursorId, vDdlCommand, dbms_sql.native );
        vResultOfDdl := dbms_sql.execute (vCursorId);
        dbms_sql.close_cursor (vCursorId);
    END IF;
    
END;
/
EOF`

}

check_user()
{
typeset user
user=$1
x=`sqlplus -s tcm/tcm@habuprod <<EOF
   set pages 0 echo off verify off feed off term off
   whenever sqlerror exit 1
     select get_name_fun('$AUTO_USER')
       from dual;
exit 0
EOF`
   if [ "$?" != "0" ] 
   then
      echo "check_user $user name failed!"
   else 
         if [ "$x" = "None" ]
         then
            echo "User $user for tester $AUTO_TESTER not found in the TCM Database"
            echo "Check your $AUTO_TESTER_name.env file. Exiting..."
            exit 1
         fi
   fi
}

check_suite()
{
x=`sqlplus -s tcm/tcm@habuprod <<EOF 
   set pages 0 echo off verify off feed off term off
   whenever sqlerror exit 1
     select check_suite_fun('$suite_name') 
       from dual;
exit 0
EOF`
   if [ "$?" != "0" ] 
   then
      echo "check_suite $suite_name failed!"
   else 
         if [ $x -eq "0" ]
         then
            echo "Suite $suite_name not found in the TCM Database"
            echo "Check your suite_name."
            echo "Warning!!! Your suite $suite_name is not on master suite list. You won't be able to insert it results to TCM.
" | mail $email -s "Warning!!! Your suite $suite_name is not on master suite list."
          #  exit
         fi
   fi
}

function GetMasterSuitePID {

    typeset SuitePid=$PPID

    typeset MasterSuitePid


    MasterSuitePid=`ps -ef | grep "^$USER *$SuitePid" | awk '{print $3}'` || {
      print "Error: splex.ksh.GetMasterSuitePID couln't get PID of master suite"
      return $FALSE
    }

    # Make sure we have a pid
    if [ $MasterSuitePid ]; then
        print $MasterSuitePid
        return $TRUE
    else
      print "Error: splex.ksh.GetMasterSuitePID couln't get PID of master suite"
      return $FALSE
    fi

}

###########################################################################
# Function Name: SetPlatform                        Date Created:12/10/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Sets the PLATFORM environment variable according the the 
#              host type passed in.
#
# Usage: SetPlatform $MyHostType
#
# Output/Return: Returns 1 on failure, 0 on success. Prints error messages
#                to stdout
#
# Ex: SetPlatform $MyHostType   -or-
#     Ret=$(SetPlatform $MyHostType)|| { print "Error: $Ret"; exit; }
###########################################################################
function SetPlatform {

    # Get at least 1 argument or return now
    if [ $# != 1 ]; then 
        print "Error: No arguments passed to 'splex.SetPlatform'"
        print "\tMust pass 'src' or 'dst'"
        return 1
    fi

    typeset HostType=$1

    # Argument must be "src" or "SRC"
    if [[ "$HostType" == "src"  || "$HostType" == "SRC" ]]; then 
        export PLATFORM=$AUTO_SRC_PLATFORM

    # Argument must be "dst" or "DST"
    elif [[ "$HostType" == "dst" || "$HostType" == "DST" ]]; then
        export PLATFORM=$AUTO_DST_PLATFORM

    # Anthing else besides above, return now
    else
        print "Error: Invalid argument passed to 'splex.SetPlatform'"
        print "\tMust pass 'src' or 'dst'"
        return 1
    fi

}

function LogFunctStart {
    typeset FunctionName=$1
    shift

    LogIt "\n##################################################"

    String="Start '$FunctionName $@' `date`"
    LogIt "$String"

}

function LogFunctEnd {

    typeset FunctionName=$1
    shift

    String="Finished '$FunctionName $@' `date`"
    LogIt "$String"
    LogIt "##################################################\n"

}

function run_lob_script {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    debug_pause 1

    # Local variables
    typeset ValArgPat="$# == 5"
    typeset UseMsg="usage: $0 src|dst HostId Uid Pwd SqlScript" 

    typeset CreateDirState  # Sql statement to create ora dir
    typeset LobDir          # Physical lob dir at OS level

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments to local variables
    HostType=$1
    HostId=$2
    Uid=$3  # User to login to sqlplus as
    Pwd=${4:-$Uid}  # Password of user to login to sqlplus as
    SqlScript=$AUTO_SQL_DIR/$5  # Full path to sql script

    # Check that the file exists
    _ValFileExists $0 "$SqlScript" || {
        LogFunctEnd $0 "$@";
        return $FALSE
    }

    # TODO
    # COMMENTED OUT BECAUSE NEED TO APPEND .sql if not there
    # NEED TO DO THAT LATER
    # Make sure the sql script exists with or without ".sql" extention
    #if [[ ! -f $SqlScript || ! -f "$SqlScript.sql" ]]; then
    #    LogIt "Failed:: $File sql script doesn't exist."
    #    LogFunctEnd $0 "$@"
    #    return $FALSE
    #fi 

    set_oracle_env $HostType $HostId

    # Set up the lob directory depending on remote OS
    if _IsWindows $PLATFORM; then
        LobDir="$AUTO_LOB_WIN_DIR"  # Windows
    else
        LobDir="$AUTO_LOB_DIR"      # Unix
    fi

    CreateDirState="create or replace directory LOB_FILES as '$LobDir';\n"

    . $AUTO_ROOT_DIR/local_sqlplus

    # Start SQL*Plus in a co-process or fail
    sqlplus -s /NOLOG |& 

    # Save CO-process PID so we can kill it later if it doens't die 
    CoProcPID=$!

    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Pwd $this_tns) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $this_tns"
        _KillPID CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Execute the sql to create oracle dir
    Output=$(_CoProcExecSql "p" "p" "$CreateDirState") || {
        LogIt "Failed:: $Output"
        _ExitCoProcSql CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    print "$Output"

    # Execute the sql script that inserts lob and fail it
    # if sqlplus status is false
    Output=$(_CoProcExecSql "p" "p" "start $SqlScript") || {
        LogIt "Failed:: $Output"
        _ExitCoProcSql CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #print -p "exit\n"  # exit sqlplus co-proc
    _ExitCoProcSql CoProcPID
    LogIt "Passed:: $SqlScript"

    LogFunctEnd $0 "$@"

}

function _ExitCoProcSql {

    typeset Pid=$1

    # Try clean
    print -p "exit" 2>&1 >/dev/null

    # Now forcefully
    while `ps -ef | grep -v grep | grep $Pid >/dev/null`; do
        ps -ef | grep $Pid | grep -v grep
        kill -9 $Pid
        sleep 1
    done

}
###############################################################################
# Name: truncate_all_tables
# Description: truncates all tables in the current config
# Author: Tim Whetsel           Date Created: Tues Nov 1, 2005
# Usage: truncate_all_tables src|dst 0 OraUser [OraPass]
###############################################################################
function truncate_all_tables {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    # Local variables
    typeset ValArgPat="$# == 3 || $# == 4"
    typeset UseMsg="usage: $0 src|dst HostId Uid Pwd"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return··
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments to local variables
    HostType=$1
    HostId=$2
    Uid=$3
    Pwd=${4:-$Uid} # Default password to user name if 4 arg not given

    set_oracle_env $HostType $HostId

    . $AUTO_ROOT_DIR/local_sqlplus

    # Sql statement to truncate table. Will be dynamic for each table
    typeset TruncateState

    # Start SQL*Plus in a co-process or fail
    sqlplus -s /NOLOG |&
    CoProcPID=$!
    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Pwd $this_tns) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $this_tns"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Drop each table in the table list
    while read Table; do

        TruncateState="truncate table $Table;\n"

        # Execute the truncate statement for current table
        # Continue even if truncate fails and returns Oracle error.
        # Table might not exist.
        Output=$(_CoProcExecSql "p" "p" "$TruncateState")

        # Check for oracle errors and show them if found
        Errors=$(_GetOraErr "${Output}") && LogIt "$Errors"

        LogIt "$Table: $Output"

    done < $AUTO_TABLE_LIST # END WHILE READ LINE

    # exit sqlplus co-proc
    _ExitCoProcSql CoProcPID

    LogIt "Passed:: All tables in $AUTO_CURRENT_CONFIG truncated"

    LogFunctEnd $0 "$@"

}



###############################################################################
# Name: drop_all_tables
# Description: Drops all tables in the current config
# Author: Tim Whetsel           Date Created: Fri Apr 16 10:09:36
# Usage: drop_all_tables src|dst 0 OraUser [OraPass]
###############################################################################
function drop_all_tables {

    LogFunctStart $0 "$@"

    # Local variables
    typeset ValArgPat="$# == 3 || $# == 4"
    typeset UseMsg="usage: $0 src|dst HostId Uid Pwd"·

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return··
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Set arguments to local variables
    HostType=$1
    HostId=$2
    Uid=$3
    Pwd=${4:-$Uid} # Default password to user name if 4 arg not given

    set_oracle_env $HostType $HostId

    . $AUTO_ROOT_DIR/local_sqlplus

    # Sql statement to drop table. Will be dynamic for each table
    typeset DropState

    # Start SQL*Plus in a co-process or fail
    sqlplus -s /NOLOG |&
    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Pwd $this_tns) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $this_tns"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Drop each table in the table list
    while read Table; do

        DropState="drop table $Table;\n"

        # Execute the drop statement for current table
        # Continue even if drop fails and returns Oracle error.
        # Table might not exist.
        Output=$(_CoProcExecSql "p" "p" "$DropState")

        print "$Output"

    done < $AUTO_TABLE_LIST # END WHILE READ LINE

    print -p "exit"  # exit sqlplus co-proc

    LogIt "Passed:: All tables in $AUTO_CURRENT_CONFIG dropped"

    LogFunctEnd $0 "$@"

}


###############################################################################
# Author: Tim Whetsel           Date Created: Tue May  4 11:53:47 PDT 2004
# Name: LogIt
# Description: Use this function to display text in term and to testcase log
# Usage: LogIt "This test is cool!"

###############################################################################
function LogIt {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 1"

    # Usage message for function
    typeset UseMsg="usage: $0 StringToLog"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        return $FALSE
    }

    typeset StringToLog="$1"

    typeset ExitFlag="$FALSE"

    print "$StringToLog" | tee -a $AUTO_TEST_CASE_LOG
        
    [[ $StringToLog = +(Warning::*) ]] && {

        # Log test in rep as skipped
        [[ $StringToLog = +(*skipped_test*) ]] && { 
            typeset TCSetClause="SET TC_RESULT='S', TC_RESULT_ORIGINAL_RESULT='S'"
        } 

        _UpdateTestResult "$TCSetClause"

        return $TRUE

    }

    [[ $StringToLog = +(Failed::*) ]] && { 

        # Mark suites as failed in repository if String to log has "Failed::"
        typeset SuiteSetClause="SET suite_result_result='F', suite_result_original_result='F' "
        typeset TCSetClause="SET TC_RESULT='F', TC_RESULT_ORIGINAL_RESULT='F'"

        _UpdateSuiteResult "$SuiteSetClause" 
        _UpdateTestResult "$TCSetClause"

        # Flag to pause when error occurs
        [[ -n "$AUTO_PAUSE_ON_ERROR" ]] && {
            typeset Msg="\n\n\n#############################################################\n"
                    Msg="${Msg}An error has occured and you have AUTO_PAUSE_ON_ERROR set.\n" 
                    Msg="${Msg}Press Enter to continue, or Ctrl-C to abort.\n"
                    Msg="${Msg}#############################################################\n"
                    print "$Msg"
                    read UserIn
        }      

        # Flag to exit test when error occurs
        [[  -n "$AUTO_EXIT_SUITE_ON_ERROR" ]] && exit 127

    }
     
    return $TRUE

}

    

#Updates the suite result record in the repository
#   Pass in the "Set clause(s)"
function PromptUser {
    read UserIn?"Press Enter to continue, or Ctrl-C to abort> "
}

function version {
   
    typeset Ver="$Id: splex.ksh,v 1.9.2.42.2.61.2.138 2007/08/22 21:57:55 twhetsel Exp $"

    LogIt "##################################################################"
    LogIt "                     VERSION INFORMATION"
    LogIt "$Ver"
    LogIt "##################################################################"
    LogIt "Failed::-testing failure"

}


###############################################################################
# Author: Tim Whetsel           Date Created: Fri March 2, 2006
# Description: Updates the test result record in the repository
#   Pass in the "Set clause(s)"
###############################################################################
function _UpdateTestResult {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset SetClause=$1

    typeset Sql="
UPDATE auto.testcase_results
${SetClause}
WHERE tc_result_id = $AUTO_TC_RESULT_ID;
commit;
"

    typeset Output

    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql "$AUTO_REP_UID" "$AUTO_REP_PWD" "$AUTO_REP_NAME" "$Sql") || {
        print "Failed:: $0 encountered errors while connecting to Oracle" | tee -a $AUTO_TEST_CASE_LOG
        print "$Output" | tee -a $AUTO_TEST_CASE_LOG
        print "Finished '$0 $@ `date`'"  | tee -a $AUTO_TEST_CASE_LOG
        return $FALSE
    }

    # Check for oracle errors and show them if found
    Errors=$(_GetOraErr "${Output}") && LogIt "$Errors"

}


###############################################################################
# Author: Tim Whetsel           Date Created: Fri Feb 10 11:32:49 PST 2006
# Description: Updates the suite result record in the repository
#   Pass in the "Set clause(s)"
###############################################################################
function _UpdateSuiteResult {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset SetClause=$1

    typeset Sql="
UPDATE auto.suite_results
${SetClause}
WHERE suite_result_id = $AUTO_SUITE_RESULT_ID;
commit;
"

    typeset Output

    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql "$AUTO_REP_UID" "$AUTO_REP_PWD" "$AUTO_REP_NAME" "$Sql") || {
        print "Failed:: $0 encountered errors while connecting to Oracle" | tee -a $AUTO_TEST_CASE_LOG
        print "$Output" | tee -a $AUTO_TEST_CASE_LOG
        print "Finished '$0 $@ `date`'"  | tee -a $AUTO_TEST_CASE_LOG
        return $FALSE
    }

    # Check for oracle errors and show them if found
    Errors=$(_GetOraErr "${Output}") && LogIt "$Errors"

}


###############################################################################
# Branching of start_cop script was need because of new banner in 6.0 when 
# starting cop. This function evaluates the given spo version and returns
# the appropriate script name.
###############################################################################
function _GetStartCopScript {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType="$1"
    typeset TDE="$2"


    [[  "$HostType" == "src" && "$TDE" == "0" ]] && { 
        print "start_cop_tde.exp"
    } || {  
        print "start_cop_60.exp"
    }

}

#juliatde function _GetStartCopScript {
#juliatde
#juliatde    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
#juliatde
#juliatde    typeset SPOVersion="$1"
#juliatde
#juliatde    FirstNumber=`print "$SPOVersion" | cut -d. -f1`
#juliatde
#juliatde    [[ $FirstNumber -ge 6 ]] && { 
#juliatde        print "start_cop_60.exp"
#juliatde    } || {  
#juliatde        print "start_cop.exp"
#juliatde    }
#juliatde
#juliatde}

###############################################################################
# Author: Tim Whetsel           Date Created: Wed Oct 13 14:18:06 PDT 2004
# Name: start_cop
# Description: Starts sp_cop on Unix or Windows
###############################################################################
function start_cop {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 2"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst 0"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType=$1
    typeset HostId=$2

    set_oracle_env $HostType $HostId

#juliatde
#juliatde    ScriptName=$(_GetStartCopScript "$this_spo_ver")

    ScriptName=$(_GetStartCopScript "$HostType" "$AUTO_SRC_TDE")
    LogIt "Running expect script $ScriptName"
    $AUTO_EXPECT_DIR/$ScriptName

    # Pass or fail the execution of the expect script
    if (( $? != 0 )); then
        LogIt "Failed:: $0"
    else
        LogIt "Passed:: $0"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}


###############################################################################
# Author: Tim Whetsel           Date Created: Wed Oct 13 14:18:06 PDT 2004
# Name: shutdown_cop
# Description: issued the shutdown force command at sp_ctl for Unix and 
#              uses the kill.exe to shutdown SPO on Windows
###############################################################################
function shutdown_cop {

    LogFunctStart $0 "$@"

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 2"

    # Usage message for function
    typeset UseMsg="usage: $0 src|dst  0"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType=$1
    typeset HostId=$2

    set_oracle_env $HostType $HostId

    $AUTO_EXPECT_DIR/shutdown_cop.exp

    # Pass or fail the execution of the expect script
    if (( $? != 0 )); then
        LogIt "Failed:: $0"
    else
        LogIt "Passed:: $0"
    fi

    LogFunctEnd $0 "$@"

    debug_pause 1

}


# ==============================================================================
# Executes the given sql statement on all tables in the config
# Uses sqlplus coprocess
# Note: Do NOT add ";" to end of statement
# ==============================================================================
function ExecSqlOnAllTables {

    LogFunctStart $0 "$@"

    debug_pause 1

    typeset ValArgPat="$# == 5 || $# == 6" 
    typeset UseMsg="usage: $0 src|dst HostId OraUser OraPwd SqlStatement" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType=$1
    typeset HostId=$2
    typeset Uid=$3
    typeset Pwd=$4
    typeset Sql=$5
    typeset Log=$6

    set_oracle_env $HostType $HostId

    # Start SQL*Plus in a co-process
    sqlplus -s /NOLOG |& 

    # Save CO-process PID so we can kill it later if it doesn't die 
    CoProcPID=$!

    # Connect to database
    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Pwd $this_tns) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $this_tns"
        _KillPID CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Perform sql on all tables in table list(config)
    while read Table; do


        # Change the <TABLE> sub string in sql statement to 
        # current table in the list
        NewSql=$(_ChangeSubString "$Sql" "<TABLE>" "$Table")

        # Execute the sql 
        Output=$(_CoProcExecSql "p" "p" "$NewSql;\n") || {
            LogIt "Failed:: $Output"

            # commented out exit so it will do the next table
            #_ExitCoProcSql CoProcPID
            #LogFunctEnd $0 "$@"
            #return $FALSE
        }

        [ -n "${Log:-}" ] && LogIt "$Output" 

        LogIt "$Table: $Output"

    done < $AUTO_TABLE_LIST # END WHILE READ LINE

    _ExitCoProcSql CoProcPID

    LogFunctEnd $0 "$@"

    debug_pause 1

}


#function splex_compare_old {
#
#    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
#
#    LogFunctStart $0 "$@"
#
#    debug_pause 1
#
#    typeset ValArgPat="$# == 2 || $# == 3"
#    typeset UseMsg="usage: $0 splex_command expected_result [ Timeout for compare to complet in 3 sec intervals]" 
#
#    # Validate the number of arguments passed to the function
#    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
#        LogFunctEnd $0 "$@"
#        return $FALSE
##    }
#
#    typeset SpoCmd=$1
#    typeset ExpResult=$(UpperCase "$2")
#    typeset TimeOut=${3:-"600"}
#
#    # Default to pass
#    [[ "$ExpResult" == "FAIL" ]] && ExpResult="FAIL" || ExpResult="PASS"
#
#
#    # Clean up any previous compares
#    cleanup_compare_procs src 0
#    cleanup_compare_procs dst 0
#
#    send src 0 "show compare" log
#    send src 0 "remove log compare all" log
#
#    # execute the compare
#    execute src 0 "$SpoCmd"
#
#    #Make sure that compare server started on source
#    get_string src 0 "$AUTO_SRC_OPT_DIR/log/event_log" "Process launched: sp_desvr" PASS email
#
#    # Wait till SPO says compare is done
#    get_string_spctrl src 0 "status" "Compare Svr" FAIL email "$TimeOut"
#    get_string_spctrl dst 0 "status" "Compare Clnt" FAIL email "$TimeOut"
#
#    # Wait till the SPO process are gone
#    wait_for_process src 0 "ps -ef | grep $AUTO_SRC_OPT_DIR/bin/sp_desvr"
#    wait_for_process dst 0 "ps -ef | grep $AUTO_SRC_OPT_DIR/bin/sp_declt"
#
#    # Look for error messages
#    get_string_spctrl src 0 "show compare" Running FAIL email
#    get_string_spctrl src 0 "show compare" Unknown FAIL email
#    get_string_spctrl src 0 "show compare" Error FAIL email 5
#
#    # If expected to pass, then expect it to be in sync
#    [[ "$ExpResult" == "PASS" ]] && {
#        get_string_spctrl src 0 "show compare" "Out Sync" FAIL email 5
#    } || {
#        # If expected to fail, then expect it to be out of sync
#        get_string_spctrl src 0 "show compare" "Out Sync" PASS email 5
#    }
#
#    #send src 0 "show compare" log 
#    #send src 0 "show compare detail" log
#
#    SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "show compare")
#    LogIt "$SpctrlOut"
#
#    SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "show compare detail")
#    LogIt "$SpctrlOut"
#
#    LogFunctEnd $0 "$@"
#
#    debug_pause 1
#}

# Checks if the sp_desvr process started message is in the event log
function _CheckSpdesvrEventLog {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    LogFunctStart $0 "$@"

    typeset Counter=0
    typeset CounterMax=10

    while (( $Counter <= $CounterMax )); do

        get_event_log src
        _WriteEventLogHistory src
        truncate_event_log src 0

        EventLogSearch=$(egrep "Process launched: sp_desvr|Opened Compare session" $AUTO_SRC_E_LOG_RECENT)

        
        # See if string was found. If so, return true.
        [[ -n "$EventLogSearch" ]] && {
            return $TRUE
            LogFunctEnd $0 "$@"
        } 

        # String not found. Recheck after short sleep
       LogIt "sp_desvr not found in $AUTO_SRC_E_LOG_RECENT....rechecking in 3 seconds."
       Counter=`expr $Counter + 1`
       sleep 3

    done

    LogFunctEnd $0 "$@"

    # If we get this far, string was not found. Return false.
    return $FALSE

}

function splex_compare {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    LogFunctStart $0 "$@"

    debug_pause 1

    typeset ValArgPat="$# == 2 || $# == 3"
    typeset UseMsg="usage: $0 splex_command expected_result [ Timeout for compare to complet in 3 sec intervals]" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset SpoCmd=$1
    typeset ExpResult=$(UpperCase "$2")
    typeset TimeOut=${3:-"600"}

    # Default to pass
    [[ "$ExpResult" == "FAIL" ]] && ExpResult="FAIL" || ExpResult="PASS"


    # Clean up any previous compares
    cleanup_compare_procs src 0
    cleanup_compare_procs dst 0

    # REplaced send with using sp_ctrl on automation box due to to manny problems with expet/telnet/sp_ctrl
    #send src 0 "show compare" log
    #send src 0 "remove log compare all" log

    _SPCTRL_CmdLocToRemote src 0 "show compare"
    _SPCTRL_CmdLocToRemote src 0 "remove log compare all"

    #11/15/12 Ilya added "remove log compare all" on target for SPO version > 8.0
    if ([[ $AUTO_DST_BASE_VERSION > 8.0 ]] || [[ $AUTO_DST_BASE_VERSION = 8.0 ]]) ; then
     _SPCTRL_CmdLocToRemote dst 0 "remove log compare all"
    fi

    # execute the compare
    SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "$SpoCmd")
    LogIt "$SpctrlOut"

    # June 20, 2008 - Commented out because event_log structure changes in 6.1.85. This was causing the function to fail
    #get_string src 0 "$AUTO_SRC_VAR_DIR/log" "event_log" "Process launched: sp_desvr" PASS email

    # June 21, 2008
    # if process not in event_log, then fail
    # versions < 6.1.85 use "Process launched: sp_desvr". Versions >= 6.1.85 use "Compare server launched"
    #get_event_log src
    #EventLogSearch=$(egrep "Process launched: sp_desvr|Compare server launched" $AUTO_SRC_E_LOG_HIST)
    ! _CheckSpdesvrEventLog && {
        LogIt "Failed:: Process launched: sp_desvr or Compare server launched NOT found in event_log on source"
        SendEMail "Failed:: Process launched: sp_desvr or Compare server launched NOT found in event_log on source"
    } || {
        LogIt "Passed:: Process launched: sp_desvr or Compare server launched found in event_log on source"
    }

    # run new wait for compare
    if [[ "$AUTO_SRC_OS" != "Windows 2012R2 Server" ]] || [[ "$AUTO_DST_OS" != "Windows 2012R2 Server" ]]; then
    wait_for_compare
    fi

    #copy_compare_logs dst 0

    # Wait till SPO says compare is done
    get_string_spctrl src 0 "status" "Compare Svr" FAIL email "$TimeOut"
    get_string_spctrl dst 0 "status" "Compare Clnt" FAIL email "$TimeOut"

    # Wait till the SPO process are gone
    if [[ "$AUTO_SRC_OS" != "Windows 2012R2 Server" ]] || [[ "$AUTO_DST_OS" != "Windows 2012R2 Server" ]]; then
      # 2-16-2016 Julia change path to user .app-modules instead of bin
      # wait_for_process src 0 "ps -ef | grep $AUTO_SRC_OPT_DIR/bin/sp_desvr"
      # wait_for_process dst 0 "ps -ef | grep $AUTO_DST_OPT_DIR/bin/sp_declt"
      wait_for_process src 0 "ps -ef | grep $AUTO_SRC_OPT_DIR/.app-modules/sp_desvr"
      wait_for_process dst 0 "ps -ef | grep $AUTO_DST_OPT_DIR/.app-modules/sp_declt"
    fi

    # Look for error messages
    get_string_spctrl src 0 "show compare" Running FAIL email
    get_string_spctrl src 0 "show compare" Error FAIL email 5
    #Ilya 103112 skip below line for SPO>8.0
    #get_string_spctrl src 0 "show compare" Unknown FAIL email

   if [[ $AUTO_SRC_BASE_VERSION < 8.0 ]] ; then 
    get_string_spctrl src 0 "show compare" Unknown FAIL email
   fi


    # If expected to pass, then expect it to be in sync
    [[ "$ExpResult" == "PASS" ]] && {

        SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "show compare")
        #Ilya 103112 skip "Unknown" from below line for SPO>8.0
        #print "$SpctrlOut" | grep -P "Out Sync|Error|Running|Unknown"
        if [[ $AUTO_SRC_BASE_VERSION < 8.0 ]] ; then
         print "$SpctrlOut" | grep -P "Out Sync|Error|Running|Unknown"
        else 
         print "$SpctrlOut" | grep -P "Out Sync|Error|Running"
        fi
        retVal=$?

        if [[ "$retVal" == "$TRUE" ]]; then
            LogIt "Failed:: Out Sync, Error, Running, or Unknown found in show compare" 
            copy_compare_logs src 0
            copy_compare_logs dst 0
        fi

        # This will pause automation if OOS is found
        if [[ -n "$AUTO_STOP_ON_OOS" ]]; then

            if [[ "$retVal" == "$TRUE" ]]; then
                LogIt "Failed:: Out Sync, Error, Running, or Unknown found in show compare" 
                print "AUTO_STOP_ON_OOS was set and an OOS was detected"
                print "Automation is paused." 
                print "Press return to continue running automation or CTL+C to abort."
                read x
            fi
        fi

    } || {
        # If expected to fail, then expect it to be out of sync
        get_string_spctrl src 0 "show compare" "Out Sync" PASS email 5
    }

    SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "show compare")
    LogIt "$SpctrlOut"

    SpctrlOut=$(_SPCTRL_CmdLocToRemote src 0 "show compare detail")
    LogIt "$SpctrlOut"

    LogFunctEnd $0 "$@"

    debug_pause 1
}


function copy_compare_logs {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2

    set_oracle_env $HostType $HostId

    # logs
    typeset Cmd="cp -p $this_vardir/log/*-*.log $this_vardir/save_log"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    # sql files
    typeset Cmd="cp -p $this_vardir/log/*-*.sql $this_vardir/save_log"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    LogFunctEnd $0 "$@"

}

function jdbc_compare {
 [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset JdbcStatus     # status of JDBC compare
    mkdir -p $AUTO_WORK_DIR/jdbc_compare/log

    #cleanup_jdbc_log
    find $AUTO_WORK_DIR/jdbc_compare/log/* -mmin +1440 -exec rm {} \;
 
    export JDBC_COMPARE_VARDIR=$AUTO_WORK_DIR/jdbc_compare


    if [ "$AUTO_ORACLE_RAC" == 0 ]; then 

      typeset sRac=${AUTO_SRC_SID%?}    #pass in RAC service name as JDBC compare needs it for RAC connection
      LogIt "AUTO_ORACLE_RAC= $AUTO_ORACLE_RAC,  Starting jdbc_compare `date` srac=$sRac"

         if [[ -n $AUTO_PG_PORT ]]; then 
            Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac tport=$AUTO_PG_PORT) 
            JdbcStatus=$?

	    LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac tport=$AUTO_PG_PORT"

        elif [[ "$AUTO_DST_DBTYPE" == "hana" ]]; then 
            Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac tpwd=$AUTO_DST_SP_PWD rtrim) 
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac tpwd=$AUTO_DST_SP_PWD rtrim"

        elif [[ "$AUTO_DST_DBTYPE" == "mysql" ]]; then
            Output=$(java -Xms4g -Xmx4g -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -Xms4g -Xmx4g -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim"
        elif [[ "$AUTO_DST_DBTYPE" == "teradata" ]]; then
            Output=$(java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=${spadmin} tpwd=${spapass} tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=${spadmin} tpwd=${spapass} tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim"
        else
            Output=$(java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE srac=$sRac rtrim"

        #else
        #    Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac) 
        #    JdbcStatus=$?

	#    LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE srac=$sRac"

        fi
  
 
   else

         if [[ -n $AUTO_PG_PORT ]]; then 
            Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE tport=$AUTO_PG_PORT) 
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE tport=$AUTO_PG_PORT"

         elif [[ "$AUTO_DST_DBTYPE" == "hana" ]]; then 
            Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE tpwd=$AUTO_DST_SP_PWD rtrim) 
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE tpwd=$AUTO_DST_SP_PWD rtrim"

         elif [[ "$AUTO_DST_DBTYPE" == "mysql" ]]; then
            Output=$(java -Xms4g -Xmx4g -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -Xms4g -Xmx4g -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE rtrim"
         elif [[ "$AUTO_DST_DBTYPE" == "teradata" ]]; then
            Output=$(java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=${spadmin} tpwd=${spapass} tdb=$AUTO_DST_DBTYPE rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=${spadmin} tpwd=${spapass} tdb=$AUTO_DST_DBTYPE rtrim"
         else
            Output=$(java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE rtrim)
            JdbcStatus=$?

            LogFunctEnd $0 "java -jar $AUTO_NEW_JDBC_DIR/JDBC_compare.jar config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP shost=$AUTO_SRC_HOST_NAME sdb=$AUTO_SRC_DBTYPE suser=$AUTO_SRC_SP_USER spwd=$AUTO_SRC_SP_USER tuser=$AUTO_DST_SP_USER tpwd=$AUTO_DST_SP_USER tdb=$AUTO_DST_DBTYPE rtrim"

         #else 
         #   Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE) 
         #   JdbcStatus=$?

         #   LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE"

         fi 


    fi

    LogIt "$Output"
    LogIt "JDBCexitStatus:"
    LogIt "$JdbcStatus"

      case $JdbcStatus in
          0) LogIt "Passed:: JDBC_compare In-Sync"
         ;;
          8) LogIt "Failed:: JDBC_compare Out-Sync"
         ;;
          *) LogIt "Failed:: $0 encountered errors while running java"
         ;;
      esac
    debug_pause 1

}

function jdbc_compare_orig {

    typeset JdbcStatus     # status of JDBC compare

    mkdir -p $AUTO_WORK_DIR/jdbc_compare/log
    # Clean up any previous jdbc log files
    #cleanup_jdbc_log
    find $AUTO_WORK_DIR/jdbc_compare/log/* -mmin +1440 -exec rm {} \;

    export JDBC_COMPARE_VARDIR=$AUTO_WORK_DIR/jdbc_compare

    LogIt "Starting jdbc_compare `date`"
    Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE)

    JdbcStatus=$?


      case $JdbcStatus in
          0) LogIt "Passed:: JDBC_compare In-Sync"
         ;;
          8) LogIt "Failed:: JDBC_compare Out-Sync"
         ;;
          *) LogIt "Failed:: $0 encountered errors while running java"
         ;;
      esac

        LogIt "$Output"
        LogFunctEnd $0 "$@"

    debug_pause 1

}



function jdbc_compare_rtrim {

    typeset JdbcStatus     # status of JDBC compare rtrim
    typeset sRac=${AUTO_SRC_SID%?}    #pass in RAC service name as JDBC compare needs it for RAC connection

    mkdir -p $AUTO_WORK_DIR/jdbc_compare/log
    # Clean up any previous jdbc log files
    #cleanup_jdbc_log
    find $AUTO_WORK_DIR/jdbc_compare/log/* -mmin +1440 -exec rm {} \;

    export JDBC_COMPARE_VARDIR=$AUTO_WORK_DIR/jdbc_compare

    LogIt "Starting jdbc_compare rtrim `date` srac=$sRac"

    [[ "$AUTO_ORACLE_RAC" == "$TRUE" ]] && {
    Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE srac=${sRac} tdb=$AUTO_DST_DBTYPE rtrim)
    } || {
    Output=$(java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE rtrim)
    }

    JdbcStatus=$?

    LogIt "$Output"
    LogFunctEnd $0 "java -jar $AUTO_REMOTE_SCRIPT_DIR/JDBC_compare.jar   env=$AUTO_ENV_DIR/$AUTO_ENV_FILE config=$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP sdb=$AUTO_SRC_DBTYPE tdb=$AUTO_DST_DBTYPE"

      case $JdbcStatus in
          0) LogIt "Passed:: JDBC_compare_rtrim In-Sync"
         ;;
          8) LogIt "Failed:: JDBC_compare_rtrim Out-Sync"
         ;;
          *) LogIt "Failed:: $0 encountered errors while running java"
         ;;
      esac


    debug_pause 1

}


###############################################################################
# waits for SPO compare to complete
###############################################################################
function wait_for_compare {

    LogFunctStart $0 "$@"

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    x=$TRUE

    typeset DesrvFileSize=0
    typeset SleepTime=5

    typeset Process="sp_desvr"
    #typeset Process="sp_cop"

    while (( x==$TRUE )); do 

        sleep $SleepTime

        _IsRemoteProcessRunning "src" 0 "$this_proddir.*$Process"
        #_IsRemoteProcessRunning "src" 0 "$Process"
        ProcCheck=$?

        if [[ $ProcCheck != $TRUE ]]; then
            print "\n$Process NOT running" 
            break
        fi

        _GetRemoteFileSize src 0 "$this_vardir/log/*desvr*.log"
    
        if [[ "$GET_REMOTE_FILE_SIZE" != "$DesrvFileSize" ]]; then
            
            print "\n$Process running"
            continue
        else
            print "ERRORS IN COMPARE"
            break
        fi

        DesrvFileSize="$GET_REMOTE_FILE_SIZE"
        
    done

   LogFunctEnd $0 "$@"

}

###############################################################################
# Gets the size of a remote file. The size is exported to GET_REMOTE_FILE_SIZE
###############################################################################
function _GetRemoteFileSize {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset File=$3

    set_oracle_env $HostType $HostId

    typeset Cmd="echo SIZE=\`ls -l $File | awk '{print \$5}'\`"

    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    FileSize=$(print "$Output" | grep -v "echo" | grep SIZE=)
    FileSize=${FileSize##SIZE=}

    export GET_REMOTE_FILE_SIZE="$FileSize"

}


###############################################################################
# Returns 0 or 1 if the process is running or not on remote machine
###############################################################################
function _IsRemoteProcessRunning {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Process=$3

    set_oracle_env $HostType $HostId

    typeset Cmd="ps -ef | grep $Process"

    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    print "$Output" | grep $Process | grep -v "grep" > /dev/null

    return $?

}


###############################################################################
#                          INTERNAL FUNCTIONS
###############################################################################

function _Funct_Template {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    LogFunctStart $0 "$@"

    debug_pause 1

    typeset ValArgPat="$# == 4 || $# == 5" 
    typeset UseMsg="usage: $0 src|dst HostId Remote_Path Local_File" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

   LogFunctEnd $0 "$@"

   debug_pause 1
}


# ==============================================================================
# UpperCase(String):
# Convert the given string to upper case
# ==============================================================================
function UpperCase {
    print $1 | tr [:lower:] [:upper:]
}


# ==============================================================================
# _GetOraPwd(Uid):
# This is mainly for setting sys or system password.
# This returns(prints) the password if sys or system given. 
# All others just print the Uid given
# ==============================================================================
function _GetOraPwd {

    typeset Uid=$1

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

#    UpperUid=$(UpperCase $Uid)

#    if [[ "$UpperUid" == "SYSTEM" ]]; then 
    if [[ "$Uid" == "SYSTEM" ]]; then 
        print $AUTO_SYSTEM_PWD

    elif [[ "$Uid" == "system" ]]; then 
        print $AUTO_SYSTEM_PWD

    elif [[ "$Uid" == "SYS" ]]; then
        print $AUTO_SYS_PWD

    elif [[ "$Uid" == "sys" ]]; then
        print $AUTO_SYS_PWD

    #parse out pwd=PassWord strings
    elif [[ "$Uid" = +(pwd=*) ]]; then
        Pwd=$(_GetEqualString "$Uid")
        print "$Pwd"
    else

        print $Uid

    fi

}



# ==============================================================================
# Substitutes a sub string in string with a new sub string
# ==============================================================================
function _ChangeSubString {

    typeset OldString=$1
    typeset OldSub=$2
    typeset NewSub=$3

    # Return original string if sub string not found
    [[ "$OldString" = *(*$OldSub*) ]] || {
        print "$OldString"
        return 0
    }

    First=${OldString%%$OldSub*}
    Last=${OldString##*$OldSub}
    NewString="$First$NewSub$Last"

    print "$NewString"

    return 0
}


# ==============================================================================
# Name: _InitGlobalArray
# Splits the given string(1st argument) by the given delimiter(2nd argument) and
# assignes it to the AUTO_GLOBAL_ARRAY
# ==============================================================================
function _InitGlobalArray {

    typeset List=$1
    typeset Delim=$2

    OIFS=$IFS && IFS=$Delim # Save old IFS and intialize it to new

    # Initialize and export global array
    set -A AUTO_GLOBAL_ARRAY $List
    export AUTO_GLOBAL_ARRAY

    IFS=$OIFS  # Set IFS back to what it was

}


###############################################################################
# This function will return true if the given string doesn't have any usefull
# data. For example, if string is blank it will return True
###############################################################################

function _IsJunk {

    typeset String=$1

    [[ -z $String ]] && return $TRUE
    [[ "$String" == "^M" ]] && return $TRUE

    return $FALSE
}

################################################################################
# _ValHostType - Internal function for testing a value to make sure it is 
#                     a proper host type. If not then an email is send and the
#                     test case fails.
#
# Input: FunctName = Name of calling function
#        HostType  = Type of host, this is the value being validated
#        UseMsg    = The usage message for the calling function
################################################################################
function _ValHostType {

    typeset FunctName=$1
    typeset HostType=$2
    typeset UseMsg=$3

    # Variable that holds the subject for failure email
    typeset EmailSub="ERROR: $AUTO_CURRENT_TEST has a syntax error"

    # Variable that holds the body for the failure email
    typeset EmailBody="Host type argument to $FunctName must be \"src\" or \"dst\".\n"
    EmailBody="${EmailBody}You have: $HostType\n"
    EmailBody="${EmailBody}$UseMsg\nPlease fix this testcase immediatly."
    EmailBody="${EmailBody}\nTest case marked as Failed"

    # Variable that holds the failure message printed to log and term
    typeset FailMsg="Failed:: splex.$FunctName : arguments must be \"src\""
            FailMsg="${FailMsg} or \"dst\", not \"$HostType\""

    # Validate the the host type. Fail testcase and send email if invalid
    if [[ "$HostType" != ?(src|SRC|dst|DST) ]]; then
        LogIt "$FailMsg"
        LogIt "$UseMsg"
        SendEMail "${EmailSub}" "${EmailBody}"
        return $FALSE
    fi
   
    return $TRUE
}



################################################################################
# _ExecSql - Internal function for executing sql commands.
#            Sqlplus is run in silent mode.
#            Output of sql is printed and my be captured by calling the function
#            like: Output=$(_ExecSql User Pwd TNS "select * from foo").
#            The return code of sqlplus is returned by the function. 
#
# INPUT: OracleUser OraclePassword DB_ServiceName SqlCommand
#
################################################################################
function _ExecSql {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Set arguments to local variables
    typeset User=$1
    typeset Pwd=$2
    typeset Service=$3
    typeset Sql=$4

    # Other local variables
    typeset Output          # Output of sqlplus
    typeset ReturnCode      # Return value of sqlplus
    typeset SqlPlus         # String used to start sqlplus

    # If user is system need to use system password
    #UpperUid=$(UpperCase $Uid)
    #[[ "$UpperUid" == "SYSTEM" ]] && Pwd="$AUTO_SYSTEM_PWD"

    # TODO: add more options for starting. Silent is only way right now
    # 3-25-2014 Julia: If user is sys need to connect as sysdba
    UpperUser=$(UpperCase $User)
    if
        [[ "$UpperUser" == "SYS" ]]; then
        SqlPlus="sqlplus -s  $User/$Pwd@$Service as sysdba"
    else
        SqlPlus="sqlplus -s $User/$Pwd@$Service"
    fi


# Execute the script in sqlplus
Output=`$SqlPlus <<HERE
${Sql}
exit 0
HERE`

    ReturnCode=$?          # Store the return code of sqlplus

    print "${Output}"      # Print the output of the sql command

    return $ReturnCode     # return the return code of sqlplus


}


################################################################################
# This function was created to work with the many changes being made to sp_ctrl
# in 6.X+. 
################################################################################
function _Set_SPO_60_LOC_OPTDIR {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Get the source spo ver and split it up
    _InitGlobalArray "$AUTO_SRC_SPO_VER" "."
    SrcNum1="${AUTO_GLOBAL_ARRAY[0]}"
    SrcNum2="${AUTO_GLOBAL_ARRAY[1]}"
    SrcNum3="${AUTO_GLOBAL_ARRAY[2]}"
    SrcNum4="${AUTO_GLOBAL_ARRAY[3]}"

    # 6.0.x use 5.x sp_ctrl
    [[ ! -n $SrcNum4 ]] && { 
        OptDir=$AUTO_LOC_OPT_DIR_60
        export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_60
        print "$OptDir"
        return 1
    }

    # 6.0.0.x to 6.0.0.200 use lowest 6.0.0
    [[ $SrcNum4 < 201 ]] && { 
        OptDir=$AUTO_LOC_OPT_DIR_600
        export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_600
        print "$OptDir"
        return 1
    }
    

    # 6.0.0.201+ use 6.0.0.201 sp_ctrl
    [[ $SrcNum4 > 200 ]] && { 
        OptDir=$AUTO_LOC_OPT_DIR_600201
        export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_600201
        print "$OptDir"
        return 1
    }

}


function _SPCTRL_CmdLocToRemote {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Set local vars to values of arguments passed in
    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3
    typeset Cmd2=$4

    set_oracle_env $HostType $HostId 1

    # set local vars to globals set in set_oracle_env for readablity of code
    typeset Host=$this_hostname
    typeset Port=$AUTO_SPO_PORT
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset SpoVer=$this_spo_ver

    # Other local vars
    typeset OptDir # will be set to local SPO opt dir depending on SPO version

    # Set local SPO opt dir and export var depending on SPO version
    case $SpoVer in

        4*)
            OptDir=$AUTO_LOC_OPT_DIR_45
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_45
            Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`
            typeset Status=$?
            print "$Output"
        ;;

        5*)
            OptDir=$AUTO_LOC_OPT_DIR_50
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_50
            Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`
            typeset Status=$?
            print "$Output"
        ;;

        6*)
            #All 6.0.x to GA version 6.0.0.230
            OptDir=$AUTO_LOC_OPT_DIR_600201
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_600201
            Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`
            typeset Status=$?
            print "$Output"
        ;;

        7.6*)
            #All 7.6.x 
            OptDir=$AUTO_LOC_OPT_DIR_76
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_76
            Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`
            typeset Status=$?
            print "$Output"
        ;;

        7*)
            #All 7.0.x to 7.0.0.12
            OptDir=$AUTO_LOC_OPT_DIR_70
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_70
            Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`
            typeset Status=$?
            print "$Output"
        ;;

    #9-27-2012 Julia added for 8.0
    #10-8-2012 Julia change from using AUTO_LOC_OPT_DIR_70 to AUTO_LOC_OPT_DIR_76 since 'show compare' does not work with 8.0
    #10-8-2012 Julia: together with this change, change all 'show compare' command to 'job status' to adopted to 8.0 compare status change 
    #9-10-2013 Julia & Thang: change to use 8.0 sp_ctrl for 8.0 from spql04 (64bit spo installed)
    #3-25-2014 Julia switch to use 8.5 sp_ctrl for 8.x. to support 8.5 new compare command incl option 
    #4-29-2015 Julia previous 8.5 sp_ctrl is 8.6.18, install 8.6.2.43 (862 ga) into 86 dir and start using 8.6.2.43 sp_ctrl
    #2-29-2016 Julia change 8*) to *)
    #7-01-2016 Julia change * OptDir to AUTO_LOC_OPT_DIR_90, use 9.0 sp_ctrl to be able to "view partitions all" and it should be backward compatible
    #    8*)
          *)
            #All 8.x and up
            #OptDir=$AUTO_LOC_OPT_DIR_85
            #OptDir=$AUTO_LOC_OPT_DIR_86
            OptDir=$AUTO_LOC_OPT_DIR_90
            export SP_SYS_VARDIR=$AUTO_LOC_VAR_DIR_90
            if [ "$Cmd" = "show compare" ]; then
               #Output=`$OptDir/bin/sp_ctrl compare status on $Uid/$Pwd@$Host:$Port 2>&1`
               Output=`$OptDir/bin/sp_ctrl  job status full on $Uid/$Pwd@$Host:$Port 2>&1`
               typeset Status=$?
               print "$Output"

            elif [ "$Cmd" = "show compare detail" ]; then
               #Output=`$OptDir/bin/sp_ctrl job status all on $Uid/$Pwd@$Host:$Port 2>&1`
               #typeset Status=$?
               #print "$Output"
               print "Show compare detail command ignored. Command show compare from 7.6.3 remote sp_ctrl  on 8.0 host returns --No active or completed comparisons to show"
            elif [ "$Cmd" = "remove log compare all" ]; then
               #Output=`execute src 0 "$Cmd"`
                if [ "$PLATFORM" == "$UNIX" ]; then
                	Output=`execute $HostType $HostId "$Cmd"`
                	typeset Status=$?
                	print "$Output"
      	  	else 
		        Output=`$OptDir/bin/sp_ctrl  clear status all on $Uid/$Pwd@$Host:$Port 2>&1`	
                	typeset Status=$?
                	print "$Output"
      	 	fi
            else
               Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port $Cmd2 2>&1`
               typeset Status=$?
               print "$Output"
            fi
        ;;


    esac

    # execute the command in sp_ctrl
    #Output=`$OptDir/bin/sp_ctrl $Cmd on $Uid/$Pwd@$Host:$Port 2>&1`

    #typeset Status=$?

    #print "$Output"

    # If the flag set to ignore cop is set, then check output
    # for message about cop not running. This is so the function
    # will always return true if cop is not running
    [[ -n "$AUTO_IGNORE_NO_COP" ]] && {
           #   [[ "$Output" = +(*sp_cop*is not running*) ]] && {
        LogIt "$Output"
        LogIt "Notice:: sp_cop is not running on $Host."
        LogIt "\tAUTO_IGNORE_NO_COP is on."
        Status=$TRUE
     }

    return $Status
}



function _ValFileExists {

    typeset FunctName=$1
    typeset File=$2

    ChkFile=$(ChkFileExists "$File") || {  

        print "$ChkFile"
        print "$File could not be found"
        LogIt "Failed:: splex.$FunctName : $File Not Found "

        SendEMail "Error: splex.$FunctName : $File Not Found" \
                  "$ChkFile\nTestcase marked as Failed"
                  
        return $FALSE
    }

    return $TRUE
}

function _ValNumArgs {

    typeset FunctName=$1
    typeset Pattern=$2
    typeset UsageMsg=$3


    typeset EmailSub="ERROR: $AUTO_CURRENT_TEST has a syntax error"

    typeset EmailBod="$FunctName has invalid # arguments passed to it."
    EmailBod="${EmailBod}\n$UseMsg"
    EmailBod="${EmailBod}\nTest case marked as Failed"
    EmailBod="${EmailBod}\nPlease fix this testcase"

    if (( $Pattern )); then
        return $TRUE
    else
        LogIt "Failed:: splex.$FunctName : invalid # of arguments"
        LogIt "$UsageMsg"

        SendEMail "$EmailSub" "$EmailBod"

        return $FALSE
    fi
    

}


function _GetTabCount {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset Tns=$1
    typeset Uid=$2
    typeset Pwd=$3
    typeset Tab=$4

    typeset SqlCmd="select 'result=' || count(*) from $Tab;"

    # The row count
    typeset Count 

    Output=$(_ExecSql $Uid $Pwd $Tns "$SqlCmd") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }
  
    # Return false if oracle errors
    print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
        print "$Output"
        return $FALSE 
    }

    Count=${Output#*result=} # Extract the number of rows
    print "$Count"

    return $TRUE
    
}

# Returns 0 if array contains the given search string. Or returns 1
# if array does NOT contain the given search string
#
# NOTE: IMPORTANT!!!
#   The array it will search is called AUTO_GLOBAL_ARRAY. Your array
#   you MUST initialize and export an array called AUTO_GLOBAL_ARRAY
function _IsInArray {

    # MUST INITIALIZE AN EXPORTED ARRAY CALLED "AUTO_GLOBAL_ARRAY"!!!

    typeset Search=$1

    typeset i=0

    while (( $i < ${#AUTO_GLOBAL_ARRAY[*]} )); do
        [[ "${AUTO_GLOBAL_ARRAY[$i]}" == "$Search" ]] && return $TRUE
        ((i=$i + 1))
    done

    return $FALSE
}
# Starts sqlplus in a coprocess with "p" as I/O descriptor
# Note: redirect "p" before starting more than one sqlplus session
# sqlplus must be kicked off before calling this
function _CoProcConnSqlPlus {

    typeset In=$1
    typeset Out=$2
    typeset Uid=$3
    typeset Pwd=$4
    typeset Tns=$5

    # Connect to the remote database or return 0 and print oracle errors
    Output=$(_CoProcExecSql "$In" "$Out" "connect $Uid/$Pwd@$Tns") || {
        print "$Output"
        return $FALSE
    }

    return $TRUE

}

# Checks a string for Oracle errors
# Returns 0 if no errors found
# Returns 1 if errors found. Errors are printed to term
function _GetOraErr {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset DataToChk=$1

    typeset OraErrs
    
    OraErrs=`print $DataToChk | egrep "(ORA-|SP3-|PLS-|SQL-|SLL-|TNS-)"` && {
        print "$OraErrs"
        return $TRUE # Return 1, errors found
    }

    # Return 0, no errors found
    return $FALSE

}

function _CoProcExecSql {

    typeset In=$1   # Co-process's STDIN
    typeset Out=$2  # Co-process's STDOUT
    typeset Sql=$3  # The sql command(s)

    print -$In "$Sql"            # Send sql to co-process
    print -$In "prompt marker1"  # Place marker on output

    typeset OraErrFlag="$FALSE"

    # Get the output of the sql command
    while read -$Out Line; do 
  
        # Evaluate the line from sqlplus
        case "$Line" in

            # When the marker is read then we are done
            marker1 ) break ;;

            # If Oracle errors
            ORA-* | SP2-* | PLS-* | SQL-* | SLL-* | TNS-* )
                OraErrFlag="$TRUE"  # Set flag indicting error
            ;;

        esac 

        print - "$Line"             # Print all lines

    done

    # Return false if oracle errors occurred
    if [[ "$OraErrFlag" == "$TRUE" ]]; then
        return $FALSE
    else
        return $TRUE
    fi

}



###############################################################################
# Parses out the owner name of a string with owner.object_name
###############################################################################
function _GetObjOwner {

    typeset OwnerObject=$1
    typeset Owner=${OwnerObject%%.*}

    #Print and return true if the owner was parsed
    [[ -n "$Owner" ]] && {
        print "$Owner"
        return $TRUE
    } || {
        return $FALSE
    }
   
}


###############################################################################
# Parses out the right side of a string with equals sign (This=That, returns "That")
###############################################################################
function _GetEqualString {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
    typeset InString=$1
    typeset Result=${InString##*=}

    [[ -n "$Result" ]] && { 
        print "$Result"
        return $TRUE
    } || {  
        return $FALSE
    }

}

###############################################################################
# Parses out the object name of a string with owner.object_name
###############################################################################
function _GetObjName {

    typeset OwnerObject=$1
    typeset Name=${OwnerObject##*.}

    #Print and return true if the object name that was parsed out
    [[ -n "$Name" ]] && {
        print "$Name"
        return $TRUE
    } || {
        return $FALSE
    }
   
}


###############################################################################
# Gets the Oracle object id for the given owner.object_name
###############################################################################
function _GetObjId {

    typeset ObjOwn=$1
    typeset Tns=$2
    typeset Uid=$3
    typeset Pwd=$4

    typeset Owner
    typeset Name
    typeset Sql
    typeset ObjId

    Owner=$(_GetObjOwner "$ObjOwn") || {
        print "$0 Couldn't get obj owner from $Line"
        return $FALSE
    }    
    
    Name=$(_GetObjName "$ObjOwn") || {
        print "$0 Counldn't get obj name from $Line"
        return $FALSE
    }

    # set up sql for getting the object id
    Sql="select 'result=' || obj# from sys.obj$ o, sys.user$ u"
    Sql="${Sql} where o.NAME = upper('$Name') and"
    Sql="${Sql} u.name = upper('$Owner') and u.user# = o.owner#;"

    Output=$(_ExecSql $Uid $Pwd $Tns "$Sql") || {
        LogIt "$0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        return $FALSE
    }
  
    # Return false if oracle errors
    print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
        print "$Output"
        return $FALSE 
    }

    ObjId=${Output#*result=} # Extract the number of rows

    [[ $ObjId = +([0-9]*) ]] || {
        print "$0 Couldn't get object id: $ObjId"
        return $FALSE
    }
    print $ObjId

    return $TRUE
}



function _RunSqlLoader {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
#TODO: still need to handle the other files, maybe make them optional
    typeset Srvc=$1        # tnsname
    typeset Uid=$2         # username
    typeset Pwd=$3         # password
    typeset CtlFile=$4     # Control file
    typeset Direct=$5      # y or n for direct load

    typeset MaxErrors="100"
    typeset LogDir="$AUTO_WORK_DIR"
    typeset LogRoot="$LogDir/$AUTO_TEST_RUN_ID.$AUTO_CURRENT_TEST_ID.$RANDOM.${CtrlFile##/*/}"
    typeset MainLog="$LogRoot.log"
    typeset BadLog="$LogRoot.bad"
    typeset DiscardLog="$LogRoot.dsc"

    # Exports needed by the sqlloader control files
    export CTL_DIR=${CtlFile%/*}    
    export LOG_DIR=$LogDir

    # Build SQL*Loader command
    Cmd="$ORACLE_HOME/bin/sqlldr"
      Cmd="${Cmd} $Uid/$Uid@$Srvc"
      Cmd="${Cmd} silent=HEADER"
      Cmd="${Cmd} control=$CtlFile"
      Cmd="${Cmd} errors=$MaxErrors"
      Cmd="${Cmd} direct=$Direct"
      Cmd="${Cmd} log=$MainLog"
      Cmd="${Cmd} bad=$BadLog"
      Cmd="${Cmd} discard=$DiscardLog"

print "################\n "$Cmd"\n#####################"
    # Execute sqlloader
    $Cmd 2>&1

    # Return the status of Sql*loader 
    return $?

}


function _GetOtestApp {

    typeset OS=$1
    typeset OraVer=$2

    # If it's windows
    if _IsWindows $OS; then
        #print "otest.10.interval" 
        print "otest.10.anydata" 
        return $TRUE
    fi

    # Mid-tier otest is run localy
    [[ -n $AUTO_MID_TIER ]] && {
        print "otest"
        return $TRUE
    }

    # PDB otest is run localy
    [[ -n $AUTO_SRC_PDB ]] && {
        print "otest"
        return $TRUE
    }

    #[[ "$OS" == "hpIT" ]] && {
        #print "otest.itanium"
        #return $TRUE
#
    #}


    # for remote hp machines spe67 and spe68
    [[ $this_hostname = +(spe*) ]] && {
        print "otest"
        return $TRUE
    }

    # Must be Unix/Linux
    case $OraVer in
         7) print "otest.7"  ;;
         8) print "otest.8"  ;;
        8i) print "otest.8i" ;;
        9i) print "otest.9i" ;;
       10g) print "otest.10" ;;
       11g) print "otest.11" ;;
       110) print "otest.11" ;;
       12c) print "otest.11" ;;
         *) return $FALSE
    esac

    return $TRUE

}

function _IsWindows {

    [[ "$1" = +(*(W|w)in*) ]] && return $TRUE || return $FALSE
}


# Returns the directory for otest on Linux platforms
function _GetLinuxOtestPlatform {

    typeset OsString="$1"

    [[ "$OsString" = +(*ia*) ]] && print "linux-ia64" || print "linux"
}


function _GetOtestPlatform {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
    typeset OS=$1

    case $OS in
        SunOS*) 

            if [[ "$OS" = +(*opt*) ]]; then
                print "sunOpt"
            else
                print "sun"  
            fi
        ;; 

        AIX*)         print "aix"   ;;
        Win*)         print "win"   ;;
        OSF1*|Tru64*) print "osf"   ;;
        Linux*)       print $(_GetLinuxOtestPlatform "$OS" ) ;;
        HP-UX*)

            if [[ "$OS" = +(*10*) ]]; then
                print "hp10"

            # HP 11.23 Itanium machines
         #   elif [[ "$OS" = +(*11.23*) ]]; then
            elif [[ "$OS" = +(*ia*) ]]; then
                #print "hpIT"
                print "hp-ia64"

            elif [[ "$OS" = +(*11*) ]]; then
                print "hp11"

            else
                return $FALSE
            fi
        ;;

        *) return $FALSE ;;

    esac

    return $TRUE
}


# ==============================================================================
# Name: wait_4_string
# Waits for a string from sp_ctrl. Returns 0 or 1 if found.
# ==============================================================================
function _wait_4_string {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset HostType=$1
    typeset HostId=$2
    typeset Cmd=$3
    typeset String=$4

    typeset Result
    typeset output

    typeset counter=1
    typeset countermax
    typeset sleeptime=3


    # Set the max counter
    # TODO: just use the last element of argument array
    if [[ $5 = +([0-9]*) ]];then
        countermax=$5
    else
        countermax=600
    fi

    debug_pause 1

    set_oracle_env $HostType $HostId

    typeset Host=$this_hostname
    typeset Uid=$this_spadmin
    typeset Pwd=$this_spapass
    typeset Port=$AUTO_SPO_PORT

    Result=$FALSE
    while (( $Result != $TRUE && $counter <= $countermax )); do
       SpctrlOut=$(_SPCTRL_CmdLocToRemote $HostType $HostId "$Cmd")
       output=`print "$SpctrlOut" | grep "$String"`
       Result=$?
       counter=`expr $counter + 1`
       sleep $sleeptime
    done

    return $Result

}


########################################################################
########################################################################
function BackupParamDB {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"

    set_oracle_env $HostType 0 

    typeset RemoteFile="$this_vardir/data/paramdb"

    # DO NOT EVER DELETE TEMP FILE. _SuiteLogShowParamDB in driverlib needs it
    typeset TmpLocalFile="$AUTO_WORK_DIR/$HostType.parmdb.tmp"

    typeset FinalLocalFile="$AUTO_WORK_DIR/$HostType.parmdb"
    
    get_remote_file "$HostType" "$RemoteFile" "$TmpLocalFile" "ascii"

#juliatde
    grep "SP_COP_WALLET_PATH" $TmpLocalFile > $FinalLocalFile
    grep "SP_SYS_LIC" $TmpLocalFile > $FinalLocalFile
    grep "SP_ORD_LOGIN" $TmpLocalFile >> $FinalLocalFile
    grep "SP_ORD_OWNER" $TmpLocalFile >> $FinalLocalFile
    grep "SP_COP_UPORT" $TmpLocalFile >> $FinalLocalFile
    grep "SP_COP_TPORT" $TmpLocalFile >> $FinalLocalFile
    grep "SP_OPO_TYPE" $TmpLocalFile >> $FinalLocalFile
    grep "SP_OCT_ASM_SID" $TmpLocalFile >> $FinalLocalFile
    grep "SP_OCT_ASM_SUPPORT" $TmpLocalFile >> $FinalLocalFile

    LogFunctEnd $0 "$@"
}


########################################################################
########################################################################
function cleanup_splex {

   [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"
  
    set_oracle_env $HostType 0

    # get the event logs
    get_event_log $HostType
    _WriteEventLogHistory $HostType
    truncate_event_log $HostType 0
    get_trace_log $HostType


    # kill procs
    typeset otest="$AUTO_REMOTE_SCRIPT_DIR/kill_procs.ksh otest"
    typeset sqlplus="$AUTO_REMOTE_SCRIPT_DIR/kill_procs.ksh sqlplus"

    if [[ "$UcHostType" == "SRC" ]]; then
        typeset RootPwd=$AUTO_SRC_ROOT_PWD
    else
        typeset RootPwd=$AUTO_DST_ROOT_PWD
    fi

    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $RootPwd "$otest" 0 1
    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $RootPwd "$sqlplus" 0 1

#    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $AUTO_ROOT_PWD "$otest" 0 1
#    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $AUTO_ROOT_PWD "$sqlplus" 0 1

    # cleanup SPLEX
    $AUTO_EXPECT_DIR/shutdown_cop.exp
    $AUTO_EXPECT_DIR/ora_cleansp

    # remove target vardir/data/*yaml file from jms or target config tests

    # $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $RootPwd "rm ${this_vardir}/data/*yaml" 0 1
    $AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM "root" $RootPwd "rm ${this_vardir}/data/*target_config.yaml" 0 1

    # restore paramdb
    RestoreParamDB $HostType

    # Startup SPLEX
#juliatde    ScriptName=$(_GetStartCopScript "$this_spo_ver")
    ScriptName=$(_GetStartCopScript "$HostType" "$AUTO_SRC_TDE")
    $AUTO_EXPECT_DIR/$ScriptName

    LogFunctEnd $0 "$@"
}

function RestoreParamDB {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"
  
    set_oracle_env $HostType 0


    #typeset File="$AUTO_WORK_DIR/$HostType.parmdb"
    #Changed to use org paramdb that was in place before running suite.
    typeset File="$AUTO_WORK_DIR/$HostType.parmdb.tmp"
    typeset RemoteDir="$this_vardir/data/paramdb"

    RemoteCopyFile $File $this_hostname "$RemoteDir"

    LogFunctEnd $0 "$@"
}

function AddToParamDB {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"
    typeset HostId=$2
    typeset param_name="$3"
    typeset param_value="$4"

    set_oracle_env $HostType 0

    typeset TmpLocalFileAdd="$AUTO_WORK_DIR/$HostType.parmdb.addtmp"
    typeset RemoteFile="$this_vardir/data/paramdb"
	
    get_remote_file "$HostType" "$RemoteFile" "$TmpLocalFileAdd" "ascii"

    sed -i "/$param_name/d" $TmpLocalFileAdd

    echo "$param_name \"$param_value\" " >> $TmpLocalFileAdd
	
    RemoteCopyFile $TmpLocalFileAdd $this_hostname "$RemoteFile"

    LogFunctEnd $0 "$@"
}

########################################################################
# Dumps the local and remote event_logs to history files.
# Useage: _WriteEventLogHistory src|dst
# Note: event_log must already exist on local machine(automation box)
#       Call get_event_log before using this to copy event_log from
#       SPO machine to automation box.
#       This function should always be called  BEFORE truncating event 
#       log.
########################################################################
function _WriteEventLogHistory {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"

    set_oracle_env $HostType 0 

    # Set vars according to host type
    [[ "$HostType" == "src" ]] && {
        typeset ELocalTmpLog="$AUTO_SRC_E_LOG_RECENT"
        typeset ELogHist="$AUTO_SRC_E_LOG_HIST"
    } || {
        typeset ELocalTmpLog="$AUTO_DST_E_LOG_RECENT"
        typeset ELogHist="$AUTO_DST_E_LOG_HIST"
    }
 
    # Dump existing event_log on remote host to it's history file
    typeset Cmd="cat $this_vardir/log/event_log >> $this_vardir/log/event_log.history"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    # Dump event log into the history log on local automation server
    cat $ELocalTmpLog >> $ELogHist

    LogFunctEnd $0 "$@"

}




########################################################################
# This function will get the event_log and trace_log
########################################################################
function get_event_log {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"

    # Set vars according to host type
    [[ "$HostType" == "src" ]] && {
        typeset ELocalTmpLog="$AUTO_SRC_E_LOG_RECENT"
    } || {
        typeset ELocalTmpLog="$AUTO_DST_E_LOG_RECENT"
    }
 
    set_oracle_env $HostType 0 

    typeset ERemoteFile="$this_vardir/log/event_log"

    get_remote_file "$HostType" "$ERemoteFile" "$ELocalTmpLog" "ascii"

    LogFunctEnd $0 "$@"
}

function get_trace_log {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    # Saving trace_log is disabled by default. Export AUTO_SAVE_TRACE_LOG to enable.
    [[ -z "$AUTO_SAVE_TRACE_LOG" ]] && {
        LogIt "Saving trace_log disabled. Export AUTO_SAVE_TRACE_LOG to enable".
        LogFunctEnd $0 "$@"
        return $TRUE
    }

    typeset HostType="$1"

    set_oracle_env $HostType 0 

    #Vars for trace_log
    typeset TRemoteFile="$this_vardir/log/trace_log"
    typeset TLocalTmpLog="$AUTO_WORK_DIR/${AUTO_TESTER}_${this_sid}_${this_hostname}.tlog.tmp"
    typeset TLocalLog="$AUTO_WORK_DIR/$this_hostname.tlog.history"

    # Dump existing trace_log on remote host to it's history file
    typeset Cmd="cat $this_vardir/log/trace_log >> $this_vardir/log/trace_log.history"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    get_remote_file "$HostType" "$TRemoteFile" "$TLocalTmpLog" "ascii"

    # Dump trace log into the history log on local automation server
    cat $TLocalTmpLog >> $TLocalLog

    LogFunctEnd $0 "$@"

}



########################################################################
########################################################################
function get_remote_file {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType="$1"
    typeset RemoteFile=$2   # copy from where on remote hose
    typeset LocalFile=$3    # copy to where on local hose
    typeset TransferMode=$4 # Mode to transfer file (ascii/bin)

    set_oracle_env $HostType 0

    typeset RemoteHost=$1

    # Build command that will get the file
    # TW - April 17, 2008
    # OS uid/pwd was not supposed to use oracle user like below.
    # commented below out and changed to use OS user's info like the block
    # below the commented out block.
    #typeset TransCmd="$AUTO_ROOT_DIR/TransferFile.py $this_hostname"
        #TransCmd="${TransCmd} $this_ora_spadmin $this_ora_spapass"
        #TransCmd="${TransCmd} $RemoteFile $LocalFile"
        #TransCmd="${TransCmd} get $TransferMode"

    # Build command that will get the file
    #typeset TransCmd="$AUTO_ROOT_DIR/TransferFile.py $this_hostname"
    typeset TransCmd
    if _IsWindows $PLATFORM; 
    then
       TransCmd="$AUTO_ROOT_DIR/TransferFile.py $this_hostname"
    else
       #os=`/usr/bin/rexec -a -l ${spadmin} -p ${spapass} ${this_hostname} uname -s`
       os=$(_GetOtestPlatform "$this_os")
       if [ "$os" == "aix" ]; 
       then
          TransCmd="$AUTO_ROOT_DIR/TransferFile.py $this_hostname"
       else
          TransCmd="$AUTO_ROOT_DIR/TransferFile_v1.py $this_hostname"
       fi
    fi
        TransCmd="${TransCmd} $this_spadmin $this_spapass"
        TransCmd="${TransCmd} $RemoteFile $LocalFile"
        TransCmd="${TransCmd} get $TransferMode"

    # Execute the command that gets the file
    print "Getting $RemoteFile from $RemoteHost"
    Output=$($TransCmd) || {
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    LogFunctEnd $0 "$@"
    return $TRUE

}



########################################################################
# Kills sp_desvr or sp_declt processes. Searches process for the
# full path to the process and not just the procs name.
# Note: If the proc doesn't exist, kill will get mad and give error.
#   This will be seen when running in debug mode.
########################################################################
function cleanup_compare_procs {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    debug_pause 1

    # Local vars
    typeset Uid="root"
    typeset Pwd="$AUTO_ROOT_PWD"
    typeset ValArgPat="$# == 2"
    typeset UseMsg="usage: $0 src|dst HostId" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType="$1"
    typeset HostId="$2"

    set_oracle_env $HostType $HostId
    UcHostType=$(UpperCase "$HostType")

    # Don't run it on windows
    if _IsWindows $PLATFORM; then
       print "$0 not supported for windows."
       print "exiting $0 function"
       return
    fi

    typeset Script="$AUTO_REMOTE_SCRIPT_DIR/kill_compare_proc.ksh"

    # Issue remote command to kill the compare proc(s)
    if [[ "$UcHostType" == "SRC" ]]; then
        Pwd=$AUTO_SRC_ROOT_PWD
    else
        Pwd=$AUTO_DST_ROOT_PWD
    fi

#    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $Uid $Pwd "$Script $AUTO_SRC_OPT_DIR $AUTO_SPO_PORT sp_declt" 1 1)	
     Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $Uid $Pwd "$Script $this_proddir $AUTO_SPO_PORT sp_desvr" 1 1)
     Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $Uid $Pwd "$Script $this_proddir $AUTO_SPO_PORT sp_declt" 1 1)

 
    # Log the output
    #LogIt "$Output"


    # Need to clear the event_log of SIKILL's if they exist because any check will fail it.
    export AUTO_IGNORE_EVENT_KILL='1'
    check_log_on $HostType $HostId 
    unset AUTO_IGNORE_EVENT_KILL


    # We arn't going to pass or fail this
    LogIt "Neutral:: $0 ran."
    [[ -n "$AUTO_DEBUG" ]] && LogIt "$Output"

    LogFunctEnd $0 "$@"

}


########################################################################
# prints out result of a sql statement
########################################################################
function get_sql_value {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    debug_pause 1

    typeset ValArgPat="$# == 5" 
    typeset UseMsg="usage: $0 src|dst HostId OraUser OraPwd SqlStatement" 

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    #Validate the host type passed in or return  
    _ValHostType $0 "$1" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset HostType=$1
    typeset HostId=$2
    typeset Uid=$3
    typeset Pwd=$4
    typeset Sql=$5

    set_oracle_env $HostType $HostId

 
    # Start SQL*Plus in a co-process
    sqlplus -s /NOLOG |& 

    # Save CO-process PID so we can kill it later if it doesn't die 
    CoProcPID=$!

    Output=$(_CoProcConnSqlPlus "p" "p" $Uid $Pwd $this_tns) || {
        LogIt "$Output"
        LogIt "Failed:: $0 Couldn't connect to $this_tns"
        _KillPID CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    # Setup env
    _CoProcExecSql "p" "p" "set heading off;"

    # Execute the sql
    Output=$(_CoProcExecSql "p" "p" "$Sql") || {
        LogIt "Failed:: $Output"
        _ExitCoProcSql CoProcPID
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    print $Output | grep '.'

    _ExitCoProcSql CoProcPID
 
    LogFunctEnd $0 "$@"

}


########################################################################
# removes all spo config files except the active one
########################################################################
function DeleteConfigs {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    LogFunctStart $0 "$@"

    typeset HostType=${1:-src}
    typeset HostId=0

    set_oracle_env $HostType $HostId

    ActiveCfgName=$(get_active_cfg_name $HostType $HostId) || {
        LogIt "Failed:: $0 couldn't get currently active config"
        LogIt "sp_ctrl reported\n$ActiveCfgName"
        LogFunctEnd $0 "$@"
        return $FALSE
    }


    ListConfigs=$(_SPCTRL_CmdLocToRemote $HostType $HostId "list config") || {
        LogIt "Failed:: $0 couldn't list config on $this_hostname"           
        LogIt "sp_ctrl reported:\n$ListConfigs"
        LogFunctEnd $0 "$@"
        return $FALSE
    }


    # Pull out lines that have "Inactive" in them from list config out put
    InactiveLines=$(print "$ListConfigs" | grep "Inactive") || {

        # Exit function if there are no inactive configs
        [[ -z "$InactiveLines" ]] && {
            LogIt "No Inactive config files to delte."
            LogFunctEnd $0 "$@"
            return $TRUE
        }
    }

    # Pull out just the config file names from the Inactive lines
    InactiveCfgNames=$(print "$InactiveLines" | cut -d" " -f1)

    # Dump config names to file so we can loop in a while loop
    typeset LstCfgFile="$AUTO_WORK_DIR/$this_hostname.InactiveCfgs.txt"
    print "$InactiveCfgNames" > $LstCfgFile

    # Some output.
    LogIt "\n=========================================================="
    LogIt "Inactive config files to be deleted"
    LogIt "=========================================================="
    LogIt "$InactiveCfgNames"
    LogIt "=========================================================="
    LogIt "Note: Config $ActiveCfgName is active and will not be deleted"
    LogIt "==========================================================\n"

    # Delete the config files using sp_ctrl so it's windows compatable
    while read ConfigFileName; do

        Output=$(_SPCTRL_CmdLocToRemote $HostType $HostId "remove config $ConfigFileName") || {
            LogIt "Warning:: $0 couldn't remove config $ConfigFileName on $this_hostname"           
            LogIt "sp_ctrl reported:\n$Output"
        }

        print "$ConfigFileName deleted."

    done < $LstCfgFile

    # Clean up
    rm $LstCfgFile

    LogFunctEnd $0 "$@"

}

########################################################################
# SPLOPPY, poor writen functions that keep messing up my syntax 
# hight lighting
########################################################################


# ==============================================================================
# Name: check_sp_tables_structure
# ==============================================================================
function check_sp_tables_structure {
   
    typeset host_type=$1
    typeset host_id=$2
    typeset sqluser=$3
    
    typeset table
    typeset sp_user
    typeset sp_table
    typeset result
    typeset File
    typeset comp_table_struc_all_file
     
    
    typeset Log=$AUTO_TEST_CASE_LOG
    
    LogFunctStart $0 "$@"
    
    File=${AUTO_SP_TABLES_FILE:-$AUTO_ROOT_DIR/sp_tables_var${this_ora_s_ver}}
    echo "\nUsing $File"

    typeset BaseName="$AUTO_WORK_DIR/$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID.$this_hostname"    
    comp_table_struc_all_file="$BaseName.tab_struct_not_equal"

    remove_if_exist $comp_table_struc_all_file

    debug_pause 1

    . $AUTO_ROOT_DIR/local_sqlplus
    check_oracle $AUTO_SRC_TNS_NAME
    check_oracle $AUTO_DST_TNS_NAME

    # Create DB link if needed
    run_sql_file src 0 qa_create_db_link.sql sp_otest log

    LogIt "check_sp_tables_structure Results"
    LogIt "+++++++++++++++++++++++++++++++++++++++++++++"

    cat $File | while read table; do

        sp_user=`print $table | cut -d. -f1`
        sp_table=`print $table | cut -d. -f2`

x=`sqlplus ${sqluser}/${sqluser}@${AUTO_SRC_TNS_NAME}<<EOF | grep SPACE | sed 's/SPACE//;s/[  ]//g'
        whenever sqlerror exit 1
        ALTER SESSION SET global_names = FALSE;
 
 select 'SPACE' , count(*)
 from
    (
     (
     select table_name, column_name, data_type, data_length, data_precision, nullable
     from all_tab_columns
     where owner = UPPER('$sp_user')
     and table_name = UPPER('$sp_table')
      MINUS
     select table_name, column_name, data_type, data_length, data_precision, nullable
     from all_tab_columns@$AUTO_DST_TNS_NAME
     where owner = UPPER('$sp_user')
     and table_name = UPPER('$sp_table')
     )
     UNION
     (
     select table_name, column_name, data_type, data_length, data_precision, nullable
     from all_tab_columns@$AUTO_DST_TNS_NAME
     where owner = UPPER('$sp_user')
     and table_name = UPPER('$sp_table')
      MINUS
     select table_name, column_name, data_type, data_length, data_precision, nullable
     from all_tab_columns
     where owner = UPPER('$sp_user')
     and table_name = UPPER('$sp_table')
     )
   );

        exit 0
EOF`

        x=`print $x | tr -d [:blank:]`

        if [ "$x" == "0" ]; then
            printf '%-19s %-34s %-10s\n' "Passed::  Structure of" "${sp_user}.${sp_table}" "EQUAL" | tee -a $Log
        else

            if [ -z $x ]; then 
                printf '%-19s %-34s %-50s\n' "Skipped:: Structure of" "${sp_user}.${sp_table}" "NOT ABLE to determine, might contai LOBS or other large object types!" | tee -a $Log else
            else
                printf '%-19s %-34s %-10s\n' "Failed::  Structure of" "${sp_user}.${sp_table}" "NOT EQUAL" | tee -a $Log
                printf '%-19s %-34s %-10s\n' "Failed::  Structure of" "${sp_user}.${sp_table}" "NOT EQUAL" >> $comp_table_struc_all_file
            fi

        fi

    done


    if [ -s $comp_table_struc_all_file ]; then

        SendEMail "Some table structures are not equal between ${AUTO_SRC_TNS_NAME} and ${AUTO_DST_TNS_NAME}" \
                  "in subject" $comp_table_struc_all_file

        LogIt "********************************************"
        LogIt "Some table STRUCTURES are not equal  !!!    "
        LogIt "Please fix these tables before you continue,"
        LogIt "or else some of your tests will fail        "
        LogIt "********************************************"
        PromptUser
    fi
    

    LogFunctEnd $0 "$@"
    debug_pause 1
}

# ==============================================================================
# Gets the name of a table from the table list by the tables order in the list
# ==============================================================================
function _GetTabNameIfNum {

    typeset TabIn=$1

    # If a number was given, then lookup table name by number
    [[ "$TabIn" = *[0-9] ]] && {
        set -A Tables `cat $AUTO_TABLE_LIST`
        TabName=${Tables[$TabIn-1]}
    } || {
        # Use current name since it is not a number
        TabName=$TabIn
    }

    print $TabName

}


# ==============================================================================
# Name: compare_table
# ==============================================================================
function compare_table {

    LogFunctStart $0 "$@"

    # Pattern that validates the arguments
    typeset ValArgPat="$# == 7 || $# == 8"

    # Usage message for function
    typeset UseMsg="usage: $0 src HostId dst HostId SrcTable DstTable OraUser"

    # Validate the number of arguments passed to the function
    _ValNumArgs $0 "$ValArgPat" "$UseMsg" || {
        LogFunctEnd $0 "$@"
        return $FALSE
    }

    typeset src_type=$1
    typeset src_id=$2
    typeset dst_type=$3
    typeset dst_id=$4
    typeset src_tab=$(_GetTabNameIfNum $5)
    typeset dst_tab=$(_GetTabNameIfNum $6)
    typeset sqluser=$7
    typeset ExpResult=${8:-'PASS'}

    debug_pause 1

    set_oracle_env $src_type $src_id

    . $AUTO_ROOT_DIR/local_sqlplus

    check_oracle $AUTO_SRC_TNS_NAME
    check_oracle $AUTO_DST_TNS_NAME

    # Create DB link if needed
    run_sql_file src 0 qa_create_db_link.sql sp_otest log

    print "Comparing $src_tab to $dst_tab" 

    # This is the sql that compares the data in the tables
    typeset SqlCmd="ALTER SESSION SET global_names = FALSE;
       set heading off
       select 'result='|| count(*) from
        (
           ( select * from $src_tab
             minus
             select * from $dst_tab@$AUTO_DST_TNS_NAME )
             union
           ( select * from $src_tab@$AUTO_DST_TNS_NAME
             minus
             select * from $dst_tab )
        );
    "

    # Run the sqlcommand. Return if failed to login to sqlplus
    Output=$(_ExecSql $sqluser $sqluser $this_tns "$SqlCmd") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }
  
    # Result = 0 means no differences in data where found
    if print "$Output" | grep "result=0" >/dev/null ; then

        [[ "$ExpResult" == "PASS" ]] && { 
            LogIt "Passed:: Compare $src_tab to $dst_tab equal"
            LogIt "         Comparison expected to pass"
        } || {

            # Get the table counts
            SrcCount=$(_GetTabCount "$AUTO_SRC_TNS_NAME" "$sqluser" "$sqluser" "$src_tab")
            DstCount=$(_GetTabCount "$AUTO_DST_TNS_NAME" "$sqluser" "$sqluser" "$dst_tab")

            # If both tables have zero records then pass
            if [[ "$SrcCount" == "0" ]] && [[ "$DstCount" == "0" ]]; then
                LogIt "Warning:: Both tables have zero rows"            
            else
                LogIt "Failed:: Compare $src_tab to $dst_tab equal"
                LogIt "         Comparison expected to fail"
           fi 

        }

    # For now all Oracle errors will be considered un-comparable objects
    elif print "$Output" | grep "ORA-" >/dev/null; then
        LogIt "Compare $src_tab to $dst_tab: Not comparable - possible LOBs"

    # Anything else will be considered unequal objects
    else

        [[ "$ExpResult" == "FAIL" ]] && {
            LogIt "Passed:: Compare $src_tab to $dst_tab: NOT equal"
            LogIt "         Comparison expected to fail"
        } || {
            typeset Msg="Compare table $src_tab FAILED in TC# $AUTO_CURRENT_TEST_ID"
            SendEMail "$Msg" "$Msg"
            LogIt "Failed:: Compare $src_tab to $dst_tab: NOT equal"
            LogIt "         Comparison expected to pass"

        }

    fi

    LogFunctEnd $0 "$@"

    debug_pause 1
}
