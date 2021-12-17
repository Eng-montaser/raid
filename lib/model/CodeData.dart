class CodeData {
  String title;
  String image;
  List<String> description;
  CodeData({this.title, this.image, this.description});
  CodeData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    image = json['image'];
    //  description = json['description'];
    description = [];
    json['code'].forEach((productReport) {
      description.add(productReport);
    });
  }
}

class Company {
  int id;
  String name;
  String image;

  Company({this.name, this.image, this.id});
  Company.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    id = int.parse("${json['id']}");
    //  description = json['description'];
  }
}

class CodeCat {
  int id;
  String name;
  CodeCat({this.id, this.name});
  CodeCat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = int.parse("${json['id']}");
  }
}

class CodeName {
  int id;
  String title;
  String description;
  CodeName({this.id, this.title});
  CodeName.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    id = int.parse("${json['id']}");
  }
}
