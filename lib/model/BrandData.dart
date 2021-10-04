class BrandData {
  int id;
  String title;
  String image;
  BrandData({this.title, this.image, this.id});
  BrandData.fromJson(Map<String, dynamic> json) {
    id = int.parse('${json['id']}');
    title = json['title'];
    image = json['image'];
  }
}
