#!/bin/bash
############################################################################
#
# Author     : Valerio Capecchi (capecchi@lamma.toscana.it; valcap74@gmail.com)
# Date       : 20/02/2025
# Ver        : Servizio per NOME_SERVIZIO
#
# ATTENZIONE : LO SCRIPT VIENE LANCIATO DAL MAIN DEL WW3
#              /home/meteop/scripts/ww3/MAIN.sh
#              VA LANCIATO CON ENV DEL WW3  (ww305gfs)
############################################################################
# Usage
############################################################################
if [ $# -lt 3 ]; then
  echo "Not enough arguments, need at least 3."
  echo "Usage: $0 file_env run rlen"
  echo "Example: $0 $HOME/scripts/etc/ww305gfs.env 00 120"
  echo "WARNING LAUNCH with WW305GFS ENV!!!!"
  exit 8
fi

if [ ! -e $HOME/scripts/util/init.sh ]; then
  echo "ops function file $HOME/scripts/util/init.sh is missing...EXITING"; exit 8;
else
  source $HOME/scripts/util/init.sh $1 $2 $3
fi

###########################################################################
# SERVICE NAME (to be modified for each new service)
SERVICE=NOME_SERVIZIO
###########################################################################

###########################################################################
# LOGDIR & LOGFILE (NOT to be modified for each new service)
DIRLOG=$HOME/log
[ ! -d $DIRLOG ] && { notice "$DIRLOG NOT FOUND...EXITING"; exit 8; }
LOGFILE=$DIRLOG/MAIN_${SERVICE}_${RUNDATEHH}.log
exec 1>$LOGFILE; exec 2>&1
echo "INPUT ARGUMENTS"
echo "---------------------"
echo "---------------------"
echo "LOGFILE: $LOGFILE"
echo "file_env: $file_env"
echo "hh: $hh"
echo "RLEN: $RLEN"
echo "run: $run"
echo "FT: $FT"
echo "RUNDATE: $RUNDATE"
echo "RUNDATEHH: $RUNDATEHH"
echo "---------------------"
echo "---------------------"
# DIR ROOT (NOT to be modified for each new service)
DIRROOT=$HOME/scripts/services/$SERVICE
[ ! -d $DIRROOT ] && { notice "$DIRROOT NOT FOUND...EXITING"; exit 8; }
# DIR OUTPUT (NOT to be modified for each new service)
DIROUT=$HOME/www/img/SERVICES/$SERVICE
[ ! -d $MYDIR ] && { mkdir $MYDIR; }
notice 'IMPORTANT: OUTPUT DIR IS '$DIROUT' +++'

###########################################################################
# FILE WAVE (NetCDF format) (NOT to be modified for each new service)
MODELWAVE=ww305gfs
DIRWAVE=/data01/$MODELWAVE/$run
[ ! -d $DIRWAVE ] && { notice "$DIRWAVE NOT FOUND...EXITING"; exit 8; }
FILEWAVE=${MODELWAVE}.${run}.ectable.nc
[ ! -e $DIRWAVE/$FILEWAVE ] && { notice "$DIRWAVE/$FILEWAVE NOT FOUND...EXITING"; exit 8; }
notice 'IMPORTANT: INPUT WAVE FILE IS '$DIRWAVE/$FILEWAVE' +++'

###########################################################################
# FILE ATMO (Grib format) (NOT to be modified for each new service)
MODELATMO=mol05gfs
DIRATMO=/data01/$MODELATMO/$run
[ ! -d $DIRATMO ] && { notice "$DIRATMO NOT FOUND...EXITING"; exit 8; }
FILEATMO=all.${MODELATMO}.${run}.grb2.shf
[ ! -e $DIRATMO/$FILEATMO ] && { notice "$DIRATMO/$FILEATMO NOT FOUND...EXITING"; exit 8; }
notice 'IMPORTANT: INPUT ATMO FILE IS '$DIRATMO/$FILEATMO' +++'
OKFILEATMO=$DIRATMO/OKFILE.$FILEATMO
if ! ([ -f "$OKFILEATMO" ] && grep -q "$RUNDATEHH" "$OKFILEATMO"); then
  notice "FILEATMO NOT FOUND...EXITING"
  exit 8;
fi

###########################################################################
# List of points to extract (FILELIST.DET to be modified for each new service)
FILELIST=$DIRROOT/env/FILELIST.DET
[ ! -f $FILELIST ] && { notice "$FILELIST NOT FOUND !!!!"; exit 8; }
NLOC=$(cat $FILELIST | wc -l)
notice "FILELIST IS $FILELIST AND NUMBER OF LOC IS "$NLOC

###########################################################################
# DIR Grads (NOT to be modified for each new service)
DIRGS=$DIRROOT/gs
[ ! -d $DIRGS ] && { notice "$DIRGS NOT FOUND...EXITING"; exit 8; }
# Configuration file for Grads (GRADS.CONF to be modified for each new service)
FILECONF=$DIRROOT/env/GRADS.CONF
[ ! -f $FILECONF ] && { notice "FILECONF NOT FOUND !!!!"; exit 8; }
# Script Grads to estract values and create meteograms/maps (NOT to be modified for each new service)
for fff in estraidati_ATMO.gs estraidati_WAVE.gs ts_wave.gs ts_wind.gs swh.gs
do
  [ ! -f $DIRGS/$fff ] && { notice "$DIRGS/$fff NOT FOUND !!!!"; exit 8; }
done

###########################################################################
# Ensemble stuff (driver_ecmens_opendata.sh && FILELIST.ENS to be modified for each new service)
DIRENS=$DIRROOT/ecmens_opendata
[ ! -f $DIRENS/driver_ecmens_opendata.sh ] && { notice "$DIRENS/driver_ecmens_opendata.sh NOT FOUND !!!!"; exit 8; }
FILELIST_ENS=$DIRROOT/env/FILELIST.ENS
[ ! -f $FILELIST_ENS ] && { notice "$FILELIST_ENS NOT FOUND !!!!"; exit 8; }

###########################################################################
# Misc ($DIR_ARCHIVIO NOT to be modified for each new service)
DIR_ARCHIVIO=/ARCHIVIO/DATA/archive/services/${SERVICE}
if [ ! -d $DIR_ARCHIVIO ]; then
  mkdir -p $DIR_ARCHIVIO
fi
# (crea_tabella.sh send_mail.* scp2web.sh to be modified for each new service)
for fff in crea_tabella.sh send_mail.sh scp2web.sh send_mail.py
do
  [ ! -f $DIRROOT/$fff ] && { notice "$DIRROOT/$fff NOT FOUND !!!!"; exit 8; }
done

############################################################################
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTHING SHOULD BE CHANGED BELOW HERE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
############################################################################
if [ -z ${DIROUT+x} ]; then notice "DIROUT not SET; exit"; exit 8; fi
rm -fr $DIROUT
mkdir $DIROUT

# link files atmo in $DIROUT
cd $DIROUT
echo "WORKING DIRECTORY IS $DIROUT"
for ext in ctl idx
do
  if [ -f $DIRATMO/${FILEATMO}.${ext} ]; then
    ln -sf $DIRATMO/${FILEATMO}.${ext} . 
  else
    echo "ops missing $DIRATMO/${FILEATMO}.${ext}"; exit 0;
  fi
done
ln -sf $DIRATMO/$FILEATMO .

cd $DIRGS

# estrae i dati ATMO and WAVE per la tabella
echo "WORKING IN $DIRGS estrae i dati ATMO and WAVE per la tabella"
for ((iloc = 1; iloc <= $NLOC; iloc++)); do
  locnum=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $1 }')
  locnam=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $2 }')
  loclon=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $3 }')
  loclat=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $4 }')
  lochgt=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $5 }')
  echo "$locnam,$locnum,$locnam,$loclon,$loclat"
  FILEIN=$DIROUT/${FILEATMO}.ctl
  FILEOUT=$DIROUT/GEO.ATMO.csv.${locnum}
  echo "run estraidati_ATMO.gs $SERVICE $locnam $loclon $loclat $FILEOUT"
  grads -blc "run estraidati_ATMO.gs $FILEIN $locnum $locnam $loclon $loclat $lochgt $FILEOUT"
  if [ -e $FILEOUT ]; then
    echo $FILEOUT exists
  else
    echo ops $FILEOUT
  fi
  FILEIN=$DIRWAVE/${FILEWAVE}
  FILEOUT=$DIROUT/GEO.WAVE.csv.${locnum}
  echo "run estraidati_WAVE.gs $SERVICE $locnam $loclon $loclat $FILEOUT"
  grads -blc "run estraidati_WAVE.gs $FILEIN $locnum $locnam $loclon $loclat $lochgt $FILEOUT"
