#!/bin/ksh
# Copyright 2015-2023 Teradata. All rights reserved.
#
# File: tar_teradata_client_packages.sh                  17.20.14.00
#
# Description: Script to create a tar file of the Teradata Tools
#              and Utilities from the media for these platforms:
#              * AIX
#              * HP-UX
#              * Linux
#              * NCR MP-RAS UNIX
#              * Solaris (Sparc)
#              * Solaris (Opteron)
#
#
# History Revision:
# 17.00.07.00 09052019 MS186163 CLNTINS-11645 signing/importkey.sh script is missing from 1700 efix bundle.
# 17.00.00.00 04192019 MS186163 CLNTINS-11105 Adding git path.
# 16.20.09.00 07092018 PP186048 CLNTINS-9678 Linux: Add changes related to
#                                            bteq 32 and 64 bit packages.
# 16.20.04.00 02122018 PK186046 CLNTINS-9163 adding signing directory to
#                                            efix bundles.
# 16.20.03.00 01122018 RM185040 CLNTINS-4802 Update copyright year and version
#                                            during build.
# 16.20.02.00 12152017 PK186046 CLNTINS-8444 Removing TeraJDBC and tar_teradata
#                                            files during tar bundle creation.
# 16.10.02.00 06202017 PK186046 CLNTINS-8104 Support Ubuntu platform
# 16.10.00.00 05112017 SG255032 CLNTINS-7967 Add TeraGSS Admin package
# 15.10.00.00 08032015 PP121926 CLNTINS-5249 Add ttulistproducts.sh
# 16.00.00.01 08032015 PP121926 CLNTINS-5249 Add ttulistproducts.sh
# 16.00.00.00 06022015 PP121926 CLNTINS-5469 Update to 16.00
# 15.10.00.00 04282014 PP121926 CLNTINS-4724 Update to 15.10
# 15.00.00.00 10312013 PP121926 CLNTINS-4207 Update to 15.00
# 14.10.00.01 01162013 PP121926 CLNTINS-3816 Add ThirdPartyLicenses-.txt support
# 14.10.00.00 05022012 PP121926 CLNTINS-3230 Remove package_size.sh.
#
# 14.00.00.03 05252011 PP121926 DR151210 Add TeraJDBC to all tars
# 14.00.00.02 05122011 PP121926 DR147885 Remove script name changed to
#                                        uninstall_ttu.sh.
# 14.00.00.01 04282011 PP121926 DR147885 Add TPTBASE, and remove papi
# 14.00.00.00 11242010 PP121926 DR145390 Update for HPUX/Linux new directories
# 13.10.01.01 08022010 PP121926 DR144518 Fix to add papi/tbld to tar
# 13.10.01.00 07062010 PP121926 DR141060 Add package_size.sh script.
# 13.10.00.00 09212009 PP121926 DR127863 Add TeraJDBC support.
# 13.10.00.00 09012009 PP121926 DR127863 Update for TTU13.10 support.
# 13.00.00.00 10282008 PP121926 DR121109 Update for TTU13 support.
# 01.00.00.01 05162008 PP121926 DR121109 Remove need for "tar" parameter
#                                        Add HOME to default dir.,
#                                        use /tmp if HOME is "/"
# 01.00.00.00 04012008 PP121926 DR121109 Initial checkin
#
#

# Initialize Variables
# Set the initial values to variables here.

# Include the UNIX main install script, .setup.sh
SETUPFILES=".setup.sh setup.sh MEDIALABEL uninstall_ttu.sh ThirdPartyLicense*.txt ThirdPartyLicensesTTU.pdf ttulistproducts_unix.sh"
DEPENDENCIES="cliv2 tdicu piom "

# Include the Solaris Sparc files for the "installer" program
SPARCFILES="Solaris/.cdtoc Solaris/Copyright Solaris/installer Solaris/README "
SPARCDIRS="Solaris/Docs Solaris/Misc Solaris/Patches Solaris/Tools "

VERSION="17.20.14.00"
SHORT_VERSION="1710"

