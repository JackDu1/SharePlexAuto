#!/bin/ksh
# 4-23-2015 log prescan setting to splexqa suite results
# 8-12-2015 change function _CheckSrcNonTdeSkip to use "$AUTO_SRC_TDE" != "0"  instead of "$AUTO_SRC_TDE" -eq 1
# 06-14-2016 driverlib.ksh.v7 => replace TransferFile.py with Candy's TransferFile_v1.py
#
################################################################################
# File Name: driverlib.ksh                              Date Created: 11/14/2003
#
# Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
#
# Description: File containing functions called from driver only. All functions
#              that pretain only to the driver will be here. This file also
#              requires functions in splex.ksh be exported to env. The driver 
#              should export splex.ksh before exporting driverlib.ksh
# 
################################################################################


################################################################################
#                       ROLL OUTS TO EVERYONE
################################################################################
#09-13-04 v 1.9.2.42.2.61.2.34  rel-2-0-1


################################################################################
#                             FUNCTION INDEX
################################################################################
#
# CopySPOConfigToHost          - Copies Splex config to source machine
# CreateSplexConfig        - Creates the Shareplex config file
# CreateTestDirs           - Creates log and tmp dir under current testcase dir
#
#
################################################################################


################################################################################
#                          FUNCTION DEFINITIONS
################################################################################


###########################################################################
# Function Name: CopySPOConfigToHost                    Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Copies shareplex config to source machine
#
# Usage: CopySPOConfigToHost
#
# Output/Return: This function will exit current test case if it fails to
#     copy file to remote source host. 0 is returned on success.
#
# Example: Ouput=$(CopySPOConfigToHost) || { print "ERROR"; exit } 
#############################################################################
function CopySPOConfigToHost {

    typeset HostType=$1
    typeset HostId=$2

    set_oracle_env $HostType $HostId 0

    # Friendly error message for email and stdout
    typeset ErrSubject="Error: Suite $AUTO_CURRENT_SUITE can not continue"
    typeset ErrBody="Error: couldn't copy config $AUTO_CURRENT_CONFIG to $this_hostname"

    # Check that the temp config file exists
    _ValFileExists $0 "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP" || {
        print "$ErrBody"    | tee -a $AUTO_TEST_CASE_LOG 
        print "$ErrSubject" | tee -a $AUTO_TEST_CASE_LOG
        exit $FALSE
    }

    typeset Output # will contain all output of RemoteCopyFile

    # Skipp windows destination
    [[ "$HostType" == "dst" ]] &&  _IsWindows $PLATFORM && return 

    # Build command that will call expect script to transfer file
   #updated by candy in 05202016, replace ftp by sftp
   # typeset TransCmd="$AUTO_ROOT_DIR/TransferFile.py $this_hostname"
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
        TransCmd="${TransCmd} $AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
        TransCmd="${TransCmd} $this_vardir/config/$AUTO_CURRENT_CONFIG"
        TransCmd="${TransCmd} put ascii"

    # Transfer the file or die
    Output=$($TransCmd) || {

        print "$ErrBody"    | tee -a $AUTO_TEST_CASE_LOG 
        print "$Output"     | tee -a $AUTO_TEST_CASE_LOG
        print "$ErrSubject" | tee -a $AUTO_TEST_CASE_LOG

        SendEMail "$ErrSubject" "$ErrBody\n$Output" # Email the tester

        exit $FALSE 
    }

    # print all out put from FTP
    print "$Output"

    return 0
}

###########################################################################
# Function Name: CreateSplexConfig                  Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Creates the shareplex config file that will be used on
#    source host.
#
# Usage: CreateSplexConfig
#
# Output/Return: This function is designed to exit the current testcase
#     if it fails to create the config file. 0 is returned on success.
#############################################################################
function CreateSplexConfig {

    typeset CpOutput # STDOUT & STDERR of copy command
    typeset ErrSub   # Subject of email if there is an error
    typeset ErrBod   # Body of email if there is an error

    ErrSub="Error: Suite $AUTO_CURRENT_SUITE can not continue"
    ErrBod="Error: couldn't create shareplex config: $AUTO_CURRENT_CONFIG" 
    
    # Create the name of the temp config that will be put on server
    #[[ -n "$AUTO_CURRENT_TEST_ID" ]] && {
    #    # If TC id is set, then running in p option & can use TC id in name
    #    AUTO_CURRENT_CONF_TMP="$AUTO_SUITE_RUN_ID.$AUTO_CURRENT_TEST_ID.$AUTO_CURRENT_CONFIG.spo_conf"
    #} || {
    #    # Not running in parallel so we don't have the TC id.
    #    AUTO_CURRENT_CONF_TMP="$AUTO_SUITE_RUN_ID.$AUTO_CURRENT_CONFIG.spo_conf"
    #}

    AUTO_CURRENT_CONF_TMP="$AUTO_CURRENT_CONFIG.tmp"

    # Copy config from automation dir to temp dir
    # STDOUT and STDERR are stored in variable CpOutput
    # This suite will terminate if copy fails
    CpOutput=$(CopyFile "$AUTO_ROOT_DIR/configs/$AUTO_CURRENT_CONFIG" \
                "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP") || {

        print $ErrBod; print $CpOutput; print $ErrSub # Print errors to terminal
        SendEMail "$ErrSub" "$ErrBod\n$CpOutput"      # Email the tester the errors
        exit 1                                        # Terminate suite
    } 

    # Change source and dest host and sid in config  
    change "s_host0" $AUTO_SRC_HOST_NAME  "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
    change "s_sid0"  $AUTO_SRC_SID        "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
    change "d_host0" $AUTO_DST_HOST_NAME  "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
    change "d_sid0"  $AUTO_DST_SID        "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"

    ReplaceUserInConfig

    return 0
}


