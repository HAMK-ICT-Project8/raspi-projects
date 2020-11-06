#!/bin/sh

# TCP port
port=5000
# GPIO chip you wish to use
# On Raspberry Pi 4 it is "gpiochip0".
chip="gpiochip0"
# Run 'pinout' to decipher which pin is which.
# The GPIO pin your button is connected to
btnPin=4
# The GPIO pin your LED is connected to
ledPin=17

# Listens for value changes on the button pin.
# Outputs strings indicating state changes.
while :; do

	gpiomon \
		--falling-edge \
		--num-events=1 \
		--silent \
		"$chip" "$btnPin"
	echo -n "Button pressed"

	gpiomon \
		--rising-edge \
		--num-events=1 \
		--silent \
		"$chip" "$btnPin"
	echo -n "Button released"

	# Strings are piped to our TCP server
	# which sends them to the client (Unreal Engige).
done | nc -lk "$port" |
	# Pipes any recieved data forward.

	# Changes LED pin value according to recieved data.
	while read -r input; do

		case "$input" in
			on)
				if [ -z "$pid" ]; then
					gpioset --mode=signal "$chip" "$ledPin"=1 &
					pid="$!"
				fi
				;;
			off)
				[ -n "$pid" ] && kill "$pid" && unset pid
				;;
		esac

	done
