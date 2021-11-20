import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/NewModels.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:raid/ui/Salesperson/sales_person.dart';

class SupPreviewPage extends StatefulWidget {
  final List<CartItem> cart;
  final double shipping;
  final double discount;
  final SuppliersData customerData;
  final double total;
  final int warId;
  const SupPreviewPage(
      {Key key,
      this.cart,
      this.shipping,
      this.discount,
      this.customerData,
      this.total,
      this.warId})
      : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SupPreviewPage> {
  // data
  List<String> saleStatus = ['مستلم', 'جزئى', 'معلق', 'تم الطلب'];
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
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    height: ScreenUtil().setHeight(35),
                    width: ScreenUtil().setWidth(100),
                    child: Center(
                      child: Text(' اسـم المورد:  ',
                          style: FCITextStyle().normal18()),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: ScreenUtil().setHeight(35),
                    padding: EdgeInsets.symmetric(),
                    decoration: BoxDecoration(border: Border.all(width: 1)),
                    child: Center(
                      child: Text('${widget?.customerData?.name ?? ''}',
                          style: FCITextStyle().normal18()),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              rowDataHeader(),
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
                      Text('${widget?.customerData?.address ?? ''}',
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
                              'supplier_id': '${widget?.customerData?.id}',
                              'warehouse_id': '${widget.warId}',
                              'qty': json.encode(qty),
                              'product_code': "$pcode",
                              'product_id': json.encode(pid),
                              'purchase_unit': json.encode(saleunit),
                              'net_unit_cost': json.encode(netunitprice),
                              'discount': json.encode(discount),
                              'tax_rate': json.encode(taxrate),
                              'tax': json.encode(tax),
                              'subtotal': json.encode(subtotal),
                              'total_discount': '$totaldiscount',
                              'total_tax': '$totaltax',
                              "total_qty": '$totalqty',
                              'total_cost': '$totalprice',
                              'item': '${widget.cart.length}',
                              'order_tax': '$ordertax',
                              'grand_total': '${widget.total}',
                              'order_tax_rate': '0',
                              'order_discount': '0',
                              'shipping_cost': '${widget.shipping}',
                              'status': '${saleIndex + 1}',
                              'payment_status': '$paymentIndex',
                              'paid_by_id': '${widget?.customerData?.id}',
                              'paid_amount': '$paidamount',
                              "recieved": json.encode(qty),
                              //"batch_no": jsonEncode([]),
                              // "expired_date": jsonEncode([]),
                              'note': ''
                            };
                            // print('data is $data');
                            await Provider.of<PostProvider>(context,
                                    listen: false)
                                .addPurchase(data)
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
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(1)),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .5,
            height: ScreenUtil().setHeight(35),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            decoration: BoxDecoration(border: Border.all(width: 1)),
            child: FittedBox(
              child: Text(
                '${cart.product.name}',
                maxLines: 2,
                softWrap: true,
                style: FCITextStyle().bold16().copyWith(height: 1.4),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(35),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1),
            ),
            child: Center(
              child: Text('${cart.qty.toInt()}',
                  style: FCITextStyle().bold16().copyWith(height: 1.4)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            //margin: EdgeInsets.all(7),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(35),

            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1),
            ),
            child: Center(
              child: Text('${cart.product.price.toStringAsFixed(2)}',
                  style: FCITextStyle().bold16().copyWith(height: 1.4)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(35),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(width: 1),
            ),
            child: Center(
              child: Text('${total.toStringAsFixed(2)}',
                  style: FCITextStyle().bold16().copyWith(height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowDataHeader() {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .5,
          height: ScreenUtil().setHeight(35),
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          child: FittedBox(
            child: Text(
              'الصنـف',
              maxLines: 2,
              softWrap: true,
              style: FCITextStyle().bold16().copyWith(height: 1.4),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          width: ScreenUtil().setWidth(60),
          height: ScreenUtil().setHeight(35),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1),
          ),
          child: Center(
            child: Text('الكميـة',
                style: FCITextStyle().bold16().copyWith(height: 1.4)),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          //margin: EdgeInsets.all(7),
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setHeight(35),

          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1),
          ),
          child: Center(
            child: Text('السعـر',
                style: FCITextStyle().bold16().copyWith(height: 1.4)),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
          width: ScreenUtil().setWidth(80),
          height: ScreenUtil().setHeight(35),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(width: 1),
          ),
          child: Center(
            child: Text('الاجمــالى',
                style: FCITextStyle().bold16().copyWith(height: 1.4)),
          ),
        ),
      ],
    );
  }
}
