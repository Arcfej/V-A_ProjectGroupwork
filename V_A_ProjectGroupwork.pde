// Backup image to resize from
PImage bg;
// The picture to draw every time
PImage sky;

// The size of the background
int size;

// The position of the centre of the constellation map
float centreX;
float centreY;

void setup() {
  size(750, 750);
  bg = loadImage("starMap.jpg");
  sky = bg.copy();
  
  // Initial size and centre of the star consteallation map
  size = 750;
  centreX = 375;
  centreY = 375;
  resizeMap();
  
  // Draw always around a center
  imageMode(CENTER);
}

void draw() {
  background(#242021);
  // Draw the map at the center of the window
  image(sky, centreX, centreY);
}

void mouseWheel(MouseEvent event) {
  int newSize = size;
  
  // Calculate how much enlarge or shrink the constellation map
  float zoom = 0.95 * event.getCount();
  if (zoom < 0) {
    // Enlarging the map
    newSize = (int) Math.abs(newSize / zoom);
  }
  if (zoom > 0) {
    // Shrinking the map
    newSize = (int) Math.abs(newSize * zoom);
  }
  
  // Set constraints on the image (maximum and minimum sizes)
  if (newSize > 2075) {
    newSize = 2075;
  } else if (newSize < 750) {
    newSize = 750;
  }
  
  //Finallize the size
  size = newSize;
  
  // Resize the map
  resizeMap();
}

// Resizing the constellation map from the backup image
void resizeMap() {
  sky = bg.copy();
  sky.resize(size, size);
}

// Change the position of the constellation map based on mouse drags
void mouseDragged() {
  float transX = pmouseX - mouseX;
  float transY = pmouseY - mouseY;
  
  centreX -= transX;
  centreY -= transY;
}
