#!bin/bash
# inpath--Verifies that a specified program is either valid as is
#	or can be found in the PATH directory list

in_path()
{
  #Given a command and the PATH, tries to find the command. Returns 0 if
  #  found and executable; 1 if not.

  cmd=$1	ourpath=$2	result=1
  # Use ":" as the IFS (Internal Field Separator) Notice it is restored later on.
  oldIFS=$IFS	IFS=":"

 for directory in $ourpath
 do
  # -x operator will validate the path passed is correct or not
  if [ -x $directory/$cmd ] ; then
     result=0	# If we are here, we found the command
   fi
 done

 IFS=$oldIFS
 return $result
}

checkForCmdInPath()
{
  var=$1

  if [ "$var" != "" ] ; then
    # slice the first character of the parameter and check if it starts with /
    if [ "${var:0:1}" = "/" ] ; then
      if [ ! -x $var ] ; then
        return 1
      fi
    elif ! in_path $var "$PATH" ; then
      return 2
    fi
  fi
}

# Entry point
# $# checks the number of parameters passed. In this case, we are validating
#    only one parameter is being passed.
if [ $# -ne 1 ] ; then
  echo "Usage: $0 command" >&2
  exit 1
fi

checkForCmdInPath "$1"

# Helper block to map result to user friendly message. Comment out later
# $? Checks the exit code of the last program run. In this case is checking
#    the code returned by checkForCmdInPath
case $? in
  0 ) echo "$1 found in PATH"			;;
  1 ) echo "$1 not found or not executable"	;;
  2 ) echo "$1 not found in PATH"		;;
esac

exit 0

