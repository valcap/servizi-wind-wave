* grads script
* Name:         swh.gs
* Date:         20120124
* UpDate:       20150518 (valcap74@gmail.com)
* Author:       Matteo Rossi & Francesco Pasi (rossi, pasi@lamma.rete.toscana.it)
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
imagename='ts_wave'
_cap1=' ' 
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
*itau = (it-1)*_modtstep
imn = 1

**************************************************************
* Open ctl
**************************************************************
'sdfopen '_filectl

'set mpt * off'
'set grads off'
'set csmooth on'
*'set lat '_latmin' '_latmax
*'set lon '_lonmin' '_lonmax

initime(anatime)
say 'INITSTR: '_initstr

yrange.1='0 6'
yrange.2='0 12'

sogliaonda1=2.0
sogliaonda2=3.0

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
'set parea 0.6 10.55 0.8 8.0'
'set grads off'
'set tlsupp year'
'set xlab on'
'set rgb 94 200 0 0'
'set rgb 95 0 0 200'

* periodo 
'set vrange 'yrange.2
'set ylpos 0 r'
'set ylopts 1 1 0.13'
'set csmooth on'
'set cthick 12'
** medio
'set ccolor 9'
'set cmark 0'
'set cstyle 2'
'd mwp'
if (hh = 00)
'set xlopts 1 1'
'set xaxis 1 120'
'set xlevs 7 13 19 30.5 36.6 42.6 54.5 60.5 66.5 78.1 84 90.1 102 108 114'
'set xlabs 6|12|18|6|12|18|6|12|18|6|12|18|6|12|18|'
endif
if (hh = 12)
'set xlopts 1 1'
'set xaxis 1 120'
'set xlevs 1 6.3 17.3 22.9 28.2 38.8 44.2 49.7 60.4 65.85 71.25 82.15 87.7 93 103.7 109.05 114.4'
'set xlabs 12|18|6|12|18|6|12|18|6|12|18|6|12|18|6|12|18|'
endif
** picco
*'set ccolor 2'
*'set cmark 0'
*'set cstyle 5'
*'d PERPWsfc.2'
* onde
'set vrange 'yrange.1
'set ylpos 0 l'
'set ylopts 1 1 0.13'
'set csmooth on'
'set cthick 20'
** onda massima
*'set ccolor 4'
*'set cmark 0'
*'set cstyle 2'
*'d HTSGWsfc.1*1.8'
** onda significativa
'set gxout line'
'set ccolor 11'
'set cmark 0'
'set cstyle 1'
'set cthick 12'
'd swh'

* direzione wave
'set gxout vector'
'set parea 0.6 10.65 4.50 7.80'
'set ylab off'
'set xlab off'
'set frame off'
'set ccolor 95'
'set cthick 6'
'set arrowhead 0.04'
'set arrscl 0.17'
'define sx=-sin(mwd*0.01745327)'
'define sy=-cos(mwd*0.01745327)'
'd const(sx,2.5);skip(sx,2,2);sy'

* STRING
'set line 0'
'draw recf 0.90 7.51 10.35 7.9'
'set line 15'
'draw rec 0.90 7.51 10.35 7.9'
'set string 95 tl 4'
'set strsiz 0.14'
*'draw string 1.5 0.9 Wave Direction'

'set string 1 tl 6'
'set strsiz 0.14'
'draw string 5.9 0.3 '_tit2

'set line 11 1 12'
'draw line 1.05 7.7 1.5 7.7'
'draw string 1.6 7.78 Significant Wave Height [m]'

'set line 9 2 12'
'draw line 5.0 7.7 5.5 7.7'
'draw string 5.55 7.78 Mean Wave Period [s]'

* Draw string
drawstringmet(it)
'set line 0'
'draw recf 0.90 8.02 1.5 8.05'
'set strsiz 0.14'
'set string 1 tl 4 90'
'draw string 0.04 3.1 Wave Height in meters'
'draw string 10.82 3.0 Mean Wave Period in seconds'
say _dirout'/'_imagename'.png'

* Printim
'printim '_dirout'/'_imagename'.png x1180 y980 white'

* quit
'quit'
