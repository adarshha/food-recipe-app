class RecipeModel {
  String label;
  String imgUrl;
  String calories;
  String url;

  RecipeModel({this.label, this.imgUrl, this.calories, this.url});

  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
        calories: recipe['calories'].toString(),
        imgUrl: recipe['image'],
        label: recipe['label'],
        url: recipe['url']);
  }
}
