import 'package:flutter/material.dart';
import 'package:foodapp/model/model.dart';
import 'package:foodapp/screens/recipe_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  String query;
  SearchScreen(this.query);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = new TextEditingController();
  List<RecipeModel> recipeList = <RecipeModel>[];
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
    getRecipe(widget.query);
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
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return SearchScreen(searchController.text);
                              }));
                            }
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
                  margin: EdgeInsets.fromLTRB(5, 0, 5, 20),
                  // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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
                                  margin: EdgeInsets.all(20),
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
