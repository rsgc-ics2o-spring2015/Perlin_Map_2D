/*
 * To the extent possible under law, Russell Gordon has waived all copyright and related
 * or neighboring rights to Perlin Map 2D illustration. This work is published from: Canada.
 * http://creativecommons.org/publicdomain/zero/1.0/
 */

// Fonts
PFont serifItalic;
PFont serif;
PFont sansSerif;

// Flag for what type of random noise to show
boolean usePerlin = true;

// Flag for whether to fill text areas to visualize Perlin noise values mapped to a grayscale fill
boolean visualize = true;

// How much of a jump through Perlin noise space to make
float increment = 0.004;

// How far from start of x-axis to retrieve Perlin noise values from
float xStart = 0.0;

// Where we are on x-axis in Perlin noise space
float xOffset = 0.0;

// How far from start of y-axis to retrieve Perlin noise values from
float yStart = 0.0;

// Where we are on y-axis in Perlin noise space
float yOffset = 0.0;

// This function runs once only.
void setup() {

  // Create canvas
  size(1400, 800);

  // White background
  background(255);

  // Set fonts
  serif = loadFont("Times-Roman-24.vlw");
  serifItalic = loadFont("Times-Italic-24.vlw");
  sansSerif = loadFont("Calibri-24.vlw");

  // Set noise detail for Perlin noise generator
  noiseDetail(8, 0.6);

  // Draw the help text
  drawHelpText();

  // Draw the axes
  drawAxes();

  // Draw the values
  drawValues();

  // No need to loop
  noLoop();
}

// This function runs repeatedly.
void draw() {
}

// keyPressed 
//
// Purpose: This function responds when keyboard keys are pressed.
//
// r: show regular random noise
// p: show Perlin noise
// arrow keys: move along x and y axes in Perlin noise space
// ]: increase the increment or "size of the leap" through Perlin noise space
// [: decrease the increment used for moving through Perlin noise space
// c: show noise values without visualization
// v: show nosie values with visualization
//
void keyPressed() {

  // Toggle display of Perlin noise values versus random values
  if (key == 'r') {
    usePerlin = false;
    refresh();
  } 
  else if (key == 'p') {
    usePerlin = true;
    refresh();
  }

  // Toggle display of Perlin noise values with visualization
  if (key == 'c') {
    visualize = false;
    refresh();
  } 
  else if (key == 'v') {
    visualize = true;
    refresh();
  }

  // Export a PNG file of the on-screen image when 's' is pressed.
  // Will be created in same folder as the .PDE file
  if (key == 's') {
    saveFrame("Perlin-map-2D-####.png");
  }

  // Change position in 2D Perlin noise space based on keypresses
  if (key == CODED) {
    if (keyCode == RIGHT && xStart < 94) {
      xStart++;
      refresh();
    }
    if (keyCode == LEFT && xStart > 0) {
      xStart--;
      refresh();
    }
    if (keyCode == UP && yStart < 94) {
      yStart++;
      refresh();
    }
    if (keyCode == DOWN && yStart > 0) {
      yStart--;
      refresh();
    }
  }

  // Change increment for how much to jump through 2D Perlin noise space
  if (key == 93) { // ']' key: increase increment
    if (increment >= 0.001 && increment < 0.01) {
      increment += 0.001;
    } 
    else if (increment > 0.009 && increment < 0.1) {
      increment += 0.01;
    } 
    else if (increment > 0.09 && increment < 0.5) {
      increment += 0.1;
    }
    //println("] " + increment); // DEBUG
    refresh();
  }
  if (key == 91) { // '[' key: decrease increment
    if (increment >= 0.002 && increment <= 0.011) {
      increment -= 0.001;
    } 
    else if (increment > 0.011 && increment <= 0.11) {
      increment -= 0.01;
    } 
    else if (increment > 0.09 && increment <= 0.51) {
      increment -= 0.1;
    }
    //println("] " + increment); // DEBUG
    refresh();
  }
  //println(keyCode); // DEBUG
}

// refresh
//
// Purpose: Re-draw the grid of values
// 
// Parameters: (none)
void refresh() {
  // Re-draw grid
  background(255);
  drawHelpText();
  drawAxes();
  drawValues();
  redraw();
}

