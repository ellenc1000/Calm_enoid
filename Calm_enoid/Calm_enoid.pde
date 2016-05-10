boolean gameStart;
int level = 1;
int score = 0;
int lives = 5;
float[][] wall;
boolean brickHit = false;
boolean startScreen = true;

float ballSize = 10;
float ballX;
float ballY;
float ballSpeedX;
float ballSpeedY;

float playerWidth = 50;
float playerHeight = 10;
float playerX;
float playerY;

float edge = 30;
int rows = 8;
int cols = 10;

float brickX;
float brickY;
float brickWidth = 40;
float brickHeight = 20;

import ddf.minim.*;

Minim minim;

AudioSnippet bounceBricks;
AudioSnippet bounceWall;
AudioSnippet bouncePaddle;
AudioSnippet offscreenMusic;
AudioSnippet winMusic;
AudioSnippet lossMusic;
AudioSnippet calmMusic;

import gifAnimation.*;

Gif space;

void startScreen()
{
  if (startScreen == true)
  {
    text("CALM-ENOID", 140, 260);
    text("click to begin", 110, 370);
    text("Clear your view", 100, 290);
    text("of the sky", 140, 330);
  }
}

//START GAME
void mouseClicked()
{
  ballX += ballSpeedX;
  ballY += ballSpeedY;

  startScreen = false;

  gameStart = true;
  int i = (int) random(0, 2); // random ball start direction
  if (i == 0) // option 1 - up
  {
    ballSpeedX = -1;
  } else //  option 2 - down
  {
    ballSpeedX = 1;
  }

  ballSpeedY = random(2, 5);
}

//PADDLE BOUNDING BOX
boolean playerBoundingBox()
{
  if (ballX + ballSize / 2 < playerX - playerWidth / 2)
  {
    return true;
  }

  if (ballX - ballSize / 2 > playerX + playerWidth / 2)
  {
    return true;
  }

  if (ballY + ballSize / 2 < playerY - playerHeight / 2)
  {
    return true;
  }

  if (ballY + ballSize / 2 > playerY + playerHeight / 2)
  {
    return true;
  }

  return false;
}


//BRICK BOUNDING BOX
boolean brickBoundingBox()
{
  if (ballX + ballSize / 2 < brickX - brickWidth / 2)
  {
    return true;
  }

  if (ballX - ballSize / 2 > brickX + brickWidth / 2)
  {
    return true;
  }

  if (ballY + ballSize / 2 < brickY - brickHeight / 2)
  {
    return true;
  }

  if (ballY + ballSize / 2 > brickY + brickHeight / 2)
  {
    return true;
  }

  return false;
}

//ball movement an wall collision
void ballMove()
{
  if (gameStart = true)
  {

    ballX += ballSpeedX;//ball movement
    ballY += ballSpeedY;//ball movement

    // detect & result collides walls
    if ((ballY <= 0)) 
    {
      ballSpeedY *= -1;

      bounceWall.play();
      bounceWall.rewind();
    }

    if ((ballX <= 0) || (ballX + ballSize > width))
    {
      ballSpeedX *= -1;
      bounceWall.play();
      bounceWall.rewind();
    }
  }
}


void buildWall()
{
  for (int row = 2; row < rows; row ++)
  {
    for (int col = 2; col < cols; col ++)
    {
      brickX = col * 1.2 * brickWidth;
      brickY = row * 1.5 * brickHeight;
      fill(255);

      if (gameStart = true && brickHit == false)
      {
        wall[row][col] = 1;
      }

      if (wall[row][col]==0 && brickHit == true)//KILL BRICK
      {
        noStroke();
        noFill();
      } else if (wall[row][col] == 1)//DONT KILL
      {
        fill(255, 245, 255);
      }


      rect(brickX, brickY, brickWidth, brickHeight, 5);//build wall
      ellipse(brickX, brickY, 25, 30);
      ellipse(brickX - 8, brickY, 30, 15);
      ellipse(brickX + 8, brickY, 30, 15);
    }
  }
}

void brickCollision()
{

  for (int row = 2; row < rows; row ++)
  {
    for (int col = 2; col < cols; col ++)
    {
      brickX = col * 1.2 * brickWidth;
      brickY = row * 1.5 * brickHeight;
      noFill();
      rect(brickX, brickY, brickWidth, brickHeight);
      if (!brickBoundingBox() && wall[row][col] == 1)
      {
        ballSpeedY *= -1;
        score ++;
        wall[row][col] = 0;
        brickHit = true;

        bounceBricks.play();
        bounceBricks.rewind();

        println(wall[row][col]);
      }
    }
  }
}

