


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




Resource file missing

Next up, I got the following error:

Source file '/home/acu/RiderProjects/App1/App1/App1.Android/Resources/Resource.Designer.cs' could not be found.

Nasty error, what I figured out is that this problem happens because Linux is case sensitive (Windows isn't).

In the Android project file "<same_name>.Droid.csproj" there's the following line:

<AndroidResgenFile>Resources\Resource.designer.cs</AndroidResgenFile>

And a bit further down in the same file, there's the following:

<Compile Include="Resources\Resource.Designer.cs" />

As far as the Linux file system is concerned, Resource.Designer.cs and Resource.designer.cs are different files. You can fix the casing in either line - and the error's gone.

And that's it, now I was able to compile the Android project successfully



- https://github.com/Flying--Dutchman/RiderXamarinAndroid/blob/main/README.md

- https://rider-support.jetbrains.com/hc/en-us/articles/360000557259--Obsolete-How-to-develop-Xamarin-Android-applications-on-Linux-with-Rider
