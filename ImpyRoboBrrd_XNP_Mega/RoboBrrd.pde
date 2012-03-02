
void sing(int from, int to, int del) {
  
  if(from < to) {
  
    for(int i=from; i<to; i++) {
      playTone(i, del);
    }
  
  } else {
    
    for(int i=from; i>to; i--) {
      playTone(i, del);
    }
    
  }
}


// ----

void quickChirp() {
 
 for(int j=0; j<5; j++) {
    for(int i=100; i<200; i++) {
      playTone(i, 1);
    }
    delay(100);
  }
  
}

void dataGarble() {
  for(int i=0; i<50; i++) {
    long func = 1000*sin(i);
    int scale = (int)map(func, -1000, 1000, 50, 200);
    playTone(scale, 10);
  }
}


// ----

void eyesBlue() {
    digitalWrite(RED, HIGH);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, LOW);
}

void eyesRed() {
    digitalWrite(RED, LOW);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, HIGH);
}

void eyesPurple() {
    digitalWrite(RED, LOW);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, LOW);
}

void eyesGreen() {
    digitalWrite(RED, HIGH);
    digitalWrite(GREEN, LOW);
    digitalWrite(BLUE, HIGH);
}

void eyesWhite() {
    digitalWrite(RED, LOW);
    digitalWrite(GREEN, LOW);
    digitalWrite(BLUE, LOW);
}

void eyesOff() {
    digitalWrite(RED, HIGH);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, HIGH);
}


// ------------
// D A N C E S
// ------------

void happy() {
    
    for(int i=0; i<3; i++) {
    rotationServo.write(MIDDLE+50);
    delay(500);
    
    rotationServo.write(MIDDLE-50);
    delay(500);
    }
    
    beakServo.write(BEAK_OPEN);
    delay(1000);
    
    beakServo.write(BEAK_CLOSED);
    delay(1000);
    
    delay(1000);
    
    for(int i=0; i<3; i++) {
        digitalWrite(HULA, HIGH);
        delay(5);
        digitalWrite(HULA, LOW);
        delay(100);
    }
    
    delay(1000);
    
    for(int i=0; i<3; i++) {
        rotationServo.write(MIDDLE+50);
        delay(500);
        
        rotationServo.write(MIDDLE-50);
        delay(500);
    }
    
    wingsWave();
    
    delay(1000);
    
    for(int i=0; i<3; i++) {
        digitalWrite(HULA, HIGH);
        delay(5);
        digitalWrite(HULA, LOW);
        delay(100);
    }
    
    delay(1000);
    
    delay(500);
    
}

void macarena() {
    
    playTone(700, 20);
    
    
    int sway = 5;
    int rest = 500;
    
    int angle = 60;
    
    for(int i=0; i<12; i++) {
        rotationServo.write(MIDDLE+angle+sway);
        delay(rest);
        rotationServo.write(MIDDLE+angle-sway);
        delay(rest);
    }
    
    for(int j=0; j<10; j++) {
        
        for(int i=0; i<2; i++) {
            rwingServo.write(RWING_DOWN);
            lwingServo.write(LWING_DOWN);
            rotationServo.write(MIDDLE+angle);
            
            
            rotationServo.write(MIDDLE+angle+sway);
            rwingServo.write(RWING_MIDDLE);
            delay(rest);
            
            rotationServo.write(MIDDLE+angle-sway);
            lwingServo.write(LWING_MIDDLE);
            delay(rest);
            
            
            rotationServo.write(MIDDLE+angle+sway);
            rwingServo.write(RWING_MIDDLE+sway);
            delay(rest);
            
            rotationServo.write(MIDDLE+angle-sway);
            lwingServo.write(LWING_MIDDLE-sway);
            delay(rest);
            
            
            rotationServo.write(MIDDLE+angle+sway);
            rwingServo.write(RWING_UP);
            delay(rest);
            
            rotationServo.write(MIDDLE+angle-sway);
            lwingServo.write(LWING_UP);
            delay(rest);
            
            
            rotationServo.write(MIDDLE+angle+sway);
            rwingServo.write(RWING_MIDDLE-sway);
            delay(rest);
            
            rotationServo.write(MIDDLE+angle-sway);
            lwingServo.write(LWING_MIDDLE+sway);
            delay(rest);
            
            
            rotationServo.write(MIDDLE+angle+sway);
            rwingServo.write(RWING_DOWN);
            delay(rest);
            
            rotationServo.write(MIDDLE+angle-sway);
            lwingServo.write(LWING_DOWN);
            delay(rest);
        }
        
        
        for(int i=0; i<5; i++) {
            rotationServo.write(MIDDLE+angle+(sway*2));
            delay(100);
            rotationServo.write(MIDDLE+angle-(sway*2));
            delay(100);
        }
        
        // turn
        
        turn++;
        
        if(turn%3 == 0) {
            left = !left;
            turn = 1;
        }
        
        if(left) {
            angle += 60;
        } else {
            angle -= 60;
        }
        
        rotationServo.write(MIDDLE+angle);
        
        rwingServo.write(RWING_UP);
        lwingServo.write(LWING_UP);
        
        delay(rest);
        
        rwingServo.write(RWING_MIDDLE);
        lwingServo.write(LWING_MIDDLE);
        
    }
    
}

