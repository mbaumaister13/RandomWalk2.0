import controlP5.*;

RandomWalker walk;
Square square;
Hexagon hex;
ControlP5 controlP5;
controlP5.Button start;
controlP5.DropdownList shape;
controlP5.Slider stepCount;
controlP5.Textlabel stepct;
controlP5.Slider stepRate;
controlP5.Textlabel steprt;
controlP5.Slider stepSize;
controlP5.Textlabel stepsz;
controlP5.Slider stepScale;
controlP5.Textlabel stepscl;
controlP5.Toggle constrain;
controlP5.Toggle terrain;
controlP5.Toggle stroke;
controlP5.Toggle seed;
controlP5.Textfield seedVal;
boolean draw = false;
boolean reset = false;
boolean strt = false;

void rectangle() { //Draws UI rectangle
  rectMode(CORNER);
  fill(80);
  rect(0, 0, 200, 800);
}

void reset() { //Resets values everytime start is pressed
  background(129, 180, 250);
  rectangle();
  square.step = 0;
  square.steps = 0;
  square.r = 0;
  square.g = 0;
  square.b = 0;
  square.x = width/2;
  square.y = height/2;
  square.count.clear();
  hex.step = 0;
  hex.steps = 0;
  hex.r = 0;
  hex.g = 0;
  hex.b = 0;
  hex.x = width/2;
  hex.y = height/2;
  hex.count.clear();
  reset = true;
  strt = true;
  if(seed.getState()) { //Sets the random seed to the textfield, and to a random number otherwise
    randomSeed(Integer.parseInt(seedVal.getText()));
  } else {
    randomSeed((long)random(100000000));
  }
}

void setup() { //Creates the window and the UI
  size(1200, 800); //Size of window
  background(129, 180, 250); //Sets background color
  rectangle();
  controlP5 = new ControlP5(this);
  walk = new RandomWalker(); 
  square = new Square();
  hex = new Hexagon();
  
  start = controlP5.addButton("Start", 0, 10, 7, 100, 30).setColorBackground(color(0, 150, 0)).setColorForeground(color(0, 200, 0)).setColorActive(color(0, 175, 0)); //Start button
  
  shape = controlP5.addDropdownList("Shape").setPosition(10, 45).setSize(175, 140).setBarHeight(40).addItem("Squares", 0).setItemHeight(40).addItem("Hexagons", 1).setItemHeight(40).close(); //Shape dropdown
  
  stepCount = controlP5.addSlider("Maxstep").setRange(100, 50000).setPosition(10, 200).setSize(180, 20).setDecimalPrecision(0); //Step count slider
  stepRate = controlP5.addSlider("Steprate").setRange(1, 1000).setPosition(10, 250).setSize(180, 20).setDecimalPrecision(0); //Step rate slider
  stepSize = controlP5.addSlider("Stepsize").setRange(10, 30).setPosition(10, 350).setSize(75, 20).setDecimalPrecision(0); //Shape size slider
  stepScale = controlP5.addSlider("Stepscale").setRange(1.0, 1.5).setPosition(10, 400).setSize(75, 20); //Step scale slider
  
  controlP5.getController("Maxstep").setCaptionLabel(""); //Removes labels of all of the sliders
  controlP5.getController("Steprate").setCaptionLabel("");
  controlP5.getController("Stepsize").setCaptionLabel("");
  controlP5.getController("Stepscale").setCaptionLabel("");
  
  constrain = controlP5.addToggle("Constrain Steps", 10, 600, 25, 25); //Constrain toggle
  
  terrain = controlP5.addToggle("Simulate Terrain", 10, 650, 25, 25); //Terrain toggle
  
  stroke = controlP5.addToggle("Use Stroke", 10, 700, 25, 25); //Stroke toggle
  
  seed = controlP5.addToggle("Use Random Seed", 10, 750, 25, 25); //Seed toggle
  
  seedVal = controlP5.addTextfield("Seed Value", 110, 750, 60, 25).setInputFilter(ControlP5.INTEGER).setText("0"); //Seed input textfield
  
  stepct = controlP5.addTextlabel("Maximum Steps").setPosition(8, 185).setText("Maximum Steps"); //Adds all of the text labels above the sliders
  steprt = controlP5.addTextlabel("Step Rate").setPosition(8, 235).setText("Step Rate");
  stepsz = controlP5.addTextlabel("Step Size").setPosition(8, 335).setText("Step Size");
  stepscl = controlP5.addTextlabel("Step Scale").setPosition(8, 385).setText("Step Scale");  
}

void draw() {
  if(start.isPressed()) { //Checks if start is activated
    reset(); //Resets variables //<>//
    draw = true; //Allows the random walk to be displayed gradually, and also allows the remainder of iterations to be displayed if gradual is deactivated after starting
  }
  if(draw && reset && strt && !start.isPressed()) { //Only runs after start has been pressed and released, and the reset function has been called
    for(int i = 0; i < stepRate.getValue(); i++) { //Iterates through all of the iterations and displays them based on how many steps determined by the slider
      if(shape.getValue() == 0) { //Call square functions if square is chosen
        square.Update((int)stepSize.getValue(), stepScale.getValue(), constrain.getState());//Uses size, scale and constrain to determine where to move
        square.Draw(stepCount.getValue(), terrain.getState(), (int)stepSize.getValue(), stroke.getState()); //Uses step count, terrain, size and stroke as parameters
      } else if(shape.getValue() == 1) { //Call hexagon functions if hexagon is chosen
        hex.Update((int)stepSize.getValue(), stepScale.getValue(), constrain.getState()); //Uses size, scale and constrain to determine where to move
        hex.Draw(stepCount.getValue(), terrain.getState(), (int)stepSize.getValue(), stroke.getState()); //Uses step count, terrain, size and stroke as parameters
      }
    }
  }
  rectangle(); //Redraws the background rectangle each frame so the shapes don't get drawn over it
}
