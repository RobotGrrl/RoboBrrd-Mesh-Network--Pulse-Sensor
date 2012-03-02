/*
 Impy RoboBrrd
 --------------
 
 Nov 14, 2011
 robotgrrl.com
 
 Examples of how you can program your RoboBrrd!
 
 CC BY-SA
 */

#include <Servo.h> 
#include <Streaming.h>
#include <PN532.h>

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


#define SCK 13
#define MOSI 11
#define SS 10
#define MISO 12

PN532 nfc(SCK, MISO, MOSI, SS);

Servo beakServo, rwingServo, lwingServo, rotationServo;

// Servos
int BEAK = 9;
int RWING = 8;
int LWING = 7;
int ROTATION = 6;
int HULA = 4;

// LEDs
int RED = A5;
int GREEN = A4;
int BLUE = A3;

// Misc
int SPKR = 5;
int LDR_R = A0;
int LDR_L = A1;

// Positions
int BEAK_OPEN = 75;
int BEAK_CLOSED = 30;
int BEAK_MIDDLE = 53;

int RWING_UP = 130;
int RWING_DOWN = 65;
int RWING_MIDDLE = 80;

int LWING_UP = 70;
int LWING_DOWN = 135;
int LWING_MIDDLE = 110;

int LEFT = 180;
int RIGHT = 0;
int MIDDLE = 90;

int pos = RWING_DOWN;
char c_char;
boolean stopped = false;
boolean forwards = true;

int ledR = 0;
int ledG = 0;
int ledB = 0;

int ledR_0 = 255;
int ledG_0 = 255;
int ledB_0 = 255;

int fadeCount = 0;
int fadeColour = 0;


int turn = 0;
boolean left = false;

int ldrLprev;
int ldrRprev;
int thresh = 30;

int hat = 0;
int phat = 0;

int ldrL_home;
int ldrR_home;
int ldr_thresh = 30;

char pulse = 'n';
boolean recu = false;
int repcount = 0;
int lastpulse = 0;


void setup()  {

  Serial.begin(9600);

  Serial.println("Jellow!");

  Serial1.begin(9600);

  XNPsetHostsFile(); 

  Serial.println("Hello!");


  nfc.begin();
  Serial.println("nfc begin!");

  uint32_t versiondata = nfc.getFirmwareVersion();
  if (! versiondata) {
    Serial.print("Didn't find PN53x board");
    while (1); // halt
  }
  // Got ok data, print it out!
  Serial.print("Found chip PN5"); 
  Serial.println((versiondata>>24) & 0xFF, HEX); 
  Serial.print("Firmware ver. "); 
  Serial.print((versiondata>>16) & 0xFF, DEC); 
  Serial.print('.'); 
  Serial.println((versiondata>>8) & 0xFF, DEC);
  Serial.print("Supports "); 
  Serial.println(versiondata & 0xFF, HEX);

  // configure board to read RFID tags and cards
  nfc.SAMConfig();
  Serial.println("nfc samconfig!");


  // Attach all the servos
  beakServo.attach(BEAK);
  rwingServo.attach(RWING);
  lwingServo.attach(LWING);
  rotationServo.attach(ROTATION);

  // Set the servos
  beakServo.write(BEAK_MIDDLE);
  rwingServo.write(RWING_MIDDLE+20);
  lwingServo.write(LWING_MIDDLE-20);
  rotationServo.write(MIDDLE);

  // Set up all the other pins
  pinMode(HULA, OUTPUT);
  digitalWrite(HULA, LOW);

  pinMode(LDR_R, INPUT);
  pinMode(LDR_L, INPUT);

  pinMode(SPKR, OUTPUT);
  pinMode(RED, OUTPUT);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);

  // Evaluate LDRs
  evaluateLDRs();

  // Random chirp!
  //randomChirp();

} 


void loop() { 


  checkNFC();

  if(hat != phat) {

    switch (hat) {
    case 0:
      eyesWhite();
      break;
    case 1: // top hat
      for(int i=0; i<3; i++) {
        eyesWhite();
        delay(100);
        eyesBlue();
        delay(100);
      }
      break;
    case 2: // red maker hat
      for(int i=0; i<3; i++) {
        eyesWhite();
        delay(100);
        eyesRed();
        delay(100);
      }
      break;
    case 3: // purple robot hat
      for(int i=0; i<3; i++) {
        eyesWhite();
        delay(100);
        eyesPurple();
        delay(100);
      }
      break;
    case 4: // green hat
      for(int i=0; i<3; i++) {
        eyesWhite();
        delay(100);
        eyesGreen();
        delay(100);
      }
      break;
    default:
      break;
    }

  XNPhatSend();

  }

  phat = hat;
  
  

  if(ENABLE_PACKET_ENGINE == 1) {

    XNPreadSerialBus();

    Serial.println("\n pulse: " + pulse);

    if(recu) {

      if(pulse == '1') {

        //delay(140);

        //updateLights();
        
        switch(hat) {
          case 0:
            bothWings(1, 150);
            break;
          case 1:
            bothWings(1, 150);
            break;
          case 2:
            bothWings(1, 150);
            break;
          case 3:
            beakServo.write(BEAK_OPEN);
            quickChirp();
            beakServo.write(BEAK_CLOSED);
            break;
          case 4:
            shakeNo();
            break;
        }
        

        //Serial.print("!");

        //wingsWave();
        //quickChirp();
        //delay(100);

        lastpulse = repcount;

      }

      recu = false;
      
    } else {

      if(repcount-lastpulse >= 1000) {
        shakeNo();
        repcount = 0;
        lastpulse = 0;
      }

    }

    repcount++;

    delay(10);

  }


}



void XNPhatSend() {
    
  Serial.println("sending func"); delay(50);
  
  sprintf(destination, "LP");

  sprintf(payload, "H%d", hat);    

  XNPsendDataPacket(destination, payload, 3);
  
}


void checkNFC() {

  uint32_t id;
  // look for MiFare type cards
  id = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A);

  if (id != 0) {

    uint8_t keys[]= {
      0xFF,0xFF,0xFF,0xFF,0xFF,0xFF                        };
    if(nfc.authenticateBlock(1, id ,0x08,KEY_A,keys)) //authenticate block 0x08
    {
      //if authentication successful
      uint8_t block[16];
      //read memory block 0x08
      if(nfc.readMemoryBlock(1,0x08,block)) {
        //if read operation is successful

        if(block[0] == 1) {
          //Serial.println("top hat");
          hat = 1;
        } 
        else if(block[0] == 2) {
          //Serial.println("red maker hat");
          hat = 2;
        } 
        else if(block[0] == 3) {
          //Serial.println("purple robot hat");
          hat = 3;
        } 
        else if(block[0] == 4) {
          //Serial.println("green hat");
          hat = 4;
        }

      }
    }
  } 
  else {
    //Serial.println("no hat");
    hat = 0;
  }

}