void offscreen()
{
  if (ballY > height) 
  {
    ballX = (height * 0.5f) - (ballSize * 0.5f); // centre ball
    ballY = (width * 0.8f) - (ballSize * 0.5f); // centre ball

    ballSpeedY = 0;
    ballSpeedX = 0;

    lives -= 1;
    offscreenMusic.play();
    offscreenMusic.rewind();
  }
  if ( ballSpeedX == 0)
  {
    calmMusic.pause();
  }
}

void paddleBall()
{
  if (!playerBoundingBox())
  {
    ballSpeedY *= -1.1;

    bouncePaddle.play();
    bouncePaddle.rewind();
  }
}

void levelChange()
{
  if (score > 47 && level == 1 || score > 95 && level == 2 )
  {
    ballX = (height * 0.5f) - (ballSize * 0.5f);
    ballY = (width * 0.8f) - (ballSize * 0.5f); 

    ballSpeedY = 0;
    ballSpeedX = 0;
    fill(255);

    text("WELL DONE", 140, 170);
    text("HIT SPACEBAR TO", 70, 220);
    text("CONTINUE", 150, 270);
    buildWall();
    brickCollision();

    if (level == 1 && keyPressed)
    {
      if (key == ' ')
      {
        level = 2;
        reset();
      }
    }
    if (level == 2 && keyPressed && score > 95)
    {
      if (key == ' ')
      {
        level = 3;
        reset();
      }
    }
  }
}

PImage winImg;
PImage lossImg;

void gameOver()
{
  if (lives <= 0)
  {
    gameStart = false;

    image(lossImg, 0, 0);
    fill(255);
    textSize(32);
    text("Oh no!", 200, 100);
    text("YOU LOSE", 170, 150);
    text("Hit the space bar to", 40, 200);

    lossMusic.play();
    offscreenMusic.pause();
    calmMusic.pause();
    score = 0;

    rect(width/2, 270, 240, 60);
    fill(0);
    textSize(48);
    text("RESTART", 135, 290);

    if (gameStart == false && keyPressed)
    {
      if (key == ' ')
      {
        reset();
      }
    }
  }
}

void winScreen()
{
  if (score >= 144 && level == 3) // total bricks = 48
  {
    image(winImg, 0, 0);
    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("WELL DONE", 250, 100);
    text("YOU WIN", 250, 150);
    winMusic.play();
    offscreenMusic.pause();
    calmMusic.pause();
  }
}

void displayScore()
{
  fill(255);
  textSize(32);
  text("Score" +score, 5, 40);
  text("Lives " +lives, 345, 40);
  text("Lvl" +level, 210, 40);
}

void setup()
{
  size(500, 500);
  rectMode(CENTER);
  frameRate(60);

  //SET PLAYER START POSITION
  playerY = (height * 0.9f);
  playerX = (width * 0.5f);

  //SET BALL START POSITION - CENTRE SCREEN
  ballX = (height * 0.5f) - (ballSize * 0.5f);
  ballY = (width * 0.8f) - (ballSize * 0.5f);

  wall = new float [rows][cols];

  minim = new Minim(this);

  bounceBricks = minim.loadSnippet("bounceBricks.wav");
  bounceWall = minim.loadSnippet("wallBounce.wav");
  bouncePaddle = minim.loadSnippet("paddleBounce.wav");
  offscreenMusic = minim.loadSnippet("spaceMusic.wav");
  winMusic = minim.loadSnippet("softMusic.wav");
  lossMusic = minim.loadSnippet("lossMusic.wav");
  calmMusic = minim.loadSnippet("calmmusic.wav");

  space = new Gif(this, "space.gif");
  space.play();


  winImg = loadImage("winimage.jpg");
  lossImg = loadImage("lossimage.jpg");
}

PFont font;

void draw()
{
  background(0);
  image(space, 1, 1);
  noCursor();
  font = createFont("light_pixel-7.ttf", 32);
  textFont(font);
  noStroke();
  fill(255);

  //calmMusic.rewind();
  calmMusic.play();

  startScreen();

  //DRAW BALL
  ellipse(ballX, ballY, ballSize, ballSize);

  //player size change based on levels
  if (level == 1)
  {
    playerWidth = 50;
  }
  if (level == 2)
  {
    playerWidth = 40;
  }
  if (level == 3)
  {
    playerWidth = 35;
  }
  //DRAW PLAYER
  rect(playerX, playerY, playerWidth, playerHeight);

  //BALLSPEED & WALL COLLISION
  ballMove();

  buildWall();

  brickCollision();

  offscreen();

  //PADDLE/BALL COLLISION
  paddleBall();

  displayScore();

  levelChange();

  gameOver();

  winScreen();

  //controls
  playerX = mouseX;

  println(gameStart);
}


void reset()
{
  setup();
  mouseClicked();
  lives = 5;

  buildWall();

  brickCollision();

  offscreen();

  paddleBall();

  displayScore();

  brickHit = false;
}

