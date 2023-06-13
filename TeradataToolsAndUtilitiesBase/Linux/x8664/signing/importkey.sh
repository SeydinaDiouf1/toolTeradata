#!/bin/bash

publicKeyName=TD-RPM-SIGN-KEY
keyInfo=gpg-pubkey-4b121135-5f18c294
ttukey=`rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | grep $keyInfo`

if [ -z "$ttukey" ]; then
  signing_dir=$1
  if [ -z "$signing_dir" ]; then
    scriptPath="`dirname $0`"
    signing_dir=$scriptPath/../etc
    if [ ! -f $signing_dir/$publicKeyName ]; then
      signing_dir=$scriptPath/../../etc
    fi
  fi

  if [ -f $signing_dir/$publicKeyName ]; then  
    echo "Importing $publicKeyName"

    rpm --import $signing_dir/$publicKeyName
    worked=`rpm -q gpg-pubkey --qf '%{NAME}-%{VERSION}-%{RELEASE}\t%{SUMMARY}\n' | grep $keyInfo`
    if [ -z "$worked"  ]; then
      echo "The import of $publicKeyName failed."
    else
      echo "$publicKeyName was imported."
    fi
  else
    echo "$publicKeyName was not found in $signing_dir"
  fi
else
  echo "$publicKeyName is already imported."
fi

