#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Not enough/too many arguments, need 2"
  echo "Usage: $0 SERVICE rundate"
  echo "Usage: $0 STOCAZZO YYYYMMDDHH"
  exit 8
fi

SERVICE=$1
rundate=$2
dirlog=$HOME"/log"

filelog=$dirlog/$(basename "$0" .sh).log
exec 1>"$filelog"
exec 2>&1

dirwork=$HOME/scripts/services/$SERVICE
/usr/bin/python $dirwork/send_mail.py $SERVICE $rundate

exit 0;

