int GROUND = 600;
float GRAVITY = 1;

int ballWidth = 74;     
int ballHeight = 74;

PImage bgn;

PImage ssbgn; //start screen background
PImage esbgn; //end screen background

int curBall = 0;

float [] ballX = new float[100];
float [] ballY = new float[100];

float [] ballVx = new float[100]; // 15;  // horizontal speed
float [] ballVy = new float[100]; // -40;  // vertical speed

float [] x = new float [50]; //X value for blade
float [] y = new float [50]; //Y value for blade

PImage [] fruit = new PImage [10];

PImage [] cFruitA = new PImage[10]; //images of the cut fruits; first piece
PImage [] cFruitB = new PImage[10]; //second piece

int [] ballType = new int[100];

boolean [] ballVisible = new boolean[100];

PImage background;

PImage scorewm;

PImage frenzysign;
PImage freezesign;
PImage doublepsign;

PFont font;

int [] ballSep = new int[100]; //pieces of cut fruits separating

int score;

boolean frenzy = false;
boolean freeze = false;
boolean doublepoints = false;

boolean gameStart = false;

int frenzySX = 387; //X values of all banana signs
int freezeSX = 387;
int doublepSX = 387;

int frenzySY = -60; //Y values of all banana signs
int freezeSY = -60; 
int doublepSY = -60;

int gametimer = 60;

int frenzytimer = 7;
int freezetimer = 7;
int doubleptimer = 7;

void redraw_screen() {

  image(bgn, 0, 0);  
  fill(0, 100);
  rect(-20, -20, width+50, height+50);
  // fill(0, 255, 255);
  imageMode(CENTER);
  for (int i = 0; i<ballVisible.length; i++) {
    if (ballVisible[i]) {
      noStroke();
      image(fruit[ballType[i]], ballX[i], ballY[i]);
    } else {
      image(cFruitA[ballType[i]], ballX[i]-ballSep[i], ballY[i]-20);
      image(cFruitB[ballType[i]], ballX[i]+ballSep[i], ballY[i]-20);
    }
  }
  imageMode(CORNER);
}  

int distance (int x1, int y1, int x2, int y2) {
  return round(sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2)));
}

void checkStuff() { //checks whether the mouse makes contact with a fruit

  for (int i = 0; i < ballVisible.length; i++) {

    float dist1 = dist(ballX[i], ballY[i], mouseX, mouseY);
    float dist2 = dist(ballX[i], ballY[i], pmouseX, pmouseY);
    float dist3 = dist(ballX[i], ballY[i], (pmouseX+mouseX)/2, (pmouseY+mouseY)/2);

    if (ballVisible[i] && (dist1 < 37||dist2 < 37||dist3 < 37)) {
      ballVisible[i] = false;
      ballSep[i]=20;
      if (doublepoints) {
        score+=2;
      } else {
        score++;
      }

      if (ballType[i]==7) {
        frenzy = true;
      }
      if (ballType[i]==8) {
        doublepoints = true;
      }
      if (ballType[i]==9) {
        freeze = true;
      }
    }
  }
}

void bladeSetup() { //sets up the blade
  smooth();
  noStroke();

  for (int i = 0; i<50; i++) { 
    x[i] = 0;
    y[i] = 0;
  }
}

void bladeDraw() { //draws the blade

  for (int i=0; i<30; i++) {
    x[i] = x [i+1];
    y[i] = y [i+1];

    fill (i*2); //colour i is the circles devided by two makes it lighter
    ellipse (x[i], y[i], i, i);
  }

  x[30] = mouseX;
  y[30] = mouseY;
}

void imageSetup() { //uploads all the images for fruits
  for (int i = 0; i<10; i++) {
    fruit[i] = loadImage("fruit"+i+".png");
  }

  fruit[7].resize(93, 150);
  fruit[8].resize(93, 150);
  fruit[9].resize(93, 150);

  for (int i = 0; i<10; i++) {
    cFruitA[i] = loadImage("cfruit"+i+"a.png");
    cFruitB[i] = loadImage("cfruit"+i+"b.png");
  }
  cFruitA[7].resize(47, 150);
  cFruitA[8].resize(47, 150);
  cFruitA[9].resize(47, 150);

  cFruitB[7].resize(47, 150);
  cFruitB[8].resize(47, 150);
  cFruitB[9].resize(47, 150);
}

void moveBall() { //moves the fruits
  for (int i = 0; i<100; i++) {

    ballSep[i]+=5;

    if (freeze) {
      ballX[i] = ballX[i] + (ballVx[i]*0.25);
      ballVy[i] = ballVy[i] + (GRAVITY*0.25);
      ballY[i] = ballY[i] + (ballVy[i]*0.25);
    } else {
      ballX[i] = ballX[i] + ballVx[i];
      ballVy[i] = ballVy[i] + GRAVITY;
      ballY[i] = ballY[i] + ballVy[i];
    }
  }
}

void startScreen() {
  background(ssbgn);
  
  if (mouseX>400 && mouseX<600 && mouseY>500 && mouseY<560) {
    fill(220,220,220);
  }
  else {
    fill(190,190,190);
  }
  rect(400,500,200,60);
  
  fill(0);
  textFont(font,50);
  textAlign(CENTER);
  text("START",500,547);
  
  bladeDraw();
}

