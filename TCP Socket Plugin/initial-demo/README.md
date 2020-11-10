# Initial demo
This is a proof of concept of communication between Raspberry Pi and Unreal
Engine via TCP. In this demo, a button switch and a LED is connected to a
Raspberry Pi's GPIO interface. You can turn on the LED by pressing and holding
'1' key within Unreal Engine and see a state change of the button updated on the
screen in Unreal Engine.
## Dependencies
### Unreal Engine
* [TCP Socket Plugin](https://www.unrealengine.com/marketplace/en-US/product/tcp-socket-plugin)
### Raspberry Pi
* gpiod
