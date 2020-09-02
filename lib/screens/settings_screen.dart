import 'package:flutter/material.dart';
import 'package:recipe_library/config.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: IconButton(
          icon: Icon(Icons.brightness_medium),
          onPressed: () {
            currentTheme.switchTheme();
          },
        ),
      ),
    );
  }
}
