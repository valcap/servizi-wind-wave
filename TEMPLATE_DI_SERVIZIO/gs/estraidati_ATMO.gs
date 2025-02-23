*
* Name:         estraidata4SERVICES
* Author:       Francesco Pasi (pasi@lamma.toscana.it)
* Author:       Valerio Capecchi (capecchi@lamma.toscana.it)
* Date:         20120919
* UpDate:       20250214
* feature:      calcola tutto qui poi viene formattato in seguito
*
function main(args)
         filectl = subwrd(args,1)
         locnum = subwrd(args,2)
         locnam = subwrd(args,3)
         loclon = subwrd(args,4)
         loclat = subwrd(args,5)
         lochgt = subwrd(args,6)
         fileout = subwrd(args,7)
         modstp = subwrd(args,8)

say '++++++++++++++++++++++++++++++'
say 'FILECTL: 'filectl
say 'FILEOUT:  'fileout
say 'MODSTP:  'modstp
say 'LOCNUM:  'locnum
say 'LOCNAME: 'locnam
say 'LOCLAT:  'loclat
say 'LOCLON:  'loclon
say 'LOCHGT:  'lochgt

rc = gsfallow("on")

* Open ctl
'open 'filectl

* Trovo init time e tstep
'set lat 'loclat
'set lon 'loclon
'set t last'
'q dims'
dummy=sublin(result,5)
_etime=subwrd(dummy,9)

say 'ETIME: '_etime
it=1

while (it <= _etime)
'set t 'it
'q time'
dummy=subwrd(result,3)
dummytime=getdata(dummy)

say '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
say 'TIME: 'dummytime'      IT:'it
say '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'

fmt = '%3.0f'

* VENTO 10m in nodi
scal=1.96

'd mag(UGRD10m,VGRD10m)*'scal
temp1=subwrd(result,4)
vel10=math_format(fmt,temp1)
say 'VEL10: 'vel10

temp1=winddir(UGRD10m,VGRD10m)
dir10=math_format(fmt,temp1)
say 'DIR10: 'dir10

dir10cl=winddircl(UGRD10m,VGRD10m)
say 'DIR10CL: 'dir10cl

* VENTO 50m in nodi
scal=1.96
'define U=UGRD50m'
'define V=VGRD50m'
'd mag(U,V)*'scal
temp1=subwrd(result,4)
vel50=math_format(fmt,temp1)
say 'VEL50: 'vel50

temp1=winddir(U,V)
dir50=math_format(fmt,temp1)
say 'DIR50: 'dir50

dir50cl=winddircl(U,V)
say 'DIR50CL: 'dir50cl

* GUST 10m in nodi
scal=1.96
'd GUST10m*'scal
temp1=subwrd(result,4)
g10=math_format(fmt,temp1)
say 'G10: 'g10

* TMP2m -- CON CORREZIONE IN BASE ALLA QUOTA!
'define t2m=TMP2m-273.3'
'd t2m'
temp1=subwrd(result,4)
t2m=math_format(fmt,temp1)
say 'T2: 't2m

* TotalCloud -- in octa 
'd TCDCsfc'
temp1=subwrd(result,4)
tc=math_format(fmt,temp1)
say 'TOTALCLOUD: 'tc

* PCP -- in octa 
'd APCPsfc'
temp1=subwrd(result,4)
pcp=math_format(fmt,temp1)
say 'PCP: 'pcp

* WRITE
if (it=1)
  res=write(fileout,'Time(UTC);v10(kt);v10dir(deg);v10dir(cl);v50(kt);v50dir(deg);v50dir(cl);gust10(kt);t2m(C);totalcloud(%);pcp(mm/1hr)')
endif
res=write(fileout,dummytime';'vel10';'dir10';'dir10cl';'vel50';'dir50';'dir50cl';'g10';'t2m';'tc';'pcp,append)

it = it + 1

endwhile

'quit'

**************************************************************************
* FUNCTION getdata
**************************************************************************

function getdata(var)

leadn=zellerday(var)
leadh=substr(var,1,2)
leadd=substr(var,4,2)
leadm=substr(var,6,3)
leady=substr(var,9,5)
  if leadm = "JAN"; leadm = 01; endif
  if leadm = "FEB"; leadm = 02; endif
  if leadm = "MAR"; leadm = 03; endif
  if leadm = "APR"; leadm = 04; endif
  if leadm = "MAY"; leadm = 05; endif
  if leadm = "JUN"; leadm = 06; endif
  if leadm = "JUL"; leadm = 07; endif
  if leadm = "AUG"; leadm = 08; endif
  if leadm = "SEP"; leadm = 09; endif
  if leadm = "OCT"; leadm = 10; endif
  if leadm = "NOV"; leadm = 11; endif
  if leadm = "DEC"; leadm = 12; endif
*  datestr=leadh'Z'leadd%leadm%leady
  datestr=leadn','leadd'-'leadm' 'leadh
return datestr
***************************************************************************
function classtempo(tc,lc,mc,hc,pcp,snow)
* coperto o velato
  if (tc>=80);tempo='coperto';endif
  if (tc>=80 & mc<=30 & lc<=30);tempo='stratificata2';endif
