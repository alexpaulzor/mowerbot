#include <PPMReader.h>
//#include <AccelStepper.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,20,4);  // set the LCD address to 0x27 for a 16 chars and 2 line display

#define ENABLE_SERIAL 0
#define IF_SERIAL if (ENABLE_SERIAL)
#define BAUD_RATE 9600

#define DRIVE_MS 100
#define THROTTLE_WEIGHT 255
#define STEERING_WEIGHT 255
#define PPM_LOW 1000
#define PPM_HIGH 2000
#define PPM_CENTER ((PPM_LOW + PPM_HIGH) / 2)
#define PPM_FUZZ 10

#define STATUS_LED_PIN 13
#define INTERRUPT_PIN 2
#define RC_TIMEOUT_S 1

#define PWM_MAX 255
#define PWM_MAX_STEP 255

#define CUR_SENS_MAX 1024
#define CUR_SENS_MAX_MA 20000

#define LEFT_FORWARD_PIN 11
#define LEFT_REVERSE_PIN 10
#define RIGHT_FORWARD_PIN 9
#define RIGHT_REVERSE_PIN 6

#define TOOL_PIN 3
#define CUR_SENS_PIN A7

#define NUM_CHANNELS 7

#define CHANNEL_R_EW 0
#define CHANNEL_R_NS 1
#define CHANNEL_L_NS 2
#define CHANNEL_L_EW 3
#define CHANNEL_SWA 4
#define CHANNEL_SWB 5
#define CHANNEL_DIAL_VRA 6

#define CHANNEL_THROTTLE CHANNEL_L_NS
#define CHANNEL_STEERING CHANNEL_L_EW
#define CHANNEL_ENABLE_DRIVE CHANNEL_SWA
#define CHANNEL_ENABLE_TOOL CHANNEL_SWB

#define H_STEPPER_MAX_STEPS PWM_MAX
#ifdef ENABLE_STEPPER
#define STEPPER_STEPS_PER_REV 200
#define MAX_SPEED_STEPS_PER_SEC (5 * STEPPER_STEPS_PER_REV)
#define MM_PER_REV 8
#define H_STEPPER_DIR_PIN 4
#define H_STEPPER_PUL_PIN 5
#define H_STEPPER_LIM_SW_PIN A6
#define H_STEPPER_FUZZ (STEPPER_STEPS_PER_REV / 2)

AccelStepper height_stepper(AccelStepper::DRIVER,
  H_STEPPER_PUL_PIN, H_STEPPER_DIR_PIN);
#endif

PPMReader ppm(INTERRUPT_PIN, NUM_CHANNELS);
unsigned long last_ppm_signal = 0;
unsigned long last_drive = 0;
int left_speed = 0;
int right_speed = 0;

int read_current() {
  int current = analogRead(CUR_SENS_PIN);
  return map(current, 0, CUR_SENS_MAX, -CUR_SENS_MAX_MA, CUR_SENS_MAX_MA);
} 

void blink(int count, int interval) {
  for (int i = 0; i < count; i++) {
    digitalWrite(STATUS_LED_PIN, HIGH);
    delay(interval);
    digitalWrite(STATUS_LED_PIN, LOW);
    delay(interval);
  }
}

void setup() {
  IF_SERIAL Serial.begin(BAUD_RATE);
  pinMode(STATUS_LED_PIN, OUTPUT);
  digitalWrite(STATUS_LED_PIN, LOW);

  pinMode(TOOL_PIN, OUTPUT);
  pinMode(LEFT_FORWARD_PIN, OUTPUT);
  pinMode(LEFT_REVERSE_PIN, OUTPUT);
  pinMode(RIGHT_FORWARD_PIN, OUTPUT);
  pinMode(RIGHT_REVERSE_PIN, OUTPUT);

  #ifdef ENABLE_STEPPER
  height_stepper.setMaxSpeed(MAX_SPEED_STEPS_PER_SEC);
  height_stepper.setCurrentPosition(H_STEPPER_MAX_STEPS);
  #endif

  stop_motors();
  setup_lcd();

  blink(3, 200);
  IF_SERIAL Serial.println("setup() complete");
  
}

