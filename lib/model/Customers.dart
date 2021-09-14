import 'package:easy_localization/easy_localization.dart';
import 'package:raid/provider/settings.dart';

class CustomersProfileData {
  int id;
  String name;
  String image;
  CustomersProfileData({this.id,this.image,this.name});
  CustomersProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
//class CustomersData {
//  int id;
//  String name;
//  String company_name;
//  String address;
//  String city;
//  String phoneNumber;
//  CustomersData({this.id,this.phoneNumber,this.name,this.address,this.city,this.company_name});
//  CustomersData.fromJson(Map<String, dynamic> json) {
//    id = json['id'];
//    name = json['name'];
//    company_name = json['company_name'];
//    address = json['address'];
//    city = json['city'];
//    phoneNumber = json['phone_number'];
//  }
//}
class CustomersData {
  int id;
  int customer_group_id;
  int user_id;
  String name;
  String company_name;
  String email;
  String phone;
  String address;

  CustomersData(
      {this.id,
        this.customer_group_id,
        this.user_id,
        this.name,
        this.company_name,
        this.email,
        this.phone,
        this.address});

  CustomersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    customer_group_id = json['customer_group_id'];
    user_id = json['user_id'];
    company_name = json['company_name'];
    email = json['email'];
    phone = json['phone_number'];
    address = json['address'];
  }
}
class CustomersReportData {
  String customer_id;
  String start_date;
  String end_date;
  List<CustomersReportSalesData>sales = [];
  List<CustomersReportPaymentsData>payments = [];
  List<CustomersReportQuotationsData>quotations = [];
  List<CustomersReportReturnsData>returns = [];
  double totalPriceSales=0.0;
  double totalDiscountSales=0.0;
  double totalTaxSales=0.0;
  double totalPriceQuotations=0.0;
  double totalDiscountQuotations=0.0;
  double totalTaxQuotations=0.0;
  double totalPriceReturns=0.0;
  double totalDiscountReturns=0.0;
  double totalTaxReturns=0.0;
  CustomersReportData(
      {this.customer_id, this.start_date, this.end_date, this.sales,this.payments,this.quotations});

  CustomersReportData.fromJson(Map<String, dynamic> json) {
    customer_id = json['customer_id'];
    start_date = json['start_date'];
    end_date = json['end_date'];
    ///Sales-------------------
    json['sales']
        .forEach((sale) {
      sales.add(CustomersReportSalesData.fromJson(sale));
      totalPriceSales+=sale['total_price'];
      totalDiscountSales+=sale['total_discount'];
      totalTaxSales +=sale['total_tax'];
    });
    ///-----------------------
    ///Payments-------------------
    json['payments']
        .forEach((payment) {
      payments.add(CustomersReportPaymentsData.fromJson(payment));
    });
    ///-----------------------
    ///quotations-------------------
    json['quotations']
        .forEach((quotation) {
      quotations.add(CustomersReportQuotationsData.fromJson(quotation));
      totalPriceQuotations+=quotation['total_price'];
      totalDiscountQuotations+=quotation['total_discount'];
      totalTaxQuotations +=quotation['total_tax'];
    });
    ///-----------------------
    ///return-------------------
    json['returns']
        .forEach((returnsdata) {
      returns.add(CustomersReportReturnsData.fromJson(returnsdata));
      totalPriceReturns+=returnsdata['total_price'];
      totalDiscountReturns+=returnsdata['total_discount'];
      totalTaxReturns +=returnsdata['total_tax'];
    });
    ///-----------------------
  }
}

class CustomersReportSalesData{
//  Product (Qty)
//  Due
  int id;
  String date;
  String reference_no;
  String warehouse;
  int total_qty;
  int grand_total;
  int paid_amount;
  int price;
  int status;
  int discount;
  double tax;
  CustomersReportSalesData({this.id,this.price,this.paid_amount,this.status,this.reference_no,
  this.date,this.grand_total,this.discount,this.total_qty,this.tax,this.warehouse});
  CustomersReportSalesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['created_at'];//DateFormat('dd/MM/yyyy').format(DateTime.parse(json['created_at'])).toString();
    reference_no = json['reference_no'];
    warehouse = json['warehouse']['name'];
    total_qty = json['total_qty'];
    grand_total = json['grand_total'];
    paid_amount = json['paid_amount'];
    price = json['total_price'];
    status = json['sale_status'];
    discount = json['total_discount'];
    tax = double.parse(json['total_tax'].toString());
  }
}
class CustomersReportPaymentsData{
  int id;
  String date;
  String paying_method;
  String payment_reference;
  int amount;
  String sale_reference;
  CustomersReportPaymentsData({this.id,this.paying_method,this.date,this.amount,this.payment_reference,this.sale_reference});
  CustomersReportPaymentsData.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    id = json['id'];
    date = json['created_at'];
    paying_method = json['paying_method'];
    amount = json['amount'];
    sale_reference = json['sale_reference'];
    payment_reference = json['payment_reference'];

  }
}
class CustomersReportQuotationsData{
  int id;
  String date;
  String reference_no;
  int price;
  int discount;
  int quotation_status;
  CustomersReportQuotationsData({this.id,this.quotation_status});
  CustomersReportQuotationsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['created_at'];
    reference_no = json['reference_no'];
    quotation_status = json['quotation_status'];
    price = json['total_price'];
    discount = json['total_discount'];
  }
}
class CustomersReportReturnsData{
  int id;
  String date;
  String reference_no;
  String biller;
  int total_price;
  CustomersReportReturnsData({this.id,this.reference_no});
  CustomersReportReturnsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['created_at'];
    reference_no = json['reference_no'];
    biller = json['biller']['name'];
    total_price = json['total_price'];
  }
}