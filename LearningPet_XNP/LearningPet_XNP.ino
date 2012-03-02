// LP SWMTL
// --------------


#include <Streaming.h>
#include <Servo.h>

int led = 13;
boolean debug = true;

int SPKR = A8;


//---

int IDENTITY = 4;

#define MAX_BUFFER_LENGTH 64
int MAX_BUFFER_LENGTHS = 64;
int MAX_PACKET_LENGTHS = 64;
#define MAX_PACKET_LENGTH 64
#define PAYLOAD_LENGTH 32
int PAYLOAD_LENGTHS = 32;
#define HOST_LENGTH 16
int HOST_LENGTHS = 16;
#define SERIAL_LENGTH 12
int SERIAL_LENGTHS = 12;

uint32_t INTERVAL_USER_DATA = 50;
int ENABLE_PACKET_ENGINE = 1;
int MY_PACKET_DELINEATOR = 38;

uint32_t checkTime, serialNumber, discardPackets, inPackets;

int packetFlag, packetType, forwardPacket, bufferlen, parsePosition;
int packetLength, packetPositionPointer, foundDelineator, processingPacket, packetlen;
int z, f, s, x, y, c, a, i, b;

char buffer1[MAX_BUFFER_LENGTH], buffer2[MAX_BUFFER_LENGTH], packetbuffer[MAX_PACKET_LENGTH], buffer3[MAX_BUFFER_LENGTH];
char MY_ROUTER_ID[HOST_LENGTH], CONTROL_ROUTER[HOST_LENGTH], serialnum[HOST_LENGTH], psource[HOST_LENGTH], destination[HOST_LENGTH], pdest[HOST_LENGTH], source[HOST_LENGTH];
char payload[PAYLOAD_LENGTH], ppayload[PAYLOAD_LENGTH];

long MasterCount, serialNumberOffset;

//---

//--

#define  LED3_RED       2
#define  LED3_GREEN     4
#define  LED3_BLUE      3

#define  LED2_RED       5
#define  LED2_GREEN     7
#define  LED2_BLUE      6

#define  LED1_RED       8       // eyes
#define  LED1_GREEN     10      // eyes
#define  LED1_BLUE      9       // eyes

#define  SERVO1         11      // right wing
#define  SERVO2         12      // left wing
#define  SERVO3         13      // beak
#define  SERVO4         27      // rotation

#define  TOUCH_RECV     14
#define  TOUCH_SEND     15

#define  RELAY1         A0
#define  RELAY2         A1

#define  LIGHT_SENSOR   A2
#define  TEMP_SENSOR    A3

#define  BUTTON1        A6
#define  BUTTON2        A7
#define  BUTTON3        A8

#define  JOY_SWITCH     A9      // pulls line down when pressed
#define  JOY_nINT       A10     // active low interrupt input
#define  JOY_nRESET     A11     // active low reset output

#define  ULTRASONIC     A14     // ultrasonic sensor (plug 2)
#define  ANSWER_SWITCH  A13      // answer switch (plug 2)


#define  WING_R_UPPER   30;
#define  WING_R_LOWER   90;

#define  WING_L_UPPER   110
#define  WING_L_LOWER   70      // accounts for the ultrasonic sensor height

#define  BEAK_OPEN      140
#define  BEAK_CLOSED    10


Servo servos[4];

int R_start = 0;
int G_start = 0;
int B_start = 0;
int R_pre = 0;
int G_pre = 0;
int B_pre = 0;


#define LENGTH 2

int rxBuffer[128]; 
int rxIndex  = 0;

int fadesleep = 10;
boolean fadeup = true;
int count = 0;


char pulse = 'n';
boolean recu = false;
int repcount = 0;
int lastpulse = 0;