function ChkTestList {

    # Validate an argument was passed in, or error msg and return False
    if [ $# != 1 ]; then
        print "Error: Must pass file name to $0"
        return $FALSE
    fi

    typeset File=$1 # Argument passed in
    typeset ChkFile # return of ChkFileExists

    ChkFile=$(ChkFileExists "$AUTO_TESTS_DIR/$File") || {  
        print "$ChkFile"
        print "Test list could not be found"
        SendEMail "Error:Testlist $File Not Found" \
                  "$ChkFile"
        return $FALSE
    }

    return $TRUE

}

function ChkSuiteSyntax {

    # Full path to the suite
    typeset TestList="$AUTO_TESTS_DIR/$1"

    typeset Errors

    # Read each line in the test list and check the testcase for syntax errors
    while read TestCase; do

        # Skip blank lines
        [ "$TestCase" == "" ] && continue 

        # If not commented then check the syntax of test case
        if [ `print ${TestCase} | cut -c1` != "#" ]; then         
            Results=$(ChkSyntax "$TestCase/main.ksh") || {
                Errors="${Errors}\n$TestCase has Errors:\n$Results\n"
            }
        else
            continue
        fi

    done < $TestList

    # If any testcase has an error then send email and return 1
    if [ -n "$Errors" ]; then
        
        # Print Errors to term
        print "$Errors"

        # Setup and email and send it
        typeset EmailSub="ERROR: $AUTO_CURRENT_SUITE SUITE CAN NOT BE RUN!"

        typeset EmailBod="The following main.ksh files(s) have errors.\n"
        EmailBod="${EmailBod}Please correct them and re-run the suite.\n"
        EmailBod="${EmailBod}####################################################\n"
        EmailBod="${EmailBod}#                    ERRORS\n"
        EmailBod="${EmailBod}####################################################\n"
        EmailBod="${EmailBod}$Errors"

        SendEMail "${EmailSub}" "${EmailBod}"
        return $FALSE

    fi
  
    return $TRUE
 
}

function ChkSyntax {

    typeset TestCase=$1

    # Make sure the file exists
    ChkFileExists $TestCase || {
        print "$TestCase does not exist" 
        return $FALSE
    }

    # Check syntax. If there are errors then print errors and return 1
    Output=`ksh -n $TestCase 2>&1` || {
        print "$Output"
        return $FALSE
    }

    return $TRUE
}


function ReplaceUserInConfig {

    # If sp_user var is set then sub all user names in config to it's value
    if [ -n "$sp_user" ]; then
        change "s_user0" $sp_user "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
        change "d_user0" $sp_user "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"

    # If AUTO_SRC_SP_USER and AUTO_DST_SP_USER is set then sub user's with
    # their values
    elif [[ -n "$AUTO_SRC_SP_USER" && -n "$AUTO_DST_SP_USER" ]]; then
        change "s_user0" $AUTO_SRC_SP_USER "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
        change "d_user0" $AUTO_DST_SP_USER "$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
    fi

}

###########################################################################
# Function Name: SetupLogging                       Date Created:05/18/2004
###########################################################################
function SetupSuiteLog {


    #AUTO_SUITE_RUN_ID=$(GenUniqueId)
    AUTO_SUITE_RUN_ID=$(GetSeqNextVal "SEQ_SUITE_RUN_ID")

    typeset SuiteLogName="$AUTO_SUITE_RUN_ID.${AUTO_CURRENT_SUITE}"
    AUTO_SUITE_LOG="$AUTO_MASTER_SUITE_DIR/$SuiteLogName"
    CreateFile $AUTO_SUITE_LOG 666

    # Record suite name to suite log list
    print "$SuiteLogName" >> $AUTO_SUITE_LIST

    # TODO: Change all scripts to AUTO_SUITE_LOG instead of auto_log
    export auto_log=$AUTO_SUITE_LOG

    typeset Log=$AUTO_SUITE_LOG
    typeset TestsLst="$AUTO_TESTS_DIR/$AUTO_TEST_LIST"
    typeset CfgLst="$AUTO_CFGS_DIR/$AUTO_CONFIG_LIST" 

    #################################################
    # Calculate number of tests and configs in lists
    #################################################
    print "Setting up auto_log at $Log"
    total=0
    num_tests1=`grep ^/qa $TestsLst | wc -l`
    num_tests=`expr $num_tests1`
    num_configs1=`cat $CfgLst | grep -v "#" | wc -l`
    num_configs=`expr $num_configs1`  

    if [ "$AUTO_RUN_OPTION" == "a" ]
    then
        let total='total + num_tests * num_configs'
    else
        total=`cat $TestsLst| grep -v "#" | wc -l`
    fi

    #################################################
    # Print some information about the suite to auto log
    #################################################
    printf '%-20s %-20s\n' "Start time is:"     "`date`"                >> $Log
    printf '%-20s %-20s\n' "Master_suite_name:" "$AUTO_MASTER_SUITE"    >> $Log
    printf '%-20s %-20s\n' "Sub_suite_name:"    "$AUTO_CURRENT_SUITE"   >> $Log
    printf '%-20s %-20s\n' "Env file:" "$AUTO_ENV_FILE"                 >> $Log
    printf '%-20s %-20s\n' "Source:" "$AUTO_SRC_OS,$AUTO_SRC_ORA_VER"   >> $Log

    printf '%-20s %-20s\n' "Source Name:" "$AUTO_SRC_HOST_NAME"         >> $Log
    printf '%-20s %-20s\n' "Source SID:" "$AUTO_SRC_SID"                >> $Log

    printf '%-20s %-20s\n' "Target:" "$AUTO_DST_OS,$AUTO_DST_ORA_VER"   >> $Log
    printf '%-20s %-20s\n' "Target Name:" "$AUTO_DST_HOST_NAME"         >> $Log
    printf '%-20s %-20s\n' "Target SID:" "$AUTO_DST_SID"                 >> $Log

    printf '%-20s %-20s\n' "SharePlex Version:" "$AUTO_SRC_SPO_VER"     >> $Log

    printf '%-20s %-20s\n' "  Src from sp_ctrl:" \
      "`print $AUTO_SP_CTRL_INFO|grep "VERSION="|cut -d = -f3`"         >> $Log

    printf '%-20s %-20s\n' "  Dst from sp_ctrl:" \
      "`print $AUTO_SP_CTRL_INFO|grep "VERSION_TARGET="|cut -d = -f3`"  >> $Log

    printf '%-20s %-20s\n' "Number of tests:" "$num_tests"              >> $Log
    printf '%-20s %-20s\n' "Number of configs:" "$num_configs"          >> $Log
    printf '%-20s %-20s\n' "Total TC N to run:" "$total"                >> $Log  


    [[ -n "$AUTO_EXIT_SUITE_ON_ERROR" ]] && {
        printf '%-20s %-20s\n' "Exit suite on error:" "YES"   >> $Log  
    } || {
        printf '%-20s %-20s\n' "Exit suite on error:" "NO"   >> $Log  
    }

}



############################################################################################
# Writes column headers for the list of suite in the suite log.
############################################################################################
function _SuiteLogSuiteLstHeader {

    typeset Log=$AUTO_SUITE_LOG

    print " "                                                           >> $Log

    printf '%-8s %-16s %-35s %-22s %-8s\n' "RUN ID" "TIME" \
        "CONFIG" "TEST CASE ID" "RESULT"                                >> $Log

    print "==============================================================================================" >> $Log

}



############################################################################################
# Get some paramdb parameters from source and display them in the suite log.
# ParamDB file needs to be in work dir already. Call BackupParamDB before calling this.
############################################################################################
function _SuiteLogShowParamDB {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset Log=$AUTO_SUITE_LOG
    typeset ParamDBFile="$AUTO_WORK_DIR/src.parmdb.tmp"

    OlogSingleValue=$(_GetParamDBValue $ParamDBFile "SP_OCT_OLOG_THREAD_SINGLE")
    BatchEnableValue=$(_GetParamDBValue $ParamDBFile "SP_ORD_BATCH_ENABLE")
    TargCompartValue=$(_GetParamDBValue $ParamDBFile "SP_OCT_TARGET_COMPATIBILITY")

    printf '%-20s %-20s\n' "Src SP_OCT_OLOG_THREAD_SINGLE:" "$OlogSingleValue"   >> $Log  
    printf '%-20s %-20s\n' "Src SP_ORD_BATCH_ENABLE:" "$BatchEnableValue"   >> $Log  
    printf '%-20s %-20s\n' "Src SP_OCT_TARGET_COMPATIBILITY:" "$TargCompartValue"   >> $Log  

}

############################################################################################
# Parses the given parameter from the paramdb file and prints the parameter's value
############################################################################################
function _GetParamDBValue {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset ParamDBFile=$1
    typeset Parameter=$2

    Line="$(grep $Parameter $ParamDBFile)"

    [[ -n "$Line" ]] && {
        retVal=$(print "$Line" | awk -F" " '{ print $2 }' | sed "s/\"//g")
        print "$retVal"
    } || {
        print "Default"
    }

}


###########################################################################
# Function Name: SetupTestLog                       Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com)
# 
# Description: Sets up the name of the log for the current testcase. It 
#     also checks if a log with the same name already exists. If so it will
#     rename the existing log with a name that has the time.
#
# Usage: SetupTestLog
#
# Output/Return: Returns 0 if successfull, or prints a warning message to 
#    terminal if it fails to rename an existing log. 
#    Exists test case, emails user, and prints msg to term if it fails to
#    create a new log.   
#
# TODO: Might want to change this so it emails user and exits test if it 
#       can't rename the existing log. I will wait and see if this becomes
#       a common problem, and consulte with others on what they want to do
#       went rename fails.
##########################################################################
function SetupTestLog {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    #AUTO_TEST_RUN_ID=$(GenUniqueId)
    AUTO_TEST_RUN_ID=$(GetSeqNextVal "SEQ_TESTCASE_RUN_ID")

    # Get the current test case ID
    AUTO_CURRENT_TEST_ID=${AUTO_CURRENT_TEST##/*/}

    typeset FileNameBase="$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID.$AUTO_CURRENT_TEST_ID."
        FileNameBase="${FileNameBase}$AUTO_CURRENT_CONFIG.$AUTO_ENV_FILE"

    #OLD - typeset LogBase="$AUTO_CURRENT_TEST/log/$FileNameBase"
    typeset LogBase="$AUTO_MASTER_SUITE_DIR/$FileNameBase"
    typeset CurTime=`date +"%d%b%y%H%M%S"`
    typeset MovedLog="${LogBase}${CurTime}.log"
    typeset CmdOut # Output of commands

    AUTO_TEST_CASE_LOG="$LogBase.log"

    # Create the log file for the test case
    CmdOut=$(CreateFile $AUTO_TEST_CASE_LOG 666) || {
        print "Failed:: Couldn't create testcase log at:$AUTO_TEST_CASE_LOG"
        print "CmdOut"
        SendEMail "Testcase:$AUTO_CURRENT_TEST_ID failed to execute" \
                  "Testcase:$AUTO_CURRENT_TEST_ID failed to create test log:$AUTO_TEST_CASE_LOG\n$CmdOut"
        exit 1                    
    } 

    # Make a copy of the config for web page
    CopyCfgFile

    return 0
}

#############################################################################
# This is done because we need a copy of the SPO config file that has a name
# that will allow the web page to find it for a particular test case.
#############################################################################
function CopyCfgFile {
    
   Src="$AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP"
   Dst="$AUTO_WORK_DIR/$AUTO_SUITE_RUN_ID.$AUTO_TEST_RUN_ID."
   Dst="${Dst}$AUTO_CURRENT_TEST_ID.$AUTO_CURRENT_CONFIG.spo_conf"

   CpOutput=$(CopyFile $Src $Dst)
}


# Does the final update to the suite result record
function UpdateSuiteResultFinal {

    typeset RunTime="$1"
    typeset Result=$(_GetSuiteResult)

    typeset SetClause="SET suite_result_result='$Result', suite_result_run_length=$RunTime, suite_result_original_result='$Result'"
    
    # Call the update from splex.ksh
    _UpdateSuiteResult "$SetClause"

}

function  _InsertTestResultLogFile {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    $AUTO_ROOT_DIR/TestLogInsert.py "$AUTO_TC_RESULT_ID" "$AUTO_TEST_CASE_LOG"
}

# Evaluates current test case and writes failure or passed to suite log
#function EvalTestResult {
#
    #[[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
#
    #typeset TestResultCode=$1
#
    ## Search for failed commands in test case log
    #if grep "Failed::" $AUTO_TEST_CASE_LOG; then
#
#
        ### Check if failures causes testcase to be skipped
        #grep "skipped_test" $AUTO_TEST_CASE_LOG
##
        ## If it's true that there are skips
        #if grep "skipped_test" $AUTO_TEST_CASE_LOG; then
            #SkipTest
        #else    # No skips, this is a failed test
            #FailTest  
        #fi

    #else    # No failures, pass the test
        #PassTest
    #fi
#
    ##_InsertTestResultLogFile
#}




# Evaluates current test case and writes failure or passed to suite log
function EvalTestResult {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset TestResultCode=$1

    # If it's true that there are skips
    if grep "skipped_test" $AUTO_TEST_CASE_LOG; then
        SkipTest
        return
    fi
 
    # Search for failed commands in test case log
    if grep "Failed::" $AUTO_TEST_CASE_LOG; then
        FailTest  
    else   
        PassTest
    fi

    #_InsertTestResultLogFile
}


function PassTest {
    printf '%-8s\n' "Passed" >> $AUTO_SUITE_LOG

    # Print result to xml file
    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t\t\t<Result>Pass</Result>" >> $AUTO_XML_FILE
    fi

    typeset C="SET TC_RESULT='P', TC_RESULT_ORIGINAL_RESULT='P', TC_RESULT_RUN_LENGTH=$AUTO_TC_TIME"

    _UpdateTestResult "$C"
}


function FailTest {
    printf '%-8s\n' "Failed" >> $AUTO_SUITE_LOG

    # Print result to xml file
    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t\t\t<Result>Fail</Result>" >> $AUTO_XML_FILE
    fi


    # Update record in test results table of repository
    _UpdateTestResult "SET TC_RESULT='F', TC_RESULT_ORIGINAL_RESULT='F', TC_RESULT_RUN_LENGTH=$AUTO_TC_TIME"

    # Update record in suite results table of  repository
    _UpdateSuiteResult "SET suite_result_result='F', suite_result_original_result='F'"
}



function SkipTest {
    printf '%-8s\n' "Skipped" >> $AUTO_SUITE_LOG

    # Print result to xml file
    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t\t\t<Result>Skipped</Result>" >> $AUTO_XML_FILE
    fi
}

function SuiteLogHeader {

    print "<HTML>\n<BODY>"                          > $AUTO_WEB_MSTR_SUITE_LOG  
    print "<TABLE width=780><TR><TD width=\"25%\">TIME</TD>" >> $AUTO_WEB_MSTR_SUITE_LOG
    print "\t\t<TD width=\"25%\">CONFIG</TD>"      >> $AUTO_WEB_MSTR_SUITE_LOG
    print "\t\t<TD width=\"25%\">TESTCASE</TD>"    >> $AUTO_WEB_MSTR_SUITE_LOG
    print "<TD width=\"25%\">RESULT</TD></TR>"     >> $AUTO_WEB_MSTR_SUITE_LOG
}

function CreateXMLFile {

    #
    AUTO_XML_FILE="$AUTO_XML_DIR/$AUTO_TESTER.$AUTO_MASTER_SUITE.$AUTO_MASTER_SUITE_PID" 

    # If xml file doesn't exist then this must be the first suite in the master suite list
    # So the xml file needs to be created. If it exists then the existing file will be used
    # for the rest of the test cases in the current suite
    if [[ ! -f $AUTO_XML_FILE ]]; then
        print "Createing xml file:$AUTO_XML_FILE"
        CreateFile $AUTO_XML_FILE 666
     
        # Print xml header to xml file
        print "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>" > $AUTO_XML_FILE
        print "\t<AutomationRun>"                                             >> $AUTO_XML_FILE
        print "\t\t<MasterSuite name=\"$AUTO_MASTER_SUITE\">"                 >> $AUTO_XML_FILE
        
    fi


    # The reset will always go in xml file for a new suite
    print "\t\t\t<Suite name=\"$AUTO_CURRENT_SUITE\">"  >> $AUTO_XML_FILE

}


function PrintXMLEnvInfo {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then

        print "\t\t\t\t<Environment name=\"$AUTO_ENV_FILE\">"            >> $AUTO_XML_FILE
        print "\t\t\t\t\t<Source>"                                          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Host>$AUTO_SRC_HOST_NAME</Host>"                >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Sid>$AUTO_SRC_SID</Sid>"                        >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraHome>$AUTO_SRC_ORA_HOME</OraHome>"           >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraVer>$AUTO_SRC_ORA_VER</OraVer>"              >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraSVer>$AUTO_SRC_ORA_S_VER</OraSVer>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<TnsName>$AUTO_SRC_TNS_NAME</TnsName>"           >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Platform>$AUTO_SRC_PLATFORM</Platform>"         >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexVer>$AUTO_SRC_SPO_VER</SplexVer>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexOpt>$AUTO_SRC_OPT_DIR</SplexOpt>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexVar>$AUTO_SRC_VAR_DIR</SplexVar>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t</Source>"                                         >> $AUTO_XML_FILE
        print "\t\t\t\t\t<Destination>"                                     >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Host>$AUTO_DST_HOST_NAME</Host>"                >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Sid>$AUTO_DST_SID</Sid>"                        >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraHome>$AUTO_DST_ORA_HOME</OraHome>"           >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraVer>$AUTO_DST_ORA_VER</OraVer>"              >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<OraSVer>$AUTO_DST_ORA_S_VER</OraSVer>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<TnsName>$AUTO_DST_TNS_NAME</TnsName>"           >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<Platform>$AUTO_DST_PLATFORM</Platform>"         >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexVer>$AUTO_DST_SPO_VER</SplexVer>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexOpt>$AUTO_DST_OPT_DIR</SplexOpt>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<SplexVar>$AUTO_DST_VAR_DIR</SplexVar>"          >> $AUTO_XML_FILE
        print "\t\t\t\t\t</Destination>"                                    >> $AUTO_XML_FILE
        
        
    fi
}

function PrintXMLCfgInfo {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t<SplexConfig name=\"$AUTO_CURRENT_CONFIG\">"     >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t<FileContents>"                                >> $AUTO_XML_FILE
        print "`cat $AUTO_WORK_DIR/$AUTO_CURRENT_CONF_TMP`"               >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t</FileContents>"                               >> $AUTO_XML_FILE
    fi

}

function PrintXMLCfgFooter {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t</SplexConfig>" >> $AUTO_XML_FILE
    fi
}

function PrintXMLTCInfo {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t\t<TestCase name=\"$AUTO_CURRENT_TEST_ID\">"     >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t\t<Location>$AUTO_CURRENT_TEST</Location>"     >> $AUTO_XML_FILE
        print "\t\t\t\t\t\t\t<Log>$AUTO_TEST_CASE_LOG</Log>"              >> $AUTO_XML_FILE
    fi

}

function PrintXMLTCFooter {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t\t\t</TestCase>"  >> $AUTO_XML_FILE
    fi
}

function RemoveXML_LastFooter {

       typeset TempFile="$AUTO_TEMP_DIR/tmp$$"

       cat $AUTO_XML_FILE | sed "s/$from/$to/g" > $TempFile

                if [ -s $TempFile ]
                then
                   mv $TempFile $AUTO_XML_FILE
                fi

}


function PrintXML_EnvFooter {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t</Environment>" >> $AUTO_XML_FILE
        print "\t\t\t</Suite>"         >> $AUTO_XML_FILE
        print "\t\t</MasterSuite>"     >> $AUTO_XML_FILE
        print "\t</AutomationRun>"     >> $AUTO_XML_FILE
    fi

}

function PrintXMLFooter {
    
    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t\t\t</Environment>" >> $AUTO_XML_FILE
        print "\t\t\t</Suite>"         >> $AUTO_XML_FILE
        print "\t\t</MasterSuite>"     >> $AUTO_XML_FILE
        print "\t</AutomationRun>"     >> $AUTO_XML_FILE
    fi

}

function PrintXML_MSFooter {

    if [[ $AUTO_XML_GEN_FLAG = $TRUE ]]; then
        print "\t\t</MasterSuite>"     >> $AUTO_XML_FILE
        print "\t</AutomationRun>"     >> $AUTO_XML_FILE
    fi

}

#############################################################################
# Just prints out all the exports' values
#############################################################################
function PrintExports {
        print "#############################################"
        print "#                  EXPORTS"                   
        print "#############################################"
        set | grep "AUTO_"
}


###########################################################################
# Function Name: GenUniqueId                     Date Created:4/28/2004
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Generates a unique number based on time and PID
#
# Usage: GenUniqueId
#
# Output/Return: Unique Id printed to stdout
#
# Ex: MyNum=$(GenUniqueId)
###########################################################################
function GenUniqueId {

    #typeset Hour=`date +"%H"`
    #typeset Min=`date +"%M"`
    #typeset Sec=`date +"%S"`
    #typeset Year=`date +"%y"`
    #typeset Day=`date +"%e"`
    #typeset Mnth=`date +"%m"`
    #typeset Pid=$$

    #typeset TheNum
            
    #((TheNum=$Hour+$Min+$Sec+$Year+$Day+$Mnth+$Pid))
    
    TheNum=$RANDOM
    print "$TheNum"

}

################################################################################
# gets the nextval of the given sequence
################################################################################
function GetSeqNextVal {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset SeqName=$1

typeset SQL="

    SET FEEDBACK OFF;
    SET SERVEROUTPUT ON;
    SELECT 'result=' || $SeqName.NEXTVAL FROM DUAL;
"

    typeset Result=$(_RepositorySqlGet "$SQL" "1")

    print $Result 
}


###########################################################################
# Writes the diff between 2 times to a file
###########################################################################
function WriteTime {

    typeset Start=$1
    typeset End=$2
    typeset Info=$3 # testcase or suite name
    typeset File=$4
    typeset RunId=$5

    ((Seconds=$End-$Start))

    typeset Today=`date +"%D"`
    typeset Host=`hostname`
    typeset Src=$AUTO_SRC_HOST_NAME
    typeset Dst=$AUTO_DST_HOST_NAME
    typeset SrcSid=$AUTO_SRC_SID
    typeset DstSid=$AUTO_DST_SID
    

    #print "$Today:$RunId:$Info:$Seconds:$Host:$Src:$Dst" >> $File

    #print "$Today:$RunId:$Info:$Seconds:$Host:$Src:$Dst:$SrcSid:$DstSid" >> $File

    export SUITE_EXE_TIME="$Seconds"
    print "$Seconds"
}

###########################################################################
# Inserts the suite result into the repository. AUTO_SUITE_RESULT_ID
# will be exported to hold the value of the new record it creates.
###########################################################################
function InsertSuiteResults {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    #typeset Result=$(_GetSuiteResult)


typeset SQL="

SET FEEDBACK OFF
SET SERVEROUTPUT ON

DECLARE
   ID   NUMBER (10);
BEGIN
   INSERT INTO AUTO.SUITE_RESULTS (SUITE_RESULT_ID,
                                   SUITE_RESULT_DATE,
                                   SUITE_RESULT_RUN_LENGTH,
                                   SUITE_RESULT_RUN_ID,
                                   SUITE_RESULT_RESULT,
                                   SUITE_RESULT_FAILURE_REASON,
                                   SUITE_RESULT_COMMENTS,
                                   SUITE_RESULT_SUITE_NAME,
                                   SUITE_RESULT_MSTR_ID,
                                   SUITE_DB_SECUREFILE,
                                   SUITE_TABLESPACE_COMPRESSION,
                                   SUITE_TDE,
                                   SUITE_SECUREFILE_ATTR,
                                   SUITE_PRESCAN)
        VALUES (
                  AUTO.SEQ_SUITE_RESULT_ID.NEXTVAL,
                  SYSDATE,
                  0,
                  $AUTO_SUITE_RUN_ID,
                  'I',
                  '',
                  'comments',
                  '$AUTO_CURRENT_SUITE',
                  '$AUTO_MSTR_SUITE_RESULT_ID',
                  '$AUTO_DB_SECUREFILE',
                  '$AUTO_TABLESPACE_COMPRESSION',
                  DECODE (
                     '$AUTO_SRC_TDE',
                     0, 'Y',
                     NULL),
                  DECODE (
                     '$AUTO_SECUREFILE_LOB',
                     'qa_modify_lob_compress_high', 'compress high',
                     'qa_modify_lob_compress_medium', 'compress medium',
                     'qa_modify_lob_medium_cache', 'compress medium cache',
                     'qa_modify_lob_high_cache', 'compress high cache',
                     'qa_modify_lob_cache', 'cache',
                     'qa_modify_lob_mix', 'mix',
                     'qa_modify_lob_deduplicate', 'deduplicate',
                     'qa_modify_lob_keep_duplicates', 'keep duplicates',
                     NULL),
		  DECODE (
                     '$AUTO_DST_PRESCAN',
                     1, 'Y',
                     0, 'N',
                     NULL))
     RETURNING suite_result_id
          INTO ID;

   DBMS_OUTPUT.put_line ('result=' || ID);
END;
/

COMMIT;
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
        print "into the suite results table"
        print "******************* WARNING *********************"
        print "\n$Output"

        #print "\nPres ctrl-C to abort, or enter to continue: "
        #read x
    }
        
    export AUTO_SUITE_RESULT_ID=${Output#*result=} 

}


# Checks the suite log for failures and returns F or P
function _GetSuiteResult {

    typeset Result=""

    if grep "SUITE_SKIPPED" $AUTO_SUITE_LOG 2>&1 > /dev/null; then
        Result="S"
    else
        grep "Fail" $AUTO_SUITE_LOG 2>&1 > /dev/null && Result="F" || Result="P"
    fi

    #grep "SUITE_SKIPPED" $AUTO_SUITE_LOG 2>&1 > /dev/null && { Result="S" } || {
    #        grep "Fail" $AUTO_SUITE_LOG 2>&1 > /dev/null && Result="F" || Result="P" 
    #}

    print "$Result"

}

function DriverUsage {

    S="ERROR: Suite: $AUTO_CURRENT_SUITE is invalid" 

    M="${S}\nUsage: ./driver env_file config_file test_file error_option run_option\n" 
    M="${M}===========================================================\n" 
    M="${M}print env_file - environment file list\n"  
    M="${M}config_file - config file list\n" 
    M="${M}test_file - test suit list\n" 
    M="${M}error_option - 'c' run cleanup procedure and continue the test suit in case of an error\n"  
    M="${M}error_option - 'y'for continue the test suit in case of an error\n"
    M="${M}error_option - 'n' for NOT continue the test suit in case of an error\n"
    M="${M}run_option - 'a' to run ALL the tests in a loop\n"
    M="${M}run_option - 'p' to run a test PAIRED with a config\n"
    M="${M}For the files, use only names without path.\n"

    print "$M"

    SendEMail "$S" "$M"

    exit 1
}

###########################################################################
# Function Name: TEMPLATE                     Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description:
#
# Usage: 
#
# Output/Return:
#
# Ex:
###########################################################################
function RunTestCase {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    print "\n#############################################"
    print "# START TEST: Test $AUTO_CURRENT_TEST"
    print "#\t`date`"
    print "#############################################\n"

    print "Running Test $AUTO_CURRENT_TEST"
    print "Using Config $AUTO_CURRENT_CONFIG"

    cwd=$AUTO_CURRENT_TEST_ID #TODO: remove later

    SetupTestLog

    #TODO: Remove this when they are all removed from splex.ksh 
    export log_file=$AUTO_TEST_CASE_LOG

    Tm=`date +"%H%M%S"`

    printf '%-8s %-16s %-35s %-22s\c' "$AUTO_TEST_RUN_ID" "$Tm" \
        "$AUTO_CURRENT_CONFIG" "$AUTO_CURRENT_TEST" >> $AUTO_SUITE_LOG


    PrintExports


    _InsertTCResult

    TCStartTime=`date +"%s"`
    $AUTO_CURRENT_TEST/main.ksh $AUTO_CURRENT_CONFIG
    TCResult=$?
    TCEndTime=`date +"%s"`

    sec=$(WriteTime $TCStartTime $TCEndTime "$AUTO_CURRENT_TEST_ID" "$AUTO_TEST_TIMES" "$AUTO_TEST_RUN_ID")

    export AUTO_TC_TIME=$sec

    EvalTestResult $TCResult

    print "\n#############################################"
    print "# FINISHED TEST: $AUTO_CURRENT_TEST"
    print "#\t`date`"
    print "#############################################\n"

    return "$TCResult"
}

###########################################################################
# Gets the testcase id from the repository for the given testcase dir
###########################################################################
function _GetTestId {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

typeset SQL="

SET FEEDBACK OFF
SET SERVEROUTPUT ON
SELECT 'result=' || test_id FROM auto.test_cases
WHERE test_file_dir = '$AUTO_CURRENT_TEST'
AND test_version = (
 SELECT MAX(test_version)
 FROM test_cases 
 WHERE test_file_dir='$AUTO_CURRENT_TEST'
);
"

    typeset Result=$(_RepositorySqlGet "$SQL")

    [[ "$Result" == "" ]] && {
        print "#######`date`##################" >> $AUTO_REP_ERROR_FILE
        print "FAILED TO GET TEST ID FOR TEST_FILE_DIR " >> $AUTO_REP_ERROR_FILE
        print "test_file_dir = $AUTO_CURRENT_TEST" >> $AUTO_REP_ERROR_FILE
        Result="0"
    }

    print "$Result"

}

function _RepositorySqlGet {

    typeset SQL="$1"
    typeset Pause=${2:-""} # if set to value, pause on sql errors

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql "$AUTO_REP_UID" "$AUTO_REP_PWD" "$AUTO_REP_NAME" "$SQL") || {
        LogIt "Failed:: $0 encountered errors while connecting to Oracle"
        LogIt "$Output"
        LogFunctEnd $0 "$@"
        return $FALSE
    } 
  
    # Log errors to a file and allow automation to continue
    print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {

        print "#######`date`##################" >> $AUTO_REP_ERROR_FILE
        print "Test: $AUTO_CURRENT_TEST" >> $AUTO_REP_ERROR_FILE
        print "Suite: $AUTO_CURRENT_SUITE" >> $AUTO_REP_ERROR_FILE
        print "SQL:\n$SQL" >> $AUTO_REP_ERROR_FILE
        print "$Output" >> $AUTO_REP_ERROR_FILE

        #[[ -n "$Pause" ]] && {
        #    print "\nPres ctrl-C to abort, or enter to continue: "
        #    read x
        #}
        
        Result="0"

    } || {
        Result=${Output#*result=} 
    }

    print "$Result"
 
}


###########################################################################
###########################################################################
function _InsertTCResult {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    export AUTO_REP_TEST_ID=$(_GetTestId)

typeset SQL="

SET FEEDBACK OFF
SET SERVEROUTPUT ON
DECLARE
    ID number(10);
BEGIN

    INSERT INTO AUTO.TESTCASE_RESULTS (
        TC_RESULT_ID,
        TC_RESULT_SUITE_ID,
        TC_RESULT_RUN_ORDER, 
        TC_RESULT_DATE, 
        TC_RESULT_RUN_ID, 
        TC_RESULT, 
        TC_RESULT_FAILURE_REASON, 
        TC_RESULT_CONFIG,
        TC_RESULT_RUN_LENGTH,
        TC_RESULT_TEST_ID,
        TC_RESULT_LOG_LOCATION
        ) 
    VALUES ( 
        AUTO.SEQ_TESTCASE_RESULT_ID.NEXTVAL,
        $AUTO_SUITE_RESULT_ID,
        $AUTO_TEST_NUMBER,
        sysdate,
        $AUTO_TEST_RUN_ID,
        'I',
        '',
        '$AUTO_CURRENT_CONFIG',
        0,
        $AUTO_REP_TEST_ID,
        '$AUTO_TEST_CASE_LOG'
    )
    RETURNING tc_result_id into ID;
    dbms_output.put_line('result=' || ID );
END;
/
commit;
"

    typeset Result=$(_RepositorySqlGet "$SQL" "1")

    # check if got just a number, if so export it
    [[ "$Result" = *[0-9] ]] && export AUTO_TC_RESULT_ID=$Result

    # Check for oracle errors and show them if found
    Errors=$(_GetOraErr "${Output}") && LogIt "$Errors"
}


function SuiteCleanUp {
 
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    TestResultCode=$1

    if [[ "$TestResultCode" = 127 ]]; then
        print "##################### TEST FAILED EXIT SUITE  ######"
        cleanup_splex src
        cleanup_splex dst
        EndSuite
    fi


}

function EndSuite {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '
    SuiteEndTime=`date +"%s"`
    Seconds=$(WriteTime $AUTO_SUITE_START_TIME $SuiteEndTime "$AUTO_CURRENT_SUITE" "$AUTO_SUITE_TIMES" "$AUTO_SUITE_RUN_ID")
    print "End time is: `date` " >> $AUTO_SUITE_LOG
    #Ilya 031814
    #mail $AUTO_USER_EMAIL -s "Your Suite $suite_name is finished" < $AUTO_SUITE_LOG
    mail -s "Your Suite $suite_name is finished" $AUTO_USER_EMAIL < $AUTO_SUITE_LOG
    
    print "\n#############################################"
    print "# FINISH SUITE: $suite_name"
    print "#\t`date`"
    print "#############################################\n"


    UpdateSuiteResultFinal $Seconds

    print "Exiting this suite...."
    exit 0
}



###########################################################################
# Function Name: ChkSkipFlags                     Date Created: 07/18/2007
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com)
# Description: Check if flags are set that indicate if a suite should be 
#              skipped if certain conditions are met.
###########################################################################
function ChkSkipFlags {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Check if any oracle versions should not be skipped.
    _ChkOraSkips || return $FALSE

    #Windows
    _CheckWindowsSkip || return $FALSE

    # SPO Version
    _CheckSpoVersionSkip || return $FALSE

    # Oracle Char sets different
    _CheckOraCharSetDiffSkip || return $FALSE

    # SPO version different
    _CheckSpoVerDiffSkip || return $FALSE

    # Check if src or dst char set matches a char set in the list of only char sets to run on
    _CheckOnlyCharSetList || return $FALSE

    # RAC
    _CheckRACSkip || return $FALSE

    # Src ora version > target ora version
    _CheckSrcOraGreaterDst || return $FALSE

    # Dst ora version > source ora version
    _CheckDstOraGreaterSrc || return $False

#juliatde    # Src TDE enabled
    _CheckSrcTdeSkip || return $False

    # No flags set. Return true to continue testing.

#juliatde    # Src TDE disabled
    _CheckSrcNonTdeSkip || return $False

    # No flags set. Return true to continue testing.
    return $TRUE

}

function _CheckRACSkip {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    [[ -n $AUTO_SKIP_SUITE_RAC ]] && {

        [[ "$AUTO_ORACLE_RAC" == "$TRUE" ]] && {
            print "You set flag to skip RAC"
            return $FALSE
        }

    }

    # No RAC to skip. Return true to continue testing.
    return $TRUE

}

function _ChkOraSkips {

    # Check for Oracle 8i flag
    [[ -n $AUTO_SKIP_SUITE_ORA_8I ]] && { 

        # Skip if source or target is 8i
        [[ $AUTO_SRC_ORA_S_VER == "8i" || $AUTO_DST_ORA_S_VER == "8i" ]] && { 
            print "You set flag to skip Oracle 8i "
            return $FALSE
        }

    }

    # Check for Oracle 9i flag
    [[ -n $AUTO_SKIP_SUITE_ORA_9I ]] && { 

        # Skip if source or target is 9i
        [[ $AUTO_SRC_ORA_S_VER == "9i" || $AUTO_DST_ORA_S_VER == "9i" ]] && { 
            print "You set flag to skip Oracle 9i"
            return $FALSE
        }

    }

    # Check for Oracle 10g flag
    [[ -n $AUTO_SKIP_SUITE_ORA_10G ]] && { 

        # Skip if source or target is 10g 
        [[ $AUTO_SRC_ORA_S_VER == "10g" || $AUTO_DST_ORA_S_VER == "10g" ]] && { 
            print "You set flag to skip Oracle 10g"
            return $FALSE
        }

    }

    # Check for Oracle 11g flag
    [[ -n $AUTO_SKIP_SUITE_ORA_11G ]] && { 

        # Skip if source or target is 11g 
        [[ $AUTO_SRC_ORA_S_VER == "11g" || $AUTO_DST_ORA_S_VER == "11g" ]] && { 
            print "You set flag to skip Oracle 11g"
            return $FALSE
        }

    }


    # Check for Oracle 11gR1 flag
    [[ -n $AUTO_SKIP_SUITE_ORA_SRC_11G1 ]] && { 

        # Skip if source is 11gR1 
        [[ $AUTO_SRC_ORA_S_VER == "110" ]] && { 
            print "You set flag to skip source Oracle 11gR1"
            return $FALSE
        }

    }

    # Check for Oracle 12c flag
    [[ -n $AUTO_SKIP_SUITE_ORA_12c ]] && { 

        # Skip if source or target is 12c 
        [[ $AUTO_SRC_ORA_S_VER == "12c" || $AUTO_DST_ORA_S_VER == "12c" ]] && { 
            print "You set flag to skip Oracle 12c"
            return $FALSE
        }

    }


    # No Oracle versions to skip. Return true to continue testing.
    return $TRUE

}





function _CheckSpoVersionSkip {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # If export is not set then nothing to skip. 
    [[ -z $AUTO_SKIP_SUITE_SPO_VER ]] && return $TRUE

    # Function for checking if SPO version is lower than the version to skip
    function _CompareSpoVersions {

        [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

        SPOVersion=$1
        SkipVersion=$(echo "$2" | sed "s/[X|x]/9999/g")

        # Get the source spo ver and split it up
        _InitGlobalArray "$SPOVersion" "."
        SpoNum1="${AUTO_GLOBAL_ARRAY[0]}"
        SpoNum2="${AUTO_GLOBAL_ARRAY[1]:=0}"
        SpoNum3="${AUTO_GLOBAL_ARRAY[2]:=0}"
        SpoNum4="${AUTO_GLOBAL_ARRAY[3]:=0}"

        # Get the spo version to skip and split it up
        _InitGlobalArray "$SkipVersion" "."
        SkipNum1="${AUTO_GLOBAL_ARRAY[0]:=0}"
        SkipNum2="${AUTO_GLOBAL_ARRAY[1]:=0}"
        SkipNum3="${AUTO_GLOBAL_ARRAY[2]:=0}"
        SkipNum4="${AUTO_GLOBAL_ARRAY[3]:=0}"

 
        # if 1st number on source is < 1st number of version to skip, then skip and return
        if (( $SpoNum1 <  $SkipNum1 )); then
            return  0

        # if 1st number on source is equal to 1st number of version to skip then
        # go on to eval the 2nd number
        elif (( $SpoNum1 == $SkipNum1 )); then


            # if 2nd number on source is < 2nd number of ver to skip, then skip and return
            if (( $SpoNum2 < $SkipNum2 )); then
                return  0

            # if 2nd num on src is equal to 2nd num of ver to skip then go on to eval 3rd num
            elif (( $SpoNum2 == $SkipNum2 )); then

                # if 3rd number on source is < 3rd number of ver to skip, then skip and return
                if (( $SpoNum3 < $SkipNum3 )); then
                    return  0

                # if 3rd num on src is equal to 3rd num of ver to skip then go on to eval 4th num
                elif (( $SpoNum3 == $SkipNum3 )); then

                    # if 4th num on src is < 4th num of ver ti skip, then skip and return
                    if (( $SpoNum4 < $SkipNum4 )); then
                        return  0
                    fi

                fi

            fi

        fi

        # Nothing to skip
        return 1

    } # END FUNCTION


    _CompareSpoVersions $AUTO_SRC_SPO_VER $AUTO_SKIP_SUITE_SPO_VER
    SrcResult=$?


    _CompareSpoVersions $AUTO_DST_SPO_VER $AUTO_SKIP_SUITE_SPO_VER
    DstResult=$?

    # Check if src or dst should be skipped. If so return false.
    if (( $SrcResult == 0 || $DstResult == 0 )); then
        print "Skipping: src($AUTO_SRC_SPO_VER) or dst($AUTO_DST_SPO_VER) SPO version is less than $AUTO_SKIP_SUITE_SPO_VER"
        return $FALSE 
    fi
    #else
    #    print "SPO Version Check: Not Skipping"
    #fi


    # retrun true, nothing to skip
    return $TRUE

}

















function _CheckSpoVersionSkip_OLD {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # If the flag to skip a suite is set. Then check if this suite should be skipped
    [[ -n $AUTO_SKIP_SUITE_SPO_VER ]] && {

        # Get the source spo ver and split it up
        _InitGlobalArray "$AUTO_SRC_SPO_VER" "."
        SrcNum1="${AUTO_GLOBAL_ARRAY[0]}"
        SrcNum2="${AUTO_GLOBAL_ARRAY[1]}"
        SrcNum3="${AUTO_GLOBAL_ARRAY[2]}"

        # Get the spo version to skip and split it up
        _InitGlobalArray "$AUTO_SKIP_SUITE_SPO_VER" "."
        SkipNum1="${AUTO_GLOBAL_ARRAY[0]}"
        SkipNum2="${AUTO_GLOBAL_ARRAY[1]}"
        SkipNum3="${AUTO_GLOBAL_ARRAY[2]}"

        # Logic to compare the skip pattern
        if [[ $SrcNum1 -le  $SkipNum1 ]]; then

            if [[ "$SkipNum2" == "X" ]]; then
                print "skipping $AUTO_CURRENT_SUITE,  $AUTO_SRC_SPO_VER matches $AUTO_SKIP_SUITE_SPO_VER"
                return  $FALSE
            fi

            if [[ $SrcNum2 -le $SkipNum2 ]]; then

                if [[ "$SrcNum3" == "$SkipNum3" ]]; then 
                    print "skipping $AUTO_CURRENT_SUITE, $AUTO_SRC_SPO_VER matches $AUTO_SKIP_SUITE_SPO_VER"
                    return $FALSE 
                fi

                if [[ "$SkipNum3" == "X" ]]; then
                    print "skipping $AUTO_CURRENT_SUITE, $AUTO_SRC_SPO_VER matches $AUTO_SKIP_SUITE_SPO_VER"
                    return $FALSE 
                fi

            fi

        fi

    }

    return $TRUE

}


function _CheckOnlyCharSetList {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # See if export is set to  run only on specific char sets
    [[ -n "$AUTO_ONLY_CHAR_SETS" ]] && {

        # Check if src or dst char set is in the list of char sets to run 
        _InitGlobalArray "$AUTO_ONLY_CHAR_SETS" ":"
        _IsInArray "$AUTO_SRC_CHAR_SET" == $TRUE && return $TRUE
        _IsInArray "$AUTO_DST_CHAR_SET" == $TRUE && return $TRUE

        # if havn't returned TRUE by now, then return false so this suite is skipped.
        print "Skipping. Char set check didn't find $AUTO_SRC_CHAR_SET or $AUTO_DST_CHAR_SET in list"
        return $FALSE
    }

    return $TRUE    

}


function _CheckOraCharSetDiffSkip {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # See if export is set to skipp when char sets are different
    [[ -n "$AUTO_SKIP_SUITE_DIFF_CHAR_SET" ]] && {

        # See if char sets are different
        [[ "$AUTO_SRC_CHAR_SET" != "$AUTO_DST_CHAR_SET" ]] && {
            print "Skipping. Different char sets. $AUTO_SRC_CHAR_SET is not equal to $AUTO_DST_CHAR_SET"
            return $FALSE
        }

    }

    #Return true to continue testing.
    return $TRUE
}


function _CheckSpoVerDiffSkip {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # See if export is set to skipp when spo versions are different
    [[ -n "$AUTO_SKIP_SUITE_DIFF_SPO_VER" ]] && {

        # See if versions are different
        [[ "$AUTO_SRC_SPO_VER" != "$AUTO_DST_SPO_VER" ]] && {
            print "Skipping. Different SPO Versions. $AUTO_SRC_SPO_VER is not equal to $AUTO_DST_SPO_VER"
            return $FALSE
        }

    }

    #Return true to continue testing.
    return $TRUE
}


function _CheckWindowsSkip {

    # Check for windows should be skipped
    [[ -n $AUTO_SKIP_SUITE_WINDOWS ]] && { 

        # Skip if source or target is windows 
        [[ $AUTO_SRC_PLATFORM == $WINDOWS || $AUTO_DST_PLATFORM == $WINDOWS ]] && { 
            print "You set flag to skip Windows"
            return $FALSE
        }

    }

    #Return true to continue testing.
    return $TRUE
}

function _CheckSrcOraGreaterDst {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    [[ -n "$AUTO_SKIP_SUITE_SRC_ORA_GREATER" ]] && {


#9-28-2011 Julia: to enable comparison of 110 and 11g(=11gR2)
#10-11-2011 modify previous change since Kevin got error on alvqasl42 _CheckSrcOraGreaterDst: ./driver[99]: : bad substitution
#1-13-2016 remove mapping 11g to 112 since 112 > 12 (12c) and we don't test 11gR1 any more

 
#     if [[ $AUTO_SRC_ORA_S_VER == '11g' ]]; then
#        SrcOraNum="112"
#     else
        SrcOraNum="${AUTO_SRC_ORA_S_VER%%[a-z]}"
#     fi

#     if [[ $AUTO_DST_ORA_S_VER == '11g' ]]; then
#        DstOraNum="112"
#     else
        DstOraNum="${AUTO_DST_ORA_S_VER%%[a-z]}"
#     fi


        typeset SkipMsg="Oracle Version Check:Skipping. Source oracle version($AUTO_SRC_ORA_S_VER) is greater than target($AUTO_DST_ORA_S_VER)"

        if [[ $SrcOraNum -gt $DstOraNum ]]; then
            print "$SkipMsg"
            return $FALSE
        fi

    }

    #Return true to continue testing.
    return $TRUE

}


function _CheckDstOraGreaterSrc {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    [[ -n "$AUTO_SKIP_SUITE_DST_ORA_GREATER" ]] && {


        SrcOraNum="${AUTO_SRC_ORA_S_VER%%[a-z]}"
        DstOraNum="${AUTO_DST_ORA_S_VER%%[a-z]}"

        typeset SkipMsg="Oracle Version Check:Skipping. Target oracle version($AUTO_DST_ORA_S_VER) is greater than source($AUTO_SRC_ORA_S_VER)"

        if [[ $DstOraNum -gt $SrcOraNum ]]; then
            print "$SkipMsg"
            return $FALSE
        fi

    }

    #Return true to continue testing.
    return $TRUE

}

#juliatde
function _CheckSrcTdeSkip {
 
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Check if src tde is enabled 
    # [[  -n "$AUTO_SKIP_SUITE_TDE" && "$AUTO_SRC_TDE" -eq 0 ]] && { 
    [[  -n "$AUTO_SKIP_SUITE_TDE" && "$AUTO_SRC_TDE" = "0" ]] && { 

             print "skipping ${AUTO_CURRENT_SUITE}, TDE is enabled on ${AUTO_SRC_HOST_NAME} ${this_vardir}/data/paramdb or connections.yaml."
             return $FALSE 

    }

    #Return true to continue testing.
    return $TRUE
}


function _CheckSrcNonTdeSkip {
 
    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    # Check if src tde is disabled 
    # [[  -n "$AUTO_SKIP_SUITE_NON_TDE" && "$AUTO_SRC_TDE" -eq 1 ]] && { 
    [[  -n "$AUTO_SKIP_SUITE_NON_TDE" && "$AUTO_SRC_TDE" != "0" ]] && {

             print "skipping ${AUTO_CURRENT_SUITE}, TDE is disabled on ${AUTO_SRC_HOST_NAME} ${this_vardir}/data/paramdb or connections.yaml."
             return $FALSE 

    }

    #Return true to continue testing.
    return $TRUE
}


function _WriteSuiteSkipTxt {

    typeset Reason=$1
    print "SUITE_SKIPPED: $Reason\n" >> $AUTO_SUITE_LOG
}



###########################################################################
# Function Name: TEMPLATE                     Date Created:01/17/2008
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com)
# 
# Description: Queries the repository for information about the suite and
#              sets env variables.
#
###########################################################################
function GetSuiteInfo {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '


    typeset SQL="SELET * FROM auto.suites"

    Output=$(_RunRepositorySQL "$SQL") || {
        print "$0 failed to query repository for suite information.\n$Output\n "
        return $FALSE
    }

}


function _RunRepositorySQL {

    [[ -n "$AUTO_DEBUG" ]] && set -o xtrace;export PS4='$LINENO:$0: '

    typeset SQL=$1

    # Run ths sql. If connection problems occur then print errors and return 1
    Output=$(_ExecSql "$AUTO_REP_UID" "$AUTO_REP_PWD" "$AUTO_REP_NAME" "$SQL") || {
        print "$0 encountered errors while connecting to Oracle"
        return $FALSE
    }
  
    # Return false if oracle errors
    print "$Output" | egrep "(ORA|PLS|SP2|SQL|SLL|TNS)-" && {
        print "$0 Encountered the following repository error\n$Output"
        return $FALSE

    }
 
}




###########################################################################
# Function Name: TEMPLATE                     Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description:
#
# Usage: 
#
# Output/Return:
#
# Ex:
###########################################################################
