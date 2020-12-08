#!/bin/bash -e

# Edit /lib/systemd/system/bluetooth.service to enable Bluetooth services.
sudo sed -i: 's|^Exec.*toothd$| \
ExecStart=/usr/lib/bluetooth/bluetoothd -C \
ExecStartPost=/usr/bin/sdptool add SP \
ExecStartPost=/bin/hciconfig hci0 piscan \
|g' /lib/systemd/system/bluetooth.service

# Create /etc/systemd/system/rfcomm.service to enable 
# the Bluetooth serial port from systemctl.
sudo cat <<EOF | sudo tee /etc/systemd/system/rfcomm.service > /dev/null
[Unit]
Description=RFCOMM service
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/bin/rfcomm watch hci0 1

[Install]
WantedBy=multi-user.target
EOF

# Enable the new rfcomm service.
sudo systemctl enable rfcomm

# Start the rfcomm service.
sudo systemctl restart rfcomm