done

# make meteogram
cd $DIRGS
echo "WORKING DIR IS $DIRGS"

echo "WORKING ON make meteogram"
for ((iloc = 1; iloc <= $NLOC; iloc++)); do
  locnum=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $1 }')
  locnam=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $2 }')
  loclon=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $3 }')
  loclat=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $4 }')
  lochgt=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $5 }')
  area=`echo {A..Z} | cut -d' ' -f $iloc`
  echo "$locnam,$locnum,$locnam,$loclon,$loclat,$area"
  FILEIN=$DIROUT/${FILEATMO}.ctl
  grads -blc "run ts_wind.gs $FILEIN $FILECONF $hh $locnam $locnum $loclat $loclon $area"
  FILEIN=$DIRWAVE/${FILEWAVE}
  grads -blc "run ts_wave.gs $FILEIN $FILECONF $hh $locnam $locnum $loclat $loclon $area"
done

cd $DIRGS

# make swh maps
echo "WORKING ON make swh maps"
for ((iloc = 1; iloc <= $NLOC; iloc++)); do
  area=`echo {A..Z} | cut -d' ' -f $iloc`
  FILEIN=$DIRWAVE/${FILEWAVE}
  grads -blc "run swh.gs $FILEIN $FILECONF $hh $area $FILELIST"
