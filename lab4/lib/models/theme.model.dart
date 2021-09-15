import 'package:flutter/material.dart';


import 'package:laba3/utils/storageManager.dart';

class ThemeModel extends ChangeNotifier {
  bool isDark = false;
  double fontSize = 14;
  static Color _mainColor = Colors.orangeAccent;

  ThemeData _themeData;
  ThemeData getTheme() => _themeData;

  Color getMainColor() => _mainColor;

  _getLightTheme() => ThemeData(
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFE5E5E5),
      primaryColor: _mainColor,
      accentColor: _mainColor,
      switchTheme: SwitchThemeData(trackColor: MaterialStateProperty.all<Color>(_mainColor)),
      sliderTheme: SliderThemeData(
        activeTrackColor: _mainColor.withOpacity(0.5),
        thumbColor: _mainColor,
      ),
      radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all<Color>(_mainColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_mainColor))),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: fontSize),
        headline2: TextStyle(fontSize: fontSize),
        headline3: TextStyle(fontSize: fontSize),
        headline4: TextStyle(fontSize: fontSize),
        headline5: TextStyle(fontSize: fontSize),
        headline6: TextStyle(fontSize: fontSize),
        subtitle1: TextStyle(fontSize: fontSize),
        subtitle2: TextStyle(fontSize: fontSize),
        bodyText1: TextStyle(fontSize: fontSize),
        bodyText2: TextStyle(fontSize: fontSize),
        caption: TextStyle(fontSize: fontSize),
        button: TextStyle(fontSize: fontSize),
        overline: TextStyle(fontSize: fontSize),
      ));

  _getDarkTheme() => ThemeData(
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF212121),
      primaryColor: _mainColor,
      accentColor: _mainColor,
      switchTheme: SwitchThemeData(
        trackColor: MaterialStateProperty.all<Color>(_mainColor.withOpacity(0.5)),
        thumbColor: MaterialStateProperty.all<Color>(_mainColor)
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: _mainColor.withOpacity(0.5),
        thumbColor: _mainColor,
      ),
      radioTheme: RadioThemeData(fillColor: MaterialStateProperty.all<Color>(_mainColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(_mainColor))),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: fontSize),
        headline2: TextStyle(fontSize: fontSize),
        headline3: TextStyle(fontSize: fontSize),
        headline4: TextStyle(fontSize: fontSize),
        headline5: TextStyle(fontSize: fontSize),
        headline6: TextStyle(fontSize: fontSize),
        subtitle1: TextStyle(fontSize: fontSize),
        subtitle2: TextStyle(fontSize: fontSize),
        bodyText1: TextStyle(fontSize: fontSize),
        bodyText2: TextStyle(fontSize: fontSize),
        caption: TextStyle(fontSize: fontSize),
        button: TextStyle(fontSize: fontSize),
        overline: TextStyle(fontSize: fontSize),
      ));

  ThemeModel() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        isDark = false;
        _themeData = _getLightTheme();
      } else {
        isDark = true;
        print('setting dark theme');
        _themeData = _getDarkTheme();
      }
      notifyListeners();
    });
  }

  void setMainColor(Color color) {
    _mainColor = color;
    isDark ? setDarkMode() : setLightMode();
  }

  void setFontSize(double size) {
    fontSize = size;
    isDark ? setDarkMode() : setLightMode();
  }

  void setDarkMode() async {
    isDark = true;
    _themeData = _getDarkTheme();
    StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    isDark = false;
    _themeData = _getLightTheme();
    StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
