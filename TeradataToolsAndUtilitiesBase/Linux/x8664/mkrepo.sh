#!/bin/bash
#-----------------------------------------------------------------------------------------------------------------
# File     : mkrepo.sh
# Purpose  : Setup to create a repository meant for holding and managing TTU Packages.
#            It supports clients such as yum,zypper and apt used by popular Unix systems such as RHEL,CentOS,SuSE
#            and Ubuntu for managing binary packages. 
#
# Copyright 2016-2022 Teradata. All rights reserved.
# TERADATA CONFIDENTIAL AND TRADE SECRET.
# 
# Usage:
#	mkrepo.sh [-u server -n <destination>] [-u client -n <repourl>]
#
# History:
# 16.00.00.00	pk186048    CLNTINS-6977
# 16.10.01.00   PK186046    CLNTINS-7648  update mkrepo.sh to create the apt-get repo for Ubuntu
# 16.20.00.00   PK186048    CLNTINS-8637  Enable gpgkey verification for TTU YUM Repository
# 16.20.00.04   RM185040    CLNTINS-8883  Improve the usage information and correct spelling mistakes
# 17.00.00.00   MS186163    CLNTINS-11832 mkrepo.sh needs to include the ttupublickey rpm
# 17.00.10.00   PK186046    CLNTINS-11966 Removing errors while creating Ubuntu repository
# 17.00.19.00   MS186163    CLNTINS-13202 Update mkrepo.sh to work with the new public key.
# 17.10.09.00   PK186046    CLNTINS-15250 mkrepo.sh script to have default values for prompts.
#-------------------------------------------------------------------------------------------------------------------

###############################################################################
# Function: display_usage
# Description: Displays the usage for this script.
# Input : None
# Output: Displays how to use this script.
# Note  : None
display_usage ()
{
  echo ""
  echo "Usage: $script_name [-u server -n <destination>] [-u client -n <repourl>] [-h] [-c <entry(s)>]"
  echo ""
  
  echo "[-u server -n <destination>]"
  echo ""
  
  echo "-u server        : Script will setup TTU $REPO repository on local server."
  echo "-n <destination> : Denotes absolute path of the destination folder to copy TTU packages."
  echo "                   This <destination> must be the root folder of the web server or it should have a symbolic link created to the root folder."
  echo "                   Example Web server: /var/www/html"

  echo ""
  echo "[-u client -n <repourl>]"
  echo ""
  
  echo "-u client        : Script will add existing TTU repository to $REPO configuration."
  echo "-n <repourl>     : Denotes web URL from which $REPO can download TTU packages."
  echo "                   Here assumption is that TTU repository is available for download on the web server."
  echo "                   Example <repourl>: http://server-address/17.20/$PLATFORM/x8664/BASE"  
  
  echo "-c <entry(s)>    : One or more entries separated by ',' - ex. -c UpdateETC=no,InstallDir=/abc"

  echo ""
  echo "Note: If no input is given, the script assumes that a TTU Bundle is copied and extracted to the local machine."
  echo "      The script will add the local TTU repository to $REPO configuration."
  echo
}

###############################################################################
# Function: create_server_repo
# Description: Copies TTU packages and repodata folder to user given destination
# Input : None
# Output: NA
# Note  : None
create_server_repo ()
{
   if [ -z "${dest_baseurl}" ]; then
       echo ""
       echo "ERROR: Please provide a valid destination path to copy TTU packages."
       display_usage
       exit 1
   fi
  
   #Check if destination is a remote directory
   if [[ "${dest_baseurl}" == *"@"* ]]; then
        echo ""
        echo "ERROR: Destination cannot be a remote folder while copying packages." 
        echo "       Please provide a local path as input."
        exit 1
   fi
  
  #check if apache web server is running
  service_status=`ps -A | grep 'apache2\|httpd'`
  if [ "$service_status" = "" ]; then
      echo ""
      echo "ERROR: Unable to detect Apache web server running on local host." 
      echo "       Please make sure your web server is up and running before setting up the repository."
  fi
   
  #Check if given destination is available or not, if not create it
  if [ ! -d "${dest_baseurl}" ]; then
      mkdir -p ${dest_baseurl} 
  fi
 
  mkdir -p "${dest_baseurl}/17.20/$PLATFORM/x8664/BASE"
     
  #copy ttu packages to user given detination
  copy_status="$(cp -R ${PWD}/* ${dest_baseurl}/17.20/$PLATFORM/x8664/BASE)"
  if [ "$?" != "0" ]; then
      echo "ERROR: Copy $packages packages from ${PWD} to destination:${dest_baseurl}/17.20/$PLATFORM/x8664/BASE failed."
      echo "Reason: ${copy_status}"
      exit 1
  fi

  echo "Successfully copied $packages packages from ${PWD} to destination: ${dest_baseurl}/17.20/$PLATFORM/x8664/BASE."
  echo "Please refresh your web server URL to check if $packages packages are available for download."
  echo "Example URL: http://server-address/."
  echo "Example RPM location: http://server-address/17.20/$PLATFORM/x8664/BASE."
  exit 0
}

