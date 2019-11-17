import java.io.FileInputStream;

import edu.cmu.sphinx.api.Configuration;
import edu.cmu.sphinx.api.SpeechResult;
import edu.cmu.sphinx.api.StreamSpeechRecognizer;

/** Size of the window */
final static int windowSize = 750;

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

/**
 * A list of clickable buttons.
 * Each shows additional details about the clicked constellation.
 */
ArrayList<Button> constellationButtons = new ArrayList();

/** True if a constellation is clicked and additional details are visible */
boolean isDetailsVisible;
/** The name of the clicked constellation */
String clickedConstellation;
/** The button which closes the details window */
Button closeDetailsButton;

/** Recognize speech and can transform it into text */
StreamSpeechRecognizer recognizer;

void setup() {
  // Unfortunately using the windowSize variable here is not possible
  size(750, 750);
  sky = loadImage("starMap.jpg");
  
  // Initial size and centre of the coordinate system
  scale = lowestScale;
  centreX = 0;
  centreY = 0;
  
  // Save the base coordinate system
  pushMatrix();
  // Transform the coordinate system for the initial size and centre
  transformCoordinateSystem();
  
  // Create clickable buttons with the current scale and shift
  createButtons();
  
  try {
    setupVoiceRecognition();
  } catch(IOException e) {
    println("error");
    //print(e.getMessage().substring(0,100));
  }
}

void draw() {
  background(#242021);
  
  // Transform the coordinate system to the required size and position
  transformCoordinateSystem();
  
  // Draw the constellation map from the centre of the coordinate system
  image(sky, 0, 0);
  
  if(isDetailsVisible) {
    showDetails();
  }
}

/** Make clickable areas around the names of the constellations */
void createButtons() {
  constellationButtons.add(new Button(385, 200, 195, 75, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Hercules";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(811, 211, 162, 59, new OnClickListener() {
    public void onClick() {
      println("Cygnus");
    }
  }));
  constellationButtons.add(new Button(168, 448, 143, 53, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Boötes";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(128, 838, 91, 50, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Leo";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(276, 702, 171, 105, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Big_Dipper";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(596, 569, 243, 60, new OnClickListener() {
    public void onClick() {
      println("Little Dipper");
    }
  }));
  constellationButtons.add(new Button(961, 525, 187, 70, new OnClickListener() {
    public void onClick() {
      println("Cepheus");
    } //<>//
  }));
  constellationButtons.add(new Button(1270, 554, 187, 70, new OnClickListener() {
    public void onClick() {
      println("Pegasus");
    }
  }));
  constellationButtons.add(new Button(824, 876, 225, 59, new OnClickListener() {
    public void onClick() {
      println("Cassiopeia");
    }
  }));
  constellationButtons.add(new Button(175, 1066, 145, 59, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Cancer";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(545, 1104, 164, 71, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Gemini";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(1255, 1127, 133, 72, new OnClickListener() {
    public void onClick() {
      println("Aries");
    }
  }));
  constellationButtons.add(new Button(1042, 1212, 171, 75, new OnClickListener() {
    public void onClick() {
      println("Taurus");
    }
  }));
  constellationButtons.add(new Button(375, 1340, 254, 85, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Canis_Minor";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(496, 1442, 258, 77, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Canis_Major";
      isDetailsVisible = true;
    }
  }));
  constellationButtons.add(new Button(858, 1373, 142, 66, new OnClickListener() {
    public void onClick() {
      clickedConstellation = "Orion";
      isDetailsVisible = true;
    }
  }));
}

/**
 * Show details of a constellation in a new window
 */
