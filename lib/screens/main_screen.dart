import 'package:flutter/material.dart';
import 'package:foodapp/model/model.dart';
import 'package:foodapp/screens/recipe_detail.dart';
import 'package:foodapp/screens/search_Screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchController = new TextEditingController();

  List<RecipeModel> recipeList = <RecipeModel>[];

  List reciptCatList = [
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1564869733874-7c154d5de210?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1575&q=80s",
      "heading": "Chilli Food"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80",
      "heading": "Breakfast"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1498837167922-ddd27525d352?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80",
      "heading": "Healthy Food"
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1496568554266-bc8a06b4d8b5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80",
      "heading": "Desert "
    },
    {
      "imgUrl":
          "https://images.unsplash.com/photo-1485768071412-bded21c2be08?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80",
      "heading": "Street Food"
    }
  ];

  bool isLoading = true;

  getRecipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=25881f71&app_key=8d270a5b43263d5a916c1ed86fad0717";
    http.Response response = await http.get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    print(data);
    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element['recipe']);
      recipeList.add(recipeModel);
      setState(() {
        isLoading = false;
      });
    });

    recipeList.forEach((element) {
      print(element.label);
    });
  }

  @override
  void initState() {
    getRecipe("burger");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff213A50),
                  Color(0xff071938),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white),
                    // color: Colors.grey,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              // getRecipe(searchController.text);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SearchScreen(searchController.text);
                              }));
                            }

                            getRecipe(searchController.text);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Icon(
                              (Icons.search),
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Food Recipe"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WHAT DO YOU WANT TO COOK TODAY?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Let's Cook Something New!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: reciptCatList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SearchScreen(
                                      reciptCatList[index]["heading"]);
                                }));
                              },
                              child: Card(
                                  margin: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0.0,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          child: Image.network(
                                            reciptCatList[index]["imgUrl"],
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 450,
                                          )),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.black26),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    reciptCatList[index]
                                                        ["heading"],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28),
                                                  ),
                                                ],
                                              ))),
                                    ],
                                  )),
                            ));
                          }),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: recipeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RecipeDetail(recipeList[index].url);
                                  }));
                                },
                                child: Card(
                                  margin: EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          recipeList[index].imgUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 200,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black26),
                                          // margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 15),
                                          child: Text(
                                            recipeList[index].label,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black12),
                                          child: Row(
                                            children: [
                                              Icon(Icons.local_fire_department,
                                                  color: Colors.white),
                                              Text(
                                                recipeList[index]
                                                    .calories
                                                    .substring(0, 6),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
