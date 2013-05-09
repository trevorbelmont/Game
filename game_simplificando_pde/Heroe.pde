
class Heroe {
  float x, y, vx, vf, vy, g;
  float  frame;
  PImage personagem;
  Boolean andando, respirando, pulando, walling, pressing, atacando;
  Boolean inAir, zeraTrava, jumpTrava,comboTrava, noSolo, doubleJump, pulou, canTurn, gotTo;
  float tamY, tamX;
  color baixo, frente, tras, cima;
  int stepsNumber;

  //pulou = variável que indica o impulso de parede


  Heroe() {
    g=0.98*0.1;
    vx=0;
    vf=0;
    x=width-300;
    y=height/2-tamY/2;
    frame = 1;
    respirando = true;
    andando = false;
    pulando = false;
    walling = false;
    atacando = false;
    personagem = breathing[0];
    tamY = 300;
    tamX = 240;
    inAir = false;
    pressing = false;
    zeraTrava = true;
    jumpTrava = false;
    comboTrava = false;
    noSolo =false;
    baixo = color(0);
    doubleJump=true;
    pulou = false;
    canTurn = true;
    gotTo = false;
    stepsNumber = 0;
  }
  void kinematics() {
    x+=vx;
    y+=vy;
    vy+=g;
    /*if(pulou == true && dist(frame,0,60,0)<2 ){
     vx = -3; vy = -10; g= 0.98*0.2;
     }*/
    if (y+tamY >= height) {
      noSolo =true;
    }
    else if (y+tamY < height && walling == false) {
      noSolo=false;
    }

    if (noSolo && walling == false) {
      y = height-tamY;
      vy = 0;
      g = 0;
    }
    else {
      g=0.98*0.2;
    }


    if (pulando == true && frame ==12) {
      vy =-10;
      g=0.98*0.2;
    }
    else if ( pulando == true &&  (frame < 12 || (frame >35 && frame <45))  ) { // 43 = jEnd   35 = quando Tunner toca o solo
      vx = vy = g = 0;
    }
  }
  void anda(int rStart, int rEnd, int rF, int rF2, int rF3, int rF4) {
    gotTo = false;
    canTurn =true;
    vf= 1;
    frame+=vf;
    if (x<=0) { 
      x= 1;  
      vx = 0;
    }
    if (x+tamX>=width) {
      x = width-tamX-1;
      vx = 0;
    }

    if (frame<=1 && vf <0) {
      vx = 0;
      frame =1;
    }
    if (frame==rEnd && pressing == true && space == false ) {
      frame= rStart;
    }
    if ((frame >= rF || frame ==69 || frame == 101 ||  frame == 82)/* && pressing == false*/) {
      andando = false;
      jumpTrava = false;
      zeraTrava = true;
      frame = 0;
      if (space ==true) {
        pulando = true;
      }
    } 
    if (  ( pressing == false || (pressing == true && space == true) )  && frame ==33) {
      frame = 70;
    } 
    if (( pressing == false || (pressing == true && space == true) ) && frame ==12) {
      frame = 59;
    } 
    if (( pressing == false || (pressing == true && space == true) ) && frame ==22) {
      frame = 83;
    } 
    if (( pressing == false || (pressing == true && space == true) ) && frame ==45) {
      frame = 101;
    } 

    /*
    if (pressing == true && space==true  && frame ==33) {
     frame = 70;
     } 
     if (pressing == true  && frame ==33) {
     frame = 70;
     } 
     if (pressing == true   && frame ==12) {
     frame = 59;
     } 
     if (pressing == true   && frame ==22) {
     frame = 83;
     } 
     if (pressing == true   && frame ==45) {
     frame = 101;
     } */


    try {
      personagem = running[floor(frame)];
    }
    catch(Exception e) {
      println("Array Exception running[x] > nRunning");
    }
  }
  void respira(int bStart, int bEnd) {
    gotTo = false;
    canTurn =true;
    if (vf<0 && frame <=0) { 
      vf= 1;  
      frame = 0;
    }
    if (x+tamX>=width) {
      x = width-tamX-1;
      vx = 0;
    }
    vf=0;
    frame+=vf;

    if (frame<=1 && vf<0) {
      frame=1;
    }
    if (frame>= bEnd) {
      frame = bStart;
    }
    try {
      personagem = breathing[floor(frame)];
    }
    catch(Exception e) {
      background(255, 0, 0);
      println("Array Exception, brething[x] > nBreathing");
    }
  }

