import 'package:flutter/material.dart';
import 'package:recipe_library/constants.dart';

class RecipeCard extends StatelessWidget {
  RecipeCard({this.title, this.imageURL, this.onTap});

  final String imageURL;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
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
                color: kBoxColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Hero(
                tag: "RecipeImage",
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                  height: 139,
                  width: 91,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 107, bottom: 96),
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
