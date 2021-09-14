class ProductReportData {
//  int key;
  String name;
  int purchased_amount;
  int purchased_qty;
  int sold_amount;
  int sold_qty;
  int returned_amount;
  int returned_qty;
  int purchase_returned_amount;
  int purchase_returned_qty;
  String profit;
  int in_stock;

  ProductReportData(
      {
//        this.key,
        this.name,
        this.purchased_amount,
        this.purchased_qty,
        this.sold_amount,
        this.sold_qty,
        this.returned_amount,
        this.returned_qty,
        this.purchase_returned_amount,
        this.purchase_returned_qty,
        this.profit,
        this.in_stock});

  ProductReportData.fromJson(Map<String, dynamic> json) {
//    key = json['id'];
    name = json['name'];
    purchased_amount = json['purchased_amount'];
    purchased_qty = json['purchased_qty'];
    sold_amount = json['sold_amount'];
    sold_qty = json['sold_qty'];
    returned_amount = json['returned_amount'];
    returned_qty = json['returned_qty'];
    purchase_returned_amount = json['purchase_returned_amount'];
    purchase_returned_qty = json['purchase_returned_qty'];
    profit = json['profit'];
    in_stock = json['in_stock'];
  }
}
