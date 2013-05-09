


class Heroe {
  float x, y, vx, vf, vy, g;
  float altAbsoluta;
  float  frame;
  PImage personagem;
  Boolean andando, respirando, pulando, walling, pressing, atacando;
  Boolean inAir, zeraTrava, jumpTrava, comboTrava, noSolo, doubleJump, pulou, canTurn, gotTo;
  float tamY, tamX;
  color baixo, frente, tras, cima;
  int stepsNumber;
  boolean oneMore;

  //pulou = variável que indica o impulso de parede


  Heroe() {
    oneMore = false;
    g=0.98*0.1;
    vx=0;
    vf=0;
    x=width/2;
    y=-500;
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
    
    //********************************************************************************************************************************************//
    //------------------------------------******************COMO FUNCIONA (algorítmo ANALÍTICO)*********************------------------------------
    float difDeAlts = ( ground[floor(x/tamQuadrante)]-ground[ceil(x/tamQuadrante)] ) / tamQuadrante;//talvez mudar: trocar o ceil por floor + 1
    // ( ground[floor(x/tamQuadrante)]-ground[ceil(x/tamQuadrante)] ) = diferença de altura entre o tamQuadrante q o personagem já passou e o próximo à passar 
    // a personagem está entre os tamQuadrantes em questão
    // dessa forma a difDeAlts é igual a diferença de altura entre os pixels do tamQuadrante
    float steps =  x  - (floor(x/tamQuadrante)*tamQuadrante); // número de pixels entre a posição atual e o tamQuadrante anterior 
    altAbsoluta = ground[floor(x/tamQuadrante)] - ((steps*steps)*difDeAlts)*0.1; 
    
    // altAbsoluta = calculo de interpolação de acordo com a proximidade com a altura do tamQuadrante anterior
    
    //*******************************************************************************************************************************************/
    
   //*******************************************************algorítimo sintético***********************************************************************************************
    //altAbsoluta = ground[floor(x/tamQuadrante)] - ( (x-(floor(x/tamQuadrante)*tamQuadrante)) )* (( ground[floor(x/tamQuadrante)]-ground[ceil(x/tamQuadrante)] ) / tamQuadrante);
   //*******************************************************algorítimo sintético***********************************************************************************************
    
    if(x-width/2 >0){
    cameraX = x-width*0.5;
    }
    if(y < height/2){
    cameraY = height*0.5 - y;
    }
        /*if(pulou == true && dist(frame,0,60,0)<2 ){
     vx = -3; vy = -10; g= 0.98*0.2;
     }*/
    if (y+tamY >= altAbsoluta ) {
      noSolo =true;
      inAir= false;
      
    }
    

    
     if (y+tamY < altAbsoluta && walling == false) {
      noSolo=false;
    }
    
    
    if (noSolo && walling == false) {
      y =altAbsoluta-tamY;
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
    
    if (x-tamX/2<0) { 
      x= tamX/2;  
      vx = 0;
    }
    if (x+tamX/2>fimDaFase) {
      x = fimDaFase-tamX/2;
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
      frame = 0;
      respirando = true;
      andando = false;
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
    if (x+tamX/2>fimDaFase) {
      x = fimDaFase-tamX/2;
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
      frame = 0;
      println("Array Exception, brething[x] > nBreathing");
    }
  }

  void combo(int cEnd, int cEnd2, int cF1, int cF2, int cF3, boolean f) {
   
    vf = 0.5;
    frame+=vf;
    int reflexo = 4;
    
    
    if(frame >= 2 && frame <= 4){
      fTrava = true;
      oneMore = false;
    }
    
    

if ( ( (abs(cEnd +1 - frame)<= reflexo && frame <=cEnd+1) || (abs(cEnd2+1-frame) <= reflexo && frame <=cEnd2 +1 )) &&F == true && F0 == false) {
      oneMore = true;
        }
    if (frame<=0 && vf <0) {
      frame =1;
    }

    if (frame == cEnd && oneMore == false) {
      frame = 37;
    }
    if (frame == cEnd2 && oneMore == false) {
      frame = 44;
    }

    if (frame == cEnd+0.5 || frame == cEnd2+0.5) {
      oneMore = false;
    } 

    if (frame == cF1 || frame == cF2 || frame == cF3) {
      println("lllllllllllllllllllllllllllllll");
      oneMore = false;
      respirando = true;
      atacando = false;
      frame = 0;
      //comboTrava = true;
    }    

    try {
      personagem = combo[floor(frame)];
    }
    catch(Exception e) {
      background(255, 0, 0);
      respirando = true;
      atacando = false;
      frame = 0;
      println("Array Exception, combo[x] >  nJumping");
    }
     
  }
  void pula(int jHolding, int jEnd, int jF) {
    
    
    if (x-tamX/2<0) { 
      x= tamX/2;  
      vx = 0;
    }
    if (x +tamX/2>fimDaFase) {
      x = fimDaFase-tamX/2;
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
      noSolo = true;
      inAir = false;
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

    if (doubleJump == true && inAir == true && frame == jHolding && space == true && (x-tamX/2 -1<=0 && lado == 1 || x+ tamX/2 +1 >= fimDaFase && lado == -1)) {
      doubleJump = false;
      frame = jEnd+1;
      if (x - tamX/2<0) x= tamX/2;
      if (x + tamX/2>fimDaFase) x = fimDaFase-tamX/2;
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
     
     //---------sistema de atrito---------
    
     //-----------------------------------
    if (x-tamX/2 >= 0 && x +tamX/2 <= fimDaFase && space == false ) {
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
      frame = jHolding;
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
      respirando = true;
      walling = false;
      frame = 0;
      println("Array Exception, wallRunning[x] > nWallRunning");
    }
  }
}

