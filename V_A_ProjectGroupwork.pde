/** Backup image to resize from */
PImage bg;
/** The picture of the constellation map */
PImage sky;

/** The scale used on the coordinate system */
float scale;

/** Constraints on the scale */
final static float biggestScale = 1.287220843672;
final static float lowestScale = 0.465260545906;

/** The position of the centre of the coordinate system compared to the window */
float centreX;
float centreY;

void setup() {
  size(750, 750);
  bg = loadImage("starMap.jpg");
  sky = bg.copy();
  
  // Initial size and centre of the coordinate system
  scale = lowestScale;
  centreX = 0;
  centreY = 0;
  
  // Save the base coordinate system
  pushMatrix();
  // Transform the coordinate system for the initial size and centre
  transformCoordinateSystem();
}

void draw() {
  background(#242021);
  sky = bg.copy();
  
  // Transform the coordinate system to the required size and position
  transformCoordinateSystem();
  
  // Draw the constellation map from the centre of the coordinate system
  image(sky, 0, 0);
}

void mouseWheel(MouseEvent event) {
  // Exit the event if mouse is pressed (e.g. dragged)
  if (mousePressed) {
    return;
  }
  
  float newScale = scale;
  
  // Calculate how much enlarge or shrink the constellation map
  float zoom = -0.05 * event.getCount();
  if (zoom > 0) {
    // Enlarging the map
    newScale = newScale + zoom;
  }
  if (zoom < 0) {
    // Shrinking the map
    newScale = newScale + zoom;
  }
  
  // Set constraints on the image (maximum and minimum sizes)
  if (newScale > biggestScale) {
    newScale = biggestScale;
  } else if (newScale < lowestScale) {
    newScale = lowestScale;
  }
  
  //Finallize the scale
  scale = newScale;
}

/** Change the position of the coordinate system based on mouse drags */
void mouseDragged() {
  float transX = pmouseX - mouseX;
  float transY = pmouseY - mouseY;
  
  centreX -= transX;
  centreY -= transY;
}

/** First shift than scale the coordinate system to the stored values */
void transformCoordinateSystem() {
  popMatrix();
  pushMatrix();
  translate(centreX, centreY); //<>//
  scale(scale);
}
