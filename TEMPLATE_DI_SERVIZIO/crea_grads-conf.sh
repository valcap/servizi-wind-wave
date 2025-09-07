#!/bin/bash

# input file should be env/FILELIST.DET
# which has to be set before running the procedure
input="env/FILELIST.DET"
if [ ! -e $input ]; then
  echo "ops cannot find $input"
  exit 1
fi

# printout header file
for h in "filectl    = mol05gfs" "dirin      = /data01/mol05gfs" "dirout     = /home/meteop/www/img/SERVICES/flotilla" "dirleg     = /home/meteop/grads/legend" "tend       = 133" "tstep      = 1" "Consorzio LaMMA" "WW3-5km - MOLOCH-5km (GFS-25km)"
do
  echo $h
done

# simple routine to print out
# first point -> A,
# second point -> B, etc...
num_to_letters() {
  local n=$1
  local out=""
  local letters=( {A..Z} )
  while (( n > 0 )); do
    local rem=$(( (n - 1) % 26 ))
    out="${letters[$rem]}$out"
    n=$(( (n - 1) / 26 ))
  done
  printf "%s" "$out"
}

# Loop over the points listed in $input
idx=0
while read -r id name lon lat z; do
  # salta righe vuote o commenti
  [[ -z "$id" || "$id" =~ ^# ]] && continue

  idx=$((idx + 1))
  area="$(num_to_letters "$idx")"

    # Calcola range lat/lon ±2
    lat_min=$(echo "$lat - 2" | bc)
    lat_max=$(echo "$lat + 2" | bc)
    lon_min=$(echo "$lon - 2" | bc)
    lon_max=$(echo "$lon + 2" | bc)

    echo "*************************************************"
    echo "* PUNTO-$name"
    echo "area = $area"
    echo "*************************************************"
    echo "areaname   = PUNTO-$name(Lat:${lat}_Lon:${lon})"
    echo "lat        = $lat_min $lat_max"
    echo "lon        = $lon_min $lon_max"
    echo "pareaxy    = 0.4 10.89 1.3 7.99"
    echo "cbarn1     = 1.0 0 5.7 0.5"
    echo "xyinit     = 6.29 8.22"
    echo "xyvalid    = 0.41 8.22"
    echo "xytau      = 5.05 8.22"
    echo "xytit1     = 0.37 8.49"
    echo "xytit2     = 5.63 8.49"
    echo "xycapt1    = 2.55 0.23"
    echo "xycapt2    = 5.0 0.20"
    echo "uvskip1    = 2 1"
    echo "arrow1     = 0.1 0.15"
    echo "digsiz     = 0.1"
done < "$input"

exit 0;
