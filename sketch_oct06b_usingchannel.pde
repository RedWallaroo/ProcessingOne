import krister.Ess.*;
AudioChannel myChannel;
AudioChannel myinput;
FFT myFFT;

int bufferSize;
int bufferDuration;

 void setup() {
  size(532,400);
  
  //FOR DRAWSHAPE2
  frameRate(30);
  background(255);
  noStroke();
  fill(0);
// END


  Ess.start(this);
  
 //DRAWSHAPE2
 
  myinput=new AudioChannel("saeed.mp3");
  //bufferSize=myinput.buffer.length;
  bufferSize = 512;
  
  myFFT=new FFT(bufferSize*2);
  myinput.play();

  myFFT.damp(.3);
  myFFT.equalizer(true);
  myFFT.limits(.005,.05);

/* OTHER 
 myChannel=new AudioChannel("saeed.mp3");
  //println(myChannel.length());
  
   bufferSize=myChannel.buffer.length;
  bufferDuration=myChannel.ms(bufferSize);

  myFFT=new FFT(512);

  frameRate(30);
  noSmooth();
*/
 }
 
 void draw(){
  // background(0,0,255);
   //drawSpectrum();
   //drawSamples();
   drawshape3();
 }
 
  void drawSpectrum() {
  noStroke();

  myFFT.getSpectrum(myChannel);

  for (int i=0; i<256; i++) {
    float temp=max(0,185-myFFT.spectrum[i]*175);
    rect(i,temp+.5,1,height-temp+.5);
  }
}

void drawSamples() {
  stroke(255);

  // interpolate between 0 and writeSamplesSize over writeUpdateTime
  int interp=(int)max(0,(((millis()-myChannel.bufferStartTime)/(float)bufferDuration)*bufferSize));

  for (int i=0;i<256;i++) {
    float left=100;
    float right=100;

    if (i+interp+1<myChannel.buffer2.length) {
      left-=myChannel.buffer2[i+interp]*75.0;
      right-=myChannel.buffer2[i+1+interp]*75.0;
    }

    line(i,left,i+1,right);
  }
}

void mousePressed() {
  if (myChannel.state==Ess.PLAYING) {
    myChannel.stop();
  } 
  else {
    myChannel.play(Ess.FOREVER);
  }
}

 void drawshape(){ 
  
  noFill();
  beginShape();
  for (int i=0; i<800-1;i++) {
    curveVertex(i, (int)(100+myChannel.samples[i*25]*100));
  }
  endShape(); 
}

void drawshape2() {
  background(255);
  for (int i=0; i<bufferSize;i++) {
    rect(i+10,390,1,myFFT.spectrum[i]*-400);
  }
}

void drawshape3() {
  noFill();
  beginShape();
   for (int i=0; i<bufferSize;i++) {
    curveVertex(i,(int)(100+myinput.samples[i*25]*100));
    //rect(i+10,390,1,myFFT.spectrum[i]*-400);
  }
  endShape();
}
  
public void audioInputData(AudioChannel theInput) {
  myFFT.getSpectrum(myinput);
} 
  
public void stop() {
  Ess.stop();
  super.stop();
}