// ---------------
// R O T A T I O N
// ---------------

void goLeft() {
    rotationServo.write(LEFT);
}

void goRight() {
    rotationServo.write(RIGHT);
}

void goMiddle() {
    rotationServo.write(MIDDLE);
}

void shakeNo() {
    
    for(int i=0; i<5; i++) {
        rotationServo.write(MIDDLE+20);
        delay(100);
        rotationServo.write(MIDDLE-20); 
        delay(100);
    }
    
    rotationServo.write(MIDDLE);
    
}

void shiver() {
    
    for(int i=0; i<5; i++) {
        rotationServo.write(MIDDLE+10);
        delay(80);
        rotationServo.write(MIDDLE-10); 
        delay(80);
    }
    
    rotationServo.write(MIDDLE);
    
}

void searching() {
    
    int curr = rotationServo.read();
    
    int lorr = (int)random(0, 2);
    int newpos = curr;
    
    if(lorr == 0) {
        newpos += (int)random(20, 60);
    } else {
        newpos -= (int)random(20, 60);
    }
    
    if(newpos > 180) newpos = 180; 
    if(newpos < 0) newpos = 0;
    
    rotationServo.write(newpos);
    
}

// ----------
// W I N G S
// ----------

void rwingWave() {
    
    for(int i=0; i<5; i++) {
        rwingServo.write(RWING_UP);
        delay(150);
        rwingServo.write(RWING_DOWN);
        delay(150);
    }
    
    rwingServo.write(RWING_MIDDLE);
    
}

void lwingWave() {
    
    for(int i=0; i<5; i++) {
        lwingServo.write(LWING_UP);
        delay(150);
        lwingServo.write(LWING_DOWN);
        delay(150);
    }
    
    lwingServo.write(LWING_MIDDLE);
    
}

void wingsWave() {
    
    for(int i=0; i<5; i++) {
        lwingServo.write(LWING_UP);
        rwingServo.write(RWING_UP);
        delay(150);
        lwingServo.write(LWING_DOWN);
        rwingServo.write(RWING_DOWN);
        delay(150);
    }
    
    lwingServo.write(LWING_MIDDLE);
    rwingServo.write(RWING_MIDDLE);
    
}

void bothWings(int repeat, int speed) {
    
    for(int i=0; i<repeat; i++) {
        lwingServo.write(LWING_UP);
        rwingServo.write(RWING_UP);
        delay(speed);
        if(repeat > 1) {
          lwingServo.write(LWING_DOWN);
          rwingServo.write(RWING_DOWN);
          delay(speed);
        }
    }
    
    lwingServo.write(LWING_MIDDLE);
    rwingServo.write(RWING_MIDDLE);
    
}


void rwingExcited() {
    
    for(int i=0; i<5; i++) {
        rwingServo.write(RWING_UP);
        delay(100);
        rwingServo.write(RWING_UP-30);
        delay(100);
    }
    
    rwingServo.write(RWING_MIDDLE);
    
}

void lwingExcited() {
    
    for(int i=0; i<5; i++) {
        lwingServo.write(LWING_UP);
        delay(100);
        lwingServo.write(LWING_UP+30);
        delay(100);
    }
    
    lwingServo.write(LWING_MIDDLE);
    
}

void wingsExcited() {
    
    for(int i=0; i<5; i++) {
        rwingServo.write(RWING_UP);
        lwingServo.write(LWING_UP);
        delay(100);
        rwingServo.write(RWING_UP-30);
        lwingServo.write(LWING_UP+30);
        delay(100);
    }
    
    rwingServo.write(RWING_MIDDLE);
    lwingServo.write(LWING_MIDDLE);
    
}

void rwingBottom() {
    
    for(int i=0; i<5; i++) {
        rwingServo.write(RWING_DOWN);
        delay(100);
        rwingServo.write(RWING_DOWN+30);
        delay(100);
    }
    
    rwingServo.write(RWING_MIDDLE);
    
}

void lwingBottom() {
    
    for(int i=0; i<5; i++) {
        lwingServo.write(LWING_DOWN);
        delay(100);
        lwingServo.write(LWING_DOWN-30);
        delay(100);
    }
    
    lwingServo.write(LWING_MIDDLE);
    
}

void wingsBottom() {
    
    for(int i=0; i<5; i++) {
        rwingServo.write(RWING_DOWN);
        lwingServo.write(LWING_DOWN);
        delay(100);
        rwingServo.write(RWING_DOWN+30);
        lwingServo.write(LWING_DOWN-30);
        delay(100);
    }
    
    rwingServo.write(RWING_MIDDLE);
    lwingServo.write(LWING_MIDDLE);
    
}


// ---------------
// P A R T Y ! ! !
// ---------------


void partyBehaviour() {
    
    playTone((int)random(20,175), (int)random(70, 150));
    updateLights();
    
}

void updateLights() {
    // TODO.
}


