#!/bin/bash
#DR51932 - CSG: Removed shebang (#!/usr/bin/ksh).
# Copyright 2001-2023 Teradata. All rights reserved.
#
# File: .setup.sh                                      17.20.14.00
#
# Description: Script to install the Teradata Tools and Utilities from
#              the CD for these platforms:
#              * AIX
#              * HP-UX
#              * Linux
#              * NCR MP-RAS UNIX
#              * Solaris (Sparc)
#
#              The script uses the Korn shell script language.
#
# Usage: './.setup.sh' (on UNIX platforms. Runs with sh,ksh,bash interpreters)
#
# Note: 1) This script is started by the "setup.bat" script.
#
# History Revision:
#
# 17.20.05.00 08112022 AG255088 CLNTINS-17343 Update script to install the ThirdPartyLicenseTTU.pdf
# 17.10.06.00 o4122021 MS186163 CLNTINS-14166 Remove the option from .setup.sh to install
#                                             all products except tdwallet. 
# 17.10.01.00 10122020 SG255032 CLNTINS-13558 The installation should quit if a dependent 
#                                             package fails to install
# 17.00.16.00 07172020 MS186163 CLNTINS-13044 seup.sh needs to block if any TTU database packages are installed. 
# 17.00.14.00 05152020 MS186163 CLNTINS-12634 Linux/Ubuntu: Update .setup.sh to handle the new 
#                                             Google Cloud Storage Access Module. 
# 17.00.14.00 04222020 AW186011 CLNTINS-12436 Investigate creating a internal repo in artifactory for TTU products
# 17.00.14.00 04212020 PK186046 CLNTINS-12608 Solaris - add the redistlibs packages
# 17.00.00.01 03142019 MS186163 CLNTINS-10803 Update the .setup.sh installing mqaxsmod with nodeps.
# 17.00.00.01 11082018 AW186011 CLNTINS-8234  Update the UNIX main installer (.setup.sh) to handle 
#                                             separate 32-bit and 64-bit packages for Ubuntu.
# 17.00.00.00 02082019 MS186163 CLNTINS-10827 Linux: Add ttupublickey to Base bundle and update .setup.sh.
# 17.00.00.00 11082018 AW186011 CLNTINS-8234  Update the UNIX main installer (.setup.sh) to handle 
#                                             separate 32-bit and 64-bit packages for Linux.
# 16.20.13.00 11062918 AW186011 CLNTINS-10466 Add -test to use "-Uvh" flags only
# 16.20.11.00 10042018 SG255032 CLNTINS-10307 Ubuntu: Remove obsoleted BTEQ packages during
#                                             installation of new 32-bit package
# 16.20.11.00 09252018 PK186046 CLNTINS-10239 Ubuntu: Adding 64-bit BTEQ package
# 16.20.07.00 05112018 AW186011 CLNTINS-9638 Linux: add the 32-bit bteq package
# 16.20.04.00 02122018 PK186046 CLNTINS-9163 removing tdicu dependency from SEN ODBC
# 16.20.03.00 01122018 RM185040 CLNTINS-4802 Update copyright year and version during build.
# 16.20.01.00 12072017 PK186046 CLNTINS-8896 setup.sh complaining wrong incompatible
#                                            packages.
# 16.20.00.00 10162017 MS186163 CLNTINS-8633 Alternative path of TTU_INSTALL.cfg.
# 16.20.00.00 08302017 AW186011 CLNTINS-8205 Update .setup.sh to import the public signing key
# 16.10.04.00 09082017 PK186046 CLNTINS-8323 Modified display_menu function
# 16.10.02.00 07242017 RM185040 CLNTINS-8146 Fix broken silent install.
# 16.10.00.00 05152017 SG255032 CLNTINS-7996 Add ThirdPartyLicensesTTU.txt file
# 16.10.00.00 05122017 PK186046 CLNTINS-7978 tdodbc uninstall leaves files behind
# 16.10.00.00 04262017 SG255032 CLNTINS-7854 Add support for Ubuntu OS
# 16.10.00.00 04282017 SG255032 CLNTINS-7900 Add teragssAdmin as an optional package
# 16.00.05.00 03212017 RM185040 CLNTINS-7497 Add support azureaxsmod
# 16.00.02.00 12142016 RM185040 CLNTINS-7165 Add support of 16.00 s3axsmod
# 16.00.01.00 12072016 PK186046 CLNTINS-7169 Update .setup.sh and setup_wrapper.sh
#                                            to use --replaceFiles
# 16.00.00.00 08102016 PK186046 CLNTINS-6603 Modify the IVST scripts to test
#                                            HPUX-PA packages
#                                            on HPUX-IA machine
# 16.00.00.00 07012016 RM185040 CLNTINS-6722 Accommodate kafkaaxsmod
# 16.00.00.00 06232016 RM185040 CLNTINS-6665 Remove calls to ttulistproducts_unix.sh
# 16.00.00.00 06152016 PK186046 CLNTINS-6332 UNIX: Block the 16.00 install if
#                                            tdicu1510-15.10.01.00 is installed
# 16.00.00.00 04202016 RM185040 CLNTINS-6238 Upgrade/Reinstall should change
#                                            active release.
# 16.00.00.00 03282016 PK186046 CLNTINS-6123 Adding "--replacepkgs" in the maininstaller
#                                            to reinstall a package
#                               CLNTINS-6149 Removing "--nodeps" in the maininstaller
#                                            to skip force installation of cliv2,tdodbc
# 16.00.00.00 01052016 AW186011 CLNTINS-5332 Provide option to keep the previous
#                                            release
# 16.00.00.00 01052016 AW186011 CLNTINS-6075 Main Install script failed when missing
#                                            the jmsaxsmod package
# 15.10.01.00 11162015 SB186089 CLNTINS-5980 Main Install Should Skip
#                                            Installing Individual Package When
#                                            User Enters Incorrect choice other
#                                            than y or n.
# 15.10.01.00 10132015 AW186011 CLNTINS-5916 15.10.xx display problem for arc
# 15.10.01.00 10132015 AW186011 CLNTINS-5952 Remove previous PKGs message
# 15.10.01.00 10122015 AW186011 CLNTINS-5948 Fix issue with pre-15.10.01 rel
# 15.10.01.00 09282015 AW186011 CLNTINS-5716 AIC Changes
# 15.10.01.00 07162015 PP121926 CLNTINS-5670 Check available space in the
#                                            get_install_dir function.
# 15.10.01.00 06082015 PP121926 CLNTINS-4665 Check user input, command line,
#                                            or config file for install directory
# 15.10.00.04 02032015 PP121926 CLNTINS-5261 Check dirs /usr,/usr/lib on AIX.
#                                            If they are set to 777, change to 755.
# 15.10.00.03 01262015 PP121926 CLNTINS-5236 Automatically remove the previous 
#                                            version if installed silent, and change default
#                                            to "Yes" instead of "No" for the user question.
# 15.10.00.02 01022015 PP121926	CLNTINS-5191 Fix response files for tptstream
# 15.10.00.01 12242014 PP121926 CLNTINS-5136 Check for previous versions, 
#                                            and offer to auto remove.
# 15.10.00.00 04382014 PP121926 CLNTINS-4724 Update for TTU 15.10
# 15.00.00.05 03062014 PP121926 CLNTINS-4826 Pass "y" to response files.
# 15.00.00.04 03052014 PP121926 CLNTINS-4614 Remove -w for grep on HPUX
# 15.00.00.03 11212013 PP121926 CLNTINS-4327 Remove VERNUM from AIX/HPUX dirs
# 15.00.00.02 09092013 PP121926 CLNTINS-4245 Remove workaround for TDODBC
#                                            Solaris package for response files.
# 15.00.00.01 07242013 PP121926 CLNTINS-4023 Create response files in
#                                            /var/log/teradata/client/$RELNUM.
#                                            New function create_solaris_response
# 15.00.00.00 05082013 PP121926 CLNTINS-4022 Use response files in
#                                            /var/log/teradata/client/$RELNUM
# 14.10.00.23 11012013 PP121926 CLNTINS-4248 Add VERNUM to directories for AIX
#                                            and HPUX packages
# 14.10.00.22 09052013 PP121926 CLNTINS-4258 Launch Mac GUI if executed on
#                                            Mac OS X (Darwin)
# 14.10.00.21 05082013 PP121926 CLNTINS-4022 Use response files in 
#                                            /var/log/teradata/client/$RELNUM
# 14.10.00.20 04172013 PP121926 CLNTINS-3980 Add new Copyright notice.
# 14.10.00.19 01152013 PP121926 CLNTINS-3816 Add ThirdPartyLicenses.txt file
# 14.10.00.18 12122012 PP121926 CLNTINS-3802 Fix Linux PKGSIZE / 1024 command.
# 14.10.00.17 11122012 PP121926 CLNTINS-3750 Update Copyright to 2013
# 14.10.00.16 09183012 PP121926 CLNTINS-3687 Fix get_init_package_size and
#                                            get_init_package_version for
#                                            teradata_arc package name.
# 14.10.00.15 09113012 PP121926 CLNTINS-3686 Allow pkg names as parameters.
# 14.10.00.14 09112012 PP121926 CLNTINS-3685 Display msg. if alpha packages.
# 14.10.00.13 09112012 PP121926 CLNTINS-3653 Fix choice so a/w don't give mesg.
# 14.10.00.12 08212012 PP121926 CLNTINS-3577 mqaxsmod, HPUX single package for
#                                            pa32 and pa64.
# 14.10.00.11 08062012 PP121926 CLNTINS-3653 Tweak for media build, round 0
# 14.10.00.10 08062012 PP121926 CLNTINS-3622 Skip product question on parameter
#                                            input. 
# 14.10.00.09 07272012 PP121926 CLNTINS-3622 Hide Dependencies: TeraGSS, tdcli,
#                                            cliv2, and piom.
# 14.10.00.08 06272012 PP121926 CLNTINS-3599 Remove obsolete JDBC references.
# 14.10.00.07 06152012 PP121926 CLNTINS-3534 Fix read to work on ksh and bash.
# 14.10.00.06 06112012 PP121926 CLNTINS-3578 Replace whoami with id, to check
#                                            id #, not just username=root.
# 14.10.00.05 05292012 PP121926 CLNTINS-3538 TeraGSS packages now combined.
# 14.10.00.04 05152012 PP121926 CLNTINS-3492 Allow menu #s as parameters 
# 14.10.00.03 04112012 PP121926 CLNTINS-3478 Remove "Raising Intelligence"
#                                            from Teradata logo display. 
# 14.10.00.02 04052012 PP121926 CLNTINS-3146 Remove TDODBC AIX/HPUX pkg remove.
# 14.10.00.01 03272012 PP121926 CLNTINS-3230 Display pkg size on menu
# 14.10.00.00 03212012 PP121926 CLNTINS-3226 Display pkg versions on menu
# 14.00.01.02 11022011 PP121926 CLNTINS-3243 Fix TPT STREAM install on HPUX
# 14.00.01.01 10212011 PP121926 CLNTINS-3208 Add jmsaxsmod to HPUX IA64 inst.
# 14.00.01.00 09142011 PP121926 CLNTINS-3142 Check diskspace on /opt.
# Version history removed prior to 14.00.01. See ClearCase for previous history.

# Copyright year and Teradata Tools and Utilities release number.
# IMPORTANT: UPDATE COPYRIGHT YEAR AND RELEASE NUMBER FOR EACH RELEASE!!!
CRYEAR="2001-2023"

#DR116663 - Added to display the version of the script
SCRIPTVER="17.20.14.00"

#DR116663 - Added for package names containing major ver and minor ver 
MAJORVER=`echo $SCRIPTVER | awk -F. '{ printf("%02d", $1 ) }'`   #14
MINORVER=`echo $SCRIPTVER | awk -F. '{ printf("%02d", $2 ) }'`   #10
EFIX=`echo $SCRIPTVER | awk -F. '{ printf("%02d", $3 ) }'`
VERNUM="${MAJORVER}${MINORVER}"                                  #1410
VER3NUM="${MAJORVER}${MINORVER}${EFIX} "                         #141000
RELNUM="${MAJORVER}.${MINORVER}"                                 #14.10
REL3NUM="${MAJORVER}.${MINORVER}.${EFIX}"  #14.10.00

if [ "$DEBUG" ]; then
  echo "MAJORVER is $MAJORVER and MINORVER is $MINORVER and EFIX is $EFIX"
  echo "VERNUM is $VERNUM and VER3NUM is $VER3NUM"
  echo "RELNUM is $RELNUM and REL3NUM is $REL3NUM"
  echo "----------------------"
  echo ""
fi

#not compatible with pre 15.10.01 packages
PRE151001=151001

#Set the response directory here
RESPONSEDIR="/var/log/teradata/client/$RELNUM"

# DR 67864 - Create the TTUNAME.
TTUNAME="Teradata Tools and Utilities"

# Chip types for Solaris.
CHIP_INTEL=i386
CHIP_SPARC=sparc

# Chip types for Linux.
CHIP_SUSE64=x86_64
CHIP_IA64=ia64

#DR101866
CHIP_OPTERON=x86_64
CHIP_S390X=s390x           #s390x

# MP-RAS release version number.
MPRAS_RELVER="4.0 3.0"
# DR 93851 - MP-RAS 3.3 version number.
MPRAS_3_3_VER="3.3"

# DR 93851 - MP-RAS release id file.
RELID_FILE=/etc/.relid

# Supported platform names.
NAME_AIX=AIX
NAME_LINUX=Linux
NAME_MPRAS="NCR MP-RAS UNIX"
NAME_SOLARIS_SPARC="Solaris Sparc"
#DR101866
NAME_SOLARIS_OPTERON="Solaris Opteron"
NAME_UBUNTU=Ubuntu

# OS names from the "uname" command.
OS_AIX=AIX
OS_LINUX=Linux
OS_MPRAS=UNIX_SV
OS_MACOSX=Darwin
OS_SOLARIS=SunOS
OS_UBUNTU=Ubuntu

# 32-bit/64-bit platforms
PLATFORM_32BIT=32bit
PLATFORM_64BIT=64bit

# DR145390 - Trim TPT packages
TPTBASE="tptbase"                   # TPT Base

# DR 67864 - Teradata Warehouse Builder software names.
#TPT Dependency products
TPT_NAME="Teradata Parallel Transporter"    #TPT Full Name
TPT_BASE_NAME="$TPT_NAME Base"              #TPT Base Name
TPT_STREAM_NAME="$TPT_NAME Stream"          #TPT Stream

#DR109162 Add Query Director disk support
QRYDIR_NAME="Query Director"

# DR 67864 - Teradata Parallel Transporter installation info file.
TWBINSTALLINFOFILE=/tmp/twbinstallinfo

# DR 67864 - Init TTUMAININSTALLFILE. This file indicates that the installation
#            is being done from the CD.
TTUMAININSTALLFILE=/tmp/ttumaininstall

#The file/location for the remove script.
REMOVE_SCRIPT="uninstall_ttu.sh"

#The Media Label File - used to display the media name.
#DR 109162  - Previous method is obsolete.
MEDIALABEL="MEDIALABEL"
BITNESS=""

# Return codes
RC_OKAY=0
RC_WARNING=4
RC_USERERROR=8
RC_FATALERROR=12
RC_HIGHEST=$RC_OKAY
RC_TDICU=0
RC_CLIV2=0
RC_PIOM=0
RC_TTUPUBKEY=0

# Error messages. Begin with "ERR" and use 8 letter code.
ERRINVSL="Error: Invalid selection. Try again."
ERRNOISS="Error: Missing 'installer' program in Solaris directory."
ERRNOPRV="Error: No root privilege to install."
ERRPLATF="Error: Unsupported platform:"
ERRSPCSL="Error: Need to specify a selection. Try again."
ERRTOOMS="Error: Too many selections. Select only one."  #DR99782 add "s"
ERRUNBPF="Error: Unknown bit platform: " 
ERRUNPKG="Error: Unknown package directory name: " 
ERRUNSOL="Error: Unsupported Solaris platform with chip type:"

# Information messages. Begin with "INFO" and use 8 letter code.
INFOCNTQ="Do you want to continue with the installation? [y/n (default: y)]: "
INFOCONT="Press Enter to continue."
INFOCPYR="Copyright $CRYEAR Teradata. All rights reserved.
IF YOU OR THE ENTITY FOR WHOM YOU ARE INSTALLING THIS SOFTWARE DOES NOT HAVE 
A WRITTEN LICENSE AGREEMENT WITH TERADATA FOR THIS SOFTWARE, DO NOT INSTALL,
USE, OR ALLOW USE OF THIS SOFTWARE."
INFOEFIX="INFO: There may be important patches available for the products you just
      installed. Please consult the Teradata Software Server for the most
      recent version of all products."
INFOENTS="Enter one or more selections (separated by space): "
INFOREMOVE="u. Remove previously installed Teradata Tools and Utilities software (pre ${VERNUM})"
INFOMEDA="Media:"
INFONSFT="No software to install for this platform."
INFOPLTF="Platform:"
INFOWELC="Welcome to the Teradata Tools and Utilities $RELNUM installation"

# Warning messages. Begin with "WARN" and use 8 letter code.
#DR103114 - TPT warning instead of standard CLI warning
WARNTPTBASE="Warning: The $TPT_BASE_NAME software
         is a prerequisite for the following software:
         $TPT_STREAM_NAME." 
# DR 67864 - Create new WARNTPTBASE2 message.
WARNTPTBASE2="Warning: The $TPT_BASE_NAME software
         will be installed."

#DR116663 - Add code for Solaris Opteron to allow packages to upgrade
TMP_ADMIN_FILE=/tmp/adminfile

#Installation Directories
#In an effort to curtail the out of control media directory changes, they have
#consolidated into this section here.

# Directory names on the CD.
DIR_MPRAS=MPRAS
DIR_SOLARIS=Solaris
DIR_WINDOWS=Windows
DIR_MACOSX=MacOSX

#FORMAT:  PLATFORM_product_(32bit | 64bit )
# VERNUM varies per disk and is used during script run time.
#
# AIX Section 
# No bit specification=both 32bit & 64bit.  Must contain a package and .toc file
DIR_AIX=AIX
DIR_AIX_tdicu="$DIR_AIX/tdicu"
#DR106503 - Provide AIX/tdodbc directory
DIR_AIX_tdodbc="$DIR_AIX/tdodbc"
DIR_AIX_tdodbc_32bit="$DIR_AIX/tdodbc/32bit"
DIR_AIX_tdodbc_64bit="$DIR_AIX/tdodbc/64bit"
DIR_AIX_cliv2="$DIR_AIX/cliv2"
DIR_AIX_piom="$DIR_AIX/piom"
DIR_AIX_lfile="$DIR_AIX/lfile"
DIR_AIX_npaxsmod="$DIR_AIX/npaxsmod"
#DR101866 - Remove 64-bit MQAXSMOD
DIR_AIX_mqaxsmod="$DIR_AIX/mqaxsmod"
DIR_AIX_arc="$DIR_AIX/arc"
DIR_AIX_cobpp="$DIR_AIX/cobpp"
DIR_AIX_sqlpp="$DIR_AIX/sqlpp"
DIR_AIX_bteq="$DIR_AIX/bteq"
DIR_AIX_fastexp="$DIR_AIX/fastexp"
DIR_AIX_fastld="$DIR_AIX/fastld"
DIR_AIX_mload="$DIR_AIX/mload"
DIR_AIX_tdwallet="$DIR_AIX/tdwallet"
DIR_AIX_tpump="$DIR_AIX/tpump"

#TPT uses the version number in the directory name, /AIX/tpt8200 for example.
#These are used in the function with $DIR_AIX.
DIR_AIX_tptbase="$DIR_AIX/tptbase"

DIR_AIX_jmsaxsmod="$DIR_AIX/jmsaxsmod"        	#DR109162

#FORMAT:  DIR_LINUX_(i386 | s390x)_Product
#Linux i386 (includes x8664)
DIR_LINUX=Linux

cd `dirname $0`
pkgs32bit=$1
if [ -d $DIR_LINUX/i386 ] && [ -d $DIR_LINUX/x8664 ]; then
   MACHINE_ARCH=`uname -m`
   if [ "$pkgs32bit" = "32bit" ] || [ "$MACHINE_ARCH" != "x86_64" ];then
     DIR_LINUX_RPMS="$DIR_LINUX/i386"
   else
      DIR_LINUX_RPMS="$DIR_LINUX/x8664"
   fi
elif [ -d $DIR_LINUX/i386 ]; then
   DIR_LINUX_RPMS="$DIR_LINUX/i386"
else
   DIR_LINUX_RPMS="$DIR_LINUX/x8664"
fi