// drawAxes
//
// Purpose: Draw horizontal and vertical axes to display random numbers with
//
// Parameters: (none)
void drawAxes() {

  // Shift everything around a bit to centre the values
  translate(width/42, height/36);

  // Draw axes
  stroke(0); // black
  strokeWeight(2);
  line(width/8, height-height/8, width-width/8, height-height/8); // horizontal
  line(width/8, height-height/8, width/8, height/8); // vertical

  // Label axes
  textFont(serifItalic);
  fill(0);
  text("x", width-width/8, height-height/8+height/24);
  text("y", width/8-width/24, height/8);

  // Arrows for end of axes
  fill(0);
  triangle(width - width/8, height-height/8-height/96, width - width/8, height-height/8+height/96, width-width/8+width/96, height-height/8); // x 
  triangle(width/8 - width/96, height/8, width/8 + width/96, height/8, width/8, height/8-width/96); // y
}

// drawValues
//
// Purpose: Draw the noise values and labels for horizontal and vertical axes
//
// Parameters: (none)
void drawValues() {

  // How much to move left and up to display grid
  float gridNumberWidth = ((width - 2*(width/8)) / 12);
  float gridWhiteSpaceWidth = (2*gridNumberWidth / 10);
  float gridNumberHeight = ((height - 2*(height/8)) / 12);
  float gridWhiteSpaceHeight = (2*gridNumberHeight / 10); 

  // Display a grid of the Perlin noise values
  textFont(serif);
  xOffset = xStart;
  for (int x = 0; x < 10; x++) {

    xOffset += increment; // Increment xOffset with each additional column
    yOffset = yStart;  // For every xOffset (column), start yOffset at yStart (Keep in same patch of Y-axis as we move along X-axis in Perlin noise space)

    // Draw x-axis labels as we go
    fill(125); // grey
    String xL;
    if (usePerlin) {
      xL = String.format("%.3f", xOffset);
      text(xL, width/8 + gridWhiteSpaceWidth*(x+1) + gridNumberWidth*x, height - height/8 + gridNumberHeight/3*2);
    } 
    else {
      xL = String.format("%3d", x + 1);
      text(xL, width/8 + gridWhiteSpaceWidth*(x+1) + gridNumberWidth*x + gridWhiteSpaceWidth/2, height - height/8 + gridNumberHeight/3*2);
    }

    // Get Perlin noise values along the y-axis for this x-axis value
    for (int y = 0; y < 10; y++) {

      // Increment yOffset
      yOffset += increment;

      // Draw y-axis labels if we're on the first column
      if (x == 0) {
        String yL;
        fill(125); // grey
        if (usePerlin) {
          yL = String.format("%.3f", yOffset);
          if (yStart > 9) {
            text(yL, width/7 - gridWhiteSpaceWidth*(x+2)/32*27 - gridNumberWidth, height - height/8 - gridWhiteSpaceHeight*1.5 - gridWhiteSpaceHeight*(y+1) - gridNumberHeight*y);
          } 
          else {
            text(yL, width/7 - gridWhiteSpaceWidth*(x+1) - gridNumberWidth, height - height/8 - gridWhiteSpaceHeight*1.5 - gridWhiteSpaceHeight*(y+1) - gridNumberHeight*y);
          }
        } 
        else {
          yL = String.format("%3d", y + 1);
          text(yL, width/7 - gridWhiteSpaceWidth*(x+2) - gridNumberWidth/7*5, height - height/8 - gridWhiteSpaceHeight*1.5 - gridWhiteSpaceHeight*(y+1) - gridNumberHeight*y);
        }
      }

      // Get noise values
      float noiseValue = 0.0;
      if (usePerlin) {
        noiseValue = noise(xOffset, yOffset); // Perlin noise values
      } 
      else {
        noiseValue = random(0, 1);  // Regular random numbers
      }

      // Show value
      fill(0); // black
      String s = String.format("%.3f", noiseValue);
      if (visualize) {
        fill(255-noiseValue*255); // black is high, white is low
      } 
      else {
        fill(0); // black is high, white is low
      }
      text(s, width/8 + gridWhiteSpaceWidth*(x+1) + gridNumberWidth*x, height - height/8 - gridWhiteSpaceHeight*1.5 - gridWhiteSpaceHeight*(y+1) - gridNumberHeight*y);
    }
  }
}

// drawHelpText
//
// Purpose: Draws the instructions on screen.
//
// Parameters:     (none)
void drawHelpText() {

  // Box with pale yellow fill
  noStroke();
  fill(255, 253, 222); // pale yellow
  rect(0, 0, width, height/12);

  // Separating line
  stroke(100);
  strokeWeight(2);
  line(0, height/12, width, height/12);

  // Help text
  textFont(sansSerif);
  fill(100);
  text("Use arrow keys to move through Perlin noise space. R: random noise. P: Perlin noise. C/V: Toggle visualization. [/]: Change Perlin increment.", width/120, height/20);
}
