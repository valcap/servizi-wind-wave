
*function main(args)
*         _mylon = subwrd(args,1)
*         _mylat = subwrd(args,2)
*         _mynam = subwrd(args,3)
*         _myrun = subwrd(args,4)
*
** Parse input arguments
*if (_mylon='')
*  say "ops input longitude"
*  say "Usage:"
*  say "grads -blc this_script 11.00 43.80 PIPPO 00"
*  'quit'
*endif
*if (_mylat='')
*  say "ops input latitude"
*  say "Usage:"
*  say "grads -blc this_script 11.00 43.80 PIPPO 00"
*  'quit'
*endif
*if (_mylnam='')
*  say "ops input name"
*  say "Usage:"
*  say "grads -blc this_script 11.00 43.80 PIPPO 00"
*  'quit'
*endif
*if (_mylrun='')
*  say "ops input run"
*  say "Usage:"
*  say "grads -blc this_script 11.00 43.80 PIPPO 00"
*  'quit'
*endif

* User defined function
rc=gsfallow("on")

****************
* Open file
'reinit'
_myrun='MYRUN'
'open ecmens_opendata.'_myrun'z.grb2.ctl'
****************

****************
* Set dimensions
_mylon='loclon'
_mylat='loclat'
_mynam='locnam'
_myendtime=16
'set lon '_mylon
'set lat '_mylat
'q dims'
line=sublin(result,2)
cminlon=subwrd(line,6)
cmaxlon=subwrd(line,8)
line=sublin(result,3)
cminlat=subwrd(line,6)
cmaxlat=subwrd(line,8)
'set e last'
line=sublin(result,1)
eend=subwrd(line,4)
'set e 1'
line=sublin(result,1)
eini=subwrd(line,4)
'set t last'
'q dims'
line=sublin(result,5)
tend=subwrd(line,9)
'set t 1'
initime_ens(-_myendtime)
say 'Init date and time is: '_initstr
****************

********************************************************************************
* Significant Height
* HTSGWsfc   0  10,0,3   ** mean sea level Significant Height of Combined Wind Waves and Swell [m]
********************************************************************************

****************
* General stuff
'set grid off'
'set grads off'
'set parea 0.5 10.7 4 8.0'
'set tlsupp year'
_mycol=11
_my_errbarcol=1
_my_barcol=15
****************

* Time and general settings
'set t 1 '_myendtime
'set gxout line'
'set vrange 0 6'
* Variables
'define myave = ave(HTSGWsfc,e='eini',e='eend')'
'define mymin = min(HTSGWsfc,e='eini',e='eend')'
'define mymax = max(HTSGWsfc,e='eini',e='eend')'
'define mystd = sqrt((ave(pow(HTSGWsfc-myave,2),e='eini',e='eend')))'
* Time again
'set t 0.5 'tend+0.5

* draw bars centered on the mean, spanning the range from plus/minus 1 standard deviaton
'set gxout bar'
* in percentage 0..100
'set bargap 20'
* filled/outline
'set baropts filled'
'set ccolor '_my_barcol
*'d myave-mystd/2;myave+mystd/2'
'd myave-mystd;myave+mystd'
* draw error bars spanning the range from the min/max values
'set gxout errbar'
'set ccolor '_my_errbarcol
'd mymin;mymax'
* draw yellow line showing the mean values 
'set gxout line'
'set ccolor '_mycol
'set cmark 0'
'set cthick 12'
'set cstyle 1'
'd myave'
'set cthick 4'

*
'set line 0'
'draw rec 0.8 7.56 10 7.9'
'set line 15'
'draw rec 0.8 7.56 10 7.9'
'set string 1 tl 6'
'set strsiz 0.14'
'set line '_mycol' 1 12'
'draw line 1.05 7.7 1.5 7.7'
'draw string 1.6 7.78 Significant Wave Height [m] (ensemble mean)'
'set line 15 1 4'
'set ccolor 15'
'draw recf 6.95 7.6 7.25 7.8'
'draw string 7.3 7.78 Dev Std'
'set line 1 1 4'
'draw line 8.3 7.6 8.4 7.6'
'draw line 8.3 7.8 8.4 7.8'
'draw line 8.35 7.6 8.35 7.8'
'draw string 8.50 7.78 Min/Max'

********************************************************************************
* Mean Period
* MWSPERsfc  0  10,0,15  ** mean sea level Mean Period of Combined Wind Waves and Swell [s]
********************************************************************************

****************
* General stuff
'set grid off'
'set grads off'
'set parea 0.5 10.7 0.5 3.75'
_mycol=9
_my_errbarcol=1
_my_barcol=15
****************

* Time and general settings
'set t 1 '_myendtime
'set gxout line'
'set vrange 0 12'
* Variables
'define myave = ave(MWSPERsfc,e='eini',e='eend')'
'define mymin = min(MWSPERsfc,e='eini',e='eend')'
'define mymax = max(MWSPERsfc,e='eini',e='eend')'
'define mystd = sqrt((ave(pow(MWSPERsfc-myave,2),e='eini',e='eend')))'
* Time again
'set t 0.5 'tend+0.5

* draw bars centered on the mean, spanning the range from plus/minus 1 standard deviaton
'set gxout bar'
'set ccolor '_my_barcol
'set bargap 20'
'set baropts filled'
*'d myave-mystd/2;myave+mystd/2'
'd myave-mystd;myave+mystd'
* draw error bars spanning the range from the min/max values
'set gxout errbar'
'set ccolor '_my_errbarcol
'd mymin;mymax'
* draw yellow line showing the mean values 
'set gxout line'
'set ccolor '_mycol
'set cmark 0'
'set cthick 12'
'set cstyle 2'
'd myave'
'set cthick 4'

*
'set line 0'
'draw rec 0.8 3.35 10 3.7'
'set line 15'
'draw rec 0.8 3.35 10 3.7'
'set string 1 tl 6'
'set strsiz 0.14'
'set line '_mycol' 2 12'
'draw line 1.0 3.5 1.5 3.5'
'draw string 1.55 3.58 Mean Wave Period [s] (ensemble mean)'
'set line 15 1 4'
'set ccolor 15'
'draw recf 6.95 3.4 7.25 3.6'
'draw string 7.3 3.58 Dev Std'
'set line 1 1 4'
'draw line 8.3  3.4    8.4  3.4'
'draw line 8.3  3.6    8.4  3.6'
'draw line 8.35 3.4    8.35 3.6'
'draw string 8.50 3.58 Min/Max'

********************************************************************************
* title
'set string 1 tl 8'
'set strsiz 0.14'
'set string 4 tl 8'
'draw string 0.5 8.20 '_mynam
'set string 1 tl 8'
'draw string 3 8.20 Lat='_mylat' Lon='_mylon'  Init. Time:'
'set string 4 tl 8'
'draw string 6.9 8.20 '_initstr
'set string 1 tl 8'
'draw string 6 0.25 ECMWF ensemble - res 0.25 deg'

* y labels
'set line 0'
'draw recf 0.90 8.02 1.5 8.05'
'set strsiz 0.14'
'set string 1 tl 4 90'
'draw string 0.04 4.4 Significant Wave Height [m]'
'draw string 0.04 1.0 Mean Wave Period [s]'

* Save plot
'printim FILEOUT x1180 y980 white'

'quit'

