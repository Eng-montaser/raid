import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/Customers.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:whatsapp_share/whatsapp_share.dart';

import 'sales_person.dart';

class PreviewPage extends StatefulWidget {
  final List<CartItem> cart;
  final double shipping;
  final double discount;
  final CustomersData customerData;
  final double total;
  final int wareHouse;
  const PreviewPage(
      {Key key,
      this.cart,
      this.shipping,
      this.discount,
      this.customerData,
      this.total,
      this.wareHouse})
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
  TextEditingController paymentCOntroller = TextEditingController(text: '');
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

    /* final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));*/
  }

  Future<bool> isInstalled() async {
    final val = await WhatsappShare.isInstalled(package: Package.whatsapp);
    return val;
  }

  /*Future<void> share() async {
    bool isinstalled = await isInstalled();
    if (isinstalled)
      await WhatsappShare.share(
        text: 'Whatsapp share text',
        linkUrl: 'https://flutter.dev/',
        phone: '+201102490707',
      );
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> shareFile(File file) async {
    // FlutterOpenWhatsapp.sendSingleMessage("+201113985706", file.path);
    await WhatsappShare.shareFile(
      text: 'فاتورة شراء',
      phone: '911234567890',
      filePath: [file.path],
    );
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
          child: SingleChildScrollView(
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
                        child: Text(' الاســـم:  ',
                            style: FCITextStyle().normal18()),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .5,
                      height: ScreenUtil().setHeight(35),
                      padding: EdgeInsets.symmetric(),
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Center(
                        child: Text('${widget.customerData.name}',
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
                                        if (index == 3) {
                                          paymentCOntroller.text =
                                              '${widget.total}';
                                        } else
                                          paymentCOntroller.text = '';
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
                if (paymentIndex == 2 || paymentIndex == 3)
                  Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(50),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(7)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Center(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: FCITextStyle().normal16(),
                        controller: paymentCOntroller,
                        enabled: paymentIndex == 2,
                        onChanged: (val) {
                          setState(() {
                            paidamount = double.parse(val);
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "المبلغ المدفوع",
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
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
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              setState(() {
                                isLoading = true;
                              });
                              var data = {
                                'customer_id': '${widget.customerData.id}',
                                'qty': json.encode(qty),
                                'warehouse_id': '${widget.wareHouse}',
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
                                'paid_amount': '${paymentCOntroller.text}',
                                'payment_note': '',
                                'sale_note': '',
                                'staff_note': ''
                              };
                              if (paymentIndex == 2 || paymentIndex == 3) {
                                if (paymentCOntroller.text.isNotEmpty)
                                  await Provider.of<PostProvider>(context,
                                          listen: false)
                                      .addsale(data)
                                      .then((value) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (value != null) {
                                      AwesomeDialog(
                                          context: context,
                                          animType: AnimType.LEFTSLIDE,
                                          headerAnimationLoop: false,
                                          dialogType: DialogType.SUCCES,
                                          dismissOnBackKeyPress: false,
                                          dismissOnTouchOutside: false,
                                          title: 'اصدار فاتورة',
                                          desc: 'تم الاصدار بنجاح',
                                          btnOkText: "مشاركة",
                                          btnOkIcon: FontAwesomeIcons.whatsapp,
                                          btnOkColor: Colors.lightGreen,
                                          btnOkOnPress: () {
                                            billPrint(value['invoice']['id']);
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPerson()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          btnCancelText: 'إنهاء',
                                          btnCancelColor: Colors.redAccent,
                                          btnCancelOnPress: () {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SalesPerson()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          },
                                          onDissmissCallback: (type) {})
                                        ..show();
                                    } else
                                      showMessage(context, 'اصدار فاتورة',
                                          "فشل فى تسجيل الفاتورة", false);
                                  });
                                else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showMessage(context, 'اصدار فاتورة',
                                      "ادخل المبلغ المدفوع", false);
                                }
                              } else
                                await Provider.of<PostProvider>(context,
                                        listen: false)
                                    .addsale(data)
                                    .then((value) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (value != null) {
                                    AwesomeDialog(
                                        context: context,
                                        animType: AnimType.LEFTSLIDE,
                                        headerAnimationLoop: false,
                                        dialogType: DialogType.SUCCES,
                                        dismissOnBackKeyPress: false,
                                        dismissOnTouchOutside: false,
                                        title: 'اصدار فاتورة',
                                        desc: 'تم الاصدار بنجاح',
                                        btnOkText: "مشاركة",
                                        btnOkIcon: FontAwesomeIcons.whatsapp,
                                        btnOkColor: Colors.lightGreen,
                                        btnOkOnPress: () {
                                          billPrint(value['invoice']['id']);
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              SalesPerson()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        btnCancelText: 'إنهاء',
                                        btnCancelColor: Colors.redAccent,
                                        btnCancelOnPress: () {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              SalesPerson()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        onDissmissCallback: (type) {})
                                      ..show();
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
                                style:
                                    FCITextStyle(color: Colors.white).bold18(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  billPrint(num) async {
    var data = await rootBundle.load("assets/fonts/open-sans.ttf");
    final ttf = pw.Font.ttf(data);
    final pdf = pw.Document();
    final img = pw.MemoryImage(
      (await rootBundle.load(kLogoBlack)).buffer.asUint8List(),
    );
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        build: (pw.Context context) {
          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          final String formatted = formatter.format(now);
          return pw.Center(
            child: pw.Column(children: [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Container(
                            width: ScreenUtil().setWidth(120),
                            padding: pw.EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(5)),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(' التاريخ:  ',
                                    style: pw.TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        font: ttf,
                                        fontWeight: pw.FontWeight.bold),
                                    textDirection: pw.TextDirection.rtl),
                                pw.SizedBox(
                                  height: ScreenUtil().setHeight(5),
                                ),
                                pw.Text('${formatted}',
                                    style: pw.TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      font: ttf,
                                    ),
                                    textDirection: pw.TextDirection.rtl),
                              ],
                            ))),
                    pw.Image(img,
                        height: ScreenUtil().setHeight(150),
                        width: ScreenUtil().setWidth(150),
                        fit: pw.BoxFit.fill),
                    pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Container(
                            width: ScreenUtil().setWidth(150),
                            padding: pw.EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(5)),
                            decoration: pw.BoxDecoration(
                                border: pw.Border.all(width: 1)),
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text(' رقم الفاتورة:  ',
                                    style: pw.TextStyle(
                                        fontSize: ScreenUtil().setSp(18),
                                        font: ttf,
                                        fontWeight: pw.FontWeight.bold),
                                    textDirection: pw.TextDirection.rtl),
                                pw.SizedBox(
                                  height: ScreenUtil().setHeight(5),
                                ),
                                pw.Text('${num}',
                                    style: pw.TextStyle(
                                      fontSize: ScreenUtil().setSp(18),
                                      font: ttf,
                                    ),
                                    textDirection: pw.TextDirection.rtl),
                              ],
                            ))),
                  ]),
              pw.SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(35),
                        padding: pw.EdgeInsets.symmetric(),
                        decoration:
                            pw.BoxDecoration(border: pw.Border.all(width: 1)),
                        child: pw.Center(
                          child: pw.Text('${widget.customerData.name}',
                              style: pw.TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                font: ttf,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ),
                      pw.Container(
                        decoration:
                            pw.BoxDecoration(border: pw.Border.all(width: 1)),
                        height: ScreenUtil().setHeight(35),
                        width: ScreenUtil().setWidth(100),
                        child: pw.Center(
                          child: pw.Text(' الاســـم:  ',
                              style: pw.TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                font: ttf,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ),
                    ],
                  )),
              pw.SizedBox(
                height: ScreenUtil().setHeight(15),
              ),
              rowDataPWHeader(ttf),
              pw.ListView.builder(
                itemBuilder: (context, index) =>
                    rowDataPW(widget.cart[index], ttf),
                //shrinkWrap: true,
                itemCount: widget.cart.length,
              ),
              pw.SizedBox(
                height: ScreenUtil().setHeight(20),
              ),
              totalsPW(ttf),
              pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: ScreenUtil().setWidth(200),
                        height: ScreenUtil().setHeight(35),
                        padding: pw.EdgeInsets.symmetric(),
                        decoration:
                            pw.BoxDecoration(border: pw.Border.all(width: 1)),
                        child: pw.Center(
                          child: pw.Text('${paymentCOntroller.text}',
                              style: pw.TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                font: ttf,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ),
                      pw.Container(
                        decoration:
                            pw.BoxDecoration(border: pw.Border.all(width: 1)),
                        height: ScreenUtil().setHeight(35),
                        width: ScreenUtil().setWidth(100),
                        child: pw.Center(
                          child: pw.Text(' المدفوع:  ',
                              style: pw.TextStyle(
                                fontSize: ScreenUtil().setSp(18),
                                font: ttf,
                              ),
                              textDirection: pw.TextDirection.rtl),
                        ),
                      ),
                    ],
                  )),
            ]),
          ); // Center
        }));
    final output = await getExternalStorageDirectory();
    final file = File("${output.absolute.path}/bill.pdf");
    // final file = File("bill.pdf");
    await file.writeAsBytes(await pdf.save());
    shareFile(file);
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
        btnOkText: "حسنا",
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

  pw.Widget totalsPW(pw.Font ttf) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
          border: pw.Border.all(width: .3),
          //  boxShadow: [BoxShadow()],
          borderRadius: pw.BorderRadius.circular(10)),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${widget.shipping ?? ''}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16),
                    font: ttf,
                    height: 1.4),
              ),
              pw.Text('مصاريف الشحن',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: ScreenUtil().setSp(16),
                      font: ttf,
                      height: 1.4),
                  textDirection: pw.TextDirection.rtl),
            ],
          ),
          //    const SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${widget.discount ?? ''}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16),
                    font: ttf,
                    height: 1.4),
              ),
              pw.Text('التخفيض',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: ScreenUtil().setSp(16),
                      font: ttf,
                      height: 1.4),
                  textDirection: pw.TextDirection.rtl),
            ],
          ),
          // const SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${widget.total ?? ''} جنيه',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16),
                    font: ttf,
                    height: 1.4),
              ),
              pw.Text('الإجمالى:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: ScreenUtil().setSp(16),
                      font: ttf,
                      height: 1.4),
                  textDirection: pw.TextDirection.rtl),
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

  pw.Widget rowDataPW(CartItem cart, pw.Font ttf) {
    double total = cart.qty * cart.product.price;
    return pw.Container(
      margin: pw.EdgeInsets.only(top: ScreenUtil().setHeight(1)),
      child: pw.Row(
        children: [
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(35),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                '${total.toStringAsFixed(2)}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                    fontSize: ScreenUtil().setSp(16),
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            //margin: EdgeInsets.all(7),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(35),

            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                '${cart.product.price.toStringAsFixed(2)}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16),
                    font: ttf,
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(35),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                '${cart.qty.toInt()}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                    fontSize: ScreenUtil().setSp(16),
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            width: MediaQuery.of(context).size.width * .7,
            height: ScreenUtil().setHeight(35),
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
            child: pw.FittedBox(
              child: pw.Text('${cart.product.name}',
                  maxLines: 2,
                  softWrap: true,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: ScreenUtil().setSp(16),
                      font: ttf,
                      height: 1.4),
                  textDirection: pw.TextDirection.rtl),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget rowDataPWHeader(pw.Font ttf) {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: ScreenUtil().setHeight(1)),
      child: pw.Row(
        children: [
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(100),
            height: ScreenUtil().setHeight(35),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                'الاجمــالى',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                    fontSize: ScreenUtil().setSp(16),
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            //margin: EdgeInsets.all(7),
            width: ScreenUtil().setWidth(80),
            height: ScreenUtil().setHeight(35),

            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                'السعـر',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: ScreenUtil().setSp(16),
                    font: ttf,
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            width: ScreenUtil().setWidth(60),
            height: ScreenUtil().setHeight(35),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.rectangle,
              border: pw.Border.all(width: 1),
            ),
            child: pw.Center(
              child: pw.Text(
                'الكميـة',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                    fontSize: ScreenUtil().setSp(16),
                    height: 1.4),
              ),
            ),
          ),
          pw.Container(
            width: MediaQuery.of(context).size.width * .7,
            height: ScreenUtil().setHeight(35),
            padding:
                pw.EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(5)),
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
            child: pw.FittedBox(
              child: pw.Text('الصنـف',
                  maxLines: 2,
                  softWrap: true,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: ScreenUtil().setSp(16),
                      font: ttf,
                      height: 1.4),
                  textDirection: pw.TextDirection.rtl),
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
