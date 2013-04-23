
MJPEGParser parser;
PImage currentFrame;
PImage lastFrame;
PImage drawFrame;

int changeAmount = 200;

void setup() {
  size(800,450);
  
  //MJPEGParser parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", "root", "streamme", "--myboundary", this);
  parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", 800, 450, "root", "streamme", this); 
  
  drawFrame = createImage(800,450,RGB);
  
}

void newFrame(PImage newPimage) {
  if (currentFrame != null) {
    lastFrame = currentFrame;
  }
  
  currentFrame = newPimage;
  
  if (lastFrame != null && currentFrame != null) {

    lastFrame.loadPixels();
    currentFrame.loadPixels();
    
    drawFrame.loadPixels();
    
    synchronized(currentFrame.pixels) {
      for (int p = 0; p < currentFrame.pixels.length; p++) {
      
        float r = currentFrame.pixels[p] >> 16 & 0xFF; // red(currentFrame.pixels[p]);
        float g = currentFrame.pixels[p] >> 8 & 0xFF; // green(currentFrame.pixels[p]);
        float b = currentFrame.pixels[p] & 0xFF; // blue(currentFrame.pixels[p]);
      
        float pr = lastFrame.pixels[p] >> 16 & 0xFF;
        float pg = lastFrame.pixels[p] >> 8 & 0xFF;
        float pb = lastFrame.pixels[p] & 0xFF;
        
        float diff = dist(r,g,b,pr,pg,pb);
      
        //print(pr + "-" + r + " = " + (pr - r) + "\t");
        if (diff > mouseX) {
        //if ((abs(pr - r) + abs(pg - g) + abs(pb - b)) > changeAmount) {
        
          drawFrame.pixels[p] = color(0,0,255);  
          //print("" + (abs(pr - r) + abs(pg - g) + abs(pb - b)));
        
        } else {
         
          drawFrame.pixels[p] = color(r,g,b);
          
        }
     }
    }
  }

  println(mouseX);
  drawFrame.updatePixels();  
}

void draw() {
  
  //if (currentFrame != null) {
    //synchronized (currentFrame.pixels) {
    //  lastFrame = currentFrame.get();
      //lastFrame.copy(currentFrame, 0, 0, currentFrame.width, currentFrame.height, 0, 0, currentFrame.width, currentFrame.height);
      //lastFrame.updatePixels();
      
    //}
  //}
  
  //println(currentFrame +  " " + lastFrame);
  
  //currentFrame = parser.getPImage();
  
  if (drawFrame != null) {
    image(drawFrame,0,0);
  }
}
