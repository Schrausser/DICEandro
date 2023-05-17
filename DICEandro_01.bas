! ///////////////////////////////////////////////////////////
! // DICE for Android                                      //
! // Dietmar Schrausser 2023                               //
! //                                                       //
_name$="DICE"
_ver$= "v1.5.2"
! ///////////////////////////////////////////////////////////
INCLUDE strg.inc
INCLUDE dice.inc
GR.OPEN 255,60,100,60,0,1
GR.SCREEN sx,sy
mx=sx/2:my=sy/2
GOSUB dvect
scm=-1                      % // color scheme              //
dl=5                        % // dice width and hight      //
dn=sx/21                    % // length of roll            //
dy1=sy/dl                   % // dice hight min            //
dx2=sx/dl                   % // dice width                //
dy2=dy1-dx2                 % // dice hight max            //
dxv=18                      % // dice way length           //
dcn1x=sx/(dl*2)
dcn1y=dy1-dcn1x
dcn1r=sx/(dl*12)
dre=1                       % // direction                 //
rnd_=1                      % // pseudo random generator   //
swsed=1
seed=INT(RND()*10000)       % // time seed                 //
r0=RANDOMIZE(seed)
__sd_=seed
swfl=1
fld$="dice.dat"             % // data outstream            //
vlen=10                     % // screen vector output len  //
GOSUB dialog      
! //
GR.BITMAP.CREATE         
st:                         % // main start                //
DO
 IF rnd_=1: meth$="SIGMA"
 ELSE
 meth$="System":ENDIF
 dx0=sx/20                   % // dice roll factor         //
 IF dre=-1                   % // left to right roll       //
 ELSE                        % // right to left roll       //
  dx0=2*dx0+(dxv*(dn))-dx2   % // d r factor reversed      //
 ENDIF
 GOSUB diceroll
 dicev[cntr]=rndt            % // vector                   //
 cntr=cntr+1
 DO
  GR.TOUCH2 tc2,tx2,ty2
  IF tc2:GOSUB dialog:ENDIF
  GR.TOUCH tc,tx,ty
 UNTIL tc                    % // main end                 //
UNTIL 0             
ONERROR:
swsed=1:swfl=-1:GOSUB dialog
ONBACKKEY:
GOSUB fin
END
! ///////////////////////////////////////////////////////////
! //                                          subroutines  //
dvect:
DIM dicev[10000]
cntr=1:cntr2=1
RETURN 
! //
diceroll:                    % // dice roll cycle          //
FOR i=1 TO dn  
 GR.CLS
 IF scm=1: GR.COLOR 200,0,0,0,1:ENDIF
 IF scm=-1: GR.COLOR 240,240,240,240:ENDIF
 GR.RECT dice, dx0, dy1, dx2+dx0, dy2
 GOSUB randsw
 GOSUB dicern
 IF dre=-1
  IF i>dn-5:dx0=dx0-(dxv/2):ELSE: dx0=dx0+dxv:ENDIF
 ELSE
  IF i>dn-5:dx0=dx0+(dxv/2):ELSE: dx0=dx0-dxv:ENDIF
 ENDIF
 GOSUB txt
 GOSUB vector
 GR.RENDER
 !PAUSE (1080/sx)*10      % // speed  //
NEXT
cntr2=cntr2+1
RETURN 
! //
randsw:                   % // random number calculation   //
IF rnd_=1:INCLUDE sigma.inc:rnd=CEIL(n__*6):rndt=n__*6+0.5:ELSE
rnd=RND():rndt=rnd*6+0.5:rnd=CEIL(rnd*6):ENDIF
CLIPBOARD.PUT STR$(rndt)
RETURN
! //
dicern:                   % // dice numbers                //
IF scm=1:GR.COLOR 225,255,255,255,1:ENDIF
IF scm=-1:GR.COLOR 240,255,0,0,1:ENDIF
SW.BEGIN rnd
 SW.CASE 1:GR.CIRCLE dcn, dcn1x+dx0, dcn1y, dcn1r: SW.BREAK
 SW.CASE 2
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  SW.BREAK
 SW.CASE 3
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x+dx0, dcn1y, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  SW.BREAK
 SW.CASE 4
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  SW.BREAK
 SW.CASE 5
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x+dx0, dcn1y, dcn1r
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  SW.BREAK
 SW.CASE 6
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y, dcn1r
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y, dcn1r
  GR.CIRCLE dcn, dcn1x+dcn1x/2+dx0, dcn1y+dcn1y/5, dcn1r
  GR.CIRCLE dcn, dcn1x-dcn1x/2+dx0, dcn1y-dcn1y/5, dcn1r
  SW.BREAK
SW.END
RETURN
! //
txt:                        % // text output                 //
GR.TEXT.SIZE sx/20
GR.TEXT.ALIGN 1
IF dre=1
 GOSUB coln
 GR.TEXT.DRAW tx,sx/32,sy/16,FORMAT$("%.###",rndt)
ELSE
 GR.COLOR 180,40,80,40,1
 GR.TEXT.DRAW tx,sx/8,sy/16,meth$
ENDIF
!GR.COLOR 100,30,80,30,1
GR.TEXT.ALIGN 3
IF dre=1
 GR.COLOR 180,40,80,40,1
 GR.TEXT.DRAW tx,sx-sx/8,sy/16,meth$
ELSE
 GOSUB coln
 GR.TEXT.DRAW tx,sx-sx/19,sy/16,FORMAT$("%.###",rndt)