void loop() {
    int channel_values[NUM_CHANNELS];
    // Print latest valid values from all channels
    for (int channel = 1; channel <= NUM_CHANNELS; ++channel) {
        int value = ppm.latestValidChannelValue(channel, 0);
        IF_SERIAL Serial.print(String(value) + " ");
        if (abs(value - channel_values[channel - 1]) <= PPM_FUZZ) {
            last_ppm_signal = millis();
        }
        channel_values[channel - 1] = value;
    }

    refresh_disp(channel_values);

    if (millis() > (last_ppm_signal + RC_TIMEOUT_S * 1000) || millis() < last_ppm_signal) {
        stop_motors();
        blink(3, 100);
        return;
    }

    if (channel_values[CHANNEL_ENABLE_DRIVE] > PPM_CENTER) {
        if (channel_values[CHANNEL_ENABLE_TOOL] > PPM_CENTER) {
          digitalWrite(TOOL_PIN, HIGH);
        } else {
          digitalWrite(TOOL_PIN, LOW);
        }
        drive(
            map(channel_values[CHANNEL_THROTTLE],
                PPM_LOW, PPM_HIGH, -THROTTLE_WEIGHT, THROTTLE_WEIGHT),
            map(channel_values[CHANNEL_STEERING],
                PPM_LOW, PPM_HIGH, -STEERING_WEIGHT, STEERING_WEIGHT),
            map(channel_values[CHANNEL_DIAL_VRA],
                PPM_LOW, PPM_HIGH, 0, H_STEPPER_MAX_STEPS));
    } else {
        stop_motors();
        blink(1, DRIVE_MS/2);
   }
}

void drive(int throttle_pct, int steering_pct, long desired_position) {
  unsigned long now = millis();
  if (now - last_drive > DRIVE_MS) {
    int old_left_speed = left_speed;
    int old_right_speed = right_speed;
  
    int min_left = old_left_speed - PWM_MAX_STEP; // old_left_speed / PWM_MAX_FACTOR;
    int max_left = old_left_speed + PWM_MAX_STEP; //old_left_speed / PWM_MAX_FACTOR;
  
    int min_right = old_right_speed - PWM_MAX_STEP; //old_right_speed / PWM_MAX_FACTOR;
    int max_right = old_right_speed + PWM_MAX_STEP; //old_right_speed / PWM_MAX_FACTOR;
    // restrict throttle changes to a multiple of previous speed
    left_speed = constrain(throttle_pct + steering_pct, max(min(min_left, max_left), -PWM_MAX), min(max(min_left, max_left), PWM_MAX));
    right_speed = constrain(throttle_pct - steering_pct, max(min(min_right, max_right), -PWM_MAX), min(max(min_right, max_right), PWM_MAX));
    last_drive = now;
  }
  IF_SERIAL Serial.println(
    "T: " + String(throttle_pct) +
    "; S: " + String(steering_pct) +
    "; -> L=" + String(left_speed) +
    "; R=" + String(right_speed) //+ 
    //"; H=" + String(height_stepper.currentPosition()) +
    //" -> " + String(height_steps) +
    //" @ " + String(height_stepper.speed())
    );

  digitalWrite(STATUS_LED_PIN, HIGH);
  drive_motors(left_speed, right_speed, desired_position);
  digitalWrite(STATUS_LED_PIN, LOW);
}

void stop_motors() {
  digitalWrite(TOOL_PIN, LOW);
  digitalWrite(LEFT_FORWARD_PIN, LOW);
  digitalWrite(LEFT_REVERSE_PIN, LOW);
  digitalWrite(RIGHT_FORWARD_PIN, LOW);
  digitalWrite(RIGHT_REVERSE_PIN, LOW);
}

