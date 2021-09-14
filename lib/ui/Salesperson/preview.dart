import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';

import 'sales_person.dart';

class PreviewPage extends StatefulWidget {
  final List<CartItem> cart;
  final double shipping;
  final double discount;
  final CustomersData customerData;
  final double total;
  const PreviewPage(
      {Key key,
      this.cart,
      this.shipping,
      this.discount,
      this.customerData,
      this.total})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<PreviewPage> {
  // data
  List<String> saleStatus = ['غير مكتمل', 'مكتمل'];
  List<String> paymentStatus = ['معلق', 'مؤجل', 'جزئى', 'مدفوع'];
  int paymentIndex = 0, saleIndex = 0;
  List<double> qty = [];
  List<int> pbatch = [];
  List<String> pcode = [];
  List<int> pid = [];
  List<String> saleunit = [];
  List<double> netunitprice = [];
  List<double> discount = [];
  List<double> taxrate = [];
  List<double> tax = [];
  List<double> subtotal = [];
  double totaldiscount = 0,
      totalqty = 0,
      totaltax = 0,
      totalprice = 0,
      item = 0,
      ordertax = 0,
      grandtotal = 0,
      pos = 0,
      couponactive = 0,
      ordertaxrate = 0,
      orderdiscount = 0,
      shippingm = 0; // initState()
  double payingamount = 0, paidamount = 0, giftcardId = 0, checkno = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    init();
    // _getCurrentUserNameAndUid();
  }

