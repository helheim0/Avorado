//COLORS
//one green: -10144254
//purple: -4313379
//orange: -1010901
//ground: -4340351

//competitive game: 2 screens 2 player. stuff get spawned, you have to collect them
//if you miss 3-5 you lose
//scores displayed
//new screen with winner
import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context

PImage avocado;
PImage seed;
int x1 = 50;
int x2 = 650;
int y1 = 630;
int y2 = 630;
float seedSpeed = random(3,5);
int enemyX = width/2;
int enemyY = 20;
int player1Health = 5;
int player2Health = 5;
int player1Score = 0;
int player2Score = 0;
boolean shooting1 = false;
boolean shooting2 = false;
boolean startMenu = true;
boolean endScreen = false;
boolean collidedPurple = false;
boolean collidedOrange = false;
int[] circleSize = new int[10];
int r; //random
int h1 = 1;
int h2 = 1;
int w = (int)random(300);
int w2 = (int)random(360,700);
int speed1 = 1;
int speed2 = 1;
 
void setup(){
  size(700,700);
  background(186, 220, 88);
  
  avocado = loadImage("avocado.png");
  seed =  loadImage("seed.png");
  minim = new Minim(this);
  player = minim.loadFile("audio.mp3", 2048);
  player.play();
}

void draw(){
   if(startMenu){
    for(int i = 0; i < height; i++){
      background(186, 220, 88, i);
    }
    image(avocado, 440, 100, 200,260);
    fill(255);
    textSize(100);
    text("Avorado", width/4, height/3);
    textSize(30);
    text("Help Alfred get his seed together!", 160, height/3 +100);
    
    
    textSize(20);
    text("Press S or click to start", width/3, height/3 + 160);
    
    //Player 1 controls
    fill(190, 46, 221);
    textSize(30);
    text("Player 1 controls", 50, height - 160);
    textSize(20);
    text("a - move left", 50, height - 140);
    text("d - move right", 50, height - 120);
    //text("w - fire", 50, height - 100);
    
    //Player 2 controls
    fill(240, 147, 43);
    textSize(30);
    text("Player 2 controls", 400, height - 160);
    textSize(20);
    text("left mouse - move left", 400, height - 140);
    text("right mouse - move right", 400, height - 120);
    //text("mouse wheel - fire", 400, height - 100);
    
    noFill();
    stroke(139,69,19);
    if(mousePressed && mouseButton == LEFT){
      startMenu = false;
    }
  }
  
  else {
  background(186, 220, 88);
  
  //Ground
  fill(189, 197, 129);
  rect(0, height - 20, width, height);
  //Divider 
  fill(0);
  rect(width/2 -20, 0, 20, height);

  //Make player 1 + movement
  drawPlayers(x1, y1, true);
  //Player 1 score
  fill(255);
  textSize(20);
  String score = "Score: " + player1Score;
  text(score,20,30);
  String lives = "Lives: " + player1Health;
  text(lives,20,50);
  
  //Make player 2 + movement
  drawPlayers(x2, y2, false);
  //Player 2 score
  fill(255);
  textSize(20);
  String score2 = "Score: " + player2Score;
  text(score2,600,30);
  String lives2 = "Lives: " + player2Health;
  text(lives2,600,50);
      
   //If collided, instantiate new enemy, increasing its speed
   if(endScreen == false){
   if(collidedPurple == true){
      h1 = 1;
      w = (int)random(width/2 - 40); 
   } else {
     // h1 *= speed1;
      image(seed, w, h1, 30, 30);
      //circle(w, h1, 20);
      h1+=5;
     // speed1+=2;
   }}
   else {
     circle(-50, -100, 20);
   }
   
  color c = get(w,h1+15);
  if(c == -4313379){ //collides with purple
    player1Score+=5;
    println("Collision called");
    collidedPurple = true;
  } 
  else if(c == -4340351 && w < width/2){
    player1Health--;
       if(player1Health < 0)
      player1Health = 0;
    collidedPurple = true;
  }
  else {
    collidedPurple = false;
  }
  
   //If collided with orange, instantiate new enemy, increasing its speed
   if(endScreen == false){
    if(collidedOrange == true){
        h2 = 1;
        w2 = (int)random(460, 630); 
     } else {
     // h2 *= speed2;
      //circle(w2, h2, 20);
      image(seed, w2, h2, 30, 30);
      h2+=5;
      }
     }
   else
   {
     circle(-100, -100, 20);
   }
   
  color c2 = get(w2,h2+15);
   if(c2 == -1010901){ //collides with orange
    player2Score+=5;
    println("Collision called");
    collidedOrange = true;
  } 
    else if(c2 == -4340351 && w2 > width/2){
     player2Health--;
    collidedOrange = true;
    if(player2Health < 0)
      player2Health = 0;
  }
  else {
    collidedOrange = false;
  }
  
  //Make player2 move, limit it for only horizontal movement --mouseclick?
  if(mousePressed){  
    if(mouseButton == LEFT && x2 > width/2){
       x2 -= 5;
    }
    if(mouseButton == RIGHT){
       if(x2 + 30 < width)
        x2 += 5;
    }
    if(mouseButton == CENTER){
      println("2 shoot ");
      shooting2 = true;
    }
  }
  }
  
  if((player1Health == 0 || player2Health == 0) || (player1Health == 0 && player2Health ==0)){
    endScreen = true;
  }
  
  if(endScreen == true){
    String winner = "";
    
    if(player1Health == 0 && player2Health == 0){
      winner = "It's a TIE!!";
   }
    else if(player1Health == 0){
      winner = "OMG Player 2 won!!";
    }
    else if(player2Health == 0){
      winner = "Yass Player 1 won!!";
    }
      textSize(60);
      text(winner, 100, 200);
  }
}

void drawPlayers(int w, int h, boolean first){
  noStroke();
  if(first)
    fill(190, 46, 221);
   else
     fill(240, 147, 43);
  rect(w, h, 30, 50);
}

void keyPressed(){
  if(key == 'a' && x1 > 0){
    x1 -= 10;
  }
  if(key == 'd' ){
    if(x1 + 30 < width && x1 < width/2 - 50)
      x1 += 10;
  }
  if(key == 'w'){
    //SHOOT
    println("1 shoot");
    shooting1 = true;
  }
  if(key == 's'){
    startMenu = false;
  }
  if(key == 'r'){
    startMenu = true;
    endScreen = false;
    player1Health = 5;
    player2Health = 5;
    player1Score = 0;
    player2Score = 0;
    collidedPurple = false;
    collidedOrange = false;
    h1 = 1;
    h2 = 1;
    w = (int)random(width/2 -20); 
    w2 = (int)random(width/2, width -20); 
    circle(w, h1, 20);
    circle(w2, h2, 20);
  }
}
