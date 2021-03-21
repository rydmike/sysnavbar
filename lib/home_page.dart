import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'all_shared_imports.dart';
import 'color_schemes.dart';

// The content of the HomePage below is not relevant for using FlexColorScheme
// based application theming. The critical parts are in the MaterialApp
// theme definitions. The HomePage just contains UI to visually show what the
// defined example looks like in an application and with commonly used Widgets.
class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.schemeIndex,
    required this.onSchemeChanged,
    required this.themeSurface,
    required this.onThemeSurfaceChanged,
    required this.appBarStyle,
    required this.onAppBarStyleChanged,
    required this.appBarElevation,
    required this.onAppBarElevationChanged,
    required this.tabBarStyle,
    required this.onTabBarStyleChanged,
    required this.tooltipsMatchBackground,
    required this.onTooltipsMatchBackgroundChanged,
    required this.darkIsTrueBlack,
    required this.onDarkIsTrueBlackChanged,
    required this.useToDark,
    required this.onUseToDarkChanged,
    required this.whiteBlend,
    required this.onWhiteBlendChanged,
    required this.useToTheme,
    required this.onUseToThemeChanged,
    required this.flexSchemeData,
    required this.androidLevel,
  }) : super(key: key);
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final int schemeIndex;
  final ValueChanged<int> onSchemeChanged;
  final FlexSurface themeSurface;
  final ValueChanged<FlexSurface> onThemeSurfaceChanged;
  final FlexAppBarStyle appBarStyle;
  final ValueChanged<FlexAppBarStyle> onAppBarStyleChanged;
  final FlexTabBarStyle tabBarStyle;
  final double appBarElevation;
  final ValueChanged<double> onAppBarElevationChanged;
  final ValueChanged<FlexTabBarStyle> onTabBarStyleChanged;
  final bool tooltipsMatchBackground;
  final ValueChanged<bool> onTooltipsMatchBackgroundChanged;
  final bool darkIsTrueBlack;
  final ValueChanged<bool> onDarkIsTrueBlackChanged;
  final bool useToDark;
  final ValueChanged<bool> onUseToDarkChanged;
  final int whiteBlend;
  final ValueChanged<int> onWhiteBlendChanged;
  final bool useToTheme;
  final ValueChanged<bool> onUseToThemeChanged;
  final FlexSchemeData flexSchemeData;
  final int androidLevel;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // The reason for example 5 using a stateful widget is that it holds the
  // state of the dummy side menu/rail locally. All state concerning the
  // application theme are in this example also held by the stateful MaterialApp
  // widget, and values are passed in and changed via ValueChanged callbacks.
  late double currentSidePanelWidth;
  late bool isSidePanelExpanded;
  late bool showSidePanel;
  late double opacity;
  late bool useSysNavDivider;

  @override
  void initState() {
    super.initState();
    currentSidePanelWidth = AppConst.expandWidth;
    isSidePanelExpanded = true;
    showSidePanel = true;
    // Start with fully transparent, note, if we make it "0" the default scrim
    // will become visible, this can also be used if desired. You can try it
    // with the slider in this example.
    opacity = 0.01;
    // Used to control if we have a top divider on the system navigation bar.
    useSysNavDivider = false;
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final double topPadding = media.padding.top;
    final double bottomPadding = media.padding.bottom;
    final bool menuAvailable = media.size.width > 650;
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final TextStyle headline4 = textTheme.headline4!;
    final Color appBarColor = theme.appBarTheme.color ?? theme.primaryColor;
    final bool isLight = Theme.of(context).brightness == Brightness.light;

    // Give the width of the side panel some automatic adaptive behavior and
    // make it rail sized when there is not enough room for a menu, even if
    // menu size is requested.
    if (!menuAvailable && showSidePanel) {
      currentSidePanelWidth = AppConst.shrinkWidth;
    }
    if (menuAvailable && showSidePanel && !isSidePanelExpanded) {
      currentSidePanelWidth = AppConst.shrinkWidth;
    }
    if (menuAvailable && showSidePanel && isSidePanelExpanded) {
      currentSidePanelWidth = AppConst.expandWidth;
    }

    // FlexSurface enum to widget map, used in a CupertinoSegment control.
    const Map<FlexSurface, Widget> themeSurface = <FlexSurface, Widget>{
      FlexSurface.material: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Default\ndesign',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexSurface.light: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Light\nprimary',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexSurface.medium: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Medium\nprimary',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexSurface.strong: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Strong\nprimary',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexSurface.heavy: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Heavy\nprimary',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
    };

    // FlexAppBarStyle enum to widget map, used in a CupertinoSegment control.
    const Map<FlexAppBarStyle, Widget> themeAppBar = <FlexAppBarStyle, Widget>{
      FlexAppBarStyle.primary: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Primary\ncolor',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexAppBarStyle.material: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          // Wait, what is \u{00AD} below?? It is Unicode char-code for an
          // invisible soft hyphen. It can be used to guide text layout where
          // it can break a word to the next line, if it has to. On small phones
          // or a desktop builds where you can make the UI really narrow in
          // Flutter, you can observe this with the 'background' word below.
          'Default\nback\u{00AD}ground',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexAppBarStyle.surface: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Branded\nsurface',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexAppBarStyle.background: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Branded\nback\u{00AD}ground',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexAppBarStyle.custom: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'Custom\ncolor',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
    };

    // FlexTabBarStyle enum to widget map, used in a CupertinoSegment control.
    const Map<FlexTabBarStyle, Widget> themeTabBar = <FlexTabBarStyle, Widget>{
      FlexTabBarStyle.forAppBar: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'TabBar used\nin AppBar',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
      FlexTabBarStyle.forBackground: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          'TabBar used\non background',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11),
        ),
      ),
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // FlexColorScheme contains a helper that can be use to theme
      // the system navigation bar using an AnnotatedRegion. Without this
      // page wrapper the system navigation bar in Android will not change
      // theme color as we change themes for the page. This is a
      // Flutter "feature", but with this annotated region we can have the
      // navigation bar at follow the background color and theme-mode,
      // which looks nicer and as it should on an Android device.
      // With some additional tweaks we can also make it transparent.
      // For more info see: https:///github.com/flutter/flutter/issues/69999.
      value: FlexColorScheme.themedSystemNavigationBar(
        context,
        // In this example we only do the system navbar opacity if we are on
        // Android and the level was > 29. The opacity does not work
        // on lower levels and if we apply it, it will only make our color
        // on the system navbar transparent until it gets the color of the
        // system navbar scrim, which does not look pretty, to avoid that
        // we keep the color fully opaque for other SDK levels.
        opacity: widget.androidLevel > 29 ? opacity : 1,
        // We can toggle the divider ON/OFF it also gets transparency
        useDivider: useSysNavDivider,
      ),
      child: Row(
        children: <Widget>[
          // Contains the demo menu and side rail.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppConst.expandWidth),
            child: Material(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: currentSidePanelWidth,
                child: SideMenu(
                  isVisible: showSidePanel,
                  menuWidth: AppConst.expandWidth,
                ),
              ),
            ),
          ),
          // The actual page content is a normal Scaffold.
          Expanded(
            child: Scaffold(
              // For scrolling behind the app bar
              extendBodyBehindAppBar: true,
              // For scrolling behind the bottom nav bar, if there would be one.
              extendBody: true,
              //
              resizeToAvoidBottomInset: true,
              // resizeToAvoidBottomPadding: true,
              appBar: AppBar(
                title: const Text('FlexColorScheme SysNavBar'),
                actions: const <Widget>[AboutIconButton()],
                backgroundColor: Colors.transparent,
                // Gradient partially transparent AppBar, just because it looks
                // nice and we can see content scroll behind it.
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                    gradient: LinearGradient(
                      begin: AlignmentDirectional.centerStart,
                      end: AlignmentDirectional.centerEnd,
                      colors: <Color>[
                        appBarColor,
                        appBarColor.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),
              body: PageBody(
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    AppConst.edgePadding,
                    topPadding + kToolbarHeight + AppConst.edgePadding,
                    AppConst.edgePadding,
                    AppConst.edgePadding + bottomPadding,
                  ),
                  children: <Widget>[
                    Text('Theme', style: headline4),
                    const Text(
                      'This example builds on Example nr 5 in FlexColorScheme '
                      'package samples. It shows how you can make and use '
                      'transparent system '
                      'navigation bar in Android.\n\n'
                      ''
                      'You will also need to modify '
                      'styles.xml and MainActivity.kt and in Android build and '
                      'set SDK target version to 30, as this is only supported '
                      'on 30 '
                      'or higher. On lower version the background color will '
                      'still be color themed with the primary colored branded '
                      'background color, which looks nice too. \n',
                    ),
                    Text('${widget.flexSchemeData.name} theme',
                        style: textTheme.headline5),
                    // A 3-way theme mode toggle switch.
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppConst.edgePadding),
                      child: FlexThemeModeSwitch(
                        themeMode: widget.themeMode,
                        onThemeModeChanged: widget.onThemeModeChanged,
                        flexSchemeData: widget.flexSchemeData,
                        // Style the selected theme mode's label
                        selectedLabelStyle: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    const Divider(),

                    // Popup menu button to select color scheme.
                    PopupMenuButton<int>(
                      padding: const EdgeInsets.all(0),
                      onSelected: widget.onSchemeChanged,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuItem<int>>[
                        for (int i = 0; i < myFlexSchemes.length; i++)
                          PopupMenuItem<int>(
                            value: i,
                            child: ListTile(
                              leading: Icon(Icons.lens,
                                  color: isLight
                                      ? myFlexSchemes[i].light.primary
                                      : myFlexSchemes[i].dark.primary,
                                  size: 35),
                              title: Text(myFlexSchemes[i].name),
                            ),
                          )
                      ],
                      child: ListTile(
                        title: Text('${widget.flexSchemeData.name} theme'),
                        subtitle: Text(widget.flexSchemeData.description),
                        trailing: Icon(
                          Icons.lens,
                          color: colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Active theme color indicators.
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppConst.edgePadding),
                      child: ShowThemeColors(),
                    ),
                    const SizedBox(height: 8),
                    // System navbar opacity
                    ListTile(
                      title: const Text('System navbar opacity'),
                      subtitle: Slider.adaptive(
                        divisions: 100,
                        label: opacity.toStringAsFixed(2),
                        value: opacity,
                        onChanged: (double value) {
                          setState(() {
                            opacity = value;
                          });
                        },
                      ),
                      trailing: Text(
                        opacity.toStringAsFixed(2),
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      subtitle: Text(
                        'Found Android SDK ${widget.androidLevel}.\n'
                        'On SDK<30 the above would only make the '
                        'color on the system nav bar transparent, which does '
                        'not look nice. This example include extra code to '
                        'handle it by using the package "device_info" to read '
                        'the current Android SDK level and make sure the '
                        'background color is kept for such devices. ',
                      ),
                    ),
                    SwitchListTile.adaptive(
                      title: const Text(
                        'System navbar has divider',
                      ),
                      value: useSysNavDivider,
                      onChanged: (bool value) {
                        setState(() {
                          useSysNavDivider = value;
                        });
                      },
                    ),
                    const Divider(),
                    // Open a sub-page
                    ListTile(
                      title: const Text('Open a demo subpage'),
                      subtitle: const Text(
                        'The subpage will use the same '
                        'color scheme based theme automatically.',
                      ),
                      trailing: const Icon(Icons.chevron_right, size: 34),
                      onTap: () {
                        Subpage.show(context,
                            androidLevel: widget.androidLevel);
                      },
                    ),
                    const Divider(),
                    const ListTile(
                      title: Text('Tab bar theme'),
                      subtitle: Text(
                        'Choose the style that fit best with where '
                        'you primarily intend to use the TabBar.',
                      ),
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Compute dark theme'),
                      subtitle: const Text(
                        'From the light scheme, instead '
                        'of using a dark scheme.',
                      ),
                      value: widget.useToDark,
                      onChanged: widget.onUseToDarkChanged,
                    ),
                    // White blend slider in a ListTile.
                    ListTile(
                      title: Slider.adaptive(
                        max: 100,
                        divisions: 100,
                        label: widget.whiteBlend.toString(),
                        value: widget.whiteBlend.toDouble(),
                        onChanged: (double value) {
                          widget.onWhiteBlendChanged(value.floor().toInt());
                        },
                      ),
                      trailing: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'LEVEL',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Text(
                              '${widget.whiteBlend} %',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Set dark mode to use true black!
                    SwitchListTile.adaptive(
                      title: const Text('Dark mode uses true black'),
                      subtitle: const Text(
                        'Keep OFF for normal dark mode.',
                      ),
                      value: widget.darkIsTrueBlack,
                      onChanged: widget.onDarkIsTrueBlackChanged,
                    ),
                    // Set to make dark scheme lazily for light theme

                    // Surface style selector.
                    const SizedBox(height: 8),
                    const ListTile(
                      title: Text('Branded surface and background'),
                      subtitle: Text(
                        'Default Material design uses white and dark surface '
                        'colors. With the light, medium, heavy '
                        'and strong branding, you can blend primary '
                        'color into surface and background colors with '
                        'increasing strength.',
                      ),
                    ),
                    const SizedBox(height: 4),
                    CupertinoSegmentedControl<FlexSurface>(
                      children: themeSurface,
                      groupValue: widget.themeSurface,
                      onValueChanged: widget.onThemeSurfaceChanged,
                      borderColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      selectedColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      unselectedColor: theme.cardColor,
                    ),
                    const SizedBox(height: 8),
                    const ListTile(
                      title: Text('App bar theme'),
                      subtitle: Text(
                        'Flutter ColorScheme themes have a primary '
                        'colored app bar in light mode, and a background '
                        'colored one in dark mode. With FlexColorScheme '
                        'you can choose if it should be primary, background, '
                        'surface or a custom color. The predefined schemes '
                        'use their secondary variant color as the custom '
                        'color for the app bar theme, but it can be any color.',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // AppBar style
                    CupertinoSegmentedControl<FlexAppBarStyle>(
                      children: themeAppBar,
                      groupValue: widget.appBarStyle,
                      onValueChanged: widget.onAppBarStyleChanged,
                      borderColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      selectedColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      unselectedColor: theme.cardColor,
                    ),
                    const SizedBox(height: 8),
                    // AppBar elevation value in a ListTile.
                    ListTile(
                      title: const Text('App bar themed elevation'),
                      subtitle: Slider.adaptive(
                        max: 30,
                        divisions: 30,
                        label: widget.appBarElevation.floor().toString(),
                        value: widget.appBarElevation.roundToDouble(),
                        onChanged: widget.onAppBarElevationChanged,
                      ),
                      trailing: Text(
                        '${widget.appBarElevation.floor()}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const ListTile(
                      title: Text('Tab bar theme'),
                      subtitle: Text(
                        'Choose the style that fit best with where '
                        'you primarily intend to use the TabBar.',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // AppBar style
                    CupertinoSegmentedControl<FlexTabBarStyle>(
                      children: themeTabBar,
                      groupValue: widget.tabBarStyle,
                      onValueChanged: widget.onTabBarStyleChanged,
                      borderColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      selectedColor: isLight
                          ? colorScheme.primary
                          : theme.primaryColorLight,
                      unselectedColor: theme.cardColor,
                    ),
                    const SizedBox(height: 8),
                    // Tooltip theme style.
                    Tooltip(
                      message: 'A tooltip, on the tooltip style toggle',
                      child: SwitchListTile.adaptive(
                        title: const Text(
                          'Tooltips are light on light, and dark on dark',
                        ),
                        subtitle: const Text(
                          "Keep OFF to use Material's default inverted "
                          'background style.',
                        ),
                        value: widget.tooltipsMatchBackground,
                        onChanged: widget.onTooltipsMatchBackgroundChanged,
                      ),
                    ),
                    const Divider(),
                    // Theme creation method.
                    SwitchListTile.adaptive(
                      title: const Text(
                        'Theme with FlexColorScheme.toTheme',
                      ),
                      subtitle: const Text(
                        'Turn OFF to make the theme with the '
                        'ThemeData.from factory.\n'
                        'NOT recommended, but try it in this demo '
                        'to see the differences.',
                      ),
                      value: widget.useToTheme,
                      onChanged: widget.onUseToThemeChanged,
                    ),
                    const Divider(),
                    Text('Menu', style: headline4),
                    const Text(
                      'The menu is a just a demo to make a larger '
                      'area that uses the primary branded background color.',
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Turn ON to show the menu'),
                      subtitle: const Text('Turn OFF to hide the menu.'),
                      value: showSidePanel,
                      onChanged: (bool value) {
                        setState(() {
                          showSidePanel = value;
                          if (showSidePanel) {
                            if (isSidePanelExpanded) {
                              currentSidePanelWidth = AppConst.expandWidth;
                            } else {
                              currentSidePanelWidth = AppConst.shrinkWidth;
                            }
                          } else {
                            currentSidePanelWidth = 0.01;
                          }
                        });
                      },
                    ),
                    SwitchListTile.adaptive(
                      title: const Text('Turn ON for full sized menu'),
                      subtitle: const Text(
                        'Turn OFF for a rail sized menu. '
                        'The full size menu will only be shown when '
                        'screen width is above 650 dp and this toggle is ON.',
                      ),
                      value: isSidePanelExpanded,
                      onChanged: (bool value) {
                        setState(() {
                          isSidePanelExpanded = value;
                          if (showSidePanel) {
                            if (isSidePanelExpanded) {
                              currentSidePanelWidth = AppConst.expandWidth;
                            } else {
                              currentSidePanelWidth = AppConst.shrinkWidth;
                            }
                          } else {
                            currentSidePanelWidth = 0.01;
                          }
                        });
                      },
                    ),
                    const Divider(),
                    Text('Theme Showcase', style: headline4),
                    const ThemeShowcase(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
