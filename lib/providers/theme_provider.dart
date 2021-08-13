// we use provider to manage the app state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  bool? isLightTheme;

  ThemeProvider({this.isLightTheme});

  // the code below is to manage the status bar color when the theme changes
  getCurrentStatusNavigationBarColor() {
    if (isLightTheme != null && isLightTheme!) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFFFFFFF),
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0XFF0c0c0c),
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    }
  }

  // use to toggle the theme
  toggleThemeData() async {
    final settings = await Hive.openBox('settings');
    settings.put('isLightTheme', !isLightTheme!);
    isLightTheme = !isLightTheme!;
    getCurrentStatusNavigationBarColor();
    notifyListeners();
  }

  // Global theme data we are always check if the light theme is enabled #isLightTheme
  ThemeData themeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(  
        color: Colors.pink,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: isLightTheme! ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor:
          isLightTheme! ? Colors.grey[50] : Color(0XFF0c0c0c),
      primaryColor: Colors.pink,
      indicatorColor: Colors.pink,
      backgroundColor: Colors.pink[200],
      textTheme: TextTheme(
        bodyText1: GoogleFonts.merriweather(
          letterSpacing: 1,
        ),
        bodyText2: GoogleFonts.gelasio(),
        button: GoogleFonts.lora(
          fontWeight: FontWeight.bold,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.amber,
        ),
      ),
    );
  }
}

// A class to manage specify colors and styles in the app not supported by theme data
class ThemeColor {
  List<Color>? gradient;
  Color? backgroundColor;
  Color? toggleButtonColor;
  Color? toggleBackgroundColor;
  Color? textColor;
  List<BoxShadow>? shadow;

  ThemeColor({
    this.gradient,
    this.backgroundColor,
    this.toggleBackgroundColor,
    this.toggleButtonColor,
    this.textColor,
    this.shadow,
  });
}
