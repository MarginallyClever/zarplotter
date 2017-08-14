// animated belt length calculator
// dan royer (dan@marginallyclever.com) 2017-08-14
final float MOTOR = 45;
final float PLOTTER = 60;
final float PLOTTER_HALF = PLOTTER / 2;

float px,py;
float right,left,top,bottom;


void setup() {
  size(608,602);  // size of machine
  
  right  = (width/2.0) -PLOTTER_HALF -MOTOR;
  left   = -right;
  top    = (height/2.0) -PLOTTER_HALF -MOTOR;
  bottom = -top;
  println("("+left+","+top+") - ("+right+","+bottom+")");
  
  px=0;
  for(py=0;py<=100;py+=5) {
    testBeltLength();
  }
  
  px=width/2;
  py=height/2;
}

void testBeltLength() {
  float dx,dy;
  
  print(px*0.1+" ");
  print(py*0.1+" ");
  dx=(px- left)*0.1; dy=(py-   top)*0.1; float a = sqrt(dx*dx+dy*dy);  print(a+" ");
  dx=(px-right)*0.1; dy=(py-   top)*0.1; float b = sqrt(dx*dx+dy*dy);  print(b+" ");
  dx=(px- left)*0.1; dy=(py-bottom)*0.1; float c = sqrt(dx*dx+dy*dy);  print(c+" ");
  dx=(px-right)*0.1; dy=(py-bottom)*0.1; float d = sqrt(dx*dx+dy*dy);  print(d+"\n");
}


void mouseDragged() {
  float mdx = mouseX - pmouseX;
  float mdy = mouseY - pmouseY;
  px+=mdx;
  py+=mdy;
  // will update entire picture on next draw()
}

void draw() {
  background(128,128,128);
  drawA4();
   
  drawMotors();
  drawPlotter();
  drawBelts();
}

void drawA4() {
  noFill();
  stroke(64,64,64);
  float w=297;
  float h=210;
  rect((width/2.0)-(w/2.0),
       (height/2.0)-(h/2.0),
       w,
       h);
}


void drawMotors() {
  noStroke();
  fill(0,0,0);
  rect(          0,           0,MOTOR,MOTOR);
  rect(width-MOTOR,           0,MOTOR,MOTOR);
  rect(          0,height-MOTOR,MOTOR,MOTOR);
  rect(width-MOTOR,height-MOTOR,MOTOR,MOTOR);
}

void drawPlotter() {
  noStroke();
  fill(192,192,192);
  rect(px-PLOTTER_HALF,py-PLOTTER_HALF,PLOTTER,PLOTTER);
  fill(255,255,255);
  text("("+px+","+py+")",px,py);
}

void drawBelts() {
  fill(255,255,255);
  stroke(255,  0,  0);  line2(      MOTOR,       MOTOR,px-PLOTTER_HALF,py-PLOTTER_HALF);
  stroke(  0,255,  0);  line2(width-MOTOR,       MOTOR,px+PLOTTER_HALF,py-PLOTTER_HALF);
  stroke(  0,  0,255);  line2(      MOTOR,height-MOTOR,px-PLOTTER_HALF,py+PLOTTER_HALF);
  stroke(255,255,255);  line2(width-MOTOR,height-MOTOR,px+PLOTTER_HALF,py+PLOTTER_HALF);
}

void line2(float x1,float y1,float x2,float y2) {
  line(x1,y1,x2,y2);
  float dx=(x1-x2)*0.1;
  float dy=(y1-y2)*0.1;
  float d=sqrt(dx*dx+dy*dy);
  text(d,x1,y1);
}