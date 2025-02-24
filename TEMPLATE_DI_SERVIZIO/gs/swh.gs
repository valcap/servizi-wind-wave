* grads script
* Name:         wind.gs
* Date:         20161024
* Author:       Francesco Pasi (pasi@lamma.rete.toscana.it)
*
* Internal conf par
*

function main(args)
         _filectl = subwrd(args,1)
         fileconf = subwrd(args,2)
         hh = subwrd(args,3)
         area = subwrd(args,4)
         filelist = subwrd(args,5)

**************************************************************
* !!!! Check these parameter!!!!
**************************************************************
imagename='swh.'area
_cap1='Significant Wave Height [m] + Mean Wave Direction'
**************************************************************
* Reading config
**************************************************************
rc = gsfallow("on")

readconf(fileconf' 'hh' 'area)

**************************************************************
* local settings
**************************************************************
gstep = 12
anatime = 1
it = 1
itau = (it-1)
imn = 1
**************************************************************
*   end of file conf
**************************************************************
say "+++++++++++++++++++++++++++++++++++"
say 'IMAGENAME: '   imagename
say "+++++++++++++++++++++++++++++++++++"
**************************************************************
* Open ctl
**************************************************************
'sdfopen '_filectl

'set mpt * off'
'set parea '_paxmin' '_paxmax' '_paymin' '_paymax
'set grads off'
'set csmooth on'
'set lat '_latmin' '_latmax 
'set lon '_lonmin' '_lonmax 

* Init time e tstep
initime(anatime)
say 'INITSTR: '_initstr

* TIME LOOP
while (it <= _etime)
'set t 'it
'set grads off'
_tauh = itau'h'
* lead time
leadtime(it)
_inittstr = _initstr
say 'LEADTIME: '_leadstr
say 'TAU: '_tauh

* DRAW VARIABLES
'set gxout shaded'
'run '_dirleg'/colori_swh.gs'
'vrbot = boterp(SWH,9.999E+20,5)'
'd vrbot'
'run '_dirleg'/cbarn_douglas_VM.gs '_cbarnd' '_cbarnvo' '_cbarnx' '_cbarny

* Overplot wave direction
'set gxout vector'
'set ccolor 1'
'set arrscl '_arrscl
'set cthick 2'
'define wx=-SWH*sin(MWD*0.01745327)'
'define wy=-SWH*cos(MWD*0.01745327)'
'd skip(wx,'_uskp','_vskp');wy'

* draw map
drawshp(area)

* drawloc
drawloc

* draw rotta nave
'set line 1 1 14'
'draw shp $HOME/grads/shp/WTYL-PTO-line'

* draw punti d'interesse
drawpoint(filelist)

* Draw string
drawstring(it)

* Printim
makeimg(imagename' 'imn)

c
it = it + gstep
imn = imn + 1
itau = itau + gstep
endwhile
'quit'
