import 'package:flutter/material.dart';
import 'package:recipe_library/constants.dart';

class StatsIcon extends StatelessWidget {
  StatsIcon({this.text, this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: kPrimaryAccentColor,
          size: 30,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFFACACAC),
          ),
        )
      ],
    );
  }
}