// -------
// L D R s
// -------


void evaluateLDRs() {
    
    int ldrL_total = 0;
    int ldrR_total = 0;
    
    for(int i=0; i<10; i++) {
        ldrL_total += analogRead(LDR_L);
        ldrR_total += analogRead(LDR_R);
        delay(100);
    }
    
    Serial << "LDR Total- L: " << ldrL_total << " R: " << ldrR_total << endl;
    
    ldrL_home = (int)ldrL_total/10;
    ldrR_home = (int)ldrR_total/10;
    
    Serial << "LDR Home- L: " << ldrL_home << " R: " << ldrR_home << endl;
    
}

void peekABooBehaviour(int ldrL, int ldrR) {
    
    if(ldrL <= (ldrLprev-50) || ldrR <= (ldrRprev-50)) {
        
        // Close eyes
        digitalWrite(RED, HIGH);
        digitalWrite(GREEN, HIGH);
        digitalWrite(BLUE, HIGH);
        
        // Wiggle the wings
        wingsExcited();
        
        // Open Eyes
        digitalWrite(RED, LOW);
        digitalWrite(GREEN, LOW);
        digitalWrite(BLUE, LOW);
        
        // Play music
        for(int i=0; i<3; i++) {
            playTone((int)random(100,200), (int)random(50, 200));
            delay(50);
        }
        
    }
    
    ldrLprev = ldrL;
    ldrRprev = ldrR;
    
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


// ----------------------
// C A L I B R A T I O N
// ----------------------


void beakCalibration() {
    
    if(Serial.available() > 0) {
        c_char = Serial.read();
        
        if(c_char == 's') {
            Serial << "Stop position: " << pos << endl;
            stopped = true;
        }
        
        if(c_char == 'g') {
            forwards = !forwards;
            stopped = false;
        }
        
    }
    
    if(!stopped) {
        if(forwards) {
            pos += 1;
        } else {
            pos -= 1;
        }
        beakServo.write(pos);
        Serial << pos << endl;
        delay(100);
        
        if(pos == 30 || pos == 75) {
            forwards = !forwards;
        }
        
    }
    
}

void rwingCalibration() {
    
    if(Serial.available() > 0) {
        c_char = Serial.read();
        
        if(c_char == 's') {
            Serial << "Stop position: " << pos << endl;
            stopped = true;
        }
        
        if(c_char == 'g') {
            forwards = !forwards;
            stopped = false;
        }
        
    }
    
    if(!stopped) {
        if(forwards) {
            pos += 1;
        } else {
            pos -= 1;
        }
        rwingServo.write(pos);
        Serial << pos << endl;
        delay(100);
        
        if(pos == RWING_UP || pos == RWING_DOWN) {
            forwards = !forwards;
        }
        
    }
    
}

void lwingCalibration() {
    
    if(Serial.available() > 0) {
        c_char = Serial.read();
        
        if(c_char == 's') {
            Serial << "Stop position: " << pos << endl;
            stopped = true;
        }
        
        if(c_char == 'g') {
            forwards = !forwards;
            stopped = false;
        }
        
    }
    
    if(!stopped) {
        if(forwards) {
            pos += 1;
        } else {
            pos -= 1;
        }
        lwingServo.write(pos);
        Serial << pos << endl;
        delay(100);
        
        if(pos == LWING_UP || pos == LWING_DOWN) {
            forwards = !forwards;
        }
        
    }
    
}



// -------------
// T E S T I N G
// -------------


void beakTest() {
    
    beakServo.write(BEAK_OPEN);
    delay(2000);
    beakServo.write(BEAK_CLOSED);
    delay(2000);
    
}

void rwingTest() {
    
    rwingServo.write(RWING_UP);
    delay(2000);
    rwingServo.write(RWING_DOWN);
    delay(2000);
    
}

void lwingTest() {
    
    lwingServo.write(LWING_UP);
    delay(2000);
    lwingServo.write(LWING_DOWN);
    delay(2000);
    
}

void rotationTest() {
    
    rotationServo.write(LEFT);
    delay(2000);
    rotationServo.write(RIGHT);
    delay(2000);
    
}

void hulaTest() {
    
    for(int i=0; i<3; i++) {
        digitalWrite(HULA, HIGH);
        delay(5);
        digitalWrite(HULA, LOW);
        delay(100);
    }
    delay(1000);
    
}

void ldrTest() {
    
    Serial << "R: " << analogRead(LDR_R) << " L: " << analogRead(LDR_L) << endl;
    delay(100);
    
}

void ledTest() {
    
    Serial << "Red" << endl;
    digitalWrite(RED, LOW);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, HIGH);
    delay(2000);
    
    Serial << "Green" << endl;
    digitalWrite(RED, HIGH);
    digitalWrite(GREEN, LOW);
    digitalWrite(BLUE, HIGH);
    delay(2000);
    
    Serial << "Blue" << endl;
    digitalWrite(RED, HIGH);
    digitalWrite(GREEN, HIGH);
    digitalWrite(BLUE, LOW);
    delay(2000);
    
}

