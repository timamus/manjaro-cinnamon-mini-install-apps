


For a custom editor or any other key to continue: 4
:: Enter command for running custom editor: xed



Enter Packager name:
xamarin-android


Adding udev rules

Use the rules from android-udev (or android-udev-gitAUR), install them manually from Android developer, or use the following template for your udev rules, just replace [VENDOR ID] and [PRODUCT ID] with yours. Copy these rules into /etc/udev/rules.d/51-android.rules:

/etc/udev/rules.d/51-android.rules

SUBSYSTEM=="usb", ATTR{idVendor}=="[VENDOR ID]", MODE="0660", GROUP="adbusers"
SUBSYSTEM=="usb",ATTR{idVendor}=="[VENDOR ID]",ATTR{idProduct}=="[PRODUCT ID]",SYMLINK+="android_adb"
SUBSYSTEM=="usb",ATTR{idVendor}=="[VENDOR ID]",ATTR{idProduct}=="[PRODUCT ID]",SYMLINK+="android_fastboot"

Then, to reload your new udev rules, execute:

# udevadm control --reload-rules

Make sure you are member of adbusers user group to access adb devices. 

- https://github.com/Flying--Dutchman/RiderXamarinAndroid/blob/main/README.md

- https://rider-support.jetbrains.com/hc/en-us/articles/360000557259--Obsolete-How-to-develop-Xamarin-Android-applications-on-Linux-with-Rider