void setup() {

  Serial.begin(9600);
  Serial.print("\r\nStart");
  
  Serial2.begin(9600); // XB
  Serial3.begin(9600); // RSK

  XNPsetHostsFile();

  pinMode(led, OUTPUT);
  digitalWrite(led, LOW);

  int p = WING_R_UPPER;
    
  servos[0].attach(SERVO1);
  servos[0].write(p);
  servos[1].attach(SERVO2);
  servos[1].write(WING_L_UPPER);

  servos[3].attach(SERVO4);
  servos[3].write(90);
  Serial.println("servos initialized");
  
  pinMode(SPKR, OUTPUT);
  
  //randomChirp();

}

void loop() {
  
  if(ENABLE_PACKET_ENGINE == 1) {
    
    XNPreadSerialBus();
    
    Serial.println("\n pulse: " + pulse);
    
    if(recu) {
      if(pulse == '1') {
        updateLights();
        
        bothWings(1, 100);
        
        /*
        if(repcount%3 == 0) {
          leftWing(1, 100);
        } else if(repcount%3 == 1) {
          rightWing(1, 100);
        } else if(repcount%3 == 2) {
          bothWings(1, 100);
        }
        */
        
        lastpulse = repcount;
        
      }
      
      recu = false;
    }  else {
       
        if(repcount-lastpulse >= 1000) {
          shake(3);
          repcount = 0;
          lastpulse = 0;
        }
        
    }
    
    repcount++;
    
    /*
    MasterCount++;
    if(MasterCount >= INTERVAL_USER_DATA) {
      XNPmySendingFunction();
      MasterCount = 0;
    }
    */
    
  }
  
  //delay(25);
  
  /*
  fade2 (R_pre,  G_pre,  B_pre, 
         128, 128, 128,
           1 );
  
  delay(10);
  */
  
}

void doVictory() {
  for(int i=0; i<3; i++) {
    fade2 (R_pre,  G_pre,  B_pre, 
           0, 255, 0,
           1 );
    openBeak(10, 5);
    
    if(i%2 == 0) {
    
      for(int i=0; i<5; i++) {
        playTone(260, 70);
        playTone(280, 70);
        playTone(300, 70);
        delay(100);
      }
    
    } else {
      
      for(int i=0; i<5; i++) {
        playTone(80, 70);
        playTone(100, 70);
        playTone(120, 70);
        delay(100);
      }
      
    }
    
    leftWing(3, 100);
    rightWing(3, 100);
    updateLights();
    closeBeak(10, 5);
    bothWings(1, 80);
  }
}

void doMatch() {
  fade2 (R_pre,  G_pre,  B_pre, 
           0, 255, 0,
           1 );
  bothWings(3, 100);
  openBeak(10, 5);
  
  for(int i=0; i<3; i++) {
    playTone(160, 70);
    playTone(180, 70);
    playTone(200, 70);
    delay(100);
  }
  
  closeBeak(10, 5);
  
}

void doWrong() {
  fade2 (R_pre,  G_pre,  B_pre, 
           255, 0, 0,
           1 );
  shake(2);
  
  openBeak(10, 5);

  //playTone(300, 300);
  playTone(50, 300);
  
  closeBeak(10, 5);
  
}


void hotkeyAction(int hotkey) {

  switch(hotkey) {
    case 1:
      openBeak(10, 5);
      break;
    case 2:
      closeBeak(10, 5);
      break;
    case 3:
      rightWing(3, 100);
      break;
    case 4:
      leftWing(3, 100);
      break;
    case 5:
      bothWings(3, 100);
      break;
    case 6:
      shake(2);
      break;
  }
  
}


// --------------
// S P E A K E R
// --------------

void randomChirp() {
    for(int i=0; i<10; i++) {
        playTone((int)random(100,800), (int)random(50, 200));
    }
}

void playTone(int tone, int duration) {
	
	for (long i = 0; i < duration * 1000L; i += tone * 2) {
		digitalWrite(SPKR, HIGH);
		delayMicroseconds(tone);
		digitalWrite(SPKR, LOW);
		delayMicroseconds(tone);
	}
	
}

