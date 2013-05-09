// Modularizar mais o código
// talvez criar um void declara variáveis para universalizar as variáveis na classe
//_________________________________________________************______________________________________________________________
/********************///// TRANSFORMAR O VOID COMBO EM UM VOID MODULARIZÁVEL COM INFINITOS NÚMEROS DE COMBOS********/
//_________________________________________________************_______________________________________________________________
/*  Classe Heroe (Children of Classe Personagem)
 >>RESOLVER PROBLEMA QUE DÁ QUANDO SE APERTA RAPIDAMENTE (D + ->, space, <-)
 >> Implementar aceleração de velocidade venom.vx (da classe) personagem com variação de animação para cada tipo de deslocamento
 >> Implementar mudança de sentido de velocidade venom.vx com aceleração - em especial depois do jumpFromWall
 >> Modularizar absolutamente o void correNaParede. Com inputs de: número de passos,velocidade vy, cadência de velocidade ay, habilidade... 
 >> Implementar diferença entre correNaParede -> jumpFromWall e correnaParede -> frame jHolding.pulando em queda livre só com ação da g
 */



Boolean esquerda, direita, space, A, F;

PImage[] running= new PImage[150];
PImage[] breathing = new PImage[15];
PImage[] jumping = new PImage[100];
PImage[] combo = new PImage[50];
PImage[] wallRunning = new PImage[100];
Heroe venom;
int nRunning, nBreathing, nJumping, nWallRunning, nCombo;
float lado;
PImage fundo;

void setup() {
  venom = new Heroe();
  esquerda = direita = space = false;
  size(screen.width, screen.height, P3D);
  background(0);
  fill(0);
  rect(-width, -height, width*2, height*2);
  nRunning = 112;
  nBreathing= 15;
  nJumping = 70;
  nWallRunning = 75;
  nCombo = 50;
  fundo = loadImage("Fundo.PNG");
  venom.respirando = true;
  F = A = direita = esquerda = space = false;
  for (int i = 0; i< nBreathing; i++) {
    breathing[i] = loadImage("Breathing ("+i+").png");
    //breathing[i] =  requestImage("breathing000"+i+".png");
  }
  for (int i = 0; i< nRunning; i++) {
    running[i] = loadImage("Running ("+i+").png");
    //breathing[i] =  requestImage("breathing000"+i+".png");
  }
  for (int i = 0; i<nJumping; i++) {
    jumping[i] =loadImage("Jumping (" + i+ ").png");
  }
  for (int i = 0; i<nWallRunning; i++) {
    wallRunning[i] =loadImage("WallRunning (" + i+ ").png");
  }
  for (int i = 0; i<nCombo; i++) {
    combo[i] = loadImage("Combo (" +i+ ").png");
  }
  lado = 1;

  /*else if (i==0) {
   walking[i] = requestImage("0001.png");
   }
   else {
   walking[i] = requestImage("00"+i+".png");
   //if (i<=12) breathing[i] = requestImage("breathing00"+i+".png");
   }*/
}

void draw() {
  //println(venom.pulou);
  // println( "D: "+direita +",E: " + esquerda +",S: "+ space);
  // println( "r: "+ venom.respirando + ",a: " +venom.andando+",p: "+ venom.pulando);
  teclasVirtuais();
  color cor = breathing[0].get(0, 0);
  background(cor);
  //  image(fundo,0,0,width,height);
  statusMachine();
  venom.kinematics();

  try {

    pushMatrix();
    translate(venom.x+120, venom.y);
    scale(lado, 1);
    image(venom.personagem, -120, 0); //venom.x, venom.y);
    popMatrix();
  }
  catch(Exception e) {
    println(e);
  }
}

void keyPressed() {
  //rob.keyPress(KeyEvent.VK DELETE);

  if (keyCode ==LEFT) {
    esquerda =true;
  }
  if (keyCode == RIGHT) {
    direita = true;
  }

  if (key == ' ') {
    space =  true;
  }
  if (key == 'd') {
    A = true;
  }
  if (key == 'f') {
    F = true;
    venom.comboTrava = false;
  }
}

