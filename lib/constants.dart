import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFF272727);
const kOffWhite = Color(0xFFf7f7f7);
const kPrimaryAccentColor = Color(0xFFBB86FC);
const kLightAccentColor = Color(0xFF00ce6a);
const kBoxColor = Color(0xFF383838);

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  accentColor: kPrimaryAccentColor,
  backgroundColor: kBackgroundColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
final kLightTheme = ThemeData(
  brightness: Brightness.light,
  accentColor: kLightAccentColor,
  backgroundColor: kOffWhite,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