* nuvoloso o sereno
  if (tc>50 & tc<80);tempo='nuvoloso';endif
  if (tc>50 & tc<80 & mc<=30 & lc<=30);tempo='sereno';endif
* poconuvoloso o sereno
  if (tc>30 & tc<=50);tempo='poconuvoloso';endif
  if (tc>30 & tc<=50 & mc<=30 & lc<=30);tempo='sereno';endif
* sereno
  if (tc<=30);tempo='sereno';endif

  if (pcp>0.5)
    if (pcp>5);tempo='pioggiadebole';endif
    if (2<=pcp<5);tempo='pioggiadebole1';endif
    if (pcp<2);tempo='pioggiasole3';endif
  endif

  if (snow>0.5)
    if (snow>2);tempo='neve';endif
    if (snow<=2);tempo='nevedebole';endif
  endif
return (tempo)

**************************************************************************
* FUNCTION getwinddir
**************************************************************************
function winddir(u,v)
DperR=57.29578
RperD=0.01745329
'd (180+atan2('u','v')*'DperR')'
temp=subwrd(result,4)
dir=math_fmod(temp,360)
return(dir)

function winddircl(u,v)
DperR=57.29578
RperD=0.01745329
'd (180+atan2('u','v')*'DperR')'
temp=subwrd(result,4)
dir=math_fmod(temp,360)
angle=22.5
*if(dir>=360-angle);dirclass='N';endif
*if(dir<0+angle);dirclass='N';endif
if(dir>=360-angle | dir<angle);dircl='N';endif
if(dir>=45-angle & dir<45+angle);dircl='NE';endif
if(dir>=90-angle & dir<90+angle);dircl='E';endif
if(dir>=135-angle & dir<135+angle);dircl='SE';endif
if(dir>=180-angle & dir<180+angle);dircl='S';endif
if(dir>=225-angle & dir<225+angle);dircl='SW';endif
if(dir>=270-angle & dir<270+angle);dircl='W';endif
if(dir>=315-angle & dir<315+angle);dircl='NW';endif
return(dircl)

* FUNCTION classwind
function windspdcl(var)
if(var<10);vv='0';endif
if(var>=10 & var<20);vv='1';endif
if(var>=20 & var<40);vv='2';endif
if(var>=40 & var<60);vv='3';endif
if(var>=60);vv='4';endif
return(vv)

**************************************************************************
* FUNCTION getwindclass
**************************************************************************
function getwindclass(var,dir)
if (var<4); dircl='calm'; endif
if (var>=4 & var<8); dircl='5'; endif
if (var>=8 & var<13); dircl='10'; endif
if (var>=13 & var<18); dircl='15'; endif
if (var>=18 & var<23); dircl='20'; endif
if (var>=23 & var<28); dircl='25'; endif
if (var>=28 & var<33); dircl='30'; endif
if (var>=33 & var<38); dircl='35'; endif
if (var>=38 & var<43); dircl='40'; endif
if (var>=43 & var<48); dircl='45'; endif
if (var>=48 & var<53); dircl='50'; endif
return(dircl)

**************************************************************************
* FUNCTION getclgust
**************************************************************************
function getclgust(var,dir)
if (var<20); dircl='0'; endif
if (var>=20 & var<40); dircl='1'; endif
if (var>=40 & var<60); dircl='2'; endif
if (var>=60 & var<80); dircl='3'; endif
if (var>=80); dircl='4'; endif
return(dircl)


**************************************************************************
* FUNCTION getwindforce
**************************************************************************
function getwindforce(var,force)
if (var<1); force='0'; endif
if (var>=1 & var<3); force='1'; endif
if (var>=3 & var<6); force='2'; endif
if (var>=6 & var<10); force='3'; endif
if (var>=10 & var<16); force='4'; endif
if (var>=16 & var<21); force='5'; endif
if (var>=21 & var<27); force='6'; endif
if (var>=27 & var<33); force='7'; endif
if (var>=33 & var<40); force='8'; endif
if (var>=40 & var<47); force='9'; endif
if (var>=47 & var<55); force='10'; endif
return(force)

**************************************************************************
* FUNCTION getseaclass
**************************************************************************
function getseaclass(var,class)
if (var<=0.1); class='calmo'; endif
if (var>0.1 & var<=0.5); class='poco_mosso'; endif
if (var>0.5 & var<=1.25); class='mosso'; endif
if (var>1.25 & var<=2.5); class='molto_mosso'; endif
if (var>2.5 & var<=4); class='agitato'; endif
if (var>4 & var<=6); class='molto_agitato'; endif
if (var>6 & var<=9); class='grosso'; endif
return(class)

function classrh2m(var)
if (var<=14); class=10; endif
if (var>14 & var<=24); class=20; endif
if (var>24 & var<=34); class=30; endif
if (var>34 & var<=44); class=40; endif
if (var>44 & var<=54); class=50; endif
if (var>54 & var<=64); class=60; endif
if (var>64 & var<=74); class=70; endif
if (var>74 & var<=84); class=80; endif
if (var>84 & var<=94); class=90; endif
if (var>94 & var<=97); class=95; endif
if (var=98); class=98; endif
if (var=99); class=99; endif
if (var>=100); class=100; endif
return(class)