done

# ecmens_opendata for ensemble meteograms day 5-10
echo "WORKING ON ecmens_opendata for ensemble..."
if [ $hh == '00' ]; then
  newhh='12'
fi
if [ $hh == '12' ]; then
  newhh='00'
fi
cd $DIRENS
sh driver_ecmens_opendata.sh dummy1 $newhh dummy2
cd -

# write OKFILE
echo $RUNDATEHH >$DIROUT/OKFILE.GEO

cd $DIRROOT
# ftp
echo "WORKING ON archivia su ftp"
./ftp2arc.sh $SERVICE
# crea tabella
echo "WORKING ON crea tabella"
./crea_tabella.sh $SERVICE $hh
# invio mail
echo "WORKING ON invio mail"
./send_mail.sh $SERVICE $RUNDATEHH
# invio web
echo "WORKING ON invio su web"
./scp2web.sh $SERVICE

# invio su archivio
echo "WORKING ON invio su dir archivio $DIR_ARCHIVIO"
for ((iloc = 1; iloc <= $NLOC; iloc++)); do
  area=`echo {A..Z} | cut -d' ' -f $iloc`
  if [ ! -f $DIROUT/Forecast_Lamma_${RUNDATEHH}_${iloc}.pdf ]; then
    echo "ops pdf file $DIROUT/Forecast_Lamma_${RUNDATEHH}_${iloc}.pdf is missing";
  else
    cp -f $DIROUT/Forecast_Lamma_${RUNDATEHH}_${iloc}.pdf $DIR_ARCHIVIO/
  fi
done

# Bye
echo "WORKING ON niente, off-finito $SERVICE"
exit 0

