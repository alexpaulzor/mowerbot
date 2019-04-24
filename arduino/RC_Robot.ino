#include <PPMReader.h>
#include <AccelStepper.h>

#define ENABLE_SERIAL 0
#define IF_SERIAL if (ENABLE_SERIAL)

#define ARM_MICROSTEP 1
//#define MOWER_DC 1

#define DRIVE_MS 200
#define RC_TIMEOUT_S 3
#define THROTTLE_WEIGHT 255
#define STEERING_WEIGHT 255
#define PPM_LOW 1000
#define PPM_HIGH 2000
#define PPM_CENTER ((PPM_LOW + PPM_HIGH) / 2)

#define STATUS_LED_PIN 13
#define INTERRUPT_PIN 3
#define RC_POWER_PIN 12

#ifdef MOWER_DC
  #define MOWER_REVERSE_PIN 26  // green
  #define MOWER_REVERSE_SPEED_PIN 27 // blue
  #define MOWER_FORWARD_SPEED_PIN 28 // violet
  #define MOWER_FORWARD_PIN 29 // grey
#else
  #define AC_RELAY_CONTROL_PIN 22
#endif

#ifdef ARM_MICROSTEP
  #define STEPPER_STEPS_PER_REV 200
  #define MAX_SPEED_STEPS_PER_SEC (5 * STEPPER_STEPS_PER_REV)
  #define H_STEPPER_PIN_ENABLE 51
  #define H_STEPPER_PIN_DIR 52
  #define H_STEPPER_PIN_PUL 53
  AccelStepper height_stepper(AccelStepper::DRIVER,
      H_STEPPER_PIN_PUL, H_STEPPER_PIN_DIR);
#endif

#define H_STEPPER_MAX_STEPS 6000
#define H_STEPPER_HOME_SW_PIN 50
#define H_STEPPER_HOME_THRESH (H_STEPPER_MAX_STEPS / 20.0)
#define H_STEPPER_FUZZ (STEPPER_STEPS_PER_REV / 2)
#define HEIGHT_WEIGHT H_STEPPER_MAX_STEPS
  
#define PWM_MAX 255
#define PWM_MAX_STEP (PWM_MAX / 4)
//#define PWM_MAX_FACTOR 
#define L_FORWARD_PIN 4 // grey
#define L_FORWARD_SPEED_PIN 5  // violet
#define L_REVERSE_SPEED_PIN 6  // blue
#define L_REVERSE_PIN 7  // green
#define R_FORWARD_PIN 8  // brown
#define R_REVERSE_PIN 9  // red
#define R_FORWARD_SPEED_PIN 10  // orange
#define R_REVERSE_SPEED_PIN 11  // yellow

#define NUM_CHANNELS 7

#define CHANNEL_R_EW 0
#define CHANNEL_R_NS 1
#define CHANNEL_L_NS 2
#define CHANNEL_L_EW 3
#define CHANNEL_SWA 4
#define CHANNEL_SWB 5
#define CHANNEL_DIAL_VRA 6

#define CHANNEL_THROTTLE CHANNEL_L_NS
#define CHANNEL_STEERING CHANNEL_R_EW
#define CHANNEL_AC_RELAY CHANNEL_SWB
#define CHANNEL_ENABLE_DRIVE CHANNEL_SWA
#define CHANNEL_HEIGHT CHANNEL_DIAL_VRA

PPMReader ppm(INTERRUPT_PIN, NUM_CHANNELS);
unsigned long last_ppm_signal = 0;
unsigned long last_drive = 0;
int left_speed = 0;
int right_speed = 0;

void blink(int count, int interval) {
  for (int i = 0; i < count; i++) {
    digitalWrite(STATUS_LED_PIN, HIGH);
    delay(interval);
    digitalWrite(STATUS_LED_PIN, LOW);
    delay(interval);
  }
}

void setup() {
  IF_SERIAL Serial.begin(115200);
  pinMode(STATUS_LED_PIN, OUTPUT);
  digitalWrite(STATUS_LED_PIN, LOW);
  
  pinMode(RC_POWER_PIN, OUTPUT);
  digitalWrite(RC_POWER_PIN, LOW);
  blink(5, 200);
  digitalWrite(RC_POWER_PIN, HIGH);
 
  pinMode(L_FORWARD_PIN, OUTPUT);
  pinMode(L_REVERSE_PIN, OUTPUT);
  pinMode(L_FORWARD_SPEED_PIN, OUTPUT);
  pinMode(L_REVERSE_SPEED_PIN, OUTPUT);
  pinMode(R_FORWARD_PIN, OUTPUT);
  pinMode(R_REVERSE_PIN, OUTPUT);
  pinMode(R_FORWARD_SPEED_PIN, OUTPUT);
  pinMode(R_REVERSE_SPEED_PIN, OUTPUT);

  #ifdef MOWER_DC
    pinMode(MOWER_FORWARD_PIN, OUTPUT);
    pinMode(MOWER_REVERSE_PIN, OUTPUT);
    pinMode(MOWER_FORWARD_SPEED_PIN, OUTPUT);
    pinMode(MOWER_REVERSE_SPEED_PIN, OUTPUT);
  #else
    pinMode(AC_RELAY_CONTROL_PIN, OUTPUT);
    digitalWrite(AC_RELAY_CONTROL_PIN, LOW);
  #endif

  pinMode(H_STEPPER_HOME_SW_PIN, INPUT);

  height_stepper.setEnablePin(H_STEPPER_PIN_ENABLE);
  //height_stepper.setPinsInverted(directionInvert = false, stepInvert = false, enableInvert = false);
  height_stepper.setPinsInverted(true, false, false);
  stop_motors();
  mower_off();
  height_stepper.setMaxSpeed(MAX_SPEED_STEPS_PER_SEC);
  height_stepper.setCurrentPosition(H_STEPPER_MAX_STEPS);
  while (!drive_height(0)) {
    // Homing...
  }
 
  IF_SERIAL Serial.println("setup() complete");
}