DIR_LINUX_ttupublickey="$DIR_LINUX_RPMS/tdicu"
DIR_LINUX_tdicu="$DIR_LINUX_RPMS/tdicu"
DIR_LINUX_tdodbc="$DIR_LINUX_RPMS/tdodbc"
DIR_LINUX_tdodbc32="$DIR_LINUX_RPMS/tdodbc32"
DIR_LINUX_cliv2="$DIR_LINUX_RPMS/cliv2"
DIR_LINUX_piom="$DIR_LINUX_RPMS/piom"
DIR_LINUX_mqaxsmod="$DIR_LINUX_RPMS/mqaxsmod"
DIR_LINUX_npaxsmod="$DIR_LINUX_RPMS/npaxsmod"
DIR_LINUX_s3axsmod="$DIR_LINUX_RPMS/s3axsmod"
DIR_LINUX_gcsaxsmod="$DIR_LINUX_RPMS/gcsaxsmod"
DIR_LINUX_azureaxsmod="$DIR_LINUX_RPMS/azureaxsmod"
DIR_LINUX_kafkaaxsmod="$DIR_LINUX_RPMS/kafkaaxsmod"
DIR_LINUX_bteq="$DIR_LINUX_RPMS/bteq"
DIR_LINUX_fastexp="$DIR_LINUX_RPMS/fastexp"
DIR_LINUX_fastld="$DIR_LINUX_RPMS/fastld"
DIR_LINUX_arc="$DIR_LINUX_RPMS/arc"
DIR_LINUX_mload="$DIR_LINUX_RPMS/mload"
DIR_LINUX_sqlpp="$DIR_LINUX_RPMS/sqlpp"
DIR_LINUX_tdwallet="$DIR_LINUX_RPMS/tdwallet"
DIR_LINUX_tpump="$DIR_LINUX_RPMS/tpump"

DIR_LINUX_tptbase="$DIR_LINUX_RPMS/tptbase"

DIR_LINUX_jmsaxsmod="$DIR_LINUX_RPMS/jmsaxsmod"        	#DR109162

#Linux s390x (includes s390)
DIR_LINUX_s390x="$DIR_LINUX/s390x"

DIR_LINUX_s390x_tdicu="$DIR_LINUX_s390x/tdicu"
DIR_LINUX_s390x_tdodbc="$DIR_LINUX_s390x/tdodbc"
DIR_LINUX_s390x_cliv2="$DIR_LINUX_s390x/cliv2"
DIR_LINUX_s390x_piom="$DIR_LINUX_s390x/piom"
DIR_LINUX_s390x_mqaxsmod="$DIR_LINUX_s390x/mqaxsmod"
DIR_LINUX_s390x_npaxsmod="$DIR_LINUX_s390x/npaxsmod"
DIR_LINUX_s390x_bteq="$DIR_LINUX_s390x/bteq"
DIR_LINUX_s390x_fastexp="$DIR_LINUX_s390x/fastexp"
DIR_LINUX_s390x_fastld="$DIR_LINUX_s390x/fastld"
DIR_LINUX_s390x_arc="$DIR_LINUX_s390x/arc"
DIR_LINUX_s390x_mload="$DIR_LINUX_s390x/mload"
DIR_LINUX_s390x_sqlpp="$DIR_LINUX_s390x/sqlpp"
DIR_LINUX_s390x_tdwallet="$DIR_LINUX_s390x/tdwallet"
DIR_LINUX_s390x_tpump="$DIR_LINUX_s390x/tpump"

DIR_LINUX_s390x_tptbase="$DIR_LINUX_s390x/tptbase"

#DR109162 Add Query Director disk support
DIR_LINUX_s390x_qrydir="$DIR_LINUX_s390x/qrydir"
DIR_LINUX_s390x_jmsaxsmod="$DIR_LINUX_s390x/jmsaxsmod"        	#DR109162

#Directory names for Solaris packages
#FORMAT:  DIR_(SOLARIS | OPTERON)_Product
#Solaris Sparc
DIR_SPARC=Sparc
DIR_SOLARIS_SPARC="Solaris/Sparc"

DIR_SPARC_tdicu="$DIR_SOLARIS_SPARC/tdicu"
DIR_SPARC_tdodbc="$DIR_SOLARIS_SPARC/tdodbc"
DIR_SPARC_cliv2="$DIR_SOLARIS_SPARC/cliv2"
DIR_SPARC_piom="$DIR_SOLARIS_SPARC/piom"
DIR_SPARC_mqaxsmod="$DIR_SOLARIS_SPARC/mqaxsmod"
DIR_SPARC_npaxsmod="$DIR_SOLARIS_SPARC/npaxsmod"
DIR_SPARC_bteq="$DIR_SOLARIS_SPARC/bteq"
DIR_SPARC_fastexp="$DIR_SOLARIS_SPARC/fastexp"
DIR_SPARC_fastld="$DIR_SOLARIS_SPARC/fastld"
DIR_SPARC_arc="$DIR_SOLARIS_SPARC/arc"
DIR_SPARC_mload="$DIR_SOLARIS_SPARC/mload"
DIR_SPARC_sqlpp="$DIR_SOLARIS_SPARC/sqlpp"
DIR_SPARC_tdwallet="$DIR_SOLARIS_SPARC/tdwallet"
DIR_SPARC_tpump="$DIR_SOLARIS_SPARC/tpump"

DIR_SPARC_ssredistlibs="$DIR_SOLARIS_SPARC/ssredistlibs"

DIR_SPARC_tptbase="$DIR_SOLARIS_SPARC/tptbase"

#Solaris Opteron
DIR_SOLARIS_OPTERON="Solaris/Opteron"

DIR_OPTERON_tdicu="$DIR_SOLARIS_OPTERON/tdicu"
DIR_OPTERON_tdodbc="$DIR_SOLARIS_OPTERON/tdodbc"
DIR_OPTERON_cliv2="$DIR_SOLARIS_OPTERON/cliv2"
DIR_OPTERON_piom="$DIR_SOLARIS_OPTERON/piom"
DIR_OPTERON_mqaxsmod="$DIR_SOLARIS_OPTERON/mqaxsmod"
DIR_OPTERON_npaxsmod="$DIR_SOLARIS_OPTERON/npaxsmod"
DIR_OPTERON_bteq="$DIR_SOLARIS_OPTERON/bteq"
DIR_OPTERON_fastexp="$DIR_SOLARIS_OPTERON/fastexp"
DIR_OPTERON_fastld="$DIR_SOLARIS_OPTERON/fastld"
DIR_OPTERON_arc="$DIR_SOLARIS_OPTERON/arc"
DIR_OPTERON_mload="$DIR_SOLARIS_OPTERON/mload"
DIR_OPTERON_sqlpp="$DIR_SOLARIS_OPTERON/sqlpp"
DIR_OPTERON_tdwallet="$DIR_SOLARIS_OPTERON/tdwallet"
DIR_OPTERON_tpump="$DIR_SOLARIS_OPTERON/tpump"

DIR_OPTERON_soredistlibs="$DIR_SOLARIS_OPTERON/soredistlibs"

DIR_OPTERON_tptbase="$DIR_SOLARIS_OPTERON/tptbase"

#Ubuntu
DIR_UBUNTU=Ubuntu
if [ -d $DIR_UBUNTU/i386 ] && [ -d $DIR_UBUNTU/x8664 ]; then
   MACHINE_ARCH=`uname -m`
   if [ "$pkgs32bit" = "32bit" ] || [ "$MACHINE_ARCH" != "x86_64" ];then
      DIR_UBUNTU_DEBS="$DIR_UBUNTU/i386"
   else
      DIR_UBUNTU_DEBS="$DIR_UBUNTU/x8664"
   fi
elif [ -d $DIR_UBUNTU/i386 ]; then
   DIR_UBUNTU_DEBS="$DIR_UBUNTU/i386"
else
   DIR_UBUNTU_DEBS="$DIR_UBUNTU/x8664"
fi

DIR_UBUNTU_tdicu="$DIR_UBUNTU_DEBS/tdicu"
DIR_UBUNTU_tdodbc="$DIR_UBUNTU_DEBS/tdodbc"
DIR_UBUNTU_cliv2="$DIR_UBUNTU_DEBS/cliv2"
DIR_UBUNTU_piom="$DIR_UBUNTU_DEBS/piom"
DIR_UBUNTU_mqaxsmod="$DIR_UBUNTU_DEBS/mqaxsmod"
DIR_UBUNTU_npaxsmod="$DIR_UBUNTU_DEBS/npaxsmod"
DIR_UBUNTU_jmsaxsmod="$DIR_UBUNTU_DEBS/jmsaxsmod"
DIR_UBUNTU_s3axsmod="$DIR_UBUNTU_DEBS/s3axsmod"
DIR_UBUNTU_gcsaxsmod="$DIR_UBUNTU_DEBS/gcsaxsmod"
DIR_UBUNTU_azureaxsmod="$DIR_UBUNTU_DEBS/azureaxsmod"
DIR_UBUNTU_kafkaaxsmod="$DIR_UBUNTU_DEBS/kafkaaxsmod"
DIR_UBUNTU_bteq="$DIR_UBUNTU_DEBS/bteq"
DIR_UBUNTU_bteq32="$DIR_UBUNTU_DEBS/bteq32"
DIR_UBUNTU_fastexp="$DIR_UBUNTU_DEBS/fastexp"
DIR_UBUNTU_fastld="$DIR_UBUNTU_DEBS/fastld"
DIR_UBUNTU_arc="$DIR_UBUNTU_DEBS/arc"
DIR_UBUNTU_mload="$DIR_UBUNTU_DEBS/mload"
DIR_UBUNTU_sqlpp="$DIR_UBUNTU_DEBS/sqlpp"
DIR_UBUNTU_tdwallet="$DIR_UBUNTU_DEBS/tdwallet"
DIR_UBUNTU_tpump="$DIR_UBUNTU_DEBS/tpump"
DIR_UBUNTU_tptbase="$DIR_UBUNTU_DEBS/tptbase"

# Function definitions start here.

##############################################################################
# Function: pause
#
# Description: pause until any key is entered
#
# Input: none
#        
# Output: none
#
# Note: Added with DR141060 to have a consistent pause function

pause ()
{
  printf "$1" 
  read pauseinput
}

###############################################################################
# Function: get_installed_package_version
#
# Description: Get the version of the package being installed
#
# Input: The path to the package file or directory
#
#
# Output: The version number of the package

get_installed_package_version ()
{
  case $PLATFORM in
    $NAME_LINUX)
      #If there isn't a package installed, rpm doesn't return the version.
      #Check the return code and if it is "1" then the package doesn't exist.
      #If that's the case, return nothing.
      tmpver=`rpm -q "$1" --queryformat "%{VERSION}\n"`
      if [ "$?" = "0" ]; then
        #0 is returned if the package exists, 1 if the package isn't installed.
        echo $tmpver | sort -r | head -1 | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4) }'
      fi
    ;;
    $NAME_UBUNTU)
      dpkg -s $1 2>/dev/null | grep '^Version' | awk '{print $2}' | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4) }'
    ;;
    $NAME_AIX)
      lslpp_r -R ALL -L -c 2>/dev/null | grep -w -i $1 | awk -F: '{ print $3 }' | sort -r| head -1 | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4) }'
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS)
      pkginfo -l $1 2>/dev/null | grep VERSION | awk '{print $2}' 
    ;;
  esac
}

##############################################################################
# Function: get_init_package_size
#
# Description: Get the version of the package being installed during initial stage
#
# Input: The path to the package file or directory
#        
# Output: The version number of the package
#

get_init_package_size ()
{
  case $PLATFORM in
    $NAME_LINUX)
      PKGSIZE=`$INSTALLCMD -qp $1/$2 --queryformat "%{SIZE}" 2> /dev/null`
      #PKGSIZE=`$INSTALLCMD -qp $1/*.rpm --queryformat "%{SIZE}" 2> /dev/null`
      # make sure PKGSIZE is not empty
      if [ -n "$PKGSIZE" ]
      then
        PKGSIZEMB=$(( ${PKGSIZE} / 1024 )) #Size is in bytes, we want KB
      else
        PKGSIZEMB=0
      fi
      echo $PKGSIZEMB
    ;;
    $NAME_UBUNTU)
      PKGSIZE=`$INSTALLCMD -f $1/*.deb Installed-Size`
      # make sure PKGSIZE is not empty
      if [ -n "$PKGSIZE" ]; then
        PKGSIZEMB=$PKGSIZE
      else
        PKGSIZEMB=0
      fi
      echo $PKGSIZEMB
    ;;
    $NAME_AIX)
      PKG_PATH=$1
      PKGSIZE=`du -s -k $PKG_PATH/*.bff | awk '{ print $1 }'`
      echo $PKGSIZE
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS) 
      PKGSIZE=`du -s -k $DIR | awk '{ print $1 }'`
      echo $PKGSIZE
    ;;
  esac
}

##############################################################################
# Function: get_init_package_version
#
# Description: Get the version of the package being installed during initial stage
#
# Input: The path to the package file or directory
#        
# Output: The version number of the package
#

