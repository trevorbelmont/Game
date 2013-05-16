
class Heroe {
  float x, y, vx, vf, vy, g;
  float  frame;
  PImage personagem;
  Boolean andando, respirando, pulando, pressing;
  Boolean inAir, zeraTrava, jumpTrava, noSolo;
  float tamY, tamX;
  color baixo, frente, tras, cima;




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
    personagem = breathing[0];
    tamY = 300;
    tamX = 240;
    inAir = false;
    pressing = false;
    zeraTrava = true;
    jumpTrava = false;
    noSolo =false;
    baixo = color(0);
  }
  void kinematics() {
    x+=vx;
    y+=vy;
    vy+=g;
    baixo = get(int(x+tamX/2), int(y+tamY+2));
    if (baixo ==color(0)) {
      noSolo = true;
    }
    else {
      noSolo = false;
    }

    if (noSolo == true) {
      //y = height-tamY;
      vy = 0;
      g = 0;
    }
    else{
      g=0.98*0.2;
    }


    if (pulando == true && frame ==12) {
      vy =-10;
      g=0.98*0.2;
    }
  }
  void anda(int rStart, int rEnd) {
    vf= 1;
    frame+=vf;

    if (frame<=1 && vf <0) {
      vx = 0;
      frame =1;
    }
    if (frame==rEnd && pressing == true && space == false ) {
      frame= rStart;
    }
    if ((frame >= nRunning || frame ==69)/* && pressing == false*/) {
      andando = false;
      jumpTrava = false;
      zeraTrava = true;
      frame = 0;
      if (space ==true) {
        pulando = true;
      }
    } 
    if (pressing == false  && frame ==33) {
      frame = 70;
    } 
    if (pressing == false   && frame ==12) {
      frame = 59;
    } 


    if (pressing == true && space==true  && frame ==33) {
      frame = 70;
    } 



    personagem = running[floor(frame)];
    // println(frame);
  }
  void respira(int bStart, int bEnd) {
    vf=1;
    frame+=vf;

    if (frame<=1 && vf<0) {
      frame=1;
    }
    if (frame>= bEnd) {
      frame = bStart;
    }
    personagem = breathing[floor(frame)];
  }

  void pula(int jHolding, int jEnd) {

    vf=1;
    frame+=vf;

    if (noSolo == true) {
      inAir = false;
    }
    else {
      inAir =true;
    }
    if (inAir==true && dist(frame, 0, jHolding, 0)<2) {
      frame = jHolding;
      vf = 0;
      frame = jHolding;
    }
    else {
      frame+=vf;
    }
    if (frame<=1 && vf<0) {
      frame=1;
    }
    if (frame >= jEnd) {
      frame = 0;
      zeraTrava = true;
      pulando = false;
      //jumpTrava = false;
    } 

    personagem = jumping[floor(frame)];
  }
}

