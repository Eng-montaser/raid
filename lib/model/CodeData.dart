class CodeData {
  String title;
  String image;
  String description;
  CodeData({this.title, this.image, this.description});
  CodeData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }
}
