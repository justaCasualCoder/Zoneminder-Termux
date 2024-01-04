# Zoneminder On Android!
This is a bash script which auto installs Zoneminder , Apache2 , and Mariadb in a proot container.... Without Root! 
## Getting started on Android
1. Donwload [Termux](https://f-droid.org/en/packages/com.termux/)
2. Set up a proot container 
```
termux-setup-storage
proot-distro install debian
```
3. Login to the container
```
proot-distro login debian
```
4. Install Zoneminder!
```
wget https://raw.githubusercontent.com/justaCasualCoder/Zoneminder-Termux/main/installzm.sh && bash installzm.sh
```

### What the bash script does
- Install's Mariadb , Apache2 , and Zoneminder 
- Configures Mariadb with zmuser and zmpass
- Enables Conf Zoneminder and enabled modules
- Adds API to Zoneminder conf
- Changes Apache2 port from 80 to 8080
- Starts Zoneminder , Apache2 , and Mariadb

##### Why?
- Because it is free and is WAY more customizable than most options on the market
- Open Source
- I had found [this](https://github.com/tapans/DIY-Surveillance-with-Smartphones) and liked the idea but it was far to outdated to use
- I had the time

### Setting up on-device cameras
The simplest way I have found to pass through cameras is by running a ip camera server on the device. The app i have been using is [Cameraserve](https://github.com/arktronic/cameraserve). Although it has not been updated since 2019, it is a Free & Open source app that does everything I could want (It also dosent have ads or telemetry :) ). You can also just download one of the many ip camera apps on google play if you find that easier. Anyway, Once you have all of that set up run the app, and add the ip cam in Zoneminder. [There are multiple guides on how to do this](https://zoneminder.readthedocs.io/en/stable/userguide/gettingstarted.html). cURL setting seems to work with the above app
