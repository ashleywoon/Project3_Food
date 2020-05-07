/* Project 3 Food
 *  by Ashley Woon
 *  
 *  Designed for Adafruit ESP32, Hardware components include: 
 *  (1)breadboard, (1)push button, (1)potentiometer, (1)LED, (1) RGB LED, (5)resistors
 *  
 *  This sketch was written to be run alongside the Processing sketch Project3_Food as the interactive elements.
 *  Project3 simulates an imaginary machine that transforms small nutrution pellets into full meals that can be 
 *  chosen via a "knob" which in this case refers to the potentiometer. A push button serves as a mean to confirm 
 *  meal choice, open, and close a door to access the meal.
 */
//LED pins
const int rLED = 4;
const int bLED = 5;
const int gLED = 18;
const int LED = 15;

//analog pins and values
const int button = 12;
int buttonState;
int lastButtonState;
int buttonCount = 0;
const int pot = A2;
int potValue = 0;


void setup() {
  //initializing pins, inputs, and outputs
  pinMode(rLED, OUTPUT);
  pinMode(bLED, OUTPUT);
  pinMode(gLED, OUTPUT);
  pinMode(LED, OUTPUT);

  pinMode(button, INPUT);
  pinMode(pot, INPUT);

  Serial.begin(115200);
}

void loop() {
  getButtonValue();
  getPotValue();
  sendSerialData();
  checkButton();
  changeFood();
}

void getButtonValue() {
  buttonState = digitalRead(button);
}

void getPotValue() {
  potValue = analogRead(pot);
}

void sendSerialData() {
  // Add switch on or off
  if(buttonState ) {
    Serial.print(1);
  }
  else {
    Serial.print(0);
  }

   Serial.print(",");
   Serial.print(potValue);

   Serial.print(",");
   Serial.print(buttonCount);
  // end with newline
  Serial.println();
}

void checkButton() {
  if(buttonState != lastButtonState) 
      {
        if(buttonState == HIGH)
        {
          buttonCount++;
        }
        if(buttonCount == 2)
        {
          buttonCount = 0;
        }
      }
  lastButtonState = buttonState;
}

//Checks to see if button count is equal to 2 indicating a meal has been chosen, confirmed, and the user
//now wants to open the door. An LED will stay on until the button is pressed again indicating the door has closed
void checkDoor() {
  if(buttonCount == 1)
    {
       digitalWrite(LED, HIGH);
    }
    else
      digitalWrite(LED, LOW);
}

//This function changes states between default and meal choices based on potentiometer values
void changeFood() {
  if(potValue >= 0 && potValue < 1365)
    defaultState();
  else if(potValue >= 1365 && potValue < 2730)
    chickenState();
  else if(potValue >= 2730 && potValue <= 4095)
    fishState();
}

//when the potentiometer is in the zero range and the door is closed, all lights are off
void defaultState() {
    digitalWrite(rLED, LOW);
    digitalWrite(gLED, LOW);
    digitalWrite(bLED, LOW);
    checkDoor();
}

// the potentiometer is within the 1026-2050 range resulting in a green light turning on indicating the
//user's choice of chicken for their meal
void chickenState() {
    digitalWrite(rLED, LOW);
    digitalWrite(gLED, HIGH);
    digitalWrite(bLED, LOW);
    checkDoor();
}

// the potentiometer is within the 3076-4095 range resulting in a blue light turning on indicating the
//user's choice of fish for their meal
void fishState() {
    digitalWrite(rLED, LOW);
    digitalWrite(gLED, LOW);
    digitalWrite(bLED, HIGH);
    checkDoor();
}