get_init_package_version ()
{
  case $PLATFORM in
    $NAME_LINUX)
      $INSTALLCMD -qp $1/$2 --queryformat "%{VERSION}" 2> /dev/null
      #$INSTALLCMD -qp $1/*.rpm --queryformat "%{VERSION}" 2> /dev/null
    ;;
    $NAME_UBUNTU)
      $INSTALLCMD -f $1/*.deb Version | awk -F- '{print $1}'
    ;;
    $NAME_AIX)
      PKG_PATH=$1
      TOC_LINE=`sed '3q;d' < $PKG_PATH/.toc` 
      echo $TOC_LINE | awk '{ print $2 }' | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4) }'
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS) 
      PKG_PATH=$1
      if [ -f "${PKG_PATH}/pkginfo" ]; then
        grep VERSION $PKG_PATH/pkginfo | awk -F= '{ print $2 }'
      fi
    ;;
  esac
}

##############################################################################
# Function: get_package_version
#
# Description: Get the version of the package being installed
#
# Input: The path to the package file or directory
#        
# Output: The version number of the package
#

get_package_version ()
{
  case $PLATFORM in
    $NAME_LINUX)
      $INSTALLCMD -qp $1 --queryformat "%{VERSION}" 2> /dev/null
    ;;
    $NAME_UBUNTU)
      $INSTALLCMD -f $1 Version | awk -F- '{print $1}'
    ;;
    $NAME_AIX)
      PKG_PATH=$1
      TOC_LINE=`sed '3q;d' < $PKG_PATH/.toc` 
      echo $TOC_LINE | awk '{ print $2 }' | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4) }'
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS) 
      PKG_PATH=`echo $1 | awk '{ print $1 }'`
      PKG_PATH=${PKG_PATH}/$2
      if [ -f "${PKG_PATH}/pkginfo" ]; then
        grep VERSION $PKG_PATH/pkginfo | awk -F= '{ print $2 }'
      fi
    ;;
  esac
}

###############################################################################
# Function: write_to_install_log_file
#
# Description: Creates an installation log file in /var/log/teradata/client
#
# Input: Install_Type, Install Phase, Package Name, Package Parameters, 
#        Package File/Dir, Return Code, Error output file, System install cmd.
#
# Output: The output is echoed to the file /var/log/teradata/client/install.log
#

write_to_install_logfile ()
{
  NOW=$(date +"%m-%d-%Y")
  LOG_DIRECTORY=/var/log/teradata/client
  LOG_FILE="$LOG_DIRECTORY/install-$NOW.log"
  LOG_DATE=`date +"%m-%d-%Y,%T"`
  INSTALL_TYPE=$1
  INSTALL_PHASE=$2
  PKG_NAME=$3
  PKG_VERSION=$4
  PKG_PARAM=$5
  PKG_FILE=$6
  RETURN_CODE=$7
  ERR_OUTFILE=$8
  SYSTEM_INSTALL_COMMAND=$9

  if [ ! -d $LOG_DIRECTORY ]; then
    mkdir -p $LOG_DIRECTORY
  fi

     
  if [ ! -f $LOG_FILE ]; then
    MACHINE_NAME=`uname -n`
    printf "Teradata Client Utilities Installation Log File\n" > $LOG_FILE
    printf "Initially Created: $LOG_DATE\nSystem name=$MACHINE_NAME\n" >> $LOG_FILE
    printf "System type=$PLATFORM $BIT_PLATFORM $CHIP\n" >> $LOG_FILE
    printf "Date,Time,Type,Phase,Media,Package Name,Package Architecture,Package Version,Release Version,Script Version,Install Program,Parameters,Package Path/File,Return Code, Error File\n" >> $LOG_FILE
  fi

  printf "$LOG_DATE,$INSTALL_TYPE,$INSTALL_PHASE,$MEDIA,$PKG_NAME,$PKG_VERSION,'$RELNUM',$SCRIPTVER,$SYSTEM_INSTALL_COMMAND,'$PKG_PARAM',$PKG_FILE,$RETURN_CODE,$ERR_OUTFILE\n" >> $LOG_FILE
  
}

###############################################################################
# Function: create_solaris_response
#
# Description: Creates the Solaris response files
#
# Input:
#
# Output: 
#
create_solaris_response ()
{
if [ ! -d "$RESPONSEDIR" ]; then
    mkdir -p $RESPONSEDIR
    chmod 755 $RESPONSEDIR
    echo "Response Directory: $RESPONSEDIR"
fi
RESPONSE_NUM=`ls -l $RESPONSEDIR/*.response 2>/dev/null | wc -l`
if [ "$RESPONSE_NUM" -gt 0 ]; then
  for responsefile in $RESPONSEDIR/*
  do
    RESPONSEBASEDIR=`grep BASEDIR $responsefile | awk -F\' '{ print $2}'`
    if [ "$INSTALLED_DIR" ] && [ "$INSTALLED_DIR" != "$RESPONSEBASEDIR" ]; then
      printf "\nPackages are currently installed in $INSTALLED_DIR, and must be installed\n"
      echo "in the same location. Response files located at $RESPONSEDIR"
      echo "and set to install \"`basename $responsefile | awk -F. '{print $1}'`\" to $RESPONSEBASEDIR. "
      echo "Please remove the response files in order to install the TTU packages."
      if [ ! "$DEBUG" ]; then
        break #We break here so that we don't list ALL of the response files.
              #we have found one and that's sufficient. If DEBUG is set, just list them all.
      fi
    fi
  done
  if [ ! "$MENU_PARAMETERS" ]; then 
    echo "$RESPONSE_NUM response files found. Would you like to create new response files?"
    printf "Remove response files in $RESPONSEDIR? ([y/n] default: Y):"
    read REM_RESPONSE
    printf "\n"
  else
     REM_RESPONSE="y" #Install from the command line
  fi
  case $REM_RESPONSE in
    n* | N* )
      echo "Using response files in $RESPONSEDIR."
      return
    ;;
    y* | Y* | * )
      echo "Removing response files in $RESPONSEDIR."
      rm $RESPONSEDIR/*.response >/dev/null 2>&1
      echo "Using existing $RESPONSEDIR directory for response files."
    ;;
  esac 
fi

printf "\n"

#Start out the pkgask commands in the correct directory.
if [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ]; then
  cd "Solaris/Sparc"
else
  cd "Solaris/Opteron"
fi

echo "Creating response files in $RESPONSEDIR"
for PRODUCT in *
do 
  RESPONSE="$RESPONSEDIR/$PRODUCT.response"
  if [ "$DEBUG" ]; then
    echo "Response file=$RESPONSE"
  fi
  printf "."
  case $PRODUCT in
    #1 question, base dir only
    #At one time more packages asked more questions. Leaving this in for future expansion
    #if needed. However, this should only work on the following directories anyway.
    bteq* | fastexp* | fastld* | mload* | mqaxsmod* | npaxsmod* | piom* | sqlpp* | tdwallet* | tptbase* | tpump* | tdodbc* | cliv2* | jmsaxsmod* | tdicu*  | ttupublickey* | *redistlibs* )
      #A single directory, and "Y" to confirm install
      echo "$BASEDIR" | pkgask -r $RESPONSE -d . $PRODUCT >/dev/null 2>&1
    ;;
  esac
done
 
printf "\n"
cd - > /dev/null

}

###############################################################################
# Function: get_install_dir
#
# Description: Get the install directory from the user, config file or parameter.
#
# Input: None
#
# Output: None
#
get_install_dir ()
{
# default location for the ttu_install.cfg is var/opt/teradata
installCfg=/var/opt/teradata/ttu_install.cfg

#If the installCfg file isn't found in the default location, then find it.
#in the TTU_INSTALL_CFG path variable. This is from the ICU Linux package
#to do the same thing.
if [ ! -f "$installCfg" ]
then
  unset installCfg #Clear the variable for the config file
  #Check the environment variable TTU_INSTALL_CFG to see if it exists
  CFGPATH=`echo ${TTU_INSTALL_CFG}`
  echo $TTU_INSTALL_CFG
  if [ "$CFGPATH" != "" ]  #If it's not empty
  then
    installCfg=$CFGPATH/ttu_install.cfg
  elif [ -e ~/ttu_install.cfg ]
  then
    installCfg=~/ttu_install.cfg
  else
    installCfg=/tmp/ttu_install.cfg
  fi
  if [ -f $installCfg ]
  then
    #We found a config file in the list, so use it!
    echo "Reading install configuration file at $installCfg."
  else
    unset installCfg
  fi
fi
#If the installCfg file exists, then set INSTALLCFG_DIR to the path/file
#but only if PARAMINSTALL_DIR is empty as the parameter overrides the cfg file
if [ -f "$installCfg" ]
then
  checkinstallcfg=`grep -i "installdir=" $installCfg`
  if [ "$?" = "0" ]
  then
     INSTALLCFG_DIR=`echo $checkinstallcfg | awk -F= '{ print $2 }'`
     echo "Read install directory information from $installCfg"
  fi
fi

#If a package is currently installed, use that path as default don't 
#ask for input from the user, use the config file, or the command line.
if [ "$INSTALLED_DIR" ]; then
#This checks if the INSTALLED_DIR value is set, and it doesn't equal the
#value input by the parameter.
#Either way this is a good check to ensure installed packages to in the
#same location as already installed packages.
  if ([ "$PARAMINSTALL_DIR" ] && [ "$INSTALLED_DIR" != "$PARAMINSTALL_DIR" ]) || \
     ([ "$INSTALLCFG_DIR" ] && [ "$INSTALLED_DIR" != "$INSTALLCFG_DIR" ]); then
    echo "The package ${installed_pkg} package is already installed in"
    echo "\"${INSTALLED_DIR}\". In order to install, all packages of TTU ${RELNUM}, must be"
    echo "installed at same prefix. The directory \"$INSTALLED_DIR\" will be used to install."
  fi
  #Using currently installed directory $INSTALLED_DIR.
  echo "Using current base directory: $INSTALLED_DIR"
  BASEDIR="$INSTALLED_DIR"
else
  #If the installdir path is NOT passed on the command line, use the path
  #in the config file, or the installed packages, or /opt if nothing is set.
  if [ -z "$PARAMINSTALL_DIR" ] && [ -z "$MENU_PARAMETERS" ]; then 
    #Do this if not supplied command line dir
    echo "Which directory should be used as a base dir (prefix) for installing files?"
    printf "<base_dir>/teradata/client/$RELNUM\n"
    #If the installdir is in the config file, display that for default.
    if [ "$INSTALLCFG_DIR" ]; then
      printf "(default install dir from $installCfg: $INSTALLCFG_DIR ) : "
    #Suggest /opt if it's found in neither an installed package or .cfg file
    else
      printf "(default base dir: /opt ) : "
    fi 
    read BASEDIR
    #Make sure that the first character is "/" if it is not. This is to catch
    #any mistakes from the user in the menu
    FIRSTCHAR=`echo $BASEDIR | cut -c1`
    if [ "$BASEDIR" ] && [ "${FIRSTCHAR}" != "/" ]; then
      BASEDIR=`echo $BASEDIR | awk '{ print "/" $0;}'`
    fi
    if [ -z "$BASEDIR" ]; then
        if [ "$INSTALLCFG_DIR" ]; then
          echo "Using install directory from $installCfg: $INSTALLCFG_DIR"
          BASEDIR="$INSTALLCFG_DIR"
        else 
          #If no input from the user and the path isn't found, use /opt
          echo "Using /opt for the default installation directory."
          BASEDIR="/opt"
        fi
    else
      echo "Using $BASEDIR for the base directory for package installation."
    fi
  else
    #Added to display a warning message if both the parameter and cfg file
    #are set, and they conflict with each other. The parameter wins.
    #Only display it if nothing has already been installed.
    if [ "$PARAMINSTALL_DIR" ] && [ "$INSTALLCFG_DIR" ]; then
       if [ "$PARAMINSTALL_DIR" != "$INSTALLCFG_DIR" ]; then
         echo "A directory value has been provided from $installCfg,"
         echo "and from the command line and they conflict. The value from the"
         echo "command line, $PARAMINSTALL_DIR, will be used for the install."
      fi
    fi
    #If we're using the path from the command line, set it here as this is
    #considered to then be a silent install.
    #If it conflicts with an installed package later, it'll fail there.
    if [ -z "$PARAMINSTALL_DIR" ] && [ -z "$INSTALLCFG_DIR" ]; then
      echo "Using /opt as the install directory as one hasn't been provided."
      BASEDIR=/opt
    elif [ "$PARAMINSTALL_DIR" ]; then
      echo "Using $PARAMINSTALL_DIR from the command line."
      BASEDIR=$PARAMINSTALL_DIR
    elif [ "$INSTALLCFG_DIR" ]; then
      echo "Using $INSTALLCFG_DIR from $installCfg."
      BASEDIR=$INSTALLCFG_DIR
    fi
  fi
fi 

#Make sure that the first character is "/" if it is not. This is to catch
#any mistakes from the user in the config file, or parameter.
FIRSTCHAR=`echo $BASEDIR | cut -c1`
if [ "$BASEDIR" ] && [ "${FIRSTCHAR}" != "/" ]; then
  BASEDIR=`echo $BASEDIR | awk '{ print "/" $0;}'`
fi

#Quick and easy check. Try and make the directory to install to.
#If, for whatever reason, the directory doesn't exist, then it's
#an invalid directory and won't work for the install so end it here.
mkdir -p $BASEDIR 2>/dev/null
if [ ! -d "$BASEDIR" ]; then
  echo "Error: $BASEDIR unable to be created. This install cannot continue."
  exit 1
fi
if [ "$PLATFORM" = "$NAME_AIX" ]; then
  #Use lsusil to see if BASEDIR is in there. If not, then add is with mkusil
  lsusil -R $BASEDIR 2>/dev/null 1>&2
  if [ "$?" = "1" ]; then
    mkusil -R $BASEDIR -c "Created by $0 on `date`"
  fi
fi
#Added to warn about possible low space if installing the full suite. 
#The system will handle any issues with actually running out of space, and this
#is just a warning for the user at this point.
check_available_space "$BASEDIR"
}

FixTDWallet ()
{
  PACKAGE_NAME=$1
  TEMP_FILE=$2

  # all previous version hang so need to be creative with the uninstall
  if [[ "$PACKAGE_NAME" == *"32bit"* ]]; then
    procPath="/opt/teradata/client/$CURRENT_SHORTVER/tdwallet/suselinux-i386"
  else
    procPath="/opt/teradata/client/$CURRENT_SHORTVER/tdwallet/suselinux-x8664"
  fi
  mv $procPath/tdwallet $procPath/tdwallet-bad 2>/dev/null
  (sleep 1;echo y;sleep 1;echo y;sleep 1; echo y;sleep 1;echo y) | dpkg -P --force-all $PARSED_PKG_NAME > $TEMP_FILE 2>&1

  rm -fr $procPath
  ps ax | grep "$procPath/tdwallet daemon" | grep -v "grep" > tdwalletProcs.txt
  while read line
  do
    procID=`echo $line | cut -d' ' -f1`
    kill -9 $procID
  done < tdwalletProcs.txt
  rm -f tdwalletProcs.txt
}



###############################################################################
# Function: install_function
#
# Description: Replaces INSTALL_CMD for the install command
#
# Input: Package name, install parameters, install file/path
#
# Output: None
#
install_function ()
{
  NOW=$(date +"%m-%d-%Y")
  PACKAGE_NAME=$1
  INSTALL_PARAMETER=$2
  INSTALL_FILE=$3

  case $PLATFORM in
    $NAME_LINUX)
      PACKAGE_NAME=`ls $INSTALL_FILE`
    ;;
    $NAME_UBUNTU)
      PACKAGE_NAME=`ls $INSTALL_FILE`
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS)
      PACKAGE_NAME=`echo $3 | awk '{ print $2 }'`
    ;;
    $NAME_AIX)
      PACKAGE_NAME=`echo $3 | awk '{ print $2 }'`
    ;;
  esac

  RETURN_CODE="-"
  TEMP_FILE="/tmp/ttu-temp.$$"

  SYSTEM_INSTALL_COMMAND=$INSTALLCMD
  FULL_INSTALL_PATH=`echo $3 | awk '{ print $1 }'`
  INSTALL_PATH=`dirname $FULL_INSTALL_PATH`
  INSTALL_BASE=`basename $3 | awk -F- '{ print $1 "-" $2 }'`

  #This next part is to deal with the nonstandard TeraGSS name on
  #Linux and other platforms. The version query needs "TeraGSS_redhatlinux-i386
  #to determine the version, whereas the other products only need the first 
  #part.  (tdicu, bteq, fastld, etc.)
  if [ "$PLATFORM" = "$NAME_LINUX" ] || [ "$PLATFORM" = "$NAME_UBUNTU" ]; then 
    PARSED_PKG_NAME=`echo $INSTALL_BASE | awk -F- '{ print $1 }'`
    TMPLOC=`echo $INSTALL_BASE | awk -F- '{print $2 }'`
    if [ "$TMPLOC" = "32bit" ]; then
      PARSED_PKG_NAME=${PARSED_PKG_NAME}-$TMPLOC
    fi
    case $PARSED_PKG_NAME in
      TeraGSS*)
        PARSED_PKG_NAME=`echo $PARSED_PKG_NAME | awk -F_ '{ print $1 }'`
        if [ "$PARSED_PKG_NAME" = "TeraGSS" ]; then
          PARSED_PKG_NAME=$INSTALL_BASE
        fi  
      ;;
    esac
  else
    PARSED_PKG_NAME=$PACKAGE_NAME
  fi
  
  INSTALL_VERSION=`get_package_version $INSTALL_FILE`
#  INSTALL_VERSION_NUMERICAL=`echo $INSTALL_VERSION | sed 's#[^0-9]##g'`
# the above code only works on HP when alpha chars in the version string
  v1=`echo $INSTALL_VERSION | cut -d '.' -f 1 | cut -c1-2`
  v2=`echo $INSTALL_VERSION | cut -d '.' -f 2 | cut -c1-2`
  v3=`echo $INSTALL_VERSION | cut -d '.' -f 3 | cut -c1-2`
  v4=`echo $INSTALL_VERSION | cut -d '.' -f 4 | cut -c1-2`
  INSTALL_VERSION_NUMERICAL=${v1}${v2}${v3}${v4}
  

  CURRENT_VERSION=`get_installed_package_version $PARSED_PKG_NAME`
  if [ -z "$CURRENT_VERSION" ]; then
    CURRENT_VERSION="0"
    CURRENT_VERSION_NUMERICAL="0"
  else
    #CURRENT_VERSION_NUMERICAL=`echo $CURRENT_VERSION | sed 's#[^0-9]##g'`
    v1=`echo $CURRENT_VERSION | cut -d '.' -f 1 | cut -c1-2`
    v2=`echo $CURRENT_VERSION | cut -d '.' -f 2 | cut -c1-2`
    v3=`echo $CURRENT_VERSION | cut -d '.' -f 3 | cut -c1-2`
    v4=`echo $CURRENT_VERSION | cut -d '.' -f 4 | cut -c1-2`
    CURRENT_VERSION_NUMERICAL=${v1}${v2}${v3}${v4}	
    CURRENT_SHORTVER=${v1}.${v2}
  fi

  ERR_TEXT="-"
  ERR_FILE="/var/log/teradata/client/install-errorout-$PARSED_PKG_NAME-$NOW.$$"

########################################################
# End of Endless declarations and such
########################################################
  #Check to see if the version to be installed is the same version.
  if [ "$CURRENT_VERSION" = "$INSTALL_VERSION" ]; then
    #Skip asking for packages that are already installed if using parameters
    if [ "$MENU_PARAMETERS" ]; then
      echo "Skipping $PARSED_PKG_NAME: $CURRENT_VERSION = $INSTALL_VERSION"
      write_to_install_logfile Installation Skipped "$PACKAGE_NAME" "$INSTALL_VERSION" "$INSTALL_PARAMETER" "$INSTALL_FILE" 0  "Skipping install of $PACKAGE_NAME as $CURRENT_VERSION = $INSTALL_VERSION."
      return 1
    fi
    #Skip asking for packages that are dependency products.
    case $PARSED_PKG_NAME in
    tdicu*)
      set_active_rel="yes"
      return 1
    ;;
    ttupublickey*|cliv2*|piom*)
      if [ "$DEBUG" ]; then
        echo "Skipping $PARSED_PKG_NAME: $CURRENT_VERSION = $INSTALL_VERSION"
      fi
      write_to_install_logfile Installation Skipped "$PACKAGE_NAME" "$INSTALL_VERSION" "$INSTALL_PARAMETER" "$INSTALL_FILE" 0  "Skipping install of $PACKAGE_NAME as $CURRENT_VERSION = $INSTALL_VERSION." 
      return 1
    ;;
    *)
      echo ""
      echo "***The installed package $PARSED_PKG_NAME is the same version as the"
      echo "***package to be installed ($CURRENT_VERSION)."
      printf "***Do you want to reinstall the package? [y/n (default: n)]: "
      read INPUT
      if [ "$INPUT" != "y" ] && [ "$INPUT" != "Y" ]; then      
        echo "***Skipping install of $PARSED_PKG_NAME."
        echo ""
        write_to_install_logfile Installation Skipped "$PACKAGE_NAME" "$INSTALL_VERSION" "$INSTALL_PARAMETER" "$INSTALL_FILE" 0  "Skipping install of $PACKAGE_NAME as $CURRENT_VERSION = $INSTALL_VERSION." 
        return 1
      fi
    ;;
    esac
  fi

  #If the package isn't installed, the version returned is 0
  if [ "$CURRENT_VERSION_NUMERICAL" -lt "$INSTALL_VERSION_NUMERICAL" ] && \
     [ "$CURRENT_VERSION_NUMERICAL" -gt 0 ]; then
    echo "$PARSED_PKG_NAME: Currently Installed: $CURRENT_VERSION, Installing: $INSTALL_VERSION" 
  fi

  echo ""
  echo "Installing: $PARSED_PKG_NAME"

  unset RESPONSECMD
  if [ -d "$RESPONSEDIR" ]; then
    RESPONSEFILE="$RESPONSEDIR/$PARSED_PKG_NAME.response"
    if [ -f "$RESPONSEFILE" ]; then
      RESPONSECMD="-n -r $RESPONSEFILE"
      echo "Response file: $RESPONSEFILE"
    fi
  fi

  SYSTEM_INSTALL_COMMAND=$INSTALLCMD
  write_to_install_logfile Installation Start "$PACKAGE_NAME" "$INSTALL_VERSION" "$INSTALL_PARAMETER" "$INSTALL_FILE" $RETURN_CODE $ERR_TEXT $SYSTEM_INSTALL_COMMAND

  #Remove previously installed package with same name if platform is Solaris. This is done in order
  #to get around the error thrown by certain versions of Solaris when packages are reinstalled.
  installed_already=""
  if [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ] || [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ]; then
    installed_already=`pkginfo $PACKAGE_NAME 2>/dev/null | grep $PACKAGE_NAME`
    if [ -n "$installed_already" ]; then
      (sleep 1;echo y;sleep 1;echo y;sleep 1; echo y;sleep 1;echo y) | pkgrm $PARSED_PKG_NAME > $TEMP_FILE 2>&1
    fi
    rm -rf $TEMP_FILE
  fi

  #Remove previously installed package with same name if platform is AIX. This is done in order
  #to get around the error thrown by syschk during upgrade when file size changes.
  installed_already=""
  if [ "$PLATFORM" = "$NAME_AIX" ] ; then
    case $PARSED_PKG_NAME in
     tdicu*)
      dependent_pkgs=`lslpp -R $BASEDIR -cd cliv2$VERNUM.cliv2$VERNUM 2>/dev/null | grep \/usr\/lib | grep -v NONE | cut -d: -f3 | cut -d. -f1`
      if [ ! -z "$dependent_pkgs" ]; then
        dependent_pkgs="tdodbc$VERNUM $dependent_pkgs"
        dependent_pkgs=`echo $dependent_pkgs | tr '\n' ' '`
#        set -A dependent_pkgs_list $dependent_pkgs
      fi
      ;;
    cliv2*|piom*)
      dependent_pkgs=`lslpp -R $BASEDIR -cd $PACKAGE_NAME.$PACKAGE_NAME 2>/dev/null | grep \/usr\/lib | grep -v NONE | cut -d: -f3 | cut -d. -f1`
      if [ ! -z "$dependent_pkgs" ]; then
        dependent_pkgs=`echo $dependent_pkgs | tr '\n' ' '`
#        set -A dependent_pkgs_list $dependent_pkgs
      fi
      ;;
    *)
      ;;
    esac
	
    if [ "$CURRENT_VERSION" != "$INSTALL_VERSION" ]; then
      installed_already=`lslpp -R ALL -lc 2>/dev/null | grep $PACKAGE_NAME`
      if [ ! -z "$installed_already" ]; then
        BASENAME=`lslpp -R ALL -lc 2>/dev/null | grep $PACKAGE_NAME | grep "\/usr\/lib\/" | awk -F"usr\/lib" {' print $1 '}`
        if [ "$BASENAME" != "/" ]; then
            installp -R $BASENAME -g -u "$PACKAGE_NAME" > $TEMP_FILE 2>&1
        else
            installp -g -u "$PACKAGE_NAME" > $TEMP_FILE 2>&1
        fi
        rm -rf $TEMP_FILE
      fi
    fi
  fi
  
  #Remove previously installed package with same name if platform is Ubuntu. This is done in order
  #to get rid of any errors during upgrade
  installed_already=""
  if [ "$PLATFORM" = "$NAME_UBUNTU" ]; then
    installed_already=`dpkg -l | grep $PARSED_PKG_NAME`
    if [ -n "$installed_already" ]; then
      if [ "$CURRENT_VERSION_NUMERICAL" -lt 17100023 ] && [ "$PARSED_PKG_NAME" == *"tdwallet"* ]; then
        FixTDWallet $PARSED_PKG_NAME $TEMP_FILE
      else
        (sleep 1;echo y;sleep 1;echo y;sleep 1; echo y;sleep 1;echo y) | dpkg -P --force-all $PARSED_PKG_NAME > $TEMP_FILE 2>&1
      fi
    fi
    rm -rf $TEMP_FILE
  fi


  if [ "$DEBUG" ]; then 
    echo "*******Installation Command: $INSTALLCMD $RESPONSECMD $INSTALL_PARAMETER $INSTALL_FILE 2> $TEMP_FILE"
  fi
  $INSTALLCMD $RESPONSECMD $INSTALL_PARAMETER $INSTALL_FILE 2> "$TEMP_FILE"
  RETURN_CODE=$?
  #If the return code is NULL, set to "-".
  if [ -z $RETURN_CODE ]; then
    RETURN_CODE="-"
  fi
  #If there's an output file and the return code isn't 0, then set the err file
  #and put that information into the logfile.
  if [ -f "$TEMP_FILE" ] && [ $RETURN_CODE != "0" ]; then
    ERR_TEXT="$ERR_FILE"
    echo "$PACKAGE_NAME, $INSTALL_VERSION, $SYSTEM_INSTALL_COMMAND $INSTALL_PARAMETER $INSTALL_FILE" >> $ERR_FILE
    echo "*******************************************************************************" >> $ERR_FILE
    cat $TEMP_FILE >> $ERR_FILE
    echo "*******************************************************************************" >> $ERR_FILE
    cat $TEMP_FILE 
    rm $TEMP_FILE
  fi
  write_to_install_logfile Installation Finish "$PACKAGE_NAME" "$INSTALL_VERSION" "$INSTALL_PARAMETER" "$INSTALL_FILE" $RETURN_CODE $ERR_TEXT $SYSTEM_INSTALL_COMMAND
}

##############################################################################
# Function: make_temp_adminfile
#
# Description: Makes admin file which is passed on command line to pkgadd 
#              calls.  This is necessary b/c SUN by default does not overwrite
#              packages, but creates another version of packages.  We also want to
#              avoid any unnecessary questions for the user.
#              Based on make_temp_adminfile from installer.c for Solaris Sparc:
#              /master.src/scm/flexcrypt/globetrotter/SPARC/solaris_lic/
#              /installer/installer.c
#
# Input: none
#
# Output: The output is echoed into the new file TMP_ADMIN_FILE.
#
# Note:   Added with DR116663.
#
# See http://www.cims.nyu.edu/cgi-comment/man.cgi?section=4&topic=admin
#
# for a list of the parameters and options.  These settings are universal
# across all pkgadd installations (MP-RAS, Solaris, etc.)
#

make_temp_adminfile ()
{
  #Use TMP_ADMIN_FILE defined as /tmp/adminfile
  echo "## Teradata installer program temporary admin file." > $TMP_ADMIN_FILE
  echo "mail=" >> $TMP_ADMIN_FILE
  echo "instance=overwrite" >> $TMP_ADMIN_FILE
  echo "partial=nocheck" >> $TMP_ADMIN_FILE
  echo "runlevel=nocheck" >> $TMP_ADMIN_FILE
  echo "idepend=nocheck" >> $TMP_ADMIN_FILE
  echo "rdepend=nocheck" >> $TMP_ADMIN_FILE
  echo "space=nocheck" >> $TMP_ADMIN_FILE
  echo "setuid=nocheck" >> $TMP_ADMIN_FILE
  echo "conflict=nocheck" >> $TMP_ADMIN_FILE
  echo "action=nocheck" >> $TMP_ADMIN_FILE
  echo "basedir=default" >> $TMP_ADMIN_FILE
}

##############################################################################
# Function: validate_directories
#
# Description: Validates all of the available paths for installation
#              from the media or install directories.
# Input: none
#
# Output: If the expected directories exist for all directory paths
#         the path is echoed.
#
# Note:   This list must be checked against what is expected to be 
#         provided. This checks the SCM build from this script against
#         the media.
#         MP-RAS doesn't get checked, as the directories are a single level,
#         there aren't any 32-bit vs. 64-bit issues, and the product directories
#         aren't even looked at in this script.
#
#         Solaris Sparc/Opteron are also not used in the installation function,
#         but are provided here to check for the product.
#         
validate_directories ()
{
  echo "Validating Directories on Media Path : $PWD"
  #This gets all of the variables with "DIR_" such as "DIR_AIX" etc.
  #and puts them in a file so we can deal with them one line at a time.
  set | grep "^DIR_" > /tmp/validate_directories.out
  echo "On Media"

  #Read each variable from the file
  while read line
  do
     #We need the second argument, separated by the "=" sign"
     #And then we check to see if it exists as a directory, and just
     #echo the directory and path.  This will work for CD media
     #as well as mounted cds in any directory.
     DIRPATH=`echo $line | awk -F= '{ print $2 }'`
     if [ -d "$PWD/$DIRPATH" ]; then
       echo "$PWD/$DIRPATH" 
     fi
  done < /tmp/validate_directories.out

  #Remove the temp output file.
  rm /tmp/validate_directories.out
}

##############################################################################
#
# Function: ask_continue
#
# Description: Asks the user to continue or quit the installation.
#
# Input: 'y' - Continue the installation.
#        'n' - Quit the installation.
#        No input - defaults to 'y'.
#
# Output: If input is 'y' or no input, then there is no output and the
#         installation continues.
#         If input is 'n', then the installation exits with a return
#         code of zero.
#         For other input, it displays an error message and asks the user
#         to continue or quit the installation.
#
# Note: None
#
ask_continue ()
{
  invalid=1
  while [ $invalid ]
  do
    echo
    printf "$INFOCNTQ"
    read ans extra extra2
    # DR101866 - To support execution on Opteron
    if [ "$extra" ]; then
      display_msg "$ERRTOOMS" $RC_OKAY
    else
      # DR101866 - To support execution on Opteron
      if [ "$ans" ]; then
        case $ans in
          n) exit 0 ;;
          y) invalid= ;;
          *) display_msg "$ERRINVSL" $RC_OKAY ;;
        esac
      else
        invalid=
      fi
    fi
  done
}

##############################################################################
#
# Function: begin_installation
#
# Description: Starts the installation depending on the platform.
#
# Input: None
#
# Output: None
#
# Note: None
#
begin_installation ()
{
   if [ "$OSTYPE" = "$OS_MACOSX" ]; then
     if [ -d "$DIR_MACOSX" ]; then
       PKG_MAC=`ls $DIR_MACOSX/Teradata*.pkg`
       if [ -f "$PKG_MAC" ]; then
         open $PKG_MAC
         exit 0
       else
         echo "File not found: $PKG_MAC"
         exit 1
       fi
       echo "Directory not found: $DIR_MACOSX"
       exit 1
     fi
   exit 1
   fi

   if [ "$PLATFORM" = "$NAME_MPRAS" ]; then
      if [ -d "$DIR_MPRAS" ] &&
         [ `ls -1 "$DIR_MPRAS" | wc -l` -gt 0 ]; then

         # DR 67864 - Perform steps before installation.
         perform_preinstall

         #DR116663 Check for a empty PWD, and set it to what is returned
         # from calling pwd (the current directory). PWD should never be empty
         # but on rare occasions it can happen on MPRAS.
         if [ "${PWD}" = "" ]; then
           PWD=`pwd`
         fi

         #DR116663 Fix for ksh support - use PWD for path
         $INSTALLCMD -d ${PWD}/${DIR_MPRAS}

         # DR 67864 - Perform steps after installation.
         perform_postinstall
      else
         display_msg "$INFONSFT" $RC_OKAY
         exit 0
      fi
   elif [ "$PLATFORM" = "$NAME_AIX" ]; then
      if [ -d "$DIR_AIX" ] &&
         [ `ls -1 "$DIR_AIX" | wc -l` -gt 0 ]; then
         reset_install
         read_pkgs
         fill_version_numbers 
         fill_package_sizes 
         setup_menu
         display_menu
         check_dependency
         get_install_dir
         execute_on_AIX
      else
         display_msg "$INFONSFT" $RC_OKAY
         exit 0
      fi
   elif [ "$PLATFORM" = "$NAME_LINUX" ]; then
      # DR 51932 - Support Linux.
      if [ -d "$DIR_LINUX" ] &&
         [ `ls -1 "$DIRNAME" | wc -l` -gt 0 ]; then
         reset_install
         read_pkgs
         fill_version_numbers 
         fill_package_sizes
         checkFormat=1
         setup_menu
         display_menu
         check_dependency
         get_install_dir
         execute_on_LINUX
      else
         display_msg "$INFONSFT" $RC_OKAY
         exit 0
      fi
   elif [ "$PLATFORM" = "$NAME_UBUNTU" ]; then
      if [ -d "$DIR_UBUNTU" ] &&
         [ `ls -1 "$DIRNAME" | wc -l` -gt 0 ]; then
         reset_install
         read_pkgs
         fill_version_numbers 
         fill_package_sizes
         checkFormat=1
         setup_menu
         display_menu
         check_dependency
         #get_install_dir
         #Currently Ubuntu packages support installations in /opt prefix only.
         BASEDIR=/opt
         execute_on_UBUNTU
      else
         display_msg "$INFONSFT" $RC_OKAY
         exit 0
      fi
    elif [ "$PLATFORM" = "${NAME_SOLARIS_OPTERON}" ]; then
      # DR101866 - Support Solaris Opteron
      if [ -d "${DIR_SOLARIS}" ] &&
         [ `ls -1 "${DIRNAME}" | wc -l` -gt 0 ]; then
         reset_install
         read_pkgs
         fill_version_numbers 
         fill_package_sizes 
         setup_menu
         display_menu
         check_dependency
         execute_on_Solaris
         else
            display_msg "$INFONSFT" $RC_FATALERROR
         fi
   elif [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ]; then
      if [ -d "$DIR_SOLARIS" ] &&
         [ `ls -1 $DIRNAME | wc -l` -gt 0 ]; then
            reset_install
            read_pkgs
            fill_version_numbers 
            fill_package_sizes 
            setup_menu
            display_menu
            check_dependency
            execute_on_Solaris
      else
         display_msg "$INFONSFT" $RC_OKAY
         exit 0
      fi
   fi

   # If the very same version of tdicu was found installed, skip reinstallation
   # of tdicu, and simply change the active TTU release to the version of that
   # tdicu..
   if [ "${set_active_rel}" = "yes" ]; then
     echo ""
     if [ "$BITNESS" = "32-bit Bundle" ]; then
       . "${BASEDIR}"/teradata/client/"${CURRENT_SHORTVER}"/bin/setactiverel_32.sh
     else
       . "${BASEDIR}"/teradata/client/"${CURRENT_SHORTVER}"/bin/setactiverel.sh
     fi
   fi

   # DR 67864 - Display message about latest patches.
   if [ ! "$MENU_PARAMETERS" ]; then
     echo ""
     display_msg "$INFOEFIX" $RC_OKAY
   fi

LICENSEFILE="ThirdPartyLicensesTTU.txt" 
if [ -f "${LICENSEFILE}" ]; then
  #LICENSEFILE found on media
  if [ "${BASEDIR}/teradata/client/${RELNUM}" ]; then
    cp ${LICENSEFILE} "${BASEDIR}"/teradata/client/${RELNUM}
  fi
fi

LICENSEFILE_PDF="ThirdPartyLicensesTTU.pdf" 
if [ -f "${LICENSEFILE_PDF}" ]; then
  #LICENSEFILE_PDF found on media
  if [ "${BASEDIR}/teradata/client/${RELNUM}" ]; then
    cp ${LICENSEFILE_PDF} "${BASEDIR}"/teradata/client/${RELNUM}
  fi
fi
   
#CLNTINS-4765 - If /usr or /usr/lib are 777, change to 755.
#This can happen from TDICU packages prior to 15.10. This cleans it up.
if [ "$PLATFORM" = "$NAME_AIX" ]; then
  CHECKDIRS="/usr /usr/lib /usr/lib/lib_64"
  for dir in $CHECKDIRS
  do
    perms=`ls -ld $dir 2>/dev/null | awk '{ print $1 '}`
    if [ "$perms" = "drwxrwxrwx" ]; then
      chmod 755 $dir
    fi
  done
fi
#Exit the .setup.sh script here normally after installing all products
}

##############################################################################
#
# Function: check_dependency
#
# Description: Checks software dependency. If a dependency fails, the user
#              will be asked to continue or quit the installation.
#
# Input: None
#
# Output: None
#
# Note: display_ask_continue is a global variable. It will be set to 1 if
#       a dependency fails.
#
check_dependency ()
{
  display_ask_continue=0
  check_tdicu
  check_cli
  check_piom

if [ "$PLATFORM" = "$NAME_LINUX" ]; then
    check_ttupublickey
fi

if [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ] || [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ]; then
   check_redistlibs
fi


if [ $display_ask_continue -eq 1 ]; then
    ask_continue
fi
}

#################################################################################
#
# Function: check_redistlibs
#
# Description: Checks the dependency for runtime libraries.
#              If redistlibs is not installed and not selected for installation,
#              then it displays a warning message
#              --- only for Solaris platform
# Input: None
#
# Output: None
#
# Note: None
#
check_redistlibs ()
{
  if [ $install_tdicu -eq 1 ] || [ $install_tdwallet -eq 1 ]; then
      if [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ]; then
           install_soredistlibs=1
      elif [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ]; then
           install_ssredistlibs=1
      fi
  fi
}
##############################################################################
#
# Function: check_ttupublickey
#
# Description: Checks the dependency for ttupublickey.
#              If ttupublickey is not installed and ttupublickey is not selected for
#              installation, then it displays a warning message
#              about ttupublickey dependency, makes ttupublickey installable, and
#              sets the flag to ask the user to continue or quit
#              the installation.
#
# Input: None
#
# Output: None
#
# Note: None
#
check_ttupublickey ()
{
  if [ $install_tdicu -eq 1 ]  ||[ $install_piom -eq 1 ] ||
     [ $install_tdwallet -eq 1 ]; then 
    install_ttupublickey=1
  fi
}


##############################################################################
#
# Function: check_tdicu
#
# Description: Checks the dependency for tdicu.
#              If tdicu is not installed and tdicu is not selected for
#              installation, then it displays a warning message
#              about tdicu dependency, makes tdicu installable, and
#              sets the flag to ask the user to continue or quit
#              the installation.
#
# Input: None
#
# Output: None
#
# Note: None
#
check_tdicu ()
{
# DR95397 add TPT packages
# DR99782 Add products dependent on tdicu: bteq, fastexp, fastlld, etc.
#DR109162 Add Query Director disk support
#DR109162 Add check for install_picu
  if [ $install_bteq -eq 1 ]    || [ $install_bteq32 -eq 1 ]    ||
     [ $install_fastexp -eq 1 ] || [ $install_cliv2 -eq 1 ]     ||
     [ $install_fastld -eq 1 ]  || [ $install_mload -eq 1 ]     ||
     [ $install_tpump -eq 1 ]   || [ $install_qrydir -eq 1 ]    ||
     [ $install_cobpp -eq 1 ]   || [ $install_sqlpp -eq 1 ]     ||
     [ $install_arc -eq 1 ]     || [ $install_tptbase -eq 1 ]; then 
    install_tdicu=1
  fi
}

##############################################################################
#
# Function: check_cli
#
# Description: Checks the dependency for CLI.
#              If CLI is not installed and CLI is not selected for
#              installation, then it displays a warning message
#              about CLI dependency, makes CLI installable, and
#              sets the flag to ask the user to continue or quit
#              the installation.
#
# Input: None
#
# Output: None
#
# Note: The <cliv2so> package has been removed as of TTU8.1.
#
check_cli ()
{
  #DR95397 add TPT packages dependent on CLI
  #DR109162 Add Query Director disk support
  if [ $install_bteq -eq 1 ]   || [ $install_fastexp -eq 1 ]   ||
     [ $install_fastld -eq 1 ] || [ $install_mload -eq 1 ]     ||
     [ $install_tpump -eq 1 ]  || [ $install_qrydir -eq 1 ]    ||
     [ $install_cobpp -eq 1 ]  || [ $install_sqlpp -eq 1 ]     ||
     [ $install_arc -eq 1 ]    ||  
     [ $install_tptbase -eq 1 ]|| [ $install_bteq32 -eq 1 ]; then 
    install_cliv2=1
  fi
}

##############################################################################
#
# Function: check_piom
#
# Description: Checks the dependency for Data Connector.
#              If Data Connector is not installed and Data Connector
#              is not selected for installation, then it displays a
#              warning message about Data Connector dependency, makes
#              Data Connector installable, and sets the flag to ask
#              the user to continue or quit the installation.
#
# Input: None
#
# Output: None
#
# Note: The package name for the Data Connector is <piom>.
#
check_piom ()
{
  if [ $install_bteq -eq 1 ]   || [ $install_bteq32 -eq 1 ] ||
     [ $install_fastld -eq 1 ] || [ $install_mload -eq 1 ]  ||
     [ $install_tpump -eq 1 ]  || [ $install_arc -eq 1 ]    ||
	 [ $install_fastexp -eq 1 ]; then
    install_piom=1
  fi
}


##############################################################################
#
# Function: check_available_space
#
# Description: Checks how much space is available in a directory
#
# Input: directory
#
# Output: Sets AVAILABLE_SPACE to a value
#
# Note: None
#
check_available_space ()
{
CHECKDIR="$1"
case $PLATFORM in
  $NAME_AIX)
     AVAILABLE_SPACE=`df -k $CHECKDIR | tail -1 | awk '{ print $3 }'`
  ;;
  $NAME_LINUX)
     AVAILABLE_SPACE=`df -k $CHECKDIR | tail -1 | awk '{ print $4 }'`
  ;;
  $NAME_UBUNTU)
     AVAILABLE_SPACE=`df -k $CHECKDIR | tail -1 | awk '{ print $4 }'`
  ;;
  $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON | $NAME_MPRAS)
    AVAILABLE_SPACE=`df -k $CHECKDIR | tail -1 | awk '{ print $4 }'`
  ;;
  esac

  INSTALLED_SIZE=$(( $arc_size + $bteq_size + $ttupublickey_size + $cliv2_size + $cobpp_size + $fastexp_size + $fastld_size + $lfile_size + $mload_size + $mqaxsmod_size + $npaxsmod_size + $s3axsmod_size + $gcsaxsmod_size + $azureaxsmod_size + $kafkaaxsmod_size + $piom_size + $sqlpp_size + $tptbase_size +  $tdicu_size + $tdodbc_size + $tdodbc32_size + $teragss_size + $tdwallet_size + $tpump_size + $qrydir_size +  $jmsaxsmod_size + $soredistlibs_size + $ssredistlibs_size ))
  if [ "$DEBUG" ]; then
    printf "\nThe total size of all installed packages is: ${INSTALLED_SIZE}KB.\n"
    printf "The total size of the available space is...: ${AVAILABLE_SPACE}KB in $CHECKDIR.\n"
  fi
  if [ "$AVAILABLE_SPACE" -lt "$INSTALLED_SIZE" ] && [ -d "$CHECKDIR" ]; then
    echo ""
    echo "Warning: The filesystem $CHECKDIR may not have enough space for a full install."
    echo "         There is only ${AVAILABLE_SPACE}KB available for installation in $CHECKDIR."
    echo "         Estimated total install size: ${INSTALLED_SIZE}KB"
  fi
}

##############################################################################
#
# Function: display_media_label
#
# Description: Determines the name of the media from the MEDIALABEL file.
#              It reads the file MEDIALABEL in the root directory of the
#              media to determine the name to display
#
# Input: None
#
# Output: Displays the name of the media.
#
# Note: None
#
display_media_label ()
{
  if [ -f "$MEDIALABEL" ]; then  #Only do this if MEDIALABEL file exists.
    MEDIA=`head -n 1 $MEDIALABEL`
    if [ "$MEDIA" ]; then
      if [ "$pkgs32bit" = "32bit" ]; then
        BITNESS="32-bit Bundle"
      elif [ -d $DIR_LINUX/x8664 ] || [ -d $DIR_UBUNTU/x8664 ]; then
        BITNESS="64-bit Bundle"
      elif [ -d $DIR_LINUX/i386 ] || [ -d $DIR_UBUNTU/i386 ]; then
        BITNESS="32-bit Bundle"
      fi
      echo "$INFOMEDA" "$MEDIA" "$BITNESS"
    fi
  fi
}


##############################################################################
#
# Function: determine_platform
#
# Description: Determines the platform using the "uname" command.
#
# Input: None
#
# Output: If a platform is supported, then it sets the global variable,
#         PLATFORM, with the name of the platform.
#         If it's unsupported, then it displays an error message and
#         exits.
#
# Note: None
#
determine_platform ()
{
   OSTYPE=`uname -s`
   OSRELVER=`uname -r -v`
   OSREL=`uname -r`
   OSVER=`uname -v`
   OSHW=`uname -m`

   #DR101866 add Solaris Opteron
   ISAINFO="/usr/bin/isainfo"

   #If /opt doesn't exist, try and create it.
   if [ ! -d "/opt" ]; then
     mkdir /opt 2>/dev/null
     chmod 755 /opt  2>/dev/null
   fi
   if [ "$OSTYPE" = "$OS_AIX" ]; then
      PLATFORM="$NAME_AIX"

      # DR 67864 - Set the DIRNAME for AIX.
      DIRNAME="$DIR_AIX"

      #This is used to determine version of AIX in use. Currently unused.
      #OSLEVEL=`/usr/bin/oslevel`

      PLATFORM_AIX_32BIT=32
      PLATFORM_AIX_64BIT=64

      # DR 64258 - Determine if AIX is 32-bit or 64-bit.
      # DR 93956 - Use getconf instead of bootinfo, as bootinfo needs
      #            root privilege.
      #BIT_PLATFORM=`/usr/bin/getconf HARDWARE_BITMODE`
      BIT_PLATFORM=`/usr/sbin/bootinfo -y 2>/dev/null` 
      if [ "$?" -ne "0" ]; then
        display_msg "$ERRNOPRV" $RC_USERERROR
        exit $RC_USERERROR
      fi 
        

      if [ "$BIT_PLATFORM" = "$PLATFORM_AIX_32BIT" ]; then
         BIT_PLATFORM=$PLATFORM_32BIT
      elif [ "$BIT_PLATFORM" = "$PLATFORM_AIX_64BIT" ]; then
         BIT_PLATFORM=$PLATFORM_64BIT
      else
         echo "$ERRUNBPF" "$BIT_PLATFORM"
         exit $RC_USERERROR
      fi

      # DR 68034 - Get the OS base version.
      X11_BASE_COMMON_VER=`lslpp -lq | grep X11.base.common | /usr/bin/awk {'print $2'}`

   elif [ "$OSTYPE" = "$OS_LINUX" ]; then
      OS_DISTRIB_ID=`cat /etc/lsb-release 2>/dev/null | grep DISTRIB_ID | awk -F= '{ print $2 }'`
      OS_ID=`cat /etc/os-release 2>/dev/null | egrep "(ID=ubuntu|ID=debian)" | awk -F= '{ print $2 }'`
      if [ "$OS_ID" = "ubuntu" ] || [ "$OS_ID" = "debian" ]; then
         PLATFORM="$NAME_UBUNTU"

         # Determine if Linux is 32-bit or 64-bit.
         BIT_PLATFORM=`uname -m`
         DIRNAME="$DIR_UBUNTU_DEBS"

         case $BIT_PLATFORM in
           i3* | I3* | i4* | I4* | i5* | I5* | i6* | I6* ) 
             BIT_PLATFORM=$PLATFORM_32BIT
             CHIP=$CHIP_INTEL
             ;;
           ia64 )
             BIT_PLATFORM=$PLATFORM_64BIT
             CHIP=$CHIP_IA64
             ;;
           x86*)
             BIT_PLATFORM=$PLATFORM_64BIT
             CHIP=$CHIP_SUSE64
             ;;
           *)
             echo "$ERRUNBPF" "$BIT_PLATFORM"
             exit $RC_USERERROR
             ;;
         esac
      else
         # DR 51932 - Support Linux.
         PLATFORM="$NAME_LINUX"
         DIRNAME="$DIR_LINUX_RPMS"

         # Determine if Linux is 32-bit or 64-bit.
         BIT_PLATFORM=`uname -m`
         
         case $BIT_PLATFORM in
           i3* | I3* | i4* | I4* | i5* | I5* | i6* | I6* ) 
           BIT_PLATFORM=$PLATFORM_32BIT
           CHIP=$CHIP_INTEL
           ;;
         ia64 )
           BIT_PLATFORM=$PLATFORM_64BIT
           CHIP=$CHIP_IA64
           ;;
         x86*)
           BIT_PLATFORM=$PLATFORM_64BIT
           CHIP=$CHIP_SUSE64
           ;;
         s390x)
           BIT_PLATFORM=$PLATFORM_64BIT
           CHIP=$CHIP_S390X   #s390x
           DIRNAME="$DIR_LINUX_s390x"
           ;;
         s390)
           BIT_PLATFORM=$PLATFORM_32BIT
           CHIP=$CHIP_S390X   #s390x
           DIRNAME="$DIR_LINUX_s390x"
           ;;
         *)
           echo "$ERRUNBPF" "$BIT_PLATFORM"
           exit $RC_USERERROR
           ;;
         esac
      fi

   elif [ "$OSTYPE" = "$OS_SOLARIS" ]; then
      CHIP=`uname -p`
      KRNLMODS=`$ISAINFO -k`

      if [ "$CHIP" = "$CHIP_SPARC" ]; then
         PLATFORM="$NAME_SOLARIS_SPARC"
         # DR 67864 - Set the DIRNAME for Solaris-Sparc.
         # Change this when decomissioning the "installer" program
         DIRNAME="$DIR_SOLARIS_SPARC"

         #DR116663 - Add correct BIT_PLATFORM setting for 64bit
         if [ "$KRNLMODS" = "sparcv9" ]
         then
           BIT_PLATFORM="$PLATFORM_64BIT"
         else
           BIT_PLATFORM="$PLATFORM_32BIT"
         fi
      elif [ "$CHIP" = "$CHIP_INTEL" ]; then
         PLATFORM="$NAME_SOLARIS_OPTERON"
         DIRNAME="$DIR_SOLARIS_OPTERON" 
         CHIP="$CHIP_OPTERON"
         #DR101866
         if [ "$KRNLMODS" = "amd64" ]
         then
           BIT_PLATFORM="$PLATFORM_64BIT"
         else
           BIT_PLATFORM="$PLATFORM_32BIT"
         fi
      else
         echo
         echo "$ERRUNSOL" "$CHIP"
         exit $RC_USERERROR
      fi
   # DR 93851 - Check for MP-RAS 3.03.
   elif [ "$OSTYPE" = "$OS_MPRAS" ] || [ "$OSRELVER" = "$MPRAS_RELVER" ] ||
        ([ -f "$RELID_FILE" ] && [ "$OSVER" = "$MPRAS_3_3_VER" ]); then
      PLATFORM="$NAME_MPRAS"

      # DR 67864 - Set the DIRNAME for MP-RAS.
      DIRNAME="$DIR_MPRAS"
   elif [ "$OSTYPE" = "$OS_MACOSX" ]; then
      PLATFORM="Mac OS X `uname -r`"
      CHIP=`uname -p`
      DIRNAME="$DIR_MACOSX"
   else      
      echo
      echo "$ERRPLATF" "$OSTYPE"
      exit $RC_USERERROR
   fi

   echo
   if [ "$CHIP" = "$CHIP_SPARC" ] || [ "$CHIP" = "$CHIP_OPTERON" ]; then
     echo "$INFOPLTF $PLATFORM $BIT_PLATFORM"
   elif [ "$OSTYPE" = "$OS_MACOSX" ]; then
       echo "$INFOPLTF $PLATFORM $BIT_PLATFORM $OSHW $CHIP"
  else
       echo "$INFOPLTF $PLATFORM $BIT_PLATFORM $CHIP"
   fi
}

##############################################################################
#
# Function: determine_privilege
#
# Description: Determines if the installer has root privilege.
#              If the installer does not have root privilege,
#              then it displays an error message and exits.
#
# Input: None
#
# Output: None
#
# Note: The installer must have root privilege.
#
determine_privilege ()
{
  if [ "$PLATFORM" = "$NAME_MPRAS" ]; then
    if (type pkgplus > /dev/null 2>&1); then
      INSTALLCMD=pkgplus
    elif (type pkgadd > /dev/null 2>&1); then
      INSTALLCMD=pkgadd
    else
      display_msg "$ERRNOPRV" $RC_USERERROR
    fi
  elif [ "$PLATFORM" = "$NAME_AIX" ]; then
    INSTALLCMD=installp_r #Added _r for relocatable packages
    if [ `/bin/id -u` != "0" ]; then
      display_msg "$ERRNOPRV" $RC_USERERROR
    fi
  elif [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ] ||  
       [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ]; then # Added for both 
    if [ `/usr/xpg4/bin/id -u` != "0" ]; then
      display_msg "$ERRNOPRV" $RC_USERERROR
    fi 
      INSTALLCMD=pkgadd
      PKGINFOCMD=pkginfo
  elif [ "$PLATFORM" = "$NAME_LINUX" ]; then
    # DR 51932 - Support Linux.
    INSTALLCMD=rpm
    if [ `/usr/bin/id -u` != "0" ]; then
      display_msg "$ERRNOPRV" $RC_USERERROR
    fi 
  elif [ "$PLATFORM" = "$NAME_UBUNTU" ]; then
    INSTALLCMD=dpkg
    if [ `/usr/bin/id -u` != "0" ]; then
      display_msg "$ERRNOPRV" $RC_USERERROR
    fi 
  fi
}

##############################################################################
reset_pkg_nums ()
{
  ttupublickey_num=0
  cliv2_num=0
  arc_num=0
  bteq_num=0
  bteq32_num=0
  cobpp_num=0
  fastexp_num=0
  fastld_num=0
  lfile_num=0
  mload_num=0
  mqaxsmod_num=0
  npaxsmod_num=0
  s3axsmod_num=0
  gcsaxsmod_num=0  
  azureaxsmod_num=0
  kafkaaxsmod_num=0
  piom_num=0
  sqlpp_num=0
  tptbase_num=0
  tdicu_num=0
  odbc_num=0
  odbc32_num=0
  tdwallet_num=0
  tpump_num=0
  qrydir_num=0   	#DR109162
  jmsaxsmod_num=0  	#DR109162
  soredistlibs_num=0
  ssredistlibs_num=0
}

##############################################################################
reset_pkg_exists ()
{
  ttupublickey_pkg_exists=0
  cliv2_pkg_exists=0
  arc_pkg_exists=0
  bteq_pkg_exists=0
  bteq32_pkg_exists=0
  cobpp_pkg_exists=0
  fastexp_pkg_exists=0
  fastld_pkg_exists=0
  lfile_pkg_exists=0
  mload_pkg_exists=0
  mqaxsmod_pkg_exists=0
  npaxsmod_pkg_exists=0
  s3axsmod_pkg_exists=0
  gcsaxsmod_pkg_exists=0  
  azureaxsmod_pkg_exists=0
  kafkaaxsmod_pkg_exists=0
  piom_pkg_exists=0
  sqlpp_pkg_exists=0
  tptbase_pkg_exists=0
  tdicu_pkg_exists=0
  tdodbc_pkg_exists=0
  tdodbc32_pkg_exists=0
  tdwallet_pkg_exists=0
  tpump_pkg_exists=0
  qrydir_pkg_exists=0   	#DR109162
  jmsaxsmod_pkg_exists=0  	#DR109162
  soredistlibs_pkg_exists=0
  ssredistlibs_pkg_exists=0
}

##############################################################################
read_pkgs ()
{
   reset_pkg_exists

   cd "$DIRNAME"
   cDir=$PWD
   for file in *
   do
      printf "."
      if [ "$DEBUG" ]; then echo "Debug read_pkgs : $file "; fi

      if [ "$PLATFORM" != "$NAME_LINUX" ]; then
         cd $file      2>/dev/null
      elif [ -d $file ]; then
        cd $file
        file=`ls *.rpm 2>/dev/null`
      fi
  
      case "$file" in
         bteq*) bteq_pkg_exists=1;;
         cliv2*) cliv2_pkg_exists=1;;
         cobpp*) cobpp_pkg_exists=1;;
         fastexp*) fastexp_pkg_exists=1;;
         fastld*) fastld_pkg_exists=1;;
         lfile*) lfile_pkg_exists=1;;
         mload*) mload_pkg_exists=1;;
         mqaxsmod*) mqaxsmod_pkg_exists=1;;
         npaxsmod*) npaxsmod_pkg_exists=1;;
         s3axsmod*) s3axsmod_pkg_exists=1;;
         gcsaxsmod*) gcsaxsmod_pkg_exists=1;;		 
         azureaxsmod*) azureaxsmod_pkg_exists=1;;
         kafkaaxsmod*) kafkaaxsmod_pkg_exists=1;;
         piom*) piom_pkg_exists=1;;
         sqlpp*) sqlpp_pkg_exists=1;;
         $TPTBASE*) tptbase_pkg_exists=1;;         # DR 147885
         tdicu*) tdicu_pkg_exists=1;;
         tdodbc32*) tdodbc32_pkg_exists=1;;
         tdodbc*) tdodbc_pkg_exists=1;;
         #DR101866 add * to TeraGSS since TeraGSS for different dirname
         tdwallet*) tdwallet_pkg_exists=1;;
         tpump*) tpump_pkg_exists=1;;
         ttupublickey*) ttupublickey_pkg_exists=1;;
         qrydir*) qrydir_pkg_exists=1;;        #DR109162
         jmsaxsmod*) jmsaxsmod_pkg_exists=1;;  #DR109162
         soredistlibs*) soredistlibs_pkg_exists=1;;
         ssredistlibs*) ssredistlibs_pkg_exists=1;;
         *) 
         : ;;
            #DR147885 Don't exit. If there's a directory setup doesn't
            #recognize, it exits. That's bad, and we don't want that.
            #exit $RC_FATALERROR;; 
      esac
      cd $cDir
   done
   #DR109162 Added to support the odd double directory for Opteron
   #Note: If changing Solaris Sparc to use the script, add DIR_SOLARIS_SPARC
   #DR145390 - Adding Linux (i386/s390x) and HPUX (parisc/ia64)
   #Need to change 2 directories instead of 1
   if [ "${DIRNAME}" = "$DIR_SOLARIS_OPTERON" ] || [ "${DIRNAME}" = "$DIR_SOLARIS_SPARC" ] ||
   [ "${DIRNAME}" = "$DIR_LINUX_RPMS" ] || [ "${DIRNAME}" = "$DIR_LINUX_s390x" ] ||
   [ "${DIRNAME}" = "$DIR_UBUNTU_DEBS" ]; then
     cd ../..
   else
     cd ..
   fi
}

##############################################################################
fill_package_sizes ()
{
  arc_size=0
  bteq_size=0
  bteq32_size=0
  cliv2_size=0
  cobpp_size=0
  fastexp_size=0
  fastld_size=0
  lfile_size=0
  mload_size=0
  mqaxsmod_size=0
  npaxsmod_size=0
  s3axsmod_size=0
  gcsaxsmod_size=0  
  azureaxsmod_size=0
  kafkaaxsmod_size=0
  piom_size=0
  sqlpp_size=0
  tptbase_size=0
  tdicu_size=0
  tdodbc32_size=0
  tdodbc_size=0
  tdwallet_size=0
  tpump_size=0
  ttupublickey_size=0
  qrydir_size=0
  jmsaxsmod_size=0
  soredistlibs_size=0
  ssredistlibs_size=0

  cd "$DIRNAME"
  cDir=$PWD
  for file in *
  do
    printf "."
    if [ "$DEBUG" ]; then echo "Debug fill_packages_sizes : $PWD $file "; fi

    if [ "$PLATFORM" != "$NAME_LINUX" ]; then
       cd $file      2>/dev/null
    elif [ -d $file ]; then
      cd $file
      file=`ls *.rpm 2>/dev/null`
    fi

    case "$file" in
       arc*) arc_size=`get_init_package_size $PWD $file`;; 
       bteq32*)bteq32_size=`get_init_package_size $PWD $file`;; 
       bteq*)bteq_size=`get_init_package_size $PWD $file`;; 
       cliv2*)cliv2_size=`get_init_package_size $PWD $file`;; 
       cobpp*)cobpp_size=`get_init_package_size $PWD $file`;; 
       fastexp*)fastexp_size=`get_init_package_size $PWD $file`;; 
       fastld*)fastld_size=`get_init_package_size $PWD $file`;; 
       lfile*)lfile_size=`get_init_package_size $PWD $file`;; 
       mload*)mload_size=`get_init_package_size $PWD $file`;; 
       mqaxsmod*)mqaxsmod_size=`get_init_package_size $PWD $file`;; 
       npaxsmod*)npaxsmod_size=`get_init_package_size $PWD $file`;; 
       s3axsmod*)s3axsmod_size=`get_init_package_size $PWD $file`;;
       gcsaxsmod*)gcsaxsmod_size=`get_init_package_size $PWD $file`;;	   
       azureaxsmod*)azureaxsmod_size=`get_init_package_size $PWD $file`;;
       kafkaaxsmod*)kafkaaxsmod_size=`get_init_package_size $PWD $file`;; 
       piom*)piom_size=`get_init_package_size $PWD $file`;; 
       sqlpp*)sqlpp_size=`get_init_package_size $PWD $file`;; 
       $TPTBASE*) tptbase_size=`get_init_package_size $PWD $file`;; 
       tdicu*) tdicu_size=`get_init_package_size $PWD $file`;; 
       tdodbc32*) tdodbc32_size=`get_init_package_size $PWD $file`;; 
       tdodbc*) tdodbc_size=`get_init_package_size $PWD $file`;; 
       tdwallet*)tdwallet_size=`get_init_package_size $PWD $file`;; 
       tpump*)tpump_size=`get_init_package_size $PWD $file`;; 
       ttupublickey*)ttupublickey_size=`get_init_package_size $PWD $file`;; 
       qrydir*) qrydir_size=`get_init_package_size $PWD $file`;; 
       jmsaxsmod*)jmsaxsmod_size=`get_init_package_size $PWD $file`;; 
       soredistlibs*)soredistlibs_size=`get_init_package_size $PWD $file`;;
       ssredistlibs*)ssredistlibs_size=`get_init_package_size $PWD $file`;;
       *) 
       : ;;
          #DR147885 Don't exit. If there's a directory setup doesn't
          #recognize, it exits. That's bad, and we don't want that.
          #exit $RC_FATALERROR;; 
     esac
     cd $cDir
   done
   #DR109162 Added to support the odd double directory for Opteron
   #Note: If changing Solaris Sparc to use the script, add DIR_SOLARIS_SPARC
   #DR145390 - Adding Linux (i386/s390x) and HPUX (parisc/ia64)
   #Need to change 2 directories instead of 1
   if [ "${DIRNAME}" = "$DIR_SOLARIS_OPTERON" ] || [ "${DIRNAME}" = "$DIR_SOLARIS_SPARC" ] ||
   [ "${DIRNAME}" = "$DIR_LINUX_RPMS" ] || [ "${DIRNAME}" = "$DIR_LINUX_s390x" ] ||
   [ "${DIRNAME}" = "$DIR_UBUNTU_DEBS" ]; then
     cd ../..
   else
     cd ..
   fi

   check_available_space "/opt"
}

##############################################################################
fill_version_numbers ()
{
   cd "$DIRNAME"
   cDir=$PWD
   for file in *
   do
      printf "."
      if [ "$DEBUG" ]; then echo "Debug fill_version_numbers : $PWD $file "; fi

         if [ "$PLATFORM" != "$NAME_LINUX" ]; then
            cd $file  2>/dev/null
         elif [ -d $file ]; then
           cd $file
           file=`ls *.rpm 2>/dev/null`
         fi

      case "$file" in
         arc*) arc_ver=`get_init_package_version $PWD $file`;; 
         bteq32*)bteq32_ver=`get_init_package_version $PWD $file`;; 
         bteq*)bteq_ver=`get_init_package_version $PWD $file`;;
         cliv2*)cliv2_ver=`get_init_package_version $PWD $file`;; 
         cobpp*)cobpp_ver=`get_init_package_version $PWD $file`;; 
         fastexp*)fastexp_ver=`get_init_package_version $PWD $file`;; 
         fastld*)fastld_ver=`get_init_package_version $PWD $file`;; 
         lfile*)lfile_ver=`get_init_package_version $PWD $file`;; 
         mload*)mload_ver=`get_init_package_version $PWD $file`;; 
         mqaxsmod*)mqaxsmod_ver=`get_init_package_version $PWD $file`;; 
         npaxsmod*)npaxsmod_ver=`get_init_package_version $PWD $file`;; 
         s3axsmod*)s3axsmod_ver=`get_init_package_version $PWD $file`;;
         gcsaxsmod*)gcsaxsmod_ver=`get_init_package_version $PWD $file`;;		 
         azureaxsmod*)azureaxsmod_ver=`get_init_package_version $PWD $file`;;
         kafkaaxsmod*)kafkaaxsmod_ver=`get_init_package_version $PWD $file`;; 
         piom*)piom_ver=`get_init_package_version $PWD $file`;; 
         sqlpp*)sqlpp_ver=`get_init_package_version $PWD $file`;; 
         $TPTBASE*) tptbase_ver=`get_init_package_version $PWD $file`;; 
         tdicu*) tdicu_ver=`get_init_package_version $PWD $file`;; 
         tdodbc32*)tdodbc32_ver=`get_init_package_version $PWD $file`;; 
         tdodbc*)tdodbc_ver=`get_init_package_version $PWD $file`;; 
         tdwallet*)tdwallet_ver=`get_init_package_version $PWD $file`;; 
         tpump*)tpump_ver=`get_init_package_version $PWD $file`;; 
         ttupublickey*)ttupublickey_ver=`get_init_package_version $PWD $file`;; 
         qrydir*) qrydir_ver=`get_init_package_version $PWD $file`;; 
         jmsaxsmod*)jmsaxsmod_ver=`get_init_package_version $PWD $file`;; 
         soredistlibs*)soredistlibs_ver=`get_init_package_version $PWD $file`;;
         ssredistlibs*)ssredistlibs_ver=`get_init_package_version $PWD $file`;;
         *) 
         : ;;
            #DR147885 Don't exit. If there's a directory setup doesn't
            #recognize, it exits. That's bad, and we don't want that.
            #exit $RC_FATALERROR;; 
      esac
      cd $cDir
   done
   #DR109162 Added to support the odd double directory for Opteron
   #Note: If changing Solaris Sparc to use the script, add DIR_SOLARIS_SPARC
   #DR145390 - Adding Linux (i386/s390x) and HPUX (parisc/ia64)
   #Need to change 2 directories instead of 1
   if [ "${DIRNAME}" = "$DIR_SOLARIS_OPTERON" ] || [ "${DIRNAME}" = "$DIR_SOLARIS_SPARC" ] ||
   [ "${DIRNAME}" = "$DIR_LINUX_RPMS" ] || [ "${DIRNAME}" = "$DIR_LINUX_s390x" ] ||
   [ "${DIRNAME}" = "$DIR_UBUNTU_DEBS" ]; then
     cd ../..
   else
     cd ..
   fi

}
##############################################################################
#
# Function: display_menu_item
#
# Description: Displays the installation menu items.
#
# Input: counter for item number, short package name, full package name
#
# Output: None
#
display_menu_item ()
{
  COUNTER="$1"
  PACKAGE="$2"
  FULLPACKAGE="$3"
  VERSION="$4"
  SIZE=$5

#  echo "display_menu_item - 1-$1 2=$2 3=$3 4=$4 5=$5"
  #Don't display the menu items when menu parameters are passed.
  if [ ! "$MENU_PARAMETERS" ]; then 
    printf "%2s. %-13s- %-12s - %-${formatName}s %6d KB\n" $COUNTER $PACKAGE $VERSION "$FULLPACKAGE" $SIZE
  fi
}

##############################################################################
#
# Function: setup_menu
#
# Description: Displays the installation menu.
#
# Input: None
#
# Output: None
#
setup_menu ()
{
   reset_pkg_nums
   counter=1

   if [ $arc_pkg_exists = 1 ]; then
      arc_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $bteq_pkg_exists = 1 ]; then
      bteq_num=$counter
      counter=`expr $counter + 1`
   fi
   
   if [ $bteq32_pkg_exists = 1 ]; then
      bteq32_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $cobpp_pkg_exists = 1 ]; then
      cobpp_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $fastexp_pkg_exists = 1 ]; then
      fastexp_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $fastld_pkg_exists = 1 ]; then
      fastld_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $jmsaxsmod_pkg_exists = 1 ]; then
      jmsaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $lfile_pkg_exists = 1 ]; then
      lfile_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $mload_pkg_exists = 1 ]; then
      mload_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $mqaxsmod_pkg_exists = 1 ]; then
      mqaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $npaxsmod_pkg_exists = 1 ]; then
      npaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $s3axsmod_pkg_exists = 1 ]; then
      s3axsmod_num=$counter
      counter=`expr $counter + 1`
   fi
   
   if [ $gcsaxsmod_pkg_exists = 1 ]; then
      gcsaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $azureaxsmod_pkg_exists = 1 ]; then
      azureaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $kafkaaxsmod_pkg_exists = 1 ]; then
      kafkaaxsmod_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $qrydir_pkg_exists = 1 ]; then
      qrydir_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $sqlpp_pkg_exists = 1 ]; then
      sqlpp_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $tdodbc32_pkg_exists = 1 ]; then
      odbc32_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $tdodbc_pkg_exists = 1 ]; then
      odbc_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $tdwallet_pkg_exists = 1 ]; then
      tdwallet_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $tptbase_pkg_exists = 1 ]; then
      tptbase_num=$counter
      tptbase_pkg_name=tptbase
      counter=`expr $counter + 1`
   fi

   if [ $tpump_pkg_exists = 1 ]; then
      tpump_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $ttupublickey_pkg_exists = 1 ]; then
      ttupublickey_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $tdicu_pkg_exists = 1 ]; then
      tdicu_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $cliv2_pkg_exists = 1 ]; then
      cliv2_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $piom_pkg_exists = 1 ]; then
      piom_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $soredistlibs_pkg_exists = 1 ]; then
      soredistlibs_num=$counter
      counter=`expr $counter + 1`
   fi

   if [ $ssredistlibs_pkg_exists = 1 ]; then
      ssredistlibs_num=$counter
      counter=`expr $counter + 1`
   fi

   #Since we have cycled through the menu, we know how many packages there are.
   TOTALPACKAGES=`expr $counter - 1`
   TOTALDEPENDENCIES=`expr $ttupublickey_size + $tdicu_size + $cliv2_size + $piom_size + $soredistlibs_size + $ssredistlibs_size`
   TOTAL=`expr $ttupublickey_size + $arc_size + $bteq_size + $bteq32_size + $cliv2_size + $cobpp_size + $fastexp_size + $fastld_size + $lfile_size + $mload_size + $mqaxsmod_size + $npaxsmod_size + $s3axsmod_size + $gcsaxsmod_size + $azureaxsmod_size + $kafkaaxsmod_size + $piom_size + $sqlpp_size + $tptbase_size + $tdicu_size + $tdodbc_size + $tdodbc32_size + $tdwallet_size + $tpump_size + $qrydir_size + $jmsaxsmod_size + $soredistlibs_size + $ssredistlibs_size`
   
   #Now that we know the menu numbers of the packages, add those numbers
   #to the MENU_PARAMETERS so that they will install if passed from the
   #command line.  <product>_num will only be set if that product exists on
   #the media. This way MENU_PARAMETERS will have all the products, and
   #products can be added by name on the command line.
   #
   for INPUT_PKG_NAME in $MENU_TEXT
   do
     case $INPUT_PKG_NAME in
       arc)
          if [ "$arc_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $arc_num"
          fi ;;
       bteq)
          if [ "$bteq_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $bteq_num"
          fi
          if [ "$DEBUG" ]; then echo "setup_menu - bteq_num is $bteq_num"; fi
          if [ "$DEBUG" ]; then echo "setup_menu - MENU_PARAMETERS is $MENU_PARAMETERS"; fi
          ;;
       bteq32)
          if [ "$bteq32_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $bteq32_num"
          fi
          if [ "$DEBUG" ]; then echo "setup_menu - bteq32_num is $bteq32_num"; fi
          if [ "$DEBUG" ]; then echo "setup_menu - MENU_PARAMETERS is $MENU_PARAMETERS"; fi
          ;;
       cobpp)
          if [ "$cobpp_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $cobpp_num"
          fi ;;
       fastexp)
          if [ "$fastexp_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $fastexp_num"
          fi ;;
       fastld )
          if [ "$fastld_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $fastld_num"
          fi ;;
       jmsaxsmod)
          if [ "$jmsaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $jmsaxsmod_num"
          fi ;;
       lfile)
          if [ "$lfile_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $lfile_num"
          fi ;;
       mload )
          if [ "$mload_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $mload_num"
          fi ;;
       mqaxsmod)
          if [ "$mqaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $mqaxsmod_num"
          fi ;;
       npaxsmod)
          if [ "$npaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $npaxsmod_num"
          fi ;;
       s3axsmod)
          if [ "$s3axsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $s3axsmod_num"
          fi ;;
       gcsaxsmod)
          if [ "$gcsaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $gcsaxsmod_num"
          fi ;;		  
       azureaxsmod)
          if [ "$azureaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $azureaxsmod_num"
          fi ;;
       kafkaaxsmod)
          if [ "$kafkaaxsmod_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $kafkaaxsmod_num"
          fi ;;
       sqlpp)
          if [ "$sqlpp_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $sqlpp_num"
          fi ;;
       odbc32)
          if [ "$odbc32_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $odbc32_num"
          fi ;;
       odbc)
          if [ "$odbc_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $odbc_num"
          fi ;;
       qrydir)
          if [ "$qrydir_num" != 0 ]; then
            MENU_PARAMETERS="$MENU_PARAMETERS $qrydir_num"
          fi ;;
       tdwallet)
          if [ "$tdwallet_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $tdwallet_num"
          fi ;;
       tptbase)
          if [ "$tptbase_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $tptbase_num"
          fi ;;
       tpump)
          if [ "$tpump_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $tpump_num"
          fi ;;
       ttupublickey)
          if [ "$ttupublickey_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $ttupublickey_num"
          fi ;;
       tdicu)
          if [ "$tdicu_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $tdicu_num"
          fi ;;
       cliv2)
          if [ "$cliv2_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $cliv2_num"
          fi ;;
       piom)
          if [ "$piom_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $piom_num"
          fi ;;
       soredistlibs)
          if [ "$soredistlibs_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $soredistlibs_num"
          fi ;;
       ssredistlibs)
          if [ "$ssredistlibs_num" != 0 ]; then
         MENU_PARAMETERS="$MENU_PARAMETERS $ssredistlibs_num"
          fi ;;
     esac
   done

}
 
##############################################################################
#
# Function: display_menu
#
# Description: Displays the installation menu.
#
# Input: None
#
# Output: None
#
display_menu ()
{
   echo

   if [ "$ISBETA" ]; then
     echo "       +-----------------------------------------------------------------+"
     echo "       | This version of Teradata Tools and Utilities is a BETA version. |"
     echo "       +-----------------------------------------------------------------+"
   fi

   PKG_LIST="arc_pkg_exists bteq_pkg_exists bteq32_pkg_exists cobpp_pkg_exists fastexp_pkg_exists fastld_pkg_exists jmsaxsmod_pkg_exists lfile_pkg_exists mload_pkg_exists mqaxsmod_pkg_exists"
   PKG_LIST="$PKG_LIST npaxsmod_pkg_exists s3axsmod_pkg_exists gcsaxsmod_pkg_exists azureaxsmod_pkg_exists kafkaaxsmod_pkg_exists qrydir_pkg_exists sqlpp_pkg_exists tdodbc_pkg_exists tdodbc32_pkg_exists"
   PKG_LIST="$PKG_LIST tptbase_pkg_exists tpump_pkg_exists"

   DEPENDS_LIST="ttupublickey_pkg_exists tdicu_pkg_exists cliv2_pkg_exists piom_pkg_exists soredistlibs_pkg_exists ssredistlibs_pkg_exists"

   DEPENDS_ONLY=0
   PKGS_WITH_WALLET=0

   if [ $tdwallet_pkg_exists = 1 ]; then
        PKGS_WITH_WALLET=1
   fi

   if [ $PKGS_WITH_WALLET = 0 ]; then
       for pkg in $DEPENDS_LIST
       do
           if [ $(($pkg)) = 1 ]; then
               DEPENDS_ONLY=1
               break
           fi
       done
   fi

   formatName=39
   if [ "$checkFormat" = "1" ] && [ $gcsaxsmod_pkg_exists = 1 ]; then
      formatName=48
   fi

   if [ $arc_pkg_exists = 1 ]; then
      display_menu_item $arc_num arc "Teradata ARC Utility" $arc_ver $arc_size
   fi

   if [ $bteq_pkg_exists = 1 ]; then
      display_menu_item $bteq_num bteq "Teradata BTEQ Application" $bteq_ver $bteq_size
   fi

   if [ $bteq32_pkg_exists = 1 ]; then
      display_menu_item $bteq32_num bteq32 "Teradata BTEQ 32-bit Application" $bteq32_ver $bteq32_size
   fi

   if [ $cobpp_pkg_exists = 1 ]; then
      display_menu_item $cobpp_num cobpp "Teradata Cobol Preprocessor" $cobpp_ver $cobpp_size
   fi

   if [ $fastexp_pkg_exists = 1 ]; then
      display_menu_item $fastexp_num fastexp "Teradata FastExport Utility" $fastexp_ver $fastexp_size
   fi

   if [ $fastld_pkg_exists = 1 ]; then
      display_menu_item $fastld_num fastld "Teradata FastLoad Utility" $fastld_ver $fastld_size
   fi

   if [ $jmsaxsmod_pkg_exists = 1 ]; then
      display_menu_item $jmsaxsmod_num jmsaxsmod "Teradata JMS Access Module" $jmsaxsmod_ver $jmsaxsmod_size
   fi

   if [ $lfile_pkg_exists = 1 ]; then
      display_menu_item $lfile_num lfile "Teradata Large File Access Module" $lfile_ver $lfile_size
   fi

   if [ $mload_pkg_exists = 1 ]; then
      display_menu_item $mload_num mload "Teradata MultiLoad Utility" $mload_ver $mload_size
   fi

   if [ $mqaxsmod_pkg_exists = 1 ]; then
      display_menu_item $mqaxsmod_num mqaxsmod "WebSphere(r) Access Module for Teradata" $mqaxsmod_ver $mqaxsmod_size
   fi

   if [ $npaxsmod_pkg_exists = 1 ]; then
      display_menu_item $npaxsmod_num npaxsmod "Teradata Named Pipes Access Module" $npaxsmod_ver $npaxsmod_size
   fi

   if [ $s3axsmod_pkg_exists = 1 ]; then
      display_menu_item $s3axsmod_num s3axsmod "Teradata Access Module for S3" $s3axsmod_ver $s3axsmod_size
   fi

   if [ $gcsaxsmod_pkg_exists = 1 ]; then
      display_menu_item $gcsaxsmod_num gcsaxsmod "Teradata Access Module for Google Cloud Storage" $gcsaxsmod_ver $gcsaxsmod_size
   fi

   if [ $azureaxsmod_pkg_exists = 1 ]; then
      display_menu_item $azureaxsmod_num azureaxsmod "Teradata Access Module for Azure" $azureaxsmod_ver $azureaxsmod_size
   fi

   if [ $kafkaaxsmod_pkg_exists = 1 ]; then
      display_menu_item $kafkaaxsmod_num kafkaaxsmod "Teradata Kafka Access Module" $kafkaaxsmod_ver $kafkaaxsmod_size
   fi

   if [ $qrydir_pkg_exists = 1 ]; then
      display_menu_item $qrydir_num qrydir "$QRYDIR_NAME" $qrydir_ver $qrydir_size
   fi

   if [ $sqlpp_pkg_exists = 1 ]; then
      display_menu_item $sqlpp_num sqlpp "Teradata C Preprocessor" $sqlpp_ver $sqlpp_size
   fi

   if [ $tdodbc32_pkg_exists = 1 ]; then
      display_menu_item $odbc32_num tdodbc32 "Teradata ODBC 32-bit Driver" $tdodbc32_ver $tdodbc32_size
   fi

   if [ $tdodbc_pkg_exists = 1 ]; then
      display_menu_item $odbc_num tdodbc "Teradata ODBC Driver" $tdodbc_ver $tdodbc_size
   fi

   if [ $tdwallet_pkg_exists = 1 ]; then
      display_menu_item $tdwallet_num tdwallet "Teradata Wallet Utility" $tdwallet_ver $tdwallet_size
   fi

   if [ $tptbase_pkg_exists = 1 ]; then
      display_menu_item $tptbase_num tptbase "$TPT_BASE_NAME" $tptbase_ver $tptbase_size
   fi

   if [ $tpump_pkg_exists = 1 ]; then
      display_menu_item $tpump_num tpump "Teradata TPump Utility" $tpump_ver $tpump_size
   fi

   if [ $tdicu_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $tdicu_num tdicu "Teradata Shared Component for I18N" $tdicu_ver $tdicu_size
      fi
   fi

   if [ $cliv2_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $cliv2_num cliv2 "Teradata CLIv2" $cliv2_ver $cliv2_size
      fi
   fi

   if [ $piom_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $piom_num piom "Teradata Data Connector API" $piom_ver $piom_size
      fi
   fi
   
   if [ $ttupublickey_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $ttupublickey_num ttupublickey "Teradata TTU Public Key" $ttupublickey_ver $ttupublickey_size
      fi
   fi

   if [ $soredistlibs_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $soredistlibs_num soredistlibs "Solaris Redistributable Libraries for Teradata" $soredistlibs_ver $soredistlibs_size
      fi
   fi

   if [ $ssredistlibs_pkg_exists = 1 ]; then
      if [ "$DEPENDS" = 1 ] || [ $DEPENDS_ONLY = 1 ]; then
        display_menu_item $ssredistlibs_num ssredistlibs "Solaris Redistributable Libraries for Teradata" $ssredistlibs_ver $ssredistlibs_size
      fi
   fi

   if [ "$MENU_PARAMETERS" ]; then 
     choice="$MENU_PARAMETERS"
   else
     #Use this line if we want to display the total of the installed packages
     if [ "$DEBUG" ]; then 
       printf "%67s :%7d KB\n" "Total Size" $INSTALLED_SIZE
     fi
     
     outformatName=69
     if [ "$checkFormat" = "1" ] && [ $gcsaxsmod_pkg_exists = 1 ]; then
        outformatName=78
     fi
     echo
     if [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ]; then
         printf "%71s :%7d KB\n" "Total Dependency Packages Size (tdicu, cliv2, piom, ssredistlibs)" $TOTALDEPENDENCIES
         printf "%71s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
     elif [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ]; then
         printf "%71s :%7d KB\n" "Total Dependency Packages Size (tdicu, cliv2, piom, soredistlibs)" $TOTALDEPENDENCIES
         printf "%71s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
     elif [ "$PLATFORM" = "$NAME_LINUX" ]; then
        if [ "$BITNESS" = "32-bit Bundle" ]; then
           printf "%71s :%7d KB\n" "Total Dependency Packages Size (ttupublickey, tdicu, cliv2)" $TOTALDEPENDENCIES
           printf "%71s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
        else
           printf "%80s :%7d KB\n" "Total Dependency Packages Size (ttupublickey, tdicu, cliv2, piom)" $TOTALDEPENDENCIES
           printf "%80s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
        fi
     elif [ "$PLATFORM" = "$NAME_AIX" ]; then
         printf "%71s :%7d KB\n" "Total Dependency Packages Size (tdicu, cliv2, piom)" $TOTALDEPENDENCIES
         printf "%71s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
     elif [ "$PLATFORM" = "$NAME_UBUNTU" ]; then
        if [ "$BITNESS" = "32-bit Bundle" ]; then
           printf "%71s :%7d KB\n" "Total Dependency Packages Size (tdicu, cliv2)" $TOTALDEPENDENCIES
           printf "%71s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
        else
           printf "%80s :%7d KB\n" "Total Dependency Packages Size (tdicu, cliv2, piom)" $TOTALDEPENDENCIES
           printf "%80s :%7d KB\n" "Packages Size (Grand Total)" $TOTAL
        fi
     fi
     echo

     echo "a. Install all of the above software"

     echo "q. Quit the installation"
     echo

     printf "$INFOENTS"
     read choice
   fi

   process_choice
}

##############################################################################
#
# Function: display_msg
#
# Description: Displays a message text.
#              Exits when the return code is greater than 4 (RC_WARNING).
#
# Input: message text to be displayed
#        return code
#
# Output: None
#
# Note: None
#
display_msg ()
{
   echo "$1"
   if [ "$2" -gt "$RC_HIGHEST" ]; then
      RC_HIGHEST=$2
   fi
   if [ "$RC_HIGHEST" -gt "$RC_WARNING" ]; then
      exit $RC_HIGHEST
   fi
}

##############################################################################
#
# Function: display_logo  DR94132
#
# Description: Displays the Teradata logo.
#
# Input: None
#
# Output: None
#
# Note: None
#
display_logo ()
{
  echo "                                                                             "
  echo "                                                  ddd"
  echo " t:t                                              d:d            t:t"
  echo " t:t                                              d:d            t:t"
  echo " t:ttttt      eeeeee   rrr  rrrr  aaaaaaa     dddd::d   aaaaaaa  t:ttttt      aaaaaaa"
  echo " t:t         e:e  e:e  r:::::::r     a:::a  d:::ddd:d      a:::a t:t             a:::a"
  echo " t:t        e:::eee::e r:r       aaaaaaa:a d:d    d:d  aaaaaaa:a t:t         aaaaaaa:a"
  echo " t:t   ttt  e:e        r:r      a:a    a:a d:d    d:d a:a    a:a t:t   ttt  a:a    a:a  **"
  echo " tt:::::::t e:::::eee  r:r      a::aaaa::a d::dddd::d a::aaaa::a tt:::::::t a::aaaa::a ****"
  echo "   tttttt     eeeeeeee rrr       aaaa  aaa  dddd  ddd  aaaa  aaa   tttttt    aaaa  aaa  **"
  echo ""
}

##############################################################################
#
# Function: display_welcome
#
# Description: Displays the welcome information.
#
# Input: None
#
# Output: None
#
# Note: None
#
display_welcome ()
{
  display_msg "$INFOWELC    v.$SCRIPTVER" $RC_OKAY
  display_msg "$INFOCPYR" $RC_OKAY
}

##############################################################################
#
# Function: execute_on_AIX
#
# Description: Executes the installation on AIX platform.
#
# Input: None
#
# Output: None
#
# Note: This applies only to the AIX platform.
#
execute_on_AIX ()
{
  #Change the following to VERNUM if using directories with the version
  #such as "bteq1400"
  DIREXT=""

  #AIX_PARAMS="-acFX -R $BASEDIR -d"
  AIX_PARAMS="-acFX -R $BASEDIR -d"

  # DR 67864 - Add tdicu.
  if [ $install_tdicu -eq 1 ]; then
    install_function "TDICU,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_tdicu${DIREXT} tdicu${VERNUM}"
  fi

  if [ $install_tdodbc -eq 1 ]; then
#DR116663 - TDODBC has a single package for 32-bit and 64-bit 
    install_function "TDODBC,AIX PowerPC 32bit/64bit" "$AIX_PARAMS" "$PWD/$DIR_AIX_tdodbc${DIREXT} tdodbc${VERNUM}"
  fi

  if [ $install_cliv2 -eq 1 ]; then
    install_function "Cliv2,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_cliv2${DIREXT} cliv2${VERNUM}"
  fi

  if [ $install_piom -eq 1 ]; then
    install_function "PIOM,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_piom${DIREXT} piom${VERNUM}"
  fi

  if [ $install_lfile -eq 1 ]; then
    install_function "Large Files,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_lfile${DIREXT} lfile"
  fi

  if [ $install_npaxsmod -eq 1 ]; then
    install_function "NPAXSMOD,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_npaxsmod${DIREXT} npaxsmod${VERNUM}"
  fi

  # DR 64258 - Added WebSphere(r) Access Module for Teradata
  # DR101866 - Remove 64-bit MQAXSMOD
  if [ $install_mqaxsmod -eq 1 ]; then
      install_function "MQAXSMOD,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_mqaxsmod${DIREXT} mqaxsmod${VERNUM}"
  fi

  if [ $install_arc -eq 1 ]; then
    install_function "Arc,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_arc${DIREXT} arc"
  fi

  if [ $install_cobpp -eq 1 ]; then
    install_function "Cobol PreProcessor,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_cobpp${DIREXT} cobpp${VERNUM}"
  fi

  if [ $install_sqlpp -eq 1 ]; then
    install_function "SQL PreProcessor,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_sqlpp${DIREXT} sqlpp${VERNUM}"
  fi

  if [ $install_bteq -eq 1 ]; then
    install_function "BTEQ,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_bteq${DIREXT} bteq${VERNUM}"
  fi

  if [ $install_fastexp -eq 1 ]; then
    install_function "FastExport,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_fastexp${DIREXT} fastexp${VERNUM}"
  fi

  if [ $install_fastld -eq 1 ]; then
    install_function "FastLoad,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_fastld${DIREXT} fastld${VERNUM}"
  fi

  if [ $install_mload -eq 1 ]; then
    install_function "MultiLoad,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_mload${DIREXT} mload${VERNUM}"
  fi

  if [ $install_tdwallet -eq 1 ]; then
    install_function "TDWallet,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_tdwallet${DIREXT} tdwallet${VERNUM}"
  fi

  if [ $install_tpump -eq 1 ]; then
    install_function "TPump,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_tpump${DIREXT} tpump${VERNUM}"
  fi

  if [ $install_tptbase -eq 1 ]; then          # DR95397 TPT pkg_name
    install_function "TPTBASE,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_tptbase${DIREXT} tptbase${VERNUM}"
  fi


  #DR109162
  if [ $install_jmsaxsmod -eq 1 ]; then
    install_function "JMSAXSMOD,AIX PowerPC" "$AIX_PARAMS" "$PWD/$DIR_AIX_jmsaxsmod${DIREXT} jmsaxsmod${VERNUM}"
  fi

}

##############################################################################
#
# Function: execute_on_LINUX               new for DR 51932
#
# Description: Executes the installation on Linux platform.
#
# Input: None
#
# Output: None
#
# Note: This applies only to the Linux platform.
#
# DR51932   CSG  12/03/02  Install only 64bit pkgs on 64bit Linux
execute_on_LINUX ()
{
  # DR 67864 - Create the RPM_INSTALL_OPTIONS variable.
  # Option -U means to upgrade.
  # Option -v means to print verbose information.
  # Option -h means to print 50 hash marks as the package archive is unpacked.
  # Option --force is the same as using --replacepkgs, --replacefiles, and
  # --oldpackage.
  # Option --replacepkgs means to install the package even if some of them are
  # already installed on the system.
  # Option --oldpackage means to allow an upgrade to replace a newer package
  # with an older one.
  # Option --replacefiles means to install the package even if they replace
  # files from other, already installed, packages.
  # DR 91147 - Set upgrade and new install options.
  # DR116663 - Add "--nodeps" to Upgrade Options so that Linux will upgrade
  #            tdicu and other libraries correctly from previous versions.
  #            Remove extra "--nodeps" from all uses of the variable
  #            RPM_UPGRADE_INSTALL_OPTIONS (added after the variable used).
  #CLNTINS-4665 - The flags --nodeps and --force were removed as part of the
  #   User Selectable changes.

  if [ "$TEST" = "yes" ]; then
    RPM_UPGRADE_INSTALL_OPTIONS="-Uvh --prefix $BASEDIR"
  else
    RPM_UPGRADE_INSTALL_OPTIONS="-Uvh --prefix $BASEDIR --replacepkgs --replacefiles"
  fi
  
  RPM_INSTALL_OPTIONS="$RPM_UPGRADE_INSTALL_OPTIONS"

  # DR 67864 - Add TeraGSS.
  # DR 91147 - For TeraGSS, must use the "-ivh --replacepkgs" RPM install
  #            options.
  # DR 93422 - Install 64-bit libaries only if the file exists on the CD-ROM/PATH
  # DR 145390 - Two separate directories for Linux, s390x and i386-x8664


  signing_dir="./${DIRNAME}/signing"
  if [ -f "${signing_dir}/importkey.sh" ]; then
    ${signing_dir}/importkey.sh $signing_dir
  else
    echo "${signing_dir}/importkey.sh was not found."
  fi

  if [ $install_ttupublickey -eq 1 ]; then
  install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/signing/ttupublickey*.rpm"
  RC_TTUPUBKEY=$RETURN_CODE
   if [ $RC_TTUPUBKEY -ne 0 ]; then
     isinstalled=`rpm -qa | grep ttupublickey`
     if [ -n "$isinstalled" ]; then
        tmpver=`rpm -q "$isinstalled" --queryformat "%{VERSION}\n"`
        if [ "$?" = "0" ]; then
           v1=`echo $tmpver | cut -d '.' -f 1 | cut -c1-2`
           v2=`echo $tmpver | cut -d '.' -f 2 | cut -c1-2`
           tmpshortver=${v1}${v2}
           if [ $tmpshortver -gt $VERNUM ]; then
              RC_TTUPUBKEY=0
           else
               echo
               echo "**** Skipping installation of ttupublickey dependent packages."
            fi
         fi
     fi
   fi
  fi

  if [ $RC_TTUPUBKEY -eq 0 ]; then
    if [ $install_tdicu -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tdicu*.rpm"
      RC_TDICU=$RETURN_CODE
      if [ "$RC_TDICU" != "0" ] && [ "$RC_TDICU" != "-" ]; then
        echo
        echo "**** Skipping installation of tdicu dependent packages."
      fi
    fi

    if [ $install_piom -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/piom*.rpm"
      RC_PIOM=$RETURN_CODE
      if [ $RC_PIOM -ne 0 ]; then
        echo
        echo "**** Skipping installation of piom dependent packages."
      fi
    fi

    if [ $install_tdwallet -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tdwallet*.rpm"
    fi
  fi

  if [ "$RC_TDICU" = "0" ] || [ "$RC_TDICU" = "-" ]; then
    if [ $install_cliv2 -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/cliv2*.rpm"
      RC_CLIV2=$RETURN_CODE
      if [ $RC_CLIV2 -ne 0 ]; then
        echo
        echo "**** Skipping installation of cliv2 dependent packages."
      fi
    fi
  fi

  if ( [ "$RC_TDICU" = "0" ] || [ "$RC_TDICU" = "-" ] ) && [ $RC_CLIV2 -eq 0 ]; then
    # DR 67864 - Add sqlpp.
    if [ $install_sqlpp -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/sqlpp*.rpm"
    fi
 
    if [ $install_tptbase -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tptbase*.rpm"
    fi
  fi

  if [ $RC_PIOM -eq 0 ] && [ $RC_CLIV2 -eq 0 ]; then
    # DR 67864 - Install fastexp on 32-bit Linux platform.
    if [ $install_fastexp -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/fastexp*.rpm"
    fi

    # DR 67864 - Install fastld on 32-bit Linux platform.
    if [ $install_fastld -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/fastld*.rpm"
    fi

    # DR 67864 - Install mload on 32-bit Linux platform.
    if [ $install_mload -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/mload*.rpm"
    fi
  fi

  if ( [ "$RC_TDICU" = "0" ] || [ "$RC_TDICU" = "-" ] ) && [ $RC_PIOM -eq 0 ] && [ $RC_CLIV2 -eq 0 ]; then
    if [ $install_bteq -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/bteq*.rpm"
    fi

    if [ $install_tpump -eq 1 ]; then
      install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tpump*.rpm"
    fi
  fi

  if [ $install_tdodbc -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tdodbc*.rpm"
  fi

  if [ $install_tdodbc32 -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/tdodbc*.rpm"
  fi

  if [ $install_mqaxsmod -eq 1 ]; then
    RPM_INSTALL_OPTIONS="$RPM_INSTALL_OPTIONS --nodeps"
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/mqaxsmod*.rpm"
    RPM_INSTALL_OPTIONS="$RPM_UPGRADE_INSTALL_OPTIONS"
  fi

  if [ $install_npaxsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/npaxsmod*.rpm"
  fi

  if [ $install_s3axsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/s3axsmod*.rpm"
  fi

  if [ $install_gcsaxsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/gcsaxsmod*.rpm"
  fi

  # Install azureaxsmod on 64-bit Linux platform.
  if [ $install_azureaxsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/azureaxsmod*.rpm"
  fi

  # Install kafkaaxsmod on 64-bit Linux platform.
  if [ $install_kafkaaxsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/kafkaaxsmod*.rpm"
  fi

  if [ $install_jmsaxsmod -eq 1 ]; then
    install_function "dummy" "$RPM_INSTALL_OPTIONS" "$PWD/$DIRNAME/jmsaxsmod*.rpm"
  fi

}

##############################################################################
#
# Function: execute_on_UBUNTU
#
# Description: Executes the installation on Ubuntu platform.
#
# Input: None
#
# Output: None
#
# Note: This applies only to the Ubuntu platform.
#
# CLNTINS-7854   SG255032  04/26/17  Add support for Ubuntu OS
execute_on_UBUNTU ()
{
  # Option -i means to install.

  DEB_INSTALL_OPTIONS="-i"

  if [ $install_tdicu -eq 1 ]; then
    install_function "TDICU,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_tdicu/tdicu*.deb"
  fi

  if [ $install_tdodbc -eq 1 ]; then
   install_function "TDODBC,amd64" "$DEB_INSTALL_OPTIONS" \
     "$PWD/$DIR_UBUNTU_tdodbc/tdodbc*.deb"
  fi

  if [ $install_tdodbc32 -eq 1 ]; then
   install_function "TDODBC,i386" "$DEB_INSTALL_OPTIONS" \
     "$PWD/$DIR_UBUNTU_tdodbc32/tdodbc*.deb"
  fi
  if [ $install_cliv2 -eq 1 ]; then
    install_function "CLIv2,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_cliv2/cliv2*.deb"
  fi

  if [ $install_piom -eq 1 ]; then
    install_function "PIOM,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_piom/piom*.deb"
  fi

  if [ $install_mqaxsmod -eq 1 ]; then
    install_function "MQAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_mqaxsmod/mqaxsmod*.deb"
  fi

  if [ $install_npaxsmod -eq 1 ]; then
    install_function "NPAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_npaxsmod/npaxsmod*.deb"
  fi

  if [ $install_s3axsmod -eq 1 ]; then
    install_function "S3AXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_s3axsmod/s3axsmod*.deb"
  fi

  if [ $install_gcsaxsmod -eq 1 ]; then
    install_function "GCSAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_gcsaxsmod/gcsaxsmod*.deb"
  fi

  if [ $install_azureaxsmod -eq 1 ]; then
    install_function "AZUREAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_azureaxsmod/azureaxsmod*.deb"
  fi

  if [ $install_kafkaaxsmod -eq 1 ]; then
    install_function "KAFKAAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_kafkaaxsmod/kafkaaxsmod*.deb"
  fi

  if [ $install_bteq -eq 1 ]; then
    install_function "BTEQ,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_bteq/bteq*.deb"
  fi

  if [ $install_bteq32 -eq 1 ]; then
      # Check if bteq1620-16.20.00.XX where XX is 00 through 06
      obsoleted_bteq_pkg=""
      obsoleted_bteq_pkg=`dpkg -l | grep bteq1620 | egrep "16.20.00.(00|01|02|03|04|05|06)"`
      if [ ! -z "$obsoleted_bteq_pkg" ]; then
        obsoleted_bteq_pkg_ver=`echo $obsoleted_bteq_pkg | awk '{print $3}'`
        echo
        echo Uninstalling Obsoleted Package - bteq1620-$obsoleted_bteq_pkg_ver
        dpkg -P --force-all bteq1620
      fi

      install_function "BTEQ,i386" "$DEB_INSTALL_OPTIONS" \
        "$PWD/$DIR_UBUNTU_bteq32/bteq*.deb"
  fi 

  if [ $install_fastexp -eq 1 ]; then
    install_function "FastExport,all" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_fastexp/fastexp*.deb"
  fi

  if [ $install_fastld -eq 1 ]; then
    install_function "FastLoad,all" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_fastld/fastld*.deb"
  fi

  if [ $install_mload -eq 1 ]; then
    install_function "MultiLoad,all" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_mload/mload*.deb"
  fi


  if [ $install_sqlpp -eq 1 ]; then
    install_function "SQLPP,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_sqlpp/sqlpp*.deb"
  fi

  if [ $install_tdwallet -eq 1 ]; then
    install_function "TDWallet,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_tdwallet/tdwallet*.deb"
  fi

  if [ $install_tpump -eq 1 ]; then
    install_function "TPump,all" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_tpump/tpump*.deb"
  fi

  if [ $install_tptbase -eq 1 ]; then
    install_function "TPTBASE,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/$DIR_UBUNTU_tptbase/tptbase*.deb"
  fi

  if [ $install_jmsaxsmod -eq 1 ]; then
    install_function "JMSAXSMOD,amd64" "$DEB_INSTALL_OPTIONS" \
      "$PWD/"$DIR_UBUNTU_jmsaxsmod"/jmsaxsmod*.deb"
  fi

}

###############################################################################
# Function: execute_on_Solaris                         new for DR101866
#
# Description: Executes the installation on Solaris platform.
#
# Input: None
#
# Output: None
#
# Note: This applies only to the Solaris Opteron platform.
###############################################################################
execute_on_Solaris ()
{
  #Create the Solaris Response files
  #Get the install directory from an installed package, user, parameter, or cfg file.
  get_install_dir 
  create_solaris_response
  #DR116663 - Create the admin file for Solaris Opteron so upgrades will work.
  make_temp_adminfile
  #Add the command for Solaris to use the admin file.
  INSTALL_PARAMETERS="-a $TMP_ADMIN_FILE -d"
   

##########################################################

  if [ $install_soredistlibs -eq 1 ]; then
    install_function "SOREDISTLIBS,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME soredistlibs${VERNUM}"
  fi

  if [ $install_ssredistlibs -eq 1 ]; then
    install_function "SSREDISTLIBS,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME ssredistlibs${VERNUM}"
  fi

  #Install tdicu on Solaris/Opteron platform.
  if [ $install_tdicu -eq 1 ]; then
    install_function "TDICU,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME tdicu${VERNUM}"
  fi

  #Install tdodbc on Solaris/Opteron platform.
  if [ $install_tdodbc -eq 1 ]; then
    install_function "TDODBC,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME tdodbc${VERNUM}"
  fi

  #Install Cliv2 on Solaris/Opteron platform.
  if [ $install_cliv2 -eq 1 ]; then
    install_function "CLIv2,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME cliv2${VERNUM}"
  fi

  #Install piom on Solaris/Opteron platform.
  if [ $install_piom -eq 1 ]; then
    install_function "PIOM,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME piom${VERNUM}"
  fi

  #Install mqaxsmod on Solaris/Opteron platform.
  if [ $install_mqaxsmod -eq 1 ]; then
    install_function "MQAXSMOD,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME mqaxsmod${VERNUM}"
  fi

  #Install npaxsmod on Solaris/Opteron platform.
  if [ $install_npaxsmod -eq 1 ]; then
    install_function "NPAXSMOD,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME npaxsmod${VERNUM}"
  fi

  #Install bteq on Solaris/Opteron platform.
  if [ $install_bteq -eq 1 ]; then
    install_function "BTEQ,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME bteq${VERNUM}"
  fi

  #Install fastexp on Solaris/Opteron platform.
  if [ $install_fastexp -eq 1 ]; then
    install_function "FastExport,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME fastexp${VERNUM}"
  fi

  #Install fastld on Solaris/Opteron platform.
  if [ $install_fastld -eq 1 ]; then
    install_function "FastLoad,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME fastld${VERNUM}"
  fi

  # - Install ARC on Solaris/Opteron platform.
  if [ $install_arc -eq 1 ]; then
    install_function "ARC,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME arc"
  fi

  # Install mload on Solaris/Opteron platform.
  if [ $install_mload -eq 1 ]; then
    install_function "MultiLoad,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME mload${VERNUM}"
  fi

  # Add sqlpp.
  if [ $install_sqlpp -eq 1 ]; then
    install_function "SQLPP,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME sqlpp${VERNUM}"
  fi

  # Install tdwallet on 64-bit Solaris/Opteron platform.
  if [ $install_tdwallet -eq 1 ]; then
    install_function "TDWallet,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME tdwallet${VERNUM}"
  fi

  # Install tpump on 64-bit Solaris/Opteron platform.
  if [ $install_tpump -eq 1 ]; then
    install_function "TPump,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME tpump${VERNUM}"
  fi

  # Install jmsaxsmod on 64-bit Solaris/Opteron platform.
  if [ $install_jmsaxsmod -eq 1 ]; then
    install_function "JMSAXSMOD,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME jmsaxsmod${VERNUM}"
  fi


###########################################################################
# Install tptbase on 64-bit Solaris/Opteron platform.
  if [ $install_tptbase -eq 1 ]; then
    install_function "TPTBASE,$PLATFORM $BIT_PLATFORM" "$INSTALL_PARAMETERS" "$DIRNAME tptbase${VERNUM}"
  fi

  #DR116663 - Remove the admin file in TMP_ADMIN_FILE
  rm $TMP_ADMIN_FILE
}

##############################################################################
#
# Function: is_installed
#
# Description: Checks if a package is installed.
#
# Input: package name
#
# Output: 0 (zero) - if the package is installed.
#         1 - if the package is not installed.
#
# Note: None
#
is_installed ()
{
  if [ "$PLATFORM" = "$NAME_AIX" ]; then
    if (lslpp_r -lq | grep $1 > /dev/null 2>&1); then
      return 0
    else
      return 1
    fi
  elif [ "$PLATFORM" = "$NAME_LINUX" ]; then
    if (rpm -qi $1 > /dev/null 2>&1); then
      return 0
    else
      return 1
    fi
  elif [ "$PLATFORM" = "$NAME_UBUNTU" ]; then
    if (dpkg -s $1 > /dev/null 2>&1); then
      return 0
    else
      return 1
    fi
  elif [ "$PLATFORM" = "$NAME_MPRAS" ] ||
       [ "$PLATFORM" = "$NAME_SOLARIS_SPARC" ] ||
       # DR101866
       [ "$PLATFORM" = "$NAME_SOLARIS_OPTERON" ]; then
    if (pkginfo -q $1 > /dev/null 2>&1); then
      return 0
    else
      return 1
    fi
  fi
}

##############################################################################
#
# Function: perform_postinstall    new for DR 67864
#
# Description: Perform steps after installation.
#
# Input: None
#
# Output: None
#
# Note: None
#
perform_postinstall ()
{
   # Remove TWBINSTALLINFOFILE, if it exists.
   if [ -f "$TWBINSTALLINFOFILE" ]; then
      rm -f "$TWBINSTALLINFOFILE"
   fi

   # Remove TTUMAININSTALLFILE, if it exists.
   if [ -f "$TTUMAININSTALLFILE" ]; then
      rm -f "$TTUMAININSTALLFILE"
   fi

   if [ "$PLATFORM" = "$NAME_MPRAS" ]; then
      if [ -f "$PKGORDERFILEORG" ]; then
         mv $PKGORDERFILEORG $PKGORDERFILE
      else
         rm -f "$PKGORDERFILE"
      fi
   fi
}

##############################################################################
#
# Function: perform_preinstall    new for DR 67864
#
# Description: Perform steps before installation.
#
# Input: None
#
# Output: None
#
# Note: None
#
perform_preinstall ()
{
   # Create TTUMAININSTALLFILE, if it does not exist.
   if [ ! -f "$TTUMAININSTALLFILE" ]; then
      touch "$TTUMAININSTALLFILE"
   fi

   # Remove TWBINSTALLINFOFILE, if it exists.
   if [ -f "$TWBINSTALLINFOFILE" ]; then
      rm -f "$TWBINSTALLINFOFILE"
   fi

   if [ "$PLATFORM" = "$NAME_MPRAS" ]; then
      if [ -f $PWD/"$DIR_MPRAS"/$ORDERFILE ]; then
         if [ -f "$PKGORDERFILEORG" ]; then
            rm -f $PKGORDERFILEORG
         fi

         if [ -f "$PKGORDERFILE" ]; then
            cp $PKGORDERFILE $PKGORDERFILEORG
         fi
         cat $PWD/"$DIR_MPRAS"/$ORDERFILE >> $PKGORDERFILE
      fi
   fi
}

##############################################################################
#
# Function: process_choice
#
# Description: Processes the user's choice(s).
#
# Input: None
#
# Output: None
#
# Note: None
#
process_choice ()
{
  noinput=1
  badselection=0
  quit=0
  repeat=0
  for c in ${choice}
  do
    noinput=0

    case $c in
      0) badselection=1;;  #DR99782 - Do not accept 0 as input.
      $odbc32_num)   install_tdodbc32=1;;
      $odbc_num)     install_tdodbc=1;;
      $cliv2_num)    install_cliv2=1;;
      $piom_num)     install_piom=1;;
      $lfile_num)    install_lfile=1;;
      $mqaxsmod_num) install_mqaxsmod=1;;
      $npaxsmod_num) install_npaxsmod=1;;
      $s3axsmod_num) install_s3axsmod=1;;
      $gcsaxsmod_num) install_gcsaxsmod=1;;	  
      $azureaxsmod_num) install_azureaxsmod=1;;
      $kafkaaxsmod_num) install_kafkaaxsmod=1;;
      $arc_num)      install_arc=1;;
      $cobpp_num)    install_cobpp=1;;
      $sqlpp_num)    install_sqlpp=1;;
      $bteq_num)     install_bteq=1;;
      $bteq32_num)   install_bteq32=1;;
      $fastexp_num)  install_fastexp=1;;
      $fastld_num)   install_fastld=1;;
      $mload_num)    install_mload=1;;
      $tdwallet_num) install_tdwallet=1;;
      $tpump_num)    install_tpump=1;;
      $ttupublickey_num)    install_ttupublickey=1;;
      $tdicu_num)    install_tdicu=1;;
      $tptbase_num)  install_tptbase=1;;
      $qrydir_num)   install_qrydir=1;;                 #DR109162
      $jmsaxsmod_num) install_jmsaxsmod=1;; 		#DR109162
      $soredistlibs_num) install_soredistlibs=1;;
      $ssredistlibs_num) install_ssredistlibs=1;;
      a) set_all;;
      u) uninstall_script; repeat=1;;
      q) quit=1;;
      *) badselection=1;;
    esac
    done

  if [ $noinput -eq 0 ]; then
    if [ $badselection -eq 1 ]; then
      display_msg "$ERRINVSL" $RC_OKAY
      reset_install
      display_menu
    fi
  else
    display_msg "$ERRSPCSL" $RC_OKAY
    display_menu
  fi
  
  if [ $repeat -eq 1 ]; then
    display_menu
  fi

  if [ $quit -eq 1 ]; then
    exit 0
  fi
}

##############################################################################
#
# Function: reset_install
#
# Description: Sets the install flag to 0 (zero) for all packages.
#
# Input: None
#
# Output: None
#
# Note: None
#
reset_install ()
{
  install_all=0
  install_tdodbc=0
  install_tdodbc32=0
  install_cliv2=0
  install_piom=0
  install_lfile=0
  install_mqaxsmod=0
  install_npaxsmod=0
  install_s3axsmod=0
  install_gcsaxsmod=0  
  install_azureaxsmod=0
  install_kafkaaxsmod=0
  install_arc=0
  install_cobpp=0
  install_sqlpp=0
  install_bteq=0
  install_bteq32=0
  install_fastexp=0
  install_fastld=0
  install_mload=0
  install_tdicu=0
  install_ttupublickey=0
  install_tdwallet=0
  install_tpump=0
  install_tptbase=0
  install_qrydir=0                  #DR109162
  install_jmsaxsmod=0               #DR109162
  install_soredistlibs=0
  install_ssredistlibs=0
}

##############################################################################
#
# Function: uninstall_script
#
# Description: Calls the uninstall script to remove packages
#
# Input: None
#
# Output: None
#
# Note: None
#
uninstall_script ()
{
  #Pass the version # to the package remove script only containing the first
  #three digits.  The last set is for internal version of this install script
  
  if [ -n "$2" ]
  then
    PRIORTO=$2
  else
    PRIORTO=`echo $SCRIPTVER | awk -F. '{ print $1 "." $2 "." $3 ".00" }'`
  fi

  #DR126914 If the shell /bin/ksh doesn't exist, call the script with bash
  if [ ! -f /bin/ksh ] && [ ! -L /bin/ksh ]; then
    bash ./uninstall_ttu.sh script priorto $PRIORTO $1
  else
    ./uninstall_ttu.sh script priorto $PRIORTO $1
  fi
  #If there's not a parameter passed to this function, then pause.
  if [ -z "$1" ]; then
    pause "$INFOCONT"
  fi
}

##############################################################################
#
# Function: set_all
#
# Description: Sets the install flag to 1 for all packages, + Teradata Wallet
#
# Input: None
#
# Output: None
#
# Note: None
#
set_all ()
{
  install_all=1

  if [ $tdicu_pkg_exists = 1 ]; then
    install_tdicu=1
  fi

  if [ $tdodbc_pkg_exists = 1 ]; then
    install_tdodbc=1
  fi

  if [ $cliv2_pkg_exists = 1 ]; then
    install_cliv2=1
  fi

  if [ $piom_pkg_exists = 1 ]; then
    install_piom=1
  fi

  if [ $lfile_pkg_exists = 1 ]; then
    install_lfile=1
  fi

  if [ $mqaxsmod_pkg_exists = 1 ]; then
    install_mqaxsmod=1
  fi

  if [ $npaxsmod_pkg_exists = 1 ]; then
    install_npaxsmod=1 
  fi

  if [ $s3axsmod_pkg_exists = 1 ]; then
    install_s3axsmod=1
  fi

  if [ $gcsaxsmod_pkg_exists = 1 ]; then
    install_gcsaxsmod=1
  fi

  if [ $azureaxsmod_pkg_exists = 1 ]; then
    install_azureaxsmod=1
  fi

  if [ $kafkaaxsmod_pkg_exists = 1 ]; then
    install_kafkaaxsmod=1 
  fi

  if [ $arc_pkg_exists = 1 ]; then
    install_arc=1
  fi

  if [ $cobpp_pkg_exists = 1 ]; then
    install_cobpp=1
  fi

  if [ $sqlpp_pkg_exists = 1 ]; then
    install_sqlpp=1
  fi

  if [ $bteq_pkg_exists = 1 ]; then
    install_bteq=1
  fi

  if [ $bteq32_pkg_exists = 1 ]; then
    install_bteq32=1
  fi

  if [ $fastexp_pkg_exists = 1 ]; then
    install_fastexp=1
  fi

  if [ $fastld_pkg_exists = 1 ]; then
    install_fastld=1
  fi

  if [ $mload_pkg_exists = 1 ]; then
    install_mload=1
  fi

  if [ $tdwallet_pkg_exists = 1 ]; then
    install_tdwallet=1
  fi

  if [ $tpump_pkg_exists = 1 ]; then
    install_tpump=1
  fi

  if [ $ttupublickey_pkg_exists = 1 ]; then
    install_ttupublickey=1
  fi
  
  if [ $tptbase_pkg_exists = 1 ]; then
    install_tptbase=1
  fi


#DR109162 Add Query Director support
  if [ $qrydir_pkg_exists = 1 ]; then
    install_qrydir=1
  fi

#DR109162 Add JMSAxsmod
  if [ $jmsaxsmod_pkg_exists = 1 ]; then
    install_jmsaxsmod=1
  fi

  if [ $soredistlibs_pkg_exists = 1 ]; then
    install_soredistlibs=1
  fi

  if [ $ssredistlibs_pkg_exists = 1 ]; then
    install_ssredistlibs=1
  fi
}

###############################################################################
# Function: import_signing_key
#
# Description: Imports the signing certificate
#
import_signing_key ()
{
    signdir=
}

###############################################################################
# Function: remove_previous_versions
#
# Description: Remove any previous packages if they are installed
#
remove_previous_versions ()
{
  tmpfile=/tmp/ttu_pkgs_tmp.out.$$
  #CLNTINS-6332: Block tdicu1600-16.00.00.00 if tdicu1510-15.10.01.00 is installed
  incompat_tdicu_name=""
  priorto=15.10.01.01
    
  case $PLATFORM in
    $NAME_LINUX)
      incompat_tdicu_name="tdicu1510-15.10.01.00"
      usetempfile=0
      rpm -qa --queryformat='%{NAME}-%{VERSION}\n'| egrep "(ttupublickey|teragssAdmin|teragss|TeraGSS_linux_x64|tdicu|teradata_arc|^arc|bteq|cliv2|piom|npaxsmod|mqaxsmod|jmsaxsmod|s3axsmod|gcsaxsmod|azureaxsmod|kafkaaxsmod|mload|fastexp|fastld|tpump|sqlpp|tdwallet|tptbase|tdodbc)" > $tmpfile  
	  all_installed_pkgs=`cat $tmpfile | egrep -v "(-13.|-14.|-15.00|-15.10.00|${incompat_tdicu_name})"`
      incompat="13.00|13.10|14.00|14.10|15.00|15.10.00|${incompat_tdicu_name}"
      dbFlag=`rpm -qa | grep pdegpl`
      if [ -n "$dbFlag" ]; then
         incompat="13.00|13.10|14.00|14.10|15.00|15.10|16.00|16.10|16.20"
         priorto=17.00.00.00
      fi
      pkgs=`cat $tmpfile | egrep "(${incompat})"`
    ;;

    $NAME_UBUNTU)
      dpkg -l | egrep "(teragssAdmin|tdicu|^arc|bteq|cliv2|piom|npaxsmod|mqaxsmod|jmsaxsmod|s3axsmod|gcsaxsmod|azureaxsmod|kafkaaxsmod|mload|fastexp|fastld|tpump|sqlpp|tdwallet|tptbase|tdodbc)" | awk '{print $2}' > $tmpfile  
	  all_installed_pkgs=`cat $tmpfile`
    ;;
	
    $NAME_AIX)
      incompat_tdicu_name="tdicu1510-15.10.1.0"
      lslpp_r -R ALL -Lc 2>/dev/null | egrep "(bteq|piom|npaxsmod|mqaxsmod|jmsaxsmod|mload|fastexp|fastld|tpump|cliv2|sqlpp|tdwallet|tptbase|tdodbc|teragss|TeraGSS|teragssAdmin|tdicu)" > $tmpfile
      all_installed_pkgs=`cat $tmpfile | egrep -v "(13.|14.|15.00|15.10.00|${incompat_tdicu_name})"`

      pkgs=`cat $tmpfile | awk -F:  '{ print $1 "-" $3 }' | egrep "(-13|-14|-15.00|-15.10.0|${incompat_tdicu_name})"`
      if [ "$DEBUG" ]; then echo "remove_previous_versions - pkgs is $pkgs"; fi
      if [ -n "$pkgs" ]; then
	rm $tmpfile
        for pkg in $pkgs
        do
          pkgname=`echo $pkg | awk -F'-' '{ print $1 }'`
          thisver=`echo $pkg | awk -F'-' '{ print $2 }' | awk -F. '{ printf("%02d.%02d.%02d.%02d", $1, $2, $3, $4)}'`
          echo "${pkgname}-${thisver}" >> $tmpfile
        done
        pkgs=`cat $tmpfile`
        if [ "$DEBUG" ]; then echo "remove_previous_versions - pkgs is $pkgs"; fi
      fi	   
	;;

     $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON )
       pkginfo | egrep "(bteq|piom|npaxsmod|mqaxsmod|jmsaxsmod|mload|fastexp|fastld|tpump|cliv2|sqlpp|tdwallet|tptbase|tdodbc|tdicu|teragss|TeraGSS|teragssAdmin|redistlibs)" > $tmpfile
       pkgs=`cat $tmpfile`
       if [ "$DEBUG" ]; then echo "pkgs is $pkgs"; fi
       if [ -n "$pkgs" ]
       then
         tmpfile1=/tmp/ttu_pkgs_tmp1.out.$$
         tmpfile2=/tmp/ttu_pkgs_tmp2.out.$$

         while read pkg
         do
           pkgName=`echo $pkg | awk '{ print $2 }'`
           if [ "$DEBUG" ]; then echo "pkgName is $pkgName"; fi
           thisver=`pkginfo -l $pkgName | grep -i ver | sed 's/[^0-9.]*//g' | tr -d '\n'`
