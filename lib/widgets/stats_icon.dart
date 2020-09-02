import 'package:flutter/material.dart';

class StatsIcon extends StatelessWidget {
  StatsIcon({this.text, this.icon, this.iconSize = 30, this.color});

  final String text;
  final IconData icon;
  final double iconSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: iconSize,
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
