class ConciliationData {
  String name;
  int id;
  String image;
  List<Integrations> integrations;
  ConciliationData({this.id, this.integrations, this.name, this.image});
  ConciliationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    integrations = new List<Integrations>();
    json['integrations'].forEach((v) {
      integrations.add(new Integrations.fromJson(v));
    });
  }
}

class Integrations {
  String name;
  int id;
  String tags;
  Integrations({this.id, this.tags, this.name});
  Integrations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tags = json['tags'];
  }
}
