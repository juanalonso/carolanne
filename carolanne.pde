// https://github.com/juanalonso/carolanne
// Feedback welcome

import gab.opencv.*;
import processing.video.*;
import java.awt.Rectangle;

Capture video;
OpenCV opencv;
Rectangle[] faces;

int CV_POSTBLUR = 0;
int DELAY = 2000;

int DETECT_MINNEIGHBOURS = 8;
int DETECT_MINSIZE = 0;
int DETECT_MAXSIZE = 100;

int lastPicture = 0;
int camW = 640, camH = 480;

boolean doDilate = true;
boolean doThreshold = true;
int thresvalue = 190;
int preblur = 4;

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

    if (doThreshold) {
        opencv.threshold(thresvalue);
    }

    if (doDilate) {
        opencv.dilate();
        opencv.erode();
    }

    if (preblur > 0) {
        opencv.blur(preblur);
    }


    faces = opencv.detect(1.1, DETECT_MINNEIGHBOURS, 0, DETECT_MINSIZE, DETECT_MAXSIZE);
    //faces = opencv.detect();

    if (CV_POSTBLUR > 0) {
        opencv.blur(CV_POSTBLUR);
    }

    PImage snapshot = opencv.getSnapshot();

    image(snapshot, 0, 0);

    if (faces.length > 0) {

        if (millis()-lastPicture > DELAY) {

            image(snapshot, camW, 0);

            noFill();
            stroke(235,40,40);

            PImage faceMain = video.get(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
            PImage faceTreated = get (faces[0].x + camW, faces[0].y, faces[0].width, faces[0].height);
            rect(faces[0].x + camW, faces[0].y, faces[0].width, faces[0].height);
            PImage ocvImage = get (camW, 0, camW, camH);

            //            for (int i = 0; i < faces.length; i++) {
            //                rect(faces[i].x + camW, faces[i].y, faces[i].width, faces[i].height);
            //            }

            String dateTime = String.format("%d%02d%02d_%02d%02d%02d", 
            year(), month(), day(), 
            hour(), minute(), second()
                );

            ocvImage.save(dateTime + ".png");                
            faceMain.save(dateTime + "_m.png");                
            faceTreated.save(dateTime + "_t.png");                

            lastPicture = millis();
        }
    }
    
    image(video, camW-camW/4-5, camH-camH/4-5, camW/4, camH/4);


    fill(255);
    text("Dilate / Erode: " + (doDilate?"on":"off"), 4, 480 + 14);
    text("Threshold: " + (doThreshold?"on":"off") + " (" +thresvalue+  ")", 140, 480 + 14);
    text("Preblur: " + preblur, 280, 480 + 14);
}

void keyPressed() {

    if (key=='d' || key=='D') {
        doDilate = !doDilate;
    } else if (key=='t' || key=='T') {
        doThreshold = !doThreshold;
    } else if (key=='b' || key=='B') {
        preblur++;
        if (preblur>10) {
            preblur = 0;
        }
    }  else if (key=='+') {
        thresvalue+=10;
        if (thresvalue>255) {
            thresvalue = 0;
        }
    }
}

