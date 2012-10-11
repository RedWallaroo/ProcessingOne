import krister.Ess.*;
AudioChannel myInput;
FFT myFFT;
 
int bufferSize = 512;
int steps;
float limitDiff;
int numAverages=4;
float myDamp=.6f;
float maxLimit,minLimit;
int bufferDuration;

float rotation = PI-0.5; //rotation
float strokelen; //length of stroke
float x2=100, y2=100;

int dim=30;
float[] x = new float[dim];
float[] y = new float[dim];
float r, g, b;
float theta = 0;
boolean isPlaying = true; //check if music is playing
 
void setup(){
  background(0,0,0);
  r=random(255);
  g=random(255);
  b=random(255);
  x[0]=(0);
  y[0]=(height/2);
  size(900,400);
  frameRate(30);
  for(int i=1;i<dim;i++){
    x[i]=x[i-1]+(width/dim);
    y[i]=height/2;
  }
  Ess.start(this);
  // set up our AudioInput
  myInput = new AudioChannel("saeed.mp3");
    
  // set up our FFT
  myFFT= new FFT(bufferSize);
  myFFT.equalizer(true);
   
  // set up our FFT normalization/dampening
  minLimit=.005;
  maxLimit=.05;
  myFFT.limits(minLimit,maxLimit);
  myFFT.damp(myDamp);
  myFFT.averages(numAverages);
  myInput.play(Ess.FOREVER);
 
}
 
void draw(){
  
  if (isPlaying){
  myFFT.getSpectrum(myInput);
  newCol();
  stroke(r,g,b,5);
  
  strokelen = 10;
   for (int i=1; i<dim; i++) {
  //float temp=max(0,185-myFFT.spectrum[i]*-400); original
   float temp=min(50, max(0, (myFFT.spectrum[i]*4000)));
 
     //calculating the next x and y positions
   if (temp > 45){
    y2 = strokelen + sin(radians((temp)*100)+(PI/dim * i)+rotation);
    x2 = strokelen + cos(radians((temp)*100)+(PI/dim * i)+rotation); 
    line(x[i-1],y[i-1],x2+x[i],y2+y[i]);
   }
   }
  
   newcord();
   border();
  }
}
 
void newcord(){
  for(int i=0;i<dim;i++){
    x[i] += random(-5,5);
  
    if(i > 0){if(x[i] < x[i-1]){x[i]=x[i-1];}} 
    y[i] += random(-4,4);
    
  }
  x[dim-1]=width;
  y[dim-1]=height/2;
  x[0]=0;
  y[0]=height/2;
}
 
void newCol(){
  r+=random(-10,10);
  g+=random(-10,10);
  b+=random(-10,10);
}
 
void border(){
  for(int i=0;i<dim;i++){
    if(x[i]<0){x[i]=0;}
    if(y[i]<0){y[i]=0;}
     
    if(x[i]>width){x[i]=width;}
    if(y[i]>height){y[i]=height;}
  }
}
 
void mousePressed(){
  r=random(255);
  g=random(255);
  b=random(255);
}

void audioChannelDone(AudioChannel ch){
  isPlaying = false;
}

// clean up Ess before exiting

public void stop() {
  Ess.stop();
  super.stop();
}
