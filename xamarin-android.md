# How to install xamarin-android for Rider

## 1. Xamarin.Android package

1. Download the current release of Xamarin.Android from the build server: https://dev.azure.com/xamarin/public/_build?definitionId=48&_a=summary
2. Pick one where both stages were successfull and click on it.
3. In the "Summary" box, check for "Related" and click on "n published" below it.
4. Download the "installers-unsigned - Linux" (Using the 3 dots menu on the far right)
5. Unzip the downloaded file.
6. If possible install using your package manager. <br>
6.1 **Arch Linux users**: You can install the .deb package using "debtap"<br>
6.2 sudo debtap -U<br>
6.3 sudo debtap -U < deb_file ><br>
6.4 Enter Packager name: xamarin-android
6.5 When asked to edit the .PGKINFO file, do so with your favourite editor (select number 4 and enter xed) and remove any invalid, or not needed dependency. (In my case I removed c, c0 and java8-sdk)<br>
6.6 Install the zst package using the command sudo pacman -U < zst_file ><br>

## 2. Adding udev rules (required for USB debugging)

To install, run: `sudo pacman -S --noconfirm android-udev`

If you have problems connecting your android device via usb, use the following commands:

```bash
sudo adb kill-server
sudo adb start-server
sudo adb devices
```

## 3. Install OpenJDK Java 8 development kit

`sudo pacman -S --noconfirm jdk8-openjdk`

## 4. Install plugin "Rider Xamarin Android Support"

## 5. Setting up Rider

In the Rider, when creating a Xamarin project, you can immediately put the base version of the Android SDK. Then go to the "SDK Components" tab and install NDK.

1. In your Rider settings, search for "SDK Components" and set the following fields (should be under "Build, Execution, Deployment" --> "Android" --> "SDK Components"):<br>
2. Under "SDK Platforms" install the Android API and the latest stable Android version.
3. Under "SDK Tools" make sure that the following are installed:<br>
3.1 Android SDK Build-Tools<br>
3.2 NDK (Side by side)<br>
3.3 Android SDK Command-line Tools<br>
3.4 CMake<br>
3.5 Android Emulator<br>
3.6 Android SDK Platform-Tools
4. In your Rider settings, search for "Android" and set the following fields (should be under "Build, Execution, Deployment" --> "Android"):<br>
4.1 Android SDK Location (e.g. /home/user/Android/Sdk)<br>
4.2 Android NDK Location (e.g. /home/user/Android/Sdk/ndk/< version >)<br>
4.3 Java Development Kit Location (e.g. /usr/lib/jvm/java-8-openjdk)

## Resource file missing

```
Next up, I got the following error:<br>
Source file '/home/acu/RiderProjects/App1/App1/App1.Android/Resources/Resource.Designer.cs' could not be found.<br>
Nasty error, what I figured out is that this problem happens because Linux is case sensitive (Windows isn't).<br>
In the Android project file there's the following line:<br>
<AndroidResgenFile>Resources\Resource.designer.cs</AndroidResgenFile><br>
And a bit further down in the same file, there's the following:<br>
<Compile Include="Resources\Resource.Designer.cs" /><br>
As far as the Linux file system is concerned, Resource.Designer.cs and Resource.designer.cs are different files. You can fix the casing in either line - and the error's gone.
And that's it, now I was able to compile the Android project successfully.
```

## Links

- https://github.com/Flying--Dutchman/RiderXamarinAndroid/blob/main/README.md

- https://rider-support.jetbrains.com/hc/en-us/articles/360000557259--Obsolete-How-to-develop-Xamarin-Android-applications-on-Linux-with-Rider
