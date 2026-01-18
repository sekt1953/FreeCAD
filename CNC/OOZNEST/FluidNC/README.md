# FluidNC

## FluidNC Web Installer

* [FluidNC Web Installer](https://installer.fluidnc.com/fluidnc)
  * ![FluidNC Web Installer](./Images/Skærmbillede%20fra%202026-01-16%2018-24-51.png)
* [External Stepper Motor Drivers](http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers)

## ESP32 Pin Reference

* [ESP32 Pin Reference](http://wiki.fluidnc.com/en/hardware/esp32_pin_reference)
  * Here is a pinout for an ESP32 Dev Kit (ESP32-DevKitC V4). This is common module used for FluidNC controllers, but other versions will work on controllers designed for them. This is a good reference of the capabilities of each pin.
  * Try to buy from a reputable seller. The best come from Espressif and cost about $10. You can find them from AliExpress, for cheaper, but these often have low quality compenets and have trouble programming or crash often due to power issues.
  * Be sure to use the WROOM version and not the WROVER version. The WROVER uses PSRAM and that uses up some GPIO.
  * They are available with different RAM sizes. FluidNC uses the 4MB size. Getting a larger size will not be of much benefit. The web installer and release packages will format it as 4MB by default, so the extra FLASH is not available. Advanced programmers only: If you know how to compile and how to use alternate partition sizes, you can allocate the extra flash for the local file sytem.

  * ![ESP-WROOM-32 DEV KIT MODULE](./Images/Skærmbillede%20fra%202026-01-16%2017-57-57.png)

### Usable I/O pins

* GPIO_NUM_0
  * This is used for the bootloader (Usable, but for experts only). If it is low on boot it will enter bootloader mode. It is best if you can guarantee that it is high regardless of the connected item state at boot. For example if you use it for a limit switch, the switch could force a low state and cause problems.
* GPIO_NUM_2
  * Some dev boards have an LED on this. It does not work well as an input if this is the case because the LED affects the voltage on the pin.
  * It is a strapping pin. It must be either left unconnected/floating, or driven Low, in order to enter the serial bootloader (read more)
  * It works well as the spindle pin. The LED gives a nice indication of the spindle on and PWM level.
* GPIO_NUM_4
* GPIO_NUM_5
* GPIO_NUM_12
  * It is a strapping pin. If driven High, flash voltage (VDD_SDIO) is 1.8V not the default 3.3V. This pin has an internal pull-down resistor, so unconnected = Low = 3.3V. If driven high, the flash may brownout. If however the flash is meant to work at 1.8V then not driving this pin to High may cause the flash to burn out (read more). Most off the shelf controlers (such as the the ESP-WROOM-32) work at the default 3.3V
  * You can remove the strapping pin feature by setting the one time programmable efuse. python espefuse.py --port COM4 set_flash_voltage 3.3V. This will prevent the pin from being checked.
* GPIO_NUM_13
* GPIO_NUM_14 (some pulses at boot)
* GPIO_NUM_15
  * Some pulses at boot
  * It is a strapping pin. If driven Low, silences boot messages printed by the ROM bootloader. Has an internal pull-up, so unconnected = High = normal output (read more).
* GPIO_NUM_16
* GPIO_NUM_17
* GPIO_NUM_18
* GPIO_NUM_19
* GPIO_NUM_21
* GPIO_NUM_22
* GPIO_NUM_23
* GPIO_NUM_25
* GPIO_NUM_26
* GPIO_NUM_27
* GPIO_NUM_32
* GPIO_NUM_33

### Input Only (no pullup/pulldown)

If you do not have external pull up or pull down resistors. Do not use these pins! We recommend a 5k to 10k resistor. If you don't know how to use pull resistors, google it for some nice pictures and diagrams.

* GPIO_NUM_34
* GPIO_NUM_35
* GPIO_NUM_36
* GPIO_NUM_37 (not typically available)
* GPIO_NUM_38 (not typically available)
* GPIO_NUM_39

### Do not use (or not recommended)

* GPIO_NUM_1 - Used for USB/Serial Data
* GPIO_NUM_3 - Used for USB/Serial Data
* GPIO_NUM_20 - This is not available on ESP32
* GPIO_NUM_24 - This is not available on ESP32
* GPIO_NUM_28 - This is not available on ESP32
* GPIO_NUM_29 - This is not available on ESP32
* GPIO_NUM_30 - This is not available on ESP32
* GPIO_NUM_31 - This is not available on ESP32

### Unusable GPIO

*GPIO_NUM_6 - Use for External Flash
*GPIO_NUM_7 - Use for External Flash
*GPIO_NUM_8 - Use for External Flash
*GPIO_NUM_9 - Use for External Flash
*GPIO_NUM_10 - Use for External Flash
*GPIO_NUM_11 - Use for External Flash

### Default Pin

Some pins have default uses in FluidNC. If you are using these functions, it is best to use the default pins. They have been tested a lot and we know they work.

* I2S
  * bck_pin: gpio.22
  * data_pin: gpio.21
  * ws_pin: gpio.17
* SPI (SD CArd, etc)
  * miso_pin: gpio.19
  * mosi_pin: gpio.23
  * sck_pin: gpio.18
* I2C OLED
  * SCL gpio.12
  * SDA gpio.15


## Frequently Asked Questions

### Determining steps per mm.

* For FluidNC, the term steps_per_mm is used because that is the generic term CNC builders use. The firmware is actually sending signal pulses per mm. That is the same as steps only if you are not using microstepping (1 pulse = 1 full step).
* You must calculate this value based on your machine. Typically, leads screws, pulley ratios, belts, etc need to go into this calculation. There are a lot of resources and calculators on the internet to help with this.
* You should carefully test your calculation by jogging a small amount like 10mm and measuring the move. If you measure 20mm you should cut your steps_per_mm in half. If you moved 5mm you should double it. Basically divide the jog distance by the actual move distance and multiply it by your current step_per_mm value.  
    
* Example: steps_per_mm=160, jog amount=10, move=20
* new step_per_mm = 10/20*160 = 80

* Note: If you measure very close, but not exactly the same as your calculation, it may be a measurement error or some slop in your system. "Tuning" these errors out is hard because they are typically not linear with distance. Try some longer moves to check this.
* Note: The machine is always setup in mm even if you use inches.
* If you end up with a high steps_per_mm (over 100) and you are using microstepping, you should consider using a lower microstepping value. High microstepping will limit how fast your machine can move and you will get configuration warnings if you exceed that. Most DIY are not more accurate than 100 steps per mm anyway.

### Can fluidnc motor ena be shared

* Søg i stedet efter fluidnc con moter ena be shared
  * [External Stepper Motor Drivers](http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers)
* AI-oversigt
  * Yes, FluidNC can share an enable (ENA) pin for multiple stepper motor drivers, especially with external drivers that default to enabled, allowing a single pin to control all motors simultaneously for power-up/down or disabling during idle, configured via the **shared_stepper_disable_pin** setting, though individual control is also possible if drivers have separate enable pins.
* How it works
  * External Drivers:
    * Most external drivers (like TB6600) have an ENA pin that disables the driver when connected to a signal, meaning leaving it unconnected enables the motor by default.
  * Shared Control:
    * You can connect the ENA pins of several drivers to a single digital pin on your FluidNC board.
  * FluidNC Configuration:
    * Set this shared pin using the shared_stepper_disable_pin parameter in your FluidNC configuration.
  * Automatic Management: 
    * FluidNC automatically enables drivers for motion and disables them after a set idle time (controlled by idle_ms), or you can manually disable them with the $MD command. 
  * Configuration steps
    * Wire: Connect the ENA pins of all your drivers to one digital output pin on your FluidNC board.
    * Configure: In your FluidNC settings, define the shared pin (e.g., **shared_stepper_disable_pin=25**).
    * Test: If motors are locked, try disconnecting the ENA pin (they should then be enabled) or check if the pin needs inverting (if it locks when it should unlock, set **enable_pin_invert=true**).
