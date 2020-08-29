import 'package:flutter/material.dart';

class Format {
  static Widget formatIngredients(Map input) {
    var values = input.values.toList();
    var ingredientNames = input.keys.toList();

    List<Widget> finalColumn = [];

    for (var i = 0; i < ingredientNames.length; i++) {
      var textWidget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${values[i]}",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFa9a9a9),
            ),
            textAlign: TextAlign.start,
          ),
          Text(
            "${ingredientNames[i]}",
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFa9a9a9),
            ),
            textAlign: TextAlign.start,
          ),
        ],
      );
      if (i != 0) {
        finalColumn.add(
          Divider(
            thickness: 1,
            //color: Colors.white,
          ),
        );
      }
      finalColumn.add(textWidget);
    }

    return Column(
      children: finalColumn,
    );
  }

  static Widget formatSteps(List steps) {
    List<Widget> finalColumn = [];

    for (var i = 0; i < steps.length; i++) {
      var textWidget = Text(
        "${i + 1}. ${steps[i]} \n",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFFa9a9a9),
          height: 1.2,
        ),
        textAlign: TextAlign.start,
      );

      if (i != 0) {
        finalColumn.add(
          Divider(
            thickness: 1,
            //color: Colors.white,
          ),
        );
      }
      finalColumn.add(textWidget);
    }

    return Column(
      children: finalColumn,
    );
  }

  static Widget formatTools(List tools) {
    List<Widget> finalColumn = [];

    for (var i = 0; i < tools.length; i++) {
      var textWidget = Text(
        "${tools[i]}",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFFa9a9a9),
        ),
        textAlign: TextAlign.start,
      );

      if (i != 0) {
        finalColumn.add(
          Divider(
            thickness: 1,
            //color: Colors.white,
          ),
        );
      }
      finalColumn.add(textWidget);
    }

    return Column(
      children: finalColumn,
    );
  }
}
