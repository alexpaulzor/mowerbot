# mowerbot
A lawnmowing robot

## v4.0 Wiring

Arduino pin | Color | Function | Destination pin
----------- | ----- | -------- | ---------------
3 | violet | PPM | <code>IA6B<sub>1</sub></code>
4 | gray | L - forward enable | <code><sup>L</sup>IBT2<sub>L_EN</sub></code>
5 | violet | L forward speed | <code><sup>L</sup>IBT2<sub>R_PWM</sub></code>
6 | blue | L reverse speed | <code><sup>L</sup>IBT2<sub>L_PWM</sub></code>
7 | green | L reverse enable | <code><sup>L</sup>IBT2<sub>R_EN</sub></code>
8 | brown | R forward enable | <code><sup>R</sup>IBT2<sub>R_EN</sub></code>
9 | red | R reverse enable | <code><sup>R</sup>IBT2<sub>L_EN</sub></code>
10 | orange | R forward speed | <code><sup>R</sup>IBT2<sub>R_PWM</sub></code>
11 | yellow | R reverse speed | <code><sup>R</sup>IBT2<sub>L_PWM</sub></code>
12 | red | RC power | <code>IA6B<sub>vcc</sub></code>
13 | violet | status LED | 
22 | white | SSR enable | <code>SSR<sub>+</sub></code>
26 | green |  | 
27 | blue |  | 
28 | violet | | 
29 | gray | | 
30 | brown | | 
50 | orange | limit switch | 
51 | white | Stepper ENA | <code>TB6600<sub>ENA-</sub></code>
52 | brown | Stepper DIR | <code>TB6600<sub>DIR-</sub></code>
53 | orange | Stepper PUL | <code>TB6600<sub>PUL-</sub></code>

## Inventory

