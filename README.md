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
curl -sSL "https://raw.githubusercontent.com/justaCasualCoder/Zoneminder-Termux/main/installzm.sh" | bash
```
### Setting up on-device cameras
The simplest way I have found to pass through cameras is by running a ip camera server on the phone. The app i have been using is [Cameraserve](https://github.com/arktronic/cameraserve). Although it has not been updated since 2019, it is a Free & Open source app that does everything I could want (It also dosent have ads or telemetry :) ). You can also just download one of the many ip camera apps on google play if you find that easier. Anyway, Once you have all of that set up run the app, and add the ip cam in Zoneminder. [There are multiple guides on how to do this](https://zoneminder.readthedocs.io/en/stable/userguide/gettingstarted.html)
