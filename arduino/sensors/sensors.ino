#include <Wire.h> 
//#include <LiquidCrystal_I2C.h>
#include <AccelStepper.h>
#include <Adafruit_SSD1306.h>
#include <Adafruit_GFX.h>

// OLED display TWI address
#define OLED_ADDR   0x3C

// reset pin not used on 4-pin OLED module
Adafruit_SSD1306 display(-1);  // -1 = no reset pin

// 128 x 64 pixel display
//#if (SSD1306_LCDHEIGHT != 64)
//#error("Height incorrect, please fix Adafruit_SSD1306.h!");
//#endif

void setup() {
  // initialize and clear display
  display.begin(SSD1306_SWITCHCAPVCC, OLED_ADDR);
  display.clearDisplay();
  display.display();

  
}

void loop() {
  // put your main code here, to run repeatedly:
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0,0);
  char buf[128];
  sprintf(buf, "up %09u ms", millis());
  display.print(buf);
  display.display();
}


#define PIN_LCD_SDA 20
#define PIN_LCD_SCL 21
#define PIN_US_TRIGGER 12
#define PIN_US_ECHO 11
#define US_SLOPE 5.9
#define US_INTERCEPT 0

#define STEPPER_STEPS_PER_REV 200
#define MAX_SPEED_STEPS_PER_SEC (0.25 * STEPPER_STEPS_PER_REV)
#define H_STEPPER_PIN_ENABLE 51
#define H_STEPPER_PIN_DIR 52
#define H_STEPPER_PIN_PUL 53

#define DRIVE_MS 500

/*

AccelStepper height_stepper(AccelStepper::DRIVER,
  H_STEPPER_PIN_PUL, H_STEPPER_PIN_DIR);



LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display

void setup()
{
    setup_ultrasonic();
    setup_lcd();
    height_stepper.setMaxSpeed(MAX_SPEED_STEPS_PER_SEC);
    height_stepper.setSpeed(MAX_SPEED_STEPS_PER_SEC);
    height_stepper.setAcceleration(MAX_SPEED_STEPS_PER_SEC / 2);
    //height_stepper.setPinsInverted(directionInvert = false, stepInvert = false, enableInvert = false);
    //height_stepper.setPinsInverted(true, false, true);
    
    //long d = 1000;
    //refresh_disp(d);
    //height_stepper.runToNewPosition(d);
    //height_stepper.moveTo(1000);

    //while (height_stepper.runSpeed()) {
    //    refresh_disp(0);
    //}
    //height_stepper.moveTo(0);
    //while (height_stepper.runSpeed()) {
        //wait
    //}
    //refresh_disp(0);
}

void setup_lcd() {

  lcd.init();  //initialize the lcd
  lcd.backlight();  //open the backlight
  
  
}

void refresh_disp(long d) {
    char buf[20];
    lcd.setCursor ( 0, 0 );
    sprintf(buf, "Up %09u ms", millis());
    lcd.print(buf);
    lcd.setCursor (0, 1);
    sprintf(buf, "us: %09u mm", d);
    lcd.print(buf);
    lcd.setCursor (0, 2);
    sprintf(buf, "pos: %09d steps", height_stepper.currentPosition());
    lcd.print(buf);
}


void loop() 
{
    long d = get_us_distance();
    refresh_disp(d);   
    
    height_stepper.moveTo(d);
    //height_stepper.setSpeed(MAX_SPEED_STEPS_PER_SEC);
    
    //height_stepper.runSpeedToPosition();

    long start = millis();
    while (millis() < start + DRIVE_MS && millis() > start - 1) {
        height_stepper.run();
    }
    //    d = get_us_distance();
    //    refresh_disp(d);  
    //}
    //delayMicroseconds(10);
    //delay(500);
    /*lcd.setCursor ( 0, 1 );
    lcd.print(d);
    lcd.setCursor ( 0, 2 );
    lcd.print("  20 cols, 4 rows   ");
    lcd.setCursor ( 0, 3 );
    lcd.print(" www.sunfounder.com ");
}

// * /

long get_us_distance() {
    unsigned long distance, duration;
    digitalWrite(PIN_US_TRIGGER, HIGH);
    long s = micros();
    while (micros() < s + 10) {
        height_stepper.runSpeed();
    }
    digitalWrite(PIN_US_TRIGGER, LOW);
    duration = pulseIn(PIN_US_ECHO,HIGH);
    distance = duration;
    return distance / US_SLOPE + US_INTERCEPT;
}

void setup_ultrasonic() {
    pinMode(PIN_US_ECHO, INPUT);
    pinMode(PIN_US_TRIGGER, OUTPUT);
    digitalWrite(PIN_US_TRIGGER, LOW);
}

// */