OUTPUTDIR="$HOME"
if [ ${OUTPUTDIR} = "/" ]; then
  OUTPUTDIR="/tmp"
fi

P_1="$1"
P_2="$2"
P_3="$3"
ARGS="$*"

platforms() {
# List all of the available platforms.  With the media the only
# directories on the disk are those with the name of the platform
# containing the packages.  This should continue to be maintained.
# Also, this script shouldn't be on a Windows-Only disk.
# If that happens (except for the Query Director disk), a reminder
# is to be displayed noting that Windows is not supported by this script.

#If the file MEDIALABEL exists, display it as it is the label/name
#the Media (CD/DVD)  If not, exit..
if [ -f MEDIALABEL ]; then
    cat MEDIALABEL
  else
    echo "ERROR: Teradata Client Packages not found.  Please change to the directory"
    echo "       or disk where the Teradata packages are located, and rerun this script."
    exit 1
fi

echo ""
echo "The available platforms are:"

#List the Platforms

if [ -d "AIX" ]; then
  echo ""
  echo "AIX:"
  echo "aix"
fi


#For Linux MEDIA, tell the user to use 'i386-x8664' or 's390x' for the platform.
if [ -d "Linux" ]; then
  echo ""
  echo "Linux:"
  if [ -d "Linux/x8664" ]; then
    echo "x8664"
  fi
  if [ -d "Linux/i386" ]; then
    echo "i386"
  fi
fi

#For Ubuntu MEDIA, tell the user to use 'ubuntu' for the platform.
if [ -d "Ubuntu" ]; then
  echo ""
  echo "Ubuntu:"
  if [ -d "Ubuntu/x8664" ]; then
    echo "Ubuntu-x8664"
  fi
  if [ -d "Ubuntu/i386" ]; then
    echo "Ubuntu-i386"
  fi
fi

#For Solaris MEDIA, tell the user to use 'sparc' or 'opteron' for the platform.
if [ -d "Solaris" ]; then
  echo ""
  echo "Solaris:"
  if [ -d "Solaris/Sparc" ]; then
    echo "sparc"
  fi
  if [ -d "Solaris/Opteron" ]; then
    echo "opteron"
  fi
fi

# Check to see if a directory exists for each known Platform:
# AIX, HP-UX, Linux, MPRAS, Solaris/Sparc and Solaris/Opteron.
# And then list the directories there (which contain the packages).
# Windows is not supported as there is no way to easily
# break up Windows .cab files.
# Also, the extra code for Sparc/Opteron is there because of
# limitations with the DOS "dir" command not listing directories
# in directories.  UNIX would have no problem with that.

echo ""
echo "The available packages are:"
echo ""
# Allow the second parameter ($2) to list only the packages for
# a specfic platform.  This will help with having huge lists.
case "$P_2" in
  a*|A*)
    echo "--- AIX Products:"
    ls AIX
    echo ""
  ;;
  lin*|LIN*)
    echo "--- Linux i386 Products:"
    ls Linux/i386 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
    echo "--- Linux s390x Products:"
    ls Linux/s390x -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
    echo "--- Linux x8664 Products:"
    ls Linux/x8664 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  ;;
  sp*|SP*)
    echo "--- Solaris Sparc Products:"
    ls Solaris/Sparc
    echo ""
  ;;
  op*|OP*)
    echo "--- Solaris Opteron Products:"
    ls Solaris/Opteron
    echo ""
  ;;
  solar*|SOLARI*)
    echo "--- Solaris Sparc Products:"
    ls Solaris/Sparc
    echo ""
    echo "--- Solaris Opteron Products:"
    ls Solaris/Opteron
    echo ""
  ;;
  ubu*|Ubu*|u*|U*)
    echo "--- Ubuntu i386 Products:"
    ls Ubuntu/i386 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
    echo "--- Ubuntu x8664 Products:"
    ls Ubuntu/x8664 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  ;;
  tera*|Tera*)
    echo "--- TeraJDBC Product:"
    echo "terajdbc"
    echo ""
  ;;
esac

