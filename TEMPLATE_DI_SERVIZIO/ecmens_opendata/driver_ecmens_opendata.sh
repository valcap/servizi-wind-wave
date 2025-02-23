#!/bin/bash
############################################################################
#
# Author  : Valerio Capecchi (capecchi@lamma.toscana.it)
# Date    : 17/02/2025
# Ver     : servizio see $SERVICE below...
#
############################################################################
# Usage
############################################################################
#source $HOME/scripts/util/init.sh $1 $2 $3
HH=$2
exec 1>$HOME/log/`basename $0`.log
exec 2>&1
###########################################################################
# LOCAL DEFINITIONS
###########################################################################
SERVICE=NOME_SERVIZIO
SERVICE_UC=`echo ${SERVICE^^}`
DIRGEO=$HOME/data/$SERVICE
DIROUT=$HOME/www/img/SERVICES/$SERVICE
DIRSCR=$HOME/scripts/services/$SERVICE/ecmens_opendata
DIRDAT=/DATAPRE/data/ecmens_opendata
for ext in grb2 grb2.ctl grb2.idx
do
  if [ ! -e $DIRDAT/ecmens_opendata.${HH}z.${ext} ]; then
    echo "ops $DIRDAT/ecmens_opendata.${HH}z.${ext} is missing"
    exit 1;
  fi
done
FILELIST=$HOME/scripts/services/$SERVICE/env/FILELIST.ENS
[ ! -f $FILELIST ] && { echo "FILELIST $FILELIST NOT FOUND !!!!"; exit 5; }
NLOC=`cat $FILELIST | wc -l`

# Do
cd $DIRSCR
ln -svf $DIRDAT/ecmens_opendata.${HH}z.* .
for (( iloc=1; iloc<=$NLOC; iloc++ )); do
  locnum=`cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $1 }'`
  locnam=`cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $2 }'`
  loclon=`cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $3 }'`
  loclat=`cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $4 }'`
  lochgt=`cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $5 }'`
  echo working on $locnum $locnam $loclon $loclat
  FILEOUT=$DIROUT/ecmens_ww.${locnum}.png
  cat plot_ecmens_tmpl.gs | sed -e "s/MYRUN/$HH/g" \
                          | sed -e "s/loclon/$loclon/g" \
                          | sed -e "s/loclat/$loclat/g" \
                          | sed -e "s/locnam/$locnam/g" \
                          | sed -e "s!FILEOUT!$FILEOUT!" > stocazzo.gs
  grads -blc "run stocazzo.gs"
  if [ $? -eq 0 ]; then
    rm -f stocazzo.gs
  else
    echo "ops $locnum $locnam"; exit 1
  fi
done

rm -f ecmens_opendata.${HH}z.*

exit 0

