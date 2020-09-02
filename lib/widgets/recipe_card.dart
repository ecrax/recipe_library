import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:recipe_library/widgets/stats_icon.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({this.onTap, this.data, this.backgroundColor, this.iconColor});

  final Function onTap;
  final Map<String, dynamic> data;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    var imageURL = data["image"];
    var title = data["name"];
    var steps = data["steps"];
    var time = data["time"];
    var difficulty = data["difficulty"];
    var id = data["id"].toString();

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              height: 128,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    tag: "RecipeImage$id",
                    child: Stack(
                      children: [
                        Container(
                          color: backgroundColor,
                          height: 139,
                          width: 91,
                        ),
                        Image.network(
                          imageURL,
                          fit: BoxFit.cover,
                          height: 139,
                          width: 91,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 16),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            StatsIcon(
                              text: time,
                              icon: Icons.timer,
                              iconSize: 25,
                              color: iconColor,
                            ),
                            Expanded(
                              child: StatsIcon(
                                text: steps.length != 1
                                    ? "${steps.length} Steps"
                                    : "${steps.length} Step",
                                icon: MdiIcons.chartTimelineVariant,
                                iconSize: 25,
                                color: iconColor,
                              ),
                            ),
                            StatsIcon(
                              text: difficulty,
                              icon: MdiIcons.chefHat,
                              iconSize: 25,
                              color: iconColor,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
