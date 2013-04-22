
MJPEGParser parser;

void setup() {
  size(800,450);
  
  //MJPEGParser parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", "root", "streamme", "--myboundary", this);
  parser = new MJPEGParser("http://128.122.151.228/mjpg/video.mjpg", 800, 450, "root", "streamme", this); 
}

void draw() {
  image(parser.getPImage(),0,0);  
}
