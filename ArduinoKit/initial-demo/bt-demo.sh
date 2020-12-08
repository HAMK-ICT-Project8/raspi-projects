#!/bin/bash -e

# Serial port
port="/dev/rfcomm0"
# GPIO chip you wish to use
# On Raspberry Pi 4 it is "gpiochip0".
chip="gpiochip0"
# Run 'pinout' to decipher which pin is which.
# The GPIO pin your button is connected to
btnPin=4
# The GPIO pin your LED is connected to
ledPin=17

# Process ID of this script, needed for trap command
ppid="$$"

# Configure the serial port
stty -F "$port" raw -echo

# Listens for value changes on the button pin.
# Outputs strings indicating state changes.
while :; do

	output=$(gpiomon \
		--falling-edge \
		--num-events=1 \
		--silent \
		"$chip" "$btnPin")
	[ -z "$output" ] && echo "Button pressed"
	# Compensates a bit for false additional actuations.
	sleep 0.05

	output=$(gpiomon \
		--rising-edge \
		--num-events=1 \
		--silent \
		"$chip" "$btnPin")
	[ -z "$output" ] && echo "Button released"
	sleep 0.05

	# Strings are piped to our Bluetooth serial port
	# connected to Unreal Engine. 
done | {
	cat > "$port" &
	# Makes sure all child processes are stopped on script exit.
	trap "pkill -TERM -P $ppid" EXIT;
	# Pipes any recieved data forward from the serial port.
	cat "$port" 
} |

	# Changes LED pin value according to recieved data.
	while read -r input; do
		echo "$input" | sed -un 'l'

		case "$input" in
			?on)
				if [ -z "$pid" ]; then
					gpioset --mode=signal "$chip" "$ledPin"=1 &
					pid="$!"
				fi
				;;
			?off)
				[ -n "$pid" ] && kill "$pid" && unset pid
				;;
		esac

	done


