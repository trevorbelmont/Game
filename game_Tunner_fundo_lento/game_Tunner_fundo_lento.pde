Boolean esquerda, direita, space;

PImage[] running= new PImage[100];
PImage[] breathing = new PImage[15];
PImage[] jumping = new PImage[43];
Heroe venom;
int nRunning, nBreathing, nJumping;
float lado;
PImage fundo;

void setup() {
  venom = new Heroe();
  esquerda = direita = space = false;
  size(screen.width, screen.height, P3D);
  background(0);
  fill(0);
  rect(-width,-height,width*2,height*2);
  nRunning = 82;
  nBreathing= 15;
  venom.respirando = true;
  nJumping = 43;
  fundo = loadImage("Fundo.PNG");
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
  // println( "D: "+direita +",E: " + esquerda +",S: "+ space);
  println( "r: "+ venom.respirando + ",a: " +venom.andando+",p: "+ venom.pulando);
  teclasVirtuais();
  //image(fundo,0,0,width,height);
  fill(0);
  rect(0,0,width,height);
  fill(255);
  rect(100,100,width-200,height-200);
  
  statusMachine();
  venom.kinematics();

  pushMatrix();
  translate(venom.x+120, venom.y);
  scale(lado, 1);
  image(venom.personagem, -120, 0); //venom.x, venom.y);
  popMatrix();
}
void statusMachine() {
  if (venom.respirando == false && venom.andando == false && venom.pulando == false) {
    venom.respirando = true;
    venom.frame = 0;
  }
  if (venom.andando ==true && venom.respirando == true) {
    venom.respirando = false;
    venom.frame = 0;
  }

  if (venom.andando == true && venom.respirando == false && venom.pulando == false) {

    venom.anda(12, 58);
    //venom.frame = 0;
  }
  if (venom.respirando == true && venom.andando == false) {
    venom.respira(0, 14) ;
    venom.vx = 0;
  }
  if (venom.pulando == true && venom.andando == false ) {
    venom.pula(29, 43);
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
}  

void teclasVirtuais() {
  if (esquerda == true  ) {
    lado = 1;
    if (venom.inAir == false) { 
      venom.vx=-2;
    }
    else {
      venom.vx = -3;
    }
  }
  else if (direita == true && (venom.frame <=58 && venom.andando == true || venom.andando == false)) {
    lado = -1; 
    if (venom.inAir == false) {
      venom.vx=2;
    }
     else {
      venom.vx=3;
    }
  }
  else {
    venom.vx=0;
  }


  if (esquerda || direita) {
    if (venom.pulando == false) {
      venom.andando = true;
    }
    venom.pressing = true;
    //venom.respirando=false;
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
}

