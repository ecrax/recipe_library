import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_library/screens/recipe_screen.dart';
import 'package:recipe_library/widgets/recipe_card.dart';

class AllRecipesScreen extends StatefulWidget {
  @override
  _AllRecipesScreenState createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  FirebaseFirestore fb = FirebaseFirestore.instance;

  Future<QuerySnapshot> getImages() {
    return fb.collection("recipes").get();
  }

  void search(String searchTerm) {
    // TODO implement search functionality
    print(searchTerm);
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
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.search,
                      color: Color(0xFF979797),
                    ),
                  ),
                  onTap: () {
                    search(_searchValue);
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getImages(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(
                      title: snapshot.data.docs[index].data()["name"],
                      imageURL: snapshot.data.docs[index].data()["image"],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeScreen(
                              title: snapshot.data.docs[index].data()["name"],
                              imageURL:
                                  snapshot.data.docs[index].data()["image"],
                              time: snapshot.data.docs[index].data()["time"],
                              steps: snapshot.data.docs[index].data()["steps"],
                              difficulty: snapshot.data.docs[index]
                                  .data()["difficulty"],
                              ingredients: snapshot.data.docs[index]
                                  .data()["ingredients"],
                              tools: snapshot.data.docs[index].data()["tools"],
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
              return CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