# If the second parameter is blank, just list all of the packages
# for the all of the platforms that exist.
if [ "$P_2" = "" ]; then
  if [ -d "AIX" ]; then
    echo "--- AIX Products:"
    ls AIX
    echo ""
  fi
  if [ -d "Linux/i386" ]; then
    echo "--- Linux i386 Products:"
    ls Linux/i386 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  fi
  if [ -d "Linux/x8664" ]; then
    echo "--- Linux x8664 Products:"
    ls Linux/x8664 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  fi
  if [ -d "Solaris/Sparc" ]; then
    echo "--- Solaris Sparc Products:"
    ls Solaris/Sparc
    echo ""
  fi
  if [ -d "Solaris/Opteron" ]; then
    echo "--- Solaris Opteron Products:"
    ls Solaris/Opteron
    echo ""
  fi
  if [ -d "Ubuntu/i386" ]; then
    echo "--- Ubuntu i386 Products:"
    ls Ubuntu/i386 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  fi
  if [ -d "Ubuntu/x8664" ]; then
    echo "--- Ubuntu x8664 Products:"
    ls Ubuntu/x8664 -I "mkrepo.sh" -I "repodata" -I "Packages" -I "signing" 2>/dev/null
    echo ""
  fi
  if [ -d "TeraJDBC" ]; then
    echo "--- TeraJDBC Product:"
    echo "terajdbc"
    echo ""
  fi
fi

if [ -d "Windows" ]; then
  echo "--- Windows Products cannot be archived with this script."
fi
}

# This is the main tarring function.  The meat of this script.
#
tar_function () {

# The 2rd variable starts the package list. If "all" or blank, then tar
# all files for a particular platform.
if [ "$P_2" = ""  ]; then PACKAGES="ALL"
  fi
if [ "$P_2" = "all" ]; then PACKAGES="ALL"
  fi

#If the file MEDIALABEL exists, display it as it is the label/name
#the Media (CD/DVD or otherwise).

if [ -f MEDIALABEL ]; then
    cat MEDIALABEL
  else
    echo "ERROR: Teradata Client Packages not found.  Please change to the directory"
    echo "       or disk where the Teradata packages are located, and rerun this script."
    exit 1
 fi

# Get the value from the file MEDIALABEL, put it in a temporary string,
# replaces the spaces with "-", remove the "/"s and replace triple "---"
# with a single dash.  Then lower case it and set the final result
# to a value called MEDIALABEL

# Read the information in the file MEDIALABEL into the variable tmpstr
read tmpstr <MEDIALABEL

# Replace all spaces with dashes "-"
tmpstr=`echo "$tmpstr" | sed -e "s/ /-/g"`

# Replace the / (in "Load/Unload") with a dash.
tmpstr=`echo "$tmpstr" | sed -e "s/\//-/g"`

# Replace triple dashes with a single dash.
tmpstr=`echo "$tmpstr" | sed -e "s/---/-/g"`

# Now set the variable MEDIALABEL to be tmpstr in lowercase.
MEDIALABEL=$(echo $tmpstr | tr [A-Z] [a-z])

# Go through each platform possibility.  If on UNIX this could be a case
# which would cover any combination of "aix" "AIX" etc.
# Just being as flexible as we can here.
# The set for DEPEND could have used PLATFORM for the path, but for
# some reason the DOS script wouldn't allow it to be set.
# Hard coding it here ensures that it is set for DEPEND.
case "$P_1" in
  a*|A*)
    PLATFORM=AIX
    PLATFORMDIR=AIX
  ;;
 i386|i386|I386)
    PLATFORM=Linux-i386
    PLATFORMDIR="Linux/i386"
  ;;
  X8664|x8664)
    PLATFORM=Linux-x8664
    PLATFORMDIR="Linux/x8664"
  ;;
  ubuntu-x8664|Ubuntu-x8664|UBUNTU-x8664)
    PLATFORM=Ubuntu
    PLATFORMDIR="Ubuntu/x8664"
  ;;
  ubuntu-i386|Ubuntu-i386|UBUNTU-i386)
    PLATFORM=Ubuntu
    PLATFORMDIR="Ubuntu/i386"
  ;;
  sp*|SP*)
    PLATFORM=Solaris-Sparc
    PLATFORMDIR="Solaris/Sparc"
  ;;
  op*|OP*)
    PLATFORM=Solaris-Opteron
    PLATFORMDIR="Solaris/Opteron"
  ;;
  # Set the platform, but don't set the dependencies as they won't be needed.
  tera*|Tera*)
    PLATFORM=TeraJDBC
    DEPEND=""
    SETUPFILES=""
  ;;
 *)
  echo "Error: The PLATFORM is not set. '$P_1' is not a correct value."
  exit 1
  ;;
