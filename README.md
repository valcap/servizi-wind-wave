# servizi-wind-wave

Il codice di questo progetto è disponibile su GitHub al seguente link: [GitHub Repository](https://github.com/valcap/servizi-wind-wave). Per ottenere una copia locale del repository, è possibile eseguire il seguente comando:

```bash
git clone https://github.com/valcap/servizi-wind-wave.git
```

Dopo aver clonato il repository, spostarsi nella directory del progetto con:
```bash
cd servizi-wind-wave
```

Scripts per la creazione e l'esecuzione di servizi che forniscono bollettini meteo contenenti dati su vento e mare per punti specifici indicati dal committente. I dati di origine provengono dagli output del modello WW3 a 5 km di risoluzione per la parte marina, forzati dai dati del modello Moloch a 5 km per la parte atmosferica (dati di inizializzazione GFS).

## Struttura del Progetto

La directory di lavoro principale è:

```
$HOME/scripts/services
```

All'interno del repository, i principali file e directory sono:

- `TEMPLATE_DI_SERVIZIO/`: Template per la creazione di un nuovo servizio.
- `LISTA_SERVIZI_ATTIVI`: File contenente l'elenco dei servizi attivi.
- `create_new_service`: Script per creare un nuovo servizio.
- `runall_services`: Script per eseguire tutti i servizi attivi.
- `README.md`: Questo file, contenente la descrizione del progetto.
- `LICENSE`: Licenza GPL-2.0 del progetto.

## Creazione di un Nuovo Servizio

Per creare un nuovo servizio, seguire questi passaggi:

1. **Esecuzione dello Script di Creazione**:  
   Eseguire lo script `create_new_service` passando come argomento il nome del nuovo servizio:
   ```bash
   ./create_new_service NOME_NUOVO_SERVIZIO
   ```
   Assicurarsi che `NOME_NUOVO_SERVIZIO` non esista già.

2. **Aggiunta alla Lista dei Servizi Attivi**:  
   Dopo aver creato il nuovo servizio, aggiungerlo al file `LISTA_SERVIZI_ATTIVI` nel seguente formato:
   ```
   NOME_SERVIZIO ; ATTIVO
   ```
   Ad esempio:
   ```
   NOME_SERVIZIO ; ATTIVO
   PORTO1 ; YES
   CAVO1 ; YES
   PORTO2 ; NO
   REGATA1 ; YES
   NOME_NUOVO_SERVIZIO ; YES
   ```

3. **Personalizzazione del Servizio**:  
   Modificare i file all'interno della directory del nuovo servizio (`NOME_NUOVO_SERVIZIO`) secondo le esigenze specifiche.

## Personalizzazione del Servizio

Per personalizzare un nuovo servizio, è necessario modificare i seguenti file all'interno della directory del servizio creato:

### **GRADS.CONF.$MY_NEW_SERVICE_NAME**
Questo file definisce le impostazioni di visualizzazione e rendering dei dati meteo-marini. È possibile configurare:
- le aree di interesse.
- altre impostazioni di GrADS per generare i meteogrammi e le mappe di swh tra cui:
  * La palette dei colori per le variabili meteo.
  * Le unità di misura per i dati visualizzati.
  * La risoluzione della griglia e la frequenza di aggiornamento.
  * ...

### **FILELIST.ENS.$MY_NEW_SERVICE_NAME**
Questo file contiene il o i punti su cui estrarre le informazioni meteo-marine per la parte di previsione a medio termine che si basa sui dati ECMWF-ENS

### **FILELIST.DET.$MY_NEW_SERVICE_NAME**
Simile a `FILELIST.ENS`, ma dedicato ai dati deterministici ad alta risoluzione.

Dopo aver personalizzato questi file, il servizio può essere eseguito normalmente tramite:
```bash
./runall_services
```

### **send_mail.py**
Contiene gli indirizzi della lista di distribuzione del servizio. E' possibile specificare indirizzi nella variabile `send_email_to` e nella variabile `send_email_cc`. Altre modifiche sono possibili nel testo dell'oggetto e della mail. Il numero di attachment è uguale al numero di punti specificati nel file `FILELIST.DET`

Dopo aver personalizzato questi file, il servizio può essere eseguito normalmente tramite:
```bash
./runall_services
```


## Esecuzione dei Servizi

Per eseguire tutti i servizi attivi, utilizzare lo script `runall_services`:
```bash
./runall_services
```
Questo script eseguirà in sequenza tutti i servizi elencati nel file `LISTA_SERVIZI_ATTIVI` con lo stato `YES`.

## Requisiti

⚠️ **Nota Importante**: Il codice è stato sviluppato e testato specificamente per l'architettura della macchina `postmare` presente sulla intranet aziendale. Il funzionamento su altre configurazioni non è garantito e potrebbe richiedere modifiche o adattamenti.


- **Sistema Operativo**: Unix-like (ad esempio, Linux).
- **Dipendenze**: Assicurarsi di avere installato tutti i software necessari per l'esecuzione degli script e la generazione dei bollettini (GrADS, librerie Python, etc...).

## Risoluzione Problemi

TODO

## Contributi

TODO

## Licenza

Questo progetto è distribuito sotto la licenza GPL-2.0. Per maggiori dettagli, consultare il file `LICENSE` nel repository.

## Contatti

Valerio Capecchi; valcap74@gmail.com


