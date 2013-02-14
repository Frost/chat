#!/bin/bash
BIN="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../node_modules/.bin

path_remove ()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }

#if [[ $PATH == *$BIN*  ]]; then
if [ "$1" = "disable" ]; then
  path_remove $BIN
elif [ "$1" = "enable" ]; then
  path_remove $BIN
  export PATH="$BIN:$PATH"
else
  echo "Usage: shim enable|disable"
fi
