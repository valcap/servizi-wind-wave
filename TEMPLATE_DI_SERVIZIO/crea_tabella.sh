#!/bin/sh
#
# Name:         crea_tabella
# Date:         10/04/2024
# History:      major update
# Author:       Claudio Tei (tei@lamma.toscana.it)
# What's for: fa il pdf

# COSA RESTA?
# FARE i DAT GEO.ATMO.csv.1 ecc
# FARE IMG in dir

if [ $# -ne 2 ]; then
  echo "Not enough/too many arguments, need 2"
  echo "Usage: $0 SERVICE run"
  echo "Usage: $0 STOCAZZO 00"
  exit 8
fi

SERVICE=$1
hh=$2

######################################
# NOTHING SHOULD BE CHANGED BELOW HERE
######################################

# DIR definition
DIR=$HOME/scripts/services/$SERVICE
DIRHTML=$DIR/html
DIRWORK=$HOME/www/img/SERVICES/$SERVICE
DIRURL="http://192.168.1.78/meteop/www/img/SERVICES/${SERVICE}"

# LOG
FILELOG=$HOME/log/crea_tabella_${SERVICE}.log
exec 1>$FILELOG
exec 2>&1

# template files
copertina_template=$DIRHTML/copertina.html
tabella_template=$DIRHTML/tabella.html
grafici_template=$DIRHTML/grafici.html
cd $DIRHTML
for file in copertina.html tabella.html grafici.html tabella_geo.css; do
 [ ! -f $file ] && { echo "ERROR - $file MISSING... EXIT"; exit 8; }
done 

# output files
copertina_file=copertina.html
tabella_file=tabella.html
grafici_file=grafici.html

daterun=$(cat $DIRWORK/OKFILE.GEO)
dateupd=$(date +"%a, %d-%m-%Y %H:%M UTC")

FILELIST=$DIR/env/FILELIST.DET
[ ! -f $FILELIST ] && { echo "FILELIST NOT FOUND !!!!"; exit 8; }
NLOC=$(cat $FILELIST | wc -l)
echo "FILELIST is: "$FILELIST
echo "Number of LOC is: "$NLOC

[ -z ${DIRWORK+x} ] && { echo "$DIRWORK not SET; exit"; exit 8; }
if [ -d $DIRWORK ]; then
  rm -f $DIRWORK/copertina*
  rm -f $DIRWORK/grafici*
  rm -f $DIRWORK/tabella*
  rm -f $DIRWORK/Forecast_Lamma*
else
  mkdir $DIRWORK
fi

cd $DIRWORK

# genero i file di work
cp -f $DIRHTML/tabella_geo.css .
if [ ! -e $DIRHTML/logo_lamma.png ]; then
  echo "WARNING $DIRHTML/logo_lamma.png DOES NOT EXIST (sticazzi)"
fi
cp -f $DIRHTML/logo_lamma.png .

# numero di pagina da cui iniziano le tabelle
# 1 = copertina
# 2 = grafico det
# 3 = grafico ens
npage=4

IDAYMAX=5
NPAGETOT=$((IDAYMAX+3))

if [ $hh -eq 12 ]; then
  IDAYMAX=6
  NPAGETOT=$((IDAYMAX+3))
fi
ils=2
ilsm=24

for ((iloc = 1; iloc <= $NLOC; iloc++)); do
  locnum=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $1 }')
  locnam=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $2 }')
  loclat=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $4 }')
  loclon=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $3 }')
  lochgt=$(cat $FILELIST | head -n $iloc | tail -1 | awk '{ print $5 }')
  areaname=`echo {A..Z} | cut -d' ' -f $iloc`
  echo "DOING: "$locnum" "$locnam" "$loclat" "$loclon
  # copertina
  rm -f copertina.html copertina.pdf
  cp -f $DIRHTML/copertina.html .
  sed -i "s/@areaname/$areaname/" $copertina_file
  sed -i "s/@stnname/$locnam/" $copertina_file
  sed -i "s/@stnlat/$loclat/" $copertina_file
  sed -i "s/@stnlon/$loclon/" $copertina_file
  sed -i "s/@dateupd/$dateupd/" $copertina_file
  sed -i "s/@pagetot/$NPAGETOT/" $copertina_file
  wkhtmltopdf --enable-local-file-access copertina.html copertina.pdf
  # grafici
  rm -f grafici.html grafici.pdf
  cp -f $DIRHTML/grafici.html .
  sed -i "s/@iloc/$iloc/" grafici.html
  sed -i "s/@pagetot/$NPAGETOT/" grafici.html
  wkhtmltopdf --enable-local-file-access grafici.html grafici.pdf
  # tabella
  rm -f tabella.html
  FILEIN_ATMO=$HOME/www/img/SERVICES/$SERVICE/GEO.ATMO.csv.$iloc
  FILEIN_WAVE=$HOME/www/img/SERVICES/$SERVICE/GEO.WAVE.csv.$iloc
  ir=2
  for ((iday = 1; iday <= $IDAYMAX; iday++)); do
    cp -f $DIRHTML/tabella.html tabella.html
    echo "DOING DAY"$iday
    if [ $hh -eq 12 ] && [ $iday -eq 1 ]; then
      ilm=12
      cp -f $DIRHTML/tabella.${hh}.html tabella.html
    else
     ilm=24
    fi

    for ((il=1; il<=$ilm; il++)); do
        datetime=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $1 }')
        winddir=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $4 }')
        winddirez=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $3 }')
        windspeed=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $2 }')
        wind50dir=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $6 }')
        wind50direz=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $7 }')
        windspeed50=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $5 }')
        if [ $il -eq 1 ]; then
          gust='NA'
        else
          gust=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $8 }')
        fi
        temp=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $9 }')
        totcld=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $10 }')
        if [ $il -eq 1 ]; then
          pcp='NA'
        else
          pcp=$(cat $FILEIN_ATMO | head -n $ir | tail -1 | awk -F ";" '{ print $11 }')
        fi

        waveht=$(cat $FILEIN_WAVE | head -n $ir | tail -1 | awk -F ";" '{ print $2 }')
        wavedir=$(cat $FILEIN_WAVE | head -n $ir | tail -1 | awk -F ";" '{ print $3 }')
        wavedirez=$(cat $FILEIN_WAVE | head -n $ir | tail -1 | awk -F ";" '{ print $4 }')
        waveper=$(cat $FILEIN_WAVE | head -n $ir | tail -1 | awk -F ";" '{ print $5 }')
        wavemax=$(cat $FILEIN_WAVE | head -n $ir | tail -1 | awk -F ";" '{ print $6 }')

        echo $datetime" "$winddir" "$wavedir
        sed -i "0,/@datetime_$il/s//$datetime/" "$tabella_file"
        sed -i "0,/@winddir_$il/s//$winddir/" "$tabella_file"
        sed -i "0,/@winddirez_$il/s//$winddirez/" "$tabella_file"
        sed -i "0,/@windspeed_$il/s//$windspeed/" "$tabella_file"
        sed -i "0,/@wind50dir_$il/s//$wind50dir/" "$tabella_file"
        sed -i "0,/@wind50direz_$il/s//$wind50direz/" "$tabella_file"
        sed -i "0,/@windspeed50_$il/s//$windspeed50/" "$tabella_file"
        sed -i "0,/@gust_$il/s//$gust/" "$tabella_file"
        sed -i "0,/@temp_$il/s//$temp/" "$tabella_file"
        sed -i "0,/@totcld_$il/s//$totcld/" "$tabella_file"
        sed -i "0,/@pcp_$il/s//$pcp/" "$tabella_file"
        sed -i "0,/@waveht_$il/s//$waveht/" "$tabella_file"
        sed -i "0,/@wavedir_$il/s//$wavedir/" "$tabella_file"
        sed -i "0,/@wavedirez_$il/s//$wavedirez/" "$tabella_file"
        sed -i "0,/@waveper_$il/s//$waveper/" "$tabella_file"
        sed -i "0,/@wavemax_$il/s//$wavemax/" "$tabella_file"

        sed -i "s/@stnname/$locnam/" $tabella_file
        sed -i "s/@stnlat/$loclat/" $tabella_file
        sed -i "s/@stnlon/$loclon/" $tabella_file
        sed -i "s/@pagenum/$npage/" $tabella_file
        sed -i "s/@pagetot/$NPAGETOT/" $tabella_file
        ir=$((ir+1)) 
    done
    npage=$((npage+1))
    wkhtmltopdf $DIRURL/tabella.html tabella.pdf.$iday
  done
  pdfunite copertina.pdf grafici.pdf tabella.pdf.* Forecast_Lamma_${daterun}_${iloc}.pdf
done

## creo zip per archivio
zip -r Forecast_Lamma_${daterun}.pdf.zip Forecast_Lamma_${daterun}_*.pdf
if [ ! -e Forecast_Lamma_${daterun}.pdf.zip ]; then
  echo "WARNING: ops qualche problema nella creazione dello zip Forecast_Lamma_${daterun}.pdf.zip"
fi

## creo index per web pubblico
cp $DIRHTML/index_web.html index.html.web
sed -i "s/@NAME_OF_SERVICE/$SERVICE/g" index.html.web
sed -i "s/@daterun/$daterun/g" index.html.web
sed -i "s/@dateupd/$dateupd/g" index.html.web

rm -f copertina.pdf
rm -f grafici.pdf
rm -f tabella.pdf.*
#rm -f GEO.*

exit 0
