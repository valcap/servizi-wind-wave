#!/bin/bash

#invio file sul web

if [ $# -ne 1 ]; then
  echo "Not enough/too many arguments, need 1"
  echo "Usage: $0 STOCAZZO"
  exit 8
fi

exec 1>$HOME/log/$(basename $0).log
exec 2>&1
SERVICE=$1
DIRWWW=$HOME/www/img/SERVICES/$SERVICE
DIRWEB=/www-data/lamma/servizi/$SERVICE
ssh webdata@172.16.1.13 <<EOF
if [ ! -d "$DIRWEB" ]; then
    mkdir -p "$DIRWEB"
fi
cd "$DIRWEB" && rm -f Forecast_*.pdf
rm -f index.html
exit
EOF

scp $DIRWWW/index.html.web webdata@172.16.1.13:$DIRWEB/index.html
scp $DIRWWW/Forecast*.pdf webdata@172.16.1.13:$DIRWEB

exit
