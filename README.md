# BlueNomad
A tool which show the strenght and range of Bluetooth devices.

# Credits
This tool is inspired from [GIJack](https://github.com/GIJack/BlueRanger).

# Key Features
- Show Strenght and Link Quality
- Show Range of Target Bluetooth Device from the Point of Scan preciously.

# OS Support
- Raspberry Pi OS

# Parameters
There are 2 parameters :
1. *-i - Bluetooth Interface (e.g. hci0)*
2. *-a - Target Bluetooth Device Address*

# Install and Run
1. Download or Clone the Repository.
2. Open the folder and type the following command :

```
make
```
3. Type the following command to start :
```
sudo ./BlueNomad.sh -i hciX -a XX:XX:XX:XX:XX:XX
```
- Replace `X` with bluetooth interface number like 0,1,2 etc.
- Replace `XX:XX:XX:XX:XX:XX` with MAC Address of the Bluetooth Device.
