include<ub.scad>; //⇒ v.gd/ubaer or https://github.com/UBaer21/UB.scad
/*[Hidden]*/
designVersion="3.1";
designer="Ulrich Bär";
license="CC0";
useVersion=22.333;//(sites.google.com/site/ulrichbaer)
assert(Version>=useVersion,str("lib version ",Version," detected, install ",useVersion," ub.scad library‼ ⇒http://v.gd/ubaer"));
/*[Basics]*/
nozzle=.2;
bed=false;
pPos=[0,0];
info=false;
name=undef;

/*[GT2Spanner]*/

through=false;


connector=false;
connector2=false;
connector3=false;

con=connector||connector2||connector3?true:false;
screw=true;
nut=true;
swivel=true;

if (connector3)T(printPos)GT2Connect(opt=3,dist=[0,7],side=0);
if (connector3)T(printPos)T(y=20)GT2Connect(opt=3,dist=[10,0],side=1);
if (connector3)T(printPos)T(y=15)mirror([0,0,0])GT2Connect(opt=3,dist=[10,0],side=0);
if (connector3)T(printPos)T(y=-15)mirror([0,+0,0])GT2Connect(opt=3,dist=[10,7],side=0);

if (connector2)T(printPos)GT2Connect(opt=2);
if (connector2)T(printPos)T(y=10)mirror([0,1,0])GT2Connect(opt=2);

if (connector)T(printPos)GT2Connect(opt=0);
if (connector)T(printPos)T(y=10)mirror([0,1,0])GT2Connect(opt=0);
if (connector)T(printPos)T(y=-10)GT2Connect(opt=1);

 
if (nut&&!con)    T(printPos) Cut(t=-20,ghost=false)T(x=-20)PrevPos(t=[12],rot=[0,90,0])rotate(180)Mutter();

if (screw&&!con)  T(printPos) Cut(t=-20,ghost=false)GewindeEinsatz(opt=0);
if (screw&&!con)  T(printPos) Cut(t=-20,ghost=false)PrevPos(t=-20)R(180)T(20)GewindeEinsatz(opt=1);

if (swivel&&!con) T(printPos) PrevPos(t=[-3.5,-20],rot=[0,180,180])T(y=-20)DrehWirbel();
if (swivel&&!con) T(printPos) Cut(t=-20,ghost=false)T(y=20)PrevPos(t=[-3.5,-20],rot=[0,0,0])R(180)mirror([0,0,1])DrehWirbel();


// swivel for screws
*if (swivel&&!con) T(printPos) PrevPos(t=[-3.5,0],rot=[0,-90])DrehWirbel(opt=2,screw=3.5);
*if (swivel&&!con) T(printPos) PrevPos(t=[-3.5,0,-2.5],rot=[0,0])!DrehWirbel(opt=3,screw=3.5);





