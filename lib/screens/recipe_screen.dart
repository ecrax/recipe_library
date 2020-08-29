import 'package:flutter/material.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/widgets/big_recipe_card.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen(
      {this.title,
      this.imageURL,
      this.time,
      this.steps,
      this.difficulty,
      this.ingredients,
      this.tools});

  final String title;
  final String imageURL;
  final String time;
  final List<dynamic> steps;
  final Map<dynamic, dynamic> ingredients;
  final List<dynamic> tools;
  final String difficulty;

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
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
      var textWidget = Text("${values[i]} ${ingredientNames[i]}");
      finalColumn.add(textWidget);
    }

    return Column(
      children: finalColumn,
    );
  }

  Widget formatSteps(List steps) {
    List<Widget> finalColumn = [];

    for (var i = 0; i < steps.length; i++) {
      var textWidget = Text("${i + 1}. ${steps[i]} \n");
      finalColumn.add(textWidget);
    }

    return Column(
      children: finalColumn,
    );
  }

  Widget formatTools(List tools) {
    List<Widget> finalColumn = [];

    for (var i = 0; i < tools.length; i++) {
      var textWidget = Text("${tools[i]}");
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
        title: Text(widget.title),
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
              child: Image.network(widget.imageURL),
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
                      widget: widget,
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
                          Center(
                            child: [
                              Container(
                                child: formatIngredients(widget.ingredients),
                              ),
                              Container(
                                child: formatTools(widget.tools),
                              ),
                              Container(
                                child: formatSteps(widget.steps),
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