category  |  make  |  component  |  link  |  specs  |  scad module | count 
---------  |  ----  |  ---------  |  ----  |  -----  |  ----------- | ---- 
hardware  |  JeremyWell  |  #40 roller chain  | [link](https://smile.amazon.com/gp/product/B00NP5LDMG) |  `0.5" pitch` |  | 15m 
hardware  |  MakerBeam  |  beams  | [link](https://smile.amazon.com/gp/product/B06XHXJSVL) |  |  | 2+ 
hardware  |  metalsonline  |  1" square steel tubing  | [link](https://smile.amazon.com/gp/product/B003TPMSDK) |  |  | 3x8' 
hardware  |   |  6 to 8mm shaft connector  | [link](https://smile.amazon.com/gp/product/B07BY8PHGZ) |  `6mm -> 8mm` |  | ? 
hardware  |   |  608zz bearing  | [link](https://smile.amazon.com/gp/product/B07211VH78) |  `8mm` |  | ? 
hardware  |   |  8mm linear bearing  | [link](https://smile.amazon.com/gp/product/B01LPZPJ18) |  `8mm` |  | ? 
hardware  |   |  8mm linear motion rods  | [link](https://smile.amazon.com/gp/product/B01LPZPJ18) |  `8mm` |  | ? 
hardware  |   |  8mm linear motion screw  | [link](https://smile.amazon.com/gp/product/B01H1QNSAE) |  `8mm` |  | 3
hardware  |   |  8mm shaft bearing  | [link](https://smile.amazon.com/gp/product/B07K7DX3L6) |  `8mm` |  | ? 
hardware  |   |  8mm shaft mount  | [link](https://smile.amazon.com/gp/product/B06X94LZ33) |  `8mm` |  | ? 
hardware  |   |  IEC C14 plug  | [link](https://smile.amazon.com/gp/product/B07DCXKNXQ) |  `120v AC` |  | ? 
hardware  |   |  Limit switch  | [link](https://smile.amazon.com/gp/product/B00E0JOTV8) |  |  | ? 
hardware  |   |  NEMA 17 mount  | [link](https://smile.amazon.com/gp/product/B071NWWB7Z) |  |  | 3
hardware  |   |  NEMA 23 mount  | [link](https://smile.amazon.com/gp/product/B06WRNRNNV) |  |  | 2
interface  |   |  Rocker switch  | [link](https://smile.amazon.com/gp/product/B011U1NU90) |  |  | ? 
interface  |   |  voltage display  | [link](https://smile.amazon.com/gp/product/B00YALV0NG) |  |  | 4 (+1?) 
microcontroller  |  Arduino  |  ATMEGA2650 knockoff  | [link](https://smile.amazon.com/gp/product/B00D9NA4CY) |  |  | 2
microcontroller  |  Arduino  |  `Deumilanove`  | [link](?) |  |  | 3
microcontroller  |  Arduino  |  `Nano V3.0`  | [link](https://smile.amazon.com/gp/product/B0713XK923) |  |  | 3
microcontroller  |  Arduino  |  `Uno R3`  | [link](https://smile.amazon.com/gp/product/B006H06TVG) |  |  | 2
microcontroller  |  Arduino  |  `Uno`  | [link](https://smile.amazon.com/gp/product/B004CG4CN4) |  |  | 1
microcontroller  |  Raspberry Pi  |  `3B+`  | [link](?) |  |  | 1
microcontroller  |  Raspberry Pi  |  `Zero W`  | [link](https://smile.amazon.com/gp/product/B0748MPQT4) |  |  | 1
motor  |  Black & Decker  |  `GH900` string trimmer  | [link](https://smile.amazon.com/gp/product/B00HH4K6RE) |  `6.5A 13"` |  | 1
motor  |  Ford  |  wiper motor  | [link](https://smile.amazon.com/gp/product/B0010DN0UI) |  `12v` |  | 3
motor  |  InstallGear  |  Linear Actuator  | [link](https://smile.amazon.com/gp/product/B00P2KANI2) |  `12v` |  | 4
motor  |  Kimdrox  |  Mini Gear Box Motor  | [link](https://smile.amazon.com/gp/product/B00L6FQK84) |  `12V DC 1.1W 30rpm 37mm dia. 83mm length 23mm shaft 6mm shaft dia.` |  | 1
motor  |  Ryobi  |  `RY40204` string trimmer  | [link](https://smile.amazon.com/Ryobi-40-Volt-Lithium-Ion-Cordless-Included/dp/B01GOXBO9W) |  `40v` |  | 1
motor  |  STEPPERONLINE  |  `17HS19-2004S1` NEMA 17 stepper motor  | [link](https://smile.amazon.com/gp/product/B00PNEQKC0) |  `2.0A 1.4ohm 0.59Nm 200s/rev 48mm body 5x24mm shaft` |  | 3
motor  |  hitec  |  `HS-311` servo  | [link](?) |  |  | 1
motor  |   |  Miniature Worm Gear Motor  | [link](https://smile.amazon.com/gp/product/B00NLZ46GU) |  `12v 5 RPM 6mm shaft` |  | 2
motor  |   |  Miniature Worm Gear Motor  | [link](https://smile.amazon.com/gp/product/B01D2H4FOY) |  `12v 45 RPM 6mm shaft` |  | 2
motor  |   |  `23HS45-4204S` NEMA 23 stepper motor  | [link](https://smile.amazon.com/gp/product/B074JJ6NGQ) |  `4.2A 0.9ohm 3.0Nm 48V 200s/rev 100mm body 10x24mm shaft D-cut=9.5mm` |  | 2
output  |  Aweking  |  PWM Motor Controller  | [link](https://smile.amazon.com/gp/product/B071ZKGMGN) |  `DC10-60V 30A 500W` |  | 1
output  |  DROK  |  `L298` Dual H Bridge  | [link](https://smile.amazon.com/gp/product/B078TDKC4F) |  `DC 6.5V-27V 7A 24V 160W` |  | 1
output  |  DROK  |  `XY-1260` Motor controller  | [link](https://smile.amazon.com/gp/product/B07B4B2X35) |  `DC 10-50V 60A PWM 48V 3000W ` |  | 2
output  |  HiLetgo  |  `BTS7960` / `IBT_2` H-bridge  | [link](https://smile.amazon.com/gp/product/B00WSN98DC) |  `5.5-27v 43A` |  | 2
output  |  Mysweety  |  `TB6600` (fake)  | [link](https://smile.amazon.com/gp/product/B01MYMK1G9) |  `4A 9-42v` |  | 1
output  |  WGCD  |  `IRF520` MOSFET Driver Module  | [link](https://smile.amazon.com/gp/product/B07F7SV84V) |  |  | 10
output  |  WGCD  |  `L298N` Dual H Bridge  | [link](https://smile.amazon.com/gp/product/B06X9D1PR9) |  `5-35v DC 2A 25W` |  | 4
output  |   |  AC solid state relay `SSR-25`  | [link](https://smile.amazon.com/gp/product/B005KPGPU4) |  |  | 1
output  |   |  DC Dual mosfet  | [link](https://smile.amazon.com/gp/product/B01J78FX9S) |  `5-36V 400W 0-20KHz PWM` |  | 4
output  |   |  `FDP 7030BL` N-channel 30v 60A mosfet  | [link](?) |  |  | 5
output  |   |  `HY-DIV268N-5A` microstep controller  | [link](https://smile.amazon.com/gp/product/B07GNZV6YM) |  `0.2-5A 48v` |  | 3
output  |   |  `IR540` mosfet  | [link](?) |  |  | 16
output  |   |  `IRF1404L` 40v 162A hexfet  | [link](?) |  |  | 2
output  |   |  `PN222a` npn transistor 30V 500mA  | [link](https://www.onsemi.com/pub/Collateral/PN2222-D.PDF) |  |  | 5
output  |   |  `ZS-H3` Dual H Bridge  | [link](https://smile.amazon.com/gp/product/B078TDKC4F) |  `DC 7.5V-40V 3.5A` |  | 3
power  |  Acogedor  |  Battery Charge+Protection BMS  | [link](https://smile.amazon.com/gp/product/B07GDN6PP5) |  `36V 30A` |  | 1
power  |  DROK  |  DC-DC step down Converter  | [link](https://smile.amazon.com/gp/product/B01MSJQAKY) |  `6V-65V to 0-60V 8A 400W` |  | 1
power  |  LST  |  Battery Charger  | [link](https://smile.amazon.com/gp/product/B07F8V8FFT) |  `12V 5A` |  | 1
power  |  Mighty Max  |  GEL Battery   | [link](?) |  `12V 8.6AH 190CCA` |  | 1
power  |  Ninebot  |  `NEB1002-H` battery  | [link](?) |  `36v 5200mAh/187Wh` |  | 1
power  |  Yeeco  |  Battery Charger Protection Board  | [link](https://smile.amazon.com/gp/product/B07JZ4D6ZP) |  `DC 10-90V` |  | 1
power  |   |  Type B outlet  | [link](?) |  `120v AC` |  | ? 
power  |   |  `AS2850` voltage regulator  | [link](?) |  `5A 5v` |  | 5
power  |   |  `HJS-480-0-48` PSU  | [link](https://smile.amazon.com/gp/product/B0777MH681) |  `0-48V 480W` |  | 1
power  |   |  `LM2596` voltage regulator  | [link](https://smile.amazon.com/gp/product/B01GJ0SC2C) |  `3.0-40V to 1.5-35V ` |  | 1
sensor  |  DIYmall  |  6M GPS Module  | [link](https://smile.amazon.com/gp/product/B01H5FNA4K) |  |  | 1
sensor  |  ELGOO  |  37 Sensor Modules Kit  | [link](https://smile.amazon.com/gp/product/B01MG49ZQ5) |  |  | 1
sensor  |  Flysky  |  `IA6B`  | [link](https://smile.amazon.com/gp/product/B0744DPPL8) |  <=10 channel PPM |  | 2
sensor  |  HiLetgo  |  `MPU9250/6500` / `GY-9250` Gyro+Accel+Mag Sensor  | [link](https://smile.amazon.com/gp/product/B01I1J0Z7Y) |  `9-Axis 16 Bit` |  | 1
sensor  |  RPI  |  NV camera  | [link](https://smile.amazon.com/gp/product/B07BK1QZ2L) |  |  | 1
sensor  |  RPI  |  wide angle NV camera  | [link](?) |  |  | 1
sensor  |   |  Photoelectric Switch Sensor Relay  | [link](https://smile.amazon.com/gp/product/B00BLZ93T2) |  `DC 12V` |  | 1
sensor  |   |  `EK8443` IR tx LED /rx diode  | [link](https://smile.amazon.com/gp/product/B01HGIQ8NG) |  `5mm 940nm` |  | 20
sensor  |   |  `HC-SR04` Ultrasonic sensor   | [link](https://smile.amazon.com/gp/product/B071W9689R) |  |  | ? 
sensor  |   |  `TLRS-9700` 40&deg; C cutoff  | [link](?) |  |  | 9
sensor  |  ublox  |  `NEO-6M-001` GPS receiver  | [link](https://smile.amazon.com/gp/product/B01H5FNA4K) | https://engineersportal.com/blog/2018/5/9/comparing-iphone-gps-against-neo-6m-gy-gps6m-gps-module-with-arduino |  | 1
sensor  |   |  current sensor  | [link](https://smile.amazon.com/gp/product/B07L6CNHTJ) | `30A 5V` |  | 4
output | MakerFocus | I2c OLED Display Module | [link](https://smile.amazon.com/gp/product/B076WXR8N9) | `0.96" 128x64 px 16bit grayscale` |  | 1
output | SunFounder | I2c LCD Module | [link](https://smile.amazon.com/gp/product/B07MTFDHXZ) | `20x4 char @ 5x8px/char` |  | 2
output | Elecrow | RPI Touch Screen LCD Display | [link](https://smile.amazon.com/gp/product/B013JECYF2) | `5" 800x480 TFT` |  | 1
sensor |  | `ESP8266` WiFi Module | [link](https://smile.amazon.com/gp/product/B07H1W6DJZ) | 3.3v, NOT 5v!! |  | 4
sensor | Gikfun | `EK8460` / `VS1838B` IR Tx/Rx LED | [link](https://smile.amazon.com/gp/product/B06XYNDRGF) | `5mm 940nm` |  | 10

### ELGOO Sensors

1. Blink  
1. Temperature and Humidity
1. DS18B20 Temperature Sensor
1. Button Switch
1. Switchs  
1. IR Receiver and Emission
1. Active Buzzer
1. Passive Buzzer
1. Laser
1. SMD RGBand RGB
1. Photo-Interrupter
1. Two Color LED
1. Light Dependent Resistor
1. Large Microphone
1. Small Microphone
1. Reed Switch
1. Digital Temperature
1. Linear Magnetic Hall Sensor
1. Flame Sensor
1. Touch Sensor
1. Seven-Color Flash LED
1. Joystick
1. Line Tracking
1. Obstacle Avoidance
1. Rotary Encode
1. Relay
1. LCD Display  
1. Ultrasonic Sensor
1. GY-521
1. HC-SR501 PIR Sensor   
1. Water Level Detection Sensor
1. Real Time Clock
1. Keypad

### TODO / To-source components

1. Experiment with 2bit rotary encoder
1. Fabricate drive sprocket for NEMA23 stepper motor
