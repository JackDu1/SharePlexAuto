# 6-01-2015 Julia mstrlib.ksh.v9 change AUTO_SRC_TDE to get TDE setting from vardir/data/connections.yaml instead of from vardir/data/paramdb (for 8.6.3 change since sp_wallet auto-open) 
# 6-23-2015 Julia mstrilb.ksh.v10 change AUTO_SRC_TDE to get TDE for both pre 8.6.3 (paramdb)  and 8.6.3+ (connections.yaml) 
# 8-12-2015 Julia mstrilb.ksh.v11 for Windows not getting AUTO_SRC_TDE from src host, just export SP_SRC_TDE in Windows master suite 
# 8-19-2015  Ilya mstrilb.ksh.v12 added _GetDBType function and AUTO_SRC_DBTYPE and AUTO_DST_DBTYPE params to detect src/trg DB types (oracle!sqlserver|sybase|postgres|unknown)
# 8-19-2015  Ilya mstrilb.ksh.v13 added AUTO_PG_DIR and PgDir
# 11-4-2015 Julia _GetOraCharSet only runs when db is Oracle
# 02-10-2016 Kevin Bai add new master suite variable "typeset TdDir=$RootDir/td_scripts"; "export AUTO_TD_DIR=$TdDir" for Teradata support 
# 02-19-2016 Kbai add support teradata to function _GetDBType
# 02-29-2016 Julia add export SP_TEST_FORCE_DEACT=1 in mstrlib.ksh to support new parameter (de-activate and remove old post queues before new activation) 
# 05-10-2016 Julia for spqlauto1 only, Shareplex on this server is 12c, change LocOptDir86 to 12c; AUTO_LOC_OPT_DIR_86=$LocOptDir86
# 05-24-2016 Julia add SAP HANA support. 1) add HanaDir=$RootDir/hana_scripts; export AUTO_HANA_DIR=$HanaDir
#                                        2) add SAP HANA to _GetDBType
# 06-16-2016 Julia add spo version 9.0 in AUTO_SP_CTRL_INFO
# 07-01-2016 Julia installed SPO 9.0 and set LocOptDir90 to use SPO 9.0 sp_ctrl when source SharePlex version is 9 and up (SPO-2492 "view partitions all")
# 07-13-2016 v24 Julia: change _RAC_check to run against Oracle only
# 07-14-2016 v24 Julia: move _db_securefile and _tblsp_compression under Oracle source when _InitLastGlobalVars 
# 02-10-2017 v26 Candy: add parameters for mysql:AUTO_MYSQL_DIR and AUTO_DST_MYSQL_DB
# 03-02-2017 v27 Candy: add new jdbc compare directory
# 04-21-2017 v28 Candy: add parameters for msstest: AUTO_MSSTEST_PARM_DIR and AUTO_MSSTEST_DIR, add parameters: winadmin and winpasswd.
#
ExecutedMasterSuite=$0

