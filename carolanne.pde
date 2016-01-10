// https://github.com/juanalonso/carolanne
// Feedback welcome

import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
Rectangle[] faces;

int CV_POSTBLUR = 0;
int CV_THRESHOLD = 180;
int DELAY = 2000;

int DETECT_MINNEIGHBOURS = 3;
int DETECT_MINSIZE = 0;
int DETECT_MAXSIZE = 100;

int lastPicture = 0;
int camW = 640, camH = 480;

boolean doDilate = false;
boolean doThreshold = false;
int preblur = 0;

void setup() {

    size(640*2, 480 + 20);
    strokeWeight(3);

    video = new Capture(this, camW, camH);
    video.start();

    opencv = new OpenCV(this, camW, camH);

    /* Detection flags 
     
     CASCADE_FRONTALFACE
     CASCADE_PROFILEFACE
     CASCADE_FULLBODY
     CASCADE_LOWERBODY
     CASCADE_UPPERBODY
     
     CASCADE_CLOCK
     CASCADE_EYE
     CASCADE_MOUTH
     CASCADE_NOSE
     CASCADE_PEDESTRIAN
     CASCADE_PEDESTRIANS
     CASCADE_RIGHT_EAR
     
     */

    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
}



void draw() {

    fill(0);
    noStroke();
    rect(0, camH, camW*2, 20);

    if (video.available() == true) {
        video.read();
    }  

    opencv.loadImage(video);

    if (preblur > 0) {
        opencv.blur(preblur);
    }

    if (doThreshold) {
        opencv.threshold(CV_THRESHOLD);
    }

    if (doDilate) {
        opencv.dilate();
        opencv.erode();
    }

    faces = opencv.detect(1.1, DETECT_MINNEIGHBOURS, 0, DETECT_MINSIZE, DETECT_MAXSIZE);
    //faces = opencv.detect();

    if (CV_POSTBLUR > 0) {
        opencv.blur(CV_POSTBLUR);
    }

    PImage snapshot = opencv.getSnapshot();

    image(video, 0, 0);
    image(snapshot, camW-camW/3-5, camH-camH/3-5, camW/3, camH/3);

    if (faces.length > 0) {
        
        if (millis()-lastPicture > DELAY) {

            image(snapshot, camW, 0);
            
            noFill();
            stroke(255);
            for (int i = 0; i < faces.length; i++) {
                rect(faces[i].x + camW, faces[i].y, faces[i].width, faces[i].height);
            }

            String dateTime = String.format("%d%02d%02d_%02d%02d%02d.png", 
            year(), month(), day(), 
            hour(), minute(), second()
                );

            PImage ocvImage = get (camW, 0, camW, camH);
            ocvImage.save(dateTime);                

            lastPicture = millis();
        }
    }

    text("Dilate / Erode: " + (doDilate?"on":"off"), 4, 480 + 14);
    text("Threshold: " + (doThreshold?"on":"off"), 133, 480 + 14);
    text("Preblur: " + preblur, 240, 480 + 14);
}

void keyPressed() {

    if (key=='d' || key=='D') {
        doDilate = !doDilate;
    } else if (key=='t' || key=='T') {
        doThreshold = !doThreshold;
    } else if (key=='b' || key=='B') {
        preblur+=2;
        if (preblur>20) {
            preblur = 0;
        }
    }
}

