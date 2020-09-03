import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:recipe_library/config.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/utils/format.dart';
import 'package:recipe_library/widgets/big_recipe_card.dart';

class RecipeScreen extends StatefulWidget {
  RecipeScreen({this.data});

  final dynamic data;

  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  FirebaseFirestore fb = FirebaseFirestore.instance;

  String title;
  String imageURL;
  String time;
  List<dynamic> steps;
  Map<dynamic, dynamic> ingredients;
  List<dynamic> tools;
  String difficulty;
  String id;

  int _index = 0;

  bool _isSaving = false;

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

    title = widget.data.data()["name"];
    imageURL = widget.data.data()["image"];
    time = widget.data.data()["time"];
    steps = widget.data.data()["steps"];
    ingredients = widget.data.data()["ingredients"];
    tools = widget.data.data()["tools"];
    difficulty = widget.data.data()["difficulty"];
    id = widget.data.data()["id"].toString();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void handleClick(String value) async {
    switch (value) {
      case 'Edit':
        break;
      case 'Delete':
        showDialog(
          useSafeArea: true,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Delete"),
              content: Text("Do you really want to delete this recipe?"),
              actions: [
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      _isSaving = true;
                    });
                    await fb.runTransaction((transaction) async {
                      transaction.delete(widget.data.reference);
                    });
                    setState(() {
                      _isSaving = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Yes"),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                ),
              ],
            );
          },
        );

        Navigator.pop(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentTheme.isDark() ? kBackgroundColor : kOffWhite,
      appBar: AppBar(
        backgroundColor: currentTheme.isDark() ? null : kLightAccentColor,
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: _isSaving,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              child: Hero(
                tag: "RecipeImage$id",
                child: Container(
                  width: double.infinity,
                  child: Image.network(
                    imageURL,
                    fit: BoxFit.fitWidth,
                  ),
                ),
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
                        backgroundColor:
                            currentTheme.isDark() ? kBoxColor : Colors.white,
                        data: widget.data.data(),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: currentTheme.isDark()
                              ? kBackgroundColor //Color(0xFF2e2e2e)
                              : kOffWhite,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TabBar(
                              labelColor: currentTheme.isDark()
                                  ? kPrimaryAccentColor
                                  : kLightAccentColor,
                              unselectedLabelColor: Color(0xFFa9a9a9),
                              controller: _tabController,
                              tabs: _tabs,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: [
                                Container(
                                  child: Format.formatIngredients(ingredients),
                                ),
                                Container(
                                  child: Format.formatTools(tools),
                                ),
                                Container(
                                  child: Theme(
                                    data: currentTheme.isDark()
                                        ? kDarkTheme
                                        : kLightTheme,
                                    child: Stepper(
                                      steps: Format.formatSteps(steps),
                                      currentStep: _index,
                                      onStepTapped: (value) {
                                        setState(() {
                                          _index = value;
                                        });
                                      },
                                      onStepCancel: () {
                                        //print("You are clicking the cancel button.");
                                        if (_index == 0) {
                                          Navigator.pop(context);
                                        } else {
                                          setState(() {
                                            _index -= 1;
                                          });
                                        }
                                      },
                                      onStepContinue: () async {
                                        //print("You are clicking the continue button.");
                                        if (_index + 1 < steps.length) {
                                          setState(() {
                                            _index += 1;
                                          });
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      },
                                    ),
                                  ),
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
      ),
    );
  }
}