#           vernum=`echo $thisver | awk -F. '{ printf("%02d%02d%02d", $1, $2, $3 ) }'`
           v1=`echo $thisver | cut -d '.' -f 1 | cut -c1-2`
           v2=`echo $thisver | cut -d '.' -f 2 | cut -c1-2`
           v3=`echo $thisver | cut -d '.' -f 3 | cut -c1-2`
           vernum=${v1}${v2}${v3}
           v4=`echo $thisver | cut -d '.' -f 4 | cut -c1-2`
           incompat_tdicu_name=${vernum}${v4}

		   
		   if [ "$DEBUG" ]; then echo "vernum is $vernum"; fi
           if [ "$vernum" -lt "151001" ]; then
             echo "${pkgName}-${thisver}" >> $tmpfile1
           elif [ "$incompat_tdicu_name" -eq "15100100" ] && [ "$pkgName" == "tdicu1510" ]; then
             echo "${pkgName}-${thisver}" >> $tmpfile1
           else
             echo "$pkg" >> $tmpfile2
           fi
         done < "$tmpfile"
		 
		 if [ -f "$tmpfile1" ]; then
           pkgs=`cat $tmpfile1`
		 else
		   pkgs="" 
		 fi
		 if [ -f "$tmpfile2" ]; then
           all_installed_pkgs=`cat $tmpfile2`