  init() {
    for (var item in widget.cart) {
      qty.add(item.qty);
      pcode.add(item.product.code);
      pid.add(item.product.productId);
      saleunit.add(item.product.unit);
      subtotal.add(item.product.price * item.qty);
    }
    for (var st in subtotal) {
      totalprice = totalprice + st;
    }
    for (var st in qty) {
      totalqty = totalqty + st;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // building the search page widget
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          elevation: 0.0,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('فاتورة بإســم:  ',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: GoogleFonts.cairo().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('${widget.customerData.name}',
                      style: TextStyle(
                          fontSize: 22.0,
                          fontFamily: GoogleFonts.cairo().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              ListView.builder(
                itemBuilder: (context, index) => rowData(widget.cart[index]),
                shrinkWrap: true,
                itemCount: widget.cart.length,
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              totals(),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('العنوان', style: FCITextStyle().bold16()),
                      Text('${widget.customerData.address}',
                          style:
                              FCITextStyle(color: Colors.black54).normal14()),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حالة البيع', style: FCITextStyle().bold16()),
                      Text('${saleStatus[saleIndex]}',
                          style:
                              FCITextStyle(color: Colors.black54).normal14()),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
//                              title: Text(
//                                "Select.Integration".tr(),
//                                style: FCITextStyle(color: accentColor).normal18(),
//                              ),
                                  actions: List.generate(
                                2,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${saleStatus[index]}",
                                      style: FCITextStyle(color: Colors.blue)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        saleIndex = index;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Text('تعديل',
                        style: FCITextStyle(color: Colors.orange).bold16()),
                  ),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('حالة الدفع', style: FCITextStyle().bold16()),
                      Text('${paymentStatus[paymentIndex]}',
                          style:
                              FCITextStyle(color: Colors.black54).normal14()),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
//                              title: Text(
//                                "Select.Integration".tr(),
//                                style: FCITextStyle(color: accentColor).normal18(),
//                              ),
                                  actions: List.generate(
                                4,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${paymentStatus[index]}",
                                      style: FCITextStyle(color: Colors.blue)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        paymentIndex = index;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Text('تعديل',
                        style: FCITextStyle(color: Colors.orange).bold16()),
                  ),
                ],
              ),
              isLoading
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(10)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10),
                          vertical: ScreenUtil().setHeight(5)),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: primaryColor),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            var data = {
                              'customer_id': '${widget.customerData.id}',
                              'qty': json.encode(qty),
                              'product_code': json.encode(pcode),
                              'product_id': json.encode(pid),
                              'sale_unit': json.encode(saleunit),
                              'net_unit_price': json.encode(netunitprice),
                              'discount': json.encode(discount),
                              'tax_rate': json.encode(taxrate),
                              'tax': json.encode(tax),
                              'subtotal': json.encode(subtotal),
                              'total_discount': '$totaldiscount',
                              'total_tax': '$totaltax',
                              "total_qty": '$totalqty',
                              'total_price': '$totalprice',
                              'item': '${widget.cart.length}',
                              'order_tax': '$ordertax',
                              'grand_total': '${widget.total}',
                              'pos': '0',
                              'coupon_active': '0',
                              'order_tax_rate': '0',
                              'order_discount': '0',
                              'shipping_cost': '${widget.shipping}',
                              'sale_status': '$saleIndex',
                              'payment_status': '$paymentIndex',
                              'paid_by_id': '${widget.customerData.id}',
                              'paying_amount': '${payingamount}',
                              'paid_amount': '$paidamount',
                              'payment_note': '',
                              'sale_note': '',
                              'staff_note': ''
                            };
                            print('data is $data');
                            await Provider.of<PostProvider>(context,
                                    listen: false)
                                .addsale(data)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              if (value != null) {
                                if (value)
                                  showMessage(context, 'اصدار فاتورة',
                                      "تم تسجيل الفاتورة بنجاح", true);
                                else
                                  showMessage(context, 'اصدار فاتورة',
                                      "فشل فى تسجيل الفاتورة", false);
                              } else
                                showMessage(context, 'اصدار فاتورة',
                                    "فشل فى تسجيل الفاتورة", false);
                            });
                            //else
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(15)),
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(20),
                                vertical: ScreenUtil().setHeight(5)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: primaryColor),
                            child: Text(
                              'إرسال الطلب',
                              style: FCITextStyle(color: Colors.white).bold18(),
                            ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  showMessage(context, String title, String desc, bool success) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: success ? DialogType.SUCCES : DialogType.ERROR,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        title: title,
        desc: desc,
        btnOkText: "ok".tr(),
        btnOkColor: success ? Colors.lightGreen : Colors.red,
        btnOkOnPress: () {
          if (success)
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SalesPerson()),
                (Route<dynamic> route) => false);
        },
        onDissmissCallback: (type) {})
      ..show();
  }

  Widget totals() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: .3),
          //  boxShadow: [BoxShadow()],
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('مصاريف الشحن',
                  style: FCITextStyle(color: Colors.grey.shade700).normal14()),
              Text(
                '${widget.shipping ?? ''}',
                style: FCITextStyle(color: Colors.grey.shade700).normal14(),
              ),
            ],
          ),
          //    const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('التخفيض',
                    style:
                        FCITextStyle(color: Colors.grey.shade700).normal14()),
              ),
              Text(
                '${widget.discount ?? ''}',
                style: FCITextStyle(color: Colors.grey.shade700).normal14(),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالى:', style: FCITextStyle().bold16()),
              Text(
                '${widget.total ?? ''} جنيه',
                style: FCITextStyle().bold20(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget rowData(CartItem cart) {
    double total = cart.qty * cart.product.price;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 7),
                  //margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(width: 1, color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text('${cart.qty.toInt()}'),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(12),
                ),
                Icon(
                  Icons.clear,
                  size: 15,
                  color: Colors.black45,
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(12),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Text(
                    '${cart.product.name}',
                    maxLines: 2,
                    softWrap: true,
                    style: FCITextStyle().bold16().copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            Text('${total.toStringAsFixed(2)} جنيه',
                style: FCITextStyle(color: Colors.orange).normal14()),
          ],
        ),
        Divider(
          color: Colors.grey.shade300,
          //  height: 10,
        ),
        SizedBox(
          height: ScreenUtil().setHeight(10),
        ),
      ],
    );
  }
}
