// Try :
//http://opentsps.com/

MJPEGParser parser;
PImage currentFrame;
PImage lastFrame;
PImage drawFrame;

int changeAmount = 45;

String axisCamControlUrl = "http://root:streamme@128.122.151.228/axis-cgi/com/ptz.cgi?speed=50&move=";
//http://root:interact@128.122.151.53/axis-cgi/com/ptz.cgi?center=0,0 Center on a point
//http://root:interact@128.122.151.53/axis-cgi/com/ptz.cgi?move=home Move to home position

public static final int LEFT = 1;
public static final int CENTER = 2;
public static final int RIGHT = 3;

public static final String LEFT_STRING = "left";
public static final String CENTER_STRING = "home";
public static final String RIGHT_STRING = "right";

int currentRegion = CENTER;

void moveCamera(int region) 
{
  String regionString = CENTER_STRING;
  
  if (region == LEFT) 
  {
    regionString = LEFT_STRING;
  }
  else if (region == RIGHT) 
  {
    regionString = RIGHT_STRING;
  }
  
  String axisCamRequest = axisCamControlUrl + regionString;
  loadStrings(axisCamRequest);
  currentRegion = region;
}

void setup() {
  size(800,450);
  
  //MJPEGParser parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", "root", "streamme", "--myboundary", this);
  parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", 800, 450, "root", "streamme", this); 
  
  moveCamera(CENTER);
  drawFrame = createImage(800,450,RGB);
  
}


    int leftTotal = 0;
    int rightTotal = 0;
    int centerTotal = 0;
    int numFrames = 0;
    
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
        if (diff > changeAmount) {
        //if ((abs(pr - r) + abs(pg - g) + abs(pb - b)) > changeAmount) {
        
          int pp = p % currentFrame.width;
          if (pp < currentFrame.width/3) {
           leftTotal++; 
          } else if (pp < currentFrame.width/3 * 2) {
            centerTotal++;
          } else {
            rightTotal++;
          }
          
          drawFrame.pixels[p] = color(0,0,255);  
          //print("" + (abs(pr - r) + abs(pg - g) + abs(pb - b)));
        
        } else {
         
          drawFrame.pixels[p] = color(r,g,b);
          
        }
     }
    }
  }

  //println(mouseX);
  drawFrame.updatePixels();
  numFrames++;
  
  if (numFrames == 30) {
    
  if (leftTotal > centerTotal && leftTotal > rightTotal) {
     if (currentRegion > LEFT) {
       moveCamera(currentRegion-1);
     }
  } else if (rightTotal > centerTotal && rightTotal > leftTotal) {
    if (currentRegion < RIGHT) {
      moveCamera(currentRegion+1);
    }
  }
  }
  // skip 10 frames
  if (numFrames > 50) {
     numFrames = 0;
    leftTotal = 0;
    rightTotal = 0;
     centerTotal = 0;
  }
  
}

void draw() {
  
  if (drawFrame != null) {
    image(drawFrame,0,0);
  }
}
