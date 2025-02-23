#!/bin/bash
#
# Name:         ftp2arc.sh
# Date:         20230913
# UpDate:       20240220
# Version:      1.0
# History:      first release
# Author:       Claudio Tei (tei@lamma.toscana.it)
# Author:       Valerio Capecchi (capecchi@lamma.toscana.it)
# Call:	->
# 		->
#		->
# What's for: invia lo zip con le tabelle a $SERVICE

exec 1>$HOME/log/$(basename $0).log
exec 2>&1
if [ -z "$1" ]; then
    echo "Errore: devi specificare un valore per SERVICE."
    exit 1
fi
SERVICE=$1
# Variabili per la connessione SFTP
SFTP_USER="MY_USER"
SFTP_HOST="MY_HOST"
SFTP_PORT=MY_PORT
REMOTE_DIR="/$SERVICE"
# Imposta la password come variabile d'ambiente
export SFTP_PASS="MY_PASS"
# Percorso del file ZIP da inviare
LOCAL_FILE="$HOME/www/img/SERVICES/${SERVICE}/Forecast*.zip"

# Verifica connessione SFTP
sshpass -p "$SFTP_PASS" sftp -oBatchMode=no -oConnectTimeout=10 -P $SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
exit
EOF
# Controllo stato della connessione
if [ $? -ne 0 ]; then
    echo "Errore: impossibile connettersi a $SFTP_HOST sulla porta $SFTP_PORT."
    exit 1
fi
echo "Connessione SFTP riuscita!"

# Connessione e trasferimento del file
sshpass -p "$SFTP_PASS" sftp -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
mkdir $REMOTE_DIR
cd $REMOTE_DIR
mput $LOCAL_FILE
bye
EOF

# Verifica lo stato del trasferimento
if [ $? -eq 0 ]; then
    echo "Il file è stato inviato con successo...forse controlla meglio su $SFTP_HOST."
else
    echo "Si è verificato un errore durante l'invio del file."
fi