void endScreen() {
  background(esbgn);
  textAlign(CENTER);
  fill(190,190,190);
  text("GAME OVER",500,200);
  text("Your score is "+score,500,400);
}

void timer1() { //timer for frenzy banana
  if (frameCount%50==0) {
    frenzytimer--;
  }
}

void timer2() { //timer for freeze banana
  if (frameCount%50==0) {
    freezetimer--;
  }
}

void timer3() { //timer for double points banana
  if (frameCount%50==0) {
    doubleptimer--;
  }
}

void gametimer() { //60 second gamer timer
  if (frameCount%50==0) {
    if (freeze==false) {
      gametimer--;
    }
  }
}

void setup() {
  size(1000, 600);
  for (int i = 0; i<ballVisible.length; i++) {
    ballX[i] = width/6;
    ballY[i] = GROUND + ballHeight;
    ballVisible[i] = true;
    ballVx[i] = int(random (-30, 30));
    ballVy[i] = int(random (10, 30));
    ballSep[i] = 20;
  }
  
  frameRate(50);

  bgn = loadImage("fruitninjabgn.jpg");
  bgn.resize(1000, 600);

  scorewm = loadImage("scorewm.png");
  frenzysign = loadImage("frenzysign.png");
  freezesign = loadImage("freezesign.png");
  doublepsign = loadImage("doublepsign.png");
  ssbgn = loadImage("startscreen.jpg");
  ssbgn.resize(1000, 600);
  esbgn = loadImage("wood.png");
  esbgn.resize(1000,600);
  
  imageSetup();

  font = createFont("go3v2.ttf", 1);

  bladeSetup();
}

void draw() {

  if (gameStart==false) {
    startScreen();
  } else {
    
    textAlign(CORNERS);

    if (gametimer >= 0) {

      moveBall();

      gametimer();

      int fC1 = 28; //framecount variables
      int fC2 = 1;

      if (frenzy) {
        timer1();
        fC1 = 3;
        fC2 = 0;
      }

      if (frameCount%fC1==fC2) { //Spawns the fruits
        ballX[curBall] = int(random (-200, 1200));
        ballY[curBall] = int(height);
        ballVx[curBall] = int(random (-15, 15));
        ballType[curBall] = int(random(7));
        int r = int(random(80));
        if (frenzy) {
          r = int(random(200));
        }
        if (r<3) {
          ballType[curBall] = 7+r;
        }
        ballVy[curBall] = int(random (-35, -25));
        ballVisible[curBall] = true;
        curBall++;
        curBall = curBall%ballVy.length;
      }



      redraw_screen();

      bladeDraw();

      checkStuff();

      if (freeze) { //tints the screen when the freeze banana is active
        fill(118, 183, 204, 100);
        rect(-20, -20, width+50, height+50);
      }

      image(scorewm, 10, 5);
      
      //below are the images and settings of the signs that come up when a power-up is active 

      image(frenzysign, frenzySX, frenzySY); 
      image(freezesign, freezeSX, freezeSY);
      image(doublepsign, doublepSX, doublepSY);

      if (frenzy && frenzySY<0) {
        frenzySY+=10;
      }

      if (frenzy==false && frenzySY>=-60) {
        frenzySY-=10;
        frenzytimer = 7;
      }

      if (frenzytimer==0) {
        frenzy = false;
      }

//----------------------------------------------------------------------//

      if (freeze) {
        timer2();
      }

      if (freeze && freezeSY<0) {
        freezeSY+=10;
      }

      if (freeze==false && freezeSY>=-60) {
        freezeSY-=10;
        freezetimer = 7;
      }

      if (freezetimer==0) {
        freeze = false;
      }

//----------------------------------------------------------------------//

      if (doublepoints) {
        timer3();
      }
      if (doubleptimer==0) {
        doublepoints = false;
      }

      if (doublepoints && doublepSY<0) {
        doublepSY+=10;
      }

      if (doublepoints==false && doublepSY>=-60) {
        doublepSY-=10;
        doubleptimer = 7;
      }

//----------------------------------------------------------------------//

      if (frenzy && freeze) {
        frenzySX = 274;
        freezeSX = 500;
      }

      if (frenzy && doublepoints) {
        frenzySX = 274;
        doublepSX = 500;
      }

      if (freeze && doublepoints) {
        freezeSX = 274;
        doublepSX = 500;
      }

      if (freeze && doublepoints && frenzy) {
        freezeSX = 166;
        frenzySX = 387;
        doublepSX = 613;
      }

      if (frenzy && freeze==false && doublepoints==false) { 
        frenzySX = 387;
      }
      if (freeze && frenzy==false && doublepoints==false) { 
        freezeSX = 387;
      }
      if (doublepoints && frenzy==false && freeze==false) { 
        doublepSX = 387;
      }
//----------------------------------------------------------------------//

      textFont(font, 70);
      fill(250, 180, 0);
      text(score, 100, 75);

      if (gametimer==60) { //sets up timer
        text("1:00", 845, 75);
      } else if (gametimer>=10) {
        text("0:"+gametimer, 845, 75);
      } else {
        text("0:0"+gametimer, 845, 75);
      }
    }

    if (gametimer==-1) {
      endScreen();
    }
  }
}

void mousePressed() { //operates button on startscreen
    if (mouseX>400 && mouseX<600 && mouseY>500 && mouseY<560) {
      gameStart = true;
    }
}