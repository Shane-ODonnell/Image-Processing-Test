//recognise different pool balls

PImage allBalls;

void setup() {
  size(500, 500);

  allBalls = loadImage("poolBalls.jpg");//DudOffer
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
boolean red = false;
boolean blue = false;
boolean green = false;
int r,g,b;
int X = 0; int Y = 0;

void draw() {
  if(first)
    filter();
}

void filter(){
  while( X < width && Y < height){
    if(X < width){
      loadPixels();
      curr = white;
      red = false;
      blue = false;
      green = false;
      r = 0; g = 0; b = 0;

      if( Y < height){
        curr = pixels[ Y * height + X ];
        r = floor( curr >> 16 & 0xFF);
        g = floor( curr >> 8 & 0xFF );
        b = floor( curr & 0xFF);
      }

      if( r > g + b + 125)
        red = true;
      if( b > r + g + 25 && r < 25)
        blue = true;
      if( g > r + b + 15)
        green = true;
      //
      //fill(black);
      if( red)
        fill(white);//rect(X, Y, pw, pw);
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

  if(first){  
    println( floor( millis() / 1000)); 
    first = false;
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
  // getWhite(mouseY, mouseX); //debug
}

void keyPressed(){
  if(key == 's')
    showInput();
  if(key == 'm')
    medianFiltering(false, false);
  if(key == 'g'){ 
    X = 0; Y = 0; first = true;
  }

  if(key == 'd'){ 
    //erosion = false, dilution = true
    medianFiltering(false, true);
  }  
  if(key == 'e'){ 
    //erosion = true, dilution = false
    medianFiltering(true, false);
  }  
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

/*
  int getWhite(int row, int col){
    int count = 0;
    //written to debug

    for( int rowi = row - 1; rowi <= row + 1; rowi++){
      if( 0 < rowi && rowi < height){
        for(int coli = col - 1; coli <= col + 1; coli++){
          if( 0 < coli && coli < width ) {
            if( !(coli == col && rowi == row) ){
              println( rowi + ", " + coli);
              if( pixels[ rowi * height + coli ] == white ){
                count++;
              }
            }
          }
        }
      }
    }
    println( count );
    return count;
  }
*/

void medianFiltering(boolean erosion, boolean dilution){
  loadPixels();

  if(dilution)
    println( "applying dilution" );
  else if(erosion)
    println( "applying erosion" );
  else 
    println( "median filtering" );
  int count = 0;
  color current = black;
  color[] next = new color[width * height];
  int increment = 0;

  for(int row = 0; row < height; row++){
    for(int col = 0; col < width; col++){
      count = 0;
      if(dilution && pixels[ row * height + col ] == white || !dilution){
        for( int rowi = row - 1; rowi <= row + 1; rowi++){
          if( 0 < rowi && rowi < height){
            for(int coli = col - 1; coli <= col + 1; coli++){
              if( 0 < coli && coli < width ) {
                if( !(coli == col && rowi == row) ){
                  current = pixels[ rowi * height + coli ];
                  if( current == white && !dilution){
                    count++;
                  }           
                  else if(dilution){
                    next[ rowi * height + coli] = white;
                  } 
                }
              }
            }
          }
        }

        if(!dilution){
          //now we know how many of the pixels (out of 8) in the 3x3 area around our current pixel are white
          if((count >= 5 && !erosion) || (count >= 8 && erosion))
            next[ increment ] = white;
          else 
            next[ increment ] = black;
        }

        increment++;
      }
    }
  }
  increment = 0;

  for(int row = 0; row < width; row++){
    for(int col = 0; col < height; col++){
      pixels[increment] = next[increment];
      increment++;
    }
  }

  updatePixels();
}

/*
  void dilution(){
    println( "applying dilution" );
    loadPixels();
    color current = black;
    color[] next = new color[width * height];
    int increment = 0;

    for(int row = 0; row < height; row++){
      for(int col = 0; col < width; col++){
        current = pixels[ row * height + col ];
        if( current == white ){
          for( int rowi = row - 1; rowi <= row + 1; rowi++){
            if( 0 < rowi && rowi < height){
              for(int coli = col - 1; coli <= col + 1; coli++){
                if( 0 < coli && coli < width ) {
                  if( !(coli == col && rowi == row) ){
                    if(dilution)
                      next[ rowi * height + coli] = white;
                  }
                }
              }
            }
          }
        }
        increment++;
      }
    }
    increment = 0;

    for(int row = 0; row < width; row++){
      for(int col = 0; col < height; col++){
        pixels[increment] = next[increment];
        increment++;
      }
    }

    updatePixels();
  }
*/