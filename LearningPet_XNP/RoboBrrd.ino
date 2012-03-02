
void shake(int repeat) {
    
    for(int j=0; j<repeat; j++) {
    
    for(int i=90; i>60; i--) {
        servos[3].write(i);
    }
    delay(100);
    
    for(int i=60; i<120; i++) {
        servos[3].write(i);
    }
    delay(100);
    
    for(int i=120; i>90; i--) {
        servos[3].write(i);
    }
    delay(10);
        
    }
    
    
}


void leftWing(int repeat, int speed) {
    
    for(int j=0; j<repeat; j++) {
    
        for(int i=WING_L_LOWER; i<WING_L_UPPER; i++) {
            servos[1].write(i);
        }
        delay(speed);
        
        for(int i=WING_L_UPPER; i>WING_L_LOWER; i--) {
            servos[1].write(i);
        }
        delay(speed);
        
    }
}

void rightWing(int repeat, int speed) {
    
    int l = WING_R_LOWER;
    int u = WING_R_UPPER;
    
    for(int j=0; j<repeat; j++) {
        
        for(int i=u; i<l; i++) {
            servos[0].write(i);
        }
        delay(speed);
        
        for(int i=l; i>u; i--) {
            servos[0].write(i);
        }
        delay(speed);
        
    }
}

void bothWings(int repeat, int speed) {
    
  Serial << "hello" << endl;
  
    int rl = WING_R_LOWER;
    int ll = WING_L_LOWER;
    
    for(int j=0; j<repeat; j++) {
        
        for(int i=0; i<40; i++) {
            servos[0].write(rl-20-i);
            servos[1].write(ll+i);
        }
        delay(speed);
        
        for(int i=40; i>0; i--) {
            servos[0].write(rl-20-i);
            servos[1].write(ll+i);
        }
        delay(speed);
        
    }
}

void openBeak(int speed, int step) {
    
    int b = BEAK_OPEN;
    int currentPos = servos[2].read();
    
    servos[2].attach(SERVO3);
        
    if(currentPos > b) {
        for(int i=currentPos; i>b; i-=step) {
            servos[2].write(i);
            delay(speed);
        }
    } else {
        for(int i=currentPos; i<b; i+=step) {
            servos[2].write(i);
            delay(speed);
        }
    }
    
    servos[2].detach();
    
}

void closeBeak(int speed, int step) {
    
    int b = BEAK_CLOSED;
    int currentPos = servos[2].read();
    
    servos[2].attach(SERVO3);
    
    if(currentPos > b) {
        for(int i=currentPos; i>b; i-=step) {
            servos[2].write(i);
            delay(speed);
        }
    } else {
        for(int i=currentPos; i<b; i+=step) {
            servos[2].write(i);
            delay(speed);
        }
    }
    
    servos[2].detach();
    
}


void resetValues() {
    
    // reset outputs to default values on disconnect
    analogWrite(LED1_RED, 255);
    analogWrite(LED1_GREEN, 255);
    analogWrite(LED1_BLUE, 255);
    analogWrite(LED2_RED, 255);
    analogWrite(LED2_GREEN, 255);
    analogWrite(LED2_BLUE, 255);
    analogWrite(LED3_RED, 255);
    analogWrite(LED3_GREEN, 255);
    analogWrite(LED3_BLUE, 255);
    servos[0].write(90);
    servos[1].write(90);
    servos[2].write(90);
    servos[3].write(90);
    digitalWrite(RELAY1, LOW);
    digitalWrite(RELAY2, LOW);
    
}






void updateLights() {
    
    R_start = int(random(50, 255));
    G_start = int(random(50, 255));
    B_start = int(random(50, 255));
    
    fade2( R_pre,    G_pre,      B_pre, 
          R_start,  G_start,    B_start, 
          1);
    
    R_pre = R_start;
    G_pre = G_start;
    B_pre = B_start;
    
}



void fade2 ( int start_R,  int start_G,  int start_B, 
            int finish_R, int finish_G, int finish_B,
            int stepTime ) {
    
                      Serial << "before: r pre: " << R_pre << " fadesleep: " << fadesleep << endl;
              
    int skipEvery_R = 256/abs(start_R-finish_R); 
    int skipEvery_G = 256/abs(start_G-finish_G);
    int skipEvery_B = 256/abs(start_B-finish_B);
    
    for(int i=0; i<256; i++) {
        
        if(start_R<finish_R) {
            if(i<=finish_R) {
                if(i%skipEvery_R == 0) {
                    analogWrite(LED1_RED, i);
                } 
            }
        } else if(start_R>finish_R) {
            if(i>=(256-start_R)) {
                if(i%skipEvery_R == 0) {
                    analogWrite(LED1_RED, 256-i); 
                }
            } 
        }
        
        if(start_G<finish_G) {
            if(i<=finish_G) {
                if(i%skipEvery_G == 0) {
                    analogWrite(LED1_GREEN, i);
                } 
            }
        } else if(start_G>finish_G) {
            if(i>=(256-start_G)) {
                if(i%skipEvery_G == 0) {
                    analogWrite(LED1_GREEN, 256-i); 
                }
            } 
        }
        
        if(start_B<finish_B) {
            if(i<=finish_B) {
                if(i%skipEvery_B == 0) {
                    analogWrite(LED1_BLUE, i);
                } 
            }
        } else if(start_B>finish_B) {
            if(i>=(256-start_B)) {
                if(i%skipEvery_B == 0) {
                    analogWrite(LED1_BLUE, 256-i); 
                }
            } 
        }
        
        delay(stepTime);
        
    }
    
    
    R_pre = finish_R;
    G_pre = finish_G;
    B_pre = finish_B;

    Serial << "hi: " << R_pre << endl;
    
}

