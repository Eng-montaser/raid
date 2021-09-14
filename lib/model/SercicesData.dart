class ServicesData {
  String title;
  String image;
  String description;
  ServicesData({this.title, this.image, this.description});
  ServicesData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }
}
