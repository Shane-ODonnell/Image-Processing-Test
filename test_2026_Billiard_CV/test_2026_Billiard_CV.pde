//recognise different pool balls

PImage allBalls;

void setup() {
  size(500, 500);

  allBalls = loadImage("poolBalls.jpg");
  showInput();
  colorMode(RGB, 255);
  noStroke();
  println(floor( millis() / 1000));
}

boolean first = true;
int iterator = 0;
color black = color(0);
color white = color(255);
int pw = 1;
color curr = white;
boolean red = true;
int r,g,b;
int X = 0; int Y = 0;

void draw() {
  while( X < width && Y < height){
    if(X < width){
      loadPixels();
      curr = white;
      red = true;
      r = 0; g = 0; b = 0;

      if( Y < height){
        curr = pixels[ Y * height + X ];
        r = getRed(X, Y, -1);
        g = getGrn(X, Y, -1);
        b = getBlu(X, Y, -1);
      }

      if( r < g + b + 125)
        red = false;
      
      if( red)
        fill(white);
      else
        fill(black);
      //
    
      //updatePixels();
    }
       
    rect(X, Y, pw, pw);
    X = X + pw;
    
    if( X >= width){
      if( Y >= height){
        X = width;
      }
      else 
        X = 0;
      Y = Y + pw;
    }

  }
  updatePixels();
  if(first){  println( floor( millis() / 1000)); first = false;}
}

void showInput() {
  if (allBalls != null)
    image(allBalls, 0, 0, width, height);
}

void printColor(int x, int y) {
  
  loadPixels();
  color curr = pixels[ y * height + x ];  //curr = get(y,x);

  float redVal = curr >> 16 & 0xFF; // Very fast to calculate 
  float grnVal = curr >> 8 & 0xFF; // Very fast to calculate 
  float bluVal = curr & 0xFF; // Very fast to calculate 
  int r,g,b;

  r = floor(redVal);
  g = floor(grnVal);
  b = floor(bluVal);

  println( "rgb (" + r + ", " + g +  ", " + b + ")" );
  
  /*
    fill(color(r,g,b));
    rect( 0, 0, width, height);
  //*/

}

color temp;
int getRed(int x, int y, int i){
  //the integer 0 - 255 red component value of the pixel at x,y
  //loadPixels();

  if(i == -1)
    temp = pixels[ y * height + x ];
  else
    temp = pixels[i];
  //
  float redVal = temp >> 16 & 0xFF; // Very fast to calculate 
  return floor(redVal);
}

int getGrn(int x, int y, int i){
  //the integer 0 - 255 green component value of the pixel at x,y
  //loadPixels();

  if(i == -1)
    temp = pixels[ y * height + x ];
  else
    temp = pixels[i];
  //
  float grnVal = temp >> 8 & 0xFF; // Very fast to calculate 
  return floor(grnVal);
}

int getBlu(int x, int y, int i){
  //loadPixels();

  if(i == -1)
    temp = pixels[ y * height + x ];
  else
    temp = pixels[i];
  //
  float bluVal = temp & 0xFF; // Very fast to calculate 
  return floor(bluVal);
}

void mousePressed() {
  //println(mouseX + ", " + mouseY);
  printColor(mouseX, mouseY);
}

void keyPressed(){
  if(key == 's')
    showInput();
  if(key == 'r')
    RedBinaryFilter();
}

void RedBinaryFilter(){
  loadPixels();
  color black = color(0);
  color white = color(255);
  for(int i = 0; i < width * height; i++){
    println("working on pixel: " + i + " Out of " + width*height);
    if( i > 0){
      int percent = floor(i / (width * height));
      println( percent + "% finished");
    }
    boolean red = true;
    color curr = pixels[i];
    int r = getRed(0,0,i);
    int g = getGrn(0,0,i);
    int b = getBlu(0,0,i);

    if( r < g + b)
      red = false;
    if( red)
      pixels[i] = white;
    else
      pixels[i] = black;
  }
  updatePixels();
}
