import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../all_shared_imports.dart';

// It is not necessary to review or understand the code in this file in order
// to understand how to use the FlexColorScheme package demonstrated in
// the examples.
//
// For this Android Sysnavbar demo, it is however helpful to look this example
// page as well.
//
// The original version of this sub page is used as a demo in FlexColorScheme
// package examples 4 and 5 to show a sub-page using the same FlexColorScheme
// based theme.
//
class Subpage extends StatefulWidget {
  const Subpage({Key? key, this.androidLevel = 0}) : super(key: key);
  final int androidLevel;

  // A static convenience function show this screen, as pushed on top.
  static Future<void> show(
    BuildContext context, {
    int androidLevel = 0,
  }) async {
    await Navigator.of(context).push<Widget>(
      MaterialPageRoute<Widget>(
        builder: (BuildContext context) => Subpage(androidLevel: androidLevel),
      ),
    );
  }

  @override
  _SubpageState createState() => _SubpageState();
}

class _SubpageState extends State<Subpage> {
  late int _buttonIndex;

  @override
  void initState() {
    super.initState();
    _buttonIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color appBarBackground = theme.appBarTheme.color?.withOpacity(0.96) ??
        (isDark
            ? colorScheme.surface.withOpacity(0.96)
            : colorScheme.primary.withOpacity(0.96));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // FlexColorScheme contains a helper that can be use to theme
      // the system navigation bar using an AnnotatedRegion. Without this
      // page wrapper the system navigation bar in Android will not change
      // theme color as we change themes for the page. This is a
      // Flutter "feature", but with this annotated region we can have the
      // navigation follow the background color and theme-mode,
      // which looks nicer and as it should on an Android device.
      //
      // This example is not using the system nav bar transparency value from
      // the HomePage, simply because I wanted to show some example values
      // that looks nice when a slightly transparent Flutter Material
      // `BottomNavigationBar` is used at the bottom and we have an
      // Android system nav bar that is fully transparent.
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        // We make it almost fully transparent, but but not totally as that
        // triggers the built in light/dark scrim to be applied.
        // by making it almost fully transparent the system navigation bar
        // will show the background of the bottom navigation bar used on this
        // demo page. To see things scrolling behind the Flutter Material
        // bottom navigation bar, we also need to make it transparent.
        // Like on the home page, if this is built on other than Android with
        // SDK > 29, we keep the system nav bar fully opaque with its
        // background color.
        opacity: widget.androidLevel > 29 ? 0.01 : 1.0,
      ),
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: appBarBackground,
            title: const Text('Subpage Demo'),
            actions: const <Widget>[AboutIconButton()],
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'Home'),
                Tab(text: 'Favorites'),
                Tab(text: 'Profile'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
          body: PageBody(
            child: ListView(
              padding: const EdgeInsets.all(AppConst.edgePadding),
              children: <Widget>[
                Text('Subpage demo', style: headline4),
                const Text(
                  'This page just shows another example page with the same '
                  'FlexColorScheme based theme applied when you open a '
                  'subpage. It also has a BottomNavigationBar and TabBar '
                  'in the AppBar.',
                ),
                const Divider(),
                // Show all key active theme colors.
                Text('Theme colors', style: headline4),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppConst.edgePadding),
                  child: ShowThemeColors(),
                ),
                const Divider(),
                Text('Theme Showcase', style: headline4),
                const ThemeShowcase(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            // The bottom navbar is colorScheme background colored by
            // default. We give it some transparency so we can see text
            // scrolling behind it. Its background extends behind the
            // system navigation bar, but since the system navigation bar
            // is fully transparent in this setup, we will se it just as its
            // controls on top the bottom navigation bar that has a
            // bit of transparency. The end result, it looks like system nav
            // buttons are integrated into to the translucent app bottom nav
            // bar, which look quite OK.
            // We can make a frosted glass blurred version too like on iOS,
            // for both the bottom navbar and thus also the system nav bar, but
            // that is beyond this simple example. It will be used and shown in
            // the Flexfold demo later.
            backgroundColor:
                Theme.of(context).colorScheme.background.withOpacity(0.9),
            onTap: (int value) {
              setState(() {
                _buttonIndex = value;
              });
            },
            currentIndex: _buttonIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble),
                label: 'Chat',
                // API still only on Master channel
                // tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.beenhere),
                label: 'Tasks',
                // API still only on Master channel
                // tooltip: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.create_new_folder),
                label: 'Archive',
                // API still only on Master channel
                // tooltip: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
