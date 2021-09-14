class BrandData {
  String title;
  String image;
  BrandData({this.title, this.image});
  BrandData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
  }
}
