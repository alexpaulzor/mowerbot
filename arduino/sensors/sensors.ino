  
 /*
 The circuit:
 * LCD RS pin to digital pin 7
 * LCD Enable pin to digital pin 8
 * LCD D4 pin to digital pin 9
 * LCD D5 pin to digital pin 10
 * LCD D6 pin to digital pin 11
 * LCD D7 pin to digital pin 12
 * LCD R/W pin to ground
 * LCD VSS pin to ground
 * LCD VCC pin to 5V
 * 10K resistor:
 * ends to +5V and ground
 * wiper to LCD VO pin (pin 3)

 Library originally added 18 Apr 2008
 by David A. Mellis
 library modified 5 Jul 2009
 by Limor Fried (http://www.ladyada.net)
 example added 9 Jul 2009
 by Tom Igoe
 modified 22 Nov 2010
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/LiquidCrystal
 */

// include the library code:
#include <LiquidCrystal.h>

#define VCC -1
#define V33 -3
#define NC 0
#define GND -2

#define PIN_LCD_VSS GND
#define PIN_LCD_VDD 53
// VO: Contrast adjustment (0V-VDD)
#define PIN_LCD_VO 51
// RS: Register selection H: Data register (for read and write) L: Instruction code (for write)
#define PIN_LCD_RS 49
// RW: H: Read (Host module) L: write(Host Module)
#define PIN_LCD_RW 47
// E: Read/write enable signal. H: Read data is enabled by a high level. H->L: Write data is latched on the falling edge.
#define PIN_LCD_E  45
// D0 - D7: data bit 0 - 7
#define PIN_LCD_D0 43
#define PIN_LCD_D1 41
#define PIN_LCD_D2 39
#define PIN_LCD_D3 37
#define PIN_LCD_D4 35
#define PIN_LCD_D5 33
#define PIN_LCD_D6 31
#define PIN_LCD_D7 29
// A (LED +): Supply voltage for LED. “A”(anode)or “+” of LED backlight.
#define PIN_LCD_A  27
// K (LED -): Supply voltage for LED. “K”(cathode or cathode for German and original) Greek spelling) or “-” of LED backlight.
#define PIN_LCD_K  25

#define LCD_W 16
#define LCD_H 2

//  LiquidCrystal(uint8_t rs, uint8_t enable,
//      uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3,
//      uint8_t d4, uint8_t d5, uint8_t d6, uint8_t d7);
//  LiquidCrystal(uint8_t rs, uint8_t rw, uint8_t enable,
//      uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3,
//      uint8_t d4, uint8_t d5, uint8_t d6, uint8_t d7);
// LiquidCrystal(uint8_t rs, uint8_t rw, uint8_t enable,
//      uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3)
// LiquidCrystal(uint8_t rs, uint8_t enable,
//      uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3);

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(PIN_LCD_RS, PIN_LCD_RW, PIN_LCD_E, 
    PIN_LCD_D0, PIN_LCD_D1, PIN_LCD_D2, PIN_LCD_D3,
    PIN_LCD_D4, PIN_LCD_D5, PIN_LCD_D6, PIN_LCD_D7);

void setup() {
    //pinMode(PIN_LCD_VSS, OUTPUT);
    pinMode(PIN_LCD_VDD, OUTPUT);
    pinMode(PIN_LCD_A, OUTPUT);
    pinMode(PIN_LCD_K, OUTPUT);
    pinMode(PIN_LCD_VO, OUTPUT);

    //digitalWrite(PIN_LCD_VSS, LOW);
    digitalWrite(PIN_LCD_VDD, HIGH);
    digitalWrite(PIN_LCD_A, HIGH);
    digitalWrite(PIN_LCD_K, LOW);
    digitalWrite(PIN_LCD_VO, HIGH);

  // set up the LCD's number of columns and rows:
  lcd.begin(LCD_W, LCD_H);
  // Print a message to the LCD.
  lcd.print("hello, world!");
  lcd.display();

  //blink(PIN_LCD_VO);
  //blink(PIN_LCD_A);
  //blink(PIN_LCD_VDD);
}

void blink(int pin) {
    int i;
    for (i = 0; i < 4; i++) {
        digitalWrite(pin, LOW);
        delay(500);
        digitalWrite(pin, HIGH);
        delay(500);
    }
}

void loop() {
  // set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  //lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  //lcd.print(millis() / 1000);
  //lcd.display();
  delay(500);
}

/*
ultrasonic
#define TRIGGER 12
#define ECHO 11

void setup()
{
pinMode(ECHO, INPUT);
pinMode(TRIGGER, OUTPUT);
digitalWrite(TRIGGER, LOW);
Serial.begin(9600);
}
void loop()
{
long distance, duration;
digitalWrite(TRIGGER, HIGH);
delayMicroseconds(10);
digitalWrite(TRIGGER, LOW);
duration = pulseIn(ECHO,HIGH);
distance = duration / 2 / 7.6;
Serial.println(distance);
}*/