esac

if [ "$PLATFORM" = "Solaris-Sparc" ] || [ "$PLATFORM" = "Solaris-Opteron" ]; then
    if [ ! -d "${PLATFORMDIR}/cliv2$SHORT_VERSION" ] || [ ! -d "${PLATFORMDIR}/tdicu$SHORT_VERSION" ] || [ ! -d "${PLATFORMDIR}/piom$SHORT_VERSION" ]; then
        echo "ERROR: Teradata Client Packages not found.  Please change to the directory"
        echo "       or disk where the Teradata packages are located, and rerun this script."
        exit 1
    fi
    if [ -d "$PLATFORMDIR/tptbase$SHORT_VERSION" ]; then
            TPTDEPEND="$PLATFORMDIR/tptbase$SHORT_VERSION*"
    fi
elif [ "$PLATFORM" = "Linux-x8664" ] || [ "$PLATFORM" = "Linux-i386" ]; then
    cliv2Rpm=`ls ${PLATFORMDIR}/cliv2*.rpm`
    tdicuRpm=`ls ${PLATFORMDIR}/tdicu*.rpm`
    if [ -z "$tdicuRpm" ] || [  -z "cliv2Rpm" ]; then
        echo "ERROR: Teradata Client Packages not found.  Please change to the directory"
        echo "       or disk where the Teradata packages are located, and rerun this script."
        exit 1
    fi
else
    if [ ! -d "${PLATFORMDIR}/cliv2" ] || [ ! -d "${PLATFORMDIR}/tdicu" ]; then
   # if [ ! -d "${PLATFORMDIR}/cliv2" ] || [ ! -d "${PLATFORMDIR}/tdicu" ] || [ ! -d "${PLATFORMDIR}/piom" ]; then
        echo "ERROR: Teradata Client Packages not found.  Please change to the directory"
        echo "       or disk where the Teradata packages are located, and rerun this script."
        exit 1
    fi
    if [ -d "${PLATFORMDIR}/tptbase" ]; then
            TPTDEPEND="${PLATFORMDIR}/tptbase*"
    fi
fi

DEPEND_with_PIOM="${PLATFORMDIR}/cliv2* ${PLATFORMDIR}/tdicu* ${PLATFORMDIR}/piom*"
DEPEND_without_PIOM="${PLATFORMDIR}/cliv2* ${PLATFORMDIR}/tdicu*"

if [ "$PLATFORM" = "TeraJDBC" ]; then
  echo "Product: $PLATFORM"
else
  echo "Platform: $PLATFORM"
fi

#Add TeraJDBC to all platforms
if [ -d "TeraJDBC" ]; then
  TERAJDBC=TeraJDBC
fi

#echo "DEPENDENCIES : $DEPEND"
#echo "SETUPFILES   : $SETUPFILES"

echo ""
echo "Default Path and Output File:"
if [ "$PLATFORM" = "TeraJDBC" ]; then
  echo "${OUTPUTDIR}/teradata-client-terajdbc.tar"
else
  echo "${OUTPUTDIR}/teradata-client-${PLATFORM}-${MEDIALABEL}.tar"
fi
echo ""
echo "Hit [Enter] to accept the default save path ($OUTPUTDIR), or enter a"
echo "different save directory : "
read -r NEWPATH

if [ "$NEWPATH" = "" ]; then
  NEWPATH=${OUTPUTDIR}
