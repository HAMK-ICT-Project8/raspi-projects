# Initial demo
This is a proof of concept of communication between Raspberry Pi and Unreal
Engine via Serial over Bluetooth. In this demo, a button switch and a LED is
connected to a Raspberry Pi's GPIO interface. You can turn on the LED by
pressing and holding :one: key within Unreal Engine game and see a state change
of the button updated on the game screen.

This demo was created using Unreal Engine 4.25.4 and ArduinoKit from [our repository](https://github.com/HAMK-ICT-Project8/ArduinoKit).

## Table of contents
* [Dependencies](#dependencies)
* [Installation](#installation)
* [Usage](#usage)

## Dependencies

### Hardware
* Button switch
* Red LED
* 220R resistor

### Software

#### Unreal Engine
* [ArduinoKit](https://github.com/HAMK-ICT-Project8/ArduinoKit)

#### Raspberry Pi
* gpiod

## Installation

### Raspberry Pi

#### Hardware
1. Connect to Raspberry Pi connected to your local network via SSH. The
   username is `pi` and the hostname is `raspberrypi`.
2. Run `pinout` command. It should show you the GPIO pin-out information of
   your device.
3. According to the command output, make a connection from pin `GPIO17` to 220R
   resistor and from the resistor to the longer leg of a red LED. Connect the
   shorter leg to one of the ground(`GND`) pins. It doesn't matter which one.
4. Make a connection from pin `GPIO4` to one of the legs on the button switch.
   From the opposite corner of the switch, make a connection to one of the
   ground pins.

#### Software
1. Install gpiod package by running these commands on Raspberry Pi:
		
		sudo apt update
		sudo apt install gpiod
		
2. Download `demo.sh` and `serial-over-bt.sh` to Raspberry Pi, for example like this: 
		
		wget ./bt-demo.sh  \
			./serial-over-bt.sh
		
3. And make them executable:
		
		chmod +x bt-demo.sh serial-over-bt.sh
		
4. Run `serial-over-bt.sh` to set up necessary services to automatically create
   a serial port on Bluetooth connection:
		
		./serial-over-bt.sh
		

### Unreal Engine
1. Create a new blank Blueprint project.
2. Install ArduinoKit plugin to your project according to
   [the instructions](https://github.com/HAMK-ICT-Project8/ArduinoKit#how-to-use-it).
3. Replace the existing files with
   [Minimal_Default_BuiltData.uasset](./Minimal_Default_BuiltData.uasset)
   and
   [Minimal_Default.umap](./Minimal_Default.umap)
   in `<your project>/Content/StarterContent/Maps`. In Unreal Editor the
   Blueprint should look like
   [this](./Minimal_Default.png)
   with a function like 
   [this](./ReadSerial.png).
   In `Open` node insert the serial port of your Raspberry Pi. To find the
   right serial port, you can follow the Bluetooth pairing section in
   [here](https://github.com/HAMK-ICT-Project8/arduino-projects/tree/main/Cluster%20Communication%20Port/Ambient%20LED%20via%20BT#usage).

## Usage

1. Start the serial communication script on Raspberry Pi, and leave it running:

		./bt-demo.sh

2. Start the Unreal Engine game.
3. Hold :one: key on your keyboard to light up the LED, release the key to turn
   it off.
4. When pressing the button switch, you can see the button state changes
   printed on the game screen.