void keyReleased() {
  venom.pressing = false;
  /*
  if(keyCode == RIGHT) venom.vx = 0;
   if(keyCode == LEFT) venom.vx = 0;
   
   if (key == ' ') venom.jumpTrava = false;
   */
  if (keyCode == RIGHT) direita = false;
  if (keyCode == LEFT) esquerda = false; 
  if (key == ' ') space = false;
  if (key == 'd') A = false;
  if (key == 'f') F = false;
}  

void statusMachine() {

  if (venom.respirando == false && venom.andando == false && venom.pulando == false && venom.walling == false && venom.gotTo == false) {
    venom.respirando = true;
    venom.frame = 0;
  }
  if (venom.andando ==true && venom.respirando == true) {
    venom.respirando = false;
    venom.frame = 0;
  }

  if (venom.andando == true && venom.respirando == false && venom.pulando == false) {
    venom.anda(12, 58, nRunning, 69, 81, 82);
  }
  if (venom.respirando == true && venom.andando == false) {
    venom.respira(0, 14) ;
    venom.vx = 0;
  }
  if (venom.pulando == true && venom.andando == false ) {
    venom.pula(29, 43, nJumping);
  }
  if (venom.pulando == false && venom.andando == false&& (venom.walling ==true || venom.gotTo == true) ) {
    venom.correNaParede(19, 53, 36, nWallRunning, 64, A, 0);
  }
  if ( venom.atacando == true && venom.comboTrava == false && venom.pulando == false && venom.walling == false) {
    venom.combo(9, 18, 36, 43, 50, F);
     }
}
void teclasVirtuais() {
  if (  (venom.canTurn == true || (venom.frame > 12 && venom.frame < 29 && venom.pulando == true)) && 
    venom.x-1 > 0 && esquerda == true && (venom.frame <=58 && venom.andando == true || venom.andando == false) ) {
    lado = 1;
    if (venom.inAir == false) { 
      venom.vx=-2;
    }
    else {
      venom.pulou = false;
      venom.vx = -3;
    }
  }
  else if ( (venom.canTurn == true || venom.frame > 12 && venom.frame < 29 && venom.pulando == true) &&
    venom.x + venom.tamX+1 < width &&direita == true && (venom.frame <=58 && venom.andando == true || venom.andando == false)) {
    lado = -1; 
    if (venom.inAir == false) {
      venom.vx=2;
    }
    else {
      venom.pulou = false;
      venom.vx=3;
    }
  }
  else {
    if (venom.pulou == false) {
      venom.vx=0;
    }
  }

  if (A == true && venom.x-1 <= 0 && esquerda == true && venom.andando == false&& venom.pulando ==false && venom.inAir == false) {
    venom.walling = true;
    venom.respirando = false;
    venom.andando = false;
    //  venom.frame = 0;
  }
  else if (A == true && venom.x + venom.tamX+1 >= width && direita == true && venom.andando == false &&  venom.pulando ==false && venom.inAir == false) {
    venom.walling = true;
    venom.respirando = false;
    venom.andando = false;
    // venom.frame = 0;
  }
  if (esquerda || direita  && venom.walling == false && venom.gotTo == false) {
    if ( (venom.x-3<=0 && lado == 1) || (venom.x+venom.tamX+3>width && lado == -1) ) {
      venom.pressing = false;
    }
    else {
      if (venom.pulando == false ) {
        venom.andando = true;
      }
      venom.pressing = true;
    }
  } 
  else {
    venom.pressing = false;
  }
  if (space == true && venom.jumpTrava == false && venom.pulando ==false && (  ((venom.frame == 69 || venom.frame == nRunning) && venom.andando ==true) || venom.andando ==false   )) {
    venom.respirando = false;
    venom.pressing = false;
    venom.pulando =true;
    venom.jumpTrava = true;
    if (venom.zeraTrava ==true) {
      venom.frame = 0;
      venom.zeraTrava =false;
    }
  }

  if (direita == false && esquerda == false) venom.vx = 0;


  if (space == false) venom.jumpTrava = false;

  if (F == true && venom.comboTrava == false && venom.pulando ==false && venom.walling == false) {
   // if (venom.respirando == true) venom.frame = 0; 
    venom.atacando = true;
    venom.respirando = false;
    venom.walling = false;
    venom.andando = false;
  }
}

