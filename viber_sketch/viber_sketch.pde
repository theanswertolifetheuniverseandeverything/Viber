// Import box2d libraries
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// Import minim libraries
import ddf.minim.*;
import ddf.minim.analysis.*;

// Physics
Box2DProcessing box2d;

ArrayList <Particle> particleList = new <Particle> ArrayList();
ArrayList <Boundary> boundaryList = new <Boundary> ArrayList();

// Audio 
Minim minim;
AudioPlayer song;
FFT fft;

int numAudioBands = 40;
boolean attractOn;

void setup() {
  size(600, 600);
  background(0);

  // Physics
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  // Enabling collision detection
  box2d.listenForCollisions();

  box2d.setGravity(0, 0);

  boundaryList.add(new Boundary(width/2, height-10, width, 20));
  boundaryList.add(new Boundary(width/2, 0, width, 20));
  boundaryList.add(new Boundary(0, height/2, 20, height));
  boundaryList.add(new Boundary(width, height/2, 20, height));

  // Audio
  minim = new Minim(this);
  song = minim.loadFile("summertime sadness.mp3");

  fft = new FFT(song.bufferSize(), song.sampleRate());
  fft.linAverages(numAudioBands);  //定义音频如何截取分割 这里我们分成10档

  for (int i = 0; i < numAudioBands; i++) {
    particleList.add(new Particle(random(10, width-10), random(10, height-10)));
  }

  song.loop();

  attractOn = false;
}

void draw() {
  //background(9, 22, 212);
  background(255);


  // Update physics
  box2d.step();

  // Update audio
  fft.forward(song.mix);

  float sizeMult; 
  for (int i = 0; i < numAudioBands; i++) {
    sizeMult = fft.getAvg(i);

    Particle p = particleList.get(i);
    p.display(sizeMult);
  }

  for (Particle p : particleList) {
    p.attract(mouseX, mouseY);
  }
}

//void mousePressed() {
//  attractOn = true;

//  if (attractOn) {
//    for (Particle p : particleList) {
//      p.attract(mouseX, mouseY);
//    }
//  }
//}


void keyPressed() {
  if (key == 'a') {
    song.pause();
  }
  if (key == 's') {
    song.play();
  }
}

// Collision Detection
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class) {
    // Casting obj
    Particle box1 = (Particle)o1;

    box1.r = 255;
    box1.g = 0;
    box1.b = 0;
  }

  if (o2.getClass() == Particle.class) {
    // Casting obj
    Particle box2 = (Particle)o2;

    box2.r = 255;
    box2.g = 0;
    box2.b = 0;
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Particle.class) {
    // Casting obj
    Particle box1 = (Particle)o1;

    box1.r = (int)random(255);
    box1.g = (int)random(255);
    box1.b = (int)random(255);
  }

  if (o2.getClass() == Particle.class) {
    // Casting obj
    Particle box2 = (Particle)o2;

    box2.r = (int)random(255);
    box2.g = (int)random(255);
    box2.b = (int)random(255);
  }
}