void drive_motors(int left_speed, int right_speed, long desired_position) {
    int l_pwm_pin = LEFT_FORWARD_PIN;
    int l_low_pin = LEFT_REVERSE_PIN;
    if (left_speed < 0) {
        l_pwm_pin = LEFT_REVERSE_PIN;
        l_low_pin = LEFT_FORWARD_PIN;
    } 
    int r_pwm_pin = RIGHT_FORWARD_PIN;
    int r_low_pin = RIGHT_REVERSE_PIN;
    if (right_speed < 0) {
        r_pwm_pin = RIGHT_REVERSE_PIN;
        r_low_pin = RIGHT_FORWARD_PIN;
    } 
    digitalWrite(l_low_pin, LOW);
    digitalWrite(r_low_pin, LOW);
    analogWrite(l_pwm_pin,
        constrain(map(abs(left_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX));
    analogWrite(r_pwm_pin,
        constrain(map(abs(right_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX)); 
    long start = millis();
    #ifdef ENABLE_STEPPER
    height_stepper.moveTo(desired_position);
    #endif
    
    while (millis() < start + DRIVE_MS && millis() > start - 1) {
        #ifdef ENABLE_STEPPER
        height_stepper.runSpeed()
        #endif
    }
}

void setup_lcd() {
  lcd.init();  //initialize the lcd
  lcd.backlight();  //open the backlight 
}

void refresh_disp(int* channel_values) {
    int current = read_current();
    char buf[20];
    lcd.setCursor ( 0, 0 );
    sprintf(buf, "Up %6u s\0", millis() / 1000);
    lcd.print(buf);
    lcd.setCursor (0, 1);
    sprintf(
        buf, "Spd=%4d Str=%4d\0", 
        (channel_values[CHANNEL_THROTTLE] - 1500) / 5,
        (channel_values[CHANNEL_STEERING] - 1500) / 5);
    lcd.print(buf);
    lcd.setCursor (0, 2);
    sprintf(
        buf, "Ena=%4d Aux=%4d\0",
        (channel_values[CHANNEL_ENABLE_DRIVE] - 1000) / 10,
        (channel_values[CHANNEL_SWB] - 1000) / 10);
    lcd.print(buf);
    lcd.setCursor (0, 3);
    sprintf(
        buf, "Adj=%4d Cur=%06dmA\0",
        (channel_values[CHANNEL_DIAL_VRA] - 1500) / 5,
        current);
    lcd.print(buf);
}

#ifdef ENABLE_STEPPER
bool drive_height(long desired_position) {
  bool at_home = arm_at_home(desired_position);
  if (desired_position < H_STEPPER_FUZZ && !at_home) {
    // Home zero was broken, seek to negative
    desired_position = height_stepper.currentPosition() - MAX_SPEED_STEPS_PER_SEC;
  } 
  long steps_off = desired_position - height_stepper.currentPosition();
  int dir = steps_off / abs(steps_off);
  if (abs(steps_off) < H_STEPPER_FUZZ || (desired_position < H_STEPPER_FUZZ && at_home)) {
    height_stepper.setSpeed(0);
    return true;
  } else {
    height_stepper.moveTo(desired_position);
    height_stepper.setSpeed(dir * MAX_SPEED_STEPS_PER_SEC);
  }
  // height_stepper.enableOutputs();
  long start = millis();
  //IF_SERIAL Serial.println("runSpeed() @ " + String(height_stepper.speed()) + " (" + String(steps_off));
  while (millis() < start + DRIVE_MS && millis() > start - 1 && height_stepper.runSpeed()) {
    // wait
  }
  return false;
}

bool arm_at_home(long desired_position) {
  int home_sw = digitalRead(H_STEPPER_HOME_SW_PIN);
  if (home_sw == HIGH) {
    if (desired_position < H_STEPPER_FUZZ) {
      // Only reset position if we are trying to home
      height_stepper.setCurrentPosition(0);
    }
    IF_SERIAL Serial.println("home=" + String(home_sw));
    return true;
  }
  return false;
}
#endif