ENDIF
GR.COLOR 60,40,80,40,1
GR.TEXT.SIZE sx/5
GR.TEXT.DRAW tx,sx-sx/8,sy-sy/16,"DICE"
RETURN 
! //
vector:    
GOSUB coln                % // random vector screen output 1 //
GR.TEXT.SIZE sx/20
GR.TEXT.ALIGN 1
IF cntr2<=vlen
 FOR j=1 TO cntr-1:GOSUB vectscr:NEXT
ELSE
 FOR j=1 TO vlen:GOSUB vectscr:NEXT
ENDIF
RETURN
! //
vectscr:                  % // random vector screen output 2 //
IF dre=1
 GR.TEXT.DRAW vc,sx/32,sy/4+j*(sy/40),FORMAT$("%.###",dicev[cntr-j])
ELSE
 GR.TEXT.ALIGN 3
 GR.TEXT.DRAW vc,sx-sx/19,sy/4+j*(sy/40),FORMAT$("%.###",dicev[cntr-j])
ENDIF
RETURN
! //
coln:                     % // color of random numbers      //
IF scm=1
 GR.COLOR 200,50,50,50,1
ELSE
 GR.COLOR 100,200,200,200,1
ENDIF
RETURN
! //
dialog:
GOSUB menu
std:
ARRAY.LOAD sel$[],o01$,o02$,o03$,o04$,o05$,o06$,o07$,"OK",_ex$+" Exit"
DIALOG.SELECT sel, sel$[],_name$+" "+_ver$+" - Options:"
SW.BEGIN sel
 SW.CASE 1:rnd_=rnd_*-1:GOSUB reset:SW.BREAK
 SW.CASE 2
  swsed=swsed*-1
  IF swsed=1:seed=INT(RND()*10000):ELSE
  INPUT "Seed... ",seed,9999:ENDIF
  r0=RANDOMIZE(seed):__sd_=seed
  SW.BREAK
 SW.CASE 3
  INPUT "F(n) Vektor m...",vlen,10
  IF vlen <0 THEN vlen =0
  IF vlen >20 THEN vlen =20
  SW.BREAK
 SW.CASE 4
  swfl=swfl*-1
  IF swfl=1
  INPUT "F(n) Vector Output File...",fld$,"dice.dat":ENDIF
  SW.BREAK
 SW.CASE 5:dre=dre*-1:  SW.BREAK
 SW.CASE 6:scm=scm*-1:  SW.BREAK
 SW.CASE 7: GOSUB reset:SW.BREAK
 SW.CASE 8:GOTO st:SW.BREAK
 SW.CASE 9:IF swfl=1:GOSUB file:ENDIF:GOSUB fin:END:SW.BREAK
SW.END
GOSUB menu
GOTO std
RETURN
! //
menu:
IF rnd_=1: o01$=smq$+"  Random: SIGMA": ENDIF
IF rnd_=-1:o01$=smq$+"  Random: System":ENDIF
IF swsed=1 :o02$="     Seed: TIME":ENDIF
IF swsed=-1:o02$=smb$+"  Seed: "+INT$(seed):ENDIF
IF dre=1:  o05$=smq$+"  Roll: Left  "+smdl$:    ENDIF
IF dre=-1: o05$=smq$+"  Roll: Right  "+smdr$:   ENDIF
IF scm=1: o06$=smq$+"  Color scheme: Black":ENDIF
IF scm=-1: o06$=smq$+"  Color scheme: White":ENDIF
IF vlen>0: o03$=smb$+"  F(n) Vector length: "+INT$(vlen):ENDIF
IF vlen<1:o03$="     F(n) Vector off":ENDIF
IF swfl=1:o04$=smb$+"  Output File:  "+fld$:ELSE
o04$="     Output File off":ENDIF
o07$="     Reset"
RETURN
! //
reset:
IF swfl=1:GOSUB file:ENDIF
ARRAY.DELETE dicev[]
IF swsed=1:seed=INT(RND()*10000):ENDIF
r0=RANDOMIZE(seed):__sd_=seed
GOSUB dvect
RETURN 
! //
file:                            % // vector file output //
TEXT.OPEN a, fld, fld$ 
GOSUB systime
GOSUB lin:GOSUB head:GOSUB lin
FOR i=1 TO cntr-1
 TEXT.WRITELN fld, FORMAT$("%.##############",dicev[i])+_tb$+INT$(ROUND(dicev[i],0))
NEXT
GOSUB lin
TEXT.WRITELN fld, meth$+" Seed: "+INT$(seed)
GOSUB bottom
TEXT.CLOSE fld
RETURN
! //
systime:
TIME Y$, M$, D$, h$, min$, sec$
RETURN
! //
head:
TEXT.WRITELN fld,_name$;" ";_ver$;_tb$;"/" +Y$+"."+M$+"."+D$+"/"+h$+":"+min$+":"+sec$+"/"
RETURN
! //
lin:
ln$=""
FOR i= 1 TO 45: ln$=ln$+"-":NEXT
TEXT.WRITELN fld, ln$
RETURN
! //
bottom:
TEXT.WRITELN fld,"-"
RETURN
! //
fin: 
CONSOLE.TITLE _name$ 
PRINT _name$+" Random Dice Roll "+ _ver$
PRINT"Copyright "+_cr$+" 2023 by Dietmar Gerald Schrausser"
PRINT "https://github.com/Schrausser/DICEandro"
RETURN
!// END //
!//