else
  # Try to create the directory, just in case it doesn't exist.
  mkdir $NEWPATH 2> /dev/null
fi

if [ "$PLATFORM" = "TeraJDBC" ]; then
  TAROUT="${NEWPATH}/teradata-client-terajdbc.tar"
else
  TAROUT="${NEWPATH}/teradata-client-${PLATFORM}-${MEDIALABEL}.tar"
fi

# Try creating a file at TAROUT to make sure it's not being written to
# a read-only file location.  Yes, we will overwrite whatever file is at
# that location.  This is what we want, for now.
echo "Test File" > $TAROUT
if [ -f  $TAROUT ]; then
    echo "Output File: $TAROUT"
    rm $TAROUT
  else
    echo "ERROR: $TAROUT cannot be written."
    echo "Please rerun using a different path."
    exit 1
fi

# Clear the following variable
INDIVIDUAL_PACKAGES=""

#Start at the 2nd value in the variable list. This is the list passed
#on the command line.
i=2

for value in $ARGS;do
  if [[ $i -gt 2 ]]; then
    case $value in
           piom*|tdicu*|cli*)
                echo "---$value will include by default with primary products"
           ;;
           arc*|fast*|tpump*|bteq*|mload*|cobpp*)
                if [ "$with_tptbase" -eq 1 ]; then
                    DEPEND="$TPTDEPEND $DEPEND_with_PIOM"
                else
                    DEPEND="$DEPEND_with_PIOM"
                fi
                with_piom=1
           ;;
           sqlpp*|tptbase*)
                if [ "$with_piom" -eq 1 ] && [ "$with_tptbase" -eq 1 ]; then
                    DEPEND="$DEPEND_with_PIOM $TPTDEPEND"
                elif [ "$with_tptbase" -eq 1 ];then
                    DEPEND="$DEPEND_without_PIOM $TPTDEPEND"
                elif [ "$with_piom" -eq 1 ]; then
                    DEPEND="$DEPEND_with_PIOM"
                else
                    DEPEND="$DEPEND_without_PIOM"
                fi
                without_piom=1
           ;;
           tptstream*)
                if [ "$with_piom" -eq 1 ]; then
                    DEPEND="$DEPEND_with_PIOM $TPTDEPEND"
                else
                    DEPEND="$DEPEND_without_PIOM $TPTDEPEND"
                fi
                with_tptbase=1
           ;;
           *axsmod*|tdodbc*|tdwallet*)
                if [ "$with_piom" -eq 1 ] && [ "$with_tptbase" -eq 1 ]; then
                    DEPEND="$DEPEND_with_PIOM $TPTDEPEND"
                elif [ "$without_piom" -eq 1 ] && [ "$with_tptbase" -eq 1 ]; then
                    DEPEND="$DEPEND_without_PIOM $TPTDEPEND"
                elif [ "$with_tptbase" -eq 1 ]; then
                    DEPEND="$DEPEND_without_PIOM $TPTDEPEND"
                elif [ "$with_piom" -eq 1 ]; then
                    DEPEND="$DEPEND_with_PIOM"
                elif [ "$without_piom" -eq 1 ]; then
                    DEPEND="$DEPEND_without_PIOM"
                else
                    DEPEND=""
                fi
           ;;
           *)
               echo "ERROR: Invalid product name ($value). Please provide valid product name"
               exit 1
           ;;
   esac
   case $value in
           piom*|tdicu*|cli*)
                echo ""
           ;;
           *)
                INDIVIDUAL_PACKAGES="${INDIVIDUAL_PACKAGES} ${PLATFORMDIR}/${value}*"
           ;;
   esac
  fi
  (( i+=1 ))
