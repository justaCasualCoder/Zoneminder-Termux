# Zoneminder On Android!
This is a bash script auto installs Zoneminder,Apache2, and Mysql. 
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