if (swivel&&!con) T(printPos) Cut(t=-20,ghost=false)T(-20,20)PrevPos(t=[10 -3.5,-20],rot=[0,90])DrehWirbel(opt=1);//ring
 
 module Mutter(dn=12,h=15,rand=2,d=8.5){
 boden=2;
 Tz(boden+3)Gewinde(p=1,dn=dn,innen=true,h=h-3-boden);
   difference(){
      Pille(l=h,d=dn+rand*2,rad=1,center=false,);
      Tz(h/2)Polar(round(dn),-dn/2-rand)LinEx(h=h-5,center=true,end=true,lap=.001)Vollwelle(r=0.2,1.5,xCenter=-1,extrude=0,x0=-5);
      Tz(boden)Loch(h=h-2,h2=[0,.5],rad=0,l=0,extrude=[0,1],d=dn+.1,cuts=false);
      Loch(h=boden,h2=[0.5,.25],rad=0,l=0,d=d,cuts=false);
   }
   Tz(boden)VarioFill(.5,dia=-dn-spiel*2);
 }
 
 
 module GewindeEinsatz(dn=12,h=10,rand=2,opt=0,through=through){
 h2=5.5;
 beltH=6.5;
  difference(){
    R(0,90)union(){
      Tz(h)Pille(l=h2,d=dn+rand*2,rad=1,center=false,);
      Gewinde(p=1,dn=dn-spiel*2,innen=false,h=h,wand=0,center=false);
    }
    R(0,90)Tz(h+h2/2)Polar(round(dn),-dn/2-rand)LinEx(h=h2-5,center=true,end=true,lap=.001)Vollwelle(r=0.2,1.5,xCenter=-1,extrude=0,x0=-5);
   T(h+h2/ 2)MKlon(ty=dn/3){
      cylinder(10,d=2,$fn=0,center=true); // register holes
      R(opt?180:0)Tz(-.001)Kegel(d1=2.5,d2=1);
      }
   
   T(through?0:1.15+.5)mirror([0,0,opt?1:0])Tz(-.01)LinEx(beltH/2,1,0,scale=[1,1.25],center=false)GT(z=(h+h2)/2 +2,pulley=false,spielO=-0.15);
   R(opt?0:180)cylinder(50,d=50,$fn=6);
   }
 }
 
 
 module DrehWirbel(dn=12,h=10,rand=2,d=8,opt=0,through=through,screw=3.5){
 id=dn-1.5;
 beltH=6.5;
 ringH=5;
  if(opt==0)rotate(180)difference(){
    R(0,90){
      Pille(center=false,d=d,l=h,rad=[0,1],fn=fn);
      Tz(2)VarioFill(.5,dia=d);
      Pille(center=false,d=id,l=2,rad=.5);
    }
    T(through?0:2.35)Tz(-.01)LinEx(beltH/2,1,0,scale=[1,1.25],center=false)GT(z=(h)/2 +2,pulley=false,spielO=-0.15);
    R(0,90)Tz(h-ringH/2)RotEx()Vollwelle(r=.3,r2=.2,xCenter=-1,extrude=-d/2,x0=-d);
    R(0,90)Tz(h) Polar(4,d/2,rot=45)LinEx(h,end=true,center=true)Vollwelle(r=-.5,xCenter=-1,extrude=0,x0=1);
   R(180)cylinder(50,d=50,$fn=6);
   }
   
  if(opt==2)rotate(180)difference(){ //screw axial
  h=5;
    union(){
      Pille(center=false,d=d,l=h,rad=[0,.5],fn=fn);
      Tz(2)VarioFill(.5,dia=d);
      Pille(center=false,d=id,l=2,rad=.5); // rim
    }
    Loch(h,h2=[1,.5],d=screw,d2=[min(screw+3,id-2),undef],rad=1);
   }
   
 if(opt==3)rotate(180)difference(){ //screw vertical
  h=15;
  z=6;
    Tz(z/2)R(90)intersection(){union(){
      Pille(center=false,d=d,l=h,rad=[0,.5],fn=fn);
      Tz(2)VarioFill(.5,dia=d);
      Pille(center=false,d=id,l=2,rad=.5); // rim
    }
    cube([500,z,500],true);
    }
    T(y=-h/1.5)Loch(z,h2=[.5,1],d=screw,d2=[undef,min(screw+2,id-2)],rad=1);
   }    
   
 
  if(opt==1)difference(){ //ring
    Pille(center=false,d=dn+rand*2,l=ringH,rad=1,fn=fn);
    Tz(ringH/2)Polar(round(dn),-dn/2-rand)LinEx(h=ringH-4.5,center=true,end=true,lap=.001)Vollwelle(r=0.2,1.5,xCenter=-1,extrude=0,x0=-5);
    difference(){ // grooves & hole
      Loch(h=ringH,h2=.5,l=0,rad=1,d=d+spiel*2,cuts=false);
      Tz(ringH/2)Polar(4,d/2+spiel,rot=45)LinEx(2,end=true,center=true)Vollwelle(r=-.5,xCenter=-1,extrude=0,x0=1);
      Tz(ringH/2)RotEx()Vollwelle(r=.2,r2=.3,xCenter=-1,extrude=-d/2-spiel,x0=-d);
    }
  }
 
 }
 
 module GT2Connect(z=10,h=6.5/2,opt=0,rand=.6,d=3+spiel*2,dist=[0,0],side){
 
 base=1;
 s=h+base;
 sy=s;
  if(opt==0)difference(){
    Prisma(z*2,sy,s,rad=.5,r=sy/3);
    Tz(base)LinEx(h+.01,0,1,scale=[1,1.15])MKlon(tx=2)GT(z=z +2,pulley=false,spielO=-0.15);
    Tz(s)MKlon(my=1)rotate(90)LinEx(s,end=true,center=true)Vollwelle(r=-.35,extrude=s/2,xCenter=-1,x0=s/2+rand);
  }
  if(opt==1){
    Roof(z*1.5,rand/3*[1,1])Rand(rand)Quad(s*2+spiel*2,sy+spiel*2,rad=.5+spiel);
    Tz(z*.75)MKlon(my=1)R(90,0,90)LinEx(s-1,end=true,center=true)Vollwelle(r=-.35,extrude=sy/2+spiel,xCenter=-1,x0=sy/2+rand);
    LinEx(l(1))Rand(2)offset(rand)Quad(s*2+spiel*2,sy+spiel*2,rad=.5+spiel);
  }
  if(opt==2){
    *T(d/2+1)difference(){
      Prisma(z,sy,s,rad=.5,r=sy/3*[0.1,1,1,.1],center=[0,1]);
      Tz(base)T(2)LinEx(h+.01,0,1,scale=[1,1.15])GT(z=z +2,pulley=false,spielO=-0.15);
    } 
   difference(){
    Roof(s,[.25,0.15])difference(){
      Rund(0,5)union(){
        Kreis(d=d +3);
        Quad(d/2+z +2,sy,center=[0,1],r=sy/3);
      }
      Kreis(d=d);
      }
    Tz(base)T(d/2+2)LinEx(h+.01,0,1,scale=[1,1.15])GT(z=z +2,pulley=false,spielO=-0.15);
   }
  } 
  
  if(opt==3){
  y=(side?1:-1)*(d/2+2);
   difference(){
    Roof(s,[.3,0.15])difference(){
      Rund(0,5,fn=60)union(){
      T(y=dist[1]?0:y) Grid(2,es=dist) Kreis(d=d +3);
        Quad(z*2,sy,center=true,r=sy/3);
      }
    T(y=dist[1]?0:y) Grid(2,es=dist) Kreis(d=d);
      }
    Tz(base)T(-z)LinEx(h+.01,0,1,scale=[1,1.15])GT(z=z*2 +2,pulley=false,spielO=-0.15);
   }
  }   
  
  
    
 
 }


// version Info
if(designVersion)T(1,-1)color("navy")linear_extrude(.1)Seg7(str(designVersion),h=1,spiel=0.01,b=.05,ratio=0.5,center=true,name=0);