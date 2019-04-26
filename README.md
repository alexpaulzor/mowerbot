# mowerbot
A lawnmowing robot

# Incoming prototype state:

## BOM

### Electronics
1. 12v battery `Mighty Max 12V 8.6AH 190CCA GEL Battery`
1. 0-48V 480W PSU [HJS-480-0-48](https://smile.amazon.com/gp/product/B0777MH681)
1. adjustable [LM2596 3.0-40V to 1.5-35V voltage regulator](https://smile.amazon.com/gp/product/B01GJ0SC2C)
1. [voltage display](https://smile.amazon.com/gp/product/B00YALV0NG)
1. H bridge [HiLetgo BTS7960 43A](https://smile.amazon.com/gp/product/B00WSN98DC)
1. R/C receiver [Flysky IA6B](https://smile.amazon.com/gp/product/B0744DPPL8)
1. TB6600-type stepper driver [HY-DIV268N-5A](https://smile.amazon.com/gp/product/B07GNZV6YM)
1. AC solid state relay [SSR-25](https://smile.amazon.com/gp/product/B005KPGPU4)
1. [Rocker switch](https://smile.amazon.com/gp/product/B011U1NU90)
1. [Limit switch](https://smile.amazon.com/gp/product/B00E0JOTV8)
1. [Arduino ATMEGA2650 knockoff](https://smile.amazon.com/gp/product/B00D9NA4CY)

### Hardware
1. [12v wiper motor]()
1. [NEMA 17 stepper motor](https://smile.amazon.com/gp/product/B00PNEQKC0)
1. [NEMA 17 mount](https://smile.amazon.com/gp/product/B071NWWB7Z)
1. [Black & Decker string trimmer](https://smile.amazon.com/gp/product/B00HH4K6RE)
1. [#40 roller chain](https://smile.amazon.com/gp/product/B00NP5LDMG)
1. [MakerBeam](https://smile.amazon.com/gp/product/B06XHXJSVL)
1. [1" square steel tubing](https://smile.amazon.com/gp/product/B003TPMSDK)
1. [8mm linear motion rods](https://smile.amazon.com/gp/product/B01LPZPJ18)
1. [8mm linear motion screw](https://smile.amazon.com/gp/product/B01H1QNSAE)
1. [6 to 8mm shaft connector](https://smile.amazon.com/gp/product/B07BY8PHGZ)
1. [8mm shaft mount](https://smile.amazon.com/gp/product/B06X94LZ33)
1. [8mm shaft bearing](https://smile.amazon.com/gp/product/B07K7DX3L6)
1. [608zz bearing](https://smile.amazon.com/gp/product/B07211VH78)
1. [8mm linear bearing](https://smile.amazon.com/gp/product/B01LPZPJ18)
1. [IEC C14 plug](https://smile.amazon.com/gp/product/B07DCXKNXQ)
1. [Type B outlet]()


## Wiring

| Arduino pin | Color | Function | Destination pin |
| ----------- | ----- | -------- | --------------- |
| 3 | violet | PPM | <code>IA6B<sub>1</sub></code> |
| 4 | gray | L - forward enable | <code><sup>L</sup>IBT2<sub>L_EN</sub></code> |
| 5 | violet | L forward speed | <code><sup>L</sup>IBT2<sub>R_PWM</sub></code> |
| 6 | blue | L reverse speed | <code><sup>L</sup>IBT2<sub>L_PWM</sub></code> |
| 7 | green | L reverse enable | <code><sup>L</sup>IBT2<sub>R_EN</sub></code> |
| 8 | brown | R forward enable | <code><sup>R</sup>IBT2<sub>R_EN</sub></code> |
| 9 | red | R reverse enable | <code><sup>R</sup>IBT2<sub>L_EN</sub></code> |
| 10 | orange | R forward speed | <code><sup>R</sup>IBT2<sub>R_PWM</sub></code> |
| 11 | yellow | R reverse speed | <code><sup>R</sup>IBT2<sub>L_PWM</sub></code> |
| 12 | red | RC power | <code>IA6B<sub>vcc</sub></code> |
| 13 | violet | status LED |  |
| 22 | white | SSR enable | <code>SSR<sub>+</sub></code> |
| 26 | green |  |  |
| 27 | blue |  |  |
| 28 | violet | |  |
| 29 | gray | |  |
| 30 | brown | |  |
| 50 | orange | limit switch |  |
| 51 | white | Stepper ENA | <code>TB6600<sub>ENA-</sub></code> |
| 52 | brown | Stepper DIR | <code>TB6600<sub>DIR-</sub></code> |
| 53 | orange | Stepper PUL | <code>TB6600<sub>PUL-</sub></code> |


# Next Gen

## Add Components

### Electronics

1. 36v battery `NEB1002-H 36v 5200mAh/187Wh` 
1. Ultrasonic sensor [HC-SR04](https://smile.amazon.com/gp/product/B071W9689R)
1. Raspberry Pi [Zero W](https://smile.amazon.com/gp/product/B0748MPQT4)
1. RPI NV [camera](https://smile.amazon.com/gp/product/B07BK1QZ2L)

### Hardware

1. [Ryobi RY40204 40v string trimmer](https://smile.amazon.com/Ryobi-40-Volt-Lithium-Ion-Cordless-Included/dp/B01GOXBO9W)

### To-source components
1. GPS receiver
1. Directional sensor
1. travel motion feedback sensor--IR interrupt?
1. Accelerometer?