  void combo(int cEnd, int cEnd2, int cF1, int cF2, int cF3,boolean f) {
    vf = 1;
    frame+=vf;
    int reflexo = 2;
    boolean oneMore = false;

 /*   if ( ( (cEnd-frame < reflexo && cEnd-frame >=0) || (cEnd2-frame < reflexo && cEnd2-frame >=0)) && f == true) {
      oneMore = true;
    }
*/
    if (frame<=0 && vf <0) {
      frame =1;
    }

    if (frame == cEnd && oneMore == false) {
      frame = 37;
    }
    if (frame == cEnd2 && oneMore == false) {
      frame = 44;
    }

    if (frame == cEnd+1 || frame == cEnd2+1) {
      oneMore = false;
    } 

    if (frame == cF1 || frame == cF2 || frame == cF3) {
      println("lllllllllllllllllllllllllllllll");
      oneMore = false;
      respirando = true;
      atacando = false;
      frame = 0;
      comboTrava = true;
      
    }    

    try {
      personagem = combo[floor(frame)];
    }
    catch(Exception e) {
      background(255,0,0);
      background(255, 0, 0);
      println("Array Exception, combo[x] >  nJumping");
    }
  }
  void pula(int jHolding, int jEnd, int jF) {
    if (x<=0) { 
      x= 1;  
      vx = 0;
    }
    if (x+tamX>=width) {
      x = width-tamX-1;
      vx = 0;
    }
    if (pulou == true) {
      if (lado == 1)  vx = 3 ;
      if (lado == -1) vx = -3;
    }
    vf=0.5;
    frame+=vf;

    if (noSolo == true) {
      inAir = false;
    }
    else {
      inAir =true;
    }
    if (inAir==true && dist(frame, 0, jHolding, 0)<=1) {
      frame = jHolding;
      vf = 0;
      frame = jHolding;
      canTurn = true;
    }
    else {
      frame+=vf;
      canTurn =false;
    }
    if (frame<=1 && vf<0) {
      frame=1;
    }
    if (frame == jEnd && space == false) {
      zeraTrava = true;
      pulou = false;
      frame = 0;
      pulando = false;
      //jumpTrava = false;
      //jumpTrava = false;
    }
    else if (frame == jEnd && space == true) {
      zeraTrava = true;
      pulou = false;
      frame = 0;
      pulando = true;
      //jumpTrava = false;
      //jumpTrava = false;
    }

    if (doubleJump == true && inAir == true && frame == jHolding && space == true && (x-1<=0 && lado == 1 || x+tamX+1>=width && lado == -1)) {
      doubleJump = false;
      frame = jEnd+1;
      if (x<=0) x= 1;
      if (x+tamX>=width) x = width-tamX-1;
    }
    if (frame <jHolding ) {
      doubleJump = false;
    }
    if (frame > 52 && frame < 60) {
      vx= 0;
      vy = 0;
    }
    if (dist(frame, 0, 60, 0)<2) {
      if (lado ==1) {
        vx = 3;
        vy = -10;
      }
      if (lado == -1) {
        vx = -3;
        vy = -10;
      }
      pulou = true;
    }  
    /* vira depois de bater na parede
     if(frame == 70){
     lado =-lado;
     }*/
    if (x>0 && x+tamX<=width && space == false ) {
      doubleJump = true;
    }
    if (frame >= jF) {
      frame = jHolding;
    } 
    try {
      personagem = jumping[floor(frame)];
    }
    catch(Exception e) {
      background(255, 0, 0);
      println("Array Exception, jumping[x] >  nJumping");
    }
  }
  // venom.correNaParede( 19,         53,       36      nWallRunning,  64,        A);
  void correNaParede(int wrBegin, int wrEnd, int wrEnd2, int wrF1, int wrF2, boolean wrA, int maxSteps) {
    vf=1;
    frame+=vf; 

    println(stepsNumber);
    if (frame < wrBegin) {
      canTurn = false;
      respirando = false;
      andando = false;
      pulando = false;
      jumpTrava = true;
      pressing = false;
      stepsNumber = 0;
    }
    if (frame == 0 && vf <0) {
      frame = 0;
      vf = 0;
    }
    if (frame == wrEnd && wrA == true && stepsNumber < maxSteps) {
      frame =wrBegin;
      stepsNumber +=1;
    }
    if (frame>=wrBegin && frame <wrEnd) {
      canTurn = false;
      jumpTrava = true;
      vy= -5;
    }
    else {
      vy = 0;
    }
    if (frame == wrEnd2 && wrA == false) {
      frame =82;
    }
    else if (frame == wrEnd2 && wrA == true) {
      stepsNumber += 1;
    }

    if (abs(frame-wrF1) <= 1 || abs(frame - wrF2) <=1 || frame >= wrF1) {
      pulando = true;
      walling = false;
      frame = 55;
      inAir = true;
      gotTo = false;
      noSolo = false;
      respirando = false;
      pressing = false;
      jumpTrava = true;
      zeraTrava = true;
    }
    try {
      personagem = wallRunning[floor(frame)];
    }
    catch(Exception e) {
      background(255, 0, 0);
      println("Array Exception, wallRunning[x] > nWallRunning");
    }
  }
}

