import gab.opencv.*;
import processing.video.*;
import java.awt.*;

OpenCV opencv;
Capture cam;

int pw, ph;
int pixel = 10;
color c[];

void setup() {
  size(640, 480);
  cam = new Capture(this, 640, 480);
  cam.start();
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE); 
  
  pw = width / pixel;
  ph = height / pixel;
  println(pw);
  c = new color[pw * ph];
  
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  
 }

void draw() {
  image(cam, 0, 0 );
  opencv.loadImage(cam);
  background(0,75);
  opencv.calculateOpticalFlow ();
  opencv.updateBackground();
  opencv.dilate();
  opencv.erode();
  
  if (cam.available() == true) {
    cam.read();
    cam.loadPixels();
    int count = 0;
    for (int j = 0; j < ph; j++) {
      for (int i = 0; i < pw; i++) {
        c[count] = cam.get(i*pixel, j*pixel);
        count++;
      }
    }
  }
  
    for (int j = 0; j < ph; j++) {
      for (int i = 0; i < pw; i++) {
        fill(#03FF11);
        text("1",i*pixel, j*pixel);
      }
    }
    
    for (Contour contour : opencv.findContours()) {
    fill(0);
    noStroke();
    contour.draw();
    opencv.drawOpticalFlow();
  }
        
}
