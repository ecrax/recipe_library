import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;
  ImagePicker _picker = ImagePicker();

  int _index = 0;
  int _stepAmount = 7;

  File _image;

  String uploadedImageURL;
  String name;
  String difficulty = "Beginner";
  Duration duration = Duration(minutes: 0);
  String toolsInput;
  String ingredientsInput;
  String stepsInput;

  bool _isSaving = false;

  List<String> stringToList(String string) {
    var list = string.split("+");

    return list;
  }

  Map<dynamic, dynamic> stringToMap(String string) {
    var bigList = string.split("+");
    var smallList = [];

    for (var item in bigList) {
      smallList.add(item.split(","));
    }

    var finalMap = {};

    for (var item in smallList) {
      finalMap[item[0]] = item[1];
    }

    return finalMap;
  }

  bool isEmpty(String s) {
    if (s == null || s.trim() == "") {
      return true;
    } else {
      return false;
    }
  }

  Future getImageGallery() async {
    var image = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  Future getImageCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(image.path);
    });
  }

  Future uploadFile(int id) async {
    StorageReference reference =
        _storage.ref().child("recipe_images/").child("${id.toString()}.jpg");
    StorageUploadTask uploadTask = reference.putFile(_image);

    StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    uploadedImageURL = (await downloadUrl.ref.getDownloadURL());

    //print(uploadedImageURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Recipe"),
      ),
      body: LoadingOverlay(
        isLoading: _isSaving,
        child: Container(
          child: Stepper(
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
              if (_index + 1 < _stepAmount) {
                setState(() {
                  _index += 1;
                });
              } else {
                // Finished with form | submit everything to firebase

                if (isEmpty(name) ||
                    isEmpty(ingredientsInput) ||
                    isEmpty(toolsInput) ||
                    isEmpty(stepsInput)) {
                  // Form not filled out correctly
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Some fields are still empty."),
                        content:
                            Text("Please make sure to fill out every step."),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    _isSaving = true;
                  });

                  QuerySnapshot snapshot =
                      await _database.collection("recipes").orderBy("id").get();

                  int highestID = snapshot.docs.last.data()["id"];

                  uploadFile(highestID + 1);

                  if (!isEmpty(uploadedImageURL)) {
                    await _database
                        .collection("recipes")
                        .doc((highestID + 1).toString())
                        .set({
                      'name': name,
                      'id': highestID + 1,
                      'image': uploadedImageURL,
                      'difficulty': difficulty,
                      'time': duration.inMinutes >= 60
                          ? duration.inHours.toString() + " h"
                          : duration.inMinutes.toString() + " min",
                      'ingredients': stringToMap(ingredientsInput),
                      'tools': stringToList(toolsInput),
                      'steps': stringToList(stepsInput),
                    });

                    // Display spinner
                    Navigator.pop(context);
                    setState(() {
                      _isSaving = false;
                    });
                  } else {
                    // Image did not upload correctly
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "Something went wrong when uploading the image."),
                          content: Text(
                              "Mabe try another image or try again later."),
                          actions: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    setState(() {
                      _isSaving = false;
                    });
                  }
                }
              }
            },
            steps: [
              Step(
                title: Text("Enter a name"),
                subtitle: Text(
                    "This name will be displayed when looking at the recipe."),
                content: TextField(
                  decoration: InputDecoration(hintText: "Name"),
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              Step(
                title: Text("Pick an image"),
                subtitle: Text("The cover image of your recipe."),
                content: Column(
                  children: [
                    _image != null
                        ? Image.asset(
                            _image.path,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                        : Container(height: 150),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FlatButton(
                          child: Text('Choose Picture'),
                          onPressed: getImageGallery,
                        ),
                        FlatButton(
                          child: Text('Take Picture'),
                          onPressed: getImageCamera,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Step(
                title: Text("Choose a difficulty"),
                subtitle: Text("How hard is it to make your recipe?"),
                content: DropdownButton(
                  items: [
                    DropdownMenuItem(
                      child: Text("Beginner"),
                      value: "Beginner",
                    ),
                    DropdownMenuItem(
                      child: Text("Intermediate"),
                      value: "Intermediate",
                    ),
                    DropdownMenuItem(
                      child: Text("Advanced"),
                      value: "Advanced",
                    ),
                    DropdownMenuItem(
                      child: Text("Expert"),
                      value: "Expert",
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      difficulty = value;
                    });
                  },
                  value: difficulty,
                ),
              ),
              Step(
                  title: Text("How much time does it take?"),
                  content: DurationPicker(
                    onChange: (value) {
                      setState(() {
                        duration = value;
                        //print(duration);
                      });
                    },
                    snapToMins: 5,
                  )),
              Step(
                title: Text("List the ingredients"),
                subtitle: Text(
                  "Seperate Ingredients with a (+).\nAppend the amount with a comma (,).",
                  overflow: TextOverflow.fade,
                ),
                content: TextField(
                  maxLines: null,
                  decoration:
                      InputDecoration(hintText: "e.g. Peas,500g+Honey Combs,3"),
                  onChanged: (value) {
                    ingredientsInput = value;
                  },
                ),
              ),
              Step(
                title: Text("What tools do you need?"),
                subtitle: Text(
                  "Seperate each with a plus (+)",
                  overflow: TextOverflow.fade,
                ),
                content: TextField(
                  maxLines: null,
                  decoration:
                      InputDecoration(hintText: "e.g. Blender+Cutting Plate"),
                  onChanged: (value) {
                    toolsInput = value;
                  },
                ),
              ),
              Step(
                title: Text("How do you make it?"),
                subtitle: Text(
                  "Seperate each with a plus (+)",
                  overflow: TextOverflow.fade,
                ),
                content: TextField(
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText:
                          "e.g. Mix flour with baking soda.+Bake for 30 min."),
                  onChanged: (value) {
                    stepsInput = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
