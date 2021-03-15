import 'dart:async';
import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

import 'all_shared_imports.dart';
import 'color_schemes.dart';
import 'home_page.dart';

// -----------------------------------------------------------------------------
// FlexColorScheme: Transparent SysNavBar Example.
//
// This example builds on example number 5 bundled with FlexColorScheme package:
// https://pub.dev/packages/flex_color_scheme
// To show how you can use transparent system navigation bar in Flutter Android
// apps together with FlexColorScheme.
//
// It also shows how you can use all the built in color schemes in
// FlexColorScheme to define themes from them and how you can define your own
// custom scheme colors and use them together with the predefined ones.
// It can give you an idea of how you can create your own complete custom list
// of themes if you do not want to use any of the predefined ones.
//
// The example also shows how you can use the surface branding feature and
// how to use the custom app bar theme features of FlexColorScheme. The usage
// of the true black theme feature for dark themes is also demonstrated.
// Using the optional Windows desktop like tooltip theme is also shown.
//
// A toggle that allows us to compare the result of custom defined dark schemes
// to the lazy computed versions is also available. To further demonstrate the
// difference between FlexColorScheme.toTheme and ThemeData.from an option
// to try both is presented for comparison purposes.
//
// The example includes a dummy responsive side menu and rail to give a visual
// presentation of what applications that have larger visible surfaces using the
// surface branding look like.
//
// A theme showcase widget shows the theme with several common Material widgets.
//
// ---
// For simplicity this example just creates a few const and final instances
// of the needed objects and list in 'color_schemes'. In a real app, you may
// want to use a Provider or equivalent package(s) to provide the objects
// where needed in your app. Still these are just consts and finals, so this
// works just fine for them.
// -----------------------------------------------------------------------------