#		   if [ "$DEBUG" ]; then echo "all_installed_pkgs is $all_installed_pkgs"; fi
		 fi
       fi

    ;;
  esac

  if [ ! "$DEBUG" ]; then
    rm $tmpfile  2>/dev/null
    rm $tmpfile1 2>/dev/null
    rm $tmpfile2 2>/dev/null	
  fi

  if [ -n "$pkgs" ]; then
    echo "The following product(s) are incompatible with the"
    echo "version (${REL3NUM}) of TTU to be installed:"
    echo $pkgs  | tr " " "\n"
	echo ""
    echo "The above product(s) must be removed before installing $REL3NUM."

    #CLNTINS-6332: Block tdicu1600-16.00.00.00 if tdicu1510-15.10.01.00 is installed
    incompat_tdicu_msg=""
    incompat_tdicu_name="tdicu1510-15.10.01.00"
    incompat_tdicu=`echo $pkgs | tr " " "\n" | grep $incompat_tdicu_name`
    if [ -n "$incompat_tdicu" ]
    then 
       incompat_tdicu_msg="\n-------------------------------------------------------------------------------\nNote: 'tdicu1510-15.10.01.00' is installed. If you continue with 'Yes/Y' then\n       all installed '15.10.01.00' products will also be removed.\n-------------------------------------------------------------------------------\n"
    fi

    printf "$incompat_tdicu_msg"
    #CLNTINS-6332

    if [ "$MENU_PARAMETERS" ] || [ "$MENU_TEXT" ]; then
      printf "\nThe installed products will be automatically removed at this time.\n"
      uninstall_script all $priorto
    else
      printf "\nThe above products can be automatically removed at this time.\n"
      printf "Enter \"Yes\" to remove the above products and continue with the\n"
      printf "installation or \"No\" to cancel the installation?  ([y/n] default: Y): "

      printf "${MSG1}"
      read input
      case $input in
        n* | N* )
          echo ""
          echo "Cancelling the installation. Leaving products prior to ${RELNUM} installed."
          echo "These products should be removed before installing ${RELNUM} packages."
          exit 1
        ;;
        *)
          #Removing packages prior to $RELNUM
          uninstall_script all $priorto
        ;;
      esac
    fi	
  fi

  if [ -n "$dbFlag" ]; then
     return 0
  fi
  # remove the incompatible products because they would have been uninstalled in IsProductCompatible
