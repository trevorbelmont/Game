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
int nQuadrantes = 200;
int nObs = 20;

float obx[] = new float [nObs];
float oby[] = new float [nObs];
float obtx[] = new float [nObs];
float obty[] = new float [nObs]; //<>//

float ground[] = new float [nQuadrantes+1];
int fimDaFase;
float cameraX, cameraY;

Boolean esquerda, direita, space, A, F;
Boolean fTrava, F0;
PImage[] running= new PImage[150];
PImage[] breathing = new PImage[15];
PImage[] jumping = new PImage[100];
PImage[] combo = new PImage[50];
PImage[] wallRunning = new PImage[100];
Heroe venom;
int nRunning, nBreathing, nJumping, nWallRunning, nCombo;
float lado;
PImage fundo;
int tamQuadrante;
void setup() {
  venom = new Heroe();
  cameraX = cameraY = 0;
  fimDaFase = int( (nQuadrantes)*200 - venom.tamX/2) ;
  tamQuadrante = 200;
  /* ----------------------------------------------------- Cálculo de colisão com o chão de forma pixel
   ---------------------------------------------------------usa uma variavel no vetor pra cada pixel 
   for (int i = 1; i<width+1; i++) {
   ground[0] = height;
   if (i <= width/2) {
   ground[i] = ground[i-1] -1;
   }
   else {
   ground[i] = ground[i-1] +1;
   }
   ground[i+width*5] = ground[i+width*5-1] +1;
   ground[i+width] = ground[i+width*2] = ground[i+width*3] = ground[i+width*4]  = ground[i];
   }
   */

  for (int i =0; i < nObs; i++) {
    obx[i] = random(width, width*5);
    oby[i] = random(height*0.3, height*0.8);
    obtx[i] = random(100, 400);
    obty[i] = random(100, 500);
  }

  for (int i = 0; i<nQuadrantes; i++) {
    if (i <4) {
      ground[i] = height-50;
    }
    else {
      ground[i] = random(height*0.2, height*0.9);
    }
  }


  F0 = false;
  fTrava = false;

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
  translate(-cameraX, cameraY);
  //translate(-cameraX - 2*(mouseX- height/2), cameraY - 2*(mouseY- width/2)); //camera móvel
  frameRate(60);
  teclasVirtuais();
  color cor = breathing[0].get(0, 0);
  background(255);


  //************************************************************ sem sistema de tamQuadrantes (colisão pixel a pixel)*****************
  /*
int tela = int(venom.x-width*0.75);
   if (tela <0) tela = 0;
   for (int i = tela; i< int(venom.x+width*0.75); i++) {
   
   stroke(10);
   strokeWeight(10);
   point(  i, ground[i]);
   }
   */
  //************************************************************ sem sistema de tamQuadrantes (colisão pixel a pixel)*****************
  int beginQuad = floor( venom.x/tamQuadrante) - ceil(height/tamQuadrante) -2; 
  int endQuad = floor( venom.x/tamQuadrante) + ceil(height*2/tamQuadrante)+1;
  //ceil(height/tamQuadrante) = número de quadrantes em uma tela
  if ( beginQuad < 1) beginQuad = 1;
  if (endQuad >nQuadrantes) endQuad = nQuadrantes;
  println(beginQuad + " " +endQuad + " " + str(floor(venom.x/tamQuadrante)) );

  for (int i = beginQuad; i<endQuad; i++) {

    stroke(10);
    strokeWeight(10);
    line((i-1)*tamQuadrante, ground[i-1], i*tamQuadrante, ground[i]);
  }

  for (int i =0; i < nObs; i++) {
    fill(0);
    rect(obx[i], oby[i], obtx[i], obty[i]);
  }

  //  image(fundo,0,0,width,height);
  statusMachine();
  venom.kinematics();

  try {

    pushMatrix();
    translate(venom.x, venom.y);
    scale(lado, 1);
    image(venom.personagem, -venom.tamX/2, 0); //venom.x, venom.y);
    ellipse(0, venom.tamY, 20, 20);
    popMatrix();
  }
  catch(Exception e) {
    println(e);
  }
  F0 = F;
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
  if ( key == 'f' /*&& fTrava == false*/) {
    F = true;
    fTrava = true;
  }
  else {// if(fTrava == true){
    F= false;
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
  if (key == 'f') {
    F = false;
    //;fTrava = false;
    venom.comboTrava = false;
  }
}  

void statusMachine() {

  if (venom.respirando == false && venom.atacando == false && venom.andando == false && venom.pulando == false && venom.walling == false && venom.gotTo == false) {
    venom.respirando = true;
    venom.frame = 0;
  }
  if (venom.andando ==true && venom.respirando == true) {
    venom.respirando = false;
    venom.frame = 0;
  }
  if (venom.atacando == true && ( venom.andando == true || venom.pulando == true || venom.respirando == true || venom.walling == true)) {
    venom.andando = venom.pulando = venom.respirando = venom.walling = false;
  } 
  if (venom.andando == true && venom.respirando == false && venom.pulando == false && venom.atacando == false) {
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
  if ( venom.atacando == true && venom.andando == false && venom.comboTrava == false && venom.pulando == false && venom.walling == false) {
    venom.respirando = false;
    venom.andando = false;
    venom.combo(9, 18, 36, 43, 50, F);
  }
}
void teclasVirtuais() {
  if (  (venom.canTurn == true || (venom.frame > 12 && venom.frame < 29 && venom.pulando == true)) && venom.leftBlock == false &&
    venom.x-venom.tamX/2 > 0 && esquerda == true && venom.atacando == false && (venom.frame <=58 && venom.andando == true || venom.andando == false) ) {
    lado = 1;
    if (venom.inAir == false) { 
      venom.vx=-2;
    }
    else {
      venom.pulou = false;
      venom.vx = -3;
    }
  }
  else if ( (venom.canTurn == true || venom.frame > 12 && venom.frame < 29 && venom.pulando == true) && venom.rightBlock == false &&
    venom.x+venom.tamX/2+1  < fimDaFase &&direita == true && venom.atacando == false && (venom.frame <=58 && venom.andando == true || venom.andando == false)) {
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

  if (A == true && venom.x-venom.tamX/2-1 <= 0 && esquerda == true && venom.andando == false&& venom.pulando ==false && venom.inAir == false) {

    venom.walling = true;
    venom.respirando = false;
    venom.andando = false;
    //  venom.frame = 0;
  }
  else if (A == true && venom.x + venom.tamX/2+1 >= fimDaFase && direita == true && venom.andando == false &&  venom.pulando ==false && venom.inAir == false) {
    venom.walling = true;
    venom.respirando = false;
    venom.andando = false;
    // venom.frame = 0;
  }
  if (esquerda || direita  && venom.walling == false && venom.gotTo == false) {
    if ( (venom.x-venom.tamX/2-1<0 && lado == 1) || (venom.x+venom.tamX/2+2>fimDaFase && lado == -1) ) {
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

  if (F == true && venom.andando == false && venom.comboTrava == false && venom.pulando ==false && venom.walling == false) {
    // if (venom.respirando == true) venom.frame = 0; 
    venom.atacando = true;
    venom.respirando = false;
    venom.walling = false;
    venom.andando = false;
  }
}