done

  
  if [ "$PACKAGES" = "ALL" ]; then
    echo "---Archiving all packages for $P_1."
    echo "tar cvfp $TAROUT $PLATFORMDIR $TERAJDBC $SETUPFILES"
    tar cvfp $TAROUT $PLATFORMDIR $TERAJDBC $SETUPFILES
  else
    echo "---Archiving setupfiles and dependency packages for $P_1"
    if [ "$P_1" = "sparc" ] && [ -f "Solaris/installer" ]; then
      echo "---Adding Pre-TTU13.0 Solaris Sparc files..."
      echo "tar cvfp $TAROUT $DEPEND $SETUPFILES $SPARCFILES $SPARCDIRS $TERAJDBC $INDIVIDUAL_PACKAGES"
      tar cvfp $TAROUT $DEPEND $SETUPFILES $SPARCFILES $SPARCDIRS $TERAJDBC $INDIVIDUAL_PACKAGES
    elif [ "$PLATFORM" = "TeraJDBC" ]; then
      echo "tar cvfp $TAROUT $DEPEND $TERAJDBC $SETUPFILES"
    else
      if [ "$PLATFORM" = "Linux-i386" ] || [ "$PLATFORM" = "Linux-x8664" ]; then
          echo "tar cvfp $TAROUT $DEPEND $SETUPFILES $INDIVIDUAL_PACKAGES $PLATFORMDIR/signing"
          tar cvfp $TAROUT $DEPEND $SETUPFILES $INDIVIDUAL_PACKAGES $PLATFORMDIR/signing
      else
          echo "tar cvfp $TAROUT $DEPEND $SETUPFILES $INDIVIDUAL_PACKAGES"
          tar cvfp $TAROUT $DEPEND $SETUPFILES $INDIVIDUAL_PACKAGES
      fi
    fi
  fi

if [ "$?" != 0 ];then
    echo ""
    echo "Error: Unable to create tar archive, please check error and try again."
    exit 1
fi

which gzip > /dev/null 2>&1
if [ "$?" != 0 ]; then
    echo ""
    echo "Notice: The executable 'gzip' is not found. Download from www.gzip.org for this"
    echo "        platform to automatically compress the output tar file to a gzip file."
    echo ""
    echo "The file has been saved at:"
    echo "  $TAROUT"
    echo ""
else
  gzip $TAROUT
  if [ "$?" != 0 ]; then
    echo ""
    echo "The file has been saved at:"
    echo "  $TAROUT"
    echo ""
  else
    echo ""
    echo "The file has been saved at:"
    echo "  $TAROUT.gz"
    echo ""
  fi
fi
}

help () {
echo "Usage: $0 list"
echo "       $0 list {platform}"
echo "       $0 {platform} [{package1} {package2} ...]"
echo ""
echo "Parameters:"
echo ""
echo " help            : Display this help message."
echo
echo " list            : List the available platforms and packages from the media."
echo
echo " list {platform} : List the packages available for the specified platform."
echo
echo "      {platform} : Available platforms: "
echo "                   aix, ia64, i386, s390x, ubuntu, opteron, sparc"
echo "                   (or) terajdbc for the TeraJDBC product."
echo
echo "                   Create the tar file for the supplied platform and include"
echo "                   all required dependency packages or individual packages."
echo
echo "      {package}  : Specify the packages available on this media for the"
echo "                   specific platform.  The parameter 'all' (or blank) will"
echo "                   include all available packages.  To specify individual"
echo "                   packages, list the packages separated by a space."
echo
echo "                   Example: $0 i386 bteq fastld"
echo
echo "The dependencies will automatically be included and do not need to"
echo "be listed individually ( --- $DEPENDENCIES)."
echo
}

#main
echo "***************************************************************************"
echo "*               Tar Teradata Client Packages v.$VERSION                *"
echo "***************************************************************************"

case $1 in
  aix*|AIX*)          tar_function;;  # AIX
  i386*|x8664*|I386*) tar_function;;  # Linux
  sparc*|SPARC*)      tar_function;;  # Solaris Sparc
  opt*|OPT*)          tar_function;;  # Solaris Opteron
  u*|U*)              tar_function;;  # Ubuntu
  tera*|Tera*|JDBC)   tar_function;;  # TeraJDBC Product
  lis*)               platforms;;     # list available platforms and packages
  *)                  help;;          # Display help
esac