###############################################################################
# Function: configure_repo_file
# Description: Adds TTU repo file to YUM,ZYPPER or APT configuration
# Input : None
# Output: NA
# Note  : None
configure_repo_file ()
{
  if [ ! -d "${REPO_PATH}" ]; then
      mkdir -p "${REPO_PATH}"
  fi

  echo "Will use/create the following '${REPO}' repository file:"
  echo "Filename: '${REPO_PATH}/${OUT_REPO}'"

  OUT_REPO=/tmp/"$OUT_REPO"

  echo "-----------------------------------------------------------------"
  if [ "${PLATFORM}" = "Linux" ]; then
      echo "[ttu-foundation-1720]" > $OUT_REPO
      echo "name=TTU Foundation 1720 x8664" >> $OUT_REPO
      echo "baseurl=${dest_url}" >> $OUT_REPO
      echo "enabled=1" >> $OUT_REPO
      echo "gpgcheck=1" >> $OUT_REPO
      echo "gpgkey=https://www.teradata.com/Security-Information/TD-RPM-SIGN-KEY.asc" >> $OUT_REPO
      cat $OUT_REPO
      chmod 644 $OUT_REPO

  else
      echo "deb [trusted=yes] $dest_url ./" > $OUT_REPO    
      cat $OUT_REPO
      chmod 644 $OUT_REPO
  fi
  echo "-----------------------------------------------------------------"

  printf "Do you want to continue? [Y/n (default: Y)]: "
  read input
    
  echo
  if [ -z "$input" ]; then
      input="y"
  fi

  if [ "$input" = "y" ] || [ "$input" = "Y" ]; then
      mv -f $OUT_REPO ${REPO_PATH}
  else
      echo "Abort."
      exit 1
  fi

  if [ $? -eq 0 ]; then
      echo "Successfully copied to $REPO_PATH. Kindly update the package lists before installing any packages."
      echo "Example: $REPO update."
      echo
  fi
}

###############################################################################
# Function: create_client_repo
# Description: Adds TTU repo file to YUM configuration
#              Here script assumes that TTU repository is configured on a web server
#               and adds that repo information to YUM configuration
# Input : None
# Output: NA
# Note  : None
create_client_repo ()
{
   if [ -z "${dest_baseurl}" ]; then
       echo
       echo "ERROR: Please provide server base URL to configure $REPO repository on the local host."     
       display_usage
       exit 1
   fi

   echo "Adding $dest_baseurl to $REPO configuration..."
   echo
   dest_url=$dest_baseurl
   configure_repo_file
}

#######################################################################################
# Function: create_client_repo
# Description: Adds TTU repo file to YUM configuration.  
#			   Here script assumes that TTU Bundle is available on local host
# Input : None
# Output: NA
# Note  : None
create_local_repo ()
{
  echo 
  echo "-------------------------------------------------------------------------------------"
  echo "No inputs have been provided to the '$script_name' script."
  echo "The script will add the local TTU repository to '$REPO' configuration."
  printf "Do you want to continue? [Y/n (default: Y)]: "
  read ans
  
  echo
  while [ -z "$ans" ]; do
       ans="Y"
  done

  if [ $ans = "y" ] || [ $ans = "Y" ]; then
      dest_url="file://${PWD}"
      configure_repo_file
      if [ $PLATFORM = "Linux" ]; then
          if [ -f ${PWD}/signing/importkey.sh ]; then
              echo "Executing importkey.sh"
              ${PWD}/signing/importkey.sh ${PWD}/signing
          else
              echo "importkey.sh is not found in ${PWD}"
          fi
      fi
  else
      echo "Abort."
      exit 1
  fi

}

find_platform()
{
    OS_FLAVOUR=`uname -s`

    if [ "$OS_FLAVOUR" = "Linux" ]; then
	 OS_ID=`awk -F= '/^ID/{print $2}' /etc/os-release | head -1`
         if [ "$OS_ID" = "ubuntu" ] || [ "$OS_ID" = "debian" ]; then
             # Required Setup for Ubuntu platform
             PLATFORM="Ubuntu"
	     REPO="apt"
	     packages="debian"
             OUT_REPO="ttu-foundation-1720.list"
	     REPO_PATH="/etc/apt/sources.list.d"
         else
	     PLATFORM="Linux"
	     packages="rpm"
             OUT_REPO="ttu-foundation-1720.repo"
             OS_ID=`awk -F= '/^ID/{print $2}' /etc/os-release | head -1 | awk -F'"' '{print $2}'`
	     if [ "$OS_ID" = "sles" ]; then
	         # Required Setup for SUSE platform
	         REPO="zypper"
	         REPO_PATH="/etc/zypp/repos.d"
	     else
                 # Required Setup for RHEL platform
	         REPO="yum"
	         REPO_PATH="/etc/yum.repos.d"
             fi
	 fi
    else
	 echo
	 echo "ERROR: Un-Supported Platform. Kindly use $0 in Linux/Ubuntu only."
	 echo
	 exit 1
    fi
}

###############################################################################
# Main script starts here
###############################################################################
#Get the script name for display_usage
script_name=$0 
#./mkrepo.sh

full_path=$(realpath $script_name)
#/opt/BASE/TeradataToolsAndUtilitiesBase/Ubuntu/x8664/mkrepo.sh

dir_path=$(dirname $full_path)  
#/opt/BASE/TeradataToolsAndUtilitiesBase/Ubuntu/x8664

cd $dir_path

find_platform

url_type="local"  #Default configuration option

while getopts :u:n:c:h setup_args
do
  case $setup_args in
    u) url_type=$OPTARG
       ;;
    n) dest_baseurl=$OPTARG
       ;;
    c) configInfo=$OPTARG
       ;;   
    h) display_usage
       exit 1
       ;;
    ?) display_usage
       exit 1
       ;;
  esac
done
shift $(($OPTIND -1))

if [ "$url_type" = "server" ]; then
    create_server_repo
elif [ "$url_type" = "client" ]; then
    create_client_repo
else
    display_usage
    create_local_repo
fi

if [ -n "$configInfo" ]; then
  # add the info to the /var/opt/teradata/ttu_install.cfg
  configFile=/var/opt/teradata/ttu_install.cfg
  if [ -f $configFile ]; then
    mv $configFile ${configFile}-old
  fi
  for i in ${configInfo//,/ }
  do
    echo "$i" >> $configFile
  done
fi