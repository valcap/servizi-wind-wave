* draw punti d'interesse
il=0
while (il < 100)
  ret=read('/home/meteop/scripts/etc/FILELIST/FILELIST.GEOSOLUTIONS');err=sublin(ret,1)
  if err=2
    ile=il
    break
  endif
  il=il+1
endwhile
ret=close('/home/meteop/scripts/etc/FILELIST/FILELIST.GEOSOLUTIONS');err=sublin(ret,1)


il=0
while (il < ile)
  ret=read('/home/meteop/scripts/etc/FILELIST/FILELIST.GEOSOLUTIONS');tmp=sublin(ret,2)
  prog=subwrd(tmp,1)
  locname=subwrd(tmp,2)
  mlon=subwrd(tmp,3)
  mlat=subwrd(tmp,4)
  'q w2xy 'mlon' 'mlat
  mxp=subwrd(result,3)
  myp=subwrd(result,6)
  'set string 1 bl 1'
  'set strsiz 0.12'
  'draw mark 1 'mxp' 'myp' 0.15'
  'draw string 'mxp+0.1' 'myp+0.1' 'locname
  il = il +1
endwhile

