import processing.pdf.*;
import org.gicentre.handy.*;

PImage invader, ship;

HandyRenderer h;
boolean att[][];
int numdays;
int numpeeps;
int currday = -1;
int shipx;

void setup() {
  size(720, 600);
  
  h = HandyPresets.createColouredPencil(this);
  invader = loadImage("space_invader.png");
  ship = loadImage("space_ship.png");
  
  String lines[] = loadStrings("attendance1.csv");
  numdays = lines.length - 1;
  numpeeps = lines[0].split(",").length - 1;
  
  println("days " + numdays);
  println("peeps " + numpeeps);
  
  att = new boolean[numdays][numpeeps];
  for (int i = 1; i < lines.length - 1; i++) {
    String pres[] = lines[i].split(",");
    for (int j = 1; j < pres.length; j++) {
      att[i - 1][j - 1] = pres[j].equals("TRUE");
    }
  }

}

void draw() {
  background(0);
  noStroke();
  frameRate(1);
  
  float w = width / (numpeeps - 1.0);
  float h = (3.0 * height / 4) / (numdays - 1.0);
  float bdr = 5;
  float cnr = 10;
  
  for (int i = 0; i < numdays; i++) {
    for (int j = 0; j < numpeeps; j++) {
      if (att[i][j]) {
        int delta = currday - i;
        int opac = 112;
        if (i > 0 && att[i-1][j]) {
          opac = 255;
        }
        if (delta < 0) {
          opac = 0;
        }
        if (opac > 0) {
          tint(128, 255, 0, opac);
          image(invader, j * w + bdr, i * h + bdr, w - 2 * bdr, h - 2 * bdr);
        }
      }
    }
  }
  
  tint(255);
  image(ship,
    width / 2 + w * shipx - ship.width / 2,
    height - 60);
    
  shipx += ((abs(shipx) < 4) ? 1 : 0)
   * ((random(1) > 0.5) ? 1 : -1);

  currday++;
  if (currday >= numdays) {
    noLoop();
    //currday = 0;
  }
  
  save("standup_" + currday + ".png");
}



