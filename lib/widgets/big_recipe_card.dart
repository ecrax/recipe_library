import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recipe_library/config.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/widgets/stats_icon.dart';

class BigRecipeCard extends StatelessWidget {
  BigRecipeCard({this.data, this.iconColor, this.backgroundColor});

  final Map<String, dynamic> data;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data["name"],
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(
                    MdiIcons.heartCircle,
                    color: Color(0xFFF85755),
                    size: 42,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Divider(
              color: Color(0xFF2c2c2c),
              thickness: 2,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsIcon(
                  text: data["time"],
                  icon: Icons.timer,
                  color: currentTheme.isDark()
                      ? kPrimaryAccentColor
                      : kLightAccentColor,
                ),
                Expanded(
                  child: StatsIcon(
                    color: currentTheme.isDark()
                        ? kPrimaryAccentColor
                        : kLightAccentColor,
                    text: data["steps"].length != 1
                        ? "${data["steps"].length} Steps"
                        : "${data["steps"].length} Step",
                    icon: MdiIcons.chartTimelineVariant,
                  ),
                ),
                StatsIcon(
                  text: data["difficulty"],
                  icon: MdiIcons.chefHat,
                  color: currentTheme.isDark()
                      ? kPrimaryAccentColor
                      : kLightAccentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
