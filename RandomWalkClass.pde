class RandomWalker { //Random Walk Class
  HashMap<PVector, Integer> count; //HashMap for visit counter
  PVector dir; //Directional vector for hexagon movement
  float x;
  float y;
  float angle;
  float r;
  float g;
  float b;
  int step;
  int steps;
  
  RandomWalker() { //Constructor
    count = new HashMap<PVector, Integer>();
    x = width/2;
    y = height/2;
    dir = new PVector(x, y);
    r = 0;
    g = 0;
    b = 0;
    step = 0;
    steps = 0;
  }

  void Draw(float steps, boolean clr) { //Not used for project 2
  
  }
  
  void Update() { //Also not used for project 2
    int rand = int(random(4));
    switch(rand) { 
      case 0:
        y++;
        break;
      case 1:
        y--;
        break;
      case 2:
        x++;
        break;
      case 3:
        x--;
        break;
    }
    x = constrain(x, 0, width-1); 
    y = constrain(y, 0, height-1);
  }
}

class Square extends RandomWalker { //Square class
  void Draw(float steps, boolean clr, int size, boolean strk) {
    if (step < steps) { //Draws until max steps is reached
      if (clr) { //Checks for color toggle
        if (count.get(dir) < 2) { //Less than 2 visits (I added this one for a sand color)
          r = 247;
          g = 255;
          b = 191;
        } else if (count.get(dir) < 4) { //Less than 4 visits
          r = 160;
          g = 126;
          b = 84;
        } else if (count.get(dir) < 7) { //Less than 7 visits
          r = 143;
          g = 170;
          b = 64;
        } else if (count.get(dir) < 10) { //Less than 10 visits
          r = 134;
          g = 134;
          b = 134;
        } else { //Scales color after 10 visits
          r = count.get(dir) * 20;
          g = count.get(dir) * 20;
          b = count.get(dir) * 20;
        }
      } else { //Default color
        r = 168;
        g = 4;
        b = 32;
      }
      rectMode(CENTER); 
      fill(r, g, b);
      if (strk) { //Checks for stroke toggle
        stroke(0);
      } else {
        noStroke();
      }
      rect(x, y, size, size); //Draws square
    } else { //Resets booleans once done drawing
      draw = false;
      reset = false;
      strt = false;
    }
    step++; //Increments current step
  }
  
  void Update(int size, float scale, boolean constrain) { //Generates each movement
    int rand = int(random(4));
    if (constrain) { //Checks constrain toggle
      if((rand == 3 && x - (2 * (size * scale)) <= 200) || (rand == 2 && x + (2 * (size * scale)) >= width) || (rand == 0 && y + (2 * (size * scale)) >= height) || (rand == 1 && y - (2 * (size * scale)) <= 0)) { //Sets all boundaries that the shapes can be drawn up to in each direction //<>//
        count.put(dir, count.get(dir) + 1); //Adds a visit if it hits the border
        return;
      } 
    }
    switch(rand) { //Sets new center for square based on size and scale sliders
      case 0:
        y += size * scale;
        break;
      case 1:
        y -= size * scale;
        break;
      case 2:
        x += size * scale;
        break;
      case 3: 
        x -= size * scale;
        break;
    }
    dir.x = x; //Sets vector x and y
    dir.y = y;
    if(!count.containsKey(dir)) { //Adds first visit if the shape hasn't been drawn before
      count.put(dir, 1); 
    } else { //Adds another visit if drawn before
      count.put(dir, count.get(dir) + 1); 
    }
  }
}



class Hexagon extends RandomWalker { //
  void hexagon(float x, float y, float rad) { //Hexagon draw method found on processing forums: https://forum.processing.org/two/discussion/21083/#Comment_90165
    beginShape();
    vertex(x - rad, y - sqrt(3) * rad);
    vertex(x + rad, y - sqrt(3) * rad);
    vertex(x + 2 * rad, y);
    vertex(x + rad, y + sqrt(3) * rad);
    vertex(x - rad, y + sqrt(3) * rad);
    vertex(x - 2 * rad, y);
    endShape(CLOSE);
  }  
  
  void Draw(float steps, boolean clr, int size, boolean strk) {
    if (step < steps) { //Draws until max steps is reached
      if (clr) { //Checks for color toggle
        if (count.get(dir) < 2) { //Less than 2 visits (I added this one for a sand color)
          r = 247;
          g = 255;
          b = 191;
        } else if (count.get(dir) < 4) { //Less than 4 visits
          r = 160;
          g = 126;
          b = 84;
        } else if (count.get(dir) < 7) { //Less than 7 visits
          r = 143;
          g = 170;
          b = 64;
        } else if (count.get(dir) < 10) { //Less than 10 visits
          r = 134;
          g = 134;
          b = 134;
        } else { //Scales color after 10 visits
          r = count.get(dir) * 20;
          g = count.get(dir) * 20;
          b = count.get(dir) * 20;
        }
      } else { //Default color
        r = 168;
        g = 4;
        b = 32;
      }
      fill(r, g, b);
      if (strk) { //Checks for stroke toggle
        stroke(0);
      } else {
        noStroke();
      }
      hexagon(x, y, size/2); //Draws hexagon
    } else { //Resets booleans once done drawing
      draw = false;
      reset = false;
      strt = false;
    }
    step++; //Increments current step
  }
  
  void Update(int size, float scale, boolean constrain) { //Generates each movement
    int rand = int(random(6)); 
    if (constrain) { //Checks constrain toggle
      if(((rand == 3 || rand == 2) && x - (2 * sqrt(3) * (size * scale)) <= 200) || ((rand == 0 || rand == 5) && x + (2 * sqrt(3) * (size * scale)) >= width) || (rand < 3 && y + (2 * sqrt(3) * (size * scale)) >= height) || (rand > 2 && y - (2 * sqrt(3) * (size * scale)) <= 0)) { //Sets all boundaries that the shapes can be drawn up to in each direction
        count.put(dir, count.get(dir) + 1); //Adds a visit if it hits the border
        return;
      } 
    }
    switch(rand) { //Generates each angle to move by
      case 0:
        angle = 30;
        break;
      case 1:
        angle = 90;
        break;
      case 2:
        angle = 150;
        break;
      case 3:
        angle = 210;
        break;
      case 4:
        angle = 270;
        break;
      case 5:
        angle = 330;
        break;
    }
    x += cos(radians(angle)) * sqrt(3) * size * scale; //Formulas for angled x and y movements
    y += sin(radians(angle)) * sqrt(3) * size * scale;
    dir.x = (int)x; //Sets vector x and y and casts x and y to int in case of floating point errors
    dir.y = (int)y;
    if(!count.containsKey(dir)) { //Adds first visit if the shape hasn't been drawn before
      count.put(dir, 1);
    } else { //Adds another visit if drawn before
      count.put(dir, count.get(dir) + 1);
    }
  }
}