##############################################################################
# Just exporting variables for the sake of declaring them all in one place
##############################################################################
function _InitMstrExp {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    #TODO: IMPORTANT!!! DO THIS BEFORE ROLLOUT!!!!
    #TODO: have all this read from a config file
    #############################################################################
    #             CONFIGURABLE VARIABLES LOCAL TO THIS SCRIPT
    #############################################################################
#    typeset  SuiteStartTime=`date +"%s"` # DO NOT TOUCH THIS ONE

    export spadmin="qarun"
    #export spapass="qarun"
    export spapass=${AUTO_SPO_ADMIN_PWD:-qarun}

    #Windows admin username and password
    export winadmin="administrator"
    export winpasswd="habuqa"

    # REPOSITORY - PRODUCTION
    export AUTO_REP_NAME=${AUTO_REP_NAME:=splexqa}
    export AUTO_REP_UID=${AUTO_REP_UID:=auto}
    export AUTO_REP_PWD=${AUTO_REP_PWD:=auto}
    
    # REPOSITORY - TESTING
    #export AUTO_REP_NAME=${AUTO_REP_NAME:=tim}
    #export AUTO_REP_UID=${AUTO_REP_UID:=auto}
    #export AUTO_REP_PWD=${AUTO_REP_PWD:=auto}
    
    # Directories and files
    typeset RootDir=${AUTO_ROOT_DIR:-/qa/splex/common}
    typeset Expect=$RootDir/expect
    typeset RunsDir=$RootDir/runs
    typeset EnvDir="$RootDir/env"
    typeset TestDir="$RootDir/tests"
    typeset ConfigDir="$RootDir/configs"
    typeset ErrLst="$RootDir/error_list"
    typeset UsersLst="$RootDir/email_list"
    typeset EnvsLst="$RootDir/env_list"
    
    export AUTO_REP_ERROR_FILE="$RootDir/.RepositoryErrors.txt"

    # Directories for loading data files
    typeset LoadRootDir=$RootDir/load  # Root SQL*Loader dir
    typeset LoadCtlDir=$LoadRootDir/ctl # control/data files dir
    typeset LobDir=/spoqa/lob_files  # lobs dir
    typeset LobWinDir=D:\\splex\\load  # Remote windows ora dir for lobs
    typeset RemoteScriptDir="/spoqa/remote_scripts"
    typeset NewJdbcDir="/spoqa/new_jdbc"
    
    typeset XMLDir=$RootDir/xml
    typeset SqlDir=$RootDir/sql_scripts
    typeset MssDir=$RootDir/mss_scripts
    typeset TdDir=$RootDir/td_scripts
    typeset PgDir=$RootDir/pg_scripts
    typeset HanaDir=$RootDir/hana_scripts
    typeset MysqlDir=$RootDir/mysql_scripts
    typeset TestDir="$RootDir/tests"
    typeset LocalOtestDir="/quest/habu-package/otest/linux"
    typeset UnixOtestDir="/quest/habu-package/otest"
    typeset LocalMsstestDir="/msstest"

    typeset LocOptDir45="/splex/SharePlex-4.5.1.248/opt9i"
    typeset LocVarDir45="/splex/SharePlex-4.5.1.248/var9i"
    typeset LocOptDir50="/splex/SharePlex-5.0.0.430/opt9i"
    typeset LocVarDir50="/splex/SharePlex-5.0.0.430/var9i"

    # Changed to use 5.0.0 due to many ongoing changed in 6.x
    #typeset LocOptDir60="/splex/SharePlex-6.0/opt9i"
    #typeset LocVarDir60="/splex/SharePlex-6.0/var9i"
    typeset LocOptDir60="/splex/SharePlex-5.0.0.430/opt9i"
    typeset LocVarDir60="/splex/SharePlex-5.0.0.430/var9i"

    typeset LocOptDir600="/splex/SharePlex-6.0.0/opt9i"
    typeset LocVarDir600="/splex/SharePlex-6.0.0/var9i"

    typeset LocOptDir600201="/splex/SharePlex-6.0.0.201/opt9i"
    typeset LocVarDir600201="/splex/SharePlex-6.0.0.201/var9i"

    typeset LocOptDir70="/splex/SharePlex-7.0/opt9i"
    typeset LocVarDir70="/splex/SharePlex-7.0/var9i"

    typeset LocOptDir76="/splex/SharePlex-7.6/opt11"
    typeset LocVarDir76="/splex/SharePlex-7.6/var11"

    #9-27-2012 Julia added for 8.0
    typeset LocOptDir80="/splex/SharePlex-8.0/opt11"
    typeset LocVarDir80="/splex/SharePlex-8.0/var11"

    #3-25-2014 Julia add for 8.5
    typeset LocOptDir85="/splex/SharePlex-8.5/opt11"
    typeset LocVarDir85="/splex/SharePlex-8.5/var11"

    #4-29-2015 Julia add for 8.6
    typeset LocOptDir86="/splex/SharePlex-8.6/opt11"
    typeset LocVarDir86="/splex/SharePlex-8.6/var11"    

    #7-01-2016 Julia for SPO 9.0 
    typeset LocOptDir90="/splex/SharePlex-9.0/opt11"
    typeset LocVarDir90="/splex/SharePlex-9.0/var11"

    typeset OtestParmDir="$RootDir/otest_param"

    typeset MsstestParmDir="$RootDir/msstest_param"
    
    typeset SuiteTimeFile="$RootDir/.SuiteTimes.dat"
    typeset TestTimeFile="$RootDir/.TestCaseTimes.dat"

    typeset SysPwd=${AUTO_SYS_PWD:-quest4me}
    typeset SystemPwd=${AUTO_SYSTEM_PWD:-quest4me}

    # Set default or over rides Oracle's spadmin users
    typeset SrcOraSpadminUid=${AUTO_SRC_ORA_SPADMIN_UID:-qarun}
    typeset SrcOraSpadminPwd=${AUTO_SRC_ORA_SPADMIN_PWD:-$SrcOraSpadminUid}
    typeset DstOraSpadminUid=${AUTO_DST_ORA_SPADMIN_UID:-$SrcOraSpadminUid}
    typeset DstOraSpadminPwd=${AUTO_DST_ORA_SPADMIN_PWD:-$DstOraSpadminUid}

    # Set default or over rides root's pwd
    typeset RootPwd=${AUTO_ROOT_PWD:-qa4qsft}
    typeset SrcRootPwd=${AUTO_SRC_ROOT_PWD:-qa4qsft}
    typeset DstRootPwd=${AUTO_DST_ROOT_PWD:-$SrcRootPwd}

    # Set default database for PPAS
    typeset DstPpasDb=${AUTO_DST_PPAS_DB:-sp_pg}

    # Set default database for mysql
    typeset DstMysqlDb=${AUTO_DST_MYSQL_DB:-sp_ms}

   #############################################################################
    #                 GLOBAL VARIABLES EXPORTED TO ENVIRONMENT 
    #############################################################################

    #Constants
    export TRUE="0"                 # Alias for return value of 0
    export FALSE="1"                # Alias for return value of 1
    export WINDOWS="Windows_NT"        
    export UNIX="Unix"
    export AUTO_PRODUCT="2"          #1=spo 2=opr
    
    # Constant directories
    export AUTO_ROOT_DIR=$RootDir   # Root automation directory
    export AUTO_EXPECT_DIR=$Expect  # Automation expect directory   
    export AUTO_SQL_DIR=$SqlDir     # Directory for sql scripts
    export AUTO_MSS_DIR=$MssDir     # Directory for mss scripts
    export AUTO_TD_DIR=$TdDir       # Directory for teradata scripts
    export AUTO_PG_DIR=$PgDir       # Directory for postgres scripts
    export AUTO_MYSQL_DIR=$MysqlDir # Directory for mysql scripts
    export AUTO_HANA_DIR=$HanaDir   # Directory for SAP Hana scripts
    export AUTO_TESTS_DIR=$TestDir  # Directory where test lists are kept
    export AUTO_RUNS_DIR=$RunsDir   # Directory for test logs and temp files
    export AUTO_ENV_DIR=$EnvDir     # Directory for environment files
    export AUTO_TESTS_DIR=$TestDir  # Directory for test lists
    export AUTO_CFGS_DIR=$ConfigDir # Directory for configs and lists
    export AUTO_LOCAL_OTEST_DIR=$LocalOtestDir
    export AUTO_MSSTEST_LOCAL_DIR=$LocalMsstestDir
    export AUTO_NIX_OTEST_DIR=$UnixOtestDir
    export AUTO_OTEST_PARM_DIR=$OtestParmDir
    export AUTO_MSSTEST_PARM_DIR=$MsstestParmDir
    export AUTO_LOAD_CTL_DIR=$LoadCtlDir   # control file dir
    export AUTO_LOB_DIR=$LobDir            # Lob directory
    export AUTO_LOB_WIN_DIR=$LobWinDir     # Remote win dir 4 lobs
    export AUTO_REMOTE_SCRIPT_DIR=$RemoteScriptDir
    export AUTO_NEW_JDBC_DIR=$NewJdbcDir
    
    # Constant files
    export AUTO_ERROR_LIST="$ErrLst"
    export AUTO_USERS_LIST="$UsersLst"
    export AUTO_ENVS_LIST="$EnvsLst"
    export AUTO_SUITE_TIMES="$SuiteTimeFile"
    export AUTO_TEST_TIMES="$TestTimeFile"
    export AUTO_WIN_SEND_EXCLUDES="$AUTO_ROOT_DIR/send_win_exclude_list.txt"

    export AUTO_SRC_E_LOG_HIST="" # SPO event_log history files
    export AUTO_DST_E_LOG_HIST="" # these are given values in _InitLastGlobalVars

    export AUTO_SRC_E_LOG_RECENT="" # SPO most current event_log taken from test machine
    export AUTO_DST_E_LOG_RECENT="" # These are given values in _InitLastGlobalVars

    export AUTO_SRC_E_LOG_ERRORS="" # SPO list of errors found in the recent event_log
    export AUTO_DST_E_LOG_ERRORS="" # These are given values in _InitLastGlobalVars

    # Local shareplex directories
    export AUTO_LOC_OPT_DIR_45=$LocOptDir45  # SPO v4.5.x opt dir
    export AUTO_LOC_VAR_DIR_45=$LocVarDir45  # SPO v4.5.x var dir
    export AUTO_LOC_OPT_DIR_50=$LocOptDir50  # SPO v5.0.x opt dir
    export AUTO_LOC_VAR_DIR_50=$LocVarDir50  # SPO v5.0.x var dir
    export AUTO_LOC_OPT_DIR_60=$LocOptDir60  # SPO v6.0.x opt dir
    export AUTO_LOC_VAR_DIR_60=$LocVarDir60  # SPO v6.0.x var dir
    export AUTO_LOC_OPT_DIR_600=$LocOptDir600  # SPO v6.0.0.x to 6.0.0.200 opt dir
    export AUTO_LOC_VAR_DIR_600=$LocVarDir600  # SPO v6.0.0.x to 6.0.0.200 var dir
    export AUTO_LOC_OPT_DIR_600201=$LocOptDir600201  # SPO v6.0.0.201+ opt dir
    export AUTO_LOC_VAR_DIR_600201=$LocVarDir600201  # SPO v6.0.0.201+ var dir
    export AUTO_LOC_OPT_DIR_70=$LocOptDir70          # SPO v7.0 opt dir
    export AUTO_LOC_VAR_DIR_70=$LocVarDir70          # SPO v7.0 var dir
    export AUTO_LOC_OPT_DIR_76=$LocOptDir76          # SPO v7.6 opt dir
    export AUTO_LOC_VAR_DIR_76=$LocVarDir76          # SPO v7.6 var dir
    export AUTO_LOC_OPT_DIR_80=$LocOptDir80          # SPO v8.0 opt dir
    export AUTO_LOC_VAR_DIR_80=$LocVarDir80          # SPO v8.0 var dir
    export AUTO_LOC_OPT_DIR_85=$LocOptDir85          # SPO v8.5 opt dir
    export AUTO_LOC_VAR_DIR_85=$LocVarDir85          # SPO v8.5 var dir
    export AUTO_LOC_OPT_DIR_86=$LocOptDir86          # SPO v8.6 opt dir
    export AUTO_LOC_VAR_DIR_86=$LocVarDir86          # SPO v8.6 var dir
    export AUTO_LOC_OPT_DIR_90=$LocOptDir90          # SPO v9.0 opt dir
    export AUTO_LOC_VAR_DIR_90=$LocVarDir90          # SPO v9.0 var dir


    export AUTO_ORACLE_RAC          # True(1) if rac, false(0) if not
    export AUTO_SRC_HOST_NAME       # Source host name 
    export AUTO_DST_HOST_NAME       # Destination host name
    
    export AUTO_SRC_SID             # Source oracle SID
    export AUTO_DST_SID             # Destination oracle SID
    
    export AUTO_SRC_ORA_HOME        # Source oracle home
    export AUTO_DST_ORA_HOME        # Destination oracle home
    
    export AUTO_SRC_ORA_VER         # Source oracle version by numbers
    export AUTO_DST_ORA_VER         # Destination oracle version by numbers
    
    export AUTO_SRC_ORA_S_VER       # Short Oracle version for source
    export AUTO_DST_ORA_S_VER       # Short Oracle version for destination
    
    export AUTO_SRC_TNS_NAME        # Tnsnames entry for source machine 
    export AUTO_DST_TNS_NAME        # Tnsnames entry for destination machine
    
    export AUTO_SRC_OS              # Source OS
    export AUTO_DST_OS              # Destination OS

    export AUTO_SRC_OS_BITS         # Source OS Bits
    export AUTO_DST_OS_BITS         # Destination OS Bits

    export AUTO_SRC_PLATFORM        # Souce platform
    export AUTO_DST_PLATFORM        # Destination platform

    export AUTO_SRC_DBTYPE          # Souce DB type
    export AUTO_DST_DBTYPE          # Destination DB type
    
#juliatde
    export AUTO_SRC_TDE  	    # juliatde Source is TDE enabled (8.0.3+)           
    export AUTO_SRC_SPO_VER         # Source SharePlex version
    export AUTO_DST_SPO_VER         # Destination SharePlex version
    
    export AUTO_SRC_OPT_DIR         # Source SharePlex product directory
    export AUTO_DST_OPT_DIR         # Destination Shareplex product directory
    
    export AUTO_SRC_VAR_DIR         # Source SharePlex variable directory 
    export AUTO_DST_VAR_DIR         # Destination SharePlex variable directory
    
    export AUTO_SRC_ENV_FILE        # Env file copied to source machine
    export AUTO_DST_ENV_FILE        # Env file copied to destination machine
    
    export AUTO_SRC_BASE_VERSION    # Src base spo version. ex)5.1
    export AUTO_DST_BASE_VERSION    # Dst base spo version. ex)4.0
    
    export AUTO_SP_CTRL_INFO        # Information gathered from sp_ctrl
    export AUTO_SPO_BASE_VERSION    # Shareplex major.minor version number 
    export AUTO_SPO_PORT            # Port shareplex cop runs on
    
    export AUTO_TEST_PLAN_ID        # Test plan id in testplan list file

    # master_suite_name is exported in master suite file
    export AUTO_MASTER_SUITE=$master_suite_name  
    export AUTO_MASTER_SUITE_DESC

    # User information
    export AUTO_TESTER
    export AUTO_USER
    export AUTO_USER_EMAIL
    export AUTO_TESTER_DIR          # Dir for testers results/working files

    # OLD EXPORTS to remove later
    export SPCOMMON=$AUTO_ROOT_DIR
    export COMMONDIR=$AUTO_EXPECT_DIR

    export AUTO_MASTER_SUITE_DIR
    export AUTO_SUITE_LIST

    export AUTO_MASTER_SUITE_ID # RUN ID FOR THE MASTER SUITE
    export AUTO_WORK_DIR            # Dir for all work files, same as AUTO_MASTER_SUITE_DIR

    # name of master suite file that was executed
    export AUTO_EXE_MSTR_SUITE_FILE=$ExecutedMasterSuite 
    export AUTO_EXE_MSTR_SUITE_FILE=${ExecutedMasterSuite##./}

    # OVER RIDE DEFAULTS
    # Export these before running automation to set defaults
    export AUTO_ROOT_PWD=$RootPwd # Over ride default root password
    export AUTO_SRC_ROOT_PWD=$SrcRootPwd
    export AUTO_DST_ROOT_PWD=$DstRootPwd
    export AUTO_SYS_PWD=$SysPwd
    export AUTO_SYSTEM_PWD=$SystemPwd
    export AUTO_SRC_ORA_SPADMIN_UID=$SrcOraSpadminUid # over rides src oracle spadmin uid
    export AUTO_SRC_ORA_SPADMIN_PWD=$SrcOraSpadminPwd # over rides src oracle spadmin pwd
    export AUTO_DST_ORA_SPADMIN_UID=$DstOraSpadminUid # over rides dst oracle spadmin uid
    export AUTO_DST_ORA_SPADMIN_PWD=$DstOraSpadminPwd # over rides dst oracle spadmin pwd

    # repository stuff
    export AUTO_MSTR_SUITE_RESULT_ID="" # unique id generate by sequence when rec inserted

    export AUTO_DST_PPAS_DB=$DstPpasDb  # over rides if not exported
    export AUTO_DST_MYSQL_DB=$DstMysqlDb

    #Options

    # COMMENTED OUT SO IT DOESN'T OVERWRITE ONES EXPORTED BEFORE RUNNING
    #export AUTO_SP_USERS_FILE     # Path/file to oracle users list used in chech_sp_users
    #export AUTO_SP_TBL_SPACE_FILE # Path/file to oracle table spaces list in check_sp_tablespaces 
    #export AUTO_SP_TABLES_FILE    # Path/file to oracle tables list in check_sp_tables & check_sp_tables_structure
    #export AUTO_SP_TABLES_FILE

    #NOTE: AUTO_ENV_FILE is exported in _InitMstrArgs
}


##############################################################################
# Initializes user information exports
##############################################################################
function _InitUserData {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    printf "Initializing tester:$AUTO_TESTER"

    # Get tester name from the front of env file or exit 
    [[ "$AUTO_ENV_FILE" = *(*\.*) ]] && {
        AUTO_TESTER=${AUTO_ENV_FILE%%\.*}
    } || {
        print "ERROR: Invalid environment file name: $AUTO_ENV_FILE"
        print " File format: TesterName.ShortDesc"
        print " Example: JoeBob1.u02817_u03817"
        exit
    }

    # Get the acutal user name by grepping for the alias or exit
    AUTO_USER=`grep $AUTO_TESTER $AUTO_ROOT_DIR/email_list | cut -d' ' -f1`

    [[ -z "$AUTO_USER" ]] && {
        print "ERROR: Could not find your alias name: $AUTO_TESTER in the email_list"
        exit 
    }

    #check_user $AUTO_USER

    # Get the users email address
    AUTO_USER_EMAIL=`grep $AUTO_TESTER $AUTO_ROOT_DIR/email_list | cut -d' ' -f3`

    [[ -z "$AUTO_USER_EMAIL" ]] && {
        print "ERROR: Failed to get your email address from email_list"
        exit 
    }

    # Create tester directory if it doesn't exist
    AUTO_TESTER_DIR="$AUTO_RUNS_DIR/$AUTO_TESTER"

    [[ ! -d $AUTO_TESTER_DIR ]] && {
        CreateDir "$AUTO_TESTER_DIR" 777 || {
            print "ERROR: Failed to create log/work dir at: $AUTO_TESTER_DIR"
            exit
        }
    }

    print "...successful."
}


##############################################################################
# Validates the number of arguments passed in and sets them to exports
##############################################################################
function _InitMstArgs {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    if [ $# != 1 ]; then
        print "ERROR: Invalid number of arguments to master suite."
        print "USAGE: MasterSuiteName UserEnvironmentFile 2>&1 | tee YourHomeDir/TestLogName.txt"
        exit
    fi

    export AUTO_ENV_FILE=$1

    #TODO: REMOVE IF NO ONE COMPLAINS
    #export current_env=$AUTO_ENV_FILE # TODO: replace this

}


##############################################################################
# Setups up the master suite directory for logging
##############################################################################
function _InitMstSuiteDir {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    printf "Initializing MasterSuite:$AUTO_MASTER_SUITE"

    typeset DirNameSearch="$AUTO_TESTER_DIR/$AUTO_MASTER_SUITE*"

    # Get the directories of the same master s suite
    set -A Dirs `ls -drt $DirNameSearch 2>/dev/null`

    # If no existing directory for thist master suite
    [[ ${#Dirs[*]} > 0 ]] && {

        # Keep asking user untill the get it right(endless loop)
        while (( 1 < 2 )); do

            [[ -n "$AUTO_MASTER_SUITE_DIR" ]] && {
                print "\nUsing last master dir: $AUTO_MASTER_SUITE_DIR\n"
                break
            }


            print "\n$AUTO_TESTER already has a directory for master suite:$AUTO_MASTER_SUITE."
            print "Would you like to use an existing directory or create a new one [e|n]:\c"
            read Answer


            case "$Answer"  in

                # Use an existing dir
                +(e|E)* )

                    # Save old and set PS3
                    Old=$PS3
                    PS3="Select an existing directory: "

                    # Get one of these dirs from the user
                    select DirName in ${Dirs[*]}; do

                        # Set the chosen dir to global
                        AUTO_MASTER_SUITE_DIR=$DirName
                        export AUTO_MASTER_SUITE_ID=`print $DirName|cut -f2 -d.`

                        PS3=$Old # Reset it back

                        break # Break select control struct

                    done #End select control struct

                    break ;;  # Break while control struct
             
                # Create a new dir
                +(n|N)* )

                    _CreateNewMstrSuiteDir
                    break ;; # Break while control struct

                # Everything else, keep ask'n
                * ) 
                    print "\nError: Invalid entry\nPlease try again";;

            esac

        done

    # No dirs, create a new one
    } || {
        _CreateNewMstrSuiteDir
    }
        
    # For now the working dir is the same as suite dir.
    # I made a seperate var just incase we decide to move working files some where else.
    # This way, only this var has to change
    AUTO_WORK_DIR=$AUTO_MASTER_SUITE_DIR

    _SetupSuiteList
    _SetupPidFile

    print "...successful."
}


##############################################################################
##############################################################################
function _SetupPidFile {

    typeset Dir="$AUTO_MASTER_SUITE_DIR"
    typeset File="$Dir/MstrPID"
    typeset Pid=$$

    print "$Pid" > $File
    chmod 666 $File

}


##############################################################################
# Creates the file that contains a list of suites run in a masters suite dir
##############################################################################
function _SetupSuiteList {

    # Create suite list file if it doesn't exist. Doing it like this so perms are 666
    export AUTO_SUITE_LIST="$AUTO_MASTER_SUITE_DIR/SuiteLogList.txt"

    [[ -f $SuiteList ]] || {
        CreateFile $AUTO_SUITE_LIST 666 || {
            print "ERROR: Failed to create suite list"
            exit
        }
    } 



}


##############################################################################
# Handles creating a new master directory
##############################################################################
function _CreateNewMstrSuiteDir {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    # RUN ID FOR THIS MASTER SUITE'S RUN
    #AUTO_MASTER_SUITE_ID=$RANDOM
    AUTO_MASTER_SUITE_ID=$(GetSeqNextVal "SEQ_MSTR_SUITE_RUN_ID")

    # A number wasn't given, then exit automation.
    [[ "$AUTO_MASTER_SUITE_ID" = *[0-9] ]] || { 
        print "\n\n\nFailed to generate AUTO_MASTER_SUITE_ID!"
        exit 1  
    }

    #Year,Month,Day,Hour,Minute,Second,Master Suite Name,Master Suite PID
    typeset RunDirName="${AUTO_MASTER_SUITE}.$AUTO_MASTER_SUITE_ID"

    AUTO_MASTER_SUITE_DIR="$AUTO_TESTER_DIR/$RunDirName"

    # Create Master suite directory if doesn't exist
    [[ ! -d $AUTO_MASTER_SUITE_DIR ]] && {
        CreateDir "$AUTO_MASTER_SUITE_DIR" 777 || {
            print "ERROR: When creating suite dir at: $AUTO_MASTER_SUITE_DIR"
            exit
        }
    }

}


#############################################################################
# Description:  Parses data from the given user's environment file and 
#               initializes global variables with it
#
# Input:        File - complete path to environment file
#
# Example Call: ParseUserEnv "/path/to/file"
#############################################################################
function _ParseUserEnv {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    typeset File="$AUTO_ENV_DIR/$AUTO_ENV_FILE"
    printf "Parsing %s" "$File"

    # Local vars
    typeset FieldSize="11" #Number of fields in an env_list entry

    typeset Syn="SrcHost DstHost SrcSID DstSID SrcOptDir DstOptDir SrcVarDir "
            Syn="${Syn}DstVarDir SrcBaseVersion DstBaseVersion Port"

    function _EntryErr {
        typeset Msg="\nERROR: Failed to parse your environment file"
                Msg="${Msg}\n\nSyntax:\n\t$Syn\n"

        typeset Msg="$Msg"
        SendEMail "$ErrEmailSub" "$Msg"
        print "$Msg"
        _Prompt
    }

    function _Prompt {
        print "Do you want to continue y/n?"
        read Response

        case "$Response" in
            y|Y ) return $TURE;;
            * ) exit $FALSE;;
        esac
    }

    # Save old value of the Input Field Seperator and set to it "."
    OIFS=$IFS && IFS=";"

    # Set elements in array to the env info
    set -A EnvArray `head -1 $File`

    # Set IFS back to what it was
    IFS=$OIFS

    # Validate the field sizes
    [ ${#EnvArray[*]} == $FieldSize ] || _EntryErr

    # Assign elements to global variables
    AUTO_SRC_HOST_NAME="${EnvArray[0]}"
    AUTO_DST_HOST_NAME="${EnvArray[1]}"
    AUTO_SRC_SID="${EnvArray[2]}"
    AUTO_DST_SID="${EnvArray[3]}"
    AUTO_SRC_OPT_DIR="${EnvArray[4]}"
    AUTO_DST_OPT_DIR="${EnvArray[5]}"
    AUTO_SRC_VAR_DIR="${EnvArray[6]}"
    AUTO_DST_VAR_DIR="${EnvArray[7]}"
    AUTO_SRC_BASE_VERSION="${EnvArray[8]}"
    AUTO_DST_BASE_VERSION="${EnvArray[9]}"
    AUTO_SPO_PORT="${EnvArray[10]}"
    
    print "...Successful"

}


#############################################################################
# Description:  Parses data from the env_list file and sets it to
#               the global variables
#
# Input:        File - complete path to environment file
#
# Example Call: ParseEnvList "/path/to/file"
#############################################################################
function _ParseEnvList {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    typeset File=$AUTO_ENVS_LIST

    printf "Parsing %s" "$File"

    # Local vars
    typeset FieldSize="9" #Number of fields in an env_list entry

    function _EntryErr {
        typeset Host=$1
        typeset Sid=$2
        typeset ErrEmailSub="ERROR: Failed to parse env_list"
        typeset ErrEmailBod="Entry in env_list of the following env might not exist"
                ErrEmailBod="${ErrEmailBod} or is invalid"

        typeset Bod="$ErrEmailBod\nHost:$Host\nSID:$Sid"
        SendEMail "$ErrEmailSub" "$Bod"
        print "$Bod"
        _Prompt
    }

    function _Prompt {
        print "Do you want to continue y/n?"
        read Response

        case "$Response" in
            y|Y ) return $TURE;;
            * ) exit $FALSE;;
        esac
    }

    # Get the source and target environment infomation line from file
    SrcEnvLine=`grep "$AUTO_SRC_HOST_NAME;" $File | grep "$AUTO_SRC_SID;"`
    [ $? == 0 ] || _EntryErr "$AUTO_SRC_HOST_NAME" "$AUTO_SRC_SID"

    DstEnvLine=`grep "$AUTO_DST_HOST_NAME;" $File | grep "$AUTO_DST_SID;"`
    [ $? == 0 ] || _EntryErr "$AUTO_DST_HOST_NAME" "$AUTO_DST_SID"

    # Save old value of the Input Field Seperator and set to it "."
    OIFS=$IFS && IFS=";"

    # Set elements in array to the env info
    set -A SrcArray $SrcEnvLine
    set -A DstArray $DstEnvLine

    # Set IFS back to what it was
    IFS=$OIFS

    # Validate the field sizes
    [ ${#SrcArray[*]} == $FieldSize ] || _EntryErr "$AUTO_SRC_HOST_NAME" "$AUTO_SRC_SID"
    [ ${#DstArray[*]} == $FieldSize ] || _EntryErr "$AUTO_DST_HOST_NAME" "$AUTO_DST_SID"

    # Assign elements to global variables
    AUTO_SRC_OS="${SrcArray[2]}"
    AUTO_DST_OS="${DstArray[2]}"
    AUTO_SRC_OS_BITS="${SrcArray[3]}"
    AUTO_DST_OS_BITS="${DstArray[3]}"
    AUTO_SRC_ORA_VER="${SrcArray[5]}"
    AUTO_DST_ORA_VER="${DstArray[5]}"
    AUTO_SRC_TNS_NAME="${SrcArray[7]}"
    AUTO_DST_TNS_NAME="${DstArray[7]}"
    AUTO_SRC_ORA_HOME="${SrcArray[8]}"
    AUTO_DST_ORA_HOME="${DstArray[8]}"

    AUTO_SRC_DBTYPE=$(_GetDBType "$AUTO_SRC_ORA_HOME")
    AUTO_DST_DBTYPE=$(_GetDBType "$AUTO_DST_ORA_HOME")

    AUTO_SRC_PLATFORM=$(_GetPlatform "$AUTO_SRC_OS") || {
        print "$AUTO_SRC_PLATFORM\n\tExiting test case";
        exit
    }

    AUTO_DST_PLATFORM=$(_GetPlatform "$AUTO_DST_OS") || {
        print "$AUTO_DST_PLATFORM\n\tExiting test case";
        exit
    }

    AUTO_SRC_ORA_S_VER=$(_GetSpoOraDir $AUTO_SRC_ORA_VER)
    AUTO_DST_ORA_S_VER=$(_GetSpoOraDir $AUTO_DST_ORA_VER)

    print "...Successful"
}


###########################################################################
# Function Name: Get Platform                       Date Created:12/12/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Prints the platform for the give OS
#
# Usage: GetPlatform "$OsName" 
#
# Output/Return: Prints the platform usually Unix or Windows_NT
#
# Ex: GetPlatform "$OsName" -or-
#     MyPlatform=$(GetPlatform $MyOsName) || { exit }
###########################################################################
function _GetPlatform {

    [[ "$#" == "1" ]] || return $FALSE

    typeset Os=$1

    # See if windows and set to windows if it is or else set to unix
    [[ "$Os" = +(*(W|w)in*) ]] && print "$WINDOWS" || print "$UNIX"

    return $TRUE

}

#Ilya 081915 Prints DBType - oracle|sqlserver|postres|sybase|unknown for now
#kbai 021916 Prints DBType - oracle|sqlserver|postres|sybase|teradata|unknown for now
#Juila 05242016 Prints DBType - oracle|sqlserver|postres|sybase|teradata|hana|unknown for now
function _GetDBType {

    [[ "$#" == "1" ]] || return $FALSE

    typeset DBT=$1

    ([[ "$DBT" = +(*oracle*) ]] && print "oracle") ||
        ([[ "$DBT" = +(*sqlserver*) ]] && print "sqlserver") ||
        ([[ "$DBT" = +(*postgres*) ]] && print "postgres") ||
        ([[ "$DBT" = +(*sybase*) ]] && print "sybase") ||
        ([[ "$DBT" = +(*teradata*) ]] && print "teradata") ||
        ([[ "$DBT" = +(*hana*) ]] && print "hana") ||
        ([[ "$DBT" = +(*mysql*) ]] && print "mysql") ||
        print "unknown"

    return $TRUE

}

##############################################################################
# Gets spo version and other info from sp_ctrl
##############################################################################
function _GetSpctrlInfo {

#TODO: this needs to be switched back to getting the info using
# the remotes host's sp_ctrl

    # Arguments passed in
    typeset cmd=$1
    typeset param=$2

    # Local vars
    typeset SrcOutPut
    typeset DstOutPut

    typeset ErrMsg="Suite is exiting!!!\n"
     ErrMsg="${ErrMsg}Automation can not possibly continue until sp_ctrl works\n"
     ErrMsg="${ErrMsg}sp_ctrl reported:"
             
    typeset ErrEmailSub="Suite: $AUTO_CURRENT_SUITE aborted!" 

    # Execute on source
    SrcOutPut=$(_SPCTRL_CmdLocToRemote src 0 "$cmd") || { 
        typeset ErrMsgHead="Failed: can't connect sp_ctrl to $AUTO_SRC_HOST_NAME"
        print "$ErrMsgHead\n$ErrMsg\n$SrcOutPut" | tee -a $AUTO_TEST_CASE_LOG
        SendEMail "$ErrEmailSub" "$ErrMsgHead\n$ErrMsg\n$SrcOutPut"
        exit $FALSE
    }

    #Execute on destination
    DstOutPut=$(_SPCTRL_CmdLocToRemote dst 0 "$cmd") || { 
        typeset ErrMsgHead="Failed: can't connect sp_ctrl to $AUTO_DST_HOST_NAME"
        print "$ErrMsgHead\n$ErrMsg\n$DstOutPut" | tee -a $AUTO_TEST_CASE_LOG
        SendEMail "$ErrEmailSub" "$ErrMsgHead\n$ErrMsg\n$DstOutPut"
        exit $FALSE
    }

    # Add the output to the global var so it can be accessed later
    AUTO_SP_CTRL_INFO="$AUTO_SP_CTRL_INFO\n$param= `print $SrcOutPut | tr -d '\n'`"
    AUTO_SP_CTRL_INFO="$AUTO_SP_CTRL_INFO\n${param}_TARGET= `print $DstOutPut | tr -d '\n'`"

}


#############################################################################
# This function was created to get the oracle version from the sid. This will
# be used in creating the path to Shareplex opt and var dir
# See also: splex.ksh function "optvar" - this may replace it
# Note: this is not the best way to get the oracle version becaus sid must be 
#       in a special formate(example: o817v32a)
#############################################################################
function _GetSpoOraDir {
    typeset OraVer=$1
  
    case $OraVer in
        7.3.4*|734*       ) print "7"  ;;
        8.0*|80*          ) print "8"  ;;
        8.1*|81*|*11i*    ) print "8i" ;;
        9*                ) print "9i" ;;
        10*               ) print "10g" ;;
        110*              ) print "110" ;;
        11g*              ) print "11g" ;;
        12c*              ) print "12c" ;;
    esac
}


