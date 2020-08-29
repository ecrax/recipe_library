import 'package:flutter/material.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/widgets/big_recipe_card.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({this.data});

  final Map<String, dynamic> data;

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  String title;
  String imageURL;
  String time;
  List<dynamic> steps;
  Map<dynamic, dynamic> ingredients;
  List<dynamic> tools;
  String difficulty;

  TabController _tabController;

  final List<Widget> _tabs = [
    Tab(
      text: "INGREDIENTS",
    ),
    Tab(
      text: "TOOLS",
    ),
    Tab(
      text: "PROCESS",
    ),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);

    title = widget.data["name"];
    imageURL = widget.data["image"];
    time = widget.data["time"];
    steps = widget.data["steps"];
    ingredients = widget.data["ingredients"];
    tools = widget.data["tools"];
    difficulty = widget.data["difficulty"];
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  Widget formatIngredients(Map input) {
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

  Widget formatSteps(List steps) {
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

  Widget formatTools(List tools) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
            child: Hero(
              tag: "RecipeImage",
              child: Image.network(imageURL),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.65,
            minChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                child: ListView(
                  controller: scrollController,
                  children: [
                    BigRecipeCard(
                      data: widget.data,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF2e2e2e),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: kPrimaryAccentColor,
                            unselectedLabelColor: Color(0xFFa9a9a9),
                            controller: _tabController,
                            tabs: _tabs,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: [
                              Container(
                                child: formatIngredients(ingredients),
                              ),
                              Container(
                                child: formatTools(tools),
                              ),
                              Container(
                                child: formatSteps(steps),
                              ),
                            ][_tabController.index],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