void showDetails() {
  String[] details = loadStrings(clickedConstellation + ".txt");
  if (details == null) {
    println(clickedConstellation + ".txt does not exists");
    return;
  }
  
  // Draw the details window according to the program's window,
  // so return to the original coordinate system
  popMatrix();
  // Draw the details window
  fill(#ffffff);
  stroke(#000000);
  strokeWeight(1);
  rect(187.5, 187.5, 375, 375);
  // Close button square
  fill(#ff0000);
  stroke(#ff0000);
  rect(537.5, 187.5, 25, 25);
  // The x of the close button
  stroke(#ffffff);
  strokeWeight(3);
  line(542.5, 192.5, 557.5, 207.5);
  line(542.5, 207.5, 557.5, 192.5);
  closeDetailsButton = new Button(187.5, 187.5, 375, 375, new OnClickListener() {
    public void onClick() {
      clickedConstellation = null;
      isDetailsVisible = false;
    }
  });
  
  // Text contents
  textSize(12);
  fill(#000000);
  for(int i = 0; i < details.length; i++) {
    String line = details[i];
    text(line, 200, 200 + i * 40, 350, 350);
  }
  pushMatrix();
}

/** First shift than scale the coordinate system to the stored values */
void transformCoordinateSystem() {
  popMatrix();
  pushMatrix();
  translate(centreX, centreY);
  scale(scale);
}

/**
 * Set constraints on the position of the coordinate system
 * 
 * @param centreX the new x coordinate of the centre of the coordinate system (compared to the window)
 * @param centreY the new y coordinate of the centre of the coordinate system (compared to the window)
 */
void constrainPosition(float centreX, float centreY) {
  // The constraints on the position of the coordinate system (based on scale)
  final float upperConstraint = 0;
  final float lowerConstraint = -(scale * sky.height - windowSize);
  
  // Set constraints on the position of the coordinate system
  if (centreX > upperConstraint) {
    centreX = upperConstraint;
  } else if (centreX < lowerConstraint) {
    centreX = lowerConstraint;
  }
  if (centreY > upperConstraint) {
    centreY = upperConstraint;
  } else if (centreY < lowerConstraint) {
    centreY = lowerConstraint;
  }
  
  // Finalize the position of the coordinate system
  this.centreX = centreX;
  this.centreY = centreY;
}

void setupVoiceRecognition() throws IOException {
  Configuration configuration = new Configuration();

  configuration.setAcousticModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us");
  configuration.setDictionaryPath("resource:/edu/cmu/sphinx/models/en-us/cmudict-en-us.dict");
  configuration.setLanguageModelPath("resource:/edu/cmu/sphinx/models/en-us/en-us.lm.bin");

  recognizer = new StreamSpeechRecognizer(configuration);
  
  //InputStream stream = new FileInputStream(new File("test.wav"));

  //recognizer.startRecognition(stream);
  //SpeechResult result;
  //while ((result = recognizer.getResult()) != null) {
  //  System.out.format("Hypothesis: %s\n", result.getHypothesis());
  //}
  //recognizer.stopRecognition();
}

// ----------------------------
// EVENT LISTENERS
// ----------------------------

/** Enlarge or shrink the constellation map */
void mouseWheel(MouseEvent event) {
  // Don't allow zooming if the details window is visible or
  // the mouse is pressed (e.g. dragged)
  if (isDetailsVisible || mousePressed) {
    return;
  }
  
  float newScale = scale;
  
  // Calculate how much enlarge or shrink the constellation map
  float zoom = -0.05 * event.getCount();
  // TODO remove unnecessary if statements
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
  // Constrain the position, because the scale has changed
  constrainPosition(centreX, centreY);
}

/** Change the position of the coordinate system based on mouse drags */
void mouseDragged() {
  // Don't allow to drag the map when the details window is visible.
  if (isDetailsVisible) {
    return;
  }
  
  float newX = centreX - pmouseX + mouseX;
  float newY = centreY - pmouseY + mouseY;
  
  constrainPosition(newX, newY);
}

/** Checks all the buttons if it was clicked */
void mouseClicked() {
  if (isDetailsVisible) {
    if (closeDetailsButton.isInside(pmouseX, pmouseY)) {
      closeDetailsButton.onClick();
    }
  }
  // Allow clicks on constellation only if the details window is not visible
  else {
    for(Button button : constellationButtons) {
      // Transform the click position to the coordinate system and check if it's clicked
      if (button.isInside((pmouseX - centreX) / scale, (pmouseY - centreY) / scale)) {
        button.onClick();
        // Break the loop, because we found the clicked button
        break;
      }
    }
  }
}
