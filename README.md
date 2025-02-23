# servizi-wind-wave
Scripts per la creazione e run di un nuovo servizio con la fornitura di bollettini meteo con dati di vento e mare per n punti indicati dal committente.
I dati di origine sono gli output del modello ww3 a 5 km di risoluzione per la parte mare, forzati dai dati del modello moloch a 5 km per la parte atmosferica (dati di inizializzazione GFS).
La directory di lavoro è: //home/meteop/scripts/services

# create_new_service
USAGE: ./create_new_service NOME_NUOVO_SERVIZIO (che non deve gia esistere...)
Una volta inizializzato il servizio, per includerlo della lista dei servizi attivit, è sucfficiente inserire NOME_NUOVO_SERVIZIO nel file LISTA_SERVIZI_ATTIVI che ha la forma di:
NOME_SERIVIZIO        ;    ATTIVO
civitavecchia         ;    YES
piombino              ;    YES
genovaport            ;    YES
vadoligure            ;    YES
nextgeosolutionsP1866 ;    YES 
CapraiaGorgona        ;    YES
NOME_NUOVO_SERVIZIO   ;    YES
Una volta lanciato create_new_service è sufficiente modificare i seguenti file per ottenere il servizio funzionante:
echo "RIMANGONO DA SETTARE I SEGUENTI FILES:"
echo "$CURDIR/$MY_NEW_SERVICE_NAME/env/GRADS.CONF.$MY_NEW_SERVICE_NAME"
echo "$CURDIR/$MY_NEW_SERVICE_NAME/env/FILELIST.ENS.$MY_NEW_SERVICE_NAME"
echo "$CURDIR/$MY_NEW_SERVICE_NAME/env/FILELIST.DET.$MY_NEW_SERVICE_NAME"
echo "$CURDIR/$MY_NEW_SERVICE_NAME/send_mail.py (per i destinatari della mail)"

# run_service
./runall_services
Si basa su alcuni script presenti sulla macchina di postproc mare (.78), così come alcune directory di servizio (ad esempio $HOME/log); quindi la procedura non funziona aldifuori di quest'architettura
# servizi-wind-wave
