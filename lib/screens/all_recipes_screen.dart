import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_library/config.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/screens/recipe_screen.dart';
import 'package:recipe_library/screens/search_screen.dart';
import 'package:recipe_library/widgets/recipe_card.dart';

class AllRecipesScreen extends StatefulWidget {
  @override
  _AllRecipesScreenState createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future futureRecipes;

  Future getRecipes() async {
    setState(() {
      futureRecipes = fb.collection("recipes").get();
    });
  }

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  void search(String searchTerm) {
    // TODO implement search functionality
    print(searchTerm);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          query: searchTerm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String _searchValue;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF979797),
                ),
                borderRadius: BorderRadius.circular(5)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search recipes",
                        ),
                        onChanged: (value) {
                          _searchValue = value;
                        },
                        onSubmitted: (value) {
                          search(value);
                        }),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Color(0xFF979797),
                  ),
                  onPressed: () {
                    search(_searchValue);
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
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
        ),
      ],
    );
  }
}
