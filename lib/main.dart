import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipe_library/config.dart';
import 'package:recipe_library/constants.dart';
import 'package:recipe_library/screens/add_recipe_screen.dart';
import 'package:recipe_library/screens/all_recipes_screen.dart';
import 'package:recipe_library/screens/favorites_screen.dart';
import 'package:recipe_library/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Library',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode: currentTheme.currentTheme(),
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
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: _currentIndex == 0
            ? FloatingActionButton(
                tooltip: "Add Recipe",
                child: Icon(
                  Icons.add,
                  color: currentTheme.isDark() ? Colors.black : Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipeScreen(),
                    ),
                  );
                },
              )
            : null,
        //backgroundColor: kBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor:
              currentTheme.isDark() ? kPrimaryAccentColor : kLightAccentColor,
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
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Settings"),
            ),
          ],
        ),
        body: _children[_currentIndex],
      ),
    );
  }
}
