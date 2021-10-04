class CatProductData {
  int categoryId;
  String name;
  String image;
  int is_active;
  CatProductData({this.categoryId, this.name, this.image, this.is_active});
  CatProductData.fromJson(Map<String, dynamic> json) {
    categoryId = int.parse('${json['id']}');
    name = json['name'] ?? '';
    image = json['image'];
    is_active = int.parse('${json['is_active']}');
  }
}

class ProductData {
  int productId;
  int key;
  String image;
  String name;
  String code;
  String brand;
  String category;
  double qty;
  String unit;
  double price;
  double cost;
  String stock_worth;
  double offer;
  String description;
  ProductData(
      {this.productId,
      this.key,
      this.name,
      this.code,
      this.brand,
      this.category,
      this.qty,
      this.unit,
      this.price,
      this.cost,
      this.stock_worth,
      this.image,
      this.offer,
      this.description});
  ProductData.fromJson(Map<String, dynamic> json) {
    try {
      productId = int.parse('${json['id']}');
      key = int.parse('${json['key']}');
      name = json['name'];
      image = json['image'];
      code = json['code'];
      brand = json['brand'];
      category = json['category'];
      qty = json['qty'].toString().replaceAll(' ', '') != null
          ? double.parse('${json['qty'].toString().replaceAll(' ', '')}')
          : 1.0;
      unit = json['unit'];
      price = json['price'] != null ? double.parse('${json['price']}') : 1.0;
      cost = double.parse('${json['cost']}');
      stock_worth = json['stock_worth'];
      description = json['description'];
    } catch (e) {
      print('xxx $e');
    }
  }
}

class ProductOffer {
  int productId;
  String image;
  String name;
  double oldPrice;
  double newPrice;
  String description;
  String createdAt;
  ProductOffer(
      {this.productId,
      this.name,
      this.newPrice,
      this.image,
      this.description,
      this.oldPrice,
      this.createdAt});
  ProductOffer.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    name = json['product'];
    image = json['image'];
    createdAt = json['created_at'];
    description = json['description'];
    oldPrice = double.parse('${json['old_price']}');
    newPrice = double.parse('${json['new_price']}');
  }
}

class CartItem {
  double qty;
  final ProductData product;
  setCart(double qt) {
    this.qty = qt;
  }

  CartItem({this.qty, this.product});
}

/*class Brand {
  int id;
  String title;
  String image;
  int is_active;
  Brand({this.id, this.title, this.image, this.is_active});
  Brand.fromJson(Map<String, dynamic> json) {
    id = int.parse('${json['id']}');
    title = json['title'] ?? '';
    image = json['image'];
    is_active = int.parse('${json['is_active']}');
  }
}*/

class Unit {
  int id;
  String unit_code;
  String unit_name;
  int is_active;
  int operation_value;
  Unit(
      {this.id,
      this.unit_code,
      this.unit_name,
      this.is_active,
      this.operation_value});
  Unit.fromJson(Map<String, dynamic> json) {
    id = int.parse('${json['id']}');
    unit_code = json['unit_code'] ?? '';
    unit_name = json['unit_name'] ?? '';
    is_active = int.parse('${json['is_active']}');
    operation_value = int.parse('${json['operation_value']}');
  }
}
