import 'package:flutter/material.dart';

class FormFactor {
  static double desktop = 900;
  static double tablet = 600;
  static double handset = 300;
}

enum ScreenType {
  Desktop,
  Tablet,
  Handset,
  Watch
}

ScreenType getFormFactor(BuildContext context) {
  // Use .shortestSide to detect device type regardless of orientation
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > FormFactor.desktop) return ScreenType.Desktop;
  if (deviceWidth > FormFactor.tablet) return ScreenType.Tablet;
  if (deviceWidth > FormFactor.handset) return ScreenType.Handset;
  return ScreenType.Watch;
}
