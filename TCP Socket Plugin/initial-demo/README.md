# Initial demo
This is a proof of concept of communication between Raspberry Pi and Unreal
Engine via TCP. In this demo, a button switch and a LED is connected to a
Raspberry Pi's GPIO interface. You can turn on the LED by pressing and holding
:one: key within Unreal Engine game and see a state change of the button
updated on the game screen.

As TCP connections can be done over networks, the communication can be done
both wired and wirelessly, even over the Internet, though in that case
attention to proper connection security is adviced.

## Dependencies

### Hardware
* Button switch
* Red LED
* 220R resistor

### Software

#### Unreal Engine
* [TCP Socket Plugin](https://www.unrealengine.com/marketplace/en-US/product/tcp-socket-plugin)

#### Raspberry Pi
* gpiod

## Installation

### Raspberry Pi

#### Hardware
1. Connect to Raspberry Pi connected to your local network via SSH. The username is `pi` and the hostname is `raspberrypi`.
2. Run `pinout` command. It should show you the GPIO pin-out information of your device.
3. According to the command output, make a connection from pin `GPIO17` to 220R resistor and from the resistor to the longer leg of a red LED. Connect the shorter leg to one of the ground(`GND`) pins. It doesn't matter which one.
4. Make a connection from pin `GPIO4` to one of the legs on the button switch. From the opposite corner of the switch, make a connection to one of the ground pins.

#### Software
1. Install gpiod package by running these commands on Raspberry Pi:
		
		sudo apt update
		sudo apt install gpiod
		
2. Download `demo.sh` to Raspberry Pi, for example like this: 
		
		wget https://raw.githubusercontent.com/HAMK-ICT-Project8/raspi-projects/main/TCP%20Socket%20Plugin/initial-demo/demo.sh
		
3. And make it executable:
		
		chmod +x demo.sh
4. Run `ip add` command and look up the local IP address of your device. It's either under `eth0` interface if you have a wired connection or under `wlan0` if wireless. This is needed for setting up the Unreal Engine blueprint.

### Unreal Engine
1. Download TCP Socket Plugin from Unreal Engine Marketplace and optionally move the plugin to your project.
2. Create a new blueprint class and set its parent class to `TcpSocketConnection`.
3. Create a similar blueprint as in [blueprint.png](https://github.com/HAMK-ICT-Project8/raspi-projects/blob/main/TCP%20Socket%20Plugin/initial-demo/blueprint.png). In `Connect` node insert the local IP of your Raspberry Pi.
4. Add the class to your game world.

## Usage

1. Start the TCP server script on Raspberry Pi, and leave it running:

		./demo.sh

2. Start the Unreal Engine game.
3. Hold :one: key on your keyboard to light up the LED, release the key to turn it off.
4. When pressing the button switch, you can see the button state changes printed on the game screen.
