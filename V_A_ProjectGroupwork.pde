// Backup image to resize from
PImage bg;
// The picture to draw every time
PImage sky;

// The size of the background
int size;

void setup() {
  size(750, 750);
  bg = loadImage("starMap.jpg");
  sky = bg.copy();
  
  // Initial size of the star consteallation map
  size = 750;
  resizeMap();
  
  // Draw always around a center
  imageMode(CENTER);
}

void draw() {
  background(#000000);
  // Draw the map at the center of the window
  image(sky, 375, 375);
}

void mouseWheel(MouseEvent event) {
  int newSize = size;
  
  // Calculate how much enlarge or shrink the constellation map
  float zoom = 0.95 * event.getCount();
  if (zoom < 0) {
    // Enlarging the map
    newSize = (int) Math.abs(size / zoom);
  }
  if (zoom > 0) {
    // Shrinking the map
    newSize = (int) Math.abs(size * zoom);
  }
  
  // Set constraints on the image (maximum and minimum sizes)
  if (size > 2075) {
    newSize = 2075;
  } else if (size < 750) {
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
