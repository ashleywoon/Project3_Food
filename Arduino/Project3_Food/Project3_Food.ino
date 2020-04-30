/* Project 3 Food
 *  by Ashley Woon
 *  
 *  
 * 
 */

const int rLED = 4;
const int bLED = 5;
const int gLED = 18;

const int button = 12;
int buttonState;

const int pot = A2;
int potValue;

const int LED = 15;

void setup() {
  pinMode(rLED, OUTPUT);
  pinMode(bLED, OUTPUT);
  pinMode(gLED, OUTPUT);

  pinMode(LED, OUTPUT);

  pinMode(button, INPUT);
  pinMode(pot, INPUT);

  Serial.begin(9600);
}

void loop() {
  buttonState = digitalRead(button);
  potValue = analogRead(pot);

}
