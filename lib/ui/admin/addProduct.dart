import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:raid/constants.dart';
import 'package:raid/model/BrandData.dart';
import 'package:raid/model/ProductData.dart';
import 'package:raid/provider/GetProvider.dart';
import 'package:raid/provider/PostProvider.dart';
import 'package:raid/style/FCITextStyles.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  TextEditingController amountController = TextEditingController(text: '');
  TextEditingController costController = TextEditingController(text: '');
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController codeController = TextEditingController(text: '');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  List<Unit> units = [];
  Unit unit;
  List<BrandData> symbologies = [];
  BrandData sympolgy;
  List<CatProductData> categories = [];
  CatProductData category;
  List<String> types = ['Standard', 'Combo', 'Digital'];
  String type;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      units = await Provider.of<GetProvider>(context, listen: false).getUnits();
      symbologies =
          await Provider.of<GetProvider>(context, listen: false).getBrands();
      categories = await Provider.of<GetProvider>(context, listen: false)
          .getCatProducts();
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    costController.dispose();
    nameController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var getProvider = Provider.of<GetProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white.withOpacity(.9),
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'إضافة صنف',
            style: FCITextStyle(color: Colors.white).bold20(),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios_outlined),
          ),
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setHeight(15),
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              title: Text(
                                "نــوع المنتـــج",
                                style:
                                    FCITextStyle(color: accentColor).normal18(),
                              ),
                              actions: List.generate(
                                types.length,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${types[index]}",
                                      style: FCITextStyle(color: primaryColor)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        type = types[index];
                                      });

                                      //ontap(selected);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      width: size.width,
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: accentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type == null ? "نــوع المنتـــج" : type,
                            style: FCITextStyle(color: accentColor).normal18(),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: accentColor,
                            size: ScreenUtil().setWidth(25),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: accentColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: TextField(
                      //keyboardType: TextInputType.number,
                      controller: nameController,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'اســم الصنـــف',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: accentColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: TextField(
                      // keyboardType: TextInputType.number,
                      controller: codeController,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'كــودالصــــنف',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              title: Text(
                                "إختــر العلامة التجارية",
                                style:
                                    FCITextStyle(color: accentColor).normal18(),
                              ),
                              actions: List.generate(
                                symbologies.length,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${symbologies[index].title}",
                                      style: FCITextStyle(color: primaryColor)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        sympolgy = symbologies[index];
                                      });

                                      //ontap(selected);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      width: size.width,
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: accentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sympolgy == null
                                ? "إختــر العلامة التجارية "
                                : sympolgy.title,
                            style: FCITextStyle(color: accentColor).normal18(),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: accentColor,
                            size: ScreenUtil().setWidth(25),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              title: Text(
                                "إختــــــــر الفئـــــــــــة",
                                style:
                                    FCITextStyle(color: accentColor).normal18(),
                              ),
                              actions: List.generate(
                                categories.length,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${categories[index].name}",
                                      style: FCITextStyle(color: primaryColor)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        category = categories[index];
                                      });

                                      //ontap(selected);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      width: size.width,
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: accentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category == null
                                ? "إختــــــــر الفئـــــــــــة"
                                : category.name,
                            style: FCITextStyle(color: accentColor).normal18(),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: accentColor,
                            size: ScreenUtil().setWidth(25),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  InkWell(
                    onTap: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                              title: Text(
                                "إختــــــر وحدة المنتج",
                                style:
                                    FCITextStyle(color: accentColor).normal18(),
                              ),
                              actions: List.generate(
                                units.length,
                                (int index) {
                                  return CupertinoActionSheetAction(
                                    child: Text(
                                      "${units[index].unit_name}",
                                      style: FCITextStyle(color: primaryColor)
                                          .normal18(),
                                    ),
                                    isDefaultAction: true,
                                    onPressed: () {
                                      setState(() {
                                        unit = units[index];
                                      });

                                      //ontap(selected);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
//
                              )));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(20)),
                      width: size.width,
                      alignment: Alignment.center,
                      height: ScreenUtil().setHeight(50),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.white,
                          border: Border.all(color: accentColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            unit == null
                                ? "إختــــــر وحدة المنتج"
                                : unit.unit_name,
                            style: FCITextStyle(color: accentColor).normal18(),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: accentColor,
                            size: ScreenUtil().setWidth(25),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: accentColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'المبـــلغ',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: accentColor,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: TextField(
                      keyboardType: TextInputType.number,

                      controller: costController,
                      //maxLines: 5,
                      //  focusNode: focusNode,
                      onSubmitted: (value) {},
                      autofocus: false,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        border: InputBorder.none,
                        hintText: 'تكلفة المنتج',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(25),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: RoundedLoadingButton(
                      child: Text('send'.tr(),
                          style: FCITextStyle(color: Colors.white).normal18()),
                      width: ScreenUtil().setWidth(100),
                      color: primaryColor,
                      controller: _btnController,
                      onPressed: () {
                        sendExpense();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    if (type == null) {
      showInSnackBar('إختر نوع الصنف ');
      return false;
    } else if (nameController.text.isEmpty) {
      showInSnackBar('ادخل اسم الصنف');

      return false;
    } else if (codeController.text.isEmpty) {
      showInSnackBar('ادخل كود الصنف');

      return false;
    } else if (sympolgy == null) {
      showInSnackBar('إختر العلامة التجارية');

      return false;
    } else if (category == null) {
      showInSnackBar('إختر الفــــــئة ');

      return false;
    } else if (unit == null) {
      showInSnackBar('إختر وحدة المنتج ');

      return false;
    } else if (amountController.text.isEmpty ||
        amountController.text == '.' ||
        amountController.text == ',') {
      showInSnackBar('ادخل السعر بشكل صحيح');
      return false;
    } else if (costController.text.isEmpty ||
        costController.text == '.' ||
        costController.text == ',') {
      showInSnackBar('ادخل التكلفة بشكل صحيح');
      return false;
    }
    return true;
  }

  clearData() {
    setState(() {
      unit = null;
      category = null;
      sympolgy = null;
      type = null;
      amountController.text = '';
      costController.text = '';
      codeController.text = '';
      nameController.text = '';
      _btnController.reset();
    });
  }

  sendExpense() async {
    if (validate() == true) {
      var data = {
        'brand_id': '${sympolgy.id}',
        'unit_id': '${unit.id}',
        'category_id': '${category.categoryId}',
        'price': '${amountController.text}',
        'cost': '${costController.text}',
        'name': '${nameController.text}',
        'code': '${codeController.text}',
        'type': '${type}',
      };
      print('data is $data');
      await Provider.of<PostProvider>(context, listen: false)
          .addProduct(data)
          .then((response) {
        if (response) {
          // Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.SUCCES,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "اضافة اصناف",
              desc: "تمت الاضافة بنجاح",
              btnOkText: "ok".tr(),
              btnOkColor: Colors.green,
              btnOkOnPress: () {},
              onDissmissCallback: (type) {})
            ..show();
          clearData();
        } else {
          AwesomeDialog(
              context: context,
              animType: AnimType.LEFTSLIDE,
              headerAnimationLoop: false,
              dialogType: DialogType.ERROR,
              dismissOnBackKeyPress: true,
              dismissOnTouchOutside: true,
              title: "اضافة صنف",
              desc: "فشل عملية اضافة الاصناف",
              btnOkText: "ok".tr(),
              btnOkColor: Colors.red,
              btnOkOnPress: () {},
              onDissmissCallback: (type) {})
            ..show();
          _btnController.reset();
        }
      });
    } else {
//        showInSnackBar("please fill all required fields");
      _btnController.reset();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        style: FCITextStyle(color: Colors.white).normal18(),
      ),
      duration: new Duration(milliseconds: 1000),
      backgroundColor: primaryColor,
    ));
  }
}
