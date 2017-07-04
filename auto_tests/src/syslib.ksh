################################################################################
#                       ROLL OUTS TO EVERYONE
################################################################################
#09-13-04 v 1.9.2.42.2.61.2.34  rel-2-0-1
#01-05-2005 v1.1.2.1.2.2.2.3    rel-2-0-1

###########################################################################
# Function Name: ChkFileExists                     Date Created:01/19/2004
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: 
#
# Usage: ChkFileExists
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: CopyFile File1 File2               <-- STDOUT/STDERR sent to term
#     CopyOutput=$(CopyFile File1 File2) <-- STDOUT/STDERR stored in var
###########################################################################
function ChkFileExists {

    # Validate an argument was passed in, or error msg and return False
    if [ $# != 1 ]; then
        print "SYS-ERR: Must file name to $0"
        return 1
    fi

    typeset File=$1

    # Varify file exists or print error and return false
    if [ ! -f $File ]; then
        print "SYS-ERR: File: '$File' Not Found" 
        return 1
    fi

    # File exists, return True
    return 0
}

###########################################################################
# Function Name: CopyFile                         Date Created:11/15/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Wrapper function to the 'cp' command that copies the source
#     file to destination file with some validation. STDERR is redirected
#     to STDOUT so that you my call this function and have the output
#     stored into a variable. For example, Output=$(CopyFile f1 f2) will
#     copy the file, but if there are errors then the variable OutPut will
#     contain the error message of the 'cp' command. STDOUT is also stored
#     in this variable. On success, Output is null. Return value is 0. 
#
# Usage: CopyFile /path/to/source/file /path/to/dest/file
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: CopyFile File1 File2               <-- STDOUT/STDERR sent to term
#     CopyOutput=$(CopyFile File1 File2) <-- STDOUT/STDERR stored in var
###########################################################################
function CopyFile {

    # Validate 2 arguments where passed in
    if [ $# != 2 ]; then
        print "SYS-ERR: Must pass source and destination file to syslib.CopyFile"
        return 1
    fi

    # Assign arguments to local variables
    typeset SrcFileIn=$1
    typeset DstFileIn=$2

    # Local variables
    typeset CmdOut # Var to hold STDOUT and STDERR of copy command

    # Varify source file exists or print error and return false
    if [ ! -f $SrcFileIn ]; then
        print "SYS-ERR: Source file: '$SrcFileIn' - not found in syslib.CopyFile" 
        return 1
    fi

    # Do the copy or print error and return false
    CmdOut=`/bin/cp -p $SrcFileIn $DstFileIn 2>&1` || {
        print "SYS-ERR: Copy '$SrcFileIn' to '$DstFileIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Return true
    return 0
}


###########################################################################
# Function Name: MoveFile                         Date Created:11/15/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Wrapper function to the 'mv' command that moves the source
#     file to destination file with some validation. STDERR is redirected
#     to STDOUT so that you my call this function and have the output
#     stored into a variable. For example, Output=$(MoveFile f1 f2) will
#     move file1 to file2, but if there are errors then the variable OutPut
#     will contain the error message of the 'mv' command. STDOUT is also
#     stored in this variable. On success, Output is null, return val is 0. 
#
# Usage: MoveFile /path/to/source/file /path/to/dest/file
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: MoveFile File1 File2               <-- STDOUT/STDERR sent to term
#     MoveOutput=$(MoveFile File1 File2) <-- STDOUT/STDERR stored in var
#
###########################################################################
function MoveFile {

    # Validate 2 arguments where passed in
    if [ $# != 2 ]; then
        print "SYS-ERR: Must pass source and destination file to syslib.MoveFile"
        return 1
    fi

    # Assign arguments to local variables
    typeset SrcFileIn=$1
    typeset DstFileIn=$2

    # Local variables
    typeset CmdOut # Var to hold STDOUT and STDERR of move command

    # Varify source file exists or print error and return false
    if [ ! -f $SrcFileIn ]; then
        print "SYS-ERR: Source file: '$SrcFileIn' - not found in syslib.MoveFile" 
        return 1
    fi

    # Do the move or print error and return false
    CmdOut=`mv $SrcFileIn $DstFileIn 2>&1` || {
        print "SYS-ERR: Move '$SrcFileIn' to '$DstFileIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Return true
    return 0
}

###########################################################################
# Function Name: DeleteFile                        Date Created:11/15/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
#
# Description: Wrapper function to the 'rm' command that deletes the given 
#     file with some validation. STDERR is redirected to STDOUT so that you
#     my call this function and have the output stored into a variable. 
#     For example, Output=$(DeleteFile f1) will delete f1, but if there
#     are errors then the variable OutPut will contain the error message
#     of the 'mv' command. STDOUT is also stored in this variable. On 
#     success, Output is null, return val is 0. 
#
# Usage: DeleteFile /path/to/file
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: DeleteFile File1                 <-- STDOUT/STDERR sent to term
#     DeleteOutput=$(DeleteFile File1) <-- STDOUT/STDERR stored in var
#
###########################################################################
function DeleteFile {

    # Validate 1 argument was passed in
    if [ $# != 1 ]; then
        print "SYS-ERR: Must file name of file to delete to syslib.DeleteFile"
        return 1
    fi

    # Assign argument to local variable
    typeset SrcFileIn=$1

    # Local variables
    typeset CmdOut # Var to hold STDOUT and STDERR of delete command

    # Varify source file exists or print error and return false
    if [ ! -f $SrcFileIn ]; then
        print "SYS-ERR: Source file: '$SrcFileIn' - not found in syslib.DeleteFile" 
        return 1
    fi

    # Do the delete or print error and return false
    CmdOut=`rm -f $SrcFileIn 2>&1` || {
        print "SYS-ERR: Delete '$SrcFileIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Return true
    return 0
}

###########################################################################
# Function Name: CreateFile                         Date Created:11/15/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Wrapper function to the 'touch' command that creates the
#     given file with the optional permissions. Some validation is done.
#     STDERR is redirected to STDOUT so that you my call this function and
#     have the output stored into a variable. For example, 
#     Output=$(CreateFile f1 775) will create f1 with permissions of 775,
#     But if there are errors then the variable OutPut will contain the 
#     error message of the 'touch' command. STDOUT is also stored in this 
#     variable. On success, Output is null, return val is 0. 
#
# Usage: CreateFile /path/to/file -or- CreateFile /path/to/file 664
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: CreateFile File1 644                 <-- STDOUT/STDERR sent to term
#     CreateOutput=$(CreateFile File1 644) <-- STDOUT/STDERR stored in var
#
###########################################################################
function CreateFile {

    # Validate at least 1 argument was passed in
    if [ $# = 0 ]; then
        print "SYS-ERR: Must pass name of file to create to syslib.CreateFile"
        return 1
    fi

    # Assign argument to local variable
    typeset SrcFileIn=$1

    # Assign optional permissions to variable if second argument exists
    if [ $# = 2 ]; then
        typeset PermIn=$2
    fi

    # Local variables
    typeset CmdOut # Var to hold STDOUT and STDERR of touch command

    # Do the create or print error and return false
    CmdOut=`touch $SrcFileIn 2>&1` || {
        print "SYS-ERR: Create file '$SrcFileIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Set permissions of new file if user gave them
    if [ $PermIn ]; then
        CmdOut=`chmod $PermIn $SrcFileIn 2>&1` || {
            print "SYS-ERR: Set permissions to $PermIn on file '$SrcFileIn' unsuccessfull"
            print $CmdOut
            return 1
        }
    fi

    # Return true
    return 0
    
}

###########################################################################
# Function Name: CreateDir                          Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Wrapper function to the '/bin/mkdir' command that creates
#     the given file with the optional permissions. Some validation is done.
#     STDERR is redirected to STDOUT so that you my call this function and
#     have the output stored into a variable. For example, 
#     Output=$(CreateDir d1 775) will create dirctory d1 with permissions
#     of 775. But if there are errors then the variable OutPut will contain the 
#     error message of the 'mkdir' command. STDOUT is also stored in this 
#     variable. On success, Output is null, return val is 0. 
#
# Usage: CreateDir /path/to/file -or- CreateDirt /path/to/file 664
#
# Output/Return: 1 on failure, 0 on success, 3 if directory already exists.
#     Errors and warning if dir exists, are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: CreateDir File1 644                 <-- STDOUT/STDERR sent to term
#     CreateOutput=$(CreateDir File1 644) <-- STDOUT/STDERR stored in var
#
###########################################################################
function CreateDir {

    # Validate at least 1 argument was passed in
    if [ $# = 0 ]; then
        print "SYS-ERR: Must pass name of directory to create in syslib.CreateDir"
        return 1
    fi

    # Assign argument to local variable
    typeset SrcDirIn=$1

    # Assign optional permissions to variable if second argument exists
    if [ $# = 2 ]; then
        typeset PermIn=$2
    fi

    # Local variables
    typeset CmdOut # Var to hold STDOUT and STDERR of touch command

    # If directory already exists then print warning and return 3
    if [ -d $SrcDirIn ]; then
        print "SYS-WARN: Directory $SrcDirIn already exists"
        return 3
    fi

    # Do the create or print error and return false
    CmdOut=`/bin/mkdir $SrcDirIn 2>&1` || {
        print "SYS-ERR: Create directory '$SrcDirIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Set permissions of new file if user gave them
    CmdOut=$(SetPermissions $SrcDirIn $PermIn) || {
        print "SYS-ERR: Set permissions to $PermIn on file '$SrcDirIn' unsuccessfull"
        print $CmdOut
        return 1
    } 

    # Return true
    return 0
    
}

###########################################################################
# Function Name: SetPermissions                     Date Created:11/18/2003
###########################################################################
# Original Author: Tim Whetsel (tim.whetsel@quest.com, tdw55@netzero.net)
# 
# Description: Wrapper function to the '/bin/chmod' command that sets the
#     given permissions on a file or dir. Some validation is done. STDERR 
#     is redirected to STDOUT so that you my call this function and have
#     the output stored into a variable. For example, 
#     Output=$(SetPermissions f1 775) will set the permisssions on f1 to
#     775. But if there are errors then the variable OutPut will contain
#     the error message of the '/bin/chmod' command. STDOUT is also stored
#     in this variable. On success, Output is null, return val is 0. 
#
# Usage: SetPermisssions /path/to/file -or- SetPermissions /path/to/file 664
#
# Output/Return: 1 on failure, 0 on success. Errors are printed to term.
#     See above on how to store STDOUT and STDERR in a variable
#
# Ex: SetPermissions File1 644           <-- STDOUT/STDERR sent to term
#     Output=$(SetPermissions File1 644) <-- STDOUT/STDERR stored in var
#
###########################################################################
function SetPermissions {

    # Validate at 2 arguments were passed in
    if [ $# != 2 ]; then
        print "SYS-ERR: Must pass name of file/dir to set permissions on in syslib.SetPermissions"
        return 1
    fi

    # Assign argument to local variable
    typeset SrcFileIn=$1
    typeset PermIn=$2

    # Varify source file/dir exists, or print error and return false
    if [ ! -e $SrcFileIn ]; then
        print "SYS-ERR: Source file: '$SrcFileIn' - not found in syslib.SetPermissions" 
        return 1
    fi

    # Set permissions
    CmdOut=`/bin/chmod $PermIn $SrcFileIn 2>&1` || {
        print "SYS-ERR: Set permissions to $PermIn on file/dir '$SrcFileIn' unsuccessfull"
        print $CmdOut
        return 1
    }

    # Return true
    return 0

}

#############################################################################
# Description: Wrapper function that uses ftp to copy a file to remote host
#
# Input: SourceFile = File on local machine that will be copied to remote host
#        Host = Name/IP of remote host that file will be copied to
#        DestFile = The directory/filename on remote host that file will be 
#                   copied to. 
#
# Example Call: RemoteCopyFile "/Path/to/my/file" "MyHost" "/Path/to/my/file"
#############################################################################
function RemoteCopyFile {

    # Make sure 3 arguments were passed in
    if [ $# != 3 ]; then 
        print "Error: Must pass source_file, host, dest_file to RemoteCopyFile"
        return 1
    fi

    # Set arguments to local variables
    typeset SrcFile=$1
    typeset Host=$2 
    typeset DstFile=$3

    # Make sure source file exists and is not a directory
    if [ ! -f $SrcFile ]; then 
       print "Error: Source file, $1 does not exist"
       return 1
    fi 

    # Build command that will put the file 
    #typeset TransCmd="$AUTO_EXPECT_DIR/TransferFile.exp $Host"
    #    TransCmd="${TransCmd} $this_spadmin $this_spapass"
    #    TransCmd="${TransCmd} $SrcFile $DstFile"
    #    TransCmd="${TransCmd} ascii put"
 
    # Build command that will put the file 
    # updated by candy in 05202016, replace ftp by sftp
    typeset TransCmd
    if _IsWindows $PLATFORM;
    then
       TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
    else
       #os=`/usr/bin/rexec -a -l ${spadmin} -p ${spapass} $Host uname -s`
       os=$(_GetOtestPlatform "$this_os")
       if [ "$os" == "aix" ];
       then
          TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
       else
          TransCmd="$AUTO_ROOT_DIR/TransferFile_v1.py $Host"
       fi
    fi
    #typeset TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
        TransCmd="${TransCmd} $this_spadmin $this_spapass"
        TransCmd="${TransCmd} $SrcFile $DstFile"
        TransCmd="${TransCmd} put ascii"
 

    # transfer the file
    Output=$($TransCmd) || {
        print "FTP-ERR: $Output"
        return 1
    }

    return 0
} 

#############################################################################
# Description: Wrapper function that uses ftp get a file from remote host
# 
# Note: do not use with binary files
#############################################################################
function RemoteGetFile {

    # Make sure 3 arguments were passed in
    if [ $# != 3 ]; then
        print "Error: Must pass Host SrcFile DstFile to $0"
        return 1
    fi

    # Set arguments to local variables
    typeset Host=$1
    typeset SrcFile=$2
    typeset DstFile=$3

    # Build command that will put the file
    #typeset TransCmd="$AUTO_EXPECT_DIR/TransferFile.exp $Host"
    ##    TransCmd="${TransCmd} $this_spadmin $this_spapass"
    #    TransCmd="${TransCmd} $SrcFile $DstFile"
    #    TransCmd="${TransCmd} ascii get"
 
    # Build command that will put the file 
    # updated by candy in 05202016, replace ftp by sftp
    typeset TransCmd
    if _IsWindows $PLATFORM;
    then
       TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
    else
       #os=`/usr/bin/rexec -a -l ${spadmin} -p ${spapass} $Host uname -s`
       os=$(_GetOtestPlatform "$this_os")
       if [ "$os" == "aix" ];
       then
          TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
       else
          TransCmd="$AUTO_ROOT_DIR/TransferFile_v1.py $Host"
       fi
    fi
    #typeset TransCmd="$AUTO_ROOT_DIR/TransferFile.py $Host"
        TransCmd="${TransCmd} $this_spadmin $this_spapass"
        TransCmd="${TransCmd} $SrcFile $DstFile"
        TransCmd="${TransCmd} get ascii"
 

    # transfer the file
    Output=$($TransCmd) || {
        print "FTP-ERR: $Output"
        return 1
    }

    # Make sure source file exists and is not a directory
    if [ ! -f $DstFile ]; then
       print "Error: Transfer passed, but $DstFile does not exist"
       return 1
    fi

    return 0
}

