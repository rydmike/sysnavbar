# IMPORTANT

This is still a work in progress, in the sense that the updated version of
**FlexColorScheme** that supports this app has not yet been published on pub.dev.
The example app is otherwise ready.

This notice will be removed when it has been published, most likely Jan 16, 2021.

## Sysnavbar with FlexColorScheme

Transparent Android system navigation bar with Flutter and FlexColorScheme.


## About this Example

This an extra Android companion example to the Flutter 
package [**FlexColorScheme**](https://pub.dev/packages/flex_color_scheme).

It is a slight modification of example nr 5 bundled with the package and shows
how FlexColorScheme can be used to make a transparent system navigation bar in 
Flutter Android applications.


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

## How to design for both transparent and color branded

When you want to use color branded system navigation bar it is best to never put any transparency on it if it is not
supported. Adding transparency to the system navigation bar color when it is not supported will just make
the color on it transparent and show the default scrim color used on the system navigation bar. This will not look
very nice.

If you design your app to use transparent system navigation bar when it is supported and want to use and have a nice
look background color branded system navigation bar color when transparency is not supported, then we must
check Android SDK level the application is running on adjust the behaviour accordingly. You can use the package
`device_info` to get the Android SDK level and keep the `opacity` as 1 when SDK level is < 30.

This example also presents one suggestion on how this can be accomplished.

The end result is an app looking like the left one, when transparency is supported and like the right one, 
when it is not.

<img src="https://github.com/rydmike/sysnavbar/blob/master/resources/sysnavbar4.gif?raw=true" alt="System navbar transparent"/>