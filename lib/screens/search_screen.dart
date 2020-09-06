import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_library/config.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/screens/recipe_screen.dart';
import 'package:recipe_library/widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({this.query});

  final String query;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future futureRecipes;

  Future getRecipes() async {
    setState(() {
      futureRecipes =
          fb.collection("recipes").where("name", isEqualTo: widget.query).get();
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
    print("hurray");
  }

  @override
  void dispose() {
    fb.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentTheme.isDark() ? null : kLightAccentColor,
        title: Text("${widget.query}"),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getRecipes();
        },
        child: FutureBuilder(
          future: futureRecipes,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    backgroundColor:
                        currentTheme.isDark() ? kBoxColor : Colors.white,
                    iconColor: currentTheme.isDark()
                        ? kPrimaryAccentColor
                        : kLightAccentColor,
                    data: snapshot.data.docs[index].data(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeScreen(
                            data: snapshot.data.docs[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("No data");
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