#  all_installed_pkgs=`echo $all_installed_pkgs | tr " " "\n" | egrep -v "(-13.|-14.|-15.00|-15.10.00)"`
  tdicupkgs=`echo $all_installed_pkgs | tr " " "\n" | grep tdicu`
  thisicu=`echo $tdicupkgs | tr " " "\n" | grep tdicu${VERNUM}`

  if [ -z "$thisicu" ] && [ -n  "$tdicupkgs" ]; then
  # only do the rest if this tdicu for this release is not installed
    # found a compatible product
	for ICUPKG in `echo ${tdicupkgs}`
    do
      ver=`get_installed_package_version $ICUPKG`
#      ver=`echo $ICUPKG | cut -d '-' -f 2`
	  v1=`echo $ver | cut -d '.' -f 1 | cut -c1-2`
      v2=`echo $ver | cut -d '.' -f 2 | cut -c1-2`
      ICUSHORTVER=${v1}.${v2}
      ICUSHORTVER_NODOT=${v1}${v2}

	  if [ "$ICUSHORTVER_NODOT" -lt "$VERNUM" ]; then
        echo ""
 	    echo "The $ICUSHORTVER TTU Client Software is currently installed and "
	    echo "can co-exist with the $RELNUM release."
        found=1
	  fi
        done
	  
	if [ "$found" = "1" ]; then
	  priorto=${RELNUM}.99.00
      if [ "$MENU_PARAMETERS" ] || [ "$MENU_TEXT" ]; then
        # silent install so check if we should remove the previous release
        if [ "$PARAMPREV_REL" != "1" ]; then
          uninstall_script all $priorto
        fi
      else
        echo ""
        printf "Enter \"Yes\" to remove the previous release(s) and continue with the\n"
   	    printf "installation or \"No\" to keep the previous release?  ([y/n] default: Y): "

        printf "${MSG1}"
        read input
        case $input in
          n* | N* )
	   	    # do nothing
          ;;
          *)
            #Removing packages prior to $RELNUM
            uninstall_script all $priorto
          ;;
        esac
      fi
    fi	  
  fi
}

