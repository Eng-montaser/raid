class ExpenseCategory {
  int id;
  String name;
  String code;
  String is_active;
  ExpenseCategory({this.id, this.code, this.name, this.is_active});
  ExpenseCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    is_active = json['is_active'];
  }
}

class Account {
  int id;
  String name;
  String account_no;
  String is_active;
  String is_default;
  String note;
  double initial_balance;
  double total_balance;

  Account(
      {this.id,
      this.name,
      this.account_no,
      this.is_active,
      this.is_default,
      this.note,
      this.initial_balance,
      this.total_balance});

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    is_default = json['is_default'];
    is_active = json['is_active'];
    note = json['note'];
    account_no = json['account_no'];
    initial_balance = json['initial_balance'] != null
        ? double.parse('${json['initial_balance']}')
        : 0.0;
    total_balance = json['total_balance'] != null
        ? double.parse('${json['total_balance']}')
        : 0.0;
  }
}

class CustomerGroup {
  int id;
  String name;
  String percentage;
  String is_active;
  CustomerGroup({this.id, this.percentage, this.name, this.is_active});
  CustomerGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    percentage = json['percentage'];
    is_active = json['is_active'];
  }
}

class Warehouse {
  int id;
  String name;
  String phone;
  String email;
  String address;
  String is_active;
  Warehouse({this.id, this.phone,this.email,this.address, this.name, this.is_active});
  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    is_active = json['is_active'];
  }
}
