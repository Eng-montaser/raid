import 'package:flutter/cupertino.dart';
import 'package:raid/style/FCITextStyles.dart';

class SuppliersData {
  int id;

  String name;
  String company_name;
  String email;
  String phone_number;
  String image;
  String address;
  String city;
  String is_active;

  SuppliersData(
      {this.id,
      this.is_active,
      this.city,
      this.name,
      this.company_name,
      this.email,
      this.phone_number,
      this.image,
      this.address});

  SuppliersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    is_active = json['is_active'];
    image = json['image'];
    company_name = json['company_name'];
    email = json['email'];
    phone_number = json['phone_number'];
    address = json['address'];
    city = json['city'];
  }
}

class WarehousesData {
  String name;
  int wId;
  WarehousesData({this.wId, this.name});
  WarehousesData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    wId = json['id'];
  }
}

void modalBottomSheetMenu({context, vacationName, vacationId, data}) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
            title: Text(
              "اختر المستودع",
              style: FCITextStyle().bold16(),
            ),
            actions: _createListView(context, data, vacationName, vacationId),
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                "الغاء",
                style: FCITextStyle().bold16(),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ));
}

List<CupertinoActionSheetAction> _createListView(
    BuildContext context, List<WarehousesData> data, changeName, changeId) {
  Size size = MediaQuery.of(context).size;
  List<CupertinoActionSheetAction> cupertinoActionSheetAction;
  if (data != null) {
    cupertinoActionSheetAction =
        new List<CupertinoActionSheetAction>(data.length);
    for (int index = 0; index < data.length; index++) {
      cupertinoActionSheetAction[index] = new CupertinoActionSheetAction(
          //leading: new Icon(CupertinoIcons.directions_car),
          child: new Text(
            '${data[index].name}',
            style: FCITextStyle().normal18(),
          ),
          onPressed: () {
            changeName(data[index].name);
            changeId(data[index].wId);
            Navigator.pop(context);
          });
    }
  }
  return cupertinoActionSheetAction;
}

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
  Warehouse(
      {this.id,
      this.phone,
      this.email,
      this.address,
      this.name,
      this.is_active});
  Warehouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    is_active = json['is_active'];
  }
}