###############################################################################
# Function: check_installed_packages
#
# Description: Check previous packages if they are installed
#
check_installed_packages ()
{ 
  #VERNUM is short version, no dot: 1500, 1510, etc.
  #RELNUM is short version, with dot: 15.00, 15.10, etc.
  case $PLATFORM in
    $NAME_LINUX)
      installed_pkg=`rpm -qa | egrep "(ttupublickey|teradata_arc|^arc|bteq|cliv2|piom|npaxsmod|mqaxsmod|jmsaxsmod|s3axsmod|gcsaxsmod|azureaxsmod|kafkaaxsmod|mload|fastexp|fastld|tpump|sqlpp|tdwallet|tptbase|tdodbc|tdicu|teragssAdmin)${VERNUM}-${MAJORVER}[a-z]*\.${MINORVER}" | head -1`
      if [ "$installed_pkg" ]; then
        INSTALLED_DIR=`rpm -q --queryformat '%{INSTPREFIXES}' ${installed_pkg}`
      fi
    ;;
    $NAME_UBUNTU)
      installed_pkg=`dpkg -l | egrep "(^arc|bteq|cliv2|piom|npaxsmod|mqaxsmod|jmsaxsmod|s3axsmod|gcsaxsmod|azureaxsmod|kafkaaxsmod|mload|fastexp|fastld|tpump|sqlpp|tdwallet|tptbase|tdodbc|tdicu)${VERNUM}" | head -1`
      if [ "$installed_pkg" ]; then
        INSTALLED_DIR=/opt
      fi
    ;;
    $NAME_SOLARIS_SPARC | $NAME_SOLARIS_OPTERON)
      #Look in the system list of installed packages,
      VARSADMPKGDIR="/var/sadm/pkg"
      installed_pkg=`ls ${VARSADMPKGDIR} | egrep "(arc|piom|bteq|npaxsmod|mqaxsmod|jmsaxsmod|mload|fastexp|fastld|tpump|sqlpp|tdwallet|cliv2|tdodbc|tptbase|tdicu|teragssAdmin|redistlibs)${VERNUM}" | head -1`
      #After choosing an installed TTU package, look at its pkginfo file
      pkginfofile="${VARSADMPKGDIR}"/"${installed_pkg}"/pkginfo
      if [ -f "${pkginfofile}" ]; then
        INSTALLED_DIR=`awk -F= '$1 ~/^BASEDIR/ {print $2 }' < $pkginfofile`
         if [ "${INSTALLED_DIR}" = "/" ]; then
           INSTALLED_DIR=/opt
         fi
      fi
    ;;
    $NAME_AIX)
      installed_pkg=`lslpp_r -R ALL -Lc 2>/dev/null| egrep "(arc|bteq|piom|npaxsmod|mqaxsmod|jmsaxsmod|mload|fastexp|fastld|tpump|sqlpp|cobpp|tdwallet|tptbase|tdodbc|tdicu|teragssAdmin)${VERNUM}" | head -1`
      INSTALLED_DIR=`echo $installed_pkg | rev | cut -d ':' -f 2 | rev`
      if [ ! -z "${INSTALLED_DIR}" ]; then
        installed_pkg=`echo $installed_pkg | cut -d ':' -f 1`
        if [ "${INSTALLED_DIR}" = "/" ]; then
          INSTALLED_DIR=/opt
        fi
      fi
    ;;