##############################################################################
# Sets some globals to information taken from sp_ctrl
##############################################################################
function _SetSPCtrlInfo {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    # If cop isn't set, then we can't get the real version
    # set it to the base given in env file
    [[ "$AUTO_IGNORE_NO_COP" != "" ]] && {
        AUTO_SRC_SPO_VER=$AUTO_SRC_BASE_VERSION
        AUTO_DST_SPO_VER=$AUTO_DST_BASE_VERSION
        print "Warning: AUTO_IGNORE_NO_COP is set. SRC/DST versions will be set to version indicated in your env file"
        return $TRUE
    }


    printf "Getting info from sp_ctrl."

    ####################################################################
    # The global var, AUTO_SP_CTRL_INFO, will hold all info that was
    # retrieved from sp_ctrl when GetSpctrlInfo function is called. This
    # is done so that each testcase can print out this same infomation
    # when it calls oracle_vars
    ####################################################################
    AUTO_SP_CTRL_INFO="## INFORMATION TAKEN FROM SP_CTRL ## "

    #Temporarly set this because if not then _SPCTRLCmdToRemote breaks
    AUTO_SRC_SPO_VER=$AUTO_SRC_BASE_VERSION
    AUTO_DST_SPO_VER=$AUTO_DST_BASE_VERSION

    case "$AUTO_SRC_BASE_VERSION" in
        4.0*)
            _GetSpctrlInfo "version" "SP_CTRL VERSION" ;;

        4.5|5*)
            _GetSpctrlInfo "version full" "SP_CTRL VERSION" ;;

        6*|7*|8*|9*)
            _GetSpctrlInfo "version full" "SP_CTRL VERSION" ;;

        *)
            print "Warning: SPO \"$AUTO_SRC_BASE_VERSION\" is unsupported."
            print "\tPlease have someone add it to the driver" ;;
    esac

    _GetSpctrlInfo hostinfo "SP_CTRL HOSTINFO"
    _GetSpctrlInfo authlevel "SP_CTRL AUTHLEVEL"

    # Get the real shareplex version
    TempVar=`print $AUTO_SP_CTRL_INFO | grep "VERSION="`
    TempVar=${TempVar##*Version = }
    TempVar=${TempVar%%\ *}
    TempVar=$(echo "$TempVar" | sed "s/-b/./g")


    [[ "$TempVer" == "4.0" ]] && {
        AUTO_SRC_SPO_VER=${TempVar##*VERSION= }
    } || {
        AUTO_SRC_SPO_VER=${TempVar##*VERSION=*Version = }
    }

    TempVar=`print $AUTO_SP_CTRL_INFO | grep "VERSION_TARGET="`
    TempVar=${TempVar##*Version = }
    TempVar=${TempVar%%\ *}
    TempVar=$(echo "$TempVar" | sed "s/-b/./g")

    [[ "$TempVer" == "4.0" ]] && {
        AUTO_DST_SPO_VER=${TempVar##*VERSION_TARGET= }
    } || {
        AUTO_DST_SPO_VER=${TempVar##*Version = }
    }

    # Make sure we got the version
    [ -z "$AUTO_SRC_SPO_VER" ] && {
        print "Failed to get Shareplex source version!!!"
        exit
    }

    [ -z "$AUTO_DST_SPO_VER" ] && {
        print "Failed to get Shareplex destination version!!!"
        exit
    }

    print "...Successful"
}



##############################################################################
# Creates and copies the env exports files used on test machines
##############################################################################
function _InitExportsFile {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    printf "Initializing exports files"


    #################################################
    # Create the env files for source and destination
    #################################################
    if ! _CreateExportsFile "src"; then
        print "Error: '$0' Failed to create file for source env."
        return 1 
    fi 

    if ! _CreateExportsFile "dst"; then
        print "Error: '$0' Failed to create file for dest env."
        return 1
    fi 

    printf "."


    #################################################
    # Copy over the exports file to source and dest
    #################################################
    if ! _CopyExportFiles; then
        return 1
    fi

    printf "."

    #################################################
    #OLD EXPORTS - try to get rid of these 
    #################################################
    export ohs=$AUTO_SRC_ORA_HOME
    export ohd=$AUTO_DST_ORA_HOME
    export DROP_VERSION=$AUTO_SRC_SPO_VER
    export tp=$AUTO_SPO_BASE_VERSION


    print ".successful."
}

  
###########################################################################
# Function Name: CopyEnvFile                        Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Copies the env file from the temp directory to the testcase
#    temporary directory. This is just to provide back-ward compatibility
#    with old code that still requires the env file to be in this directory.
#
# Usage: CopyEnvFile
#
# Output/Return: 0 if successfull. 
#    On failure, print msg to term, send email and exit the testcase
#
# TODO: Remove calls to this function once all old code requiring the
#       env file to be in this directory.
###########################################################################
function _CopyEnvFile {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    SrcF="$AUTO_ENV_DIR/$AUTO_ENV_FILE"
    DstF="$AUTO_WORK_DIR/$AUTO_ENV_FILE"

    CmdOut=$(CopyFile $SrcF $DstF) || {

        print "Failed:: Couldn't copy $SrcF to $DstF"
        print "$CmdOut"
        SendEMail "A testcase failed to execute" \
                  "A testcase failed to copy $AUTO_ENV_FILE\n$CmdOut"
        exit 1                    
    }

    return 0
}



#############################################################################
# Description:
#
# Input:
#
# Example Call: 
#############################################################################
function _CreateExportsFile {

    typeset BaseFile="$AUTO_WORK_DIR/$AUTO_ENV_FILE"
    typeset FileName
    typeset Type

    #################################################
    # Validate argument(s) passed in to function
    #################################################
    if [ $# != 1 ]; then # Get at least 1 argument or return now
        print "Error: No arguments passed to 'driver.CreateExportsFile'"
        print "\tMust pass 'src' or 'dst'"
        return 1

    elif [ -z $1 ]; then # Argument 1 is not blank, or return now 
        print "Error: argument 1 passed to 'driver.CreateExportsFile' is blank"
        print "\tMust pass 'src' or 'dst'"
        return 1

    # Argument must be "src" or "SRC"
    elif [[ "$1" == "src"  || "$Type" == "SRC" ]]; then 
        Type="src" # Set to lower case no matter what

    # Argument must be "dst" or "DST"
    elif [[ "$1" == "dst" || "$Type" == "DST" ]]; then
        Type="dst" # Set to lower case no mater what

    # Anthing else besides above, return now
    else
        print "Error: $1 is an invalid argument to pass to 'driver.CreateExportsFile'"
        print "\tMust pass 'src' or 'dst' to driver.CreateExportsFile"
        return 1
    fi 
        
    #################################################
    # Create the file that will be copied to server 
    #################################################
    FileName="$BaseFile.$Type" # create final file name 

    SetPlatform $Type


    # Save file name to source or destination global variable
    if [ "$Type" == "src" ]; then
        AUTO_SRC_ENV_FILE=$FileName
    else
        AUTO_DST_ENV_FILE=$FileName
    fi

    # Remove existing file if there is one
    if [[ -a $FileName ]]; then
        rm $FileName 
    fi

    # Create a new blank file
    if ! touch $FileName; then
        print "Error: Failed to create $FileName in 'driver.CreateExportsFile'"
        return 1
    fi


    #################################################
    # Write the exports to file
    #################################################
    print "#!/usr/bin/ksh"                                          >> $FileName
    print "# =====================================================" >> $FileName
    print "# Environment Script for SharePlex Automation that"      >> $FileName
    print "# contains all the information needed for source"        >> $FileName
    print "# and target environments"                               >> $FileName
    print "# =====================================================" >> $FileName
    print "\n\n# SOURCE INFORMATION"                                >> $FileName
    print "export s_host0=$AUTO_SRC_HOST_NAME"                      >> $FileName
    print "export s_sid0=$AUTO_SRC_SID"                             >> $FileName
    print "export s_vardir0=$AUTO_SRC_VAR_DIR"                      >> $FileName
    print "export s_proddir0=$AUTO_SRC_OPT_DIR"                     >> $FileName
    print "export s_var_ver=var$AUTO_SRC_ORA_S_VER"                 >> $FileName
    print "export s_opt_ver=opt$AUTO_SRC_ORA_S_VER"                 >> $FileName

    print "\n\n# TARGET INFORMATION"                                >> $FileName
    print "export d_host0=$AUTO_DST_HOST_NAME"                      >> $FileName
    print "export d_sid0=$AUTO_DST_SID"                             >> $FileName
    print "export d_vardir0=$AUTO_DST_VAR_DIR"                      >> $FileName
    print "export d_proddir0=$AUTO_DST_OPT_DIR"                     >> $FileName
    print "export d_var_ver=var$AUTO_DST_ORA_S_VER"                 >> $FileName
    print "export d_opt_ver=opt$AUTO_DST_ORA_S_VER"                 >> $FileName 


    print "\n\n# GENERAL INFORMATION"                               >> $FileName
#    print "export SP_TEST_FORCE_DEACT=1"                            >> $FileName
    print "export curr_tester=$AUTO_TESTER"                         >> $FileName
    print "export OTEST_CONNECT=sp_otest/sp_otest"                  >> $FileName 
    print "export rootpass=qa4qsft"                                 >> $FileName 
    print "export install_user=splexo"                              >> $FileName
    print "export ctrl=sp_ctrl"                                     >> $FileName 
    print "export dba=system"                                       >> $FileName
    print "export dbapass=quest4me"                                 >> $FileName 
    print "export PORTNUM=$AUTO_SPO_PORT"                           >> $FileName
    print "export TIMEOUT=1800"                                     >> $FileName 
    print "export PLATFORM=$PLATFORM"                               >> $FileName
    print "export PRODUCT=\"Oracle\""                               >> $FileName

    print "export spadmin=$spadmin"                                 >> $FileName
    print "export spapass=$spapass"                                 >> $FileName

    #added by candy in 06242016, check if the parameter SP_TEST_FORCE_DEACT need to be exported.
    if [ -n "$SP_TEST_FORCE_DEACT" ]; then
        print "export SP_TEST_FORCE_DEACT=1"                        >> $FileName
    fi

    if [[ -n $AUTO_SRC_NLS_LANG ]]; then
        print "export NLS_LANG=$AUTO_SRC_NLS_LANG" >> $FileName
    fi

    # export only the above once to automation machine environment
    if [ "$Type" == "src" ]; then
        . $AUTO_SRC_ENV_FILE # export exports created so far to automation machine 
    fi

    # This is as far as it needs to go for windows
    [ "$PLATFORM" == "$WINDOWS" ] && return $TRUE

    # Type, source or dest, specific exports
    if [ "$Type" == "src" ]; then 
        print "export ORACLE_SID=$AUTO_SRC_SID"                     >> $FileName
        print "export ORACLE_HOME=$AUTO_SRC_ORA_HOME"               >> $FileName
        print "export SP_SYS_VARDIR=$AUTO_SRC_VAR_DIR"              >> $FileName
        print "export OTEST_TAB_LIST=$AUTO_SRC_VAR_DIR/config"      >> $FileName
    else
        print "export ORACLE_SID=$AUTO_DST_SID"                     >> $FileName
        print "export ORACLE_HOME=$AUTO_DST_ORA_HOME"               >> $FileName
        print "export SP_SYS_VARDIR=$AUTO_DST_VAR_DIR"              >> $FileName
        print "export OTEST_TAB_LIST=$AUTO_DST_VAR_DIR/config"      >> $FileName
    fi
         
    print "export LD_LIBRARY_PATH=\$ORACLE_HOME/lib"                >> $FileName

    # Path. This is done for each platform here because we don't want to export
    # this to the automation machine env
    if [ "$PLATFORM" == "$UNIX" ];then
        print "export PATH=\$PATH:\$ORACLE_HOME/bin"                >> $FileName
        print "export otestdir=$AUTO_NIX_OTEST_DIR"                 >> $FileName
    else
        print "export otestdir=$AUTO_LOCAL_OTEST_DIR"                 >> $FileName
    fi
    
}

#############################################################################
# Description: Copies the exports file to a host
#
# Input: File
#        Host
#        Uid
#        Pwd 
#
# Example Call: 
#############################################################################
function _CopyExportsToHost {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
 
    typeset ValArgPat="$# == 2"
    typeset UseMsg="usage: $0 FileName Host src|dst Uid Pwd"

    # Validate the number of arguments passed to the function
    _ValNumArgs "$0" "$ValArgPat" "$UseMsg" ||  return $FALSE 
        
    #Validate the host type passed in or return  
    _ValHostType "$0" "$3" "$UseMsg" ||  return $FALSE

    # Set arguments to local variables
    typeset File=$1
    typeset Type=$2

    # Other local variables
    typeset Root       # Will be "/" or "D:/" according to platform
    typeset RemoteDir  # complete path to directory to create on remote host

    # Make sure file exists on local machine
    _ValFileExists "$0" "$File" || return $FALSE

    set_oracle_env $Type 0 0

    # Set remote root dir for mkdir comand according to the platform
    [ "$PLATFORM" == "$WINDOWS" ] || Root="D:/" && Root="/"

    RemoteDir="${Root}${this_vardir}"

    # Copy the file to remote dir or exit test
    if ! RemoteCopyFile $File $this_hostname "$RemoteDir/oracle_env.tmp"; then
        return 1
    fi


}

#############################################################################
# Description:
#
# Input:
#
# Example Call: 
#############################################################################
function _CopyExportFiles {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    typeset Uid="$spadmin"
    typeset Pwd="$spapass" 
   
    # Source
    if [ "$AUTO_SRC_PLATFORM" == "$UNIX" ]; then
        _CopyExportsToHost $AUTO_SRC_ENV_FILE "src" || {
            print "Error: $AUTO_SRC_ENV_FILE couldn't be copied to $AUTO_SRC_HOST_NAME"
            exit 127
        } 
    fi

    # Destination
    if [ "$AUTO_DST_PLATFORM" == "$UNIX" ]; then
        _CopyExportsToHost $AUTO_DST_ENV_FILE "dst" || {
            print "Error: $AUTO_DST_ENV_FILE couldn't be copied to $AUTO_DST_HOST_NAME"
            exit 127
        }
    fi

    # REMOVE TEMP FILES
    #rm $AUTO_SRC_ENV_FILE
    #rm $AUTO_DST_ENV_FILE

}



##############################################################################
##############################################################################
function _SetTestPlanId {
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    
    typeset Desc
    typeset testplan_id_list

    TPLst=$AUTO_ROOT_DIR/testplan_id_list

    # Anne wants to use the target machines version
    Line=`grep $AUTO_DST_BASE_VERSION $TPLst| grep -m 1 $AUTO_MASTER_SUITE`
    AUTO_TEST_PLAN_ID=`print $Line | awk '{print $1}'`
    AUTO_MASTER_SUITE_DESC=`print $Line | awk -F "\"" '{print $2}'`

    # Print warning if can't find it
    [[ -z "$AUTO_TEST_PLAN_ID" ]] && {
        print "\n\nWARNING: Couldn't find the test plan ID# for $AUTO_MASTER_SUITE"
        print "\t for SPO v${AUTO_DST_BASE_VERSION}.X.X. Please have a test lead add it to the"
        print "\t test plan list or you may not be able to insert test results into the TCM"
        print "\n Would you like to continue anyway? (y/n): \c"

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

}


function _DumpXML {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '
    typeset TempF=$AUTO_WORK_DIR/$$.tmp
    typeset XMLF=$AUTO_WORK_DIR/MstrGlobals.xml
   
    #Delete file if exists
    [[ -f $XMLF ]] && rm -f $XMLF

    CreateFile $XMLF 666
     
    # Write out xml header
    print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>" >> $XMLF
    print "\t<MstrGlobels>"                                                >> $XMLF

    # Grab all AUTO_* and dump to temp file.
    # Had to dump to temp file cause IPS was messing it up. Only way to get
    # a clean line was reading from a file :-(
    set | grep -v "AUTO_SP_CTRL_INFO" | grep -P "^AUTO_.+$" > $TempF

    # Split each line and write it to xml file
    while IFS="\n" read Line;do

        # Split the line by = sign
        Item=${Line%%=*}
        Value=${Line##*=}

        # Write out each item/value pairs in xml
        print "\t\t<$Item>$Value</$Item>" >> $XMLF

    done <$TempF
    
    # Write out xml closing tag
    print "\t</MstrGlobels>" >> $XMLF

    # Remove the temp file
    rm -f $TempF

}


##############################################################################
##############################################################################
function _InsertMstrSuiteResults {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

typeset SQL="

SET FEEDBACK OFF
SET SERVEROUTPUT ON
DECLARE
    ID number(10);
BEGIN

    INSERT INTO AUTO.MASTER_SUITE_RESULTS (
        MSTR_RESULT_ID,
        MSTR_RESULT_DATE, 
        MSTR_RESULT_LENGTH, 
        MSTR_RESULT_RUN_ID, 
        MSTR_RESULT_SRC_HOST, 
        MSTR_RESULT_SRC_SID, 
        MSTR_RESULT_SRC_OS, 
        MSTR_RESULT_SRC_ORA_VER, 
        MSTR_RESULT_SRC_SPO_VER, 
        MSTR_RESULT_DST_HOST, 
        MSTR_RESULT_DST_SID,
        MSTR_RESULT_DST_OS, 
        MSTR_RESULT_DST_ORA_VER, 
        MSTR_RESULT_DST_SPO_VER, 
        MSTR_RESULT_NAME,
        MSTR_RESULT_USER_NAME,
        MSTR_RESULT_TESTER,
        MSTR_RESULT_PRODUCT
        ) 
    VALUES ( 
        AUTO.SEQ_MSTR_SUITE_RESULT_ID.NEXTVAL,
        sysdate,
        0,
        $AUTO_MASTER_SUITE_ID,
        '$AUTO_SRC_HOST_NAME',
        '$AUTO_SRC_SID',
        '$AUTO_SRC_OS',
        '$AUTO_SRC_ORA_VER',
        '$AUTO_SRC_SPO_VER',
        '$AUTO_DST_HOST_NAME',
        '$AUTO_DST_SID',
        '$AUTO_DST_OS',
        '$AUTO_DST_ORA_VER',
        '$AUTO_DST_SPO_VER',
        '$AUTO_MASTER_SUITE',
        '$AUTO_USER',
        '$AUTO_TESTER',
        '$AUTO_PRODUCT'
    )
    RETURNING MSTR_RESULT_ID into ID;
    dbms_output.put_line('result=' || ID );
END;
/
commit;
"
    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql "$AUTO_REP_UID" "$AUTO_REP_PWD" "$AUTO_REP_NAME" "$SQL") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    }
  
    # Return false if oracle errors
    print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
        print "******************* WARNING *********************"
        print "Encountered the following error inserting into"
        print "into the master suite results table"
        print "******************* WARNING *********************"
        print "\n$Output"
        print "$SQL"

        print "\nPres ctrl-C to abort, or enter to continue: "
        read x
    }
        
    export AUTO_MSTR_SUITE_RESULT_ID=${Output#*result=} 


}


###############################################################################
# Creates a remote dir on src/dst machine for saving spo logs and such
###############################################################################
function _CreateRemoteErrDir {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

    #SRC
    set_oracle_env src 0 0
    Cmd="mkdir $AUTO_SRC_VAR_DIR/save_log"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    #DST
    set_oracle_env dst 0 0
    Cmd="mkdir $AUTO_DST_VAR_DIR/save_log"
    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $this_hostname $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)
}


##############################################################################
# This function is where last minute global exports are set. This is done
# last because it uses variables that must already have data.
##############################################################################
function _InitLastGlobalVars {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Local SPO event_log history files
    AUTO_SRC_E_LOG_HIST="$AUTO_WORK_DIR/$AUTO_SRC_HOST_NAME.elog.history"
    AUTO_DST_E_LOG_HIST="$AUTO_WORK_DIR/$AUTO_DST_HOST_NAME.elog.history"

    # Local SPO event_log temp file. check_log_on deletes these. So these vars might not ever be useful exported.
    AUTO_SRC_E_LOG_RECENT="$AUTO_WORK_DIR/$AUTO_SRC_HOST_NAME.elog.recent"
    AUTO_DST_E_LOG_RECENT="$AUTO_WORK_DIR/$AUTO_DST_HOST_NAME.elog.recent"

    # Local SPO event_log error file. check_log_on deletes these. So these vars might not ever be useful exported.
    AUTO_SRC_E_LOG_ERRORS="$AUTO_WORK_DIR/$AUTO_SRC_HOST_NAME.elog.errors"
    AUTO_DST_E_LOG_ERRORS="$AUTO_WORK_DIR/$AUTO_DST_HOST_NAME.elog.errors"

    _RAC_check


        # 11-04 Julia, Only call _GetOraCharSet when dbType is Oracle
        # 07-14-2016 Julia, also move _db_securefile and _tblsp_compression here

        # Src
        if [ "$AUTO_SRC_DBTYPE" == "oracle" ]; then

          _GetOraCharSet "src"
          _db_securefile

                if ([ "$AUTO_SRC_ORA_VER" == "11g" ] || [ "$AUTO_SRC_ORA_VER" == "12g" ]); then
                        _tblsp_compression
                fi

        elif [ "$AUTO_SRC_DBTYPE" == "sqlserver" ]; then
                export AUTO_SRC_CHAR_SET=MsSqlDefault

        elif [ "$AUTO_SRC_DBTYPE" == "postgres" ]; then
                export AUTO_SRC_CHAR_SET=PpasDefault

        elif [ "$AUTO_SRC_DBTYPE" == "sybase" ]; then
                export AUTO_SRC_CHAR_SET=SybaseDefault

        else
                export AUTO_SRC_CHAR_SET=Unknown
        fi

        # Dst
        if [ "$AUTO_DST_DBTYPE" == "oracle" ]; then
        _GetOraCharSet "dst"

        elif [ "$AUTO_DST_DBTYPE" == "sqlserver" ]; then
                export AUTO_DST_CHAR_SET=MsSqlDefault

        elif [ "$AUTO_DST_DBTYPE" == "postgres" ]; then
                export AUTO_DST_CHAR_SET=PpasDefault

        elif [ "$AUTO_DST_DBTYPE" == "sybase" ]; then
                export AUTO_DST_CHAR_SET=SybaseDefault

        else
                export AUTO_DST_CHAR_SET=Unknown
        fi


# Ilya 01-14-14
#    _db_securefile
#
#    if ([ "$AUTO_SRC_ORA_VER" == "11g" ] || [ "$AUTO_SRC_ORA_VER" == "12g" ]); then
#     _tblsp_compression
#    fi
#    _tblsp_compression
}

##############################################################################
# This function will check if it's RAC and export AUTO_ORACLE_RAC
##############################################################################
function _RAC_check {

        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

        if [ "$AUTO_SRC_DBTYPE" == "oracle" ]; then 
        typeset Sql="select 'result=' || value from v\$parameter where upper(name)='CLUSTER_DATABASE';"

        Output=$(_ExecSql $AUTO_SRC_ORA_SPADMIN_UID $AUTO_SRC_ORA_SPADMIN_PWD $AUTO_SRC_TNS_NAME "$Sql") || { 
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }     

        # Return false if oracle errors
        print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && { 
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }     

        typeset QueryResult=${Output#*result=}

        [[ "$QueryResult" == "TRUE" ]] && AUTO_ORACLE_RAC=$TRUE || AUTO_ORACLE_RAC=$FALSE

        fi   
}


##############################################################################
# Set exports to ora char set
##############################################################################
function _GetOraCharSet {


        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '


        typeset HostType="$1"
        typeset UpperHostType=$(UpperCase $HostType)

        set_oracle_env "$HostType" 0

        [[ "$UpperHostType" == "SRC" ]] && {
            Uid="$AUTO_SRC_ORA_SPADMIN_UID"
            Pwd="$AUTO_SRC_ORA_SPADMIN_PWD"
            Tns="$AUTO_SRC_TNS_NAME"
        } || {
            Uid="$AUTO_DST_ORA_SPADMIN_UID"
            Pwd="$AUTO_DST_ORA_SPADMIN_PWD"
            Tns="$AUTO_DST_TNS_NAME"
        }

        typeset Sql="select 'result=' || value from nls_database_parameters where upper(parameter)='NLS_CHARACTERSET';"

        Output=$(_ExecSql $Uid $Pwd $Tns "$Sql") || {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }       

        # Return false if oracle errors
        print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }       

        CharSet=$(_GetEqualString "$Output")

        [[ "$UpperHostType" == "SRC" ]] && { 
            export AUTO_SRC_CHAR_SET="$CharSet" 
        } || {
            export AUTO_DST_CHAR_SET="$CharSet"
        }

}

# Ilya 01-14-14
##############################################################################
# This function will check db_securefile parameter on source
##############################################################################
function _db_securefile {

        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

        typeset Sql="select 'result=' || upper(value) from v\$parameter where upper(name)='DB_SECUREFILE';"

        Output=$(_ExecSql $AUTO_SRC_ORA_SPADMIN_UID $AUTO_SRC_ORA_SPADMIN_PWD $AUTO_SRC_TNS_NAME "$Sql") || {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }

        # Return false if oracle errors
        print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }

        dbSecurefile=$(_GetEqualString "$Output")
        export AUTO_DB_SECUREFILE="$dbSecurefile"
}

# Ilya 01-14-14
##############################################################################
# This function will check tablespace compression on source
##############################################################################
function _tblsp_compression {

        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

        typeset Sql="select 'result=' || compress_for from dba_tablespaces where upper(tablespace_name)='SPLEX_DDL_ALL';"

        Output=$(_ExecSql $AUTO_SRC_ORA_SPADMIN_UID $AUTO_SRC_ORA_SPADMIN_PWD $AUTO_SRC_TNS_NAME "$Sql") || {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }

        # Return false if oracle errors
        print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
            LogIt "Failed:: $0 encountered errors while connecting to Oracle"
            LogIt "$Output"
            return $FALSE
        }

        tblspCompr=$(_GetEqualString "$Output")
        export AUTO_TABLESPACE_COMPRESSION="$tblspCompr"
}

##############################################################################
# Called first thing in all master suites. This initializes the whole 
# master suite.
##############################################################################
function InitMstSuite {

    _InitMstArgs "$@"
    _InitMstrExp

    print "#########################################################################"
    print "# REMINDER: Be sure env file has correct Shareplex information"
    print "#########################################################################\n\n"

    # Included libraries 
    . $AUTO_ROOT_DIR/syslib.ksh
    . $AUTO_ROOT_DIR/splex.ksh
    . $AUTO_ROOT_DIR/driverlib.ksh
    
    _InitUserData

    _ParseUserEnv 
    _SetTestPlanId
    _ParseEnvList 

    _InitMstSuiteDir
    _CopyEnvFile

    _InitExportsFile 
    _SetSPCtrlInfo 
    _InsertMstrSuiteResults
    _CreateRemoteErrDir
    _InitLastGlobalVars
    _DumpXML
    _CkTde   $AUTO_SRC_HOST_NAME 
}
###########################################################################################
# Read Source paramdb (pre-863) or connections.yaml (8.6.3) file to check if TDE is enabled
###########################################################################################
function _CkTde {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO: '

typeset Host="$1"

    #SRC

#juliatde

    if [ "$AUTO_SRC_PLATFORM" == "$UNIX" ]; then



	    if [[ "$AUTO_SRC_SPO_VER" = 8.0* || "$AUTO_SRC_SPO_VER" = 8.5* ]]; then
	      Cmd="grep SP_COP_WALLET_PATH $AUTO_SRC_VAR_DIR/data/paramdb | grep 'oracle' | grep -v ^'#'"

	    elif [[ "$AUTO_SRC_SPO_VER" = 8.6.0* || "$AUTO_SRC_SPO_VER" = 8.6.1* || "$AUTO_SRC_SPO_VER" = 8.6.2* ]]; then
	      Cmd="grep SP_COP_WALLET_PATH $AUTO_SRC_VAR_DIR/data/paramdb | grep 'oracle' | grep -v ^'#'"

	    else    
	      Cmd="grep wallet_location $AUTO_SRC_VAR_DIR/data/connections.yaml | grep "$AUTO_SRC_SID" | grep -v ^'#'"

	    fi


    Output=$($AUTO_EXPECT_DIR/RemoteCmd.exp $Host $PLATFORM $this_spadmin $this_spapass "$Cmd" 1)

    export AUTO_SRC_TDE=$?
    echo $AUTO_SRC_TDE

    fi
}


