// https://github.com/juanalonso/carolanne
// Feedback welcome

import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
Rectangle[] faces;

int BLURRADIUS = 5;
int DELAY = 2000;

int lastPicture = 0;
int camW = 640, camH = 480;



void setup() {

    size(640*2, 480);
    noFill();
    stroke(255);
    strokeWeight(3);

    video = new Capture(this, camW, camH);
    video.start();

    opencv = new OpenCV(this, camW, camH);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}



void draw() {

    if (video.available() == true) {
        video.read();
    }  

    opencv.loadImage(video);
    opencv.blur(BLURRADIUS);

    faces = opencv.detect();

    image(opencv.getInput(), 0, 0);

    if (faces.length > 0) {
        if (millis()-lastPicture > DELAY) {

            image(opencv.getSnapshot(), camW, 0);
            for (int i = 0; i < faces.length; i++) {
                rect(faces[i].x + camW, faces[i].y, faces[i].width, faces[i].height);
            }

            String dateTime = String.format("CarolAnne - %d%02d%02d %02d%02d%02d.png", 
            year(), month(), day(), 
            hour(), minute(), second()
                );

            PImage ocvImage = get (camW,0,camW,camH);
            ocvImage.save(dateTime);                

            lastPicture = millis();

        }
    }

}