esac

if [ -n "$INSTALLED_DIR" ]; then
  echo "Packages currently installed at: $INSTALLED_DIR"
fi
}

##############################################################################
#
# Main script execution starts here.
#
#Shift through the parameters passed to this script
while [ $# -gt 0 ]
do
  case "$1" in
    debug)
      DEBUG=1
      DEPENDS=1 ;;
    depend*)
      DEPENDS=1 ;;
    a|all)
      ALL="all-wallet" ;;
    w*)
      ALL="all+wallet" ;;
    h* | help | -help | --help)
      HELP=1 ;;
    [1-9]|[1-9][0-9])
      MENU_PARAMETERS="$MENU_PARAMETERS $1" ;;
    arc)
      MENU_TEXT="$MENU_TEXT arc" ;;
    bteq)
      MENU_TEXT="$MENU_TEXT bteq" ;;
    bteq32)
      MENU_TEXT="$MENU_TEXT bteq32" ;;
    cobpp)
      MENU_TEXT="$MENU_TEXT cobpp" ;;
    fastexp | fastexport)
      MENU_TEXT="$MENU_TEXT fastexp" ;;
    fastld | fastload)
      MENU_TEXT="$MENU_TEXT fastld" ;;
    jmsaxsmod)
      MENU_TEXT="$MENU_TEXT jmsaxsmod" ;;
    lfile)
      MENU_TEXT="$MENU_TEXT lfile" ;;
    mload)
      MENU_TEXT="$MENU_TEXT mload" ;;
    mqaxsmod)
      MENU_TEXT="$MENU_TEXT mqaxsmod" ;;
    npaxsmod)
      MENU_TEXT="$MENU_TEXT npaxsmod" ;;
    s3axsmod)
      MENU_TEXT="$MENU_TEXT s3axsmod" ;;
    gcsaxsmod)
      MENU_TEXT="$MENU_TEXT gcsaxsmod" ;;	  
    azureaxsmod)
      MENU_TEXT="$MENU_TEXT azureaxsmod" ;;
    kafkaaxsmod)
      MENU_TEXT="$MENU_TEXT kafkaaxsmod" ;;
    sqlpp)
      MENU_TEXT="$MENU_TEXT sqlpp" ;;
    odbc | tdodbc)
      MENU_TEXT="$MENU_TEXT odbc" ;;
    odbc32 | tdodbc32)
      MENU_TEXT="$MENU_TEXT odbc32" ;;
    tdwallet)
      MENU_TEXT="$MENU_TEXT tdwallet" ;;
    tptbase)
      MENU_TEXT="$MENU_TEXT tptbase" ;;
    tpump)
      MENU_TEXT="$MENU_TEXT tpump" ;;
    qrydir)
      MENU_TEXT="$MENU_TEXT qrydir" ;;
    tdicu)
      MENU_TEXT="$MENU_TEXT tdicu" ;;
    ttupublickey)
      MENU_TEXT="$MENU_TEXT ttupublickey" ;;
    cliv2)
      MENU_TEXT="$MENU_TEXT cliv2" ;;
    piom)
      MENU_TEXT="$MENU_TEXT piom" ;;
    soredistlibs)
      MENU_TEXT="$MENU_TEXT soredistlibs" ;;
    ssredistlibs)
      MENU_TEXT="$MENU_TEXT ssredistlibs" ;;
    -prevrel=*)
      PARAMPREV_REL=`echo $1 | awk -F= '{ print $2 }'`
      ;;
    -installdir=*)
      PARAMINSTALL_DIR=`echo $1 | awk -F= '{ print $2 }'`
      ;;
    -test)
      TEST="yes"
      ;;
  esac
  shift
done

if [ "$HELP" ]; then
  echo ""
  echo "Usage: setup.bat COMMAND"
  echo ""
  echo "List of Commands:"
  echo ""
  echo "help       Show this help message and exit"
  echo "debug      Sets debug flag to display additional information"
  echo "depends    Sets dependencies flag to display dependencies on the menu."
  echo "a          Install all TTU products available on the media, except for TDWallet."
  echo "w          Install all TTU products available on the media, including TDWallet."
  echo "[1 2 3...] Install a specific product number, based on the number for the" 
  echo "           package displayed in the menu."
  echo "[arc bteq cobpp fastexp fastexport fastld fastload jmsaxsmod lfile mload"
  echo "  mqaxsmod npaxsmod s3axsmod gcsaxsmod azureaxsmod kafkaaxsmod sqlpp odbc odbc32 tdodbc"
  echo "  tdwallet tptbase tpump qrydir tdicu cliv2 piom ttupublickey]"
  echo "           Install a product by package name if the TTU product exists"
  echo "           on the media. Products not available on the media will be"
  echo "           ignored and products already installed will be skipped."
  echo ""
  echo " -installdir=/path"
  echo "            If \"path\" is provided, the install will use that directory to"
  echo "            install the packages: /path/teradata/client/$RELNUM"
exit 0
fi
#If "a" or "all" is passed as a parameter, then just set the menu items
#chosen to "a" to install all of the packages rather than by number
if [ "$ALL" = "all-wallet" ]; then
  MENU_PARAMETERS="a"   #All packages, except for TDWallet
elif [ "$ALL" = "all+wallet" ]; then
  MENU_PARAMETERS="w"   #All packages, including TDWallet
fi

if [ "$DEBUG" ]; then
  if [ "$MENU_PARAMETERS" ]; then
    echo "Debug: Menu items passed on the command line to install:"
    echo "  MENU_PARAMETERS: $MENU_PARAMETERS"
    echo "  MENU_TEXT      : $MENU_TEXT"
  fi
  validate_directories
fi

#Don't display the Teradata logo when menu parameters are passed.
if [ -z "$MENU_TEXT" ]; then 
  display_logo
fi 
display_welcome
determine_platform
determine_privilege
display_media_label
remove_previous_versions
check_installed_packages
begin_installation

if [ -f "$TEMP_FILE" ]; then
   rm -rf /tmp/ttu-temp.*
fi

