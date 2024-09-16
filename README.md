# BlueNomad
A tool which show the strenght and range of Bluetooth devices.

# Key Features
- Show Strenght and Link Quality
- Show Range of Target Bluetooth Device from the Point of Scan

# OS Support
- Raspberry Pi OS

# Parameters
There are 2 parameters :

-i - Bluetooth Interface (e.g. hci0)
-a - Target Bluetooth Device Address

# Install and Run
1. Download or Clone the Repository.
2. Open the folder and type the following command :

```
make
```
3. Type the following command to start :
```
sudo ./BlueNomad.sh -i hci0 -a XX:XX:XX:XX:XX:XX
```