void main() {
  runZonedGuarded(() {
    runApp(const DemoApp());
  }, (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  // Used to select if we use the dark or light theme.
  late ThemeMode themeMode;

  // Used to select which FlexSchemeData we use in our list of schemes.
  late int themeIndex;

  // Enum used to control the level of primary color surface branding applied
  // to surfaces and backgrounds.
  late FlexSurface flexSurface;

  // Enum used to select what app bar style we use.
  late FlexAppBarStyle flexAppBarStyle;

  // Used to modify the themed app bar elevation.
  late double appBarElevation;

  // Enum used to select what tab bar style we use.
  late FlexTabBarStyle flexTabBarStyle;

  // If true, tooltip theme background will be light in light theme, and dark
  // in dark themes. The Flutter and Material default and standard is the other
  // way, tooltip background color is inverted compared to app background.
  // Set to true, to mimic e.g. the look of Windows desktop tooltips. You
  // could tie this to the active platform and have different style of tooltips
  // on different platforms.
  late bool tooltipsMatchBackground;

  // Allow toggling between normal dark mode and true black dark mode.
  late bool darkIsTrueBlack;

  // Allow toggling between using the actual defined dark color scheme or try
  // how it would look if we had not defined the dark colors, but had been lazy
  // and just created the dark scheme from the light scheme with the toDark()
  // method.
  late bool useToDarkMethod;

  // The 'level' of white blend percentage used when computing dark scheme
  // colors from the light scheme colors with the toDark method.
  late int level;

  // Use the toTheme method to create Themes from [FlexColorScheme]. This
  // is the preferred method when using [FlexColorScheme]. In this demo
  // you can use a toggle to see what a FlexColorScheme looks like if you just
  // return its color scheme and use [ThemeData.from] to instead create your
  // theme.
  late bool useToThemeMethod;

  // The Android SDK level
  late int androidSDKLevel;

  @override
  void initState() {
    super.initState();
    themeMode = ThemeMode.light;
    themeIndex = 5; // Start with hippie blue theme.
    flexSurface = FlexSurface.heavy;
    flexAppBarStyle = FlexAppBarStyle.background;
    appBarElevation = 0;
    flexTabBarStyle = FlexTabBarStyle.forAppBar;
    tooltipsMatchBackground = false;
    darkIsTrueBlack = false;
    useToDarkMethod = false;
    level = 35;
    useToThemeMethod = true;
    androidSDKLevel = 0; // Set to 0 as a starting point.
    initPlatformState();
  }

  // If we a re running on Android, then the androidSDKLevel will be changed
  // to current Android DSK level, otherwise it will remain 0.
  Future<void> initPlatformState() async {
    int _sdkLevel = 0;
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo deviceData =
            await DeviceInfoPlugin().androidInfo;
        _sdkLevel = deviceData.version.sdkInt;
      } else {
        _sdkLevel = 0;
      }
    } on PlatformException {
      _sdkLevel = 0;
    }
    setState(() {
      androidSDKLevel = _sdkLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlexColorScheme',
      // Define the light theme for the app, using current theme index, selected
      // surface style and app bar style. With the built in 20 themes and the
      // custom ones we defined above, we can use 23 different app themes via
      // the definition below, times the surface styles and app bar variants.
      // The factory FlexColorScheme.light is used to define a FlexColorScheme
      // for a light theme, from the light FlexSchemeColor plus some other theme
      // factory properties, like the surface and app bar style used in
      // this example as well as the tooltip and true black setting for the dark
      // theme.
      // Lastly the method .toTheme is used to create the slightly opinionated
      // theme from the defined color scheme.
      //
      // In this example we also demonstrate how to create the same theme with
      // the standard from color scheme ThemeData factory. The surface style
      // works, but will not be applied as elegantly, but it works fairly OK up
      // to medium blend. The app bar style has no effect here, nor the tooltip
      // style. We also have to make sure we use the same typography as the one
      // used in FlexColorScheme, otherwise the animated theme will show an
      // assertion error as it cannot animate between different typography or
      // null default typography in the theme data.
      //
      // When toggling between the standard ThemeData.from and the
      // FlexColorScheme.toTheme we can observe the differences and also see
      // some of the colors the standard method does not fully adjust to match
      // the used color scheme.
      theme: useToThemeMethod
          ? FlexColorScheme.light(
              colors: myFlexSchemes[themeIndex].light,
              surfaceStyle: flexSurface,
              appBarStyle: flexAppBarStyle,
              appBarElevation: appBarElevation,
              tabBarStyle: flexTabBarStyle,
              tooltipsMatchBackground: tooltipsMatchBackground,
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              fontFamily: AppFonts.mainFont,
            ).toTheme
          // The default ThemeData.from method as an option, for demo and
          // comparison purposes. It will not not be fully color scheme colored,
          // nor will it look as nice and balanced when color branding is used.
          : ThemeData.from(
              textTheme: ThemeData(
                brightness: Brightness.light,
                fontFamily: AppFonts.mainFont,
              ).textTheme,
              colorScheme: FlexColorScheme.light(
                colors: myFlexSchemes[themeIndex].light,
                surfaceStyle: flexSurface,
                appBarStyle: flexAppBarStyle,
                appBarElevation: appBarElevation,
                tabBarStyle: flexTabBarStyle,
                tooltipsMatchBackground: tooltipsMatchBackground,
                visualDensity: FlexColorScheme.comfortablePlatformDensity,
                fontFamily: AppFonts.mainFont,
              ).toScheme,
            ).copyWith(
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              typography: Typography.material2018(
                platform: defaultTargetPlatform,
              ),
            ),
      // We do the exact same definition for the dark theme, but using
      // FlexColorScheme.dark factory and the dark FlexSchemeColor and we add
      // the true black option as well and the feature to demonstrate
      // the usage of computed dark schemes.
      darkTheme: useToThemeMethod
          ? FlexColorScheme.dark(
              colors: useToDarkMethod
                  ? myFlexSchemes[themeIndex].light.defaultError.toDark(level)
                  : myFlexSchemes[themeIndex].dark,
              surfaceStyle: flexSurface,
              appBarStyle: flexAppBarStyle,
              appBarElevation: appBarElevation,
              tabBarStyle: flexTabBarStyle,
              tooltipsMatchBackground: tooltipsMatchBackground,
              darkIsTrueBlack: darkIsTrueBlack,
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              fontFamily: AppFonts.mainFont,
            ).toTheme
          : ThemeData.from(
              textTheme: ThemeData(
                brightness: Brightness.dark,
                fontFamily: AppFonts.mainFont,
              ).textTheme,
              colorScheme: FlexColorScheme.dark(
                colors: useToDarkMethod
                    ? myFlexSchemes[themeIndex].light.defaultError.toDark(level)
                    : myFlexSchemes[themeIndex].dark,
                surfaceStyle: flexSurface,
                appBarStyle: flexAppBarStyle,
                appBarElevation: appBarElevation,
                tabBarStyle: flexTabBarStyle,
                tooltipsMatchBackground: tooltipsMatchBackground,
                darkIsTrueBlack: darkIsTrueBlack,
                visualDensity: FlexColorScheme.comfortablePlatformDensity,
                fontFamily: AppFonts.mainFont,
              ).toScheme,
            ).copyWith(
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              typography: Typography.material2018(
                platform: defaultTargetPlatform,
              ),
            ),
      // Use the above dark or light theme based on active themeMode.
      themeMode: themeMode,
      // This simple example app has only one page.
      home: HomePage(
        // We pass it the current theme mode.
        themeMode: themeMode,
        // On the home page we toggle theme mode between light and dark.
        onThemeModeChanged: (ThemeMode mode) {
          setState(() {
            themeMode = mode;
          });
        },
        // We pass it the index of the active theme.
        schemeIndex: themeIndex,
        // We can select a new theme and get its index back.
        onSchemeChanged: (int index) {
          setState(() {
            themeIndex = index;
          });
        },
        // We pass in the current surface and background style.
        themeSurface: flexSurface,
        // And select a new surface and background style.
        onThemeSurfaceChanged: (FlexSurface surface) {
          setState(() {
            flexSurface = surface;
          });
        },
        // We pass in the active app bar style.
        appBarStyle: flexAppBarStyle,
        // And select a new app bar style.
        onAppBarStyleChanged: (FlexAppBarStyle style) {
          setState(() {
            flexAppBarStyle = style;
          });
        },
        // We pass in the current app bar elevation level
        appBarElevation: appBarElevation,
        // And use the new white elevation value.
        onAppBarElevationChanged: (double value) {
          setState(() {
            appBarElevation = value;
          });
        },
        // We pass in the active tab bar style.
        tabBarStyle: flexTabBarStyle,
        // And select a new tab bar style.
        onTabBarStyleChanged: (FlexTabBarStyle style) {
          setState(() {
            flexTabBarStyle = style;
          });
        },
        // We pass in the current tooltip style.
        tooltipsMatchBackground: tooltipsMatchBackground,
        // And toggle the tooltip style.
        onTooltipsMatchBackgroundChanged: (bool value) {
          setState(() {
            tooltipsMatchBackground = value;
          });
        },
        // We pass in the current true black value.
        darkIsTrueBlack: darkIsTrueBlack,
        // And toggle the dark mode's true black value.
        onDarkIsTrueBlackChanged: (bool value) {
          setState(() {
            darkIsTrueBlack = value;
          });
        },
        // We pass in the current dark scheme creation method
        useToDark: useToDarkMethod,
        // And toggle the dark scheme creation method.
        onUseToDarkChanged: (bool value) {
          setState(() {
            useToDarkMethod = value;
          });
        },
        // We pass in the current dark scheme level
        whiteBlend: level,
        // And use the new white blend level value.
        onWhiteBlendChanged: (int value) {
          setState(() {
            level = value;
          });
        },
        // We pass in the current theme creation method
        useToTheme: useToThemeMethod,
        // And toggle the theme creation method.
        onUseToThemeChanged: (bool value) {
          setState(() {
            useToThemeMethod = value;
          });
        },
        // Pass in the FlexSchemeData we used for the active theme. Not really
        // needed to use FlexColorScheme, but we will use it to show the
        // active theme's name, descriptions and colors in the demo.
        // We also use it for the theme mode switch that shows the theme's
        // color's in the different theme modes.
        // We use copyWith to modify the dark scheme to the colors we get from
        // toggling the switch for computed dark colors or the actual defined
        // dark colors.
        flexSchemeData: myFlexSchemes[themeIndex].copyWith(
            dark: useToDarkMethod
                ? myFlexSchemes[themeIndex].light.defaultError.toDark(level)
                : myFlexSchemes[themeIndex].dark),
        // We pass the android SDK level to out HomePage, yes getting
        // tedious passing stuff down, but I decided early to leave all
        // fancy state management out of this simple example.
        androidLevel: androidSDKLevel,
      ),
    );
  }
}
