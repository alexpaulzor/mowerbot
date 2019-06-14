#include <PPMReader.h>
#include <AccelStepper.h>

#define ENABLE_SERIAL 0
#define IF_SERIAL if (ENABLE_SERIAL)
#define BAUD_RATE 9600

#define DRIVE_MS 100
#define THROTTLE_WEIGHT 255
#define STEERING_WEIGHT 255
#define PPM_LOW 1000
#define PPM_HIGH 2000
#define PPM_CENTER ((PPM_LOW + PPM_HIGH) / 2)

#define STATUS_LED_PIN 13
#define INTERRUPT_PIN 2
#define RC_TIMEOUT_S 1

#define PWM_MAX 255
#define PWM_MAX_STEP 255
/*

#define L298N_ENA 6  // PWM
#define L298N_ENB 11  // PWM
#define L298N_IN1 7  // forward
#define L298N_IN2 8  // reverse
#define L298N_IN3 9  // forward
#define L298N_IN4 10  // reverse

#define LEFT_SPEED L298N_ENA
#define RIGHT_SPEED L298N_ENB
#define LEFT_FORWARD L298N_IN1   // forward
#define LEFT_REVERSE L298N_IN2   // reverse
#define RIGHT_FORWARD L298N_IN3   // forward
#define RIGHT_REVERSE L298N_IN4   // reverse
*/
#define LEFT_FORWARD 11
#define LEFT_REVERSE 10
#define RIGHT_FORWARD 9
#define RIGHT_REVERSE 6

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
#define CHANNEL_ENABLE_DRIVE CHANNEL_SWA

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
  IF_SERIAL Serial.begin(BAUD_RATE);
  pinMode(STATUS_LED_PIN, OUTPUT);
  digitalWrite(STATUS_LED_PIN, LOW);

  pinMode(LEFT_FORWARD, OUTPUT);
  pinMode(LEFT_REVERSE, OUTPUT);
  pinMode(RIGHT_FORWARD, OUTPUT);
  pinMode(RIGHT_REVERSE, OUTPUT);
  
  blink(3, 200);
  IF_SERIAL Serial.println("setup() complete");
}

void loop() {
  int channel_values[NUM_CHANNELS];
  // Print latest valid values from all channels
  for (int channel = 1; channel <= NUM_CHANNELS; ++channel) {
    int value = ppm.latestValidChannelValue(channel, 0);
    IF_SERIAL Serial.print(String(value) + " ");
    if (value != channel_values[channel - 1]) {
      last_ppm_signal = millis();
    }
    channel_values[channel - 1] = value;
  }

  if (millis() > (last_ppm_signal + RC_TIMEOUT_S * 1000) || millis() < last_ppm_signal) {
        stop_motors();
        blink(3, 100);
        last_ppm_signal = millis();
    }

   if (channel_values[CHANNEL_ENABLE_DRIVE] > PPM_CENTER) {
      drive(
        map(channel_values[CHANNEL_THROTTLE],
            PPM_LOW, PPM_HIGH, -THROTTLE_WEIGHT, THROTTLE_WEIGHT),
        map(channel_values[CHANNEL_STEERING],
            PPM_LOW, PPM_HIGH, -STEERING_WEIGHT, STEERING_WEIGHT));
   } else {
     stop_motors();
     blink(1, DRIVE_MS/2);
   }
  
}

void drive(int throttle_pct, int steering_pct) {
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
  drive_motors(left_speed, right_speed);
  digitalWrite(STATUS_LED_PIN, LOW);
}

void stop_motors() {
  digitalWrite(LEFT_FORWARD, LOW);
  digitalWrite(LEFT_REVERSE, LOW);
  digitalWrite(RIGHT_FORWARD, LOW);
  digitalWrite(RIGHT_REVERSE, LOW);
}

void drive_motors(int left_speed, int right_speed) {
    int l_pwm_pin = LEFT_FORWARD;
    int l_low_pin = LEFT_REVERSE;
    if (left_speed < 0) {
        l_pwm_pin = LEFT_REVERSE;
        l_low_pin = LEFT_FORWARD;
    } 
    int r_pwm_pin = RIGHT_FORWARD;
    int r_low_pin = RIGHT_REVERSE;
    if (left_speed < 0) {
        r_pwm_pin = RIGHT_REVERSE;
        r_low_pin = RIGHT_FORWARD;
    } 
    digitalWrite(l_low_pin, LOW);
    digitalWrite(r_low_pin, LOW);
    analogWrite(l_pwm_pin,
        constrain(map(abs(left_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX));
    analogWrite(r_pwm_pin,
        constrain(map(abs(right_speed), 0, THROTTLE_WEIGHT, 0, PWM_MAX), 0, PWM_MAX));
    
    
    
}
