//recognise different pool balls

PImage allBalls;



void setup() {
  size(250, 250);


  allBalls = loadImage("poolBalls.jpg");
  showInput();
  colorMode(RGB, 255);
  noStroke();
}

boolean first = true;
int iterator = 0;
color black = color(0);
color white = color(255);

void draw() {
  if(iterator < width * height){
    loadPixels();
  
    println("working on pixel: " + iterator + " Out of " + width*height);

    if( iterator > 0){
      int percent = floor(iterator / (width * height));
      println( percent + "% finished");
    }

    boolean red = true;
    color curr = pixels[iterator];
    int r = getRed(0,0,iterator);
    int g = getGrn(0,0,iterator);
    int b = getBlu(0,0,iterator);

    if( r < g + b)
      red = false;
    if( red)
      pixels[iterator] = white;
    else
      pixels[iterator] = black;
    iterator++;

    updatePixels();
  }
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

int getRed(int x, int y, int i){
  //the integer 0 - 255 red component value of the pixel at x,y
  loadPixels();
  color curr;

  if(i == -1)
    curr = pixels[ y * height + x ];
  else
    curr = pixels[i];
  //
  float redVal = curr >> 16 & 0xFF; // Very fast to calculate 
  return floor(redVal);
}

int getGrn(int x, int y, int i){
  //the integer 0 - 255 green component value of the pixel at x,y
  loadPixels();
  color curr;

  if(i == -1)
    curr = pixels[ y * height + x ];
  else
    curr = pixels[i];
  //
  float grnVal = curr >> 8 & 0xFF; // Very fast to calculate 
  return floor(grnVal);
}

int getBlu(int x, int y, int i){
  loadPixels();
  color curr;

  if(i == -1)
    curr = pixels[ y * height + x ];
  else
    curr = pixels[i];
  //
  float bluVal = curr & 0xFF; // Very fast to calculate 
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

