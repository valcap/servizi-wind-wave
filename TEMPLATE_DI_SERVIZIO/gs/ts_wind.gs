* grads script
* Name:         ts_wind.gs
* Date:         20120124
* UpDate:       20150518 (valcap74@gmail.com)
* UpDate:       20250217 (valcap74@gmail.com)
*               _filectl NON \'e letto da readconf
*               ma \'e un argomento in input
* Authors:      Rossi & Pasi & Capecchi ({capecchi,rossi,pasi}@lamma.rete.toscana.it)
*
* Internal conf par
*
function main(args)
         _filectl = subwrd(args,1)
         fileconf = subwrd(args,2)
         hh = subwrd(args,3)
         _namestn = subwrd(args,4)
         _codestn = subwrd(args,5)
         _latstn = subwrd(args,6)
         _lonstn = subwrd(args,7)
         _area = subwrd(args,8)
**************************************************************
* !!!! Check these parameter!!!!
**************************************************************
imagename='ts_wind'
_imagename=imagename'.'_codestn
**************************************************************
* Reading config
**************************************************************
rc = gsfallow("on")

readconf(fileconf' 'hh' '_area)

**************************************************************
* local settings
**************************************************************
gstep = 1
anatime = 1
it = 1
itau = (it-1)*_modtstep
imn = 1

**************************************************************
* Open ctl
**************************************************************
*'sdfopen '_filectl
'open '_filectl

'set mpt * off'
'set grads off'
'set csmooth on'

initime(anatime)
say 'INITSTR: '_initstr

yrange.1='0 50'
yrange.2='0 12'
soglia1=2.0
soglia2=3.0
sfactor=1.85

* inizio ciclo sul tempo
if (hh = 00)
  'set t 1 121'
else
  'set t 1 last'
endif
'set lat '_latstn
'set lon '_lonstn
'set z 1'

*****************************************************
* Display var
*****************************************************
'set parea 0.6 10.6 0.8 8.0'
'set grads off'
'set tlsupp year'
'set xlab on'
'set rgb 94 200 0 0'
'set rgb 95 0 0 200'

* Vento in kt
scale=1.94
'define gust=GUST10m*'scale
'define vx=UGRD10m*'scale
'define vy=VGRD10m*'scale


* vento nodi
'set vrange 'yrange.1
'set ylpos 0 l'
'set ylopts 1 3 0.13'
'set xlopts 1 6'
'set csmooth on'
'set cthick 12'
'set ccolor 4'
'set cmark 0'
'set cstyle 1'
'd mag(vx,vy)'
if (hh = 00)
'set xlopts 1 1'
'set xaxis 1 120'
'set xlevs 7 13 19 30.5 36.6 42.6 54.5 60.5 66.5 78.1 84 90.1 102 108 114'
'set xlabs 6|12|18|6|12|18|6|12|18|6|12|18|6|12|18|'
endif
if (hh = 12)
'set xlopts 1 1'
'set xlopts 1 1'
'set xaxis 1 120'
'set xlevs 1 6.3 17.3 22.9 28.2 38.8 44.2 49.7 60.4 65.85 71.25 82.15 87.7 93 103.7 109.05 114.4'
'set xlabs 12|18|6|12|18|6|12|18|6|12|18|6|12|18|6|12|18|'
endif
* raffica
'set gxout line'
'set ccolor 2'
'set cthick 12'
'set cmark 0'
'set cstyle 2'
'd gust'

* direzione vento
'set gxout vector'
'set parea 0.6 10.65 4.50 7.80'
'set ylab off'
'set xlab off'
'set frame off'
'set ccolor 95'
'set cthick 6'
'set arrowhead 0.04'
'set arrscl 0.17'
'd const(vx,20.5);skip(vx,2,2);vy'

'set line 0'
'draw recf 0.90 7.51 10.35 7.9'
'set line 15'
'draw rec 0.90 7.51 10.35 7.9'
'set string 95 tl 4'
'set strsiz 0.14'

'set string 1 tl 6'
'set strsiz 0.14'
'draw string 5.9 0.3 '_tit2

'set string 1 tl 4'
'set strsiz 0.12'
'set line 95 1 12'
'draw line 1.05 7.7 1.5 7.7'
'draw string 1.6 7.78 10m WindSpeed (kt)'
'set line 2 2 12'
'draw line 4.0 7.7 4.55 7.7'
'draw string 4.6 7.78 10m WindGust (kt)'

* Draw string
drawstringmet(it)

'set line 0'
'draw recf 0.90 8.02 1.5 8.05'
'set strsiz 0.14'
'set string 1 tl 4 90'
'draw string 0.04 3.1 Wind Speed in knots'

* Printim
'printim '_dirout'/'_imagename'.png x1180 y980 white'

'quit'