void loop() {
  int channel_values[NUM_CHANNELS];
  // Print latest valid values from all channels
  for (int channel = 1; channel <= NUM_CHANNELS; ++channel) {
    int value = ppm.latestValidChannelValue(channel, 0);
//    IF_SERIAL Serial.print(String(value) + " ");
    if (value != channel_values[channel - 1]) {
      last_ppm_signal = millis();
    }
    channel_values[channel - 1] = value;
  }
//  IF_SERIAL Serial.println();

  if (millis() > (last_ppm_signal + RC_TIMEOUT_S * 1000) || millis() < last_ppm_signal) {
    IF_SERIAL Serial.println("Resetting receiver...");
    stop_motors();
    mower_off();
    digitalWrite(RC_POWER_PIN, LOW);
    blink(3, 100);
    digitalWrite(RC_POWER_PIN, HIGH);
    last_ppm_signal = millis();
  } else {

    if (channel_values[CHANNEL_AC_RELAY] > PPM_CENTER) {
      mower_on();
    } else {
      mower_off();
    }

   if (channel_values[CHANNEL_ENABLE_DRIVE] > PPM_CENTER) {
      drive(
        map(channel_values[CHANNEL_THROTTLE],
            PPM_LOW, PPM_HIGH, -THROTTLE_WEIGHT, THROTTLE_WEIGHT),
        map(channel_values[CHANNEL_STEERING],
            PPM_LOW, PPM_HIGH, -STEERING_WEIGHT, STEERING_WEIGHT),
        map(channel_values[CHANNEL_HEIGHT],
            PPM_LOW, PPM_HIGH, 0, HEIGHT_WEIGHT));
   } else {
    stop_motors();
    delay(DRIVE_MS);
   }
  }
}

void mower_off() {
  #ifdef MOWER_DC
    analogWrite(MOWER_REVERSE_SPEED_PIN, 0);
    analogWrite(MOWER_FORWARD_SPEED_PIN, 0);
    digitalWrite(MOWER_REVERSE_PIN, LOW);
    digitalWrite(MOWER_FORWARD_PIN, LOW);
  #else
    digitalWrite(AC_RELAY_CONTROL_PIN, LOW);
  #endif
}

void mower_on() {
  #ifdef MOWER_DC
    analogWrite(MOWER_REVERSE_SPEED_PIN, 0);
    analogWrite(MOWER_FORWARD_SPEED_PIN, PWM_MAX);
    digitalWrite(MOWER_REVERSE_PIN, LOW);
    digitalWrite(MOWER_FORWARD_PIN, HIGH);
  #else
    digitalWrite(AC_RELAY_CONTROL_PIN, HIGH);
  #endif
}

void drive(int throttle_pct, int steering_pct, long height_steps) {
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
    "; R=" + String(right_speed) + 
    "; H=" + String(height_stepper.currentPosition()) +
    " -> " + String(height_steps) +
    " @ " + String(height_stepper.speed())
    );

  digitalWrite(STATUS_LED_PIN, HIGH);
  drive_motors(left_speed, right_speed);
  drive_height(height_steps);
  digitalWrite(STATUS_LED_PIN, LOW);
}

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

void stop_motors() {
  digitalWrite(L_FORWARD_PIN, HIGH);
  digitalWrite(L_REVERSE_PIN, HIGH);
  digitalWrite(R_FORWARD_PIN, HIGH);
  digitalWrite(R_REVERSE_PIN, HIGH);
  digitalWrite(L_FORWARD_SPEED_PIN, LOW);
  digitalWrite(L_REVERSE_SPEED_PIN, LOW);
  digitalWrite(R_FORWARD_SPEED_PIN, LOW);
  digitalWrite(R_REVERSE_SPEED_PIN, LOW);

  //height_stepper.setSpeed(0);
  // height_stepper.disableOutputs();
}

void drive_motors(int left_speed, int right_speed) {
  analogWrite(
    (left_speed < 0 ? L_REVERSE_SPEED_PIN : L_FORWARD_SPEED_PIN),
    constrain(map(abs(left_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX));
  digitalWrite(
    (left_speed >= 0 ? L_REVERSE_SPEED_PIN : L_FORWARD_SPEED_PIN),
    LOW);
  analogWrite(
    (right_speed < 0 ? R_REVERSE_SPEED_PIN : R_FORWARD_SPEED_PIN),
    constrain(map(abs(right_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX));
  digitalWrite(
    (right_speed >= 0 ? R_REVERSE_SPEED_PIN : R_FORWARD_SPEED_PIN),
    LOW);    
}
