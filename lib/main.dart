import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/screens/add_recipe_screen.dart';
import 'package:recipe_library/screens/all_recipes_screen.dart';
import 'package:recipe_library/screens/favorites_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Library',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: kPrimaryAccentColor,
        backgroundColor: kBackgroundColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InitialScreen(),
    );
  }
}

class InitialScreen extends StatefulWidget {
  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    AllRecipesScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Recipe",
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipeScreen(),
              ),
            );
          },
        ),
        backgroundColor: kBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text("Favorites"),
            ),
          ],
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}
