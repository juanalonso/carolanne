# Carol Anne
### Find faces hidden in white noise

It all started when we were talking about an old restored TV: "I can only get white noise" We started joking about the film Poltergeist and Carol Anne, the little girl hypnotized by the static-filled screen.

So, this project was born: Can a computer, using computer vision algorithms, detect faces in a TV displaying only white noise? Can a person identify those faces? Let’s see.

The sketch, written in Processing 2.2.1, uses [Greg Borenstein’s](https://twitter.com/atduskgreg) OpenCV wrapper for Processing, available at [his GitHub repo](https://github.com/atduskgreg/opencv-processing).

The filters are applied in the following order:

1. Threshold
2. Dilate / erode
3. Blur
4. Face detection 

Keyboard shortcuts
* D/d: toggle dilate / erode filters
* T/t: toggle image thresholding
* +: Increase threshold
* B/b: increase blurring, from zero (no blurring) to ten
