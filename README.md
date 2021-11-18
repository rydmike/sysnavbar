# Sysnavbar with FlexColorScheme

Transparent Android system navigation bar with Flutter and FlexColorScheme.

> ## FlexColorScheme V4 Notice
>
>If you are using FlexColorScheme version 4 and Flutter 2.5 or later, then this example is obsoloete.
>FlexColorScheme V4 together with Flutter 2.5 or later, support transparent Android system navigation bar without any of the setups discussed here.

## About this Example

This an extra Android companion example to the Flutter 
package [**FlexColorScheme**](https://pub.dev/packages/flex_color_scheme). For more information about **FlexColorScheme** and its usage please refer to its
[**readme**](https://pub.dev/packages/flex_color_scheme) file on pub.ev as well as its 
[**API documentation**](https://pub.dev/documentation/flex_color_scheme/latest/flex_color_scheme/flex_color_scheme-library.html) there.

This example is a variation of example nr 5 bundled with the package and shows
how **FlexColorScheme** can be used to make a transparent system navigation bar in 
Flutter Android applications.

> **NOTE:**  
> The static helper `FlexColorScheme.themedSystemNavigationBar(context, ...)` is designed to provide a 
> convenience wrapper for a `SystemUiOverlayStyle` that works for screens that use 
> and adhere to current theme mode colors.
> 
> If your application use screens that do not follow the current theme, then just use `SystemUiOverlayStyle`
> directly in the annotated region for such screens to define their desired style. You can also make your own
> convenience wrapper function or even just a const value for it if you need to use a fixed style and 
> design frequently.
 
### Change log

**[1.1.0]** March 21, 2021:  
Updated to use FlexColorScheme 2.1.0 and added a show/hide divider on top of system navigation bar on the 
HomePage.

**[1.0.0]** March 15, 2021:  
Updated to sound null safety and to use FlexColorScheme 2.0.0.

**[0.1.0]** Jan 18, 2021:  
First version released with FlexColorScheme 1.4.0.

## Android setup

To make transparent system navigation bar in Flutter you must also make this change to them MainActivity.kt
file in your Flutter Android embedder:

in `../android/app/src/main` the default `MainActivity.kt` for your project:

```kotlin
package com.rydmike.sysnavbar  // Replace with your package name

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
```

is changed to:

```kotlin
package com.rydmike.sysnavbar  // Replace with your package name

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            window.setDecorFitsSystemWindows(false)
        }
    }
}
```

Additionally, you must use Android SDK 30 to build the Flutter Android project, so you also need to update 
your `build.gradle` file in `../android/app` from:

```kotlin
 :
android {
compileSdkVersion 29

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        applicationId "com.rydmike.sysnavbar"
        minSdkVersion 16
        targetSdkVersion 29
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
  :
```

to be:

```kotlin
 :
android {
compileSdkVersion 30

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    lintOptions {
        disable 'InvalidPackage'
    }

    defaultConfig {
        applicationId "com.rydmike.sysnavbar"
        minSdkVersion 16
        targetSdkVersion 30
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
  :
```

You can find additional info and discussion about transparent system navigation in Flutter Android apps in 
[**Flutter issue 69999**](https://github.com/flutter/flutter/issues/69999), it was that discussion that lead me
to adding this experimental support for it in [**FlexColorScheme**](https://pub.dev/packages/flex_color_scheme).

## Support both transparent and color branded sysnavbar

When you want to use color branded system navigation bar it is best to never put any transparency on it if it is not
supported. Adding transparency to the system navigation bar color when it is not supported, will just make
the color on it transparent and show the default scrim color used on the system navigation bar. This will not look
very nice.

If you design your app to use transparent system navigation bar when it is supported, and then want to use and have a 
nice looking color branded background colored system navigation bar, when transparency is not supported, then we must
check which Android SDK level the application is running on and adjust the behaviour accordingly. We can use the 
package `device_info` to get the Android SDK level and keep the `opacity` as 1 when SDK level is below 30.

This example presents one suggestion on how this can be implemented, and the different approach to the design for
the use cases. 

In the sub-page in this example, it also shows how you can use a fully transparent system navigation bar when possible,
and for the case when this is not possible, a color branded opaque one. Then combine this with a same background primary 
color branded Material `BottomNavigationBar` using a slight transparency. For the case that support 
transparency on the system navigation bar, when it is placed on top of this `BottomNavigationBar` with its slight 
transparency, it makes `BottomNavigationBar` and system navigation bar look like one shared translucent bottom area, 
with content scrolling behind it. 

For the case when the system navigation bar transparency is not supported, it still has 
the same color as the `BottomNavigationBar`, but without the transparency, so it does not clash so badly 
with it. The `BottomNavigationBar` still keeps it slight transparency, and we can at least see content scrolling behind 
it. 

Instead of just transparency on the bottom navigation bar, you can add a container to it with blur filter in it,
you can then recreate the iOS frosted glass blur effect and have that on the system navigation bar too. 
This is not shown in this demo, but is e.g. used by one of the configuration options offered for Material 
`BottomNavigationBar` in Flexfold. 

The end result is an app looking like the left one, when transparency is supported and like the right one, 
when it is not. I kind of like it.

This setup also supports the much smaller Android system navigation bar you get when the phone is configured to 
use gestures. Some Android implementations don't even use a visible system navigation bar when gestures are enabled,
this configuration also works with such Android implementation, like e.g. OnePlus gestures.

<img src="https://github.com/rydmike/sysnavbar/blob/master/resources/sysnavbar4.gif?raw=true" alt="System navbar transparent"/>

>Please note that phones with API30 (Android 11), were when this was written (Jan 16, 2021) still very
>rare, and at the time did not even register on
>[**statcounter**](https://gs.statcounter.com/os-version-market-share/android/mobile-tablet/worldwide). This
> will improve over time.
