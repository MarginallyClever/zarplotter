//---------------------------------
// Visualize what happens if a polargraph starts at the wrong position.
//
// blue is the believed position of the pen
// red is the actual position of the pen
// green is the difference between believed and actual positions at the start.
// click & drag to see effect as origin changes.
// also try changing values in setup() to tweak other differences. 
//
// please visit marginallyclever.com to check out our other great robot stuff.
//
// 2016-11-25 dan@marginallyclever.com
// Written in Processing 3.2.1
// CC-BY-SA-NC (https://creativecommons.org/licenses/by-nc-sa/4.0/)
//---------------------------------

class Machine {
  public float w,h;  // machine dimensions
  public float x,y;  // plotter position
  public float l,r;  // right and left belt length
  public float p;  // pulley diameter

  Machine() {
    w=width;
    h=height;
    x=w/2;
    y=h/2;
    p = 4.0/PI;
  }
  // update l,r based on x,y and w,h
  void IK() {
    float adj = x;
    float opp = y;
    l = sqrt(adj*adj+opp*opp);
    adj = w - x;
    r = sqrt(adj*adj+opp*opp);
  }
  // update x,y based on l,r and w,h
  void FK() {
    float a = l;
    float b = w;
    float c = r;
    float theta = ((a*a+b*b-c*c)/(2.0*a*b));
    x = theta * a;
    y = (sqrt( 1.0 - theta * theta ) * a);
  }
  
  void teleport(float xx,float yy) {
    x=xx;
    y=yy;
    IK();
  }
};


Machine actual, believed;
float dx, dy;  // xy deviation between actual origin and believed origin
float leftDiff, rightDiff;  // belt differences at origin


void setup() {
  size(650,800);  // machine size
  strokeWeight(3);
  dx=0;
  dy=0;
  actual = new Machine();
  believed = new Machine();

  actual.w += 20;  // Change me to see what happens!
  actual.p = 3.2/PI;  // Change me to see what happens!
  
  adjustDiff();
}


void mouseDragged() {
  float mdx = mouseX - pmouseX;
  float mdy = mouseY - pmouseY;
  dx+=mdx;
  dy+=mdy;
  adjustDiff();
  // will update entire picture on next draw()
}


void adjustDiff() {
  believed.teleport(believed.w/2.0f,believed.h/2.0f);
  actual.teleport(believed.x+dx,believed.y+dy);
  leftDiff = believed.l - actual.l;
  rightDiff = believed.r - actual.r;
}


void draw() {
  background(128,128,128);
  stroke(0,255,0);
  // believed home position to actual home position 
  line(
    believed.w/2.0f,
    believed.h/2.0f,
    believed.w/2.0f+dx,
    believed.h/2.0f+dy
  );
  // believed pulley diameter
  noFill();
  stroke(0,0,255);
  ellipse(width /2 - believed.w/2,
          height/2 - believed.h/2,
          believed.p*100,
          believed.p*100);
  ellipse(width /2 + believed.w/2,
          height/2 - believed.h/2,
          believed.p*100,
          believed.p*100);
  // actual pulley diameter
  stroke(255,0,0);
  ellipse(width /2 - actual.w/2,
          height/2 - actual.h/2,
          actual.p*100,
          actual.p*100);
  ellipse(width /2 + actual.w/2,
          height/2 - actual.h/2,
          actual.p*100,
          actual.p*100);
  
  // draw a rectangle 1/9 the size of the polargraph
  float x0,y0,x1,y1;
  x0 = believed.w/3.0f;
  y0 = believed.h/3.0f;
  x1 = believed.w*2.0f/3.0f;
  y1 = y0;
  lineInterpolate(x0,y0,x1,y1,15);
  x0=x1;
  y0=y1;
  y1=believed.h*2.0f/3.0f;
  lineInterpolate(x0,y0,x1,y1,15);
  x0=x1;
  y0=y1;
  x1=believed.w/3.0f;
  lineInterpolate(x0,y0,x1,y1,15);
  x0=x1;
  y0=y1;
  y1=believed.h/3.0f;
  lineInterpolate(x0,y0,x1,y1,15);
}  


// Draw an interpolated line so the curvature of the error is visible. 
void lineInterpolate(float x0,float y0,float x1,float y1,int steps) {
  float a=x1-x0;
  float b=y1-y0;
  float s = steps;
  
  float i;
  for(i=0;i<steps;++i) {
    lineVisual(
      x0 + a * (i  )/s,
      y0 + b * (i  )/s,
      x0 + a * (i+1)/s,
      y0 + b * (i+1)/s
    );
  }
}


// draw a line, showing the difference between believed and actual belt length
void lineVisual(float x0,float y0,float x1,float y1) {
  // believed
  stroke(0,0,255);
  line(x0,y0,x1,y1);
  // actual
  moveTo(x0,y0);
  float x0a = actual.x;
  float y0a = actual.y;
  moveTo(x1,y1);
  float x1a = actual.x;
  float y1a = actual.y;
  stroke(255,0,0);
  line(x0a,y0a,x1a,y1a);
}


// moves the believed and actual pens while maintaining consistent belt difference
void moveTo(float x,float y) {
  believed.x=x;
  believed.y=y;
  believed.IK();
  float s = actual.p / believed.p;
  actual.l = (believed.l - leftDiff)*s;
  actual.r = (believed.r - rightDiff)*s;
  actual.FK();
}