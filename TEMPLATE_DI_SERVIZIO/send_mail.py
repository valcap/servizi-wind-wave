import smtplib
import mimetypes
import email.utils
from email.encoders import encode_base64
from email.mime.base import MIMEBase
from email.mime.image import MIMEImage
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# rileva il path ed il  nome del file da inviare
import sys
import os
# Controllo sugli argomenti
if len(sys.argv) < 3:
    print("Errore: devi specificare NAME_OF_SERVICE e rundate.")
    sys.exit(1)
NAME_OF_SERVICE=sys.argv[1]
rundate=sys.argv[2]
bollettini_path = '/home/meteop/www/img/SERVICES/' + NAME_OF_SERVICE + '/'
filelist = '/home/meteop/scripts/services/' + NAME_OF_SERVICE + '/env/FILELIST.DET'
if not os.path.exists(filelist):
    print("Errore: il file " + filelist + ' non esiste')
    sys.exit(1)

# utente(i) a cui inviare l'email
# TO
send_email_to = "meteo@lamma.toscana.it"
send_email_to += ",NOME.COGNOME@INDIRIZZO"
# CC
send_email_cc = "capecchi@lamma.toscana.it"
send_email_cc += ",pasi@lamma.toscana.it"
send_email_cc += ",gozzini@lamma.toscana.it"
send_email_cc += ",tei@lamma.toscana.it"
send_email_cc += ",rossi@lamma.toscana.it"


#########################
# BOH
def getAttachment(path, filename):
    ctype, encoding = mimetypes.guess_type(path)
    if ctype is None or encoding is not None:
        ctype = 'application/octet-stream'
    maintype, subtype = ctype.split('/', 1)
    fp = open(path, 'rb')
    if maintype == 'text':
        attach = MIMEText(fp.read(),_subtype=subtype)
    else:
        attach = MIMEBase(maintype, subtype)
        attach.set_payload(fp.read())
        encode_base64(attach)
    fp.close
    attach.add_header('Content-Disposition', 'attachment', filename=filename)
    return attach

def SendMail():

#########################
# This is the header part
    COMMASPACE = ', '
msg = MIMEMultipart()   
msg['Subject'] = NAME_OF_SERVICE + ' - LaMMA Weather Forecast'
msg['From'] = email.utils.formataddr(('Consorzio LaMMA - Meteo', 'meteo@lamma.toscana.it'))
me = "meteo@lamma.toscana.it"
to = send_email_to
cc = send_email_cc
rcpt = cc.split(",") + to.split(",")
msg['To'] = to
msg['Cc'] = cc

#########################
# This is the textual part:
part = MIMEText("Please find attached the wave-weather forecast for the point of interest. \n\n\n  Best regards, Meteo Staff \n  LaMMA Consortium - www.lamma.toscana.it ")
msg.attach(part)

#########################
# This is the attachment part
with open(filelist, "r") as file:
    for line in file:
        parts = line.strip().split("\t")  # Divide la riga in base ai tab
        if len(parts) >= 5:
            index = parts[0]
            name = parts[1]
            lon = float(parts[2])
            lat = float(parts[3])
            value = int(parts[4])
            bollettini_fname = 'Forecast_Lamma_' + rundate + '_'+ index +'.pdf'
            print('Adding ' + bollettini_fname + ' (codice ' + index + ') as email attachment')
            part = MIMEApplication(open(bollettini_path + bollettini_fname, "rb").read())
            part.add_header('Content-Disposition', 'attachment', filename=bollettini_fname)
            msg.attach(part)

#########################
# Spedisce la mail    
server = smtplib.SMTP("172.16.1.2", 25)
server.starttls()
server.ehlo()
server.login("meteo", "Vmy!!eehKU")
server.sendmail(me, rcpt, msg.as_string())
server.quit()

print ("SentMail")
