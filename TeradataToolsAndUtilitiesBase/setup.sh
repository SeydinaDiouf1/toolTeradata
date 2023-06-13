
#setup.sh

# DR126914 - Support for Linux without /bin/ksh

if [ ! -f /bin/ksh ] && [ ! -L /bin/ksh ]; then
  [ "$0" = "`basename \"$0\"`" ] && bash .setup.sh $*
  bash "`dirname \"$0\"`"/.setup.sh $*
else
  [ "$0" = "`basename \"$0\"`" ] && exec .setup.sh $*
  exec "`dirname \"$0\"`"/.setup.sh $*
fi
